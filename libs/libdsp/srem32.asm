/***************************************************************************
Copyright (C) 2000-2006 Analog Devices, Inc.
This file is subject to the terms and conditions of the GNU Lesser
General Public License. See the file COPYING.LIB for more details.

Non-LGPL License is also available as part of VisualDSP++
from Analog Devices, Inc.

****************************************************************************
  File name :  srem32.asm 
 
  This program computes 32 bit signed remainder. It calls div32 function  
  for quotient estimation.

  Registers used :
  Numerator/ Denominator in  R0, R1 
  R0  -  returns remainder.
  R2-R7    
 
Special cases :
			1)	If(numerator == 0) return 0 
		    2)  If(denominator ==0) return 0
          	3)  If(numerator == denominator) return 0
		    4)  If(denominator ==(1||-1)) return 0

	 BLACKFIN  hidden functions
	 IPDC, Bangalore, 24 April 2000.
	 Modified on 14th July 2000
	 Modification include:
	 Removed declaration of external call for ___div32 function. 
    
     Modified for new instruction set 
	 and  tested using Dev13 toolset on    : 13 October 2000 

  !!NOTE- Uses non-standard clobber set in compiler:
          DefaultClobMinusBIMandLoop1Regs

  (32-bit mult clobbers A0 & A1 on Tahoe)

**************************************************************/

#if !defined(__NO_LIBRARY_ATTRIBUTES__)

.file_attr libGroup      = integer_support;
.file_attr libName = libdsp;
.file_attr prefersMem    = internal;
.file_attr prefersMemNum = "30";
.file_attr libFunc = ___rem32;
.file_attr FuncName      = ___rem32;

#endif

.text;
.align 2;

.global ___rem32;
.type ___rem32, STT_FUNC;
.extern ____div32;
___rem32:

	CC=R0==0;
	IF CC JUMP RETURN_R0;		/* Return 0, if numerator  == 0 */
	CC=R1==0;
	IF CC JUMP RETURN_ZERO;		/* Return 0, if denominator == 0 */
	CC=R0==R1;
	IF CC JUMP RETURN_ZERO;		/* Return 0, if numerator == denominator */
	CC = R1 == 1;
	IF CC JUMP RETURN_ZERO;		/* Return 0, if denominator ==  1 */
	CC = R1 == -1;
	IF CC JUMP RETURN_ZERO;		/* Return 0, if denominator == -1 */

	/* Valid input. Use ___div32() to compute the quotient, and then
	   derive the remainder from that. */

	[--SP] = (R7:6);		/* Push  R7 and R6 */
	[--SP] = RETS;			/* and return address */
	R7 = R0;			/* Copy of R0 */   
	R6 = R1;			/* Save for later */
	SP += -12;			/* Should always provide this space */
	CALL.X ____div32;			/* Compute signed quotient using ___div32()*/
	SP += 12;
	R0 *= R6;			/* Quotient * divisor */
	R0 = R7 - R0;			/* Dividend - ( quotient *divisor) */
	RETS = [SP++];			/* Get back return address */
	(R7:6) = [SP++];		/* Pop registers R7 and R4 */
	RTS;				/* Store remainder    */

RETURN_ZERO:
	R0 = 0;
RETURN_R0:
	RTS;
.size ___rem32, .-___rem32
