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
** Addition of two double-precision IEEE floating-point
** numbers. R0=low(X), R1=high(X), R2=low(Y), [SP+12]=high(y).
** low(result) returned in R0. high(result) returned in R1.
**
** double __adddf3(double, double)
*/

#define CARRY AC0

#define NEGATE64(_rlo,_rhi,_rtmp) \
	_rlo = - _rlo; \
	CC = CARRY; \
	CC = !CC; \
	_rhi = - _rhi; \
	_rtmp = CC; \
	_rhi = _rhi - _rtmp

#define NEGATE128(_r3, _r2, _r1, _r0, _rtmp) \
	_r3 = ~ _r3; \
	_r2 = ~ _r2; \
	_r1 = ~ _r1; \
	_r0 = ~ _r0; \
	_r0 += 1; \
	CC = CARRY; \
	_rtmp = CC; \
	_r1 = _r1 + _rtmp; \
	CC = CARRY; \
	_rtmp = CC; \
	_r2 = _r2 + _rtmp; \
	CC = CARRY; \
	_rtmp = CC; \
	_r3 = _r3 + _rtmp

.text;
.align 2;
.global ___adddf3;
.type ___adddf3, STT_FUNC;
___adddf3:
	R3 = [SP+12];			// Recover high(Y)
	[--SP] = (R7:4);

	// Check for addition of zero.

	R4 = R3 << 1;			// is Y 0.0 or -0.0?
	R4 = R4 | R2;
	CC = R4 == 0;
	IF CC JUMP .return_x;

	R4 = R1 << 1;			// is X 0.0 or -0.0?
	R4 = R4 | R0;
	CC = R4 == 0;
	IF CC JUMP .return_y;

	// Extract the exponents of X and Y: 11 bits,
	// starting at position 20 in the high half.
	R4.L = (20<<8) | 11;
	R6 = EXTRACT(R1, R4.L) (Z);	// eX
	R7 = EXTRACT(R3, R4.L) (Z);	// eY

	// Compute difference D between exponents
	R4 = R6 - R7;			// D

	// If D > 53, then Y is too insignificant to have
	// an effect on the result - just return X.
	R5 = 53 (Z);
	CC = R5 < R4;
	IF CC JUMP .return_x;

	// Conversely, if D < -53, X is too insignificant
	// to have an effect on Y, so return Y.
	R5 = -R5;
	CC = R4 < R5;
	IF CC JUMP .return_y;

	// There is a boundary case, where abs(D)==53,
	// where the smaller value is just large enough
	// to affect the result during the rounding
	// process. That's handled in the normal course
	// of events.

	// We want X to be the most significant of the two
	// operands and we're adjusting Y to align. So if
	// eY is the most significant (D is negative), swap
	// X and Y, and negate D.

	CC = R4 < 0;
	IF CC JUMP do_swap;
	CC = R4 == 0;		// If D is 0, but Y's mantissa is larger
	IF !CC JUMP no_swap;	// than X's, then we still want to swap.
				// D==0, so have to see whether R1:0 < R3:2.
				// Complicated by needing to ignore the
				// sign bits.
	P2 = R6;		// Need a spare reg so save eX briefly
	R6 = R1 << 1;		// X without sign (high)
	R5 = R3 << 1;		// Y without sign (high)
	CC = R6 < R5 (IU);	// X (high) < Y (high)
	IF CC JUMP do_swap;	// If Y's most sig, do swap. But if the highs
	CC = R6 == R5;		// match, we have to consider the lows too.
	R6 = P2;		// Restore eX, since we're finished with R6.
	IF !CC JUMP no_swap;	// Highs different, so X most sig.
	CC = R0 < R2 (IU);	// Highs match, so consider lows: X < Y.
	IF !CC JUMP no_swap;	// And if not, skip over the swapping.
do_swap:
	R6 = P2;		// Restore eX from saved value (possibly again)
	R4 = -R4;		// negate D (making it positive)

	R5 = R0;		// Low halves
	R0 = R2;
	R2 = R5;

	R5 = R1;		// High halves
	R1 = R3;
	R3 = R5;

	R6 = R7;		// eX = eY
