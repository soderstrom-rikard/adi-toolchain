// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "xatexit.i";
.data;
.align 2
_xatexit_head:	.long	_xatexit_first
.text;
.align 2
.global _xatexit;
.type _xatexit, STT_FUNC;
_xatexit:
	LINK 0;
	[--sp] = ( r7:6 );
	R6  =R0 ;
	P2.L  = __xexit_cleanup; P2.H  = __xexit_cleanup;
	R0  =[P2 ];
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$2;
	R0.L  = _xatexit_cleanup; R0.H  = _xatexit_cleanup;
	[P2 ] =R0 ;
L$L$2:
	P0.L  = _xatexit_head; P0.H  = _xatexit_head;
	P0  =[P0 ];
	R0  =[P0 +4];
	R1  = 31 (X);
	cc =R0 <=R1 ;
	if !cc jump 6; jump.l L$L$3;
	R0  = 136 (X);
	call _malloc;
	P0  =R0 ;
	R0  = -1 (X);
	cc =P0 ==0;
	if !cc jump 6; jump.l L$L$1;
	R0  = 0 (X);
	[P0 +4] =R0 ;
	P2.L  = _xatexit_head; P2.H  = _xatexit_head;
	R1  =[P2 ];
	[P0 ] =R1 ;
	[P2 ] =P0 ;
L$L$3:
	P1  = 4 (X);
	P1 =P1 +P0 ; //immed->Preg 
	P2  =[P1 ];
	P0  =P0 +(P2 <<2);
	[P0 +8] =R6 ;
	P2 +=1;
	[P1 ] =P2 ;
	R0  = 0 (X);
L$L$1:
	( r7:6 ) = [sp++];
	UNLINK;
	rts;


.align 2
.type _xatexit_cleanup, STT_FUNC;
_xatexit_cleanup:
	LINK 0;
	[--sp] = ( p5:4 );
	P5.L  = _xatexit_head; P5.H  = _xatexit_head;
	P5  =[P5 ];
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$17;
L$L$15:
	P4  =[P5 +4];
	P4 +=-1;
	cc =P4 <0;
	if !cc jump 6; jump.l L$L$19;
L$L$14:
	P2  =P5 +(P4 <<2);
	P2  =[P2 +8];
	call (P2 );
	P4 +=-1;
	cc =P4 <0;
	if cc jump 6; jump.l L$L$14;
L$L$19:
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$15;
L$L$17:
	( p5:4 ) = [sp++];
	UNLINK;
	rts;


.data;
.align 2
_xatexit_first:.space 136;
