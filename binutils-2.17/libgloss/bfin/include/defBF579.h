/*
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

/*
** defBF579.h
**
** Copyright (C) 2008 Analog Devices Inc., All Rights Reserved.
**
************************************************************************************
**
** This include file contains a list of macro "defines" to enable the programmer
** to use symbolic names for register-access and bit-manipulation.
**
**/
#ifndef _DEF_BF579_H
#define _DEF_BF579_H

/* Include all Core registers and bit definitions */

#define DMEM_CONTROL           0xFFE00004  /* Data memory control */
#define DTEST_COMMAND          0xFFE00300  /* Data Test Command Register */
#define DTEST_DATA0            0xFFE00400  /* Data Test Data Register */
#define DTEST_DATA1            0xFFE00404  /* Data Test Data Register */

#define IMEM_CONTROL           0xFFE01004  /* Instruction Memory Control */
#define ITEST_COMMAND          0xFFE01300  /* Instruction Test Command Register */
#define ITEST_DATA0            0xFFE01400  /* Instruction Test Data Register */
#define ITEST_DATA1            0xFFE01404  /* Instruction Test Data Register */

/* Event/Interrupt Registers */
#define EVT0                   0xFFE02000  /* Event Vector 0 ESR Address */

#endif /* _DEF_BF549_H */
