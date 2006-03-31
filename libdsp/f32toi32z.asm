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
*/

#if 0
    This program converts a floating point number to a 32-bit integer.

    Does not support:
      denormalized numbers 

    returns:
      0 for -0.0
      0 for NaN's
      0x7fffffff for Inf 
      0x80000000 for -Inf 

    Registers used :
     R0 - Input/output parameter 
     R1 - R3, CC
#endif
     
.text;

.align 2;
.global ___fixsfsi;
.type ___fixsfsi, STT_FUNC;
___fixsfsi:
         
     
                                     // Check for zero input
   R2 = R0 << 1;                     // remove sign bit
   CC = R2 == 0;
   IF CC JUMP .ret_zero;
       
                                     // Check for other exceptional values.
   R3 = 0xff (Z);
   R3 <<= 24;
   CC = R3 <= R2 (IU);
   IF CC JUMP .inf_or_nan;


   R2 = R2 >> 24;                    // Bring exponent to LSB 

   R1 = 150;                         // 127 + 23 offset for float to int 1 
   R3 = R2 - R1;                     // unbiased exponent                   
   R2 = R0 << 9;                     // MSB r2 will have mantissa 
       
   R2 = R2 >> 9;                     // Position mantissa 
   BITSET(R2,23);                    // Implicit 1 for hidden bit made explicit, 
   CC = BITTST(R3,31);
   R3 = ABS R3;
   R1 = R0;
   R0 = ASHIFT R2 BY R3.L (S);       // Shift mantissa by exponent 
   R2 >>= R3;			     // Logical rshift equiv. for neg shift
   IF CC R0 = R2;		     // If negative, copy in rshift to res.
   CC = BITTST(R1,31);
   R1 = -R0;
   IF CC R0 = R1;
   RTS;    

.inf_or_nan:
   // It's an Inf or a NaN. If it's an Inf, then mantissa will be all zero.

   CC = R3 < R2 (IU);
   IF CC JUMP .is_nan;

   CC = BITTST(R0, 31);              // Check for sign of input 
   IF CC JUMP .neg_inf;              // if negative, return negative inf

   R0.H = 0x7FFF;
   R0.L = 0xFFFF;
   RTS;

.neg_inf:
   R0.H = 0x8000;
   R0.L = 0x0000;
   RTS;

.is_nan:
.ret_zero:                           // if we jump here R0==(+/-)0.0/NaN
                                     // We just return zero.
   R0 = 0;
   RTS;
   .size ___fixsfsi, .-___fixsfsi;

// end of file
