// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "cplus-dem.i";
.global _current_demangling_style;
.data;
.align 2
_current_demangling_style:	.long	256
_cplus_markers:	.byte	36
	.byte	46
	.byte	36
	.byte	0
_char_str:.space 4;
.text;
.align 2
.global _set_cplus_marker_for_demangling;
.type _set_cplus_marker_for_demangling, STT_FUNC;
_set_cplus_marker_for_demangling:
	LINK 0;
	P2.L  = _cplus_markers; P2.H  = _cplus_markers;
	B [P2 ] =R0 ;
	UNLINK;
	rts;


.align 2
L$LC$0:
.dw	0x776e;
.db	0x00;
.align 2
L$LC$1:
.dw	0x6e20;
.dw	0x7765;
.db	0x00;
.align 2
L$LC$2:
.dw	0x6c64;
.db	0x00;
.align 2
L$LC$3:
.dw	0x6420;
.dw	0x6c65;
.dw	0x7465;
.db	0x65;
.db	0x00;
.align 2
L$LC$4:
.dw	0x656e;
.db	0x77;
.db	0x00;
.align 2
L$LC$5:
.dw	0x6564;
.dw	0x656c;
.dw	0x6574;
.db	0x00;
.align 2
L$LC$6:
.dw	0x6e76;
.db	0x00;
.align 2
L$LC$7:
.dw	0x6e20;
.dw	0x7765;
.dw	0x5b20;
.db	0x5d;
.db	0x00;
.align 2
L$LC$8:
.dw	0x6476;
.db	0x00;
.align 2
L$LC$9:
.dw	0x6420;
.dw	0x6c65;
.dw	0x7465;
.dw	0x2065;
.dw	0x5d5b;
.db	0x00;
.align 2
L$LC$10:
.dw	0x7361;
.db	0x00;
.align 2
L$LC$11:
.db	0x3d;
.db	0x00;
.align 2
L$LC$12:
.dw	0x656e;
.db	0x00;
.align 2
L$LC$13:
.dw	0x3d21;
.db	0x00;
.align 2
L$LC$14:
.dw	0x7165;
.db	0x00;
.align 2
L$LC$15:
.dw	0x3d3d;
.db	0x00;
.align 2
L$LC$16:
.dw	0x6567;
.db	0x00;
.align 2
L$LC$17:
.dw	0x3d3e;
.db	0x00;
.align 2
L$LC$18:
.dw	0x7467;
.db	0x00;
.align 2
L$LC$19:
.db	0x3e;
.db	0x00;
.align 2
L$LC$20:
.dw	0x656c;
.db	0x00;
.align 2
L$LC$21:
.dw	0x3d3c;
.db	0x00;
.align 2
L$LC$22:
.dw	0x746c;
.db	0x00;
.align 2
L$LC$23:
.db	0x3c;
.db	0x00;
.align 2
L$LC$24:
.dw	0x6c70;
.dw	0x7375;
.db	0x00;
.align 2
L$LC$25:
.db	0x2b;
.db	0x00;
.align 2
L$LC$26:
.dw	0x6c70;
.db	0x00;
.align 2
L$LC$27:
.dw	0x7061;
.db	0x6c;
.db	0x00;
.align 2
L$LC$28:
.dw	0x3d2b;
.db	0x00;
.align 2
L$LC$29:
.dw	0x696d;
.dw	0x756e;
.db	0x73;
.db	0x00;
.align 2
L$LC$30:
.db	0x2d;
.db	0x00;
.align 2
L$LC$31:
.dw	0x696d;
.db	0x00;
.align 2
L$LC$32:
.dw	0x6d61;
.db	0x69;
.db	0x00;
.align 2
L$LC$33:
.dw	0x3d2d;
.db	0x00;
.align 2
L$LC$34:
.dw	0x756d;
.dw	0x746c;
.db	0x00;
.align 2
L$LC$35:
.db	0x2a;
.db	0x00;
.align 2
L$LC$36:
.dw	0x6c6d;
.db	0x00;
.align 2
L$LC$37:
.dw	0x6d61;
.db	0x75;
.db	0x00;
.align 2
L$LC$38:
.dw	0x3d2a;
.db	0x00;
.align 2
L$LC$39:
.dw	0x6d61;
.db	0x6c;
.db	0x00;
.align 2
L$LC$40:
.dw	0x6f63;
.dw	0x766e;
.dw	0x7265;
.db	0x74;
.db	0x00;
.align 2
L$LC$41:
.dw	0x656e;
.dw	0x6167;
.dw	0x6574;
.db	0x00;
.align 2
L$LC$42:
.dw	0x7274;
.dw	0x6e75;
.dw	0x5f63;
.dw	0x6f6d;
.db	0x64;
.db	0x00;
.align 2
L$LC$43:
.db	0x25;
.db	0x00;
.align 2
L$LC$44:
.dw	0x646d;
.db	0x00;
.align 2
L$LC$45:
.dw	0x6d61;
.db	0x64;
.db	0x00;
.align 2
L$LC$46:
.dw	0x3d25;
.db	0x00;
.align 2
L$LC$47:
.dw	0x7274;
.dw	0x6e75;
.dw	0x5f63;
.dw	0x6964;
.db	0x76;
.db	0x00;
.align 2
L$LC$48:
.db	0x2f;
.db	0x00;
.align 2
L$LC$49:
.dw	0x7664;
.db	0x00;
.align 2
L$LC$50:
.dw	0x6461;
.db	0x76;
.db	0x00;
.align 2
L$LC$51:
.dw	0x3d2f;
.db	0x00;
.align 2
L$LC$52:
.dw	0x7274;
.dw	0x7475;
.dw	0x5f68;
.dw	0x6e61;
.dw	0x6964;
.db	0x66;
.db	0x00;
.align 2
L$LC$53:
.dw	0x2626;
.db	0x00;
.align 2
L$LC$54:
.dw	0x6161;
.db	0x00;
.align 2
L$LC$55:
.dw	0x7274;
.dw	0x7475;
.dw	0x5f68;
.dw	0x726f;
.dw	0x6669;
.db	0x00;
.align 2
L$LC$56:
.dw	0x7c7c;
.db	0x00;
.align 2
L$LC$57:
.dw	0x6f6f;
.db	0x00;
.align 2
L$LC$58:
.dw	0x7274;
.dw	0x7475;
.dw	0x5f68;
.dw	0x6f6e;
.db	0x74;
.db	0x00;
.align 2
L$LC$59:
.db	0x21;
.db	0x00;
.align 2
L$LC$60:
.dw	0x746e;
.db	0x00;
.align 2
L$LC$61:
.dw	0x6f70;
.dw	0x7473;
.dw	0x6e69;
.dw	0x7263;
.dw	0x6d65;
.dw	0x6e65;
.db	0x74;
.db	0x00;
.align 2
L$LC$62:
.dw	0x2b2b;
.db	0x00;
.align 2
L$LC$63:
.dw	0x7070;
.db	0x00;
.align 2
L$LC$64:
.dw	0x6f70;
.dw	0x7473;
.dw	0x6564;
.dw	0x7263;
.dw	0x6d65;
.dw	0x6e65;
.db	0x74;
.db	0x00;
.align 2
L$LC$65:
.dw	0x2d2d;
.db	0x00;
.align 2
L$LC$66:
.dw	0x6d6d;
.db	0x00;
.align 2
L$LC$67:
.dw	0x6962;
.dw	0x5f74;
.dw	0x6f69;
.db	0x72;
.db	0x00;
.align 2
L$LC$68:
.db	0x7c;
.db	0x00;
.align 2
L$LC$69:
.dw	0x726f;
.db	0x00;
.align 2
L$LC$70:
.dw	0x6f61;
.db	0x72;
.db	0x00;
.align 2
L$LC$71:
.dw	0x3d7c;
.db	0x00;
.align 2
L$LC$72:
.dw	0x6962;
.dw	0x5f74;
.dw	0x6f78;
.db	0x72;
.db	0x00;
.align 2
L$LC$73:
.db	0x5e;
.db	0x00;
.align 2
L$LC$74:
.dw	0x7265;
.db	0x00;
.align 2
L$LC$75:
.dw	0x6561;
.db	0x72;
.db	0x00;
.align 2
L$LC$76:
.dw	0x3d5e;
.db	0x00;
.align 2
L$LC$77:
.dw	0x6962;
.dw	0x5f74;
.dw	0x6e61;
.db	0x64;
.db	0x00;
.align 2
L$LC$78:
.db	0x26;
.db	0x00;
.align 2
L$LC$79:
.dw	0x6461;
.db	0x00;
.align 2
L$LC$80:
.dw	0x6161;
.db	0x64;
.db	0x00;
.align 2
L$LC$81:
.dw	0x3d26;
.db	0x00;
.align 2
L$LC$82:
.dw	0x6962;
.dw	0x5f74;
.dw	0x6f6e;
.db	0x74;
.db	0x00;
.align 2
L$LC$83:
.db	0x7e;
.db	0x00;
.align 2
L$LC$84:
.dw	0x6f63;
.db	0x00;
.align 2
L$LC$85:
.dw	0x6163;
.dw	0x6c6c;
.db	0x00;
.align 2
L$LC$86:
.dw	0x2928;
.db	0x00;
.align 2
L$LC$87:
.dw	0x6c63;
.db	0x00;
.align 2
L$LC$88:
.dw	0x6c61;
.dw	0x6873;
.dw	0x6669;
.db	0x74;
.db	0x00;
.align 2
L$LC$89:
.dw	0x3c3c;
.db	0x00;
.align 2
L$LC$90:
.dw	0x736c;
.db	0x00;
.align 2
L$LC$91:
.dw	0x6c61;
.db	0x73;
.db	0x00;
.align 2
L$LC$92:
.dw	0x3c3c;
.db	0x3d;
.db	0x00;
.align 2
L$LC$93:
.dw	0x7261;
.dw	0x6873;
.dw	0x6669;
.db	0x74;
.db	0x00;
.align 2
L$LC$94:
.dw	0x3e3e;
.db	0x00;
.align 2
L$LC$95:
.dw	0x7372;
.db	0x00;
.align 2
L$LC$96:
.dw	0x7261;
.db	0x73;
.db	0x00;
.align 2
L$LC$97:
.dw	0x3e3e;
.db	0x3d;
.db	0x00;
.align 2
L$LC$98:
.dw	0x6f63;
.dw	0x706d;
.dw	0x6e6f;
.dw	0x6e65;
.db	0x74;
.db	0x00;
.align 2
L$LC$99:
.dw	0x3e2d;
.db	0x00;
.align 2
L$LC$100:
.dw	0x7470;
.db	0x00;
.align 2
L$LC$101:
.dw	0x6672;
.db	0x00;
.align 2
L$LC$102:
.dw	0x6e69;
.dw	0x6964;
.dw	0x6572;
.dw	0x7463;
.db	0x00;
.align 2
L$LC$103:
.dw	0x656d;
.dw	0x6874;
.dw	0x646f;
.dw	0x635f;
.dw	0x6c61;
.db	0x6c;
.db	0x00;
.align 2
L$LC$104:
.dw	0x3e2d;
.dw	0x2928;
.db	0x00;
.align 2
L$LC$105:
.dw	0x6461;
.dw	0x7264;
.db	0x00;
.align 2
L$LC$106:
.dw	0x7261;
.dw	0x6172;
.db	0x79;
.db	0x00;
.align 2
L$LC$107:
.dw	0x5d5b;
.db	0x00;
.align 2
L$LC$108:
.dw	0x6376;
.db	0x00;
.align 2
L$LC$109:
.dw	0x6f63;
.dw	0x706d;
.dw	0x756f;
.dw	0x646e;
.db	0x00;
.align 2
L$LC$110:
.dw	0x202c;
.db	0x00;
.align 2
L$LC$111:
.dw	0x6d63;
.db	0x00;
.align 2
L$LC$112:
.dw	0x6f63;
.dw	0x646e;
.db	0x00;
.align 2
L$LC$113:
.dw	0x3a3f;
.db	0x00;
.align 2
L$LC$114:
.dw	0x6e63;
.db	0x00;
.align 2
L$LC$115:
.dw	0x616d;
.db	0x78;
.db	0x00;
.align 2
L$LC$116:
.dw	0x3f3e;
.db	0x00;
.align 2
L$LC$117:
.dw	0x786d;
.db	0x00;
.align 2
L$LC$118:
.dw	0x696d;
.db	0x6e;
.db	0x00;
.align 2
L$LC$119:
.dw	0x3f3c;
.db	0x00;
.align 2
L$LC$120:
.dw	0x6e6d;
.db	0x00;
.align 2
L$LC$121:
.dw	0x6f6e;
.db	0x70;
.db	0x00;
.align 2
L$LC$122:
.db	0x00;
.align 2
L$LC$123:
.dw	0x6d72;
.db	0x00;
.align 2
L$LC$124:
.dw	0x3e2d;
.db	0x2a;
.db	0x00;
.align 2
L$LC$125:
.dw	0x7a73;
.db	0x00;
.align 2
L$LC$126:
.dw	0x6973;
.dw	0x657a;
.dw	0x666f;
.db	0x20;
.db	0x00;
.align 2
_optable:	.long	L$LC$0
	.long	L$LC$1
	.long	2
	.long	L$LC$2
	.long	L$LC$3
	.long	2
	.long	L$LC$4
	.long	L$LC$1
	.long	0
	.long	L$LC$5
	.long	L$LC$3
	.long	0
	.long	L$LC$6
	.long	L$LC$7
	.long	2
	.long	L$LC$8
	.long	L$LC$9
	.long	2
	.long	L$LC$10
	.long	L$LC$11
	.long	2
	.long	L$LC$12
	.long	L$LC$13
	.long	2
	.long	L$LC$14
	.long	L$LC$15
	.long	2
	.long	L$LC$16
	.long	L$LC$17
	.long	2
	.long	L$LC$18
	.long	L$LC$19
	.long	2
	.long	L$LC$20
	.long	L$LC$21
	.long	2
	.long	L$LC$22
	.long	L$LC$23
	.long	2
	.long	L$LC$24
	.long	L$LC$25
	.long	0
	.long	L$LC$26
	.long	L$LC$25
	.long	2
	.long	L$LC$27
	.long	L$LC$28
	.long	2
	.long	L$LC$29
	.long	L$LC$30
	.long	0
	.long	L$LC$31
	.long	L$LC$30
	.long	2
	.long	L$LC$32
	.long	L$LC$33
	.long	2
	.long	L$LC$34
	.long	L$LC$35
	.long	0
	.long	L$LC$36
	.long	L$LC$35
	.long	2
	.long	L$LC$37
	.long	L$LC$38
	.long	2
	.long	L$LC$39
	.long	L$LC$38
	.long	2
	.long	L$LC$40
	.long	L$LC$25
	.long	0
	.long	L$LC$41
	.long	L$LC$30
	.long	0
	.long	L$LC$42
	.long	L$LC$43
	.long	0
	.long	L$LC$44
	.long	L$LC$43
	.long	2
	.long	L$LC$45
	.long	L$LC$46
	.long	2
	.long	L$LC$47
	.long	L$LC$48
	.long	0
	.long	L$LC$49
	.long	L$LC$48
	.long	2
	.long	L$LC$50
	.long	L$LC$51
	.long	2
	.long	L$LC$52
	.long	L$LC$53
	.long	0
	.long	L$LC$54
	.long	L$LC$53
	.long	2
	.long	L$LC$55
	.long	L$LC$56
	.long	0
	.long	L$LC$57
	.long	L$LC$56
	.long	2
	.long	L$LC$58
	.long	L$LC$59
	.long	0
	.long	L$LC$60
	.long	L$LC$59
	.long	2
	.long	L$LC$61
	.long	L$LC$62
	.long	0
	.long	L$LC$63
	.long	L$LC$62
	.long	2
	.long	L$LC$64
	.long	L$LC$65
	.long	0
	.long	L$LC$66
	.long	L$LC$65
	.long	2
	.long	L$LC$67
	.long	L$LC$68
	.long	0
	.long	L$LC$69
	.long	L$LC$68
	.long	2
	.long	L$LC$70
	.long	L$LC$71
	.long	2
	.long	L$LC$72
	.long	L$LC$73
	.long	0
	.long	L$LC$74
	.long	L$LC$73
	.long	2
	.long	L$LC$75
	.long	L$LC$76
	.long	2
	.long	L$LC$77
	.long	L$LC$78
	.long	0
	.long	L$LC$79
	.long	L$LC$78
	.long	2
	.long	L$LC$80
	.long	L$LC$81
	.long	2
	.long	L$LC$82
	.long	L$LC$83
	.long	0
	.long	L$LC$84
	.long	L$LC$83
	.long	2
	.long	L$LC$85
	.long	L$LC$86
	.long	0
	.long	L$LC$87
	.long	L$LC$86
	.long	2
	.long	L$LC$88
	.long	L$LC$89
	.long	0
	.long	L$LC$90
	.long	L$LC$89
	.long	2
	.long	L$LC$91
	.long	L$LC$92
	.long	2
	.long	L$LC$93
	.long	L$LC$94
	.long	0
	.long	L$LC$95
	.long	L$LC$94
	.long	2
	.long	L$LC$96
	.long	L$LC$97
	.long	2
	.long	L$LC$98
	.long	L$LC$99
	.long	0
	.long	L$LC$100
	.long	L$LC$99
	.long	2
	.long	L$LC$101
	.long	L$LC$99
	.long	2
	.long	L$LC$102
	.long	L$LC$35
	.long	0
	.long	L$LC$103
	.long	L$LC$104
	.long	0
	.long	L$LC$105
	.long	L$LC$78
	.long	0
	.long	L$LC$106
	.long	L$LC$107
	.long	0
	.long	L$LC$108
	.long	L$LC$107
	.long	2
	.long	L$LC$109
	.long	L$LC$110
	.long	0
	.long	L$LC$111
	.long	L$LC$110
	.long	2
	.long	L$LC$112
	.long	L$LC$113
	.long	0
	.long	L$LC$114
	.long	L$LC$113
	.long	2
	.long	L$LC$115
	.long	L$LC$116
	.long	0
	.long	L$LC$117
	.long	L$LC$116
	.long	2
	.long	L$LC$118
	.long	L$LC$119
	.long	0
	.long	L$LC$120
	.long	L$LC$119
	.long	2
	.long	L$LC$121
	.long	L$LC$122
	.long	0
	.long	L$LC$123
	.long	L$LC$124
	.long	2
	.long	L$LC$125
	.long	L$LC$126
	.long	2
.align 2
L$LC$127:
.dw	0x6f6e;
.dw	0x656e;
.db	0x00;
.align 2
L$LC$128:
.dw	0x6544;
.dw	0x616d;
.dw	0x676e;
.dw	0x696c;
.dw	0x676e;
.dw	0x6420;
.dw	0x7369;
.dw	0x6261;
.dw	0x656c;
.db	0x64;
.db	0x00;
.align 2
L$LC$129:
.dw	0x7561;
.dw	0x6f74;
.db	0x00;
.align 2
L$LC$130:
.dw	0x7541;
.dw	0x6f74;
.dw	0x616d;
.dw	0x6974;
.dw	0x2063;
.dw	0x6573;
.dw	0x656c;
.dw	0x7463;
.dw	0x6f69;
.dw	0x206e;
.dw	0x6162;
.dw	0x6573;
.dw	0x2064;
.dw	0x6e6f;
.dw	0x6520;
.dw	0x6578;
.dw	0x7563;
.dw	0x6174;
.dw	0x6c62;
.db	0x65;
.db	0x00;
.align 2
L$LC$131:
.dw	0x6e67;
.db	0x75;
.db	0x00;
.align 2
L$LC$132:
.dw	0x4e47;
.dw	0x2055;
.dw	0x6728;
.dw	0x2b2b;
.dw	0x2029;
.dw	0x7473;
.dw	0x6c79;
.dw	0x2065;
.dw	0x6564;
.dw	0x616d;
.dw	0x676e;
.dw	0x696c;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$133:
.dw	0x756c;
.dw	0x6963;
.db	0x64;
.db	0x00;
.align 2
L$LC$134:
.dw	0x754c;
.dw	0x6963;
.dw	0x2064;
.dw	0x6c28;
.dw	0x6363;
.dw	0x2029;
.dw	0x7473;
.dw	0x6c79;
.dw	0x2065;
.dw	0x6564;
.dw	0x616d;
.dw	0x676e;
.dw	0x696c;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$135:
.dw	0x7261;
.db	0x6d;
.db	0x00;
.align 2
L$LC$136:
.dw	0x5241;
.dw	0x204d;
.dw	0x7473;
.dw	0x6c79;
.dw	0x2065;
.dw	0x6564;
.dw	0x616d;
.dw	0x676e;
.dw	0x696c;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$137:
.dw	0x7068;
.db	0x00;
.align 2
L$LC$138:
.dw	0x5048;
.dw	0x2820;
.dw	0x4361;
.dw	0x2943;
.dw	0x7320;
.dw	0x7974;
.dw	0x656c;
.dw	0x6420;
.dw	0x6d65;
.dw	0x6e61;
.dw	0x6c67;
.dw	0x6e69;
.db	0x67;
.db	0x00;
.align 2
L$LC$139:
.dw	0x6465;
.db	0x67;
.db	0x00;
.align 2
L$LC$140:
.dw	0x4445;
.dw	0x2047;
.dw	0x7473;
.dw	0x6c79;
.dw	0x2065;
.dw	0x6564;
.dw	0x616d;
.dw	0x676e;
.dw	0x696c;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$141:
.dw	0x6e67;
.dw	0x2d75;
.dw	0x3376;
.db	0x00;
.align 2
L$LC$142:
.dw	0x4e47;
.dw	0x2055;
.dw	0x6728;
.dw	0x2b2b;
.dw	0x2029;
.dw	0x3356;
.dw	0x4120;
.dw	0x4942;
.dw	0x732d;
.dw	0x7974;
.dw	0x656c;
.dw	0x6420;
.dw	0x6d65;
.dw	0x6e61;
.dw	0x6c67;
.dw	0x6e69;
.db	0x67;
.db	0x00;
.align 2
L$LC$143:
.dw	0x616a;
.dw	0x6176;
.db	0x00;
.align 2
L$LC$144:
.dw	0x614a;
.dw	0x6176;
.dw	0x7320;
.dw	0x7974;
.dw	0x656c;
.dw	0x6420;
.dw	0x6d65;
.dw	0x6e61;
.dw	0x6c67;
.dw	0x6e69;
.db	0x67;
.db	0x00;
.align 2
L$LC$145:
.dw	0x6e67;
.dw	0x7461;
.db	0x00;
.align 2
L$LC$146:
.dw	0x4e47;
.dw	0x5441;
.dw	0x7320;
.dw	0x7974;
.dw	0x656c;
.dw	0x6420;
.dw	0x6d65;
.dw	0x6e61;
.dw	0x6c67;
.dw	0x6e69;
.db	0x67;
.db	0x00;
.global _libiberty_demanglers;
.align 2
_libiberty_demanglers:	.long	L$LC$127
	.long	-1
	.long	L$LC$128
	.long	L$LC$129
	.long	256
	.long	L$LC$130
	.long	L$LC$131
	.long	512
	.long	L$LC$132
	.long	L$LC$133
	.long	1024
	.long	L$LC$134
	.long	L$LC$135
	.long	2048
	.long	L$LC$136
	.long	L$LC$137
	.long	4096
	.long	L$LC$138
	.long	L$LC$139
	.long	8192
	.long	L$LC$140
	.long	L$LC$141
	.long	16384
	.long	L$LC$142
	.long	L$LC$143
	.long	4
	.long	L$LC$144
	.long	L$LC$145
	.long	32768
	.long	L$LC$146
	.long	0
	.long	0
	.long	0
.align 2
.type _consume_count, STT_FUNC;
_consume_count:
	LINK 4;
	[--sp] = ( r7:6, p5:3 );
	P3  =R0 ;
	P5  = 0 (X);
	R1  =[P3 ];
	P2  =R1 ;
	R1  = B [P2 ] (Z);
	P2  =R1 ;
	P2  =P2 +P2 ;
	R1  =P2 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R1 ; //immed->Dreg 
	P2  =R0 ;
	R1  = W[P2 ] (Z);
	R0  = 4 (X);
	R0  =R1 &R0 ;
	R1  = -1 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2;
	P4.L  = __sch_istable; P4.H  = __sch_istable;
	R6  = 4 (X);
L$L$12:
	P5  =P5 +(P5 <<2);
	P5  =P5 +P5 ;
	R0  =P5 ;
	R1  = 10 (X);
	call ___modsi3;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$7;
	P1  =[P3 ];
	R0  = B [P1 ] (Z);
	P2  =R0 ;
	P2  =P4 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R6  =R0 &R6 ;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$17;
	R1  = 4 (X);
L$L$11:
	P1 +=1;
	[P3 ] =P1 ;
	R0  = B [P1 ] (Z);
	P2  =R0 ;
	P2  =P4 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$11;
