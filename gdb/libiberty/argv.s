// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "argv.i";
.text;
.align 2
.global _dupargv;
.type _dupargv, STT_FUNC;
_dupargv:
	LINK 0;
	[--sp] = ( r7:6, p5:3 );
	P3  =R0 ;
	R0  = 0 (X);
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$1;
	P1  = 0 (X);
	R0  =[P3 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$16;
L$L$7:
	P1 +=1;
	P2  =P3 +(P1 <<2);
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$7;
L$L$16:
	P1  =P1 <<2;
	R0  =P1 ;
	R0 +=4;
	call _malloc;
	P4  =R0 ;
	R0  = 0 (X);
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$1;
	jump.s L$L$8;
L$L$19:
	R0  =P4 ;
	call _freeargv;
	R0  = 0 (X);
	jump.s L$L$1;
L$L$8:
	P5  = 0 (X);
	R0  =[P3 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$18;
L$L$14:
	P1  =P5 <<2;
	R6  =P1 ;
	P2 =P1 +P3 ;
	R0  =[P2 ];
	call _strlen;
	R1  =P4 ;
	R6 =R6 +R1 ;
	P1  =R0 ;
	P2  =P1 <<2;
	R0  =P2 ;
	R0 +=4;
	call _malloc;
	P2  =R6 ;
	[P2 ] =R0 ;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$19;
	P1  =P5 <<2;
	P1 =P1 +P3 ;
	R1  =[P1 ];
	call _strcpy;
	P5 +=1;
	P2  =P3 +(P5 <<2);
	P2  =[P2 ];
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$14;
L$L$18:
	P5  =P4 +(P5 <<2);
	R0  = 0 (X);
	[P5 ] =R0 ;
	R0  =P4 ;
L$L$1:
	( r7:6, p5:3 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _freeargv;
.type _freeargv, STT_FUNC;
_freeargv:
	LINK 4;
	[--sp] = ( p5:4 );
	P4  =R0 ;
	cc =P4 ==0;
	if !cc jump 6; jump.l L$L$20;
	P5  =R0 ;
	R0  =[P4 ];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$28;
L$L$26:
	R0  =[P5 ++];
	call _free;
	R0  =[P5 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$26;
L$L$28:
	R0  =P4 ;
	call _free;
L$L$20:
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.align 2
.global _buildargv;
.type _buildargv, STT_FUNC;
_buildargv:
	LINK 16;
	[--sp] = ( r7:4, p5:3 );
	P3  =R0 ;
	[FP +-4] =SP ;
	R5  = 0 (X);
	R0  = 0 (X);
	[FP +-8] =R0 ;
	R6  = 0 (X);
	P4  = 0 (X);
	R4  = 0 (X);
	P5  = 0 (X);
	cc =P3 ==0;
	if !cc jump 6; jump.l L$L$30;
	R0  =P3 ;
	call _strlen;
	P2  =R0 ;
	P2 +=4;
	P2  =P2 >>2;
	P2  =P2 <<2;
	R1  =SP ;
	R2  =P2 ;
	R1  =R1 -R2 ;
	SP  =R1 ;
	P2  = 12 (X);
	P2 =P2 +SP ; //immed->Preg 
	[FP +-12] =P2 ;
L$L$31:
	R0  = B [P3 ] (X);
	R1  = 32 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$79;
	R2  = 9 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$75;
L$L$79:
	P3 +=1;
	R0  = B [P3 ] (X);
	R1  = 32 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$79;
	R2  = 9 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$79;
L$L$75:
	cc =R4 ==0;
	if !cc jump 6; jump.l L$L$39;
	P2  =R4 ;
	P2 +=-1;
	cc =P4 <P2 ;
	if !cc jump 6; jump.l L$L$38;
L$L$39:
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$40;
	R4  = 8 (X);
	R0  = 32 (X);
	call _malloc;
	jump.s L$L$41;
L$L$40:
	P2  =R4 ;
	P2  =P2 +P2 ;
	R4  =P2 ;
	P2  =P2 <<2;
	R1  =P2 ;
	R0  =P5 ;
	call _realloc;
L$L$41:
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$42;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$30;
	jump.s L$L$82;
L$L$42:
	P5  =R0 ;
	P2  =P5 +(P4 <<2);
	R1  = 0 (X);
	[P2 ] =R1 ;
L$L$38:
	P2  =[FP +-12];
	R0  = B [P3 ] (X);
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$45;
L$L$66:
	R0  = B [P3 ] (X);
	R2  = 32 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$48;
	R1  = 9 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$47;
L$L$48:
	cc =R5 ==0;
	if cc jump 6; jump.l L$L$47;
	R0  =[FP +-8];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$47;
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$45;
	jump.s L$L$73;
L$L$47:
	cc =R6 ==0;
	if !cc jump 6; jump.l L$L$50;
L$L$73:
	R6  = 0 (X);
	jump.s L$L$59;
L$L$50:
	R0  = B [P3 ] (X);
	R1  = 92 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$52;
	R6  = 1 (X);
	jump.s L$L$51;
L$L$52:
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$54;
	R0  = B [P3 ] (X);
	R2  = 39 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$64;
	R5  = 0 (X);
	jump.s L$L$51;
L$L$54:
	R0  =[FP +-8];
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$58;
	R0  = B [P3 ] (X);
	R1  = 34 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$59;
	R0  = 0 (X);
	jump.s L$L$81;
L$L$59:
	R2  = B [P3 ] (X);
	B [P2 ++] =R2 ;
	jump.s L$L$51;
L$L$58:
	R0  = B [P3 ] (X);
	R1  = 39 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$62;
	R5  = 1 (X);
	jump.s L$L$51;
L$L$62:
	R0  = B [P3 ] (X);
	R2  = 34 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$64;
	R0  = 1 (X);
L$L$81:
	[FP +-8] =R0 ;
	jump.s L$L$51;
L$L$64:
	R0  = B [P3 ] (X);
	B [P2 ++] =R0 ;
L$L$51:
	P3 +=1;
	R0  = B [P3 ] (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$66;
L$L$45:
	R1  = 0 (X);
	B [P2 ] =R1 ;
	R0  =[FP +-12];
	call _strdup;
	P2  =P5 +(P4 <<2);
	[P2 ] =R0 ;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$67;
L$L$82:
	R0  =P5 ;
	call _freeargv;
	P5  = 0 (X);
	jump.s L$L$30;
L$L$67:
	P4 +=1;
	P2  =P5 +(P4 <<2);
	R2  = 0 (X);
	[P2 ] =R2 ;
	R0  = B [P3 ] (X);
	R1  = 32 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$80;
	R2  = 9 (X);
	cc =R0 ==R2 ;
	if cc jump 6; jump.l L$L$78;
L$L$80:
	P3 +=1;
	R0  = B [P3 ] (X);
	R1  = 32 (X);
	cc =R0 ==R1 ;
	if !cc jump 6; jump.l L$L$80;
	R2  = 9 (X);
	cc =R0 ==R2 ;
	if !cc jump 6; jump.l L$L$80;
L$L$78:
	R0  = B [P3 ] (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$31;
L$L$30:
	R0  =[FP +-4];
	SP  =R0 ;
	R0  =P5 ;
	( r7:4, p5:3 ) = [sp++];
	UNLINK;
	rts;


