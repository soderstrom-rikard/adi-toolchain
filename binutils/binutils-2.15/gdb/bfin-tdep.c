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

/* Analog Devices Blackfin architecture (bfin)
   Written and tested on BF533
   TODO :
   1. Resolve the orig_r0 mystery. 
   2. Test the frameless gcc option
   Info :
   1. Most of the frame functions have to bother about frameless
      as well as frame case. Since blackfin does not modify the
      stack with a call, on entry to a subroutine, we have the
      frameless case. A prologue may or maynot build a frame.  */

#include "defs.h"
#include "dwarf2-frame.h"
#include "frame.h"
#include "frame-base.h"
#include "frame-unwind.h"
#include "inferior.h"
#include "gdbcmd.h"
#include "gdbcore.h"
#include "symfile.h"
#include "gdb_string.h"
#include "dis-asm.h"
#include "regcache.h"
#include "doublest.h"
#include "value.h"
#include "arch-utils.h"
#include "osabi.h"
#include "bfin-tdep.h"
#include "elf-bfd.h"
#include "gdb_assert.h"
#include "command.h"
#include "sim-regno.h"
#include "objfiles.h"
#include "trad-frame.h"
#include "gdb/sim-bfin.h"
#include "elf/bfin.h"
#include "infcall.h"

/* Macros used by prologue functions.  */
#define P_LINKAGE             		0xE800  
#define P_MINUS_SP1           		0x0140
#define P_MINUS_SP2           		0x05C0
#define P_MINUS_SP3           		0x0540
#define P_MINUS_SP4           		0x04C0
#define P_SP_PLUS             		0x6C06
#define P_P2_LOW              		0xE10A
#define P_P2_HIGH             		0XE14A
#define P_SP_EQ_SP_PLUS_P2    		0X5BB2
#define P_SP_EQ_P2_PLUS_SP    		0x5B96
#define P_MINUS_MINUS_SP_EQ_RETS	0x0167

/* Macros used for program flow control.  */
/* 16 bit instruction, max  */
#define P_16_BIT_INSR_MAX		0xBFFF
/* 32 bit instruction, min  */
#define P_32_BIT_INSR_MIN		0xC000
/* 32 bit instruction, max  */
#define P_32_BIT_INSR_MAX		0xE801
/* jump (preg), 16-bit, min  */
#define P_JUMP_PREG_MIN			0x0050
/* jump (preg), 16-bit, max  */
#define P_JUMP_PREG_MAX			0x0057
/* jump (pc+preg), 16-bit, min  */
#define P_JUMP_PC_PLUS_PREG_MIN		0x0080
/* jump (pc+preg), 16-bit, max  */
#define P_JUMP_PC_PLUS_PREG_MAX		0x0087
/* jump.s pcrel13m2, 16-bit, min  */
#define P_JUMP_S_MIN			0x2000
/* jump.s pcrel13m2, 16-bit, max  */
#define P_JUMP_S_MAX			0x2FFF
/* jump.l pcrel25m2, 32-bit, min  */
#define P_JUMP_L_MIN			0xE200
/* jump.l pcrel25m2, 32-bit, max  */
#define P_JUMP_L_MAX			0xE2FF
/* conditional jump pcrel11m2, 16-bit, min  */
#define P_IF_CC_JUMP_MIN		0x1800
/* conditional jump pcrel11m2, 16-bit, max  */
#define P_IF_CC_JUMP_MAX		0x1BFF
/* conditional jump(bp) pcrel11m2, 16-bit, min  */
#define P_IF_CC_JUMP_BP_MIN		0x1C00
/* conditional jump(bp) pcrel11m2, 16-bit, max  */
#define P_IF_CC_JUMP_BP_MAX		0x1FFF
/* conditional !jump pcrel11m2, 16-bit, min  */
#define P_IF_NOT_CC_JUMP_MIN		0x1000
/* conditional !jump pcrel11m2, 16-bit, max  */
#define P_IF_NOT_CC_JUMP_MAX		0x13FF
/* conditional jump(bp) pcrel11m2, 16-bit, min  */
#define P_IF_NOT_CC_JUMP_BP_MIN		0x1400
/* conditional jump(bp) pcrel11m2, 16-bit, max  */
#define P_IF_NOT_CC_JUMP_BP_MAX		0x17FF
/* call (preg), 16-bit, min  */
#define P_CALL_PREG_MIN			0x0060
/* call (preg), 16-bit, max  */
#define P_CALL_PREG_MAX			0x0067
/* call (pc+preg), 16-bit, min  */
#define P_CALL_PC_PLUS_PREG_MIN		0x0070
/* call (pc+preg), 16-bit, max  */
#define P_CALL_PC_PLUS_PREG_MAX		0x0077
/* call pcrel25m2, 32-bit, min  */
#define P_CALL_MIN			0xE300
/* call pcrel25m2, 32-bit, max  */
#define P_CALL_MAX			0xE3FF
/* RTS  */
#define P_RTS				0x0010
/* MNOP  */
#define P_MNOP				0xC803
/* EXCPT, 16-bit, min  */
#define P_EXCPT_MIN			0x00A0
/* EXCPT, 16-bit, max  */
#define P_EXCPT_MAX			0x00AF
/* multi instruction mask 1, 16-bit  */
#define P_BIT_MULTI_INS_1 		0xC000
/* multi instruction mask 2, 16-bit  */
#define P_BIT_MULTI_INS_2 		0x0800

/* Macros used for signal handling  */
/* Instruction 1 for signal  */
#define P_SIGNAL_INS_1			0x0077E128
/* Instruction 1 for rt_signal  */
#define P_RT_SIGNAL_INS_1		0x00ADE128
/* Instruction 2 is common for both signal and rt_signal  */
#define P_SIGNAL_INS_2			0x000000A0

/* ???  */
#define UPPER_LIMIT			(40)
/* ???  */
#define BFIN_NOT_TESTED	       		0	
/* Frame offsets  */
#define OLD_FP_OFFSET			0
#define RETS_OFFSET			4

