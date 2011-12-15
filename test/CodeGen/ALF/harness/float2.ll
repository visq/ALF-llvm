; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@o1f = global float 0x3FF0000020000000, align 4
@o2f = global float 1.000000e+00, align 4
@z1f = global float 0x3FEFFFFDE0000000, align 4
@z1d = global double 0x3FEFFFFFF543388F, align 8
@o1d = global double 0x3FF0000000000005, align 8
@o2d = global double 1.000000e+00, align 8

define i32 @main() nounwind {
bb:
  call void @llvm.dbg.value(metadata !14, i64 0, metadata !15), !dbg !17
  %tmp = load float* @z1f, align 4, !dbg !18
  %tmp1 = fptosi float %tmp to i8, !dbg !18
  call void @llvm.dbg.value(metadata !{i8 %tmp1}, i64 0, metadata !19), !dbg !18
  %tmp2 = icmp eq i8 %tmp1, 0, !dbg !18
  br i1 %tmp2, label %bb3, label %bb4, !dbg !18

bb3:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !21, i64 0, metadata !15), !dbg !18
  br label %bb4, !dbg !18

bb4:                                              ; preds = %bb3, %bb
  %r.0 = phi i32 [ 27, %bb3 ], [ 28, %bb ]
  %tmp5 = load double* @z1d, align 8, !dbg !22
  %tmp6 = fptosi double %tmp5 to i8, !dbg !22
  call void @llvm.dbg.value(metadata !{i8 %tmp6}, i64 0, metadata !19), !dbg !22
  %tmp7 = icmp eq i8 %tmp6, 0, !dbg !22
  br i1 %tmp7, label %bb8, label %bb10, !dbg !22

bb8:                                              ; preds = %bb4
  %tmp9 = add nsw i32 %r.0, -1, !dbg !22
  call void @llvm.dbg.value(metadata !{i32 %tmp9}, i64 0, metadata !15), !dbg !22
  br label %bb10, !dbg !22

bb10:                                             ; preds = %bb8, %bb4
  %r.1 = phi i32 [ %tmp9, %bb8 ], [ %r.0, %bb4 ]
  %tmp11 = load float* @o1f, align 4, !dbg !23
  %tmp12 = fptosi float %tmp11 to i8, !dbg !23
  call void @llvm.dbg.value(metadata !{i8 %tmp12}, i64 0, metadata !19), !dbg !23
  %tmp13 = icmp eq i8 %tmp12, 1, !dbg !23
  br i1 %tmp13, label %bb14, label %bb16, !dbg !23

bb14:                                             ; preds = %bb10
  %tmp15 = add nsw i32 %r.1, -1, !dbg !23
  call void @llvm.dbg.value(metadata !{i32 %tmp15}, i64 0, metadata !15), !dbg !23
  br label %bb16, !dbg !23

bb16:                                             ; preds = %bb14, %bb10
  %r.2 = phi i32 [ %tmp15, %bb14 ], [ %r.1, %bb10 ]
  %tmp17 = load float* @o2f, align 4, !dbg !24
  %tmp18 = fptosi float %tmp17 to i8, !dbg !24
  call void @llvm.dbg.value(metadata !{i8 %tmp18}, i64 0, metadata !19), !dbg !24
  %tmp19 = icmp eq i8 %tmp18, 1, !dbg !24
  br i1 %tmp19, label %bb20, label %bb22, !dbg !24

bb20:                                             ; preds = %bb16
  %tmp21 = add nsw i32 %r.2, -1, !dbg !24
  call void @llvm.dbg.value(metadata !{i32 %tmp21}, i64 0, metadata !15), !dbg !24
  br label %bb22, !dbg !24

bb22:                                             ; preds = %bb20, %bb16
  %r.3 = phi i32 [ %tmp21, %bb20 ], [ %r.2, %bb16 ]
  %tmp23 = load double* @o1d, align 8, !dbg !25
  %tmp24 = fptosi double %tmp23 to i8, !dbg !25
  call void @llvm.dbg.value(metadata !{i8 %tmp24}, i64 0, metadata !19), !dbg !25
  %tmp25 = icmp eq i8 %tmp24, 1, !dbg !25
  br i1 %tmp25, label %bb26, label %bb28, !dbg !25

