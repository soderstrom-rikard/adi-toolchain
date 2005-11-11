/* Target-dependent code for Blackfin, for GDB, the GNU Debugger.
   Copyright 2005 Free Software Foundation, Inc.

   This file is part of GDB.

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
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* Register numbers of various important registers. Note that some of
   these values are "real" register numbers, and correspond to the
   general registers of the machine, and some are "phony" register
   numbers which are too large to be actual register numbers as far as
   the user is concerned but do serve to get the desired values when
   passed to read_register.  */

enum gdb_regnum {
  /* Core Registers */
  BFIN_R0_REGNUM = 0,
  BFIN_R1_REGNUM,
  BFIN_R2_REGNUM,
  BFIN_R3_REGNUM,
  BFIN_R4_REGNUM,
  BFIN_R5_REGNUM,
  BFIN_R6_REGNUM,
  BFIN_R7_REGNUM,
  BFIN_P0_REGNUM,
  BFIN_P1_REGNUM,
  BFIN_P2_REGNUM,
  BFIN_P3_REGNUM,
  BFIN_P4_REGNUM,
  BFIN_P5_REGNUM,
  BFIN_SP_REGNUM,
  BFIN_FP_REGNUM,
  BFIN_I0_REGNUM,
  BFIN_I1_REGNUM,
  BFIN_I2_REGNUM,
  BFIN_I3_REGNUM,
  BFIN_M0_REGNUM,
  BFIN_M1_REGNUM,
  BFIN_M2_REGNUM,
  BFIN_M3_REGNUM,
  BFIN_B0_REGNUM,
  BFIN_B1_REGNUM,
  BFIN_B2_REGNUM,
  BFIN_B3_REGNUM,
  BFIN_L0_REGNUM,
  BFIN_L1_REGNUM,
  BFIN_L2_REGNUM,
  BFIN_L3_REGNUM,
  BFIN_A0_DOT_X_REGNUM,
  BFIN_AO_DOT_W_REGNUM,
  BFIN_A1_DOT_X_REGNUM,
  BFIN_A1_DOT_W_REGNUM,
  BFIN_ASTAT_REGNUM,
  BFIN_RETS_REGNUM,
  BFIN_LC0_REGNUM,
  BFIN_LT0_REGNUM,
  BFIN_LB0_REGNUM,
  BFIN_LC1_REGNUM,
  BFIN_LT1_REGNUM,
  BFIN_LB1_REGNUM,
  BFIN_CYCLES_REGNUM,
  BFIN_CYCLES2_REGNUM,
  BFIN_USP_REGNUM,
  BFIN_SEQSTAT_REGNUM,
  BFIN_SYSCFG_REGNUM,
  BFIN_RETI_REGNUM,
  BFIN_RETX_REGNUM,
  BFIN_RETN_REGNUM,
  BFIN_RETE_REGNUM,

  /* Pseudo Registers */
  BFIN_PC_REGNUM,
  BFIN_CC_REGNUM,
  BFIN_EXTRA1,		/* Address of .text section.  */
  BFIN_EXTRA2,		/* Address of .data section.  */
  BFIN_EXTRA3,		/* Address of .bss section.  */

  /* MMRs */
  BFIN_IPEND_REGNUM,

  /* LAST ENTRY SHOULD NOT BE CHANGED.  */
  BFIN_NUM_REGS		/* The number of all registers.  */
};

enum gcc_regnum {
  BFIN_GCC_R0_REGNUM = 0,
  BFIN_GCC_R1_REGNUM,
  BFIN_GCC_R2_REGNUM,
  BFIN_GCC_R3_REGNUM,
  BFIN_GCC_R4_REGNUM,
  BFIN_GCC_R5_REGNUM,
  BFIN_GCC_R6_REGNUM,
  BFIN_GCC_R7_REGNUM,
  BFIN_GCC_P0_REGNUM,
  BFIN_GCC_P1_REGNUM,
  BFIN_GCC_P2_REGNUM,
  BFIN_GCC_P3_REGNUM,
  BFIN_GCC_P4_REGNUM,
  BFIN_GCC_P5_REGNUM,
  BFIN_GCC_SP_REGNUM,
  BFIN_GCC_FP_REGNUM,
  BFIN_GCC_I0_REGNUM,
  BFIN_GCC_I1_REGNUM,
  BFIN_GCC_I2_REGNUM,
  BFIN_GCC_I3_REGNUM,
  BFIN_GCC_B0_REGNUM,
  BFIN_GCC_B1_REGNUM,
  BFIN_GCC_B2_REGNUM,
  BFIN_GCC_B3_REGNUM,
  BFIN_GCC_L0_REGNUM,
  BFIN_GCC_L1_REGNUM,
  BFIN_GCC_L2_REGNUM,
  BFIN_GCC_L3_REGNUM,
  BFIN_GCC_M0_REGNUM,
  BFIN_GCC_M1_REGNUM,
  BFIN_GCC_M2_REGNUM,
  BFIN_GCC_M3_REGNUM,
  BFIN_GCC_A0_REGNUM,
  BFIN_GCC_A1_REGNUM,
  BFIN_GCC_CC_REGNUM,
  BFIN_GCC_RETS_REGNUM,
  BFIN_GCC_RETI_REGNUM,
  BFIN_GCC_RETX_REGNUM,
  BFIN_GCC_RETN_REGNUM,
  BFIN_GCC_RETE_REGNUM,
  BFIN_GCC_ASTAT_REGNUM,
  BFIN_GCC_SEQSTAT_REGNUM,
  BFIN_GCC_USP_REGNUM,
  BFIN_GCC_ARGP_REGNUM
};

/* Used in target-specific code when we need to know the size of the
   largest type of register we need to handle.  */
#define BFIN_MAX_REGISTER_RAW_SIZE      4	
#define BFIN_MAX_REGISTER_VIRTUAL_SIZE	4

/* Size of integer registers.  */
#define INT_REGISTER_RAW_SIZE		4
#define INT_REGISTER_VIRTUAL_SIZE	4

/* Status registers are the same size as general purpose registers.
   Used for documentation purposes and code readability in this
   header.  */
#define STATUS_REGISTER_SIZE		4

/* Offset in setjump definition. Defined in uClibc. */
#define BFIN_LINUX_JB_PC 39

/* ??? */
#define BFIN_LINUX_JB_ELEMENT_SIZE 4

/* Target-dependent structure in gdbarch.  */
struct gdbarch_tdep
{
  /* Lowest address at which instructions will appear.  */
  CORE_ADDR lowest_pc;

  /* Breakpoint pattern for an BFIN insn.  */
  const char *bfin_breakpoint;

  /* And its size.  */
  int bfin_breakpoint_size;

  /* Offset to PC value in jump buffer. If this is negative, longjmp
     support will be disabled.  */
  int jb_pc;

  /* And the size of each entry in the buf.  */
  size_t jb_elt_size;

  int struct_value_regnum;
};

/* in opcodes/bfin-dis.c */
extern int print_insn_bfin (bfd_vma pc, disassemble_info *outf);

