; ModuleID = 'ins_insert_value_composite'

@global = global { i8, { i8, i32 } } { i8 3, {i8,i32} { i8 7, i32 4 } }

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %s    = load {i8,{i8,i32}}* @global
  %sub  = extractvalue {i8,{i8,i32}} %s, 1
  %sub2 = insertvalue {i8,i32} %sub, i32 7, 1
  %s2   = insertvalue {i8,{i8,i32}} %s, {i8,i32} %sub2, 1
  %v    = extractvalue {i8,{i8,i32}} %s2, 1, 1
  %r = sub i32 %v, 7
  ret i32 %r
}