bb26:                                             ; preds = %bb22
  %tmp27 = add nsw i32 %r.3, -1, !dbg !25
  call void @llvm.dbg.value(metadata !{i32 %tmp27}, i64 0, metadata !15), !dbg !25
  br label %bb28, !dbg !25

bb28:                                             ; preds = %bb26, %bb22
  %r.4 = phi i32 [ %tmp27, %bb26 ], [ %r.3, %bb22 ]
  %tmp29 = load double* @o2d, align 8, !dbg !26
  %tmp30 = fptosi double %tmp29 to i8, !dbg !26
  call void @llvm.dbg.value(metadata !{i8 %tmp30}, i64 0, metadata !19), !dbg !26
  %tmp31 = icmp eq i8 %tmp30, 1, !dbg !26
  br i1 %tmp31, label %bb32, label %bb34, !dbg !26

bb32:                                             ; preds = %bb28
  %tmp33 = add nsw i32 %r.4, -1, !dbg !26
  call void @llvm.dbg.value(metadata !{i32 %tmp33}, i64 0, metadata !15), !dbg !26
  br label %bb34, !dbg !26

bb34:                                             ; preds = %bb32, %bb28
  %r.5 = phi i32 [ %tmp33, %bb32 ], [ %r.4, %bb28 ]
  %tmp35 = load double* @z1d, align 8, !dbg !27
  %tmp36 = fptrunc double %tmp35 to float, !dbg !27
  %tmp37 = fptosi float %tmp36 to i8, !dbg !27
  call void @llvm.dbg.value(metadata !{i8 %tmp37}, i64 0, metadata !19), !dbg !27
  %tmp38 = icmp eq i8 %tmp37, 1, !dbg !27
  br i1 %tmp38, label %bb39, label %bb41, !dbg !27

bb39:                                             ; preds = %bb34
  %tmp40 = add nsw i32 %r.5, -1, !dbg !27
  call void @llvm.dbg.value(metadata !{i32 %tmp40}, i64 0, metadata !15), !dbg !27
  br label %bb41, !dbg !27

bb41:                                             ; preds = %bb39, %bb34
  %r.6 = phi i32 [ %tmp40, %bb39 ], [ %r.5, %bb34 ]
  %tmp42 = load float* @z1f, align 4, !dbg !28
  %tmp43 = fptosi float %tmp42 to i16, !dbg !28
  call void @llvm.dbg.value(metadata !{i16 %tmp43}, i64 0, metadata !29), !dbg !28
  %tmp44 = icmp eq i16 %tmp43, 0, !dbg !28
  br i1 %tmp44, label %bb45, label %bb47, !dbg !28

bb45:                                             ; preds = %bb41
  %tmp46 = add nsw i32 %r.6, -1, !dbg !28
  call void @llvm.dbg.value(metadata !{i32 %tmp46}, i64 0, metadata !15), !dbg !28
  br label %bb47, !dbg !28

bb47:                                             ; preds = %bb45, %bb41
  %r.7 = phi i32 [ %tmp46, %bb45 ], [ %r.6, %bb41 ]
  %tmp48 = load double* @z1d, align 8, !dbg !31
  %tmp49 = fptosi double %tmp48 to i16, !dbg !31
  call void @llvm.dbg.value(metadata !{i16 %tmp49}, i64 0, metadata !29), !dbg !31
  %tmp50 = icmp eq i16 %tmp49, 0, !dbg !31
  br i1 %tmp50, label %bb51, label %bb53, !dbg !31

bb51:                                             ; preds = %bb47
  %tmp52 = add nsw i32 %r.7, -1, !dbg !31
  call void @llvm.dbg.value(metadata !{i32 %tmp52}, i64 0, metadata !15), !dbg !31
  br label %bb53, !dbg !31

bb53:                                             ; preds = %bb51, %bb47
  %r.8 = phi i32 [ %tmp52, %bb51 ], [ %r.7, %bb47 ]
  %tmp54 = load float* @o1f, align 4, !dbg !32
  %tmp55 = fptosi float %tmp54 to i16, !dbg !32
  call void @llvm.dbg.value(metadata !{i16 %tmp55}, i64 0, metadata !29), !dbg !32
  %tmp56 = icmp eq i16 %tmp55, 1, !dbg !32
  br i1 %tmp56, label %bb57, label %bb59, !dbg !32

