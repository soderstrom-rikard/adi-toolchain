// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "obstack.i";
.global _obstack_alloc_failed_handler;
.data;
.align 2
_obstack_alloc_failed_handler:	.long	_print_and_abort
.global _obstack_exit_failure;
.align 2
_obstack_exit_failure:	.long	1
.text;
.align 2
.global __obstack_begin;
.type __obstack_begin, STT_FUNC;
__obstack_begin:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R3  =R1 ;
	[FP +16] =R2 ;
	P2  =[FP +20];
	R1  =[FP +24];
	R0  = 4 (X);
	cc =R2 ==0;
	if cc R2  =R0 ; /* movsicc-1b */
	R0  = 4072 (X);
	cc =R3 ==0;
	if cc R3  =R0 ; /* movsicc-1b */
	[P5 +28] =P2 ;
	[P5 +32] =R1 ;
	[P5 ] =R3 ;
	R2 +=-1;
	[P5 +24] =R2 ;
	R0  = B [P5 +40] (X);
	BITCLR (R0 ,0);
	B [P5 +40] =R0 ;
	R1  = B [P5 +40] (Z);
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$4;
	R0  =[P5 +36];
	R1  =R3 ;
	call (P2 );
	jump.s L$L$7;
L$L$4:
	P2  =[P5 +28];
	R0  =[P5 ];
	call (P2 );
L$L$7:
	R6  =R0 ;
	[P5 +4] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$6;
	P2.L  = _obstack_alloc_failed_handler; P2.H  = _obstack_alloc_failed_handler;
	P2  =[P2 ];
	call (P2 );
L$L$6:
	R0  = 8 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	[P5 +8] =R0 ;
	[P5 +12] =R0 ;
	R0  =[P5 ];
	R0 =R6 +R0 ;
	P2  =R6 ;
	[P2 ] =R0 ;
	[P5 +16] =R0 ;
	R0  = 0 (X);
	[P2 +4] =R0 ;
	R0  = B [P5 +40] (X);
	BITCLR (R0 ,1);
	BITCLR (R0 ,2);
	B [P5 +40] =R0 ;
	R0  = 1 (X);
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global __obstack_begin_1;
.type __obstack_begin_1, STT_FUNC;
__obstack_begin_1:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	P1  =R1 ;
	[FP +16] =R2 ;
	R3  =R2 ;
	P2  =[FP +20];
	R1  =[FP +24];
	R2  =[FP +28];
	R0  = 4 (X);
	cc =R3 ==0;
	if cc R3  =R0 ; /* movsicc-1b */
	R0  = 4072 (X);
	cc =P1 ==0;
	if cc P1  =R0 ; /* movsicc-1b */
	[P5 +28] =P2 ;
	[P5 +32] =R1 ;
	[P5 ] =P1 ;
	R3 +=-1;
	[P5 +24] =R3 ;
	[P5 +36] =R2 ;
	R0  = B [P5 +40] (X);
	BITSET (R0 ,0);
	B [P5 +40] =R0 ;
	R1  = B [P5 +40] (Z);
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$11;
	R0  =R2 ;
	R1  =P1 ;
	call (P2 );
	jump.s L$L$14;
L$L$11:
	P2  =[P5 +28];
	R0  =[P5 ];
	call (P2 );
L$L$14:
	R6  =R0 ;
	[P5 +4] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$13;
	P2.L  = _obstack_alloc_failed_handler; P2.H  = _obstack_alloc_failed_handler;
	P2  =[P2 ];
	call (P2 );
L$L$13:
	R0  = 8 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	[P5 +8] =R0 ;
	[P5 +12] =R0 ;
	R0  =[P5 ];
	R0 =R6 +R0 ;
	P2  =R6 ;
	[P2 ] =R0 ;
	[P5 +16] =R0 ;
	R0  = 0 (X);
	[P2 +4] =R0 ;
	R0  = B [P5 +40] (X);
	BITCLR (R0 ,1);
	BITCLR (R0 ,2);
	B [P5 +40] =R0 ;
	R0  = 1 (X);
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global __obstack_newchunk;
.type __obstack_newchunk, STT_FUNC;
__obstack_newchunk:
	LINK 0;
	[--sp] = ( r7:5, p5:3 );
	P5  =R0 ;
	P3  =[P5 +4];
	R0  =[P5 +12];
	R6  =[P5 +8];
	R6  =R0 -R6 ;
	R5 =R6 +R1 ;
	R0  =R6 ;
	R0  >>>=3;
	R5 =R5 +R0 ;
	R0  = 100 (X);
	R0 =R0 +R5 ; //immed->Dreg 
	R5  =R0 ;
	R0  =[P5 ];
	R5  =max(R5 ,R0 );
	R1  = B [P5 +40] (Z);
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$17;
	R0  =[P5 +36];
	P2  =[P5 +28];
	R1  =R5 ;
	call (P2 );
	jump.s L$L$40;
