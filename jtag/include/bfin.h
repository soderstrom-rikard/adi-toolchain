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

/* OAB stands for Operations and Bits. */

/* TODO It will be better to add this to PART_T and initialize it when
   detecting parts.  Such that when ACTIVE_PART is changed, EMU_OAB
   automatically points to the right object.  More important, if we
   need operate on multicore with different cores, current method will
   not work at all.  But now it's enough.  So let's keep it simple
   before it is stablized.  */

struct emu_oab
{
  /* Operations */
  void (*dbgctl_bit_clear_and_set) (chain_t *, uint16_t, uint16_t, int);
  uint16_t (*dbgstat_get) (chain_t *);

  /* Bits */
  uint16_t dbgctl_sram_init;
  uint16_t dbgctl_wakeup;
  uint16_t dbgctl_sysrst;
  uint16_t dbgctl_esstep;
  uint16_t dbgctl_emudatsz_32;
  uint16_t dbgctl_emudatsz_40;
  uint16_t dbgctl_emudatsz_48;
  uint16_t dbgctl_emudatsz_mask;
  uint16_t dbgctl_emuirlpsz_2;
  uint16_t dbgctl_emuirsz_64;
  uint16_t dbgctl_emuirsz_48;
  uint16_t dbgctl_emuirsz_32;
  uint16_t dbgctl_emuirsz_mask;
  uint16_t dbgctl_empen;
  uint16_t dbgctl_emeen;
  uint16_t dbgctl_emfen;
  uint16_t dbgctl_empwr;

  uint16_t dbgstat_lpdec1;
  uint16_t dbgstat_core_fault;
  uint16_t dbgstat_idle;
  uint16_t dbgstat_in_reset;
  uint16_t dbgstat_lpdec0;
  uint16_t dbgstat_bist_done;
  uint16_t dbgstat_emucause_mask;
  uint16_t dbgstat_emuack;
  uint16_t dbgstat_emuready;
  uint16_t dbgstat_emudiovf;
  uint16_t dbgstat_emudoovf;
  uint16_t dbgstat_emudif;
  uint16_t dbgstat_emudof;
};

extern struct emu_oab *current_emu_oab;

#define BFIN_DBGCTL_BIT_CLEAR_AND_SET (current_emu_oab->dbgctl_bit_clear_and_set)
#define BFIN_DBGCTL_GET (current_emu_oab->dbgctl_get)
#define BFIN_DBGSTAT_GET (current_emu_oab->dbgstat_get)
#define BFIN_EMUDAT_SET bfin_emudat_set
#define BFIN_EMUDAT_GET bfin_emudat_get
#define BFIN_EMUIR_SET bfin_emuir_set

#define BFIN_DBGCTL_SET(chain, v, exit) BFIN_DBGCTL_BIT_CLEAR_AND_SET (chain, -1, v, exit)
#define BFIN_DBGCTL_BIT_SET(chain, v, exit) BFIN_DBGCTL_BIT_CLEAR_AND_SET (chain, 0, v, exit)
#define BFIN_DBGCTL_BIT_CLEAR(chain, v, exit) BFIN_DBGCTL_BIT_CLEAR_AND_SET (chain, v, 0, exit)

#define DBGCTL_SRAM_INIT	(current_emu_oab->dbgctl_sram_init)
#define DBGCTL_WAKEUP		(current_emu_oab->dbgctl_wakeup)
#define DBGCTL_SYSRST		(current_emu_oab->dbgctl_sysrst)
#define DBGCTL_ESSTEP		(current_emu_oab->dbgctl_esstep)
#define DBGCTL_EMUDATSZ_32	(current_emu_oab->dbgctl_emudatsz_32)
#define DBGCTL_EMUDATSZ_40	(current_emu_oab->dbgctl_emudatsz_40)
#define DBGCTL_EMUDATSZ_48	(current_emu_oab->dbgctl_emudatsz_48)
#define DBGCTL_EMUDATSZ_MASK	(current_emu_oab->dbgctl_emudatsz_mask)
#define DBGCTL_EMUIRLPSZ_2	(current_emu_oab->dbgctl_emuirlpsz_2)
#define DBGCTL_EMUIRSZ_64	(current_emu_oab->dbgctl_emuirsz_64)
#define DBGCTL_EMUIRSZ_48	(current_emu_oab->dbgctl_emuirsz_48)
#define DBGCTL_EMUIRSZ_32	(current_emu_oab->dbgctl_emuirsz_32)
#define DBGCTL_EMUIRSZ_MASK	(current_emu_oab->dbgctl_emuirsz_mask)
#define DBGCTL_EMPEN		(current_emu_oab->dbgctl_empen)
#define DBGCTL_EMEEN		(current_emu_oab->dbgctl_emeen)
#define DBGCTL_EMFEN		(current_emu_oab->dbgctl_emfen)
#define DBGCTL_EMPWR		(current_emu_oab->dbgctl_empwr)

