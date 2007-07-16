/*
** Copyright (C) Analog Devices Inc, All Rights Reserved.
**
** long long remainder.
**
** long long __umoddi3(long long, long long);
**
** !!NOTE- Uses non-standard clobber set in compiler:
**         DefaultClobMinusA0BIMandLoop1Regs
**
*/

.file_attr libGroup      = integer_support;
.file_attr libName = libdsp;
.file_attr prefersMem    = internal;
.file_attr prefersMemNum = "30";
.file_attr libFunc = ___moddi3;
.file_attr FuncName      = ___moddi3;

#if defined(__ADSPBLACKFIN__) && !defined(__ADSPLPBLACKFIN__)
/* __ADSPBF535__ core only */
#define CARRY AC
#else
#define CARRY AC0
#endif

.section program;

.align 2;

___moddi3:
	[SP +0] = R0;
	[SP +4] = R1;
	[SP +8] = R2;
	R3 = [SP +12];
	LINK 16;
	// Compute d = x / y
	[SP +12] = R3;
	CALL.X ___divdi3;
	// then compute n = d * y
	R2 = [FP +16];
	R3 = [FP +20];
	[SP +12] = R3;
	CALL.X ___mulli3;
	UNLINK;
	// r = x (sp+0:sp+4) - n (r0:1) == ( -n + x )
		R2 = [SP +0];
		R0 = R2 - R0 (NS) || R2 = [SP+ 4] || NOP;
		CC = CARRY;
		CC = ! CC;
		R3 = CC;
		R2 = R2 - R3;
		R1 = R2 - R1;

		
return_x:
	RTS;


.___moddi3.end:
.global ___moddi3;
.type ___moddi3, STT_FUNC;
.extern ___divdi3;
.extern ___mulli3;
