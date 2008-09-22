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

#include "sysdep.h"

#include <assert.h>
#include <string.h>

#include <chain.h>
#include <bfin.h>

static struct emu_oab bfin_emu_oab;
static struct emu_oab bf579_emu_oab;

struct emu_oab *current_emu_oab;

void
bfin_part_init (part_t *part)
{
  if (part == 0)
    current_emu_oab = NULL;
  else if (strcmp (part->part, "BF579") == 0)
    current_emu_oab = &bf579_emu_oab;
  else
    current_emu_oab = &bfin_emu_oab;
}

static tap_register *
register_init_value (tap_register *tr, uint64_t value)
{
  int i;

  // assert (tr->len <= 64);

  for (i = 0; i < tr->len; i++)
    tr->data[i] = (value >> (tr->len - i - 1)) & 1;

  return tr;
}

static uint64_t
register_value (tap_register *tr)
{
  uint64_t v = 0;
  int i;

  //  assert (tr->len <= 64);

  for (i = 0; i < tr->len; i++)
    v = (v << 1) | tr->data[i];

  return v;
}

/* Select scan chain.  It's used by both Blackfin and BF579.  */

static int
bfin_scan_select (chain_t *chain, const char *scan)
{
  part_t *part;

  part = chain->parts->parts[chain->active_part];

  if (part->active_instruction
      && strcmp (part->active_instruction->name, scan) == 0)
    return 0;

  part_set_instruction (part, scan);
  if (part->active_instruction == NULL)
    {
      printf (_("%s: unknown instruction '%s'\n"), part->part, scan);
      return -1;
    }
  chain_shift_instructions_mode (chain, 0, 1, EXITMODE_UPDATE);
  return 0;
}

/* These two emudat functions only care the payload data, which is the
   upper 32 bits.  Then follows EMUDOF and EMUDIF if the register size
   is larger than 32 bits.  Then the remaining is reserved or don't
   care bits.  */

void
bfin_emudat_set (chain_t *chain, uint32_t value, int exit)
{
  part_t *part;
  tap_register *r;
  uint64_t v = value;

  assert (exit == EXITMODE_UPDATE || exit == EXITMODE_IDLE);

  if (bfin_scan_select (chain, "EMUDAT_SCAN") < 0)
    return;

  part = chain->parts->parts[chain->active_part];
  r = part->active_instruction->data_register->in;

  v <<= (r->len - 32);
  /* If the register size is larger than 32 bits, set EMUDIF.  */
  if (r->len == 34 || r->len == 40 || r->len == 48)
    v |= 0x1 << (r->len - 34);

  register_init_value (r, v);
  chain_shift_data_registers_mode (chain, 0, 1, exit);

  return;
}

uint32_t
bfin_emudat_get (chain_t *chain, int exit)
{
  part_t *part;
  tap_register *r;
  uint64_t value;

  assert (exit == EXITMODE_UPDATE || exit == EXITMODE_IDLE);

  if (bfin_scan_select (chain, "EMUDAT_SCAN") < 0)
    return -1;

  chain_shift_data_registers_mode (chain, 1, 1, exit);

  part = chain->parts->parts[chain->active_part];
  r = part->active_instruction->data_register->out;
  value = register_value (r);
  value >>= (r->len - 32);

  /* FIXME  Is it good to check EMUDOF here if it's available?  */

  return value;
}

void
bfin_emuir_set (chain_t *chain, uint64_t insn, int exit)
{
  part_t *part;
  tap_register *r;
  const char *emuir_scan;

  assert (exit == EXITMODE_UPDATE || exit == EXITMODE_IDLE);

  if ((insn & 0xffffffff00000000ULL) == 0)
    {
      emuir_scan = "EMUIR_SCAN";
      BFIN_DBGCTL_BIT_CLEAR_AND_SET (chain, DBGCTL_EMUIRSZ_MASK,
				     DBGCTL_EMUIRSZ_32, EXITMODE_UPDATE);
    }
  else
    {
      emuir_scan = "EMUIR64_SCAN";
      BFIN_DBGCTL_BIT_CLEAR_AND_SET (chain, DBGCTL_EMUIRSZ_MASK,
				     DBGCTL_EMUIRSZ_64, EXITMODE_UPDATE);
    }

  if (bfin_scan_select (chain, emuir_scan) < 0)
    return;

  part = chain->parts->parts[chain->active_part];
  r = part->active_instruction->data_register->in;

  if ((insn & 0xffffffffffff0000ULL) == 0)
    register_init_value (r, insn << 16);
  else
    register_init_value (r, insn);

  /* If EMUIR has two identify bits, set it properly.
     [len-1:len-2] is
       1 for 16-bit instruction.
       2 for 32-bit instruction.
       3 for 64-bit instruction.
     [len-1] is in data[0] and [len-2] is in data[1].  */

  if (r->len % 32 == 2)
    {
      if ((insn & 0xffffffffffff0000ULL) == 0)
	{
	  r->data[0] = 0;
	  r->data[1] = 1;
	}
      else if ((insn & 0xffffffff00000000ULL) == 0)
	{
	  r->data[0] = 1;
	  r->data[1] = 0;
	}
      else
	  r->data[0] = r->data[1] = 1;
    }

  chain_shift_data_registers_mode (chain, 0, 1, exit);

  return;
}

