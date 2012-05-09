; arm layout
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"
target triple = "armv4t-elf-linux"

@bit = common global [33 x i32] zeroinitializer, align 4


define i32 @f1(i32 %x) {
       %idx = getelementptr inbounds [33 x i32]* @bit, i32 0, i32 %x
       %a = load i32* %idx, align 4
       ret i32 %a
}
define i32 @f2(i16 %x) {
       %idx = getelementptr inbounds [33 x i32]* @bit, i32 0, i16 %x
       %a = load i32* %idx, align 4
       ret i32 %a
}
define i32 @f3(i8 %x) {
       %idx = getelementptr inbounds [33 x i32]* @bit, i32 0, i8 %x
       %a = load i32* %idx, align 4
       ret i32 %a
}
define i32 @main() {
       %a = call i32 @f1(i32 0)
       %b = call i32 @f2(i16 1)
       %c = call i32 @f3(i8 0)
       %ret = add i32 %c, %b
       ret i32 %ret

}