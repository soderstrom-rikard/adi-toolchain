/*
 * cdefBF566.h
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

#ifndef _CDEFBF566_H
#define _CDEFBF566_H

#include <defBF566.h>
#include <sys/XML_cdefBF566.h>

#ifndef _PTR_TO_VOL_VOID_PTR
#ifndef _USE_LEGACY_CDEF_BEHAVIOUR
#define _PTR_TO_VOL_VOID_PTR (void * volatile *)
#else
#define _PTR_TO_VOL_VOID_PTR (volatile void **)
#endif
#endif
/* legacy names from def_LPBlackfin.h */
#define pSRAM_BASE_ADDRESS ( _PTR_TO_VOL_VOID_PTR SRAM_BASE_ADDRESS)
#define pDCPLB_FAULT_STATUS ((volatile unsigned long *)DCPLB_FAULT_STATUS)

#endif /* _CDEFBF566_H */
