/* Copyright (C) 2008, Analog Devices, Inc.
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
 */

#ifndef BFIN_H
#define BFIN_H

#include "tap.h"
#include "part.h"


/* High-Nibble: group code, low nibble: register code.  */
#define T_REG_R				0x00
#define T_REG_P				0x10
#define T_REG_I				0x20
#define T_REG_B				0x30
#define T_REG_L				0x34
#define T_REG_M				0x24
#define T_REG_A				0x40

enum core_regnum
{
  REG_R0 = T_REG_R, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_P0 = T_REG_P, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
  REG_I0 = T_REG_I, REG_I1, REG_I2, REG_I3,
  REG_M0 = T_REG_M, REG_M1, REG_M2, REG_M3,
  REG_B0 = T_REG_B, REG_B1, REG_B2, REG_B3,
  REG_L0 = T_REG_L, REG_L1, REG_L2, REG_L3,
  REG_A0x = T_REG_A, REG_A0w, REG_A1x, REG_A1w,
  REG_ASTAT = 0x46,
  REG_RETS = 0x47,
  REG_LC0 = 0x60, REG_LT0, REG_LB0, REG_LC1, REG_LT1, REG_LB1,
  REG_CYCLES, REG_CYCLES2,
  REG_USP = 0x70, REG_SEQSTAT, REG_SYSCFG,
  REG_RETI, REG_RETX, REG_RETN, REG_RETE, REG_EMUDAT,
};

#define CLASS_MASK		0xf0
#define GROUP(x)		(((x) & CLASS_MASK) >> 4)
#define DREG_P(x)		(((x) & CLASS_MASK) == T_REG_R)
#define PREG_P(x)		(((x) & CLASS_MASK) == T_REG_P)


#define DTEST_COMMAND			0xffe00300
#define DTEST_DATA0			0xffe00400
#define DTEST_DATA1			0xffe00404

#define ITEST_COMMAND			0xffe01300
#define ITEST_DATA0			0xffe01400
#define ITEST_DATA1			0xffe01404

/* OAB stands for Operations and Bits.  */

struct emu_oab
{
  /* Operations */

  void (*dbgctl_init) (part_t *part, uint16_t value);
  uint16_t (*dbgstat_value) (part_t *part);

  /* Generate TEST_COMMAND from ADDR and W(rite).  */
  uint32_t (*test_command) (uint32_t addr, int w);

  /* For existing Blackfin processors, it's actually DTEST_COMMAND
     address.  */
  uint32_t test_command_addr;

  /* For existing Blackfin processors, they are actually DTEST_DATA
     addresses.  */
  uint32_t test_data0_addr;
  uint32_t test_data1_addr;

  /* No existing Blackfin processors use this.  It should be 0.  */
  int dbgctl_dbgstat_in_one_chain;

