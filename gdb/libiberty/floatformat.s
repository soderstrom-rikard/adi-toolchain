// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "floatformat.i";
.text;
.align 2
L$LC$0:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6569;
.dw	0x6565;
.dw	0x735f;
.dw	0x6e69;
.dw	0x6c67;
.dw	0x5f65;
.dw	0x6962;
.db	0x67;
.db	0x00;
.global _floatformat_ieee_single_big;
.align 2
_floatformat_ieee_single_big:	.long	1
	.long	32
	.long	0
	.long	1
	.long	8
	.long	127
	.long	255
	.long	9
	.long	23
	.long	1
	.long	L$LC$0
.align 2
L$LC$1:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6569;
.dw	0x6565;
.dw	0x735f;
.dw	0x6e69;
.dw	0x6c67;
.dw	0x5f65;
.dw	0x696c;
.dw	0x7474;
.dw	0x656c;
.db	0x00;
.global _floatformat_ieee_single_little;
.align 2
_floatformat_ieee_single_little:	.long	0
	.long	32
	.long	0
	.long	1
	.long	8
	.long	127
	.long	255
	.long	9
	.long	23
	.long	1
	.long	L$LC$1
.align 2
L$LC$2:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6569;
.dw	0x6565;
.dw	0x645f;
.dw	0x756f;
.dw	0x6c62;
.dw	0x5f65;
.dw	0x6962;
.db	0x67;
.db	0x00;
.global _floatformat_ieee_double_big;
.align 2
_floatformat_ieee_double_big:	.long	1
	.long	64
	.long	0
	.long	1
	.long	11
	.long	1023
	.long	2047
	.long	12
	.long	52
	.long	1
	.long	L$LC$2
.align 2
L$LC$3:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6569;
.dw	0x6565;
.dw	0x645f;
.dw	0x756f;
.dw	0x6c62;
.dw	0x5f65;
.dw	0x696c;
.dw	0x7474;
.dw	0x656c;
.db	0x00;
.global _floatformat_ieee_double_little;
.align 2
_floatformat_ieee_double_little:	.long	0
	.long	64
	.long	0
	.long	1
	.long	11
	.long	1023
	.long	2047
	.long	12
	.long	52
	.long	1
	.long	L$LC$3
.align 2
L$LC$4:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6569;
.dw	0x6565;
.dw	0x645f;
.dw	0x756f;
.dw	0x6c62;
.dw	0x5f65;
.dw	0x696c;
.dw	0x7474;
.dw	0x656c;
.dw	0x7962;
.dw	0x6574;
.dw	0x625f;
.dw	0x6769;
.dw	0x6f77;
.dw	0x6472;
.db	0x00;
.global _floatformat_ieee_double_littlebyte_bigword;
.align 2
_floatformat_ieee_double_littlebyte_bigword:	.long	2
	.long	64
	.long	0
	.long	1
	.long	11
	.long	1023
	.long	2047
	.long	12
	.long	52
	.long	1
	.long	L$LC$4
.align 2
L$LC$5:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x3369;
.dw	0x3738;
.dw	0x655f;
.dw	0x7478;
.db	0x00;
.global _floatformat_i387_ext;
.align 2
_floatformat_i387_ext:	.long	0
	.long	80
	.long	0
	.long	1
	.long	15
	.long	16383
	.long	32767
	.long	16
	.long	64
	.long	0
	.long	L$LC$5
.align 2
L$LC$6:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x366d;
.dw	0x3838;
.dw	0x3138;
.dw	0x655f;
.dw	0x7478;
.db	0x00;
.global _floatformat_m68881_ext;
.align 2
_floatformat_m68881_ext:	.long	1
	.long	96
	.long	0
	.long	1
	.long	15
	.long	16383
	.long	32767
	.long	32
	.long	64
	.long	0
	.long	L$LC$6
