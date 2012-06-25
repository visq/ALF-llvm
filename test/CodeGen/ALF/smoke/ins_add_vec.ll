; ModuleID = 'ins_add'

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %v = add <4 x i32> <%argc,%argc,%argc,%argc> <-2,-1,0,1>
  ret <4 x i32> %v
}
