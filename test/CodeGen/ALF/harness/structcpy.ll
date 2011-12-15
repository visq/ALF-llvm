; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%0 = type { i64, i32, i16, %1, [2 x i8] }
%1 = type { i16, i8, i8 }
%struct.anon = type { i16, i8 }
%struct.s = type { i64, i32, i16, %struct.anon }

@a = global %0 { i64 217020518514230019, i32 84215045, i16 1799, %1 { i16 2313, i8 17, i8 undef }, [2 x i8] undef }, align 4
@vol = global i16 2313, align 2

define %struct.s* @cpy(%struct.s* %dst, %struct.s* %src) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{%struct.s* %dst}, i64 0, metadata !34), !dbg !35
  call void @llvm.dbg.value(metadata !{%struct.s* %src}, i64 0, metadata !36), !dbg !37
  %tmp = bitcast %struct.s* %dst to i8*, !dbg !38
  %tmp1 = bitcast %struct.s* %src to i8*, !dbg !38
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %tmp, i8* %tmp1, i32 20, i32 4, i1 false), !dbg !38
  ret %struct.s* %dst, !dbg !40
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i32, i1) nounwind

define i64 @f(%struct.s* %s) nounwind {
bb:
  %tmp = alloca %struct.s, align 8
  call void @llvm.dbg.value(metadata !{%struct.s* %s}, i64 0, metadata !41), !dbg !42
  call void @llvm.dbg.declare(metadata !{%struct.s* %tmp}, metadata !43), !dbg !45
  %tmp1 = call %struct.s* @cpy(%struct.s* %s, %struct.s* %s), !dbg !46
  %tmp2 = bitcast %struct.s* %tmp to i8*, !dbg !46
  %tmp3 = bitcast %struct.s* %tmp1 to i8*, !dbg !46
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %tmp2, i8* %tmp3, i32 20, i32 4, i1 false), !dbg !46
  %tmp4 = volatile load i16* @vol, align 2, !dbg !47
  %tmp5 = and i16 %tmp4, 4095
  %tmp6 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 3, i32 0, !dbg !47
  store i16 %tmp5, i16* %tmp6, align 2, !dbg !47
  %tmp7 = volatile load i16* @vol, align 2, !dbg !48
  %tmp8 = trunc i16 %tmp7 to i8
  %tmp9 = and i8 %tmp8, 15
  %tmp10 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 3, i32 1, !dbg !48
  store i8 %tmp9, i8* %tmp10, align 2, !dbg !48
  %tmp11 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 3, i32 0, !dbg !49
  %tmp12 = load i16* %tmp11, align 2, !dbg !49
  %tmp13 = zext i8 %tmp9 to i16
  %tmp14 = add i16 %tmp12, %tmp13
  %tmp15 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 2, !dbg !49
  %tmp16 = load i16* %tmp15, align 4, !dbg !49
  %tmp17 = add i16 %tmp16, %tmp14
  store i16 %tmp17, i16* %tmp15, align 4, !dbg !49
  %tmp18 = zext i16 %tmp17 to i32, !dbg !50
  %tmp19 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 1, !dbg !50
  %tmp20 = load i32* %tmp19, align 8, !dbg !50
  %tmp21 = add i32 %tmp20, %tmp18, !dbg !50
  store i32 %tmp21, i32* %tmp19, align 8, !dbg !50
  %tmp22 = zext i32 %tmp21 to i64, !dbg !51
  %tmp23 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 0, !dbg !51
  %tmp24 = load i64* %tmp23, align 8, !dbg !51
  %tmp25 = add i64 %tmp24, %tmp22, !dbg !51
  store i64 %tmp25, i64* %tmp23, align 8, !dbg !51
  %tmp26 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 1, !dbg !52
  %tmp27 = load i32* %tmp26, align 8, !dbg !52
  %tmp28 = zext i32 %tmp27 to i64, !dbg !52
  %tmp29 = sub i64 %tmp25, %tmp28, !dbg !52
  %tmp30 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 2, !dbg !52
  %tmp31 = load i16* %tmp30, align 4, !dbg !52
  %tmp32 = zext i16 %tmp31 to i64, !dbg !52
  %tmp33 = add i64 %tmp29, %tmp32, !dbg !52
  %tmp34 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 3, i32 0, !dbg !52
  %tmp35 = load i16* %tmp34, align 2, !dbg !52
  %tmp36 = zext i16 %tmp35 to i64, !dbg !52
  %tmp37 = sub i64 %tmp33, %tmp36, !dbg !52
  ret i64 %tmp37, !dbg !52
}

