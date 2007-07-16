/*
** Float16 compare.  Compares 2 non-IEEE-754 floating point numbers (16.16)
**
** Copyright (C) 2003 Analog Devices, Inc. All Rights Reserved.
*/

.file_attr libGroup      = float16.h;
.file_attr libFunc       = _cmp_fl16;
.file_attr libFunc       = cmp_fl16;
.file_attr libName = libdsp;
.file_attr prefersMem    = internal;
.file_attr prefersMemNum = "30";
.file_attr FuncName      = _cmp_fl16;

.section program;
.align 2;

_cmp_fl16:
	CC = R0 < 0;
	R2 = CC;
	CC = R1 < 0;
	R3 = CC;
	CC = R2 == R3;
	IF !CC JUMP diff_signs;

	// signs are the same. Examine exponents.
	R0 = R0 -|- R1;
	R1 = R0.L (X);	// difference between exponents
	R0 >>>= 16;	// difference between mantissas
	CC = R1 == 0;	// If exponents are the different, they decide.
	IF !CC R0 = R1;	// Otherwise, mantissas decide.
	R1 = -R0;	// If x was negative (and therefore y also negative)
	CC = R2 == 0;	// then we have to negate our result
	IF !CC R0 = R1;	//
	RTS;

diff_signs:
	// Signs are different, so we return a number that
	// derives its sign from whether X was negative.
	R0 = R2 << 31;
	R0 += 1;
	RTS;
._cmp_fl16.end:
.global _cmp_fl16;
.type _cmp_fl16, STT_FUNC;
