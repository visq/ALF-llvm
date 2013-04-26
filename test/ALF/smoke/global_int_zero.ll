; ModuleID = 'global_int_zero'
@global = global i32 zeroinitializer

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %tmp = load i32* @global
  ret i32 %tmp
}
