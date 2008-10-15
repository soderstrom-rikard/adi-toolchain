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
** cdefBF579.h
**
** Copyright (C) 2008 Analog Devices Inc., All Rights Reserved.
**
************************************************************************************
**
** This include file contains a list of macro "defines" to enable the programmer
** to use symbolic names for the ADSP-BF579 peripherals.
**
************************************************************************************
** System MMR Register Map
************************************************************************************/

#ifndef _CDEF_BF579_H
#define _CDEF_BF579_H

/* include all Core registers and bit definitions */
#include <defBF549.h>

#ifndef _PTR_TO_VOL_VOID_PTR
#ifndef _USE_LEGACY_CDEF_BEHAVIOUR
#define _PTR_TO_VOL_VOID_PTR (void * volatile *)
#else
#define _PTR_TO_VOL_VOID_PTR (volatile void **)
#endif
#endif

#define pDMEM_CONTROL ((volatile unsigned long *)DMEM_CONTROL)
#define pDTEST_COMMAND ((volatile unsigned long *)DTEST_COMMAND)
#define pDTEST_DATA0 ((volatile unsigned long *)DTEST_DATA0)
#define pDTEST_DATA1 ((volatile unsigned long *)DTEST_DATA1)

#define pIMEM_CONTROL ((volatile unsigned long *)IMEM_CONTROL)
#define pITEST_COMMAND ((volatile unsigned long *)ITEST_COMMAND)
#define pITEST_DATA0 ((volatile unsigned long *)ITEST_DATA0)
#define pITEST_DATA1 ((volatile unsigned long *)ITEST_DATA1)

#define pEVT0 (_PTR_TO_VOL_VOID_PTR EVT0)

#endif /* _CDEF_BF549_H */