L$L$17:
	R1  = -1 (X);
	jump.s L$L$2;
L$L$7:
	R1  =[P3 ];
	P2  =R1 ;
	R1 +=1;
	R0  = B [P2 ++] (X);
	P2  =R0 ;
	P5 =P5 +P2 ;
	P5 +=-48;
	[P3 ] =R1 ;
	P2  =R1 ;
	R1  = B [P2 ] (Z);
	P2  =R1 ;
	P2  =P2 +P2 ;
	R1  =P2 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R1 ; //immed->Dreg 
	P2  =R0 ;
	R1  = W[P2 ] (Z);
	R1  =R1 &R6 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$12;
	R1  = -1 (X);
	R0  =P5 ;
	R1  =max(R0 ,R1 );
L$L$2:
	R0  =R1 ;
	( r7:6, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _consume_count_with_underscores, STT_FUNC;
_consume_count_with_underscores:
	LINK 4;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R2  =[P5 ];
	P1  =R2 ;
	R0  = B [P1 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$20;
	R2 +=1;
	[P5 ] =R2 ;
	P1  =R2 ;
	R2  = B [P1 ] (Z);
	P2  =R2 ;
	P2  =P2 +P2 ;
	R2  =P2 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R2 ; //immed->Dreg 
	P1  =R0 ;
	R2  = W[P1 ] (Z);
	R1  = 4 (X);
	R1  =R2 &R1 ;
	R0  = -1 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$19;
	R0  =P5 ;
	call _consume_count;
	R1  =R0 ;
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	R0  = -1 (X);
	P1  = 95 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$19;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	jump.s L$L$23;
L$L$20:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P2 +=-48;
	R1  =P2 ;
	R1  = R1.B  (Z);
	P2  =R1 ;
	R0  = -1 (X);
	P1  = 9 (X);
	cc =P2 <=P1  (iu);
	if cc jump 6; jump.l L$L$19;
	P2  =[P5 ];
	R1  = B [P2 ++] (X);
	R1 +=-48;
	[P5 ] =P2 ;
L$L$23:
	R0  =R1 ;
L$L$19:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _code_for_qualifier, STT_FUNC;
_code_for_qualifier:
	LINK 0;
	R1  = 2 (X);
	R2  = 86 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$25;
	cc =R0 <=R2 ;
	if cc jump 6; jump.l L$L$32;
	R1  = 67 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$27;
	jump.s L$L$26;
L$L$32:
	R2  = 117 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$29;
	jump.s L$L$26;
L$L$27:
	R1  = 1 (X);
	jump.s L$L$25;
L$L$29:
	R1  = 4 (X);
	jump.s L$L$25;
L$L$26:
	call _abort;
L$L$25:
	R0  =R1 ;
	UNLINK;
	rts;


.align 2
L$LC$147:
.dw	0x6f63;
.dw	0x736e;
.db	0x74;
.db	0x00;
.align 2
L$LC$148:
.dw	0x6f76;
.dw	0x616c;
.dw	0x6974;
.dw	0x656c;
.db	0x00;
.align 2
L$LC$149:
.dw	0x5f5f;
.dw	0x6572;
.dw	0x7473;
.dw	0x6972;
.dw	0x7463;
.db	0x00;
.align 2
L$LC$150:
.dw	0x6f63;
.dw	0x736e;
.dw	0x2074;
.dw	0x6f76;
.dw	0x616c;
.dw	0x6974;
.dw	0x656c;
.db	0x00;
.align 2
L$LC$151:
.dw	0x6f63;
.dw	0x736e;
.dw	0x2074;
.dw	0x5f5f;
.dw	0x6572;
.dw	0x7473;
.dw	0x6972;
.dw	0x7463;
.db	0x00;
.align 2
L$LC$152:
.dw	0x6f76;
.dw	0x616c;
.dw	0x6974;
.dw	0x656c;
.dw	0x5f20;
.dw	0x725f;
.dw	0x7365;
.dw	0x7274;
.dw	0x6369;
.db	0x74;
.db	0x00;
.align 2
L$LC$153:
.dw	0x6f63;
.dw	0x736e;
.dw	0x2074;
.dw	0x6f76;
.dw	0x616c;
.dw	0x6974;
.dw	0x656c;
.dw	0x5f20;
.dw	0x725f;
.dw	0x7365;
.dw	0x7274;
.dw	0x6369;
.db	0x74;
.db	0x00;
.align 2
.type _qualifier_string, STT_FUNC;
_qualifier_string:
	LINK 0;
	P2  = 7 (X);
	P1  =R0 ;
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$34;
P2.L =L$L$44;
P2.H =L$L$44;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$44:
	.dd		L$L$35;
	.dd		L$L$36;
	.dd		L$L$37;
	.dd		L$L$39;
	.dd		L$L$38;
	.dd		L$L$40;
	.dd		L$L$41;
	.dd		L$L$42;
L$L$35:
	R0.L  = L$LC$122; R0.H  = L$LC$122;
	jump.s L$L$33;
L$L$36:
	R0.L  = L$LC$147; R0.H  = L$LC$147;
	jump.s L$L$33;
L$L$37:
	R0.L  = L$LC$148; R0.H  = L$LC$148;
	jump.s L$L$33;
L$L$38:
	R0.L  = L$LC$149; R0.H  = L$LC$149;
	jump.s L$L$33;
L$L$39:
	R0.L  = L$LC$150; R0.H  = L$LC$150;
	jump.s L$L$33;
L$L$40:
	R0.L  = L$LC$151; R0.H  = L$LC$151;
	jump.s L$L$33;
L$L$41:
	R0.L  = L$LC$152; R0.H  = L$LC$152;
	jump.s L$L$33;
L$L$42:
	R0.L  = L$LC$153; R0.H  = L$LC$153;
	jump.s L$L$33;
L$L$34:
	call _abort;
L$L$33:
	UNLINK;
	rts;


.align 2
.type _demangle_qualifier, STT_FUNC;
_demangle_qualifier:
	LINK 0;
	call _code_for_qualifier;
	call _qualifier_string;
	UNLINK;
	rts;


.align 2
.global _cplus_demangle_opname;
.type _cplus_demangle_opname, STT_FUNC;
_cplus_demangle_opname:
	LINK 0;
	UNLINK;
	rts;


.align 2
.global _cplus_mangle_opname;
.type _cplus_mangle_opname, STT_FUNC;
_cplus_mangle_opname:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	R4  =R0 ;
	R5  =R1 ;
	call _strlen;
	R6  =R0 ;
	P4  = 0 (X);
	P2  = 78 (X);
	cc =P4 <=P2  (iu);
	if cc jump 6; jump.l L$L$55;
	R0  = 2 (X);
	R5  =R5 &R0 ;
L$L$53:
	P3  =P4 +(P4 <<1);
	P3  =P3 <<2;
	P2.L  = _optable; P2.H  = _optable;
	P2 =P2 +P3 ; //immed->Preg 
	P3  =P2 ;
	P5  = 4 (X);
	P5 =P5 +P2 ; //immed->Preg 
	R0  =[P5 ];
	call _strlen;
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$50;
	R0  =[P3 +8];
	R1  = 2 (X);
	R1  =R0 &R1 ;
	cc =R5 ==R1 ;
	if cc jump 6; jump.l L$L$50;
	R2  =R6 ;
	R0  =[P5 ];
	R1  =R4 ;
	call _memcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$50;
	R0  =[P3 ];
	jump.s L$L$47;
L$L$50:
	P4 +=1;
	P2  = 78 (X);
	cc =P4 <=P2  (iu);
	if !cc jump 6; jump.l L$L$53;
L$L$55:
	R0  = 0 (X);
L$L$47:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _cplus_demangle_set_style;
.type _cplus_demangle_set_style, STT_FUNC;
_cplus_demangle_set_style:
	LINK 0;
	P1.L  = _libiberty_demanglers; P1.H  = _libiberty_demanglers;
	R1  =[P1 +4];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$64;
	P2.L  = _current_demangling_style; P2.H  = _current_demangling_style;
L$L$62:
	R1  =[P1 +4];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$59;
	[P2 ] =R0 ;
	jump.s L$L$56;
L$L$59:
	P1 +=12;
	R1  =[P1 +4];
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$62;
L$L$64:
	R0  = 0 (X);
L$L$56:
	UNLINK;
	rts;


.align 2
.global _cplus_demangle_name_to_style;
.type _cplus_demangle_name_to_style, STT_FUNC;
_cplus_demangle_name_to_style:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	R6  =R0 ;
	P5.L  = _libiberty_demanglers; P5.H  = _libiberty_demanglers;
	R0  =[P5 +4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$73;
L$L$71:
	R0  =R6 ;
	R1  =[P5 ];
	call _strcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$68;
	R0  =[P5 +4];
	jump.s L$L$65;
L$L$68:
	P5 +=12;
	R0  =[P5 +4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$71;
L$L$73:
	R0  = 0 (X);
L$L$65:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _cplus_demangle;
.type _cplus_demangle, STT_FUNC;
_cplus_demangle:
	LINK 84;
	[--sp] = ( r7:5, p5:5 );
	R5  =R0 ;
	R6  =R1 ;
	P2.L  = _current_demangling_style; P2.H  = _current_demangling_style;
	P2  =[P2 ];
	cc =P2 ==-1;
	if cc jump 6; jump.l L$L$75;
	call _xstrdup;
	jump.s L$L$74;
L$L$75:
	R1  =FP ;
	R0  = -84 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	R1  = 84 (X);
	call _bzero;
	[FP +-84] =R6 ;
	R1  = -252 (Z);
	R0  =R6 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$76;
	P2.L  = _current_demangling_style; P2.H  = _current_demangling_style;
	P2  =[P2 ];
	R0  =P2 ;
	R1  =R0 &R1 ;
	R1  =R1 |R6 ;
	[FP +-84] =R1 ;
L$L$76:
	R1  =[FP +-84];
	R0  = 16384 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$78;
	R0  = 256 (X);
	R1  =R1 &R0 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$77;
L$L$78:
	R1  =[FP +-84];
	R0  =R5 ;
	call _cplus_demangle_v3;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$74;
	R2  =[FP +-84];
	R1  = 16384 (X);
	R1  =R2 &R1 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$74;
L$L$77:
	R1  =[FP +-84];
	R0  = 4 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$81;
	R0  =R5 ;
	call _java_demangle_v3;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$74;
L$L$81:
	R1  =[FP +-84];
	R0  = -32768 (Z);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$83;
	R0  =R5 ;
	R1  =R6 ;
	call _ada_demangle;
	jump.s L$L$74;
L$L$83:
	P5  = -84 (X);
	P5 =P5 +FP ; //immed->Preg 
	R0  =P5 ;
	R1  =R5 ;
	call _internal_cplus_demangle;
	R6  =R0 ;
	R0  =P5 ;
	call _squangle_mop_up;
	R0  =R6 ;
L$L$74:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _grow_vect, STT_FUNC;
_grow_vect:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	[FP +16] =R2 ;
	R0  =R2 ;
	R2  =[FP +20];
	P1  =R1 ;
	P2  =[P1 ];
	R3  =P2 ;
	cc =R3 <R0  (iu);
	if cc jump 6; jump.l L$L$84;
	P2  =P2 +P2 ;
	[P1 ] =P2 ;
	R3  =P2 ;
	cc =R3 <R0  (iu);
	if cc jump 6; jump.l L$L$86;
	[P1 ] =R0 ;
L$L$86:
	P1  =R1 ;
	R0  =[P1 ];
	R1  =R2 ;
	R1  *=R0 ;
	R0  =[P5 ];
	call _xrealloc;
	[P5 ] =R0 ;
L$L$84:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$154:
.dw	0x615f;
.dw	0x6164;
.db	0x5f;
.db	0x00;
.align 2
L$LC$155:
.dw	0x5f5f;
.db	0x5f;
.db	0x00;
.align 2
L$LC$156:
.dw	0x253c;
.dw	0x3e73;
.db	0x00;
.align 2
.type _ada_demangle, STT_FUNC;
_ada_demangle:
	LINK 8;
	[--sp] = ( r7:4, p5:4 );
	P5  =R0 ;
	R0  = 0 (X);
	[FP +-4] =R0 ;
	[FP +-8] =R0 ;
	R6  = 0 (X);
	R2  = 5 (X);
	R0  =P5 ;
	R1.L  = L$LC$154; R1.H  = L$LC$154;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$88;
	P5 +=5;
	R6  = 1 (X);
L$L$88:
	R0  = B [P5 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$91;
	R2  = 60 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$91;
	R0  =P5 ;
	R1.L  = L$LC$155; R1.H  = L$LC$155;
	call _strstr;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$92;
	R0  =P5 ;
	call _strlen;
	R4  =R0 ;
	jump.s L$L$93;
L$L$92:
	P0  =R0 ;
	R1  = B [P0 +3] (X);
	R2  = 88 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$91;
	R5  =P5 ;
	R4  =R0 -R5 ;
	R6  = 1 (X);
L$L$93:
	P0  =R4 ;
	P2  =P0 +P0 ;
	R2  =P2 ;
	R2 +=1;
	P1  = 1 (X);
	[SP +12] =P1 ;
	R0  =FP ;
	R0 +=-4;
	R1  =FP ;
	R1 +=-8;
	call _grow_vect;
	P1.L  = __sch_istable; P1.H  = __sch_istable;
	P0  =R4 ;
	P2 =P5 +P0 ;
	R0  = B [P2 +-1] (Z);
	P2  =R0 ;
	P2  =P1 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R1  = 4 (X);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$96;
	R2  = -2 (X);
	R2 =R2 +R4 ; //immed->Dreg 
	cc =R2 <0;
	if !cc jump 6; jump.l L$L$98;
	P0  =R2 ;
	P2 =P5 +P0 ;
	R0  = B [P2 ] (Z);
	P2  =R0 ;
	P2  =P1 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$98;
	R1  = 4 (X);
L$L$102:
	R2 +=-1;
	cc =R2 <0;
	if !cc jump 6; jump.l L$L$98;
	P0  =R2 ;
	P2 =P5 +P0 ;
	R0  = B [P2 ] (Z);
	P2  =R0 ;
	P2  =P1 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$102;
L$L$98:
	cc =R2 <=1;
	if !cc jump 6; jump.l L$L$103;
	P0  =R2 ;
	P2 =P5 +P0 ;
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$103;
	R5  = B [P2 +-1] (X);
	P2  =R5 ;
	P0  =R1 ;
	cc =P2 ==P0 ;
	if cc jump 6; jump.l L$L$103;
	R4  = -1 (X);
	R4 =R4 +R2 ; //immed->Dreg 
	jump.s L$L$135;
L$L$103:
	P1  =R2 ;
	P2 =P5 +P1 ;
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P0  = 36 (X);
	cc =P2 ==P0 ;
	if cc jump 6; jump.l L$L$96;
	R4  =R2 ;
L$L$135:
	R6  = 1 (X);
L$L$96:
	R2  = 0 (X);
	R1  = 0 (X);
	cc =R2 <R4 ;
	if cc jump 6; jump.l L$L$132;
	P1.L  = __sch_istable; P1.H  = __sch_istable;
	R0  = B [P5 ] (Z);
	P2  =R0 ;
	P2  =P1 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R3  = 136 (X);
	R0  =R0 &R3 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$107;
L$L$111:
	R0  =[FP +-4];
	R0 =R0 +R1 ;
	P0  =R2 ;
	P2 =P5 +P0 ;
	R5  = B [P2 ] (X);
	P0  =R0 ;
	B [P0 ] =R5 ;
	R2 +=1;
	R1 +=1;
	cc =R2 <R4 ;
	if cc jump 6; jump.l L$L$132;
	P0  =R2 ;
	P2 =P5 +P0 ;
	R0  = B [P2 ] (Z);
	P2  =R0 ;
	P2  =P1 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R0  =R0 &R3 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$111;
L$L$107:
	cc =R2 <R4 ;
	if cc jump 6; jump.l L$L$132;
	R3  = -2 (X);
	R3 =R3 +R4 ; //immed->Dreg 
L$L$117:
	cc =R2 <R3 ;
	if cc jump 6; jump.l L$L$115;
	P0  =R2 ;
	P2 =P5 +P0 ;
	R0  = B [P2 ] (X);
	R5  = 95 (X);
	cc =R0 ==R5 ;
	if cc jump 6; jump.l L$L$115;
	R0  = B [P2 +1] (X);
	P2  =R0 ;
	P0  =R5 ;
	cc =P2 ==P0 ;
	if cc jump 6; jump.l L$L$115;
	R0  =[FP +-4];
	R0 =R0 +R1 ;
	R5  = 46 (X);
	P0  =R0 ;
	B [P0 ] =R5 ;
	R6  = 1 (X);
	R2 +=2;
	jump.s L$L$136;
L$L$115:
	R0  =[FP +-4];
	R0 =R0 +R1 ;
	P1  =R2 ;
	P2 =P5 +P1 ;
	R5  = B [P2 ] (X);
	P0  =R0 ;
	B [P0 ] =R5 ;
	R2 +=1;
L$L$136:
	R1 +=1;
	cc =R2 <R4 ;
	if !cc jump 6; jump.l L$L$117;
L$L$132:
	R0  =[FP +-4];
	R1 =R0 +R1 ;
	R0  = 0 (X);
	P0  =R1 ;
	B [P0 ] =R0 ;
	R2  = 0 (X);
	P4  =[FP +-4];
	R0  = B [P4 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$134;
	P0.L  = __sch_istable; P0.H  = __sch_istable;
	R1  = 128 (X);
L$L$124:
	P2  =R2 ;
	P1 =P4 +P2 ;
	R0  = B [P1 ] (Z);
	P2  =R0 ;
	P2  =P0 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$91;
	R5  = B [P1 ] (X);
	P1  =R5 ;
	P2  = 32 (X);
	cc =P1 ==P2 ;
	if !cc jump 6; jump.l L$L$91;
	R2 +=1;
	P1  =R2 ;
	P2 =P4 +P1 ;
	R0  = B [P2 ] (X);
	P2  =R0 ;
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$124;
L$L$134:
	R1  =[FP +-4];
	R0  = 0 (X);
	cc =R6 ==0;
	if !cc R0  =R1 ; /* movsicc-1a */
	jump.s L$L$87;
L$L$91:
	R0  =P5 ;
	call _strlen;
	R2  = 3 (X);
	R2 =R2 +R0 ; //immed->Dreg 
	R1  = 1 (X);
	[SP +12] =R1 ;
	R0  =FP ;
	R0 +=-4;
	R1  =FP ;
	R1 +=-8;
	call _grow_vect;
	R0  = B [P5 ] (X);
	R5  = 60 (X);
	cc =R0 ==R5 ;
	if cc jump 6; jump.l L$L$127;
	R0  =[FP +-4];
	R1  =P5 ;
	call _strcpy;
	jump.s L$L$128;
L$L$127:
	R6  =[FP +-4];
	[SP +12] =R6 ;
	P0.L  = L$LC$156; P0.H  = L$LC$156;
	[SP +16] =P0 ;
	[SP +20] =P5 ;
	call _sprintf;
L$L$128:
	R0  =[FP +-4];
L$L$87:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$157:
.dw	0x6c67;
.dw	0x626f;
.dw	0x6c61;
.dw	0x6320;
.dw	0x6e6f;
.dw	0x7473;
.dw	0x7572;
.dw	0x7463;
.dw	0x726f;
.dw	0x2073;
.dw	0x656b;
.dw	0x6579;
.dw	0x2064;
.dw	0x6f74;
.db	0x20;
.db	0x00;
.align 2
L$LC$158:
.dw	0x6c67;
.dw	0x626f;
.dw	0x6c61;
.dw	0x6420;
.dw	0x7365;
.dw	0x7274;
.dw	0x6375;
.dw	0x6f74;
.dw	0x7372;
.dw	0x6b20;
.dw	0x7965;
.dw	0x6465;
.dw	0x7420;
.dw	0x206f;
.db	0x00;
.align 2
L$LC$159:
.dw	0x6d69;
.dw	0x6f70;
.dw	0x7472;
.dw	0x7320;
.dw	0x7574;
.dw	0x2062;
.dw	0x6f66;
.dw	0x2072;
.db	0x00;
.align 2
.type _internal_cplus_demangle, STT_FUNC;
_internal_cplus_demangle:
	LINK 12;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	[FP +12] =R1 ;
	P4  = 0 (X);
	R1  = 0 (X);
	P5  =[P3 +40];
	R4  =[P3 +44];
	R5  =[P3 +48];
	R6  =[P3 +56];
	[P3 +44] =R1 ;
	[P3 +40] =R1 ;
	[P3 +56] =R1 ;
	[P3 +60] =R1 ;
	R0  =[FP +12];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$138;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$138;
	R0  =FP ;
	R0 +=-12;
	call _string_init;
	R1  =[P3 ];
	R0  = 768 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$139;
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =FP ;
	R1 +=12;
	call _gnu_special;
	P4  =R0 ;
L$L$139:
	cc =P4 ==0;
	if cc jump 6; jump.l L$L$147;
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =FP ;
	R1 +=12;
	call _demangle_prefix;
	P4  =R0 ;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$141;
L$L$147:
	R0  =[FP +12];
	P2  =R0 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$141;
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =FP ;
	R1 +=12;
	call _demangle_signature;
	P4  =R0 ;
L$L$141:
	R0  =[P3 +40];
	cc =R0 ==2;
	if cc jump 6; jump.l L$L$142;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$157; R1.H  = L$LC$157;
	call _string_prepend;
	R1  = 0 (X);
	[P3 +40] =R1 ;
	jump.s L$L$143;
L$L$142:
	R0  =[P3 +44];
	cc =R0 ==2;
	if cc jump 6; jump.l L$L$144;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$158; R1.H  = L$LC$158;
	call _string_prepend;
	P2  = 0 (X);
	[P3 +44] =P2 ;
	jump.s L$L$143;
L$L$144:
	R0  =[P3 +60];
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$143;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$159; R1.H  = L$LC$159;
	call _string_prepend;
	R1  = 0 (X);
	[P3 +60] =R1 ;
L$L$143:
	R1  =FP ;
	R1 +=-12;
	R2  =P4 ;
	R0  =P3 ;
	call _mop_up;
	R1  =R0 ;
L$L$138:
	[P3 +40] =P5 ;
	[P3 +44] =R4 ;
	[P3 +48] =R5 ;
	[P3 +56] =R6 ;
	R0  =R1 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _squangle_mop_up, STT_FUNC;
_squangle_mop_up:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	call _forget_B_and_K_types;
	R0  =[P5 +12];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$149;
	call _free;
L$L$149:
	R0  =[P5 +8];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$148;
	call _free;
L$L$148:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _work_stuff_copy_to_from, STT_FUNC;
_work_stuff_copy_to_from:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	P5  =R1 ;
	call _delete_work_stuff;
	R2  = 84 (X);
	R0  =P5 ;
	R1  =P4 ;
	call _bcopy;
	P2  =[P5 +36];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$152;
	P2  =P2 <<2;
	R0  =P2 ;
	call _xmalloc;
	[P4 +4] =R0 ;
L$L$152:
	P3  = 0 (X);
	R0  =[P5 +32];
	R1  =P3 ;
	cc =R1 <R0 ;
	if cc jump 6; jump.l L$L$178;
L$L$157:
	R0  =[P5 +4];
	P2  =P3 <<2;
	R5  =P2 ;
	R0 =R5 +R0 ;
	P2  =R0 ;
	R0  =[P2 ];
	call _strlen;
	R6  = 1 (X);
	R6 =R6 +R0 ; //immed->Dreg 
	R4  =[P4 +4];
	R4 =R5 +R4 ;
	R0  =R6 ;
	call _xmalloc;
	P2  =R4 ;
	[P2 ] =R0 ;
	R0  =[P4 +4];
	R0 =R5 +R0 ;
	P2  =R0 ;
	R1  =[P2 ];
	R0  =[P5 +4];
	R5 =R5 +R0 ;
	P2  =R5 ;
	R0  =[P2 ];
	R2  =R6 ;
	call _bcopy;
	P3 +=1;
	R0  =[P5 +32];
	R2  =P3 ;
	cc =R2 <R0 ;
	if !cc jump 6; jump.l L$L$157;
L$L$178:
	P2  =[P5 +24];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$158;
	P2  =P2 <<2;
	R0  =P2 ;
	call _xmalloc;
	[P4 +8] =R0 ;
L$L$158:
	P3  = 0 (X);
	R0  =[P5 +16];
	R1  =P3 ;
	cc =R1 <R0 ;
	if cc jump 6; jump.l L$L$180;
L$L$163:
	R0  =[P5 +8];
	P2  =P3 <<2;
	R5  =P2 ;
	R0 =R5 +R0 ;
	P2  =R0 ;
	R0  =[P2 ];
	call _strlen;
	R6  = 1 (X);
	R6 =R6 +R0 ; //immed->Dreg 
	R4  =[P4 +8];
	R4 =R5 +R4 ;
	R0  =R6 ;
	call _xmalloc;
	P2  =R4 ;
	[P2 ] =R0 ;
	R0  =[P4 +8];
	R0 =R5 +R0 ;
	P2  =R0 ;
	R1  =[P2 ];
	R0  =[P5 +8];
	R5 =R5 +R0 ;
	P2  =R5 ;
	R0  =[P2 ];
	R2  =R6 ;
	call _bcopy;
	P3 +=1;
	R0  =[P5 +16];
	R2  =P3 ;
	cc =R2 <R0 ;
	if !cc jump 6; jump.l L$L$163;
L$L$180:
	P2  =[P5 +28];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$164;
	P2  =P2 <<2;
	R0  =P2 ;
	call _xmalloc;
	[P4 +12] =R0 ;
L$L$164:
	P3  = 0 (X);
	R0  =[P5 +20];
	R1  =P3 ;
	cc =R1 <R0 ;
	if cc jump 6; jump.l L$L$182;
L$L$169:
	R0  =[P5 +12];
	P2  =P3 <<2;
	R5  =P2 ;
	R0 =R5 +R0 ;
	P2  =R0 ;
	R0  =[P2 ];
	call _strlen;
	R6  = 1 (X);
	R6 =R6 +R0 ; //immed->Dreg 
	R4  =[P4 +12];
	R4 =R5 +R4 ;
	R0  =R6 ;
	call _xmalloc;
	P2  =R4 ;
	[P2 ] =R0 ;
	R0  =[P4 +12];
	R0 =R5 +R0 ;
	P2  =R0 ;
	R1  =[P2 ];
	R0  =[P5 +12];
	R5 =R5 +R0 ;
	P2  =R5 ;
	R0  =[P2 ];
	R2  =R6 ;
	call _bcopy;
	P3 +=1;
	R0  =[P5 +20];
	R2  =P3 ;
	cc =R2 <R0 ;
	if !cc jump 6; jump.l L$L$169;
L$L$182:
	P2  =[P5 +68];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$170;
	P2  =P2 <<2;
	R0  =P2 ;
	call _xmalloc;
	[P4 +64] =R0 ;
L$L$170:
	P3  = 0 (X);
	R0  =[P5 +68];
	R1  =P3 ;
	cc =R1 <R0 ;
	if cc jump 6; jump.l L$L$184;
L$L$175:
	R0  =[P5 +64];
	P2  =P3 <<2;
	R5  =P2 ;
	R0 =R5 +R0 ;
	P2  =R0 ;
	R0  =[P2 ];
	call _strlen;
	R6  = 1 (X);
	R6 =R6 +R0 ; //immed->Dreg 
	R4  =[P4 +64];
	R4 =R5 +R4 ;
	R0  =R6 ;
	call _xmalloc;
	P2  =R4 ;
	[P2 ] =R0 ;
	R0  =[P4 +64];
	R0 =R5 +R0 ;
	P2  =R0 ;
	R1  =[P2 ];
	R0  =[P5 +64];
	R5 =R5 +R0 ;
	P2  =R5 ;
	R0  =[P2 ];
	R2  =R6 ;
	call _bcopy;
	P3 +=1;
	R0  =[P5 +68];
	R2  =P3 ;
	cc =R2 <R0 ;
	if !cc jump 6; jump.l L$L$175;
L$L$184:
	R0  =[P5 +76];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$151;
	R0  = 12 (X);
	call _xmalloc;
	[P4 +76] =R0 ;
	call _string_init;
	R0  =[P4 +76];
	R1  =[P5 +76];
	call _string_appends;
L$L$151:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _delete_non_B_K_work_stuff, STT_FUNC;
_delete_non_B_K_work_stuff:
	LINK 0;
	[--sp] = ( p5:4 );
	P4  =R0 ;
	call _forget_types;
	R0  =[P4 +4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$186;
	call _free;
	R1  = 0 (X);
	[P4 +4] =R1 ;
	[P4 +36] =R1 ;
L$L$186:
	R0  =[P4 +64];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$187;
	P5  = 0 (X);
	R0  =[P4 +68];
	R1  =P5 ;
	cc =R1 <R0 ;
	if cc jump 6; jump.l L$L$196;
L$L$193:
	P2  =[P4 +64];
	P2  =P2 +(P5 <<2);
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$190;
	call _free;
L$L$190:
	P5 +=1;
	R0  =[P4 +68];
	R1  =P5 ;
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$193;
L$L$196:
	R0  =[P4 +64];
	call _free;
	R1  = 0 (X);
	[P4 +64] =R1 ;
L$L$187:
	R0  =[P4 +76];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$185;
	call _string_delete;
	R0  =[P4 +76];
	call _free;
	R1  = 0 (X);
	[P4 +76] =R1 ;
L$L$185:
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _delete_work_stuff, STT_FUNC;
_delete_work_stuff:
	LINK 0;
	[--sp] = ( r7:6 );
	R6  =R0 ;
	call _delete_non_B_K_work_stuff;
	R0  =R6 ;
	call _squangle_mop_up;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _mop_up, STT_FUNC;
_mop_up:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	R6  = 0 (X);
	call _delete_non_B_K_work_stuff;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$199;
	R0  =P5 ;
	call _string_delete;
	jump.s L$L$200;
L$L$199:
	R2  = 1 (X);
	R0  =P5 ;
	R1.L  = L$LC$122; R1.H  = L$LC$122;
	call _string_appendn;
	R6  =[P5 ];
L$L$200:
	R0  =R6 ;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$161:
.dw	0x3a3a;
.db	0x00;
.align 2
L$LC$160:
.db	0x2e;
.db	0x00;
.align 2
L$LC$162:
.db	0x20;
.db	0x00;
.align 2
L$LC$163:
.dw	0x7320;
.dw	0x6174;
.dw	0x6974;
.db	0x63;
.db	0x00;
.align 2
.type _demangle_signature, STT_FUNC;
_demangle_signature:
	LINK 56;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	P5  =R2 ;
	R0  = 0 (X);
	[FP +-52] =R0 ;
	R4  = 0 (X);
	[FP +-56] =R0 ;
	R5  = 0 (X);
	R6  = 1 (X);
	P1  =[P4 ];
	R0  = B [P1 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$203;
L$L$278:
	R0  = B [P1 ] (X);
	P1  =R0 ;
	P1 +=-48;
	P2  = 69 (X);
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$272;
P2.L =L$L$275;
P2.H =L$L$275;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$275:
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$237;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$242;
	.dd		L$L$216;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$246;
	.dd		L$L$272;
	.dd		L$L$268;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$210;
	.dd		L$L$218;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$207;
	.dd		L$L$272;
	.dd		L$L$212;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$216;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$257;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$272;
	.dd		L$L$249;
	.dd		L$L$216;
L$L$207:
	R5  =[P4 ];
	R1  = 1 (X);
	[SP +12] =R1 ;
	R2  = 0 (X);
	[SP +16] =R2 ;
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_qualified;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$292;
	R0  =[P4 ];
	R2  =R0 -R5 ;
	R0  =P3 ;
	R1  =R5 ;
	call _remember_type;
	jump.s L$L$292;
L$L$210:
	P2  = 1 (X);
	[SP +12] =P2 ;
	R0  = 0 (X);
	[SP +16] =R0 ;
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_qualified;
	R6  =R0 ;
L$L$292:
	R0  =[P3 ];
	R1  = 768 (X);
	R1  =R0 &R1 ;
	R0  = 1 (X);
	cc =R1 ==0;
	if !cc R4  =R0 ; /* movsicc-2b */
	jump.s L$L$240;
L$L$212:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$213;
	R5  =[P4 ];
L$L$213:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R1  = 1 (X);
	[P3 +48] =R1 ;
	jump.s L$L$206;
L$L$216:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	call _code_for_qualifier;
	R1  =[P3 +56];
	R1  =R0 |R1 ;
	[P3 +56] =R1 ;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$291;
	R5  =[P4 ];
	jump.s L$L$291;
L$L$218:
	R1  =[P3 ];
	R0  = 4096 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$273;
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$273;
	R2  = 95 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$221;
L$L$224:
	P2 +=1;
	[P4 ] =P2 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$273;
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$224;
L$L$221:
	R0  =[P4 ];
	P2  =R0 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$273;
	jump.s L$L$291;
L$L$237:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$238;
	R5  =[P4 ];
L$L$238:
	R0  = -1 (X);
	[P3 +52] =R0 ;
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_class;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$239;
	R0  =[P4 ];
	R2  =R0 -R5 ;
	R0  =P3 ;
	R1  =R5 ;
	call _remember_type;
L$L$239:
	R1  =[P3 ];
	R0  = 8960 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$240;
	R0  =[P4 ];
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 1 (X);
	R2  = 70 (X);
	cc =R0 ==R2 ;
	if !cc R4  =R1 ; /* movsicc-2b */
L$L$240:
	R5  = 0 (X);
	jump.s L$L$206;
L$L$242:
	R5  =FP ;
	R5 +=-36;
	R2  =R5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _do_type;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$290;
	R2  =[P3 ];
	R1  = 4 (X);
	R1  =R2 &R1 ;
	R3.L  = L$LC$161; R3.H  = L$LC$161;
	R2.L  = L$LC$160; R2.H  = L$LC$160;
	cc =R1 ==0;
	if cc R1  =R3 ; if !cc R1 =R2 ; /* movsicc-1 */
	R0  =R5 ;
	call _string_append;
	R5  =FP ;
	R5 +=-36;
	R0  =P5 ;
	R1  =R5 ;
	call _string_prepends;
	R0  =R5 ;
	jump.s L$L$293;
L$L$246:
	R5  = 0 (X);
	R0  = 1 (X);
	[FP +-52] =R0 ;
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R1  =[P3 ];
	R0  = 15360 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$247;
	R0  =P3 ;
	call _forget_types;
L$L$247:
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_args;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$281;
	R1  =[P3 ];
	R0  = 8448 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$206;
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$206;
	P2 +=1;
	[P4 ] =P2 ;
	R2  =FP ;
	R2 +=-24;
	R0  =P3 ;
	R1  =P4 ;
	call _do_type;
	R6  =R0 ;
	R0  =FP ;
	R0 +=-24;
	jump.s L$L$289;
L$L$249:
	R0  =FP ;
	R0 +=-12;
	call _string_init;
	R0  =FP ;
	R0 +=-24;
	call _string_init;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$250;
	R5  =[P4 ];
L$L$250:
	P2  = -12 (X);
	P2 =P2 +FP ; //immed->Preg 
	[SP +12] =P2 ;
	R2  = 1 (X);
	[SP +16] =R2 ;
	[SP +20] =R2 ;
	R2  =FP ;
	R2 +=-24;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_template;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$251;
	R0  =[P4 ];
	R2  =R0 -R5 ;
	R0  =P3 ;
	R1  =R5 ;
	call _remember_type;
L$L$251:
	P2  = -24 (X);
	P2 =P2 +FP ; //immed->Preg 
	R2  =[P3 ];
	R1  = 4 (X);
	R1  =R2 &R1 ;
	R3.L  = L$LC$161; R3.H  = L$LC$161;
	R2.L  = L$LC$160; R2.H  = L$LC$160;
	cc =R1 ==0;
	if cc R1  =R3 ; if !cc R1 =R2 ; /* movsicc-1 */
	R0  =P2 ;
	call _string_append;
	R0  =P5 ;
	R1  =FP ;
	R1 +=-24;
	call _string_prepends;
	R1  =[P3 +44];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$254;
	R5  =FP ;
	R5 +=-12;
	R0  =R5 ;
	R1.L  = L$LC$83; R1.H  = L$LC$83;
	call _string_prepend;
	R0  =P5 ;
	R1  =R5 ;
	call _string_appends;
	R0  =[P3 +44];
	R0 +=-1;
	[P3 +44] =R0 ;
L$L$254:
	R0  =[P3 +40];
	R1  = 1 (X);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$256;
	R0  =[P3 +44];
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$255;
L$L$256:
	R0  =P5 ;
	R1  =FP ;
	R1 +=-12;
	call _string_appends;
	R0  =[P3 +40];
	R0 +=-1;
	[P3 +40] =R0 ;
L$L$255:
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	R0  =FP ;
	R0 +=-24;
L$L$293:
	call _string_delete;
L$L$290:
	R5  = 0 (X);
	R4  = 1 (X);
	jump.s L$L$206;
L$L$257:
	R1  =[P3 ];
	R0  = 768 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$258;
	R0  =[FP +-56];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$258;
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R2  =FP ;
	R2 +=-48;
	R0  =P3 ;
	R1  =P4 ;
	call _do_type;
	R6  =R0 ;
	R1  =[FP +-48];
	R0  =[FP +-44];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$259;
	R0  =FP ;
	R0 +=-48;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$259:
	R1  =FP ;
	R1 +=-48;
	R0  =P5 ;
	call _string_prepends;
	R0  =FP ;
	R0 +=-48;
L$L$289:
	call _string_delete;
	jump.s L$L$206;
L$L$258:
	R1  =[P3 ];
	R0  = 4096 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$273;
	P2  =[P4 ];
	P2 +=1;
	[P4 ] =P2 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$206;
	P1.L  = __sch_istable; P1.H  = __sch_istable;
	R0  = B [P2 ] (Z);
	P2  =R0 ;
	P2  =P1 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R1  = 4 (X);
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$206;
	R1  = 4 (X);
L$L$266:
	P2  =[P4 ];
	P2 +=1;
	[P4 ] =P2 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$206;
	R2  = B [P2 ] (Z);
	P2  =R2 ;
	P2  =P1 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$266;
	jump.s L$L$206;
L$L$268:
	R1  =[P3 ];
	R0  = 768 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$273;
	P2  = 0 (X);
	[SP +12] =P2 ;
	[SP +16] =P2 ;
	[SP +20] =P2 ;
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_template;
	R6  =R0 ;
	R1  =[P3 +40];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	R1  = 1 (X);
	cc =R0 ==0;
	R0  =[FP +-56];
	if cc R0  =R1 ; /* movsicc-1b */
	[FP +-56] =R0 ;
L$L$291:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	jump.s L$L$206;
L$L$272:
	R1  =[P3 ];
	R0  = 768 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$273;
	R0  = 1 (X);
	[FP +-52] =R0 ;
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_args;
	R6  =R0 ;
	jump.s L$L$206;
L$L$273:
	R6  = 0 (X);
L$L$206:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$281;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$202;
	R0  = 1 (X);
	[FP +-52] =R0 ;
	R1  =[P3 ];
	R0  = 11264 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$277;
	R0  =P3 ;
	call _forget_types;
L$L$277:
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_args;
	R6  =R0 ;
	R4  = 0 (X);
L$L$202:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$281;
	P1  =[P4 ];
	R0  = B [P1 ] (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$278;
L$L$203:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$281;
	R0  =[FP +-52];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$279;
	R1  =[P3 ];
	R0  = 768 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$279;
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_args;
	R6  =R0 ;
L$L$279:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$281;
	R1  =[P3 ];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$281;
	R0  =[P3 +48];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$282;
	R0  =P5 ;
	R1.L  = L$LC$163; R1.H  = L$LC$163;
	call _string_append;
L$L$282:
	R0  =[P3 +56];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$281;
	R1  =[P5 ];
	R0  =[P5 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$284;
	R0  =P5 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$284:
	R0  =[P3 +56];
	call _qualifier_string;
	R1  =R0 ;
	R0  =P5 ;
	call _string_append;
L$L$281:
	R0  =R6 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$164:
.dw	0x6574;
.dw	0x706d;
.dw	0x616c;
.dw	0x6574;
.dw	0x3c20;
.db	0x00;
.align 2
L$LC$165:
.dw	0x6c63;
.dw	0x7361;
.db	0x73;
.db	0x00;
.align 2
L$LC$166:
.dw	0x203e;
.dw	0x6c63;
.dw	0x7361;
.db	0x73;
.db	0x00;
.align 2
.type _demangle_template_template_parm, STT_FUNC;
_demangle_template_template_parm:
	LINK 16;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	R5  = 0 (X);
	R4  = 1 (X);
	R0  =R2 ;
	R1.L  = L$LC$164; R1.H  = L$LC$164;
	call _string_append;
	R0  =P5 ;
	R1  =FP ;
	R1 +=-16;
	call _get_count;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$295;
	R6  = 0 (X);
	R0  =[FP +-16];
	cc =R6 <R0 ;
	if cc jump 6; jump.l L$L$295;
L$L$308:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$300;
	R0  =P4 ;
	R1.L  = L$LC$110; R1.H  = L$LC$110;
	call _string_append;
L$L$300:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 90 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$301;
	P2 +=1;
	[P5 ] =P2 ;
	R0  =P4 ;
	R1.L  = L$LC$165; R1.H  = L$LC$165;
	call _string_append;
	jump.s L$L$302;
L$L$301:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 122 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$303;
	P2 +=1;
	[P5 ] =P2 ;
	R2  =P4 ;
	R0  =P3 ;
	R1  =P5 ;
	call _demangle_template_template_parm;
	R4  =R0 ;
	jump.s L$L$311;
L$L$303:
	R5  =FP ;
	R5 +=-12;
	R2  =R5 ;
	R0  =P3 ;
	R1  =P5 ;
	call _do_type;
	R4  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$306;
	R0  =P4 ;
	R1  =R5 ;
	call _string_appends;
L$L$306:
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
L$L$311:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$295;
L$L$302:
	R5  = 1 (X);
	R6 +=1;
	R0  =[FP +-16];
	cc =R6 <R0 ;
	if !cc jump 6; jump.l L$L$308;
L$L$295:
	P2  =[P4 +4];
	R0  = B [P2 +-1] (X);
	P2  =R0 ;
	P1  = 62 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$309;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$309:
	R0  =P4 ;
	R1.L  = L$LC$166; R1.H  = L$LC$166;
	call _string_append;
	R0  =R4 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$167:
.db	0x28;
.db	0x00;
.align 2
L$LC$168:
.db	0x29;
.db	0x00;
.align 2
.type _demangle_expression, STT_FUNC;
_demangle_expression:
	LINK 16;
	[--sp] = ( r7:4, p5:3 );
	[FP +-4] =R0 ;
	P3  =R1 ;
	[FP +16] =R2 ;
	R0  =R2 ;
	[FP +-8] =R2 ;
	R1  =[FP +20];
	[FP +-12] =R1 ;
	R4  = 0 (X);
	R2  = 1 (X);
	R1.L  = L$LC$167; R1.H  = L$LC$167;
	call _string_appendn;
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R5  = 1 (X);
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 87 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$314;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$314;
L$L$326:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$317;
	R5  = 0 (X);
	R0  =[P3 ];
	call _strlen;
	[FP +-16] =R0 ;
	P5  = 0 (X);
	R1  = 78 (X);
	cc =R5 <=R1  (iu);
	if cc jump 6; jump.l L$L$319;
L$L$323:
	P4  =P5 +(P5 <<1);
	P4  =P4 <<2;
	P2.L  = _optable; P2.H  = _optable;
	P2 =P2 +P4 ; //immed->Preg 
	P4  =P2 ;
	R0  =[P2 ];
	call _strlen;
	R6  =R0 ;
	R0  =[FP +-16];
	cc =R6 <=R0  (iu);
	if cc jump 6; jump.l L$L$320;
	R2  =R6 ;
	R0  =[P4 ];
	R1  =[P3 ];
	call _memcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$331;
L$L$320:
	P5 +=1;
	P2  = 78 (X);
	cc =P5 <=P2  (iu);
	if !cc jump 6; jump.l L$L$323;
L$L$319:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$314;
	jump.s L$L$325;
L$L$331:
	R2  = 1 (X);
	R0  =[FP +-8];
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_appendn;
	R0  =[FP +-8];
	R1  =[P4 +4];
	call _string_append;
	R2  = 1 (X);
	R0  =[FP +-8];
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_appendn;
	R5  = 1 (X);
	R0  =[P3 ];
	R6 =R6 +R0 ;
	[P3 ] =R6 ;
	jump.s L$L$319;
L$L$317:
	R4  = 1 (X);
L$L$325:
	R0  =[FP +-12];
	[SP +12] =R0 ;
	R2  =[FP +-8];
	R0  =[FP +-4];
	R1  =P3 ;
	call _demangle_template_value_parm;
	R5  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$314;
	R0  =[P3 ];
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 87 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$327;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$326;
L$L$314:
	R0  =[P3 ];
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 87 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$327;
	R5  = 0 (X);
	jump.s L$L$328;
L$L$327:
	R2  = 1 (X);
	R0  =[FP +-8];
	R1.L  = L$LC$168; R1.H  = L$LC$168;
	call _string_appendn;
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
L$L$328:
	R0  =R5 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$169:
.dw	0x6425;
.db	0x00;
.align 2
.type _demangle_integral_value, STT_FUNC;
_demangle_integral_value:
	LINK 32;
	[--sp] = ( r7:4, p5:3 );
	P5  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	P2  =[P5 ];
	R1  = B [P2 ] (X);
	P2  =R1 ;
	P1  = 69 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$333;
	P2  = 3 (X);
	[SP +12] =P2 ;
	R1  =P5 ;
	call _demangle_expression;
	jump.s L$L$350;
L$L$333:
	P2  =[P5 ];
	R1  = B [P2 ] (X);
	P2  =R1 ;
	P1  = 81 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$336;
	P1 +=-6;
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$335;
L$L$336:
	P2  = 0 (X);
	[SP +12] =P2 ;
	R1  = 1 (X);
	[SP +16] =R1 ;
	R2  =R5 ;
	R1  =P5 ;
	call _demangle_qualified;
L$L$350:
	R6  =R0 ;
	jump.s L$L$334;
L$L$335:
	P4  = 0 (X);
	R4  = 0 (X);
	R6  = 0 (X);
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$338;
	R0  = B [P2 +1] (X);
	P2  =R0 ;
	P1  = 109 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$348;
	P4  = 1 (X);
	R2  = 1 (X);
	R0  =R5 ;
	R1.L  = L$LC$30; R1.H  = L$LC$30;
	call _string_appendn;
	R0  =[P5 ];
	R0 +=2;
	[P5 ] =R0 ;
	jump.s L$L$341;
L$L$338:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 109 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$342;
	R2  = 1 (X);
	R0  =R5 ;
	R1.L  = L$LC$30; R1.H  = L$LC$30;
	call _string_appendn;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
L$L$342:
	P4  = 1 (X);
L$L$348:
	R4  = 1 (X);
L$L$341:
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$343;
	R0  =P5 ;
	call _consume_count;
	jump.s L$L$349;
L$L$343:
	R0  =P5 ;
	call _consume_count_with_underscores;
L$L$349:
	P3  =R0 ;
	cc =P3 ==-1;
	if !cc jump 6; jump.l L$L$334;
	R6  =FP ;
	R6 +=-32;
	[SP +12] =R6 ;
	P2.L  = L$LC$169; P2.H  = L$LC$169;
	[SP +16] =P2 ;
	[SP +20] =R0 ;
	call _sprintf;
	R0  =R5 ;
	R1  =R6 ;
	call _string_append;
	P1  = 9 (X);
	cc =P3 <=P1 ;
	if cc jump 6; jump.l L$L$347;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$346;
L$L$347:
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$346;
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$346;
	P2 +=1;
	[P5 ] =P2 ;
L$L$346:
	R6  = 1 (X);
L$L$334:
	R0  =R6 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$170:
.db	0x65;
.db	0x00;
.align 2
.type _demangle_real_value, STT_FUNC;
_demangle_real_value:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P2  =[P5 ];
	R1  = B [P2 ] (X);
	P2  =R1 ;
	P1  = 69 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$352;
	P2  = 6 (X);
	[SP +12] =P2 ;
	R1  =P5 ;
	call _demangle_expression;
	jump.s L$L$351;
L$L$352:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 109 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$353;
	R2  = 1 (X);
	R0  =R6 ;
	R1.L  = L$LC$30; R1.H  = L$LC$30;
	call _string_appendn;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
L$L$353:
	R1  =[P5 ];
	P2  =R1 ;
	R2  = B [P2 ] (Z);
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R2 ; //immed->Dreg 
	P1  =R0 ;
	R2  = W[P1 ] (Z);
	R0  = 4 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$369;
	R5  = 4 (X);
L$L$357:
	R2  = 1 (X);
	R0  =R6 ;
	call _string_appendn;
	R0  =[P5 ];
	R1  = 1 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	[P5 ] =R1 ;
	P2  =R1 ;
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P1  =P1 +P1 ;
	R0  =P1 ;
	R2.L  = __sch_istable; R2.H  = __sch_istable;
	R2 =R2 +R0 ; //immed->Dreg 
	P1  =R2 ;
	R0  = W[P1 ] (Z);
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$357;
L$L$369:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 46 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$358;
	R2  = 1 (X);
	R0  =R6 ;
	R1.L  = L$LC$160; R1.H  = L$LC$160;
	call _string_appendn;
	R1  =[P5 ];
	R1 +=1;
	[P5 ] =R1 ;
	P2  =R1 ;
	R1  = B [P2 ] (Z);
	P1  =R1 ;
	P1  =P1 +P1 ;
	R1  =P1 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R1 ; //immed->Dreg 
	P1  =R0 ;
	R1  = W[P1 ] (Z);
	R0  = 4 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$358;
	R5  = 4 (X);
L$L$362:
	R2  = 1 (X);
	R0  =R6 ;
	R1  =[P5 ];
	call _string_appendn;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P1  =P1 +P1 ;
	R0  =P1 ;
	R1.L  = __sch_istable; R1.H  = __sch_istable;
	R1 =R1 +R0 ; //immed->Dreg 
	P1  =R1 ;
	R0  = W[P1 ] (Z);
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$362;
L$L$358:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 101 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$363;
	R2  = 1 (X);
	R0  =R6 ;
	R1.L  = L$LC$170; R1.H  = L$LC$170;
	call _string_appendn;
	R1  =[P5 ];
	R1 +=1;
	[P5 ] =R1 ;
	P2  =R1 ;
	R1  = B [P2 ] (Z);
	P1  =R1 ;
	P1  =P1 +P1 ;
	R1  =P1 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R1 ; //immed->Dreg 
	P1  =R0 ;
	R1  = W[P1 ] (Z);
	R0  = 4 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$363;
	R5  = 4 (X);
L$L$367:
	R2  = 1 (X);
	R0  =R6 ;
	R1  =[P5 ];
	call _string_appendn;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P1  =P1 +P1 ;
	R0  =P1 ;
	R1.L  = __sch_istable; R1.H  = __sch_istable;
	R1 =R1 +R0 ; //immed->Dreg 
	P1  =R1 ;
	R0  = W[P1 ] (Z);
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$367;
L$L$363:
	R0  = 1 (X);
L$L$351:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$171:
.db	0x27;
.db	0x00;
.align 2
L$LC$172:
.dw	0x6166;
.dw	0x736c;
.db	0x65;
.db	0x00;
.align 2
L$LC$173:
.dw	0x7274;
.dw	0x6575;
.db	0x00;
.align 2
L$LC$174:
.db	0x30;
.db	0x00;
.align 2
.type _demangle_template_value_parm, STT_FUNC;
_demangle_template_value_parm:
	LINK 8;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R4  =R2 ;
	P5  =[FP +20];
	R5  = 1 (X);
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 89 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$373;
	P2 +=1;
	[P4 ] =P2 ;
	R0  =P4 ;
	call _consume_count_with_underscores;
	P5  =R0 ;
	cc =P5 ==-1;
	if !cc jump 6; jump.l L$L$375;
	R0  =[P3 +64];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$376;
	P2  =[P3 +68];
	cc =P5 <P2 ;
	if cc jump 6; jump.l L$L$375;
L$L$376:
	R0  =P4 ;
	call _consume_count_with_underscores;
	cc =R0 ==-1;
	if cc jump 6; jump.l L$L$374;
L$L$375:
	R0  = -1 (X);
	jump.s L$L$372;
L$L$374:
	P3  =[P3 +64];
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$377;
	P5  =P3 +(P5 <<2);
	R0  =R4 ;
	R1  =[P5 ];
	call _string_append;
	jump.s L$L$379;
L$L$377:
	R0  =R4 ;
	R1  =P5 ;
	call _string_append_template_idx;
	jump.s L$L$379;
L$L$373:
	cc =P5 ==3;
	if cc jump 6; jump.l L$L$380;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_integral_value;
	jump.s L$L$404;
L$L$380:
	P0  = 5 (X);
	cc =P5 ==P0 ;
	if cc jump 6; jump.l L$L$382;
	R0  =[P4 ];
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 109 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$383;
	R2  = 1 (X);
	R0  =R4 ;
	R1.L  = L$LC$30; R1.H  = L$LC$30;
	call _string_appendn;
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
L$L$383:
	R2  = 1 (X);
	R0  =R4 ;
	R1.L  = L$LC$171; R1.H  = L$LC$171;
	call _string_appendn;
	R0  =P4 ;
	call _consume_count;
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$390;
	B [FP +-4] =R0 ;
	R1  = 0 (X);
	B [FP +-3] =R1 ;
	R1  =FP ;
	R1 +=-4;
	R2  = 1 (X);
	R0  =R4 ;
	call _string_appendn;
	R2  = 1 (X);
	R0  =R4 ;
	R1.L  = L$LC$171; R1.H  = L$LC$171;
	jump.s L$L$405;
L$L$382:
	P0  = 4 (X);
	cc =P5 ==P0 ;
	if cc jump 6; jump.l L$L$387;
	R0  =P4 ;
	call _consume_count;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$388;
	R2  = 5 (X);
	R0  =R4 ;
	R1.L  = L$LC$172; R1.H  = L$LC$172;
	jump.s L$L$405;
L$L$388:
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$390;
	R2  = 4 (X);
	R0  =R4 ;
	R1.L  = L$LC$173; R1.H  = L$LC$173;
L$L$405:
	call _string_appendn;
	jump.s L$L$379;
L$L$390:
	R5  = 0 (X);
	jump.s L$L$379;
L$L$387:
	P2  = 6 (X);
	cc =P5 ==P2 ;
	if cc jump 6; jump.l L$L$393;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_real_value;
	jump.s L$L$404;
L$L$393:
	R0  =P5 ;
	R0 +=-1;
	cc =R0 <=1 (iu);
	if cc jump 6; jump.l L$L$379;
	R0  =[P4 ];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R1  = 81 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$396;
	P0  = 0 (X);
	[SP +12] =P0 ;
	P2  = 1 (X);
	[SP +16] =P2 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_qualified;
L$L$404:
	R5  =R0 ;
	jump.s L$L$379;
L$L$396:
	R0  =P4 ;
	call _consume_count;
	R6  =R0 ;
	R0  = -1 (X);
	cc =R6 ==-1;
	if !cc jump 6; jump.l L$L$372;
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$399;
	R2  = 1 (X);
	R0  =R4 ;
	R1.L  = L$LC$174; R1.H  = L$LC$174;
	call _string_appendn;
	jump.s L$L$400;
L$L$399:
	R0  = 1 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _xmalloc;
	[FP +-8] =R0 ;
	R2  =R6 ;
	R1  =[P4 ];
	call _strncpy;
	P1  =[FP +-8];
	P0  =R6 ;
	P2 =P1 +P0 ;
	R1  = 0 (X);
	B [P2 ] =R1 ;
	R0  =P1 ;
	R1  =[P3 ];
	call _cplus_demangle;
	P3  =R0 ;
	cc =P5 ==1;
	if cc jump 6; jump.l L$L$401;
	R2  = 1 (X);
	R0  =R4 ;
	R1.L  = L$LC$78; R1.H  = L$LC$78;
	call _string_appendn;
L$L$401:
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$402;
	R0  =R4 ;
	R1  =P3 ;
	call _string_append;
	R0  =P3 ;
	call _free;
	jump.s L$L$403;
L$L$402:
	R0  =R4 ;
	R1  =[FP +-8];
	call _string_append;
L$L$403:
	R0  =[FP +-8];
	call _free;
L$L$400:
	R0  =[P4 ];
	R6 =R6 +R0 ;
	[P4 ] =R6 ;
L$L$379:
	R0  =R5 ;
L$L$372:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$175:
.dw	0x414a;
.dw	0x7272;
.dw	0x7961;
.dw	0x5a31;
.db	0x00;
.align 2
.type _demangle_template, STT_FUNC;
_demangle_template:
	LINK 92;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	P5  =[FP +20];
	R4  =[FP +24];
	R1  =[FP +28];
	[FP +-32] =R1 ;
	R0  = 0 (X);
	[FP +-36] =R0 ;
	R6  = 0 (X);
	[FP +-40] =R0 ;
	[FP +-44] =R0 ;
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$407;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$408;
	R0  =P3 ;
	call _register_Btype;
	[FP +-44] =R0 ;
L$L$408:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 122 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$409;
	P2 +=2;
	[P4 ] =P2 ;
	R0  =P4 ;
	call _consume_count_with_underscores;
	[FP +-48] =R0 ;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$419;
	R1  =[P3 +64];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$412;
	P2  =[P3 +68];
	R3  =P2 ;
	cc =R0 <R3 ;
	if cc jump 6; jump.l L$L$419;
L$L$412:
	R0  =P4 ;
	call _consume_count_with_underscores;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$419;
	P2  =[P3 +64];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$413;
	P1  =[FP +-48];
	P1  =P1 <<2;
	[FP +-52] =P1 ;
	P2 =P1 +P2 ;
	R0  =R5 ;
	R1  =[P2 ];
	call _string_append;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$407;
	P2  =[P3 +64];
	P1  =[FP +-52];
	P2 =P1 +P2 ;
	R0  =P5 ;
	R1  =[P2 ];
	call _string_append;
	jump.s L$L$407;
L$L$413:
	R0  =R5 ;
	R1  =[FP +-48];
	call _string_append_template_idx;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$407;
	R0  =P5 ;
	R1  =[FP +-48];
	call _string_append_template_idx;
	jump.s L$L$407;
L$L$409:
	R0  =P4 ;
	call _consume_count;
	[FP +-28] =R0 ;
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$419;
	R0  =[P4 ];
	call _strlen;
	R1  =[FP +-28];
	cc =R0 <R1 ;
	if cc jump 6; jump.l L$L$418;
L$L$419:
	R0  = 0 (X);
	jump.s L$L$406;
L$L$418:
	R0  = 0 (X);
	[FP +-40] =R0 ;
	R1  =[P3 ];
	R0  = 4 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$420;
	R2  = 8 (X);
	R0  =[P4 ];
	R1.L  = L$LC$175; R1.H  = L$LC$175;
	call _strncmp;
	R1  = 1 (X);
	cc =R0 ==0;
	R0  =[FP +-40];
	if cc R0  =R1 ; /* movsicc-1b */
	[FP +-40] =R0 ;
L$L$420:
	R0  =[FP +-40];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$421;
	R2  =[FP +-28];
	R0  =R5 ;
	R1  =[P4 ];
	call _string_appendn;
L$L$421:
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$422;
	R2  =[FP +-28];
	R0  =P5 ;
	R1  =[P4 ];
	call _string_appendn;
L$L$422:
	R1  =[P4 ];
	R0  =[FP +-28];
	R0 =R1 +R0 ;
	[P4 ] =R0 ;
L$L$407:
	R0  =[FP +-40];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$423;
	R0  =R5 ;
	R1.L  = L$LC$23; R1.H  = L$LC$23;
	call _string_append;
L$L$423:
	R0  =P4 ;
	R1  =FP ;
	R1 +=-28;
	call _get_count;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$406;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$425;
	P2  =[FP +-28];
	P2  =P2 <<2;
	R0  =P2 ;
	call _xmalloc;
	[P3 +64] =R0 ;
	R0  =[FP +-28];
	[P3 +68] =R0 ;
	P1  = 0 (X);
	cc =R4 <R0 ;
	if cc jump 6; jump.l L$L$425;
L$L$430:
	P2  =[P3 +64];
	P2  =P2 +(P1 <<2);
	R0  = 0 (X);
	[P2 ] =R0 ;
	P1 +=1;
	P2  =[FP +-28];
	cc =P1 <P2 ;
	if !cc jump 6; jump.l L$L$430;
L$L$425:
	P5  = 0 (X);
	P2  =[FP +-28];
	cc =P5 <P2 ;
	if cc jump 6; jump.l L$L$432;
L$L$452:
	R0  =[FP +-36];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$435;
	R0  =R5 ;
	R1.L  = L$LC$110; R1.H  = L$LC$110;
	call _string_append;
L$L$435:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 90 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$436;
	P2 +=1;
	[P4 ] =P2 ;
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =P4 ;
	call _do_type;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$437;
	R0  =R5 ;
	R1  =FP ;
	R1 +=-12;
	call _string_appends;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$437;
	R1  =[FP +-8];
	R0  =[FP +-12];
	R0  =R1 -R0 ;
	[FP +-56] =R0 ;
	P1  =[P3 +64];
	P2  =P5 <<2;
	[FP +-60] =P2 ;
	P1 =P2 +P1 ;
	[FP +-64] =P1 ;
	R0 +=1;
	call _xmalloc;
	P2  =[FP +-64];
	[P2 ] =R0 ;
	P2  =[P3 +64];
	P1  =[FP +-60];
	P2 =P1 +P2 ;
	R1  =[P2 ];
	R0  =[FP +-12];
	R2  =[FP +-56];
	call _bcopy;
	P2  =[P3 +64];
	P1  =[FP +-60];
	P2 =P1 +P2 ;
	P2  =[P2 ];
	P1  =[FP +-56];
	P1 =P2 +P1 ;
	R3  = 0 (X);
	B [P1 ] =R3 ;
L$L$437:
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	jump.s L$L$442;
L$L$436:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 122 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$441;
	P2 +=1;
	[P4 ] =P2 ;
	R2  =R5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_template_template_parm;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$432;
	R0  =P4 ;
	call _consume_count;
	[FP +-68] =R0 ;
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$442;
	R0  =[P4 ];
	call _strlen;
	P2  =[FP +-68];
	R3  =P2 ;
	cc =R0 <R3 ;
	if !cc jump 6; jump.l L$L$442;
	R0  =R5 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
	R2  =[FP +-68];
	R0  =R5 ;
	R1  =[P4 ];
	call _string_appendn;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$443;
	P2  =[P3 +64];
	P1  =P5 <<2;
	[FP +-72] =P1 ;
	P2 =P1 +P2 ;
	[FP +-76] =P2 ;
	P2  =[FP +-68];
	R0  =P2 ;
	R0 +=1;
	call _xmalloc;
	P2  =[FP +-76];
	[P2 ] =R0 ;
	P2  =[P3 +64];
	P1  =[FP +-72];
	P2 =P1 +P2 ;
	R1  =[P2 ];
	R0  =[P4 ];
	R2  =[FP +-68];
	call _bcopy;
	P1  =[P3 +64];
	P2  =[FP +-72];
	P1 =P2 +P1 ;
	P1  =[P1 ];
	P2  =[FP +-68];
	P2 =P1 +P2 ;
	R3  = 0 (X);
	B [P2 ] =R3 ;
L$L$443:
	R0  =[P4 ];
	P2  =[FP +-68];
	R1  =P2 ;
	R0 =R1 +R0 ;
	[P4 ] =R0 ;
L$L$442:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$432;
	jump.s L$L$440;
L$L$441:
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =P4 ;
	call _do_type;
	R6  =R0 ;
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$432;
	[FP +-80] =R5 ;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$448;
	R0  =FP ;
	R0 +=-24;
	[FP +-80] =R0 ;
	call _string_init;
L$L$448:
	[SP +12] =R6 ;
	R2  =[FP +-80];
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_template_value_parm;
	R6  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$449;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$450;
	R0  =[FP +-80];
	call _string_delete;
L$L$450:
	R6  = 0 (X);
	jump.s L$L$432;
L$L$449:
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$440;
	R0  =[FP +-80];
	P2  =R0 ;
	R1  =[P2 +4];
	R0  =[P2 ];
	R1  =R1 -R0 ;
	[FP +-84] =R1 ;
	P1  =[P3 +64];
	P2  =P5 <<2;
	[FP +-88] =P2 ;
	P1 =P2 +P1 ;
	[FP +-92] =P1 ;
	R0  = 1 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	call _xmalloc;
	P2  =[FP +-92];
	[P2 ] =R0 ;
	P2  =[P3 +64];
	P1  =[FP +-88];
	P2 =P1 +P2 ;
	R1  =[P2 ];
	P2  =[FP +-80];
	R0  =[P2 ];
	R2  =[FP +-84];
	call _bcopy;
	P2  =[P3 +64];
	P1  =[FP +-88];
	P2 =P1 +P2 ;
	P2  =[P2 ];
	P1  =[FP +-84];
	P1 =P2 +P1 ;
	R3  = 0 (X);
	B [P1 ] =R3 ;
	R0  =R5 ;
	R1  =[FP +-80];
	call _string_appends;
	R0  =[FP +-80];
	call _string_delete;
L$L$440:
	R0  = 1 (X);
	[FP +-36] =R0 ;
	P5 +=1;
	P2  =[FP +-28];
	cc =P5 <P2 ;
	if !cc jump 6; jump.l L$L$452;
L$L$432:
	R0  =[FP +-40];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$453;
	R0  =R5 ;
	R1.L  = L$LC$107; R1.H  = L$LC$107;
	jump.s L$L$461;
L$L$453:
	P2  =R5 ;
	R0  =[P2 +4];
	P2  =R0 ;
	R0  = B [P2 +-1] (X);
	R1  = 62 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$455;
	R0  =R5 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$455:
	R0  =R5 ;
	R1.L  = L$LC$19; R1.H  = L$LC$19;
L$L$461:
	call _string_append;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$456;
	R0  =[FP +-32];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$456;
	P2  =R5 ;
	R3  =[P2 ];
	R2  =[P2 +4];
	R1  =R2 -R3 ;
	R0  = 0 (X);
	cc =R3 ==R2 ;
	if !cc R2  =R1 ; if cc R2 =R0 ; /* movsicc-1 */
	R0  =[FP +-44];
	[SP +12] =R0 ;
	R0  =P3 ;
	R1  =[P2 ];
	call _remember_Btype;
L$L$456:
	R0  =R6 ;
L$L$406:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$176:
.dw	0x5f5f;
.dw	0x7470;
.dw	0x5f5f;
.db	0x00;
.align 2
L$LC$177:
.dw	0x5f5f;
.dw	0x6d74;
.dw	0x5f5f;
.db	0x00;
.align 2
L$LC$178:
.dw	0x5f5f;
.dw	0x7370;
.dw	0x5f5f;
.db	0x00;
.align 2
L$LC$179:
.dw	0x5f5f;
.db	0x53;
.db	0x00;
.align 2
.type _arm_pt, STT_FUNC;
_arm_pt:
	LINK 0;
	[--sp] = ( r7:5, p5:3 );
	P3  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P4  =[FP +20];
	P5  =[FP +24];
	R1  =[P3 ];
	R0  = 6144 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$463;
	R0  =R5 ;
	R1.L  = L$LC$176; R1.H  = L$LC$176;
	call _strstr;
	[P4 ] =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$463;
	R0 +=6;
	[P5 ] =R0 ;
	R0  =P5 ;
	call _consume_count;
	R2  =R0 ;
	R1  = 0 (X);
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$462;
	P2  =[P5 ];
	R0  =P2 ;
	R2 =R2 +R0 ;
	R0 =R5 +R6 ;
	cc =R2 ==R0 ;
	if cc jump 6; jump.l L$L$463;
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$475;
L$L$463:
	P3  =[P3 ];
	R0  = 8448 (X);
	R1  =P3 ;
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$466;
	R0  =R5 ;
	R1.L  = L$LC$177; R1.H  = L$LC$177;
	call _strstr;
	[P4 ] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$468;
	R0  =R5 ;
	R1.L  = L$LC$178; R1.H  = L$LC$178;
	call _strstr;
	[P4 ] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$468;
	R0  =R5 ;
	R1.L  = L$LC$176; R1.H  = L$LC$176;
	call _strstr;
	[P4 ] =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$467;
L$L$468:
	P4  =[P4 ];
	P4 +=6;
	[P5 ] =P4 ;
	jump.s L$L$478;
L$L$467:
	R0  =R5 ;
	R1.L  = L$LC$179; R1.H  = L$LC$179;
	call _strstr;
	[P4 ] =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$466;
	R0 +=3;
	[P5 ] =R0 ;
L$L$478:
	R0  =P5 ;
	call _consume_count;
	R1  = 0 (X);
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$462;
	P2  =[P5 ];
	R1  =P2 ;
	R0 =R0 +R1 ;
	R6 =R5 +R6 ;
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$466;
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$466;
L$L$475:
	P2 +=1;
	[P5 ] =P2 ;
	R1  = 1 (X);
	jump.s L$L$462;
L$L$466:
	R1  = 0 (X);
L$L$462:
	R0  =R1 ;
	( r7:5, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$180:
.db	0x2c;
.db	0x00;
.align 2
L$LC$181:
.dw	0x475f;
.dw	0x4f4c;
.dw	0x4142;
.dw	0x5f4c;
.db	0x00;
.align 2
L$LC$182:
.dw	0x617b;
.dw	0x6f6e;
.dw	0x796e;
.dw	0x6f6d;
.dw	0x7375;
.db	0x7d;
.db	0x00;
.align 2
.type _demangle_arm_hp_template, STT_FUNC;
_demangle_arm_hp_template:
	LINK 36;
	[--sp] = ( r7:4, p5:3 );
	R4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P3  =[FP +20];
	P1  =R1 ;
	R0  =[P1 ];
	R1 =R2 +R0 ;
	P4  =R1 ;
	P1  =R4 ;
	R2  =[P1 ];
	R1  = 4096 (X);
	R1  =R2 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$480;
	R1  = B [P4 ] (X);
	R2  = 88 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$480;
	R1  = 60 (X);
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$481;
	P1  =R5 ;
	R1  =[P1 ];
	R2  =R0 -R1 ;
	R0  =P3 ;
	cc =R2 <R6 ;
	if !cc jump 6; jump.l L$L$528;
L$L$481:
	R2  =R6 ;
	R0  =P3 ;
	P2  =R5 ;
	R1  =[P2 ];
L$L$528:
	call _string_appendn;
	P1  =R5 ;
	R0  =[P1 ];
	R6 =R6 +R0 ;
	R6 +=1;
	[P1 ] =R6 ;
	R0  =FP ;
	R0 +=-12;
	call _string_init;
	P2  =R4 ;
	R0  =[P2 +52];
	cc =R0 ==-1;
	if cc jump 6; jump.l L$L$483;
	R1  =[P3 +4];
	R0  =[P3 ];
	R0  =R1 -R0 ;
	[P2 +52] =R0 ;
L$L$483:
	R0  =P3 ;
	R1.L  = L$LC$23; R1.H  = L$LC$23;
L$L$529:
	call _string_append;
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	P2  =R5 ;
	P1  =[P2 ];
	R0  = B [P1 ] (X);
	P1  =R0 ;
	P2  = -65 (X);
	P2 =P2 +P1 ; //immed->Preg 
	P1  =P2 ;
	P2  = 20 (X);
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$490;
P2.L =L$L$497;
P2.H =L$L$497;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$497:
	.dd		L$L$494;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$490;
	.dd		L$L$492;
	.dd		L$L$488;
	.dd		L$L$492;
L$L$488:
	P1  =R5 ;
	R0  =[P1 ];
	R0 +=1;
	[P1 ] =R0 ;
	R2  =FP ;
	R2 +=-12;
	R0  =R4 ;
	R1  =R5 ;
	call _do_type;
	jump.s L$L$530;
L$L$492:
	R2  =FP ;
	R2 +=-12;
	R0  =R4 ;
	R1  =R5 ;
	call _do_hpacc_template_const_value;
	jump.s L$L$530;
L$L$494:
	R2  =FP ;
	R2 +=-12;
	R0  =R4 ;
	R1  =R5 ;
	call _do_hpacc_template_literal;
L$L$530:
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$490;
	R0  =P3 ;
	R1  =FP ;
	R1 +=-12;
	call _string_appends;
	P2  =R5 ;
	R0  =[P2 ];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$490;
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$490;
	R0  =P3 ;
	R1.L  = L$LC$180; R1.H  = L$LC$180;
	jump.s L$L$529;
L$L$490:
	R0  =P3 ;
	R1.L  = L$LC$19; R1.H  = L$LC$19;
	call _string_append;
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	P1  =R5 ;
	P2  =[P1 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$479;
	P2 +=1;
	[P1 ] =P2 ;
	jump.s L$L$479;
L$L$480:
	P2  = -28 (X);
	P2 =P2 +FP ; //immed->Preg 
	[SP +12] =P2 ;
	P2  = -32 (X);
	P2 =P2 +FP ; //immed->Preg 
	[SP +16] =P2 ;
	R2  =R6 ;
	R0  =R4 ;
	P1  =R5 ;
	R1  =[P1 ];
	call _arm_pt;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$504;
	R0  =FP ;
	R0 +=-12;
	call _string_init;
	R0  =[FP +-28];
	P2  =R5 ;
	R1  =[P2 ];
	R2  =R0 -R1 ;
	R0  =P3 ;
	call _string_appendn;
	P1  =R4 ;
	R0  =[P1 +52];
	cc =R0 ==-1;
	if cc jump 6; jump.l L$L$505;
	R1  =[P3 +4];
	R0  =[P3 ];
	R0  =R1 -R0 ;
	[P1 +52] =R0 ;
L$L$505:
	R0  =P3 ;
	R1.L  = L$LC$23; R1.H  = L$LC$23;
	call _string_append;
	P2  =[FP +-32];
	cc =P2 <P4  (iu);
	if cc jump 6; jump.l L$L$512;
	P5  = -12 (X);
	P5 =P5 +FP ; //immed->Preg 
L$L$521:
	R0  =P5 ;
	call _string_delete;
	P2  =[FP +-32];
	R0  = B [P2 ] (X);
	R1  = 76 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$515;
	R2  = 88 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$517;
	P2 +=1;
	[FP +-32] =P2 ;
	R2  =FP ;
	R2 +=-24;
	R0  =R4 ;
	R1  =FP ;
	R1 +=-32;
	call _do_type;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$512;
	R0  =P5 ;
	R1.L  = L$LC$167; R1.H  = L$LC$167;
	call _string_append;
	R0  =P5 ;
	R1  =FP ;
	R1 +=-24;
	call _string_appends;
	R0  =FP ;
	R0 +=-24;
	call _string_delete;
	R0  =P5 ;
	R1.L  = L$LC$168; R1.H  = L$LC$168;
	call _string_append;
	P2  =[FP +-32];
	R0  = B [P2 ] (X);
	R2  = 76 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$512;
	P2 +=1;
	[FP +-32] =P2 ;
	R0  =FP ;
	R0 +=-32;
	R1  =P5 ;
	jump.s L$L$531;
L$L$515:
	R0  =[FP +-32];
	R0 +=1;
	[FP +-32] =R0 ;
	R0  =FP ;
	R0 +=-32;
	R1  =FP ;
	R1 +=-12;
L$L$531:
	call _snarf_numeric_literal;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$512;
	jump.s L$L$509;
L$L$517:
	R0  =[FP +-32];
	[FP +-36] =R0 ;
	R2  =FP ;
	R2 +=-12;
	R0  =R4 ;
	R1  =FP ;
	R1 +=-32;
	call _do_type;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$512;
	R1  =[FP +-32];
	R0  =[FP +-36];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$479;
L$L$509:
	R0  =P3 ;
	R1  =FP ;
	R1 +=-12;
	call _string_appends;
	R0  =P3 ;
	R1.L  = L$LC$180; R1.H  = L$LC$180;
	call _string_append;
	P2  =[FP +-32];
	cc =P2 <P4  (iu);
	if !cc jump 6; jump.l L$L$521;
L$L$512:
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	P2  =[FP +-32];
	cc =P2 <P4  (iu);
	if !cc jump 6; jump.l L$L$522;
	R0  =[P3 +4];
	R0 +=-1;
	[P3 +4] =R0 ;
L$L$522:
	R0  =P3 ;
	R1.L  = L$LC$19; R1.H  = L$LC$19;
	jump.s L$L$532;
L$L$504:
	R0  = 10 (X);
	cc =R6 <=R0 ;
	if !cc jump 6; jump.l L$L$524;
	R2  = 8 (X);
	P1  =R5 ;
	R0  =[P1 ];
	R1.L  = L$LC$181; R1.H  = L$LC$181;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$524;
	P2  =R5 ;
	R2  =[P2 ];
	P1  =R2 ;
	R0  = B [P1 +9] (X);
	R1  = 78 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$524;
	R1  = B [P1 +8] (X);
	R2  = B [P1 +10] (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$524;
	R0.L  = _cplus_markers; R0.H  = _cplus_markers;
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$524;
	R0  =P3 ;
	R1.L  = L$LC$182; R1.H  = L$LC$182;
L$L$532:
	call _string_append;
	jump.s L$L$503;
L$L$524:
	P1  =R4 ;
	R0  =[P1 +52];
	cc =R0 ==-1;
	if cc jump 6; jump.l L$L$526;
	P2  = 0 (X);
	[P1 +52] =P2 ;
L$L$526:
	R2  =R6 ;
	R0  =P3 ;
	P1  =R5 ;
	R1  =[P1 ];
	call _string_appendn;
L$L$503:
	P2  =R5 ;
	R0  =[P2 ];
	R6 =R6 +R0 ;
	[P2 ] =R6 ;
L$L$479:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_class_name, STT_FUNC;
_demangle_class_name:
	LINK 0;
	[--sp] = ( r7:4, p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	R4  =R2 ;
	R5  = 0 (X);
	R0  =R1 ;
	call _consume_count;
	R6  =R0 ;
	R0  = 0 (X);
	cc =R6 ==-1;
	if !cc jump 6; jump.l L$L$533;
	R0  =[P5 ];
	call _strlen;
	cc =R0 <R6 ;
	if !cc jump 6; jump.l L$L$535;
	[SP +12] =R4 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_arm_hp_template;
	R5  = 1 (X);
L$L$535:
	R0  =R5 ;
L$L$533:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_class, STT_FUNC;
_demangle_class:
	LINK 12;
	[--sp] = ( r7:4, p5:3 );
	P5  =R0 ;
	R6  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	P3  = 0 (X);
	P4  = -12 (X);
	P4 =P4 +FP ; //immed->Preg 
	R0  =P4 ;
	call _string_init;
	R0  =P5 ;
	call _register_Btype;
	R4  =R0 ;
	R2  =P4 ;
	R0  =P5 ;
	R1  =R6 ;
	call _demangle_class_name;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$537;
	R6  =[FP +-8];
	R0  =[P5 +40];
	R1  = 1 (X);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$539;
	R0  =[P5 +44];
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$538;
L$L$539:
	R1  =[P5 +52];
	R0  = 1 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	cc =R0 <=1 (iu);
	if !cc jump 6; jump.l L$L$540;
	R0  =[FP +-12];
	R1 =R0 +R1 ;
	[FP +-8] =R1 ;
L$L$540:
	R1  =FP ;
	R1 +=-12;
	R0  =R5 ;
	call _string_prepends;
	R1  =[P5 +44];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$541;
	R0  =R5 ;
	R1.L  = L$LC$83; R1.H  = L$LC$83;
	call _string_prepend;
	R0  =[P5 +44];
	R0 +=-1;
	[P5 +44] =R0 ;
	jump.s L$L$538;
L$L$541:
	R0  =[P5 +40];
	R0 +=-1;
	[P5 +40] =R0 ;
L$L$538:
	[FP +-8] =R6 ;
	R1  =[FP +-12];
	R2  =R6 -R1 ;
	R0  = 0 (X);
	cc =R1 ==R6 ;
	if cc R2  =R0 ; /* movsicc-1b */
	R0  =P5 ;
	call _remember_Ktype;
	R1  =[FP +-12];
	R3  =[FP +-8];
	R2  =R3 -R1 ;
	R0  = 0 (X);
	cc =R1 ==R3 ;
	if cc R2  =R0 ; /* movsicc-1b */
	[SP +12] =R4 ;
	R0  =P5 ;
	call _remember_Btype;
	P5  =[P5 ];
	R0  = 4 (X);
	R3  =P5 ;
	R0  =R3 &R0 ;
	R2.L  = L$LC$161; R2.H  = L$LC$161;
	R1.L  = L$LC$160; R1.H  = L$LC$160;
	cc =R0 ==0;
	if cc R1  =R2 ; /* movsicc-2a */
	R0  =R5 ;
	call _string_prepend;
	R1  =FP ;
	R1 +=-12;
	R0  =R5 ;
	call _string_prepends;
	P3  = 1 (X);
L$L$537:
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	R0  =P3 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _iterate_demangle_function, STT_FUNC;
_iterate_demangle_function:
	LINK 0;
	UNLINK;
	rts;


.align 2
L$LC$183:
.dw	0x695f;
.dw	0x706d;
.dw	0x5f5f;
.db	0x00;
.align 2
L$LC$184:
.dw	0x5f5f;
.dw	0x6d69;
.dw	0x5f70;
.db	0x00;
.align 2
L$LC$185:
.dw	0x5f5f;
.dw	0x7473;
.dw	0x5f64;
.db	0x5f;
.db	0x00;
.align 2
L$LC$186:
.dw	0x5f5f;
.dw	0x7473;
.dw	0x5f69;
.db	0x5f;
.db	0x00;
.align 2
L$LC$187:
.db	0x5f;
.db	0x00;
.align 2
L$LC$188:
.dw	0x5f5f;
.db	0x00;
.align 2
.type _demangle_prefix, STT_FUNC;
_demangle_prefix:
	LINK 0;
	[--sp] = ( r7:5, p5:3 );
	P4  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R5  = 1 (X);
	R0  =[P5 ];
	call _strlen;
	cc =R0 <=6 (iu);
	if !cc jump 6; jump.l L$L$551;
	R2  = 6 (X);
	R0  =[P5 ];
	R1.L  = L$LC$183; R1.H  = L$LC$183;
	call _strncmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$552;
	R2  = 6 (X);
	R0  =[P5 ];
	R1.L  = L$LC$184; R1.H  = L$LC$184;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$551;
L$L$552:
	R0  =[P5 ];
	R0 +=6;
	[P5 ] =R0 ;
	R0  = 1 (X);
	[P4 +60] =R0 ;
	jump.s L$L$553;
L$L$551:
	R0  =[P5 ];
	call _strlen;
	R1  = 10 (X);
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$554;
	R2  = 8 (X);
	R0  =[P5 ];
	R1.L  = L$LC$181; R1.H  = L$LC$181;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$554;
	P2  =[P5 ];
	R1  = B [P2 +8] (X);
	R0.L  = _cplus_markers; R0.H  = _cplus_markers;
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$553;
	P2  =[P5 ];
	P1  =R0 ;
	R1  = B [P1 ] (X);
	R0  = B [P2 +10] (X);
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$553;
	R0  = B [P2 +9] (X);
	R1  = 68 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$556;
	P2 +=11;
	[P5 ] =P2 ;
	P1  = 2 (X);
	[P4 +44] =P1 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _gnu_special;
	R1  =R0 ;
	R0  =R5 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$550;
	jump.s L$L$553;
L$L$556:
	P2  =[P5 ];
	R0  = B [P2 +9] (X);
	R1  = 73 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$553;
	P2 +=11;
	[P5 ] =P2 ;
	P1  = 2 (X);
	[P4 +40] =P1 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _gnu_special;
	R1  =R0 ;
	R0  =R5 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$550;
	jump.s L$L$553;
L$L$554:
	R1  =[P4 ];
	R0  = 14336 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$553;
	R2  = 7 (X);
	R0  =[P5 ];
	R1.L  = L$LC$185; R1.H  = L$LC$185;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$562;
	R0  =[P5 ];
	R0 +=7;
	[P5 ] =R0 ;
	P2  = 2 (X);
	[P4 +44] =P2 ;
	jump.s L$L$553;
L$L$562:
	R1  =[P4 ];
	R0  = 14336 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$553;
	R2  = 7 (X);
	R0  =[P5 ];
	R1.L  = L$LC$186; R1.H  = L$LC$186;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$553;
	R0  =[P5 ];
	R0 +=7;
	[P5 ] =R0 ;
	R0  = 2 (X);
	[P4 +40] =R0 ;
L$L$553:
	P3  =[P5 ];
L$L$565:
	R0  =P3 ;
	R1  = 95 (X);
	call _strchr;
	P3  =R0 ;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$599;
	P3 +=1;
	R0  = B [P3 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$565;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$599;
	P3 +=-1;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$599;
	R0  =P3 ;
	R1.L  = L$LC$187; R1.H  = L$LC$187;
	call _strspn;
	cc =R0 <=2;
	if !cc jump 6; jump.l L$L$571;
	P1  =R0 ;
	P3 =P3 +P1 ;
	P3 +=-2;
L$L$571:
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$599;
	R0  =[P4 +48];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$575;
	R2  = B [P3 ] (Z);
	P2  =R2 ;
	P2  =P2 +P2 ;
	R2  =P2 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R2 ; //immed->Dreg 
	P1  =R0 ;
	R2  = W[P1 ] (Z);
	R0  = 4 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$574;
	R0  = B [P3 ] (X);
	P3  =R0 ;
	P1  = 116 (X);
	cc =P3 ==P1 ;
	if !cc jump 6; jump.l L$L$574;
	jump.s L$L$599;
L$L$575:
	R0  =[P5 ];
	R1  =P3 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$578;
	R2  = B [P3 +2] (Z);
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R2 ; //immed->Dreg 
	P1  =R0 ;
	R2  = W[P1 ] (Z);
	R0  = 4 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$579;
	R0  = B [P3 +2] (X);
	R1  = 81 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$579;
	R1 +=35;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$579;
	R1 +=-41;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$579;
	R1 +=-3;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$578;
L$L$579:
	R1  =[P4 ];
	R0  = 7168 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$580;
	R2  = B [P3 +2] (Z);
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R2 ; //immed->Dreg 
	P1  =R0 ;
	R2  = W[P1 ] (Z);
	R0  = 4 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$580;
	P3 +=2;
	[P5 ] =P3 ;
	R0  =P5 ;
	call _consume_count;
	R0  =R6 ;
	R1  =[P5 ];
	call _string_append;
	R0  =[P5 ];
	call _strlen;
	R1  =[P5 ];
	R1 =R0 +R1 ;
	[P5 ] =R1 ;
	R5  = 1 (X);
	jump.s L$L$574;
L$L$580:
	R1  =[P4 ];
	R0  = 15360 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$582;
	R0  =[P4 +40];
	R0 +=1;
	[P4 +40] =R0 ;
L$L$582:
	P3 +=2;
	[P5 ] =P3 ;
	jump.s L$L$574;
L$L$578:
	R1  =[P4 ];
	R0  = 2048 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$584;
	R0  = B [P3 +2] (X);
	R1  = 112 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$584;
	R0  = B [P3 +3] (X);
	R1 +=4;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$587;
L$L$584:
	R1  =[P4 ];
	R0  = 8192 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$586;
	R0  = B [P3 +2] (X);
	R1  = 116 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$588;
	R0  = B [P3 +3] (X);
	R1 +=-7;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$587;
L$L$588:
	R0  = B [P3 +2] (X);
	R1  = 112 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$586;
	R0  = B [P3 +3] (X);
	R1 +=3;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$587;
	R0  = B [P3 +2] (X);
	R1 +=-3;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$586;
	R0  = B [P3 +3] (X);
	R1 +=4;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$586;
L$L$587:
	R5  = 1 (X);
	R0  =[P5 ];
	call _strlen;
	R2  =R0 ;
	[SP +12] =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_arm_hp_template;
	jump.s L$L$574;
L$L$586:
	R0  =[P5 ];
	R1  =P3 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$591;
	R2  = B [P3 +2] (Z);
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R2 ; //immed->Dreg 
	P1  =R0 ;
	R2  = W[P1 ] (Z);
	R0  = 4 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$591;
	R0  = B [P3 +2] (X);
	R1  = 116 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$591;
	R1  =[P4 ];
	R0  = 15360 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$593;
	R0  =P5 ;
	R1  =R6 ;
	call _arm_special;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$574;
L$L$593:
	R0  = B [P3 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$608;
L$L$597:
	P3 +=1;
	R0  = B [P3 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$597;
L$L$608:
	R0  =P3 ;
	R1.L  = L$LC$188; R1.H  = L$LC$188;
	call _strstr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$599;
	P1  =R0 ;
	R1  = B [P1 +2] (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$598;
L$L$599:
	R5  = 0 (X);
	jump.s L$L$574;
L$L$598:
	[SP +12] =R0 ;
	jump.s L$L$609;
L$L$591:
	R0  = B [P3 +2] (X);
	R5  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$574;
	[SP +12] =P3 ;
L$L$609:
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _iterate_demangle_function;
	jump.s L$L$550;
L$L$574:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$604;
	R0  =[P4 +40];
	cc =R0 ==2;
	if !cc jump 6; jump.l L$L$605;
	P4  =[P4 +44];
	cc =P4 ==2;
	if cc jump 6; jump.l L$L$604;
L$L$605:
	R0  =R6 ;
	R1  =[P5 ];
	call _string_append;
	R0  =[P5 ];
	call _strlen;
	R1  =[P5 ];
	R1 =R0 +R1 ;
	[P5 ] =R1 ;
	R5  = 1 (X);
L$L$604:
	R0  =R5 ;
L$L$550:
	( r7:5, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$189:
.dw	0x7620;
.dw	0x7269;
.dw	0x7574;
.dw	0x6c61;
.dw	0x7420;
.dw	0x6261;
.dw	0x656c;
.db	0x00;
.align 2
L$LC$190:
.dw	0x3130;
.dw	0x3332;
.dw	0x3534;
.dw	0x3736;
.dw	0x3938;
.dw	0x7451;
.db	0x00;
.align 2
L$LC$191:
.dw	0x5f5f;
.dw	0x6874;
.dw	0x6e75;
.dw	0x5f6b;
.db	0x00;
.align 2
L$LC$192:
.dw	0x6976;
.dw	0x7472;
.dw	0x6175;
.dw	0x206c;
.dw	0x7566;
.dw	0x636e;
.dw	0x6974;
.dw	0x6e6f;
.dw	0x7420;
.dw	0x7568;
.dw	0x6b6e;
.dw	0x2820;
.dw	0x6564;
.dw	0x746c;
.dw	0x3a61;
.dw	0x6425;
.dw	0x2029;
.dw	0x6f66;
.dw	0x2072;
.db	0x00;
.align 2
L$LC$193:
.dw	0x5f5f;
.db	0x74;
.db	0x00;
.align 2
L$LC$195:
.dw	0x7420;
.dw	0x7079;
.dw	0x5f65;
.dw	0x6e69;
.dw	0x6f66;
.dw	0x6620;
.dw	0x6e75;
.dw	0x7463;
.dw	0x6f69;
.db	0x6e;
.db	0x00;
.align 2
L$LC$194:
.dw	0x7420;
.dw	0x7079;
.dw	0x5f65;
.dw	0x6e69;
.dw	0x6f66;
.dw	0x6e20;
.dw	0x646f;
.db	0x65;
.db	0x00;
.align 2
.type _gnu_special, STT_FUNC;
_gnu_special:
	LINK 52;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R4  = 1 (X);
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$611;
	R1  = B [P2 +1] (X);
	R0.L  = _cplus_markers; R0.H  = _cplus_markers;
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$611;
	P2  =[P5 ];
	R0  = B [P2 +2] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$611;
	P2 +=3;
	[P5 ] =P2 ;
	R0  =[P4 +44];
	R0 +=1;
	[P4 +44] =R0 ;
	jump.s L$L$612;
L$L$611:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$613;
	R0  = B [P2 +1] (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$615;
	R0  = B [P2 +2] (X);
	R1 +=23;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$615;
	R0  = B [P2 +3] (X);
	R1 +=-2;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$615;
	R0  = B [P2 +4] (X);
	P2  =R0 ;
	P1  = 95 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$614;
L$L$615:
	P2  =[P5 ];
	R0  = B [P2 +1] (X);
	R1  = 118 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$613;
	R0  = B [P2 +2] (X);
	R1 +=-2;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$613;
	R1  = B [P2 +3] (X);
	R0.L  = _cplus_markers; R0.H  = _cplus_markers;
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$613;
L$L$614:
	P2  =[P5 ];
	R0  = B [P2 +2] (X);
	R1  = 118 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$616;
	P2 +=5;
	[P5 ] =P2 ;
	jump.s L$L$617;
L$L$616:
	R0  =[P5 ];
	R0 +=4;
	[P5 ] =R0 ;
L$L$617:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$619;
	R5  = 4 (X);
L$L$637:
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 81 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$623;
	cc =P2 <=P1 ;
	if cc jump 6; jump.l L$L$630;
	P1 +=-6;
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$623;
	jump.s L$L$625;
L$L$630:
	P1  = 116 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$624;
	jump.s L$L$625;
L$L$623:
	P2  = 0 (X);
	[SP +12] =P2 ;
	R0  = 1 (X);
	[SP +16] =R0 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_qualified;
	jump.s L$L$677;
L$L$624:
	R1  = 0 (X);
	[SP +12] =R1 ;
	P1  = 1 (X);
	[SP +16] =P1 ;
	[SP +20] =P1 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_template;
L$L$677:
	R4  =R0 ;
	jump.s L$L$621;
L$L$625:
	R0  =[P5 ];
	P2  =R0 ;
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P1  =P1 +P1 ;
	R0  =P1 ;
	R1.L  = __sch_istable; R1.H  = __sch_istable;
	R1 =R1 +R0 ; //immed->Dreg 
	P1  =R1 ;
	R0  = W[P1 ] (Z);
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$626;
	R0  =P5 ;
	call _consume_count;
	P3  =R0 ;
	R0  =[P5 ];
	call _strlen;
	R1  =P3 ;
	cc =R1 <=R0 ;
	if !cc jump 6; jump.l L$L$628;
	R4  = 1 (X);
	jump.s L$L$621;
L$L$626:
	R0  =[P5 ];
	R1.L  = _cplus_markers; R1.H  = _cplus_markers;
	call _strcspn;
	P3  =R0 ;
L$L$628:
	R2  =P3 ;
	R0  =R6 ;
	R1  =[P5 ];
	call _string_appendn;
	R0  =[P5 ];
	P1  =R0 ;
	P3 =P3 +P1 ;
	[P5 ] =P3 ;
L$L$621:
	R0  =[P5 ];
	R1.L  = _cplus_markers; R1.H  = _cplus_markers;
	call _strpbrk;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$631;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$618;
	R1  =[P5 ];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$631;
	R0  =[P4 ];
	R0  =R0 &R5 ;
	R2.L  = L$LC$161; R2.H  = L$LC$161;
	R1.L  = L$LC$160; R1.H  = L$LC$160;
	cc =R0 ==0;
	if cc R1  =R2 ; /* movsicc-2a */
	R0  =R6 ;
	call _string_append;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	jump.s L$L$618;
L$L$631:
	R4  = 0 (X);
	jump.s L$L$619;
L$L$618:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$637;
L$L$619:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$612;
	R0  =R6 ;
	R1.L  = L$LC$189; R1.H  = L$LC$189;
	jump.s L$L$680;
L$L$613:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$640;
	R1  = B [P2 +1] (X);
	R0.L  = L$LC$190; R0.H  = L$LC$190;
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$640;
	R0  =[P5 ];
	R1.L  = _cplus_markers; R1.H  = _cplus_markers;
	call _strpbrk;
	R5  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$640;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 81 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$643;
	cc =R0 <=R1 ;
	if cc jump 6; jump.l L$L$650;
	R1 +=-6;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$643;
	jump.s L$L$645;
L$L$650:
	R1  = 116 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$644;
	jump.s L$L$645;
L$L$643:
	P1  = 0 (X);
	[SP +12] =P1 ;
	P2  = 1 (X);
	[SP +16] =P2 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_qualified;
	jump.s L$L$678;
L$L$644:
	R0  = 0 (X);
	[SP +12] =R0 ;
	R1  = 1 (X);
	[SP +16] =R1 ;
	[SP +20] =R1 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_template;
L$L$678:
	R4  =R0 ;
	jump.s L$L$641;
L$L$645:
	R0  =P5 ;
	call _consume_count;
	P3  =R0 ;
	cc =P3 <0;
	if !cc jump 6; jump.l L$L$647;
	R0  =[P5 ];
	call _strlen;
	R1  =P3 ;
	cc =R1 <=R0 ;
	if !cc jump 6; jump.l L$L$646;
L$L$647:
	R4  = 0 (X);
	jump.s L$L$641;
L$L$646:
	P1  = 10 (X);
	cc =P3 <=P1 ;
	if !cc jump 6; jump.l L$L$648;
	R2  = 8 (X);
	R0  =[P5 ];
	R1.L  = L$LC$181; R1.H  = L$LC$181;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$648;
	P2  =[P5 ];
	R0  = B [P2 +9] (X);
	R1  = 78 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$648;
	R1  = B [P2 +8] (X);
	R0  = B [P2 +10] (X);
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$648;
	R0.L  = _cplus_markers; R0.H  = _cplus_markers;
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$648;
	R0  =R6 ;
	R1.L  = L$LC$182; R1.H  = L$LC$182;
	call _string_append;
	R0  =[P5 ];
	R1  =P3 ;
	R0 =R1 +R0 ;
	[P5 ] =R0 ;
	R1.L  = _cplus_markers; R1.H  = _cplus_markers;
	call _strpbrk;
	R5  =R0 ;
	jump.s L$L$641;
L$L$648:
	R2  =P3 ;
	R0  =R6 ;
	R1  =[P5 ];
	call _string_appendn;
	R0  =[P5 ];
	P1  =R0 ;
	P3 =P3 +P1 ;
	[P5 ] =P3 ;
L$L$641:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$662;
	R0  =[P5 ];
	cc =R5 ==R0 ;
	if cc jump 6; jump.l L$L$662;
	R5 +=1;
	[P5 ] =R5 ;
	P4  =[P4 ];
	R0  = 4 (X);
	R1  =P4 ;
	R0  =R1 &R0 ;
	R2.L  = L$LC$161; R2.H  = L$LC$161;
	R1.L  = L$LC$160; R1.H  = L$LC$160;
	cc =R0 ==0;
	if cc R1  =R2 ; /* movsicc-2a */
	R0  =R6 ;
	call _string_append;
	R0  =[P5 ];
	call _strlen;
	R5  =R0 ;
	R2  =R0 ;
	R0  =R6 ;
	R1  =[P5 ];
	call _string_appendn;
	R0  =[P5 ];
	R5 =R5 +R0 ;
	[P5 ] =R5 ;
	jump.s L$L$612;
L$L$640:
	R2  = 8 (X);
	R0  =[P5 ];
	R1.L  = L$LC$191; R1.H  = L$LC$191;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$656;
	R0  =[P5 ];
	R0 +=8;
	[P5 ] =R0 ;
	R0  =P5 ;
	call _consume_count;
	R5  =R0 ;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$662;
	R0  =[P5 ];
	R1  = 1 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	[P5 ] =R1 ;
	R0  =P4 ;
	call _internal_cplus_demangle;
	P3  =R0 ;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$662;
	P4  = -52 (X);
	P4 =P4 +FP ; //immed->Preg 
	[SP +12] =P4 ;
	P1.L  = L$LC$192; P1.H  = L$LC$192;
	[SP +16] =P1 ;
	R5  =-R5 ;
	[SP +20] =R5 ;
	call _sprintf;
	R0  =R6 ;
	R1  =P4 ;
	call _string_append;
	R0  =R6 ;
	R1  =P3 ;
	call _string_append;
	R0  =P3 ;
	call _free;
	R0  =[P5 ];
	call _strlen;
	R1  =[P5 ];
	R1 =R0 +R1 ;
	[P5 ] =R1 ;
	jump.s L$L$612;
L$L$656:
	R2  = 3 (X);
	R0  =[P5 ];
	R1.L  = L$LC$193; R1.H  = L$LC$193;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$662;
	P2  =[P5 ];
	R0  = B [P2 +3] (X);
	P2  =R0 ;
	P1  = 105 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$663;
	P1 +=-3;
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$662;
L$L$663:
	P2  =[P5 ];
	R0  = B [P2 +3] (X);
	P2  =R0 ;
	R0.L  = L$LC$195; R0.H  = L$LC$195;
	R5.L  = L$LC$194; R5.H  = L$LC$194;
	P1  = 105 (X);
	cc =P2 ==P1 ;
	if !cc R5  =R0 ; /* movsicc-1a */
	R0  =[P5 ];
	R0 +=4;
	[P5 ] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 81 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$668;
	cc =R0 <=R1 ;
	if cc jump 6; jump.l L$L$672;
	R1 +=-6;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$668;
	jump.s L$L$670;
L$L$672:
	R1  = 116 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$669;
	jump.s L$L$670;
L$L$668:
	P1  = 0 (X);
	[SP +12] =P1 ;
	P2  = 1 (X);
	[SP +16] =P2 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_qualified;
	jump.s L$L$679;
L$L$669:
	R0  = 0 (X);
	[SP +12] =R0 ;
	R1  = 1 (X);
	[SP +16] =R1 ;
	[SP +20] =R1 ;
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _demangle_template;
	jump.s L$L$679;
L$L$670:
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _do_type;
L$L$679:
	R4  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$612;
	P5  =[P5 ];
	R0  = B [P5 ] (X);
	P5  =R0 ;
	R0  = 0 (X);
	cc =P5 ==0;
	if !cc R4  =R0 ; /* movsicc-2b */
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$612;
	R0  =R6 ;
	R1  =R5 ;
L$L$680:
	call _string_append;
	jump.s L$L$612;
L$L$662:
	R4  = 0 (X);
L$L$612:
	R0  =R4 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _recursively_demangle, STT_FUNC;
_recursively_demangle:
	LINK 0;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	R4  =[FP +20];
	R0  = 1 (X);
	R0 =R0 +R4 ; //immed->Dreg 
	call _xmalloc;
	R5  =R0 ;
	R0  =[P5 ];
	R2  =R4 ;
	R1  =R5 ;
	call _bcopy;
	R1 =R5 +R4 ;
	P2  =R1 ;
	R1  = 0 (X);
	B [P2 ] =R1 ;
	R0  =R5 ;
	R1  =[P3 ];
	call _cplus_demangle;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$682;
	R0  =P4 ;
	R1  =R6 ;
	call _string_append;
	R0  =R6 ;
	call _free;
	jump.s L$L$683;
L$L$682:
	R2  =R4 ;
	R0  =P4 ;
	R1  =[P5 ];
	call _string_appendn;
L$L$683:
	R0  =R5 ;
	call _free;
	R0  =[P5 ];
	R4 =R4 +R0 ;
	[P5 ] =R4 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$196:
.dw	0x5f5f;
.dw	0x7476;
.dw	0x6c62;
.dw	0x5f5f;
.db	0x00;
.align 2
.type _arm_special, STT_FUNC;
_arm_special:
	LINK 4;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	R6  = 1 (X);
	R2  = 8 (X);
	R0  =[P5 ];
	R1.L  = L$LC$196; R1.H  = L$LC$196;
	call _strncmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$685;
	R0  =[P5 ];
	R0 +=8;
	[FP +-4] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	P2  =R0 ;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$701;
L$L$691:
	R0  =FP ;
	R0 +=-4;
	call _consume_count;
	R1  = 0 (X);
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$684;
	R1  =[FP +-4];
	R1 =R0 +R1 ;
	[FP +-4] =R1 ;
	P2  =R1 ;
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$686;
	R0  = B [P2 +1] (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$686;
	P2 +=2;
	[FP +-4] =P2 ;
L$L$686:
	P2  =[FP +-4];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$691;
L$L$701:
	R0  =[P5 ];
	R0 +=8;
	[P5 ] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$703;
L$L$698:
	R0  =P5 ;
	call _consume_count;
	R4  =R0 ;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$696;
	R0  =[P5 ];
	call _strlen;
	cc =R4 <=R0 ;
	if !cc jump 6; jump.l L$L$695;
L$L$696:
	R1  = 0 (X);
	jump.s L$L$684;
L$L$695:
	R2  =R4 ;
	R0  =R5 ;
	R1  =[P5 ];
	call _string_prependn;
	R0  =[P5 ];
	R4 =R4 +R0 ;
	[P5 ] =R4 ;
	P2  =R4 ;
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$692;
	R4  = B [P2 +1] (X);
	cc =R4 ==R1 ;
	if cc jump 6; jump.l L$L$692;
	R0  =R5 ;
	R1.L  = L$LC$161; R1.H  = L$LC$161;
	call _string_prepend;
	R0  =[P5 ];
	R0 +=2;
	[P5 ] =R0 ;
L$L$692:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$698;
L$L$703:
	R0  =R5 ;
	R1.L  = L$LC$189; R1.H  = L$LC$189;
	call _string_append;
	jump.s L$L$699;
L$L$685:
	R6  = 0 (X);
L$L$699:
	R1  =R6 ;
L$L$684:
	R0  =R1 ;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_qualified, STT_FUNC;
_demangle_qualified:
	LINK 40;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	[FP +-32] =R2 ;
	R4  =[FP +20];
	R0  =[FP +24];
	[FP +-36] =R0 ;
	P5  = 0 (X);
	R5  = 1 (X);
	R0  =P3 ;
	call _register_Btype;
	[FP +-40] =R0 ;
	R6  = 0 (X);
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$706;
	R0  =[P3 +40];
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$707;
	R0  =[P3 +44];
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$706;
L$L$707:
	R6  = 1 (X);
L$L$706:
	R0  =FP ;
	R0 +=-16;
	call _string_init;
	R0  =FP ;
	R0 +=-28;
	call _string_init;
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 75 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$708;
	P2 +=1;
	[P4 ] =P2 ;
	R0  =P4 ;
	call _consume_count_with_underscores;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$727;
	P2  =[P3 +16];
	R2  =P2 ;
	cc =R0 <R2 ;
	if cc jump 6; jump.l L$L$727;
	P0  = -16 (X);
	P0 =P0 +FP ; //immed->Preg 
	P1  =[P3 +8];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	R0  =P0 ;
	R1  =[P1 ];
	call _string_append;
	jump.s L$L$712;
L$L$708:
	R0  =[P4 ];
	P2  =R0 ;
	R0  = B [P2 +1] (X);
	R1  = 57 (X);
	cc =R0 <=R1 ;
	if cc jump 6; jump.l L$L$729;
	R2  = 49 (X);
	cc =R0 <R2 ;
	if cc jump 6; jump.l L$L$724;
	jump.s L$L$727;
L$L$729:
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$727;
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R0  =P4 ;
	call _consume_count_with_underscores;
	P5  =R0 ;
	cc =P5 ==-1;
	if cc jump 6; jump.l L$L$712;
	jump.s L$L$727;
L$L$724:
	P2  =[P4 ];
	R2  = B [P2 +1] (X);
	B [FP +-4] =R2 ;
	R0  = 0 (X);
	B [FP +-3] =R0 ;
	R0  =FP ;
	R0 +=-4;
	call _atoi;
	P5  =R0 ;
	P2  =[P4 ];
	R0  = B [P2 +2] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$725;
	P2 +=1;
	[P4 ] =P2 ;
L$L$725:
	R0  =[P4 ];
	R0 +=2;
	[P4 ] =R0 ;
	jump.s L$L$712;
L$L$727:
	R5  = 0 (X);
L$L$712:
	R0  = 0 (X);
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$705;
	jump.s L$L$730;
L$L$767:
	R5  = 0 (X);
	jump.s L$L$732;
L$L$730:
	R0  =P5 ;
	P5 +=-1;
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$732;
L$L$754:
	R4  = 1 (X);
	R0  =FP ;
	R0 +=-28;
	call _string_clear;
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R2  = 95 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$734;
	P2 +=1;
	[P4 ] =P2 ;
L$L$734:
	R0  =[P4 ];
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 116 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$735;
	P2  = -28 (X);
	P2 =P2 +FP ; //immed->Preg 
	[SP +12] =P2 ;
	R2  = 1 (X);
	[SP +16] =R2 ;
	P2  = 0 (X);
	[SP +20] =P2 ;
	R2  =FP ;
	R2 +=-16;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_template;
	R5  =R0 ;
	jump.s L$L$768;
L$L$735:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 75 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$738;
	P2 +=1;
	[P4 ] =P2 ;
	R0  =P4 ;
	call _consume_count_with_underscores;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$740;
	P2  =[P3 +16];
	R2  =P2 ;
	cc =R0 <R2 ;
	if !cc jump 6; jump.l L$L$739;
L$L$740:
	R5  = 0 (X);
	jump.s L$L$741;
L$L$739:
	P1  =[P3 +8];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	R0  =FP ;
	R0 +=-16;
	R1  =[P1 ];
	call _string_append;
L$L$741:
	R4  = 0 (X);
L$L$768:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$732;
	jump.s L$L$737;
L$L$738:
	R1  =[P3 ];
	R0  = 8192 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$744;
	R0  =P4 ;
	call _consume_count;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$767;
	[SP +12] =R0 ;
	R2  =FP ;
	R2 +=-16;
	R0  =P3 ;
	R1  =P4 ;
	call _recursively_demangle;
	jump.s L$L$737;
L$L$744:
	R0  =FP ;
	R0 +=-28;
	call _string_delete;
	R2  =FP ;
	R2 +=-28;
	R0  =P3 ;
	R1  =P4 ;
	call _do_type;
	R5  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$732;
	R0  =FP ;
	R0 +=-16;
	R1  =FP ;
	R1 +=-28;
	call _string_appends;
L$L$737:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$748;
	R1  =[FP +-16];
	R2  =[FP +-12];
	R3  =R2 -R1 ;
	R0  = 0 (X);
	cc =R1 ==R2 ;
	if !cc R2  =R3 ; if cc R2 =R0 ; /* movsicc-1 */
	R0  =P3 ;
	call _remember_Ktype;
L$L$748:
	cc =P5 <=0;
	if !cc jump 6; jump.l L$L$731;
	P2  = -16 (X);
	P2 =P2 +FP ; //immed->Preg 
	R1  =[P3 ];
	R0  = 4 (X);
	R0  =R1 &R0 ;
	R1.L  = L$LC$161; R1.H  = L$LC$161;
	R2.L  = L$LC$160; R2.H  = L$LC$160;
	cc =R0 ==0;
	if !cc R1  =R2 ; /* movsicc-2b */
	R0  =P2 ;
	call _string_append;
L$L$731:
	R0  =P5 ;
	P5 +=-1;
	cc =R0 <=0;
	if cc jump 6; jump.l L$L$754;
L$L$732:
	R1  =[FP +-16];
	R2  =[FP +-12];
	R3  =R2 -R1 ;
	R0  = 0 (X);
	cc =R1 ==R2 ;
	if !cc R2  =R3 ; if cc R2 =R0 ; /* movsicc-1 */
	R0  =[FP +-40];
	[SP +12] =R0 ;
	R0  =P3 ;
	call _remember_Btype;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$757;
	R0  =FP ;
	R0 +=-16;
	R2  =[P3 ];
	R1  = 4 (X);
	R1  =R2 &R1 ;
	R3.L  = L$LC$161; R3.H  = L$LC$161;
	R2.L  = L$LC$160; R2.H  = L$LC$160;
	cc =R1 ==0;
	if cc R1  =R3 ; if !cc R1 =R2 ; /* movsicc-1 */
	call _string_append;
	R1  =[P3 +44];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$760;
	R0  =FP ;
	R0 +=-16;
	R1.L  = L$LC$83; R1.H  = L$LC$83;
	call _string_append;
L$L$760:
	R0  =FP ;
	R0 +=-16;
	R1  =FP ;
	R1 +=-28;
	call _string_appends;
L$L$757:
	R0  =[FP +-36];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$761;
	R1  =FP ;
	R1 +=-16;
	R0  =[FP +-32];
	call _string_appends;
	jump.s L$L$762;
L$L$761:
	R0  =[FP +-32];
	P2  =R0 ;
	R1  =[P2 ];
	R0  =[P2 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$763;
	R0  =FP ;
	R0 +=-16;
	P3  =[P3 ];
	R1  = 4 (X);
	R2  =P3 ;
	R1  =R2 &R1 ;
	R3.L  = L$LC$161; R3.H  = L$LC$161;
	R2.L  = L$LC$160; R2.H  = L$LC$160;
	cc =R1 ==0;
	if cc R1  =R3 ; if !cc R1 =R2 ; /* movsicc-1 */
	call _string_append;
L$L$763:
	R1  =FP ;
	R1 +=-16;
	R0  =[FP +-32];
	call _string_prepends;
L$L$762:
	R0  =FP ;
	R0 +=-28;
	call _string_delete;
	R0  =FP ;
	R0 +=-16;
	call _string_delete;
	R0  =R5 ;
L$L$705:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _get_count, STT_FUNC;
_get_count:
	LINK 4;
	[--sp] = ( p5:3 );
	P0  =R0 ;
	P5  =R1 ;
	R1  =[P0 ];
	P2  =R1 ;
	R1  = B [P2 ] (Z);
	P3  =R1 ;
	P3  =P3 +P3 ;
	R1  =P3 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R1 ; //immed->Dreg 
	P2  =R0 ;
	R1  = W[P2 ] (Z);
	R0  = 4 (X);
	R0  =R1 &R0 ;
	R1  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$769;
	P2  =[P0 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P2 +=-48;
	[P5 ] =P2 ;
	R3  =[P0 ];
	R3 +=1;
	[P0 ] =R3 ;
	P2  =R3 ;
	R2  = B [P2 ] (Z);
	P3  =R2 ;
	P3  =P3 +P3 ;
	R2  =P3 ;
	R0.L  = __sch_istable; R0.H  = __sch_istable;
	R0 =R0 +R2 ; //immed->Dreg 
	P2  =R0 ;
	R2  = W[P2 ] (Z);
	R0  = 4 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$771;
	P1  =[P5 ];
	P4.L  = __sch_istable; P4.H  = __sch_istable;
	R1  = 4 (X);
L$L$773:
	P1  =P1 +(P1 <<2);
	P3  =R3 ;
	R3 +=1;
	R0  = B [P3 ++] (X);
	P2  =R0 ;
	P1  =P2 +(P1 <<1);
	P1 +=-48;
	R0  = B [P3 ] (Z);
	P2  =R0 ;
	P2  =P4 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$773;
	R0  = B [P3 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$771;
	R3 +=1;
	[P0 ] =R3 ;
	[P5 ] =P1 ;
L$L$771:
	R1  = 1 (X);
L$L$769:
	R0  =R1 ;
	( p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$197:
.db	0x5b;
.db	0x00;
.align 2
L$LC$198:
.db	0x5d;
.db	0x00;
.align 2
.type _do_type, STT_FUNC;
_do_type:
	LINK 60;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	P5  =R2 ;
	R4  = 0 (X);
	R0  =FP ;
	R0 +=-12;
	call _string_init;
	R0  =P5 ;
	call _string_init;
	R5  = 0 (X);
	R6  = 1 (X);
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$780;
L$L$846:
	P1  =[P4 ];
	R0  = B [P1 ] (X);
	P1  =R0 ;
	P2  = -65 (X);
	P2 =P2 +P1 ; //immed->Preg 
	P1  =P2 ;
	P2  = 52 (X);
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$844;
P2.L =L$L$845;
P2.H =L$L$845;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$845:
	.dd		L$L$790;
	.dd		L$L$844;
	.dd		L$L$841;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$799;
	.dd		L$L$842;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$806;
	.dd		L$L$844;
	.dd		L$L$806;
	.dd		L$L$785;
	.dd		L$L$844;
	.dd		L$L$788;
	.dd		L$L$844;
	.dd		L$L$795;
	.dd		L$L$844;
	.dd		L$L$841;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$785;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$844;
	.dd		L$L$841;
L$L$785:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R1  =[P3 ];
	R0  = 4 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$786;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$35; R1.H  = L$LC$35;
	call _string_prepend;
L$L$786:
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$779;
	R4  = 1 (X);
	jump.s L$L$779;
L$L$788:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$78; R1.H  = L$LC$78;
	call _string_prepend;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$779;
	R4  = 2 (X);
	jump.s L$L$779;
L$L$790:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R0  =[FP +-12];
	P2  =[FP +-8];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$791;
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 42 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$792;
	R1  = 38 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$791;
L$L$792:
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$167; R1.H  = L$LC$167;
	call _string_prepend;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$168; R1.H  = L$LC$168;
	call _string_append;
L$L$791:
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$197; R1.H  = L$LC$197;
	call _string_append;
	R0  =[P4 ];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$793;
	P1  = 3 (X);
	[SP +12] =P1 ;
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_template_value_parm;
	R6  =R0 ;
L$L$793:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$794;
	P2 +=1;
	[P4 ] =P2 ;
L$L$794:
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$198; R1.H  = L$LC$198;
	jump.s L$L$875;
L$L$795:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R0  =P4 ;
	R1  =FP ;
	R1 +=-40;
	call _get_count;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$833;
	R1  =[FP +-40];
	R0  =[P3 +32];
	cc =R1 <R0 ;
	if cc jump 6; jump.l L$L$833;
	P1  =[FP +-40];
	P2  =[P3 +4];
	P2  =P2 +(P1 <<2);
	P2  =[P2 ];
	[FP +-44] =P2 ;
	P4  = -44 (X);
	P4 =P4 +FP ; //immed->Preg 
	jump.s L$L$779;
L$L$799:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R0  =[FP +-12];
	P2  =[FP +-8];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$800;
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 42 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$801;
	R1  = 38 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$800;
L$L$801:
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$167; R1.H  = L$LC$167;
	call _string_prepend;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$168; R1.H  = L$LC$168;
	call _string_append;
L$L$800:
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_nested_args;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$833;
	R0  =[P4 ];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$802;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$833;
L$L$802:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$865;
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$779;
	P2 +=1;
	[P4 ] =P2 ;
	jump.s L$L$779;
L$L$806:
	R0  = 0 (X);
	[FP +-48] =R0 ;
	P2  =[P4 ];
	R0  = B [P2 ++] (X);
	R1  = 77 (X);
	cc =R0 ==R1 ;
	R0  =CC ;
	[FP +-52] =R0 ;
	[P4 ] =P2 ;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$168; R1.H  = L$LC$168;
	call _string_append;
	R0  =[P4 ];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 81 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$807;
	R0  =FP ;
	R0 +=-12;
	R1  =[P3 ];
	R2  = 4 (X);
	R2  =R1 &R2 ;
	R3.L  = L$LC$161; R3.H  = L$LC$161;
	R1.L  = L$LC$160; R1.H  = L$LC$160;
	cc =R2 ==0;
	if cc R1  =R3 ; /* movsicc-2a */
	call _string_prepend;
L$L$807:
	P2  =[P4 ];
	R0  = B [P2 ] (Z);
	P2  =R0 ;
	P2  =P2 +P2 ;
	P1.L  = __sch_istable; P1.H  = __sch_istable;
	P1 =P1 +P2 ; //immed->Preg 
	R0  = W[P1 ] (Z);
	R1  = 4 (X);
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$810;
	R0  =P4 ;
	call _consume_count;
	[FP +-40] =R0 ;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$833;
	R0  =[P4 ];
	call _strlen;
	R1  =[FP +-40];
	cc =R0 <R1 ;
	if !cc jump 6; jump.l L$L$833;
	R2  =[FP +-40];
	R0  =FP ;
	R0 +=-12;
	R1  =[P4 ];
	call _string_prependn;
	R1  =[P4 ];
	R0  =[FP +-40];
	R0 =R1 +R0 ;
	[P4 ] =R0 ;
	jump.s L$L$813;
L$L$810:
	R0  =[P4 ];
	P1  =R0 ;
	R1  = B [P1 ] (X);
	R0  =R1 ;
	R1  = -88 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  = R1.B  (Z);
	cc =R0 <=1 (iu);
	if cc jump 6; jump.l L$L$814;
	R2  =FP ;
	R2 +=-24;
	R0  =P3 ;
	R1  =P4 ;
	call _do_type;
	R0  =FP ;
	R0 +=-12;
	R1  =FP ;
	R1 +=-24;
	call _string_prepends;
	R0  =FP ;
	R0 +=-24;
	jump.s L$L$873;
L$L$814:
	R0  =[P4 ];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 116 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$816;
	R0  =FP ;
	R0 +=-36;
	call _string_init;
	P1  = 0 (X);
	[SP +12] =P1 ;
	P2  = 1 (X);
	[SP +16] =P2 ;
	[SP +20] =P2 ;
	R2  =FP ;
	R2 +=-36;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_template;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$865;
	R1  =[FP +-36];
	R0  =[FP +-32];
	R2  =R0 -R1 ;
	R0  =FP ;
	R0 +=-12;
	call _string_prependn;
	R0  =FP ;
	R0 +=-36;
L$L$873:
	call _string_delete;
	jump.s L$L$813;
L$L$816:
	R0  =[P4 ];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R6  = 0 (X);
	R1  = 81 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$779;
	[SP +12] =R6 ;
	[SP +16] =R6 ;
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_qualified;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$865;
L$L$813:
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$167; R1.H  = L$LC$167;
	call _string_prepend;
	R0  =[FP +-52];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$834;
	R0  =[P4 ];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 86 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$827;
	cc =R0 <=R1 ;
	if cc jump 6; jump.l L$L$830;
	R1 +=-19;
	jump.s L$L$874;
L$L$830:
	R1  = 117 (X);
L$L$874:
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$824;
L$L$827:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	call _code_for_qualifier;
	R1  =[FP +-48];
	R1  =R1 |R0 ;
	[FP +-48] =R1 ;
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
L$L$824:
	P2  =[P4 ];
	R0  = B [P2 ++] (X);
	[P4 ] =P2 ;
	R0  = R0.B  (X);
	R1  = 70 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$833;
	R0  =[FP +-52];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$834;
	R2  =FP ;
	R2 +=-12;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_nested_args;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$833;
L$L$834:
	R0  =[P4 ];
	P1  =R0 ;
	R0  = B [P1 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$832;
L$L$833:
	R6  = 0 (X);
	jump.s L$L$779;
L$L$832:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R1  =[P3 ];
	R0  = 2 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$779;
	R0  =[FP +-48];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$779;
	R1  =[FP +-12];
	R0  =[FP +-8];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$837;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$837:
	R0  =[FP +-48];
	call _qualifier_string;
	R1  =R0 ;
	R0  =FP ;
	R0 +=-12;
L$L$875:
	call _string_append;
	jump.s L$L$779;
L$L$841:
	R1  =[P3 ];
	R0  = 2 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$842;
	R1  =[FP +-12];
	R0  =[FP +-8];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$843;
	R0  =FP ;
	R0 +=-12;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_prepend;
L$L$843:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	call _demangle_qualifier;
	R1  =R0 ;
	R0  =FP ;
	R0 +=-12;
	call _string_prepend;
L$L$842:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	jump.s L$L$779;
L$L$844:
	R5  = 1 (X);
L$L$779:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$865;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$846;
L$L$780:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$865;
	P1  =[P4 ];
	R0  = B [P1 ] (X);
	P1  =R0 ;
	P2  = -66 (X);
	P2 =P2 +P1 ; //immed->Preg 
	P1  =P2 ;
	P2  = 23 (X);
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$862;
P2.L =L$L$864;
P2.H =L$L$864;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$864:
	.dd		L$L$851;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$850;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$850;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$862;
	.dd		L$L$856;
	.dd		L$L$856;
L$L$850:
	R0  = 0 (X);
	[SP +12] =R0 ;
	R1  = 1 (X);
	[SP +16] =R1 ;
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_qualified;
	R6  =R0 ;
	jump.s L$L$847;
L$L$851:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R0  =P4 ;
	R1  =FP ;
	R1 +=-40;
	call _get_count;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$858;
	R1  =[FP +-40];
	R0  =[P3 +20];
	cc =R1 <R0 ;
	if cc jump 6; jump.l L$L$858;
	P2  =[FP +-40];
	P3  =[P3 +12];
	P2  =P3 +(P2 <<2);
	R0  =P5 ;
	R1  =[P2 ];
	call _string_append;
	jump.s L$L$847;
L$L$856:
	R0  =[P4 ];
	R0 +=1;
	[P4 ] =R0 ;
	R0  =P4 ;
	call _consume_count_with_underscores;
	R6  =R0 ;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$858;
	R0  =[P3 +64];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$859;
	P2  =[P3 +68];
	R0  =P2 ;
	cc =R6 <R0 ;
	if cc jump 6; jump.l L$L$858;
L$L$859:
	R0  =P4 ;
	call _consume_count_with_underscores;
	cc =R0 ==-1;
	if cc jump 6; jump.l L$L$857;
L$L$858:
	R6  = 0 (X);
	jump.s L$L$847;
L$L$857:
	P3  =[P3 +64];
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$860;
	P1  =R6 ;
	P2  =P3 +(P1 <<2);
	R0  =P5 ;
	R1  =[P2 ];
	call _string_append;
	jump.s L$L$861;
L$L$860:
	R0  =P5 ;
	R1  =R6 ;
	call _string_append_template_idx;
L$L$861:
	R6  = 1 (X);
	jump.s L$L$847;
L$L$862:
	R2  =P5 ;
	R0  =P3 ;
	R1  =P4 ;
	call _demangle_fund_type;
	R6  =R0 ;
	cc =R4 ==0;
	if cc R4  =R0 ; /* movsicc-1b */
L$L$847:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$865;
	R1  =[FP +-12];
	R0  =[FP +-8];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$867;
	R0  =P5 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
	R1  =FP ;
	R1 +=-12;
	R0  =P5 ;
	call _string_appends;
	jump.s L$L$867;
L$L$865:
	R0  =P5 ;
	call _string_delete;
L$L$867:
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	R0  = 0 (X);
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$778;
	R0  = 3 (X);
	cc =R4 ==0;
	if !cc R0  =R4 ; /* movsicc-1a */
L$L$778:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$199:
.dw	0x6e75;
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.db	0x00;
.align 2
L$LC$200:
.dw	0x6973;
.dw	0x6e67;
.dw	0x6465;
.db	0x00;
.align 2
L$LC$201:
.dw	0x5f5f;
.dw	0x6f63;
.dw	0x706d;
.dw	0x656c;
.db	0x78;
.db	0x00;
.align 2
L$LC$202:
.dw	0x6f76;
.dw	0x6469;
.db	0x00;
.align 2
L$LC$203:
.dw	0x6f6c;
.dw	0x676e;
.dw	0x6c20;
.dw	0x6e6f;
.db	0x67;
.db	0x00;
.align 2
L$LC$204:
.dw	0x6f6c;
.dw	0x676e;
.db	0x00;
.align 2
L$LC$205:
.dw	0x6e69;
.db	0x74;
.db	0x00;
.align 2
L$LC$206:
.dw	0x6873;
.dw	0x726f;
.db	0x74;
.db	0x00;
.align 2
L$LC$207:
.dw	0x6f62;
.dw	0x6c6f;
.db	0x00;
.align 2
L$LC$208:
.dw	0x6863;
.dw	0x7261;
.db	0x00;
.align 2
L$LC$209:
.dw	0x6377;
.dw	0x6168;
.dw	0x5f72;
.db	0x74;
.db	0x00;
.align 2
L$LC$210:
.dw	0x6f6c;
.dw	0x676e;
.dw	0x6420;
.dw	0x756f;
.dw	0x6c62;
.db	0x65;
.db	0x00;
.align 2
L$LC$211:
.dw	0x6f64;
.dw	0x6275;
.dw	0x656c;
.db	0x00;
.align 2
L$LC$212:
.dw	0x6c66;
.dw	0x616f;
.db	0x74;
.db	0x00;
.align 2
L$LC$213:
.dw	0x7825;
.db	0x00;
.align 2
L$LC$214:
.dw	0x6e69;
.dw	0x2574;
.dw	0x5f75;
.db	0x74;
.db	0x00;
.align 2
.type _demangle_fund_type, STT_FUNC;
_demangle_fund_type:
	LINK 48;
	[--sp] = ( r7:4, p5:3 );
	P5  =R0 ;
	P3  =R1 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	R4  = 0 (X);
	R5  = 1 (X);
	[FP +-40] =R4 ;
	R6  = 3 (X);
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$956;
L$L$894:
	P1  =[P3 ];
	R0  = B [P1 ] (X);
	P1  =R0 ;
	P2  = -67 (X);
	P2 =P2 +P1 ; //immed->Preg 
	P1  =P2 ;
	P2  = 50 (X);
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$892;
P2.L =L$L$893;
P2.H =L$L$893;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$893:
	.dd		L$L$883;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$890;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$888;
	.dd		L$L$892;
	.dd		L$L$886;
	.dd		L$L$883;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$892;
	.dd		L$L$883;
L$L$883:
	R1  =[P5 ];
	R0  = 2 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$884;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$885;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_prepend;
L$L$885:
	P2  =[P3 ];
	R0  = B [P2 ] (X);
	call _demangle_qualifier;
	R1  =R0 ;
	R0  =P4 ;
	call _string_prepend;
L$L$884:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	jump.s L$L$877;
L$L$886:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$887;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$887:
	R0  =P4 ;
	R1.L  = L$LC$199; R1.H  = L$LC$199;
	jump.s L$L$958;
L$L$888:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$889;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$889:
	R0  =P4 ;
	R1.L  = L$LC$200; R1.H  = L$LC$200;
	jump.s L$L$958;
L$L$890:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$891;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$891:
	R0  =P4 ;
	R1.L  = L$LC$201; R1.H  = L$LC$201;
L$L$958:
	call _string_append;
	jump.s L$L$877;
L$L$892:
	R4  = 1 (X);
L$L$877:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$894;
L$L$956:
	P1  =[P3 ];
	R0  = B [P1 ] (X);
	P1  =R0 ;
	P2  = 120 (X);
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$951;
P2.L =L$L$952;
P2.H =L$L$952;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$952:
	.dd		L$L$895;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$944;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$920;
	.dd		L$L$951;
	.dd		L$L$922;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$895;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$908;
	.dd		L$L$910;
	.dd		L$L$916;
	.dd		L$L$951;
	.dd		L$L$918;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$904;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$902;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$951;
	.dd		L$L$914;
	.dd		L$L$906;
	.dd		L$L$950;
	.dd		L$L$951;
	.dd		L$L$898;
	.dd		L$L$912;
	.dd		L$L$900;
L$L$898:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$899;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$899:
	R0  =P4 ;
	R1.L  = L$LC$202; R1.H  = L$LC$202;
	jump.s L$L$962;
L$L$900:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$901;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$901:
	R0  =P4 ;
	R1.L  = L$LC$203; R1.H  = L$LC$203;
	jump.s L$L$962;
L$L$902:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$903;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$903:
	R0  =P4 ;
	R1.L  = L$LC$204; R1.H  = L$LC$204;
	jump.s L$L$962;
L$L$904:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$905;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$905:
	R0  =P4 ;
	R1.L  = L$LC$205; R1.H  = L$LC$205;
	jump.s L$L$962;
L$L$906:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$907;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$907:
	R0  =P4 ;
	R1.L  = L$LC$206; R1.H  = L$LC$206;
	jump.s L$L$962;
L$L$908:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$909;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$909:
	R0  =P4 ;
	R1.L  = L$LC$207; R1.H  = L$LC$207;
	call _string_append;
	R6  = 4 (X);
	jump.s L$L$895;
L$L$910:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$911;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$911:
	R0  =P4 ;
	R1.L  = L$LC$208; R1.H  = L$LC$208;
	jump.s L$L$961;
L$L$912:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$913;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$913:
	R0  =P4 ;
	R1.L  = L$LC$209; R1.H  = L$LC$209;
L$L$961:
	call _string_append;
	R6  = 5 (X);
	jump.s L$L$895;
L$L$914:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$915;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$915:
	R0  =P4 ;
	R1.L  = L$LC$210; R1.H  = L$LC$210;
	jump.s L$L$960;
L$L$916:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$917;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$917:
	R0  =P4 ;
	R1.L  = L$LC$211; R1.H  = L$LC$211;
	jump.s L$L$960;
L$L$918:
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$919;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$919:
	R0  =P4 ;
	R1.L  = L$LC$212; R1.H  = L$LC$212;
L$L$960:
	call _string_append;
	R6  = 6 (X);
	jump.s L$L$895;
L$L$920:
	P2  =[P3 ];
	P2 +=1;
	[P3 ] =P2 ;
	R1  = B [P2 ] (Z);
	P2  =R1 ;
	P2  =P2 +P2 ;
	P1.L  = __sch_istable; P1.H  = __sch_istable;
	P1 =P1 +P2 ; //immed->Preg 
	R1  = W[P1 ] (Z);
	R0  = 4 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$951;
L$L$922:
	R1  =[P3 ];
	R1 +=1;
	[P3 ] =R1 ;
	P2  =R1 ;
	R0  = B [P2 ] (X);
	R2  = 95 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$923;
	R1 +=1;
	[P3 ] =R1 ;
	P1  = 0 (X);
	P2  = 8 (X);
	cc =P1 <=P2 ;
	if cc jump 6; jump.l L$L$925;
	P2  =R1 ;
	R1  = B [P2 ] (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$925;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$925;
	P5  = -12 (X);
	P5 =P5 +FP ; //immed->Preg 
L$L$929:
	P0 =P5 +P1 ;
	R0  =[P3 ];
	P2  =R0 ;
	R0 +=1;
	R1  = B [P2 ++] (X);
	B [P0 ] =R1 ;
	[P3 ] =R0 ;
	P1 +=1;
	P2  = 8 (X);
	cc =P1 <=P2 ;
	if cc jump 6; jump.l L$L$925;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$925;
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$929;
L$L$925:
	R0  =[P3 ];
	P2  =R0 ;
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$951;
	P1 =FP +P1 ;
	R2  = 0 (X);
	B [P1 +-12] =R2 ;
	R0  =[P3 ];
	R0 +=1;
	[P3 ] =R0 ;
	jump.s L$L$931;
L$L$923:
	R0  =FP ;
	R0 +=-12;
	R2  = 2 (X);
	R1  =[P3 ];
	call _strncpy;
	R1  = 0 (X);
	B [FP +-10] =R1 ;
	R4  =[P3 ];
	R0  =R4 ;
	call _strlen;
	R1  = 2 (X);
	R1 =R1 +R4 ; //immed->Dreg 
	cc =R0 <=1 (iu);
	if cc jump 6; jump.l L$L$933;
	R0  =[P3 ];
	call _strlen;
	R1 =R4 +R0 ;
L$L$933:
	[P3 ] =R1 ;
L$L$931:
	P5  = -12 (X);
	P5 =P5 +FP ; //immed->Preg 
	[SP +12] =P5 ;
	R2.L  = L$LC$213; R2.H  = L$LC$213;
	[SP +16] =R2 ;
	P2  = -40 (X);
	P2 =P2 +FP ; //immed->Preg 
	[SP +20] =P2 ;
	call _sscanf;
	[SP +12] =P5 ;
	P1.L  = L$LC$214; P1.H  = L$LC$214;
	[SP +16] =P1 ;
	P2  =[FP +-40];
	[SP +20] =P2 ;
	call _sprintf;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$934;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$934:
	R1  =FP ;
	R1 +=-12;
	R0  =P4 ;
L$L$962:
	call _string_append;
	jump.s L$L$895;
L$L$944:
	R0  =P5 ;
	call _register_Btype;
	[FP +-44] =R0 ;
	R4  =FP ;
	R4 +=-24;
	R0  =R4 ;
	call _string_init;
	R2  =R4 ;
	R0  =P5 ;
	R1  =P3 ;
	call _demangle_class_name;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$945;
	R1  =[FP +-24];
	R3  =[FP +-20];
	R2  =R3 -R1 ;
	R0  = 0 (X);
	cc =R1 ==R3 ;
	if cc R2  =R0 ; /* movsicc-1b */
	R0  =[FP +-44];
	[SP +12] =R0 ;
	R0  =P5 ;
	call _remember_Btype;
	R1  =[P4 ];
	R0  =[P4 +4];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$948;
	R0  =P4 ;
	R1.L  = L$LC$162; R1.H  = L$LC$162;
	call _string_append;
L$L$948:
	R1  =FP ;
	R1 +=-24;
	R0  =P4 ;
	call _string_appends;
	jump.s L$L$949;
L$L$945:
	R5  = 0 (X);
L$L$949:
	R0  =FP ;
	R0 +=-24;
	jump.s L$L$959;
L$L$950:
	R4  =FP ;
	R4 +=-36;
	R0  =R4 ;
	call _string_init;
	R0  = 0 (X);
	[SP +12] =R0 ;
	R1  = 1 (X);
	[SP +16] =R1 ;
	[SP +20] =R1 ;
	R2  =R4 ;
	R0  =P5 ;
	R1  =P3 ;
	call _demangle_template;
	R5  =R0 ;
	R0  =P4 ;
	R1  =R4 ;
	call _string_appends;
	R0  =R4 ;
L$L$959:
	call _string_delete;
	jump.s L$L$895;
L$L$951:
	R5  = 0 (X);
L$L$895:
	R0  = 0 (X);
	cc =R5 ==0;
	if !cc R0  =R6 ; /* movsicc-1a */
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$215:
.dw	0x322d;
.dw	0x3431;
.dw	0x3437;
.dw	0x3338;
.dw	0x3436;
.db	0x38;
.db	0x00;
.align 2
L$LC$216:
.db	0x55;
.db	0x00;
.align 2
.type _do_hpacc_template_const_value, STT_FUNC;
_do_hpacc_template_const_value:
	LINK 4;
	[--sp] = ( r7:4, p5:4 );
	P5  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 85 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$964;
	R0  = 0 (X);
	P1 +=-2;
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$963;
L$L$964:
	P2  =[P5 ];
	R0  = B [P2 ++] (X);
	R1  = 85 (X);
	cc =R0 ==R1 ;
	R6  =CC ;
	[P5 ] =P2 ;
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 78 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$966;
	cc =P2 <=P1 ;
	if cc jump 6; jump.l L$L$971;
	P1 +=-1;
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$968;
	jump.s L$L$969;
L$L$971:
	P1  = 80 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$967;
	jump.s L$L$969;
L$L$966:
	R0  =R5 ;
	R1.L  = L$LC$30; R1.H  = L$LC$30;
	call _string_append;
	jump.s L$L$967;
L$L$968:
	R0  =R5 ;
	R1.L  = L$LC$215; R1.H  = L$LC$215;
	call _string_append;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	jump.s L$L$977;
L$L$969:
	R0  = 0 (X);
	jump.s L$L$963;
L$L$967:
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P1  =P1 +P1 ;
	R0  =P1 ;
	R1.L  = __sch_istable; R1.H  = __sch_istable;
	R1 =R1 +R0 ; //immed->Dreg 
	P1  =R1 ;
	R0  = W[P1 ] (Z);
	R1  = 4 (X);
	R1  =R0 &R1 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$963;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$979;
	P4.L  = _char_str; P4.H  = _char_str;
	R4  = 4 (X);
L$L$976:
	R0  = B [P2 ] (X);
	B [P4 ] =R0 ;
	R0  =R5 ;
	R1  =P4 ;
	call _string_append;
	P2  =[P5 ];
	P2 +=1;
	[P5 ] =P2 ;
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P1  =P1 +P1 ;
	R0  =P1 ;
	R1.L  = __sch_istable; R1.H  = __sch_istable;
	R1 =R1 +R0 ; //immed->Dreg 
	P1  =R1 ;
	R0  = W[P1 ] (Z);
	R0  =R0 &R4 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$976;
L$L$979:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$977;
	R0  =R5 ;
	R1.L  = L$LC$216; R1.H  = L$LC$216;
	call _string_append;
L$L$977:
	R0  = 1 (X);
L$L$963:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _do_hpacc_template_literal, STT_FUNC;
_do_hpacc_template_literal:
	LINK 0;
	[--sp] = ( r7:4, p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	R0  = 0 (X);
	P1  = 65 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$980;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	R0  =R1 ;
	call _consume_count;
	R4  =R0 ;
	R0  = 0 (X);
	cc =R4 <=0;
	if !cc jump 6; jump.l L$L$980;
	R0  =R6 ;
	R1.L  = L$LC$78; R1.H  = L$LC$78;
	call _string_append;
	R0  = 1 (X);
	R0 =R0 +R4 ; //immed->Dreg 
	call _xmalloc;
	R5  =R0 ;
	R0  =[P5 ];
	R2  =R4 ;
	R1  =R5 ;
	call _bcopy;
	R1 =R5 +R4 ;
	P2  =R1 ;
	R1  = 0 (X);
	B [P2 ] =R1 ;
	R0  =R5 ;
	R1  =[P4 ];
	call _cplus_demangle;
	P4  =R0 ;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$983;
	R0  =R6 ;
	R1  =P4 ;
	call _string_append;
	R0  =P4 ;
	call _free;
	jump.s L$L$984;
L$L$983:
	R2  =R4 ;
	R0  =R6 ;
	R1  =[P5 ];
	call _string_appendn;
L$L$984:
	R0  =[P5 ];
	R4 =R4 +R0 ;
	[P5 ] =R4 ;
	R0  =R5 ;
	call _free;
	R0  = 1 (X);
L$L$980:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _snarf_numeric_literal, STT_FUNC;
_snarf_numeric_literal:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	P5  =R0 ;
	R6  =R1 ;
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 45 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$986;
	R1.L  = _char_str; R1.H  = _char_str;
	R0  = 45 (X);
	P1  =R1 ;
	B [P1 ] =R0 ;
	R0  =R6 ;
	call _string_append;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
	jump.s L$L$987;
L$L$986:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 43 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$987;
	P2 +=1;
	[P5 ] =P2 ;
L$L$987:
	R0  =[P5 ];
	P1  =R0 ;
	R0  = B [P1 ] (Z);
	P2  =R0 ;
	P2  =P2 +P2 ;
	R0  =P2 ;
	R1.L  = __sch_istable; R1.H  = __sch_istable;
	R1 =R1 +R0 ; //immed->Dreg 
	P1  =R1 ;
	R0  = W[P1 ] (Z);
	R1  = 4 (X);
	R1  =R0 &R1 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$985;
	P2  =[P5 ];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$995;
	P4.L  = _char_str; P4.H  = _char_str;
	R5  = 4 (X);
L$L$993:
	R0  = B [P2 ] (X);
	B [P4 ] =R0 ;
	R0  =R6 ;
	R1  =P4 ;
	call _string_append;
	P2  =[P5 ];
	P2 +=1;
	[P5 ] =P2 ;
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P1  =P1 +P1 ;
	R0  =P1 ;
	R1.L  = __sch_istable; R1.H  = __sch_istable;
	R1 =R1 +R0 ; //immed->Dreg 
	P1  =R1 ;
	R0  = W[P1 ] (Z);
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$993;
L$L$995:
	R0  = 1 (X);
L$L$985:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _do_arg, STT_FUNC;
_do_arg:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R5  =[P5 ];
	R0  =R2 ;
	call _string_init;
	R0  =[P4 +80];
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$997;
	R0 +=-1;
	[P4 +80] =R0 ;
	R1  =[P4 +76];
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$996;
	R0  =R6 ;
	call _string_appends;
	jump.s L$L$1007;
L$L$997:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 110 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$999;
	P2 +=1;
	[P5 ] =P2 ;
	R0  =P5 ;
	call _consume_count;
	R1  =R0 ;
	[P4 +80] =R0 ;
	R0  = 0 (X);
	cc =R1 <=0;
	if !cc jump 6; jump.l L$L$996;
	R0  =R1 ;
	R1  = 9 (X);
	cc =R0 <=R1 ;
	if !cc jump 6; jump.l L$L$1001;
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	R0  = 0 (X);
	P1  = 95 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$996;
	R0  =[P5 ];
	R0 +=1;
	[P5 ] =R0 ;
L$L$1001:
	R2  =R6 ;
	R0  =P4 ;
	R1  =P5 ;
	call _do_arg;
	jump.s L$L$996;
L$L$999:
	R0  =[P4 +76];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1004;
	call _string_delete;
	jump.s L$L$1005;
L$L$1004:
	R0  = 12 (X);
	call _xmalloc;
	[P4 +76] =R0 ;
L$L$1005:
	R2  =[P4 +76];
	R0  =P4 ;
	R1  =P5 ;
	call _do_type;
	R1  =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$996;
	R1  =[P4 +76];
	R0  =R6 ;
	call _string_appends;
	P5  =[P5 ];
	R0  =P5 ;
	R2  =R0 -R5 ;
	R0  =P4 ;
	R1  =R5 ;
	call _remember_type;
L$L$1007:
	R0  = 1 (X);
L$L$996:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _remember_type, STT_FUNC;
_remember_type:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R0  =[P5 +72];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1008;
	R1  =[P5 +32];
	R0  =[P5 +36];
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$1010;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1011;
	R0  = 3 (X);
	[P5 +36] =R0 ;
	R0  = 12 (X);
	call _xmalloc;
	jump.s L$L$1013;
L$L$1011:
	R2  =[P5 +36];
	P1  =R2 ;
	P2  =P1 +P1 ;
	[P5 +36] =P2 ;
	R0  =[P5 +4];
	R1  =R2 ;
	R1  <<=3;
	call _xrealloc;
L$L$1013:
	[P5 +4] =R0 ;
L$L$1010:
	R0  = 1 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _xmalloc;
	R4  =R0 ;
	R2  =R6 ;
	R0  =R5 ;
	R1  =R4 ;
	call _bcopy;
	R6 =R4 +R6 ;
	R1  = 0 (X);
	P1  =R6 ;
	B [P1 ] =R1 ;
	P1  = 32 (X);
	P1 =P1 +P5 ; //immed->Preg 
	P2  =[P1 ];
	P5  =[P5 +4];
	P5  =P5 +(P2 <<2);
	[P5 ] =R4 ;
	P2 +=1;
	[P1 ] =P2 ;
L$L$1008:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _remember_Ktype, STT_FUNC;
_remember_Ktype:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R1  =[P5 +16];
	R0  =[P5 +24];
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$1015;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1016;
	R0  = 5 (X);
	[P5 +24] =R0 ;
	R0  = 20 (X);
	call _xmalloc;
	jump.s L$L$1018;
L$L$1016:
	R2  =[P5 +24];
	P1  =R2 ;
	P2  =P1 +P1 ;
	[P5 +24] =P2 ;
	R0  =[P5 +8];
	R1  =R2 ;
	R1  <<=3;
	call _xrealloc;
L$L$1018:
	[P5 +8] =R0 ;
L$L$1015:
	R0  = 1 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _xmalloc;
	R4  =R0 ;
	R2  =R6 ;
	R0  =R5 ;
	R1  =R4 ;
	call _bcopy;
	R6 =R4 +R6 ;
	R1  = 0 (X);
	P1  =R6 ;
	B [P1 ] =R1 ;
	P1  = 16 (X);
	P1 =P1 +P5 ; //immed->Preg 
	P2  =[P1 ];
	P5  =[P5 +8];
	P5  =P5 +(P2 <<2);
	[P5 ] =R4 ;
	P2 +=1;
	[P1 ] =P2 ;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _register_Btype, STT_FUNC;
_register_Btype:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R1  =[P5 +20];
	R0  =[P5 +28];
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$1020;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1021;
	R0  = 5 (X);
	[P5 +28] =R0 ;
	R0  = 20 (X);
	call _xmalloc;
	jump.s L$L$1023;
L$L$1021:
	R2  =[P5 +28];
	P1  =R2 ;
	P2  =P1 +P1 ;
	[P5 +28] =P2 ;
	R0  =[P5 +12];
	R1  =R2 ;
	R1  <<=3;
	call _xrealloc;
L$L$1023:
	[P5 +12] =R0 ;
L$L$1020:
	P2  = 20 (X);
	P2 =P2 +P5 ; //immed->Preg 
	R1  =[P2 ];
	R0  =R1 ;
	R1 +=1;
	[P2 ] =R1 ;
	P5  =[P5 +12];
	P2  =R0 ;
	P5  =P5 +(P2 <<2);
	R1  = 0 (X);
	[P5 ] =R1 ;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _remember_Btype, STT_FUNC;
_remember_Btype:
	LINK 0;
	[--sp] = ( r7:4, p5:4 );
	P4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P5  =[FP +20];
	R0  = 1 (X);
	R0 =R0 +R2 ; //immed->Dreg 
	call _xmalloc;
	R4  =R0 ;
	R2  =R6 ;
	R0  =R5 ;
	R1  =R4 ;
	call _bcopy;
	R6 =R4 +R6 ;
	R0  = 0 (X);
	P2  =R6 ;
	B [P2 ] =R0 ;
	P4  =[P4 +12];
	P5  =P4 +(P5 <<2);
	[P5 ] =R4 ;
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _forget_B_and_K_types, STT_FUNC;
_forget_B_and_K_types:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =[P5 +16];
	cc =R6 <=0;
	if !cc jump 6; jump.l L$L$1037;
L$L$1030:
	R6 +=-1;
	[P5 +16] =R6 ;
	R0  =[P5 +8];
	P2  =R6 ;
	P2  =P2 <<2;
	R6  =P2 ;
	R0 =R6 +R0 ;
	P2  =R0 ;
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1026;
	call _free;
	R0  =[P5 +8];
	R6 =R6 +R0 ;
	R1  = 0 (X);
	P2  =R6 ;
	[P2 ] =R1 ;
L$L$1026:
	R6  =[P5 +16];
	cc =R6 <=0;
	if cc jump 6; jump.l L$L$1030;
L$L$1037:
	R6  =[P5 +20];
	cc =R6 <=0;
	if !cc jump 6; jump.l L$L$1039;
L$L$1035:
	R6 +=-1;
	[P5 +20] =R6 ;
	R0  =[P5 +12];
	P2  =R6 ;
	P2  =P2 <<2;
	R6  =P2 ;
	R0 =R6 +R0 ;
	P2  =R0 ;
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1031;
	call _free;
	R0  =[P5 +12];
	R6 =R6 +R0 ;
	R1  = 0 (X);
	P2  =R6 ;
	[P2 ] =R1 ;
L$L$1031:
	R6  =[P5 +20];
	cc =R6 <=0;
	if cc jump 6; jump.l L$L$1035;
L$L$1039:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _forget_types, STT_FUNC;
_forget_types:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =[P5 +32];
	cc =R6 <=0;
	if !cc jump 6; jump.l L$L$1047;
L$L$1045:
	R6 +=-1;
	[P5 +32] =R6 ;
	R0  =[P5 +4];
	P2  =R6 ;
	P2  =P2 <<2;
	R6  =P2 ;
	R0 =R6 +R0 ;
	P2  =R0 ;
	R0  =[P2 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1041;
	call _free;
	R0  =[P5 +4];
	R6 =R6 +R0 ;
	R1  = 0 (X);
	P2  =R6 ;
	[P2 ] =R1 ;
L$L$1041:
	R6  =[P5 +32];
	cc =R6 <=0;
	if cc jump 6; jump.l L$L$1045;
L$L$1047:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$217:
.dw	0x2e2e;
.db	0x2e;
.db	0x00;
.align 2
.type _demangle_args, STT_FUNC;
_demangle_args:
	LINK 28;
	[--sp] = ( r7:4, p5:4 );
	P5  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R5  = 0 (X);
	R1  =[P5 ];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1086;
	R0  =R2 ;
	R1.L  = L$LC$167; R1.H  = L$LC$167;
	call _string_append;
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1086;
	R0  =R6 ;
	R1.L  = L$LC$202; R1.H  = L$LC$202;
	call _string_append;
	jump.s L$L$1086;
L$L$1078:
	P2  =[P4 ];
	R1  = B [P2 ] (X);
	P2  =R1 ;
	P1  = 78 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$1056;
	P1 +=6;
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$1055;
L$L$1056:
	P2  =[P4 ];
	R0  = B [P2 ++] (X);
	[P4 ] =P2 ;
	R0  = R0.B  (X);
	R1  = 78 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1057;
	R0  =P4 ;
	R1  =FP ;
	R1 +=-16;
	call _get_count;
	R1  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1048;
	jump.s L$L$1059;
L$L$1057:
	P1  = 1 (X);
	[FP +-16] =P1 ;
L$L$1059:
	R1  =[P5 ];
	R0  = 14336 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1060;
	R0  =[P5 +32];
	R1  = 9 (X);
	cc =R0 <=R1 ;
	if !cc jump 6; jump.l L$L$1060;
	R0  =P4 ;
	call _consume_count;
	[FP +-20] =R0 ;
	R1  = 0 (X);
	cc =R0 <=0;
	jump.s L$L$1087;
L$L$1060:
	R0  =P4 ;
	R1  =FP ;
	R1 +=-20;
	call _get_count;
	R1  = 0 (X);
	cc =R0 ==0;
L$L$1087:
	if !cc jump 6; jump.l L$L$1048;
	R1  =[P5 ];
	R0  = 15360 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1064;
	R0  =[FP +-20];
	R0 +=-1;
	[FP +-20] =R0 ;
L$L$1064:
	R1  =[FP +-20];
	cc =R1 <0;
	if !cc jump 6; jump.l L$L$1066;
	R0  =[P5 +32];
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$1065;
L$L$1066:
	R1  = 0 (X);
	jump.s L$L$1048;
L$L$1065:
	R0  =[P5 +80];
	cc =R0 <=0;
	if cc jump 6; jump.l L$L$1083;
	R0  =[FP +-16];
	R0 +=-1;
	[FP +-16] =R0 ;
	cc =R0 <0;
	if !cc jump 6; jump.l L$L$1086;
L$L$1083:
	R4  = 1 (X);
L$L$1085:
	P1  =[FP +-20];
	P2  =[P5 +4];
	P2  =P2 +(P1 <<2);
	P2  =[P2 ];
	[FP +-24] =P2 ;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1070;
	R0  =[P5 ];
	R0  =R0 &R4 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1070;
	R0  =R6 ;
	R1.L  = L$LC$110; R1.H  = L$LC$110;
	call _string_append;
L$L$1070:
	R2  =FP ;
	R2 +=-12;
	R0  =P5 ;
	R1  =FP ;
	R1 +=-24;
	call _do_arg;
	R1  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1048;
	R0  =[P5 ];
	R0  =R0 &R4 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1072;
	R0  =R6 ;
	R1  =FP ;
	R1 +=-12;
	call _string_appends;
L$L$1072:
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	R5  = 1 (X);
	R0  =[P5 +80];
	cc =R0 <=0;
	if cc jump 6; jump.l L$L$1085;
	R0  =[FP +-16];
	R0 +=-1;
	[FP +-16] =R0 ;
	cc =R0 <0;
	if cc jump 6; jump.l L$L$1085;
	jump.s L$L$1086;
L$L$1055:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1075;
	R1  =[P5 ];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1075;
	R0  =R6 ;
	R1.L  = L$LC$110; R1.H  = L$LC$110;
	call _string_append;
L$L$1075:
	R2  =FP ;
	R2 +=-12;
	R0  =P5 ;
	R1  =P4 ;
	call _do_arg;
	R1  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1048;
	R1  =[P5 ];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1077;
	R0  =R6 ;
	R1  =FP ;
	R1 +=-12;
	call _string_appends;
L$L$1077:
	R0  =FP ;
	R0 +=-12;
	call _string_delete;
	R5  = 1 (X);
L$L$1086:
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 95 (X);
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$1054;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1054;
	P1 +=6;
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$1078;
L$L$1054:
	R0  =[P5 +80];
	cc =R0 <=0;
	if cc jump 6; jump.l L$L$1078;
	P2  =[P4 ];
	R0  = B [P2 ] (X);
	R1  = 101 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1079;
	P2 +=1;
	[P4 ] =P2 ;
	R1  =[P5 ];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1082;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1081;
	R0  =R6 ;
	R1.L  = L$LC$180; R1.H  = L$LC$180;
	call _string_append;
L$L$1081:
	R0  =R6 ;
	R1.L  = L$LC$217; R1.H  = L$LC$217;
	call _string_append;
L$L$1079:
	P5  =[P5 ];
	R0  = 1 (X);
	R1  =P5 ;
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1082;
	R0  =R6 ;
	R1.L  = L$LC$168; R1.H  = L$LC$168;
	call _string_append;
L$L$1082:
	R1  = 1 (X);
L$L$1048:
	R0  =R1 ;
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _demangle_nested_args, STT_FUNC;
_demangle_nested_args:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	[FP +16] =R2 ;
	R0  =[P5 +72];
	R0 +=1;
	[P5 +72] =R0 ;
	R6  =[P5 +76];
	R4  =[P5 +80];
	R0  = 0 (X);
	[P5 +76] =R0 ;
	[P5 +80] =R0 ;
	R0  =P5 ;
	call _demangle_args;
	R5  =R0 ;
	R0  =[P5 +76];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1089;
	call _string_delete;
	R0  =[P5 +76];
	call _free;
L$L$1089:
	[P5 +76] =R6 ;
	R0  =[P5 +72];
	R0 +=-1;
	[P5 +72] =R0 ;
	[P5 +80] =R4 ;
	R0  =R5 ;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$218:
.dw	0x5f5f;
.dw	0x7463;
.db	0x00;
.align 2
L$LC$219:
.dw	0x5f5f;
.dw	0x7464;
.db	0x00;
.align 2
L$LC$221:
.dw	0x706f;
.dw	0x7265;
.dw	0x7461;
.dw	0x726f;
.db	0x00;
.align 2
L$LC$220:
.dw	0x7361;
.dw	0x6973;
.dw	0x6e67;
.db	0x5f;
.db	0x00;
.align 2
L$LC$222:
.dw	0x7974;
.dw	0x6570;
.db	0x00;
.align 2
L$LC$223:
.dw	0x706f;
.dw	0x7265;
.dw	0x7461;
.dw	0x726f;
.db	0x20;
.db	0x00;
.align 2
.type _demangle_function_name, STT_FUNC;
_demangle_function_name:
	LINK 16;
	[--sp] = ( r7:6, p5:3 );
	P4  =R0 ;
	P3  =R1 ;
	[FP +16] =R2 ;
	P5  =R2 ;
	R6  =[FP +20];
	R1  =[P3 ];
	R2  =R6 -R1 ;
	R0  =P5 ;
	call _string_appendn;
	R0  =P5 ;
	R1  = 1 (X);
	call _string_need;
	P2  =[P5 +4];
	R0  = 0 (X);
	B [P2 ] =R0 ;
	R6 +=2;
	[P3 ] =R6 ;
	R1  =[P4 ];
	R0  = 4096 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1091;
	P2  =R6 ;
	R6  = B [P2 ] (X);
	R0  = 88 (X);
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$1091;
	[SP +12] =P5 ;
	R2  = 0 (X);
	R0  =P4 ;
	R1  =P3 ;
	call _demangle_arm_hp_template;
L$L$1091:
	R1  =[P4 ];
	R0  = 15360 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1092;
	R0  =[P5 ];
	R1.L  = L$LC$218; R1.H  = L$LC$218;
	call _strcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1093;
	R0  =[P4 +40];
	R0 +=1;
	[P4 +40] =R0 ;
	jump.s L$L$1144;
L$L$1093:
	R0  =[P5 ];
	R1.L  = L$LC$219; R1.H  = L$LC$219;
	call _strcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1092;
	R0  =[P4 +44];
	R0 +=1;
	[P4 +44] =R0 ;
L$L$1144:
	R0  =P5 ;
	call _string_clear;
	jump.s L$L$1090;
L$L$1138:
	R0  =P5 ;
	call _string_clear;
	R0  =P5 ;
	R1.L  = L$LC$221; R1.H  = L$LC$221;
	call _string_append;
	R0  =P5 ;
	R1  =[P4 +4];
	call _string_append;
	R0  =P5 ;
	R1.L  = L$LC$11; R1.H  = L$LC$11;
	jump.s L$L$1142;
L$L$1092:
	R0  =[P5 +4];
	R2  =[P5 ];
	R0  =R0 -R2 ;
	cc =R0 <=2;
	if !cc jump 6; jump.l L$L$1096;
	P2  =R2 ;
	R0  = B [P2 ] (X);
	R1  = 111 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1096;
	R0  = B [P2 +1] (X);
	R1 +=1;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1096;
	R1  = B [P2 +2] (X);
	R0.L  = _cplus_markers; R0.H  = _cplus_markers;
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1096;
	R1  =[P5 +4];
	R0  =[P5 ];
	R1  =R1 -R0 ;
	R2  = 9 (X);
	cc =R1 <=R2 ;
	if !cc jump 6; jump.l L$L$1097;
	R0 +=3;
	R2  = 7 (X);
	R1.L  = L$LC$220; R1.H  = L$LC$220;
	call _memcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1097;
	P3  = 0 (X);
	P2  = 78 (X);
	cc =P3 <=P2  (iu);
	if cc jump 6; jump.l L$L$1090;
L$L$1103:
	R0  =[P5 +4];
	R6  =[P5 ];
	R6  =R0 -R6 ;
	R6 +=-10;
	P4  =P3 +(P3 <<1);
	P4  =P4 <<2;
	P2.L  = _optable; P2.H  = _optable;
	P2 =P2 +P4 ; //immed->Preg 
	P4  =P2 ;
	R0  =[P2 ];
	call _strlen;
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$1100;
	R1  =[P5 ];
	R1 +=10;
	R2  =R0 ;
	R0  =[P4 ];
	call _memcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1138;
L$L$1100:
	P3 +=1;
	P2  = 78 (X);
	cc =P3 <=P2  (iu);
	if !cc jump 6; jump.l L$L$1103;
	jump.s L$L$1090;
L$L$1097:
	P3  = 0 (X);
	P2  = 78 (X);
	cc =P3 <=P2  (iu);
	if cc jump 6; jump.l L$L$1090;
L$L$1110:
	R0  =[P5 +4];
	R6  =[P5 ];
	R6  =R0 -R6 ;
	R6 +=-3;
	P4  =P3 +(P3 <<1);
	P4  =P4 <<2;
	P2.L  = _optable; P2.H  = _optable;
	P2 =P2 +P4 ; //immed->Preg 
	P4  =P2 ;
	R0  =[P2 ];
	call _strlen;
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$1107;
	R1  =[P5 ];
	R1 +=3;
	R2  =R0 ;
	R0  =[P4 ];
	call _memcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1141;
L$L$1107:
	P3 +=1;
	P2  = 78 (X);
	cc =P3 <=P2  (iu);
	if !cc jump 6; jump.l L$L$1110;
	jump.s L$L$1090;
L$L$1096:
	R1  =[P5 +4];
	R0  =[P5 ];
	R1  =R1 -R0 ;
	R2  = 4 (X);
	cc =R1 <=R2 ;
	if !cc jump 6; jump.l L$L$1112;
	R1.L  = L$LC$222; R1.H  = L$LC$222;
	call _memcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1112;
	P2  =[P5 ];
	R1  = B [P2 +4] (X);
	R0.L  = _cplus_markers; R0.H  = _cplus_markers;
	call _strchr;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1112;
	R0  =[P5 ];
	R0 +=5;
	[FP +-16] =R0 ;
	P3  = -12 (X);
	P3 =P3 +FP ; //immed->Preg 
	R2  =P3 ;
	R0  =P4 ;
	R1  =FP ;
	R1 +=-16;
	call _do_type;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1090;
	jump.s L$L$1143;
L$L$1112:
	P2  =[P5 ];
	R0  = B [P2 ] (X);
	R1  = 95 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1115;
	R0  = B [P2 +1] (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1115;
	R0  = B [P2 +2] (X);
	R2  = 111 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1115;
	R0  = B [P2 +3] (X);
	R1 +=17;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1115;
	P2 +=4;
	[FP +-16] =P2 ;
	P3  = -12 (X);
	P3 =P3 +FP ; //immed->Preg 
	R2  =P3 ;
	R0  =P4 ;
	R1  =FP ;
	R1 +=-16;
	call _do_type;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1090;
L$L$1143:
	R0  =P5 ;
	call _string_clear;
	R0  =P5 ;
	R1.L  = L$LC$223; R1.H  = L$LC$223;
	call _string_append;
	R0  =P5 ;
	R1  =P3 ;
	call _string_appends;
	R0  =P3 ;
	call _string_delete;
	jump.s L$L$1090;
L$L$1115:
	P0  =[P5 ];
	R0  = B [P0 ] (X);
	R2  = 95 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1090;
	R0  = B [P0 +1] (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1090;
	P1.L  = __sch_istable; P1.H  = __sch_istable;
	R0  = B [P0 +2] (Z);
	P2  =R0 ;
	P2  =P1 +(P2 <<1);
	R0  = W[P2 ] (Z);
	R1  = 8 (X);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1090;
	R0  = B [P0 +3] (Z);
	P2  =R0 ;
	P1  =P1 +(P2 <<1);
	R0  = W[P1 ] (Z);
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1090;
	R0  = B [P0 +4] (X);
	P0  =R0 ;
	cc =P0 ==0;
	if cc jump 6; jump.l L$L$1119;
	P3  = 0 (X);
	P2  = 78 (X);
	cc =P3 <=P2  (iu);
	if cc jump 6; jump.l L$L$1090;
L$L$1125:
	P4  =P3 +(P3 <<1);
	P4  =P4 <<2;
	P2.L  = _optable; P2.H  = _optable;
	P2 =P2 +P4 ; //immed->Preg 
	P4  =P2 ;
	R0  =[P2 ];
	call _strlen;
	cc =R0 ==2;
	if cc jump 6; jump.l L$L$1122;
	R0  =[P5 ];
	R1  = 2 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R2  = 2 (X);
	R0  =[P4 ];
	call _memcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1141;
L$L$1122:
	P3 +=1;
	P2  = 78 (X);
	cc =P3 <=P2  (iu);
	if !cc jump 6; jump.l L$L$1125;
	jump.s L$L$1090;
L$L$1141:
	R0  =P5 ;
	call _string_clear;
	R0  =P5 ;
	R1.L  = L$LC$221; R1.H  = L$LC$221;
	call _string_append;
	R0  =P5 ;
	R1  =[P4 +4];
L$L$1142:
	call _string_append;
	jump.s L$L$1090;
L$L$1119:
	P2  =[P5 ];
	R0  = B [P2 +2] (X);
	R1  = 97 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1090;
	R2  = B [P2 +5] (X);
	P2  =R2 ;
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1090;
	P3  = 0 (X);
	P2  = 78 (X);
	cc =P3 <=P2  (iu);
	if cc jump 6; jump.l L$L$1090;
L$L$1133:
	P4  =P3 +(P3 <<1);
	P4  =P4 <<2;
	P2.L  = _optable; P2.H  = _optable;
	P2 =P2 +P4 ; //immed->Preg 
	P4  =P2 ;
	R0  =[P2 ];
	call _strlen;
	cc =R0 ==3;
	if cc jump 6; jump.l L$L$1130;
	R0  =[P5 ];
	R1  = 2 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R2  = 3 (X);
	R0  =[P4 ];
	call _memcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1141;
L$L$1130:
	P3 +=1;
	P2  = 78 (X);
	cc =P3 <=P2  (iu);
	if !cc jump 6; jump.l L$L$1133;
L$L$1090:
	( r7:6, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_need, STT_FUNC;
_string_need:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	R0  =[P5 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1146;
	R0  = 32 (X);
	R5  =max(R1 ,R0 );
	R0  =R5 ;
	call _xmalloc;
	[P5 ] =R0 ;
	[P5 +4] =R0 ;
	jump.s L$L$1150;
L$L$1146:
	R0  =[P5 +8];
	R6  =[P5 +4];
	R0  =R0 -R6 ;
	cc =R0 <R1 ;
	if cc jump 6; jump.l L$L$1145;
	R0  =[P5 ];
	R6  =R6 -R0 ;
	R5  = (R5  + R6 ) << 1;
	R1  =R5 ;
	call _xrealloc;
	[P5 ] =R0 ;
	R6 =R6 +R0 ;
	[P5 +4] =R6 ;
L$L$1150:
	R5 =R5 +R0 ;
	[P5 +8] =R5 ;
L$L$1145:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_delete, STT_FUNC;
_string_delete:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  =[P5 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1151;
	call _free;
	R1  = 0 (X);
	[P5 +4] =R1 ;
	[P5 +8] =R1 ;
	[P5 ] =R1 ;
L$L$1151:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_init, STT_FUNC;
_string_init:
	LINK 0;
	R1  = 0 (X);
	P2  =R0 ;
	[P2 +8] =R1 ;
	[P2 +4] =R1 ;
	[P2 ] =R1 ;
	UNLINK;
	rts;


.align 2
.type _string_clear, STT_FUNC;
_string_clear:
	LINK 0;
	P2  =R0 ;
	R1  =[P2 ];
	[P2 +4] =R1 ;
	UNLINK;
	rts;


.align 2
.type _string_append, STT_FUNC;
_string_append:
	LINK 0;
	[--sp] = ( r7:6, p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$1155;
	R0  = B [P5 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1155;
	R0  =R1 ;
	call _strlen;
	R6  =R0 ;
	R0  =P4 ;
	R1  =R6 ;
	call _string_need;
	R1  =[P4 +4];
	R2  =R6 ;
	R0  =P5 ;
	call _bcopy;
	R0  =[P4 +4];
	R6 =R6 +R0 ;
	[P4 +4] =R6 ;
L$L$1155:
	( r7:6, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_appends, STT_FUNC;
_string_appends:
	LINK 0;
	[--sp] = ( r7:6, p5:4 );
	P4  =R0 ;
	P5  =R1 ;
	R6  =[P5 ];
	R0  =[P5 +4];
	cc =R6 ==R0 ;
	if !cc jump 6; jump.l L$L$1158;
	R6  =R0 -R6 ;
	R0  =P4 ;
	R1  =R6 ;
	call _string_need;
	R1  =[P4 +4];
	R0  =[P5 ];
	R2  =R6 ;
	call _bcopy;
	R0  =[P4 +4];
	R6 =R6 +R0 ;
	[P4 +4] =R6 ;
L$L$1158:
	( r7:6, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_appendn, STT_FUNC;
_string_appendn:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$1160;
	R1  =R2 ;
	call _string_need;
	R1  =[P5 +4];
	R2  =R6 ;
	R0  =R5 ;
	call _bcopy;
	R0  =[P5 +4];
	R6 =R6 +R0 ;
	[P5 +4] =R6 ;
L$L$1160:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_prepend, STT_FUNC;
_string_prepend:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	R6  =R0 ;
	P5  =R1 ;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$1162;
	R0  = B [P5 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1162;
	R0  =R1 ;
	call _strlen;
	R2  =R0 ;
	R0  =R6 ;
	R1  =P5 ;
	call _string_prependn;
L$L$1162:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _string_prepends, STT_FUNC;
_string_prepends:
	LINK 0;
	P2  =R1 ;
	R3  =[P2 ];
	R1  =[P2 +4];
	cc =R3 ==R1 ;
	if !cc jump 6; jump.l L$L$1164;
	R2  =R1 -R3 ;
	R1  =R3 ;
	call _string_prependn;
L$L$1164:
	UNLINK;
	rts;


.align 2
.type _string_prependn, STT_FUNC;
_string_prependn:
	LINK 4;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$1166;
	R1  =R2 ;
	call _string_need;
	R1  =[P5 +4];
	R1 +=-1;
	R0  =[P5 ];
	cc =R1 <R0  (iu);
	if !cc jump 6; jump.l L$L$1174;
L$L$1172:
	R0 =R1 +R6 ;
	P2  =R0 ;
	P1  =R1 ;
	R1 +=-1;
	R0  = B [P1 --] (X);
	B [P2 ] =R0 ;
	R0  =[P5 ];
	cc =R1 <R0  (iu);
	if cc jump 6; jump.l L$L$1172;
L$L$1174:
	R1  =[P5 ];
	R2  =R6 ;
	R0  =R5 ;
	call _bcopy;
	R0  =[P5 +4];
	R6 =R6 +R0 ;
	[P5 +4] =R6 ;
L$L$1166:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$224:
.dw	0x2554;
.db	0x64;
.db	0x00;
.align 2
.type _string_append_template_idx, STT_FUNC;
_string_append_template_idx:
	LINK 36;
	[--sp] = ( r7:6, p5:5 );
	R6  =R0 ;
	P5  = -36 (X);
	P5 =P5 +FP ; //immed->Preg 
	[SP +12] =P5 ;
	R0.L  = L$LC$224; R0.H  = L$LC$224;
	[SP +16] =R0 ;
	[SP +20] =R1 ;
	call _sprintf;
	R0  =R6 ;
	R1  =P5 ;
	call _string_append;
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


