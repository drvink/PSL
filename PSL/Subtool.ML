(*  Title:      src/Subtool.ML
    Author:     Yutaka Nagashima, Data61, CSIRO

This file provides utility functions that are useful to generate tactics at run-time.
*)

(*** SUBTOOL: The state monad tactic interface for sub-tools. ***)
signature SUBTOOL =
sig
  val state_stttac  : Proof.state Dynamic_Utils.stttac;
end;

(*** SUBTOOLS: A collection of sub-tools. ***)
signature SUBTOOLS =
sig
  val quickcheck  : Proof.state Dynamic_Utils.stttac;
  val nitpick     : Proof.state Dynamic_Utils.stttac;
  val hammer      : Proof.state Dynamic_Utils.stttac;
  val is_solved   : Proof.state Dynamic_Utils.stttac;
  val defer       : Proof.state Dynamic_Utils.stttac;
  val subgoal     : Proof.state Dynamic_Utils.stttac;
  val smart_induct: Proof.state -> Proof.state Dynamic_Utils.stttac Seq.seq;
  val sh_output_to_sh_stttac: string -> Proof.state Dynamic_Utils.stttac;(*used in United Reasoning*)
end;

(*** SUBTOOLS: A collection of sub-tools. ***)
structure Subtools: SUBTOOLS =
struct

(** Quickcheck_Tactic: Quickcheck as assertion tactic. **)
structure Quickcheck_Tactic : SUBTOOL =
struct

fun nontac (state:Proof.state) =
  let
    (*do_trace and show_trace are provided for the purpose of debugging.*)
    val do_trace        = false;
    fun show_trace text = if do_trace then tracing text else ();
    val quickcheck      = Quickcheck.quickcheck;
    val single          = Seq.single state;
    fun trace_no_cexm _ = show_trace "Quickcheck.quickcheck found no counterexample";
    fun trace_cexm _    = show_trace "Quickcheck.quickcheck found a  counterexample";
    fun trace_scexn _   = show_trace ("Quickcheck.quickcheck found a potentially spurious " ^
                                      "counterexample due to underspecified functions");
    fun get_result _    =  (case quickcheck [] 1 state of
      NONE => (trace_no_cexm (); single)
    | SOME (genuine, _) => if genuine then (trace_cexm (); Seq.empty) else (trace_scexn (); single));
  in
    Utils.try_with single get_result state
  end;

val state_stttac = Dynamic_Utils.log_n_nontac_to_stttac ([], nontac);

end;

(** Nitpick_Tactic: Nitpick as assertion tactic. **)
structure Nitpick_Tactic : SUBTOOL =
struct

fun nontac (state:Proof.state) =
  let
    val single             = Seq.single state;
    val thy:theory         = (Proof.theory_of state);
    val params             = Nitpick_Commands.default_params thy [];
    val nitpick_result     = Nitpick.pick_nits_in_subgoal state params Nitpick.Normal 1 1;
    (*"genuine" means "genuine counter-example".*)
    val nitpick_succeed    = fst nitpick_result = "genuine";
    val nitpick_tac_result = if nitpick_succeed then Seq.empty else single
  in
    nitpick_tac_result : Proof.state Seq.seq
  end;

val state_stttac = Dynamic_Utils.log_n_nontac_to_stttac ([], nontac);

end;

