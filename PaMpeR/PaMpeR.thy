(*  Title:      PaMpeR.thy
    Author:     Yilun He, Data61, CSIRO
    
    Import this file to enable Proof Method Recommendation System and Feature Extraction.
    The system has two components: 
      1.Feature extraction
        Enable Feature extraction by calling the initiating function in FE_Interface
        which redefines the keyword by and apply, for each call of keyword generate
        a line of Feature from the state and also the applied tactic.
        
        These data are stored by default in ./isabelle/Database, and should be manually
        deleted after use to make space for new training.
        
        The python script TrainScript.py provides an example of python machine
        learning on the database. Feel free to use your own training algorithm with the generated Database file.
        
      2.Proof method recommendation 
        
        Keyword which_method can be called during a proof stage.
        If there is still a subgoal, it will provide recommendation of method
        for the first subgoal.
        
        The default database provided is generated by multioutput regression
        from Archive of Formal Proof.
*)
theory PaMpeR
  imports Decision_Tree
  keywords "which_method" :: diag
  and    "why_method" :: diag
  and    "build_regression_trees" :: thy_decl
  and    "print_out_regression_trees" :: thy_decl
  and    "reset_regression_tree_table" :: thy_decl
  and    "read_regression_trees" :: thy_decl
  and    "build_fast_feature_extractor" :: thy_decl
begin

ML_file "./Assertions.ML"
ML_file "../src/Parser_Combinator.ML"
ML_file "./PaMpeR_Interface.ML"

build_regression_trees

print_out_regression_trees

reset_regression_tree_table

read_regression_trees

build_fast_feature_extractor

ML_file "./FE_Interface.ML"

end
