; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@out = global i32 1, align 4
@x = global i32 66, align 4

define void @fail() nounwind {
bb:
  br label %bb1, !dbg !22

bb1:                                              ; preds = %bb3, %bb
  %tmp = volatile load i32* @out, align 4, !dbg !22
  %tmp2 = icmp eq i32 %tmp, 0, !dbg !22
  br i1 %tmp2, label %bb4, label %bb3, !dbg !22

bb3:                                              ; preds = %bb1
  br label %bb1, !dbg !22

bb4:                                              ; preds = %bb1
  ret void, !dbg !24
}

define i32 @demo_value() nounwind {
bb:
  %tmp = load i32* @x, align 4, !dbg !25
  %tmp1 = mul nsw i32 %tmp, %tmp, !dbg !25
  %tmp2 = sub nsw i32 0, %tmp1, !dbg !25
  ret i32 %tmp2, !dbg !25
}

define signext i16 @zext(i8 signext %arg) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i8 %arg}, i64 0, metadata !27), !dbg !30
  %tmp = sext i8 %arg to i16, !dbg !31
  ret i16 %tmp, !dbg !31
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @zext32(i16 signext %arg) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !33), !dbg !34
  %tmp = sext i16 %arg to i32, !dbg !35
  ret i32 %tmp, !dbg !35
}

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !37), !dbg !38
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !39), !dbg !43
  %tmp = call i32 @demo_value(), !dbg !44
  call void @llvm.dbg.value(metadata !{i32 %tmp}, i64 0, metadata !46), !dbg !44
  %tmp1 = trunc i32 %tmp to i8, !dbg !47
  %tmp2 = call signext i16 @zext(i8 signext %tmp1), !dbg !47
  call void @llvm.dbg.value(metadata !8, i64 0, metadata !48), !dbg !47
  %tmp3 = trunc i32 %tmp to i16, !dbg !49
  %tmp4 = call i32 @zext32(i16 signext %tmp3), !dbg !49
  call void @llvm.dbg.value(metadata !{i32 %tmp4}, i64 0, metadata !50), !dbg !49
  %tmp5 = icmp eq i16 %tmp2, -4, !dbg !51
  br i1 %tmp5, label %bb6, label %bb8, !dbg !51

bb6:                                              ; preds = %bb
  %tmp7 = icmp eq i32 %tmp4, -4356, !dbg !51
  br i1 %tmp7, label %bb9, label %bb8, !dbg !51

bb8:                                              ; preds = %bb6, %bb
  call void @fail(), !dbg !51
  br label %bb9, !dbg !51

bb9:                                              ; preds = %bb8, %bb6
  ret i32 0, !dbg !52
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !5}
!llvm.dbg.sp = !{!6, !9, !13, !18, !19}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"out", metadata !"out", metadata !"", metadata !2, i32 1, metadata !3, i32 0, i32 1, i32* @out} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"sext.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"sext.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_volatile_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"x", metadata !"x", metadata !"", metadata !2, i32 7, metadata !4, i32 0, i32 1, i32* @x} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589870, i32 0, metadata !2, metadata !"fail", metadata !"fail", metadata !"", metadata !2, i32 2, metadata !7, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, void ()* @fail} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{null}
!9 = metadata !{i32 589870, i32 0, metadata !2, metadata !"demo_value", metadata !"demo_value", metadata !"", metadata !2, i32 8, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @demo_value} ; [ DW_TAG_subprogram ]
!10 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !11, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!11 = metadata !{metadata !12}
!12 = metadata !{i32 589846, metadata !1, metadata !"int32_t", metadata !2, i32 39, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_typedef ]
!13 = metadata !{i32 589870, i32 0, metadata !2, metadata !"zext", metadata !"zext", metadata !"", metadata !2, i32 11, metadata !14, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i16 (i8)* @zext} ; [ DW_TAG_subprogram ]
!14 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !15, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!15 = metadata !{metadata !16}
!16 = metadata !{i32 589846, metadata !1, metadata !"int16_t", metadata !2, i32 38, i64 0, i64 0, i64 0, i32 0, metadata !17} ; [ DW_TAG_typedef ]
!17 = metadata !{i32 589860, metadata !1, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!18 = metadata !{i32 589870, i32 0, metadata !2, metadata !"zext32", metadata !"zext32", metadata !"", metadata !2, i32 14, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i16)* @zext32} ; [ DW_TAG_subprogram ]
!19 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 17, metadata !20, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!20 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !21, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!21 = metadata !{metadata !4}
!22 = metadata !{i32 3, i32 5, metadata !23, null}
!23 = metadata !{i32 589835, metadata !6, i32 2, i32 13, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!24 = metadata !{i32 4, i32 1, metadata !23, null}
!25 = metadata !{i32 9, i32 5, metadata !26, null}
!26 = metadata !{i32 589835, metadata !9, i32 8, i32 22, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!27 = metadata !{i32 590081, metadata !13, metadata !"arg", metadata !2, i32 16777227, metadata !28, i32 0} ; [ DW_TAG_arg_variable ]
!28 = metadata !{i32 589846, metadata !1, metadata !"int8_t", metadata !2, i32 37, i64 0, i64 0, i64 0, i32 0, metadata !29} ; [ DW_TAG_typedef ]
!29 = metadata !{i32 589860, metadata !1, metadata !"signed char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!30 = metadata !{i32 11, i32 21, metadata !13, null}
!31 = metadata !{i32 12, i32 5, metadata !32, null}
!32 = metadata !{i32 589835, metadata !13, i32 11, i32 26, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!33 = metadata !{i32 590081, metadata !18, metadata !"arg", metadata !2, i32 16777230, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!34 = metadata !{i32 14, i32 24, metadata !18, null}
!35 = metadata !{i32 15, i32 5, metadata !36, null}
!36 = metadata !{i32 589835, metadata !18, i32 14, i32 29, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!37 = metadata !{i32 590081, metadata !19, metadata !"argc", metadata !2, i32 16777233, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!38 = metadata !{i32 17, i32 14, metadata !19, null}
!39 = metadata !{i32 590081, metadata !19, metadata !"argv", metadata !2, i32 33554449, metadata !40, i32 0} ; [ DW_TAG_arg_variable ]
!40 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !41} ; [ DW_TAG_pointer_type ]
!41 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !42} ; [ DW_TAG_pointer_type ]
!42 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!43 = metadata !{i32 17, i32 26, metadata !19, null}
!44 = metadata !{i32 18, i32 31, metadata !45, null}
!45 = metadata !{i32 589835, metadata !19, i32 17, i32 32, metadata !2, i32 4} ; [ DW_TAG_lexical_block ]
!46 = metadata !{i32 590080, metadata !45, metadata !"arg", metadata !2, i32 18, metadata !12, i32 0} ; [ DW_TAG_auto_variable ]
!47 = metadata !{i32 19, i32 35, metadata !45, null}
!48 = metadata !{i32 590080, metadata !45, metadata !"r", metadata !2, i32 19, metadata !12, i32 0} ; [ DW_TAG_auto_variable ]
!49 = metadata !{i32 20, i32 38, metadata !45, null}
!50 = metadata !{i32 590080, metadata !45, metadata !"s", metadata !2, i32 20, metadata !12, i32 0} ; [ DW_TAG_auto_variable ]
!51 = metadata !{i32 21, i32 5, metadata !45, null}
!52 = metadata !{i32 22, i32 5, metadata !45, null}
