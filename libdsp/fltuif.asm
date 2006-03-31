/*
** Copyright (C) 2000-2006 Analog Devices, Inc.
**
** This file is subject to the terms and conditions of the GNU Library General  
** Public License. See the file "COPYING.LIB" in the main directory of this  
** archive for more details.  
**
** Non-LGPL License also available as part of VisualDSP++  
** http://www.analog.com/processors/resources/crosscore/visualDspDevSoftware.html
*/

#if 0
   This function converts a integer to a floating point number. 

   As floating point number is represented by 23 bits of mantissa, 
   converted value is accurate only  to 23 most significant bits 
   (MSB) of the given integer number excluding sign bit. 
   if the given number is power of 2,then float value of it matches
   exactly.    
    
   Registers used  :
    R0 -         Input/output  parameter
    R1-R3    

#endif
 
.text;

.extern ___addsf3;
.extern ___floatsisf;

.align 2;
.global ___floatunsisf;
.type ___floatunsisf, STT_FUNC;
___floatunsisf:
	R1 = 0;                    // Test for zero input
	CC = R0 == R1;
	IF CC JUMP return_zero;    // Input zero, return zero
	CC = BITTST(R0,31);
	IF CC JUMP nonzeromsb (bp);// Input value has msb set.
	R2 = R0;
	R1.L = SIGNBITS R2;        // Get redundant sign bits
	R1 = R1.L (Z);
	R2 = ASHIFT R2 BY R1.L;    // Normalize input
	R3 = 29;                   // Offset for input value of 1
	R3 = R3 - R1;              // Compute unbiased exponent
	R0 = 127;                  // Load exponent bias
	R1 = R3 + R0;              // Compute final biased exp
	R3 = 0x7F (Z);             // calculate rounding bits
	R3 = R3 & R2;              // from significand & 0x7F
	R0 = 0x40 (Z);             // significand + round increment
	R2 = R0 + R2;
	R2 >>= 7;                  // shift significand to normal position
	BITTGL(R3, 6);             // round to nearest even as follows:
	CC = R3 == 0;              // sig &= ~((round bits ^ 0x40)==0)
	R3 = CC;
	R3 = ~R3;
	R2 = R2 & R3;
	CC = R2 == 0;              // if sig = 0, exp = 0
	IF CC R1 = R2;
	R0 = R1 << 23;             // Shift exponent into position
	R0 = R2 + R0;
	RTS; 
nonzeromsb:
	[--SP] = R0;
	[--SP] = RETS;
	R0 >>= 1;						// Convert input/2
	CALL.X ___floatsisf;
	RETS = [SP++];
	R1 = 0;							// double the converted value		
	BITSET(R1, 23);				// by adding an unbiased exponent 
	R0 = R0 + R1;					// of one 
	R2 = [SP++];
	CC = BITTST(R2,0);			// if the input LSB was set, add 1.0 
	R1.H = 0x3F80;				 	// to the result 
	IF CC JUMP jump_to_float32_add;	// This will return to caller
	RTS;

return_zero:
	RTS;

jump_to_float32_add:
	JUMP.X ___addsf3;

	.size ___floatunsisf, .-___floatunsisf;

// end of file

