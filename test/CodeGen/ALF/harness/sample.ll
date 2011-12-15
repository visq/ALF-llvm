; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%0 = type { i8, i16, i32, i32, i8, [3 x i8], %1, i8, [3 x i8] }
%1 = type { i8, [3 x i8] }
%struct.comp_t = type { i8, i16, i32, i32, i8, %union.anon, i8 }
%union.anon = type { i32 }

@input = global i32 2, align 4
@seeds = constant [3 x i64] [i64 17, i64 23, i64 64], align 4
@oseeds = global [3 x i64] zeroinitializer, align 4
@mdim_array = constant [2 x [2 x i64]] [[2 x i64] [i64 0, i64 1], [2 x i64] [i64 1, i64 0]], align 4
@my_struct = internal global %0 { i8 0, i16 0, i32 0, i32 0, i8 0, [3 x i8] undef, %1 { i8 3, [3 x i8] undef }, i8 4, [3 x i8] undef }, align 4
@fcalls = internal global i32 0, align 4

define i64 @f(i64 %x, i32 %y) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i64 %x}, i64 0, metadata !43), !dbg !44
  call void @llvm.dbg.value(metadata !{i32 %y}, i64 0, metadata !45), !dbg !47
  call void @llvm.dbg.value(metadata !48, i64 0, metadata !49), !dbg !51
  br label %bb1, !dbg !52

bb1:                                              ; preds = %bb2, %bb
  %.0 = phi i32 [ %y, %bb ], [ %tmp4, %bb2 ]
  %r.0 = phi i64 [ 1, %bb ], [ %tmp3, %bb2 ]
  %tmp = icmp eq i32 %.0, 0, !dbg !52
  br i1 %tmp, label %bb5, label %bb2, !dbg !52

bb2:                                              ; preds = %bb1
  %tmp3 = mul nsw i64 %r.0, %x, !dbg !53
  call void @llvm.dbg.value(metadata !{i64 %tmp3}, i64 0, metadata !49), !dbg !53
  %tmp4 = add i32 %.0, -1, !dbg !55
  call void @llvm.dbg.value(metadata !{i32 %tmp4}, i64 0, metadata !45), !dbg !55
  br label %bb1, !dbg !56

bb5:                                              ; preds = %bb1
  %tmp6 = load i32* @fcalls, align 4, !dbg !57
  %tmp7 = add nsw i32 %tmp6, 1, !dbg !57
  store i32 %tmp7, i32* @fcalls, align 4, !dbg !57
  %tmp8 = load i8* getelementptr inbounds (%0* @my_struct, i32 0, i32 7), align 4, !dbg !58
  %tmp9 = add i8 %tmp8, 1, !dbg !58
  store i8 %tmp9, i8* getelementptr inbounds (%0* @my_struct, i32 0, i32 7), align 4, !dbg !58
  ret i64 %r.0, !dbg !59
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !60), !dbg !61
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !62), !dbg !65
  call void @llvm.dbg.value(metadata !66, i64 0, metadata !67), !dbg !69
  br label %bb1, !dbg !69

bb1:                                              ; preds = %bb9, %bb
  %i.0 = phi i32 [ 0, %bb ], [ %tmp10, %bb9 ]
  %tmp = icmp slt i32 %i.0, 3, !dbg !69
  br i1 %tmp, label %bb2, label %bb11, !dbg !69

bb2:                                              ; preds = %bb1
  %tmp3 = getelementptr inbounds [3 x i64]* @seeds, i32 0, i32 %i.0, !dbg !70
  %tmp4 = load i64* %tmp3, align 4, !dbg !70
  %tmp5 = volatile load i32* @input, align 4, !dbg !70
  %tmp6 = sext i32 %tmp5 to i64, !dbg !70
  %tmp7 = mul nsw i64 %tmp4, %tmp6, !dbg !70
  %tmp8 = getelementptr inbounds [3 x i64]* @oseeds, i32 0, i32 %i.0, !dbg !70
  store i64 %tmp7, i64* %tmp8, align 4, !dbg !70
  br label %bb9, !dbg !73

bb9:                                              ; preds = %bb2
  %tmp10 = add nsw i32 %i.0, 1, !dbg !74
  call void @llvm.dbg.value(metadata !{i32 %tmp10}, i64 0, metadata !67), !dbg !74
  br label %bb1, !dbg !74

