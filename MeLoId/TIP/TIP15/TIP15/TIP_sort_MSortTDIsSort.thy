(* This Isabelle theory is produced using the TIP tool offered at the following website: 
     https://github.com/tip-org/tools 
   This file was originally provided as part of TIP benchmark at the following website:
     https://github.com/tip-org/benchmarks 
   Yutaka Nagashima at CIIRC, CTU changed the TIP output theory file slightly 
   to make it compatible with Isabelle2017.*)
  theory TIP_sort_MSortTDIsSort
  imports "../../Test_Base"
begin

datatype 'a list = nil2 | cons2 "'a" "'a list"

fun take :: "int => 'a list => 'a list" where
  "take x y =
   (if x <= 0 then nil2 else
      (case y of
         nil2 => nil2
         | cons2 z xs => cons2 z (take (x - 1) xs)))"

fun lmerge :: "int list => int list => int list" where
  "lmerge (nil2) y = y"
| "lmerge (cons2 z x2) (nil2) = cons2 z x2"
| "lmerge (cons2 z x2) (cons2 x3 x4) =
     (if z <= x3 then cons2 z (lmerge x2 (cons2 x3 x4)) else
        cons2 x3 (lmerge (cons2 z x2) x4))"

fun length :: "'a list => int" where
  "length (nil2) = 0"
| "length (cons2 y l) = 1 + (length l)"

fun insert :: "int => int list => int list" where
  "insert x (nil2) = cons2 x (nil2)"
| "insert x (cons2 z xs) =
     (if x <= z then cons2 x (cons2 z xs) else cons2 z (insert x xs))"

fun isort :: "int list => int list" where
  "isort (nil2) = nil2"
| "isort (cons2 y xs) = insert y (isort xs)"

fun drop :: "int => 'a list => 'a list" where
  "drop x y =
   (if x <= 0 then y else
      (case y of
         nil2 => nil2
         | cons2 z xs1 => drop (x - 1) xs1))"

(*fun did not finish the proof*)
function msorttd :: "int list => int list" where
  "msorttd (nil2) = nil2"
| "msorttd (cons2 y (nil2)) = cons2 y (nil2)"
| "msorttd (cons2 y (cons2 x2 x3)) =
     (let k :: int = (op div) (length (cons2 y (cons2 x2 x3))) 2
     in lmerge
          (msorttd (take k (cons2 y (cons2 x2 x3))))
          (msorttd (drop k (cons2 y (cons2 x2 x3)))))"
  by pat_completeness auto

theorem property0 :
  "((msorttd xs) = (isort xs))"
  oops

end