.align 2
L$LC$7:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x3969;
.dw	0x3036;
.dw	0x655f;
.dw	0x7478;
.db	0x00;
.global _floatformat_i960_ext;
.align 2
_floatformat_i960_ext:	.long	0
	.long	96
	.long	16
	.long	17
	.long	15
	.long	16383
	.long	32767
	.long	32
	.long	64
	.long	0
	.long	L$LC$7
.align 2
L$LC$8:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x386d;
.dw	0x3138;
.dw	0x3031;
.dw	0x655f;
.dw	0x7478;
.db	0x00;
.global _floatformat_m88110_ext;
.align 2
_floatformat_m88110_ext:	.long	1
	.long	80
	.long	0
	.long	1
	.long	15
	.long	16383
	.long	32767
	.long	16
	.long	64
	.long	0
	.long	L$LC$8
.align 2
L$LC$9:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x386d;
.dw	0x3138;
.dw	0x3031;
.dw	0x655f;
.dw	0x7478;
.dw	0x685f;
.dw	0x7261;
.dw	0x6972;
.db	0x73;
.db	0x00;
.global _floatformat_m88110_harris_ext;
.align 2
_floatformat_m88110_harris_ext:	.long	1
	.long	128
	.long	0
	.long	1
	.long	11
	.long	1023
	.long	2047
	.long	12
	.long	52
	.long	1
	.long	L$LC$9
.align 2
L$LC$10:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x7261;
.dw	0x5f6d;
.dw	0x7865;
.dw	0x5f74;
.dw	0x6962;
.db	0x67;
.db	0x00;
.global _floatformat_arm_ext_big;
.align 2
_floatformat_arm_ext_big:	.long	1
	.long	96
	.long	0
	.long	17
	.long	15
	.long	16383
	.long	32767
	.long	32
	.long	64
	.long	0
	.long	L$LC$10
.align 2
L$LC$11:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x7261;
.dw	0x5f6d;
.dw	0x7865;
.dw	0x5f74;
.dw	0x696c;
.dw	0x7474;
.dw	0x656c;
.dw	0x7962;
.dw	0x6574;
.dw	0x625f;
.dw	0x6769;
.dw	0x6f77;
.dw	0x6472;
.db	0x00;
.global _floatformat_arm_ext_littlebyte_bigword;
.align 2
_floatformat_arm_ext_littlebyte_bigword:	.long	2
	.long	96
	.long	0
	.long	17
	.long	15
	.long	16383
	.long	32767
	.long	32
	.long	64
	.long	0
	.long	L$LC$11
.align 2
L$LC$12:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6169;
.dw	0x3436;
.dw	0x735f;
.dw	0x6970;
.dw	0x6c6c;
.dw	0x625f;
.dw	0x6769;
.db	0x00;
.global _floatformat_ia64_spill_big;
.align 2
_floatformat_ia64_spill_big:	.long	1
	.long	128
	.long	0
	.long	1
	.long	17
	.long	65535
	.long	131071
	.long	18
	.long	64
	.long	0
	.long	L$LC$12
.align 2
L$LC$13:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6169;
.dw	0x3436;
.dw	0x735f;
.dw	0x6970;
.dw	0x6c6c;
.dw	0x6c5f;
.dw	0x7469;
.dw	0x6c74;
.db	0x65;
.db	0x00;
.global _floatformat_ia64_spill_little;
.align 2
_floatformat_ia64_spill_little:	.long	0
	.long	128
	.long	0
	.long	1
	.long	17
	.long	65535
	.long	131071
	.long	18
	.long	64
	.long	0
	.long	L$LC$13
.align 2
L$LC$14:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6169;
.dw	0x3436;
.dw	0x715f;
.dw	0x6175;
.dw	0x5f64;
.dw	0x6962;
.db	0x67;
.db	0x00;
.global _floatformat_ia64_quad_big;
.align 2
_floatformat_ia64_quad_big:	.long	1
	.long	128
	.long	0
	.long	1
	.long	15
	.long	16383
	.long	32767
	.long	16
	.long	112
	.long	1
	.long	L$LC$14