bb11:                                             ; preds = %bb1
  %tmp12 = volatile load i32* @input, align 4, !dbg !75
  %tmp13 = sext i32 %tmp12 to i64, !dbg !75
  %tmp14 = load i64* getelementptr inbounds ([3 x i64]* @oseeds, i32 0, i32 1), align 4, !dbg !75
  %tmp15 = lshr i64 %tmp14, 8
  %tmp16 = trunc i64 %tmp15 to i32, !dbg !75
  %tmp17 = call i64 @f(i64 %tmp13, i32 %tmp16), !dbg !75
  %tmp18 = icmp eq i64 %tmp17, 1, !dbg !75
  br i1 %tmp18, label %bb20, label %bb19, !dbg !75

bb19:                                             ; preds = %bb11
  br label %bb21, !dbg !75

bb20:                                             ; preds = %bb11
  br label %bb21, !dbg !76

bb21:                                             ; preds = %bb20, %bb19
  %.0 = phi i32 [ 1, %bb19 ], [ 0, %bb20 ]
  ret i32 %.0, !dbg !77
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !5, !12, !14, !18, !36}
!llvm.dbg.sp = !{!37, !40}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"input", metadata !"input", metadata !"", metadata !2, i32 18, metadata !3, i32 0, i32 1, i32* @input} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"sample.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"sample.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_volatile_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"seeds", metadata !"seeds", metadata !"", metadata !2, i32 19, metadata !6, i32 0, i32 1, [3 x i64]* @seeds} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 192, i64 32, i32 0, i32 0, metadata !7, metadata !10, i32 0, i32 0} ; [ DW_TAG_array_type ]
!7 = metadata !{i32 589862, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !8} ; [ DW_TAG_const_type ]
!8 = metadata !{i32 589846, metadata !1, metadata !"int64_t", metadata !2, i32 44, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!9 = metadata !{i32 589860, metadata !1, metadata !"long long int", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{metadata !11}
!11 = metadata !{i32 589857, i64 0, i64 2}        ; [ DW_TAG_subrange_type ]
!12 = metadata !{i32 589876, i32 0, metadata !1, metadata !"oseeds", metadata !"oseeds", metadata !"", metadata !2, i32 20, metadata !13, i32 0, i32 1, [3 x i64]* @oseeds} ; [ DW_TAG_variable ]
!13 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 192, i64 32, i32 0, i32 0, metadata !8, metadata !10, i32 0, i32 0} ; [ DW_TAG_array_type ]
!14 = metadata !{i32 589876, i32 0, metadata !1, metadata !"mdim_array", metadata !"mdim_array", metadata !"", metadata !2, i32 21, metadata !15, i32 0, i32 1, [2 x [2 x i64]]* @mdim_array} ; [ DW_TAG_variable ]
!15 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 256, i64 32, i32 0, i32 0, metadata !7, metadata !16, i32 0, i32 0} ; [ DW_TAG_array_type ]
!16 = metadata !{metadata !17, metadata !17}
!17 = metadata !{i32 589857, i64 0, i64 1}        ; [ DW_TAG_subrange_type ]
!18 = metadata !{i32 589876, i32 0, metadata !1, metadata !"my_struct", metadata !"my_struct", metadata !"", metadata !2, i32 24, metadata !19, i32 1, i32 1, %0* @my_struct} ; [ DW_TAG_variable ]
!19 = metadata !{i32 589846, metadata !1, metadata !"comp_t", metadata !2, i32 15, i64 0, i64 0, i64 0, i32 0, metadata !20} ; [ DW_TAG_typedef ]
!20 = metadata !{i32 589843, metadata !1, metadata !"", metadata !2, i32 4, i64 192, i64 32, i32 0, i32 0, i32 0, metadata !21, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!21 = metadata !{metadata !22, metadata !24, metadata !26, metadata !27, metadata !29, metadata !30, metadata !35}
!22 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 5, i64 8, i64 8, i64 0, i32 0, metadata !23} ; [ DW_TAG_member ]
!23 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!24 = metadata !{i32 589837, metadata !2, metadata !"b", metadata !2, i32 6, i64 16, i64 16, i64 16, i32 0, metadata !25} ; [ DW_TAG_member ]
!25 = metadata !{i32 589860, metadata !1, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!26 = metadata !{i32 589837, metadata !2, metadata !"c", metadata !2, i32 7, i64 32, i64 32, i64 32, i32 0, metadata !4} ; [ DW_TAG_member ]
!27 = metadata !{i32 589837, metadata !2, metadata !"d", metadata !2, i32 8, i64 32, i64 32, i64 64, i32 0, metadata !28} ; [ DW_TAG_member ]
!28 = metadata !{i32 589860, metadata !1, metadata !"long int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!29 = metadata !{i32 589837, metadata !2, metadata !"e", metadata !2, i32 9, i64 8, i64 8, i64 96, i32 0, metadata !23} ; [ DW_TAG_member ]
!30 = metadata !{i32 589837, metadata !2, metadata !"f", metadata !2, i32 13, i64 32, i64 32, i64 128, i32 0, metadata !31} ; [ DW_TAG_member ]
!31 = metadata !{i32 589847, metadata !20, metadata !"", metadata !2, i32 10, i64 32, i64 32, i64 0, i32 0, i32 0, metadata !32, i32 0, i32 0} ; [ DW_TAG_union_type ]
!32 = metadata !{metadata !33, metadata !34}
!33 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 11, i64 8, i64 8, i64 0, i32 0, metadata !23} ; [ DW_TAG_member ]
!34 = metadata !{i32 589837, metadata !2, metadata !"c", metadata !2, i32 12, i64 32, i64 32, i64 0, i32 0, metadata !4} ; [ DW_TAG_member ]
!35 = metadata !{i32 589837, metadata !2, metadata !"g", metadata !2, i32 14, i64 8, i64 8, i64 160, i32 0, metadata !23} ; [ DW_TAG_member ]
!36 = metadata !{i32 589876, i32 0, metadata !1, metadata !"fcalls", metadata !"fcalls", metadata !"", metadata !2, i32 23, metadata !4, i32 1, i32 1, i32* @fcalls} ; [ DW_TAG_variable ]
!37 = metadata !{i32 589870, i32 0, metadata !2, metadata !"f", metadata !"f", metadata !"", metadata !2, i32 26, metadata !38, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i64 (i64, i32)* @f} ; [ DW_TAG_subprogram ]
!38 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !39, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!39 = metadata !{metadata !8}
!40 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 36, metadata !41, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!41 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !42, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!42 = metadata !{metadata !4}
!43 = metadata !{i32 590081, metadata !37, metadata !"x", metadata !2, i32 16777242, metadata !8, i32 0} ; [ DW_TAG_arg_variable ]
!44 = metadata !{i32 26, i32 20, metadata !37, null}
!45 = metadata !{i32 590081, metadata !37, metadata !"y", metadata !2, i32 33554458, metadata !46, i32 0} ; [ DW_TAG_arg_variable ]
!46 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!47 = metadata !{i32 26, i32 31, metadata !37, null}
!48 = metadata !{i64 1}
!49 = metadata !{i32 590080, metadata !50, metadata !"r", metadata !2, i32 27, metadata !8, i32 0} ; [ DW_TAG_auto_variable ]
!50 = metadata !{i32 589835, metadata !37, i32 26, i32 34, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!51 = metadata !{i32 27, i32 18, metadata !50, null}
!52 = metadata !{i32 28, i32 5, metadata !50, null}
!53 = metadata !{i32 29, i32 9, metadata !54, null}
!54 = metadata !{i32 589835, metadata !50, i32 28, i32 18, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!55 = metadata !{i32 30, i32 9, metadata !54, null}
!56 = metadata !{i32 31, i32 5, metadata !54, null}
!57 = metadata !{i32 32, i32 5, metadata !50, null}
!58 = metadata !{i32 33, i32 5, metadata !50, null}
!59 = metadata !{i32 34, i32 5, metadata !50, null}
!60 = metadata !{i32 590081, metadata !40, metadata !"argc", metadata !2, i32 16777252, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!61 = metadata !{i32 36, i32 14, metadata !40, null}
!62 = metadata !{i32 590081, metadata !40, metadata !"argv", metadata !2, i32 33554468, metadata !63, i32 0} ; [ DW_TAG_arg_variable ]
!63 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !64} ; [ DW_TAG_pointer_type ]
!64 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !23} ; [ DW_TAG_pointer_type ]
!65 = metadata !{i32 36, i32 27, metadata !40, null}
!66 = metadata !{i32 0}
!67 = metadata !{i32 590080, metadata !68, metadata !"i", metadata !2, i32 37, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!68 = metadata !{i32 589835, metadata !40, i32 36, i32 33, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!69 = metadata !{i32 38, i32 5, metadata !68, null}
!70 = metadata !{i32 39, i32 9, metadata !71, null}
!71 = metadata !{i32 589835, metadata !72, i32 38, i32 28, metadata !2, i32 4} ; [ DW_TAG_lexical_block ]
!72 = metadata !{i32 589835, metadata !68, i32 38, i32 5, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!73 = metadata !{i32 40, i32 5, metadata !71, null}
!74 = metadata !{i32 38, i32 23, metadata !72, null}
!75 = metadata !{i32 41, i32 5, metadata !68, null}
!76 = metadata !{i32 42, i32 5, metadata !68, null}
!77 = metadata !{i32 43, i32 1, metadata !68, null}
