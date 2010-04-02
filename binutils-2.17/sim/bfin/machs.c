/* Simulator for Analog Devices Blackfin processers.

   Copyright (C) 2005-2010 Free Software Foundation, Inc.
   Contributed by Analog Devices, Inc.

   This file is part of simulators.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

#include "sim-main.h"
#include "gdb/sim-bfin.h"
#include "bfd.h"

static const MACH bfin_mach;

const MACH *sim_machs[] =
{
  & bfin_mach,
  NULL
};

#define LAYOUT(_addr, _len, _mask) { .addr = _addr, .len = _len, .mask = access_##_mask, }
static const struct bfin_memory_layout bf537_mem[] = {
	LAYOUT (0xEF000000, 0x800,  read_exec),
	LAYOUT (0xFF800000, 0x8000, read_write),
	LAYOUT (0xFF900000, 0x8000, read_write),
	/* Common sim code can't model exec-only memory.
	   http://sourceware.org/ml/gdb/2010-02/msg00047.html */
	LAYOUT (0xFFA00000, 0xC000, read_write_exec),
	LAYOUT (0xFFA10000, 0x4000, read_write_exec),
};

static const struct bfin_model_data bfin_model_data[] =
{
  [MODEL_BF537] = {
	.mem             = bf537_mem,
	.mem_count       = ARRAY_SIZE (bf537_mem),
	.async_bank_size = 1 * 1024 * 1024,
  },
};

static void
bfin_model_init (SIM_CPU *cpu)
{
  CPU_MODEL_DATA (cpu) = (void *) &bfin_model_data[MODEL_NUM (CPU_MODEL (cpu))];
}

static bu32
bfin_extract_unsigned_integer (unsigned char *addr, int len)
{
  bu32 retval;
  unsigned char * p;
  unsigned char * startaddr = (unsigned char *)addr;
  unsigned char * endaddr = startaddr + len;

  retval = 0;

  for (p = endaddr; p > startaddr;)
    retval = (retval << 8) | *--p;

  return retval;
}

static void
bfin_store_unsigned_integer (unsigned char *addr, int len, bu32 val)
{
  unsigned char *p;
  unsigned char *startaddr = addr;
  unsigned char *endaddr = startaddr + len;

  for (p = startaddr; p < endaddr;)
    {
      *p++ = val & 0xff;
      val >>= 8;
    }
}

static bu32 *
bfin_get_reg (SIM_CPU *cpu, int rn)
{
  switch (rn)
    {
    case SIM_BFIN_R0_REGNUM: return &DREG (0);
    case SIM_BFIN_R1_REGNUM: return &DREG (1);
    case SIM_BFIN_R2_REGNUM: return &DREG (2);
    case SIM_BFIN_R3_REGNUM: return &DREG (3);
    case SIM_BFIN_R4_REGNUM: return &DREG (4);
    case SIM_BFIN_R5_REGNUM: return &DREG (5);
    case SIM_BFIN_R6_REGNUM: return &DREG (6);
    case SIM_BFIN_R7_REGNUM: return &DREG (7);
    case SIM_BFIN_P0_REGNUM: return &PREG (0);
    case SIM_BFIN_P1_REGNUM: return &PREG (1);
    case SIM_BFIN_P2_REGNUM: return &PREG (2);
    case SIM_BFIN_P3_REGNUM: return &PREG (3);
    case SIM_BFIN_P4_REGNUM: return &PREG (4);
    case SIM_BFIN_P5_REGNUM: return &PREG (5);
    case SIM_BFIN_SP_REGNUM: return &SPREG;
    case SIM_BFIN_FP_REGNUM: return &FPREG;
    case SIM_BFIN_I0_REGNUM: return &IREG (0);
    case SIM_BFIN_I1_REGNUM: return &IREG (1);
    case SIM_BFIN_I2_REGNUM: return &IREG (2);
    case SIM_BFIN_I3_REGNUM: return &IREG (3);
    case SIM_BFIN_M0_REGNUM: return &MREG (0);
    case SIM_BFIN_M1_REGNUM: return &MREG (1);
    case SIM_BFIN_M2_REGNUM: return &MREG (2);
    case SIM_BFIN_M3_REGNUM: return &MREG (3);
    case SIM_BFIN_B0_REGNUM: return &BREG (0);
    case SIM_BFIN_B1_REGNUM: return &BREG (1);
    case SIM_BFIN_B2_REGNUM: return &BREG (2);
    case SIM_BFIN_B3_REGNUM: return &BREG (3);
    case SIM_BFIN_L0_REGNUM: return &LREG (0);
    case SIM_BFIN_L1_REGNUM: return &LREG (1);
    case SIM_BFIN_L2_REGNUM: return &LREG (2);
    case SIM_BFIN_L3_REGNUM: return &LREG (3);
    case SIM_BFIN_RETS_REGNUM: return &RETSREG;
    case SIM_BFIN_A0_DOT_X_REGNUM: return &AXREG (0);
    case SIM_BFIN_AO_DOT_W_REGNUM: return &AWREG (0);
    case SIM_BFIN_A1_DOT_X_REGNUM: return &AXREG (1);
    case SIM_BFIN_A1_DOT_W_REGNUM: return &AWREG (1);
    case SIM_BFIN_LC0_REGNUM: return &LCREG (0);
    case SIM_BFIN_LT0_REGNUM: return &LTREG (0);
    case SIM_BFIN_LB0_REGNUM: return &LBREG (0);
    case SIM_BFIN_LC1_REGNUM: return &LCREG (1);
    case SIM_BFIN_LT1_REGNUM: return &LTREG (1);
    case SIM_BFIN_LB1_REGNUM: return &LBREG (1);
    case SIM_BFIN_CYCLES_REGNUM: return &CYCLESREG;
    case SIM_BFIN_CYCLES2_REGNUM: return &CYCLES2REG;
    case SIM_BFIN_USP_REGNUM: return &USPREG;
    case SIM_BFIN_SEQSTAT_REGNUM: return &SEQSTATREG;
    case SIM_BFIN_SYSCFG_REGNUM: return &SYSCFGREG;
    case SIM_BFIN_RETI_REGNUM: return &RETIREG;
    case SIM_BFIN_RETX_REGNUM: return &RETXREG;
    case SIM_BFIN_RETN_REGNUM: return &RETNREG;
    case SIM_BFIN_RETE_REGNUM: return &RETEREG;
    case SIM_BFIN_PC_REGNUM: return &PCREG;
    default: return NULL;
  }
}

