; ModuleID = 'ins_store_composite'

@global  = global { i8, {i32, i8}} zeroinitializer
@global2 = global {i32,i8} {i32 7, i8 4 }

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %v = load {i32,i8}* @global2
  %p = getelementptr inbounds {i8,{i32,i8}}* @global, i32 0, i32 1
  store {i32,i8} %v, {i32,i8}* %p
  %p2 =getelementptr inbounds {i32,i8}* %p, i32 0, i32 0
  %tmp = load i32* %p2
  %r = sub i32 %tmp, 7
  ret i32 %r
}