/* The list of available "set bfin ..." and "show bfin ..." commands.  */

static struct cmd_list_element *setbfincmdlist  = NULL;
static struct cmd_list_element *showbfincmdlist = NULL;

/* Initial value: Register names used in BFIN's ISA documentation.  */

static char *bfin_register_name_strings[] =
{
  "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", 
  "p0", "p1", "p2", "p3", "p4", "p5", "sp", "fp",
  "i0", "i1", "i2", "i3", "m0", "m1", "m2", "m3", 
  "b0", "b1", "b2", "b3", "l0", "l1", "l2", "l3",
  "a0x", "a0w", "a1x", "a1w", "astat", "rets",
  "lc0", "lt0", "lb0", "lc1", "lt1", "lb1", "cycles", "cycles2",
  "usp", "seqstat", "syscfg", "reti", "retx", "retn", "rete",
  "pc", "cc", "extra1", "extra2", "extra3", "fdpic_exec", "fdpic_interp",
  "ipend"
};


#define NUM_BFIN_REGNAMES \
  (sizeof (bfin_register_name_strings) / sizeof (char *))


/* In this diagram successive memory locations increase downwards or the
   stack grows upwards with negative indices. (PUSH analogy for stack.)

   The top frame is the "frame" of the current function being executed.

     +--------------+ SP    -
     |  local vars  |       ^
     +--------------+       |
     |  save regs   |       |
     +--------------+ FP    |
     |   old FP    -|--    top
     +--------------+  |  frame
     |    RETS      |  |    |
     +--------------+  |    |
     |   param 1    |  |    |
     |   param 2    |  |    |
     |    ...       |  |    V
     +--------------+  |    -
     |  local vars  |  |    ^
     +--------------+  |    |
     |  save regs   |  |    |
     +--------------+<-     |
     |   old FP    -|--   next
     +--------------+  |  frame
     |    RETS      |  |    |
     +--------------+  |    |
     |   param 1    |  |    |
     |   param 2    |  |    |
     |    ...       |  |    V
     +--------------+  |    -
     |  local vars  |  |    ^
     +--------------+  |    |
     |  save regs   |  |    |
     +--------------+<-  next frame
     |   old FP     |       |
     +--------------+       |
     |    RETS      |       V
     +--------------+       -

   The frame chain is formed as following:

     FP has the topmost frame.
     FP + 4 has the previous FP and so on.  */


/* Map from DWARF2 register number to GDB register number.  */

int map_gcc_gdb[] =
{
  BFIN_R0_REGNUM,
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
  BFIN_B0_REGNUM,
  BFIN_B1_REGNUM,
  BFIN_B2_REGNUM,
  BFIN_B3_REGNUM,
  BFIN_L0_REGNUM,
  BFIN_L1_REGNUM,
  BFIN_L2_REGNUM,
  BFIN_L3_REGNUM,
  BFIN_M0_REGNUM,
  BFIN_M1_REGNUM,
  BFIN_M2_REGNUM,
  BFIN_M3_REGNUM,
  BFIN_A0_DOT_X_REGNUM,
  BFIN_A1_DOT_X_REGNUM,
  BFIN_CC_REGNUM,
  BFIN_RETS_REGNUM,
  BFIN_RETI_REGNUM,
  BFIN_RETX_REGNUM,
  BFIN_RETN_REGNUM,
  BFIN_RETE_REGNUM,
  BFIN_ASTAT_REGNUM,
  BFIN_SEQSTAT_REGNUM,
  BFIN_USP_REGNUM,
};


/* Check whether insn1 and insn2 are parts of a signal trampoline.  */

#define IS_SIGTRAMP(insn1, insn2)	\
 /* P0=0x77 (X); EXCPT 0x0 */		\
 ((insn1 == P_SIGNAL_INS_1) && ((insn2 & P_SIGNAL_INS_2) == P_SIGNAL_INS_2))

#define IS_RT_SIGTRAMP(insn1, insn2)	\
 /* P0=0xad (X); EXCPT 0x0 */		\
 ((insn1 == P_RT_SIGNAL_INS_1) && ((insn2 & P_SIGNAL_INS_2) == P_SIGNAL_INS_2))

#define SIGCONTEXT_OFFSET	28
#define UCONTEXT_OFFSET		172


/* From <asm/sigcontext.h>.  */

static int bfin_linux_sigcontext_reg_offset[BFIN_NUM_REGS] =
{
  2 * 4,	/* %r0 */
  3 * 4,	/* %r1 */
  4 * 4,	/* %r2 */
  5 * 4,	/* %r3 */
  6 * 4,	/* %r4 */
  -1,		/* %r5 */
  -1,		/* %r6 */
  -1,		/* %r7 */
  7 * 4,	/* %p0 */
  8 * 4,	/* %p1 */
  9 * 4,	/* %p2 */
  10 * 4,	/* %p3 */
  -1,		/* %p4 */
  -1,		/* %p5 */
  1 * 4,	/* %sp */
  -1,		/* %fp */
  11 * 4,	/* %i0 */
  12 * 4,	/* %i1 */
  13 * 4,	/* %i2 */
  14 * 4,	/* %i3 */
  15 * 4,	/* %m0 */
  16 * 4,	/* %m1 */
  17 * 4,	/* %m2 */
  18 * 4,	/* %m3 */
  23 * 4,	/* %b0 */
  24 * 4,	/* %b1 */
  25 * 4,	/* %b2 */
  26 * 4,	/* %b3 */
  19 * 4,	/* %l0 */
  20 * 4,	/* %l1 */
  21 * 4,	/* %l2 */
  22 * 4,	/* %l3 */
  27 * 4,	/* %a0x */
  28 * 4,	/* %a0w */
  29 * 4,	/* %a1x */
  30 * 4,	/* %a1w */
  31 * 4,	/* %astat */
  32 * 4,	/* %rets */
  33 * 4,	/* %lc0 */
  35 * 4,	/* %lt0 */
  37 * 4,	/* %lb0 */
  34 * 4,	/* %lc1 */
  36 * 4,	/* %lt1 */
  38 * 4,	/* %lb1 */
  -1,		/* %cycles */
  -1,		/* %cycles2 */
  -1,		/* %usp */
  39 * 4,	/* %seqstat */
  -1,		/* syscfg */
  40 * 4,	/* %reti */
  41 * 4,	/* %retx */
  -1,		/* %retn */
  -1,		/* %rete */
  40 * 4,	/* %pc */
  -1,		/* %cc */
  -1,		/* %extra1 */
  -1,		/* %extra2 */
  -1,		/* %extra3 */
  -1		/* %ipend */
};


