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
** long double floating-point comparison.
**
** This is the internal function implementing IEEE double-precision
** floating-point comparison. It compares two numbers X and Y.
** If X < Y, it returns <0.
** If X > Y, it returns >0.
** If X == Y, it returns 0.
** NaNs always compare as unequal, and zeroes always compare as equal
** regardless of sign.
**
** X is received in R1:0. Y is received in R2 and on the stack.
** The result is in R0.
** int __cmpdf2 (double, double)
*/

.text;
.align 2;
.global ___eqdf2;
.type ___eqdf2, STT_FUNC;
___eqdf2:
.global ___gedf2;
.type ___gedf2, STT_FUNC;
___gedf2:
.global ___gtdf2;
.type ___gtdf2, STT_FUNC;
___gtdf2:
.global ___ledf2;
.type ___ledf2, STT_FUNC;
___ledf2:
.global ___ltdf2;
.type ___ltdf2, STT_FUNC;
___ltdf2:
.global ___nedf2;
.type ___nedf2, STT_FUNC;
___nedf2:
.global ___cmpdf2;
.type ___cmpdf2, STT_FUNC;
___cmpdf2:
	P0 = R4;		// Grab some workspace.

	// NaNs are represented as all-ones exponent, and
	// a non-zero mantissa. If sign is ignored, then
	// an operand is a NaN if its high half is larger
	// than 0x7FF0, or if its high half is equal to
	// 0x7FF0, and its low half is non-zero.

	// Check X first.

	R4 = R1;		// clear the sign
	BITCLR(R4, 31);
	R3 = 0x7FF;
	R3 <<= 20;		// Set up NaN limit.
	CC = R3 < R4;		// If it's a NaN, it'll do
	IF CC JUMP .ret_y;	// as the return value
	CC = R4 < R3;		// If high-half less than the NaN
	R0 += 0;		// limit, or low-half is zero, it's
	CC |= AZ;		// not a NaN.
	IF !CC JUMP .ret_x;

	// Check Y next

	P1 = R5;		// Need more space
	R5 = R3;		// NaN limit
	R3 = [SP+12];		// Get other half of Y
	R4 = R3;
	BITCLR(R4,31);		// and clear its sign
	CC = R5 < R4;		// If it's over the limit
	IF CC JUMP .ret_y;	// it'll do as the return limit
	CC = R4 < R5;		// If its high-half is less than limit
	R2 += 0;		// or low-half is zero, it's not a
	CC |= AZ;		// a NaN.
	IF !CC JUMP .ret_y;

	// Neither is a Nan. Make any zero operands positive.
	R4 = R4 | R2;		// Check Y == 0
	CC = R4 == 0;
	IF CC R3 = R4;		// and clear sign if so.
	R5 = R1 << 1;
	R5 = R5 | R0;		// Check X == 0;
	CC = R5 == 0;
	IF CC R1 = R5;		// and clear sign if so.

	// Are both zero?
	R4 = R4 | R5;		// both operands without signs
	CC = R4 == 0;		// and if everything is zero, then
	IF CC R3 = R4;		// return zero.
	IF CC JUMP .ret_y;

	// Nope. Are they both the same?
	CC = R0 == R2;
	R4 = R1 - R3;
	CC &= AZ;
	IF CC R3 = R4;		// if so, then return zero.
	IF CC JUMP .ret_y;

	// They're both valid numbers, and X != Y, so do
	// a comparison. And we do a signed comparison,
	// because the remaining floating point values
	// are (almost) ordered like a signed integer range.

	CC = R1 < R3;
	R4 = CC;
	CC = R1 == R3;
	R4 = ROT R4 BY 1;
	CC = R0 < R2 (IU);
	R4 = ROT R4 BY 1;
	R5 = R1 & R3;
	R1 = 1;
	R0 = -R1;
	CC = R4 < 3;
	IF CC R0 = R1;
	R1 = -R0;
	CC = R5 < 0;		// if both are negative
	IF CC R0 = R1;		// negate the result again.
	R5 = P1;
	R4 = P0;
	RTS;

.ret_y:
	R5 = P1;
	R1 = R3;
.ret_x:
	R4 = P0;
	R0 = R1;
	RTS;
	.size ___cmpdf2, .-___cmpdf2;
	.size ___eqdf2, .-___eqdf2;
	.size ___gedf2, .-___gedf2;
	.size ___gtdf2, .-___gtdf2;
	.size ___ledf2, .-___ledf2;
	.size ___ltdf2, .-___ltdf2;
	.size ___nedf2, .-___nedf2;