static int
bfin_reg_fetch (SIM_CPU *cpu, int rn, unsigned char *buf, int len)
{
  bu32 value, *reg;

  reg = bfin_get_reg (cpu, rn);
  if (reg)
    value = *reg;
  else if (rn == SIM_BFIN_ASTAT_REGNUM)
    value = ASTAT;
  else if (rn == SIM_BFIN_CC_REGNUM)
    value = CCREG;
  else
    return 0; // will be an error in gdb

  bfin_store_unsigned_integer (buf, 4, value);

  return -1; // disables size checking in gdb
}

static int
bfin_reg_store (SIM_CPU *cpu, int rn, unsigned char *buf, int len)
{
  bu32 value, *reg;

  value = bfin_extract_unsigned_integer (buf, 4);
  reg = bfin_get_reg (cpu, rn);

  if (reg)
    /* XXX: Need register trace ?  */
    *reg = value;
  else if (rn == SIM_BFIN_ASTAT_REGNUM)
    SET_ASTAT (value);
  else if (rn == SIM_BFIN_CC_REGNUM)
    SET_CCREG (value);
  else
    return 0; // will be an error in gdb

  return -1; // disables size checking in gdb
}

static sim_cia
bfin_pc_get (SIM_CPU *cpu)
{
  return PCREG;
}

static void
bfin_pc_set (SIM_CPU *cpu, sim_cia newpc)
{
  SET_PCREG (newpc);
}


static void
bfin_init_cpu (SIM_CPU *cpu)
{
  CPU_REG_FETCH (cpu) = bfin_reg_fetch;
  CPU_REG_STORE (cpu) = bfin_reg_store;
  CPU_PC_FETCH (cpu) = bfin_pc_get;
  CPU_PC_STORE (cpu) = bfin_pc_set;
}

static void
bfin_prepare_run (SIM_CPU *cpu)
{
}

static const MODEL bfin_models[] =
{
  { "bf537", & bfin_mach, MODEL_BF537, NULL, bfin_model_init },
  { 0, NULL, 0, NULL, NULL, }
};

static const MACH_IMP_PROPERTIES bfin_imp_properties =
{
  sizeof (SIM_CPU),
  0,
};

static const MACH bfin_mach =
{
  "bfin", "bfin", MACH_BFIN,
  32, 32, & bfin_models[0], & bfin_imp_properties,
  bfin_init_cpu,
  bfin_prepare_run
};
