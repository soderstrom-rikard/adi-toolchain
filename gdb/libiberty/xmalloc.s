// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "xmalloc.i";
.text;
.align 2
L$LC$0:
.db	0x00;
.data;
.align 2
_name:	.long	L$LC$0
.text;
.align 2
.global _xmalloc_set_program_name;
.type _xmalloc_set_program_name, STT_FUNC;
_xmalloc_set_program_name:
	LINK 0;
	P2.L  = _name; P2.H  = _name;
	[P2 ] =R0 ;
	UNLINK;
	rts;


.align 2
L$LC$1:
.dw	0x250a;
.dw	0x2573;
.dw	0x6f73;
.dw	0x7475;
.dw	0x6f20;
.dw	0x2066;
.dw	0x656d;
.dw	0x6f6d;
.dw	0x7972;
.dw	0x6120;
.dw	0x6c6c;
.dw	0x636f;
.dw	0x7461;
.dw	0x6e69;
.dw	0x2067;
.dw	0x6c25;
.dw	0x2075;
.dw	0x7962;
.dw	0x6574;
.dw	0x0a73;
.db	0x00;
.align 2
L$LC$2:
.dw	0x203a;
.db	0x00;
.align 2
.global _xmalloc_failed;
.type _xmalloc_failed, STT_FUNC;
_xmalloc_failed:
	LINK 0;
	P2.L  = _stderr; P2.H  = _stderr;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R1.L  = L$LC$1; R1.H  = L$LC$1;
	[SP +16] =R1 ;
	P2.L  = _name; P2.H  = _name;
	P2  =[P2 ];
	[SP +20] =P2 ;
	R1  = B [P2 ] (X);
	P2  =R1 ;
	R2.L  = L$LC$0; R2.H  = L$LC$0;
	R1.L  = L$LC$2; R1.H  = L$LC$2;
	cc =P2 ==0;
	if cc R1  =R2 ; /* movsicc-2a */
	[SP +24] =R1 ;
	[SP +28] =R0 ;
	call _fprintf;
	R0  = 1 (X);
	call _xexit;
	UNLINK;
	rts;


.align 2
.global _xmalloc;
.type _xmalloc, STT_FUNC;
_xmalloc:
	LINK 0;
	[--sp] = ( r7:6 );
	R6  =R0 ;
	R0  = 1 (X);
	cc =R6 ==0;
	if cc R6  =R0 ; /* movsicc-1b */
	R0  =R6 ;
	call _malloc;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$7;
	R0  =R6 ;
	call _xmalloc_failed;
L$L$7:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xcalloc;
.type _xcalloc, STT_FUNC;
_xcalloc:
	LINK 0;
	[--sp] = ( r7:5 );
	R5  =R0 ;
	R6  =R1 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$10;
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$9;
L$L$10:
	R6  = 1 (X);
	R5  = 1 (X);
L$L$9:
	R0  =R5 ;
	R1  =R6 ;
	call _calloc;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$11;
	R0  =R5 ;
	R0  *=R6 ;
	call _xmalloc_failed;
L$L$11:
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _xrealloc;
.type _xrealloc, STT_FUNC;
_xrealloc:
	LINK 0;
	[--sp] = ( r7:6 );
	R6  =R1 ;
	R1  = 1 (X);
	cc =R6 ==0;
	if cc R6  =R1 ; /* movsicc-1b */
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$14;
	R0  =R6 ;
	call _malloc;
	jump.s L$L$15;
L$L$14:
	R1  =R6 ;
	call _realloc;
L$L$15:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$16;
	R0  =R6 ;
	call _xmalloc_failed;
L$L$16:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


