; ModuleID = 'ins_sub'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %cmp = icmp eq i32 %argc, 1
  %v = select i1 %cmp, i32 0, i32 1
  ret i32 %v
}