no_swap:

	// At this point, we know that D >= 0, and that
	// either eX was greater than eY, or that we've
	// copied eY to eX, so eX contains the exponent
	// of the most significant value. We declare
	// eX to be eR, the exponent of the result, now
	// in R6.

	// Note whether the signs are different.

	R5 = R1 ^ R3;
	P1 = R5;

	// Grab the sign bit from X - this'll be the default
	// sign of our result. Store it for later.

	R5 = R1 >> 31;
	R5 <<= 2;
	P0 = R5;		// P0.2

	// Make the hidden bits (bit 52) of the mantissas
	// explicit, and remove the exponent/sign bits of
	// the high halves.

	R5.H = 1;
	R5.L = (20 << 8) | 12;
	R1 = DEPOSIT(R1, R5);
	R3 = DEPOSIT(R3, R5);

	// Current register usage:
	// R1:0 mX, R3:2 mY, R4 D, R6 eR.
	// P0 flags, P1 sign different.

	// If the signs of X and Y differ, then negate
	// the mantissa of the negative operand, and
	// record that this has happened. The two flags
	// for this are:
	// P0.0: X negated.
	// P0.1: Y negated.
	// Both are currently false.

	CC = P1 < 0;
	R5 = P0;
	IF !CC JUMP .signs_match (bp);

	// If X is negative, negate mX.
	CC = BITTST(R5, 2);
	IF !CC JUMP .negate_y;

	// Negating mX
	NEGATE64(R0, R1, R5);
	P0 += 1;		// Set "mX negated"
	JUMP .signs_match;

.negate_y:
	// Negating mY
	NEGATE64(R2, R3, R5);
	P0 += 2;		// Set "mY negated"

.signs_match:

	// Now shift mY right D spaces, to align it with mX,
	// shifting in 1 bits (mY was negated) or 0 bits (it
	// wasn't). Note that if mY *was* negated, we'll have
	// inverted the high bits of its high half. Set up the
	// "lost" bits.

	I2 = 0;			// lost lo
	I3 = I2;		// lost hi

	CC = R4 == 0;		// If D==0, then we're
	IF CC JUMP .y_aligned;	// already aligned.
	R5 = 53;		// And if D==53, then
	CC = R4 == R5;		// we're going to have the hidden
	IF CC JUMP .max_shift;	// in the R space, so handle that.

	// 0 < D < 53, so we have to do some work here. Save mX
	// for later, so that we have some space to work.

	I0 = R0;		// mX lo
	I1 = R1;		// mX hi

	// If D <= 32, then all the shifted bits will go into
	// the high half of the lost area. If 33<=D<=52, then
	// some will make it all the way to the low half of the
	// lost area. Handle these two cases separately.

	R5 += -21;		// now 32
	CC = R5 < R4;
	IF CC JUMP .shift_to_low_half;

	// 1 <= D <= 32, so we're only shifting as far as the
	// high half.

	R7 = R5 - R4;		// 32 - D
	R1 = R2;
	R1 <<= R7;		// lost hi = D bits from mY lo
	R2 >>= R4;		// shift mY lo down D spaces
	R0 = R3;
	R0 <<= R7;		// tmp = D bits from mY hi
	R2 = R2 | R0;		// mY lo |= tmp
	R3 >>>= R4;		// shift mY hi down D spaces
	R0 = 0;			// lost lo = 0 (bits don't reach this far)

	// Put the lost bits elsewhere, and restore mX.
	I2 = R0;
	I3 = R1;
	R0 = I0;
	R1 = I1;
	JUMP .y_aligned;

.shift_to_low_half:

	// 33 <= D <= 51, so we'll reach as far as the low half
	// of the lost bits. The lost bits, in effect become
	// a copy of mY<<(64-D). So do it that way.

	M0 = R6;		// eR (get a little more workspace)

	R0 = R2;
	R1 = R3;
	R5 <<= 1;		// Now 64
	R7 = R5 - R4;		// 64 - D
	R5 >>= 1;		// Back to 32
	R5 = R5 - R7;		// 32 - (64 - D)
	R1 <<= R7;		// "lose" bits still in mY lo
	R6 = R0;		// get the bits from lo that
	R6 >>= R5;		// moves to hi
	R1 = R1 | R6;		// and OR in
	R0 <<= R7;		// then lose them from lo

	// Save the "lost" bits
	I2 = R0;
	I3 = R1;

	// Although we've computed the lost bits, we still need
	// to remove them from mY. All of mY lo will be lost,
	// mY hi will move into mY lo (and some maybe lost), and
	// mY hi will be left as just sign-bits.

	R5 = 32;
	R5 = R4 - R5;		// D - 32
	R2 = R3;
	R2 >>>= R5;		// Move mY hi bits to mY lo
	R3 >>>= 31;		// Fill mY hi with sign bits

	// Restore mX, and eR
	R0 = I0;
	R1 = I1;
	R6 = M0;

