/*
** Copyright (C) 2005 Analog Devices, Inc. All Rights Reserved.
**
** This is the internal function implementing IEEE single-precision
** floating-point less than comparison. This functions is for compiler
** internal use only. It does not follow the normal C ABI.
**
** int __float32_adi_lt(float X, float Y)
**
**   X is received in R0.
**   Y is received in R1.
**   CC contains the result and is 1 if neither input is a NaN and X<Y,
**   or 0 otherwise.
**
** !!NOTE- Uses non-standard clobber set in compiler:
**        DefaultClobMinusPABIMandLoopRegs 
*/

.file_attr libGroup      = floating_point_support;
.file_attr libName = libdsp;
.file_attr prefersMem    = internal;
.file_attr prefersMemNum = "30";
.file_attr libFunc = ___float32_adi_lt;
.file_attr FuncName      = ___float32_adi_lt;

.section program;
.align 2;

___float32_adi_lt:

	// A NaN has an exponent of 255, and a non-zero
	// mantissa. Sign is irrelevant. We check whether
	// either input is a NaN by getting rid of the
	// sign bit, and then comparing against 0xFF000000
	// if the operand is larger, it's got a 255 exponent
	// and non-zero mantissa, hence it's a NaN.

	R2 = R0 << 1;
	R3 = 0xFF;
	R3 <<= 24;
	CC = R2 <= R3 (IU);
	IF !CC JUMP .ret;
	
	R2 = R1 << 1;
	CC = R2 <= R3 (IU);
	IF !CC JUMP .ret;
	
	R2 = R0 | R1;			// Check for equality +0==-0
	R2 <<= 1;				// we know CC is already 1
	CC ^= AZ;				// and AZ set if no bits other than
	IF !CC JUMP .ret;		// sign set so CC is 0 if X==Y==0

	// Neither operand is a NaN or 0. Can treat the floats
	// as signed integers (they have a sign bit, tiny
	// exponents are smaller than huge exponents).

	R2 = R0 - R1;			// Check for non-zero equality
	CC ^= AZ;				// Quicker to AND in the flag later
	AV1 = CC;				// Than jump to seperate return

	CC = R0 < R1;
	R2 = R0 & R1;			// but if both operands are negative
	CC ^= AN;				// result must be toggled
	CC &= AV1;
.ret:
	RTS;

.___float32_adi_lt.end:
.type ___float32_adi_lt, STT_FUNC;
.global ___float32_adi_lt;
