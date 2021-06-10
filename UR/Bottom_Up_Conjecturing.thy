(*  Title:      PSL/UR/Bottom_Up_Conjecturing.thy
    Author:     Yutaka Nagashima, Czech Technical University in Prague, the University of Innsbruck

A part of this file is copied from Pure/Tools/find_consts.ML.
The authors of that part are Timothy Bourke and Gerwin Klein, NICTA.
*)

theory Bottom_Up_Conjecturing
  imports Main "PSL.PSL"
begin

ML_file "Pretty_Consts.ML"

ML\<open> signature BOTTOM_UP_CONJECTURING =
sig

datatype direction = Left | Right;

datatype bottom_up_for_binary_function =
  Associativity
| Identity       of direction
| Invertibility  of direction
| Commutativity
| Idempotent_Element of direction
| Idempotency        of direction;

datatype bottom_up_for_two_functions =
  Distributivity     (*2,2*)
| Ant_Distributivity (*1,2*)
| Homomorphism_2;    (*1,2*)

datatype bottom_up_for_relations =
  Transitivity
| Symmetry
| Connexity
| Reflexivity;

val ctxt_n_typ_to_typs: Proof.context -> typ -> typ list;

val ctxt_n_typ_to_consts: Proof.context -> typ -> terms;

(*bottom_up_for_binary_function*)
(*f (f (x, y), z) = f (x, f (y, z))*)
val ctxt_n_const_to_associativity:       Proof.context -> term -> term list;
(*left identity : f (e, x) = x*)
val ctxt_n_const_to_left_identity:       Proof.context -> term -> term list;
(*right identity: f (x, e) = x*)
val ctxt_n_const_to_right_identity:      Proof.context -> term -> term list;
(*f (x,y) = e: x is the left inverse of y and y is the right inverse of x*)
(*These type signatures for invertibility are not great. We should identify *)
val ctxt_n_const_to_left_invertibility:  Proof.context -> term -> term -> term list;
val ctxt_n_const_to_right_invertibility: Proof.context -> term -> term -> term list;
(*f (x, y) = f (y, x)*)
val ctxt_n_const_to_commutativity:       Proof.context -> term -> term list;
val ctxt_n_const_to_idempotent_element:  Proof.context -> term -> term list;
val ctxt_n_const_to_idempotency:         Proof.context -> term -> term list;

(*bottom_up_for_two_functions*)
val ctxt_n_consts_to_distributivity:     Proof.context -> (term * term) -> term list;
val ctxt_n_consts_to_anti_distributivity:Proof.context -> (term * term) -> term list;
(*f (g (x, y)) = g (f (x), f (y))*)
val ctxt_n_trms_to_homomorphism_2:       Proof.context -> (term * term) -> term list;

(*bottom_up_for_relations*)
val ctxt_n_consts_to_symmetry:           Proof.context -> term -> term list;
val ctxt_n_consts_to_reflexibility:      Proof.context -> term -> term list;
val ctxt_n_consts_to_transitivity:       Proof.context -> term -> term list;
val ctxt_n_consts_to_connexity:          Proof.context -> term -> term list;

end;
\<close>

ML\<open> structure Bottom_Up_Conjecturing: BOTTOM_UP_CONJECTURING =
struct

datatype direction = Left | Right;

datatype bottom_up_for_binary_function =
  Associativity
| Identity       of direction
| Invertibility  of direction
| Commutativity
| Idempotent_Element of direction
| Idempotency        of direction;

datatype bottom_up_for_two_functions =
  Distributivity     (*2,2*)
| Ant_Distributivity (*1,2*)
| Homomorphism_2;    (*1,2*)

datatype bottom_up_for_relations =
  Transitivity
| Symmetry
| Connexity
| Reflexivity;

val ctxt_n_typ_to_typs = undefined: Proof.context -> typ -> typ list;

val ctxt_n_typ_to_consts = undefined: Proof.context -> typ -> terms;

fun mk_free_variable_of_typ (typ:typ) (i:int) = Free ("var_" ^ Int.toString i, typ);
(*assume binary*)(*TODO: Do not assume.*)
val list_comb = Term.list_comb;

fun all_args_are_same_typ (funcs:terms) =(*TODO: rename?*)
  let
    fun get_arg_typs (f:typ)      = (snd (strip_type f)::fst (strip_type f))   : typ list;
    val typs                      = map (get_arg_typs o type_of) funcs |> flat : typ list;
    val numb_of_distinct_elements = distinct (op =) typs |> length             : int;
  in
    numb_of_distinct_elements = 1
  end;

