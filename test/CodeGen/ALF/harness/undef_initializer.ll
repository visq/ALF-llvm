; ModuleID = 'undef_initializer.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128-n8:16:32"
target triple = "i386-apple-darwin9.0.0"

%0 = type { i16, [2 x i8], i8, [3 x i8] }
@v = global %0 { i16 1, [2 x i8] [i8 3, i8 4], i8 5, [3 x i8] undef }, align 4

%1 = type { i8, i16, i32, i32, i64, i32, i32, i16, i8, i8 }
@w = global %1 { i8 1, i16 2, i32 3, i32 4, i64 5, i32 6, i32 7, i16 8, i8 9, i8 undef }, align 4

%2 = type { i8, i16, i32, i32, i64, i32, i32, i16, i8 }


define i32 @main() nounwind {
bb:
  %0 = load i16* getelementptr inbounds (%2* bitcast (%1* @w to %2*), i32 0, i32 7), align 2
  %1 = sext i16 %0 to i32

  %2 = load i8* getelementptr inbounds (%0* @v, i32 0, i32 2), align 1
  %3 = sext i8 %2 to i32

  %4 = load i8* getelementptr inbounds (%0* @v, i32 0, i32 1, i32 0), align 1
  %5 = sext i8 %4 to i32

  %6 = sub nsw i32 %1, %3
  %7 = sub nsw i32 %6, %5
  ret i32 %7
}