bb57:                                             ; preds = %bb53
  %tmp58 = add nsw i32 %r.8, -1, !dbg !32
  call void @llvm.dbg.value(metadata !{i32 %tmp58}, i64 0, metadata !15), !dbg !32
  br label %bb59, !dbg !32

bb59:                                             ; preds = %bb57, %bb53
  %r.9 = phi i32 [ %tmp58, %bb57 ], [ %r.8, %bb53 ]
  %tmp60 = load float* @o2f, align 4, !dbg !33
  %tmp61 = fptosi float %tmp60 to i16, !dbg !33
  call void @llvm.dbg.value(metadata !{i16 %tmp61}, i64 0, metadata !29), !dbg !33
  %tmp62 = icmp eq i16 %tmp61, 1, !dbg !33
  br i1 %tmp62, label %bb63, label %bb65, !dbg !33

bb63:                                             ; preds = %bb59
  %tmp64 = add nsw i32 %r.9, -1, !dbg !33
  call void @llvm.dbg.value(metadata !{i32 %tmp64}, i64 0, metadata !15), !dbg !33
  br label %bb65, !dbg !33

bb65:                                             ; preds = %bb63, %bb59
  %r.10 = phi i32 [ %tmp64, %bb63 ], [ %r.9, %bb59 ]
  %tmp66 = load double* @o1d, align 8, !dbg !34
  %tmp67 = fptosi double %tmp66 to i16, !dbg !34
  call void @llvm.dbg.value(metadata !{i16 %tmp67}, i64 0, metadata !29), !dbg !34
  %tmp68 = icmp eq i16 %tmp67, 1, !dbg !34
  br i1 %tmp68, label %bb69, label %bb71, !dbg !34

bb69:                                             ; preds = %bb65
  %tmp70 = add nsw i32 %r.10, -1, !dbg !34
  call void @llvm.dbg.value(metadata !{i32 %tmp70}, i64 0, metadata !15), !dbg !34
  br label %bb71, !dbg !34

bb71:                                             ; preds = %bb69, %bb65
  %r.11 = phi i32 [ %tmp70, %bb69 ], [ %r.10, %bb65 ]
  %tmp72 = load double* @o2d, align 8, !dbg !35
  %tmp73 = fptosi double %tmp72 to i16, !dbg !35
  call void @llvm.dbg.value(metadata !{i16 %tmp73}, i64 0, metadata !29), !dbg !35
  %tmp74 = icmp eq i16 %tmp73, 1, !dbg !35
  br i1 %tmp74, label %bb75, label %bb77, !dbg !35

bb75:                                             ; preds = %bb71
  %tmp76 = add nsw i32 %r.11, -1, !dbg !35
  call void @llvm.dbg.value(metadata !{i32 %tmp76}, i64 0, metadata !15), !dbg !35
  br label %bb77, !dbg !35

bb77:                                             ; preds = %bb75, %bb71
  %r.12 = phi i32 [ %tmp76, %bb75 ], [ %r.11, %bb71 ]
  %tmp78 = load double* @z1d, align 8, !dbg !36
  %tmp79 = fptrunc double %tmp78 to float, !dbg !36
  %tmp80 = fptosi float %tmp79 to i16, !dbg !36
  call void @llvm.dbg.value(metadata !{i16 %tmp80}, i64 0, metadata !29), !dbg !36
  %tmp81 = icmp eq i16 %tmp80, 1, !dbg !36
  br i1 %tmp81, label %bb82, label %bb84, !dbg !36

bb82:                                             ; preds = %bb77
  %tmp83 = add nsw i32 %r.12, -1, !dbg !36
  call void @llvm.dbg.value(metadata !{i32 %tmp83}, i64 0, metadata !15), !dbg !36
  br label %bb84, !dbg !36

