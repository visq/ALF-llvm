; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

%struct.mstruct = type { [4 x i32], [4 x i8], [4 x i32] }

@str = global [9 x i8] c"9-char-s\00", align 1
@a = common global %struct.mstruct zeroinitializer, align 4
@b = common global %struct.mstruct zeroinitializer, align 4

define i32 @main() nounwind {
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %steps.0 = phi i32 [ 0, %entry ], [ %inc, %while.body ]
  %p1.0 = phi i8* [ getelementptr inbounds ([9 x i8]* @str, i32 0, i32 1), %entry ], [ %incdec.ptr, %while.body ]
  %p2.0 = phi i8* [ getelementptr inbounds ([9 x i8]* @str, i32 0, i32 8), %entry ], [ %incdec.ptr12, %while.body ]
  %cmp11 = icmp ult i8* %p1.0, %p2.0
  br i1 %cmp11, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %inc = add nsw i32 %steps.0, 1
  %incdec.ptr = getelementptr inbounds i8* %p1.0, i32 1
  %incdec.ptr12 = getelementptr inbounds i8* %p2.0, i32 -1
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %not.cmp13 = icmp ne i32 %steps.0, 4
  %cond14 = zext i1 %not.cmp13 to i32
  ret i32 %cond14
}
