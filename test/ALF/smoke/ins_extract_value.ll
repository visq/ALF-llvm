; ModuleID = 'ins_extract_value'

@global = global { i8, { i8, i32 } } { i8 3, {i8,i32} { i8 7, i32 4 } }

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %p = getelementptr inbounds {i8,{i8,i32}}* @global, i32 0, i32 1
  %s = load {i8,i32}* %p
  %v = extractvalue {i8,i32} %s, 1
  %r = sub i32 %v, 4
  ret i32 %r
}
