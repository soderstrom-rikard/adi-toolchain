// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "regex.i";
.data;
.align 2
L_done_$0:.space 4;
.text;
.align 2
.type _init_syntax_once, STT_FUNC;
_init_syntax_once:
	LINK 0;
	[--sp] = ( r7:6 );
	P2.L  = L_done_$0; P2.H  = L_done_$0;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1;
	R0.L  = _re_syntax_table; R0.H  = _re_syntax_table;
	R1  = 256 (X);
	call _bzero;
	R6  = 0 (X);
	R2  = 255 (X);
	cc =R6 <=R2 ;
	if cc jump 6; jump.l L$L$10;
L$L$8:
	R0  =R6 ;
	call _isalnum;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$5;
	P1  =R6 ;
	P2.L  = _re_syntax_table; P2.H  = _re_syntax_table;
	P2 =P2 +P1 ; //immed->Preg 
	R0  = 1 (X);
	B [P2 ] =R0 ;
L$L$5:
	R6 +=1;
	R2  = 255 (X);
	cc =R6 <=R2 ;
	if !cc jump 6; jump.l L$L$8;
L$L$10:
	P2.L  = _re_syntax_table; P2.H  = _re_syntax_table;
	R0  = 1 (X);
	B [P2 +95] =R0 ;
	P2.L  = L_done_$0; P2.H  = L_done_$0;
	R2  = 1 (X);
	[P2 ] =R2 ;
L$L$1:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.global _xre_max_failures;
.data;
.align 2
_xre_max_failures:	.long	4000
.text;
.align 2
L$LC$0:
.dw	0x6c61;
.dw	0x756e;
.db	0x6d;
.db	0x00;
.align 2
L$LC$1:
.dw	0x6c61;
.dw	0x6870;
.db	0x61;
.db	0x00;
.align 2
L$LC$2:
.dw	0x6c62;
.dw	0x6e61;
.db	0x6b;
.db	0x00;
.align 2
L$LC$3:
.dw	0x6e63;
.dw	0x7274;
.db	0x6c;
.db	0x00;
.align 2
L$LC$4:
.dw	0x6964;
.dw	0x6967;
.db	0x74;
.db	0x00;
.align 2
L$LC$5:
.dw	0x7267;
.dw	0x7061;
.db	0x68;
.db	0x00;
.align 2
L$LC$6:
.dw	0x6f6c;
.dw	0x6577;
.db	0x72;
.db	0x00;
.align 2
L$LC$7:
.dw	0x7270;
.dw	0x6e69;
.db	0x74;
.db	0x00;
.align 2
L$LC$8:
.dw	0x7570;
.dw	0x636e;
.db	0x74;
.db	0x00;
.align 2
L$LC$9:
.dw	0x7073;
.dw	0x6361;
.db	0x65;
.db	0x00;
.align 2
L$LC$10:
.dw	0x7075;
.dw	0x6570;
.db	0x72;
.db	0x00;
.align 2
L$LC$11:
.dw	0x6478;
.dw	0x6769;
.dw	0x7469;
.db	0x00;
.align 2
.type _byte_regex_compile, STT_FUNC;
_byte_regex_compile:
	LINK 308;
	[--sp] = ( r7:4, p5:3 );
	P2  =R0 ;
	[FP +-156] =R0 ;
	[FP +16] =R2 ;
	[FP +-160] =R2 ;
	P5  =[FP +20];
	[FP +-152] =P2 ;
	P0  =R1 ;
	P2 =P2 +P0 ;
	[FP +-164] =P2 ;
	P2  =[P5 +20];
	[FP +-168] =P2 ;
	R6  = 0 (X);
	P4  = 0 (X);
	P3  = 0 (X);
	R0  = 0 (X);
	[FP +-172] =R0 ;
	R0  = 640 (X);
	call _malloc;
	R1  =R0 ;
	[FP +-12] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	P1  = 32 (X);
	[FP +-8] =P1 ;
	P2  = 0 (X);
	[FP +-4] =P2 ;
	R0  =[FP +-160];
	[P5 +12] =R0 ;
	R0  = -105 (X);
	R1  = B [P5 +28] (X);
	R0  =R0 &R1 ;
	B [P5 +28] =R0 ;
	[P5 +8] =P2 ;
	[P5 +24] =P2 ;
	call _init_syntax_once;
	R0  =[P5 +4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$13;
	R0  =[P5 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$14;
	R1  = 32 (X);
	call _realloc;
	jump.s L$L$904;
L$L$14:
	R0  = 32 (X);
	call _malloc;
L$L$904:
	[P5 ] =R0 ;
	R0  =[P5 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$16;
	R0  =[FP +-12];
	call _free;
	R0  = 12 (X);
	jump.l L$L$11;
L$L$16:
	R2  = 32 (X);
	[P5 +4] =R2 ;
L$L$13:
	R5  =[P5 ];
	[FP +-176] =R5 ;
	R0  =[FP +-152];
	P2  =[FP +-164];
	R3  =P2 ;
	cc =R0 ==R3 ;
	if !cc jump 6; jump.l L$L$726;
	R1  = 1 (X); R1  <<= 19; // zeros
	R0  =[FP +-160];
	R1  =R0 &R1 ;
	[FP +-180] =R1 ;
	R1  =[FP +-152];
	R0  = 14 (X);
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$11;
L$L$903:
	P2  =[FP +-152];
	R4  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$20;
	R0  = R4.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R4  = B [P2 ] (X);
L$L$20:
	R0  = R4.B  (Z);
	R0 +=-10;
	P2  = 114 (X);
	P1  =R0 ;
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$41;
P2.L =L$L$707;
P2.H =L$L$707;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$707:
	.dd		L$L$339;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$42;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$331;
	.dd		L$L$335;
	.dd		L$L$63;
	.dd		L$L$60;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$138;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$60;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$152;
	.dd		L$L$350;
	.dd		L$L$41;
	.dd		L$L$24;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$41;
	.dd		L$L$346;
	.dd		L$L$343;
L$L$24:
	P2  =[FP +-156];
	R0  =P2 ;
	R0 +=1;
	R1  =[FP +-152];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$26;
	R0  = 8 (X);
	R2  =[FP +-160];
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$26;
	R0  =P2 ;
	call _byte_at_begline_loc_p;
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$41;
L$L$26:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$728;
L$L$39:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$33;
	[P5 +4] =R2 ;
L$L$33:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$28;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$28:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$39;
L$L$728:
	R3  = 9 (X);
	jump.l L$L$916;
L$L$42:
	R0  =[FP +-152];
	P2  =[FP +-164];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$44;
	R1  = 8 (X);
	R2  =[FP +-160];
	R1  =R2 &R1 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$44;
	R1  =P2 ;
	call _byte_at_endline_loc_p;
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$41;
L$L$44:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$730;
L$L$57:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$51;
	[P5 +4] =R2 ;
L$L$51:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$46;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$46:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$57;
L$L$730:
	R3  = 10 (X);
	jump.l L$L$916;
L$L$802:
	R1  =[FP +-152];
	R1 +=-1;
	jump.s L$L$905;
L$L$60:
	R0  = 1026 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
L$L$62:
L$L$63:
	cc =P4 ==0;
	if cc jump 6; jump.l L$L$64;
	R0  = 32 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$857;
	R0  = 16 (X);
	R1  =R1 &R0 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$41;
L$L$64:
	R0  = 0 (X);
	B [FP +-181] =R0 ;
	B [FP +-182] =R0 ;
	R1  = 2 (X);
	R2  =[FP +-160];
	R2  =R2 &R1 ;
	[FP +-308] =R2 ;
L$L$892:
	R2  = B [FP +-182] (X);
	R2  = R2.B  (X);
	P2  =R2 ;
	R2  = R4.B  (Z);
	R3  =P2 ;
	BITSET (R3 ,0);
	R1  = 43 (X);
	cc =R2 ==R1 ;
	if !cc R2  =R3 ; if cc R2 =P2 ; /* movsicc-1 */
	B [FP +-182] =R2 ;
	R2  = R0.B  (X);
	R3  = R4.B  (Z);
	R4  =R2 ;
	BITSET (R4 ,0);
	R0  = 63 (X);
	cc =R3 ==R0 ;
	if !cc R0  =R4 ; if cc R0 =R2 ; /* movsicc-1 */
	R2  =[FP +-152];
	P2  =[FP +-164];
	R1  =P2 ;
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$69;
	P2  =R2 ;
	R4  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$74;
	R2  = R4.B  (Z);
	P0  =R2 ;
	P2 =P2 +P0 ;
	R4  = B [P2 ] (X);
L$L$74:
	R2  = R4.B  (Z);
	R1  = 42 (X);
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$892;
	R3  =[FP +-308];
	cc =R3 ==0;
	if cc jump 6; jump.l L$L$891;
	R1  = 43 (X);
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$892;
	R3  = 63 (X);
	cc =R2 ==R3 ;
	if !cc jump 6; jump.l L$L$892;
	R1  =[FP +-308];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$80;
L$L$891:
	R2  = R4.B  (Z);
	R3  = 92 (X);
	cc =R2 ==R3 ;
	if cc jump 6; jump.l L$L$80;
	R2  =[FP +-152];
	P2  =[FP +-164];
	R1  =P2 ;
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$842;
	P2  =R2 ;
	R2  = B [P2 ++] (X);
	B [FP +-183] =R2 ;
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$82;
	R2  = R2.B  (Z);
	P0  =R2 ;
	P2 =P2 +P0 ;
	R2  = B [P2 ] (X);
	B [FP +-183] =R2 ;
L$L$82:
	R2  = B [FP +-183] (X);
	R2  = R2.B  (Z);
	R1  = 43 (X);
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$85;
	R3  = 63 (X);
	cc =R2 ==R3 ;
	if cc jump 6; jump.l L$L$802;
L$L$85:
	R4  = B [FP +-183] (X);
	jump.s L$L$892;
L$L$80:
	R1  =[FP +-152];
L$L$905:
	R1 +=-1;
	[FP +-152] =R1 ;
L$L$69:
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$17;
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$88;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$732;
L$L$100:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$94;
	[P5 +4] =R2 ;
L$L$94:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$89;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R4 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R4 ; /* movsicc-1a */
L$L$89:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$100;
L$L$732:
	P1  =[FP +-168];
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$102;
	P2  =[FP +-152];
	R3  = B [P2 +-2] (Z);
	P2  =R3 ;
	P1 =P1 +P2 ;
	R1  = B [P1 ] (X);
	jump.s L$L$103;
L$L$102:
	R1  =[FP +-152];
	P0  =R1 ;
	R1  = B [P0 +-2] (X);
L$L$103:
	R0  =[FP +-168];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$104;
	P1  =R0 ;
	R0  = B [P1 +46] (X);
	jump.s L$L$906;
L$L$104:
	R0  = 46 (X);
L$L$906:
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$101;
	R0  = B [FP +-182] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$101;
	P1  =[FP +-152];
	P2  =[FP +-164];
	cc =P1 <P2  (iu);
	if cc jump 6; jump.l L$L$101;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$106;
	R1  = B [P1 ] (Z);
	P1  =R1 ;
	P2 =P2 +P1 ;
	R1  = B [P2 ] (X);
	jump.s L$L$107;
L$L$106:
	R1  =[FP +-152];
	P0  =R1 ;
	R1  = B [P0 ] (X);
L$L$107:
	R0  =[FP +-168];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$108;
	P1  =R0 ;
	R0  = B [P1 +10] (X);
	jump.s L$L$907;
L$L$108:
	R0  = 10 (X);
L$L$907:
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$101;
	R1  = 64 (X);
	R0  =[FP +-160];
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$101;
	R1  =P4 ;
	R0  =R1 -R5 ;
	R0 +=-3;
	R2  =R0 ;
	R0  = 13 (X);
	R1  =R5 ;
	call _byte_store_op1;
	R0  = 1 (X);
	B [FP +-181] =R0 ;
	jump.s L$L$110;
L$L$101:
	R2  =P4 ;
	R0  =R2 -R5 ;
	R0 +=-6;
	R2  =R0 ;
	R0  = 18 (X);
	R1  =R5 ;
	call _byte_store_op1;
L$L$110:
	R5 +=3;
L$L$88:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$734;
L$L$122:
	R0  = 15 (X);
	R3  = 1 (X); R3  <<= 16; // zeros
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R3 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$116;
	[P5 +4] =R3 ;
L$L$116:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$111;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R4 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R4 ; /* movsicc-1a */
L$L$111:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$122;
L$L$734:
	R0  = B [FP +-181] (X);
	R1  = R0.B  (X);
	R2  = 15 (X);
	R0  = 16 (X);
	cc =R1 ==0;
	if cc R0  =R2 ; /* movsicc-2a */
	R3  =P4 ;
	R2  =R5 -R3 ;
	[SP +12] =R5 ;
	R1  =P4 ;
	call _byte_insert_op1;
	R6  = 0 (X);
	R5 +=3;
	R0  = B [FP +-182] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$17;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$736;
L$L$137:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$131;
	[P5 +4] =R2 ;
L$L$131:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$126;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$126:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$137;
L$L$736:
	[SP +12] =R5 ;
	R2  = 3 (X);
	R0  = 19 (X);
	R1  =P4 ;
	call _byte_insert_op1;
	R5 +=3;
	jump.l L$L$17;
L$L$138:
	P4  =R5 ;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$738;
L$L$151:
	R0  = 15 (X);
	R3  = 1 (X); R3  <<= 16; // zeros
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R3 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$145;
	[P5 +4] =R3 ;
L$L$145:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$140;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$140:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$151;
L$L$738:
	R3  = 3 (X);
	jump.l L$L$916;
L$L$152:
	R0  = 0 (X);
	B [FP +-184] =R0 ;
	R0  = -1 (X);
	[FP +-188] =R0 ;
	R0  =[FP +-152];
	P2  =[FP +-164];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$838;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=34;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$740;
L$L$165:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$159;
	[P5 +4] =R2 ;
L$L$159:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$154;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$154:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=34;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$165;
L$L$740:
	P4  =R5 ;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$742;
L$L$178:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$172;
	[P5 +4] =R2 ;
L$L$172:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$167;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$167:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$178;
L$L$742:
	P2  =R5 ;
	R5 +=1;
	R0  =[FP +-152];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R1  = 94 (X);
	R1  =R0 ^R1 ;
	R1  =abs R1 ;
	R1  =-R1 ;
	R0  =R1 ;
	R0  >>=31;
	I0  = 5 (X);
	R1  =I0 ;
	R0  =R1 -R0 ;
	B [FP +-189] =R0 ;
	B [P2 ] =R0 ;
	P2  =[FP +-152];
	R0  = B [P2 ] (X);
	R1  = 94 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$181;
	P2 +=1;
	[FP +-152] =P2 ;
L$L$181:
	R0  =[FP +-152];
	[FP +-196] =R0 ;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$744;
L$L$194:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$188;
	[P5 +4] =R2 ;
L$L$188:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$183;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$183:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$194;
L$L$744:
	R3  = 32 (X);
	P0  =R5 ;
	R5 +=1;
	B [P0 ++] =R3 ;
	R0  =R5 ;
	R1  = 32 (X);
	call _bzero;
	P1  =R5 ;
	R0  = B [P1 +-2] (Z);
	R1  = 5 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$195;
	R1  = 256 (X);
	R0  =[FP +-160];
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$195;
	R0  = B [P1 +1] (X);
	BITSET (R0 ,2);
	B [P1 +1] =R0 ;
L$L$195:
	R4  = 1 (X);
	R0  =[FP +-160];
	R4  =R0 &R4 ;
	R1  = 4 (X);
	R0  =R0 &R1 ;
	[FP +-200] =R0 ;
L$L$893:
	R0  =[FP +-152];
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$838;
	P2  =R0 ;
	R1  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$200;
	R0  = R1.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R1  = B [P2 ] (X);
L$L$200:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$203;
	R0  = R1.B  (Z);
	R2  = 92 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$203;
	R0  =[FP +-152];
	P2  =[FP +-164];
	R3  =P2 ;
	cc =R0 ==R3 ;
	if !cc jump 6; jump.l L$L$842;
	P2  =R0 ;
	R0  = B [P2 ++] (X);
	B [FP +-183] =R0 ;
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$205;
	R0  = R0.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R0  = B [P2 ] (X);
	B [FP +-183] =R0 ;
L$L$205:
	R0  = B [FP +-183] (X);
	R3  = R0.B  (Z);
	R0  =R3 ;
	R0  >>=3;
	B [FP +-201] =R0 ;
	jump.s L$L$910;
L$L$203:
	R0  = R1.B  (Z);
	R2  = 93 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$208;
	R2  =[FP +-196];
	R2 +=1;
	R0  =[FP +-152];
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$197;
L$L$208:
	R0  = B [FP +-184] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$209;
	R0  = R1.B  (Z);
	R3  = 45 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$210;
	R0  =[FP +-152];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R2  = 93 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$822;
L$L$209:
	R0  = R1.B  (Z);
	R3  = 45 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$210;
	R0  =[FP +-152];
	R0 +=-2;
	P2  =[FP +-156];
	R2  =P2 ;
	cc =R0 <R2  (iu);
	if !cc jump 6; jump.l L$L$211;
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R2  = 91 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$210;
L$L$211:
	R0  =[FP +-152];
	R2  = -3 (X);
	R2 =R2 +R0 ; //immed->Dreg 
	P2  =[FP +-156];
	R3  =P2 ;
	cc =R2 <R3  (iu);
	if !cc jump 6; jump.l L$L$212;
	P0  =R2 ;
	R2  = B [P0 ] (X);
	R3  = 91 (X);
	cc =R2 ==R3 ;
	if cc jump 6; jump.l L$L$212;
	P0  =R0 ;
	R0  = B [P0 +-2] (X);
	R2  = 94 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$210;
L$L$212:
	R0  =[FP +-152];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R2  = 93 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$210;
	P2  =[FP +-168];
	[SP +12] =P2 ;
	R0  =[FP +-160];
	[SP +16] =R0 ;
	[SP +20] =R5 ;
	P2  =[FP +-164];
	R2  =P2 ;
	R0  =[FP +-188];
	R3  =FP ;
	R1  = -152 (X);
	R1 =R1 +R3 ; //immed->Dreg 
	call _byte_compile_range;
	R1  =R0 ;
	[FP +-208] =R0 ;
	R0  = -1 (X);
	[FP +-188] =R0 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$893;
	jump.l L$L$823;
L$L$210:
	P2  =[FP +-152];
	R0  = B [P2 ] (X);
	R2  = 45 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$215;
	R0  = B [P2 +1] (X);
	R3  = 93 (X);
	cc =R0 ==R3 ;
	if !cc jump 6; jump.l L$L$215;
	R0  = 14 (X);
	P1  =[FP +-164];
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$11;
	R0  =P2 ;
	R0 +=1;
	[FP +-152] =R0 ;
	R1  = R1.B  (Z);
	P2  =[FP +-168];
	[SP +12] =P2 ;
	R0  =[FP +-160];
	[SP +16] =R0 ;
	[SP +20] =R5 ;
	R2  =P1 ;
	R0  =R1 ;
	R3  =FP ;
	R1  = -152 (X);
	R1 =R1 +R3 ; //immed->Dreg 
	call _byte_compile_range;
	R1  =R0 ;
	[FP +-212] =R0 ;
	R0  = -1 (X);
	[FP +-188] =R0 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$893;
	jump.l L$L$825;
L$L$215:
	R0  =[FP +-200];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$299;
	R0  = R1.B  (Z);
	R2  = 91 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$221;
	P1  =[FP +-152];
	R0  = B [P1 ] (X);
	R3  = 58 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$221;
	R0  = 14 (X);
	P2  =[FP +-164];
	cc =P1 ==P2 ;
	if !cc jump 6; jump.l L$L$11;
	R0  =P1 ;
	R0 +=1;
	[FP +-152] =R0 ;
	R0  = 0 (X);
	B [FP +-183] =R0 ;
	R0  =[FP +-152];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$838;
	P1  = -20 (X);
	P1 =P1 +FP ; //immed->Preg 
L$L$894:
	R1  =[FP +-152];
	R0  = 14 (X);
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =R1 ;
	R0  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$229;
	R0  = R0.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R0  = B [P2 ] (X);
L$L$229:
	R1  = R0.B  (Z);
	R2  = 58 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$234;
	R1  =[FP +-152];
	P0  =R1 ;
	R1  = B [P0 ] (X);
	R2 +=35;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$227;
L$L$234:
	R1  =[FP +-152];
	P2  =[FP +-164];
	R3  =P2 ;
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$227;
	R2  = B [FP +-183] (X);
	R1  = R2.B  (Z);
	cc =R1 <=5 (iu);
	if cc jump 6; jump.l L$L$235;
	R1  =R2 ;
	R2 +=1;
	B [FP +-183] =R2 ;
	R1  = R1.B  (Z);
	P2  =R1 ;
	P2 =P1 +P2 ;
	B [P2 ] =R0 ;
	jump.s L$L$894;
L$L$235:
	R0  = 0 (X);
	B [FP +-20] =R0 ;
	jump.s L$L$894;
L$L$227:
	R1  = B [FP +-183] (X);
	R1  = R1.B  (Z);
	P2  =R1 ;
	P1  = -20 (X);
	P1 =P1 +FP ; //immed->Preg 
	P2 =P1 +P2 ;
	R1  = 0 (X);
	B [P2 ] =R1 ;
	R0  = R0.B  (Z);
	R2  = 58 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$237;
	R0  =[FP +-152];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R1  = 93 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$237;
	R0  =P1 ;
	R1.L  = L$LC$0; R1.H  = L$LC$0;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-213] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$1; R1.H  = L$LC$1;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-214] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$2; R1.H  = L$LC$2;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-215] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$3; R1.H  = L$LC$3;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-216] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$4; R1.H  = L$LC$4;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-217] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$5; R1.H  = L$LC$5;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-218] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$6; R1.H  = L$LC$6;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-219] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$7; R1.H  = L$LC$7;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-220] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$8; R1.H  = L$LC$8;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-221] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$9; R1.H  = L$LC$9;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-222] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$10; R1.H  = L$LC$10;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-223] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$11; R1.H  = L$LC$11;
	call _strcmp;
	cc =R0 ==0;
	R0  =CC ;
	B [FP +-224] =R0 ;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$1; R1.H  = L$LC$1;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$10; R1.H  = L$LC$10;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$6; R1.H  = L$LC$6;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$4; R1.H  = L$LC$4;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$0; R1.H  = L$LC$0;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$11; R1.H  = L$LC$11;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$9; R1.H  = L$LC$9;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$7; R1.H  = L$LC$7;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$8; R1.H  = L$LC$8;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$5; R1.H  = L$LC$5;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$3; R1.H  = L$LC$3;
	call _strcmp;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$238;
	P2  = -20 (X);
	P2 =P2 +FP ; //immed->Preg 
	R0  =P2 ;
	R1.L  = L$LC$2; R1.H  = L$LC$2;
	call _strcmp;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$829;
L$L$238:
	R1  =[FP +-152];
	R0  = 14 (X);
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	R0  =R1 ;
	R0 +=1;
	[FP +-152] =R0 ;
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$838;
	R0  = 0 (X);
	[FP +-228] =R0 ;
	R3  = 255 (X);
	cc =R0 <=R3 ;
	if cc jump 6; jump.l L$L$911;
L$L$265:
	R0  = B [FP +-213] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$249;
	R0  =[FP +-228];
	call _isalnum;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$248;
L$L$249:
	R0  = B [FP +-214] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$250;
	R0  =[FP +-228];
	call _isalpha;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$248;
L$L$250:
	R0  = B [FP +-215] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$251;
	R0  =[FP +-228];
	R1  = 32 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$248;
	R2  = 9 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$248;
L$L$251:
	R0  = B [FP +-216] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$247;
	R0  =[FP +-228];
	call _iscntrl;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$247;
L$L$248:
	R1  =[FP +-228];
	R1  = R1.B  (Z);
	R0  =R1 ;
	R0  >>=3;
	B [FP +-229] =R0 ;
	R2  = R0.B  (Z);
	R2 =R5 +R2 ;
	R0  = 7 (X);
	R1  =R1 &R0 ;
	R0  = 1 (X);
	R0  <<=R1 ;
	P0  =R2 ;
	R3  = B [P0 ] (X);
	R0  =R0 |R3 ;
	B [P0 ] =R0 ;
L$L$247:
	R0  = B [FP +-217] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$254;
	R0  =[FP +-228];
	call _isdigit;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$253;
L$L$254:
	R0  = B [FP +-218] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$255;
	R0  =[FP +-228];
	call _isprint;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$255;
	R0  =[FP +-228];
	call _isspace;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$253;
L$L$255:
	R0  = B [FP +-219] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$256;
	R0  =[FP +-228];
	call _islower;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$253;
L$L$256:
	R0  = B [FP +-220] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$252;
	R0  =[FP +-228];
	call _isprint;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$252;
L$L$253:
	R2  =[FP +-228];
	R0  = R2.B  (Z);
	R1  =R0 ;
	R1  >>=3;
	R3  = R1.B  (Z);
	R3 =R5 +R3 ;
	R2  =R0 ;
	R0  = 7 (X);
	R0  =R2 &R0 ;
	R1  = 1 (X);
	R1  <<=R0 ;
	P0  =R3 ;
	R0  = B [P0 ] (X);
	R1  =R1 |R0 ;
	B [P0 ] =R1 ;
L$L$252:
	R0  = B [FP +-221] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$259;
	R0  =[FP +-228];
	call _ispunct;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$258;
L$L$259:
	R0  = B [FP +-222] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$260;
	R0  =[FP +-228];
	call _isspace;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$258;
L$L$260:
	R0  = B [FP +-223] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$261;
	R0  =[FP +-228];
	call _isupper;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$258;
L$L$261:
	R0  = B [FP +-224] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$257;
	R0  =[FP +-228];
	call _isxdigit;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$257;
L$L$258:
	R2  =[FP +-228];
	R0  = R2.B  (Z);
	R1  =R0 ;
	R1  >>=3;
	R3  = R1.B  (Z);
	R3 =R5 +R3 ;
	R2  =R0 ;
	R0  = 7 (X);
	R0  =R2 &R0 ;
	R1  = 1 (X);
	R1  <<=R0 ;
	P0  =R3 ;
	R0  = B [P0 ] (X);
	R1  =R1 |R0 ;
	B [P0 ] =R1 ;
