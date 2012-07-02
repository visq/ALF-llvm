; ModuleID = 'const_struct'

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %v = extractvalue {i8,i32} {i8 7, i32 4}, 1
  %r = sub i32 %v, 4
  ret i32 %r
}