(** sledgehammer/sem_ind output to monadic tactics on proof state **)
fun tool_output_n_timeout_to_logtac (sh_output:string) (to:real) (state:Proof.state) =
  let
    (*syntax sugars*)
    type text_range        = Method.text_range;
    fun is_using sh_output = String.isPrefix "using " sh_output;
    val parse_using        = Parse.and_list1 Parse.thms1 : (Facts.ref * Token.src list) list list Token.parser;
    val parse_method       = Method.parse                 : text_range Token.parser;
    val parse_one          = Scan.one (K true)            : Token.T list -> Token.T * Token.T list;
    type ctxt              = Proof.context;
    type T                 = Token.T;
    type ref               = Facts.ref;
    type srcs              = Token.src list;
    type keywords          = Keyword.keywords;
    val thy                = Proof.theory_of state       : theory;
    val ctxt               = Proof.context_of state      : ctxt;
    val keywords           = Thy_Header.get_keywords thy : keywords;

    (*function body*)
    val op_w_stopper  = sh_output ^ " parserStopsWithMe";
    val tokens        = Token.explode keywords Position.none op_w_stopper
                      |> filter_out (fn token:T => Token.is_kind Token.Space token) : T list;
    val parser        = if   is_using sh_output
                        then (parse_one |-- parse_using) -- (parse_one |-- parse_method)
                        else (parse_one |-- parse_method) >> (fn x => ([], x));
    val p_get_meth    = (parse_one |-- parse_using) -- parse_one
                      : T list -> ((ref * srcs) list list * T) * T list;
    fun get_str tkns  = tkns
                      |> Utils.init (*drops "parserStopsWithMe" slowly.*)
                      |> map Token.unparse |> String.concatWith " " : string;
    val methN:string  = if   is_using sh_output
                        then p_get_meth tokens |> snd |> get_str
                        else parse_one  tokens |> snd |> get_str;
    val result        = parser tokens
                      : ((ref * srcs) list list * text_range) * T list;
    val using_raw     = (#1 o #1) result : (ref * srcs) list list;
    val text_range    = (#2 o #1) result : text_range;
    val check_text    = Method.check_text ctxt;
    val fail_trange   = (Method.Basic (K Method.fail), Position.no_range) : Method.text_range;
    val checked_range = (apfst check_text text_range handle ERROR _ => fail_trange) : text_range;
    val using_strings = using_raw |> List.concat |> map (Facts.string_of_ref o #1) handle Empty =>
                        (if Utils.debug
                         then tracing "using_strings in sh_output_to_sh_logtac failed." else ();
                         ["Failed constructing using_strings."])
                      : string list;
    val node : Dynamic_Utils.node = Dynamic_Utils.Apply {using = using_strings, methN = methN, back = 0};
    (*print messages for debugging.*)
    val _ =
      let
        val app = case node of
          Dynamic_Utils.Apply app_node => app_node
        | _ => error "app in Sledgehammer_Tactic panics.";
        fun tracing1 _ = tracing ("methN in node is " ^ #methN app);
        fun tracing2 _ = tracing "using_strings are ...";
        fun tracing3 _ = map tracing using_strings;
      in
        if Utils.debug then (tracing1 (); tracing2 (); tracing3 (); ()) else ()
      end;
      val _ = Basics.try;
    val state_w_using = Proof.using_cmd using_raw state : Proof.state;
    fun timeout f     = Utils.try_with Seq.empty (Isabelle_Utils.timeout_apply (seconds to) f)
    val tac_results   = timeout (Proof.apply checked_range) state_w_using
                        |> Seq.filter_results
                       (*Why Seq.try Seq.hd? Because we want to evaluate the head of
                         sequence strictly here to catch errors immediately.*)
                        |> Utils.try_with Seq.empty (Seq.try Seq.hd): Proof.state Seq.seq;
    val results_w_log = Seq.map (fn x => ([node], x)) tac_results : (Dynamic_Utils.log * Proof.state) Seq.seq;
  in
    results_w_log : (Dynamic_Utils.log * Proof.state) Seq.seq
  end;

fun sh_output_to_sh_stttac (output:string) = Dynamic_Utils.logtac_to_stttac (tool_output_n_timeout_to_logtac output 10.0 ): Proof.state Dynamic_Utils.stttac;

(** Sledgehammer_Tacctic: Sledgehammer as a state monad based tactic. **)
structure Sledgehammer_Tactic : SUBTOOL =
struct

fun hammer_logtac (pstate:Proof.state) =
  let
    (*syntax sugars*)
    infix <$>
    fun x <$> f            = Option.map f x;
    val valOf              = Option.valOf;
    val omap               = Option.map;
    val thy                = Proof.theory_of pstate : theory;
    val params             = Sledgehammer_Commands.default_params thy
                             [("isar_proofs", "false"),("smt_proofs", "false")]
    val Auto_Try           = Sledgehammer_Prover.Auto_Try;
    val fact_override      = Sledgehammer_Fact.no_fact_override;
    val run_sledgehammer   = Sledgehammer.run_sledgehammer params Auto_Try NONE 1 fact_override
                           : Proof.state -> bool * (string * string list);
    (*function body*)
    val result             = SOME (run_sledgehammer pstate)
                             handle ERROR _ =>
                             (if Utils.debug then tracing "ERROR in result/hammer_logtac" else ();
                              NONE)
                           : (bool * (string * string list)) option;
    val orig_string        = result <$> snd <$> snd <$> hd handle Empty =>
                             (if Utils.debug then tracing "Empty in orig_string/hammer_logtac" else (); 
                              NONE) : string option;
    fun did_smt_timeout (out::timed::_) = (Utils.are_same ("out)", out)) andalso
                                          (Utils.are_same ("timed", timed))
     |  did_smt_timeout _  = error "Something went wrong in Subtool.ML";
    val one_line_apply     = orig_string <$> space_explode " "
                            <$> drop 2                           (* drop "Try this:"*)
                            <$> rev <$> (fn tokens =>
                                if did_smt_timeout tokens then drop 5 tokens else drop 2 tokens)
                            <$> rev           (* drop "(0.1 ms)." and such.*)
                            <$> String.concatWith " "            : string option;
    val apply_script_cntnt = omap YXML.content_of one_line_apply : string option;
    val sh_returned        = if is_some apply_script_cntnt
                             then valOf result |> fst else false : bool;
  in
    if   sh_returned
    then
      tool_output_n_timeout_to_logtac (valOf apply_script_cntnt) 10.0 pstate
    else Seq.empty : (Dynamic_Utils.log * Proof.state) Seq.seq
  end;

val state_stttac = Dynamic_Utils.logtac_to_stttac hammer_logtac : Proof.state Dynamic_Utils.stttac;

end;

(** Smart_Induct: Smart_Induct as a state monad based tactic. **)
structure Smart_Induct_Tactic =
struct

fun pst_to_smart_induct_output_strs (pst:Proof.state) =
let
    val thm                       = Isabelle_Utils.proof_state_to_thm pst                            : thm;
    val thm_term                  = Thm.prop_of thm                                                  : term;
    val outer_path_to_unode_table = Outer_Path_To_Unode.pst_n_trm_to_path_to_unode_table pst thm_term: Outer_Path_To_Unode.path_to_unode_table;
    val (ind_best_records, ind_max_point) = Apply_SeLFiE.score_n_induct_argss_n_proof_state_to_best_pairs 0.0 [] [] Apply_SeLFiE.Induction_Heuristic 5 pst outer_path_to_unode_table;
    fun record_to_pair {score, modifiers,...} = (score, modifiers);
    val best_pairs            = Par_List.map record_to_pair ind_best_records
                              : (real * SeLFiE_Util.induct_arguments) list;
    val arb_pairs             = Smart_Construction.proof_state_n_terms_n_induct_argumentss_to_induct_argumentss_w_arbs pst (Isabelle_Utils.pstate_to_1st_subg_n_chained_facts pst) best_pairs
                              :  (real * SeLFiE_Util.induct_arguments) list;
    val (arb_best_records, _) = Apply_SeLFiE.score_n_induct_argss_n_proof_state_to_best_pairs ind_max_point arb_pairs best_pairs Apply_SeLFiE.Generalization_Heuristic 10 pst outer_path_to_unode_table;
    fun mk_arb_message (record:{modifiers: SeLFiE_Util.induct_arguments, score: real}) = SeLFiE_Util.induct_arguments_to_string (#modifiers record);
    val best_arb_messages     = map mk_arb_message arb_best_records: strings;
    val app_best_arb_messages = map (fn parenthesis => "apply " ^ parenthesis) best_arb_messages
in
  app_best_arb_messages:strings
end;

fun mk_state_stttac (smart_induct_output_str:string) = Dynamic_Utils.logtac_to_stttac (tool_output_n_timeout_to_logtac smart_induct_output_str 30.0);

fun state_stttacs (pst:Proof.state) =
  let
    val induct_output_strs = Utils.try_with [] (Isabelle_Utils.timeout_apply (seconds 30.0) pst_to_smart_induct_output_strs) pst: strings;
    val stttacs            = Par_List.map mk_state_stttac induct_output_strs:  Proof.state Dynamic_Utils.stttac list;
  in
    stttacs
  end;

end;

val timeout    = Isabelle_Utils.timeout_apply (seconds 5.0);

(** The exposed part of Subtools **)
val quickcheck = timeout Quickcheck_Tactic.state_stttac;

val nitpick    = timeout Nitpick_Tactic.state_stttac;

val hammer     = Isabelle_Utils.timeout_apply (seconds 10.0) Sledgehammer_Tactic.state_stttac;

val to_stttac  = Dynamic_Utils.log_n_nontac_to_stttac;

fun is_solved_nontac(state:Proof.state) =
  let
    val done    = Proof.local_done_proof;
    val goal    = state |> Proof.goal |> #goal : thm;
    val no_goal = Thm.nprems_of goal = 0 : bool;
    val result  = if no_goal then state |> done |> Seq.single
      handle ERROR _ => Seq.single state else Seq.empty;
  in
    result : Proof.state Seq.seq
  end;

val is_solved = to_stttac ([Dynamic_Utils.Done], is_solved_nontac);

val defer = to_stttac ([Dynamic_Utils.Defer], Seq.single o (Proof.defer 1));

val subgoal_nontac = Seq.single o #2 o Subgoal.subgoal (Binding.empty, []) NONE (false, []);

val subgoal = to_stttac ([Dynamic_Utils.Subgoal], subgoal_nontac);

fun smart_induct pst = Utils.try_with [] (Isabelle_Utils.timeout_apply (seconds 30.0) Smart_Induct_Tactic.state_stttacs) pst |> Seq.of_list;

end;