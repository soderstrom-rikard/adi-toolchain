// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "make-temp-file.i";
.text;
_tmp:	.byte	47
	.byte	116
	.byte	109
	.byte	112
	.byte	0
_usrtmp:	.byte	47
	.byte	117
	.byte	115
	.byte	114
	.byte	47
	.byte	116
	.byte	109
	.byte	112
	.byte	0
_vartmp:	.byte	47
	.byte	118
	.byte	97
	.byte	114
	.byte	47
	.byte	116
	.byte	109
	.byte	112
	.byte	0
.align 2
L$LC$0:
.dw	0x4d54;
.dw	0x4450;
.dw	0x5249;
.db	0x00;
.align 2
L$LC$1:
.dw	0x4d54;
.db	0x50;
.db	0x00;
.align 2
L$LC$2:
.dw	0x4554;
.dw	0x504d;
.db	0x00;
.align 2
L$LC$3:
.dw	0x742f;
.dw	0x706d;
.db	0x00;
.align 2
L$LC$4:
.db	0x2e;
.db	0x00;
.align 2
.global _choose_tmpdir;
.type _choose_tmpdir, STT_FUNC;
_choose_tmpdir:
	LINK 4;
	[--sp] = ( r7:4 );
	R4  = 0 (X);
	P2.L  = _memoized_tmpdir; P2.H  = _memoized_tmpdir;
	R0  =[P2 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$1;
	R0.L  = L$LC$0; R0.H  = L$LC$0;
	call _getenv;
	R6  =R0 ;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$4;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$5;
	R1  = 7 (X);
	call _access;
	R4  =R6 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$4;
L$L$5:
	R4  = 0 (X);
L$L$4:
	R0.L  = L$LC$1; R0.H  = L$LC$1;
	call _getenv;
	R6  =R0 ;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$7;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$8;
	R1  = 7 (X);
	call _access;
	R4  =R6 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$7;
L$L$8:
	R4  = 0 (X);
L$L$7:
	R0.L  = L$LC$2; R0.H  = L$LC$2;
	call _getenv;
	R6  =R0 ;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$10;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$11;
	R1  = 7 (X);
	call _access;
	R4  =R6 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$10;
L$L$11:
	R4  = 0 (X);
L$L$10:
	R6.L  = L$LC$3; R6.H  = L$LC$3;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$13;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$14;
	R0  =R6 ;
	R1  = 7 (X);
	call _access;
	R4  =R6 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$13;
L$L$14:
	R4  = 0 (X);
L$L$13:
	R6.L  = _vartmp; R6.H  = _vartmp;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$16;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$17;
	R0  =R6 ;
	R1  = 7 (X);
	call _access;
	R4  =R6 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$16;
L$L$17:
	R4  = 0 (X);
L$L$16:
	R6.L  = _usrtmp; R6.H  = _usrtmp;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$19;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$20;
	R0  =R6 ;
	R1  = 7 (X);
	call _access;
	R4  =R6 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$19;
L$L$20:
	R4  = 0 (X);
L$L$19:
	R6.L  = _tmp; R6.H  = _tmp;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$22;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$23;
	R0  =R6 ;
	R1  = 7 (X);
	call _access;
	R4  =R6 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$22;
L$L$23:
	R4  = 0 (X);
L$L$22:
	R0.L  = L$LC$4; R0.H  = L$LC$4;
	cc =R4 ==0;
	if cc R4  =R0 ; /* movsicc-1b */
	R0  =R4 ;
	call _strlen;
	R5  =R0 ;
	R0  = 2 (X);
	R0 =R0 +R5 ; //immed->Dreg 
	call _xmalloc;
	R6  =R0 ;
	R1  =R4 ;
	call _strcpy;
	R5 =R6 +R5 ;
	R1  = 47 (X);
	P2  =R5 ;
	B [P2 ++] =R1 ;
	R1  = 0 (X);
	B [P2 ] =R1 ;
	P2.L  = _memoized_tmpdir; P2.H  = _memoized_tmpdir;
	[P2 ] =R6 ;
	R0  =R6 ;
L$L$1:
	( r7:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$5:
.db	0x00;
.align 2
.global _make_temp_file;
.type _make_temp_file, STT_FUNC;
_make_temp_file:
	LINK 4;
	[--sp] = ( r7:4, p5:4 );
	R4  =R0 ;
	call _choose_tmpdir;
	P4  =R0 ;
	R0.L  = L$LC$5; R0.H  = L$LC$5;
	cc =R4 ==0;
	if cc R4  =R0 ; /* movsicc-1b */
	R0  =P4 ;
	call _strlen;
	R5  =R0 ;
	R0  =R4 ;
	call _strlen;
	R6  =R0 ;
	R0 =R5 +R0 ;
	R0 +=9;
	call _xmalloc;
	P5  =R0 ;
	R1  =P4 ;
	call _strcpy;
	R1  =P5 ;
	R5 =R1 +R5 ;
	R0  = 99 (X);
	P2  =R5 ;
	B [P2 ++] =R0 ;
	B [P2 ++] =R0 ;
	R0  = 88 (X);
	B [P2 ++] =R0 ;
	B [P2 ++] =R0 ;
	B [P2 ++] =R0 ;
	B [P2 ++] =R0 ;
	B [P2 ++] =R0 ;
	B [P2 ++] =R0 ;
	R1  = 0 (X);
	B [P2 ] =R1 ;
	R0  = 8 (X);
	R0 =R0 +R5 ; //immed->Dreg 
	R1  =R4 ;
	call _strcpy;
	R0  =P5 ;
	R1  =R6 ;
	call _mkstemps;
	cc =R0 ==-1;
	if !cc jump 6; jump.l L$L$29;
	call _close;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$28;
L$L$29:
	call _abort;
L$L$28:
	R0  =P5 ;
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.data;
.align 2
_memoized_tmpdir:.space 4;