L$L$257:
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$245;
	R0  = B [FP +-223] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$263;
	R0  = B [FP +-219] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$245;
L$L$263:
	R0  =[FP +-228];
	call _isupper;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$264;
	R0  =[FP +-228];
	call _islower;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$245;
L$L$264:
	R2  =[FP +-228];
	R0  = R2.B  (Z);
	R1  =R0 ;
	R1  >>=3;
	R3  = R1.B  (Z);
	R3 =R5 +R3 ;
	R2  =R0 ;
	R0  = 7 (X);
	R0  =R2 &R0 ;
	R1  = 1 (X);
	R1  <<=R0 ;
	P0  =R3 ;
	R0  = B [P0 ] (X);
	R1  =R1 |R0 ;
	B [P0 ] =R1 ;
L$L$245:
	R0  =[FP +-228];
	R0 +=1;
	[FP +-228] =R0 ;
	R1  = 255 (X);
	cc =R0 <=R1 ;
	if !cc jump 6; jump.l L$L$265;
	jump.s L$L$911;
L$L$237:
	R0  = B [FP +-183] (X);
	B [FP +-183] =R0 ;
	R0  = R0.B  (Z);
	R2  = 255 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$748;
	R2  =[FP +-152];
L$L$270:
	R2 +=-1;
	R0  = B [FP +-183] (X);
	R1  =R0 ;
	R1 +=-1;
	B [FP +-183] =R1 ;
	R1  = R1.B  (Z);
	R3  = 255 (X);
	cc =R1 ==R3 ;
	if cc jump 6; jump.l L$L$270;
	[FP +-152] =R2 ;
L$L$748:
	P0  =R5 ;
	R0  = B [P0 +11] (X);
	BITSET (R0 ,3);
	B [P0 +11] =R0 ;
	R0  = B [P0 +7] (X);
	BITSET (R0 ,2);
	B [P0 +7] =R0 ;
	R0  = 58 (X);
	jump.s L$L$908;
L$L$221:
	R0  =[FP +-200];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$299;
	R0  = R1.B  (Z);
	R2  = 91 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$272;
	P1  =[FP +-152];
	R0  = B [P1 ] (X);
	R3  = 61 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$272;
	R0  = 14 (X);
	P2  =[FP +-164];
	cc =P1 ==P2 ;
	if !cc jump 6; jump.l L$L$11;
	R0  =P1 ;
	R0 +=1;
	[FP +-152] =R0 ;
	R0  = 0 (X);
	B [FP +-183] =R0 ;
	R0  =[FP +-152];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$838;
	P1  = -20 (X);
	P1 =P1 +FP ; //immed->Preg 
L$L$895:
	R1  =[FP +-152];
	R0  = 14 (X);
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =R1 ;
	R0  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$280;
	R0  = R0.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R0  = B [P2 ] (X);
L$L$280:
	R1  = R0.B  (Z);
	R2  = 61 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$285;
	R1  =[FP +-152];
	P0  =R1 ;
	R1  = B [P0 ] (X);
	R2 +=32;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$278;
L$L$285:
	R1  =[FP +-152];
	P2  =[FP +-164];
	R3  =P2 ;
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$278;
	R2  = B [FP +-183] (X);
	R1  = R2.B  (Z);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$286;
	R1  =R2 ;
	R2 +=1;
	B [FP +-183] =R2 ;
	R1  = R1.B  (Z);
	P2  =R1 ;
	P2 =P1 +P2 ;
	B [P2 ] =R0 ;
	jump.s L$L$895;
L$L$286:
	R0  = 0 (X);
	B [FP +-20] =R0 ;
	jump.s L$L$895;
L$L$278:
	R1  = B [FP +-183] (X);
	R2  = R1.B  (Z);
	P0  =R2 ;
	P2 =FP +P0 ;
	R1  = 0 (X);
	B [P2 +-20] =R1 ;
	R0  = R0.B  (Z);
	R3  = 61 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$288;
	R0  =[FP +-152];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R1  = 93 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$288;
	R0  = B [FP +-20] (Z);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$288;
	cc =R2 ==1;
	if cc jump 6; jump.l L$L$840;
	R1  =P0 ;
	R0  = 14 (X);
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	R0  =P0 ;
	R0 +=1;
	[FP +-152] =R0 ;
	R2  = B [FP +-20] (Z);
	R0  =R2 ;
	R0  >>=3;
	B [FP +-230] =R0 ;
	R1  = R0.B  (Z);
	R1 =R5 +R1 ;
	R0  = 7 (X);
	R2  =R2 &R0 ;
	R0  = 1 (X);
	R0  <<=R2 ;
	P0  =R1 ;
	R3  = B [P0 ] (X);
	R0  =R0 |R3 ;
	B [P0 ] =R0 ;
L$L$911:
	R0  = 1 (X);
	jump.s L$L$909;
L$L$288:
	R0  = B [FP +-183] (X);
	B [FP +-183] =R0 ;
	R0  = R0.B  (Z);
	R1  = 255 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$750;
	R2  =[FP +-152];
L$L$297:
	R2 +=-1;
	R0  = B [FP +-183] (X);
	R1  =R0 ;
	R1 +=-1;
	B [FP +-183] =R1 ;
	R1  = R1.B  (Z);
	R3  = 255 (X);
	cc =R1 ==R3 ;
	if cc jump 6; jump.l L$L$297;
	[FP +-152] =R2 ;
L$L$750:
	P0  =R5 ;
	R0  = B [P0 +11] (X);
	BITSET (R0 ,3);
	B [P0 +11] =R0 ;
	R0  = B [P0 +7] (X);
	BITSET (R0 ,5);
	B [P0 +7] =R0 ;
	R0  = 61 (X);
	jump.s L$L$908;
L$L$272:
	R0  =[FP +-200];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$299;
	R0  = R1.B  (Z);
	R2  = 91 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$299;
	P1  =[FP +-152];
	R0  = B [P1 ] (X);
	R3  = 46 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$299;
	R0  = 14 (X);
	P2  =[FP +-164];
	cc =P1 ==P2 ;
	if !cc jump 6; jump.l L$L$11;
	R0  =P1 ;
	R0 +=1;
	[FP +-152] =R0 ;
	R0  = 0 (X);
	B [FP +-183] =R0 ;
	R0  =[FP +-152];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$838;
	P1  = -148 (X);
	P1 =P1 +FP ; //immed->Preg 
L$L$896:
	R1  =[FP +-152];
	R0  = 14 (X);
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =R1 ;
	R0  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$307;
	R0  = R0.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R0  = B [P2 ] (X);
L$L$307:
	R1  = R0.B  (Z);
	R2  = 46 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$312;
	R1  =[FP +-152];
	P0  =R1 ;
	R1  = B [P0 ] (X);
	R2 +=47;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$305;
L$L$312:
	R1  =[FP +-152];
	P2  =[FP +-164];
	R3  =P2 ;
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$305;
	R2  = B [FP +-183] (X);
	R1  = R2.B  (X);
	cc =R1 <0;
	if !cc jump 6; jump.l L$L$313;
	R1  =R2 ;
	R2 +=1;
	B [FP +-183] =R2 ;
	R1  = R1.B  (Z);
	P2  =R1 ;
	P2 =P1 +P2 ;
	B [P2 ] =R0 ;
	jump.s L$L$896;
L$L$313:
	R0  = 0 (X);
	B [FP +-148] =R0 ;
	jump.s L$L$896;
L$L$305:
	R1  = B [FP +-183] (X);
	R2  = R1.B  (Z);
	P0  =R2 ;
	P2 =FP +P0 ;
	R1  = 0 (X);
	B [P2 +-148] =R1 ;
	R0  = R0.B  (Z);
	R3  = 46 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$315;
	R0  =[FP +-152];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R1  = 93 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$315;
	R0  = B [FP +-148] (Z);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$315;
	cc =R2 ==1;
	if cc jump 6; jump.l L$L$840;
	R1  =P0 ;
	R0  = 14 (X);
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	R0  =P0 ;
	R0 +=1;
	[FP +-152] =R0 ;
	R2  = B [FP +-148] (Z);
	R0  =R2 ;
	R0  >>=3;
	B [FP +-231] =R0 ;
	R1  = R0.B  (Z);
	R1 =R5 +R1 ;
	R0  = 7 (X);
	R2  =R2 &R0 ;
	R0  = 1 (X);
	R0  <<=R2 ;
	P0  =R1 ;
	R3  = B [P0 ] (X);
	R0  =R0 |R3 ;
	B [P0 ] =R0 ;
	R0  = B [FP +-148] (Z);
	jump.s L$L$908;
L$L$315:
	R0  = B [FP +-183] (X);
	B [FP +-183] =R0 ;
	R0  = R0.B  (Z);
	R1  = 255 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$752;
	R2  =[FP +-152];
L$L$324:
	R2 +=-1;
	R0  = B [FP +-183] (X);
	R0 +=-1;
	B [FP +-183] =R0 ;
	R0  = R0.B  (Z);
	R3  = 255 (X);
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$324;
	[FP +-152] =R2 ;
L$L$752:
	P0  =R5 ;
	R0  = B [P0 +11] (X);
	BITSET (R0 ,3);
	B [P0 +11] =R0 ;
	R0  = B [P0 +5] (X);
	BITSET (R0 ,6);
	B [P0 +5] =R0 ;
	R0  = 46 (X);
L$L$908:
	[FP +-188] =R0 ;
	R0  = 0 (X);
L$L$909:
	B [FP +-184] =R0 ;
	jump.s L$L$893;
L$L$299:
	R0  = 0 (X);
	B [FP +-184] =R0 ;
	R3  = R1.B  (Z);
	R0  =R3 ;
	R0  >>=3;
	B [FP +-232] =R0 ;
L$L$910:
	R2  = R0.B  (Z);
	R2 =R5 +R2 ;
	R0  = 7 (X);
	R0  =R3 &R0 ;
	R1  = 1 (X);
	R1  <<=R0 ;
	P0  =R2 ;
	R0  = B [P0 ] (X);
	R1  =R1 |R0 ;
	B [P0 ] =R1 ;
	[FP +-188] =R3 ;
	jump.s L$L$893;
L$L$197:
	P1  =R5 ;
	R0  = B [P1 +-1] (Z);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$327;
	R0 =R5 +R0 ;
	P2  =R0 ;
	R0  = B [P2 +-1] (Z);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$327;
L$L$330:
	P0  =R5 ;
	R1  = B [P0 +-1] (X);
	R0  =R1 ;
	R0 +=-1;
	B [P0 +-1] =R0 ;
	R0  = B [P0 +-1] (Z);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$327;
	R0 =R5 +R0 ;
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$330;
L$L$327:
	P2  =R5 ;
	R0  = B [P2 +-1] (Z);
	R5 =R5 +R0 ;
	jump.l L$L$17;
L$L$331:
	R0  = 8192 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$333;
	jump.l L$L$41;
L$L$335:
	R0  = 8192 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$337;
	jump.l L$L$41;
L$L$339:
	R0  = 2048 (X);
	jump.s L$L$913;
L$L$343:
	R0  = -32768 (Z);
L$L$913:
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$341;
	jump.l L$L$41;
L$L$346:
	R0  = 4608 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	R1  = 4608 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$348;
	jump.l L$L$41;
L$L$350:
	R0  =[FP +-152];
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$842;
	P2  =R0 ;
	R4  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	R0  = R4.B  (Z);
	R0 +=-39;
	P2  = 85 (X);
	P0  =R0 ;
	cc = P0 <=P2  (iu);
if cc jump 6;
jump.l L$L$357;
P2.L =L$L$673;
P2.H =L$L$673;
P0  = P0 <<2;
P0  = P0 +P2 ;
P0  = [P0 ];
jump (P0 );

.align 2
.align 2
.align 2
L$L$673:
	.dd		L$L$626;
	.dd		L$L$355;
	.dd		L$L$376;
	.dd		L$L$357;
	.dd		L$L$667;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$649;
	.dd		L$L$649;
	.dd		L$L$649;
	.dd		L$L$649;
	.dd		L$L$649;
	.dd		L$L$649;
	.dd		L$L$649;
	.dd		L$L$649;
	.dd		L$L$649;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$551;
	.dd		L$L$357;
	.dd		L$L$566;
	.dd		L$L$667;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$596;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$536;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$611;
	.dd		L$L$357;
	.dd		L$L$581;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$521;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$357;
	.dd		L$L$442;
	.dd		L$L$414;
L$L$355:
	R0  = 8192 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$357;
L$L$333:
	R0  =[P5 +24];
	R0 +=1;
	[P5 +24] =R0 ;
	R0  =[FP +-172];
	R0 +=1;
	[FP +-172] =R0 ;
	P1  =[FP +-4];
	P2  =[FP +-8];
	cc =P1 ==P2 ;
	if cc jump 6; jump.l L$L$358;
	R0  =[FP +-12];
	P1  =P1 +(P1 <<2);
	R1  =P1 ;
	R1  <<=3;
	call _realloc;
	R1  =R0 ;
	[FP +-12] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	P2  =[FP +-8];
	P2  =P2 +P2 ;
	[FP +-8] =P2 ;
L$L$358:
	P1  =[FP +-4];
	P2  =[FP +-12];
	P1  =P1 +(P1 <<2);
	P2  =P2 +(P1 <<2);
	R1  =[P5 ];
	R0  =[FP +-176];
	R1  =R0 -R1 ;
	[P2 ] =R1 ;
	P1  =[FP +-4];
	P2  =[FP +-12];
	P1  =P1 +(P1 <<2);
	P2  =P2 +(P1 <<2);
	R0  = 0 (X);
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$361;
	R0  =[P5 ];
	R2  =P3 ;
	R0  =R2 -R0 ;
	R0 +=1;
L$L$361:
	[P2 +4] =R0 ;
	P1  =[FP +-4];
	P2  =[FP +-12];
	P1  =P1 +(P1 <<2);
	P2  =P2 +(P1 <<2);
	R0  =[P5 ];
	R0  =R5 -R0 ;
	[P2 +12] =R0 ;
	P1  =[FP +-4];
	P2  =[FP +-12];
	P1  =P1 +(P1 <<2);
	P2  =P2 +(P1 <<2);
	R0  =[FP +-172];
	[P2 +16] =R0 ;
	R3  = 255 (X);
	cc =R0 <=R3  (iu);
	if cc jump 6; jump.l L$L$362;
	P1  =[FP +-4];
	P2  =[FP +-12];
	P1  =P1 +(P1 <<2);
	P2  =P2 +(P1 <<2);
	R0  =[P5 ];
	R0  =R5 -R0 ;
	R0 +=2;
	[P2 +8] =R0 ;
	R6  =[P5 ];
	R0  =R5 -R6 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$755;
L$L$375:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$369;
	[P5 +4] =R2 ;
L$L$369:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R6 ==R1 ;
	if !cc jump 6; jump.l L$L$364;
	R6  =R1 -R6 ;
	R5 =R5 +R6 ;
L$L$364:
	R6  =[P5 ];
	R0  =R5 -R6 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$375;
L$L$755:
	R0  = 6 (X);
	P0  =R5 ;
	B [P0 ++] =R0 ;
	R0  =[FP +-172];
	B [P0 ++] =R0 ;
	R0  = 0 (X);
	P0 +=1;
	R5  =P0 ;
	P0 +=-1;
	B [P0 ++] =R0 ;
L$L$362:
	R0  =[FP +-4];
	R0 +=1;
	[FP +-4] =R0 ;
	P3  = 0 (X);
	P4  = 0 (X);
	[FP +-176] =R5 ;
	jump.s L$L$498;
