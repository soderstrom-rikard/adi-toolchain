/*
 * event.h
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
#pragma system_header /* event.h */
#endif

#warning This header file is deprecated and will be removed in a future version of VisualDSP++

#ifndef _EVENT_H
#define _EVENT_H

#define IV_EMU   0
#define IV_RST   1
#define IV_NMI   2
#define IV_EVSW  3
#define IV_IVHW  5
#define IV_TIMER 6

#define EXCPT_SSTEP      0x10
#define EXCPT_UNDEFINST  0x21
#define EXCPT_ILLICOMB   0x22
#define EXCPT_PROTVIOL   0x23
#define EXCPT_BOUND      0x24
#define EXCPT_ALGN       0x25
#define EXCPT_IFETCH     0x26
#define EXCPT_UNRECOVER  0x27
#define EXCPT_PGFALUT    0x28

#define IVbase           0xFFFF8000
#define IMASK            (*(volatile short *)(0xffff8040))

#define INVALIDATE       (*(volatile long  *)0xFFFF7FFC)

#define TPERIOD          (*(volatile long  *)(0xffff8060))
#define TSCALE           (*(volatile long  *)(0xffff8064))
#define TCOUNT           (*(volatile long  *)(0xffff8068))


#define raise(x)     asm ("raise " #x ";")
#define exception(x) asm ("excpt " #x ";")

#define sys_call1(x,arg1) \
  asm("[--sp]=%0; excpt " #x ";" : : "r" (arg1))

#define sys_call2(x,arg1,arg2) \
  asm("[--sp]=%0; [--sp]=%1; excpt " #x ";" : : "r" (arg1), "r" (arg2))

#endif /* _EVENT_H */
