; ModuleID = '<stdin>'
; target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"
; target triple = "armv4t-elf-linux"

@arg = common global [4 x i32] zeroinitializer, align 4

define i32 @main() {
       %ap  = getelementptr inbounds [4 x i32]* @arg, i32 0, i32 3
       store i32 1, i32* %ap
       %arg = load [4 x i32]* @arg, align 4
       ; %arg = [0,0,0,1]
       %r = call [4 x i32] @process([4 x i32] %arg)
       ; %r   = [?,1,?,?]
       %rv = extractvalue [4 x i32] %r, 1
       ; %rv = 1
       %ret = sub i32 %rv, 1
       ret i32 %ret
}

define [4 x i32] @process([4 x i32] %arg) nounwind {
entry:
  %local = alloca [4 x i32], align 4
  %a     = extractvalue [4 x i32] %arg, 3
  %lp    = getelementptr inbounds [4 x i32]* %local, i32 0, i32 1
  store i32 %a, i32* %lp
  %localval = load [4 x i32]* %local
  ret [4 x i32] %localval
}