define i32 @main() nounwind {
bb:
  %tmp = call i64 @f(%struct.s* bitcast (%0* @a to %struct.s*)), !dbg !53
  call void @llvm.dbg.value(metadata !{i64 %tmp}, i64 0, metadata !55), !dbg !53
  %tmp1 = lshr i64 %tmp, 32, !dbg !56
  %tmp2 = trunc i64 %tmp1 to i32, !dbg !56
  %tmp3 = trunc i64 %tmp to i32, !dbg !56
  %tmp4 = add i32 %tmp2, %tmp3, !dbg !56
  call void @llvm.dbg.value(metadata !{i32 %tmp4}, i64 0, metadata !57), !dbg !56
  %tmp5 = icmp ult i32 %tmp4, 101051648, !dbg !58
  br i1 %tmp5, label %bb6, label %bb7, !dbg !58

bb6:                                              ; preds = %bb
  br label %bb11, !dbg !58

bb7:                                              ; preds = %bb
  %tmp8 = icmp ugt i32 %tmp4, 101068073, !dbg !59
  br i1 %tmp8, label %bb9, label %bb10, !dbg !59

bb9:                                              ; preds = %bb7
  br label %bb11, !dbg !59

bb10:                                             ; preds = %bb7
  br label %bb11, !dbg !60

bb11:                                             ; preds = %bb10, %bb9, %bb6
  %.0 = phi i32 [ 1, %bb6 ], [ 1, %bb9 ], [ 0, %bb10 ]
  ret i32 %.0, !dbg !61
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !21}
!llvm.dbg.sp = !{!23, !27, !30}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"a", metadata !"a", metadata !"", metadata !2, i32 14, metadata !3, i32 0, i32 1, %0* @a} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"structcpy.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"structcpy.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589843, metadata !1, metadata !"s", metadata !2, i32 4, i64 160, i64 32, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!4 = metadata !{metadata !5, metadata !8, metadata !11, metadata !14}
!5 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 5, i64 64, i64 32, i64 0, i32 0, metadata !6} ; [ DW_TAG_member ]
!6 = metadata !{i32 589846, metadata !1, metadata !"uint64_t", metadata !2, i32 59, i64 0, i64 0, i64 0, i32 0, metadata !7} ; [ DW_TAG_typedef ]
!7 = metadata !{i32 589860, metadata !1, metadata !"long long unsigned int", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!8 = metadata !{i32 589837, metadata !2, metadata !"b", metadata !2, i32 6, i64 32, i64 32, i64 64, i32 0, metadata !9} ; [ DW_TAG_member ]
!9 = metadata !{i32 589846, metadata !1, metadata !"uint32_t", metadata !2, i32 52, i64 0, i64 0, i64 0, i32 0, metadata !10} ; [ DW_TAG_typedef ]
!10 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!11 = metadata !{i32 589837, metadata !2, metadata !"c", metadata !2, i32 7, i64 16, i64 16, i64 96, i32 0, metadata !12} ; [ DW_TAG_member ]
!12 = metadata !{i32 589846, metadata !1, metadata !"uint16_t", metadata !2, i32 50, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!13 = metadata !{i32 589860, metadata !1, metadata !"unsigned short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!14 = metadata !{i32 589837, metadata !2, metadata !"d", metadata !2, i32 11, i64 32, i64 16, i64 112, i32 0, metadata !15} ; [ DW_TAG_member ]
!15 = metadata !{i32 589843, metadata !3, metadata !"", metadata !2, i32 8, i64 32, i64 16, i32 0, i32 0, i32 0, metadata !16, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!16 = metadata !{metadata !17, metadata !18}
!17 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 9, i64 16, i64 16, i64 0, i32 0, metadata !12} ; [ DW_TAG_member ]
!18 = metadata !{i32 589837, metadata !2, metadata !"b", metadata !2, i32 10, i64 8, i64 8, i64 16, i32 0, metadata !19} ; [ DW_TAG_member ]
!19 = metadata !{i32 589846, metadata !1, metadata !"uint8_t", metadata !2, i32 49, i64 0, i64 0, i64 0, i32 0, metadata !20} ; [ DW_TAG_typedef ]
!20 = metadata !{i32 589860, metadata !1, metadata !"unsigned char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!21 = metadata !{i32 589876, i32 0, metadata !1, metadata !"vol", metadata !"vol", metadata !"", metadata !2, i32 15, metadata !22, i32 0, i32 1, i16* @vol} ; [ DW_TAG_variable ]
!22 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !12} ; [ DW_TAG_volatile_type ]
!23 = metadata !{i32 589870, i32 0, metadata !2, metadata !"cpy", metadata !"cpy", metadata !"", metadata !2, i32 17, metadata !24, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, %struct.s* (%struct.s*, %struct.s*)* @cpy} ; [ DW_TAG_subprogram ]
!24 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !25, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!25 = metadata !{metadata !26}
!26 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !3} ; [ DW_TAG_pointer_type ]
!27 = metadata !{i32 589870, i32 0, metadata !2, metadata !"f", metadata !"f", metadata !"", metadata !2, i32 22, metadata !28, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i64 (%struct.s*)* @f} ; [ DW_TAG_subprogram ]
!28 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !29, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!29 = metadata !{metadata !6}
!30 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 33, metadata !31, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!31 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !32, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!32 = metadata !{metadata !33}
!33 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!34 = metadata !{i32 590081, metadata !23, metadata !"dst", metadata !2, i32 16777233, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!35 = metadata !{i32 17, i32 25, metadata !23, null}
!36 = metadata !{i32 590081, metadata !23, metadata !"src", metadata !2, i32 33554449, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!37 = metadata !{i32 17, i32 40, metadata !23, null}
!38 = metadata !{i32 18, i32 3, metadata !39, null}
!39 = metadata !{i32 589835, metadata !23, i32 17, i32 45, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!40 = metadata !{i32 19, i32 3, metadata !39, null}
!41 = metadata !{i32 590081, metadata !27, metadata !"s", metadata !2, i32 16777238, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!42 = metadata !{i32 22, i32 22, metadata !27, null}
!43 = metadata !{i32 590080, metadata !44, metadata !"tmp", metadata !2, i32 24, metadata !3, i32 0} ; [ DW_TAG_auto_variable ]
!44 = metadata !{i32 589835, metadata !27, i32 22, i32 25, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!45 = metadata !{i32 24, i32 12, metadata !44, null}
!46 = metadata !{i32 24, i32 27, metadata !44, null}
!47 = metadata !{i32 25, i32 3, metadata !44, null}
!48 = metadata !{i32 26, i32 3, metadata !44, null}
!49 = metadata !{i32 27, i32 3, metadata !44, null}
!50 = metadata !{i32 28, i32 3, metadata !44, null}
!51 = metadata !{i32 29, i32 3, metadata !44, null}
!52 = metadata !{i32 30, i32 3, metadata !44, null}
!53 = metadata !{i32 34, i32 23, metadata !54, null}
!54 = metadata !{i32 589835, metadata !30, i32 33, i32 11, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!55 = metadata !{i32 590080, metadata !54, metadata !"r64", metadata !2, i32 34, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!56 = metadata !{i32 35, i32 55, metadata !54, null}
!57 = metadata !{i32 590080, metadata !54, metadata !"r32", metadata !2, i32 35, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!58 = metadata !{i32 39, i32 3, metadata !54, null}
!59 = metadata !{i32 40, i32 3, metadata !54, null}
!60 = metadata !{i32 41, i32 3, metadata !54, null}
!61 = metadata !{i32 42, i32 1, metadata !54, null}