/* From <asm/ucontext.h>.  */

static int bfin_linux_ucontext_reg_offset[BFIN_NUM_REGS] =
{
  1 * 4,	/* %r0 */
  2 * 4,	/* %r1 */
  3 * 4,	/* %r2 */
  4 * 4,	/* %r3 */
  5 * 4,	/* %r4 */
  6 * 4,	/* %r5 */
  7 * 4,	/* %r6 */
  8 * 4,	/* %r7 */
  9 * 4,	/* %p0 */
  10 * 4,	/* %p1 */
  11 * 4,	/* %p2 */
  12 * 4,	/* %p3 */
  13 * 4,	/* %p4 */
  14 * 4,	/* %p5 */
  15 * 4,	/* %sp */
  24 * 4,	/* %fp */
  25 * 4,	/* %i0 */
  26 * 4,	/* %i1 */
  27 * 4,	/* %i2 */
  28 * 4,	/* %i3 */
  29 * 4,	/* %m0 */
  30 * 4,	/* %m1 */
  31 * 4,	/* %m2 */
  32 * 4,	/* %m3 */
  37 * 4,	/* %b0 */
  38 * 4,	/* %b1 */
  39 * 4,	/* %b2 */
  40 * 4,	/* %b3 */
  33 * 4,	/* %l0 */
  34 * 4,	/* %l1 */
  35 * 4,	/* %l2 */
  36 * 4,	/* %l3 */
  18 * 4,	/* %a0x */
  16 * 4,	/* %a0w */
  19 * 4,	/* %a1x */
  17 * 4,	/* %a1w */
  20 * 4,	/* %astat */
  21 * 4,	/* %rets */
  41 * 4,	/* %lc0 */
  43 * 4,	/* %lt0 */
  45 * 4,	/* %lb0 */
  42 * 4,	/* %lc1 */
  44 * 4,	/* %lt1 */
  46 * 4,	/* %lb1 */
  -1,		/* %cycles */
  -1,		/* %cycles2 */
  -1,		/* %usp */
  47 * 4,	/* %seqstat */
  -1,		/* syscfg */
  22 * 4,	/* %reti */
  23 * 4,	/* %retx */
  -1,		/* %retn */
  -1,		/* %rete */
  22 * 4,	/* %pc */
  -1,		/* %cc */
  -1,		/* %extra1 */
  -1,		/* %extra2 */
  -1,		/* %extra3 */
  -1		/* %ipend */
};

/* Get info about saved registers in sigtramp.  */

struct bfin_linux_sigtramp_info
{
  /* Address of context.  */
  CORE_ADDR context_addr;

  /* Offset of registers in `struct sigcontext'.  */
  int *sc_reg_offset;
};

static enum bfin_abi
bfin_abi (struct gdbarch *gdbarch)
{
  return gdbarch_tdep (gdbarch)->bfin_abi;
}

/* Return non-zero if PC points into the signal trampoline.  For the
   sake of bfin_linux_get_sigtramp_info.  */

static int
bfin_linux_pc_in_sigtramp (CORE_ADDR pc)
{
  char buf[12];
  unsigned long insn0, insn1, insn2;

  if (deprecated_read_memory_nobpt (pc - 4, buf, sizeof (buf)))
    return 0;

  insn1 = extract_unsigned_integer (buf + 4, 4);
  insn2 = extract_unsigned_integer (buf + 8, 4);

  if (IS_SIGTRAMP (insn1, insn2))
    return 1;

  if (IS_RT_SIGTRAMP (insn1, insn2))
    return 2;
  
  insn0 = extract_unsigned_integer (buf, 4);
  if (IS_SIGTRAMP (insn0, insn1))
    return 1;

  if (IS_RT_SIGTRAMP (insn0, insn1))
    return 2;

  insn0 = ((insn0 << 16) & 0xffffffff) | (insn1 >> 16);
  insn1 = ((insn1 << 16) & 0xffffffff) | (insn2 >> 16);

  if (IS_SIGTRAMP (insn0, insn1))
    return 1;

  if (IS_RT_SIGTRAMP (insn0, insn1))
    return 2;

  return 0;
}

static struct bfin_linux_sigtramp_info
bfin_linux_get_sigtramp_info (struct frame_info *next_frame)
{
  CORE_ADDR sp;
  char buf[4];
  struct bfin_linux_sigtramp_info info;

  frame_unwind_register (next_frame, BFIN_SP_REGNUM, buf);
  sp = extract_unsigned_integer (buf, 4);

  if (bfin_linux_pc_in_sigtramp (frame_pc_unwind (next_frame)) == 0)
    fprintf(stderr, "not a sigtramp\n");
  else if (bfin_linux_pc_in_sigtramp (frame_pc_unwind (next_frame)) == 1)
    {
      /* Get sigcontext address.  */
      info.context_addr = sp + SIGCONTEXT_OFFSET;
      info.sc_reg_offset = bfin_linux_sigcontext_reg_offset;
    }
  else if (bfin_linux_pc_in_sigtramp (frame_pc_unwind (next_frame)) == 2)
    {
      /* Get ucontext address.  */
      info.context_addr = sp + UCONTEXT_OFFSET;
      info.sc_reg_offset = bfin_linux_ucontext_reg_offset;
    }

  return info;
}

/* Signal trampolines.  */

