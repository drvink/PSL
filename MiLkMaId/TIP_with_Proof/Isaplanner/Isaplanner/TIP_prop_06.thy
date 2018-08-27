(* Property from Case-Analysis for Rippling and Inductive Proof, 
   Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010. 
   This Isabelle theory is produced using the TIP tool offered at the following website: 
     https://github.com/tip-org/tools 
   This file was originally provided as part of TIP benchmark at the following website:
     https://github.com/tip-org/benchmarks 
   Yutaka Nagashima at CIIRC, CTU changed the TIP output theory file slightly 
   to make it compatible with Isabelle2017.
   Some proofs were added by Yutaka Nagashima.*)
  theory TIP_prop_06
imports "../../Test_Base" "../../../src/Build_Database/Build_Database"
begin

datatype Nat = Z | S "Nat"

fun t22 :: "Nat => Nat => Nat" where
"t22 (Z) y = y"
| "t22 (S z) y = S (t22 z y)"

fun t2 :: "Nat => Nat => Nat" where
"t2 (Z) y = Z"
| "t2 (S z) (Z) = S z"
| "t2 (S z) (S x2) = t2 z x2"

theorem property0 :
  "((t2 n (t22 n m)) = Z)"
  find_proof DInd
  apply2 (induct n (*arbitrary: m*))
  apply auto
  done

theorem property0' :
  "((t2 n (t22 n m)) = Z)"
  apply(induct n m arbitrary: m rule:t22.induct)
   apply auto
  done

theorem property0'' :
  "((t2 n (t22 n m)) = Z)"
  find_proof DInd
  apply (induct n arbitrary: m)
  apply auto
  done

end
