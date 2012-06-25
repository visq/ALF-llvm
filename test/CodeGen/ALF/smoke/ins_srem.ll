; ModuleID = 'ins_srem'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %v1 = add i32 %argc, 7
  %v = srem i32 %v1, 8
  ret i32 %v
}
