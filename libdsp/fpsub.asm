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
   This function performs 32 bit floating point subtraction.
   It calls  floating point addition function.
     
  Registers used:
     Operands in  R0 & R1 
     R0 - X operand, R1 - Y operand,R2   
                  
  Special case: 
     IF Y == 0,RETURN X
#endif
  
.text;

.global ___subsf3;
.type ___subsf3, STT_FUNC;

.extern ___addsf3;
.type ___addsf3, STT_FUNC;

.align 2;
___subsf3:
   CC = R1 == 0;           // Check if Y is zero 
   IF CC JUMP RET_X;       // If true, return X 
   BITTGL(R1,31);          // Flip sign bit of Y 
   [--SP] = RETS;          // Push return address on stack 
   SP += -12;
   CALL.X ___addsf3;       // Call addition routine
   SP += 12;
   RETS = [SP++];          // Pop return address on stack

RET_X:
   RTS;
   .size	___subsf3, .-___subsf3