static struct trad_frame_cache *
bfin_linux_sigtramp_frame_cache (struct frame_info *next_frame,
				 void **this_cache)
{
  struct frame_id this_id;
  struct trad_frame_cache *cache;
  struct gdbarch_tdep *tdep = gdbarch_tdep (current_gdbarch);
  struct bfin_linux_sigtramp_info info;
  char buf[4];
  CORE_ADDR sp;
  int i;

  if (*this_cache)
    return *this_cache;

  cache = trad_frame_cache_zalloc (next_frame);

  /* The frame ID's code address should be the start-address of the
     signal trampoline and not the current PC within that trampoline.  */
  frame_unwind_register (next_frame, BFIN_SP_REGNUM, buf);
  sp = extract_unsigned_integer (buf, 4);

  /* This would come after the LINK instruction in the ret_from_signal ()
     function, hence the frame id would be SP + 8.  */
  this_id = frame_id_build (sp + 8, frame_pc_unwind(next_frame));
  trad_frame_set_id (cache, this_id);

  info = bfin_linux_get_sigtramp_info (next_frame);

  for (i = 0; i < BFIN_NUM_REGS; i++)
    if (info.sc_reg_offset[i] != -1)
      trad_frame_set_reg_addr (cache, i,
			       info.context_addr + info.sc_reg_offset[i]);

  *this_cache = cache;
  return cache;
}

static void
bfin_linux_sigtramp_frame_this_id (struct frame_info *next_frame,
				   void **this_cache,
				   struct frame_id *this_id)
{
  struct trad_frame_cache *cache;

  cache = bfin_linux_sigtramp_frame_cache (next_frame, this_cache);
  trad_frame_get_id (cache, this_id);
}

static void
bfin_linux_sigtramp_frame_prev_register (struct frame_info *next_frame,
					 void **this_cache,
					 int regnum, int *optimizedp,
					 enum lval_type *lvalp,
					 CORE_ADDR *addrp,
					 int *realnump, void *valuep)
{
  /* Make sure we've initialized the cache.  */
  struct trad_frame_cache *cache;

  cache = bfin_linux_sigtramp_frame_cache (next_frame, this_cache);
  trad_frame_get_register (cache, next_frame, regnum, optimizedp, lvalp,
			   addrp, realnump, valuep);
}

static const struct frame_unwind bfin_linux_sigtramp_frame_unwind =
{
  SIGTRAMP_FRAME,
  bfin_linux_sigtramp_frame_this_id,
  bfin_linux_sigtramp_frame_prev_register
};

static const struct frame_unwind *
bfin_linux_sigtramp_frame_sniffer (struct frame_info *next_frame)
{
  char *name;
  CORE_ADDR pc = frame_pc_unwind (next_frame);

  find_pc_partial_function (pc, &name, NULL, NULL);
  if (bfin_linux_pc_in_sigtramp (pc))
    return &bfin_linux_sigtramp_frame_unwind;

  return NULL;
}

struct bfin_frame_cache
{
  /* Base address.  */
  CORE_ADDR base;
  CORE_ADDR sp_offset;
  CORE_ADDR pc;
  int frameless_pc_value;

  /* Saved registers.  */
  CORE_ADDR saved_regs[BFIN_NUM_REGS];
  CORE_ADDR saved_sp;

  /* Stack space reserved for local variables.  */
  long locals;
};

/* Allocate and initialize a frame cache.  */

static struct bfin_frame_cache *
bfin_alloc_frame_cache (void)
{
  struct bfin_frame_cache *cache;
  int i;

  cache = FRAME_OBSTACK_ZALLOC (struct bfin_frame_cache);

  /* Base address.  */
  cache->base = 0;
  cache->sp_offset = -4;
  cache->pc = 0;
  cache->frameless_pc_value = 0;

  /* Saved registers.  We initialize these to -1 since zero is a valid
     offset (that's where fp is supposed to be stored).  */
  for (i = 0; i < BFIN_NUM_REGS; i++)
    cache->saved_regs[i] = -1;

  /* Frameless until proven otherwise.  */
  cache->locals = -1;

  return cache;
}

static struct bfin_frame_cache *
bfin_frame_cache (struct frame_info *next_frame, void **this_cache)
{
  struct bfin_frame_cache *cache;
  char buf[4];
  int i;

  if (*this_cache)
    return *this_cache;

  cache = bfin_alloc_frame_cache ();
  *this_cache = cache;

  frame_unwind_register (next_frame, BFIN_FP_REGNUM, buf);
  cache->base = extract_unsigned_integer (buf, 4);
  if (cache->base == 0)
    return cache;

  /* For normal frames, PC is stored at [FP + 4].  */
  cache->saved_regs[BFIN_PC_REGNUM] = 4;
  cache->saved_regs[BFIN_FP_REGNUM] = 0;

  /* Adjust all the saved registers such that they contain addresses
     instead of offsets.  */
  for (i = 0; i < BFIN_NUM_REGS; i++)
    if (cache->saved_regs[i] != -1)
      cache->saved_regs[i] += cache->base;

  cache->pc = frame_func_unwind (next_frame) ;
  if (cache->pc == 0 || cache->pc == frame_pc_unwind (next_frame))
    {
      /* Either there is no prologue (frameless function) or we are at
	 the start of a function. In short we do not have a frame.
	 PC is stored in rets register. FP points to previous frame.  */

      cache->saved_regs[BFIN_PC_REGNUM] = read_register (BFIN_RETS_REGNUM);
      cache->frameless_pc_value = 1;
      frame_unwind_register (next_frame, BFIN_FP_REGNUM, buf);
      cache->base = extract_unsigned_integer (buf, 4);
#ifdef _DEBUG
      fprintf(stderr, "frameless pc case base %x\n", cache->base);
#endif
      cache->saved_regs[BFIN_FP_REGNUM] = cache->base;
      cache->saved_sp = cache->base;
    }
  else
    {
      cache->frameless_pc_value = 0;

      /* Now that we have the base address for the stack frame we can
	 calculate the value of SP in the calling frame.  */
      cache->saved_sp = cache->base + 8;
    }

  return cache;
}