bb84:                                             ; preds = %bb82, %bb77
  %r.13 = phi i32 [ %tmp83, %bb82 ], [ %r.12, %bb77 ]
  %tmp85 = load float* @z1f, align 4, !dbg !37
  %tmp86 = fptosi float %tmp85 to i32, !dbg !37
  call void @llvm.dbg.value(metadata !{i32 %tmp86}, i64 0, metadata !38), !dbg !37
  %tmp87 = icmp eq i32 %tmp86, 0, !dbg !37
  br i1 %tmp87, label %bb88, label %bb90, !dbg !37

bb88:                                             ; preds = %bb84
  %tmp89 = add nsw i32 %r.13, -1, !dbg !37
  call void @llvm.dbg.value(metadata !{i32 %tmp89}, i64 0, metadata !15), !dbg !37
  br label %bb90, !dbg !37

bb90:                                             ; preds = %bb88, %bb84
  %r.14 = phi i32 [ %tmp89, %bb88 ], [ %r.13, %bb84 ]
  %tmp91 = load double* @z1d, align 8, !dbg !39
  %tmp92 = fptosi double %tmp91 to i32, !dbg !39
  call void @llvm.dbg.value(metadata !{i32 %tmp92}, i64 0, metadata !38), !dbg !39
  %tmp93 = icmp eq i32 %tmp92, 0, !dbg !39
  br i1 %tmp93, label %bb94, label %bb96, !dbg !39

bb94:                                             ; preds = %bb90
  %tmp95 = add nsw i32 %r.14, -1, !dbg !39
  call void @llvm.dbg.value(metadata !{i32 %tmp95}, i64 0, metadata !15), !dbg !39
  br label %bb96, !dbg !39

bb96:                                             ; preds = %bb94, %bb90
  %r.15 = phi i32 [ %tmp95, %bb94 ], [ %r.14, %bb90 ]
  %tmp97 = load float* @o1f, align 4, !dbg !40
  %tmp98 = fptosi float %tmp97 to i32, !dbg !40
  call void @llvm.dbg.value(metadata !{i32 %tmp98}, i64 0, metadata !38), !dbg !40
  %tmp99 = icmp eq i32 %tmp98, 1, !dbg !40
  br i1 %tmp99, label %bb100, label %bb102, !dbg !40

bb100:                                            ; preds = %bb96
  %tmp101 = add nsw i32 %r.15, -1, !dbg !40
  call void @llvm.dbg.value(metadata !{i32 %tmp101}, i64 0, metadata !15), !dbg !40
  br label %bb102, !dbg !40

bb102:                                            ; preds = %bb100, %bb96
  %r.16 = phi i32 [ %tmp101, %bb100 ], [ %r.15, %bb96 ]
  %tmp103 = load float* @o2f, align 4, !dbg !41
  %tmp104 = fptosi float %tmp103 to i32, !dbg !41
  call void @llvm.dbg.value(metadata !{i32 %tmp104}, i64 0, metadata !38), !dbg !41
  %tmp105 = icmp eq i32 %tmp104, 1, !dbg !41
  br i1 %tmp105, label %bb106, label %bb108, !dbg !41

bb106:                                            ; preds = %bb102
  %tmp107 = add nsw i32 %r.16, -1, !dbg !41
  call void @llvm.dbg.value(metadata !{i32 %tmp107}, i64 0, metadata !15), !dbg !41
  br label %bb108, !dbg !41

bb108:                                            ; preds = %bb106, %bb102
  %r.17 = phi i32 [ %tmp107, %bb106 ], [ %r.16, %bb102 ]
  %tmp109 = load double* @o1d, align 8, !dbg !42
  %tmp110 = fptosi double %tmp109 to i32, !dbg !42
  call void @llvm.dbg.value(metadata !{i32 %tmp110}, i64 0, metadata !38), !dbg !42
  %tmp111 = icmp eq i32 %tmp110, 1, !dbg !42
  br i1 %tmp111, label %bb112, label %bb114, !dbg !42

bb112:                                            ; preds = %bb108
  %tmp113 = add nsw i32 %r.17, -1, !dbg !42
  call void @llvm.dbg.value(metadata !{i32 %tmp113}, i64 0, metadata !15), !dbg !42
  br label %bb114, !dbg !42

