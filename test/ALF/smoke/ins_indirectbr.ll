; ModuleID = 'ins_indirectbr'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  indirectbr i8* blockaddress(@main, %bb2), [ label %bb1, label %bb2, label %bb3 ]
bb1:
  unreachable
bb2:
  ret i32 0
bb3:
  unreachable
}