/* Blackfin emulation functions.  */

static void
bfin_dbgctl_bit_clear_and_set (chain_t *chain, uint16_t m, uint16_t v, int exit)
{
  part_t *part;
  uint16_t orig;

  assert (exit == EXITMODE_UPDATE || exit == EXITMODE_IDLE);

  if (bfin_scan_select (chain, "DBGCTL_SCAN") < 0)
    return;

  part = chain->parts->parts[chain->active_part];

  chain_shift_data_registers_mode (chain, 1, 1, EXITMODE_SHIFT);
  orig = register_value (part->active_instruction->data_register->out) & ~m;
  register_init_value (part->active_instruction->data_register->in, orig | v);
  chain_shift_data_registers_mode (chain, 0, 0, exit);

  return;
}

static uint16_t
bfin_dbgstat_get (chain_t *chain)
{
  part_t *part;

  if (bfin_scan_select (chain, "DBGSTAT_SCAN") < 0)
    return -1;

  chain_shift_data_registers_mode (chain, 1, 1, EXITMODE_UPDATE);

  part = chain->parts->parts[chain->active_part];

  return register_value (part->active_instruction->data_register->out);
}

int
bfin_emulation_enabled (chain_t *chain)
{
  return !!(BFIN_DBGSTAT_GET (chain) & DBGSTAT_EMUREADY);
}

static struct emu_oab bfin_emu_oab =
{
  bfin_dbgctl_bit_clear_and_set,
  bfin_dbgstat_get,

  0x1000, /* DBGCTL_SRAM_INIT */
  0x0800, /* DBGCTL_WAKEUP */
  0x0400, /* DBGCTL_SYSRST */
  0x0200, /* DBGCTL_ESSTEP */
  0x0000, /* DBGCTL_EMUDATSZ_32 */
  0x0080, /* DBGCTL_EMUDATSZ_40 */
  0x0100, /* DBGCTL_EMUDATSZ_48 */
  0x0180, /* DBGCTL_EMUDATSZ_MASK */
  0x0040, /* DBGCTL_EMUIRLPSZ_2 */
  0x0000, /* DBGCTL_EMUIRSZ_64 */
  0x0010, /* DBGCTL_EMUIRSZ_48 */
  0x0020, /* DBGCTL_EMUIRSZ_32 */
  0x0030, /* DBGCTL_EMUIRSZ_MASK */
  0x0008, /* DBGCTL_EMPEN */
  0x0004, /* DBGCTL_EMEEN */
  0x0002, /* DBGCTL_EMFEN */
  0x0001, /* DBGCTL_EMPWR */

  0x8000, /* DBGSTAT_LPDEC1 */
  0x4000, /* DBGSTAT_CORE_FAULT */
  0x2000, /* DBGSTAT_IDLE */
  0x1000, /* DBGSTAT_IN_RESET */
  0x0800, /* DBGSTAT_LPDEC0 */
  0x0400, /* DBGSTAT_BIST_DONE */
  0x03c0, /* DBGSTAT_EMUCAUSE_MASK */
  0x0020, /* DBGSTAT_EMUACK */
  0x0010, /* DBGSTAT_EMUREADY */
  0x0008, /* DBGSTAT_EMUDIOVF */
  0x0004, /* DBGSTAT_EMUDOOVF */
  0x0002, /* DBGSTAT_EMUDIF */
  0x0001, /* DBGSTAT_EMUDOF */
};

/* BF579 emulation functions.  */

/* BF579 has DBGCTL and DBGSTAT in the same scan chain DBG_SCAN.
   The data register of DBG_SCAN is 28 bits.  DBGCTL is in the upper
   12 bits.  DBGSTAT is in the lower 16 bits.  */

