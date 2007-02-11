/*
 * regs.h
 *
 * Copyright (C) 2007 Analog Devices, Inc.
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */

#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* regs.h */
#endif

#warning This header file is deprecated and will be removed in a future version of VisualDSP++

/*
** This is an include file that must be syncronized with the compiler event 
** model it basically provides the context of a full save i.e.
**  __attribute__((saveall)).
*/

#ifndef REG
#define REG(a,b)
#endif

REG(A1x,0)
REG(A1w,1)
REG(A0x,2)
REG(A0w,3)
REG(M3,4)
REG(M2,5)
REG(M1,6)
REG(M0,7)
REG(L3,8)
REG(B3,9)
REG(I3,10)
REG(L2,11)
REG(B2,12)
REG(I2,13)
REG(L1,14)
REG(B1,15)
REG(I1,16)
REG(L0,17)
REG(B0,18)
REG(I0,19)
REG(FP,20)
REG(P5,21)
REG(P4,22)
REG(P3,23)
REG(P2,24)
REG(P1,25)
REG(P0,26)
REG(R7,27)
REG(R6,28)
REG(R5,29)
REG(R4,30)
REG(R3,31)
REG(R2,32)
REG(R1,33)
REG(R0,34)
REG(ASTAT,35)

#ifndef NSAVED_REGS
#define NSAVED_REGS 36
#endif
