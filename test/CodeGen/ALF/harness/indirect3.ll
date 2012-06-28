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
  %fs = alloca [3 x i16 (i16)*], align 4
  call void @llvm.dbg.declare(metadata !{[3 x i16 (i16)*]* %fs}, metadata !27), !dbg !36
  call void @llvm.dbg.value(metadata !37, i64 0, metadata !38), !dbg !39
  call void @llvm.dbg.value(metadata !40, i64 0, metadata !41), !dbg !42
  call void @llvm.dbg.value(metadata !43, i64 0, metadata !44), !dbg !45
  %tmp = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 2, !dbg !46
  store i16 (i16)* @h, i16 (i16)** %tmp, align 4, !dbg !46
  %tmp1 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 1, !dbg !47
  store i16 (i16)* @g, i16 (i16)** %tmp1, align 4, !dbg !47
  %tmp2 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 0, !dbg !48
  store i16 (i16)* @f, i16 (i16)** %tmp2, align 4, !dbg !48
  %tmp3 = load volatile i32* @select, align 4, !dbg !49
  %tmp4 = srem i32 %tmp3, 3, !dbg !49
  %tmp5 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 %tmp4, !dbg !49
  %tmp6 = load i16 (i16)** %tmp5, align 4, !dbg !49
  %tmp7 = call signext i16 %tmp6(i16 signext 0) nounwind, !dbg !49
  call void @llvm.dbg.value(metadata !{i16 %tmp7}, i64 0, metadata !50), !dbg !49
  %tmp8 = load volatile i32* @select, align 4, !dbg !51
  %tmp9 = srem i32 %tmp8, 3, !dbg !51
  %tmp10 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 %tmp9, !dbg !51
  %tmp11 = load i16 (i16)** %tmp10, align 4, !dbg !51
  %tmp12 = call signext i16 %tmp11(i16 signext 3) nounwind, !dbg !51
  call void @llvm.dbg.value(metadata !{i16 %tmp12}, i64 0, metadata !52), !dbg !51
  %tmp13 = load volatile i32* @select, align 4, !dbg !53
  %tmp14 = srem i32 %tmp13, 3, !dbg !53
  %tmp15 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 %tmp14, !dbg !53
  %tmp16 = load i16 (i16)** %tmp15, align 4, !dbg !53
  %tmp17 = call signext i16 %tmp16(i16 signext 7) nounwind, !dbg !53
  call void @llvm.dbg.value(metadata !{i16 %tmp17}, i64 0, metadata !54), !dbg !53
  %tmp18 = add i16 %tmp7, %tmp12
  %tmp19 = add i16 %tmp18, %tmp17
  %tmp20 = add i16 %tmp19, -6
  call void @llvm.dbg.value(metadata !{i16 %tmp20}, i64 0, metadata !55), !dbg !56
  %tmp21 = sext i16 %tmp20 to i32, !dbg !57
  ret i32 %tmp21, !dbg !57
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !7, !8, !9}
!llvm.dbg.gv = !{!13}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"f", metadata !"f", metadata !"", metadata !1, i32 9, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i16 (i16)* @f} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"indirect3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"indirect3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
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
!27 = metadata !{i32 590080, metadata !28, metadata !"fs", metadata !1, i32 20, metadata !29, i32 0} ; [ DW_TAG_auto_variable ]
!28 = metadata !{i32 589835, metadata !9, i32 19, i32 1, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!29 = metadata !{i32 589825, metadata !2, metadata !"", metadata !2, i32 0, i64 96, i64 32, i32 0, i32 0, metadata !30, metadata !34, i32 0, i32 0} ; [ DW_TAG_array_type ]
!30 = metadata !{i32 589846, metadata !2, metadata !"fun", metadata !1, i32 8, i64 0, i64 0, i64 0, i32 0, metadata !31} ; [ DW_TAG_typedef ]
!31 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !32} ; [ DW_TAG_pointer_type ]
!32 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !33, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!33 = metadata !{metadata !5, metadata !5}
!34 = metadata !{metadata !35}
!35 = metadata !{i32 589857, i64 0, i64 2}        ; [ DW_TAG_subrange_type ]
!36 = metadata !{i32 20, i32 7, metadata !28, null}
!37 = metadata !{i16 0}                           
!38 = metadata !{i32 590080, metadata !28, metadata !"t1", metadata !1, i32 21, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!39 = metadata !{i32 21, i32 17, metadata !28, null}
!40 = metadata !{i16 3}                           ; [ DW_TAG_entry_point ]
!41 = metadata !{i32 590080, metadata !28, metadata !"t2", metadata !1, i32 22, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!42 = metadata !{i32 22, i32 17, metadata !28, null}
!43 = metadata !{i16 7}                           
!44 = metadata !{i32 590080, metadata !28, metadata !"t3", metadata !1, i32 23, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!45 = metadata !{i32 23, i32 17, metadata !28, null}
!46 = metadata !{i32 26, i32 3, metadata !28, null}
!47 = metadata !{i32 27, i32 3, metadata !28, null}
!48 = metadata !{i32 28, i32 3, metadata !28, null}
!49 = metadata !{i32 29, i32 3, metadata !28, null}
!50 = metadata !{i32 590080, metadata !28, metadata !"r1", metadata !1, i32 24, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!51 = metadata !{i32 30, i32 3, metadata !28, null}
!52 = metadata !{i32 590080, metadata !28, metadata !"r2", metadata !1, i32 24, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!53 = metadata !{i32 31, i32 3, metadata !28, null}
!54 = metadata !{i32 590080, metadata !28, metadata !"r3", metadata !1, i32 24, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!55 = metadata !{i32 590080, metadata !28, metadata !"s", metadata !1, i32 24, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!56 = metadata !{i32 35, i32 3, metadata !28, null}
!57 = metadata !{i32 36, i32 3, metadata !28, null}
