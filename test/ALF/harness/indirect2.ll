; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@select = common global i32 0, align 4

define signext i16 @f(i16 signext %arg) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !15), !dbg !16
  %tmp = sext i16 %arg to i32, !dbg !17
  %tmp1 = add nsw i32 %tmp, 1, !dbg !17
  %tmp2 = sdiv i32 %tmp1, 2, !dbg !17
  %tmp3 = trunc i32 %tmp2 to i16, !dbg !17
  ret i16 %tmp3, !dbg !17
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define signext i16 @g(i16 signext %arg) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !19), !dbg !20
  %tmp = shl i16 %arg, 1
  ret i16 %tmp, !dbg !21
}

define signext i16 @h(i16 signext %arg) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !23), !dbg !24
  %tmp = add i16 %arg, 1
  ret i16 %tmp, !dbg !25
}

define i32 @main() nounwind {
bb:
  call void @llvm.dbg.value(metadata !27, i64 0, metadata !28), !dbg !30
  call void @llvm.dbg.value(metadata !31, i64 0, metadata !32), !dbg !33
  call void @llvm.dbg.value(metadata !34, i64 0, metadata !35), !dbg !36
  %tmp = load volatile i32* @select, align 4, !dbg !37
  %tmp1 = srem i32 %tmp, 3, !dbg !37
  switch i32 %tmp1, label %bb4 [
    i32 0, label %bb2
    i32 1, label %bb3
  ], !dbg !37

bb2:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !38, i64 0, metadata !39), !dbg !44
  br label %bb5, !dbg !44

bb3:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !46, i64 0, metadata !39), !dbg !47
  br label %bb5, !dbg !47

bb4:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !48, i64 0, metadata !39), !dbg !49
  br label %bb5, !dbg !49

