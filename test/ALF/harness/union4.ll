; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Rational = type { i32, i32 }
%struct.Value = type { i32, %union.TIFF_value }
%union.TIFF_value = type { i8* }

@main.ratarray = private unnamed_addr constant [2 x %struct.Rational] [%struct.Rational { i32 99, i32 100 }, %struct.Rational { i32 101, i32 102 }], align 16

define i32* @load_long_array(%struct.Value* %v) nounwind uwtable noinline {
bb:
  %tmp = getelementptr inbounds %struct.Value* %v, i64 0, i32 0
  %tmp1 = load i32* %tmp, align 4
  switch i32 %tmp1, label %bb6 [
    i32 6, label %bb2
  ]

bb2:                                              ; preds = %bb
  %tmp3 = getelementptr inbounds %struct.Value* %v, i64 0, i32 1
  %tmp4 = bitcast %union.TIFF_value* %tmp3 to i32**
  %tmp5 = load i32** %tmp4, align 8
  br label %bb7

bb6:                                              ; preds = %bb
  br label %bb7

bb7:                                              ; preds = %bb6, %bb2
  %.0 = phi i32* [ null, %bb6 ], [ %tmp5, %bb2 ]
  ret i32* %.0
}

define void @store(%struct.Value* %v, i32 %tag, i8* %value.coerce) nounwind uwtable noinline {
bb:
  %value = alloca %union.TIFF_value, align 8
  %tmp = getelementptr %union.TIFF_value* %value, i64 0, i32 0
  store i8* %value.coerce, i8** %tmp, align 8
  %tmp1 = getelementptr inbounds %struct.Value* %v, i64 0, i32 0
  store i32 %tag, i32* %tmp1, align 4
  %tmp2 = getelementptr inbounds %union.TIFF_value* %value, i64 0, i32 0
  %tmp3 = load i8** %tmp2, align 8
  %tmp4 = getelementptr inbounds %struct.Value* %v, i64 0, i32 1, i32 0
  store i8* %tmp3, i8** %tmp4, align 8
  ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i32, i1) nounwind

define i32 @main(i32 %argc, i8** %argv) nounwind uwtable {
bb:
  %ratarray = alloca [2 x %struct.Rational], align 16
  %v = alloca %struct.Value, align 8
  %tmp = bitcast [2 x %struct.Rational]* %ratarray to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %tmp, i8* bitcast ([2 x %struct.Rational]* @main.ratarray to i8*), i64 16, i32 16, i1 false)
  %.c = bitcast [2 x %struct.Rational]* %ratarray to i8*
  call void @store(%struct.Value* %v, i32 7, i8* %.c)
  %tmp1 = getelementptr inbounds %struct.Value* %v, i64 0, i32 0
  store i32 6, i32* %tmp1, align 8
  %tmp2 = call i32* @load_long_array(%struct.Value* %v)
  %tmp3 = load i32* %tmp2, align 4
  %tmp4 = icmp eq i32 %tmp3, 99
  br i1 %tmp4, label %bb6, label %bb5

bb5:                                              ; preds = %bb
  br label %bb7

bb6:                                              ; preds = %bb
  br label %bb7

bb7:                                              ; preds = %bb6, %bb5
  %.0 = phi i32 [ 1, %bb5 ], [ 0, %bb6 ]
  ret i32 %.0
}
