// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "mm.i";
.text;
.align 2
.global _mcalloc;
.type _mcalloc, STT_FUNC;
_mcalloc:
	LINK 0;
	[--sp] = ( r7:5 );
	[FP +16] =R2 ;
	R6  =R2 ;
	R6  *=R1 ;
	R1  =R6 ;
	call _mmalloc;
	R5  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$2;
	R1  =R6 ;
	call _bzero;
L$L$2:
	R0  =R5 ;
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _calloc;
.type _calloc, STT_FUNC;
_calloc:
	LINK 0;
	R3  =R0 ;
	R2  =R1 ;
	R0  = 0 (X);
	R1  =R3 ;
	call _mcalloc;
	UNLINK;
	rts;


.align 2
.global ___mmalloc_free;
.type ___mmalloc_free, STT_FUNC;
___mmalloc_free:
	LINK 8;
	[--sp] = ( r7:4, p5:3 );
	P5  =R0 ;
	R6  =R1 ;
	P4  =[P5 +48];
	R0  =P4 ;
	R0  =R1 -R0 ;
	R0  >>=12;
	P4  =R0 ;
	P4 +=1;
	P2  =[P5 +60];
	P1  =P4 +(P4 <<1);
	P2  =P2 +(P1 <<2);
	R1  =[P2 ];
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$22;
	R0  =[P5 +68];
	R0 +=-1;
	[P5 +68] =R0 ;
	R1  =[P2 +4];
	R1  <<=12;
	R0  =[P5 +72];
	R0  =R0 -R1 ;
	[P5 +72] =R0 ;
	P2  =[P2 +4];
	R1  =P2 ;
	R1  <<=12;
	R0  =[P5 +80];
	R0 =R1 +R0 ;
	[P5 +80] =R0 ;
	P0  =[P5 +52];
	cc =P0 <=P4  (iu);
	if !cc jump 6; jump.l L$L$7;
	P2  =[P5 +60];
L$L$11:
	P0  =P0 +(P0 <<1);
	P0  =P2 +(P0 <<2);
	P0  =[P0 +8];
	cc =P0 <=P4  (iu);
	if cc jump 6; jump.l L$L$11;
	jump.s L$L$12;
L$L$7:
	P2  =[P5 +60];
L$L$13:
	P0  =P0 +(P0 <<1);
	P0  =P2 +(P0 <<2);
	P0  =[P0 +4];
	cc =P0 ==0;
	if !cc jump 6; jump.l L$L$14;
	cc =P0 <P4  (iu);
	if !cc jump 6; jump.l L$L$13;
L$L$14:
	P2  =[P5 +60];
	P0  =P0 +(P0 <<1);
	P0  =P2 +(P0 <<2);
	P0  =[P0 +8];
L$L$12:
	P1  =[P5 +60];
	P2  =P0 +(P0 <<1);
	P2  =P1 +(P2 <<2);
	R1  =[P2 ];
	R2  =P0 ;
	R0 =R2 +R1 ;
	R4  =P4 ;
	cc =R4 ==R0 ;
	if cc jump 6; jump.l L$L$18;
	P4  =P4 +(P4 <<1);
	P1  =P1 +(P4 <<2);
	P1  =[P1 +4];
	R0  =P1 ;
	R1 =R1 +R0 ;
	[P2 ] =R1 ;
	P4  =P0 ;
	jump.s L$L$19;
L$L$18:
	R0  =[P5 +60];
	P1  =P4 +(P4 <<1);
	P1  =P1 <<2;
	R1  =P1 ;
	R0 =R1 +R0 ;
	P2  =R0 ;
	P3  =[P2 +4];
	[P2 ] =P3 ;
	R0  =[P5 +60];
	P2  =R0 ;
	P2 =P1 +P2 ;
	[FP +-4] =P2 ;
	P2  =P0 +(P0 <<1);
	P2  =P2 <<2;
	R1  =P2 ;
	R0 =R1 +R0 ;
	P3  =R0 ;
	R0  =[P3 +4];
	P3  =[FP +-4];
	[P3 +4] =R0 ;
	R0  =[P5 +60];
	R1  =P1 ;
	R0 =R1 +R0 ;
	P3  =R0 ;
	[P3 +8] =P0 ;
	R0  =[P5 +60];
	P0  =R0 ;
	P2 =P2 +P0 ;
	[P2 +4] =P4 ;
	P2  =[P5 +60];
	P1 =P1 +P2 ;
	P1  =[P1 +4];
	P1  =P1 +(P1 <<1);
	P2  =P2 +(P1 <<2);
	[P2 +8] =P4 ;
	R0  =[P5 +76];
	R0 +=1;
	[P5 +76] =R0 ;
L$L$19:
	P0  =[P5 +60];
	P1  =P4 +(P4 <<1);
	P1  =P1 <<2;
	P3 =P1 +P0 ;
	R1  =[P3 ];
	P2  =R1 ;
	P2 =P4 +P2 ;
	[FP +-8] =P2 ;
	R0  =[P3 +4];
	R2  =P2 ;
	cc =R2 ==R0 ;
	if cc jump 6; jump.l L$L$20;
	P2  =P2 +(P2 <<1);
	P0  =P0 +(P2 <<2);
	P0  =[P0 ];
	R0  =P0 ;
	R1 =R1 +R0 ;
	[P3 ] =R1 ;
	P3  =[P5 +60];
	P0 =P1 +P3 ;
	P2  =[P0 +4];
	P2  =P2 +(P2 <<1);
	P3  =P3 +(P2 <<2);
	P3  =[P3 +4];
	[P0 +4] =P3 ;
	P2  =[P5 +60];
	P1 =P1 +P2 ;
	P1  =[P1 +4];
	P1  =P1 +(P1 <<1);
	P2  =P2 +(P1 <<2);
	[P2 +8] =P4 ;
	R0  =[P5 +76];
	R0 +=-1;
	[P5 +76] =R0 ;
L$L$20:
	R5  =[P5 +60];
	P3  =P4 +(P4 <<1);
	P3  =P3 <<2;
	R1  =P3 ;
	R5 =R1 +R5 ;
	P0  =R5 ;
	R5  =[P0 ];
	cc =R5 <=7 (iu);
	if !cc jump 6; jump.l L$L$21;
	R0  =P4 ;
	R6 =R0 +R5 ;
	R0  =[P5 +56];
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$21;
	P2  =[P5 +24];
	R0  =P5 ;
	R1  = 0 (X);
	call (P2 );
	R6  <<=12;
	R1  =[P5 +48];
	R1 =R6 +R1 ;
	R2  = -4096 (X);
	R2 =R2 +R1 ; //immed->Dreg 
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$21;
	R6  =R5 ;
	R6  <<=12;
	R0  =[P5 +56];
	R5  =R0 -R5 ;
	[P5 +56] =R5 ;
	R1  =-R6 ;
	P2  =[P5 +24];
	R0  =P5 ;
	call (P2 );
	P0  =[P5 +60];
	P1 =P3 +P0 ;
	P2  =[P1 +8];
	P2  =P2 +(P2 <<1);
	P0  =P0 +(P2 <<2);
	P1  =[P1 +4];
	[P0 +4] =P1 ;
	P0  =[P5 +60];
	P1 =P3 +P0 ;
	P2  =[P1 +4];
	P2  =P2 +(P2 <<1);
	P0  =P0 +(P2 <<2);
	P1  =[P1 +8];
	[P0 +8] =P1 ;
	P4  =[P5 +60];
	P4 =P3 +P4 ;
	P4  =[P4 +8];
	R0  =[P5 +76];
	R0 +=-1;
	[P5 +76] =R0 ;
	R0  =[P5 +80];
	R6  =R0 -R6 ;
	[P5 +80] =R6 ;
