; ModuleID = 'ins_store'
@global = global i32 7

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  store i32 5, i32* @global
  %tmp = load i32* @global
  %v = sub i32 %tmp, 5
  ret i32 %v
}
