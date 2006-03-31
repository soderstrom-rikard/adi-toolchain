/*
** Copyright (C) 2003-2006 Analog Devices, Inc.
**
** This file is subject to the terms and conditions of the GNU Library General  
** Public License. See the file "COPYING.LIB" in the main directory of this  
** archive for more details.  
**
** Non-LGPL License also available as part of VisualDSP++  
** http://www.analog.com/processors/resources/crosscore/visualDspDevSoftware.html
**
** Convert signed long long to IEEE double-precision 64-bit
** floating point.
** double __floatdidf (long long);
**
*/

#define CARRY AC0

.extern ___floatunsidf;
.extern ___floatsidf;
.text;
.align 2;
.global ___floatdidf;
.type ___floatdidf,STT_FUNC;
___floatdidf:
	// Check for zero first

	R2 = R1 | R0;
	CC = R2 == 0;
	IF CC JUMP .ret_zero;

	// Check whether this is a 32-bit value, sign-extended
	// to 64-bits. If so, it's easier to call a different
	// convertion function.

	R2 = R0 >>> 31;
	CC = R1 == R2;
	IF CC JUMP .is_32bit;

	P1 = R7;		// Workspace

	// Mantissa is unsigned, so note whether we're a
	// negative value.

	P0 = R1;		// save sign for later
	R2 = -R0;		// Compute -val
	CC = CARRY;
	CC = !CC;
	R7 = CC;
	R3 = -R1;
	R3 = R3 - R7;
	CC = P0 < 0;		// and if val < 0
	IF CC R0 = R2;		// then use -val instead.
	IF CC R1 = R3;

	// Need to determine what the exponent will be.

	CC = R1 == 0;
	IF CC JUMP .exp_gt_31;

	// There's a significant bit somewhere in the high half.

	R2.L = SIGNBITS R1;

	R2 = R2.L (X);
	R7 = 32;
	R7 = R2 - R7;
	R3 = LSHIFT R0 BY R7.L;	// bits that will be shifted from R0 to R1
	R1 <<= R2;
	R0 <<= R2;
	R1 = R1 | R3;		// incorporate those bits.

	// The most significant bit is now at position 30 (0..31) in R1.
	// We want it at position 20, which is the hidden-bit position

	R3 = R1 << 22;		// the bits that go from R1 to R0
	R7 = R0 << 22;		// the bits that fall off R0
	R0 >>= 10;
	R1 >>= 10;
	R0 = R3 | R0;

	// Clear the hidden bit.

	BITCLR(R1, 20);

	// Bias the exponent.
	R3 = (1023+62) (Z);
	R2 = R3 - R2;

	// Put the exponent into MSB place (leaving room for the sign)

	R2 <<= 20;
	R1 = R2 | R1;

	// At this point, R7 contains the bits that fell off R0 when
	// we normalised. Used these for rounding.
	// R is MSB of R7.
	// S is rest of R7.
	// G is LSB of R0.
	// We round (add 1) if R & (S | G)

	R3 = R7 >> 31;		// R bit
	R2 = R0 << 31;		// G bit
	R7 = R7 | R2;		// S | G
	CC = R7;
	R7 = CC;
	R2 = R3 & R7;		// R & (S | G)

	// When adding the rounding, it can ripple through to high
	// half.

	R0 = R0 + R2;
	CC = CARRY;
	R2 = CC;
	R1 = R1 + R2;

	// Now restore the sign bit.

	CC = P0 < 0;
	R2 = CC;
	R2 <<= 31;
	R1 = R2 | R1;

	R7 = P1;		// Recover old value.
.ret_zero:
	RTS;

.is_32bit:
	LINK 12;
	CALL.X ___floatsidf;
	UNLINK;
	RTS;

.exp_gt_31:
	// The current value fits into 32-bits, but this
	// might be after negating.
	LINK 20;
	[FP-4] = P0;		// whether negated
	[FP-8] = P1;		// old R7 value;
	CALL.X ___floatunsidf;
	R7 = [FP-8];		// restore R7
	R3 = [FP-4];		// whether negated
	UNLINK;
	R2 = R1;		// high half of the result.
	BITTGL(R2, 31);		// negate again
	CC = R3 < 0;		// whether should be negated
	IF CC R1 = R2;
	RTS;
	.size ___floatdidf, .-___floatdidf;


