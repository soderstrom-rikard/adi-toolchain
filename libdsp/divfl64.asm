/*
** Copyright (C) 2003-2006 Analog Devices, Inc.
**
** This file is subject to the terms and conditions of the GNU General  
** Public License. See the file COPYING in the main directory of this  
** archive for more details.
**
** In addition to the permissions in the GNU General Public License,
** Analog Devices gives you unlimited permission to link the
** compiled version of this file into combinations with other programs,
** and to distribute those combinations without any restriction coming
** from the use of this file.  (The General Public License restrictions
** do apply in other respects; for example, they cover modification of
** the file, and distribution when not linked into a combine
** executable.)  
**
** Non-GPL License also available as part of VisualDSP++  
** http://www.analog.com/processors/resources/crosscore/visualDspDevSoftware.html
**
** 64-bit floating-point division.
**
** This is the internal function implementing emulation of IEEE
** double-precision floating point division (X/Y). X is received
** in R1:0, Y is received in R2 and on the stack. The result is
** returned in R1:0.
**
** double __divdf3(double, double);
*/

#define CARRY AC0

.text;
.align 2;
.global ___divdf3;
.type ___divdf3, STT_FUNC;
___divdf3:
	R3 = [SP+12];			// Recover high half of Y.
	[--SP] = (R7:4);		// Claim some workspace.

	// Note the sign sR of the result, which is the exclusive-OR
	// of the signs of X and Y.

	R4 = R1 ^ R3;
	P0 = R4;

	// Discard the signs of the operands, and check for
	// division by zero, returning the appropriate Infinity.

	BITCLR(R1, 31);
	BITCLR(R3, 31);
	R6 = R3 | R2;
	CC = R6 == 0;
	IF CC JUMP .div_zero;

	R6 = R1 | R0;
	CC = R6 == 0;
	IF CC JUMP .return_zero;

	// Extract the exponents of X and Y, and compute the
	// result exponent eR = eX - eY + 1023 (both eX and eY
	// have the bias of 1023 added in; removing one bias is
	// the same as removing a bias from each of eX and eY,
	// subtracting, and adding a bias back to eR).

	R5.L = (20<<8) | 11;	// eleven bits at posn 20.
	R6 = EXTRACT(R1, R5.L) (Z);
	R7 = EXTRACT(R3, R5.L) (Z);
	R6 = R6 - R7;
	R7 = 1023 (Z);
	R6 = R6 + R7;

	// We may have overflowed, producing a larger exponent
	// than can be expressed. If so, return the appropriate
	// Infinity.
	R7 = 2047 (Z);
	CC = R7 < R6;

	// Clear the exponents out of X and Y, leaving just
	// mX and mY.

	R1 <<= 12;
	R1 >>= 12;
	R3 <<= 12;
	R3 >>= 12;

#if 0
	// The two mantissas may be equal. If they are,
	// then we can return a value of 1.0.

	CC = R1 == R3;
	R5 = R0 - R2;
	CC &= AZ;
	IF CC JUMP .ret_one;
