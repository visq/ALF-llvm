; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@g = common global i32 0, align 4

define i32 @nondet_u32(i32 %lb) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %lb}, i64 0, metadata !13), !dbg !14
  %tmp = load volatile i32* @g, align 4, !dbg !15
  call void @llvm.dbg.value(metadata !{i32 %tmp}, i64 0, metadata !17), !dbg !15
  %tmp1 = icmp ult i32 %tmp, %lb, !dbg !18
  br i1 %tmp1, label %bb2, label %bb3, !dbg !18

bb2:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !{i32 %lb}, i64 0, metadata !17), !dbg !18
  br label %bb3, !dbg !18

bb3:                                              ; preds = %bb2, %bb
  %v.0 = phi i32 [ %lb, %bb2 ], [ %tmp, %bb ]
  ret i32 %v.0, !dbg !19
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main() nounwind {
bb:
  %tmp = call i32 @nondet_u32(i32 0), !dbg !20
  call void @llvm.dbg.value(metadata !{i32 %tmp}, i64 0, metadata !22), !dbg !20
  %tmp1 = icmp eq i32 %tmp, 0, !dbg !23
  br i1 %tmp1, label %bb3, label %bb2, !dbg !23

bb2:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !24, i64 0, metadata !22), !dbg !23
  br label %bb3, !dbg !23

bb3:                                              ; preds = %bb2, %bb
  %v.0 = phi i32 [ 0, %bb2 ], [ %tmp, %bb ]
  ret i32 %v.0, !dbg !25
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !7}
!llvm.dbg.gv = !{!11}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"nondet_u32", metadata !"nondet_u32", metadata !"", metadata !1, i32 8, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @nondet_u32} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"bug_restrict.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"bug_restrict.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589846, metadata !2, metadata !"uint32_t", metadata !1, i32 52, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_typedef ]
!6 = metadata !{i32 589860, metadata !2, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 14, metadata !8, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!8 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !9, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!9 = metadata !{metadata !10}
!10 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!11 = metadata !{i32 589876, i32 0, metadata !2, metadata !"g", metadata !"g", metadata !"", metadata !1, i32 7, metadata !12, i32 0, i32 1, i32* @g} ; [ DW_TAG_variable ]
!12 = metadata !{i32 589877, metadata !2, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !5} ; [ DW_TAG_volatile_type ]
!13 = metadata !{i32 590081, metadata !0, metadata !"lb", metadata !1, i32 16777224, metadata !10, i32 0} ; [ DW_TAG_arg_variable ]
!14 = metadata !{i32 8, i32 25, metadata !0, null}
!15 = metadata !{i32 9, i32 17, metadata !16, null}
!16 = metadata !{i32 589835, metadata !0, i32 8, i32 29, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!17 = metadata !{i32 590080, metadata !16, metadata !"v", metadata !1, i32 9, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!18 = metadata !{i32 10, i32 3, metadata !16, null}
!19 = metadata !{i32 11, i32 3, metadata !16, null}
!20 = metadata !{i32 15, i32 29, metadata !21, null}
!21 = metadata !{i32 589835, metadata !7, i32 14, i32 1, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!22 = metadata !{i32 590080, metadata !21, metadata !"v", metadata !1, i32 15, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!23 = metadata !{i32 16, i32 3, metadata !21, null}
!24 = metadata !{i32 0}
!25 = metadata !{i32 17, i32 3, metadata !21, null}
