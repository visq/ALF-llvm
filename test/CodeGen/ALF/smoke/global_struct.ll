; ModuleID = 'const struct'

; <lli> @fmtstr = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
; <lli> declare i32 @printf(i8*, ...)

@global = global { i8, i32 } { i8 7, i32 4 }

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %p = getelementptr inbounds {i8,i32}* @global, i32 0, i32 1
  %s = load i32* %p
  %v = sub i32 %s, 4

; <lli> %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @fmtstr, i64 0, i64 0), i32 %v)

  ret i32 %v
}
