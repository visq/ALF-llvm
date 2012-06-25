; ModuleID = 'ins_ret_struct'

define { i32, i8 } @main(i32 %argc, i8** %argv) {
entry:
  ret { i32, i8 } { i32 4, i8 2 } ; Return a struct of values 4 and 2
}