#endif

	// Make the IEEE hidden bits explicit, at posn 52
	// (posn 20, in the high halves).

	BITSET(R1, 20);
	BITSET(R3, 20);

	// Prepare for the division sequence. The algorithm is:
	// P = X
	// R = 0
	// if (Y < P) then
	//	P = P - Y
	//	n = 63
	// else
	//	n = 64
	// for i = 1 to n
	//	if (Y < P) then
	//		P = P - Y
	//		left-shift 1 into LSB of R
	//	else
	//		left-shift 0 into LSB of R
	//	left-shift 0 into LSB of P
	//
	// So we have partial figure P, result R,
	// we're comparing against Y (+Y) and we're
	// subtracting Y (adding -Y), so that gives us
	// four 64-bit values to maintain in the loop:
	// P (starts out as mX) in R1:0.
	// R (starts out as 0) in I1:0
	// Y (is mY) in R3:2
	// -Y (is -mY) in I3:2

	P1 = R6;	// save eR
	I0 = 0;		// R starts at 0
	I1 = I0;

	R6 = -R2;	// negate Y
	CC = CARRY;
	CC = !CC;
	R5 = CC;
	R7 = -R3;
	R7 = R7 - R5;
	I3 = R7;
	I2 = R6;

	P2 = 64;	// Assume max iterations

	// Compare Y<P, i.e. R3:2 < R1:0

	CC = R3 < R1 (IU);
	R7 = CC;
	CC = R3 == R1;
	R7 = ROT R7 BY 1;
	CC = R2 < R0 (IU);
	R7 = ROT R7 BY 1;
	CC = R7 < 3;
	IF CC JUMP .max_iterations;

	// Do P = P - Y (P = P + -Y), and knock off an iteration.
	R6 = I2;	// Recover -Y
	R7 = I3;
	P2 += -1;	// one less iteration
	R0 = R0 + R6;	// Add -Y to P
	CC = CARRY;
	R6 = CC;
	R1 = R1 + R7;
	R1 = R1 + R6;

.max_iterations:
	LSETUP(.start, .end) LC0 = P2;
.start:	
	CC = R3 < R1 (IU);
	R7 = CC;
	CC = R3 == R1;
	R7 = ROT R7 BY 1;
	CC = R2 < R0 (IU);
	R7 = ROT R7 BY 1;
	CC = R7 < 3;
	CC = !CC;
	R5 = CC;
	R6 = I2;	// Recover -Y
	R7 = I3;
	IF !CC R6 = R5;	// but if comparison failed, then just
	IF !CC R7 = R5;	// add zeroes instead
	R0 = R0 + R6;	// Add -Y to P
	CC = CARRY;
	R6 = CC;
	R1 = R1 + R7;
	R1 = R1 + R6;
	R7 = I1;	// Recover R
	R6 = I0;
	R5 = ROT R5 BY -1;	// Move result cmp into CC
	R6 = ROT R6 BY 1;	// Rotate in result of comparison
	R7 = ROT R7 BY 1;
	I0 = R6;		// and store R for next iteration
	I1 = R7;
	R5 = ROT R5 BY -1;	// Set up a 0 for shifting into P
	R0 = ROT R0 BY 1;	// and move into P.
.end:	R1 = ROT R1 BY 1;

	// At this point, our result is in I1:0 (and R7:6).
	// The inputs were in 12.52 format, and the output is
	// in 2.62 format. We need to normalise it, so that
	// the decimal point appears between bit 51 and 52.
	// Since it's currently between bits 61 and 62, that's
	// a right-shift of ten places.

	R2 = R6 << 22;		// Keep what we lose off the bottom
	R5 = R7 << 22;
	R0 = R6 >> 10;
	R0 = R5 | R0;
	R1 = R7 >> 10;

	// Our result is now in R1:0. Restore the exponent.

	R4 = P1;

	// If the IEEE hidden bit is set, then there's overflow
	// into the exponent space, so right-shift and increment
	// exponent.

	CC = BITTST(R1, 20);
	IF CC JUMP .clear_hidden;
.hidden_cleared:
	CC = R4 < 0;
	IF CC JUMP .denorm;

