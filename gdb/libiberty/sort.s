// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "sort.i";
.text;
.align 2
.global _fn_1;
.type _fn_1, STT_FUNC;
_fn_1:
	LINK 8;
	[--sp] = ( p5:3 );
	P4  =R0 ;
	R3  =R1 ;
	[FP +16] =R2 ;
	R1  =[FP +20];
	P3  =[FP +24];
	P0  =[FP +28];
	P1  =[FP +32];
	P5  =R2 ;
	cc =R2 <R1  (iu);
	if cc jump 6; jump.l L$L$18;
L$L$6:
	R0  = B [P5 ] (Z);
	P2  =R0 ;
	P2  =P3 +(P2 <<2);
	R0  =[P2 ];
	R0 +=1;
	[P2 ] =R0 ;
	P5 +=4;
	R0  =P5 ;
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$6;
L$L$18:
	P2  = 4 (X);
	P2 =P2 +P3 ; //immed->Preg 
	R0  =P3 ;
	R2  = 1024 (X);
	R2 =R2 +R0 ; //immed->Dreg 
	R0  =P2 ;
	cc =R0 <R2  (iu);
	if cc jump 6; jump.l L$L$20;
L$L$11:
	R1  =[P2 ];
	R0  =[P2 +-4];
	R0 =R1 +R0 ;
	[P2 ++] =R0 ;
	R0  =P2 ;
	cc =R0 <R2  (iu);
	if !cc jump 6; jump.l L$L$11;
L$L$20:
	P4  =P0 +(P4 <<2);
	P4 +=-4;
	cc =P4 <P0  (iu);
	if !cc jump 6; jump.l L$L$22;
L$L$16:
	P2  =R3 ;
	P5 =P4 +P2 ;
	R0  = B [P5 ] (Z);
	P5  =R0 ;
	P5  =P3 +(P5 <<2);
	P2  =[P5 ];
	P2 +=-1;
	[P5 ] =P2 ;
	P2  =P1 +(P2 <<2);
	R0  =[P4 --];
	[P2 ] =R0 ;
	cc =P4 <P0  (iu);
	if cc jump 6; jump.l L$L$16;
L$L$22:
	( p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _sort_pointers;
.type _sort_pointers, STT_FUNC;
_sort_pointers:
	LINK 1028;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	P4  =R1 ;
	[FP +16] =R2 ;
	R4  =R2 ;
	R1  = 0 (X);
	R0  = 0 (X);
	cc =R1 <=3 (iu);
	if cc jump 6; jump.l L$L$38;
L$L$29:
	R0  <<=8;
	R0 =R1 +R0 ;
	R1 +=1;
	cc =R1 <=3 (iu);
	if !cc jump 6; jump.l L$L$29;
L$L$38:
	R0  = R0.B  (X);
	cc =R0 ==0;
	R0  =CC ;
	[FP +-1028] =R0 ;
	R5  = 0 (X);
	cc =R5 <=3 (iu);
	if cc jump 6; jump.l L$L$40;
	P5  = -1024 (X);
	P5 =P5 +FP ; //immed->Preg 
L$L$36:
	R6  = 4 (X);
	R6  =R6 -R5 ;
	R0  =[FP +-1028];
	cc =R0 ==0;
	if cc R6  =R5 ; /* movsicc-1b */
	R0  =P5 ;
	R1  = 1024 (X);
	call _bzero;
	P0  =R6 ;
	P1 =P4 +P0 ;
	P2  =P4 +(P3 <<2);
	P2 =P2 +P0 ;
	[SP +12] =P2 ;
	[SP +16] =P5 ;
	[SP +20] =P4 ;
	[SP +24] =R4 ;
	R2  =P1 ;
	R0  =P3 ;
	R1  =R6 ;
	call _fn_1;
	R0  =P4 ;
	P4  =R4 ;
	R4  =R0 ;
	R5 +=1;
	cc =R5 <=3 (iu);
	if !cc jump 6; jump.l L$L$36;
L$L$40:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


