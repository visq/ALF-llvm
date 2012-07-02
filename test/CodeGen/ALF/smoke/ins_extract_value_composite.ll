; ModuleID = 'ins_extract_value_composite'

@global = global { i8, { i8, i32 } } { i8 3, {i8,i32} { i8 7, i32 4 } }

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %p  = load {i8,{i8,i32}}* @global
  %vs = extractvalue {i8,{i8,i32}} %p, 1
  %v  = extractvalue {i8,i32} %vs, 1
  %r = sub i32 %v, 4
  ret i32 %r
}