static void
bfin_frame_this_id (struct frame_info *next_frame, void **this_cache,
		    struct frame_id *this_id)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);

  /* This marks the outermost frame.  */
  if (cache->base == 0)
    return;

  /* See the end of bfin_push_dummy_call.  */
  *this_id = frame_id_build (cache->base + 8, cache->pc);
}

static void
bfin_frame_prev_register (struct frame_info *next_frame, void **this_cache,
			  int regnum, int *optimizedp,
			  enum lval_type *lvalp, CORE_ADDR *addrp,
			  int *realnump, void *valuep)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);

  gdb_assert (regnum >= 0);

  if (regnum == BFIN_SP_REGNUM && cache->saved_sp)
    {
      *optimizedp = 0;
      *lvalp = not_lval;
      *addrp = 0;
      *realnump = -1;

      if (valuep)
	{
	  /* Store the value.  */
	  store_unsigned_integer (valuep, 4, cache->saved_sp);
	}

      return;
    }

  if (regnum < BFIN_NUM_REGS && cache->saved_regs[regnum] != -1)
    {
      *optimizedp = 0;
      *lvalp = lval_memory;
      *addrp = cache->saved_regs[regnum];
      *realnump = -1;

      if (valuep)
	{
	  /* Read the value in from memory.  */

	  if(regnum == BFIN_PC_REGNUM)
	    {
	      if (cache->frameless_pc_value)
		{
		  /* Blackfin stores the value of the return pc on
		     a register not a stack. A LINK command will
		     save it on the stack.  */
		  store_unsigned_integer (valuep, 4, *addrp);
		}
	      else
		store_unsigned_integer (valuep, 4,
				read_memory_unsigned_integer (*addrp, 4));
	    }
	  else if (regnum == BFIN_FP_REGNUM)
	    {
	      if (cache->frameless_pc_value)
		{
		  /* Blackfin stores the value of the return pc on
		     a register not a stack. A LINK command will
		     save it on the stack.  */
#ifdef _DEBUG
		  fprintf(stderr, "returning frameless %x\n", *addrp);
#endif
		  store_unsigned_integer (valuep, 4, *addrp);
		}
	      else
		store_unsigned_integer (valuep, 4,
				read_memory_unsigned_integer (*addrp, 4));
	    }
	  else
	    read_memory (*addrp, valuep,
			 register_size (current_gdbarch, regnum));
	}
      return;
    }

  frame_register_unwind (next_frame, regnum,
			 optimizedp, lvalp, addrp, realnump, valuep);
}

CORE_ADDR
bfin_frame_chain (struct frame_info *frame_ptr)
{
  return read_memory_unsigned_integer (get_frame_base(frame_ptr), 4);
}

static const struct frame_unwind bfin_frame_unwind =
{
  NORMAL_FRAME,
  bfin_frame_this_id,
  bfin_frame_prev_register
};

static const struct frame_unwind *
bfin_frame_sniffer (struct frame_info *next_frame)
{
  return &bfin_frame_unwind;
}

/* The following functions are for function prologue length calculations.  */

static int
is_minus_minus_sp (int op)
{
  op &= 0xFFC0; 

  if ((op == P_MINUS_SP1) || (op == P_MINUS_SP2)
      || (op == P_MINUS_SP3) || (op == P_MINUS_SP4))
    return 1;

  return 0;
}

CORE_ADDR
bfin_skip_prologue (CORE_ADDR pc)
{
  int op = read_memory_unsigned_integer (pc, 2);
  CORE_ADDR orig_pc = pc;
  int done = 0;

  /* The new gcc prologue generates the register saves BEFORE the link
     or RETS saving instruction.
     So, our job is to stop either at those instructions or some upper
     limit saying there is no frame!  */

  while (!done)
    {
      if (is_minus_minus_sp (op))
	{
	  while (is_minus_minus_sp (op))
	    {
	      pc += 2;
	      op = read_memory_unsigned_integer (pc, 2);
	    }

	  if (op == P_LINKAGE)
	    pc += 4;

	  done = 1;
	}
      else if (op == P_LINKAGE)
	{
	  pc += 4;
	  done = 1;
	}
      else if (op == P_MINUS_MINUS_SP_EQ_RETS)
	{
	  pc += 2;
	  done = 1;
	}
      else if (op == P_RTS)
	{
	  done = 1;
	}
      else if ((op >= P_JUMP_PREG_MIN && op <= P_JUMP_PREG_MAX)
	       || (op >= P_JUMP_PC_PLUS_PREG_MIN
		   && op <= P_JUMP_PC_PLUS_PREG_MAX)
	       || (op == P_JUMP_S_MIN && op <= P_JUMP_S_MAX))
	{
	  done = 1;
	}
      else if (pc - orig_pc >= UPPER_LIMIT)
	{
	  fprintf(stderr, "Function Prologue not recognised. pc will point to ENTRY_POINT of the function\n");
	  pc = orig_pc + 2;
	  done = 1;
	}
      else
	{
	  pc += 2; /* Not a terminating instruction go on.  */
	  op = read_memory_unsigned_integer (pc, 2);
	}
    }

   /* TODO:
      Dwarf2 uses entry point value AFTER some register initializations.
      We should perhaps skip such asssignments as well (R6 = R1, ...).  */

  return pc;
}

/* Return the GDB type object for the "standard" data type of data in
   register N.  This should be void pointer for P0-P5, SP, FP;
   void pointer to function for PC; int otherwise.  */

static struct type *
bfin_register_type (struct gdbarch *gdbarch, int regnum)
{
  if ((regnum >= BFIN_P0_REGNUM && regnum <= BFIN_FP_REGNUM)
      || regnum == BFIN_USP_REGNUM)
    return builtin_type_void_data_ptr;

  if (regnum == BFIN_PC_REGNUM || regnum == BFIN_RETS_REGNUM
      || (regnum >= BFIN_RETI_REGNUM && regnum <= BFIN_RETE_REGNUM))
    return builtin_type_void_func_ptr;

  return builtin_type_int32;
}

