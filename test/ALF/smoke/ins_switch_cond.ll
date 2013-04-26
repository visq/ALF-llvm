; ModuleID = 'ins_switch_cond'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  ; Emulate a conditional br instruction
  %cond = icmp eq i32 %argc, 1
  %val = zext i1 %cond to i32
  switch i32 %val, label %IfEqual [ i32 0, label %IfUnequal ]
IfUnequal:
  ret i32 1
IfEqual:
  ret i32 0
}
