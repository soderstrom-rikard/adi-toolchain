// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "xmemdup.i";
.text;
.align 2
.global _xmemdup;
.type _xmemdup, STT_FUNC;
_xmemdup:
	LINK 0;
	[--sp] = ( r7:4 );
	R4  =R0 ;
	R5  =R1 ;
	[FP +16] =R2 ;
	R1  =R2 ;
	R0  = 1 (X);
	call _xcalloc;
	R6  =R0 ;
	R2  =R5 ;
	R0  =R4 ;
	R1  =R6 ;
	call _bcopy;
	R0  =R6 ;
	( r7:4 ) = [sp++];
	UNLINK;
	rts;


