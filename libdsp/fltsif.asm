/************************************************************************
 *
 * fltsif.asm : $Revision$
 *
 * (c) Copyright 2000-2004 Analog Devices, Inc.  All rights reserved.
 *
 ************************************************************************/

#if 0
   This function converts a integer to a floating point number. 

   As floating point number is represented by 23 bits of mantissa, 
   converted value is accurate only  to 23 most significant bits 
   (MSB) of the given integer number excluding sign bit. 
   if the given number is power of 2,then float value of it matches
   exactly.    
    
   Registers used  :
    R0 -         Input/output  parameter
    R1-R3, P0    

#endif
 
.text;

.align 2;
.global ___floatsisf;
.type ___floatsisf, STT_FUNC;
___floatsisf:
	CC = R0 == 0;					// Test for zero input  
	IF CC JUMP return_zero;		// Input zero, return zero  
	R1 = 0;
	BITSET(R1,31);
	CC = R0 == R1;
	IF CC JUMP return_int_min;	// Input value is min int.
	R2 = ABS R0;					// Absolute of input   
	R1.L = SIGNBITS R2;			// Get redundant sign bits 
	R1 = R1.L (Z);
	R2 = ASHIFT R2 BY R1.L;		// Normalize input 
	P0 = R0;							// Save original input for later;
	R3 = 29;							// Offset for input value of 1 
	R3 = R3 - R1;					// Compute unbiased exponent 
	R0 = 127;						// Load exponent bias       
	R1 = R3 + R0;					// Compute final biased exp     
	R3 = 0x7F (Z);					// calculate rounding bits
	R3 = R3 & R2;					// from significand & 0x7F
	R0 = 0x40 (Z);					// significand + round increment
	R2 = R0 + R2;
	R2 >>= 7;						// shift significand to normal position
	BITTGL(R3, 6);					// round to nearest even as follows: 
	CC = R3 == 0;					// sig &= ~((round bits ^ 0x40)==0) 
	R3 = CC;
	R3 = ~R3;
	R2 = R2 & R3; 
	CC = R2 == 0;					// if sig = 0, exp = 0 
	IF CC R1 = R2;	
	R0 = R1 << 23;					// Shift exponent into position
	R0 = R2 + R0;	
	CC = P0 < 0;					// Test for negative input   
	IF CC JUMP putsign;                             
	RTS;								// if positive, return result 

return_int_min:
	R0.H = 0xCF00;					// Return float rep of min int
	RTS;

putsign:    
   BITSET(R0,31);					// if negative, set sign bit 

return_zero:						// assert R0==0 if we jump here 
   RTS;

   .size ___floatsisf, .-___floatsisf;

// end of file