L$L$376:
	R0  = 8192 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$357;
	R0  =[FP +-4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$337;
	R0  = 1 (X); R0  <<= 17; // zeros
	R1  =R1 &R0 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$357;
	jump.s L$L$917;
L$L$337:
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$381;
	R2  =[P5 ];
	R0  =R5 -R2 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$757;
L$L$394:
	[FP +-236] =R2 ;
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$388;
	[P5 +4] =R2 ;
L$L$388:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	R0  =R1 ;
	R1  =[FP +-236];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$383;
	R1  =R0 -R1 ;
	R5 =R5 +R1 ;
	R0  =[FP +-176];
	R0 =R0 +R1 ;
	[FP +-176] =R0 ;
	R2  =P3 ;
	R0 =R2 +R1 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R3  =P4 ;
	R0 =R3 +R1 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R1 =R6 +R1 ;
	cc =R6 ==0;
	if !cc R6  =R1 ; /* movsicc-1a */
L$L$383:
	R2  =[P5 ];
	R0  =R5 -R2 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$394;
L$L$757:
	R0  = 20 (X);
	P0  =R5 ;
	R5 +=1;
	B [P0 ++] =R0 ;
	R1  =P3 ;
	R0  =R5 -R1 ;
	R0 +=-4;
	R2  =R0 ;
	R0  = 14 (X);
	call _byte_store_op1;
L$L$381:
	R0  =[FP +-4];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$395;
	R0  = 1 (X); R0  <<= 17; // zeros
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
L$L$917:
	R0  =[FP +-12];
	call _free;
	R0  = 16 (X);
	jump.l L$L$11;
L$L$395:
	P1  =[FP +-4];
	P1 +=-1;
	[FP +-4] =P1 ;
	P2  =[FP +-12];
	P1  =P1 +(P1 <<2);
	P2  =P2 +(P1 <<2);
	R1  =[P5 ];
	R0  =[P2 ];
	R0 =R1 +R0 ;
	[FP +-176] =R0 ;
	P2  =[P2 +4];
	P3  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$399;
	P0  =R1 ;
	P3 =P0 +P2 ;
	P3 +=-1;
L$L$399:
	P1  =[FP +-4];
	P2  =[FP +-12];
	P1  =P1 +(P1 <<2);
	P2  =P2 +(P1 <<2);
	P1  =[P5 ];
	P4  =[P2 +12];
	P4 =P1 +P4 ;
	R1  =[P2 +16];
	[FP +-240] =R1 ;
	R6  = 0 (X);
	R0  = 255 (X);
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$17;
	P2  =[P2 +8];
	P1 =P1 +P2 ;
	R0  =[FP +-172];
	R1  =R0 -R1 ;
	B [P1 ] =R1 ;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$759;
L$L$413:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$407;
	[P5 +4] =R2 ;
L$L$407:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$402;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$402:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$413;
L$L$759:
	R3  = 7 (X);
	P0  =R5 ;
	B [P0 ++] =R3 ;
	R1  =[FP +-240];
	B [P0 ++] =R1 ;
	R0  =[FP +-172];
	R1  =R0 -R1 ;
	P0 +=1;
	R5  =P0 ;
	P0 +=-1;
	B [P0 ++] =R1 ;
	jump.s L$L$17;
L$L$414:
	R0  = -31744 (Z);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$357;
L$L$341:
	R0  = 1024 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$761;
L$L$428:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$422;
	[P5 +4] =R2 ;
L$L$422:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$417;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R0  =P3 ;
	R4 =R0 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R4 ; /* movsicc-1a */
L$L$417:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$428;
L$L$761:
	R1  =[FP +-176];
	R0  =R5 -R1 ;
	R0 +=3;
	[SP +12] =R5 ;
	R2  =R0 ;
	R0  = 15 (X);
	call _byte_insert_op1;
	R6  = 0 (X);
	R5 +=3;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$429;
	R1  =P3 ;
	R0  =R5 -R1 ;
	R0 +=-3;
	R2  =R0 ;
	R0  = 14 (X);
	call _byte_store_op1;
L$L$429:
	P3  =R5 ;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$763;
L$L$441:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$435;
	[P5 +4] =R2 ;
L$L$435:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$430;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$430:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$441;
L$L$763:
	R5 +=3;
	P4  = 0 (X);
	[FP +-176] =R5 ;
	jump.s L$L$17;
L$L$442:
	R0  = 4608 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	R2  = 512 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$357;
L$L$348:
	R4  = -1 (X);
	R0  = -1 (X);
	[FP +-244] =R0 ;
	R3  =[FP +-152];
	P2  =[FP +-164];
	R0  =P2 ;
	cc =R3 ==R0 ;
	if !cc jump 6; jump.l L$L$445;
L$L$901:
	P2  =[FP +-152];
	R0  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$449;
	R0  = R0.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R0  = B [P2 ] (X);
L$L$449:
	R1  =R0 ;
	R1 +=-48;
	R1  = R1.B  (Z);
	R2  = 9 (X);
	cc =R1 <=R2  (iu);
	if cc jump 6; jump.l L$L$447;
	R1  = 32767 (X);
	cc =R4 <=R1 ;
	if cc jump 6; jump.l L$L$446;
	R1  = 0 (X);
	R4  =max(R4 ,R1 );
	P0  =R4 ;
	P2  =P0 +(P0 <<2);
	R2  = R0.B  (Z);
	P1  =R2 ;
	P2  =P1 +(P2 <<1);
	R4  =P2 ;
	R4 +=-48;
L$L$446:
	R1  =[FP +-152];
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$901;
L$L$447:
	R1  = R0.B  (Z);
	R2  = 44 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$456;
	R1  =[FP +-152];
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$458;
L$L$902:
	P2  =[FP +-152];
	R0  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$460;
	R0  = R0.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R0  = B [P2 ] (X);
L$L$460:
	R1  =R0 ;
	R1 +=-48;
	R1  = R1.B  (Z);
	R2  = 9 (X);
	cc =R1 <=R2  (iu);
	if cc jump 6; jump.l L$L$458;
	P2  =[FP +-244];
	P0  = 32767 (X);
	cc =P2 <=P0 ;
	if cc jump 6; jump.l L$L$457;
	R1  = 0 (X);
	R2  =P2 ;
	R2  =max(R2 ,R1 );
	P2  =R2 ;
	P2  =P2 +(P2 <<2);
	R2  = R0.B  (Z);
	P0  =R2 ;
	P0  =P0 +(P2 <<1);
	R2  =P0 ;
	R2 +=-48;
	[FP +-244] =R2 ;
L$L$457:
	R1  =[FP +-152];
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$902;
L$L$458:
	R2  =[FP +-244];
	cc =R2 <0;
	if cc jump 6; jump.l L$L$468;
	R2  = 32767 (X);
	jump.s L$L$912;
L$L$456:
	R2  =R4 ;
L$L$912:
	[FP +-244] =R2 ;
L$L$468:
	cc =R4 <0;
	if !cc jump 6; jump.l L$L$445;
	R2  =[FP +-244];
	cc =R4 <=R2 ;
	if cc jump 6; jump.l L$L$445;
	R1  = 4096 (X);
	R2  =[FP +-160];
	R1  =R2 &R1 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$471;
	R0  = R0.B  (Z);
	R1  = 92 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$445;
	R0  =[FP +-152];
	P2  =[FP +-164];
	R2  =P2 ;
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$445;
	P2  =R0 ;
	R0  = B [P2 ++] (X);
	[FP +-152] =P2 ;
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$471;
	R0  = R0.B  (Z);
	P0  =R0 ;
	P2 =P2 +P0 ;
	R0  = B [P2 ] (X);
L$L$471:
	R0  = R0.B  (Z);
	R1  = 125 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$445;
	cc =P4 ==0;
	if cc jump 6; jump.l L$L$478;
	R0.L  = 32; R0.H  = 32;
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	R2  = 32 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$857;
	R0  = 16 (X);
	R1  =R1 &R0 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$483;
	P4  =R5 ;
L$L$478:
	R0  =[FP +-244];
	R3  = 32767 (X);
	cc =R0 <=R3 ;
	if cc jump 6; jump.l L$L$858;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$485;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$767;
L$L$497:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$491;
	[P5 +4] =R2 ;
L$L$491:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$486;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R4 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R4 ; /* movsicc-1a */
L$L$486:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=3;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$497;
L$L$767:
	R3  =P4 ;
	R2  =R5 -R3 ;
	[SP +12] =R5 ;
	R0  = 13 (X);
	R1  =P4 ;
	call _byte_insert_op1;
	R5 +=3;
	jump.s L$L$498;
L$L$485:
	R2  = 10 (X);
	R1  = 20 (X);
	R0  =[FP +-244];
	cc =R0 <2;
	if cc R1  =R2 ; /* movsicc-2a */
	[FP +-248] =R1 ;
	R6  =[P5 ];
	R0  =R5 -R6 ;
	R1 =R0 +R1 ;
	R2  =[P5 +4];
	cc =R1 <=R2  (iu);
	if !cc jump 6; jump.l L$L$769;
L$L$512:
	R0  = 15 (X);
	R1  = 1 (X); R1  <<= 16; // zeros
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R1 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$506;
	[P5 +4] =R1 ;
L$L$506:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R6 ==R1 ;
	if !cc jump 6; jump.l L$L$501;
	R6  =R1 -R6 ;
	R5 =R5 +R6 ;
	R0  =[FP +-176];
	R0 =R0 +R6 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R6 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R6 =R2 +R6 ;
	cc =P4 ==0;
	if !cc P4  =R6 ; /* movsicc-1a */
L$L$501:
	R6  =[P5 ];
	R0  =R5 -R6 ;
	R1  =[FP +-248];
	R1 =R0 +R1 ;
	R2  =[P5 +4];
	cc =R1 <=R2  (iu);
	if cc jump 6; jump.l L$L$512;
L$L$769:
	R1  = 5 (X);
	R1 =R1 +R5 ; //immed->Dreg 
	R0  =[FP +-244];
	cc =R0 <=1;
	if !cc jump 6; jump.l L$L$513;
	R3  =P4 ;
	R1  =R1 -R3 ;
	R1 +=2;
	jump.s L$L$514;
L$L$513:
	R0  =P4 ;
	R1  =R1 -R0 ;
	R1 +=-3;
L$L$514:
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	R2  =R1 ;
	R0  = 21 (X);
	R1  =P4 ;
	call _byte_insert_op2;
	R5 +=5;
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	R2  = 5 (X);
	R0  = 23 (X);
	R1  =P4 ;
	call _byte_insert_op2;
	R5 +=5;
	R4  =[FP +-244];
	cc =R4 <=1;
	if !cc jump 6; jump.l L$L$498;
	R1  =P4 ;
	R0  =R1 -R5 ;
	R0 +=2;
	R4 +=-1;
	[SP +12] =R4 ;
	R2  =R0 ;
	R0  = 22 (X);
	R1  =R5 ;
	call _byte_store_op2;
	R5 +=5;
	R3  =P4 ;
	R2  =R5 -R3 ;
	[SP +12] =R4 ;
	[SP +16] =R5 ;
	R0  = 23 (X);
	R1  =P4 ;
	call _byte_insert_op2;
	R5 +=5;
L$L$498:
	R6  = 0 (X);
	jump.s L$L$17;
L$L$445:
	R0  = 1 (X); R0  <<= 21; // zeros
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$483;
	R0  =[FP +-12];
	call _free;
	R1  =[FP +-152];
	R2  = 10 (X);
	R0  = 9 (X);
	P2  =[FP +-164];
	R3  =P2 ;
	cc =R1 ==R3 ;
	if !cc R0  =R2 ; /* movsicc-1a */
	jump.s L$L$11;
L$L$483:
	[FP +-152] =R3 ;
	R4  = 123 (X);
	R0  = 4096 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	jump.s L$L$357;
L$L$521:
	R0  =[FP +-180];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	P4  =R5 ;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$771;
L$L$535:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$529;
	[P5 +4] =R2 ;
L$L$529:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$524;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$524:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$535;
L$L$771:
	R3  = 24 (X);
	jump.s L$L$916;
L$L$536:
	R0  =[FP +-180];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	P4  =R5 ;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$773;
L$L$550:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$544;
	[P5 +4] =R2 ;
L$L$544:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$539;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$539:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$550;
L$L$773:
	R3  = 25 (X);
	jump.s L$L$916;
L$L$551:
	R0  =[FP +-180];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$775;
L$L$565:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$559;
	[P5 +4] =R2 ;
L$L$559:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$554;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$554:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$565;
L$L$775:
	R3  = 26 (X);
	jump.s L$L$916;
L$L$566:
	R0  =[FP +-180];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$777;
L$L$580:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$574;
	[P5 +4] =R2 ;
L$L$574:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$569;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$569:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$580;
L$L$777:
	R3  = 27 (X);
	jump.s L$L$916;
L$L$581:
	R0  =[FP +-180];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$779;
L$L$595:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$589;
	[P5 +4] =R2 ;
L$L$589:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$584;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$584:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$595;
L$L$779:
	R3  = 28 (X);
	jump.s L$L$916;
L$L$596:
	R0  =[FP +-180];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$781;
L$L$610:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$604;
	[P5 +4] =R2 ;
L$L$604:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$599;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$599:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$610;
L$L$781:
	R3  = 29 (X);
	jump.s L$L$916;
L$L$611:
	R0  =[FP +-180];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$783;
L$L$625:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$619;
	[P5 +4] =R2 ;
L$L$619:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$614;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$614:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$625;
L$L$783:
	R3  = 11 (X);
	jump.s L$L$916;
L$L$626:
	R0  =[FP +-180];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$785;
L$L$640:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$634;
	[P5 +4] =R2 ;
L$L$634:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$629;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$629:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$640;
L$L$785:
	R3  = 12 (X);
L$L$916:
	P0  =R5 ;
	R5 +=1;
	B [P0 ++] =R3 ;
	jump.s L$L$17;
L$L$649:
	R0  = 16384 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	R0  =R4 ;
	R1  = -48 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	B [FP +-183] =R1 ;
	R0  = R1.B  (Z);
	R2  =[FP +-172];
	cc =R0 <=R2  (iu);
	if cc jump 6; jump.l L$L$879;
	[SP +12] =R0 ;
	R0  =[FP +-12];
	R1  =[FP +-8];
	R2  =[FP +-4];
	call _group_in_compile_stack;
	R0  = R0.B  (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$41;
	P4  =R5 ;
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=2;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$787;
L$L$665:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$659;
	[P5 +4] =R2 ;
L$L$659:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R4 ==R1 ;
	if !cc jump 6; jump.l L$L$654;
	R4  =R1 -R4 ;
	R5 =R5 +R4 ;
	R0  =[FP +-176];
	R0 =R0 +R4 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R4 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R0 =R2 +R4 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R4 =R6 +R4 ;
	cc =R6 ==0;
	if !cc R6  =R4 ; /* movsicc-1a */
L$L$654:
	R4  =[P5 ];
	R0  =R5 -R4 ;
	R0 +=2;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$665;
L$L$787:
	R3  = 8 (X);
	P0  =R5 ;
	B [P0 ++] =R3 ;
	R0  = B [FP +-183] (X);
	P0 +=1;
	R5  =P0 ;
	P0 +=-1;
	B [P0 ++] =R0 ;
	jump.s L$L$17;
L$L$667:
	R0  = 2 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$63;
L$L$357:
	P2  =[FP +-168];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$41;
	R0  = R4.B  (Z);
	P1  =R0 ;
	P2 =P2 +P1 ;
	R4  = B [P2 ] (X);
L$L$41:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$676;
	P2  =R6 ;
	R1  = B [P2 ] (Z);
	R0 =R6 +R1 ;
	R0 +=1;
	cc =R0 ==R5 ;
	if cc jump 6; jump.l L$L$676;
	R0  = 255 (X);
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$676;
	R2  =[FP +-152];
	P0  =R2 ;
	R1  = B [P0 ] (X);
	R0  = 42 (X);
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$676;
	R3  = 94 (X);
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$676;
	R0  = 2 (X);
	R3  =[FP +-160];
	R0  =R3 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$677;
	R0  = 92 (X);
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$678;
	R2  = B [P0 +1] (X);
	R1  = 43 (X);
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$676;
	R3  = 63 (X);
	cc =R2 ==R3 ;
	jump.s L$L$914;
L$L$677:
	R0  =[FP +-152];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R1  = 43 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$676;
	R2  = 63 (X);
	cc =R0 ==R2 ;
L$L$914:
	if !cc jump 6; jump.l L$L$676;
L$L$678:
	R0  = 512 (X);
	R1  =[FP +-160];
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$675;
	R0  = 4096 (X);
	R1  =R1 &R0 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$679;
	R0  =[FP +-152];
	P0  =R0 ;
	R0  = B [P0 ] (X);
	R1  = 123 (X);
	cc =R0 ==R1 ;
	jump.s L$L$915;
L$L$679:
	R1  =[FP +-152];
	P0  =R1 ;
	R0  = B [P0 ] (X);
	R2  = 92 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$675;
	R1  = B [P0 +1] (X);
	R3  = 123 (X);
	cc =R1 ==R3 ;
L$L$915:
	if cc jump 6; jump.l L$L$675;
L$L$676:
	P4  =R5 ;
	R6  =[P5 ];
	R0  =R5 -R6 ;
	R0 +=2;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$789;
L$L$693:
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$687;
	[P5 +4] =R2 ;
L$L$687:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R6 ==R1 ;
	if !cc jump 6; jump.l L$L$682;
	R6  =R1 -R6 ;
	R5 =R5 +R6 ;
	R0  =[FP +-176];
	R0 =R0 +R6 ;
	[FP +-176] =R0 ;
	R1  =P3 ;
	R0 =R1 +R6 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R2  =P4 ;
	R6 =R2 +R6 ;
	cc =P4 ==0;
	if !cc P4  =R6 ; /* movsicc-1a */
L$L$682:
	R6  =[P5 ];
	R0  =R5 -R6 ;
	R0 +=2;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$693;
L$L$789:
	R3  = 2 (X);
	P0  =R5 ;
	B [P0 ++] =R3 ;
	R0  = 0 (X);
	P0 +=1;
	R5  =P0 ;
	P0 +=-1;
	B [P0 ++] =R0 ;
	R6  = -1 (X);
	R6 =R6 +R5 ; //immed->Dreg 
L$L$675:
	R2  =[P5 ];
	R0  =R5 -R2 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$791;
L$L$706:
	[FP +-252] =R2 ;
	R0  = 15 (X);
	R2  = 1 (X); R2  <<= 16; // zeros
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R2 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$700;
	[P5 +4] =R2 ;
L$L$700:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	R0  =R1 ;
	R1  =[FP +-252];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$695;
	R1  =R0 -R1 ;
	R5 =R5 +R1 ;
	R0  =[FP +-176];
	R0 =R0 +R1 ;
	[FP +-176] =R0 ;
	R2  =P3 ;
	R0 =R2 +R1 ;
	cc =P3 ==0;
	if !cc P3  =R0 ; /* movsicc-1a */
	R3  =P4 ;
	R0 =R3 +R1 ;
	cc =P4 ==0;
	if !cc P4  =R0 ; /* movsicc-1a */
	R1 =R6 +R1 ;
	cc =R6 ==0;
	if !cc R6  =R1 ; /* movsicc-1a */
L$L$695:
	R2  =[P5 ];
	R0  =R5 -R2 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$706;
L$L$791:
	P0  =R5 ;
	R5 +=1;
	B [P0 ++] =R4 ;
	P0  =R6 ;
	R1  = B [P0 ] (X);
	R0  =R1 ;
	R0 +=1;
	B [P0 ] =R0 ;
L$L$17:
	R0  =[FP +-152];
	P2  =[FP +-164];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$903;
L$L$726:
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$709;
	R2  =P3 ;
	R0  =R5 -R2 ;
	R0 +=-3;
	R2  =R0 ;
	R0  = 14 (X);
	R1  =P3 ;
	call _byte_store_op1;
L$L$709:
	R0  =[FP +-4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$710;
	R0  =[FP +-12];
	call _free;
	R0  = 8 (X);
	jump.s L$L$11;
L$L$822:
	R0  =[FP +-12];
	call _free;
	R0  = 11 (X);
	jump.s L$L$11;
L$L$823:
	R0  =[FP +-12];
	call _free;
	R0  =[FP +-208];
	jump.s L$L$11;
L$L$825:
	R0  =[FP +-12];
	call _free;
	R0  =[FP +-212];
	jump.s L$L$11;
L$L$829:
	R0  =[FP +-12];
	call _free;
	R0  = 4 (X);
	jump.s L$L$11;
L$L$838:
	R0  =[FP +-12];
	call _free;
	R0  = 7 (X);
	jump.s L$L$11;
L$L$840:
	R0  =[FP +-12];
	call _free;
	R0  = 3 (X);
	jump.s L$L$11;
L$L$842:
	R0  =[FP +-12];
	call _free;
	R0  = 5 (X);
	jump.s L$L$11;
L$L$857:
	R0  =[FP +-12];
	call _free;
	R0  = 13 (X);
	jump.s L$L$11;
L$L$858:
	R0  =[FP +-12];
	call _free;
	R0  = 10 (X);
	jump.s L$L$11;
L$L$879:
	R0  =[FP +-12];
	call _free;
	R0  = 6 (X);
	jump.s L$L$11;
L$L$710:
	R1  = 1 (X); R1  <<= 18; // zeros
	R0  =[FP +-160];
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$711;
	R6  =[P5 ];
	R0  =R5 -R6 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$793;
L$L$724:
	R0  = 15 (X);
	R3  = 1 (X); R3  <<= 16; // zeros
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$11;
	P2  =[P5 +4];
	P2  =P2 +P2 ;
	[P5 +4] =P2 ;
	P0  =R3 ;
	cc =P2 <=P0  (iu);
	if !cc jump 6; jump.l L$L$718;
	[P5 +4] =R3 ;
L$L$718:
	R1  =[P5 +4];
	R0  =[P5 ];
	call _realloc;
	R1  =R0 ;
	[P5 ] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$11;
	cc =R6 ==R1 ;
	if !cc jump 6; jump.l L$L$713;
	R6  =R1 -R6 ;
	R5 =R5 +R6 ;
L$L$713:
	R6  =[P5 ];
	R0  =R5 -R6 ;
	R0 +=1;
	R1  =[P5 +4];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$724;
L$L$793:
	R0  = 1 (X);
	P0  =R5 ;
	R5 +=1;
	B [P0 ++] =R0 ;
L$L$711:
	R0  =[FP +-12];
	call _free;
	R0  =[P5 ];
	R5  =R5 -R0 ;
	[P5 +8] =R5 ;
	R0  = 0 (X);
L$L$11:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_store_op1, STT_FUNC;
_byte_store_op1:
	LINK 0;
	P2  =R1 ;
	B [P2 ] =R0 ;
	B [P2 +1] =R2 ;
	R2  >>>=8;
	B [P2 +2] =R2 ;
	UNLINK;
	rts;


.align 2
.type _byte_store_op2, STT_FUNC;
_byte_store_op2:
	LINK 0;
	R3  =R2 ;
	R2  =[FP +20];
	P2  =R1 ;
	B [P2 ] =R0 ;
	B [P2 +1] =R3 ;
	R3  >>>=8;
	B [P2 +2] =R3 ;
	B [P2 +3] =R2 ;
	R2  >>>=8;
	B [P2 +4] =R2 ;
	UNLINK;
	rts;


.align 2
.type _byte_insert_op1, STT_FUNC;
_byte_insert_op1:
	LINK 0;
	[FP +16] =R2 ;
	P1  =[FP +20];
	P2  = 3 (X);
	P2 =P2 +P1 ; //immed->Preg 
	R3  =P1 ;
	cc =R3 ==R1 ;
	if !cc jump 6; jump.l L$L$929;
L$L$927:
	P2 +=-1;
	P1 +=-1;
	R3  = B [P1 ] (X);
	B [P2 ] =R3 ;
	R3  =P1 ;
	cc =R3 ==R1 ;
	if cc jump 6; jump.l L$L$927;
L$L$929:
	call _byte_store_op1;
	UNLINK;
	rts;


.align 2
.type _byte_insert_op2, STT_FUNC;
_byte_insert_op2:
	LINK 0;
	[--sp] = ( r7:6 );
	[FP +16] =R2 ;
	R3  =[FP +20];
	P1  =[FP +24];
	P2  = 5 (X);
	P2 =P2 +P1 ; //immed->Preg 
	R6  =P1 ;
	cc =R6 ==R1 ;
	if !cc jump 6; jump.l L$L$936;
L$L$934:
	P2 +=-1;
	P1 +=-1;
	R6  = B [P1 ] (X);
	B [P2 ] =R6 ;
	R6  =P1 ;
	cc =R6 ==R1 ;
	if cc jump 6; jump.l L$L$934;
L$L$936:
	[SP +12] =R3 ;
	call _byte_store_op2;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_at_begline_loc_p, STT_FUNC;
_byte_at_begline_loc_p:
	LINK 0;
	[--sp] = ( r7:6 );
	P2  =R1 ;
	[FP +16] =R2 ;
	P2 +=-2;
	R1  = 0 (X);
	R3  =P2 ;
	cc =R3 <=R0  (iu);
	if !cc jump 6; jump.l L$L$938;
	R0  = B [P2 +-1] (X);
	R6  = 92 (X);
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$938;
	R1  = 1 (X);
L$L$938:
	R3  = 0 (X);
	R0  = B [P2 ] (X);
	R6  = 40 (X);
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$941;
	R0  = 8192 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$940;
	R0  = R1.B  (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$940;
L$L$941:
	R0  = B [P2 ] (X);
	P2  =R0 ;
	P1  = 124 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$939;
	R0  = -32768 (Z);
	R2  =R2 &R0 ;
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$940;
	R0  = R1.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$939;
L$L$940:
	R3  = 1 (X);
L$L$939:
	R0  =R3 ;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_at_endline_loc_p, STT_FUNC;
_byte_at_endline_loc_p:
	LINK 4;
	[--sp] = ( r7:6 );
	R3  =R0 ;
	P1  =R1 ;
	[FP +16] =R2 ;
	R1  =R2 ;
	P2  =R0 ;
	R0  = B [P2 ++] (X);
	R2  = 92 (X);
	cc =R0 ==R2 ;
	R0  =CC ;
	R2  =R0 ;
	R0  = 0 (X);
	cc =P2 <P1  (iu);
	if !cc P2  =R0 ; /* movsicc-2b */
	P1  = 0 (X);
	R0  = 8192 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$947;
	P0  =R3 ;
	R0  = B [P0 ] (X);
	jump.s L$L$951;
L$L$947:
	R0  = R2.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$948;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$948;
	R0  = B [P2 ] (X);
L$L$951:
	R6  = 41 (X);
	cc =R0 ==R6 ;
	if !cc jump 6; jump.l L$L$946;
L$L$948:
	R0  = -32768 (Z);
	R1  =R1 &R0 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$949;
	P0  =R3 ;
	R3  = B [P0 ] (X);
	R0  = 124 (X);
	cc =R3 ==R0 ;
	jump.s L$L$952;
L$L$949:
	R0  = R2.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$945;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$945;
	R2  = B [P2 ] (X);
	P2  =R2 ;
	P0  = 124 (X);
	cc =P2 ==P0 ;
L$L$952:
	if cc jump 6; jump.l L$L$945;
L$L$946:
	P1  = 1 (X);
L$L$945:
	R0  =P1 ;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_compile_range, STT_FUNC;
_byte_compile_range:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	R4  =R0 ;
	P0  =R1 ;
	[FP +16] =R2 ;
	R0  =R2 ;
	P1  =[FP +20];
	R2  =[FP +24];
	R1  =[FP +28];
	P2  =[P0 ];
	R6  = 11 (X);
	R3  =P2 ;
	cc =R3 ==R0 ;
	if !cc jump 6; jump.l L$L$953;
	R0  =P2 ;
	R0 +=1;
	[P0 ] =R0 ;
	R0  = 1 (X); R0  <<= 16; // zeros
	R2  =R2 &R0 ;
	R0  = 0 (X);
	cc =R2 ==0;
	if cc R6  =R0 ; /* movsicc-2a */
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$959;
	R4  = R4.B  (Z);
	R0  =P1 ;
	R4 =R0 +R4 ;
	P0  =R4 ;
	R4  = B [P0 ] (X);
	R0  = B [P2 ] (Z);
	P2  =R0 ;
	P2 =P1 +P2 ;
	R3  = B [P2 ] (Z);
	P2  =R3 ;
	jump.s L$L$960;
L$L$959:
	R0  = B [P2 ] (Z);
	P2  =R0 ;
L$L$960:
	R3  =P2 ;
	cc =R4 <=R3  (iu);
	if cc jump 6; jump.l L$L$953;
	P0  = 1 (X);
L$L$977:
	R2  = R4.B  (Z);
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$981;
	R2  = R4.B  (Z);
	R0  =P1 ;
	R2 =R0 +R2 ;
	P5  =R2 ;
	R2  = B [P5 ] (Z);
L$L$981:
	R2  >>>=3;
	R2 =R1 +R2 ;
	R6  = R4.B  (Z);
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$982;
	R6  = R4.B  (Z);
	R0  =P1 ;
	R6 =R0 +R6 ;
	P5  =R6 ;
	R6  = B [P5 ] (Z);
L$L$982:
	R6  >>>=3;
	R6 =R1 +R6 ;
	P5  =R6 ;
	R6  = B [P5 ] (Z);
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$973;
	R5  = R4.B  (Z);
	R0  =P1 ;
	R5 =R0 +R5 ;
	P5  =R5 ;
	R5  = B [P5 ] (Z);
	R0  =R5 ;
	R0  >>=3;
	R0  <<=3;
	R5  =R5 -R0 ;
	R0  =P0 ;
	R0  <<=R5 ;
	R5  =R0 ;
	jump.s L$L$983;
L$L$973:
	R5  = R4.B  (Z);
	R0  =R5 ;
	R0  >>=3;
	R0  <<=3;
	R5  =R5 -R0 ;
	R3  =P0 ;
	R3  <<=R5 ;
	R5  =R3 ;
L$L$983:
	R3  =R6 |R5 ;
	P5  =R2 ;
	B [P5 ] =R3 ;
	R6  = 0 (X);
	R4 +=1;
	R0  =P2 ;
	cc =R4 <=R0  (iu);
	if !cc jump 6; jump.l L$L$977;
L$L$953:
	R0  =R6 ;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_re_compile_fastmap, STT_FUNC;
_byte_re_compile_fastmap:
	LINK 28;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	R4  =SP ;
	P4  =[P3 +16];
	P5  =[P3 ];
	R5  =[P3 +8];
	R0  =P5 ;
	R5 =R0 +R5 ;
	R6  = 1 (X);
	R0  = 0 (X);
	B [FP +-13] =R0 ;
	SP +=-20;
	P2  = 12 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-12] =P2 ;
	R0  = -2 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$984;
	R1  = 5 (X);
	[FP +-8] =R1 ;
	P1  = 0 (X);
	[FP +-4] =P1 ;
	R1  = 256 (X);
	R0  =P4 ;
	call _bzero;
	R0  = B [P3 +28] (X);
	BITSET (R0 ,3);
	BITCLR (R0 ,0);
	B [P3 +28] =R0 ;
L$L$1107:
	R0  =P5 ;
	cc =R0 ==R5 ;
	if !cc jump 6; jump.l L$L$991;
	R0  = B [P5 ] (Z);
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$990;
L$L$991:
	R3  =[FP +-4];
	cc =R3 ==0;
	if !cc jump 6; jump.l L$L$988;
	R1  = B [P3 +28] (Z);
	R0  = 1 (X);
	R1  =R1 &R0 ;
	R2  = R6.B  (X);
	R1  =R1 |R2 ;
	R0  =R1 &R0 ;
	R1  = B [P3 +28] (X);
	BITCLR (R1 ,0);
	R0  =R1 |R0 ;
	B [P3 +28] =R0 ;
	R6  = 1 (X);
	R3 +=-1;
	[FP +-4] =R3 ;
	P5  =[FP +-12];
	P1  =R3 ;
	P5  =P5 +(P1 <<2);
	P5  =[P5 ];
	jump.s L$L$1107;
L$L$990:
	R0  = B [P5 ++] (Z);
	P2  = 29 (X);
	P1  =R0 ;
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$1092;
P2.L =L$L$1093;
P2.H =L$L$1093;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$1093:
	.dd		L$L$1107;
	.dd		L$L$1092;
	.dd		L$L$997;
	.dd		L$L$1035;
	.dd		L$L$998;
	.dd		L$L$1007;
	.dd		L$L$1091;
	.dd		L$L$1091;
	.dd		L$L$995;
	.dd		L$L$1107;
	.dd		L$L$1107;
	.dd		L$L$1107;
	.dd		L$L$1107;
	.dd		L$L$1059;
	.dd		L$L$1059;
	.dd		L$L$1069;
	.dd		L$L$1069;
	.dd		L$L$1059;
	.dd		L$L$1059;
	.dd		L$L$1059;
	.dd		L$L$1107;
	.dd		L$L$1085;
	.dd		L$L$1059;
	.dd		L$L$1089;
	.dd		L$L$1021;
	.dd		L$L$1028;
	.dd		L$L$1107;
	.dd		L$L$1107;
	.dd		L$L$1107;
	.dd		L$L$1107;
L$L$995:
	R0  = B [P3 +28] (X);
	BITSET (R0 ,0);
	B [P3 +28] =R0 ;
	jump.s L$L$996;
L$L$997:
	R0  = B [P5 +1] (Z);
	P5  =R0 ;
	P5 =P4 +P5 ;
	R1  = 1 (X);
	B [P5 ] =R1 ;
	jump.s L$L$994;
L$L$998:
	R2  = B [P5 ++] (Z);
	R2  <<=3;
	R2 +=-1;
	cc =R2 <0;
	if !cc jump 6; jump.l L$L$994;
	R3  = 1 (X);
L$L$1006:
	P2  =R2 ;
	P2 +=7;
	cc =R2 <=-1;
	if !cc P2  =R2 ; /* movsicc-2b */
	R0  =P2 ;
	R0  >>>=3;
	P2  =R0 ;
	P2 =P5 +P2 ;
	R1  = B [P2 ] (Z);
	R0  = 7 (X);
	R0 =R0 +R2 ; //immed->Dreg 
	cc =R2 <=-1;
	if !cc R0  =R2 ; /* movsicc-2b */
	R0  >>>=3;
	R0  <<=3;
	R0  =R2 -R0 ;
	R1  >>>=R0 ;
	R1  =R1 &R3 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1001;
	P1  =R2 ;
	P2 =P4 +P1 ;
	R0  = 1 (X);
	B [P2 ] =R0 ;
L$L$1001:
	R2 +=-1;
	cc =R2 <0;
	if cc jump 6; jump.l L$L$1006;
	jump.s L$L$994;
L$L$1007:
	R0  = B [P5 ] (Z);
	R0  <<=3;
	R1  = 255 (X);
	cc =R0 <=R1 ;
	if cc jump 6; jump.l L$L$1098;
L$L$1012:
	P1  =R0 ;
	P2 =P4 +P1 ;
	R1  = 1 (X);
	B [P2 ] =R1 ;
	R0 +=1;
	R1  = 255 (X);
	cc =R0 <=R1 ;
	if !cc jump 6; jump.l L$L$1012;
L$L$1098:
	R2  = B [P5 ++] (Z);
	R2  <<=3;
	R2 +=-1;
	cc =R2 <0;
	if !cc jump 6; jump.l L$L$994;
	R3  = 1 (X);
L$L$1020:
	P2  =R2 ;
	P2 +=7;
	cc =R2 <=-1;
	if !cc P2  =R2 ; /* movsicc-2b */
	R0  =P2 ;
	R0  >>>=3;
	P2  =R0 ;
	P2 =P5 +P2 ;
	R1  = B [P2 ] (Z);
	R0  = 7 (X);
	R0 =R0 +R2 ; //immed->Dreg 
	cc =R2 <=-1;
	if !cc R0  =R2 ; /* movsicc-2b */
	R0  >>>=3;
	R0  <<=3;
	R0  =R2 -R0 ;
	R1  >>>=R0 ;
	R1  =R1 &R3 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1015;
	P1  =R2 ;
	P2 =P4 +P1 ;
	R0  = 1 (X);
	B [P2 ] =R0 ;
L$L$1015:
	R2 +=-1;
	cc =R2 <0;
	if cc jump 6; jump.l L$L$1020;
	jump.s L$L$994;
L$L$1021:
	R2  = 0 (X);
	R1  = 255 (X);
	cc =R2 <=R1 ;
	if cc jump 6; jump.l L$L$994;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
L$L$1027:
	R0  = R2.B  (Z);
	R0 =R0 +R1 ;
	P1  =R0 ;
	R0  = B [P1 ] (X);
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$1024;
	P1  =R2 ;
	P2 =P4 +P1 ;
	R0  = 1 (X);
	B [P2 ] =R0 ;
L$L$1024:
	R2 +=1;
	R0  = 255 (X);
	cc =R2 <=R0 ;
	if !cc jump 6; jump.l L$L$1027;
	jump.s L$L$994;
L$L$1028:
	R2  = 0 (X);
	R1  = 255 (X);
	cc =R2 <=R1 ;
	if cc jump 6; jump.l L$L$994;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
L$L$1034:
	R0  = R2.B  (Z);
	R0 =R0 +R1 ;
	P1  =R0 ;
	R0  = B [P1 ] (X);
	cc =R0 ==1;
	if !cc jump 6; jump.l L$L$1031;
	P1  =R2 ;
	P2 =P4 +P1 ;
	R0  = 1 (X);
	B [P2 ] =R0 ;
L$L$1031:
	R2 +=1;
	R0  = 255 (X);
	cc =R2 <=R0 ;
	if !cc jump 6; jump.l L$L$1034;
	jump.s L$L$994;
L$L$1035:
	R2  = B [P4 +10] (X);
	R0  = 0 (X);
	R1  = 255 (X);
	cc =R0 <=R1 ;
	if cc jump 6; jump.l L$L$1106;
L$L$1040:
	P1  =R0 ;
	P2 =P4 +P1 ;
	R1  = 1 (X);
	B [P2 ] =R1 ;
	R0 +=1;
	R1  = 255 (X);
	cc =R0 <=R1 ;
	if !cc jump 6; jump.l L$L$1040;
L$L$1106:
	R1  =[P3 +12];
	R0  = 64 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1041;
	B [P4 +10] =R2 ;
	jump.s L$L$994;
L$L$1041:
	R1  = B [P3 +28] (Z);
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$996;
	jump.s L$L$994;
L$L$1059:
	R2  = B [P5 ] (Z);
	R0  = B [P5 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	P5 +=2;
	P1  =R2 ;
	P5 =P5 +P1 ;
	cc =R2 <=0;
	if cc jump 6; jump.l L$L$1107;
	R0  = B [P5 ] (Z);
	R1  = 15 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1063;
	R1  = 21 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1107;
L$L$1063:
	P5 +=1;
	R2  = B [P5 ] (Z);
	R0  = B [P5 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	P5 +=2;
	P1  =R2 ;
	P5 =P5 +P1 ;
	P1  =[FP +-4];
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$1107;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	P2  =[P2 +-4];
	cc =P2 ==P5 ;
	if cc jump 6; jump.l L$L$1107;
	P1 +=-1;
	[FP +-4] =P1 ;
	jump.s L$L$1107;
L$L$1069:
	R2  = B [P5 ] (Z);
	R0  = B [P5 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	[FP +-20] =R2 ;
	P5 +=2;
	R0  =P5 ;
	R2 =R0 +R2 ;
	cc =R2 <R5  (iu);
	if cc jump 6; jump.l L$L$1072;
	R2  =[FP +-4];
	R0  =[FP +-8];
	cc =R2 ==R0 ;
	if cc jump 6; jump.l L$L$1076;
	P1.L  = _xre_max_failures; P1.H  = _xre_max_failures;
	P1  =[P1 ];
	P2  =P1 +(P1 <<2);
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =P1 ;
	R1  =R1 -R0 ;
	cc =R2 <=R1  (iu);
	if cc jump 6; jump.l L$L$1075;
	R0  =R2 ;
	R0  <<=3;
	R1  =SP ;
	R1  =R1 -R0 ;
	SP  =R1 ;
	P2  = 12 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-24] =P2 ;
	P1  =R2 ;
	P1  =P1 <<2;
	R2  =P1 ;
	R0  =[FP +-12];
	R1  =P2 ;
	call _bcopy;
	P2  =[FP +-24];
	[FP +-12] =P2 ;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1075;
	P2  =[FP +-8];
	P2  =P2 +P2 ;
	[FP +-8] =P2 ;
L$L$1076:
	P1  = -4 (X);
	P1 =P1 +FP ; //immed->Preg 
	P0  =[P1 ];
	P2  =[FP +-12];
	P2  =P2 +(P0 <<2);
	R0  =[FP +-20];
	R1  =P5 ;
	R0 =R1 +R0 ;
	[P2 ] =R0 ;
	P0 +=1;
	[P1 ] =P0 ;
	jump.s L$L$1081;
L$L$1075:
	R0  = -2 (X);
	jump.s L$L$984;
L$L$1072:
	R0  = B [P3 +28] (X);
	BITSET (R0 ,0);
	B [P3 +28] =R0 ;
L$L$1081:
	R0  = B [FP +-13] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1107;
	P5 +=2;
	R0  = 0 (X);
	B [FP +-13] =R0 ;
	jump.s L$L$1107;
L$L$1085:
	P5 +=2;
	R1  = B [P5 ] (Z);
	R0  = B [P5 +1] (X);
	R0  <<=8;
	R1 =R1 +R0 ;
	P5 +=2;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1107;
	P5 +=-4;
	R0  = 1 (X);
	B [FP +-13] =R0 ;
	jump.s L$L$1069;
L$L$1089:
	P5 +=4;
	jump.s L$L$1107;
L$L$1091:
	P5 +=2;
	jump.s L$L$1107;
L$L$1092:
	call _abort;
L$L$994:
	R6  = 0 (X);
	P5  =R5 ;
	jump.s L$L$1107;
L$L$988:
	R2  = B [P3 +28] (Z);
	R1  = 1 (X);
	R2  =R2 &R1 ;
	R0  = R6.B  (X);
	R2  =R2 |R0 ;
	R1  =R2 &R1 ;
	R0  = B [P3 +28] (X);
	BITCLR (R0 ,0);
	R1  =R0 |R1 ;
	B [P3 +28] =R1 ;
L$L$996:
	R0  = 0 (X);
L$L$984:
	SP  =R4 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_re_search_2, STT_FUNC;
_byte_re_search_2:
	LINK 32;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	[FP +-4] =R1 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	R0  =[FP +20];
	[FP +-8] =R0 ;
	R6  =[FP +24];
	[FP +-12] =R6 ;
	P5  =[FP +28];
	R4  =[FP +32];
	R0  =[FP +36];
	[FP +-16] =R0 ;
	R0  =[FP +40];
	[FP +-20] =R0 ;
	R5  =[P3 +16];
	R0  =[P3 +20];
	[FP +-24] =R0 ;
	R6 =R2 +R6 ;
	R2  =P5 ;
	R0 =R2 +R4 ;
	cc =P5 <0;
	if !cc jump 6; jump.l L$L$1110;
	cc =R2 <=R6 ;
	if !cc jump 6; jump.l L$L$1109;
L$L$1110:
	R1  = -1 (X);
	jump.s L$L$1108;
L$L$1109:
	cc =R0 <0;
	if cc jump 6; jump.l L$L$1111;
	R4  =-R2 ;
	jump.s L$L$1112;
L$L$1111:
	R2  =P5 ;
	R1  =R6 -R2 ;
	cc =R0 <=R6 ;
	if !cc R4  =R1 ; /* movsicc-1a */
L$L$1112:
	R0  =[P3 +8];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1114;
	cc =R4 <=0;
	if !cc jump 6; jump.l L$L$1114;
	R0  =[P3 ];
	P1  =R0 ;
	R0  = B [P1 ] (Z);
	R1  = 11 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1115;
	R2  = 9 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1114;
	R0  = B [P3 +28] (Z);
	R0  >>=7;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1114;
L$L$1115:
	R1  = -1 (X);
	cc =P5 <=0;
	if cc jump 6; jump.l L$L$1108;
	R4  = 1 (X);
L$L$1114:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1161;
	R1  = B [P3 +28] (Z);
	R1  >>=3;
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1161;
	R0  =P3 ;
	call _xre_compile_fastmap;
	R1  = -2 (X);
	cc =R0 ==-2;
	if !cc jump 6; jump.l L$L$1108;
L$L$1161:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1123;
	R0  =P5 ;
	cc =R0 <R6 ;
	if cc jump 6; jump.l L$L$1123;
	R1  = B [P3 +28] (Z);
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1123;
	cc =R4 <=0;
	if !cc jump 6; jump.l L$L$1124;
	R3  = 0 (X);
	[FP +-32] =R4 ;
	cc =P5 <P4 ;
	if cc jump 6; jump.l L$L$1155;
	R2  =P5 ;
	R1 =R2 +R4 ;
	R0  =P4 ;
	cc =R1 <R0 ;
	if !cc jump 6; jump.l L$L$1125;
	R3  =R0 -R2 ;
	R3  =R4 -R3 ;
L$L$1125:
	R2  =[FP +-4];
	R1  =P5 ;
	R2 =R2 +R1 ;
	cc =P5 <P4 ;
	if !cc jump 6; jump.l L$L$1127;
L$L$1155:
	R2  =[FP +-8];
	R0  =P4 ;
	R2  =R2 -R0 ;
	R1  =P5 ;
	R2 =R2 +R1 ;
L$L$1127:
	P2  =[FP +-24];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1128;
	cc =R4 <=R3 ;
	if !cc jump 6; jump.l L$L$1134;
	P1  =R2 ;
	R2 +=1;
	R1  = B [P1 ++] (Z);
	R0  =P2 ;
	R1 =R0 +R1 ;
	P1  =R1 ;
	R1  = B [P1 ] (Z);
	R1 =R5 +R1 ;
	P2  =R1 ;
	R1  = B [P2 ] (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1134;
L$L$1133:
	R4 +=-1;
	cc =R4 <=R3 ;
	if !cc jump 6; jump.l L$L$1134;
	P1  =R2 ;
	R2 +=1;
	R1  = B [P1 ++] (Z);
	P2  =[FP +-24];
	R0  =P2 ;
	R1 =R0 +R1 ;
	P1  =R1 ;
	R1  = B [P1 ] (Z);
	R1 =R5 +R1 ;
	P2  =R1 ;
	R1  = B [P2 ] (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1133;
	jump.s L$L$1134;
L$L$1128:
	cc =R4 <=R3 ;
	if !cc jump 6; jump.l L$L$1134;
	P1  =R2 ;
	R2 +=1;
	R1  = B [P1 ++] (Z);
	R1 =R5 +R1 ;
	P2  =R1 ;
	R1  = B [P2 ] (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1134;
L$L$1139:
	R4 +=-1;
	cc =R4 <=R3 ;
	if !cc jump 6; jump.l L$L$1134;
	P1  =R2 ;
	R2 +=1;
	R1  = B [P1 ++] (Z);
	R1 =R5 +R1 ;
	P2  =R1 ;
	R1  = B [P2 ] (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1139;
L$L$1134:
	R0  =[FP +-32];
	R0  =R0 -R4 ;
	P1  =R0 ;
	P5 =P5 +P1 ;
	jump.s L$L$1123;
L$L$1124:
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$1143;
	cc =P5 <P4 ;
	if !cc jump 6; jump.l L$L$1141;
L$L$1143:
	R1  =P5 ;
	R2  =P4 ;
	R0  =R1 -R2 ;
	R1  =[FP +-8];
	R0 =R1 +R0 ;
	P1  =R0 ;
	R1  = B [P1 ] (X);
	jump.s L$L$1142;
L$L$1141:
	P2  =[FP +-4];
	P2 =P2 +P5 ;
	R1  = B [P2 ] (X);
L$L$1142:
	R0  =[FP +-24];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1145;
	R1  = R1.B  (Z);
	R0 =R0 +R1 ;
	P2  =R0 ;
	R0  = B [P2 ] (Z);
	jump.s L$L$1162;
L$L$1145:
	R0  = R1.B  (Z);
L$L$1162:
	R0 =R5 +R0 ;
	P1  =R0 ;
	R0  = B [P1 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1147;
L$L$1123:
	cc =R4 <0;
	if !cc jump 6; jump.l L$L$1148;
	R0  =P5 ;
	cc =R0 ==R6 ;
	if cc jump 6; jump.l L$L$1148;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1148;
	R1  = B [P3 +28] (Z);
	R0  = 1 (X);
	R0  =R1 &R0 ;
	R1  = -1 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1108;
L$L$1148:
	R0  =[FP +-8];
	[SP +12] =R0 ;
	R0  =[FP +-12];
	[SP +16] =R0 ;
	[SP +20] =P5 ;
	R0  =[FP +-16];
	[SP +24] =R0 ;
	R0  =[FP +-20];
	[SP +28] =R0 ;
	R2  =P4 ;
	R0  =P3 ;
	R1  =[FP +-4];
	call _byte_re_match_2_internal;
	R1  =P5 ;
	cc =R0 <0;
	if cc jump 6; jump.l L$L$1108;
	R1  = -2 (X);
	cc =R0 ==-2;
	if !cc jump 6; jump.l L$L$1108;
L$L$1147:
	R1  = -1 (X);
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$1108;
	cc =R4 <=0;
	if !cc jump 6; jump.l L$L$1153;
	R4 +=-1;
	P5 +=1;
	jump.s L$L$1161;
L$L$1153:
	R4 +=1;
	P5 +=-1;
	jump.s L$L$1161;
L$L$1108:
	R0  =R1 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_re_match_2_internal, STT_FUNC;
_byte_re_match_2_internal:
	LINK 212;
	[--sp] = ( r7:4, p5:3 );
	[FP +-20] =R0 ;
	[FP +-24] =R1 ;
	[FP +16] =R2 ;
	[FP +-28] =R2 ;
	R0  =[FP +20];
	[FP +-32] =R0 ;
	R0  =[FP +24];
	[FP +-36] =R0 ;
	R0  =[FP +28];
	[FP +-40] =R0 ;
	P2  =[FP +32];
	[FP +-44] =P2 ;
	[FP +-48] =SP ;
	P2  =[FP +-20];
	P0  =[P2 ];
	[FP +-196] =P0 ;
	P2  =[P2 +8];
	P2 =P0 +P2 ;
	[FP +-52] =P2 ;
	R0  = 0 (X);
	[FP +-56] =R0 ;
	P2  =[FP +-20];
	R0  =[P2 +20];
	[FP +-60] =R0 ;
	P2  =[P2 +24];
	P2 +=1;
	[FP +-64] =P2 ;
	P5  = 257 (X);
	R0  = 256 (X);
	[FP +-68] =R0 ;
	P2  = 0 (X);
	[FP +-72] =P2 ;
	R0  = 0 (X);
	[FP +-76] =R0 ;
	[FP +-80] =R0 ;
	SP +=-20;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-12] =P2 ;
	R1  = -2 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1163;
	P1  = 5 (X);
	[FP +-8] =P1 ;
	[FP +-4] =R0 ;
	R0  =[FP +-20];
	P2  =R0 ;
	R0  =[P2 +24];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1166;
	R0  =[FP +-64];
	P3  =R0 ;
	P3  =P3 <<2;
	R0  =P3 ;
	R1  =SP ;
	R1  =R1 -R0 ;
	SP  =R1 ;
	R5  =SP ;
	R5 +=16;
	R1  =R1 -R0 ;
	SP  =R1 ;
	R6  =SP ;
	R6 +=16;
	R1  =R1 -R0 ;
	SP  =R1 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-84] =P2 ;
	R1  =R1 -R0 ;
	SP  =R1 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-88] =P2 ;
	R1  =R1 -R0 ;
	SP  =R1 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-92] =P2 ;
	R1  =R1 -R0 ;
	SP  =R1 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-96] =P2 ;
	R1  =R1 -R0 ;
	SP  =R1 ;
	R4  =SP ;
	R4 +=16;
	R1  =R1 -R0 ;
	SP  =R1 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-100] =P2 ;
	R1  =R1 -R0 ;
	SP  =R1 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-104] =P2 ;
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1621;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$1621;
	P2  =[FP +-84];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1621;
	P2  =[FP +-88];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1621;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$1621;
	P2  =[FP +-92];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1621;
	P2  =[FP +-96];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1621;
	P2  =[FP +-100];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1621;
	P2  =[FP +-104];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1179;
	jump.l L$L$1621;
L$L$1166:
	P2  = 0 (X);
	[FP +-100] =P2 ;
	[FP +-96] =P2 ;
	[FP +-92] =P2 ;
	[FP +-88] =P2 ;
	[FP +-84] =P2 ;
	R6  = 0 (X);
	R5  = 0 (X);
	[FP +-104] =P2 ;
	R4  = 0 (X);
L$L$1179:
	R0  =[FP +-40];
	cc =R0 <0;
	if !cc jump 6; jump.l L$L$1877;
	R0  =[FP +-36];
	R1  =[FP +-28];
	R0 =R1 +R0 ;
	R1  =[FP +-40];
	cc =R1 <=R0 ;
	if cc jump 6; jump.l L$L$1877;
	R2  = 1 (X);
	P2  =[FP +-64];
	R3  =P2 ;
	cc =R2 <R3  (iu);
	if cc jump 6; jump.l L$L$1783;
	R1.L  = _byte_reg_unset_dummy; R1.H  = _byte_reg_unset_dummy;
L$L$1196:
	P0  =R2 ;
	P1  =P0 <<2;
	P3  =R5 ;
	P2 =P1 +P3 ;
	R0  =P2 ;
	P4  =R6 ;
	P3 =P1 +P4 ;
	P0  =[FP +-84];
	P0 =P1 +P0 ;
	P2  =[FP +-88];
	P2 =P1 +P2 ;
	[P2 ] =R1 ;
	[P0 ] =R1 ;
	[P3 ] =R1 ;
	P2  =R0 ;
	[P2 ] =R1 ;
	P0  =R4 ;
	P1 =P1 +P0 ;
	R0  = 3 (X);
	R3  = B [P1 ] (X);
	R0  =R0 |R3 ;
	P2  = -29 (X);
	R3  =P2 ;
	R3  =R0 &R3 ;
	B [P1 ] =R3 ;
	R2 +=1;
	P2  =[FP +-64];
	R0  =P2 ;
	cc =R2 <R0  (iu);
	if !cc jump 6; jump.l L$L$1196;
L$L$1783:
	R0  =[FP +-36];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1197;
	R0  =[FP +-24];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1197;
	[FP +-32] =R0 ;
	R0  =[FP +-28];
	[FP +-36] =R0 ;
	R0  = 0 (X);
	[FP +-24] =R0 ;
	[FP +-28] =R0 ;
L$L$1197:
	P2  =[FP +-28];
	R0  =[FP +-24];
	P0  =R0 ;
	P2 =P0 +P2 ;
	[FP +-108] =P2 ;
	R1  =[FP +-36];
	R0  =[FP +-32];
	R1 =R0 +R1 ;
	[FP +-112] =R1 ;
	R0  =[FP +-28];
	R1  =[FP +36];
	cc =R1 <=R0 ;
	if cc jump 6; jump.l L$L$1198;
	R0  =P0 ;
	R1 =R0 +R1 ;
	[FP +-116] =R1 ;
	R0  =[FP +-32];
	[FP +-120] =R0 ;
	jump.s L$L$1199;
L$L$1198:
	R0  =[FP +-108];
	[FP +-116] =R0 ;
	R0  =[FP +-32];
	R2  =[FP +36];
	R2 =R0 +R2 ;
	R0  =[FP +-28];
	R2  =R2 -R0 ;
	[FP +-120] =R2 ;
L$L$1199:
	R0  =[FP +-28];
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$1200;
	R2  =[FP +-40];
	cc =R2 <=R0 ;
	if cc jump 6; jump.l L$L$1200;
	R0  =[FP +-24];
	R2 =R0 +R2 ;
	[FP +-180] =R2 ;
	jump.l L$L$1878;
L$L$1200:
	R1  =[FP +-40];
	R2  =[FP +-32];
	R1 =R2 +R1 ;
	R0  =[FP +-28];
	R1  =R1 -R0 ;
	[FP +-180] =R1 ;
	R0  =[FP +-120];
L$L$1852:
	[FP +-124] =R0 ;
L$L$1846:
	P2  =[FP +-52];
	P0  =[FP +-196];
	cc =P0 ==P2 ;
	if cc jump 6; jump.l L$L$1205;
	R1  =[FP +-120];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1232;
	R2  = 0 (X);
	R3  =[FP +-28];
	cc =R3 ==0;
	if !cc jump 6; jump.l L$L$1208;
	R1  =[FP +-76];
	R0  =[FP +-24];
	cc =R0 <=R1  (iu);
	if cc jump 6; jump.l L$L$1208;
	R3 =R0 +R3 ;
	cc =R1 <=R3  (iu);
	if !cc jump 6; jump.l L$L$1207;
L$L$1208:
	R2  = 1 (X);
L$L$1207:
	R1  =[FP +-124];
	R0  =[FP +-116];
	cc =R1 ==R0 ;
	R1  =CC ;
	R0  =R1 ^R2 ;
	B [FP +-125] =R0 ;
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1209;
	R0  = 0 (X);
	B [FP +-126] =R0 ;
	R1  =[FP +-76];
	R0  =[FP +-180];
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$1211;
	R0  = 1 (X);
	jump.s L$L$1856;
L$L$1209:
	R0  =[FP +-124];
	R1  =[FP +-116];
	R1  =R0 ^R1 ;
	R1  =abs R1 ;
	R1  =-R1 ;
	R0  =R1 ;
	R0  >>=31;
L$L$1856:
	B [FP +-126] =R0 ;
L$L$1211:
	R0  =[FP +-4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1213;
	P2  =[FP +-72];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1215;
	R0  = B [FP +-126] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1849;
L$L$1215:
	P1  = 1 (X);
	[FP +-72] =P1 ;
	R0  =[FP +-180];
	[FP +-76] =R0 ;
	R0  = 1 (X);
	P2  =[FP +-64];
	cc =P1 <P2  (iu);
	if cc jump 6; jump.l L$L$1849;
L$L$1220:
	P1  =R0 ;
	P0  =P1 <<2;
	P1  =[FP +-92];
	P1 =P0 +P1 ;
	P3  =R5 ;
	P2 =P0 +P3 ;
	P2  =[P2 ];
	[P1 ] =P2 ;
	P2  =[FP +-96];
	P2 =P0 +P2 ;
	P4  =R6 ;
	P0 =P0 +P4 ;
	P0  =[P0 ];
	[P2 ] =P0 ;
	R0 +=1;
	P2  =[FP +-64];
	R1  =P2 ;
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$1220;
	jump.l L$L$1849;
L$L$1213:
	P2  =[FP +-72];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1232;
	R0  = B [FP +-126] (X);
	R0  = R0.B  (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1232;
L$L$1224:
	R1  =[FP +-76];
	[FP +-180] =R1 ;
	R0  =[FP +-24];
	cc =R1 <R0  (iu);
	if !cc jump 6; jump.l L$L$1225;
	R0  =[FP +-116];
	[FP +-124] =R0 ;
	P2  =[FP +-108];
	R2  =P2 ;
	cc =R1 <=R2  (iu);
	if !cc jump 6; jump.l L$L$1226;
L$L$1225:
	R0  =[FP +-120];
	[FP +-124] =R0 ;
L$L$1226:
	R0  = 1 (X);
	P2  =[FP +-64];
	R3  =P2 ;
	cc =R0 <R3  (iu);
	if cc jump 6; jump.l L$L$1232;
L$L$1231:
	P1  =R0 ;
	P0  =P1 <<2;
	P2  =R5 ;
	P1 =P0 +P2 ;
	P2  =[FP +-92];
	P2 =P0 +P2 ;
	P2  =[P2 ];
	[P1 ] =P2 ;
	P3  =R6 ;
	P1 =P0 +P3 ;
	P2  =[FP +-96];
	P0 =P0 +P2 ;
	P0  =[P0 ];
	[P1 ] =P0 ;
	R0 +=1;
	P2  =[FP +-64];
	R1  =P2 ;
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$1231;
L$L$1232:
	R4  =[FP +-44];
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$1233;
	R2  =[FP +-20];
	P0  =R2 ;
	R2  = B [P0 +28] (Z);
	R0  =R2 ;
	R0  >>=4;
	R1  = 1 (X);
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1233;
	P1  =R2 ;
	P1  =P1 >>1;
	R2  =P1 ;
	R0  = 3 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1234;
	P2  =[FP +-64];
	P2 +=1;
	R0  = 30 (X);
	P3  = 29 (X);
	cc =P2 <=P3  (iu);
	if cc P2  =R0 ; /* movsicc-1b */
	P4  =R4 ;
	[P4 ] =P2 ;
	P2  =P2 <<2;
	R0  =P2 ;
	call _malloc;
	[P4 +4] =R0 ;
	P2  =[P4 ];
	P2  =P2 <<2;
	R0  =P2 ;
	call _malloc;
	[P4 +8] =R0 ;
	R4  =[P4 +4];
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$1621;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1621;
	R0  = -7 (X);
	P2  =[FP +-20];
	R1  = B [P2 +28] (X);
	R0  =R0 &R1 ;
	BITSET (R0 ,1);
	B [P2 +28] =R0 ;
	jump.s L$L$1248;
L$L$1234:
	R2  =[FP +-20];
	P0  =R2 ;
	R2  = B [P0 +28] (Z);
	P1  =R2 ;
	P1  =P1 >>1;
	R2  =P1 ;
	R0  = 3 (X);
	R0  =R2 &R0 ;
	cc =R0 ==1;
	if cc jump 6; jump.l L$L$1248;
	P1  =[FP +-64];
	P1 +=1;
	R4  =[FP +-44];
	P3  =R4 ;
	P2  =[P3 ];
	cc =P2 <P1  (iu);
	if cc jump 6; jump.l L$L$1248;
	[P3 ] =P1 ;
	R0  =[P3 +4];
	P1  =P1 <<2;
	R1  =P1 ;
	call _realloc;
	[P3 +4] =R0 ;
	R0  =[P3 +8];
	P2  =[P3 ];
	P2  =P2 <<2;
	R1  =P2 ;
	call _realloc;
	[P3 +8] =R0 ;
	R4  =[P3 +4];
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$1621;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1621;
L$L$1248:
	P1  =[FP +-44];
	R0  =[P1 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1264;
	P2  =[P1 +4];
	R0  =[FP +-40];
	[P2 ] =R0 ;
	P1  =[P1 +8];
	R2  =[FP +-24];
	R0  =[FP +-180];
	R2  =R0 -R2 ;
	R1  =[FP +-124];
	R0  =[FP +-116];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$1266;
	R2  =[FP +-32];
	R0  =[FP +-180];
	R2  =R0 -R2 ;
	R0  =[FP +-28];
	R2 =R2 +R0 ;
L$L$1266:
	[P1 ] =R2 ;
L$L$1264:
	R2  = 1 (X);
	R1  =[FP +-28];
	R0  =[FP +-24];
	R1 =R0 +R1 ;
	jump.s L$L$1267;
L$L$1279:
	P4  =R2 ;
	P1  =P4 <<2;
	P5  =R5 ;
	P2 =P1 +P5 ;
	P2  =[P2 ];
	P0.L  = _byte_reg_unset_dummy; P0.H  = _byte_reg_unset_dummy;
	cc =P2 ==P0 ;
	if !cc jump 6; jump.l L$L$1273;
	P2  =R6 ;
	P1 =P1 +P2 ;
	P1  =[P1 ];
	cc =P1 ==P0 ;
	if cc jump 6; jump.l L$L$1272;
L$L$1273:
	P0  =[FP +-44];
	P2  =[P0 +4];
	P3  =R2 ;
	P1  =P3 <<2;
	P2 =P1 +P2 ;
	P0  =[P0 +8];
	P1 =P1 +P0 ;
	P4  = -1 (X);
	[P1 ] =P4 ;
	[P2 ] =P4 ;
	jump.s L$L$1269;
L$L$1272:
	P0  =[FP +-44];
	P0  =[P0 +4];
	P1  =P4 <<2;
	P0 =P1 +P0 ;
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1275;
	P2  =R5 ;
	P1 =P1 +P2 ;
	P1  =[P1 ];
	R3  =[FP +-24];
	R0  =P1 ;
	cc =R3 <=R0  (iu);
	if cc jump 6; jump.l L$L$1275;
	R3  =R0 -R3 ;
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$1276;
L$L$1275:
	P1  =R2 ;
	P3  =R5 ;
	P2  =P3 +(P1 <<2);
	P2  =[P2 ];
	R0  =[FP +-32];
	R3  =P2 ;
	R0  =R3 -R0 ;
	R3  =[FP +-28];
	R3 =R0 +R3 ;
L$L$1276:
	[P0 ] =R3 ;
	P1  =[FP +-44];
	P1  =[P1 +8];
	P0  =R2 ;
	P2  =P0 <<2;
	P1 =P2 +P1 ;
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1277;
	P3  =R6 ;
	P2 =P2 +P3 ;
	P2  =[P2 ];
	R3  =[FP +-24];
	R0  =P2 ;
	cc =R3 <=R0  (iu);
	if cc jump 6; jump.l L$L$1277;
	R3  =R0 -R3 ;
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$1278;
L$L$1277:
	P0  =R2 ;
	P3  =R6 ;
	P2  =P3 +(P0 <<2);
	P2  =[P2 ];
	R3  =[FP +-32];
	R0  =P2 ;
	R3  =R0 -R3 ;
	R0  =[FP +-28];
	R3 =R3 +R0 ;
L$L$1278:
	[P1 ] =R3 ;
L$L$1269:
	R2 +=1;
L$L$1267:
	R0  =[FP +-44];
	P0  =R0 ;
	P2  =[P0 ];
	R4  =[FP +-64];
	R3  =P2 ;
	cc =R3 <=R4  (iu);
	if !cc P2  =R4 ; /* movsicc-2b */
	R3  =P2 ;
	cc =R2 <R3  (iu);
	if !cc jump 6; jump.l L$L$1279;
	R0  =[P0 ];
	cc =R4 <R0  (iu);
	if cc jump 6; jump.l L$L$1233;
L$L$1284:
	R0  =[FP +-44];
	P1  =R0 ;
	P0  =[P1 +4];
	P2  =R4 ;
	P1  =P2 <<2;
	P0 =P1 +P0 ;
	P3  =R0 ;
	P2  =[P3 +8];
	P1 =P1 +P2 ;
	P4  = -1 (X);
	[P1 ] =P4 ;
	[P0 ] =P4 ;
	R4 +=1;
	R0  =[P3 ];
	cc =R4 <R0  (iu);
	if !cc jump 6; jump.l L$L$1284;
L$L$1233:
	R3  =[FP +-40];
	R0  =[FP +-180];
	R3  =R0 -R3 ;
	R1  =[FP +-24];
	R1  =R3 -R1 ;
	R2  =[FP +-124];
	R0  =[FP +-116];
	cc =R2 ==R0 ;
	if !cc jump 6; jump.l L$L$1163;
	R0  =[FP +-32];
	R1  =[FP +-28];
	R1  =R0 -R1 ;
	R1  =R3 -R1 ;
	jump.l L$L$1163;
L$L$1205:
	P0  =[FP +-196];
	R0  = B [P0 ++] (Z);
	[FP +-196] =P0 ;
	P2  = 29 (X);
	P1  =R0 ;
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$1739;
P2.L =L$L$1740;
P2.H =L$L$1740;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$1740:
	.dd		L$L$1846;
	.dd		L$L$1232;
	.dd		L$L$1300;
	.dd		L$L$1330;
	.dd		L$L$1351;
	.dd		L$L$1351;
	.dd		L$L$1368;
	.dd		L$L$1375;
	.dd		L$L$1428;
	.dd		L$L$1462;
	.dd		L$L$1470;
	.dd		L$L$1477;
	.dd		L$L$1482;
	.dd		L$L$1593;
	.dd		L$L$1593;
	.dd		L$L$1504;
	.dd		L$L$1484;
	.dd		L$L$1579;
	.dd		L$L$1530;
	.dd		L$L$1597;
	.dd		L$L$1614;
	.dd		L$L$1631;
	.dd		L$L$1638;
	.dd		L$L$1643;
	.dd		L$L$1703;
	.dd		L$L$1721;
	.dd		L$L$1677;
	.dd		L$L$1690;
	.dd		L$L$1649;
	.dd		L$L$1663;
L$L$1300:
	P2  =[FP +-196];
	R2  = B [P2 ++] (Z);
	[FP +-196] =P2 ;
	R0  =[FP +-60];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1313;
L$L$1302:
	R1  =[FP +-124];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1789;
L$L$1309:
	R0  =[FP +-124];
	R1  =[FP +-120];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-32];
	[FP +-180] =R0 ;
	[FP +-124] =R1 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1309;
L$L$1789:
	R0  =[FP +-180];
	P3  =R0 ;
	R0 +=1;
	R1  = B [P3 ++] (Z);
	[FP +-180] =R0 ;
	R0  =[FP +-60];
	R1 =R0 +R1 ;
	P4  =R1 ;
	R1  = B [P4 ] (Z);
	P0  =[FP +-196];
	R0  = B [P0 ++] (Z);
	[FP +-196] =P0 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$1849;
	R2 +=-1;
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$1302;
	jump.s L$L$1312;
L$L$1313:
	R1  =[FP +-124];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1791;
L$L$1320:
	R0  =[FP +-124];
	R1  =[FP +-120];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-32];
	[FP +-180] =R0 ;
	[FP +-124] =R1 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1320;
L$L$1791:
	R0  =[FP +-180];
	P1  =R0 ;
	R0 +=1;
	R1  = B [P1 ++] (X);
	[FP +-180] =R0 ;
	P2  =[FP +-196];
	R0  = B [P2 ++] (X);
	[FP +-196] =P2 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$1849;
	R2 +=-1;
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$1313;
L$L$1312:
	R0  =[FP +-80];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1846;
	R0  = 1 (X);
	[FP +-80] =R0 ;
	P2  =P5 ;
	R0  =[FP +-68];
	R1  =P5 ;
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1846;
L$L$1329:
	P0  =R4 ;
	P1  =P0 +(P2 <<2);
	R0  = B [P1 ] (X);
	BITSET (R0 ,4);
	BITSET (R0 ,3);
	B [P1 ] =R0 ;
	P2 +=1;
	R0  =[FP +-68];
	R1  =P2 ;
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1329;
	jump.s L$L$1846;
L$L$1330:
	R1  =[FP +-124];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1795;
L$L$1335:
	R0  =[FP +-124];
	R1  =[FP +-120];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-32];
	[FP +-180] =R0 ;
	[FP +-124] =R1 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1335;
L$L$1795:
	R1  =[FP +-20];
	P0  =R1 ;
	R1  =[P0 +12];
	R0  = 64 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1338;
	R0  =[FP +-60];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1339;
	R1  =[FP +-180];
	P1  =R1 ;
	R1  = B [P1 ] (Z);
	R0 =R0 +R1 ;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	jump.s L$L$1857;
L$L$1339:
	R0  =[FP +-180];
	P0  =R0 ;
	R0  = B [P0 ] (X);
L$L$1857:
	R1  = 10 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
L$L$1338:
	R1  =[FP +-20];
	P0  =R1 ;
	R1  =[P0 +12];
	R0  = 128 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1336;
	R0  =[FP +-60];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1341;
	R1  =[FP +-180];
	P1  =R1 ;
	R1  = B [P1 ] (Z);
	R0 =R0 +R1 ;
	P2  =R0 ;
	R0  = B [P2 ] (X);
	jump.s L$L$1858;
L$L$1341:
	R0  =[FP +-180];
	P3  =R0 ;
	R0  = B [P3 ] (X);
L$L$1858:
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1849;
L$L$1336:
	R0  =[FP +-80];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1732;
	R0  = 1 (X);
	[FP +-80] =R0 ;
	P2  =P5 ;
	R0  =[FP +-68];
	R1  =P5 ;
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1732;
L$L$1349:
	P0  =R4 ;
	P1  =P0 +(P2 <<2);
	R0  = B [P1 ] (X);
	BITSET (R0 ,4);
	BITSET (R0 ,3);
	B [P1 ] =R0 ;
	P2 +=1;
	R0  =[FP +-68];
	R1  =P2 ;
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1349;
	jump.l L$L$1732;
L$L$1351:
	P0  =[FP +-196];
	R0  = B [P0 +-1] (Z);
	R1  = 5 (X);
	cc =R0 ==R1 ;
	R0  =CC ;
	R3  =R0 ;
	R1  =[FP +-124];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1798;
L$L$1356:
	R1  =[FP +-120];
	R0  =[FP +-124];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-32];
	[FP +-180] =R0 ;
	[FP +-124] =R1 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1356;
L$L$1798:
	P2  =[FP +-60];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1357;
	R1  =[FP +-180];
	P0  =R1 ;
	R1  = B [P0 ] (Z);
	P1  =R1 ;
	P2 =P2 +P1 ;
	jump.s L$L$1859;
L$L$1357:
	R0  =[FP +-180];
	P2  =R0 ;
L$L$1859:
	R0  = B [P2 ] (X);
	R1  = R0.B  (Z);
	P3  =[FP +-196];
	R0  = B [P3 ] (Z);
	R0  <<=3;
	cc =R1 <R0  (iu);
	if cc jump 6; jump.l L$L$1359;
	R0  =R1 ;
	R0  >>=3;
	P2  =R0 ;
	P2 =P3 +P2 ;
	R2  = B [P2 +1] (Z);
	R0  = 7 (X);
	R1  =R1 &R0 ;
	R2  >>>=R1 ;
	R0  = 1 (X);
	R0  =R2 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1359;
	R0  = R3.B  (X);
	cc =R0 ==0;
	R0  =CC ;
	R3  =R0 ;
L$L$1359:
	P0  =[FP +-196];
	R0  = B [P0 ] (Z);
	P1  =R0 ;
	P0 =P0 +P1 ;
	P0 +=1;
	[FP +-196] =P0 ;
	R0  = R3.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-80];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1732;
	R0  = 1 (X);
	[FP +-80] =R0 ;
	P2  =P5 ;
	R0  =[FP +-68];
	R1  =P5 ;
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1732;
L$L$1367:
	P0  =R4 ;
	P1  =P0 +(P2 <<2);
	R0  = B [P1 ] (X);
	BITSET (R0 ,4);
	BITSET (R0 ,3);
	B [P1 ] =R0 ;
	P2 +=1;
	R0  =[FP +-68];
	R1  =P2 ;
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1367;
	jump.l L$L$1732;
L$L$1368:
	P0  =[FP +-196];
	[FP +-16] =P0 ;
	R0  = B [P0 ] (Z);
	P1  =R0 ;
	P2  =R4 ;
	P1  =P2 +(P1 <<2);
	P3  =P1 ;
	R0  = B [P1 ] (Z);
	R1  = 3 (X);
	R1  =R0 &R1 ;
	[FP +-132] =R1 ;
	cc =R1 ==3;
	if cc jump 6; jump.l L$L$1369;
	R2  =R4 ;
	R0  =FP ;
	R0 +=-16;
	R1  =[FP +-52];
	call _byte_group_match_null_string_p;
	R0  = R0.B  (X);
	R1  =[FP +-132];
	R1  =R0 &R1 ;
	R0  = -4 (X);
	R2  = B [P3 ] (X);
	R0  =R0 &R2 ;
	R1  =R0 |R1 ;
	B [P3 ] =R1 ;
L$L$1369:
	P0  =[FP +-196];
	R3  = B [P0 ] (Z);
	P1  =R3 ;
	P1  =P1 <<2;
	P0  =[FP +-84];
	P0 =P1 +P0 ;
	P3  =R4 ;
	P2 =P1 +P3 ;
	R1  = B [P2 ] (Z);
	R0  = 3 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1370;
	P4  =R5 ;
	P1 =P1 +P4 ;
	P1  =[P1 ];
	P2.L  = _byte_reg_unset_dummy; P2.H  = _byte_reg_unset_dummy;
	cc =P1 ==P2 ;
	R0  =[FP +-180];
	if cc P1  =R0 ; /* movsicc-2a */
	jump.s L$L$1371;
L$L$1370:
	P2  =[FP +-196];
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P3  =R5 ;
	P1  =P3 +(P1 <<2);
	P1  =[P1 ];
L$L$1371:
	[P0 ] =P1 ;
	P0  =[FP +-196];
	R0  = B [P0 ] (Z);
	P2  =R0 ;
	P1  =R5 ;
	P2  =P1 +(P2 <<2);
	R0  =[FP +-180];
	[P2 ] =R0 ;
	R0  = B [P0 ] (Z);
	P2  =R0 ;
	P0  =R4 ;
	P2  =P0 +(P2 <<2);
	R0  = B [P2 ] (X);
	BITSET (R0 ,2);
	B [P2 ] =R0 ;
	P0  =[FP +-196];
	R0  = B [P0 ] (Z);
	P2  =R0 ;
	P1  =R4 ;
	P2  =P1 +(P2 <<2);
	R0  = B [P2 ] (X);
	BITCLR (R0 ,3);
	B [P2 ] =R0 ;
	R0  = 0 (X);
	[FP +-80] =R0 ;
	R0  = B [P0 ] (Z);
	[FP +-68] =R0 ;
	P2  = 257 (X);
	cc =P5 ==P2 ;
	if cc P5  =R0 ; /* movsicc-1b */
	P0 +=2;
	[FP +-196] =P0 ;
	[FP +-56] =P0 ;
	jump.s L$L$1846;
L$L$1375:
	P0  =[FP +-196];
	R0  = B [P0 ] (Z);
	P1  =R0 ;
	P1  =P1 <<2;
	P0  =[FP +-88];
	P0 =P1 +P0 ;
	P3  =R4 ;
	P2 =P1 +P3 ;
	R1  = B [P2 ] (Z);
	R0  = 3 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1376;
	P4  =R6 ;
	P1 =P1 +P4 ;
	P1  =[P1 ];
	P2.L  = _byte_reg_unset_dummy; P2.H  = _byte_reg_unset_dummy;
	cc =P1 ==P2 ;
	R0  =[FP +-180];
	if cc P1  =R0 ; /* movsicc-2a */
	jump.s L$L$1377;
L$L$1376:
	P2  =[FP +-196];
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P3  =R6 ;
	P1  =P3 +(P1 <<2);
	P1  =[P1 ];
L$L$1377:
	[P0 ] =P1 ;
	P0  =[FP +-196];
	R0  = B [P0 ] (Z);
	P2  =R0 ;
	P1  =R6 ;
	P2  =P1 +(P2 <<2);
	R0  =[FP +-180];
	[P2 ] =R0 ;
	R0  = B [P0 ] (Z);
	P2  =R0 ;
	P0  =R4 ;
	P2  =P0 +(P2 <<2);
	R0  = B [P2 ] (X);
	BITCLR (R0 ,2);
	B [P2 ] =R0 ;
	R0  = 0 (X);
	[FP +-80] =R0 ;
	R0  =[FP +-68];
	R1  =P5 ;
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$1850;
	P0  =[FP +-196];
	R2  = B [P0 ] (X);
	R1  =R2 ;
	R0  = -1 (X);
	R0 =R0 +R1 ; //immed->Dreg 
	B [FP +-133] =R0 ;
	R0  = R0.B  (Z);
	P2  =R0 ;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1850;
	P1  =R4 ;
	P2  =P1 +(P2 <<2);
	R0  = B [P2 ] (Z);
	P2  =R0 ;
	P2  =P2 >>2;
	R0  = 1 (X);
	R1  =P2 ;
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1383;
	R1  = 1 (X);
L$L$1386:
	R0  = B [FP +-133] (X);
	R0 +=-1;
	B [FP +-133] =R0 ;
	R0  = R0.B  (Z);
	P2  =R0 ;
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1850;
	P0  =R4 ;
	P2  =P0 +(P2 <<2);
	R0  = B [P2 ] (Z);
	P1  =R0 ;
	P1  =P1 >>2;
	R0  =P1 ;
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1386;
L$L$1383:
	R0  = B [FP +-133] (X);
	R1  = R0.B  (Z);
	[FP +-68] =R1 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1381;
L$L$1850:
	P5  = 257 (X);
	R0  = 256 (X);
	[FP +-68] =R0 ;
L$L$1381:
	P0  =[FP +-196];
	R0  = B [P0 ] (Z);
	P2  =R0 ;
	P1  =R4 ;
	P2  =P1 +(P2 <<2);
	R1  = B [P2 ] (Z);
	R1  >>=3;
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1390;
	R1  =P0 ;
	R1 +=-1;
	R0  =[FP +-56];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1389;
L$L$1390:
	P1  =[FP +-196];
	P1 +=2;
	P2  =[FP +-52];
	cc =P1 <P2  (iu);
	if cc jump 6; jump.l L$L$1389;
	R1  = 0 (X);
	[FP +-16] =P1 ;
	R2  = 0 (X);
	P2  =P1 ;
	R0  = B [P2 ++] (Z);
	[FP +-16] =P2 ;
	R0 +=-13;
	P2  = 9 (X);
	P3  =R0 ;
	cc = P3 <=P2  (iu);
if cc jump 6;
jump.l L$L$1391;
P2.L =L$L$1401;
P2.H =L$L$1401;
P3  = P3 <<2;
P3  = P3 +P2 ;
P3  = [P3 ];
jump (P3 );

.align 2
.align 2
.align 2
L$L$1401:
	.dd		L$L$1396;
	.dd		L$L$1391;
	.dd		L$L$1391;
	.dd		L$L$1391;
	.dd		L$L$1396;
	.dd		L$L$1396;
	.dd		L$L$1396;
	.dd		L$L$1391;
	.dd		L$L$1391;
	.dd		L$L$1392;
L$L$1392:
	R1  = 1 (X);
L$L$1396:
	P2  =[FP +-16];
	R2  = B [P2 ] (Z);
	R0  = B [P2 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	P2 +=2;
	[FP +-16] =P2 ;
	R0  = R1.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1391;
	R0  =P2 ;
	R0 +=2;
	[FP +-16] =R0 ;
L$L$1391:
	R0  =[FP +-16];
	R0 =R2 +R0 ;
	[FP +-16] =R0 ;
	cc =R2 <0;
	if cc jump 6; jump.l L$L$1389;
	P2  =R0 ;
	R0  = B [P2 ] (Z);
	R1  = 15 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1389;
	R0  = B [P2 +3] (Z);
	R2  = 6 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1389;
	R3  = B [P2 +4] (Z);
	P2  =R3 ;
	P0  =[FP +-196];
	R0  = B [P0 ] (Z);
	cc =R3 ==R0 ;
	if cc jump 6; jump.l L$L$1389;
	P1  =R4 ;
	P2  =P1 +(P2 <<2);
	R1  = B [P2 ] (Z);
	R1  >>=4;
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1403;
	R0  = B [P2 ] (X);
	BITCLR (R0 ,4);
	B [P2 ] =R0 ;
	R2  = B [P0 ] (Z);
	R0  = B [P0 +1] (Z);
	R0 =R2 +R0 ;
	cc =R2 <R0  (iu);
	if cc jump 6; jump.l L$L$1403;
L$L$1409:
	P3  =R2 ;
	P2  =P3 <<2;
	P4  =R5 ;
	P1 =P2 +P4 ;
	P0  =[FP +-84];
	P0 =P2 +P0 ;
	P0  =[P0 ];
	[P1 ] =P0 ;
	P1  =[FP +-88];
	P1 =P2 +P1 ;
	P1  =[P1 ];
	cc =P1 <P0  (iu);
	if !cc jump 6; jump.l L$L$1406;
	P0  =R6 ;
	P2 =P2 +P0 ;
	[P2 ] =P1 ;
L$L$1406:
	R2 +=1;
	P1  =[FP +-196];
	R1  = B [P1 ] (Z);
	R0  = B [P1 +1] (Z);
	R0 =R1 +R0 ;
	cc =R2 <R0  (iu);
	if !cc jump 6; jump.l L$L$1409;
L$L$1403:
	R0  =[FP +-16];
	R0 +=1;
	[FP +-16] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ] (Z);
	R1  = B [P2 +1] (X);
	R1  <<=8;
	R0 =R0 +R1 ;
	[FP +-140] =R0 ;
	P2 +=2;
	[FP +-16] =P2 ;
	R2  =[FP +-8];
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	P2  =[FP +-68];
	R1  =P2 ;
	R3  =P5 ;
	R1  =R1 -R3 ;
	P1  =R1 ;
	P1  =P1 +(P1 <<1);
	P1 +=7;
	R1  =P1 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$1803;
	R0  =P2 ;
	R0  =R0 -R3 ;
	P2  =R0 ;
	P2  =P2 +(P2 <<1);
	P2 +=7;
	P3  =P2 ;
L$L$1421:
	R0.L  = _xre_max_failures; R0.H  = _xre_max_failures;
	P0  =R0 ;
	R0  =[P0 ];
	P1  =R0 ;
	P2  =P1 +(P1 <<2);
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =R1 -R0 ;
	cc =R2 <=R0  (iu);
	if cc jump 6; jump.l L$L$1621;
	R0  =R2 ;
	R0  <<=3;
	R3  =SP ;
	R3  =R3 -R0 ;
	SP  =R3 ;
	P4  = 16 (X);
	P4 =P4 +SP ; //immed->Preg 
	P0  =R2 ;
	P0  =P0 <<2;
	R2  =P0 ;
	R0  =[FP +-12];
	R1  =P4 ;
	call _bcopy;
	[FP +-12] =P4 ;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$1621;
	R2  =[FP +-8];
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	[FP +-8] =P1 ;
	R1  =[FP +-4];
	R1  =R2 -R1 ;
	R0  =P3 ;
	cc =R1 <R0  (iu);
	if !cc jump 6; jump.l L$L$1421;
L$L$1803:
	P4  =P5 ;
	R0  =[FP +-68];
	R1  =P5 ;
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1805;
	P3  = -4 (X);
	P3 =P3 +FP ; //immed->Preg 
L$L$1427:
	R0  =[P3 ];
	P2  =[FP +-12];
	P0  =R0 ;
	P2  =P2 +(P0 <<2);
	P0  =P4 <<2;
	P1  =R5 ;
	P1 =P0 +P1 ;
	R1  =[P1 ];
	[P2 ] =R1 ;
	R0 +=1;
	[P3 ] =R0 ;
	P2  =[FP +-12];
	P1  =R0 ;
	P2  =P2 +(P1 <<2);
	P1  =R6 ;
	P1 =P0 +P1 ;
	R1  =[P1 ];
	[P2 ] =R1 ;
	R0 +=1;
	[P3 ] =R0 ;
	P2  =[FP +-12];
	P1  =R0 ;
	P2  =P2 +(P1 <<2);
	P1  =R4 ;
	P0 =P0 +P1 ;
	P0  =[P0 ];
	[P2 ] =P0 ;
	R0 +=1;
	[P3 ] =R0 ;
	P4 +=1;
	R0  =[FP +-68];
	R1  =P4 ;
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1427;
L$L$1805:
	P0  = -4 (X);
	P0 =P0 +FP ; //immed->Preg 
	P1  =[P0 ];
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	[P2 ] =P5 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  =[FP +-68];
	[P2 ] =R0 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R1  =[FP +-16];
	R0  =[FP +-140];
	R1 =R0 +R1 ;
	[P2 ] =R1 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  =[FP +-180];
	[P2 ] =R0 ;
	P1 +=1;
	[P0 ] =P1 ;
	jump.l L$L$1849;
L$L$1389:
	P0  =[FP +-196];
	jump.s L$L$1865;
L$L$1428:
	P0  =[FP +-196];
	R0  = B [P0 ++] (Z);
	[FP +-196] =P0 ;
	P1  =R0 ;
	[FP +-144] =R0 ;
	P1  =P1 <<2;
	P3  =R5 ;
	P2 =P1 +P3 ;
	P2  =[P2 ];
	P4.L  = _byte_reg_unset_dummy; P4.H  = _byte_reg_unset_dummy;
	cc =P2 ==P4 ;
	if !cc jump 6; jump.l L$L$1849;
	P0  =R6 ;
	P1 =P1 +P0 ;
	P1  =[P1 ];
	cc =P1 ==P4 ;
	if !cc jump 6; jump.l L$L$1849;
	P3  =P2 ;
	R2  = 0 (X);
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1434;
	R1  =[FP +-24];
	R3  =P2 ;
	cc =R1 <=R3  (iu);
	if cc jump 6; jump.l L$L$1434;
	R0 =R1 +R0 ;
	cc =R3 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1433;
L$L$1434:
	R2  = 1 (X);
L$L$1433:
	P1  = 0 (X);
	R1  =[FP +-28];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1435;
	P2  =[FP +-144];
	P0  =R6 ;
	P2  =P0 +(P2 <<2);
	P2  =[P2 ];
	R0  =[FP +-24];
	R3  =P2 ;
	cc =R0 <=R3  (iu);
	if cc jump 6; jump.l L$L$1435;
	R1 =R0 +R1 ;
	R3  = 1 (X);
	R0  =P2 ;
	cc =R0 <=R1  (iu);
	if cc P1  =R3 ; /* movsicc-1b */
L$L$1435:
	R0  =[FP +-116];
	[FP +-148] =R0 ;
	R1  =P1 ;
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$1847;
	P2  =[FP +-144];
	P0  =R6 ;
	P2  =P0 +(P2 <<2);
	P2  =[P2 ];
	[FP +-148] =P2 ;
L$L$1847:
	R1  =[FP +-148];
	R0  =P3 ;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1845;
	P2  =[FP +-144];
	P1  =R6 ;
	P2  =P1 +(P2 <<2);
L$L$1444:
	R1  =[FP +-148];
	R0  =[FP +-120];
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$1440;
	R2  =[P2 ];
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$1440;
	R0  =[FP +-32];
	P3  =R0 ;
	[FP +-148] =R2 ;
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$1444;
	jump.s L$L$1845;
L$L$1440:
	R1  =[FP +-148];
	R0  =P3 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1846;
L$L$1845:
	R1  =[FP +-124];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1808;
L$L$1450:
	R0  =[FP +-124];
	R1  =[FP +-120];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-32];
	[FP +-180] =R0 ;
	[FP +-124] =R1 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1450;
