; ModuleID = 'ins_br'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  br label %Good
Bad:
  ret i32 1
Good:
  ret i32 0
}
