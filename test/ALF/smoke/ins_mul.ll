; ModuleID = 'ins_mul'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %v = mul i32 %argc, 0
  ret i32 %v
}