.rounding:

	// Determine whether we need to round. Normally based on:
	// - the Guard bit G (LSB of mR, i.e. R0.0)
	// - the round bit R (MSB of lost bits, i.e. R2.31)
	// - the stick bit S (rest of lost bits, ORed together)
	// - Round if (R & (G|S)).
	// But not for division. Here, we round based on R only.
	// That way, if the two numbers are similar, but slightly different,
	// we get a result slightly different from 1.0. We only get 1.0 if
	// X==Y.

	R3 = R2 >> 31;			// Just R bit

	// R1:0 constains the mantissa. R3 is the rounding bit.
	// R4 is the exponent. If we rounded, would we have a
	// zero mantissa?

	R2 = R0 + R3;
	R2 = R2 | R1;
	CC = R2 == 0;
	IF CC JUMP .return_zero;

	// On the other hand, if we've cranked the exponent
	// up past the limit, return infinity.

	R7 = 2047 (Z);
	CC = R7 < R4;
	IF CC JUMP .return_inf;

	// Combine sign, exponent and mantissa, add in
	// rounding, and return.

	R4 <<= 20;		// Position exponent
	R1 = R4 | R1;		// and combine.
	R0 = R0 + R3;		// Add in rounding bit
	CC = CARRY;		// to R1:0. If we overflow into
	R3 = CC;		// exponent space, it'll zero mantissa,
	R1 = R1 + R3;		// and nudge exponent - possibly to Inf.
	R1 <<= 1;		// Position ready to grab sign.
	CC = P0 < 0;
	R1 = ROT R1 BY -1;	// and pull sign back in.
	(R7:4) = [SP++];
	RTS;

.div_zero:
	R6 = R0 | R1;		// For X/0, return +Inf (X>0), -Inf (X<0)
	CC = R6 == 0;		// or -NaN (X==0).
	IF !CC JUMP .return_inf;
	R0 = -1 (X);
	R1 = R0;
	(R7:4) = [SP++];
	RTS;

.return_inf:
	R0 = 0;
	R1 = 0x7FF (Z);
	R1 <<= 21;
	CC = P0 < 0;
	R1 = ROT R1 BY -1;
	(R7:4) = [SP++];
	RTS;

.return_zero:
	R0 = 0;
	CC = P0 < 0;
	R1 = ROT R0 BY -1;
	(R7:4) = [SP++];
	RTS;

.ret_one:
	// Since mX == mY, we set the mR = 0, and increment
	// the result exponent eR, indicating 1.0, normalised.
	// Note that this could push eR outside of the valid
	// range, in which case we return Infinity instead.

	R0 = 0;
	R6 += 1;
	CC = R7 < R6;		// R7 still 1047
	IF CC JUMP .return_inf;
	R6 <<= 21;
	CC = P0 < 0;
	R1 = ROT R6 BY -1;
	(R7:4) = [SP++];
	RTS;

.clear_hidden:
#if 0
	CC = !CC;	// We know that CC is set, when we get here
			// and we want to shift in a 0.
	// Shuffle everything right one, and increment the
	// exponent.
	R1 = ROT R1 BY -1;
	R0 = ROT R0 BY -1;
	R2 = ROT R2 BY -1;
	R4 += 1;
#endif
	R4 += -1;
	BITCLR(R1, 20);
	JUMP .hidden_cleared;

.denorm:
	// eR < 0, which indicates that we need to produce
	// a denormalised result. Our result is in R1:0,
	// with some lost bits in R2. We right-shift the
	// result -eR spaces, bringing the exponent back to
	// zero. Since we could be shifting more than a whole
	// register, deal with that first.

	R5 = 64 (Z);
	R4 = -R4;		// Make positive, first.
	CC = R5 <= R4;		// Would shift all of the bits
	IF CC JUMP .return_zero;
	R3 = 0;
	R5 >>= 1;		// Now 32.
	CC = R5 <= R4;
	IF CC R2 = R0;		// Shuffle everything down
	IF CC R0 = R1;		// 32 places.
	IF CC R1 = R3;
	R3 = R4 - R5;
	IF CC R4 = R3;
	CC = R4 == 0;		// Is that all we need to do?
	IF CC JUMP .rounding;

	R5 = R5 - R4;		// Still need to shuffle down some more
	R3 = R0;
	R3 <<= R5;
	R2 >>= R4;
	R2 = R3 | R2;

	R3 = R1;
	R3 <<= R5;
	R0 >>= R4;
	R0 = R3 | R3;

	R1 >>= R4;

	R4 = 0;			// Exponent now zero;
	JUMP .rounding;
	.size	___divdf3, .-___divdf3

