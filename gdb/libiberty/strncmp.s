// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "strncmp.i";
.text;
.align 2
.global _strncmp;
.type _strncmp, STT_FUNC;
_strncmp:
	LINK 8;
	[--sp] = ( r7:6 );
	P1  =R0 ;
	[FP +16] =R2 ;
	P2  =R2 ;
	P2 +=-1;
	cc =R2 ==0;
	if !cc jump 6; jump.l L$L$9;
L$L$7:
	R6  = B [P1 ++] (X);
	R3  = R6.B  (Z);
	P0  =R1 ;
	R1 +=1;
	R2  = B [P0 ++] (Z);
	R0  =R3 -R2 ;
	cc =R3 ==R2 ;
	if cc jump 6; jump.l L$L$1;
	R0  = 0 (X);
	cc =R3 ==0;
	if !cc jump 6; jump.l L$L$1;
	R0  =P2 ;
	P2 +=-1;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$7;
L$L$9:
	R0  = 0 (X);
L$L$1:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


