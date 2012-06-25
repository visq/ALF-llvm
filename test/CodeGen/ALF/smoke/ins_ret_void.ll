; ModuleID = 'ins_ret_void'

@g = global i32 1

define void @f() {
entry:
  store i32 0, i32* @g
  ret void
}

define i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @f()
  %tmp = load i32* @g
  ret i32 %tmp
}