  /* No existing Blackfin processors use this.  It should be 0.  */
  int sticky_in_reset;

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
  uint16_t dbgstat_in_powrgate;
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

struct bfin_part_data
{
  struct emu_oab *emu_oab;
  int scan;
  uint16_t dbgctl;
  uint16_t dbgstat;
  uint64_t emuir_a;
  uint64_t emuir_b;
  uint64_t emudat_out;
  uint64_t emudat_in;
  uint32_t emupc;
};

#define EMU_OAB(part)  (((struct bfin_part_data *)((part)->params->data))->emu_oab)

#define BFIN_PART_SCAN(part)  (((struct bfin_part_data *)((part)->params->data))->scan)
#define BFIN_PART_WPSTAT(part)  (((struct bfin_part_data *)((part)->params->data))->wpstat)
#define BFIN_PART_DBGCTL(part)  (((struct bfin_part_data *)((part)->params->data))->dbgctl)
#define BFIN_PART_DBGSTAT(part)  (((struct bfin_part_data *)((part)->params->data))->dbgstat)
#define BFIN_PART_EMUIR_A(part)  (((struct bfin_part_data *)((part)->params->data))->emuir_a)
#define BFIN_PART_EMUIR_B(part)  (((struct bfin_part_data *)((part)->params->data))->emuir_b)
#define BFIN_PART_EMUDAT_OUT(part)  (((struct bfin_part_data *)((part)->params->data))->emudat_out)
#define BFIN_PART_EMUDAT_IN(part)  (((struct bfin_part_data *)((part)->params->data))->emudat_in)
#define BFIN_PART_EMUPC(part)  (((struct bfin_part_data *)((part)->params->data))->emupc)

extern struct emu_oab bfin_emu_oab;


#define IDCODE_SCAN			0
#define DBGSTAT_SCAN			1
#define DBGCTL_SCAN			2
#define EMUIR_SCAN			3
#define EMUDAT_SCAN			4
#define EMUPC_SCAN			5
#define BYPASS				6
#define EMUIR64_SCAN			7
#define NUM_SCANS			8

extern const char *scans[];

#define INSN_NOP			0x0000
#define INSN_RTE			0x0014
#define INSN_CSYNC			0x0023
#define INSN_SSYNC			0x0024
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

enum {
  LEAVE_NOP_DEFAULT,
  LEAVE_NOP_YES,
  LEAVE_NOP_NO
};

extern struct timespec bfin_emu_wait_ts;

/* From src/bfin/bfin.c */

tap_register *register_init_value (tap_register *, uint64_t);
uint64_t register_value (tap_register *);
int part_scan_select (chain_t *, int, int);
int chain_scan_select (chain_t *, int);

#define DECLARE_PART_DBGCTL_SET_BIT(name)				\
  void part_dbgctl_bit_set_##name (chain_t *chain, int n);

#define DECLARE_PART_DBGCTL_CLEAR_BIT(name)				\
  void part_dbgctl_bit_clear_##name (chain_t *chain, int n);

#define DECLARE_PART_DBGCTL_IS(name)					\
  int part_dbgctl_is_##name (chain_t *chain, int n);

#define DECLARE_CHAIN_DBGCTL_SET_BIT(name)				\
  void chain_dbgctl_bit_set_##name (chain_t *chain);

#define DECLARE_CHAIN_DBGCTL_CLEAR_BIT(name)				\
  void chain_dbgctl_bit_clear_##name (chain_t *chain);

#define DECLARE_DBGCTL_BIT_OP(name)					\
  DECLARE_PART_DBGCTL_SET_BIT(name)					\
  DECLARE_PART_DBGCTL_CLEAR_BIT(name)					\
  DECLARE_PART_DBGCTL_IS(name)						\
  DECLARE_CHAIN_DBGCTL_SET_BIT(name)					\
  DECLARE_CHAIN_DBGCTL_CLEAR_BIT(name)

/* These functions check cached DBGSTAT. So before calling them,
   chain_dbgstat_get or part_dbgstat_get has to be called to update cached
   DBGSTAT value.  */

#define DECLARE_PART_DBGSTAT_BIT_IS(name)				\
  int part_dbgstat_is_##name (chain_t *chain, int n);

DECLARE_DBGCTL_BIT_OP (sram_init)
DECLARE_DBGCTL_BIT_OP (wakeup)
DECLARE_DBGCTL_BIT_OP (sysrst)
DECLARE_DBGCTL_BIT_OP (esstep)
DECLARE_DBGCTL_BIT_OP (emudatsz_32)
DECLARE_DBGCTL_BIT_OP (emudatsz_40)
DECLARE_DBGCTL_BIT_OP (emudatsz_48)
DECLARE_DBGCTL_BIT_OP (emuirlpsz_2)
DECLARE_DBGCTL_BIT_OP (emuirsz_64)
DECLARE_DBGCTL_BIT_OP (emuirsz_48)
DECLARE_DBGCTL_BIT_OP (emuirsz_32)
DECLARE_DBGCTL_BIT_OP (empen)
DECLARE_DBGCTL_BIT_OP (emeen)
DECLARE_DBGCTL_BIT_OP (emfen)
DECLARE_DBGCTL_BIT_OP (empwr)

DECLARE_PART_DBGSTAT_BIT_IS (lpdec1)
DECLARE_PART_DBGSTAT_BIT_IS (in_powrgate)
DECLARE_PART_DBGSTAT_BIT_IS (core_fault)
DECLARE_PART_DBGSTAT_BIT_IS (idle)
DECLARE_PART_DBGSTAT_BIT_IS (in_reset)
DECLARE_PART_DBGSTAT_BIT_IS (lpdec0)
DECLARE_PART_DBGSTAT_BIT_IS (bist_done)
DECLARE_PART_DBGSTAT_BIT_IS (emuack)
DECLARE_PART_DBGSTAT_BIT_IS (emuready)
DECLARE_PART_DBGSTAT_BIT_IS (emudiovf)
DECLARE_PART_DBGSTAT_BIT_IS (emudoovf)
DECLARE_PART_DBGSTAT_BIT_IS (emudif)
DECLARE_PART_DBGSTAT_BIT_IS (emudof)

uint16_t part_dbgstat_emucause (chain_t *, int);
void chain_dbgstat_get (chain_t *);
void part_dbgstat_get (chain_t *, int);
void chain_emupc_get (chain_t *);
uint32_t part_emupc_get (chain_t *, int);
void chain_dbgstat_clear_ovfs (chain_t *);
void part_dbgstat_clear_ovfs (chain_t *, int);
void chain_wait_emuready (chain_t *);
int part_sticky_in_reset (chain_t *, int);
void chain_wait_in_reset (chain_t *);
void part_wait_in_reset (chain_t *, int);
void chain_wait_reset (chain_t *);
void part_wait_reset (chain_t *, int);
void part_wait_emuready (chain_t *, int);
void part_emudat_set (chain_t *, int, uint32_t, int);
uint32_t part_emudat_get (chain_t *, int, int);
uint64_t emudat_value (tap_register *);
void emudat_init_value (tap_register *, uint32_t);
void chain_register_get (chain_t *, enum core_regnum, uint32_t *);
uint32_t part_register_get (chain_t *, int, enum core_regnum);
void chain_register_set (chain_t *, enum core_regnum, uint32_t *);
void chain_register_set_same (chain_t *, enum core_regnum, uint32_t);
void part_register_set (chain_t *, int, enum core_regnum, uint32_t);
void chain_emuir_set_same (chain_t *, uint64_t, int);
void part_emuir_set (chain_t *, int, uint64_t, int);
void chain_emuir_set_same_2 (chain_t *, uint64_t, uint64_t, int);
void part_emuir_set_2 (chain_t *, int, uint64_t, uint64_t, int);
uint32_t part_get_r0 (chain_t *, int);
uint32_t part_get_p0 (chain_t *, int);
void part_set_r0 (chain_t *, int, uint32_t);
void part_set_p0 (chain_t *, int, uint32_t);
void chain_emulation_enable (chain_t *);
void part_emulation_enable (chain_t *, int);
void chain_emulation_disable (chain_t *);
void part_emulation_disable (chain_t *, int);
void chain_emulation_trigger (chain_t *);
void part_emulation_trigger (chain_t *, int);
void chain_emulation_return (chain_t *);
void part_emulation_return (chain_t *, int);
void part_execute_instructions (chain_t *, int n, struct bfin_insn *);
void chain_system_reset (chain_t *);
void bfin_core_reset (chain_t *);
void software_reset (chain_t *);
uint32_t part_mmr_read_clobber_r0 (chain_t *, int, int32_t, int);
void part_mmr_write_clobber_r0 (chain_t *, int, int32_t, uint32_t, int);
uint32_t part_mmr_read (chain_t *, int, uint32_t, int);
void part_mmr_write (chain_t *, int, uint32_t, uint32_t, int);

/* From src/bfin/insn-gen.c */

uint32_t gen_move (enum core_regnum dest, enum core_regnum src);
uint32_t gen_load32_offset (enum core_regnum dest, enum core_regnum base, int32_t offset);
uint32_t gen_store32_offset (enum core_regnum base, int32_t offset, enum core_regnum src);
uint32_t gen_load16z_offset (enum core_regnum dest, enum core_regnum base, int32_t offset);
uint32_t gen_store16_offset (enum core_regnum base, int32_t offset, enum core_regnum src);
uint32_t gen_load8z_offset (enum core_regnum dest, enum core_regnum base, int32_t offset);
uint32_t gen_store8_offset (enum core_regnum base, int32_t offset, enum core_regnum src);
uint32_t gen_load32pi (enum core_regnum dest, enum core_regnum base);
uint32_t gen_store32pi (enum core_regnum base, enum core_regnum src);
uint32_t gen_load16zpi (enum core_regnum dest, enum core_regnum base);
uint32_t gen_store16pi (enum core_regnum base, enum core_regnum src);
uint32_t gen_load8zpi (enum core_regnum dest, enum core_regnum base);
uint32_t gen_store8pi (enum core_regnum base, enum core_regnum src);
uint32_t gen_load32 (enum core_regnum dest, enum core_regnum base);
uint32_t gen_store32 (enum core_regnum base, enum core_regnum src);
uint32_t gen_load16z (enum core_regnum dest, enum core_regnum base);
uint32_t gen_store16 (enum core_regnum base, enum core_regnum src);
uint32_t gen_load8z (enum core_regnum dest, enum core_regnum base);
uint32_t gen_store8 (enum core_regnum base, enum core_regnum src);
uint32_t gen_iflush (enum core_regnum addr);
uint32_t gen_iflush_pm (enum core_regnum addr);
uint32_t gen_flush (enum core_regnum addr);
uint32_t gen_flush_pm (enum core_regnum addr);
uint32_t gen_flushinv (enum core_regnum addr);
uint32_t gen_flushinv_pm (enum core_regnum addr);
uint32_t gen_prefetch (enum core_regnum addr);
uint32_t gen_prefetch_pm (enum core_regnum addr);

#endif /* BFIN_H */
