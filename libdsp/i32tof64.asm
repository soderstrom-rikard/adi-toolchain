/*
** Copyright (C) 2003-2004 Analog Devices, Inc. All Rights Reserved.
**
** Convert a signed integer 32-bit value into an IEEE
** double-precision floating point value.
** double __floatsidf (int)
**
*/

.text;
.align 2;
.global ___floatsidf;
.type ___floatsidf,STT_FUNC;
___floatsidf:
	// Check for zero first.

	CC = R0 == 0;
	IF CC R1 = R0;
	IF CC JUMP .ret_zero;

	// The mantissa will be unsigned, so if the input
	// value is negative, negate it, and remember this
	// fact.

	P0 = R0;		// Record for later
	CC = R0 < 0;
	R1 = -R0;
	IF CC R0 = R1;

	// Determine the exponent.

	R2.L = SIGNBITS R0;
	R2 = R2.L (X);


	R0 <<= R2;		// Adjust for normalisation
	R1 = R0;		// Put normalized bits into high half.
	R0 <<= 22;		// Adjust for the bits that are
				// in high half (including hidden)
	R1 >>= 10;		// and then back for exponent space
	BITCLR(R1,20);		// Remove the hidden bit.

	R3 = 1053;		// Exponent is biased by 1023, and it also
	R2 = R3 - R2;		// includes the number of bits we'd shift
				// *right*, to make the most significant bit
				// into 1 (because we're 1.x raised to a
				// power). So that's 1023+(30-signbits).

	R2 <<= 21;		// Position at MSB
	CC = P0 < 0;		// determine sign bit
	R2 = ROT R2 BY -1;	// and insert sign bit, realigning exponent

	R1 = R1 | R2;		// Combine with mantissa.
.ret_zero:
	RTS;
	.size ___floatsidf, .-___floatsidf;