static void
bf579_dbgctl_bit_clear_and_set (chain_t *chain, uint16_t m, uint16_t v, int exit)
{
  part_t *part;
  uint32_t orig;

  assert (exit == EXITMODE_UPDATE || exit == EXITMODE_IDLE);

  if (bfin_scan_select (chain, "DBGCTL_SCAN") < 0)
    return;

  part = chain->parts->parts[chain->active_part];

  chain_shift_data_registers_mode (chain, 1, 1, EXITMODE_SHIFT);
  orig = register_value (part->active_instruction->data_register->out) & ~(m << 16);
  register_init_value (part->active_instruction->data_register->in, orig | (v << 16));
  chain_shift_data_registers_mode (chain, 0, 0, exit);

  return;
}

static uint16_t
bf579_dbgstat_get (chain_t *chain)
{
  part_t *part;
  uint32_t value;

  if (bfin_scan_select (chain, "DBGSTAT_SCAN") < 0)
    return -1;

  part = chain->parts->parts[chain->active_part];

  /* After doing a shiftDR you always must eventually do an
     update-DR. The dbgstat and dbgctl registers are in the same scan
     chain.  Therefore when you want to read dbgstat you have to be
     careful not to corrupt the dbgctl register in the process. So you
     have to shift out the value that is currently in the dbgctl and
     dbgstat registers, then shift back the same value into the dbgctl
     so that when you do an updateDR you will not change the dbgctl
     register when all you wanted to do is read the dbgstat value.  */

  /* FIXME  A readonly shift function is better.  */

  chain_shift_data_registers_mode (chain, 1, 1, EXITMODE_SHIFT);
  value = register_value (part->active_instruction->data_register->out);
  register_init_value (part->active_instruction->data_register->in, value);
  chain_shift_data_registers_mode (chain, 0, 0, EXITMODE_UPDATE);

  return value & 0xffff;
}

static struct emu_oab bf579_emu_oab =
{
  bf579_dbgctl_bit_clear_and_set,
  bf579_dbgstat_get,

  0x0800, /* DBGCTL_SRAM_INIT */
  0x0400, /* DBGCTL_WAKEUP */
  0x0200, /* DBGCTL_SYSRST */
  0x0100, /* DBGCTL_ESSTEP */
  0x0000, /* DBGCTL_EMUDATSZ_32 */
  0x0,    /* No DBGCTL_EMUDATSZ_40 for bf579 */
  0x0080, /* DBGCTL_EMUDATSZ_48 */
  0x0080, /* DBGCTL_EMUDATSZ_MASK */
  0x0040, /* DBGCTL_EMUIRLPSZ_2 */
  0x0000, /* DBGCTL_EMUIRSZ_64 */
  0x0010, /* DBGCTL_EMUIRSZ_48 */
  0x0020, /* DBGCTL_EMUIRSZ_32 */
  0x0030, /* DBGCTL_EMUIRSZ_MASK */
  0x0008, /* DBGCTL_EMPEN */
  0x0004, /* DBGCTL_EMEEN */
  0x0002, /* DBGCTL_EMFEN */
  0x0001, /* DBGCTL_EMPWR */

  0x8000, /* DBGSTAT_IN_POWRGATE */
  0x4000, /* DBGSTAT_CORE_FAULT */
  0x2000, /* DBGSTAT_IDLE */
  0x1000, /* DBGSTAT_IN_RESET */
  0x0800, /* DBGSTAT_LPDEC0 */
  0x0400, /* DBGSTAT_BIST_DONE */
  0x03c0, /* DBGSTAT_EMUCAUSE_MASK */
  0x0020, /* DBGSTAT_EMUACK */
  0x0010, /* DBGSTAT_EMUREADY */
  0x0008, /* DBGSTAT_EMUDIOVF */
  0x0004, /* DBGSTAT_EMUDOOVF */
  0x0002, /* DBGSTAT_EMUDIF */
  0x0001, /* DBGSTAT_EMUDOF */
};

void
bfin_emulation_enable (chain_t *chain)
{
  BFIN_DBGCTL_BIT_SET (chain, DBGCTL_EMPWR, EXITMODE_UPDATE);
  BFIN_DBGCTL_BIT_SET (chain, DBGCTL_EMFEN, EXITMODE_UPDATE);
  BFIN_DBGCTL_BIT_SET (chain, DBGCTL_EMUIRSZ_32 | DBGCTL_EMUDATSZ_32, EXITMODE_UPDATE);
}

