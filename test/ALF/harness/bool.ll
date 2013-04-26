; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"
target triple = "armv4t-elf-linux"

%struct.IMMENSE = type { i32, i32 }

@bit = common global [33 x i32] zeroinitializer, align 4
@arg = common global [2 x i32] zeroinitializer, align 4

define i32 @main() {
       %arg = load [2 x i32]* @arg, align 4
       %r = call i32 @getbit([2 x i32] %arg, i32 0, i32 0)
       ret i32 %r
}

define i32 @getbit([2 x i32] %source.coerce0, i32 %bitno, i32 %nbits) nounwind {
entry:
  %source = alloca %struct.IMMENSE, align 4
  %0 = bitcast %struct.IMMENSE* %source to { [2 x i32] }*
  %1 = getelementptr { [2 x i32] }* %0, i32 0, i32 0
  store [2 x i32] %source.coerce0, [2 x i32]* %1
  %r = getelementptr inbounds %struct.IMMENSE* %source, i32 0, i32 1

  %bitno.addr = alloca i32, align 4
  store i32 %bitno, i32* %bitno.addr, align 4
  %2 = load i32* %bitno.addr, align 4
  %arrayidx = getelementptr inbounds [33 x i32]* @bit, i32 0, i32 %2

  %3 = load i32* %arrayidx, align 4
  %4 = load i32* %r, align 4
  %and = and i32 %3, %4
  %tobool = icmp ne i32 %and, 0
  %cond = select i1 %tobool, i32 1, i32 0
  ret i32 0
}
