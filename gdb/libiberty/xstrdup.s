// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "xstrdup.i";
.text;
.align 2
.global _xstrdup;
.type _xstrdup, STT_FUNC;
_xstrdup:
	LINK 0;
	[--sp] = ( r7:4 );
	R4  =R0 ;
	call _strlen;
	R5  = 1 (X);
	R5 =R5 +R0 ; //immed->Dreg 
	R0  =R5 ;
	call _xmalloc;
	R6  =R0 ;
	R2  =R5 ;
	R0  =R4 ;
	R1  =R6 ;
	call _bcopy;
	R0  =R6 ;
	( r7:4 ) = [sp++];
	UNLINK;
	rts;