L$L$1808:
	R2  =[FP +-124];
	R0  =[FP +-180];
	R2  =R2 -R0 ;
	R1  =[FP +-148];
	R3  =P3 ;
	R1  =R1 -R3 ;
	R2  =min(R2 ,R1 );
	[FP +-152] =R2 ;
	R1  =[FP +-60];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1453;
	[SP +12] =R1 ;
	R1  =P3 ;
	call _byte_bcmp_translate;
	jump.s L$L$1860;
L$L$1453:
	R2  =[FP +-152];
	R0  =[FP +-180];
	R1  =P3 ;
	call _memcmp;
L$L$1860:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1849;
	R0  =[FP +-152];
	R2  =[FP +-180];
	R2 =R2 +R0 ;
	[FP +-180] =R2 ;
	R1  =P3 ;
	R1 =R1 +R0 ;
	P3  =R1 ;
	R0  =[FP +-80];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1847;
	R0  = 1 (X);
	[FP +-80] =R0 ;
	P1  =P5 ;
	R0  =[FP +-68];
	R1  =P5 ;
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1847;
L$L$1461:
	P0  =R4 ;
	P2  =P0 +(P1 <<2);
	R0  = B [P2 ] (X);
	BITSET (R0 ,4);
	BITSET (R0 ,3);
	B [P2 ] =R0 ;
	P1 +=1;
	R0  =[FP +-68];
	R1  =P1 ;
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1461;
	jump.s L$L$1847;