.y_aligned:
	// Register usage:
	// R1:0 mX, R3:2 mY, R4 D, R6 eR, I3:2 lost bits
	// mX and mY are now aligned, and can be added.

	R0 = R0 + R2;		// Add low halves
	CC = CARRY;
	R5 = CC;
	R1 = R1 + R5;
	R1 = R1 + R3;		// Add carry and high halves
	CC = P1 < 0;		// Do X and Y have different sign?
	R5 = CC;
	CC = BITTST(R1, 21);	// And did we carry into bit 21?
	R5 = ROT R5 BY 1;
	CC = R5 == 1;		// If same sign and carry

	// Restore the lost bits, into R3:2

	R3 = I3;
	R2 = I2;

	// Was there a carry? If so, and X and Y had the same
	// sign, then there's been a carry into the exponent
	// space. We have to shift mR right one space, propagating
	// down through the lost bits.

	IF CC JUMP .carry_into_exponent;

	// Reg usage:
	// R1:0 mR, R3:2 lost bits, R4 D, R6 eR.
	// If we negated X (flagged in P0.0), then we need to
	// negate the result mantissa, including all the lost
	// bits. We do this by negating all the bits, and adding
	// one, rippling any carry upwards.

	R5 = P0;
	CC = BITTST(R5, 0);
	IF CC JUMP .negate_result;

.normalizing:
	// Normalising. We need to left-shift R1:0:3:2 until
	// there is a 1 bit in position 52 (position 20 of R1).

	R5.L = SIGNBITS R1;	// we know that the top 11
	R5 = R5.L (X);		// bits of R1 will be zeros
	R5 += -10;		// (but signbits gives number-1)
	CC = R5 == 0;		// 11 zeros, then a one - means
	IF CC JUMP .normalized;	// there's a 1 in posn 12, so
				// we're already normalized.
	R7 = 21 (Z);		// Whereas if signbits gave us 31
	CC = R5 == R7;		// then we have to get our one-bit
	IF CC JUMP .normalize_from_low;	// from R0 (or lost bits)

	// There's a one bit somewhere in R1, and it needs left-shifting
	// N=R5 places. That means N bits need moving between registers,
	// and that's equivalent to right-shifting them M=32-N places.

	R7 += 11;		// R7 now 32;

.normalizing_left:
	R4 = R7 - R5;

	R7 = R0;
	R7 >>= R4;		// bits from R0 => R1
	R1 <<= R5;		// make space in R1
	R1 = R1 | R7;		// and include them.

	R7 = R3;
	R7 >>= R4;		// bits from R3 => R0
	R0 <<= R5;		// make space in R0
	R0 = R0 | R7;		// and include them.

	R7 = R2;
	R7 >>= R4;		// bits from R2 => R3;
	R3 <<= R5;		// make space for them
	R3 = R3 | R7;		// and include them.

	R2 <<= R5;		// and shift R2 up, too.

	// Now that we've moved the one-bit into posn 20 of R1
	// (position 52 of mR), we're normalized, so adjust the
	// exponent eR to reflect this.

	R6 = R6 - R5;

.normalized:

	// Check whether we've generated a zero mantissa.
	// If so, make the exponent zero too.

	R7 = R1 | R0;
	CC = R7 == 0;
	IF CC R6 = R7;

	// At this point, the IEEE hidden bit is at position
	// 52 (20 in R1), and explicit. We now make it implicit.

	BITCLR(R1, 20);

	// Now rounding. G is the Guard bit, the LSB of mR,
	// and hence LSB of R0. R is the Rounding bit, the
	// MSB of the lost bits, hence MSB of R3. S is the
	// Sticky bit, and is the OR of all the lost bits
	// apart from R. hence all of R2, and all of R3
	// apart from the MSB. We round iff R&(S|G) is true.

	R7 = R3 << 1;		// R3's S bits
	R7 = R7 | R2;		// the remaining S bits
	CC = R7;
	R7 = CC;		// R7 now S.
	CC = BITTST(R0, 0);	// Test G
	R4 = CC;
	R7 = R7 | R4;		// S|G
	CC = BITTST(R3, 31);	// Test R
	R4 = CC;
	R7 = R7 & R4;		// R&(S|G)

// put exponent into correct position, and then add in
// rounding. If the rounding overflows, it'll increment the
// exponent too.

	R6 <<= 20;		// align exponent
	R1 = R1 | R6;		// include exponent
	R0 = R0 + R7;		// Round lower bits
	CC = CARRY;
	R7 = CC;
	R1 = R1 + R7;		// and ripple up
	R1 <<= 1;		// Prepare to receive sign bit
	R5 = P0;		// Recover flags
	CC = BITTST(R5, 2);	// Note sign
	R1 = ROT R1 BY -1;	// and move into result

	(R7:4) = [SP++];
	RTS;
	

// ===========================================================

.carry_into_exponent:
	CC = !CC;		// CC now 0
	R1 = ROT R1 BY -1;	// ripple the bits down
	R0 = ROT R0 BY -1;
	R3 = ROT R3 BY -1;
	R2 = ROT R2 BY -1;
	R6 += 1;		// increment exponent.
	JUMP .normalized;	// goto step 10;