.align 2
L$LC$15:
.dw	0x6c66;
.dw	0x616f;
.dw	0x6674;
.dw	0x726f;
.dw	0x616d;
.dw	0x5f74;
.dw	0x6169;
.dw	0x3436;
.dw	0x715f;
.dw	0x6175;
.dw	0x5f64;
.dw	0x696c;
.dw	0x7474;
.dw	0x656c;
.db	0x00;
.global _floatformat_ia64_quad_little;
.align 2
_floatformat_ia64_quad_little:	.long	0
	.long	128
	.long	0
	.long	1
	.long	15
	.long	16383
	.long	32767
	.long	16
	.long	112
	.long	1
	.long	L$LC$15
.align 2
.type _get_field, STT_FUNC;
_get_field:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P2  =R0 ;
	P1  =R1 ;
	[FP +16] =R2 ;
	R1  =R2 ;
	R0  =[FP +20];
	R6  =[FP +24];
	R2 =R0 +R6 ;
	R2  >>=3;
	cc =P1 ==0;
	if cc jump 6; jump.l L$L$2;
	R1  >>=3;
	R2  =R1 -R2 ;
	R2 +=-1;
L$L$2:
	R0 =R0 +R6 ;
	R5  = 7 (X);
	R5  =R0 &R5 ;
	R0  = -8 (X);
	R0 =R0 +R5 ; //immed->Dreg 
	P5  =R2 ;
	P0 =P2 +P5 ;
	R1  = B [P0 ] (Z);
	R0  =-R0 ;
	R1  >>>=R0 ;
	P0  =R1 ;
	R3  = 1 (X);
	R3 =R3 +R2 ; //immed->Dreg 
	R2 +=-1;
	cc =P1 ==0;
	if !cc R3  =R2 ; /* movsicc-1a */
	cc =R5 <R6  (iu);
	if cc jump 6; jump.l L$L$14;
	R1  = 1 (X);
L$L$12:
	R0  =R6 -R5 ;
	cc =R0 <=7 (iu);
	if cc jump 6; jump.l L$L$8;
	R4  =P2 ;
	R2 =R4 +R3 ;
	P5  =R2 ;
	R2  = B [P5 ] (Z);
	R4  =R1 ;
	R4  <<=R0 ;
	R0  =R4 ;
	R0 +=-1;
	R2  =R2 &R0 ;
	R2  <<=R5 ;
	R0  =P0 ;
	R0  =R0 |R2 ;
	P0  =R0 ;
	jump.s L$L$9;
L$L$8:
	R2  =P2 ;
	R0 =R2 +R3 ;
	P5  =R0 ;
	R0  = B [P5 ] (Z);
	R0  <<=R5 ;
	R2  =P0 ;
	R2  =R2 |R0 ;
	P0  =R2 ;
L$L$9:
	R5 +=8;
	R0  = 1 (X);
	R0 =R0 +R3 ; //immed->Dreg 
	R3 +=-1;
	cc =P1 ==0;
	if cc R3  =R0 ; /* movsicc-1b */
	cc =R5 <R6  (iu);
	if !cc jump 6; jump.l L$L$12;
L$L$14:
	R0  =P0 ;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _floatformat_to_double;
.type _floatformat_to_double, STT_FUNC;
_floatformat_to_double:
	LINK 20;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	[FP +-20] =R0 ;
	R0  =R1 ;
	[FP +16] =R2 ;
	[FP +-4] =R2 ;
	[FP +-8] =R1 ;
	R2  =[P4 +4];
	R1  =[P4 +12];
	[SP +12] =R1 ;
	P2  =[P4 +16];
	[SP +16] =P2 ;
	R1  =[P4 ];
	call _get_field;
	P3  =R0 ;
	P5  =[P4 +32];
	P4  =[P4 +28];
	R4  = 0 (X);
	R5  = 0 (X);
	R2  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$17;
	R1  =[FP +-20];
	P2  =R1 ;
	R1  =[P2 +24];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$16;