L$L$17:
	P2  =[P5 +28];
	R0  =R5 ;
	call (P2 );
L$L$40:
	P4  =R0 ;
	cc =P4 ==0;
	if cc jump 6; jump.l L$L$19;
	P2.L  = _obstack_alloc_failed_handler; P2.H  = _obstack_alloc_failed_handler;
	P2  =[P2 ];
	call (P2 );
L$L$19:
	[P5 +4] =P4 ;
	[P4 +4] =P3 ;
	R1  =P4 ;
	R5 =R1 +R5 ;
	[P5 +16] =R5 ;
	[P4 ] =R5 ;
	R0  =[P5 +24];
	R0 +=1;
	P1  = 0 (X);
	cc =R0 <=3;
	if !cc jump 6; jump.l L$L$26;
	P1  =R6 ;
	P0  =P1 >>2;
	P0 +=-1;
	cc =P0 <0;
	if !cc jump 6; jump.l L$L$37;
L$L$25:
	P1  =P0 <<2;
	P2 =P1 +P4 ;
	R0  =[P5 +8];
	R1  =P1 ;
	R0 =R1 +R0 ;
	P1  =R0 ;
	R0  =[P1 ];
	[P2 +8] =R0 ;
	P0 +=-1;
	cc =P0 <0;
	if cc jump 6; jump.l L$L$25;
L$L$37:
	P2  =R6 ;
	P1  =P2 >>2;
	P1  =P1 <<2;
L$L$26:
	R0  =P1 ;
	cc =R0 <R6 ;
	if cc jump 6; jump.l L$L$39;
L$L$31:
	P2 =P1 +P4 ;
	R0  =[P5 +8];
	R1  =P1 ;
	R0 =R0 +R1 ;
	P0  =R0 ;
	R0  = B [P0 ] (X);
	B [P2 +8] =R0 ;
	P1 +=1;
	R0  =P1 ;
	cc =R0 <R6 ;
	if !cc jump 6; jump.l L$L$31;
L$L$39:
	R1  =P3 ;
	R1 +=8;
	R0  =[P5 +8];
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$32;
	R0  = B [P5 +40] (Z);
	P0  =R0 ;
	P0  =P0 >>1;
	R0  =P0 ;
	R1  = 1 (X);
	R0  =R0 &R1 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$32;
	P1  =[P3 +4];
	[P4 +4] =P1 ;
	R0  = B [P5 +40] (Z);
	R1  =R0 &R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$34;
	R0  =[P5 +36];
	P2  =[P5 +32];
	R1  =P3 ;
	call (P2 );
	jump.s L$L$32;
L$L$34:
	P2  =[P5 +32];
	R0  =P3 ;
	call (P2 );