L$L$1462:
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1465;
	R1  =[FP +-24];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	jump.s L$L$1861;
L$L$1465:
	R2  =[FP +-32];
	R0  =[FP +-180];
	cc =R0 ==R2 ;
L$L$1861:
	if !cc jump 6; jump.l L$L$1464;
	R0  =[FP +-36];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1463;
L$L$1464:
	R1  =[FP +-20];
	P0  =R1 ;
	R1  = B [P0 +28] (Z);
	R1  >>=5;
	jump.s L$L$1870;
L$L$1463:
	R0  =[FP +-180];
	P1  =R0 ;
	R0  = B [P1 +-1] (X);
	jump.s L$L$1879;
L$L$1470:
	R1  =[FP +-112];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1471;
	R1  =[FP +-20];
	P1  =R1 ;
	R1  = B [P1 +28] (Z);
	R1  >>=6;
L$L$1870:
	R0  = 1 (X);
	R0  =R1 &R0 ;
	jump.s L$L$1872;
L$L$1471:
	P2  =[FP +-108];
	R0  =[FP +-180];
	R1  =P2 ;
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1475;
	R0  =[FP +-32];
	jump.s L$L$1862;
L$L$1475:
	R0  =[FP +-180];
L$L$1862:
	P0  =R0 ;
	R0  = B [P0 ] (X);