(*bottom_up_for_binary_function*)
fun ctxt_consts_string_trm_to_conjecture (ctxt:Proof.context) (consts:terms) (conj_typ:string) (conjecture_trm:term) =
let
  val consts_str = map (Long_Name.base_name o fst o dest_Const) consts |> String.concatWith "_": string;
  val lemma_name = conj_typ ^ "_" ^ consts_str: string;
  val conjecture_as_string = Isabelle_Utils.trm_to_string ctxt conjecture_trm: string;
in
   {lemma_name = lemma_name,  lemma_stmt = conjecture_as_string}
end;

fun mk_eq (lhs:term, rhs:term) = Isabelle_Utils.strip_atyp @{term "HOL.eq"} $ Isabelle_Utils.strip_atyp lhs $ Isabelle_Utils.strip_atyp rhs;

fun ctxt_n_const_to_associativity (ctxt:Proof.context) (func:term) =
(*f (f (x, y), z) = f (x, f (y, z))*)
if Isabelle_Utils.takes_n_arguments func 2 andalso all_args_are_same_typ [func]
then
 (let
    val func_w_dummyT      = map_types (K dummyT) func                   : term;
    val [var1, var2, var3] = map (mk_free_variable_of_typ dummyT) [1,2,3]: terms;
    val lhs                = list_comb (func_w_dummyT, [var1, list_comb (func_w_dummyT, [var2, var3])]) |> Isabelle_Utils.strip_atyp;
    val rhs                = list_comb (func_w_dummyT, [list_comb (func_w_dummyT, [var1, var2]), var3]) |> Isabelle_Utils.strip_atyp;
    val assoc              = mk_eq (lhs, rhs): term;
  in
    [assoc]
    (*[Syntax.check_term ctxt assoc |> ctxt_consts_string_trm_to_conjecture ctxt [func] "associativity"]*)
  end)
else []: term list
;

val ctxt_n_const_to_left_identity  = undefined:      Proof.context -> term -> term list;
val ctxt_n_const_to_right_identity = undefined:      Proof.context -> term -> term list;

fun ctxt_n_const_to_left_invertibility (ctxt:Proof.context) (identity_element as Const _:term) (func as Const _:term) =
(*f (x,y) = e: x is the left inverse of y and y is the right inverse of x*)
  if Isabelle_Utils.takes_n_arguments func 2 andalso all_args_are_same_typ [func]
  then
    let
      val func_w_dummyT           = Isabelle_Utils.strip_atyp func                                      : term;
      val (var1, var2)            = Utils.map_pair (mk_free_variable_of_typ dummyT) (1,2): (term * term);
      val identity_element_wo_typ = Isabelle_Utils.strip_atyp identity_element                          : term;
      val lhs                     = list_comb (func_w_dummyT, [var1, var2])                             : term;
      val invertibility           = mk_eq (lhs, identity_element_wo_typ)                                : term;
    in
      [invertibility]
      (*[Syntax.check_term ctxt invertibility: term] |> map (ctxt_consts_string_trm_to_conjecture ctxt [identity_element, func] "invertibility")*)
    end
  else []
| ctxt_n_const_to_left_invertibility _ _ _ = [];

val ctxt_n_const_to_right_invertibility = undefined: Proof.context -> term -> term -> term list;

 fun ctxt_n_const_to_commutativity (ctxt:Proof.context) (func:term) =
(*f (x, y) = f (y, x)*)
if Isabelle_Utils.takes_n_arguments func 2 andalso all_args_are_same_typ [func]
then
  let
    val func_w_dummyT = Isabelle_Utils.strip_atyp func: term;
    val (var1,var2)   = Utils.map_pair (mk_free_variable_of_typ dummyT) (1,2): (term * term);
    val lhs           = list_comb (func_w_dummyT, [var1,var2]);
    val rhs           = list_comb (func_w_dummyT, [var2,var1]);
    val commutativity = mk_eq (lhs, rhs): term;
  in [commutativity] end
else [];