L$L$32:
	P4 +=8;
	[P5 +8] =P4 ;
	R0  =P4 ;
	R6 =R6 +R0 ;
	[P5 +12] =R6 ;
	R0  = B [P5 +40] (X);
	BITCLR (R0 ,1);
	B [P5 +40] =R0 ;
	( r7:5, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global __obstack_allocated_p;
.type __obstack_allocated_p, STT_FUNC;
__obstack_allocated_p:
	LINK 0;
	P1  =R0 ;
	P2  =[P1 +4];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$43;
	R0  =P2 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$49;
	R0  =[P2 ];
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$43;
L$L$49:
	P2  =[P2 +4];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$43;
	R0  =P2 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$49;
	R0  =[P2 ];
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$49;
L$L$43:
	R0  = 1 (X);
	cc =P2 ==0;
	if cc R0  =P2 ; /* movsicc-2a */
	UNLINK;
	rts;


.align 2
.global __obstack_free;
.type __obstack_free, STT_FUNC;
__obstack_free:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R1  =[P5 +4];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$59;
	cc =R1 <R6  (iu);
	if cc jump 6; jump.l L$L$62;
	P2  =R1 ;
	R0  =[P2 ];
	cc =R0 <R6  (iu);
	if cc jump 6; jump.l L$L$52;
L$L$62:
	R5  = 1 (X);
L$L$63:
	P2  =R1 ;
	R4  =[P2 +4];
	R0  = B [P5 +40] (Z);
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$56;
	R0  =[P5 +36];
	P2  =[P5 +32];
	call (P2 );
	jump.s L$L$55;
L$L$56:
	P2  =[P5 +32];
	R0  =R1 ;
	call (P2 );
L$L$55:
	R1  =R4 ;
	R0  = B [P5 +40] (X);
	BITSET (R0 ,1);
	B [P5 +40] =R0 ;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$59;
	cc =R4 <R6  (iu);
	if cc jump 6; jump.l L$L$63;
	P2  =R4 ;
	R0  =[P2 ];
	cc =R0 <R6  (iu);
	if !cc jump 6; jump.l L$L$63;
L$L$52:
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$59;
	[P5 +12] =R6 ;
	[P5 +8] =R6 ;
	P2  =R1 ;
	P2  =[P2 ];
	[P5 +16] =P2 ;
	[P5 +4] =R1 ;
	jump.s L$L$50;
L$L$59:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$50;
	call _abort;
L$L$50:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _obstack_free;
.type _obstack_free, STT_FUNC;
_obstack_free:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R1  =[P5 +4];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$73;
	cc =R1 <R6  (iu);
	if cc jump 6; jump.l L$L$76;
	P2  =R1 ;
	R0  =[P2 ];
	cc =R0 <R6  (iu);
	if cc jump 6; jump.l L$L$66;
L$L$76:
	R5  = 1 (X);
L$L$77:
	P2  =R1 ;
	R4  =[P2 +4];
	R0  = B [P5 +40] (Z);
	R0  =R0 &R5 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$70;
	R0  =[P5 +36];
	P2  =[P5 +32];
	call (P2 );
	jump.s L$L$69;
L$L$70:
	P2  =[P5 +32];
	R0  =R1 ;
	call (P2 );
L$L$69:
	R1  =R4 ;
	R0  = B [P5 +40] (X);
	BITSET (R0 ,1);
	B [P5 +40] =R0 ;
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$73;
	cc =R4 <R6  (iu);
	if cc jump 6; jump.l L$L$77;
	P2  =R4 ;
	R0  =[P2 ];
	cc =R0 <R6  (iu);
	if !cc jump 6; jump.l L$L$77;
L$L$66:
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$73;
	[P5 +12] =R6 ;
	[P5 +8] =R6 ;
	P2  =R1 ;
	P2  =[P2 ];
	[P5 +16] =P2 ;
	[P5 +4] =R1 ;
	jump.s L$L$64;
L$L$73:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$64;
	call _abort;
L$L$64:
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global __obstack_memory_used;
.type __obstack_memory_used, STT_FUNC;
__obstack_memory_used:
	LINK 0;
	P2  =R0 ;
	R0  = 0 (X);
	P2  =[P2 +4];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$85;
L$L$83:
	R1  =[P2 ];
	R2  =P2 ;
	R1  =R1 -R2 ;
	R0 =R0 +R1 ;
	P2  =[P2 +4];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$83;
L$L$85:
	UNLINK;
	rts;


.align 2
L$LC$0:
.dw	0x656d;
.dw	0x6f6d;
.dw	0x7972;
.dw	0x6520;
.dw	0x6878;
.dw	0x7561;
.dw	0x7473;
.dw	0x6465;
.db	0x0a;
.db	0x00;
.align 2
.type _print_and_abort, STT_FUNC;
_print_and_abort:
	LINK 0;
	P2.L  = _stderr; P2.H  = _stderr;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R2  = 17 (X);
	R0.L  = L$LC$0; R0.H  = L$LC$0;
	R1  = 1 (X);
	call _fwrite;
	P2.L  = _obstack_exit_failure; P2.H  = _obstack_exit_failure;
	R0  =[P2 ];
	call _exit;
	UNLINK;
	rts;


.global __obstack;
.data;
.align 2
__obstack:.space 4;
