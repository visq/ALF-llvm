; ModuleID = '<stdin>'
; target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"
; target triple = "armv4t-elf-linux"

@arg = common global [4 x i32] zeroinitializer, align 4

define i32 @main() {
       %p1  = getelementptr inbounds [4 x i32]* @arg, i32 0, i32 3
       store i32 1, i32* %p1
       %arg = load [4 x i32]* @arg, align 4
       %r = call i32 @process([4 x i32] %arg)
       ret i32 %r
}

define i32 @process([4 x i32] %arg) nounwind {
entry:
  %local = alloca [4 x i32], align 4
  store [4 x i32] %arg, [4 x i32]* %local
  %p2 = getelementptr inbounds [4 x i32]* %local, i32 0, i32 3
  %p3 = load i32* %p2
  %p4 = sub i32 %p3, 1
  ret i32 %p4
}
