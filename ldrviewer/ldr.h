/*
 * File:         ldr.h
 * Author:       Mike Frysinger <michael.frysinger@analog.com>
 *
 * Description:  View LDR contents
 *               Based on the "Visual DSP++ 4.0 Loader Manual"
 *               and misc Blackfin HRMs
 *
 * Rev:          $Id$
 *
 * Modified:     Copyright 2006 Analog Devices Inc.
 *
 * Bugs:         Enter bugs at http://blackfin.uclinux.org/
 *
 * Licensed under the GPL-2, see the file COPYING in this dir
 */

#ifndef __LDR_H__
#define __LDR_H__

#include "headers.h"

/* See page 2-23 / 2-24 of Loader doc */
#define LDR_FLAG_ZEROFILL 0x0001
#define LDR_FLAG_INIT     0x0008
#define LDR_FLAG_IGNORE   0x0010
#define LDR_FLAG_FINAL    0x8000

/* BF537 flags; See page 19-14 of BF537 HRM */
#define LDR_FLAG_RESVECT     0x0002
#define LDR_FLAG_PPORT_MASK  0x0600
#define LDR_FLAG_PPORT_NONE  0x0000
#define LDR_FLAG_PPORT_PORTF 0x0200
#define LDR_FLAG_PPORT_PORTG 0x0400
#define LDR_FLAG_PPORT_PORTH 0x0600
#define LDR_FLAG_PFLAG_MASK  0x01E0

#define LDR_BLOCK_HEADER_LEN (sizeof(uint32_t) + sizeof(uint32_t) + sizeof(uint16_t))
typedef struct {
	size_t offset;
	uint32_t target_address;
	uint32_t byte_count;
	uint16_t flags;
	uint8_t header[LDR_BLOCK_HEADER_LEN];
	uint8_t *data;
} BLOCK;

typedef struct {
	BLOCK *blocks;
	size_t num_blocks;
} DXE;

typedef struct {
	DXE *dxes;
	size_t num_dxes;
} LDR;


LDR *ldr_read(const char *);
void ldr_free(LDR *);
int ldr_print(LDR *);
int ldr_dump(const char *, LDR *);
int ldr_send(LDR *, const char *);

#endif
