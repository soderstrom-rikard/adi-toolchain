// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "partition.i";
.text;
.align 2
.global _partition_new;
.type _partition_new, STT_FUNC;
_partition_new:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	P2  =P5 +(P5 <<1);
	P2  =P2 <<2;
	R0  =P2 ;
	R0 +=4;
	call _xmalloc;
	P1  =R0 ;
	[P1 ] =P5 ;
	P0  = 0 (X);
	cc =P0 <P5 ;
	if cc jump 6; jump.l L$L$8;
L$L$6:
	P2  =P0 +(P0 <<1);
	P1  =R0 ;
	P2  =P1 +(P2 <<2);
	P1  = 4 (X);
	P1 =P1 +P2 ; //immed->Preg 
	[P1 ] =P0 ;
	[P2 +8] =P1 ;
	R1  = 1 (X);
	[P2 +12] =R1 ;
	P0 +=1;
	cc =P0 <P5 ;
	if !cc jump 6; jump.l L$L$6;
L$L$8:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _partition_delete;
.type _partition_delete, STT_FUNC;
_partition_delete:
	LINK 0;
	call _free;
	UNLINK;
	rts;


.align 2
.global _partition_union;
.type _partition_union, STT_FUNC;
_partition_union:
	LINK 0;
	[--sp] = ( p5:3 );
	P5  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	P0  =R2 ;
	P5 +=4;
	P2  =P4 +(P4 <<1);
	P2  =P5 +(P2 <<2);
	P2  =[P2 ];
	P1  =P0 +(P0 <<1);
	P1  =P5 +(P1 <<2);
	P1  =[P1 ];
	cc =P2 ==P1 ;
	if !cc jump 6; jump.l L$L$10;
	P1  =P4 +(P4 <<1);
	P1  =P5 +(P1 <<2);
	P3  =P0 +(P0 <<1);
	P3  =P5 +(P3 <<2);
	P1  =[P1 +8];
	P3  =[P3 +8];
	cc =P1 <P3  (iu);
	if cc jump 6; jump.l L$L$12;
	P4  =R2 ;
	P0  =R1 ;
	P2  =P4 +(P4 <<1);
	P2  =P5 +(P2 <<2);
	P2  =[P2 ];
L$L$12:
	P4  =P4 +(P4 <<1);
	P4  =P5 +(P4 <<2);
	P0  =P0 +(P0 <<1);
	P0  =P5 +(P0 <<2);
	P3  =P2 +(P2 <<1);
	P3  =P5 +(P3 <<2);
	P1  =[P0 ];
	P1  =P1 +(P1 <<1);
	P5  =P5 +(P1 <<2);
	R0  =[P3 +8];
	P5  =[P5 +8];
	R1  =P5 ;
	R0 =R0 +R1 ;
	[P3 +8] =R0 ;
	[P0 ] =P2 ;
	P1  =[P0 +4];
	cc =P1 ==P0 ;
	if !cc jump 6; jump.l L$L$19;
L$L$17:
	[P1 ] =P2 ;
	P1  =[P1 +4];
	cc =P1 ==P0 ;
	if cc jump 6; jump.l L$L$17;
L$L$19:
	R0  =[P4 +4];
	P1  =[P0 +4];
	[P4 +4] =P1 ;
	[P0 +4] =R0 ;
L$L$10:
	R0  =P2 ;
	( p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _elem_compare, STT_FUNC;
_elem_compare:
	LINK 0;
	P2  =R0 ;
	R3  =[P2 ];
	P2  =R1 ;
	R2  =[P2 ];
	R0  = -1 (X);
	cc =R3 <R2 ;
	if !cc jump 6; jump.l L$L$20;
	R1  = 0 (X);
	R0  = 1 (X);
	cc =R3 <=R2 ;
	if cc R0  =R1 ; /* movsicc-2a */
L$L$20:
	UNLINK;
	rts;


.align 2
L$LC$1:
.dw	0x2520;
.db	0x64;
.db	0x00;
.align 2
L$LC$0:
.dw	0x6425;
.db	0x00;
.align 2
.global _partition_print;
.type _partition_print, STT_FUNC;
_partition_print:
	LINK 12;
	[--sp] = ( r7:4, p5:3 );
	P4  =R0 ;
	R4  =R1 ;
	R0  =[P4 ++];
	[FP +-4] =R0 ;
	call _xmalloc;
	[FP +-8] =R0 ;
	R1  =[FP +-4];
	call _bzero;
	P2  =[FP +-4];
	P2  =P2 <<2;
	R0  =P2 ;
	call _xmalloc;
	P3  =R0 ;
	R0  = 91 (X);
	R1  =R4 ;
	call _fputc;
	R6  = 0 (X);
	P2  =[FP +-4];
	R2  =P2 ;
	cc =R6 <R2 ;
	if cc jump 6; jump.l L$L$45;
L$L$43:
	P2  =[FP +-8];
	P1  =R6 ;
	P2 =P2 +P1 ;
	R0  = B [P2 ] (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$28;
	P5  =P1 +(P1 <<1);
	P5  =P4 +(P5 <<2);
	P5  =[P5 ];
	P5  =P5 +(P5 <<1);
	P5  =P4 +(P5 <<2);
	P5  =[P5 +8];
	P0  = 0 (X);
	cc =P0 <P5 ;
	if cc jump 6; jump.l L$L$47;
	R1.L  = -21845; R1.H  = -21846;
L$L$35:
	P2  =P3 +(P0 <<2);
	[P2 ] =P1 ;
	P2  =[FP +-8];
	P2 =P2 +P1 ;
	R0  = 1 (X);
	B [P2 ] =R0 ;
	P1  =P1 +(P1 <<1);
	P1  =P4 +(P1 <<2);
	R0  =[P1 +4];
	R2  =P4 ;
	R0  =R0 -R2 ;
	R0  >>>=2;
	R0  *=R1 ;
	P1  =R0 ;
	P0 +=1;
	cc =P0 <P5 ;
	if !cc jump 6; jump.l L$L$35;
L$L$47:
	P1.L  = _elem_compare; P1.H  = _elem_compare;
	[SP +12] =P1 ;
	R2  = 4 (X);
	R0  =P3 ;
	R1  =P5 ;
	call _qsort;
	R0  = 40 (X);
	R1  =R4 ;
	call _fputc;
	R5  = 0 (X);
	R0  =P5 ;
	cc =R5 <R0 ;
	if cc jump 6; jump.l L$L$49;
L$L$42:
	[SP +12] =R4 ;
	R1.L  = L$LC$1; R1.H  = L$LC$1;
	R0.L  = L$LC$0; R0.H  = L$LC$0;
	cc =R5 ==0;
	if !cc R0  =R1 ; /* movsicc-1a */
	[SP +16] =R0 ;
	P1  =R5 ;
	P2  =P3 +(P1 <<2);
	P2  =[P2 ];
	[SP +20] =P2 ;
	call _fprintf;
	R5 +=1;
	R0  =P5 ;
	cc =R5 <R0 ;
	if !cc jump 6; jump.l L$L$42;
L$L$49:
	R0  = 41 (X);
	R1  =R4 ;
	call _fputc;
L$L$28:
	R6 +=1;
	P2  =[FP +-4];
	R2  =P2 ;
	cc =R6 <R2 ;
	if !cc jump 6; jump.l L$L$43;
L$L$45:
	R0  = 93 (X);
	R1  =R4 ;
	call _fputc;
	R0  =[FP +-8];
	call _free;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