bb114:                                            ; preds = %bb112, %bb108
  %r.18 = phi i32 [ %tmp113, %bb112 ], [ %r.17, %bb108 ]
  %tmp115 = load double* @o2d, align 8, !dbg !43
  %tmp116 = fptosi double %tmp115 to i32, !dbg !43
  call void @llvm.dbg.value(metadata !{i32 %tmp116}, i64 0, metadata !38), !dbg !43
  %tmp117 = icmp eq i32 %tmp116, 1, !dbg !43
  br i1 %tmp117, label %bb118, label %bb120, !dbg !43

bb118:                                            ; preds = %bb114
  %tmp119 = add nsw i32 %r.18, -1, !dbg !43
  call void @llvm.dbg.value(metadata !{i32 %tmp119}, i64 0, metadata !15), !dbg !43
  br label %bb120, !dbg !43

bb120:                                            ; preds = %bb118, %bb114
  %r.19 = phi i32 [ %tmp119, %bb118 ], [ %r.18, %bb114 ]
  %tmp121 = load double* @z1d, align 8, !dbg !44
  %tmp122 = fptrunc double %tmp121 to float, !dbg !44
  %tmp123 = fptosi float %tmp122 to i32, !dbg !44
  call void @llvm.dbg.value(metadata !{i32 %tmp123}, i64 0, metadata !38), !dbg !44
  %tmp124 = icmp eq i32 %tmp123, 1, !dbg !44
  br i1 %tmp124, label %bb125, label %bb127, !dbg !44

bb125:                                            ; preds = %bb120
  %tmp126 = add nsw i32 %r.19, -1, !dbg !44
  call void @llvm.dbg.value(metadata !{i32 %tmp126}, i64 0, metadata !15), !dbg !44
  br label %bb127, !dbg !44

bb127:                                            ; preds = %bb125, %bb120
  %r.20 = phi i32 [ %tmp126, %bb125 ], [ %r.19, %bb120 ]
  %tmp128 = load float* @z1f, align 4, !dbg !45
  %tmp129 = fptoui float %tmp128 to i32, !dbg !45
  call void @llvm.dbg.value(metadata !{i32 %tmp129}, i64 0, metadata !46), !dbg !45
  %tmp130 = icmp eq i32 %tmp129, 0, !dbg !45
  br i1 %tmp130, label %bb131, label %bb133, !dbg !45

bb131:                                            ; preds = %bb127
  %tmp132 = add nsw i32 %r.20, -1, !dbg !45
  call void @llvm.dbg.value(metadata !{i32 %tmp132}, i64 0, metadata !15), !dbg !45
  br label %bb133, !dbg !45

bb133:                                            ; preds = %bb131, %bb127
  %r.21 = phi i32 [ %tmp132, %bb131 ], [ %r.20, %bb127 ]
  %tmp134 = load double* @z1d, align 8, !dbg !48
  %tmp135 = fptoui double %tmp134 to i32, !dbg !48
  call void @llvm.dbg.value(metadata !{i32 %tmp135}, i64 0, metadata !46), !dbg !48
  %tmp136 = icmp eq i32 %tmp135, 0, !dbg !48
  br i1 %tmp136, label %bb137, label %bb139, !dbg !48

bb137:                                            ; preds = %bb133
  %tmp138 = add nsw i32 %r.21, -1, !dbg !48
  call void @llvm.dbg.value(metadata !{i32 %tmp138}, i64 0, metadata !15), !dbg !48
  br label %bb139, !dbg !48

bb139:                                            ; preds = %bb137, %bb133
  %r.22 = phi i32 [ %tmp138, %bb137 ], [ %r.21, %bb133 ]
  %tmp140 = load float* @o1f, align 4, !dbg !49
  %tmp141 = fptoui float %tmp140 to i32, !dbg !49
  call void @llvm.dbg.value(metadata !{i32 %tmp141}, i64 0, metadata !46), !dbg !49
  %tmp142 = icmp eq i32 %tmp141, 1, !dbg !49
  br i1 %tmp142, label %bb143, label %bb145, !dbg !49

bb143:                                            ; preds = %bb139
  %tmp144 = add nsw i32 %r.22, -1, !dbg !49
  call void @llvm.dbg.value(metadata !{i32 %tmp144}, i64 0, metadata !15), !dbg !49
  br label %bb145, !dbg !49

