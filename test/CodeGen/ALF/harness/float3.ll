; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@nan_f = global float 0x7FF8000000000000, align 4
@pinff = global float 0x7FF0000000000000, align 4
@ninff = global float 0xFFF0000000000000, align 4
@nand = global double 0x7FF8000000000000, align 8
@pinfd = global double 0x7FF0000000000000, align 8
@ninfd = global double 0xFFF0000000000000, align 8
@in = common global i32 0, align 4

define i32 @main() nounwind {
bb:
  %zf = alloca float, align 4
  %n1f = alloca float, align 4
  %zd = alloca double, align 8
  %n1d = alloca double, align 8
  call void @llvm.dbg.declare(metadata !{float* %zf}, metadata !16), !dbg !19
  volatile store float 0.000000e+00, float* %zf, align 4, !dbg !20
  call void @llvm.dbg.declare(metadata !{float* %n1f}, metadata !21), !dbg !22
  volatile store float 0.000000e+00, float* %n1f, align 4, !dbg !20
  call void @llvm.dbg.declare(metadata !{double* %zd}, metadata !23), !dbg !25
  volatile store double 0.000000e+00, double* %zd, align 8, !dbg !26
  call void @llvm.dbg.declare(metadata !{double* %n1d}, metadata !27), !dbg !28
  volatile store double 0.000000e+00, double* %n1d, align 8, !dbg !26
  %tmp = volatile load i32* @in, align 4, !dbg !29
  %tmp1 = icmp eq i32 %tmp, 0, !dbg !29
  br i1 %tmp1, label %bb8, label %bb2, !dbg !29

bb2:                                              ; preds = %bb
  %tmp3 = volatile load float* %zf, align 4, !dbg !30
  %tmp4 = fpext float %tmp3 to double, !dbg !30
  %tmp5 = volatile load double* %zd, align 8, !dbg !30
  %tmp6 = fdiv double %tmp4, %tmp5, !dbg !30
  volatile store double %tmp6, double* %n1d, align 8, !dbg !30
  %tmp7 = fptrunc double %tmp6 to float, !dbg !30
  volatile store float %tmp7, float* %n1f, align 4, !dbg !30
  br label %bb14, !dbg !32

bb8:                                              ; preds = %bb
  %tmp9 = volatile load double* %zd, align 8, !dbg !33
  %tmp10 = volatile load float* %zf, align 4, !dbg !33
  %tmp11 = fpext float %tmp10 to double, !dbg !33
  %tmp12 = fdiv double %tmp9, %tmp11, !dbg !33
  volatile store double %tmp12, double* %n1d, align 8, !dbg !33
  %tmp13 = fptrunc double %tmp12 to float, !dbg !33
  volatile store float %tmp13, float* %n1f, align 4, !dbg !33
  br label %bb14, !dbg !35

bb14:                                             ; preds = %bb8, %bb2
  call void @llvm.dbg.value(metadata !36, i64 0, metadata !37), !dbg !38
  %tmp15 = volatile load double* %n1d, align 8, !dbg !39
  %tmp16 = load float* @nan_f, align 4, !dbg !39
  %tmp17 = fpext float %tmp16 to double, !dbg !39
  %tmp18 = fcmp olt double %tmp15, %tmp17, !dbg !39
  br i1 %tmp18, label %bb19, label %bb20, !dbg !39

bb19:                                             ; preds = %bb14
  call void @llvm.dbg.value(metadata !40, i64 0, metadata !37), !dbg !39
  br label %bb20, !dbg !39

bb20:                                             ; preds = %bb19, %bb14
  %r.0 = phi i32 [ 1, %bb19 ], [ 0, %bb14 ]
  %tmp21 = volatile load double* %n1d, align 8, !dbg !41
  %tmp22 = load double* @nand, align 8, !dbg !41
  %tmp23 = fcmp ogt double %tmp21, %tmp22, !dbg !41
  br i1 %tmp23, label %bb24, label %bb26, !dbg !41

bb24:                                             ; preds = %bb20
  %tmp25 = add nsw i32 %r.0, 1, !dbg !41
  call void @llvm.dbg.value(metadata !{i32 %tmp25}, i64 0, metadata !37), !dbg !41
  br label %bb26, !dbg !41

bb26:                                             ; preds = %bb24, %bb20
  %r.1 = phi i32 [ %tmp25, %bb24 ], [ %r.0, %bb20 ]
  %tmp27 = volatile load double* %n1d, align 8, !dbg !42
  %tmp28 = load double* @pinfd, align 8, !dbg !42
  %tmp29 = fcmp ult double %tmp27, %tmp28, !dbg !42
  br i1 %tmp29, label %bb32, label %bb30, !dbg !42

bb30:                                             ; preds = %bb26
  %tmp31 = add nsw i32 %r.1, 1, !dbg !42
  call void @llvm.dbg.value(metadata !{i32 %tmp31}, i64 0, metadata !37), !dbg !42
  br label %bb32, !dbg !42

bb32:                                             ; preds = %bb30, %bb26
  %r.2 = phi i32 [ %tmp31, %bb30 ], [ %r.1, %bb26 ]
  %tmp33 = volatile load float* %n1f, align 4, !dbg !43
  %tmp34 = fpext float %tmp33 to double, !dbg !43
  %tmp35 = load double* @ninfd, align 8, !dbg !43
  %tmp36 = fcmp ugt double %tmp34, %tmp35, !dbg !43
  br i1 %tmp36, label %bb39, label %bb37, !dbg !43

bb37:                                             ; preds = %bb32
  %tmp38 = add nsw i32 %r.2, 1, !dbg !43
  call void @llvm.dbg.value(metadata !{i32 %tmp38}, i64 0, metadata !37), !dbg !43
  br label %bb39, !dbg !43

bb39:                                             ; preds = %bb37, %bb32
  %r.3 = phi i32 [ %tmp38, %bb37 ], [ %r.2, %bb32 ]
  ret i32 %r.3, !dbg !44
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !4, !5, !6, !8, !9, !10}
!llvm.dbg.sp = !{!13}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"nan_f", metadata !"nan_f", metadata !"", metadata !2, i32 4, metadata !3, i32 0, i32 1, float* @nan_f} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"float3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"float3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589860, metadata !1, metadata !"float", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!4 = metadata !{i32 589876, i32 0, metadata !1, metadata !"pinff", metadata !"pinff", metadata !"", metadata !2, i32 4, metadata !3, i32 0, i32 1, float* @pinff} ; [ DW_TAG_variable ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"ninff", metadata !"ninff", metadata !"", metadata !2, i32 4, metadata !3, i32 0, i32 1, float* @ninff} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589876, i32 0, metadata !1, metadata !"nand", metadata !"nand", metadata !"", metadata !2, i32 5, metadata !7, i32 0, i32 1, double* @nand} ; [ DW_TAG_variable ]
!7 = metadata !{i32 589860, metadata !1, metadata !"double", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!8 = metadata !{i32 589876, i32 0, metadata !1, metadata !"pinfd", metadata !"pinfd", metadata !"", metadata !2, i32 5, metadata !7, i32 0, i32 1, double* @pinfd} ; [ DW_TAG_variable ]
!9 = metadata !{i32 589876, i32 0, metadata !1, metadata !"ninfd", metadata !"ninfd", metadata !"", metadata !2, i32 5, metadata !7, i32 0, i32 1, double* @ninfd} ; [ DW_TAG_variable ]
!10 = metadata !{i32 589876, i32 0, metadata !1, metadata !"in", metadata !"in", metadata !"", metadata !2, i32 3, metadata !11, i32 0, i32 1, i32* @in} ; [ DW_TAG_variable ]
!11 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !12} ; [ DW_TAG_volatile_type ]
!12 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!13 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 7, metadata !14, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!14 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !15, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!15 = metadata !{metadata !12}
!16 = metadata !{i32 590080, metadata !17, metadata !"zf", metadata !2, i32 8, metadata !18, i32 0} ; [ DW_TAG_auto_variable ]
!17 = metadata !{i32 589835, metadata !13, i32 7, i32 12, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!18 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !3} ; [ DW_TAG_volatile_type ]
!19 = metadata !{i32 8, i32 18, metadata !17, null}
!20 = metadata !{i32 8, i32 33, metadata !17, null}
!21 = metadata !{i32 590080, metadata !17, metadata !"n1f", metadata !2, i32 8, metadata !18, i32 0} ; [ DW_TAG_auto_variable ]
!22 = metadata !{i32 8, i32 26, metadata !17, null}
!23 = metadata !{i32 590080, metadata !17, metadata !"zd", metadata !2, i32 9, metadata !24, i32 0} ; [ DW_TAG_auto_variable ]
!24 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !7} ; [ DW_TAG_volatile_type ]
!25 = metadata !{i32 9, i32 19, metadata !17, null}
!26 = metadata !{i32 9, i32 34, metadata !17, null}
!27 = metadata !{i32 590080, metadata !17, metadata !"n1d", metadata !2, i32 9, metadata !24, i32 0} ; [ DW_TAG_auto_variable ]
!28 = metadata !{i32 9, i32 27, metadata !17, null}
!29 = metadata !{i32 10, i32 3, metadata !17, null}
!30 = metadata !{i32 11, i32 5, metadata !31, null}
!31 = metadata !{i32 589835, metadata !17, i32 10, i32 10, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!32 = metadata !{i32 12, i32 3, metadata !31, null}
!33 = metadata !{i32 13, i32 5, metadata !34, null}
!34 = metadata !{i32 589835, metadata !17, i32 12, i32 10, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!35 = metadata !{i32 14, i32 3, metadata !34, null}
!36 = metadata !{i32 0}
!37 = metadata !{i32 590080, metadata !17, metadata !"r", metadata !2, i32 15, metadata !12, i32 0} ; [ DW_TAG_auto_variable ]
!38 = metadata !{i32 15, i32 12, metadata !17, null}
!39 = metadata !{i32 16, i32 3, metadata !17, null}
!40 = metadata !{i32 1}
!41 = metadata !{i32 17, i32 3, metadata !17, null}
!42 = metadata !{i32 18, i32 3, metadata !17, null}
!43 = metadata !{i32 19, i32 3, metadata !17, null}
!44 = metadata !{i32 20, i32 3, metadata !17, null}
