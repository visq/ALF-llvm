; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

%struct.DATA = type { i32, i32 }

@data = global [15 x %struct.DATA] [%struct.DATA { i32 1, i32 100 }, %struct.DATA { i32 5, i32 200 }, %struct.DATA { i32 6, i32 300 }, %struct.DATA { i32 7, i32 700 }, %struct.DATA { i32 8, i32 900 }, %struct.DATA { i32 9, i32 250 }, %struct.DATA { i32 10, i32 400 }, %struct.DATA { i32 11, i32 600 }, %struct.DATA { i32 12, i32 800 }, %struct.DATA { i32 13, i32 1500 }, %struct.DATA { i32 14, i32 1200 }, %struct.DATA { i32 15, i32 110 }, %struct.DATA { i32 16, i32 140 }, %struct.DATA { i32 17, i32 133 }, %struct.DATA { i32 18, i32 10 }], align 4
@cnt1 = common global i32 0, align 4

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !29), !dbg !30
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !31), !dbg !32
  %call = call i32 @binary_search(i32 8), !dbg !33
  ret i32 0, !dbg !35
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @binary_search(i32 %x) nounwind {
entry:
  call void @llvm.dbg.value(metadata !{i32 %x}, i64 0, metadata !36), !dbg !37
  call void @llvm.dbg.value(metadata !2, i64 0, metadata !38), !dbg !40
  call void @llvm.dbg.value(metadata !41, i64 0, metadata !42), !dbg !43
  call void @llvm.dbg.value(metadata !44, i64 0, metadata !45), !dbg !46
  br label %while.cond, !dbg !47

while.cond:                                       ; preds = %if.end10, %entry
  %up.0 = phi i32 [ 14, %entry ], [ %up.2, %if.end10 ]
  %fvalue.0 = phi i32 [ -1, %entry ], [ %fvalue.1, %if.end10 ]
  %low.0 = phi i32 [ 0, %entry ], [ %low.2, %if.end10 ]
  %cmp = icmp sgt i32 %low.0, %up.0, !dbg !47
  br i1 %cmp, label %while.end, label %while.body, !dbg !47

while.body:                                       ; preds = %while.cond
  %add = add nsw i32 %low.0, %up.0, !dbg !48
  %shr = ashr i32 %add, 1, !dbg !48
  call void @llvm.dbg.value(metadata !{i32 %shr}, i64 0, metadata !50), !dbg !48
  %key = getelementptr inbounds [15 x %struct.DATA]* @data, i32 0, i32 %shr, i32 0, !dbg !51
  %tmp = load i32* %key, align 4, !dbg !51
  %cmp1 = icmp eq i32 %tmp, %x, !dbg !51
  br i1 %cmp1, label %if.then, label %if.else, !dbg !51

if.then:                                          ; preds = %while.body
  %sub = add nsw i32 %low.0, -1, !dbg !52
  call void @llvm.dbg.value(metadata !{i32 %sub}, i64 0, metadata !42), !dbg !52
  %value = getelementptr inbounds [15 x %struct.DATA]* @data, i32 0, i32 %shr, i32 1, !dbg !54
  %tmp1 = load i32* %value, align 4, !dbg !54
  call void @llvm.dbg.value(metadata !{i32 %tmp1}, i64 0, metadata !45), !dbg !54
  br label %if.end10, !dbg !55

if.else:                                          ; preds = %while.body
  %key4 = getelementptr inbounds [15 x %struct.DATA]* @data, i32 0, i32 %shr, i32 0, !dbg !56
  %tmp2 = load i32* %key4, align 4, !dbg !56
  %cmp5 = icmp sgt i32 %tmp2, %x, !dbg !56
  br i1 %cmp5, label %if.then6, label %if.else8, !dbg !56

if.then6:                                         ; preds = %if.else
  %sub7 = add nsw i32 %shr, -1, !dbg !57
  call void @llvm.dbg.value(metadata !{i32 %sub7}, i64 0, metadata !42), !dbg !57
  br label %if.end, !dbg !59

if.else8:                                         ; preds = %if.else
  %add9 = add nsw i32 %shr, 1, !dbg !60
  call void @llvm.dbg.value(metadata !{i32 %add9}, i64 0, metadata !38), !dbg !60
  br label %if.end

if.end:                                           ; preds = %if.else8, %if.then6
  %up.1 = phi i32 [ %sub7, %if.then6 ], [ %up.0, %if.else8 ]
  %low.1 = phi i32 [ %low.0, %if.then6 ], [ %add9, %if.else8 ]
  br label %if.end10

if.end10:                                         ; preds = %if.end, %if.then
  %up.2 = phi i32 [ %sub, %if.then ], [ %up.1, %if.end ]
  %fvalue.1 = phi i32 [ %tmp1, %if.then ], [ %fvalue.0, %if.end ]
  %low.2 = phi i32 [ %low.0, %if.then ], [ %low.1, %if.end ]
  %tmp3 = load i32* @cnt1, align 4, !dbg !62
  %inc = add nsw i32 %tmp3, 1, !dbg !62
  store i32 %inc, i32* @cnt1, align 4, !dbg !62
  br label %while.cond, !dbg !63

while.end:                                        ; preds = %while.cond
  ret i32 %fvalue.0, !dbg !64
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.cu = !{!0}

!0 = metadata !{i32 786449, i32 0, i32 12, metadata !"example_bs.c", metadata !"/home/benedikt/Projects/otap-llvm-3.0-b1/test/CodeGen/ALF/smoke", metadata !"clang version 3.1 (http://llvm.org/git/clang.git 6f576c9bfa9a22e2801485768fe56b3336ea18a7) (gitosis@forge.vmars.tuwien.ac.at:otap-llvm.git http://llvm.org/git/llvm.git 0624744fc88264009e42687020ffef0e89f9a255)", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !18} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5, metadata !15}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"main", metadata !"main", metadata !"", metadata !6, i32 80, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !13, i32 81} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"example_bs.c", metadata !"/home/benedikt/Projects/otap-llvm-3.0-b1/test/CodeGen/ALF/smoke", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9, metadata !9, metadata !10}
!9 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ]
!11 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !12} ; [ DW_TAG_pointer_type ]
!12 = metadata !{i32 786468, null, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!13 = metadata !{metadata !14}
!14 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!15 = metadata !{i32 786478, i32 0, metadata !6, metadata !"binary_search", metadata !"binary_search", metadata !"", metadata !6, i32 87, metadata !16, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32)* @binary_search, null, null, metadata !13, i32 88} ; [ DW_TAG_subprogram ]
!16 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !17, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!17 = metadata !{metadata !9, metadata !9}
!18 = metadata !{metadata !19}
!19 = metadata !{metadata !20, metadata !28}
!20 = metadata !{i32 786484, i32 0, null, metadata !"data", metadata !"data", metadata !"", metadata !6, i32 61, metadata !21, i32 0, i32 1, [15 x %struct.DATA]* @data} ; [ DW_TAG_variable ]
!21 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 960, i64 32, i32 0, i32 0, metadata !22, metadata !26, i32 0, i32 0} ; [ DW_TAG_array_type ]
!22 = metadata !{i32 786451, null, metadata !"DATA", metadata !6, i32 52, i64 64, i64 32, i32 0, i32 0, null, metadata !23, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!23 = metadata !{metadata !24, metadata !25}
!24 = metadata !{i32 786445, metadata !22, metadata !"key", metadata !6, i32 53, i64 32, i64 32, i64 0, i32 0, metadata !9} ; [ DW_TAG_member ]
!25 = metadata !{i32 786445, metadata !22, metadata !"value", metadata !6, i32 54, i64 32, i64 32, i64 32, i32 0, metadata !9} ; [ DW_TAG_member ]
!26 = metadata !{metadata !27}
!27 = metadata !{i32 786465, i64 0, i64 14}       ; [ DW_TAG_subrange_type ]
!28 = metadata !{i32 786484, i32 0, null, metadata !"cnt1", metadata !"cnt1", metadata !"", metadata !6, i32 58, metadata !9, i32 0, i32 1, i32* @cnt1} ; [ DW_TAG_variable ]
!29 = metadata !{i32 786689, metadata !5, metadata !"argc", metadata !6, i32 16777296, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!30 = metadata !{i32 80, i32 10, metadata !5, null}
!31 = metadata !{i32 786689, metadata !5, metadata !"argv", metadata !6, i32 33554512, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!32 = metadata !{i32 80, i32 23, metadata !5, null}
!33 = metadata !{i32 82, i32 2, metadata !34, null}
!34 = metadata !{i32 786443, metadata !5, i32 81, i32 1, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!35 = metadata !{i32 83, i32 2, metadata !34, null}
!36 = metadata !{i32 786689, metadata !15, metadata !"x", metadata !6, i32 16777303, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!37 = metadata !{i32 87, i32 19, metadata !15, null}
!38 = metadata !{i32 786688, metadata !39, metadata !"low", metadata !6, i32 89, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!39 = metadata !{i32 786443, metadata !15, i32 88, i32 1, metadata !6, i32 1} ; [ DW_TAG_lexical_block ]
!40 = metadata !{i32 91, i32 2, metadata !39, null}
!41 = metadata !{i32 14}
!42 = metadata !{i32 786688, metadata !39, metadata !"up", metadata !6, i32 89, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!43 = metadata !{i32 92, i32 2, metadata !39, null}
!44 = metadata !{i32 -1}                          ; [ DW_TAG_hi_user ]
!45 = metadata !{i32 786688, metadata !39, metadata !"fvalue", metadata !6, i32 89, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!46 = metadata !{i32 93, i32 2, metadata !39, null}
!47 = metadata !{i32 94, i32 2, metadata !39, null}
!48 = metadata !{i32 95, i32 3, metadata !49, null}
!49 = metadata !{i32 786443, metadata !39, i32 94, i32 20, metadata !6, i32 2} ; [ DW_TAG_lexical_block ]
!50 = metadata !{i32 786688, metadata !39, metadata !"mid", metadata !6, i32 89, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!51 = metadata !{i32 96, i32 3, metadata !49, null}
!52 = metadata !{i32 97, i32 4, metadata !53, null}
!53 = metadata !{i32 786443, metadata !49, i32 96, i32 27, metadata !6, i32 3} ; [ DW_TAG_lexical_block ]
!54 = metadata !{i32 98, i32 4, metadata !53, null}
!55 = metadata !{i32 102, i32 3, metadata !53, null}
!56 = metadata !{i32 103, i32 20, metadata !49, null}
!57 = metadata !{i32 104, i32 4, metadata !58, null}
!58 = metadata !{i32 786443, metadata !49, i32 103, i32 43, metadata !6, i32 4} ; [ DW_TAG_lexical_block ]
!59 = metadata !{i32 108, i32 3, metadata !58, null}
!60 = metadata !{i32 109, i32 4, metadata !61, null}
!61 = metadata !{i32 786443, metadata !49, i32 108, i32 10, metadata !6, i32 5} ; [ DW_TAG_lexical_block ]
!62 = metadata !{i32 115, i32 3, metadata !49, null}
!63 = metadata !{i32 117, i32 2, metadata !49, null}
!64 = metadata !{i32 121, i32 2, metadata !39, null}