L$L$21:
	[P5 +52] =P4 ;
	jump.s L$L$4;
L$L$22:
	R0  =[P5 +68];
	R0 +=-1;
	[P5 +68] =R0 ;
	R2  = 1 (X);
	R2  <<=R1 ;
	R0  =[P5 +72];
	R0  =R0 -R2 ;
	[P5 +72] =R0 ;
	R0  =[P5 +76];
	R0 +=1;
	[P5 +76] =R0 ;
	R0  =[P5 +80];
	R2 =R2 +R0 ;
	[P5 +80] =R2 ;
	R0  =P4 ;
	R0  <<=12;
	R2  =[P5 +48];
	R2 =R0 +R2 ;
	P2  =[P5 +60];
	P1  =P4 +(P4 <<1);
	P2  =P2 +(P1 <<2);
	R0  =[P2 +8];
	R0  <<=R1 ;
	R2 =R2 +R0 ;
	R4  = -4096 (X);
	R4 =R4 +R2 ; //immed->Dreg 
	R2  =R4 ;
	R5  = 4096 (X);
	R3  =R5 ;
	R3  >>=R1 ;
	R0  = -1 (X);
	R0 =R0 +R3 ; //immed->Dreg 
	P2  =[P2 +4];
	R4  =P2 ;
	cc =R4 ==R0 ;
	if cc jump 6; jump.l L$L$23;
	P1  =R2 ;
	P2  = 1 (X);
	R0  =P2 ;
	cc =R0 <R3  (iu);
	if cc jump 6; jump.l L$L$39;
	R5  =R3 ;
L$L$28:
	P1  =[P1 ];
	P2 +=1;
	R4  =P2 ;
	cc =R4 <R5  (iu);
	if !cc jump 6; jump.l L$L$28;
L$L$39:
	P0  =R2 ;
	R2  =[P0 +4];
	P2  =R2 ;
	[P2 ] =P1 ;
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$29;
	[P1 +4] =R2 ;
L$L$29:
	R0  =[P5 +60];
	P2  =P4 +(P4 <<1);
	P2  =P2 <<2;
	R2  =P2 ;
	R0 =R2 +R0 ;
	P1  = 0 (X);
	P0  =R0 ;
	[P0 ] =P1 ;
	R0  =[P5 +60];
	P3  =R0 ;
	P2 =P2 +P3 ;
	R0  = 1 (X);
	[P2 +4] =R0 ;
	R0  =[P5 +68];
	R0 +=1;
	[P5 +68] =R0 ;
	R0  =[P5 +72];
	R2  = 4096 (X);
	R2 =R2 +R0 ; //immed->Dreg 
	[P5 +72] =R2 ;
	R0  = 4096 (X);
	R0  >>=R1 ;
	R1  =R0 ;
	R0  =[P5 +76];
	R1  =R0 -R1 ;
	[P5 +76] =R1 ;
	R0  =[P5 +80];
	R4  = -4096 (X);
	R4 =R4 +R0 ; //immed->Dreg 
	[P5 +80] =R4 ;
	R0  =P4 ;
	R0  <<=12;
	P4  =R0 ;
	R0  =[P5 +48];
	R1  =P4 ;
	R0 =R1 +R0 ;
	R1  = -4096 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  =P5 ;
	call _mfree;
	jump.s L$L$4;
