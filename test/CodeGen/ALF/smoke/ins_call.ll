; ModuleID = 'call'
; simplest possible call

define i32 @f() {
entry:
  ret i32 42
}

define i32 @main() {
entry:
  %call = call i32 @f()
  ret i32 %call
}