L$L$17:
	R2  = 1 (X);
L$L$16:
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$19;
	R1  =[FP +-20];
	P2  =R1 ;
	R1  =[P2 +20];
	R0  =P3 ;
	R0  =R0 -R1 ;
	P3  =R0 ;
	R0  =[P2 +36];
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$20;
	R0  = 0 (X);
	[SP +12] =R0 ;
	R1  = 1023 (X); R1  <<= 20; // zeros
	[SP +16] =R1 ;
	R1  =P3 ;
	call _ldexp;
	R4  =R0 ;
	R5  =R1 ;
	jump.s L$L$19;
L$L$20:
	R0  =P3 ;
	R0 +=1;
	P3  =R0 ;
L$L$19:
	cc =P5 <=0;
	if !cc jump 6; jump.l L$L$29;
L$L$26:
	R6  = 32 (X);
	R0  =P5 ;
	R6  =min(R0 ,R6 );
	P2  =[FP +-20];
	R2  =[P2 +4];
	[SP +12] =P4 ;
	[SP +16] =R6 ;
	R0  =[FP +-8];
	R1  =[P2 ];
	call _get_field;
	[FP +-12] =R0 ;
	R1  =P3 ;
	R1  =R1 -R6 ;
	[FP +-16] =R1 ;
	call ___floatsidf;
	R2  =R0 ;
	R3  =R1 ;
	R0  =[FP +-12];
	cc =R0 <0;
	if cc jump 6; jump.l L$L$25;
	[SP +12] =R2 ;
	[SP +16] =R1 ;
	call ___adddf3;
	R2  =R0 ;
	R3  =R1 ;
L$L$25:
	[SP +12] =R2 ;
	[SP +16] =R3 ;
	R1  =[FP +-16];
	call _ldexp;
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	call ___adddf3;
	R4  =R0 ;
	R5  =R1 ;
	R0  =P3 ;
	R0  =R0 -R6 ;
	P3  =R0 ;
	R0  =P4 ;
	R0 =R0 +R6 ;
	P4  =R0 ;
	R0  =P5 ;
	R0  =R0 -R6 ;
	P5  =R0 ;
	cc =P5 <=0;
	if cc jump 6; jump.l L$L$26;
L$L$29:
	P2  =[FP +-20];
	R2  =[P2 +4];
	P2  =[P2 +8];
	[SP +12] =P2 ;
	R1  = 1 (X);
	[SP +16] =R1 ;
	R0  =[FP +-8];
	P2  =[FP +-20];
	R1  =[P2 ];
	call _get_field;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$27;
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	call ___negdf2;
	R4  =R0 ;
	R5  =R1 ;
L$L$27:
	P2  =[FP +-4];
	[P2 ] =R4 ;
	[P2 +4] =R5 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _put_field, STT_FUNC;
_put_field:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P1  =R0 ;
	P0  =R1 ;
	[FP +16] =R2 ;
	R0  =[FP +20];
	R5  =[FP +24];
	R1  =[FP +28];
	R4 =R0 +R5 ;
	R4  >>=3;
	cc =P0 ==0;
	if cc jump 6; jump.l L$L$31;
	R2  >>=3;
	R4  =R2 -R4 ;
	R4 +=-1;
