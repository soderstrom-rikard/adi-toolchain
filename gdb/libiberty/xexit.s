// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "xexit.i";
.text;
.align 2
.global _xexit;
.type _xexit, STT_FUNC;
_xexit:
	LINK 0;
	[--sp] = ( r7:6 );
	R6  =R0 ;
	P2.L  = __xexit_cleanup; P2.H  = __xexit_cleanup;
	P2  =[P2 ];
	cc =P2 ==0;
	if !cc jump 6; jump.l L$L$2;
	call (P2 );
L$L$2:
	R0  =R6 ;
	call _exit;
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.global __xexit_cleanup;
.data;
.align 2
__xexit_cleanup:.space 4;
