; ModuleID = 'ins_srem'
; <lli> @fmtstr = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
; <lli> declare i32 @printf(i8*, ...)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %v1 = sub i32 %argc, 9        ; (-8)
  %v2 = sdiv i32 %v1, -3        ; (-8) `sdiv` -3  =  2
  %v3 = sdiv i32 %v1,  3        ; (-8) `sdiv` 3   = -2
  %v  = add i32 %v2, %v3        ; 0
; <lli> %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @fmtstr, i64 0, i64 0), i32 %v)
  ret i32 %v
}
