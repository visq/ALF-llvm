; ModuleID = 'ins_switch'

define i32 @main(i32 %argc, i8** %argv) {
entry:
 ; Implement a jump table:
 switch i32 %argc, label %otherwise [ i32 0, label %onzero
                                      i32 1, label %onone
                                      i32 2, label %ontwo ]
onzero:
  ret i32 1
onone:
  ret i32 2
ontwo:
  ret i32 0
otherwise:
  ret i32 3
}