L$L$31:
	R2 =R0 +R5 ;
	R6  = 7 (X);
	R2  =R2 &R6 ;
	R3  = -8 (X);
	R3 =R3 +R2 ; //immed->Dreg 
	P5  =R4 ;
	P2 =P1 +P5 ;
	R0  = 1 (X);
	R0  <<=R2 ;
	R6  =R0 ;
	R6 +=-1;
	R3  =-R3 ;
	R6  <<=R3 ;
	R6  =~R6 ;
	R0  = B [P2 ] (X);
	R6  =R6 &R0 ;
	R0  = R1.B  (Z);
	R0  <<=R3 ;
	R6  =R6 |R0 ;
	B [P2 ] =R6 ;
	R6  = 1 (X);
	R6 =R6 +R4 ; //immed->Dreg 
	R4 +=-1;
	cc =P0 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
	cc =R2 <R5  (iu);
	if cc jump 6; jump.l L$L$43;
	R4  = 1 (X);
L$L$41:
	R3  =R5 -R2 ;
	cc =R3 <=7 (iu);
	if cc jump 6; jump.l L$L$37;
	P5  =R6 ;
	P2 =P1 +P5 ;
	R0  =R4 ;
	R0  <<=R3 ;
	R3  =-R0 ;
	R0  = B [P2 ] (X);
	R3  =R3 &R0 ;
	R0  =R1 ;
	R0  >>=R2 ;
	R0  =R3 |R0 ;
	jump.s L$L$44;
L$L$37:
	P5  =R6 ;
	P2 =P1 +P5 ;
	R0  =R1 ;
	R0  >>=R2 ;
L$L$44:
	B [P2 ] =R0 ;
	R2 +=8;
	R0  = 1 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	R6 +=-1;
	cc =P0 ==0;
	if cc R6  =R0 ; /* movsicc-1b */
	cc =R2 <R5  (iu);
	if !cc jump 6; jump.l L$L$41;
L$L$43:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _floatformat_from_double;
.type _floatformat_from_double, STT_FUNC;
_floatformat_from_double:
	LINK 20;
	[--sp] = ( r7:4, p5:3 );
	R6  =R0 ;
	P2  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	[FP +-16] =R2 ;
	R2  =[P2 ];
	[FP +-8] =R2 ;
	P4  = -8 (X);
	P4 =P4 +FP ; //immed->Preg 
	P2  =[P2 +4];
	[P4 +4] =P2 ;
	P1  =R0 ;
	R1  =[P1 +4];
	R1  >>=3;
	R0  =R5 ;
	call _bzero;
	R4  =[FP +-8];
	[SP +12] =R4 ;
	R2  =[P4 +4];
	[SP +16] =R2 ;
	call ___eqdf2;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$45;
	[SP +12] =R4 ;
	P4  =[P4 +4];
	[SP +16] =P4 ;
	call ___nedf2;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$48;
	P1  =R6 ;
	R2  =[P1 +4];
	P2  =[P1 +12];
	[SP +12] =P2 ;
	R0  =[P1 +16];
	[SP +16] =R0 ;
	R1  =[P1 +24];
	[SP +20] =R1 ;
	R0  =R5 ;
	R1  =[P1 ];
	call _put_field;
	P1  =R6 ;
	R2  =[P1 +4];
	P2  =[P1 +28];
	[SP +12] =P2 ;
	R0  = 32 (X);
	[SP +16] =R0 ;
	R1  = 1 (X);
	[SP +20] =R1 ;
	R0  =R5 ;
	R1  =[P1 ];
	call _put_field;
	jump.s L$L$45;
L$L$48:
	P4  = -8 (X);
	P4 =P4 +FP ; //immed->Preg 
	R2  =[FP +-8];
	[SP +12] =R2 ;
	R3  =[P4 +4];
	[SP +16] =R3 ;
	call ___ltdf2;
	cc =R0 <0;
	if cc jump 6; jump.l L$L$50;
	P1  =R6 ;
	R2  =[P1 +4];
	R3  =[P1 +8];
	[SP +12] =R3 ;
	P1  = 1 (X);
	[SP +16] =P1 ;
	[SP +20] =P1 ;
	R0  =[FP +-16];
	P1  =R6 ;
	R1  =[P1 ];
	call _put_field;
	R2  =[FP +-8];
	[SP +12] =R2 ;
	R3  =[P4 +4];
	[SP +16] =R3 ;
	call ___negdf2;
	[FP +-8] =R0 ;
	[P4 +4] =R1 ;