fun ctxt_n_typ_to_nullary_const ctxt typ =
  let
    fun ctxt_n_typ_to_nullary_const' (ctxt:Proof.context) (typ:typ) =
      (*as a candidate for the identity element*)
      let
        val typ_as_string   = Syntax.string_of_typ ctxt typ
            |> YXML.parse_body
            |> XML.content_of : string;
        val const_typ_pairs = Pretty_Consts.pretty_consts ctxt [(true, Find_Consts.Strict typ_as_string)]: (string * typ) list;
        val const_names     = map fst const_typ_pairs                                      : strings;
        val consts_w_dummyT = map (fn cname => Const (cname, dummyT)) const_names          : terms;
      in
        consts_w_dummyT: terms
      end;
  in try (ctxt_n_typ_to_nullary_const' ctxt) typ |> Utils.is_some_null end;

fun ctxt_n_typ_to_unary_const ctxt typ =
  let
    fun ctxt_n_typ_to_unary_const' (ctxt:Proof.context) (typ:typ) =
      (*as a candidate for the identity element*)
      let
        val func_typ = typ --> typ: typ;
        val typ_as_string   = Syntax.string_of_typ ctxt func_typ
            |> YXML.parse_body
            |> XML.content_of : string;
        val const_typ_pairs = Pretty_Consts.pretty_consts ctxt [(true, Find_Consts.Strict typ_as_string)]: (string * typ) list;
        val const_names     = map fst const_typ_pairs                                      : strings;
        val consts_w_dummyT = map (fn cname => Const (cname, dummyT)) const_names          : terms;
      in
        consts_w_dummyT: terms
      end;
  in
    try (ctxt_n_typ_to_unary_const' ctxt) typ |> Utils.is_some_null
  end;

fun ctxt_n_direct_n_trm_to_identity (ctxt:Proof.context) (direct:direction) (func as Const (_, typ):term) =
(*left identity : f (e, x) = x*)
(*right identity: f (x, e) = x*)
  if Isabelle_Utils.takes_n_arguments func 2 andalso all_args_are_same_typ [func]
  then
    let
      val typ_of_arg     = binder_types typ |> (case direct of
                            Left  =>  List.hd
                          | Right => (Utils.the' "ctxt_n_trm_to_identity in Bottom_Up_Conjecturing.ML failed"
                                    o try (fn args => nth args 1)))   : typ;
      val nullary_consts = ctxt_n_typ_to_nullary_const ctxt typ_of_arg: terms;
      val func_w_dummyT  = Isabelle_Utils.strip_atyp func            : term;
      val free_var       = mk_free_variable_of_typ dummyT 1           : term;
      fun mk_equation (identity_element:term) =
        let
          val lhs = case direct of
              Left  => list_comb (func_w_dummyT, [identity_element, free_var]): term
            | Right => list_comb (func_w_dummyT, [free_var, identity_element]): term;
          val rhs = free_var                                                  : term;
          val eq  = mk_eq (lhs, rhs)                                          : term;
        in
          Syntax.check_term ctxt eq
        end;
    in
      map mk_equation nullary_consts
    end
  else []
  | ctxt_n_direct_n_trm_to_identity _ _ _ = [];

val _ = ctxt_n_direct_n_trm_to_identity @{context} Right @{term "qrev"}
|> map (Isabelle_Utils.trm_to_string @{context})
|> map tracing;

(*TODO define these using functions defined above.*)
val ctxt_n_const_to_idempotent_element = undefined:  Proof.context -> term -> term list;
val ctxt_n_const_to_idempotency = undefined:         Proof.context -> term -> term list;

(*bottom_up_for_two_functions*)
fun ctxt_n_consts_to_distributivity (ctxt:Proof.context) (func1, func2) =
(* left-distributive:  f (x, g (y, z)) = g (f (x, y), f (x, z))
 * right-distributive: f (g (x, y), z) = g (f (x, y), f (x, z))
 *)
  if Isabelle_Utils.takes_n_arguments func1 2 andalso Isabelle_Utils.takes_n_arguments func2 2 andalso all_args_are_same_typ [func1, func2]
  then
    let
      val (func1_wo_typ, func2_wo_typ) = Utils.map_pair Isabelle_Utils.strip_atyp (func1, func2): (term * term);
      val [var1, var2, var3]           = map (mk_free_variable_of_typ dummyT) [1,2,3]     : terms;
      val (left_lhs, right_lhs)        =  (list_comb (func1_wo_typ, [var1,                                  list_comb (func2_wo_typ, [var2, var3])]),
                                           list_comb (func1_wo_typ, [list_comb (func2_wo_typ, [var1, var2]), var3])
                                           );
      val (left_rhs, right_rhs)        =  (list_comb
                                            (func2_wo_typ,
                                             [list_comb (func1_wo_typ, [var1, var2]),
                                              list_comb (func1_wo_typ, [var1, var3])
                                              ]
                                             ),
                                           list_comb
                                            (func2_wo_typ,
                                             [list_comb (func1_wo_typ, [var1, var3]),
                                              list_comb (func1_wo_typ, [var2, var3])
                                              ]
                                             )
                                           );
      val (left, right)                = (mk_eq (left_lhs, left_rhs), mk_eq (right_lhs, right_rhs)) |> Utils.map_pair (Syntax.check_term ctxt);
    in
      [left, right]
     (*
     [ctxt_consts_string_trm_to_conjecture ctxt [func1, func2] "left_distributivity"  left,
      ctxt_consts_string_trm_to_conjecture ctxt [func1, func2] "right_distributivity" right]
     *)
    end
  else [];
(*val ctxt_n_consts_to_distributivity = undefined:     Proof.context -> (term * term) -> (term * term) list;*)
fun ctxt_n_consts_to_anti_distributivity (ctxt:Proof.context) (unary_func, binary_func) =
(*distributivity of f on g*)
(*f (g (x, y)) = g (f (y), f (x))*)
if Isabelle_Utils.takes_n_arguments unary_func  1 andalso
   Isabelle_Utils.takes_n_arguments binary_func 2 andalso
   all_args_are_same_typ [unary_func, binary_func]
then
  let
    val (unary_wo_typ, binary_wo_typ) = Utils.map_pair Isabelle_Utils.strip_atyp (unary_func, binary_func): (term * term);
    val (var1, var2)                  = Utils.map_pair (mk_free_variable_of_typ dummyT) (1,2)              : (term * term);
    val lhs                           = list_comb (unary_wo_typ, [list_comb (binary_wo_typ, [var1, var2])]): term;
    val rhs                           = (list_comb
                                         (binary_wo_typ,
                                          [list_comb (unary_wo_typ, [var2]),
                                           list_comb (unary_wo_typ, [var1])
                                           ]
                                          )
                                        );
    val anti_distributivity           = mk_eq (lhs, rhs) |> Syntax.check_term ctxt: term;
  in
    [anti_distributivity]
  end
else [];

fun ctxt_n_trms_to_homomorphism_2 (ctxt:Proof.context) (homomorphism:term, preserved_binary:term) =
(*f is homomorphism.*)
(*f (g (x, y)) = g (f (x), f (y))*)
if Isabelle_Utils.takes_n_arguments homomorphism 1 andalso
   Isabelle_Utils.takes_n_arguments preserved_binary 2 andalso
   all_args_are_same_typ [homomorphism, preserved_binary]
then
  let
    val (homomorphism_wo_typ, preserved_binary_wo_typ) = Utils.map_pair Isabelle_Utils.strip_atyp (homomorphism, preserved_binary): term * term;
    val (var1, var2) = Utils.map_pair (mk_free_variable_of_typ dummyT) (1,2)                                                       : (term * term);
    val lhs          = (homomorphism_wo_typ $ list_comb (preserved_binary_wo_typ, [var1, var2]))                                   : term;
    val rhs          = list_comb (preserved_binary_wo_typ, [homomorphism_wo_typ $ var1, homomorphism_wo_typ $ var2])               : term;
    val proprerty    = mk_eq (lhs, rhs) |> Syntax.check_term ctxt                                                                  : term;
  in
    [proprerty]
  end
else [];

(*bottom_up_for_relations*)
fun term_is_relation (Const (_, typ)) = body_type typ = @{typ "HOL.bool"}
  | term_is_relation _ = false;

val ctxt_n_consts_to_symmetry = undefined:           Proof.context -> term -> term list;
val ctxt_n_consts_to_reflexibility = undefined:      Proof.context -> term -> term list;
val ctxt_n_consts_to_transitivity = undefined:       Proof.context -> term -> term list;
val ctxt_n_consts_to_connexity = undefined:          Proof.context -> term -> term list;

end;
\<close>

datatype 'a list = nil2 | cons2 "'a" "'a list"

print_theorems

datatype Nat = Z | S "Nat"

fun qrev :: "'a list => 'a list => 'a list" where
  "qrev (nil2) y = y"
| "qrev (cons2 z xs) y = qrev xs (cons2 z y)"

fun x :: "'a list => 'a list => 'a list" where
  "x (nil2) z = z"
| "x (cons2 z2 xs) z = cons2 z2 (x xs z)"

fun rev :: "'a list => 'a list" where
  "rev (nil2) = nil2"
| "rev (cons2 z xs) = x (rev xs) (cons2 z (nil2))"

ML\<open> ctxt_n_typ_to_unary_const @{context} @{typ "Nat"} \<close>

end