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

static tap_register *
register_init_value (tap_register *tr, uint64_t value)
{
  int i;

  assert (tr->len <= 64);

  for (i = 0; i < tr->len; i++)
    tr->data[i] = (value >> (tr->len - i - 1)) & 1;

  return tr;
}

static uint64_t
register_value (tap_register *tr)
{
  uint64_t v = 0;
  int i;

  assert (tr->len <= 64);

  for (i = 0; i < tr->len; i++)
    v |= tr->data[i] << (tr->len - i - 1);

  return v;
}

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
      printf (_("%s: unknown instruction '%s'\n"), "bfin", scan);
      return -1;
    }
  chain_shift_instructions_mode (chain, 0, 1, EXITMODE_UPDATE);
  return 0;
}

void
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

void
bfin_dbgctl_set (chain_t *chain, uint16_t v, int exit)
{
  bfin_dbgctl_bit_clear_and_set (chain, -1, v, exit);
}

void
bfin_dbgctl_bit_set (chain_t *chain, uint16_t v, int exit)
{
  bfin_dbgctl_bit_clear_and_set (chain, 0, v, exit);
}

void
bfin_dbgctl_bit_clear (chain_t *chain, uint16_t v, int exit)
{
  bfin_dbgctl_bit_clear_and_set (chain, v, 0, exit);
}

uint16_t
bfin_dbgctl_get (chain_t *chain)
{
  part_t *part;

  if (bfin_scan_select (chain, "DBGCTL_SCAN") < 0)
    return -1;

  part = chain->parts->parts[chain->active_part];

  chain_shift_data_registers_mode (chain, 1, 1, EXITMODE_UPDATE);
  return register_value (part->active_instruction->data_register->out);
}

void
bfin_emuir_set (chain_t *chain, uint64_t insn, int exit)
{
  part_t *part;
  const char *emuir_scan;

  assert (exit == EXITMODE_UPDATE || exit == EXITMODE_IDLE);

  if ((insn & 0xffffffff00000000ULL) == 0)
    {
      emuir_scan = "EMUIR_SCAN";
      bfin_dbgctl_bit_clear_and_set (chain, DBGCTL_EMUIRSZ_MASK,
				     DBGCTL_EMUIRSZ_32, EXITMODE_UPDATE);
    }
  else
    {
      emuir_scan = "EMUIR64_SCAN";
      bfin_dbgctl_bit_clear_and_set (chain, DBGCTL_EMUIRSZ_MASK,
				     DBGCTL_EMUIRSZ_64, EXITMODE_UPDATE);
    }

  if (bfin_scan_select (chain, emuir_scan) < 0)
    return;

  part = chain->parts->parts[chain->active_part];

  if ((insn & 0xffffffffffff0000ULL) == 0)
    register_init_value (part->active_instruction->data_register->in, insn << 16);
  else
    register_init_value (part->active_instruction->data_register->in, insn);

  chain_shift_data_registers_mode (chain, 0, 1, exit);

  return;
}

void
bfin_emudat_set (chain_t *chain, uint32_t value, int exit)
{
  part_t *part;

  assert (exit == EXITMODE_UPDATE || exit == EXITMODE_IDLE);

  if (bfin_scan_select (chain, "EMUDAT_SCAN") < 0)
    return;

  part = chain->parts->parts[chain->active_part];

  register_init_value (part->active_instruction->data_register->in, value);
  chain_shift_data_registers_mode (chain, 0, 1, exit);

  return;
}

uint32_t
bfin_emudat_get (chain_t *chain, int exit)
{
  part_t *part;

  assert (exit == EXITMODE_UPDATE || exit == EXITMODE_IDLE);

  if (bfin_scan_select (chain, "EMUDAT_SCAN") < 0)
    return -1;

  chain_shift_data_registers_mode (chain, 1, 1, exit);

  part = chain->parts->parts[chain->active_part];

  return register_value (part->active_instruction->data_register->out);
}

uint16_t
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
  return !!(bfin_dbgstat_get (chain) & DBGSTAT_EMUREADY);
}

void
bfin_emulation_enable (chain_t *chain)
{
  bfin_dbgctl_bit_set (chain, DBGCTL_EMPWR, EXITMODE_UPDATE);
  bfin_dbgctl_bit_set (chain, DBGCTL_EMFEN, EXITMODE_UPDATE);
  bfin_dbgctl_bit_set (chain, DBGCTL_EMUIRSZ_32 | DBGCTL_EMUDATSZ_32, EXITMODE_UPDATE);
}

void
bfin_emulation_disable (chain_t *chain)
{
  bfin_dbgctl_bit_clear (chain, DBGCTL_EMPWR, EXITMODE_UPDATE);
}

void
bfin_emulation_trigger (chain_t *chain)
{
  bfin_emuir_set (chain, INSN_NOP, EXITMODE_UPDATE);
  bfin_dbgctl_bit_set (chain, DBGCTL_EMEEN | DBGCTL_EMPEN | DBGCTL_WAKEUP, EXITMODE_IDLE);

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
  bfin_emuir_set (chain, INSN_RTE, EXITMODE_UPDATE);
  bfin_dbgctl_bit_clear (chain, DBGCTL_EMEEN | DBGCTL_EMPEN | DBGCTL_WAKEUP, EXITMODE_IDLE);

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
	bfin_emuir_set (chain, insns->i, EXITMODE_IDLE);
      else /* insns->type == BFIN_INSN_SET_EMUDAT */
	bfin_emudat_set (chain, insns->i, EXITMODE_UPDATE);

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
  bfin_dbgctl_bit_set (chain, DBGCTL_SRAM_INIT, EXITMODE_UPDATE);

  bfin_dbgctl_bit_set (chain, DBGCTL_SYSRST, EXITMODE_UPDATE);
  while (!(bfin_dbgstat_get (chain) & DBGSTAT_IN_RESET))
    continue;
  bfin_dbgctl_bit_clear (chain, DBGCTL_SYSRST, EXITMODE_UPDATE);
  while (bfin_dbgstat_get (chain) & DBGSTAT_IN_RESET)
    continue;

  if (emu_enabled)
    {
      bfin_emulation_enable (chain);
      bfin_emulation_trigger (chain);
    }

  bfin_dbgctl_bit_clear (chain, DBGCTL_SRAM_INIT, EXITMODE_UPDATE);

  if (!emu_enabled)
    bfin_emulation_return (chain);
}

void
bfin_software_reset (chain_t *chain)
{
  bfin_system_reset (chain);
  bfin_core_reset (chain);
}
