// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "ternary.i";
.text;
.align 2
.global _ternary_insert;
.type _ternary_insert, STT_FUNC;
_ternary_insert:
	LINK 4;
	[--sp] = ( r7:5, p5:5 );
	R5  =R0 ;
	P5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	R2  =[FP +20];
	P1  =R0 ;
	P2  =[P1 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$12;
L$L$11:
	R1  = B [P5 ] (X);
	R0  = B [P2 ] (X);
	R0  =R1 -R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$5;
	R0  = B [P5 ++] (X);
	R5  =P2 ;
	R5 +=8;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2;
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$7;
	[P2 +8] =R6 ;
L$L$7:
	R0  =[P2 +8];
	jump.s L$L$1;
L$L$5:
	R5  =P2 ;
	R5 +=4;
	P2 +=12;
	cc =R0 <0;
	if !cc R5  =P2 ; /* movsicc-1a */
L$L$2:
	P1  =R5 ;
	P2  =[P1 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$11;
L$L$12:
	R0  = 16 (X);
	call _xmalloc;
	P2  =R5 ;
	[P2 ] =R0 ;
	R1  = B [P5 ] (X);
	P1  =R0 ;
	B [P1 ] =R1 ;
	P2  = 0 (X);
	[P1 +8] =P2 ;
	[P1 +12] =P2 ;
	[P1 +4] =P2 ;
	R1  = B [P5 ++] (X);
	R5  = 8 (X);
	R5 =R5 +R0 ; //immed->Dreg 
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$12;
	[P1 +8] =R6 ;
	R0  =R6 ;
L$L$1:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _ternary_cleanup;
.type _ternary_cleanup, STT_FUNC;
_ternary_cleanup:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$17;
	R0  =[P5 +4];
	call _ternary_cleanup;
	R0  = B [P5 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$19;
	R0  =[P5 +8];
	call _ternary_cleanup;
L$L$19:
	R0  =[P5 +12];
	call _ternary_cleanup;
	R0  =P5 ;
	call _free;
L$L$17:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _ternary_search;
.type _ternary_search, STT_FUNC;
_ternary_search:
	LINK 0;
	P2  =R1 ;
	R3  = B [P2 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$31;
L$L$29:
	P2  =R0 ;
	R2  = B [P2 ] (X);
	R2  =R3 -R2 ;
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$24;
	cc =R3 ==0;
	if cc jump 6; jump.l L$L$25;
	R0  =[P2 +8];
	jump.s L$L$20;
L$L$25:
	R1 +=1;
	P2  =R1 ;
	R3  = B [P2 ] (X);
	P2  =R0 ;
	R0  =[P2 +8];
	jump.s L$L$21;
L$L$24:
	cc =R2 <0;
	if cc jump 6; jump.l L$L$27;
	P2  =R0 ;
	R0  =[P2 +4];
	jump.s L$L$21;
L$L$27:
	P2  =R0 ;
	R0  =[P2 +12];
L$L$21:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$29;
L$L$31:
	R0  = 0 (X);
L$L$20:
	UNLINK;
	rts;


.align 2
.type _ternary_recursivesearch, STT_FUNC;
_ternary_recursivesearch:
	LINK 0;
	P2  =R0 ;
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$32;
	P1  =R1 ;
	R2  = B [P1 ] (X);
	R0  = B [P2 ] (X);
	cc =R2 <R0 ;
	if cc jump 6; jump.l L$L$34;
	R0  =[P2 +4];
	jump.s L$L$39;
L$L$34:
	P1  =R1 ;
	R2  = B [P1 ] (X);
	R0  = B [P2 ] (X);
	cc =R2 <=R0 ;
	if !cc jump 6; jump.l L$L$36;
	R0  =[P2 +12];
	jump.s L$L$39;
L$L$36:
	P1  =R1 ;
	R0  = B [P1 ] (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$38;
	R0  =[P2 +8];
	jump.s L$L$32;
L$L$38:
	R0  =[P2 +8];
	R1 +=1;
L$L$39:
	call _ternary_recursivesearch;
L$L$32:
	UNLINK;
	rts;


