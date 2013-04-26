; ModuleID = '<stdin>'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Value = type { i32, %union.TIFF_value }
%union.TIFF_value = type { i8* }

@main.chararray = private unnamed_addr constant [2 x i8] c"cd", align 1

define zeroext i8 @load_char(%struct.Value* %v) nounwind uwtable noinline {
bb:
  %tmp = getelementptr inbounds %struct.Value* %v, i64 0, i32 0
  %tmp1 = load i32* %tmp, align 4
  switch i32 %tmp1, label %bb6 [
    i32 0, label %bb2
  ]

bb2:                                              ; preds = %bb
  %tmp3 = getelementptr inbounds %struct.Value* %v, i64 0, i32 1
  %tmp4 = bitcast %union.TIFF_value* %tmp3 to i8*
  %tmp5 = load i8* %tmp4, align 1
  br label %bb7

bb6:                                              ; preds = %bb
  br label %bb7

bb7:                                              ; preds = %bb6, %bb2
  %.0 = phi i8 [ 0, %bb6 ], [ %tmp5, %bb2 ]
  ret i8 %.0
}

define i8* @load_char_array(%struct.Value* %v) nounwind uwtable {
bb:
  %tmp = getelementptr inbounds %struct.Value* %v, i64 0, i32 0
  %tmp1 = load i32* %tmp, align 4
  switch i32 %tmp1, label %bb5 [
    i32 4, label %bb2
  ]

bb2:                                              ; preds = %bb
  %tmp3 = getelementptr inbounds %struct.Value* %v, i64 0, i32 1, i32 0
  %tmp4 = load i8** %tmp3, align 8
  br label %bb6

bb5:                                              ; preds = %bb
  br label %bb6

bb6:                                              ; preds = %bb5, %bb2
  %.0 = phi i8* [ null, %bb5 ], [ %tmp4, %bb2 ]
  ret i8* %.0
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
  %chararray = alloca i16, align 2
  %tv = alloca %union.TIFF_value, align 8
  %v = alloca %struct.Value, align 8
  store i16 25699, i16* %chararray, align 2
  %tmp = bitcast %union.TIFF_value* %tv to i8*
  store i8 99, i8* %tmp, align 8
  %tmp1 = getelementptr %union.TIFF_value* %tv, i64 0, i32 0
  %tmp2 = load i8** %tmp1, align 8
  call void @store(%struct.Value* %v, i32 0, i8* %tmp2)
  %tmp3 = call zeroext i8 @load_char(%struct.Value* %v)
  %tmp4 = icmp eq i8 %tmp3, 99
  br i1 %tmp4, label %bb6, label %bb5

bb5:                                              ; preds = %bb
  br label %bb15

bb6:                                              ; preds = %bb
  %tmp7 = bitcast i16* %chararray to i8*
  %tmp8 = getelementptr inbounds %union.TIFF_value* %tv, i64 0, i32 0
  store i8* %tmp7, i8** %tmp8, align 8
  call void @store(%struct.Value* %v, i32 4, i8* %tmp7)
  %tmp9 = call i8* @load_char_array(%struct.Value* %v)
  %tmp10 = getelementptr inbounds i8* %tmp9, i64 1
  %tmp11 = load i8* %tmp10, align 1
  %tmp12 = icmp eq i8 %tmp11, 100
  br i1 %tmp12, label %bb14, label %bb13

bb13:                                             ; preds = %bb6
  br label %bb15

bb14:                                             ; preds = %bb6
  br label %bb15

bb15:                                             ; preds = %bb14, %bb13, %bb5
  %.0 = phi i32 [ 1, %bb5 ], [ 1, %bb13 ], [ 0, %bb14 ]
  ret i32 %.0
}