#define DBGSTAT_LPDEC1		(current_emu_oab->dbgstat_lpdec1)
#define DBGSTAT_IN_POWRGATE	DBGSTAT_LPDEC1
#define DBGSTAT_CORE_FAULT	(current_emu_oab->dbgstat_core_fault)
#define DBGSTAT_IDLE		(current_emu_oab->dbgstat_idle)
#define DBGSTAT_IN_RESET	(current_emu_oab->dbgstat_in_reset)
#define DBGSTAT_LPDEC0		(current_emu_oab->dbgstat_lpdec0)
#define DBGSTAT_BIST_DONE	(current_emu_oab->dbgstat_bist_done)
#define DBGSTAT_EMUCAUSE_MASK	(current_emu_oab->dbgstat_emucause_mask)
#define DBGSTAT_EMUACK		(current_emu_oab->dbgstat_emuack)
#define DBGSTAT_EMUREADY	(current_emu_oab->dbgstat_emuready)
#define DBGSTAT_EMUDIOVF	(current_emu_oab->dbgstat_emudiovf)
#define DBGSTAT_EMUDOOVF	(current_emu_oab->dbgstat_emudoovf)
#define DBGSTAT_EMUDIF		(current_emu_oab->dbgstat_emudif)
#define DBGSTAT_EMUDOF		(current_emu_oab->dbgstat_emudof)

#define INSN_NOP			0x00000000
#define INSN_RTE			0x00140000
#define INSN_CSYNC			0x00230000
#define INSN_SSYNC			0x00240000
#define INSN_ILLEGAL			0xffffffff

#define INSN_BIT_MULTI			0x08
#define INSN_IS_MULTI(insn) \
	(((insn) & 0xc0) == 0xc0 && ((insn) & INSN_BIT_MULTI) \
	 && ((insn) & 0xe8) != 0xe8 /* not linkage */)

enum bfin_insn_type
{
  /* Instruction is a normal instruction.  */

  BFIN_INSN_NORMAL,

  /* Instruction is a value which should be set to EMUDAT.  */

  BFIN_INSN_SET_EMUDAT
};

struct bfin_insn
{
  /* The instruction or the value to be set to EMUDAT.  */

  uint64_t i;

  /* The type of this instruction.  */

  enum bfin_insn_type type;

  /* Instructions to be executed are kept on a linked list.
     This is the link.  */

  struct bfin_insn *next;
};


/* Do Blackfin part specific initialization.  It's mainly used to
   set the proper emulation methods according to the part name.  */
void bfin_part_init (part_t *);

void bfin_emuir_set (chain_t *, uint64_t, int);
void bfin_emudat_set (chain_t *, uint32_t, int);
uint32_t bfin_emudat_get (chain_t *, int);
int bfin_emulation_enabled (chain_t *);
void bfin_emulation_enable (chain_t *);
void bfin_emulation_disable (chain_t *);
void bfin_emulation_trigger (chain_t *);
void bfin_emulation_return (chain_t *);
void bfin_execute_instructions (chain_t *, struct bfin_insn *);
void bfin_system_reset (chain_t *);
void bfin_core_reset (chain_t *);
void bfin_software_reset (chain_t *);

#endif /* BFIN_H */
