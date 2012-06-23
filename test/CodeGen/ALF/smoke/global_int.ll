; ModuleID = 'global_int'
@global = global i32 0

define i32 @main() nounwind {
entry:
  %tmp = load i32* @global
  ret i32 %tmp
}
