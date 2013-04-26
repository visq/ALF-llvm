; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@out = global i32 0, align 4
@x = global i32 254, align 4

define void @fail() nounwind {
bb:
  br label %bb1, !dbg !23

bb1:                                              ; preds = %bb3, %bb
  %tmp = load volatile i32* @out, align 4, !dbg !23
  %tmp2 = icmp eq i32 %tmp, 0, !dbg !23
  br i1 %tmp2, label %bb4, label %bb3, !dbg !23

bb3:                                              ; preds = %bb1
  br label %bb1, !dbg !23

bb4:                                              ; preds = %bb1
  ret void, !dbg !25
}

define i32 @demo_value() nounwind {
bb:
  %tmp = load i32* @x, align 4, !dbg !26
  %tmp1 = mul nsw i32 %tmp, %tmp, !dbg !26
  ret i32 %tmp1, !dbg !26
}

define zeroext i16 @zext(i8 zeroext %arg) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i8 %arg}, i64 0, metadata !28), !dbg !31
  %tmp = zext i8 %arg to i16, !dbg !32
  ret i16 %tmp, !dbg !32
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @zext32(i16 zeroext %arg) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !34), !dbg !35
  %tmp = zext i16 %arg to i32, !dbg !36
  ret i32 %tmp, !dbg !36
}

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !38), !dbg !39
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !40), !dbg !44
  %tmp = call i32 @demo_value(), !dbg !45
  call void @llvm.dbg.value(metadata !{i32 %tmp}, i64 0, metadata !47), !dbg !45
  %tmp1 = trunc i32 %tmp to i8, !dbg !48
  %tmp2 = call zeroext i16 @zext(i8 zeroext %tmp1), !dbg !48
  call void @llvm.dbg.value(metadata !8, i64 0, metadata !49), !dbg !48
  %tmp3 = trunc i32 %tmp to i16, !dbg !50
  %tmp4 = call i32 @zext32(i16 zeroext %tmp3), !dbg !50
  call void @llvm.dbg.value(metadata !{i32 %tmp4}, i64 0, metadata !51), !dbg !50
  %tmp5 = icmp eq i16 %tmp2, 4, !dbg !52
  br i1 %tmp5, label %bb6, label %bb8, !dbg !52

bb6:                                              ; preds = %bb
  %tmp7 = icmp eq i32 %tmp4, 64516, !dbg !52
  br i1 %tmp7, label %bb9, label %bb8, !dbg !52

bb8:                                              ; preds = %bb6, %bb
  call void @fail(), !dbg !52
  br label %bb9, !dbg !52

bb9:                                              ; preds = %bb8, %bb6
  ret i32 0, !dbg !53
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !5}
!llvm.dbg.sp = !{!6, !9, !14, !19, !20}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"out", metadata !"out", metadata !"", metadata !2, i32 1, metadata !3, i32 0, i32 1, i32* @out} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"zext.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"zext.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_volatile_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"x", metadata !"x", metadata !"", metadata !2, i32 7, metadata !4, i32 0, i32 1, i32* @x} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589870, i32 0, metadata !2, metadata !"fail", metadata !"fail", metadata !"", metadata !2, i32 2, metadata !7, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, void ()* @fail} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{null}
!9 = metadata !{i32 589870, i32 0, metadata !2, metadata !"demo_value", metadata !"demo_value", metadata !"", metadata !2, i32 8, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @demo_value} ; [ DW_TAG_subprogram ]
!10 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !11, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!11 = metadata !{metadata !12}
!12 = metadata !{i32 589846, metadata !1, metadata !"uint32_t", metadata !2, i32 52, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!13 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!14 = metadata !{i32 589870, i32 0, metadata !2, metadata !"zext", metadata !"zext", metadata !"", metadata !2, i32 11, metadata !15, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i16 (i8)* @zext} ; [ DW_TAG_subprogram ]
!15 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !16, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!16 = metadata !{metadata !17}
!17 = metadata !{i32 589846, metadata !1, metadata !"uint16_t", metadata !2, i32 50, i64 0, i64 0, i64 0, i32 0, metadata !18} ; [ DW_TAG_typedef ]
!18 = metadata !{i32 589860, metadata !1, metadata !"unsigned short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!19 = metadata !{i32 589870, i32 0, metadata !2, metadata !"zext32", metadata !"zext32", metadata !"", metadata !2, i32 14, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i16)* @zext32} ; [ DW_TAG_subprogram ]
!20 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 17, metadata !21, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!21 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !22, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!22 = metadata !{metadata !4}
!23 = metadata !{i32 3, i32 5, metadata !24, null}
!24 = metadata !{i32 589835, metadata !6, i32 2, i32 13, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!25 = metadata !{i32 4, i32 1, metadata !24, null}
!26 = metadata !{i32 9, i32 5, metadata !27, null}
!27 = metadata !{i32 589835, metadata !9, i32 8, i32 23, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!28 = metadata !{i32 590081, metadata !14, metadata !"arg", metadata !2, i32 16777227, metadata !29, i32 0} ; [ DW_TAG_arg_variable ]
!29 = metadata !{i32 589846, metadata !1, metadata !"uint8_t", metadata !2, i32 49, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!30 = metadata !{i32 589860, metadata !1, metadata !"unsigned char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!31 = metadata !{i32 11, i32 23, metadata !14, null}
!32 = metadata !{i32 12, i32 5, metadata !33, null}
!33 = metadata !{i32 589835, metadata !14, i32 11, i32 28, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 590081, metadata !19, metadata !"arg", metadata !2, i32 16777230, metadata !17, i32 0} ; [ DW_TAG_arg_variable ]
!35 = metadata !{i32 14, i32 26, metadata !19, null}
!36 = metadata !{i32 15, i32 5, metadata !37, null}
!37 = metadata !{i32 589835, metadata !19, i32 14, i32 31, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!38 = metadata !{i32 590081, metadata !20, metadata !"argc", metadata !2, i32 16777233, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!39 = metadata !{i32 17, i32 14, metadata !20, null}
!40 = metadata !{i32 590081, metadata !20, metadata !"argv", metadata !2, i32 33554449, metadata !41, i32 0} ; [ DW_TAG_arg_variable ]
!41 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !42} ; [ DW_TAG_pointer_type ]
!42 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !43} ; [ DW_TAG_pointer_type ]
!43 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!44 = metadata !{i32 17, i32 26, metadata !20, null}
!45 = metadata !{i32 18, i32 32, metadata !46, null}
!46 = metadata !{i32 589835, metadata !20, i32 17, i32 32, metadata !2, i32 4} ; [ DW_TAG_lexical_block ]
!47 = metadata !{i32 590080, metadata !46, metadata !"arg", metadata !2, i32 18, metadata !12, i32 0} ; [ DW_TAG_auto_variable ]
!48 = metadata !{i32 19, i32 37, metadata !46, null}
!49 = metadata !{i32 590080, metadata !46, metadata !"r", metadata !2, i32 19, metadata !12, i32 0} ; [ DW_TAG_auto_variable ]
!50 = metadata !{i32 20, i32 40, metadata !46, null}
!51 = metadata !{i32 590080, metadata !46, metadata !"s", metadata !2, i32 20, metadata !12, i32 0} ; [ DW_TAG_auto_variable ]
!52 = metadata !{i32 21, i32 5, metadata !46, null}
!53 = metadata !{i32 22, i32 5, metadata !46, null}
