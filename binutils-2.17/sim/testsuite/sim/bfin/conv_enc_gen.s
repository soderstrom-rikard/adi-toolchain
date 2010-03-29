# mach: bfin

// GENERIC CONVOLUTIONAL ENCODER
// This a generic rate 1/n convolutional encoder. It computes n output
// bits for each input bit, based on n generic polynomials.
// It uses the set of BXOR_CC instructions to compute bit XOR
// reduction from a state masked by a polynomial.  For an alternate
// solution based on assembling several partial words, as in
// the BDT benchmark, see file conv_enc.c. The solution presented
// here is slower than conv_enc.c, but more generic.
//
// Performance.
// The execution time for this code is approximately 2.5 cycles
// per output bit. The time for the alternate solution for BDT's
// benchmark is 1.3 cycles/out bit. Clearly, this can be seen in the
// inner loops of these codes: former solution requires 2 cycles
// to produce one bit, and latter 1. (The additional 0.5 and 0.3
// are outer-loop and init overheads.)
// This code shows a rate 1/2-system, but has been exercised with
// rate 1/4, giving similar results.
// The advantage of the BXOR solution is that it is more general
// than the alternative, and has nearly 1/3 the amount of code:
// BXOR requires 30 bytes, while BDT requires 100 bytes.
//                                Speed               Code size
//                             cycles/bit   cycles*      bytes
// BXOR:                            2.5      631           30
// A field XOR and interleave:      1.3                   100
// * cycles to process 128 input bits -> 256 output bits
//
// Note that it is possible to achieve 1 cycle/bit + overhead for
// the BXOR solution in the case where the inefficient data
// structure of 1 bit per output word can be used (as in the
// original function Convolutional_Encode()). This can be done
// by storing the output word from BXOR rather than rotating CC.
//
// Forward Shift Register
// -----------------------
// This solution implements the XOR function by shifting the state
// left by one, applying a mask to the state, and reducing
// the result with a bit XOR reduction function.
//    	             ----- XOR------------> G0
// 	             |     |     |  |
//        +------------------------------+
//        | b0 b1 b2 b3          b14 b15 | <- in
//        +------------------------------+
//                   | 	|  |  |	    |
//    	             ----- XOR------------> G1
// Instruction BXOR computes the bit G0 or G1 and stores it into CC
// and also into a destination reg half. Here, we take CC and rotate it
// into an output register.
// However, one can also store the output bit directly by storing
// the register half where this bit is placed. This would result
// in an output structure similar to the one in the original function
// Convolutional_Encode(), where an entire half word holds a bit.
// The resulting execution speed would be roughly twice as fast,
// since there is no need to rotate output bit via CC.

#include "test.h"
.include "testutils.inc"
	start

	loadsym P0, input;
	loadsym P1, output;

	R1 = 0;	R2 = 0;R3 = 0;

	R2.L = 0;
	R2.H = 0xa01d;	// polynom 0
	R3.L = 0;
	R3.H = 0x12f4;	// polynom 1

	// load and  CurrentState to upper half of A0
	A1 = A0 = 0;
	R0 = 0x0000;
	A0.w = R0;
	A0 = A0 << 16;

	// l-loop counter is in P4
	P4 = 2(Z);
	// **** START l-LOOP *****
l$0:

	// insert 16 bits of input into lower half of A0
	// and advance input pointer
	R0 = W [ P0 ++ ] (Z);
	A0.L = R0.L;

	P5 = 2 (Z);
	LSETUP ( m$0 , m$0end ) LC0 = P5;	// **** BEGIN m-LOOP *****
m$0:

	P5 = 8 (Z);
	LSETUP ( i$1 , i$1end ) LC1 = P5;	// **** BEGIN i-LOOP *****
i$1:
	R4.L = CC = BXORSHIFT( A0 , R2 );	// polynom0 -> CC
	R1 = ROT R1 BY 1;			// CC -> R1
	R4.L = CC = BXOR( A0 , R3 );		// polynom1 -> CC
i$1end:
	R1 = ROT R1 BY 1;			// CC -> R1

	// store 16 bits of outdata RL1
m$0end:
	W [ P1 ++ ] = R1;

	P4 += -1;
	CC = P4 == 0;
	IF !CC JUMP l$0;	// **** END l-LOOP *****

				// Check results
	loadsym I2, output;
	R0.L = W [ I2 ++ ];	DBGA ( R0.L , 0x8c62 );
	R0.L = W [ I2 ++ ];	DBGA ( R0.L , 0x262e );
	R0.L = W [ I2 ++ ];	DBGA ( R0.L , 0x5b4d );
	R0.L = W [ I2 ++ ];	DBGA ( R0.L , 0x834f );
	pass

	.data
input:
	.dw 0x999f
	.dw 0x1999

output:
	.dw 0x0000
	.dw 0x0000
	.dw 0x0000
	.dw 0x0000

