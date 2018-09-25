(* Title:  MiLkMaId/TIP/TIP15/TIP15/TIP15_All.thy
   Author: Yutaka Nagashima at CIIRC, CTU
 *)
  theory TIP15_All
  imports

TIP_bin_distrib
TIP_bin_nat_distrib
TIP_bin_nat_plus
TIP_bin_nat_plus_assoc
TIP_bin_nat_plus_comm
TIP_bin_nat_s
TIP_bin_nat_times
TIP_bin_nat_times_assoc
TIP_bin_nat_times_comm
TIP_bin_plus
TIP_bin_plus_assoc
TIP_bin_plus_comm
TIP_bin_s
TIP_bin_times
TIP_bin_times_assoc
TIP_bin_times_comm
TIP_escape_Injective
TIP_escape_NoSpecial
TIP_fermat_last
TIP_int_add_assoc
TIP_int_add_comm
TIP_int_add_ident_left
TIP_int_add_ident_right
TIP_int_add_inv_left
TIP_int_add_inv_right
TIP_int_left_distrib
TIP_int_mul_assoc
TIP_int_mul_comm
TIP_int_mul_ident_left
TIP_int_mul_ident_right
TIP_int_right_distrib
TIP_list_Interleave
TIP_list_PairEvens
TIP_list_PairOdds
TIP_list_PairUnpair
TIP_list_Select
TIP_list_SelectPermutations
TIP_list_append_inj_1
TIP_list_append_inj_2
TIP_list_assoc
TIP_list_concat_map_bind
TIP_list_count_nub
TIP_list_deleteAll_count
TIP_list_elem
TIP_list_elem_map
TIP_list_elem_nub_l
TIP_list_elem_nub_r
TIP_list_nat_Interleave
(*TIP_list_nat_PairEvens*)
TIP_list_nat_PairOdds
(*TIP_list_nat_PairUnpair*)
TIP_list_nat_Select
TIP_list_nat_SelectPermutations
TIP_list_nat_append_inj_1
TIP_list_nat_append_inj_2
TIP_list_nat_count_nub
TIP_list_nat_deleteAll_count
TIP_list_nat_elem
TIP_list_nat_elem_map
TIP_list_nat_elem_nub_l
TIP_list_nat_elem_nub_r
TIP_list_nat_nub_nub
TIP_list_nat_perm_elem
TIP_list_nat_perm_refl
TIP_list_nat_perm_symm
TIP_list_nat_perm_trans
TIP_list_nub_nub
TIP_list_perm_elem
TIP_list_perm_refl
TIP_list_perm_symm
TIP_list_perm_trans
TIP_list_return_1
TIP_list_return_2
TIP_list_weird_concat_map_bind
(*TIP_list_weird_is_normal*)
TIP_mccarthy91_M1
TIP_mccarthy91_M2
TIP_mod_same
TIP_nat_acc_alt_mul_assoc
TIP_nat_acc_alt_mul_comm
TIP_nat_acc_alt_mul_same
TIP_nat_acc_plus_assoc
TIP_nat_acc_plus_comm
TIP_nat_acc_plus_same
TIP_nat_alt_mul_assoc
TIP_nat_alt_mul_comm
TIP_nat_alt_mul_same
TIP_nat_boring_ge_antisym
TIP_nat_boring_ge_reflexive
TIP_nat_boring_ge_trans
TIP_nat_boring_gt_asymmetric
TIP_nat_boring_gt_irreflexive
TIP_nat_boring_gt_trans
TIP_nat_boring_max_min_abs
TIP_nat_boring_max_min_distrib
TIP_nat_boring_min_assoc
TIP_nat_boring_min_comm
TIP_nat_boring_min_idem
TIP_nat_le_antisym
TIP_nat_le_ge_eq
TIP_nat_le_ne_lt
TIP_nat_le_reflexive
TIP_nat_le_trans
TIP_nat_lt_asymmetric
TIP_nat_lt_irreflexive
TIP_nat_lt_ne
TIP_nat_lt_trans
TIP_nat_max_assoc
TIP_nat_max_comm
TIP_nat_max_idem
TIP_nat_min_max_abs
TIP_nat_min_max_distrib
TIP_nat_pow_le_factorial
TIP_nat_pow_one
TIP_nat_pow_pow
TIP_nat_pow_times
TIP_nicomachus_theorem
(*TIP_polyrec_seq_index*)
TIP_propositional_AndCommutative
TIP_propositional_AndIdempotent
TIP_propositional_AndImplication
TIP_propositional_Okay
TIP_propositional_Sound
TIP_regexp_Deeps
TIP_regexp_PlusAssociative
TIP_regexp_PlusCommutative
TIP_regexp_PlusIdempotent
TIP_regexp_RecAtom
TIP_regexp_RecEps
TIP_regexp_RecNil
TIP_regexp_RecPlus
TIP_regexp_RecSeq
TIP_regexp_RecStar
TIP_regexp_Reverse
TIP_regexp_SeqAssociative
TIP_regexp_SeqDistrPlus
TIP_regexp_Star
TIP_relaxedprefix_correct
TIP_relaxedprefix_is_prefix_1
TIP_relaxedprefix_is_prefix_2
TIP_relaxedprefix_is_prefix_3
TIP_relaxedprefix_is_prefix_4
TIP_rotate_mod
TIP_rotate_self
TIP_rotate_snoc
TIP_rotate_snoc_self
TIP_rotate_structural_mod
TIP_sort_BSortCount
TIP_sort_BSortIsSort
TIP_sort_BSortPermutes
TIP_sort_BSortSorts
TIP_sort_BubSortCount
TIP_sort_BubSortIsSort
TIP_sort_BubSortPermutes
TIP_sort_BubSortSorts
TIP_sort_HSort2Count
TIP_sort_HSort2IsSort
TIP_sort_HSort2Permutes
TIP_sort_HSort2Sorts
TIP_sort_HSortCount
TIP_sort_HSortIsSort
TIP_sort_HSortPermutes
TIP_sort_HSortSorts
TIP_sort_ISortCount
TIP_sort_ISortPermutes
TIP_sort_ISortSorts
TIP_sort_MSortBU2Count
TIP_sort_MSortBU2IsSort
TIP_sort_MSortBU2Permutes
TIP_sort_MSortBU2Sorts
TIP_sort_MSortBUCount
TIP_sort_MSortBUIsSort
TIP_sort_MSortBUPermutes
TIP_sort_MSortBUSorts
TIP_sort_MSortTDCount
TIP_sort_MSortTDIsSort
TIP_sort_MSortTDPermutes
TIP_sort_MSortTDSorts
TIP_sort_NMSortTDCount
TIP_sort_NMSortTDIsSort
TIP_sort_NMSortTDPermutes
TIP_sort_NMSortTDSorts
(*TIP_sort_NStoogeSort2Count*)
TIP_sort_NStoogeSort2IsSort
TIP_sort_NStoogeSort2Permutes
TIP_sort_NStoogeSort2Sorts
TIP_sort_NStoogeSortCount
TIP_sort_NStoogeSortIsSort
TIP_sort_NStoogeSortPermutes
TIP_sort_NStoogeSortSorts
TIP_sort_QSortCount
TIP_sort_QSortIsSort
TIP_sort_QSortPermutes
TIP_sort_QSortSorts
TIP_sort_SSortCount
TIP_sort_SSortIsSort
TIP_sort_SSortPermutes
(*TIP_sort_SSortSorts*)
TIP_sort_StoogeSort2Count
TIP_sort_StoogeSort2IsSort
TIP_sort_StoogeSort2Permutes
TIP_sort_StoogeSort2Sorts
TIP_sort_StoogeSortCount
TIP_sort_StoogeSortIsSort
TIP_sort_StoogeSortPermutes
TIP_sort_StoogeSortSorts
TIP_sort_TSortCount
TIP_sort_TSortIsSort
TIP_sort_TSortPermutes
TIP_sort_TSortSorts
TIP_sort_nat_BSortCount
TIP_sort_nat_BSortIsSort
TIP_sort_nat_BSortPermutes
TIP_sort_nat_BSortSorts
TIP_sort_nat_BubSortCount
TIP_sort_nat_BubSortIsSort
TIP_sort_nat_BubSortPermutes
TIP_sort_nat_BubSortSorts
TIP_sort_nat_HSort2Count
TIP_sort_nat_HSort2IsSort
TIP_sort_nat_HSort2Permutes
TIP_sort_nat_HSort2Sorts
TIP_sort_nat_HSortCount
TIP_sort_nat_HSortIsSort
TIP_sort_nat_HSortPermutes
TIP_sort_nat_HSortSorts
TIP_sort_nat_ISortCount
TIP_sort_nat_ISortPermutes
TIP_sort_nat_ISortSorts
TIP_sort_nat_MSortBU2Count
TIP_sort_nat_MSortBU2IsSort
TIP_sort_nat_MSortBU2Permutes
TIP_sort_nat_MSortBU2Sorts
TIP_sort_nat_MSortBUCount
TIP_sort_nat_MSortBUIsSort
TIP_sort_nat_MSortBUPermutes
TIP_sort_nat_MSortBUSorts
TIP_sort_nat_MSortTDCount
TIP_sort_nat_MSortTDIsSort
TIP_sort_nat_MSortTDPermutes
TIP_sort_nat_MSortTDSorts
TIP_sort_nat_NMSortTDCount
TIP_sort_nat_NMSortTDIsSort
TIP_sort_nat_NMSortTDPermutes
TIP_sort_nat_NMSortTDSorts
TIP_sort_nat_NStoogeSort2Count
TIP_sort_nat_NStoogeSort2IsSort
(*TIP_sort_nat_NStoogeSort2Permutes.th*)
TIP_sort_nat_NStoogeSort2Sorts
TIP_sort_nat_NStoogeSortCount
TIP_sort_nat_NStoogeSortIsSort
TIP_sort_nat_NStoogeSortPermutes
TIP_sort_nat_NStoogeSortSorts
TIP_sort_nat_QSortCount
TIP_sort_nat_QSortIsSort
TIP_sort_nat_QSortPermutes
TIP_sort_nat_QSortSorts
TIP_sort_nat_SSortCount
TIP_sort_nat_SSortIsSort
TIP_sort_nat_SSortPermutes
TIP_sort_nat_SSortSorts
TIP_sort_nat_StoogeSort2Count
TIP_sort_nat_StoogeSort2IsSort
TIP_sort_nat_StoogeSort2Permutes
TIP_sort_nat_StoogeSort2Sorts
TIP_sort_nat_StoogeSortCount
TIP_sort_nat_StoogeSortIsSort
TIP_sort_nat_StoogeSortPermutes
TIP_sort_nat_StoogeSortSorts
TIP_sort_nat_TSortCount
TIP_sort_nat_TSortIsSort
TIP_sort_nat_TSortPermutes
TIP_sort_nat_TSortSorts
TIP_subst_SubstFreeNo
TIP_subst_SubstFreeYes
TIP_tree_Flatten1
TIP_tree_Flatten1List
TIP_tree_Flatten2
TIP_tree_Flatten3
TIP_tree_SwapAB
TIP_weird_nat_add3_assoc1
TIP_weird_nat_add3_assoc2
TIP_weird_nat_add3_assoc3
TIP_weird_nat_add3_comm12
TIP_weird_nat_add3_comm13
TIP_weird_nat_add3_comm23
TIP_weird_nat_add3_rot
TIP_weird_nat_add3_rrot
TIP_weird_nat_add3_same
TIP_weird_nat_add3_spec
TIP_weird_nat_add3acc_assoc1
TIP_weird_nat_add3acc_assoc2
TIP_weird_nat_add3acc_assoc3
TIP_weird_nat_add3acc_comm12
TIP_weird_nat_add3acc_comm13
TIP_weird_nat_add3acc_comm23
TIP_weird_nat_add3acc_rot
TIP_weird_nat_add3acc_rrot
TIP_weird_nat_add3acc_spec
TIP_weird_nat_mul2_assoc
TIP_weird_nat_mul2_comm
TIP_weird_nat_mul3_assoc1
TIP_weird_nat_mul3_assoc2
TIP_weird_nat_mul3_assoc3
TIP_weird_nat_mul3_comm12
TIP_weird_nat_mul3_comm13
TIP_weird_nat_mul3_comm23
TIP_weird_nat_mul3_rot
TIP_weird_nat_mul3_rrot
TIP_weird_nat_mul3_same
TIP_weird_nat_mul3_spec
TIP_weird_nat_mul3acc_assoc1
TIP_weird_nat_mul3acc_assoc2
TIP_weird_nat_mul3acc_assoc3
TIP_weird_nat_mul3acc_comm12
TIP_weird_nat_mul3acc_comm13
TIP_weird_nat_mul3acc_comm23
TIP_weird_nat_mul3acc_rot
TIP_weird_nat_mul3acc_rrot
TIP_weird_nat_mul3acc_spec
TIP_weird_nat_op_assoc
TIP_weird_nat_op_assoc2
TIP_weird_nat_op_comm_comm
TIP_weird_nat_op_spec

begin

end