/* Return the saved PC from this frame.
   Assumes LINK is used in every function.  */

CORE_ADDR
bfin_frame_saved_pc (struct frame_info *frame)
{
  return read_memory_unsigned_integer (get_frame_base (frame) + RETS_OFFSET, 4);
}

static CORE_ADDR
find_func_descr (struct gdbarch *gdbarch, CORE_ADDR entry_point)
{
  CORE_ADDR descr;
  char valbuf[4];

  descr = bfin_fdpic_find_canonical_descriptor (entry_point);

  if (descr != 0)
    return descr;

  /* Construct a non-canonical descriptor from space allocated on
     the stack.  */

  descr = value_as_long (value_allocate_space_in_inferior (8));
  store_unsigned_integer (valbuf, 4, entry_point);
  write_memory (descr, valbuf, 4);
  store_unsigned_integer (valbuf, 4,
                          bfin_fdpic_find_global_pointer (entry_point));
  write_memory (descr + 4, valbuf, 4);
  return descr;
}

static CORE_ADDR
bfin_convert_from_func_ptr_addr (struct gdbarch *gdbarch, CORE_ADDR addr,
				 struct target_ops *targ)
{
  CORE_ADDR entry_point;
  CORE_ADDR got_address;

  entry_point = get_target_memory_unsigned (targ, addr, 4);
  got_address = get_target_memory_unsigned (targ, addr + 4, 4);

  if (got_address == bfin_fdpic_find_global_pointer (entry_point))
    return entry_point;
  else
    return addr;
}

/* We currently only support passing parameters in integer registers.  This
   conforms with GCC's default model.  Several other variants exist and
   we should probably support some of them based on the selected ABI.  */

static CORE_ADDR
bfin_push_dummy_call (struct gdbarch *gdbarch, struct value * function,
		      struct regcache *regcache, CORE_ADDR bp_addr, int nargs,
		      struct value **args, CORE_ADDR sp, int struct_return,
		      CORE_ADDR struct_addr)
{
  struct gdbarch_tdep *tdep = gdbarch_tdep (gdbarch);
  char buf[4];
  int i;
  long reg_r0, reg_r1, reg_r2;
  int total_len = 0;
  enum bfin_abi abi = bfin_abi (gdbarch);
  CORE_ADDR func_addr = find_function_addr (function, NULL);

  for (i = nargs - 1; i >= 0; i--)
    {
      struct type *value_type = VALUE_ENCLOSING_TYPE (args[i]);
      int len = TYPE_LENGTH (value_type);
      total_len += (len + 3) & ~3;
    }

  /* At least twelve bytes of stack space must be allocated for the function's
     arguments, even for functions that have less than 12 bytes of argument
     data.  */

  if (total_len < 12)
    sp -= 12 - total_len;

  /* Push arguments in reverse order.  */

  for (i = nargs - 1; i >= 0; i--)
    {
      struct type *value_type = VALUE_ENCLOSING_TYPE (args[i]);
      struct type *arg_type = check_typedef (value_type);
      int len = TYPE_LENGTH (value_type);
      int container_len = (len + 3) & ~3;
      sp -= container_len;

      if (abi == BFIN_ABI_FDPIC
	  && len == 4
	  && TYPE_CODE (arg_type) == TYPE_CODE_PTR
	  && TYPE_CODE (TYPE_TARGET_TYPE (arg_type)) == TYPE_CODE_FUNC)
	{
	  CORE_ADDR descr;

	  /* The FDPIC ABI requires function descriptors to be passed instead
	     of entry points.  */
	  descr = extract_unsigned_integer (VALUE_CONTENTS (args[i]), 4);
	  descr = find_func_descr (gdbarch, descr);
	  write_memory_unsigned_integer (sp, 4, descr);
	}
      else
	write_memory (sp, VALUE_CONTENTS_ALL (args[i]), container_len);
    }

  /* initialize R0, R1 and R2 to the first 3 words of paramters */

  reg_r0 = read_memory_integer (sp, 4);
  store_unsigned_integer (buf, 4, reg_r0);
  regcache_cooked_write (regcache, BFIN_R0_REGNUM, buf);
  reg_r1 = read_memory_integer (sp + 4, 4);
  store_unsigned_integer (buf, 4, reg_r1);
  regcache_cooked_write (regcache, BFIN_R1_REGNUM, buf);
  reg_r2 = read_memory_integer (sp + 8, 4);
  store_unsigned_integer (buf, 4, reg_r2);
  regcache_cooked_write (regcache, BFIN_R2_REGNUM, buf);

  /* Store struct value address.  */

  if (struct_return)
    {
      store_unsigned_integer (buf, 4, struct_addr);
      regcache_cooked_write (regcache, BFIN_P0_REGNUM, buf);
    }

  /* Set the dummy return value to bp_addr.
     A dummy breakpoint will be setup to execute the call.  */

  store_unsigned_integer (buf, 4, bp_addr);
  regcache_cooked_write (regcache, BFIN_RETS_REGNUM, buf);

  if (abi == BFIN_ABI_FDPIC)
    {
      /* Set the GOT register for the FDPIC ABI.  */
      regcache_cooked_write_unsigned
	(regcache, BFIN_P3_REGNUM,
         bfin_fdpic_find_global_pointer (func_addr));
    }

  /* Finally, update the stack pointer.  */

  store_unsigned_integer (buf, 4, sp);
  regcache_cooked_write (regcache, BFIN_SP_REGNUM, buf);

  return sp;
}

/* Convert DWARF2 register number REG to the appropriate register number
   used by GDB.  */

static int
bfin_reg_to_regnum (int reg)
{
  if (reg > sizeof (map_gcc_gdb) / sizeof (int))
    return 0;

  return map_gcc_gdb[reg];
}

#include "bfd-in2.h"

