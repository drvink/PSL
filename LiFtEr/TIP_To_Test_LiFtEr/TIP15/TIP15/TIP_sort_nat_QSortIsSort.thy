(* This Isabelle theory is produced using the TIP tool offered at the following website: 
     https://github.com/tip-org/tools 
   This file was originally provided as part of TIP benchmark at the following website:
     https://github.com/tip-org/benchmarks 
   Yutaka Nagashima at CIIRC, CTU changed the TIP output theory file slightly 
   to make it compatible with Isabelle2017.*)
  theory TIP_sort_nat_QSortIsSort
  imports "../../Test_Base"
begin

datatype 'a list = nil2 | cons2 "'a" "'a list"

datatype Nat = Z | S "Nat"

fun x :: "'a list => 'a list => 'a list" where
  "x (nil2) z = z"
| "x (cons2 z2 xs) z = cons2 z2 (x xs z)"

fun lt :: "Nat => Nat => bool" where
  "lt y (Z) = False"
| "lt (Z) (S z2) = True"
| "lt (S n) (S z2) = lt n z2"

fun le :: "Nat => Nat => bool" where
  "le (Z) z = True"
| "le (S z2) (Z) = False"
| "le (S z2) (S x2) = le z2 x2"

fun insert :: "Nat => Nat list => Nat list" where
  "insert y (nil2) = cons2 y (nil2)"
| "insert y (cons2 z2 xs) =
     (if le y z2 then cons2 y (cons2 z2 xs) else
        cons2 z2 (insert y xs))"

fun isort :: "Nat list => Nat list" where
  "isort (nil2) = nil2"
| "isort (cons2 z xs) = insert z (isort xs)"

fun gt :: "Nat => Nat => bool" where
  "gt y z = lt z y"

fun filter :: "('a => bool) => 'a list => 'a list" where
  "filter q (nil2) = nil2"
| "filter q (cons2 z xs) =
     (if q z then cons2 z (filter q xs) else filter q xs)"

(*fun did not finish the proof*)
function qsort :: "Nat list => Nat list" where
  "qsort (nil2) = nil2"
| "qsort (cons2 z xs) =
     x (qsort (filter (% (z2 :: Nat) => le z2 z) xs))
       (x (cons2 z (nil2))
          (qsort (filter (% (x2 :: Nat) => gt x2 z) xs)))"
  by pat_completeness auto

theorem property0 :
  "((qsort xs) = (isort xs))"
  oops

end
