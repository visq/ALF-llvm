define i32 @main() nounwind {
bb0:
  br label %bb1

bb1:
  %i      = phi i32 [ 0, %bb0 ], [ %in, %bb1 ]
  %0      = add nsw i32 0,0
  %1      = add nsw i32 0,0
  %2      = sub nsw i32 %0, %1
  %3      = add nsw i32 %2, 1
  %in     = add nsw i32 %i, %3  
  %exitcond = icmp eq i32 %in, 10
  br i1 %exitcond, label %return, label %bb1

return:
  ret i32 0
}
