// gcc version 3.3.3 bfin version 1.0.0 opt -O0
.file "func_ext.c";
.text;
.align 2
.global _func11;
.type _func11, STT_FUNC;
_func11:
	LINK 8;
        [--sp] = (r7:4);
        SP+=12;
	R0 =[FP+-4];
	R1 =[FP+-8];
	R0 = R0 + R1;
	[FP+-4] =R0;
	UNLINK;
	rts;


.align 2
.global _func22;
.type _func22, STT_FUNC;
_func22:
        [--sp] = (r7:4);
	[--sp] = RETS;
        SP+=12;
	[FP+8] =R0;
	[FP+12] =R1;
	R1 =[FP+8];
	R0 =[FP+12];
	R0 = R1 + R0;
	UNLINK;
	rts;


.align 2
.global _func33;
.type _func33, STT_FUNC;
_func33:
	LINK 20;
        SP+=12;
	[FP+8] =R0;
	[FP+12] =R1;
	[FP+16] =R2;
	R0 =[FP+8];
	[FP+-4] =R0;
	R0 =[FP+12];
	P2 =R0;
	P2 =P2+P2;
	[FP+-8] =P2;
	R0 =[FP+16];
	P2 =R0;
	P2 =P2+P2;
	R1 =P2;
	R0 = R1 + R0;
	[FP+-12] =R0;
	R0 =[FP+20];
	P2 =R0;
	P2 =P2<<2;
	[FP+-16] =P2;
	R0 =[FP+24];
	P2 =R0;
	P2 =P2<<2;
	R1 =P2;
	R0 = R1 + R0;
	[FP+-20] =R0;
	R1 =[FP+-4];
	R0 =[FP+-8];
	R0 = R1 + R0;
	R1 =[FP+-12];
	R0 = R0 + R1;
	R1 =[FP+-16];
	R0 = R0 + R1;
	R1 =[FP+-20];
	R0 = R0 + R1;
	UNLINK;
	rts;


.align 2
.global _func44;
.type _func44, STT_FUNC;
_func44:
	LINK 404;
        P2.L = 40; P2.H = -40;
        SP = SP + P2;
	[--sp] = ( r7:4 );
        SP+=36;
	[FP+8] =R0;
	R0 = 1 (X);
	[FP+-396] =R0;
	R0 = 1 (X);
	[FP+-400] =R0;
	R0 = 2 (X);
	[FP+-404] =R0;
L$L$5:
	R1 =[FP+-404];
	R0 =[FP+8];
	cc =R1<R0;
	if cc jump L$L$8;
	jump.s L$L$6;
L$L$8:
	R0 =[FP+-404];
	P2 =R0;
	P2 =P2<<2;
	P2 = P2 + FP;
	R0 = -400 (X);
	P1 =R0;
	P0 = P2 + P1;
	R0 =[FP+-404];
	P2 =R0;
	P2 =P2<<2;
	P2 = P2 + FP;
	R0 = -404 (X);
	P5 =R0;
	P1 = P2 + P5;
	R0 =[FP+-404];
	P2 =R0;
	P2 =P2<<2;
	P2 = P2 + FP;
	R0 = -408 (X);
	P5 =R0;
	P2 = P2 + P5;
	R1 =[P1];
	R0 =[P2];
	R0 = R1 + R0;
	[P0] =R0;
	R0 =[FP+-404];
	R0 += 1;
	[FP+-404] =R0;
	jump.s L$L$5;
L$L$6:
	R0 =[FP+8];
	P2 =R0;
	P2 =P2<<2;
	P2 = P2 + FP;
	R0 = -400 (X);
	P1 =R0;
	P2 = P2 + P1;
	R0 =[P2];
	( p5:5 ) = [sp++];
	UNLINK;
	rts;