L$L$50:
	P1  =[FP +-8];
	[SP +12] =P1 ;
	R0  =[FP +-4];
	[SP +16] =R0 ;
	R1  =FP ;
	R1 +=-12;
	call _frexp;
	R4  =R0 ;
	P3  =R1 ;
	P1  =R6 ;
	R2  =[P1 +4];
	R0  =[P1 +12];
	[SP +12] =R0 ;
	R1  =[P1 +16];
	[SP +16] =R1 ;
	R1  =[FP +-12];
	R0  =[P1 +20];
	R0 =R1 +R0 ;
	R0 +=-1;
	[SP +20] =R0 ;
	R0  =[FP +-16];
	R1  =[P1 ];
	call _put_field;
	P1  =R6 ;
	R5  =[P1 +32];
	P4  =[P1 +28];
	cc =R5 <=0;
	if !cc jump 6; jump.l L$L$45;
L$L$59:
	P5  = 32 (X);
	R0  =P5 ;
	R0  =min(R5 ,R0 );
	P5  =R0 ;
	[SP +12] =R4 ;
	[SP +16] =P3 ;
	call ___muldf3;
	R4  =R0 ;
	P3  =R1 ;
	[SP +12] =R0 ;
	[SP +16] =R1 ;
	call ___fixunsdfsi;
	[FP +-20] =R0 ;
	[SP +12] =R4 ;
	[SP +16] =P3 ;
	call ___subdf3;
	R4  =R0 ;
	P3  =R1 ;
	P1  =R6 ;
	R0  =[P1 +32];
	cc =R5 ==R0 ;
	if cc jump 6; jump.l L$L$56;
	R0  =[P1 +36];
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$56;
	R0  =[FP +-20];
	BITCLR (R0 ,31);
	[FP +-20] =R0 ;
	P5 +=-1;
	jump.s L$L$57;
L$L$56:
	P1  = 31 (X);
	cc =P5 <=P1  (iu);
	if cc jump 6; jump.l L$L$57;
	R0  = 32 (X);
	R1  =P5 ;
	R0  =R0 -R1 ;
	R1  =[FP +-20];
	R1  >>=R0 ;
	[FP +-20] =R1 ;
L$L$57:
	P1  =R6 ;
	R2  =[P1 +4];
	[SP +12] =P4 ;
	[SP +16] =P5 ;
	R0  =[FP +-20];
	[SP +20] =R0 ;
	R0  =[FP +-16];
	R1  =[P1 ];
	call _put_field;
	P4 =P4 +P5 ;
	R1  =P5 ;
	R5  =R5 -R1 ;
	cc =R5 <=0;
	if cc jump 6; jump.l L$L$59;
L$L$45:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _floatformat_is_valid;
.type _floatformat_is_valid, STT_FUNC;
_floatformat_is_valid:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	R0  = 1 (X);
	P2.L  = _floatformat_i387_ext; P2.H  = _floatformat_i387_ext;
	cc =P5 ==P2 ;
	if cc jump 6; jump.l L$L$61;
	R2  =[P5 +4];
	R0  =[P5 +12];
	[SP +12] =R0 ;
	P2  =[P5 +16];
	[SP +16] =P2 ;
	R0  =R1 ;
	R1  =[P5 ];
	call _get_field;
	R6  =R0 ;
	R2  =[P5 +4];
	R0  =[P5 +28];
	[SP +12] =R0 ;
	P2  = 1 (X);
	[SP +16] =P2 ;
	R0  =R5 ;
	R1  =[P5 ];
	call _get_field;
	cc =R6 ==0;
	R1  =CC ;
	cc =R0 ==0;
	R0  =CC ;
	cc =R1 ==R0 ;
	R0  =CC ;
L$L$61:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


