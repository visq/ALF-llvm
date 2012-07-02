; ModuleID = 'ins_insert_value'

@global = global { i8, { i8, i32 } } { i8 3, {i8,i32} { i8 7, i32 4 } }

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %p = getelementptr inbounds {i8,{i8,i32}}* @global, i32 0, i32 1
  %s = load {i8,i32}* %p
  %v  = insertvalue {i8,i32} %s, i32 7, 1
  %v2 = extractvalue {i8,i32} %v, 1
  %r = sub i32 %v2, 7
  ret i32 %r
}
