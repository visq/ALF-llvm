; ModuleID = 'ins_phi'
define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %cmp = icmp eq i32 %argc, 1
  br i1 %cmp, label %IfEqual, label %IfUnequal
IfUnequal:
  br label %Join
IfEqual:
  br label %Join
Join:
  %r = phi i32 [ 1, %IfUnequal ], [ 0, %IfEqual ]
  ret i32 %r
}