bb145:                                            ; preds = %bb143, %bb139
  %r.23 = phi i32 [ %tmp144, %bb143 ], [ %r.22, %bb139 ]
  %tmp146 = load float* @o2f, align 4, !dbg !50
  %tmp147 = fptoui float %tmp146 to i32, !dbg !50
  call void @llvm.dbg.value(metadata !{i32 %tmp147}, i64 0, metadata !46), !dbg !50
  %tmp148 = icmp eq i32 %tmp147, 1, !dbg !50
  br i1 %tmp148, label %bb149, label %bb151, !dbg !50

bb149:                                            ; preds = %bb145
  %tmp150 = add nsw i32 %r.23, -1, !dbg !50
  call void @llvm.dbg.value(metadata !{i32 %tmp150}, i64 0, metadata !15), !dbg !50
  br label %bb151, !dbg !50

bb151:                                            ; preds = %bb149, %bb145
  %r.24 = phi i32 [ %tmp150, %bb149 ], [ %r.23, %bb145 ]
  %tmp152 = load double* @o1d, align 8, !dbg !51
  %tmp153 = fptoui double %tmp152 to i32, !dbg !51
  call void @llvm.dbg.value(metadata !{i32 %tmp153}, i64 0, metadata !46), !dbg !51
  %tmp154 = icmp eq i32 %tmp153, 1, !dbg !51
  br i1 %tmp154, label %bb155, label %bb157, !dbg !51

bb155:                                            ; preds = %bb151
  %tmp156 = add nsw i32 %r.24, -1, !dbg !51
  call void @llvm.dbg.value(metadata !{i32 %tmp156}, i64 0, metadata !15), !dbg !51
  br label %bb157, !dbg !51

bb157:                                            ; preds = %bb155, %bb151
  %r.25 = phi i32 [ %tmp156, %bb155 ], [ %r.24, %bb151 ]
  %tmp158 = load double* @o2d, align 8, !dbg !52
  %tmp159 = fptoui double %tmp158 to i32, !dbg !52
  call void @llvm.dbg.value(metadata !{i32 %tmp159}, i64 0, metadata !46), !dbg !52
  %tmp160 = icmp eq i32 %tmp159, 1, !dbg !52
  br i1 %tmp160, label %bb161, label %bb163, !dbg !52

bb161:                                            ; preds = %bb157
  %tmp162 = add nsw i32 %r.25, -1, !dbg !52
  call void @llvm.dbg.value(metadata !{i32 %tmp162}, i64 0, metadata !15), !dbg !52
  br label %bb163, !dbg !52

bb163:                                            ; preds = %bb161, %bb157
  %r.26 = phi i32 [ %tmp162, %bb161 ], [ %r.25, %bb157 ]
  %tmp164 = load double* @z1d, align 8, !dbg !53
  %tmp165 = fptrunc double %tmp164 to float, !dbg !53
  %tmp166 = fptoui float %tmp165 to i32, !dbg !53
  call void @llvm.dbg.value(metadata !{i32 %tmp166}, i64 0, metadata !46), !dbg !53
  %tmp167 = icmp eq i32 %tmp166, 1, !dbg !53
  br i1 %tmp167, label %bb168, label %bb170, !dbg !53

bb168:                                            ; preds = %bb163
  %tmp169 = add nsw i32 %r.26, -1, !dbg !53
  call void @llvm.dbg.value(metadata !{i32 %tmp169}, i64 0, metadata !15), !dbg !53
  br label %bb170, !dbg !53

