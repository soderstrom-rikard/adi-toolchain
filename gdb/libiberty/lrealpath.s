// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "lrealpath.i";
.text;
.align 2
L$LC$0:
.db	0x2f;
.db	0x00;
.align 2
.global _lrealpath;
.type _lrealpath, STT_FUNC;
_lrealpath:
	LINK 0;
	[--sp] = ( r7:5 );
	R6  =R0 ;
	R0.L  = L$LC$0; R0.H  = L$LC$0;
	R1  = 4 (X);
	call _pathconf;
	cc =R0 <=0;
	if !cc jump 6; jump.l L$L$2;
	call _malloc;
	R5  =R0 ;
	R0  = 0 (X);
	cc =R5 ==0;
	if !cc jump 6; jump.l L$L$1;
	R0  =R6 ;
	R1  =R5 ;
	call _realpath;
	cc =R0 ==0;
	if cc R0  =R6 ; /* movsicc-1b */
	call _strdup;
	R6  =R0 ;
	R0  =R5 ;
	call _free;
	R0  =R6 ;
	jump.s L$L$1;
L$L$2:
	R0  =R6 ;
	call _strdup;
L$L$1:
	( r7:5 ) = [sp++];
	UNLINK;
	rts;


