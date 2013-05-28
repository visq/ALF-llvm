; ModuleID = 'global_int'
@global = global i32 7

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %tmp = load i32* @global
  %v = sub i32 %tmp, 7
  ret i32 %v
}
