// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "fdmatch.i";
.text;
.align 2
.global _fdmatch;
.type _fdmatch, STT_FUNC;
_fdmatch:
	LINK 128;
	[--sp] = ( r7:6 );
	R6  =R1 ;
	R1  =FP ;
	R1 +=-64;
	call _fstat;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2;
	R0  =FP ;
	R1  = -128 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  =R6 ;
	call _fstat;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2;
	R1  = W[FP +-64] (Z);
	R0  = W[FP +-128] (Z);
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$2;
	R2  =[FP +-60];
	R1  =[FP +-124];
	R0  = 1 (X);
	cc =R2 ==R1 ;
	if !cc jump 6; jump.l L$L$1;
L$L$2:
	R0  = 0 (X);
L$L$1:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


