/*
 * cplbtab.h
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
#pragma system_header /* cplbtab.h */
#endif

/* Define structures for the CPLB tables. */ 

#ifndef _CPLBTAB_H
#define _CPLBTAB_H

#include <cplb.h>

typedef struct {
  unsigned long addr;
  unsigned long flags;
} cplb_entry;

extern cplb_entry dcplbs_table[];
extern cplb_entry icplbs_table[];
extern int __cplb_ctrl;

void cplb_init(int);
int cplb_mgr(int, int);
void cplb_hdr(void);
void cache_invalidate(int);
void icache_invalidate(void);
void dcache_invalidate(int);
void dcache_invalidate_both(void);
void flush_data_cache(void);
void flush_data_buffer(void *, void *, int);
void disable_data_cache(void);
void enable_data_cache(int);

#endif /* _CPLBTAB_H */

