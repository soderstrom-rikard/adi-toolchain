/*
** Copyright (C) 2002-2005 Analog Devices, Inc. All Rights Reserved.
** unsigned long long multiplication:
** unsigned long long muli64(unsigned long long, unsigned long long)
**
** !!NOTE- Uses non-standard clobber set in compiler:
**         DefaultClobMinusPA0BIMandLoopRegs
**
** Note that any changes to the clobber set also affects remu64.asm
*/

.file_attr libGroup      = integer_support;
.file_attr libName = libdsp;
.file_attr prefersMem    = internal;
.file_attr prefersMemNum = "30";
.file_attr libFunc = ___mullu3;
.file_attr FuncName      = ___mullu3;

.section program;
.align 2;
___mullu3:
	// We are using normal stores rather than pushes to allow
	// multi-issuing, but since they are post- rather than pre-decrement,
	// we first need to decrement SP to prevent clobbering half of the
	// second operand, that is on the top of the stack.
	SP += -4;
        R5=(A1 = R0.L*R2.L) (FU) || [SP--] = R5;
        R5 = R5.L (Z);
        A1 = A1 >> 16;
        A1 += R0.H * R2.L (FU) || [SP--] = R6;
        A1 += R0.L * R2.H (FU) || R3 = [SP+24];
        R6 = A1.W;
        R6 = R6 << 16;
        A1 = A1 >> 16;
        R6 = R6 | R5;
        A1 += R3.L * R0.L (FU) || [SP] = R7;
        A1 += R2.L * R1.L (FU);
        A1 += R0.H * R2.H (FU);
        R5 = A1.W;
        R5 = R5.L (Z);
        A1 = A1 >> 16;
        A1 += R1.H * R2.L (FU);
        A1 += R3.H * R0.L (FU);
        A1 += R1.L * R2.H (FU);
        A1 += R3.L * R0.H (FU) || R7 = [SP++];
        R3 = A1.W;
        R0 = R6;
        R3 = R3 << 16 || R6 = [SP++];
        R1 = R5 | R3;
        R5 = [SP++];
        RTS;
.___mullu3.end:
.global ___mullu3;
.type ___mullu3, STT_FUNC;
