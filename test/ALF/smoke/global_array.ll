; ModuleID = 'global_array'

; <lli> @fmtstr = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
; <lli> declare i32 @printf(i8*, ...)

@global = global [2 x [3 x i32]] [ [3 x i32] [ i32 2, i32 3, i32 5 ], [3 x i32] [i32 7,i32 11,i32 13]]

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %p = getelementptr inbounds [2 x [3 x i32] ]* @global, i32 0, i32 1, i32 2 ; 13
  %s = load i32* %p
  %v = sub i32 %s, 13

; <lli> %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @fmtstr, i64 0, i64 0), i32 %v)

  ret i32 %v
}