static int
gdb_print_insn_bfin (bfd_vma memaddr, disassemble_info *info)
{
  return print_insn_bfin (memaddr, info);
}

/* This function implements the BREAKPOINT_FROM_PC macro. It returns
   a pointer to a string of bytes that encode a breakpoint instruction,
   stores the length of the string to *lenptr, and adjusts the program
   counter (if necessary) to point to the actual memory location where
   the breakpoint should be inserted.  */

const unsigned char *
bfin_breakpoint_from_pc (CORE_ADDR *pcptr, int *lenptr)
{
  static unsigned char bfin_breakpoint[] = {0xa1, 0x00};
  *lenptr = sizeof (bfin_breakpoint);
  return bfin_breakpoint;
}

static void
bfin_extract_return_value (struct type *type, struct regcache *regs, void *dst)
{
  bfd_byte *valbuf = dst;
  int len = TYPE_LENGTH (type);
  ULONGEST tmp;
  int regno = BFIN_R0_REGNUM;

  gdb_assert(len <= 8);

  while (len > 0)
    {
      /* By using store_unsigned_integer we avoid having to do
	 anything special for small big-endian values.  */
      regcache_cooked_read_unsigned (regs, regno++, &tmp);
      store_unsigned_integer (valbuf, 
	(len > INT_REGISTER_RAW_SIZE ? INT_REGISTER_RAW_SIZE : len),
	tmp);
      len -= INT_REGISTER_RAW_SIZE;
      valbuf += INT_REGISTER_RAW_SIZE;
    }
}

/* Write into appropriate registers a function return value of type
   TYPE, given in virtual format.  */

static void
bfin_store_return_value (struct type *type, struct regcache *regs,
			 const void *src)
{
  const bfd_byte *valbuf = src;

  /* Integral values greater than one word are stored in consecutive
     registers starting with R0.  This will always be a multiple of
     the regiser size.  */

  int len = TYPE_LENGTH (type);
  int regno = BFIN_R0_REGNUM;

  gdb_assert (len <= 8);

  while (len > 0)
    {
      regcache_cooked_write (regs, regno++, valbuf);
      len -= INT_REGISTER_RAW_SIZE;
      valbuf += INT_REGISTER_RAW_SIZE;
    }
}

/* Determine, for architecture GDBARCH, how a return value of TYPE
   should be returned.  If it is supposed to be returned in registers,
   and READBUF is non-zero, read the appropriate value from REGCACHE,
   and copy it into READBUF.  If WRITEBUF is non-zero, write the value
   from WRITEBUF into REGCACHE.  */

static enum return_value_convention
bfin_return_value (struct gdbarch *gdbarch, struct type *type,
		   struct regcache *regcache, void *readbuf,
		   const void *writebuf)
{
  if (TYPE_LENGTH (type) > 2 * INT_REGISTER_RAW_SIZE)
    return RETURN_VALUE_STRUCT_CONVENTION;

  if (readbuf)
    bfin_extract_return_value (type, regcache, readbuf);

  if (writebuf)
    bfin_store_return_value (type, regcache, writebuf);

  return RETURN_VALUE_REGISTER_CONVENTION;
}

static int
bfin_get_longjmp_target (CORE_ADDR *pc)
{
  CORE_ADDR jb_addr;
  char buf[INT_REGISTER_RAW_SIZE];
  struct gdbarch_tdep *tdep = gdbarch_tdep (current_gdbarch);
  
  jb_addr = read_register (BFIN_R1_REGNUM);

  if (target_read_memory (jb_addr + tdep->jb_pc * tdep->jb_elt_size,
			  buf,
			  INT_REGISTER_RAW_SIZE))
    return 0;

  *pc = extract_unsigned_integer (buf, INT_REGISTER_RAW_SIZE);
  return 1;
}

/* Return the BFIN register name corresponding to register I.  */

static const char *
bfin_register_name (int i)
{
  return bfin_register_name_strings[i];
}



static CORE_ADDR
bfin_frame_base_address (struct frame_info *next_frame, void **this_cache)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);

  return cache->base;
}

static CORE_ADDR
bfin_frame_local_address (struct frame_info *next_frame, void **this_cache)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);

  return cache->base - 4;
}

static CORE_ADDR
bfin_frame_args_address (struct frame_info *next_frame, void **this_cache)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);

  return cache->base + 8;
}

static const struct frame_base bfin_frame_base =
{
  &bfin_frame_unwind,
  bfin_frame_base_address,
  bfin_frame_local_address ,
  bfin_frame_args_address 
};

static struct frame_id
bfin_unwind_dummy_id (struct gdbarch *gdbarch, struct frame_info *next_frame)
{
  char buf[4];
  CORE_ADDR sp;

  frame_unwind_register (next_frame, BFIN_SP_REGNUM, buf);
  sp = extract_unsigned_integer (buf, 4);

  return frame_id_build (sp, frame_pc_unwind (next_frame));
}

static CORE_ADDR
bfin_unwind_pc (struct gdbarch *gdbarch, struct frame_info *next_frame)
{
  char buf[8];
  int* pInt1 = (int*)buf;
  int* pInt2 = (int*)(buf +4);
  CORE_ADDR ret, start_code;

  frame_unwind_register (next_frame, PC_REGNUM , buf);

  return  extract_typed_address (buf, builtin_type_void_func_ptr);
}

static int
bfin_sim_regno (int regno)
{
  switch (regno)
    {
      case SIM_BFIN_ASTAT_REGNUM :
      case SIM_BFIN_CYCLES_REGNUM :
      case SIM_BFIN_CYCLES2_REGNUM :
      case SIM_BFIN_USP_REGNUM :
      case SIM_BFIN_SEQSTAT_REGNUM :
      case SIM_BFIN_SYSCFG_REGNUM :
      case SIM_BFIN_RETI_REGNUM :
      case SIM_BFIN_RETX_REGNUM :
      case SIM_BFIN_RETN_REGNUM :
      case SIM_BFIN_RETE_REGNUM :
      case SIM_BFIN_EXTRA1 :
      case SIM_BFIN_EXTRA2 :
      case SIM_BFIN_EXTRA3 :
      case SIM_BFIN_IPEND_REGNUM :
	return SIM_REGNO_DOES_NOT_EXIST;
      default :
	return regno;
    }
}

