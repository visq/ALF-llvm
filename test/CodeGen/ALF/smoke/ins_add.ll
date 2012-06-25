; ModuleID = 'ins_sub'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %v = sub nsw i32 %argc, 1
  ret i32 %v
}