bb5:                                              ; preds = %bb4, %bb3, %bb2
  %fp.0 = phi i16 (i16)* [ @h, %bb4 ], [ @g, %bb3 ], [ @f, %bb2 ]
  %tmp6 = call signext i16 %fp.0(i16 signext 0) nounwind, !dbg !50
  call void @llvm.dbg.value(metadata !{i16 %tmp6}, i64 0, metadata !51), !dbg !50
  %tmp7 = call signext i16 %fp.0(i16 signext 3) nounwind, !dbg !52
  call void @llvm.dbg.value(metadata !{i16 %tmp7}, i64 0, metadata !53), !dbg !52
  %tmp8 = call signext i16 %fp.0(i16 signext 7) nounwind, !dbg !54
  call void @llvm.dbg.value(metadata !{i16 %tmp8}, i64 0, metadata !55), !dbg !54
  %tmp9 = add i16 %tmp6, %tmp7
  %tmp10 = add i16 %tmp9, %tmp8
  %tmp11 = add i16 %tmp10, -6
  call void @llvm.dbg.value(metadata !{i16 %tmp11}, i64 0, metadata !56), !dbg !57
  %tmp12 = sext i16 %tmp11 to i32, !dbg !58
  ret i32 %tmp12, !dbg !58
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !7, !8, !9}
!llvm.dbg.gv = !{!13}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"f", metadata !"f", metadata !"", metadata !1, i32 9, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i16 (i16)* @f} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"indirect2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"indirect2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589846, metadata !2, metadata !"int16_t", metadata !1, i32 38, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_typedef ]
!6 = metadata !{i32 589860, metadata !2, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 589870, i32 0, metadata !1, metadata !"g", metadata !"g", metadata !"", metadata !1, i32 12, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i16 (i16)* @g} ; [ DW_TAG_subprogram ]
!8 = metadata !{i32 589870, i32 0, metadata !1, metadata !"h", metadata !"h", metadata !"", metadata !1, i32 15, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i16 (i16)* @h} ; [ DW_TAG_subprogram ]
!9 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 19, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!10 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !11, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!11 = metadata !{metadata !12}
!12 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!13 = metadata !{i32 589876, i32 0, metadata !2, metadata !"select", metadata !"select", metadata !"", metadata !1, i32 7, metadata !14, i32 0, i32 1, i32* @select} ; [ DW_TAG_variable ]
!14 = metadata !{i32 589877, metadata !2, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !12} ; [ DW_TAG_volatile_type ]
!15 = metadata !{i32 590081, metadata !0, metadata !"arg", metadata !1, i32 16777225, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!16 = metadata !{i32 9, i32 19, metadata !0, null}
!17 = metadata !{i32 10, i32 3, metadata !18, null}
!18 = metadata !{i32 589835, metadata !0, i32 9, i32 24, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!19 = metadata !{i32 590081, metadata !7, metadata !"arg", metadata !1, i32 16777228, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!20 = metadata !{i32 12, i32 19, metadata !7, null}
!21 = metadata !{i32 13, i32 3, metadata !22, null}
!22 = metadata !{i32 589835, metadata !7, i32 12, i32 24, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!23 = metadata !{i32 590081, metadata !8, metadata !"arg", metadata !1, i32 16777231, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!24 = metadata !{i32 15, i32 19, metadata !8, null}
!25 = metadata !{i32 16, i32 3, metadata !26, null}
!26 = metadata !{i32 589835, metadata !8, i32 15, i32 24, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!27 = metadata !{i16 0}                           
!28 = metadata !{i32 590080, metadata !29, metadata !"t1", metadata !1, i32 20, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!29 = metadata !{i32 589835, metadata !9, i32 19, i32 1, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!30 = metadata !{i32 20, i32 17, metadata !29, null}
!31 = metadata !{i16 3}                           ; [ DW_TAG_entry_point ]
!32 = metadata !{i32 590080, metadata !29, metadata !"t2", metadata !1, i32 21, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!33 = metadata !{i32 21, i32 17, metadata !29, null}
!34 = metadata !{i16 7}                           
!35 = metadata !{i32 590080, metadata !29, metadata !"t3", metadata !1, i32 22, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!36 = metadata !{i32 22, i32 17, metadata !29, null}
!37 = metadata !{i32 25, i32 3, metadata !29, null}
!38 = metadata !{i16 (i16)* @f}
!39 = metadata !{i32 590080, metadata !29, metadata !"fp", metadata !1, i32 24, metadata !40, i32 0} ; [ DW_TAG_auto_variable ]
!40 = metadata !{i32 589846, metadata !2, metadata !"fun", metadata !1, i32 8, i64 0, i64 0, i64 0, i32 0, metadata !41} ; [ DW_TAG_typedef ]
!41 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !42} ; [ DW_TAG_pointer_type ]
!42 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !43, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!43 = metadata !{metadata !5, metadata !5}
!44 = metadata !{i32 26, i32 11, metadata !45, null}
!45 = metadata !{i32 589835, metadata !29, i32 25, i32 20, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!46 = metadata !{i16 (i16)* @g}
!47 = metadata !{i32 27, i32 11, metadata !45, null}
!48 = metadata !{i16 (i16)* @h}
!49 = metadata !{i32 28, i32 12, metadata !45, null}
!50 = metadata !{i32 30, i32 3, metadata !29, null}
!51 = metadata !{i32 590080, metadata !29, metadata !"r1", metadata !1, i32 23, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!52 = metadata !{i32 31, i32 3, metadata !29, null}
!53 = metadata !{i32 590080, metadata !29, metadata !"r2", metadata !1, i32 23, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!54 = metadata !{i32 32, i32 3, metadata !29, null}
!55 = metadata !{i32 590080, metadata !29, metadata !"r3", metadata !1, i32 23, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!56 = metadata !{i32 590080, metadata !29, metadata !"s", metadata !1, i32 23, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!57 = metadata !{i32 36, i32 3, metadata !29, null}
!58 = metadata !{i32 37, i32 3, metadata !29, null}
