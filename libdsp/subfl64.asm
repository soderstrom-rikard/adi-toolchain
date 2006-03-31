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
** 64-bit IEEE floating-point subtraction.
**
** This function implements subtraction for the double type.
** double __subdf3 (double X, double Y);
** X is passed in R1:0, Y is passed in R2 and on the stack.
** The result is returned in R1:0.
*/

.extern ___adddf3;
.text;
.align 2;
.global ___subdf3;
.type ___subdf3, STT_FUNC;
___subdf3:
	LINK 16;
	R3 = [FP+20];
	BITTGL(R3, 31);
	[SP+12] = R3;
	CALL.X ___adddf3;
	UNLINK;
	RTS;
	.size	___subdf3, .-___subdf3
