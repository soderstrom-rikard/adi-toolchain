// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "choose-temp.i";
.text;
.align 2
.global _choose_temp_base;
.type _choose_temp_base, STT_FUNC;
_choose_temp_base:
	LINK 8;
	[--sp] = ( r7:5, p5:5 );
	call _choose_tmpdir;
	R5  =R0 ;
	call _strlen;
	R6  =R0 ;
	R0  = 9 (X);
	R0 =R0 +R6 ; //immed->Dreg 
	call _xmalloc;
	P5  =R0 ;
	R1  =R5 ;
	call _strcpy;
	R1  =P5 ;
	R6 =R1 +R6 ;
	R0  = 99 (X);
	P2  =R6 ;
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
	R0  =P5 ;
	call _mktemp;
	R0  = B [P5 ] (X);
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2;
	call _abort;
L$L$2:
	R0  =P5 ;
	( r7:5, p5:5 ) = [sp++];
	UNLINK;
	rts;


