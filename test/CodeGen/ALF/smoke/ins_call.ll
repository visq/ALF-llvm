; ModuleID = 'call'
; simplest possible call

define i32 @f() {
entry:
  ret i32 0
}

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %call = call i32 @f()
  ret i32 %call
}