L$L$1879:
	R1  = 10 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1849;
	R0  =[FP +-20];
	P0  =R0 ;
	R0  = B [P0 +28] (Z);
	R0  >>=7;
	cc =R0 ==0;
	jump.s L$L$1876;
L$L$1477:
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1480;
	R1  =[FP +-24];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	jump.s L$L$1863;
L$L$1480:
	R2  =[FP +-32];
	R0  =[FP +-180];
	cc =R0 ==R2 ;
L$L$1863:
	if !cc jump 6; jump.l L$L$1846;
	R0  =[FP +-36];
L$L$1872:
	cc =R0 ==0;
	jump.s L$L$1875;
L$L$1482:
	R1  =[FP +-112];
	R0  =[FP +-180];
	jump.s L$L$1881;
L$L$1484:
	P1  =[FP +-196];
	R2  = B [P1 ] (Z);
	R0  = B [P1 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	[FP +-156] =R2 ;
	P1 +=2;
	[FP +-196] =P1 ;
	R2  =[FP +-8];
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	P2  =[FP +-68];
	R1  =P2 ;
	R3  =P5 ;
	R1  =R1 -R3 ;
	P1  =R1 ;
	P1  =P1 +(P1 <<1);
	P1 +=7;
	R1  =P1 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$1812;
	R0  =P2 ;
	R0  =R0 -R3 ;
	P2  =R0 ;
	P2  =P2 +(P2 <<1);
	P2 +=7;
	[FP +-160] =P2 ;
L$L$1496:
	R0.L  = _xre_max_failures; R0.H  = _xre_max_failures;
	P0  =R0 ;
	R0  =[P0 ];
	P1  =R0 ;
	P2  =P1 +(P1 <<2);
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =R1 -R0 ;
	cc =R2 <=R0  (iu);
	if cc jump 6; jump.l L$L$1621;
	R0  =R2 ;
	R0  <<=3;
	R3  =SP ;
	R3  =R3 -R0 ;
	SP  =R3 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	P3  =P2 ;
	P0  =R2 ;
	P0  =P0 <<2;
	R2  =P0 ;
	R0  =[FP +-12];
	R1  =P2 ;
	call _bcopy;
	[FP +-12] =P3 ;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$1621;
	R2  =[FP +-8];
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	[FP +-8] =P1 ;
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	R1  =[FP +-160];
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$1496;
L$L$1812:
	R1  =P5 ;
	R0  =[FP +-68];
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1814;
	P3  = -4 (X);
	P3 =P3 +FP ; //immed->Preg 
L$L$1502:
	R0  =[P3 ];
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R1 ;
	P0  =P4 <<2;
	P2  =R5 ;
	P2 =P0 +P2 ;
	P4  =[P2 ];
	[P1 ] =P4 ;
	R0 +=1;
	[P3 ] =R0 ;
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R6 ;
	P4 =P0 +P4 ;
	R2  =[P4 ];
	[P1 ] =R2 ;
	R0 +=1;
	[P3 ] =R0 ;
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R4 ;
	P0 =P0 +P4 ;
	P0  =[P0 ];
	[P1 ] =P0 ;
	R0 +=1;
	[P3 ] =R0 ;
	R1 +=1;
	R0  =[FP +-68];
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1502;
L$L$1814:
	P0  = -4 (X);
	P0 =P0 +FP ; //immed->Preg 
	P1  =[P0 ];
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	[P2 ] =P5 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  =[FP +-68];
	[P2 ] =R0 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	P3  =[FP +-156];
	P4  =[FP +-196];
	P3 =P4 +P3 ;
	[P2 ] =P3 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  = 0 (X);
	jump.s L$L$1855;
L$L$1504:
	P0  =[FP +-196];
	R2  = B [P0 ] (Z);
	R0  = B [P0 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	[FP +-164] =R2 ;
	P0 +=2;
	[FP +-196] =P0 ;
	[FP +-16] =P0 ;
	P1  =P0 ;
	P2  =[FP +-52];
	cc =P0 <P2  (iu);
	if cc jump 6; jump.l L$L$1508;
	R0  = B [P0 ] (Z);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1508;
L$L$1511:
	P1 +=1;
	[FP +-16] =P1 ;
	P2  =[FP +-52];
	cc =P1 <P2  (iu);
	if cc jump 6; jump.l L$L$1508;
	R0  = B [P1 ] (Z);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1511;
L$L$1508:
	P1  =[FP +-16];
	P2  =[FP +-52];
	cc =P1 <P2  (iu);
	if cc jump 6; jump.l L$L$1512;
	R0  = B [P1 ] (Z);
	R1  = 6 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1512;
	R1  = B [P1 +1] (Z);
	R0  = B [P1 +2] (Z);
	R1 =R1 +R0 ;
	[FP +-68] =R1 ;
	P0  = 257 (X);
	cc =P5 ==P0 ;
	if cc jump 6; jump.l L$L$1512;
	R0  = B [P1 +1] (Z);
	P5  =R0 ;
L$L$1512:
	R2  =[FP +-8];
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	P2  =[FP +-68];
	R1  =P2 ;
	R3  =P5 ;
	R1  =R1 -R3 ;
	P1  =R1 ;
	P1  =P1 +(P1 <<1);
	P1 +=7;
	R1  =P1 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$1817;
	R0  =P2 ;
	R0  =R0 -R3 ;
	P2  =R0 ;
	P2  =P2 +(P2 <<1);
	P2 +=7;
	[FP +-168] =P2 ;
L$L$1523:
	R0.L  = _xre_max_failures; R0.H  = _xre_max_failures;
	P0  =R0 ;
	R0  =[P0 ];
	P1  =R0 ;
	P2  =P1 +(P1 <<2);
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =R1 -R0 ;
	cc =R2 <=R0  (iu);
	if cc jump 6; jump.l L$L$1621;
	R0  =R2 ;
	R0  <<=3;
	R3  =SP ;
	R3  =R3 -R0 ;
	SP  =R3 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	P3  =P2 ;
	P0  =R2 ;
	P0  =P0 <<2;
	R2  =P0 ;
	R0  =[FP +-12];
	R1  =P2 ;
	call _bcopy;
	[FP +-12] =P3 ;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$1621;
	R2  =[FP +-8];
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	[FP +-8] =P1 ;
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	R1  =[FP +-168];
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$1523;
L$L$1817:
	R1  =P5 ;
	R0  =[FP +-68];
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1819;
	P3  = -4 (X);
	P3 =P3 +FP ; //immed->Preg 
L$L$1529:
	R0  =[P3 ];
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R1 ;
	P0  =P4 <<2;
	P2  =R5 ;
	P2 =P0 +P2 ;
	P4  =[P2 ];
	[P1 ] =P4 ;
	R0 +=1;
	[P3 ] =R0 ;
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R6 ;
	P4 =P0 +P4 ;
	R2  =[P4 ];
	[P1 ] =R2 ;
	R0 +=1;
	[P3 ] =R0 ;
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R4 ;
	P0 =P0 +P4 ;
	P0  =[P0 ];
	[P1 ] =P0 ;
	R0 +=1;
	[P3 ] =R0 ;
	R1 +=1;
	R0  =[FP +-68];
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1529;
L$L$1819:
	P0  = -4 (X);
	P0 =P0 +FP ; //immed->Preg 
	P1  =[P0 ];
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	[P2 ] =P5 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  =[FP +-68];
	[P2 ] =R0 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	P3  =[FP +-164];
	P4  =[FP +-196];
	P3 =P4 +P3 ;
	[P2 ] =P3 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  =[FP +-180];
	jump.s L$L$1855;
L$L$1530:
	P0  =[FP +-196];
	R2  = B [P0 ] (Z);
	R0  = B [P0 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	P0 +=2;
	[FP +-196] =P0 ;
	R0  =P0 ;
L$L$1848:
	P1  =R0 ;
	P1 +=2;
	P2  =[FP +-52];
	cc =P1 <P2  (iu);
	if cc jump 6; jump.l L$L$1536;
	P0  =R0 ;
	R3  = B [P0 ] (X);
	R1  =R3 ;
	R1 +=-6;
	R1  = R1.B  (Z);
	cc =R1 <=1 (iu);
	if cc jump 6; jump.l L$L$1536;
	R0 +=3;
	jump.s L$L$1848;
L$L$1536:
	P1  =R0 ;
	P1 +=6;
	P2  =[FP +-52];
	cc =P1 <P2  (iu);
	if cc jump 6; jump.l L$L$1534;
	P2  =R0 ;
	R1  = B [P2 ] (Z);
	R3  = 19 (X);
	cc =R1 ==R3 ;
	if cc jump 6; jump.l L$L$1534;
	R0  =P1 ;
	jump.s L$L$1848;
L$L$1534:
	R1  =[FP +-196];
	R2 =R1 +R2 ;
	[FP +-16] =R2 ;
	P2  =[FP +-52];
	R2  =P2 ;
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1541;
	R3  = 17 (X);
	P0  =R1 ;
	B [P0 +-3] =R3 ;
	jump.s L$L$1542;
L$L$1541:
	P1  =R0 ;
	R2  = B [P1 ] (Z);
	cc =R2 ==2;
	if !cc jump 6; jump.l L$L$1544;
	R1  =[FP +-20];
	P2  =R1 ;
	R1  = B [P2 +28] (Z);
	R1  >>=7;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1543;
	R1  = 10 (X);
	cc =R2 ==R1 ;
	if cc jump 6; jump.l L$L$1543;
L$L$1544:
	P0  =R0 ;
	R1  = B [P0 ] (Z);
	R2  = 10 (X);
	R3  = 10 (X);
	cc =R1 ==R3 ;
	if !cc jump 6; jump.l L$L$1546;
	R2  = B [P0 +2] (X);
L$L$1546:
	R1  =[FP +-16];
	P0  =R1 ;
	R0  = B [P0 +3] (Z);
	cc =R0 ==2;
	if cc jump 6; jump.l L$L$1547;
	R1  = B [P0 +5] (Z);
	R0  = R2.B  (Z);
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$1576;
L$L$1547:
	P2  =[FP +-16];
	R1  = B [P2 +3] (X);
	R0  =R1 ;
	R0 +=-4;
	R0  = R0.B  (Z);
	cc =R0 <=1 (iu);
	if cc jump 6; jump.l L$L$1542;
	R0  = B [P2 +3] (Z);
	R3  = 5 (X);
	cc =R0 ==R3 ;
	R3  =CC ;
	R2  = R2.B  (Z);
	R0  = B [P2 +4] (Z);
	R0  <<=3;
	cc =R2 <R0  (iu);
	if cc jump 6; jump.l L$L$1550;
	R0  =R2 ;
	R0  >>=3;
	P0  =R0 ;
	P2 =P2 +P0 ;
	R1  = B [P2 +5] (Z);
	R0  = 7 (X);
	R2  =R2 &R0 ;
	R1  >>>=R2 ;
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1550;
	cc =R3 ==0;
	R3  =CC ;
L$L$1550:
	cc =R3 ==0;
	jump.s L$L$1880;
L$L$1543:
	P1  =R0 ;
	R1  = B [P1 ] (Z);
	R2  = 4 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$1542;
	R2  =[FP +-16];
	P0  =R2 ;
	R1  = B [P0 +3] (Z);
	cc =R1 ==2;
	if cc jump 6; jump.l L$L$1554;
	R1  = B [P1 +1] (Z);
	R1  <<=3;
	R2  = B [P0 +5] (Z);
	cc =R1 <=R2 ;
	if !cc jump 6; jump.l L$L$1864;
	R1  =R2 ;
	R1  >>=3;
	P2  =R1 ;
	P2 =P1 +P2 ;
	R3  = B [P2 +2] (Z);
	R1  = 7 (X);
	R2  =R2 &R1 ;
	R3  >>>=R2 ;
	R1  = 1 (X);
	R1  =R3 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1864;
L$L$1554:
	R1  =[FP +-16];
	P1  =R1 ;
	R1  = B [P1 +3] (Z);
	R2  = 5 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$1557;
	P2  = 0 (X);
	P0  =R0 ;
	R1  = B [P0 +1] (Z);
	R2  =P2 ;
	cc =R2 <R1 ;
	if cc jump 6; jump.l L$L$1559;
	[FP +-208] =R1 ;
L$L$1564:
	P0  =R0 ;
	P1 =P0 +P2 ;
	R3  = B [P1 +2] (Z);
	cc =R3 ==0;
	if !cc jump 6; jump.l L$L$1560;
	P1  =[FP +-16];
	R2  = B [P1 +4] (Z);
	R1  =P2 ;
	cc =R1 <R2 ;
	if cc jump 6; jump.l L$L$1559;
	P1 =P1 +P2 ;
	R2  = B [P1 +5] (Z);
	R2  =~R2 ;
	R3  =R3 &R2 ;
	cc =R3 ==0;
	if cc jump 6; jump.l L$L$1559;
L$L$1560:
	P2 +=1;
	P0  =[FP +-208];
	cc =P2 <P0 ;
	if !cc jump 6; jump.l L$L$1564;
L$L$1559:
	P1  =R0 ;
	R0  = B [P1 +1] (Z);
	R1  =P2 ;
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$1542;
L$L$1864:
	R2  = 17 (X);
	P0  =[FP +-196];
	B [P0 +-3] =R2 ;
	jump.s L$L$1542;
L$L$1557:
	P1  =[FP +-16];
	R1  = B [P1 +3] (Z);
	R2  = 4 (X);
	cc =R1 ==R2 ;
	if cc jump 6; jump.l L$L$1542;
	R2  = 0 (X);
	P0  =R0 ;
	R3  = B [P0 +1] (Z);
	[FP +-212] =R3 ;
	cc =R2 <R3 ;
	if cc jump 6; jump.l L$L$1569;
	R1  = B [P1 +4] (Z);
	cc =R2 <R1 ;
	if cc jump 6; jump.l L$L$1569;
L$L$1574:
	R1 =R0 +R2 ;
	P2  =R1 ;
	P3  =R2 ;
	P0 =P1 +P3 ;
	R1  = B [P2 +2] (X);
	R3  =R1 ;
	R1  = B [P0 +5] (X);
	R3  =R3 &R1 ;
	R3  = R3.B  (Z);
	[FP +-208] =R3 ;
	cc =R3 ==0;
	if cc jump 6; jump.l L$L$1569;
	R2 +=1;
	R1  =[FP +-212];
	cc =R2 <R1 ;
	if cc jump 6; jump.l L$L$1569;
	R1  = B [P1 +4] (Z);
	cc =R2 <R1 ;
	if !cc jump 6; jump.l L$L$1574;
L$L$1569:
	P0  =R0 ;
	R0  = B [P0 +1] (Z);
	cc =R2 ==R0 ;
	if !cc jump 6; jump.l L$L$1576;
	R0  =[FP +-16];
	P1  =R0 ;
	R0  = B [P1 +4] (Z);
	cc =R2 ==R0 ;
L$L$1880:
	if cc jump 6; jump.l L$L$1542;
L$L$1576:
	R0  = 17 (X);
	P0  =[FP +-196];
	B [P0 +-3] =R0 ;
L$L$1542:
	P1  =[FP +-196];
	P1 +=-2;
	[FP +-196] =P1 ;
	R0  = B [P1 +-1] (Z);
	R1  = 17 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1579;
	R2  = 13 (X);
	B [P1 +-1] =R2 ;
	jump.s L$L$1593;
L$L$1579:
	R0  =[FP +-4];
	P2  =[FP +-12];
	R0 +=-3;
	[FP +-4] =R0 ;
	P0  =R0 ;
	P1  =P2 +(P0 <<2);
	P1  =[P1 ];
	R0 +=-1;
	[FP +-4] =R0 ;
	P3  =R0 ;
	P2  =P2 +(P3 <<2);
	R2  =[P2 ];
	R0  =P1 ;
	cc =R0 <R2  (iu);
	if !cc jump 6; jump.l L$L$1823;
L$L$1586:
	P0  =P1 <<2;
	P3  =[FP +-104];
	P3 =P0 +P3 ;
	R1  =[FP +-4];
	R1 +=-1;
	[FP +-4] =R1 ;
	P2  =[FP +-12];
	P4  =R1 ;
	P4  =P2 +(P4 <<2);
	R0  =[P4 ];
	[P3 ] =R0 ;
	P2  =[FP +-100];
	P0 =P0 +P2 ;
	R0  =[FP +-4];
	R0 +=-1;
	[FP +-4] =R0 ;
	P2  =[FP +-12];
	P3  =R0 ;
	P2  =P2 +(P3 <<2);
	P2  =[P2 ];
	[P0 ] =P2 ;
	R0  =[FP +-4];
	R0 +=-1;
	[FP +-4] =R0 ;
	P2  =[FP +-12];
	P4  =R0 ;
	P2  =P2 +(P4 <<2);
	P2  =[P2 ];
	[P0 ] =P2 ;
	P1 +=-1;
	R0  =P1 ;
	cc =R0 <R2  (iu);
	if cc jump 6; jump.l L$L$1586;
L$L$1823:
	R0  = 0 (X);
	[FP +-80] =R0 ;
L$L$1578:
L$L$1593:
	P0  =[FP +-196];
	R2  = B [P0 ] (Z);
	R0  = B [P0 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	P0 +=2;
	P1  =R2 ;
	P0 =P0 +P1 ;
	jump.s L$L$1854;
L$L$1597:
	R2  =[FP +-8];
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	P2  =[FP +-68];
	R1  =P2 ;
	R3  =P5 ;
	R1  =R1 -R3 ;
	P1  =R1 ;
	P1  =P1 +(P1 <<1);
	P1 +=7;
	R1  =P1 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$1825;
	R0  =P2 ;
	R0  =R0 -R3 ;
	P2  =R0 ;
	P2  =P2 +(P2 <<1);
	P2 +=7;
	[FP +-172] =P2 ;
L$L$1607:
	R0.L  = _xre_max_failures; R0.H  = _xre_max_failures;
	P0  =R0 ;
	R0  =[P0 ];
	P1  =R0 ;
	P2  =P1 +(P1 <<2);
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =R1 -R0 ;
	cc =R2 <=R0  (iu);
	if cc jump 6; jump.l L$L$1621;
	R0  =R2 ;
	R0  <<=3;
	R3  =SP ;
	R3  =R3 -R0 ;
	SP  =R3 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	P3  =P2 ;
	P0  =R2 ;
	P0  =P0 <<2;
	R2  =P0 ;
	R0  =[FP +-12];
	R1  =P2 ;
	call _bcopy;
	[FP +-12] =P3 ;
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$1621;
	R2  =[FP +-8];
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	[FP +-8] =P1 ;
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	R1  =[FP +-172];
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$1607;
L$L$1825:
	R1  =P5 ;
	R0  =[FP +-68];
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1827;
	P3  = -4 (X);
	P3 =P3 +FP ; //immed->Preg 
L$L$1613:
	R0  =[P3 ];
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R1 ;
	P0  =P4 <<2;
	P2  =R5 ;
	P2 =P0 +P2 ;
	P4  =[P2 ];
	[P1 ] =P4 ;
	R0 +=1;
	[P3 ] =R0 ;
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R6 ;
	P4 =P0 +P4 ;
	R2  =[P4 ];
	[P1 ] =R2 ;
	R0 +=1;
	[P3 ] =R0 ;
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R4 ;
	P0 =P0 +P4 ;
	P0  =[P0 ];
	[P1 ] =P0 ;
	R0 +=1;
	[P3 ] =R0 ;
	R1 +=1;
	R0  =[FP +-68];
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1613;
L$L$1827:
	P0  = -4 (X);
	P0 =P0 +FP ; //immed->Preg 
	P1  =[P0 ];
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	[P2 ] =P5 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  =[FP +-68];
	[P2 ] =R0 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  = 0 (X);
	[P2 ] =R0 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	[P2 ] =R0 ;
	P1 +=1;
	[P0 ] =P1 ;
	jump.s L$L$1593;
L$L$1614:
	R2  =[FP +-8];
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	P2  =[FP +-68];
	R1  =P2 ;
	R3  =P5 ;
	R1  =R1 -R3 ;
	P1  =R1 ;
	P1  =P1 +(P1 <<1);
	P1 +=7;
	R1  =P1 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$1829;
	R0  =P2 ;
	R0  =R0 -R3 ;
	P2  =R0 ;
	P2  =P2 +(P2 <<1);
	P2 +=7;
	[FP +-176] =P2 ;
L$L$1624:
	R0.L  = _xre_max_failures; R0.H  = _xre_max_failures;
	P0  =R0 ;
	R0  =[P0 ];
	P1  =R0 ;
	P2  =P1 +(P1 <<2);
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =R1 -R0 ;
	cc =R2 <=R0  (iu);
	if cc jump 6; jump.l L$L$1621;
	R0  =R2 ;
	R0  <<=3;
	R3  =SP ;
	R3  =R3 -R0 ;
	SP  =R3 ;
	P2  = 16 (X);
	P2 =P2 +SP ; //immed->Preg 
	P3  =P2 ;
	P0  =R2 ;
	P0  =P0 <<2;
	R2  =P0 ;
	R0  =[FP +-12];
	R1  =P2 ;
	call _bcopy;
	[FP +-12] =P3 ;
	cc =P3 ==0;
	if cc jump 6; jump.l L$L$1844;
L$L$1621:
	R1  = -2 (X);
	jump.s L$L$1163;
L$L$1844:
	R2  =[FP +-8];
	P1  =R2 ;
	P1  =P1 +P1 ;
	R2  =P1 ;
	[FP +-8] =P1 ;
	R0  =[FP +-4];
	R0  =R2 -R0 ;
	R1  =[FP +-176];
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$1624;
L$L$1829:
	R1  =P5 ;
	R0  =[FP +-68];
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1831;
	P3  = -4 (X);
	P3 =P3 +FP ; //immed->Preg 
L$L$1630:
	R0  =[P3 ];
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R1 ;
	P0  =P4 <<2;
	P2  =R5 ;
	P2 =P0 +P2 ;
	P4  =[P2 ];
	[P1 ] =P4 ;
	R0 +=1;
	[P3 ] =R0 ;
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R6 ;
	P4 =P0 +P4 ;
	R2  =[P4 ];
	[P1 ] =R2 ;
	R0 +=1;
	[P3 ] =R0 ;
	P1  =[FP +-12];
	P2  =R0 ;
	P1  =P1 +(P2 <<2);
	P4  =R4 ;
	P0 =P0 +P4 ;
	P0  =[P0 ];
	[P1 ] =P0 ;
	R0 +=1;
	[P3 ] =R0 ;
	R1 +=1;
	R0  =[FP +-68];
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1630;
L$L$1831:
	P0  = -4 (X);
	P0 =P0 +FP ; //immed->Preg 
	P1  =[P0 ];
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	[P2 ] =P5 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  =[FP +-68];
	[P2 ] =R0 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
	R0  = 0 (X);
	[P2 ] =R0 ;
	P1 +=1;
	P2  =[FP +-12];
	P2  =P2 +(P1 <<2);
L$L$1855:
	[P2 ] =R0 ;
	P1 +=1;
	[P0 ] =P1 ;
	jump.l L$L$1846;
L$L$1631:
	P0  =[FP +-196];
	R2  = B [P0 +2] (Z);
	R0  = B [P0 +3] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	cc =R2 <=0;
	if !cc jump 6; jump.l L$L$1633;
	R2 +=-1;
	P0 +=2;
	B [P0 ] =R2 ;
	R2  >>>=8;
	B [P0 +1] =R2 ;
L$L$1865:
	P0 +=2;
L$L$1854:
	[FP +-196] =P0 ;
	jump.l L$L$1846;
L$L$1633:
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$1846;
	R0  = 0 (X);
	P0  =[FP +-196];
	B [P0 +2] =R0 ;
	B [P0 +3] =R0 ;
	jump.s L$L$1504;
L$L$1638:
	P1  =[FP +-196];
	R2  = B [P1 +2] (Z);
	R0  = B [P1 +3] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$1640;
	R2 +=-1;
	B [P1 +2] =R2 ;
	R2  >>>=8;
	B [P1 +3] =R2 ;
	jump.s L$L$1593;
L$L$1640:
	P2  =[FP +-196];
	P2 +=4;
	[FP +-196] =P2 ;
	jump.l L$L$1846;
L$L$1643:
	P3  =[FP +-196];
	R2  = B [P3 ] (Z);
	R0  = B [P3 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	P3 +=2;
	[FP +-196] =P3 ;
	R0  =P3 ;
	R2 =R0 +R2 ;
	[FP +-16] =R2 ;
	P0  =P3 ;
	R2  = B [P3 ] (Z);
	R0  = B [P3 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	P0 +=2;
	[FP +-196] =P0 ;
	P2  =[FP +-16];
	B [P2 ] =R2 ;
	P2  =[FP +-16];
	R2  >>>=8;
	B [P2 +1] =R2 ;
	jump.l L$L$1846;
L$L$1649:
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1652;
	R1  =[FP +-24];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	jump.s L$L$1866;
L$L$1652:
	R2  =[FP +-32];
	R0  =[FP +-180];
	cc =R0 ==R2 ;
L$L$1866:
	if !cc jump 6; jump.l L$L$1846;
	R0  =[FP +-36];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1846;
	R0  =[FP +-112];
	P1  =[FP +-180];
	R1  =P1 ;
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$1846;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P1 +=-1;
	P2  =[FP +-108];
	cc =P1 ==P2 ;
	if cc jump 6; jump.l L$L$1654;
	R0  =[FP +-32];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	jump.s L$L$1655;
L$L$1654:
	R2  =[FP +-180];
	R2 +=-1;
	R0  =[FP +-32];
	R0 +=-1;
	cc =R2 ==R0 ;
	if cc jump 6; jump.l L$L$1656;
	R0  =[FP +-108];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	jump.s L$L$1655;
L$L$1656:
	R0  =[FP +-180];
	P2  =R0 ;
	R0  = B [P2 +-1] (Z);
L$L$1655:
	R1 =R1 +R0 ;
	P3  =R1 ;
	R1  = B [P3 ] (X);
	cc =R1 ==1;
	R0  =CC ;
	R2  =R0 ;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P2  =[FP +-108];
	R0  =[FP +-180];
	R3  =P2 ;
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$1658;
	R0  =[FP +-32];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	jump.s L$L$1659;
L$L$1658:
	R3  =[FP +-32];
	R3 +=-1;
	R0  =[FP +-180];
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$1660;
	R0  =[FP +-108];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	jump.s L$L$1659;
L$L$1660:
	R0  =[FP +-180];
	P2  =R0 ;
	R0  = B [P2 ] (Z);
L$L$1659:
	R1 =R1 +R0 ;
	P3  =R1 ;
	R1  = B [P3 ] (X);
	cc =R1 ==1;
	R0  =CC ;
	R1  = R2.B  (X);
	R0  = R0.B  (X);
	cc =R1 ==R0 ;
	jump.s L$L$1876;
L$L$1663:
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1666;
	R1  =[FP +-24];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	jump.s L$L$1867;
L$L$1666:
	R2  =[FP +-32];
	R0  =[FP +-180];
	cc =R0 ==R2 ;
L$L$1867:
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-36];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-112];
	P1  =[FP +-180];
	R1  =P1 ;
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$1849;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P1 +=-1;
	P2  =[FP +-108];
	cc =P1 ==P2 ;
	if cc jump 6; jump.l L$L$1668;
	R0  =[FP +-32];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	jump.s L$L$1669;
L$L$1668:
	R2  =[FP +-180];
	R2 +=-1;
	R0  =[FP +-32];
	R0 +=-1;
	cc =R2 ==R0 ;
	if cc jump 6; jump.l L$L$1670;
	R0  =[FP +-108];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	jump.s L$L$1669;
L$L$1670:
	R0  =[FP +-180];
	P2  =R0 ;
	R0  = B [P2 +-1] (Z);
L$L$1669:
	R1 =R1 +R0 ;
	P3  =R1 ;
	R1  = B [P3 ] (X);
	cc =R1 ==1;
	R0  =CC ;
	R2  =R0 ;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P2  =[FP +-108];
	R0  =[FP +-180];
	R3  =P2 ;
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$1672;
	R0  =[FP +-32];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	jump.s L$L$1673;
L$L$1672:
	R3  =[FP +-32];
	R3 +=-1;
	R0  =[FP +-180];
	cc =R0 ==R3 ;
	if cc jump 6; jump.l L$L$1674;
	R0  =[FP +-108];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	jump.s L$L$1673;
L$L$1674:
	R0  =[FP +-180];
	P2  =R0 ;
	R0  = B [P2 ] (Z);
L$L$1673:
	R1 =R1 +R0 ;
	P3  =R1 ;
	R1  = B [P3 ] (X);
	cc =R1 ==1;
	R0  =CC ;
	R1  = R2.B  (X);
	R0  = R0.B  (X);
L$L$1881:
	cc =R1 ==R0 ;
L$L$1875:
	if cc jump 6; jump.l L$L$1849;
	jump.l L$L$1846;
L$L$1677:
	R1  =[FP +-112];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P2  =[FP +-108];
	R2  =P2 ;
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1679;
	R0  =[FP +-32];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	jump.s L$L$1680;
L$L$1679:
	R2  =[FP +-32];
	R2 +=-1;
	R0  =[FP +-180];
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1681;
	R0  =[FP +-108];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	jump.s L$L$1680;
L$L$1681:
	R0  =[FP +-180];
	P2  =R0 ;
	R0  = B [P2 ] (Z);
L$L$1680:
	R1 =R1 +R0 ;
	P3  =R1 ;
	R1  = B [P3 ] (X);
	cc =R1 ==1;
	if cc jump 6; jump.l L$L$1849;
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1684;
	R1  =[FP +-24];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	jump.s L$L$1868;
L$L$1684:
	R2  =[FP +-32];
	R0  =[FP +-180];
	cc =R0 ==R2 ;
L$L$1868:
	if !cc jump 6; jump.l L$L$1846;
	R0  =[FP +-36];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1846;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P1  =[FP +-180];
	P1 +=-1;
	P2  =[FP +-108];
	cc =P1 ==P2 ;
	if cc jump 6; jump.l L$L$1686;
	R0  =[FP +-32];
	P4  =R0 ;
	R0  = B [P4 ] (Z);
	jump.s L$L$1687;
L$L$1686:
	R2  =[FP +-180];
	R2 +=-1;
	R0  =[FP +-32];
	R0 +=-1;
	cc =R2 ==R0 ;
	if cc jump 6; jump.l L$L$1688;
	R0  =[FP +-108];
	P0  =R0 ;
	R0  = B [P0 +-1] (Z);
	jump.s L$L$1687;
L$L$1688:
	R0  =[FP +-180];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
L$L$1687:
	R1 =R1 +R0 ;
	P2  =R1 ;
	R1  = B [P2 ] (X);
	jump.s L$L$1853;
L$L$1690:
	R0  =[FP +-28];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1692;
	R1  =[FP +-24];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	jump.s L$L$1869;
L$L$1692:
	R2  =[FP +-32];
	R0  =[FP +-180];
	cc =R0 ==R2 ;
L$L$1869:
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-36];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1849;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P1  =[FP +-180];
	P1 +=-1;
	P2  =[FP +-108];
	cc =P1 ==P2 ;
	if cc jump 6; jump.l L$L$1694;
	R0  =[FP +-32];
	P3  =R0 ;
	R0  = B [P3 ] (Z);
	jump.s L$L$1695;
L$L$1694:
	R2  =[FP +-180];
	R2 +=-1;
	R0  =[FP +-32];
	R0 +=-1;
	cc =R2 ==R0 ;
	if cc jump 6; jump.l L$L$1696;
	R0  =[FP +-108];
	P4  =R0 ;
	R0  = B [P4 +-1] (Z);
	jump.s L$L$1695;
L$L$1696:
	R0  =[FP +-180];
	P0  =R0 ;
	R0  = B [P0 +-1] (Z);
L$L$1695:
	R1 =R1 +R0 ;
	P1  =R1 ;
	R1  = B [P1 ] (X);
	cc =R1 ==1;
	if cc jump 6; jump.l L$L$1849;
	R1  =[FP +-112];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1846;
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P2  =[FP +-108];
	R2  =P2 ;
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1699;
	R0  =[FP +-32];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	jump.s L$L$1700;
L$L$1699:
	R2  =[FP +-32];
	R2 +=-1;
	R0  =[FP +-180];
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1701;
	R0  =[FP +-108];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	jump.s L$L$1700;
L$L$1701:
	R0  =[FP +-180];
	P2  =R0 ;
	R0  = B [P2 ] (Z);
L$L$1700:
	R1 =R1 +R0 ;
	P3  =R1 ;
	R1  = B [P3 ] (X);
L$L$1853:
	cc =R1 ==1;
L$L$1876:
	if !cc jump 6; jump.l L$L$1849;
	jump.l L$L$1846;
L$L$1703:
	R1  =[FP +-124];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1833;
L$L$1708:
	R0  =[FP +-124];
	R1  =[FP +-120];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-32];
	[FP +-180] =R0 ;
	[FP +-124] =R1 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1708;
L$L$1833:
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P2  =[FP +-108];
	R0  =[FP +-180];
	R2  =P2 ;
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1710;
	R0  =[FP +-32];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	jump.s L$L$1711;
L$L$1710:
	R2  =[FP +-32];
	R2 +=-1;
	R0  =[FP +-180];
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1712;
	R0  =[FP +-108];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	jump.s L$L$1711;
L$L$1712:
	R0  =[FP +-180];
	P2  =R0 ;
	R0  = B [P2 ] (Z);
L$L$1711:
	R1 =R1 +R0 ;
	P3  =R1 ;
	R1  = B [P3 ] (X);
	cc =R1 ==1;
	if cc jump 6; jump.l L$L$1849;
	R0  =[FP +-80];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1732;
	R0  = 1 (X);
	[FP +-80] =R0 ;
	P2  =P5 ;
	R0  =[FP +-68];
	R1  =P5 ;
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1732;
L$L$1720:
	P0  =R4 ;
	P1  =P0 +(P2 <<2);
	R0  = B [P1 ] (X);
	BITSET (R0 ,4);
	BITSET (R0 ,3);
	B [P1 ] =R0 ;
	P2 +=1;
	R0  =[FP +-68];
	R1  =P2 ;
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1720;
	jump.s L$L$1732;
L$L$1721:
	R1  =[FP +-124];
	R0  =[FP +-180];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1836;
L$L$1726:
	R0  =[FP +-124];
	R1  =[FP +-120];
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-32];
	[FP +-180] =R0 ;
	[FP +-124] =R1 ;
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1726;
L$L$1836:
	R1.L  = _re_syntax_table; R1.H  = _re_syntax_table;
	P2  =[FP +-108];
	R0  =[FP +-180];
	R2  =P2 ;
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1728;
	R0  =[FP +-32];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	jump.s L$L$1729;
L$L$1728:
	R2  =[FP +-32];
	R2 +=-1;
	R0  =[FP +-180];
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1730;
	R0  =[FP +-108];
	P1  =R0 ;
	R0  = B [P1 +-1] (Z);
	jump.s L$L$1729;
L$L$1730:
	R0  =[FP +-180];
	P2  =R0 ;
	R0  = B [P2 ] (Z);
L$L$1729:
	R1 =R1 +R0 ;
	P3  =R1 ;
	R1  = B [P3 ] (X);
	cc =R1 ==1;
	if !cc jump 6; jump.l L$L$1849;
	R0  =[FP +-80];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1732;
	R0  = 1 (X);
	[FP +-80] =R0 ;
	P1  =P5 ;
	R0  =[FP +-68];
	R1  =P5 ;
	cc =R1 <=R0  (iu);
	if cc jump 6; jump.l L$L$1732;
L$L$1738:
	P0  =R4 ;
	P2  =P0 +(P1 <<2);
	R0  = B [P2 ] (X);
	BITSET (R0 ,4);
	BITSET (R0 ,3);
	B [P2 ] =R0 ;
	P1 +=1;
	R0  =[FP +-68];
	R1  =P1 ;
	cc =R1 <=R0  (iu);
	if !cc jump 6; jump.l L$L$1738;
L$L$1732:
	R0  =[FP +-180];
	R0 +=1;
	[FP +-180] =R0 ;
	jump.l L$L$1846;
L$L$1739:
	call _abort;
L$L$1221:
L$L$1849:
	R0  =[FP +-4];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1203;
	R0 +=-1;
	[FP +-4] =R0 ;
	P2  =[FP +-12];
	P0  =R0 ;
	P2  =P2 +(P0 <<2);
	P2  =[P2 ];
	cc =P2 ==0;
	R0  =[FP +-180];
	if !cc R0  =P2 ; /* movsicc-2b */
	[FP +-180] =R0 ;
	R0  =P0 ;
	R0 +=-1;
	[FP +-4] =R0 ;
	P5  =[FP +-12];
	P1  =R0 ;
	P1  =P5 +(P1 <<2);
	P2  =[P1 ];
	[FP +-196] =P2 ;
	R0 +=-1;
	[FP +-4] =R0 ;
	P3  =R0 ;
	P1  =P5 +(P3 <<2);
	P1  =[P1 ];
	[FP +-68] =P1 ;
	R0 +=-1;
	[FP +-4] =R0 ;
	P4  =R0 ;
	P5  =P5 +(P4 <<2);
	P5  =[P5 ];
	cc =P1 <P5  (iu);
	if !cc jump 6; jump.l L$L$1839;
L$L$1748:
	P0  =P1 <<2;
	P2  =R4 ;
	P3 =P0 +P2 ;
	R1  =[FP +-4];
	R1 +=-1;
	[FP +-4] =R1 ;
	P2  =[FP +-12];
	P4  =R1 ;
	P2  =P2 +(P4 <<2);
	P2  =[P2 ];
	[P3 ] =P2 ;
	P2  =R6 ;
	P3 =P0 +P2 ;
	R1  =[FP +-4];
	R1 +=-1;
	[FP +-4] =R1 ;
	P2  =[FP +-12];
	P4  =R1 ;
	P2  =P2 +(P4 <<2);
	P2  =[P2 ];
	[P3 ] =P2 ;
	P2  =R5 ;
	P0 =P0 +P2 ;
	R0  =[FP +-4];
	R0 +=-1;
	[FP +-4] =R0 ;
	P2  =[FP +-12];
	P3  =R0 ;
	P2  =P2 +(P3 <<2);
	P2  =[P2 ];
	[P0 ] =P2 ;
	P1 +=-1;
	cc =P1 <P5  (iu);
	if cc jump 6; jump.l L$L$1748;
L$L$1839:
	R0  = 0 (X);
	[FP +-80] =R0 ;
	P4  =[FP +-196];
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$1849;
	P2  =[FP +-52];
	cc =P4 <P2  (iu);
	if cc jump 6; jump.l L$L$1756;
	R1  = 0 (X);
	R0  = B [P4 ] (Z);
	R0 +=-13;
	P2  = 9 (X);
	P0  =R0 ;
	cc = P0 <=P2  (iu);
if cc jump 6;
jump.l L$L$1756;
P2.L =L$L$1768;
P2.H =L$L$1768;
P0  = P0 <<2;
P0  = P0 +P2 ;
P0  = [P0 ];
jump (P0 );

.align 2
.align 2
.align 2
L$L$1768:
	.dd		L$L$1761;
	.dd		L$L$1756;
	.dd		L$L$1756;
	.dd		L$L$1756;
	.dd		L$L$1761;
	.dd		L$L$1761;
	.dd		L$L$1756;
	.dd		L$L$1756;
	.dd		L$L$1756;
	.dd		L$L$1758;
L$L$1758:
	R1  = 1 (X);
L$L$1761:
	R0  =[FP +-196];
	R0 +=1;
	[FP +-16] =R0 ;
	P2  =R0 ;
	R2  = B [P2 ] (Z);
	R0  = B [P2 +1] (X);
	R0  <<=8;
	R2 =R2 +R0 ;
	P2 +=2;
	R0  =P2 ;
	R2 =R2 +R0 ;
	[FP +-16] =R2 ;
	R0  = R1.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1851;
	P1  =R2 ;
	R0  = B [P1 ] (Z);
	R2  = 21 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$1849;
	R0  = R1.B  (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1756;
L$L$1851:
	R0  =[FP +-16];
	P0  =R0 ;
	R0  = B [P0 ] (Z);
	R1  = 15 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$1849;
L$L$1756:
	R1  =[FP +-24];
	R0  =[FP +-180];
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$1846;
	P2  =[FP +-108];
	R2  =P2 ;
	cc =R0 <=R2  (iu);
	if cc jump 6; jump.l L$L$1846;
L$L$1878:
	R0  =[FP +-116];
	jump.l L$L$1852;
L$L$1203:
	P2  =[FP +-72];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$1224;
L$L$1877:
	R1  = -1 (X);
L$L$1163:
	R0  =[FP +-48];
	SP  =R0 ;
	R0  =R1 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_group_match_null_string_p, STT_FUNC;
_byte_group_match_null_string_p:
	LINK 4;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R0  =[P5 ];
	R0 +=2;
	[FP +-4] =R0 ;
	R1  =R0 ;
	cc =R0 <R5  (iu);
	if cc jump 6; jump.l L$L$1908;
L$L$1906:
	P1  =R1 ;
	R0  = B [P1 ] (Z);
	R2  = 7 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$1902;
	R2  = 15 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1903;
	R1 +=1;
	[FP +-4] =R1 ;
	P2  =R1 ;
	R4  = B [P2 ] (Z);
	R0  = B [P2 +1] (X);
	R0  <<=8;
	R4 =R4 +R0 ;
	P2 +=2;
	[FP +-4] =P2 ;
	cc =R4 <0;
	if !cc jump 6; jump.l L$L$1883;
	R0  =P2 ;
	R1 =R0 +R4 ;
	P2  =R1 ;
	R2  = B [P2 +-3] (Z);
	P2  =R2 ;
	P1  = 14 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$1892;
L$L$1899:
	R1 =R4 +R0 ;
	R1 +=-3;
	R2  =R6 ;
	call _byte_alt_match_null_string_p;
	R1  = R0.B  (X);
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1882;
	R0  =[FP +-4];
	R4 =R4 +R0 ;
	[FP +-4] =R4 ;
	P2  =R4 ;
	R0  = B [P2 ] (Z);
	R1  = 15 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$1892;
	P2 +=1;
	[FP +-4] =P2 ;
	R4  = B [P2 ] (Z);
	R0  = B [P2 +1] (X);
	R0  <<=8;
	R4 =R4 +R0 ;
	P2 +=2;
	[FP +-4] =P2 ;
	R0  =P2 ;
	R2 =R0 +R4 ;
	P2  =R2 ;
	R1  = B [P2 +-3] (Z);
	P2  =R1 ;
	P1  = 14 (X);
	cc =P2 ==P1 ;
	if cc jump 6; jump.l L$L$1910;
	P2  =R2 ;
	R2  = B [P2 +-3] (Z);
	P2  =R2 ;
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$1899;
L$L$1892:
	R0  =[FP +-4];
	P1  =R0 ;
	R4  = B [P1 +-2] (Z);
	R1  = B [P1 +-1] (X);
	R1  <<=8;
	R4 =R4 +R1 ;
	R1 =R4 +R0 ;
	R2  =R6 ;
	call _byte_alt_match_null_string_p;
	R1  = R0.B  (X);
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1882;
	jump.s L$L$1901;
L$L$1910:
	R0 +=-3;
	[FP +-4] =R0 ;
	jump.s L$L$1892;
L$L$1901:
	R0  =[FP +-4];
	R4 =R4 +R0 ;
	[FP +-4] =R4 ;
	jump.s L$L$1883;
L$L$1902:
	R0  =[FP +-4];
	R0 +=2;
	[P5 ] =R0 ;
	R0  = 1 (X);
	jump.s L$L$1882;
L$L$1903:
	R2  =R6 ;
	R0  =FP ;
	R0 +=-4;
	R1  =R5 ;
	call _byte_common_op_match_null_string_p;
	R1  = R0.B  (X);
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1882;
L$L$1883:
	R1  =[FP +-4];
	cc =R1 <R5  (iu);
	if !cc jump 6; jump.l L$L$1906;
L$L$1908:
	R0  = 0 (X);
L$L$1882:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_alt_match_null_string_p, STT_FUNC;
_byte_alt_match_null_string_p:
	LINK 4;
	[--sp] = ( r7:5 );
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	[FP +-4] =R0 ;
	R1  =R0 ;
	cc =R0 <R5  (iu);
	if cc jump 6; jump.l L$L$1924;
L$L$1922:
	P2  =R1 ;
	R0  = B [P2 ] (Z);
	R2  = 15 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$1919;
	R1 +=1;
	[FP +-4] =R1 ;
	P2  =R1 ;
	R1  = B [P2 ] (Z);
	R0  = B [P2 +1] (X);
	R0  <<=8;
	R1 =R1 +R0 ;
	P2 +=2;
	R0  =P2 ;
	R1 =R1 +R0 ;
	[FP +-4] =R1 ;
	jump.s L$L$1912;
L$L$1919:
	R2  =R6 ;
	R0  =FP ;
	R0 +=-4;
	R1  =R5 ;
	call _byte_common_op_match_null_string_p;
	R1  = R0.B  (X);
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1911;
L$L$1912:
	R1  =[FP +-4];
	cc =R1 <R5  (iu);
	if !cc jump 6; jump.l L$L$1922;
L$L$1924:
	R0  = 1 (X);
L$L$1911:
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_common_op_match_null_string_p, STT_FUNC;
_byte_common_op_match_null_string_p:
	LINK 8;
	[--sp] = ( p5:3 );
	P5  =R0 ;
	[FP +16] =R2 ;
	P4  =R2 ;
	R0  =[P5 ];
	[FP +-4] =R0 ;
	P2  =R0 ;
	R0  = B [P2 ++] (Z);
	[FP +-4] =P2 ;
	P2  = 29 (X);
	P1  =R0 ;
	cc = P1 <=P2  (iu);
if cc jump 6;
jump.l L$L$1954;
P2.L =L$L$1955;
P2.H =L$L$1955;
P1  = P1 <<2;
P1  = P1 +P2 ;
P1  = [P1 ];
jump (P1 );

.align 2
.align 2
.align 2
L$L$1955:
	.dd		L$L$1926;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1936;
	.dd		L$L$1954;
	.dd		L$L$1951;
	.dd		L$L$1926;
	.dd		L$L$1926;
	.dd		L$L$1926;
	.dd		L$L$1926;
	.dd		L$L$1939;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1944;
	.dd		L$L$1954;
	.dd		L$L$1953;
	.dd		L$L$1954;
	.dd		L$L$1954;
	.dd		L$L$1926;
	.dd		L$L$1926;
	.dd		L$L$1926;
	.dd		L$L$1926;
L$L$1936:
	P3  =[FP +-4];
	R0  = B [P3 ] (Z);
	P3  =R0 ;
	R0  =FP ;
	R0 +=-4;
	call _byte_group_match_null_string_p;
	P4  =P4 +(P3 <<2);
	R1  = B [P4 ] (Z);
	R2  = 3 (X);
	R2  =R1 &R2 ;
	cc =R2 ==3;
	if cc jump 6; jump.l L$L$1937;
	R1  = R0.B  (X);
	R2  =R1 &R2 ;
	R1  = -4 (X);
	R3  = B [P4 ] (X);
	R1  =R1 &R3 ;
	R2  =R1 |R2 ;
	B [P4 ] =R2 ;
L$L$1937:
	R1  = R0.B  (X);
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1925;
	jump.s L$L$1926;
L$L$1939:
	P2  =[FP +-4];
	R1  = B [P2 ] (Z);
	R0  = B [P2 +1] (X);
	R0  <<=8;
	R1 =R1 +R0 ;
	P2 +=2;
	[FP +-4] =P2 ;
	R0  = 0 (X);
	cc =R1 <0;
	if !cc jump 6; jump.l L$L$1925;
	jump.s L$L$1956;
L$L$1944:
	R0  =[FP +-4];
	R0 +=2;
	[FP +-4] =R0 ;
	P2  =R0 ;
	R1  = B [P2 ] (Z);
	R0  = B [P2 +1] (X);
	R0  <<=8;
	R1 =R1 +R0 ;
	P2 +=2;
	[FP +-4] =P2 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$1925;
	R0  =P2 ;
	R0 +=-4;
	[FP +-4] =R0 ;
	P2  =R0 ;
	R1  = B [P2 ] (Z);
	R0  = B [P2 +1] (X);
	R0  <<=8;
	R1 =R1 +R0 ;
	P2 +=2;
L$L$1956:
	R0  =P2 ;
	R1 =R1 +R0 ;
	[FP +-4] =R1 ;
	jump.s L$L$1926;
L$L$1951:
	P2  =[FP +-4];
	R0  = B [P2 ] (Z);
	P2  =R0 ;
	P4  =P4 +(P2 <<2);
	R0  = B [P4 ] (Z);
	R1  = 3 (X);
	R1  =R0 &R1 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1925;
	jump.s L$L$1926;
L$L$1953:
	R0  =[FP +-4];
	R0 +=4;
	[FP +-4] =R0 ;
L$L$1954:
	R0  = 0 (X);
	jump.s L$L$1925;
L$L$1926:
	R3  =[FP +-4];
	[P5 ] =R3 ;
	R0  = 1 (X);
L$L$1925:
	( p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _byte_bcmp_translate, STT_FUNC;
_byte_bcmp_translate:
	LINK 8;
	[--sp] = ( p5:5 );
	P2  =R0 ;
	[FP +16] =R2 ;
	P0  =R2 ;
	P1  =[FP +20];
	cc =P0 ==0;
	if !cc jump 6; jump.l L$L$1964;
L$L$1962:
	R3  = B [P2 ++] (Z);
	R0  =P1 ;
	R3 =R0 +R3 ;
	P5  =R1 ;
	R1 +=1;
	R2  = B [P5 ++] (Z);
	R2 =R0 +R2 ;
	P5  =R3 ;
	R3  = B [P5 ] (X);
	P5  =R2 ;
	R2  = B [P5 ] (X);
	R0  = 1 (X);
	cc =R3 ==R2 ;
	if cc jump 6; jump.l L$L$1957;
	P0 +=-1;
	cc =P0 ==0;
	if cc jump 6; jump.l L$L$1962;
L$L$1964:
	R0  = 0 (X);
L$L$1957:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xre_set_syntax;
.type _xre_set_syntax, STT_FUNC;
_xre_set_syntax:
	LINK 0;
	R1  =R0 ;
	P2.L  = _xre_syntax_options; P2.H  = _xre_syntax_options;
	R0  =[P2 ];
	[P2 ] =R1 ;
	UNLINK;
	rts;


.align 2
L$LC$12:
.dw	0x7553;
.dw	0x6363;
.dw	0x7365;
.db	0x73;
.db	0x00;
.align 2
L$LC$13:
.dw	0x6f4e;
.dw	0x6d20;
.dw	0x7461;
.dw	0x6863;
.db	0x00;
.align 2
L$LC$14:
.dw	0x6e49;
.dw	0x6176;
.dw	0x696c;
.dw	0x2064;
.dw	0x6572;
.dw	0x7567;
.dw	0x616c;
.dw	0x2072;
.dw	0x7865;
.dw	0x7270;
.dw	0x7365;
.dw	0x6973;
.dw	0x6e6f;
.db	0x00;
.align 2
L$LC$15:
.dw	0x6e49;
.dw	0x6176;
.dw	0x696c;
.dw	0x2064;
.dw	0x6f63;
.dw	0x6c6c;
.dw	0x7461;
.dw	0x6f69;
.dw	0x206e;
.dw	0x6863;
.dw	0x7261;
.dw	0x6361;
.dw	0x6574;
.db	0x72;
.db	0x00;
.align 2
L$LC$16:
.dw	0x6e49;
.dw	0x6176;
.dw	0x696c;
.dw	0x2064;
.dw	0x6863;
.dw	0x7261;
.dw	0x6361;
.dw	0x6574;
.dw	0x2072;
.dw	0x6c63;
.dw	0x7361;
.dw	0x2073;
.dw	0x616e;
.dw	0x656d;
.db	0x00;
.align 2
L$LC$17:
.dw	0x7254;
.dw	0x6961;
.dw	0x696c;
.dw	0x676e;
.dw	0x6220;
.dw	0x6361;
.dw	0x736b;
.dw	0x616c;
.dw	0x6873;
.db	0x00;
.align 2
L$LC$18:
.dw	0x6e49;
.dw	0x6176;
.dw	0x696c;
.dw	0x2064;
.dw	0x6162;
.dw	0x6b63;
.dw	0x7220;
.dw	0x6665;
.dw	0x7265;
.dw	0x6e65;
.dw	0x6563;
.db	0x00;
.align 2
L$LC$19:
.dw	0x6e55;
.dw	0x616d;
.dw	0x6374;
.dw	0x6568;
.dw	0x2064;
.dw	0x205b;
.dw	0x726f;
.dw	0x5b20;
.db	0x5e;
.db	0x00;
.align 2
L$LC$20:
.dw	0x6e55;
.dw	0x616d;
.dw	0x6374;
.dw	0x6568;
.dw	0x2064;
.dw	0x2028;
.dw	0x726f;
.dw	0x5c20;
.db	0x28;
.db	0x00;
.align 2
L$LC$21:
.dw	0x6e55;
.dw	0x616d;
.dw	0x6374;
.dw	0x6568;
.dw	0x2064;
.dw	0x7b5c;
.db	0x00;
.align 2
L$LC$22:
.dw	0x6e49;
.dw	0x6176;
.dw	0x696c;
.dw	0x2064;
.dw	0x6f63;
.dw	0x746e;
.dw	0x6e65;
.dw	0x2074;
.dw	0x666f;
.dw	0x5c20;
.dw	0x5c7b;
.db	0x7d;
.db	0x00;
.align 2
L$LC$23:
.dw	0x6e49;
.dw	0x6176;
.dw	0x696c;
.dw	0x2064;
.dw	0x6172;
.dw	0x676e;
.dw	0x2065;
.dw	0x6e65;
.db	0x64;
.db	0x00;
.align 2
L$LC$24:
.dw	0x654d;
.dw	0x6f6d;
.dw	0x7972;
.dw	0x6520;
.dw	0x6878;
.dw	0x7561;
.dw	0x7473;
.dw	0x6465;
.db	0x00;
.align 2
L$LC$25:
.dw	0x6e49;
.dw	0x6176;
.dw	0x696c;
.dw	0x2064;
.dw	0x7270;
.dw	0x6365;
.dw	0x6465;
.dw	0x6e69;
.dw	0x2067;
.dw	0x6572;
.dw	0x7567;
.dw	0x616c;
.dw	0x2072;
.dw	0x7865;
.dw	0x7270;
.dw	0x7365;
.dw	0x6973;
.dw	0x6e6f;
.db	0x00;
.align 2
L$LC$26:
.dw	0x7250;
.dw	0x6d65;
.dw	0x7461;
.dw	0x7275;
.dw	0x2065;
.dw	0x6e65;
.dw	0x2064;
.dw	0x666f;
.dw	0x7220;
.dw	0x6765;
.dw	0x6c75;
.dw	0x7261;
.dw	0x6520;
.dw	0x7078;
.dw	0x6572;
.dw	0x7373;
.dw	0x6f69;
.db	0x6e;
.db	0x00;
.align 2
L$LC$27:
.dw	0x6552;
.dw	0x7567;
.dw	0x616c;
.dw	0x2072;
.dw	0x7865;
.dw	0x7270;
.dw	0x7365;
.dw	0x6973;
.dw	0x6e6f;
.dw	0x7420;
.dw	0x6f6f;
.dw	0x6220;
.dw	0x6769;
.db	0x00;
.align 2
L$LC$28:
.dw	0x6e55;
.dw	0x616d;
.dw	0x6374;
.dw	0x6568;
.dw	0x2064;
.dw	0x2029;
.dw	0x726f;
.dw	0x5c20;
.db	0x29;
.db	0x00;
.data;
.align 2
_re_error_msgid:	.long	L$LC$12
	.long	L$LC$13
	.long	L$LC$14
	.long	L$LC$15
	.long	L$LC$16
	.long	L$LC$17
	.long	L$LC$18
	.long	L$LC$19
	.long	L$LC$20
	.long	L$LC$21
	.long	L$LC$22
	.long	L$LC$23
	.long	L$LC$24
	.long	L$LC$25
	.long	L$LC$26
	.long	L$LC$27
	.long	L$LC$28
.text;
.align 2
.type _group_in_compile_stack, STT_FUNC;
_group_in_compile_stack:
	LINK 0;
	[FP +8] =R0 ;
	[FP +12] =R1 ;
	[FP +16] =R2 ;
	R2  =[FP +20];
	R1  =[FP +16];
	R1 +=-1;
	cc =R1 <0;
	if !cc jump 6; jump.l L$L$1974;
	P1  =R0 ;
L$L$1972:
	P0  =R1 ;
	P2  =P0 +(P0 <<2);
	P2  =P1 +(P2 <<2);
	P2  =[P2 +16];
	R0  = 1 (X);
	R3  =P2 ;
	cc =R3 ==R2 ;
	if !cc jump 6; jump.l L$L$1966;
	R1 +=-1;
	cc =R1 <0;
	if cc jump 6; jump.l L$L$1972;
L$L$1974:
	R0  = 0 (X);
L$L$1966:
	UNLINK;
	rts;


.align 2
.global _xre_compile_fastmap;
.type _xre_compile_fastmap, STT_FUNC;
_xre_compile_fastmap:
	LINK 0;
	call _byte_re_compile_fastmap;
	UNLINK;
	rts;


.align 2
.global _xre_set_registers;
.type _xre_set_registers, STT_FUNC;
_xre_set_registers:
	LINK 0;
	[--sp] = ( r7:6 );
	[FP +16] =R2 ;
	P1  =R2 ;
	P2  =[FP +20];
	R3  =[FP +24];
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$1977;
	R2  = -7 (X);
	P0  =R0 ;
	R6  = B [P0 +28] (X);
	R2  =R2 &R6 ;
	BITSET (R2 ,1);
	B [P0 +28] =R2 ;
	P0  =R1 ;
	[P0 ] =P1 ;
	[P0 +4] =P2 ;
	[P0 +8] =R3 ;
	jump.s L$L$1976;
L$L$1977:
	R2  = -7 (X);
	P0  =R0 ;
	R3  = B [P0 +28] (X);
	R2  =R2 &R3 ;
	B [P0 +28] =R2 ;
	P2  = 0 (X);
	P1  =R1 ;
	[P1 ] =P2 ;
	[P1 +8] =P2 ;
	[P1 +4] =P2 ;
L$L$1976:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xre_search;
.type _xre_search, STT_FUNC;
_xre_search:
	LINK 0;
	[FP +16] =R2 ;
	P1  =R2 ;
	P2  =[FP +20];
	R3  =[FP +24];
	R2  =[FP +28];
	[SP +12] =R1 ;
	[SP +16] =P1 ;
	[SP +20] =P2 ;
	[SP +24] =R3 ;
	[SP +28] =R2 ;
	[SP +32] =P1 ;
	R2  = 0 (X);
	R1  = 0 (X);
	call _xre_search_2;
	UNLINK;
	rts;


.align 2
.global _xre_search_2;
.type _xre_search_2, STT_FUNC;
_xre_search_2:
	LINK 0;
	[--sp] = ( r7:5 );
	[FP +16] =R2 ;
	R6  =[FP +24];
	P0  =[FP +28];
	P1  =[FP +32];
	P2  =[FP +36];
	R3  =[FP +40];
	R5  =[FP +20];
	[SP +12] =R5 ;
	[SP +16] =R6 ;
	[SP +20] =P0 ;
	[SP +24] =P1 ;
	[SP +28] =P2 ;
	[SP +32] =R3 ;
	call _byte_re_search_2;
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xre_match;
.type _xre_match, STT_FUNC;
_xre_match:
	LINK 0;
	[FP +16] =R2 ;
	P2  =R2 ;
	R3  =[FP +20];
	R2  =[FP +24];
	[SP +12] =R1 ;
	[SP +16] =P2 ;
	[SP +20] =R3 ;
	[SP +24] =R2 ;
	[SP +28] =P2 ;
	R2  = 0 (X);
	R1  = 0 (X);
	call _byte_re_match_2_internal;
	UNLINK;
	rts;


.align 2
.global _xre_match_2;
.type _xre_match_2, STT_FUNC;
_xre_match_2:
	LINK 0;
	[--sp] = ( r7:6 );
	[FP +16] =R2 ;
	P0  =[FP +24];
	P1  =[FP +28];
	P2  =[FP +32];
	R3  =[FP +36];
	R6  =[FP +20];
	[SP +12] =R6 ;
	[SP +16] =P0 ;
	[SP +20] =P1 ;
	[SP +24] =P2 ;
	[SP +28] =R3 ;
	call _byte_re_match_2_internal;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xre_compile_pattern;
.type _xre_compile_pattern, STT_FUNC;
_xre_compile_pattern:
	LINK 0;
	P1  =R0 ;
	R3  =R1 ;
	[FP +16] =R2 ;
	P0  =R2 ;
	R1  = -7 (X);
	R0  = B [P0 +28] (X);
	R1  =R1 &R0 ;
	BITCLR (R1 ,4);
	R0  = -128 (X);
	R0  =R1 |R0 ;
	B [P0 +28] =R0 ;
	P2.L  = _xre_syntax_options; P2.H  = _xre_syntax_options;
	[SP +12] =R2 ;
	R2  =[P2 ];
	R0  =P1 ;
	R1  =R3 ;
	call _byte_regex_compile;
	P2  =R0 ;
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1983;
	P2  =P2 <<2;
	P1.L  = _re_error_msgid; P1.H  = _re_error_msgid;
	P1 =P1 +P2 ; //immed->Preg 
	R0  =[P1 ];
L$L$1983:
	UNLINK;
	rts;


.align 2
L$LC$29:
.dw	0x6f4e;
.dw	0x7020;
.dw	0x6572;
.dw	0x6976;
.dw	0x756f;
.dw	0x2073;
.dw	0x6572;
.dw	0x7567;
.dw	0x616c;
.dw	0x2072;
.dw	0x7865;
.dw	0x7270;
.dw	0x7365;
.dw	0x6973;
.dw	0x6e6f;
.db	0x00;
.align 2
.global _xre_comp;
.type _xre_comp, STT_FUNC;
_xre_comp:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	R6  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1986;
	P2.L  = _re_comp_buf; P2.H  = _re_comp_buf;
	P2  =[P2 ];
	R1.L  = L$LC$29; R1.H  = L$LC$29;
	R0  = 0 (X);
	cc =P2 ==0;
	if cc R0  =R1 ; /* movsicc-2a */
	jump.s L$L$1985;
L$L$1986:
	P5.L  = _re_comp_buf; P5.H  = _re_comp_buf;
	R0  =[P5 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1988;
	R0  = 200 (X);
	call _malloc;
	[P5 ] =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1992;
	P5.L  = _re_comp_buf; P5.H  = _re_comp_buf;
	R0  = 200 (X);
	[P5 +4] =R0 ;
	R0 +=56;
	call _malloc;
	[P5 +16] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1988;
L$L$1992:
	P2.L  = _re_error_msgid; P2.H  = _re_error_msgid;
	R0  =[P2 +48];
	jump.s L$L$1985;
L$L$1988:
	P5.L  = _re_comp_buf; P5.H  = _re_comp_buf;
	R0  = -128 (X);
	R1  = B [P5 +28] (X);
	R0  =R0 |R1 ;
	B [P5 +28] =R0 ;
	R0  =R6 ;
	call _strlen;
	R1  =R0 ;
	P2.L  = _xre_syntax_options; P2.H  = _xre_syntax_options;
	[SP +12] =P5 ;
	R2  =[P2 ];
	R0  =R6 ;
	call _byte_regex_compile;
	P2  =R0 ;
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$1985;
	P2  =P2 <<2;
	P1.L  = _re_error_msgid; P1.H  = _re_error_msgid;
	P1 =P1 +P2 ; //immed->Preg 
	R0  =[P1 ];
L$L$1985:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xre_exec;
.type _xre_exec, STT_FUNC;
_xre_exec:
	LINK 0;
	[--sp] = ( r7:5 );
	R5  =R0 ;
	call _strlen;
	R2  =R0 ;
	R6  = 0 (X);
	[SP +12] =R6 ;
	[SP +16] =R0 ;
	[SP +20] =R6 ;
	R0.L  = _re_comp_buf; R0.H  = _re_comp_buf;
	R1  =R5 ;
	call _xre_search;
	R1  = 1 (X);
	cc =R0 <0;
	if !cc R6  =R1 ; /* movsicc-2b */
	R0  =R6 ;
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xregcomp;
.type _xregcomp, STT_FUNC;
_xregcomp:
	LINK 4;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	[FP +-4] =R1 ;
	[FP +16] =R2 ;
	R4  =R2 ;
	R0  = 1 (X);
	R0  =R2 &R0 ;
	R1  = 33123 (Z); R1  <<= 1; //zeros
	P4.L  = -19716; P4.H  = 3;
	cc =R0 ==0;
	if cc P4  =R1 ; /* movsicc-2a */
	R0  = 0 (X);
	[P3 ] =R0 ;
	[P3 +4] =R0 ;
	[P3 +8] =R0 ;
	R0  = 256 (X);
	call _malloc;
	[P3 +16] =R0 ;
	R0  = 2 (X);
	R0  =R4 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$1998;
	R0  = 256 (X);
	call _malloc;
	R1  =R0 ;
	[P3 +20] =R0 ;
	R0  = 12 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$1995;
	P5  = 0 (X);
	P2  = 255 (X);
	cc =P5 <=P2  (iu);
	if cc jump 6; jump.l L$L$2007;
L$L$2006:
	R6  =[P3 +20];
	R0  =P5 ;
	R6 =R6 +R0 ;
	call _isupper;
	R5  =P5 ;
	BITTGL(R5 ,5);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2005;
	R5  =P5 ;
L$L$2005:
	P2  =R6 ;
	B [P2 ] =R5 ;
	P5 +=1;
	P2  = 255 (X);
	cc =P5 <=P2  (iu);
	if !cc jump 6; jump.l L$L$2006;
	jump.s L$L$2007;
L$L$1998:
	R0  = 0 (X);
	[P3 +20] =R0 ;
L$L$2007:
	R0  = 4 (X);
	R0  =R4 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2008;
	R1  =P4 ;
	BITCLR (R1 ,6);
	BITSET (R1 ,8);
	P4  =R1 ;
	R0  = -128 (X);
	R2  = B [P3 +28] (X);
	R0  =R0 |R2 ;
	jump.s L$L$2015;
L$L$2008:
	R0  = 127 (X);
	R1  = B [P3 +28] (X);
	R0  =R0 &R1 ;
L$L$2015:
	B [P3 +28] =R0 ;
	R4  >>=3;
	R1  = 1 (X);
	R1  =R4 &R1 ;
	R1  <<=4;
	R0  = B [P3 +28] (X);
	BITCLR (R0 ,4);
	R1  =R0 |R1 ;
	B [P3 +28] =R1 ;
	R0  =[FP +-4];
	call _strlen;
	R1  =R0 ;
	[SP +12] =P3 ;
	R2  =P4 ;
	R0  =[FP +-4];
	call _byte_regex_compile;
	R6  =R0 ;
	R0  = 8 (X);
	R2  = 16 (X);
	cc =R6 ==R2 ;
	if cc R6  =R0 ; /* movsicc-1b */
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$2011;
	R0  =[P3 +16];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2011;
	R0  =P3 ;
	call _xre_compile_fastmap;
	cc =R0 ==-2;
	if cc jump 6; jump.l L$L$2011;
	R0  =[P3 +16];
	call _free;
	R1  = 0 (X);
	[P3 +16] =R1 ;
L$L$2011:
	R0  =R6 ;
L$L$1995:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xregexec;
.type _xregexec, STT_FUNC;
_xregexec:
	LINK 56;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P5  =[FP +20];
	R4  =[FP +24];
	R0  =R1 ;
	call _strlen;
	[FP +-48] =R0 ;
	R5  = 0 (X);
	R0  = B [P3 +28] (Z);
	R0  >>=4;
	R1  = 1 (X);
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$2017;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$2017;
	R5  = 1 (X);
L$L$2017:
	R0  =[P3 ++];
	[FP +-44] =R0 ;
	R1  =[P3 ++];
	[FP +-40] =R1 ;
	P1  =[P3 ++];
	[FP +-36] =P1 ;
	P2  =[P3 ++];
	[FP +-32] =P2 ;
	R0  =[P3 ++];
	[FP +-28] =R0 ;
	R1  =[P3 ++];
	[FP +-24] =R1 ;
	P1  =[P3 ++];
	[FP +-20] =P1 ;
	P3  =[P3 ];
	[FP +-16] =P3 ;
	R2  = 1 (X);
	R1  =R4 &R2 ;
	R1  <<=5;
	R0  = B [FP +-16] (X);
	BITCLR (R0 ,5);
	R1  =R0 |R1 ;
	P2  =R4 ;
	P2  =P2 >>1;
	R4  =P2 ;
	R2  =R4 &R2 ;
	R2  <<=6;
	BITCLR (R1 ,6);
	R2  =R1 |R2 ;
	BITCLR (R2 ,1);
	BITSET (R2 ,2);
	B [FP +-16] =R2 ;
	R0  = R5.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2018;
	[FP +-12] =R6 ;
	R0  =R6 ;
	R0  <<=3;
	call _malloc;
	R1  =R0 ;
	[FP +-8] =R0 ;
	R0  = 1 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$2016;
	P2  =R1 ;
	P3  =R6 ;
	P2  =P2 +(P3 <<2);
	[FP +-4] =P2 ;
L$L$2018:
	P1  = -44 (X);
	P1 =P1 +FP ; //immed->Preg 
	R0  = 0 (X);
	[SP +12] =R0 ;
	R2  =[FP +-48];
	[SP +16] =R2 ;
	R0  = R5.B  (X);
	P2  = -12 (X);
	P2 =P2 +FP ; //immed->Preg 
	R1  = 0 (X);
	cc =R0 ==0;
	if !cc R1  =P2 ; /* movsicc-1a */
	[SP +20] =R1 ;
	R0  =P1 ;
	R1  =P4 ;
	call _xre_search;
	R4  =R0 ;
	R0  = R5.B  (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2022;
	cc =R4 <0;
	if !cc jump 6; jump.l L$L$2023;
	R2  = 0 (X);
	cc =R2 <R6  (iu);
	if cc jump 6; jump.l L$L$2023;
	P4  =[FP +-8];
	P0  =[FP +-4];
L$L$2028:
	R0  =R2 ;
	R0  <<=3;
	R1  =P5 ;
	R0 =R0 +R1 ;
	P2  =R2 ;
	P1  =P2 <<2;
	P2 =P1 +P4 ;
	P2  =[P2 ];
	P3  =R0 ;
	[P3 ] =P2 ;
	P1 =P1 +P0 ;
	P1  =[P1 ];
	[P3 +4] =P1 ;
	R2 +=1;
	cc =R2 <R6  (iu);
	if !cc jump 6; jump.l L$L$2028;
L$L$2023:
	R0  =[FP +-8];
	call _free;
L$L$2022:
	R0  =R4 ;
	R0  >>=31;
L$L$2016:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xregerror;
.type _xregerror, STT_FUNC;
_xregerror:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	[FP +16] =R2 ;
	R4  =R2 ;
	R5  =[FP +20];
	R1  = 16 (X);
	cc =R0 <=R1  (iu);
	if !cc jump 6; jump.l L$L$2031;
	call _abort;
L$L$2031:
	P2  =R0 ;
	P5  =P2 <<2;
	P2.L  = _re_error_msgid; P2.H  = _re_error_msgid;
	P2 =P2 +P5 ; //immed->Preg 
	P5  =[P2 ];
	R0  =P5 ;
	call _strlen;
	R6  = 1 (X);
	R6 =R6 +R0 ; //immed->Dreg 
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$2032;
	cc =R6 <=R5  (iu);
	if !cc jump 6; jump.l L$L$2033;
	R2  = -1 (X);
	R2 =R2 +R5 ; //immed->Dreg 
	R0  =R4 ;
	R1  =P5 ;
	call _mempcpy;
	R1  = 0 (X);
	P2  =R0 ;
	B [P2 ] =R1 ;
	jump.s L$L$2032;
L$L$2033:
	R2  =R6 ;
	R0  =P5 ;
	R1  =R4 ;
	call _bcopy;
L$L$2032:
	R0  =R6 ;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xregfree;
.type _xregfree, STT_FUNC;
_xregfree:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  =[P5 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2036;
	call _free;
L$L$2036:
	R0  = 0 (X);
	[P5 ] =R0 ;
	[P5 +4] =R0 ;
	[P5 +8] =R0 ;
	R0  =[P5 +16];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2037;
	call _free;
L$L$2037:
	R0  = 0 (X);
	[P5 +16] =R0 ;
	R0  = B [P5 +28] (X);
	BITCLR (R0 ,3);
	B [P5 +28] =R0 ;
	R0  =[P5 +20];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2038;
	call _free;
L$L$2038:
	R0  = 0 (X);
	[P5 +20] =R0 ;
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.global _xre_syntax_options;
.data;
.align 2
_xre_syntax_options:.space 4;
.align 2
_re_syntax_table:.space 256;
_byte_reg_unset_dummy:.space 4;
.align 2
_re_comp_buf:.space 32;