L$L$23:
	P1  =[P5 +60];
	P2  =P4 +(P4 <<1);
	P1  =P1 +(P2 <<2);
	P1  =[P1 +4];
	cc =P1 ==0;
	if !cc jump 6; jump.l L$L$31;
	P0  =R2 ;
	P1  =[P0 ];
	P0  =R6 ;
	[P0 ] =P1 ;
	[P0 +4] =R2 ;
	P2  =R2 ;
	[P2 ] =R6 ;
	P2  =[P0 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$32;
	[P2 +4] =R6 ;
L$L$32:
	P5  =[P5 +60];
	P4  =P4 +(P4 <<1);
	P5  =P5 +(P4 <<2);
	R0  =[P5 +4];
	R0 +=1;
	[P5 +4] =R0 ;
	jump.s L$L$4;
L$L$31:
	R0  =[P5 +60];
	P4  =P4 +(P4 <<1);
	P4  =P4 <<2;
	R2  =P4 ;
	R0 =R2 +R0 ;
	P1  = 1 (X);
	P0  =R0 ;
	[P0 +4] =P1 ;
	R0  =[P5 +60];
	P2  =R0 ;
	P4 =P4 +P2 ;
	R0  = 4095 (X);
	R0  =R6 &R0 ;
	R0  >>=R1 ;
	[P4 +8] =R0 ;
	R1  <<=3;
	P3  =R1 ;
	P5 =P3 +P5 ;
	P0  = 84 (X);
	P0 =P0 +P5 ; //immed->Preg 
	P2  =[P0 ];
	P1  =R6 ;
	[P1 ] =P2 ;
	[P1 +4] =P0 ;
	[P0 ] =R6 ;
	P2  =[P1 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$4;
	[P2 +4] =R6 ;
L$L$4:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _mfree;
.type _mfree, STT_FUNC;
_mfree:
	LINK 0;
	[--sp] = ( r7:5 );
	R5  =R0 ;
	R6  =R1 ;
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$40;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$42;
	P2.L  = ___mmalloc_default_mdp; P2.H  = ___mmalloc_default_mdp;
	R0  =[P2 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$42;
	call ___mmalloc_sbrk_init;
L$L$42:
	P1  =R0 ;
	P2  =[P1 +180];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$45;
L$L$49:
	R1  =[P2 +4];
	cc =R1 ==R6 ;
	if !cc jump 6; jump.l L$L$53;
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$49;
L$L$45:
	P1  =R0 ;
	P2  =[P1 +32];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$50;
	R0  =R5 ;
	R1  =R6 ;
	call (P2 );
	jump.s L$L$40;
L$L$53:
	R1  = 0 (X);
	[P2 +4] =R1 ;
	R6  =[P2 +8];
	jump.s L$L$45;
L$L$50:
	R1  =R6 ;
	call ___mmalloc_free;
L$L$40:
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _free;
.type _free, STT_FUNC;
_free:
	LINK 0;
	R1  =R0 ;
	R0  = 0 (X);
	call _mfree;
	UNLINK;
	rts;


.align 2
.type _align, STT_FUNC;
_align:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	P5  =R0 ;
	P2  =[P5 +24];
	call (P2 );
	R5  =R0 ;
	R6  = 4095 (X);
	R6  =R0 &R6 ;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$56;
	I0  = 4096 (X);
	R0  =I0 ;
	R6  =R0 -R6 ;
	P2  =[P5 +24];
	R0  =P5 ;
	R1  =R6 ;
	call (P2 );
	R5 =R5 +R6 ;
L$L$56:
	R0  =R5 ;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _initialize, STT_FUNC;
_initialize:
	LINK 0;
	[--sp] = ( p5:5 );
	P5  =R0 ;
	R0  = 1024 (X);
	[P5 +44] =R0 ;
	R1  = 12288 (X);
	R0  =P5 ;
	call _align;
	R1  =R0 ;
	[P5 +60] =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$57;
	P2  =[P5 +44];
	P2  =P2 +(P2 <<1);
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =[P5 +60];
	call _bzero;
	P2  =[P5 +60];
	R2  = 0 (X);
	[P2 ] =R2 ;
	P2  =[P5 +60];
	[P2 +8] =R2 ;
	[P2 +4] =R2 ;
	[P5 +52] =R2 ;
	R2  =[P5 +60];
	[P5 +48] =R2 ;
	R0  =[P5 +16];
	BITSET (R0 ,1);
	[P5 +16] =R0 ;
	R0  = 1 (X);
L$L$57:
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _morecore, STT_FUNC;
_morecore:
	LINK 0;
	[--sp] = ( r7:4, p5:4 );
	P4  =R0 ;
	R4  =R1 ;
	call _align;
	R5  =R0 ;
	R0  = 0 (X);
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$59;
	R1 =R5 +R4 ;
	R2  =[P4 +48];
	R0  =R1 -R2 ;
	R0  >>=12;
	R0 +=1;
	R6  =[P4 +44];
	cc =R0 <=R6  (iu);
	if !cc jump 6; jump.l L$L$61;
	R2  =R0 ;
L$L$65:
	P0  =R6 ;
	P0  =P0 +P0 ;
	R6  =P0 ;
	cc =R2 <=R6  (iu);
	if cc jump 6; jump.l L$L$65;
	P2  =P0 +(P0 <<1);
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =P4 ;
	call _align;
	P5  =R0 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$66;
	R1  =-R4 ;
	P2  =[P4 +24];
	R0  =P4 ;
	call (P2 );
	R0  = 0 (X);
	jump.s L$L$59;
L$L$66:
	P1  =R6 ;
	P2  =P1 +(P1 <<1);
	P2  =P2 <<2;
	R1  =P2 ;
	call _bzero;
	P2  =[P4 +44];
	P2  =P2 +(P2 <<1);
	P2  =P2 <<2;
	R2  =P2 ;
	R0  =[P4 +60];
	R1  =P5 ;
	call _bcopy;
	R1  =[P4 +60];
	R0  =[P4 +48];
	R0  =R1 -R0 ;
	R0  >>=12;
	P2  =R0 ;
	P2  =P2 +(P2 <<1);
	P2  =P5 +(P2 <<2);
	R3  = 0 (X);
	[P2 +12] =R3 ;
	R0  =[P4 +48];
	R0  =R1 -R0 ;
	R0  >>=12;
	P1  =R0 ;
	P1  =P1 +(P1 <<1);
	P1  =P5 +(P1 <<2);
	P2  =[P4 +44];
	P2  =P2 +(P2 <<1);
	P2  =P2 <<2;
	P0  = 4095 (X);
	P0 =P0 +P2 ; //immed->Preg 
	R3  =P0 ;
	R3  >>=12;
	[P1 +16] =R3 ;
	[P4 +60] =P5 ;
	R0  =P4 ;
	call ___mmalloc_free;
	[P4 +44] =R6 ;
L$L$61:
	R4 =R5 +R4 ;
	R0  =[P4 +48];
	R0  =R4 -R0 ;
	R0  >>=12;
	R0 +=1;
	[P4 +56] =R0 ;
	R0  =R5 ;
L$L$59:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _mmalloc;
.type _mmalloc, STT_FUNC;
_mmalloc:
	LINK 12;
	[--sp] = ( r7:4, p5:3 );
	R5  =R0 ;
	P5  =R1 ;
	R2  = 0 (X);
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$69;
	P3  =R0 ;
	cc =P3 ==0;
	if cc jump 6; jump.l L$L$71;
	P3.L  = ___mmalloc_default_mdp; P3.H  = ___mmalloc_default_mdp;
	P3  =[P3 ];
	cc =P3 ==0;
	if cc jump 6; jump.l L$L$71;
	call ___mmalloc_sbrk_init;
	P3  =R0 ;
L$L$71:
	P2  =[P3 +36];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$73;
	R0  =R5 ;
	R1  =P5 ;
	call (P2 );
	jump.s L$L$110;
L$L$73:
	R1  =[P3 +16];
	R0  = 2 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$74;
	R0  =P3 ;
	call _initialize;
	R2  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$69;
L$L$74:
	R0  = 8 (X);
	cc =P5 <=7 (iu);
	if cc P5  =R0 ; /* movsicc-1b */
	P0  = 2048 (X);
	cc =P5 <=P0  (iu);
	if cc jump 6; jump.l L$L$77;
	R6  = 1 (X);
	P5 +=-1;
	P5  =P5 >>1;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$104;
L$L$81:
	R6 +=1;
	P5  =P5 >>1;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$81;
L$L$104:
	R1  =R6 ;
	R1  <<=3;
	R0  =P3 ;
	R1 =R1 +R0 ;
	P0  =R1 ;
	R1  =[P0 +84];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$82;
	P2  =R1 ;
	P1  =[P2 +4];
	P4  =[P2 ];
	[P1 ] =P4 ;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$83;
	[P2 +4] =P1 ;
L$L$83:
	P2  =[P3 +48];
	R0  =P2 ;
	R0  =R1 -R0 ;
	R0  >>=12;
	P2  =R0 ;
	P2 +=1;
	R2  =[P3 +60];
	P2  =P2 +(P2 <<1);
	P2  =P2 <<2;
	R3  =P2 ;
	R2 =R3 +R2 ;
	P0  =R2 ;
	R0  =[P0 +4];
	R0 +=-1;
	[P0 +4] =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$84;
	R0  =[P3 +60];
	P1  =R0 ;
	P2 =P2 +P1 ;
	P4  =R1 ;
	R2  =[P4 ];
	R0  = 4095 (X);
	R0  =R2 &R0 ;
	R0  >>=R6 ;
	[P2 +8] =R0 ;
L$L$84:
	R0  =[P3 +68];
	R0 +=1;
	[P3 +68] =R0 ;
	R0  = 1 (X);
	R0  <<=R6 ;
	R6  =R0 ;
	R0  =[P3 +72];
	R0 =R6 +R0 ;
	[P3 +72] =R0 ;
	R0  =[P3 +76];
	R0 +=-1;
	[P3 +76] =R0 ;
	R0  =[P3 +80];
	R6  =R0 -R6 ;
	[P3 +80] =R6 ;
	jump.s L$L$93;
L$L$82:
	R0  =R5 ;
	R1  = 4096 (X);
	call _mmalloc;
	R1  =R0 ;
	R2  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$69;
	R5  = 1 (X);
	R0  = 4096 (X);
	R0  >>=R6 ;
	cc =R5 <R0  (iu);
	if cc jump 6; jump.l L$L$106;
	R3  =R6 ;
	R3  <<=3;
	R0  =P3 ;
	R3 =R3 +R0 ;
	R2  = 84 (X);
	R2 =R2 +R3 ; //immed->Dreg 
	R3  =R2 ;
	R2  = 4096 (X);
	R2  >>=R6 ;
L$L$92:
	R0  =R5 ;
	R0  <<=R6 ;
	R0 =R1 +R0 ;
	P0  =R3 ;
	P1  =[P0 ];
	P0  =R0 ;
	[P0 ] =P1 ;
	[P0 +4] =R3 ;
	P2  =R3 ;
	[P2 ] =R0 ;
	P2  =[P0 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$89;
	[P2 +4] =R0 ;
L$L$89:
	R5 +=1;
	cc =R5 <R2  (iu);
	if !cc jump 6; jump.l L$L$92;
L$L$106:
	P2  =[P3 +48];
	R0  =P2 ;
	R0  =R1 -R0 ;
	R0  >>=12;
	P2  =R0 ;
	P2 +=1;
	R0  =[P3 +60];
	P2  =P2 +(P2 <<1);
	P2  =P2 <<2;
	R2  =P2 ;
	R0 =R2 +R0 ;
	P0  =R0 ;
	[P0 ] =R6 ;
	R0  =[P3 +60];
	R0 =R2 +R0 ;
	R5 +=-1;
	P1  =R0 ;
	[P1 +4] =R5 ;
	R0  =[P3 +60];
	P4  =R0 ;
	P2 =P2 +P4 ;
	[P2 +8] =R5 ;
	R2  = 4096 (X);
	R2  >>=R6 ;
	R0  =[P3 +76];
	R0 =R2 +R0 ;
	R0 +=-1;
	[P3 +76] =R0 ;
	R0  = 1 (X);
	R0  <<=R6 ;
	R6  =R0 ;
	R0  =[P3 +80];
	R0  =R0 -R6 ;
	R2  = 4096 (X);
	R2 =R2 +R0 ; //immed->Dreg 
	[P3 +80] =R2 ;
	R0  =[P3 +72];
	R6 =R6 +R0 ;
	R3  = -4096 (X);
	R3 =R3 +R6 ; //immed->Dreg 
	[P3 +72] =R3 ;
	jump.s L$L$93;
L$L$77:
	P0  = 4095 (X);
	P0 =P0 +P5 ; //immed->Preg 
	R0  =P0 ;
	R0  >>=12;
	P5  =R0 ;
	P0  =[P3 +52];
	R6  =P0 ;
	P4  =[P3 +60];
	P2  =P0 +P0 ;
	R0  =P2 ;
	R0  = (R0  + R6 ) << 2;
	R1  =P4 ;
	R0 =R0 +R1 ;
	P1  =R0 ;
	R0  =[P1 ];
	R1  =P5 ;
	cc =R0 <R1  (iu);
	if cc jump 6; jump.l L$L$108;
L$L$100:
	P0  = (P0  + P2 ) << 2;
	P0 =P0 +P4 ;
	P0  =[P0 +4];
	R2  =P0 ;
	cc =R2 ==R6 ;
	if cc jump 6; jump.l L$L$94;
	R5  =[P4 +8];
	P0  =R5 ;
	P2  =P0 +(P0 <<1);
	P4  =P4 +(P2 <<2);
	P4  =[P4 ];
	R0  =[P3 +56];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$98;
	R1  =P4 ;
	R5 =R5 +R1 ;
	cc =R5 ==R0 ;
	if cc jump 6; jump.l L$L$98;
	P2  =[P3 +24];
	R0  =P3 ;
	R1  = 0 (X);
	call (P2 );
	R5  <<=12;
	R1  =[P3 +48];
	R1 =R5 +R1 ;
	R2  = -4096 (X);
	R2 =R2 +R1 ; //immed->Dreg 
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$98;
	R3  =P5 ;
	R4  =P4 ;
	R3  =R3 -R4 ;
	P4  =R3 ;
	R5  =R3 ;
	R5  <<=12;
	R0  =P3 ;
	R1  =R5 ;
	call _morecore;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$98;
	P1  =[P3 +60];
	P0  =[P1 +8];
	P2  =P0 +(P0 <<1);
	P1  =P1 +(P2 <<2);
	R0  =[P1 ];
	P2  =R0 ;
	P4 =P4 +P2 ;
	[P1 ] =P4 ;
	R0  =[P3 +80];
	R5 =R5 +R0 ;
	[P3 +80] =R5 ;
	jump.s L$L$94;
L$L$98:
	R0  =P3 ;
	R1  =P5 ;
	R1  <<=12;
	call _morecore;
	R2  = 0 (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$69;
	P2  =[P3 +48];
	R1  =P2 ;
	R1  =R0 -R1 ;
	R1  >>=12;
	P2  =R1 ;
	P2 +=1;
	R1  =[P3 +60];
	P2  =P2 +(P2 <<1);
	P2  =P2 <<2;
	R2  =P2 ;
	R1 =R2 +R1 ;
	P1  = 0 (X);
	P0  =R1 ;
	[P0 ] =P1 ;
	R1  =[P3 +60];
	P4  =R1 ;
	P2 =P2 +P4 ;
	[P2 +4] =P5 ;
	R1  =[P3 +68];
	R1 +=1;
	[P3 +68] =R1 ;
	R1  =P5 ;
	R1  <<=12;
	P5  =R1 ;
	R1  =[P3 +72];
	R2  =P5 ;
	R1 =R2 +R1 ;
	[P3 +72] =R1 ;
L$L$110:
	R2  =R0 ;
	jump.s L$L$69;
L$L$94:
	P4  =[P3 +60];
	P2  =P0 +P0 ;
	R0  =P2 ;
	R3  =P0 ;
	R0  = (R0  + R3 ) << 2;
	R4  =P4 ;
	R0 =R0 +R4 ;
	P1  =R0 ;
	R0  =[P1 ];
	R1  =P5 ;
	cc =R0 <R1  (iu);
	if !cc jump 6; jump.l L$L$100;
L$L$108:
	R0  =P0 ;
	R0  <<=12;
	R1  =[P3 +48];
	R1 =R0 +R1 ;
	R2  = -4096 (X);
	R2 =R2 +R1 ; //immed->Dreg 
	R1  =R2 ;
	R0  =[P3 +60];
	P2  =P0 +(P0 <<1);
	P2  =P2 <<2;
	P1  =R0 ;
	P4 =P2 +P1 ;
	P4  =[P4 ];
	cc =P4 <=P5  (iu);
	if !cc jump 6; jump.l L$L$101;
	P1 =P0 +P5 ;
	R2  =P1 ;
	P1  =P1 +(P1 <<1);
	P1  =P1 <<2;
	[FP +-4] =P1 ;
	R3  =P1 ;
	R0 =R3 +R0 ;
	R4  =P4 ;
	R6  =P5 ;
	R4  =R4 -R6 ;
	P1  =R0 ;
	[P1 ] =R4 ;
	R0  =[P3 +60];
	P1  =R0 ;
	P4  =[FP +-4];
	P1 =P4 +P1 ;
	[FP +-12] =P1 ;
	R3  =P2 ;
	R0 =R3 +R0 ;
	P1  =R0 ;
	R0  =[P1 +4];
	P1  =[FP +-12];
	[P1 +4] =R0 ;
	R0  =[P3 +60];
	P1  =R0 ;
	P4 =P4 +P1 ;
	[FP +-4] =P4 ;
	R0 =R3 +R0 ;
	P4  =R0 ;
	R0  =[P4 +8];
	P4  =[FP +-4];
	[P4 +8] =R0 ;
	P1  =[P3 +60];
	P2 =P2 +P1 ;
	P4  =[P2 +8];
	P4  =P4 +(P4 <<1);
	P4  =P1 +(P4 <<2);
	P2  =[P2 +4];
	P2  =P2 +(P2 <<1);
	P1  =P1 +(P2 <<2);
	[P3 +52] =R2 ;
	[P1 +8] =R2 ;
	[P4 +4] =R2 ;
	jump.s L$L$102;
L$L$101:
	P4  =[P3 +60];
	P1  =P0 +(P0 <<1);
	P1  =P1 <<2;
	P2 =P1 +P4 ;
	R0  =P2 ;
	R2  =[P2 +4];
	[FP +-8] =R2 ;
	P2  =R2 ;
	P2  =P2 +(P2 <<1);
	P4  =P4 +(P2 <<2);
	P2  =R0 ;
	R0  =[P2 +8];
	[P4 +8] =R0 ;
	P4  =[P3 +60];
	P1 =P1 +P4 ;
	P2  =[P1 +8];
	P2  =P2 +(P2 <<1);
	P4  =P4 +(P2 <<2);
	P1  =[P1 +4];
	[P3 +52] =P1 ;
	[P4 +4] =P1 ;
	R0  =[P3 +76];
	R0 +=-1;
	[P3 +76] =R0 ;
L$L$102:
	R0  =[P3 +60];
	P0  =P0 +(P0 <<1);
	P0  =P0 <<2;
	R2  =P0 ;
	R0 =R2 +R0 ;
	P2  = 0 (X);
	P1  =R0 ;
	[P1 ] =P2 ;
	R0  =[P3 +60];
	P4  =R0 ;
	P0 =P0 +P4 ;
	[P0 +4] =P5 ;
	R0  =[P3 +68];
	R0 +=1;
	[P3 +68] =R0 ;
	R0  =P5 ;
	R0  <<=12;
	P5  =R0 ;
	R0  =[P3 +72];
	R2  =P5 ;
	R0 =R2 +R0 ;
	[P3 +72] =R0 ;
	R0  =[P3 +80];
	R2  =R0 -R2 ;
	[P3 +80] =R2 ;
L$L$93:
	R2  =R1 ;
L$L$69:
	R0  =R2 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _malloc;
.type _malloc, STT_FUNC;
_malloc:
	LINK 0;
	R1  =R0 ;
	R0  = 0 (X);
	call _mmalloc;
	UNLINK;
	rts;


.align 2
.type _checkhdr, STT_FUNC;
_checkhdr:
	LINK 0;
	P1  =R1 ;
	R2  =[P1 +4];
	R3.L  = -16661; R3.H  = -294;
	cc =R2 ==R3 ;
	if cc jump 6; jump.l L$L$114;
	R2  =[P1 ];
	R2 =R1 +R2 ;
	P1  =R2 ;
	R2  = B [P1 +8] (X);
	R3  = -41 (X);
	cc =R2 ==R3 ;
	if !cc jump 6; jump.l L$L$112;
L$L$114:
	P1  =R0 ;
	P2  =[P1 +28];
	call (P2 );
L$L$112:
	UNLINK;
	rts;


.align 2
.type _mfree_check, STT_FUNC;
_mfree_check:
	LINK 0;
	[--sp] = ( r7:6, p5:4 );
	R6  =R0 ;
	P4  =R1 ;
	P4 +=-8;
	P5  =R0 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$116;
	P5.L  = ___mmalloc_default_mdp; P5.H  = ___mmalloc_default_mdp;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$116;
	call ___mmalloc_sbrk_init;
	P5  =R0 ;
L$L$116:
	R0  =P5 ;
	R1  =P4 ;
	call _checkhdr;
	R0.L  = -16657; R0.H  = -8531;
	[P4 +4] =R0 ;
	R0  = 0 (X);
	[P5 +32] =R0 ;
	R0  =R6 ;
	R1  =P4 ;
	call _mfree;
	R0.L  = _mfree_check; R0.H  = _mfree_check;
	[P5 +32] =R0 ;
	( r7:6, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _mmalloc_check, STT_FUNC;
_mmalloc_check:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	R5  =R0 ;
	R6  =R1 ;
	P5  =R0 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$119;
	P5.L  = ___mmalloc_default_mdp; P5.H  = ___mmalloc_default_mdp;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$119;
	call ___mmalloc_sbrk_init;
	P5  =R0 ;
L$L$119:
	R0  = 0 (X);
	[P5 +36] =R0 ;
	R1  = 9 (X);
	R1 =R1 +R6 ; //immed->Dreg 
	R0  =R5 ;
	call _mmalloc;
	R2.L  = _mmalloc_check; R2.H  = _mmalloc_check;
	[P5 +36] =R2 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$121;
	P2  =R0 ;
	[P2 ] =R6 ;
	R1.L  = -16661; R1.H  = -294;
	[P2 +4] =R1 ;
	R0 +=8;
	R6 =R0 +R6 ;
	R2  = -41 (X);
	P2  =R6 ;
	B [P2 ] =R2 ;
L$L$121:
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _mrealloc_check, STT_FUNC;
_mrealloc_check:
	LINK 0;
	[--sp] = ( r7:5, p5:4 );
	R5  =R0 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P4  =R1 ;
	P4 +=-8;
	P5  =R0 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$123;
	P5.L  = ___mmalloc_default_mdp; P5.H  = ___mmalloc_default_mdp;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$123;
	call ___mmalloc_sbrk_init;
	P5  =R0 ;
L$L$123:
	R0  =P5 ;
	R1  =P4 ;
	call _checkhdr;
	R0  = 0 (X);
	[P5 +32] =R0 ;
	[P5 +36] =R0 ;
	[P5 +40] =R0 ;
	R2  = 9 (X);
	R2 =R2 +R6 ; //immed->Dreg 
	R0  =R5 ;
	R1  =P4 ;
	call _mrealloc;
	R1.L  = _mfree_check; R1.H  = _mfree_check;
	[P5 +32] =R1 ;
	P2.L  = _mmalloc_check; P2.H  = _mmalloc_check;
	[P5 +36] =P2 ;
	R1.L  = _mrealloc_check; R1.H  = _mrealloc_check;
	[P5 +40] =R1 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$125;
	P2  =R0 ;
	[P2 ] =R6 ;
	R0 +=8;
	R6 =R0 +R6 ;
	R1  = -41 (X);
	P2  =R6 ;
	B [P2 ] =R1 ;
L$L$125:
	( r7:5, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _mmcheckf;
.type _mmcheckf, STT_FUNC;
_mmcheckf:
	LINK 0;
	[--sp] = ( r7:5 );
	R3  =R0 ;
	R6  =R1 ;
	[FP +16] =R2 ;
	R5  =R2 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$127;
	R3.L  = ___mmalloc_default_mdp; R3.H  = ___mmalloc_default_mdp;
	P2  =R3 ;
	R3  =[P2 ];
	cc =R3 ==0;
	if cc jump 6; jump.l L$L$127;
	call ___mmalloc_sbrk_init;
	R3  =R0 ;
L$L$127:
	R0.L  = _abort; R0.H  = _abort;
	cc =R6 ==0;
	if cc R6  =R0 ; /* movsicc-1b */
	P2  =R3 ;
	[P2 +28] =R6 ;
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$131;
	R1  =[P2 +16];
	R0  = 2 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$131;
	R1  =[P2 +32];
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$132;
L$L$131:
	R0.L  = _mfree_check; R0.H  = _mfree_check;
	P2  =R3 ;
	[P2 +32] =R0 ;
	R0.L  = _mmalloc_check; R0.H  = _mmalloc_check;
	[P2 +36] =R0 ;
	R0.L  = _mrealloc_check; R0.H  = _mrealloc_check;
	[P2 +40] =R0 ;
	R0  =[P2 +16];
	BITSET (R0 ,2);
	[P2 +16] =R0 ;
	R0  = 1 (X);
L$L$132:
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _mmcheck;
.type _mmcheck, STT_FUNC;
_mmcheck:
	LINK 0;
	R2  = 0 (X);
	call _mmcheckf;
	UNLINK;
	rts;


.align 2
.global _mmemalign;
.type _mmemalign, STT_FUNC;
_mmemalign:
	LINK 0;
	[--sp] = ( r7:4, p5:4 );
	R4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R0 =R2 +R1 ;
	R1  = -1 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  =R4 ;
	call _mmalloc;
	P4  =R0 ;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$135;
	R1  =R5 ;
	call ___umodsi3;
	R6  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$135;
	P5  =R4 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$137;
	P5.L  = ___mmalloc_default_mdp; P5.H  = ___mmalloc_default_mdp;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$137;
	call ___mmalloc_sbrk_init;
	P5  =R0 ;
L$L$137:
	R0  =[P5 +180];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$148;
L$L$144:
	P2  =R0 ;
	R1  =[P2 +4];
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$140;
	R0  =[P2 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$144;
	jump.s L$L$148;
L$L$140:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$145;
L$L$148:
	R0  =R4 ;
	R1  = 12 (X);
	call _mmalloc;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$146;
	R0  =R4 ;
	R1  =P4 ;
	call _mfree;
	R0  = 0 (X);
	jump.s L$L$134;
L$L$146:
	R1  =[P5 +180];
	P2  =R0 ;
	[P2 ] =R1 ;
	[P5 +180] =R0 ;
L$L$145:
	P2  =R0 ;
	[P2 +8] =P4 ;
	P2  =R5 ;
	P4 =P4 +P2 ;
	R1  =P4 ;
	R1  =R1 -R6 ;
	P4  =R1 ;
	P2  =R0 ;
	[P2 +4] =R1 ;
L$L$135:
	R0  =P4 ;
L$L$134:
	( r7:4, p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _mmstats;
.type _mmstats, STT_FUNC;
_mmstats:
	LINK 24;
	[--sp] = ( r7:5 );
	R5  =P0 ;
	R6  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$150;
	R6.L  = ___mmalloc_default_mdp; R6.H  = ___mmalloc_default_mdp;
	P1  =R6 ;
	R6  =[P1 ];
	cc =R6 ==0;
	if cc jump 6; jump.l L$L$150;
	call ___mmalloc_sbrk_init;
	R6  =R0 ;
L$L$150:
	P1  =R6 ;
	P2  =[P1 +24];
	R0  =R6 ;
	R1  = 0 (X);
	call (P2 );
	P2  =R6 ;
	R1  =[P2 +48];
	R1  =R0 -R1 ;
	[FP +-20] =R1 ;
	R1  =[P2 +68];
	[FP +-16] =R1 ;
	P1  =[P2 +72];
	[FP +-12] =P1 ;
	P2  =[P2 +76];
	[FP +-8] =P2 ;
	P1  =R6 ;
	R6  =[P1 +80];
	[FP +-4] =R6 ;
	P2  =R5 ;
	R1  =[FP +-20];
	[P2 ++] =R1 ;
	P1  =[FP +-16];
	[P2 ++] =P1 ;
	R1  =[FP +-12];
	[P2 ++] =R1 ;
	P1  =[FP +-8];
	[P2 ++] =P1 ;
	R1  =[FP +-4];
	[P2 ] =R1 ;
	R0  =R5 ;
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _tr_break, STT_FUNC;
_tr_break:
	LINK 0;
	UNLINK;
	rts;


.align 2
L$LC$0:
.dw	0x202d;
.dw	0x3025;
.dw	0x6c38;
.dw	0x0a78;
.db	0x00;
.align 2
.type _tr_freehook, STT_FUNC;
_tr_freehook:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	R5  =R0 ;
	R6  =R1 ;
	P5  =R0 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$154;
	P5.L  = ___mmalloc_default_mdp; P5.H  = ___mmalloc_default_mdp;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$154;
	call ___mmalloc_sbrk_init;
	P5  =R0 ;
L$L$154:
	P2.L  = _mallstream; P2.H  = _mallstream;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R0.L  = L$LC$0; R0.H  = L$LC$0;
	[SP +16] =R0 ;
	[SP +20] =R6 ;
	call _fprintf;
	P2.L  = _mallwatch; P2.H  = _mallwatch;
	P2  =[P2 ];
	R0  =P2 ;
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$156;
	call _tr_break;
L$L$156:
	P2.L  = _old_mfree_hook; P2.H  = _old_mfree_hook;
	P2  =[P2 ];
	[P5 +32] =P2 ;
	R0  =R5 ;
	R1  =R6 ;
	call _mfree;
	R0.L  = _tr_freehook; R0.H  = _tr_freehook;
	[P5 +32] =R0 ;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$1:
.dw	0x202b;
.dw	0x3025;
.dw	0x6c38;
.dw	0x2078;
.dw	0x7825;
.db	0x0a;
.db	0x00;
.align 2
.type _tr_mallochook, STT_FUNC;
_tr_mallochook:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	R6  =R0 ;
	R5  =R1 ;
	P5  =R0 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$158;
	P5.L  = ___mmalloc_default_mdp; P5.H  = ___mmalloc_default_mdp;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$158;
	call ___mmalloc_sbrk_init;
	P5  =R0 ;
L$L$158:
	P2.L  = _old_mmalloc_hook; P2.H  = _old_mmalloc_hook;
	P2  =[P2 ];
	[P5 +36] =P2 ;
	R0  =R6 ;
	R1  =R5 ;
	call _mmalloc;
	R6  =R0 ;
	R0.L  = _tr_mallochook; R0.H  = _tr_mallochook;
	[P5 +36] =R0 ;
	P2.L  = _mallstream; P2.H  = _mallstream;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R0.L  = L$LC$1; R0.H  = L$LC$1;
	[SP +16] =R0 ;
	[SP +20] =R6 ;
	[SP +24] =R5 ;
	call _fprintf;
	P2.L  = _mallwatch; P2.H  = _mallwatch;
	P2  =[P2 ];
	R0  =P2 ;
	cc =R6 ==R0 ;
	if cc jump 6; jump.l L$L$160;
	call _tr_break;
L$L$160:
	R0  =R6 ;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
L$LC$2:
.dw	0x2021;
.dw	0x3025;
.dw	0x6c38;
.dw	0x2078;
.dw	0x7825;
.db	0x0a;
.db	0x00;
.align 2
L$LC$3:
.dw	0x203c;
.dw	0x3025;
.dw	0x6c38;
.dw	0x0a78;
.dw	0x203e;
.dw	0x3025;
.dw	0x6c38;
.dw	0x2078;
.dw	0x7825;
.db	0x0a;
.db	0x00;
.align 2
.type _tr_reallochook, STT_FUNC;
_tr_reallochook:
	LINK 0;
	[--sp] = ( r7:4, p5:5 );
	R4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	P5  =R0 ;
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$162;
	P5.L  = ___mmalloc_default_mdp; P5.H  = ___mmalloc_default_mdp;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$162;
	call ___mmalloc_sbrk_init;
	P5  =R0 ;
L$L$162:
	P2.L  = _mallwatch; P2.H  = _mallwatch;
	P2  =[P2 ];
	R0  =P2 ;
	cc =R5 ==R0 ;
	if cc jump 6; jump.l L$L$164;
	call _tr_break;
L$L$164:
	P2.L  = _old_mfree_hook; P2.H  = _old_mfree_hook;
	P2  =[P2 ];
	[P5 +32] =P2 ;
	P2.L  = _old_mmalloc_hook; P2.H  = _old_mmalloc_hook;
	P2  =[P2 ];
	[P5 +36] =P2 ;
	P2.L  = _old_mrealloc_hook; P2.H  = _old_mrealloc_hook;
	P2  =[P2 ];
	[P5 +40] =P2 ;
	R2  =R6 ;
	R0  =R4 ;
	R1  =R5 ;
	call _mrealloc;
	R4  =R0 ;
	R0.L  = _tr_freehook; R0.H  = _tr_freehook;
	[P5 +32] =R0 ;
	R0.L  = _tr_mallochook; R0.H  = _tr_mallochook;
	[P5 +36] =R0 ;
	R0.L  = _tr_reallochook; R0.H  = _tr_reallochook;
	[P5 +40] =R0 ;
	cc =R4 ==0;
	if cc jump 6; jump.l L$L$165;
	P2.L  = _mallstream; P2.H  = _mallstream;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R0.L  = L$LC$2; R0.H  = L$LC$2;
	[SP +16] =R0 ;
	[SP +20] =R5 ;
	[SP +24] =R6 ;
	call _fprintf;
	jump.s L$L$166;
L$L$165:
	P2.L  = _mallstream; P2.H  = _mallstream;
	P2  =[P2 ];
	[SP +12] =P2 ;
	R0.L  = L$LC$3; R0.H  = L$LC$3;
	[SP +16] =R0 ;
	[SP +20] =R5 ;
	[SP +24] =R4 ;
	[SP +28] =R6 ;
	call _fprintf;
L$L$166:
	P2.L  = _mallwatch; P2.H  = _mallwatch;
	P2  =[P2 ];
	R0  =P2 ;
	cc =R4 ==R0 ;
	if cc jump 6; jump.l L$L$167;
	call _tr_break;
L$L$167:
	R0  =R4 ;
	( r7:4, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _mmtrace;
.type _mmtrace, STT_FUNC;
_mmtrace:
	LINK 0;
	R0  = 1 (X);
	UNLINK;
	rts;


.align 2
.global _mrealloc;
.type _mrealloc, STT_FUNC;
_mrealloc:
	LINK 4;
	[--sp] = ( r7:4, p5:3 );
	R4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R6  =R2 ;
	cc =R2 ==0;
	if cc jump 6; jump.l L$L$170;
	call _mfree;
	R0  =R4 ;
	R1  = 0 (X);
	jump.s L$L$193;
L$L$170:
	cc =R1 ==0;
	if cc jump 6; jump.l L$L$171;
	R1  =R2 ;
L$L$193:
	call _mmalloc;
	jump.s L$L$169;
L$L$171:
	P5  =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$173;
	P5.L  = ___mmalloc_default_mdp; P5.H  = ___mmalloc_default_mdp;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$173;
	call ___mmalloc_sbrk_init;
	P5  =R0 ;
L$L$173:
	P2  =[P5 +40];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$175;
	R2  =R6 ;
	R0  =R4 ;
	R1  =R5 ;
	call (P2 );
	jump.s L$L$169;
L$L$175:
	P3  =[P5 +48];
	R0  =P3 ;
	R0  =R5 -R0 ;
	R0  >>=12;
	P3  =R0 ;
	P3 +=1;
	P4  =[P5 +60];
	P2  =P3 +(P3 <<1);
	P4  =P4 +(P2 <<2);
	P4  =[P4 ];
	cc =P4 ==0;
	if cc jump 6; jump.l L$L$186;
	R1  = 2048 (X);
	cc =R6 <=R1  (iu);
	if cc jump 6; jump.l L$L$178;
	R0  =R4 ;
	R1  =R6 ;
	call _mmalloc;
	P4  =R0 ;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$178;
	R2  =R6 ;
	R0  =R5 ;
	R1  =P4 ;
	call _bcopy;
	R0  =R4 ;
	R1  =R5 ;
	call _mfree;
	R0  =P4 ;
	jump.s L$L$169;
L$L$178:
	R1  = 4095 (X);
	R1 =R1 +R6 ; //immed->Dreg 
	R1  >>=12;
	P0  =[P5 +60];
	P2  =P3 +(P3 <<1);
	P2  =P2 <<2;
	P1 =P2 +P0 ;
	P1  =[P1 +4];
	R2  =P1 ;
	cc =R1 <R2  (iu);
	if cc jump 6; jump.l L$L$180;
	P1  =R1 ;
	P3 =P3 +P1 ;
	P1  =P3 +(P3 <<1);
	P1  =P1 <<2;
	P0 =P1 +P0 ;
	R0  = 0 (X);
	[P0 ] =R0 ;
	P0  =[P5 +60];
	P1 =P1 +P0 ;
	P0 =P2 +P0 ;
	P0  =[P0 +4];
	R2  =P0 ;
	R2  =R2 -R1 ;
	[P1 +4] =R2 ;
	P1  =[P5 +60];
	P2 =P2 +P1 ;
	[P2 +4] =R1 ;
	R0  =P3 ;
	R0  <<=12;
	P5  =[P5 +48];
	R1  =P5 ;
	R0 =R0 +R1 ;
	R1  = -4096 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  =R4 ;
	call _mfree;
	[FP +-4] =R5 ;
	jump.s L$L$176;
L$L$180:
	P1  =[P5 +60];
	P2  =P3 +(P3 <<1);
	P1  =P1 +(P2 <<2);
	P1  =[P1 +4];
	[FP +-4] =R5 ;
	R2  =P1 ;
	cc =R1 ==R2 ;
	if !cc jump 6; jump.l L$L$176;
	P4  =[P5 +60];
	P4  =P4 +(P2 <<2);
	P4  =[P4 +4];
	P3  =[P5 +56];
	P1  = 0 (X);
	[P5 +56] =P1 ;
	R0  =R4 ;
	R1  =R5 ;
	call _mfree;
	[P5 +56] =P3 ;
	R0  =R4 ;
	R1  =R6 ;
	call _mmalloc;
	[FP +-4] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$184;
	R1  =P4 ;
	R1  <<=12;
	R0  =R4 ;
	call _mmalloc;
	R0  = 0 (X);
	jump.s L$L$169;
L$L$184:
	R0  =[FP +-4];
	cc =R5 ==R0 ;
	if !cc jump 6; jump.l L$L$176;
	R2  =P4 ;
	R2  <<=12;
	R1  =R5 ;
	call _memmove;
	jump.s L$L$176;
L$L$186:
	R1  =P4 ;
	R1 +=-1;
	R0  = 1 (X);
	R2  =R0 ;
	R2  <<=R1 ;
	cc =R6 <=R2  (iu);
	if !cc jump 6; jump.l L$L$187;
	R1  =P4 ;
	R0  <<=R1 ;
	[FP +-4] =R5 ;
	cc =R6 <=R0  (iu);
	if !cc jump 6; jump.l L$L$176;
L$L$187:
	R0  =R4 ;
	R1  =R6 ;
	call _mmalloc;
	R1  =R0 ;
	[FP +-4] =R0 ;
	R0  = 0 (X);
	cc =R1 ==0;
	if !cc jump 6; jump.l L$L$169;
	R0  =R6 ;
	R2  =P4 ;
	R0  >>=R2 ;
	R2  =R6 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$191;
	R0  = 1 (X);
	R2  =R0 ;
	R1  =P4 ;
	R2  <<=R1 ;
L$L$191:
	R0  =R5 ;
	R1  =[FP +-4];
	call _bcopy;
	R0  =R4 ;
	R1  =R5 ;
	call _mfree;
L$L$176:
	R0  =[FP +-4];
L$L$169:
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _realloc;
.type _realloc, STT_FUNC;
_realloc:
	LINK 0;
	R3  =R0 ;
	R2  =R1 ;
	R0  = 0 (X);
	R1  =R3 ;
	call _mrealloc;
	UNLINK;
	rts;


.align 2
.global _mvalloc;
.type _mvalloc, STT_FUNC;
_mvalloc:
	LINK 0;
	[--sp] = ( r7:5, p5:5 );
	R5  =R0 ;
	R6  =R1 ;
	P5.L  = _cache_pagesize; P5.H  = _cache_pagesize;
	R0  =[P5 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$196;
	call _getpagesize;
	[P5 ] =R0 ;
L$L$196:
	P2.L  = _cache_pagesize; P2.H  = _cache_pagesize;
	R2  =R6 ;
	R0  =R5 ;
	R1  =[P2 ];
	call _mmemalign;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _valloc;
.type _valloc, STT_FUNC;
_valloc:
	LINK 0;
	R1  =R0 ;
	R0  = 0 (X);
	call _mvalloc;
	UNLINK;
	rts;


.data;
_ansi_c_idiots:	.byte	69
.text;
.align 2
.global _mmalloc_attach;
.type _mmalloc_attach, STT_FUNC;
_mmalloc_attach:
	LINK 0;
	R0  = 0 (X);
	UNLINK;
	rts;


.align 2
.global _mmalloc_detach;
.type _mmalloc_detach, STT_FUNC;
_mmalloc_detach:
	LINK 264;
	[--sp] = ( r7:5, p5:5 );
	R5  =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$200;
	P5  = -264 (X);
	P5 =P5 +FP ; //immed->Preg 
	R6  = 264 (X);
	R2  =R6 ;
	R1  =P5 ;
	call _bcopy;
	R1  =[FP +-80];
	R0  =[FP +-76];
	R1  =R1 -R0 ;
	P2  =[FP +-240];
	R0  =P5 ;
	call (P2 );
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$201;
	R2  =R6 ;
	R0  =P5 ;
	R1  =R5 ;
	call _bcopy;
	jump.s L$L$200;
L$L$201:
	R1  =[FP +-248];
	R0  = 1 (X);
	R0  =R1 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$203;
	R0  =[FP +-68];
	call _close;
L$L$203:
	R5  = 0 (X);
L$L$200:
	R0  =R5 ;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _mmalloc_setkey;
.type _mmalloc_setkey, STT_FUNC;
_mmalloc_setkey:
	LINK 0;
	P2  =R0 ;
	[FP +16] =R2 ;
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$205;
	cc =R1 <0;
	if !cc jump 6; jump.l L$L$205;
	R3  = 15 (X);
	cc =R1 <=R3 ;
	if cc jump 6; jump.l L$L$205;
	P1  =R1 ;
	P2  =P2 +(P1 <<2);
	[P2 +200] =R2 ;
	R0  = 1 (X);
L$L$205:
	UNLINK;
	rts;


.align 2
.global _mmalloc_getkey;
.type _mmalloc_getkey, STT_FUNC;
_mmalloc_getkey:
	LINK 0;
	P2  =R0 ;
	R0  = 0 (X);
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$207;
	cc =R1 <0;
	if !cc jump 6; jump.l L$L$207;
	R2  = 15 (X);
	cc =R1 <=R2 ;
	if cc jump 6; jump.l L$L$207;
	P1  =R1 ;
	P2  =P2 +(P1 <<2);
	R0  =[P2 +200];
L$L$207:
	UNLINK;
	rts;


.align 2
.type _sbrk_morecore, STT_FUNC;
_sbrk_morecore:
	LINK 0;
	[--sp] = ( r7:6, p5:5 );
	P5  =R0 ;
	R6  =R1 ;
	R0  =R1 ;
	call _sbrk;
	cc =R0 ==-1;
	if cc jump 6; jump.l L$L$209;
	R0  = 0 (X);
	jump.s L$L$210;
L$L$209:
	R1  =[P5 +188];
	R1 =R6 +R1 ;
	[P5 +188] =R1 ;
	R1  =[P5 +192];
	R6 =R6 +R1 ;
	[P5 +192] =R6 ;
L$L$210:
	( r7:6, p5:5 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global ___mmalloc_sbrk_init;
.type ___mmalloc_sbrk_init, STT_FUNC;
___mmalloc_sbrk_init:
	LINK 0;
	[--sp] = ( r7:6, p5:4 );
	R0  = 0 (X);
	call _sbrk;
	R6  =R0 ;
	R0  = 4095 (X);
	R0  =R6 &R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$212;
	I0  = 4096 (X);
	R1  =I0 ;
	R0  =R1 -R0 ;
	call _sbrk;
	R0  = 0 (X);
	call _sbrk;
	R6  =R0 ;
L$L$212:
	P4.L  = ___mmalloc_default_mdp; P4.H  = ___mmalloc_default_mdp;
	R0  = 264 (X);
	call _sbrk;
	[P4 ] =R0 ;
	R1  = 264 (X);
	call _bzero;
	P2  =[P4 ];
	R2.L  = _sbrk_morecore; R2.H  = _sbrk_morecore;
	[P2 +24] =R2 ;
	P2  =[P4 ];
	[P2 +184] =R6 ;
	P5  =[P4 ];
	R0  = 0 (X);
	call _sbrk;
	[P5 +192] =R0 ;
	[P5 +188] =R0 ;
	P2  =[P4 ];
	R2  = -1 (X);
	[P2 +196] =R2 ;
	R0  =[P4 ];
	( r7:6, p5:4 ) = [sp++];
	UNLINK;
	rts;


.global ___mmalloc_default_mdp;
.data;
.align 2
___mmalloc_default_mdp:.space 4;
.align 2
_mallstream:.space 4;
.align 2
_mallwatch:.space 4;
.align 2
_old_mfree_hook:.space 4;
.align 2
_old_mmalloc_hook:.space 4;
.align 2
_old_mrealloc_hook:.space 4;
.align 2
_cache_pagesize:.space 4;
