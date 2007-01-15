/* Target-dependent code for Analog Devices Blackfin processer, for GDB.

   Copyright (C) 2005 Free Software Foundation, Inc.
   Contributed by Analog Devices.

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
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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
  BFIN_TEXT_ADDR,		/* Address of .text section.  */
  BFIN_TEXT_END_ADDR,		/* Address of the end of .text section.  */
  BFIN_DATA_ADDR,		/* Address of .data section.  */

  BFIN_FDPIC_EXEC_REGNUM,
  BFIN_FDPIC_INTERP_REGNUM,

  /* MMRs */
  BFIN_IPEND_REGNUM,

  /* LAST ENTRY SHOULD NOT BE CHANGED.  */
  BFIN_NUM_REGS			/* The number of all registers.  */
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
  BFIN_GCC_ARGP_REGNUM,
  BFIN_GCC_LT0_REGNUM,
  BFIN_GCC_LT1_REGNUM,
  BFIN_GCC_LC0_REGNUM,
  BFIN_GCC_LC1_REGNUM,
  BFIN_GCC_LB0_REGNUM,
  BFIN_GCC_LB1_REGNUM
};

/* The ABIs for Blackfin.  */
enum bfin_abi
{
  BFIN_ABI_FLAT,
  BFIN_ABI_FDPIC
};

/* Target-dependent structure in gdbarch.  */
struct gdbarch_tdep
{
  /* Which ABI is in use?  */
  enum bfin_abi bfin_abi;
};

/* in opcodes/bfin-dis.c */
extern int print_insn_bfin (bfd_vma pc, struct disassemble_info *outf);

/* Fetch the interpreter and executable loadmap addresses (for shared
   library support) for the FDPIC ABI.  Return 0 if successful, -1 if
   not.  (E.g, -1 will be returned if the ABI isn't the FDPIC ABI.)  */
extern int bfin_fdpic_loadmap_addresses (struct gdbarch *gdbarch,
					 CORE_ADDR *interp_addr,
					 CORE_ADDR *exec_addr);

/* Given a function entry point, find and return the GOT address for the
   containing load module.  */
CORE_ADDR bfin_fdpic_find_global_pointer (CORE_ADDR addr);

/* Given a function entry point, find and return the canonical descriptor
   for that function, if one exists.  If no canonical descriptor could
   be found, return 0.  */
CORE_ADDR bfin_fdpic_find_canonical_descriptor (CORE_ADDR entry_point);
