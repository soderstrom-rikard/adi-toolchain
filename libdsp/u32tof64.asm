/*
** Copyright (C) 2003-2004 Analog Devices, Inc. All Rights Reserved.
**
** Convert an unsigned integer 32-bit value into an IEEE
** double-precision floating point value.
** double __floatunsidf (unsigned int)
*/

.text;
.align 2;
.global ___floatunsidf;
.type ___floatunsidf,STT_FUNC;
___floatunsidf:
	// Check for zero first.

	CC = R0 == 0;
	IF CC R1 = R0;
	IF CC JUMP .ret_zero;

	CC = R0 < 0;		// I.e. the MSB (not a sign bit) is set
	IF CC JUMP .big_val;

	// Determine the exponent.

	R2.L = SIGNBITS R0;
	R2 = R2.L (X);

	R0 <<= R2;		// Adjust for normalisation
	R1 = R0;		// Put adjusted bits in high half.
	R0 <<= 22;		// Adjust for the bits that are
				// in high half (including hidden)
	R1 >>= 10;		// and then back for exponent space
	BITCLR(R1,20);		// and clear the hidden bit.

	R3 = (1023+30);		// Bias the exponent
	R2 = R3 - R2;

	R2 <<= 20;		// Position at MSB, leaving space for sign.
	R1 = R1 | R2;		// Combine with mantissa.
.ret_zero:
	RTS;

.big_val:
	// The MSB is set, where we'd expect to find the sign bit,
	// so we know what our exponent will be. Set the values
	// directly.

	R1 = R0 >> 11;		// Align MSB with hidden bit
	R0 <<= 21;		// Adjust remaining bits in low half.
	R2 = (1023+31);		// Bias exponent
	R2 <<= 20;		// and position for exponent; sign is positive.
	BITCLR(R1, 20);		// Zap hidden bit (since we know it's set)
	R1 = R1 | R2;		// and include exponent.
	RTS;
	.size ___floatunsidf, .-___floatunsidf;