CORE_ADDR 
bfin_frame_align (struct gdbarch *gdbarch, CORE_ADDR address)
{
  return (address & ~0x3);
}

/* Fetch the interpreter and executable loadmap addresses (for shared
   library support) for the FDPIC ABI.  Return 0 if successful, -1 if
   not.  (E.g, -1 will be returned if the ABI isn't the FDPIC ABI.)  */
int
bfin_fdpic_loadmap_addresses (struct gdbarch *gdbarch, CORE_ADDR *interp_addr,
			      CORE_ADDR *exec_addr)
{
  if (bfin_abi (gdbarch) != BFIN_ABI_FDPIC)
    return -1;
  else
    {
      if (interp_addr != NULL)
	{
	  ULONGEST val;
	  regcache_cooked_read_unsigned (current_regcache,
					 BFIN_FDPIC_INTERP_REGNUM, &val);
	  *interp_addr = val;
	}
      if (exec_addr != NULL)
	{
	  ULONGEST val;
	  regcache_cooked_read_unsigned (current_regcache,
					BFIN_FDPIC_EXEC_REGNUM, &val);
	  *exec_addr = val;
	}
      return 0;
    }
}

/* Initialize the current architecture based on INFO.  If possible,
   re-use an architecture from ARCHES, which is a list of
   architectures already created during this debugging session.

   Called e.g. at program startup, when reading a core file, and when
   reading a binary file.  */

static struct gdbarch *
bfin_gdbarch_init (struct gdbarch_info info, struct gdbarch_list *arches)
{
  struct gdbarch_tdep *tdep;
  struct gdbarch *gdbarch;
  int elf_flags;
  enum bfin_abi abi;

  /* Extract the ELF flags, if available.  */
  if (info.abfd && bfd_get_flavour (info.abfd) == bfd_target_elf_flavour)
    elf_flags = elf_elfheader (info.abfd)->e_flags;
  else
    elf_flags = 0;

  if (elf_flags & EF_BFIN_FDPIC)
    abi = BFIN_ABI_FDPIC;
  else
    abi = BFIN_ABI_FLAT;

  /* If there is already a candidate, use it.  */

  for (arches = gdbarch_list_lookup_by_info (arches, &info);
       arches != NULL;
       arches = gdbarch_list_lookup_by_info (arches->next, &info))
    {
      if (gdbarch_tdep (arches->gdbarch)->bfin_abi != abi)
	continue;
      return arches->gdbarch;
    }

  tdep = XMALLOC (struct gdbarch_tdep);
  gdbarch = gdbarch_alloc (&info, tdep);

  tdep->bfin_abi = abi;

  set_gdbarch_num_regs (gdbarch, BFIN_NUM_REGS);
  set_gdbarch_num_pseudo_regs (gdbarch, 0); 
  set_gdbarch_sp_regnum (gdbarch, BFIN_SP_REGNUM);
  set_gdbarch_pc_regnum (gdbarch, BFIN_PC_REGNUM);
  set_gdbarch_dwarf2_reg_to_regnum (gdbarch, bfin_reg_to_regnum);
  set_gdbarch_register_name (gdbarch, bfin_register_name);
  set_gdbarch_register_type (gdbarch, bfin_register_type);
  set_gdbarch_unwind_dummy_id (gdbarch, bfin_unwind_dummy_id);
  set_gdbarch_push_dummy_call (gdbarch, bfin_push_dummy_call);
  set_gdbarch_call_dummy_location (gdbarch, ON_STACK);
  set_gdbarch_register_sim_regno (gdbarch, bfin_sim_regno);
  set_gdbarch_get_longjmp_target (gdbarch, bfin_get_longjmp_target);
  set_gdbarch_believe_pcc_promotion (gdbarch, 1);
  set_gdbarch_return_value (gdbarch, bfin_return_value);
  set_gdbarch_extract_return_value (gdbarch, bfin_extract_return_value);
  set_gdbarch_store_return_value (gdbarch, bfin_store_return_value);
  set_gdbarch_skip_prologue (gdbarch, bfin_skip_prologue);
  set_gdbarch_inner_than (gdbarch, core_addr_lessthan);
  set_gdbarch_breakpoint_from_pc (gdbarch, bfin_breakpoint_from_pc);
  set_gdbarch_decr_pc_after_break (gdbarch, 0);
  set_gdbarch_frame_args_skip (gdbarch, 8);
  set_gdbarch_unwind_pc (gdbarch, bfin_unwind_pc);
  set_gdbarch_frame_align(gdbarch, bfin_frame_align);
  set_gdbarch_print_insn (gdbarch, gdb_print_insn_bfin);

  frame_unwind_append_sniffer (gdbarch, dwarf2_frame_sniffer);

  frame_base_set_default (gdbarch, &bfin_frame_base);

  frame_unwind_append_sniffer (gdbarch, bfin_linux_sigtramp_frame_sniffer);
  frame_unwind_append_sniffer (gdbarch, bfin_frame_sniffer);


  if (bfin_abi (gdbarch) == BFIN_ABI_FDPIC)
    set_gdbarch_convert_from_func_ptr_addr (gdbarch,
					    bfin_convert_from_func_ptr_addr);

  return gdbarch;
}

static void
bfin_dump_tdep (struct gdbarch *current_gdbarch, struct ui_file *file)
{
  struct gdbarch_tdep *tdep = gdbarch_tdep (current_gdbarch);

  if (tdep == NULL)
    return;
}

extern initialize_file_ftype _initialize_bfin_tdep; /* -Wmissing-prototypes */

void
_initialize_bfin_tdep (void)
{
  gdbarch_register (bfd_arch_bfin, bfin_gdbarch_init, bfin_dump_tdep);
}