bb170:                                            ; preds = %bb168, %bb163
  %r.27 = phi i32 [ %tmp169, %bb168 ], [ %r.26, %bb163 ]
  ret i32 %r.27, !dbg !54
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !4, !5, !6, !8, !9}
!llvm.dbg.sp = !{!10}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"o1f", metadata !"o1f", metadata !"", metadata !2, i32 2, metadata !3, i32 0, i32 1, float* @o1f} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"float2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"float2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589860, metadata !1, metadata !"float", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!4 = metadata !{i32 589876, i32 0, metadata !1, metadata !"o2f", metadata !"o2f", metadata !"", metadata !2, i32 3, metadata !3, i32 0, i32 1, float* @o2f} ; [ DW_TAG_variable ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"z1f", metadata !"z1f", metadata !"", metadata !2, i32 4, metadata !3, i32 0, i32 1, float* @z1f} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589876, i32 0, metadata !1, metadata !"z1d", metadata !"z1d", metadata !"", metadata !2, i32 5, metadata !7, i32 0, i32 1, double* @z1d} ; [ DW_TAG_variable ]
!7 = metadata !{i32 589860, metadata !1, metadata !"double", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!8 = metadata !{i32 589876, i32 0, metadata !1, metadata !"o1d", metadata !"o1d", metadata !"", metadata !2, i32 6, metadata !7, i32 0, i32 1, double* @o1d} ; [ DW_TAG_variable ]
!9 = metadata !{i32 589876, i32 0, metadata !1, metadata !"o2d", metadata !"o2d", metadata !"", metadata !2, i32 7, metadata !7, i32 0, i32 1, double* @o2d} ; [ DW_TAG_variable ]
!10 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 9, metadata !11, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!11 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !12, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!12 = metadata !{metadata !13}
!13 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!14 = metadata !{i32 28}
!15 = metadata !{i32 590080, metadata !16, metadata !"r", metadata !2, i32 15, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!16 = metadata !{i32 589835, metadata !10, i32 9, i32 12, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!17 = metadata !{i32 15, i32 13, metadata !16, null}
!18 = metadata !{i32 16, i32 3, metadata !16, null}
!19 = metadata !{i32 590080, metadata !16, metadata !"c", metadata !2, i32 10, metadata !20, i32 0} ; [ DW_TAG_auto_variable ]
!20 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!21 = metadata !{i32 27}
!22 = metadata !{i32 17, i32 3, metadata !16, null}
!23 = metadata !{i32 18, i32 3, metadata !16, null}
!24 = metadata !{i32 19, i32 3, metadata !16, null}
!25 = metadata !{i32 20, i32 3, metadata !16, null}
!26 = metadata !{i32 21, i32 3, metadata !16, null}
!27 = metadata !{i32 22, i32 3, metadata !16, null}
!28 = metadata !{i32 24, i32 3, metadata !16, null}
!29 = metadata !{i32 590080, metadata !16, metadata !"s", metadata !2, i32 11, metadata !30, i32 0} ; [ DW_TAG_auto_variable ]
!30 = metadata !{i32 589860, metadata !1, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!31 = metadata !{i32 25, i32 3, metadata !16, null}
!32 = metadata !{i32 26, i32 3, metadata !16, null}
!33 = metadata !{i32 27, i32 3, metadata !16, null}
!34 = metadata !{i32 28, i32 3, metadata !16, null}
!35 = metadata !{i32 29, i32 3, metadata !16, null}
!36 = metadata !{i32 30, i32 3, metadata !16, null}
!37 = metadata !{i32 32, i32 3, metadata !16, null}
!38 = metadata !{i32 590080, metadata !16, metadata !"i", metadata !2, i32 12, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!39 = metadata !{i32 33, i32 3, metadata !16, null}
!40 = metadata !{i32 34, i32 3, metadata !16, null}
!41 = metadata !{i32 35, i32 3, metadata !16, null}
!42 = metadata !{i32 36, i32 3, metadata !16, null}
!43 = metadata !{i32 37, i32 3, metadata !16, null}
!44 = metadata !{i32 38, i32 3, metadata !16, null}
!45 = metadata !{i32 40, i32 3, metadata !16, null}
!46 = metadata !{i32 590080, metadata !16, metadata !"u", metadata !2, i32 13, metadata !47, i32 0} ; [ DW_TAG_auto_variable ]
!47 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!48 = metadata !{i32 41, i32 3, metadata !16, null}
!49 = metadata !{i32 42, i32 3, metadata !16, null}
!50 = metadata !{i32 43, i32 3, metadata !16, null}
!51 = metadata !{i32 44, i32 3, metadata !16, null}
!52 = metadata !{i32 45, i32 3, metadata !16, null}
!53 = metadata !{i32 46, i32 3, metadata !16, null}
!54 = metadata !{i32 48, i32 3, metadata !16, null}
