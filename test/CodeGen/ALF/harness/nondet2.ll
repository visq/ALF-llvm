; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@vint_init = global i32 9, align 4
@vint_ptr = global i32* @vint_init, align 4
@tmp = common global i32 0, align 4

define i32 @nondet_int() nounwind {
bb:
  %tmp = load i32** @vint_ptr, align 4, !dbg !12
  %tmp1 = volatile load i32* %tmp, align 4, !dbg !12
  ret i32 %tmp1, !dbg !12
}

define i32 @main() nounwind {
bb:
  %tmp = call i32 @nondet_int(), !dbg !14
  call void @llvm.dbg.value(metadata !{i32 %tmp}, i64 0, metadata !16), !dbg !14
  %tmp1 = icmp sgt i32 %tmp, -1, !dbg !17
  br i1 %tmp1, label %bb2, label %bb11, !dbg !17

bb2:                                              ; preds = %bb
  %tmp3 = icmp slt i32 %tmp, 10, !dbg !17
  br i1 %tmp3, label %bb4, label %bb11, !dbg !17

bb4:                                              ; preds = %bb2
  br label %bb5, !dbg !18

bb5:                                              ; preds = %bb7, %bb4
  %i.0 = phi i32 [ %tmp, %bb4 ], [ %tmp6, %bb7 ]
  %tmp6 = add nsw i32 %i.0, 1, !dbg !20
  call void @llvm.dbg.value(metadata !{i32 %tmp6}, i64 0, metadata !16), !dbg !20
  store i32 %tmp6, i32* @tmp, align 4, !dbg !22
  br label %bb7, !dbg !23

bb7:                                              ; preds = %bb5
  %tmp8 = load i32* @tmp, align 4, !dbg !23
  %tmp9 = icmp eq i32 %tmp8, 10, !dbg !23
  br i1 %tmp9, label %bb10, label %bb5, !dbg !23

bb10:                                             ; preds = %bb7
  %phitmp = add i32 %i.0, -9
  br label %bb12, !dbg !24

bb11:                                             ; preds = %bb2, %bb
  call void @llvm.dbg.value(metadata !25, i64 0, metadata !16), !dbg !26
  br label %bb12, !dbg !28

bb12:                                             ; preds = %bb11, %bb10
  %i.1 = phi i32 [ %phitmp, %bb10 ], [ 0, %bb11 ]
  ret i32 %i.1, !dbg !29
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !4, !7}
!llvm.dbg.sp = !{!8, !11}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"vint_init", metadata !"vint_init", metadata !"", metadata !2, i32 7, metadata !3, i32 0, i32 1, i32* @vint_init} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"nondet2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"nondet2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!4 = metadata !{i32 589876, i32 0, metadata !1, metadata !"vint_ptr", metadata !"vint_ptr", metadata !"", metadata !2, i32 8, metadata !5, i32 0, i32 1, i32** @vint_ptr} ; [ DW_TAG_variable ]
!5 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !6} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !3} ; [ DW_TAG_volatile_type ]
!7 = metadata !{i32 589876, i32 0, metadata !1, metadata !"tmp", metadata !"tmp", metadata !"", metadata !2, i32 10, metadata !3, i32 0, i32 1, i32* @tmp} ; [ DW_TAG_variable ]
!8 = metadata !{i32 589870, i32 0, metadata !2, metadata !"nondet_int", metadata !"nondet_int", metadata !"", metadata !2, i32 12, metadata !9, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @nondet_int} ; [ DW_TAG_subprogram ]
!9 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !10, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!10 = metadata !{metadata !3}
!11 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 17, metadata !9, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!12 = metadata !{i32 13, i32 3, metadata !13, null}
!13 = metadata !{i32 589835, metadata !8, i32 12, i32 18, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!14 = metadata !{i32 19, i32 5, metadata !15, null}
!15 = metadata !{i32 589835, metadata !11, i32 17, i32 1, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!16 = metadata !{i32 590080, metadata !15, metadata !"i", metadata !2, i32 18, metadata !3, i32 0} ; [ DW_TAG_auto_variable ]
!17 = metadata !{i32 20, i32 5, metadata !15, null}
!18 = metadata !{i32 22, i32 9, metadata !19, null}
!19 = metadata !{i32 589835, metadata !15, i32 21, i32 5, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!20 = metadata !{i32 24, i32 13, metadata !21, null}
!21 = metadata !{i32 589835, metadata !19, i32 23, i32 9, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!22 = metadata !{i32 25, i32 13, metadata !21, null}
!23 = metadata !{i32 26, i32 9, metadata !21, null}
!24 = metadata !{i32 28, i32 5, metadata !19, null}
!25 = metadata !{i32 10}
!26 = metadata !{i32 31, i32 9, metadata !27, null}
!27 = metadata !{i32 589835, metadata !15, i32 30, i32 5, metadata !2, i32 4} ; [ DW_TAG_lexical_block ]
!28 = metadata !{i32 32, i32 5, metadata !27, null}
!29 = metadata !{i32 33, i32 5, metadata !15, null}