void
bfin_emulation_disable (chain_t *chain)
{
  BFIN_DBGCTL_BIT_CLEAR (chain, DBGCTL_EMPWR, EXITMODE_UPDATE);
}

void
bfin_emulation_trigger (chain_t *chain)
{
  BFIN_EMUIR_SET (chain, INSN_NOP, EXITMODE_UPDATE);
  BFIN_DBGCTL_BIT_SET (chain, DBGCTL_EMEEN | DBGCTL_EMPEN | DBGCTL_WAKEUP, EXITMODE_IDLE);

  /* I don't know why, but the following code works.  */
  /* Enter the emulation mode */
  chain_clock (chain, 1, 0, 1);
  /* Bring the TAP state to Update-DR */
  chain_clock (chain, 0, 0, 1);
  chain_clock (chain, 1, 0, 2);
}

void
bfin_emulation_return (chain_t *chain)
{
  BFIN_EMUIR_SET (chain, INSN_RTE, EXITMODE_UPDATE);
  BFIN_DBGCTL_BIT_CLEAR (chain, DBGCTL_EMEEN | DBGCTL_EMPEN | DBGCTL_WAKEUP, EXITMODE_IDLE);

  /* I don't know why, but the following code works.  */
  /* Enter the emulation mode */
  chain_clock (chain, 1, 0, 1);
  /* Bring the TAP state to Update-DR */
  chain_clock (chain, 0, 0, 1);
  chain_clock (chain, 1, 0, 2);
}

void
bfin_execute_instructions (chain_t *chain, struct bfin_insn *insns)
{
  while (insns)
    {
      if (insns->type == BFIN_INSN_NORMAL)
	BFIN_EMUIR_SET (chain, insns->i, EXITMODE_IDLE);
      else /* insns->type == BFIN_INSN_SET_EMUDAT */
	BFIN_EMUDAT_SET (chain, insns->i, EXITMODE_UPDATE);

      insns = insns->next;
    }

  return;
}

void
bfin_system_reset (chain_t *chain)
{
  int emu_enabled = bfin_emulation_enabled (chain);

  if (!emu_enabled)
    {
      bfin_emulation_enable (chain);
      bfin_emulation_trigger (chain);
    }

  /* P0.L = LO(SWRST); */
  bfin_emuir_set (chain, 0xe1080100, EXITMODE_IDLE);
  /* P0.H = HI(SWRST); */
  bfin_emuir_set (chain, 0xe148ffc0, EXITMODE_IDLE);
  /* R0 = 0x7 (z); */
  bfin_emuir_set (chain, 0xe1800007, EXITMODE_IDLE);
  /* [P0] = R0; */
  bfin_emuir_set (chain, 0x9700, EXITMODE_IDLE);
  /* Wait for system reset to process ... needs ~10 SCLKs */
  sleep(1);
  /* R0 = 0 (z); */
  bfin_emuir_set (chain, 0xe1800000, EXITMODE_IDLE);
  /* [P0] = R0; */
  bfin_emuir_set (chain, 0x9700, EXITMODE_IDLE);

  if (!emu_enabled)
    bfin_emulation_return (chain);
}

void
bfin_core_reset (chain_t *chain)
{
  int emu_enabled = bfin_emulation_enabled (chain);

  if (emu_enabled)
    bfin_emulation_disable (chain);

  bfin_emuir_set (chain, INSN_NOP, EXITMODE_UPDATE);
  BFIN_DBGCTL_BIT_SET (chain, DBGCTL_SRAM_INIT, EXITMODE_UPDATE);

  BFIN_DBGCTL_BIT_SET (chain, DBGCTL_SYSRST, EXITMODE_UPDATE);
  while (!(BFIN_DBGSTAT_GET (chain) & DBGSTAT_IN_RESET))
    continue;
  BFIN_DBGCTL_BIT_CLEAR (chain, DBGCTL_SYSRST, EXITMODE_UPDATE);
  while (BFIN_DBGSTAT_GET (chain) & DBGSTAT_IN_RESET)
    continue;

  if (emu_enabled)
    {
      bfin_emulation_enable (chain);
      bfin_emulation_trigger (chain);
    }

  BFIN_DBGCTL_BIT_CLEAR (chain, DBGCTL_SRAM_INIT, EXITMODE_UPDATE);

  if (!emu_enabled)
    bfin_emulation_return (chain);
}

void
bfin_software_reset (chain_t *chain)
{
  bfin_system_reset (chain);
  bfin_core_reset (chain);
}
