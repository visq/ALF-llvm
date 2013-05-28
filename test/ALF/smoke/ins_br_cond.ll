; ModuleID = 'ins_br'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %cond = icmp eq i32 %argc, 1
  br i1 %cond, label %IfEqual, label %IfUnequal
IfUnequal:
  ret i32 1
IfEqual:
  ret i32 0
}
