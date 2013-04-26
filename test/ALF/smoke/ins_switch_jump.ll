; ModuleID = 'ins_switch_jump'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  ; Emulate an unconditional br instruction
  switch i32 0, label %Good [ ]
Bad:
  ret i32 1
Good:
  ret i32 0
}
