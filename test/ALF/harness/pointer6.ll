; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@data = global [9 x i8] c"\03\05\08\09\0B\0D\0F\12\00", align 4

define i32 @test(i8* %p) nounwind uwtable {
entry:
  br label %while.cond

while.cond:                                       ; preds = %sw.epilog, %entry
  %r.0 = phi i32 [ 0, %entry ], [ %r.1, %sw.epilog ]
  %c.0 = phi i32 [ 0, %entry ], [ %c.4, %sw.epilog ]
  %p.addr.0 = phi i8* [ %p, %entry ], [ %incdec.ptr, %sw.epilog ]
  %incdec.ptr = getelementptr inbounds i8* %p.addr.0, i64 1
  %tmp = load i8* %p.addr.0, align 1
  %tobool = icmp eq i8 %tmp, 0
  br i1 %tobool, label %while.end, label %while.body

while.body:                                       ; preds = %while.cond
  %tmp1 = ptrtoint i8* %incdec.ptr to i64
  %and = and i64 %tmp1, 4
  switch i64 %and, label %sw.epilog [
    i64 0, label %sw.bb
    i64 1, label %sw.bb1
    i64 2, label %sw.bb3
    i64 3, label %sw.bb7
  ]

sw.bb:                                            ; preds = %while.body
  %tmp2 = load i8* %incdec.ptr, align 1
  %conv = zext i8 %tmp2 to i32
  br label %sw.bb1

sw.bb1:                                           ; preds = %sw.bb, %while.body
  %c.1 = phi i32 [ %c.0, %while.body ], [ %conv, %sw.bb ]
  %shl = shl i32 %c.1, 8
  %tmp3 = load i8* %incdec.ptr, align 1
  %conv2 = zext i8 %tmp3 to i32
  %or = or i32 %shl, %conv2
  br label %sw.bb3

sw.bb3:                                           ; preds = %sw.bb1, %while.body
  %c.2 = phi i32 [ %c.0, %while.body ], [ %or, %sw.bb1 ]
  %shl4 = shl i32 %c.2, 8
  %tmp4 = load i8* %incdec.ptr, align 1
  %conv5 = zext i8 %tmp4 to i32
  %or6 = or i32 %shl4, %conv5
  br label %sw.bb7

sw.bb7:                                           ; preds = %sw.bb3, %while.body
  %c.3 = phi i32 [ %c.0, %while.body ], [ %or6, %sw.bb3 ]
  %shl8 = shl i32 %c.3, 8
  %tmp5 = load i8* %incdec.ptr, align 1
  %conv9 = zext i8 %tmp5 to i32
  %or10 = or i32 %shl8, %conv9
  %xor = xor i32 %r.0, %or10
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.bb7, %while.body
  %r.1 = phi i32 [ %r.0, %while.body ], [ %xor, %sw.bb7 ]
  %c.4 = phi i32 [ %c.0, %while.body ], [ %c.3, %sw.bb7 ]
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret i32 %r.0
}

define i32 @main() nounwind uwtable {
entry:
  %call = call i32 @test(i8* getelementptr inbounds ([9 x i8]* @data, i64 0, i64 0))
  %cmp = icmp eq i32 %call, 67372036
  br i1 %cmp, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i32 [ 1, %if.then ], [ 0, %if.end ]
  ret i32 %retval.0
}
