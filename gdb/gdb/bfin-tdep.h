/* Common target dependent code for GDB on BFIN systems.
   Copyright 2002, 2003 Free Software Foundation, Inc.

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

/* Register numbers of various important registers.  Note that some of
   these values are "real" register numbers, and correspond to the
   general registers of the machine, and some are "phony" register
   numbers which are too large to be actual register numbers as far as
   the user is concerned but do serve to get the desired values when
   passed to read_register.  */

enum gdb_regnum {
  BFIN_R0_REGNUM  = 0,
  BFIN_R1_REGNUM  = 1,          /* first data register */
  BFIN_R7_REGNUM  = 7,          /* last  data register */
  BFIN_P0_REGNUM  = 8,
  BFIN_P1_REGNUM  = 9,          /* first general addressing register */
  BFIN_P5_REGNUM  = 13,         /* last  general addressing register */
  BFIN_P6_REGNUM  = 14,         /* Stack Pointer Register */
  BFIN_P7_REGNUM  = 15,         /* Frame Pointer Register */
  BFIN_I0_REGNUM  = 16,
  BFIN_I1_REGNUM  = 17,
  BFIN_I2_REGNUM  = 18,
  BFIN_I3_REGNUM  = 19,
  BFIN_M0_REGNUM  = 20,
  BFIN_M1_REGNUM  = 21,
  BFIN_M2_REGNUM  = 22,
  BFIN_M3_REGNUM  = 23,
  BFIN_L0_REGNUM  = 24,
  BFIN_L1_REGNUM  = 25,
  BFIN_L2_REGNUM  = 26,
  BFIN_L3_REGNUM  = 27,
  BFIN_B0_REGNUM  = 28,
  BFIN_B1_REGNUM  = 29,         /* START MODIFIER REGISTER */
  BFIN_B2_REGNUM  = 30,         /* END MODIFIER REGISTER */
  BFIN_B3_REGNUM  = 31,
  BFIN_A0_DOT_X_REGNUM = 32,
  BFIN_AO_DOT_W_REGNUM = 33,
  BFIN_A1_DOT_X_REGNUM = 34,
  BFIN_A1_DOT_W_REGNUM = 35,
  BFIN_LC0_REGNUM      = 36,
  BFIN_LC1_REGNUM      = 37,
  BFIN_LT0_REGNUM      = 38,
  BFIN_LT1_REGNUM      = 39,
  BFIN_LB0_REGNUM      = 40,
  BFIN_LB1_REGNUM      = 41,
  BFIN_ASTAT_REGNUM    = 42,
  BFIN_RESERVED_REGNUM = 43,
  BFIN_RETS_REGNUM     = 44, /* Subroutine address register */
  BFIN_PC_REGNUM       = 45, /*actually RETI*/
  BFIN_RETX_REGNUM     = 46,
  BFIN_RETN_REGNUM     = 47,
  BFIN_RETE_REGNUM     = 48,
  BFIN_SEQSTAT_REGNUM  = 49,
  BFIN_SYSCFG_REGNUM   = 50,
  BFIN_IPEND_REGNUM    = 51,        /* Subroutine address register */  
};

#define BFIN_NUM_REGS  BFIN_IPEND_REGNUM +1
#define BFIN_FP_REGNUM BFIN_P7_REGNUM
#define BFIN_SP_REGNUM BFIN_P6_REGNUM
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
#define STATUS_REGISTER_SIZE	4

#define BFIN_LINUX_JB_PC 39         /*offset in setjump definition. defined in uClibc*/
#define BFIN_LINUX_JB_ELEMENT_SIZE 4 /*register size*/


/* Target-dependent structure in gdbarch.  */
struct gdbarch_tdep
{
  CORE_ADDR lowest_pc;		/* Lowest address at which instructions 
				   will appear.  */

  const char *bfin_breakpoint;	/* Breakpoint pattern for an BFIN insn.  */
  int bfin_breakpoint_size;	/* And its size.  */

  int jb_pc;			/* Offset to PC value in jump buffer. 
				   If this is negative, longjmp support
				   will be disabled.  */
  size_t jb_elt_size;		/* And the size of each entry in the buf.  */
  int struct_value_regnum;
};

/* in opcodes/bfin-dis.c */
extern int print_insn_bfin (bfd_vma pc, disassemble_info *outf);

