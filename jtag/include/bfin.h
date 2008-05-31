/*
 * $Id$
 *
 * Copyright (C) 2008, Analog Devices, Inc.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Written by Jie Zhang <jie.zhang@analog.com>, 2008.
 *
 */

#ifndef BFIN_H
#define BFIN_H

#include <tap.h>

#define DBGCTL_SRAM_INIT		0x1000
#define DBGCTL_WAKEUP			0x0800
#define DBGCTL_SYSRST			0x0400
#define DBGCTL_ESSTEP			0x0200
#define DBGCTL_EMUDATSZ_32		0x0000
#define DBGCTL_EMUDATSZ_40		0x0080
#define DBGCTL_EMUDATSZ_48		0x0100
#define DBGCTL_EMUDATSZ_MASK		0x0180
#define DBGCTL_EMUIRLPSZ_2		0x0040
#define DBGCTL_EMUIRSZ_64		0x0000
#define DBGCTL_EMUIRSZ_48		0x0010
#define DBGCTL_EMUIRSZ_32		0x0020
#define DBGCTL_EMUIRSZ_MASK		0x0030
#define DBGCTL_EMPEN			0x0008
#define DBGCTL_EMEEN			0x0004
#define DBGCTL_EMFEN			0x0002
#define DBGCTL_EMPWR			0x0001

#define DBGSTAT_LPDEC1			0x8000
#define DBGSTAT_CORE_FAULT		0x4000
#define DBGSTAT_IDLE			0x2000
#define DBGSTAT_IN_RESET		0x1000
#define DBGSTAT_LPDEC0			0x0800
#define DBGSTAT_BIST_DONE		0x0400
#define DBGSTAT_EMUCAUSE_MASK		0x03c0
#define DBGSTAT_EMUACK			0x0020
#define DBGSTAT_EMUREADY		0x0010
#define DBGSTAT_EMUDIOVF		0x0008
#define DBGSTAT_EMUDOOVF		0x0004
#define DBGSTAT_EMUDIF			0x0002
#define DBGSTAT_EMUDOF			0x0001

#define INSN_NOP			0x00000000
#define INSN_RTE			0x00140000
#define INSN_CSYNC			0x00230000
#define INSN_SSYNC			0x00240000
#define INSN_ILLEGAL			0xffffffff

//tap_register *register_init_value (tap_register *, uint64_t);
//uint64_t register_value (tap_register *);

//int bfin_scan_select (chain_t *, const char *);
void bfin_dbgctl_set (chain_t *, uint16_t, int);
void bfin_dbgctl_clear (chain_t *, uint16_t, int);
uint16_t bfin_dbgctl_get (chain_t *);
uint16_t bfin_dbgstat_get (chain_t *);
void bfin_emuir_set (chain_t *, uint32_t, int);
void bfin_emudat_set (chain_t *, uint32_t, int);
uint32_t bfin_emudat_get (chain_t *, int);
void bfin_emulation_enable (chain_t *);
void bfin_emulation_disable (chain_t *);
void bfin_emulation_trigger (chain_t *);
void bfin_emulation_return (chain_t *);
void bfin_execute_instructions (chain_t *, int, uint64_t *);

#endif /* BFIN_H */
