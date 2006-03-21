/*
** Copyright (C) 2003-2004 Analog Devices, Inc. All Rights Reserved.
**
** Convert unsigned long long to IEEE double-precision 64-bit
** floating point.
** double __floatundidf (unsigned long long);
*/

#define CARRY AC0

.extern ___floatunsidf;

.text;
.align 2;
.global ___floatundidf;
.type ___floatundidf,STT_FUNC;
___floatundidf:
	// Check for zero first

	R2 = R1 | R0;
	CC = R2 == 0;
	IF CC JUMP .ret_zero;

	// Check whether this is really just a 32-bit value.
	// If so, it's easier to call a different convertion function.

	CC = R1 == 0;
	IF CC JUMP .is_32bit;

	P1 = R7;		// Workspace

	CC = R1 < 0;      // i.e. the MSB (not a sign bit) is set
	IF CC JUMP .big_val;


	// Need to determine what the exponent will be.

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

	R3 = R1 << 22;		// the bits that move from R1 to R0
	R7 = R0 << 22;		// the bits that fall off R0
	R0 >>= 10;
	R1 >>= 10;
	R0 = R3 | R0;

	// Clear the hidden bit.

	BITCLR(R1, 20);

	// Bias the exponent.
	R3 = (1023+62) (Z);
	R2 = R3 - R2;

	// Put the exponent into MSB place (but leave space
	// for sign).

	R2 <<= 20;
	R1 = R2 | R1;

.round_res:
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

	R7 = P1;		// Recover old value.
.ret_zero:
	RTS;

.is_32bit:
	LINK 12;
	CALL.X ___floatunsidf;
	UNLINK;
	RTS;

.big_val:
	// The MSB is set, where we'd expect to find the sign bit,
	// so we know what our exponent will be. Set the values
	// directly.

	R3 = R1 << 21;		// the bits that move from R1 to R0
	R7 = R0 << 21;		// the bits that fall off R0
	R0 >>= 11;
	R1 >>= 11;
	R0 = R3 | R0;

	BITCLR(R1, 20);	// Zap hidden bit (since we know it's set)

	R2 = (1023+63);	// Bias exponent
	R2 <<= 20;			// and position for exponent; sign is positive.
	R1 = R1 | R2;		// and include exponent.
      
      JUMP.X .round_res;

	.size ___floatundidf, .-___floatundidf;