.negate_result:
	NEGATE128(R1, R0, R3, R2, R5);
	JUMP .normalizing;	// Goto Step 9

.normalize_from_low:

	// We want to normalize R1:0, putting a one-bit into
	// position 20 of R1, but there are no one-bits in R1.
	// There's probably one in R0, in which case we've got
	// to shift everything up by a whole register, as well
	// as adjusting. But first check the pathological case,
	// where there isn't a one-bit in R0 either.

	CC = R0 == 0;
	IF CC JUMP .normalize_from_lost;

	// We know there's a one-bit somewhere, so we'll
	// be moving (R1, R0, R3, R2) to become
	// (R0, R3, R0, 0), effectively. Do that now.

	R1 = R0;
	R0 = R3;
	R3 = R2;
	R2 = 0;

	// Since this is effectively a left-shift of 32,
	// update the exponent eR to record this.

	R7 = 32 (Z);
	R6 = R6 - R7;

	// If R1 is negative, then there's a 1 at the MSB.

.shifted_regs:
	R5 = 0;
	R7 += -21;		// R7 now 11.
	CC = R1 < 0;
	IF CC JUMP .normalize_to_right;

	R5.L = SIGNBITS R1;
	R5 = R5.L (X);
	R5 += 1;		// Because signbits returns n-1.

	// R5 now holds the number of zeroes before the one-bit.
	// If there are eleven, then the one-bit is in the right
	// place. If there are more than eleven, a left-shift is
	// involved. If there are less than eleven, a right-shift
	// is needed. Plus a rotation of registers.
	CC = R5 <= R7;
	IF CC JUMP .normalize_to_right;

	// Adjust R5, so that it's the amount to shift, to get
	// the bit into the right place.

	R5 = R5 - R7;

	// We need to left-shift N=R5 bits. We shift right by
	// M=32-N to get the moved bits into the position they're
	// be in, in the dest reg.

	R7 += 21;		// R7 now 32 again

	// R5 is N=amount to shift left. R7=32.
	// So treat as a left-shift with one-bit in R1.

	JUMP .normalizing_left;

.normalize_to_right:

	CC = R5 == R7;
	IF CC JUMP .normalized;

	// Adjust R5, so that it's the amount to shift, to get
	// the bit into the right place.

	R5 = R7 - R5;

	// Now to shift right by N=R5. So bits that move between
	// regs will be left-shifted by M=32-N bits to get them
	// into the right place.

	R7 += 21;		// R7 now 32 again
	R4 = R7 - R5;

	R2 = R3;		// R2 already 0, so it becomes
	R2 <<= R4;		// the bits coming back from R3.

	R7 = R0;
	R7 <<= R4;		// bits moving R0 => R3
	R3 >>= R5;		// make room in R3
	R3 = R3 | R7;		// and include bits

	R7 = R1;
	R7 <<= R4;		// bits moving R1 => R0
	R0 >>= R5;		// make room in R0
	R0 = R0 | R7;		// and include them.

	R1 >>= R5;		// move R1 down.

	// Since we've shifted, update exponent eR
	// to reflect this.

	R6 = R6 + R5;

	JUMP .normalized;

.normalize_from_lost:
	// no one bits in R1 *or* R1. Any in R3:2?

	R5 = R3 | R2;
	CC = R5 == 0;
	IF CC JUMP .normalized;	// Nope. All zeroes.

	// There's a one-bit somewhere in R3:2. First,
	// shift left 64 bits, up to R1:0. Shift zeroes into
	// R3:2, and update the exponent.

	R6 += -64;		// shifted by 64.
	R5 = R6;
	R5 += -32;
	R1 = R3;		// move lost bits from
	R0 = R2;		// R3:2 to R1:0, and
	R3 = 0;			// set R3:2 to all zeroes.
	R2 = R3;
	CC = R1 == 0;		// Then, if R1 still all zeroes
	IF CC R1 = R0;		// shift left another 32 bits,
	IF CC R0 = R3;		// and update exponent again.
	IF CC R6 = R5;
	R7 = 32 (Z);		// Expected, at that point.
	JUMP .shifted_regs;

.max_shift:
	// D==53, so we want to right-shift mY 53 places.
	// This moves all the bits into the "lost" space,
	// with the hidden bit in the R rounding position.

	R3 <<= 11;
	R5 = R2 >> 21;
	R3 = R3 | R5;
	R2 <<= 11;
	I3 = R3;
	I2 = R2;
	R2 = 0;
	R3 = 0;
	JUMP .y_aligned;

.return_y:
	R0 = R2;
	R1 = R3;
.return_x:
	(R7:4) = [SP++];
	RTS;
	.size	___adddf3, .-___adddf3
