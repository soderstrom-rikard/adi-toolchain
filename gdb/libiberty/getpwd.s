// gcc version 3.3.3 bfin version 1.0.0 opt -O1
.file "getpwd.i";
.data;
.align 2
L_pwd_$0:.space 4;
.align 2
L_failure_errno_$1:.space 4;
.text;
.align 2
L$LC$0:
.dw	0x5750;
.db	0x44;
.db	0x00;
.align 2
L$LC$1:
.db	0x2e;
.db	0x00;
.align 2
.global _getpwd;
.type _getpwd, STT_FUNC;
_getpwd:
	LINK 128;
	[--sp] = ( r7:5, p5:3 );
	P5.L  = L_pwd_$0; P5.H  = L_pwd_$0;
	P5  =[P5 ];
	cc =P5 ==0;
	if cc jump 6; jump.l L$L$2;
	call ___errno_location;
	P2.L  = L_failure_errno_$1; P2.H  = L_failure_errno_$1;
	P2  =[P2 ];
	P1  =R0 ;
	[P1 ] =P2 ;
	cc =P2 ==0;
	if cc jump 6; jump.l L$L$2;
	R0.L  = L$LC$0; R0.H  = L$LC$0;
	call _getenv;
	P5  =R0 ;
	cc =P5 ==0;
	if !cc jump 6; jump.l L$L$4;
	R0  = B [P5 ] (X);
	R1  = 47 (X);
	cc =R0 ==R1 ;
	if cc jump 6; jump.l L$L$4;
	R0  =FP ;
	R1  = -128 (X);
	R1 =R1 +R0 ; //immed->Dreg 
	R0  =P5 ;
	call _stat;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$4;
	R1  =FP ;
	R1 +=-64;
	R0.L  = L$LC$1; R0.H  = L$LC$1;
	call _stat;
	cc =R0 ==0;
	if cc jump 6; jump.l L$L$4;
	R1  =[FP +-60];
	R0  =[FP +-124];
	cc =R1 ==R0 ;
	if cc jump 6; jump.l L$L$4;
	R1  = W[FP +-64] (Z);
	R0  = W[FP +-128] (Z);
	cc =R1 ==R0 ;
	if !cc jump 6; jump.l L$L$3;
L$L$4:
	R5  = 4096 (X);
	P3.L  = L_failure_errno_$1; P3.H  = L_failure_errno_$1;
	jump.s L$L$5;
L$L$10:
	call ___errno_location;
	P4  =R0 ;
	R6  =[P4 ];
	R0  =P5 ;
	call _free;
	P1  =R5 ;
	P1  =P1 +P1 ;
	R5  =P1 ;
	R0  = 34 (X);
	cc =R6 ==R0 ;
	if !cc jump 6; jump.l L$L$5;
	[P3 ] =R6 ;
	[P4 ] =R6 ;
	P5  = 0 (X);
	jump.s L$L$3;
L$L$5:
	R0  =R5 ;
	call _xmalloc;
	P5  =R0 ;
	R1  =R5 ;
	call _getcwd;
	cc =R0 ==0;
	if !cc jump 6; jump.l L$L$10;
L$L$3:
	P2.L  = L_pwd_$0; P2.H  = L_pwd_$0;
	[P2 ] =P5 ;
L$L$2:
	R0  =P5 ;
	( r7:5, p5:3 ) = [sp++];
	UNLINK;
	rts;


