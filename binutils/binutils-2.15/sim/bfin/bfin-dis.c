/* 
 *   Copyright (c) 2000, 2001 Analog Devices Inc.
 *   Copyright (c) 2003 Metrowerks
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

#ifndef PRINTF
#define PRINTF printf
#endif

#ifndef EXIT
#define EXIT exit
#endif

typedef long TIword;

#define HOST_LONG_WORD_SIZE (sizeof(long)*8)

#define XFIELD(w,p,s) (((w)&((1<<(s))-1)<<(p))>>(p))

#define SIGNEXTEND(v, n) (((bs32)v << (HOST_LONG_WORD_SIZE - (n))) >> (HOST_LONG_WORD_SIZE - (n)))

#include "bfin-sim.h"

static __attribute__ ((noreturn)) void
unhandled_instruction (void)
{
  raise (SIGILL);
  abort ();
}

static void
setflags_nz (bu32 val)
{
  saved_state.az = val == 0;
  saved_state.an = val >> 31;
}

static void
setflags_logical (bu32 val)
{
  setflags_nz (val);
  saved_state.ac0 = 0;
  saved_state.v = 0;
}

static bu32
ashiftrt (bu32 val, int cnt)
{
  int real_cnt = cnt > 32 ? 32 : cnt;
  bu32 sgn = ~((val >> 31) - 1);
  int sgncnt = 32 - real_cnt;
  if (sgncnt > 16)
    sgn <<= 16, sgncnt -= 16;
  sgn <<= sgncnt;
  if (real_cnt > 16)
    val >>= 16, real_cnt -= 16;
  val >>= real_cnt;
  val |= sgn;
  saved_state.an = val >> 31;
  saved_state.az = val == 0;
  /* @@@ */
  saved_state.v = 0;
  return val;
}

static bu32
lshiftrt (bu32 val, int cnt)
{
  int real_cnt = cnt > 32 ? 32 : cnt;
  if (real_cnt > 16)
    val >>= 16, real_cnt -= 16;
  val >>= real_cnt;
  saved_state.an = val >> 31;
  saved_state.az = val == 0;
  saved_state.v = 0;
  return val;
}

static bu32
lshift (bu32 val, int cnt)
{
  int real_cnt = cnt > 32 ? 32 : cnt;
  if (real_cnt > 16)
    val <<= 16, real_cnt -= 16;
  val <<= real_cnt;
  saved_state.an = val >> 31;
  saved_state.az = val == 0;
  saved_state.v = 0;
  return val;
}

static bu32
add32 (bu32 a, bu32 b, int carry)
{
  int flgs = a >> 31;
  int flgo = b >> 31;
  bu32 v = a + b;
  int flgn = v >> 31;
  int overflow = (flgs ^ flgn) & (flgo ^ flgn);
  saved_state.an = flgn;
  saved_state.vs |= overflow;
  saved_state.v = overflow;
  saved_state.v_internal |= overflow;
  saved_state.az = v == 0;
  if (carry)
    saved_state.ac0 = ~a < b;
  return v;
}

static bu32
sub32 (bu32 a, bu32 b, int carry)
{
  int flgs = a >> 31;
  int flgo = b >> 31;
  bu32 v = a - b;
  int flgn = v >> 31;
  int overflow = (flgs ^ flgo) & (flgn ^ flgs);
  saved_state.an = flgn;
  saved_state.vs |= overflow;
  saved_state.v = overflow;
  saved_state.v_internal |= overflow;
  saved_state.az = v == 0;
  if (carry)
    saved_state.ac0 = b > a;
  return v;
}

static bu32
min32 (bu32 a, bu32 b)
{
  int val = a;
  if ((bs32)a > (bs32)b)
    val = b;
  setflags_nz (val);
  saved_state.v = 0;
  return val;
}

static bu32
max32 (bu32 a, bu32 b)
{
  int val = a;
  if ((bs32)a < (bs32)b)
    val = b;
  setflags_nz (val);
  saved_state.v = 0;
  return val;
}

static bu32
add_and_shift (bu32 a, bu32 b, int shift)
{
  int v;
  saved_state.v_internal = 0;
  v = add32 (a, b, 0);
  while (shift-- > 0)
    {
      int x = v >> 30;
      if (x == 1 || x == 2)
	saved_state.v_internal = 1;
      v <<= 1;
    }
  saved_state.v = saved_state.v_internal;
  saved_state.vs |= saved_state.v;
  return v;
}

typedef enum
{
  c_0, c_1, c_4, c_2, c_uimm2, c_uimm3, c_imm3, c_pcrel4,
  c_imm4, c_uimm4s4, c_uimm4, c_uimm4s2, c_negimm5s4, c_imm5, c_uimm5, c_imm6,
  c_imm7, c_imm8, c_uimm8, c_pcrel8, c_uimm8s4, c_pcrel8s4, c_lppcrel10,
    c_pcrel10,
  c_pcrel12, c_imm16s4, c_luimm16, c_imm16, c_huimm16, c_rimm16, c_imm16s2,
    c_uimm16s4,
  c_uimm16, c_pcrel24,
} const_forms_t;

static struct
{
  char *name;
  int nbits;
  char reloc;
  char issigned;
  char pcrel;
  char scale;
  char offset;
  char negative;
  char positive;
} constant_formats[] =
{

  { "0", 0, 0, 1, 0, 0, 0, 0, 0},
  { "1", 0, 0, 1, 0, 0, 0, 0, 0},
  { "4", 0, 0, 1, 0, 0, 0, 0, 0},
  { "2", 0, 0, 1, 0, 0, 0, 0, 0},
  { "uimm2", 2, 0, 0, 0, 0, 0, 0, 0},
  { "uimm3", 3, 0, 0, 0, 0, 0, 0, 0},
  { "imm3", 3, 0, 1, 0, 0, 0, 0, 0},
  { "pcrel4", 4, 1, 0, 1, 1, 0, 0, 0},
  { "imm4", 4, 0, 1, 0, 0, 0, 0, 0},
  { "uimm4s4", 4, 0, 0, 0, 2, 0, 0, 1},
  { "uimm4", 4, 0, 0, 0, 0, 0, 0, 0},
  { "uimm4s2", 4, 0, 0, 0, 1, 0, 0, 1},
  { "negimm5s4", 5, 0, 1, 0, 2, 0, 1, 0},
  { "imm5", 5, 0, 1, 0, 0, 0, 0, 0},
  { "uimm5", 5, 0, 0, 0, 0, 0, 0, 0},
  { "imm6", 6, 0, 1, 0, 0, 0, 0, 0},
  { "imm7", 7, 0, 1, 0, 0, 0, 0, 0},
  { "imm8", 8, 0, 1, 0, 0, 0, 0, 0},
  { "uimm8", 8, 0, 0, 0, 0, 0, 0, 0},
  { "pcrel8", 8, 1, 0, 1, 1, 0, 0, 0},
  { "uimm8s4", 8, 0, 0, 0, 2, 0, 0, 0},
  { "pcrel8s4", 8, 1, 1, 1, 2, 0, 0, 0},
  { "lppcrel10", 10, 1, 0, 1, 1, 0, 0, 0},
  { "pcrel10", 10, 1, 1, 1, 1, 0, 0, 0},
  { "pcrel12", 12, 1, 1, 1, 1, 0, 0, 0},
  { "imm16s4", 16, 0, 1, 0, 2, 0, 0, 0},
  { "luimm16", 16, 1, 0, 0, 0, 0, 0, 0},
  { "imm16", 16, 0, 1, 0, 0, 0, 0, 0},
  { "huimm16", 16, 1, 0, 0, 0, 0, 0, 0},
  { "rimm16", 16, 1, 1, 0, 0, 0, 0, 0},
  { "imm16s2", 16, 0, 1, 0, 1, 0, 0, 0},
  { "uimm16s4", 16, 0, 0, 0, 2, 0, 0, 0},
  { "uimm16", 16, 0, 0, 0, 0, 0, 0, 0},
  { "pcrel24", 24, 1, 1, 1, 1, 0, 0, 0},};

static bu32
fmtconst (const_forms_t cf, bu32 x, bu32 pc)
{
  if (0 && constant_formats[cf].reloc)
    {
      bu32 ea = (((constant_formats[cf].pcrel
		   ? SIGNEXTEND (x, constant_formats[cf].nbits)
		   : x) + constant_formats[cf].offset)
		 << constant_formats[cf].scale);
      if (constant_formats[cf].pcrel)
	ea += pc;

      //      outf->print_address_func (ea, outf);
      return ea;
    }

  /* negative constants have an implied sign bit */
  if (constant_formats[cf].negative)
    {
      int nb = constant_formats[cf].nbits + 1;
      x = x | (1 << constant_formats[cf].nbits);
      x = SIGNEXTEND (x, nb);
    }
  else
    if (constant_formats[cf].issigned)
      x = SIGNEXTEND (x, constant_formats[cf].nbits);

  x += constant_formats[cf].offset;
  x <<= constant_formats[cf].scale;

  return x;
}

#undef SIGNEXTEND
#undef HOST_LONG_WORD_SIZE
#define HOST_LONG_WORD_SIZE (sizeof(long)*8)
#define SIGNEXTEND(v, n) (((long)(v) << (HOST_LONG_WORD_SIZE - (n))) >> (HOST_LONG_WORD_SIZE - (n)))

static int
const_fits (long v, const_forms_t form)
{
  int sz = constant_formats[form].nbits;
  int scale = constant_formats[form].scale;
  int offset = constant_formats[form].offset;
  int issigned = constant_formats[form].issigned;

  if (sz < 32)
    {

      long mask = (1l << sz) - 1;
      long minint;
      long maxint;

      if (constant_formats[form].negative)
	{
	  int nb = constant_formats[form].nbits + 1;
	  v = v | (1 << constant_formats[form].nbits);
	  v = SIGNEXTEND (v, nb);
	}
      else if (issigned)
	{
	  int nb = constant_formats[form].nbits;
	  v = SIGNEXTEND (v, nb);
	}

      if (constant_formats[form].negative && constant_formats[form].positive)
	{
	  minint = -1L << (sz - 1);
	  maxint = 0;
	  if (v > 0)
	    v = v | ~mask;
	}
      else if (!issigned)
	{
	  minint = 0;
	  maxint = (1 << sz) - 1;
	}
      else
	{
	  minint = (-1l << (sz - 1));
	  maxint = (1l << (sz - 1));
	}

      if (scale)
	{
	  long temp = v >> scale;
	  // This is to ensure that constants that are not
	  // rounded up to the correct bit position
	  // are not excepted by const_fits.
	  if (v != (temp << scale))
	    return 0;
	  v = temp;
	}



      // some numbers are treated a negative but have positive format by gyacc
      // The numbers are encodes as negative in the opcode

      if (constant_formats[form].negative && !constant_formats[form].positive)
	{
	  if (v >= 0)
	    return 0;
	  v = v | ~mask;
	  issigned = 0;
	}

      if (constant_formats[form].positive && !constant_formats[form].negative)
	{
	  if (v < 0)
	    return 0;
	}

      v -= offset;

      return (!issigned && (v & ~mask) == 0)
	|| ((minint <= v) && (v < maxint));
    }
  return 1;
}
enum machine_registers
{
  REG_RL0, REG_RL1, REG_RL2, REG_RL3, REG_RL4, REG_RL5, REG_RL6, REG_RL7,
  REG_RH0, REG_RH1, REG_RH2, REG_RH3, REG_RH4, REG_RH5, REG_RH6, REG_RH7,
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_R1_0, REG_R3_2, REG_R5_4, REG_R7_6, REG_P0, REG_P1, REG_P2, REG_P3,
  REG_P4, REG_P5, REG_SP, REG_FP, REG_A0x, REG_A1x, REG_A0w, REG_A1w,
  REG_A0, REG_A1, REG_I0, REG_I1, REG_I2, REG_I3, REG_M0, REG_M1,
  REG_M2, REG_M3, REG_B0, REG_B1, REG_B2, REG_B3, REG_L0, REG_L1,
  REG_L2, REG_L3, REG_AZ, REG_AN, REG_AC, REG_AV0, REG_AV1, REG_AQ,
  REG_sftreset, REG_omode, REG_excause, REG_emucause, REG_idle_req,
    REG_hwerrcause, REG_CC, REG_LC0,
  REG_LC1, REG_GP, REG_ASTAT, REG_RETS, REG_LT0, REG_LB0, REG_LT1, REG_LB1,
  REG_CYCLES, REG_CYCLES2, REG_USP, REG_SEQSTAT, REG_SYSCFG, REG_RETI,
    REG_RETX, REG_RETN,
  REG_RETE, REG_BR0, REG_BR1, REG_BR2, REG_BR3, REG_BR4, REG_BR5, REG_BR6,
  REG_BR7, REG_PL0, REG_PL1, REG_PL2, REG_PL3, REG_PL4, REG_PL5, REG_SLP,
    REG_FLP,
  REG_PH0, REG_PH1, REG_PH2, REG_PH3, REG_PH4, REG_PH5, REG_SHP, REG_FHP,
  REG_IL0, REG_IL1, REG_IL2, REG_IL3, REG_ML0, REG_ML1, REG_ML2, REG_ML3,
  REG_BL0, REG_BL1, REG_BL2, REG_BL3, REG_LL0, REG_LL1, REG_LL2, REG_LL3,
  REG_IH0, REG_IH1, REG_IH2, REG_IH3, REG_MH0, REG_MH1, REG_MH2, REG_MH3,
  REG_BH0, REG_BH1, REG_BH2, REG_BH3, REG_LH0, REG_LH1, REG_LH2, REG_LH3,
  REG_LASTREG,
};

enum reg_class
{
  rc_dregs_lo, rc_dregs_hi, rc_dregs, rc_dregs_pair, rc_pregs, rc_spfp,
    rc_dregs_hilo, rc_accum_ext,
  rc_accum_word, rc_accum, rc_iregs, rc_mregs, rc_bregs, rc_lregs, rc_dpregs,
    rc_gregs,
  rc_regs, rc_statbits, rc_ignore_bits, rc_ccstat, rc_counters,
    rc_dregs2_sysregs1, rc_open, rc_sysregs2,
  rc_sysregs3, rc_allregs,
  LIM_REG_CLASSES
};

static char *reg_names[] = {
  "R0.L", "R1.L", "R2.L", "R3.L", "R4.L", "R5.L", "R6.L", "R7.L",
  "R0.H", "R1.H", "R2.H", "R3.H", "R4.H", "R5.H", "R6.H", "R7.H",
  "R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7",
  "R1:0", "R3:2", "R5:4", "R7:6", "P0", "P1", "P2", "P3",
  "P4", "P5", "SP", "FP", "A0.x", "A1.x", "A0.w", "A1.w",
  "A0", "A1", "I0", "I1", "I2", "I3", "M0", "M1",
  "M2", "M3", "B0", "B1", "B2", "B3", "L0", "L1",
  "L2", "L3", "AZ", "AN", "AC", "AV0", "AV1", "AQ",
  "sftreset", "omode", "excause", "emucause", "idle_req", "hwerrcause", "CC",
    "LC0",
  "LC1", "GP", "ASTAT", "RETS", "LT0", "LB0", "LT1", "LB1",
  "CYCLES", "CYCLES2", "USP", "SEQSTAT", "SYSCFG", "RETI", "RETX", "RETN",
  "RETE",
  "R0.B", "R1.B", "R2.B", "R3.B", "R4.B", "R5.B", "R6.B", "R7.B",
  "P0.L", "P1.L", "P2.L", "P3.L", "P4.L", "P5.L", "SP.L", "FP.L",
  "P0.H", "P1.H", "P2.H", "P3.H", "P4.H", "P5.H", "SP.H", "FP.H",
  "I0.L", "I1.L", "I2.L", "I3.L", "M0.L", "M1.L", "M2.L", "M3.L",
  "B0.L", "B1.L", "B2.L", "B3.L", "L0.L", "L1.L", "L2.L", "L3.L",
  "I0.H", "I1.H", "I2.H", "I3.H", "M0.H", "M1.H", "M2.H", "M3.H",
  "B0.H", "B1.H", "B2.H", "B3.H", "L0.H", "L1.H", "L2.H", "L3.H",
  "LASTREG",
  0
};

#define REGNAME(x) ((x) < REG_LASTREG ? (reg_names[x]) : "...... Illegal register .......")

/* RL(0..7)  */
static enum machine_registers decode_dregs_lo[] =
{
  REG_RL0, REG_RL1, REG_RL2, REG_RL3, REG_RL4, REG_RL5, REG_RL6, REG_RL7,
};

#define dregs_lo(x) REGNAME(decode_dregs_lo[x&7])

/* RH(0..7)  */
static enum machine_registers decode_dregs_hi[] =
{
  REG_RH0, REG_RH1, REG_RH2, REG_RH3, REG_RH4, REG_RH5, REG_RH6, REG_RH7,
};

#define dregs_hi(x) REGNAME(decode_dregs_hi[x&7])

/* R(0..7)  */
static enum machine_registers decode_dregs[] =
{
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
};

#define dregs(x) REGNAME(decode_dregs[x&7])

/* R BYTE(0..7)  */
static enum machine_registers decode_dregs_byte[] =
{
  REG_BR0, REG_BR1, REG_BR2, REG_BR3, REG_BR4, REG_BR5, REG_BR6, REG_BR7,
};

#define dregs_byte(x) REGNAME(decode_dregs_byte[x&7])

/* R1:0 - R3:2 - R5:4 - R7:6 -  */
static enum machine_registers decode_dregs_pair[] =
{
  REG_R1_0, REG_LASTREG, REG_R3_2, REG_LASTREG, REG_R5_4, REG_LASTREG,
    REG_R7_6, REG_LASTREG,
};

#define dregs_pair(x) REGNAME(decode_dregs_pair[x&7])

/* P(0..5) SP FP  */
static enum machine_registers decode_pregs[] =
{
  REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
};

#define pregs(x) REGNAME(decode_pregs[x&7])

/* SP FP  */
static enum machine_registers decode_spfp[] =
{
  REG_SP, REG_FP,
};

#define spfp(x) REGNAME(decode_spfp[x&1])

/* [dregs_lo dregs_hi]  */
static enum machine_registers decode_dregs_hilo[] =
{
  REG_RL0, REG_RL1, REG_RL2, REG_RL3, REG_RL4, REG_RL5, REG_RL6, REG_RL7,
  REG_RH0, REG_RH1, REG_RH2, REG_RH3, REG_RH4, REG_RH5, REG_RH6, REG_RH7,
};

#define dregs_hilo(x,i) REGNAME(decode_dregs_hilo[((i)<<3)|x])

/* A0x A1x  */
static enum machine_registers decode_accum_ext[] =
{
  REG_A0x, REG_A1x,
};

#define accum_ext(x) REGNAME(decode_accum_ext[x&1])

/* A0w A1w  */
static enum machine_registers decode_accum_word[] =
{
  REG_A0w, REG_A1w,
};

#define accum_word(x) REGNAME(decode_accum_word[x&1])

/* A0 A1  */
static enum machine_registers decode_accum[] =
{
  REG_A0, REG_A1,
};

#define accum(x) REGNAME(decode_accum[x&1])

/* I(0..3)   */
static enum machine_registers decode_iregs[] =
{
  REG_I0, REG_I1, REG_I2, REG_I3,
};

#define iregs(x) REGNAME(decode_iregs[x&3])

/* M(0..3)   */
static enum machine_registers decode_mregs[] =
{
  REG_M0, REG_M1, REG_M2, REG_M3,
};

#define mregs(x) REGNAME(decode_mregs[x&3])

/* B(0..3)  */
static enum machine_registers decode_bregs[] =
{
  REG_B0, REG_B1, REG_B2, REG_B3,
};

#define bregs(x) REGNAME(decode_bregs[x&3])

/* L(0..3)  */
static enum machine_registers decode_lregs[] =
{
  REG_L0, REG_L1, REG_L2, REG_L3,
};

#define lregs(x) REGNAME(decode_lregs[x&3])

/* dregs pregs  */
static enum machine_registers decode_dpregs[] =
{
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
};

#define dpregs(x) REGNAME(decode_dpregs[x&15])

/* [dregs pregs] */
static enum machine_registers decode_gregs[] =
{
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
};

#define gregs(x,i) REGNAME(decode_gregs[((i)<<3)|x])

/* [dregs pregs (iregs mregs) (bregs lregs)]  */
static enum machine_registers decode_regs[] =
{
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
  REG_I0, REG_I1, REG_I2, REG_I3, REG_M0, REG_M1, REG_M2, REG_M3,
  REG_B0, REG_B1, REG_B2, REG_B3, REG_L0, REG_L1, REG_L2, REG_L3,
};

#define regs(x,i) REGNAME(decode_regs[((i)<<3)|x])

/* [dregs pregs (iregs mregs) (bregs lregs) Low Half]  */
static enum machine_registers decode_regs_lo[] =
{
  REG_RL0, REG_RL1, REG_RL2, REG_RL3, REG_RL4, REG_RL5, REG_RL6, REG_RL7,
  REG_PL0, REG_PL1, REG_PL2, REG_PL3, REG_PL4, REG_PL5, REG_SLP, REG_FLP,
  REG_IL0, REG_IL1, REG_IL2, REG_IL3, REG_ML0, REG_ML1, REG_ML2, REG_ML3,
  REG_BL0, REG_BL1, REG_BL2, REG_BL3, REG_LL0, REG_LL1, REG_LL2, REG_LL3,
};

#define regs_lo(x,i) REGNAME(decode_regs_lo[((i)<<3)|x])
/* [dregs pregs (iregs mregs) (bregs lregs) High Half]  */
static enum machine_registers decode_regs_hi[] =
{
  REG_RH0, REG_RH1, REG_RH2, REG_RH3, REG_RH4, REG_RH5, REG_RH6, REG_RH7,
  REG_PH0, REG_PH1, REG_PH2, REG_PH3, REG_PH4, REG_PH5, REG_SHP, REG_FHP,
  REG_IH0, REG_IH1, REG_IH2, REG_IH3, REG_MH0, REG_MH1, REG_LH2, REG_MH3,
  REG_BH0, REG_BH1, REG_BH2, REG_BH3, REG_LH0, REG_LH1, REG_LH2, REG_LH3,
};

#define regs_hi(x,i) REGNAME(decode_regs_hi[((i)<<3)|x])

/* AZ AN AC AV0 AV1 - AQ -                  -  -  -  -   -   -  - -                  -  -  -  -   -   -  - -                  -  -  -  -   -   -  - -  */
static enum machine_registers decode_statbits[] =
{
  REG_AZ, REG_AN, REG_AC, REG_AV0, REG_AV1, REG_LASTREG, REG_AQ, REG_LASTREG,
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
    REG_LASTREG, REG_LASTREG, REG_LASTREG,
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
    REG_LASTREG, REG_LASTREG, REG_LASTREG,
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
    REG_LASTREG, REG_LASTREG, REG_LASTREG,
};

/*static enum machine_registers decode_statbits[] = {
  REG_AZ,      REG_AN,      REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_AQ,      REG_LASTREG,
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_AC0, 	   REG_AC1,     REG_LASTREG, REG_LASTREG,
  REG_AV0,     REG_LASTREG, REG_AV1, 	 REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
  REG_V,       REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
  };*/

#define statbits(x) REGNAME(decode_statbits[x&31])

/* sftreset omode excause emucause idle_req hwerrcause */
static enum machine_registers decode_ignore_bits[] =
{
  REG_sftreset, REG_omode, REG_excause, REG_emucause, REG_idle_req,
    REG_hwerrcause,
};

#define ignore_bits(x) REGNAME(decode_ignore_bits[x&7])

/* CC  */
static enum machine_registers decode_ccstat[] =
{
  REG_CC,
};

#define ccstat(x) REGNAME(decode_ccstat[x&0])

/* LC0 LC1  */
static enum machine_registers decode_counters[] =
{
  REG_LC0, REG_LC1,
};

#define counters(x) REGNAME(decode_counters[x&1])

/* A0x A0w A1x A1w GP - ASTAT RETS  */
static enum machine_registers decode_dregs2_sysregs1[] =
{
  REG_A0x, REG_A0w, REG_A1x, REG_A1w, REG_GP, REG_LASTREG, REG_ASTAT,
    REG_RETS,
};

#define dregs2_sysregs1(x) REGNAME(decode_dregs2_sysregs1[x&7])

/* - - - - - - - - */
static enum machine_registers decode_open[] =
{
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
    REG_LASTREG, REG_LASTREG, REG_LASTREG,
};

#define open(x) REGNAME(decode_open[x&7])

/* LC0 LT0 LB0 LC1 LT1 LB1 CYCLES CYCLES2 */
static enum machine_registers decode_sysregs2[] =
{
  REG_LC0, REG_LT0, REG_LB0, REG_LC1, REG_LT1, REG_LB1, REG_CYCLES,
    REG_CYCLES2,
};

#define sysregs2(x) REGNAME(decode_sysregs2[x&7])

/* USP SEQSTAT SYSCFG RETI RETX RETN RETE - */
static enum machine_registers decode_sysregs3[] =
{
  REG_USP, REG_SEQSTAT, REG_SYSCFG, REG_RETI, REG_RETX, REG_RETN, REG_RETE,
    REG_LASTREG,
};

#define sysregs3(x) REGNAME(decode_sysregs3[x&7])

/* [dregs pregs (iregs mregs) (bregs lregs) 	         dregs2_sysregs1 open sysregs2 sysregs3] */
static enum machine_registers decode_allregs[] =
{
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
  REG_I0, REG_I1, REG_I2, REG_I3, REG_M0, REG_M1, REG_M2, REG_M3,
  REG_B0, REG_B1, REG_B2, REG_B3, REG_L0, REG_L1, REG_L2, REG_L3,
  REG_A0x, REG_A0w, REG_A1x, REG_A1w, REG_GP, REG_LASTREG, REG_ASTAT,
    REG_RETS,
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
    REG_LASTREG, REG_LASTREG, REG_LASTREG,
  REG_LC0, REG_LT0, REG_LB0, REG_LC1, REG_LT1, REG_LB1, REG_CYCLES,
    REG_CYCLES2,
  REG_USP, REG_SEQSTAT, REG_SYSCFG, REG_RETI, REG_RETX, REG_RETN, REG_RETE,
    REG_LASTREG,
};

#define allregs(x,i) REGNAME(decode_allregs[((i)<<3)|x])
#define uimm16s4(x) fmtconst(c_uimm16s4, x , pc)
#define pcrel4(x) fmtconst(c_pcrel4, x , pc)
#define pcrel8(x) fmtconst(c_pcrel8, x , pc)
#define pcrel8s4(x) fmtconst(c_pcrel8s4, x , pc)
#define pcrel10(x) fmtconst(c_pcrel10, x , pc)
#define pcrel12(x) fmtconst(c_pcrel12, x , pc)
#define negimm5s4(x) fmtconst(c_negimm5s4, x , pc)
#define rimm16(x) fmtconst(c_rimm16, x , pc)
#define huimm16(x) fmtconst(c_huimm16, x , pc)
#define imm16(x) fmtconst(c_imm16, x , pc)
#define uimm2(x) fmtconst(c_uimm2, x , pc)
#define uimm3(x) fmtconst(c_uimm3, x , pc)
#define luimm16(x) fmtconst(c_luimm16, x , pc)
#define uimm4(x) fmtconst(c_uimm4, x , pc)
#define uimm5(x) fmtconst(c_uimm5, x , pc)
#define imm16s2(x) fmtconst(c_imm16s2, x , pc)
#define uimm8(x) fmtconst(c_uimm8, x , pc)
#define imm16s4(x) fmtconst(c_imm16s4, x , pc)
#define uimm4s2(x) fmtconst(c_uimm4s2, x , pc)
#define uimm4s4(x) fmtconst(c_uimm4s4, x , pc)
#define lppcrel10(x) fmtconst(c_lppcrel10, x , pc)
#define imm3(x) fmtconst(c_imm3, x , pc)
#define imm4(x) fmtconst(c_imm4, x , pc)
#define uimm8s4(x) fmtconst(c_uimm8s4, x , pc)
#define imm5(x) fmtconst(c_imm5, x , pc)
#define imm6(x) fmtconst(c_imm6, x , pc)
#define imm7(x) fmtconst(c_imm7, x , pc)
#define imm8(x) fmtconst(c_imm8, x , pc)
#define pcrel24(x) fmtconst(c_pcrel24, x , pc)
#define uimm16(x) fmtconst(c_uimm16, x , pc)

/* (arch.pm)arch_disassembler_functions */
#define notethat(x)

#define OUTS(p,txt) abort ()

static int *
get_allreg (int grp, int reg)
{
  int fullreg = (grp << 3) | reg;
  /* REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
     REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
     REG_I0, REG_I1, REG_I2, REG_I3, REG_M0, REG_M1, REG_M2, REG_M3,
     REG_B0, REG_B1, REG_B2, REG_B3, REG_L0, REG_L1, REG_L2, REG_L3,
     REG_A0x, REG_A0w, REG_A1x, REG_A1w, REG_GP, REG_LASTREG, REG_ASTAT,
     REG_RETS,
     REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
     REG_LASTREG, REG_LASTREG, REG_LASTREG,
     REG_LC0, REG_LT0, REG_LB0, REG_LC1, REG_LT1, REG_LB1, REG_CYCLES,
     REG_CYCLES2,
     REG_USP, REG_SEQSTAT, REG_SYSCFG, REG_RETI, REG_RETX, REG_RETN, REG_RETE,
     REG_LASTREG */
  switch (fullreg >> 2)
    {
    case 0: case 1: return &DREG (reg); break;
    case 2: case 3: return &PREG (reg); break;
    case 4: return &IREG (reg & 3); break;
    case 5: return &MREG (reg & 3); break;
    case 6: return &BREG (reg & 3); break;
    case 7: return &LREG (reg & 3); break;
    default:
      switch (fullreg)
	{
	case 39: return &saved_state.rets;
	}
      return 0;
    }
}


static void
amod0 (int s0, int x0, bu32 pc)
{
  if ((s0 == 0) && (x0 == 0))
    {
      notethat ("(NS)");
      return;
    }
  else if ((s0 == 1) && (x0 == 0))
    {
      notethat ("(S)");
      OUTS (outf, "(S)");
      return;
    }
  else if ((s0 == 0) && (x0 == 1))
    {
      notethat ("(CO)");
      OUTS (outf, "(CO)");
      return;
    }
  else if ((s0 == 1) && (x0 == 1))
    {
      notethat ("(SCO)");
      OUTS (outf, "(SCO)");
      return;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return;
}

static void
amod1 (int s0, int x0, bu32 pc)
{
  if ((s0 == 0) && (x0 == 0))
    {
      notethat ("(NS)");
      OUTS (outf, "(NS)");
      return;
    }
  else if ((s0 == 1) && (x0 == 0))
    {
      notethat ("(S)");
      OUTS (outf, "(S)");
      return;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return;
}

static void
amod2 (int r0, bu32 pc)
{
  if ((r0 == 0))
    {
      notethat ("");
      return;
    }
  else if ((r0 == 2))
    {
      notethat ("(ASR)");
      OUTS (outf, "(ASR)");
      return;
    }
  else if ((r0 == 3))
    {
      notethat ("(ASL)");
      OUTS (outf, "(ASL)");
      return;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return;
}

static void
macmod_accm (int mod, bu32 pc)
{
  if ((mod == 0))
    {
      notethat ("");
      return;
    }
  else if ((mod == 8))
    {
      notethat ("(IS)");
      OUTS (outf, "(IS)");
      return;
    }
  else if ((mod == 4))
    {
      notethat ("(FU)");
      OUTS (outf, "(FU)");
      return;
    }
  else if ((mod == 3))
    {
      notethat ("(W32)");
      OUTS (outf, "(W32)");
      return;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return;
}

static void
searchmod (int r0, bu32 pc)
{
  if ((r0 == 0))
    {
      notethat ("GT");
      OUTS (outf, "GT");
      return;
    }
  else if ((r0 == 1))
    {
      notethat ("GE");
      OUTS (outf, "GE");
      return;
    }
  else if ((r0 == 2))
    {
      notethat ("LT");
      OUTS (outf, "LT");
      return;
    }
  else if ((r0 == 3))
    {
      notethat ("LE");
      OUTS (outf, "LE");
      return;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return;
}

static void
macmod_pmove (int mod, bu32 pc)
{


  if ((mod == 0))
    {
      notethat ("");
      return;
    }
  else if ((mod == 8))
    {
      notethat ("I");
      OUTS (outf, "I");
      return;
    }
  else if ((mod == 4))
    {
      notethat ("U");
      OUTS (outf, "U");
      return;
    }
  else if ((mod == 1))
    {
      notethat ("S");
      OUTS (outf, "S");
      return;
    }
  else if ((mod == 9))
    {
      notethat ("IS");
      OUTS (outf, "IS");
      return;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return;
}

static void
mxd_mod (int mod, bu32 pc)
{


  if ((mod == 0))
    {
      notethat ("");
      return;
    }
  else if ((mod == 1))
    {
      notethat ("(M)");
      OUTS (outf, "(M)");
      return;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return;
}

static void
aligndir (int r0, bu32 pc)
{


  if ((r0 == 0))
    {
      notethat ("");
      return;
    }
  else if ((r0 == 1))
    {
      notethat ("(R)");
      OUTS (outf, "(R)");
      return;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return;
}

/* static void A0macfunc (int op,int h0,int h1, bu32 pc, bfin_sim_info *outf) */
static void
A0macfunc (bu16 iw0, bu16 iw1, int op, int h0, int h1, bu32 pc)
{
/* dsp32mac
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src1 = ((iw1 >> 0) & 0x7);
  int src0 = ((iw1 >> 3) & 0x7);

  if ((h0 == 0) && (h1 == 0) && (op == 0))
    {
      notethat ("A0 = dregs_lo * dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 1) && (op == 0))
    {
      notethat ("A0 = dregs_lo * dregs_hi");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 0) && (op == 0))
    {
      notethat ("A0 = dregs_hi * dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 1) && (op == 0))
    {
      notethat ("A0 = dregs_hi * dregs_hi");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 0) && (op == 1))
    {
      notethat ("A0 += dregs_lo * dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 1) && (op == 1))
    {
      notethat ("A0 += dregs_lo * dregs_hi");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 0) && (op == 1))
    {
      notethat ("A0 += dregs_hi * dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 1) && (op == 1))
    {
      notethat ("A0 += dregs_hi * dregs_hi");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 0) && (op == 2))
    {
      notethat ("A0 -= dregs_lo * dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "-=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 1) && (op == 2))
    {
      notethat ("A0 -= dregs_lo * dregs_hi");
      OUTS (outf, "A0");
      OUTS (outf, "-=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 0) && (op == 2))
    {
      notethat ("A0 -= dregs_hi * dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "-=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 1) && (op == 2))
    {
      notethat ("A0 -= dregs_hi * dregs_hi");
      OUTS (outf, "A0");
      OUTS (outf, "-=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
/*  } else if ((op==3)) {
        notethat ("MNOP");
        OUTS(outf,"MNOP");
        return;*/
    }
  else
    unhandled_instruction ();
}

/* static void multfunc (int op,int h0,int h1, bu32 pc, bfin_sim_info *outf)  */
static void
multfunc (bu16 iw0, bu16 iw1, int op, int h0, int h1, bu32 pc)
{
/* dsp32mac
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src1 = ((iw1 >> 0) & 0x7);
  int src0 = ((iw1 >> 3) & 0x7);


  if ((h0 == 0) && (h1 == 0) && (op == 0))
    {
      notethat ("dregs_lo * dregs_lo");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 1) && (op == 0))
    {
      notethat ("dregs_lo * dregs_hi");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 0) && (op == 0))
    {
      notethat ("dregs_hi * dregs_lo");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 1) && (op == 0))
    {
      notethat ("dregs_hi * dregs_hi");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else
    unhandled_instruction ();
}
static void
A1macfunc (bu16 iw0, bu16 iw1, int op, int h0, int h1, bu32 pc)
/*static void A1macfunc (int op,int h0,int h1, bu32 pc, bfin_sim_info *outf) */
{
/* dsp32mac
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src1 = ((iw1 >> 0) & 0x7);
  int src0 = ((iw1 >> 3) & 0x7);

  if ((h0 == 0) && (h1 == 0) && (op == 0))
    {
      notethat ("A1 = dregs_lo * dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 1) && (op == 0))
    {
      notethat ("A1 = dregs_lo * dregs_hi");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 0) && (op == 0))
    {
      notethat ("A1 = dregs_hi * dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 1) && (op == 0))
    {
      notethat ("A1 = dregs_hi * dregs_hi");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 0) && (op == 1))
    {
      notethat ("A1 += dregs_lo * dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "+=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 1) && (op == 1))
    {
      notethat ("A1 += dregs_lo * dregs_hi");
      OUTS (outf, "A1");
      OUTS (outf, "+=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 0) && (op == 1))
    {
      notethat ("A1 += dregs_hi * dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "+=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 1) && (op == 1))
    {
      notethat ("A1 += dregs_hi * dregs_hi");
      OUTS (outf, "A1");
      OUTS (outf, "+=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 0) && (op == 2))
    {
      notethat ("A1 -= dregs_lo * dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "-=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 0) && (h1 == 1) && (op == 2))
    {
      notethat ("A1 -= dregs_lo * dregs_hi");
      OUTS (outf, "A1");
      OUTS (outf, "-=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 0) && (op == 2))
    {
      notethat ("A1 -= dregs_hi * dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "-=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      return;
    }
  else if ((h0 == 1) && (h1 == 1) && (op == 2))
    {
      notethat ("A1 -= dregs_hi * dregs_hi");
      OUTS (outf, "A1");
      OUTS (outf, "-=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      return;
/*  } else if ((op==3)) {
        notethat ("MNOP");
        OUTS(outf,"MNOP");
        return;   */
    }
  else
    unhandled_instruction ();
}

static void
macmod_hmove (int mod, bu32 pc)
{
  if ((mod == 0))
    {
      notethat ("");
      return;
    }
  else if ((mod == 8))
    {
      notethat ("(IS)");
      OUTS (outf, "(IS)");
      return;
    }
  else if ((mod == 4))
    {
      notethat ("(FU)");
      OUTS (outf, "(FU)");
      return;
    }
  else if ((mod == 12))
    {
      notethat ("(IU)");
      OUTS (outf, "(IU)");
      return;
    }
  else if ((mod == 2))
    {
      notethat ("(T)");
      OUTS (outf, "(T)");
      return;
    }
  else if ((mod == 6))
    {
      notethat ("(TFU)");
      OUTS (outf, "(TFU)");
      return;
    }
  else if ((mod == 1))
    {
      notethat ("(S2RND)");
      OUTS (outf, "(S2RND)");
      return;
    }
  else if ((mod == 9))
    {
      notethat ("(ISS2)");
      OUTS (outf, "(ISS2)");
      return;
    }
  else if ((mod == 11))
    {
      notethat ("(IH)");
      OUTS (outf, "(IH)");
      return;
    }
  else
    unhandled_instruction ();
}

static void
decode_ProgCtrl_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* ProgCtrl
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int poprnd = ((iw0 >> 0) & 0xf);
  int prgfunc = ((iw0 >> 4) & 0xf);



  if ((prgfunc == 0) && (poprnd == 0))
    {
      notethat ("NOP");
      PCREG += 2; return;
    }
  else if ((prgfunc == 1) && (poprnd == 0))
    {
      notethat ("RTS");
      PCREG = saved_state.rets;
      return;
    }
  else if ((prgfunc == 1) && (poprnd == 1))
    {
      notethat ("RTI");
      OUTS (outf, "RTI");
      return;
    }
  else if ((prgfunc == 1) && (poprnd == 2))
    {
      notethat ("RTX");
      OUTS (outf, "RTX");
      return;
    }
  else if ((prgfunc == 1) && (poprnd == 3))
    {
      notethat ("RTN");
      OUTS (outf, "RTN");
      return;
    }
  else if ((prgfunc == 1) && (poprnd == 4))
    {
      notethat ("RTE");
      OUTS (outf, "RTE");
      return;
    }
  else if ((prgfunc == 2) && (poprnd == 0))
    {
      notethat ("IDLE");
      OUTS (outf, "IDLE");
      PCREG += 2; return;
    }
  else if ((prgfunc == 2) && (poprnd == 3))
    {
      notethat ("CSYNC");
      OUTS (outf, "CSYNC");
      PCREG += 2; return;
    }
  else if ((prgfunc == 2) && (poprnd == 4))
    {
      notethat ("SSYNC");
      OUTS (outf, "SSYNC");
      PCREG += 2; return;
    }
  else if ((prgfunc == 2) && (poprnd == 5))
    {
      notethat ("EMUEXCPT");
      OUTS (outf, "EMUEXCPT");
      PCREG += 2; return;
    }
  else if ((prgfunc == 3))
    {
      notethat ("CLI dregs");
      OUTS (outf, "CLI  ");
      OUTS (outf, dregs (poprnd));
      PCREG += 2; return;
    }
  else if ((prgfunc == 4))
    {
      notethat ("STI dregs");
      OUTS (outf, "STI");
      OUTS (outf, dregs (poprnd));
      PCREG += 2; return;
    }
  else if ((prgfunc == 5))
    {
      notethat ("JUMP ( pregs )");
      PCREG = PREG (poprnd);
      return;
    }
  else if ((prgfunc == 6))
    {
      notethat ("CALL ( pregs )");
      saved_state.rets = PCREG + 2;
      PCREG = PREG (poprnd);
      return;
    }
  else if ((prgfunc == 7))
    {
      notethat ("CALL ( PC + pregs )");
      saved_state.rets = PCREG + 2;
      PCREG = PCREG + PREG (poprnd);
      return;
    }
  else if ((prgfunc == 8))
    {
      notethat ("JUMP ( PC + pregs )");
      PCREG = PCREG + PREG (poprnd);
      return;
    }
  else if ((prgfunc == 9))
    {
      notethat ("RAISE uimm4");
      bfin_trap ();
      PCREG += 2; return;
    }
  else if ((prgfunc == 10))
    {
      notethat ("EXCPT uimm4");
      OUTS (outf, "EXCPT  ");
      OUTS (outf, uimm4 (poprnd));
      PCREG += 2; return;
    }
  else if ((prgfunc == 11))
    {
      notethat ("TESTSET ( pregs )");
      OUTS (outf, "TESTSET  ");
      OUTS (outf, "(");
      OUTS (outf, pregs (poprnd));
      OUTS (outf, ")");
      PCREG += 2; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_CaCTRL_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* CaCTRL
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int a = ((iw0 >> 5) & 0x1);
  int reg = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 3) & 0x3);



  if ((a == 0) && (op == 0))
    {
      notethat ("PREFETCH [ pregs ]");
      OUTS (outf, "PREFETCH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((a == 0) && (op == 1))
    {
      notethat ("FLUSHINV [ pregs ]");
      OUTS (outf, "FLUSHINV");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((a == 0) && (op == 2))
    {
      notethat ("FLUSH [ pregs ]");
      OUTS (outf, "FLUSH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((a == 0) && (op == 3))
    {
      notethat ("IFLUSH [ pregs ]");
      OUTS (outf, "IFLUSH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((a == 1) && (op == 0))
    {
      notethat ("PREFETCH [ pregs ++ ]");
      OUTS (outf, "PREFETCH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "++");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((a == 1) && (op == 1))
    {
      notethat ("FLUSHINV [ pregs ++ ]");
      OUTS (outf, "FLUSHINV");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "++");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((a == 1) && (op == 2))
    {
      notethat ("FLUSH [ pregs ++ ]");
      OUTS (outf, "FLUSH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "++");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((a == 1) && (op == 3))
    {
      notethat ("IFLUSH [ pregs ++ ]");
      OUTS (outf, "IFLUSH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "++");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_PushPopReg_0 (bu16 iw0, bu16 iw1, bu32 pc)
{

/* PushPopReg
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.W.|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int grp = ((iw0 >> 3) & 0x7);
  int reg = ((iw0 >> 0) & 0x7);
  int W = ((iw0 >> 6) & 0x1);
  int *whichreg = get_allreg (grp, reg);

  if (whichreg == 0)
    unhandled_instruction ();

  if (W == 0)
    {
      bu32 word;
      notethat ("allregs = [ SP ++ ]");
      *whichreg = get_long (saved_state.memory, PREG (6));
      PREG (6) += 4;
    }
  else
    {
      bu32 word;
      notethat ("[ -- SP ] = allregs");
      PREG (6) -= 4;
      put_long (saved_state.memory, PREG (6), *whichreg);
    }
  PCREG += 2; return;

}

static void
decode_PushPopMultiple_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* PushPopMultiple
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int p = ((iw0 >> 7) & 0x1);
  int pr = ((iw0 >> 0) & 0x7);
  int d = ((iw0 >> 8) & 0x1);
  int dr = ((iw0 >> 3) & 0x7);
  int W = ((iw0 >> 6) & 0x1);
  int i;
  bu32 sp = PREG (6);

  if (d == 0 && p == 0)
    unhandled_instruction ();
  if (p && imm5 (pr) > 5)
    unhandled_instruction ();

  if (W == 1)
    {
      if (d)
	for (i = imm5 (dr); i < 8; i++)
	  {
	    sp -= 4;
	    put_long (saved_state.memory, sp, DREG (i));
	  }
      if (p)
	for (i = imm5 (pr); i < 6; i++)
	  {
	    sp -= 4;
	    put_long (saved_state.memory, sp, PREG (i));
	  }
    }
  else
    {
      if (p)
	for (i = 5; i >= imm5 (pr); i--)
	  {
	    PREG (i) = get_long (saved_state.memory, sp);
	    sp += 4;
	  }
      if (d)
	for (i = 7; i >= imm5 (dr); i--)
	  {
	    DREG (i) = get_long (saved_state.memory, sp);
	    sp += 4;
	  }
    }      
  PREG (6) = sp;
  PCREG += 2; return;
}

static void
decode_ccMV_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* ccMV
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 1 |.T.|.d.|.s.|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src = ((iw0 >> 0) & 0x7);
  int dst = ((iw0 >> 3) & 0x7);
  int s = ((iw0 >> 6) & 0x1);
  int d = ((iw0 >> 7) & 0x1);
  int T = ((iw0 >> 8) & 0x1);
  int cond = T ? CCREG : ! CCREG;
  if (cond)
    GREG (dst, d) = GREG (src, s);
  PCREG += 2; return;
}

static void
decode_CCflag_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* CCflag
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
  */
  int x = ((iw0 >> 0) & 0x7);
  int y = ((iw0 >> 3) & 0x7);
  int I = ((iw0 >> 10) & 0x1);
  int opc = ((iw0 >> 7) & 0x7);
  int G = ((iw0 >> 6) & 0x1);

  if (opc > 4)
    {
      if ((opc == 5) && (I == 0) && (G == 0))
	{
	  notethat ("CC = A0 == A1");
	  OUTS (outf, "CC");
	  OUTS (outf, "=");
	  OUTS (outf, "A0");
	  OUTS (outf, "==");
	  OUTS (outf, "A1");
	  PCREG += 2; return;
	}
      else if ((opc == 6) && (I == 0) && (G == 0))
	{
	  notethat ("CC = A0 < A1");
	  OUTS (outf, "CC");
	  OUTS (outf, "=");
	  OUTS (outf, "A0");
	  OUTS (outf, "<");
	  OUTS (outf, "A1");
	  PCREG += 2; return;
	}
      else if ((opc == 7) && (I == 0) && (G == 0))
	{
	  notethat ("CC = A0 <= A1");
	  OUTS (outf, "CC");
	  OUTS (outf, "=");
	  OUTS (outf, "A0");
	  OUTS (outf, "<=");
	  OUTS (outf, "A1");
	  PCREG += 2; return;
	}
    }
  else
    {
      int issigned = opc < 3;
      bu32 srcop = G ? PREG (x) : DREG (x);
      bu32 dstop = I ? (issigned ? imm3 (y) : uimm3 (y)) : G ? PREG (y) : DREG (y);
      int flgs = srcop >> 31;
      int flgo = dstop >> 31;

      bu32 result = srcop - dstop;
      int flgn = result >> 31;
      int overflow = (flgs ^ flgo) & (flgn ^ flgs);

      saved_state.az = result == 0;
      saved_state.an = flgn;
      saved_state.ac0 = srcop < dstop;
      switch (opc)
	{
	case 0: /* == */
	  CCREG = saved_state.az;
	  break;
	case 1: /* <, signed */
	  CCREG = (flgn && !overflow) || (!flgn && overflow);
	  break;
	case 2: /* <=, signed */
	  CCREG = (flgn && !overflow) || (!flgn && overflow) || saved_state.az;
	  break;
	case 3: /* <, unsigned */
	  CCREG = saved_state.ac0;
	  break;
	case 4: /* <=, unsigned */
	  CCREG = saved_state.ac0 | saved_state.az;
	  break;
	}
      PCREG += 2; return;
    }
}

static void
decode_CC2dreg_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* CC2dreg
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int reg = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 3) & 0x3);

  if ((op == 0))
    {
      notethat ("dregs = CC");
      DREG (reg) = CCREG;
    }
  else if ((op == 1))
    {
      notethat ("CC = dregs");
      CCREG = DREG (reg) != 0;
    }
  else if ((op == 3))
    {
      notethat ("CC =! CC");
      CCREG = ! CCREG;
    }
  else
    unhandled_instruction ();
  PCREG += 2;
}

static void
decode_CC2stat_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* CC2stat
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int cbit = ((iw0 >> 0) & 0x1f);
  int D = ((iw0 >> 7) & 0x1);
  int op = ((iw0 >> 5) & 0x3);
  int *pval;

  switch (cbit)
    {
    case 0: pval = &saved_state.az; break;
    case 1: pval = &saved_state.an; break;
    case 6: pval = &saved_state.aq; break;
    case 12: pval = &saved_state.ac0; break;
    case 13: pval = &saved_state.ac1; break;
    case 16: pval = &saved_state.av0; break;
    case 17: pval = &saved_state.av0s; break;
    case 18: pval = &saved_state.av1; break;
    case 19: pval = &saved_state.av1s; break;
    case 24: pval = &saved_state.v; break;
    case 25: pval = &saved_state.vs; break;
    default:
      unhandled_instruction ();
    }

  if (D == 0)
    switch (op)
      {
      case 0: CCREG = *pval; break;
      case 1: CCREG |= *pval; break;
      case 2: CCREG &= *pval; break;
      case 3: CCREG ^= *pval; break;
      }
  else
    switch (op)
      {
      case 0: *pval = CCREG; break;
      case 1: *pval |= CCREG; break;
      case 2: *pval &= CCREG; break;
      case 3: *pval ^= CCREG; break;
      }
  PCREG += 2;
}

static void
decode_BRCC_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* BRCC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int B = ((iw0 >> 10) & 0x1);
  int T = ((iw0 >> 11) & 0x1);
  int offset = ((iw0 >> 0) & 0x3ff);

  /* B is just the branch predictor hint - we can ignore it.  */

  notethat ("IF CC JUMP pcrel10");
  if (CCREG == T)
    PCREG += pcrel10 (offset);
  else
    PCREG += 2; return;
}

static void
decode_UJUMP_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* UJUMP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 0 |.offset........................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int offset = ((iw0 >> 0) & 0xfff);

  notethat ("JUMP.S pcrel12");
  PCREG += pcrel12 (offset);
}

static void
decode_REGMV_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* REGMV
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 1 |.gd........|.gs........|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src = ((iw0 >> 0) & 0x7);
  int gs = ((iw0 >> 6) & 0x7);
  int dst = ((iw0 >> 3) & 0x7);
  int gd = ((iw0 >> 9) & 0x7);
  int *srcreg = get_allreg (gs, src);
  int *dstreg = get_allreg (gd, dst);
  
  if (srcreg == 0 || dstreg == 0)
    unhandled_instruction ();

  *dstreg = *srcreg;
  PCREG += 2; return;
}

static void
decode_ALU2op_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* ALU2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src = ((iw0 >> 3) & 0x7);
  int opc = ((iw0 >> 6) & 0xf);
  int dst = ((iw0 >> 0) & 0x7);

  if ((opc == 0))
    {
      notethat ("dregs >>>= dregs");
      DREG (dst) = ashiftrt (DREG (dst), DREG (src));
    }
  else if ((opc == 1))
    {
      notethat ("dregs >>= dregs");
      DREG (dst) = lshiftrt (DREG (dst), DREG (src));
    }
  else if ((opc == 2))
    {
      notethat ("dregs <<= dregs");
      DREG (dst) = lshift (DREG (dst), DREG (src));
    }
  else if ((opc == 3))
    {
      notethat ("dregs *= dregs");
      DREG (dst) *= DREG (src);
    }
  else if ((opc == 4))
    {
      notethat ("dregs = (dregs + dregs) << 1");
      DREG (dst) = add_and_shift (DREG (dst), DREG (src), 1);
    }
  else if ((opc == 5))
    {
      notethat ("dregs = (dregs + dregs) << 2");
      DREG (dst) = add_and_shift (DREG (dst), DREG (src), 2);
    }
  else if ((opc == 8))
    {
      notethat ("DIVQ (dregs , dregs)");
      OUTS (outf, "DIVQ");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, dregs (src));
      OUTS (outf, ")");
      PCREG += 2; return;
    }
  else if ((opc == 9))
    {
      notethat ("DIVS (dregs , dregs)");
      OUTS (outf, "DIVS");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, dregs (src));
      OUTS (outf, ")");
    }
  else if ((opc == 10))
    {
      notethat ("dregs = dregs_lo (X)");
      DREG (dst) = (bs32) (bs16) DREG (src);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 11))
    {
      notethat ("dregs = dregs_lo (Z)");
      DREG (dst) = (bu32) (bu16) DREG (src);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 12))
    {
      notethat ("dregs = dregs_byte (X)");
      DREG (dst) = (bs32) (bs8) DREG (src);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 13))
    {
      notethat ("dregs = dregs_byte (Z)");
      DREG (dst) = (bu32) (bu8) DREG (src);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 14))
    {
      bu32 val = DREG (src);
      notethat ("dregs = - dregs");
      DREG (dst) = -val;
      setflags_nz (DREG (dst));
      if (val == 0x80000000)
	{
	  saved_state.v = saved_state.vs = 1;
	}
      /* @@@ Documentation isn't entirely clear about av0 and av1.  */
    }
  else if ((opc == 15))
    {
      notethat ("dregs = ~ dregs");
      DREG (dst) = ~DREG (src);
      setflags_logical (DREG (dst));
    }
  else
    unhandled_instruction ();
  PCREG += 2; return;
}

static void
decode_PTR2op_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* PTR2op
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
  */
  int src = ((iw0 >> 3) & 0x7);
  int opc = ((iw0 >> 6) & 0x7);
  int dst = ((iw0 >> 0) & 0x7);

  if ((opc == 0))
    PREG (dst) -= PREG (src);
  else if ((opc == 1))
    PREG (dst) = PREG (src) << 2;
  else if ((opc == 3))
    PREG (dst) = PREG (src) >> 2;
  else if ((opc == 4))
    PREG (dst) = PREG (src) >> 1;
  else if ((opc == 5))
    {
      notethat ("pregs += pregs ( BREV )");
      OUTS (outf, pregs (dst));
      OUTS (outf, "+=");
      OUTS (outf, pregs (src));
      OUTS (outf, "(");
      OUTS (outf, "BREV");
      OUTS (outf, ")");
    }
  else if ((opc == 6))
    PREG (dst) = (PREG (dst) + PREG (src)) << 1;
  else if ((opc == 7))
    PREG (dst) = (PREG (dst) + PREG (src)) << 2;
  else
    unhandled_instruction ();

  PCREG += 2; return;
}

static void
decode_LOGI2op_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* LOGI2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src = ((iw0 >> 3) & 0x1f);
  int opc = ((iw0 >> 8) & 0x7);
  int dst = ((iw0 >> 0) & 0x7);

  if ((opc == 0))
    {
      notethat ("CC = ! BITTST ( dregs , uimm5 )");
      CCREG = (~DREG (dst) >> uimm5 (src)) & 1;
    }
  else if ((opc == 1))
    {
      notethat ("CC = BITTST ( dregs , uimm5 )");
      CCREG = (DREG (dst) >> uimm5 (src)) & 1;
    }
  else if ((opc == 2))
    {
      notethat ("BITSET ( dregs , uimm5 )");
      DREG (dst) |= 1 << uimm5 (src);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 3))
    {
      notethat ("BITTGL ( dregs , uimm5 )");
      DREG (dst) ^= 1 << uimm5 (src);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 4))
    {
      notethat ("BITCLR ( dregs , uimm5 )");
      DREG (dst) &= ~(1 << uimm5 (src));
      setflags_logical (DREG (dst));
    }
  else if ((opc == 5))
    {
      notethat ("dregs >>>= uimm5");
      DREG (dst) = ashiftrt (DREG (dst), uimm5 (src));
    }
  else if ((opc == 6))
    {
      notethat ("dregs >>= uimm5");
      DREG (dst) = lshiftrt (DREG (dst), uimm5 (src));
    }
  else if ((opc == 7))
    {
      notethat ("dregs <<= uimm5");
      DREG (dst) = lshift (DREG (dst), uimm5 (src));
    }
  PCREG += 2; return;
}

static void
decode_COMP3op_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* COMP3op
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
  */
  int src0 = ((iw0 >> 0) & 0x7);
  int src1 = ((iw0 >> 3) & 0x7);
  int opc = ((iw0 >> 9) & 0x7);
  int dst = ((iw0 >> 6) & 0x7);


  if ((opc == 0))
    {
      notethat ("dregs = dregs + dregs");
      DREG (dst) = add32 (DREG (src0), DREG (src1), 1);
    }
  else if ((opc == 1))
    {
      notethat ("dregs = dregs - dregs");
      DREG (dst) = sub32 (DREG (src0), DREG (src1), 1);
    }
  else if ((opc == 2))
    {
      notethat ("dregs = dregs & dregs");
      DREG (dst) = DREG (src0) & DREG (src1);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 3))
    {
      notethat ("dregs = dregs | dregs");
      DREG (dst) = DREG (src0) | DREG (src1);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 4))
    {
      notethat ("dregs = dregs ^ dregs");
      DREG (dst) = DREG (src0) ^ DREG (src1);
      setflags_logical (DREG (dst));
    }
  else if ((opc == 5))
    /* If src0 == src1 this is disassembled as a shift by 1, but this
       distinction doesn't matter for our purposes.  */
    PREG (dst) = PREG (src0) + PREG (src1);
  else if ((opc == 6))
    PREG (dst) = PREG (src0) + (PREG (src1) << 1);
  else if ((opc == 7))
    PREG (dst) = PREG (src0) + (PREG (src1) << 2);

  PCREG += 2; return;
}

static void
decode_COMPI2opD_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* COMPI2opD
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 0 |.op|.isrc......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int isrc = ((iw0 >> 3) & 0x7f);
  int dst = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 10) & 0x1);

  if (op == 0)
    DREG (dst) = imm7 (isrc);
  else if (op == 1)
    DREG (dst) = add32 (DREG (dst), imm7 (isrc), 1);
  PCREG += 2; return;
}

static void
decode_COMPI2opP_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* COMPI2opP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 1 |.op|.src.......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src = ((iw0 >> 3) & 0x7f);
  int dst = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 10) & 0x1);

  if (op == 0)
    PREG (dst) = imm7 (src);
  else if (op == 1)
    PREG (dst) += imm7 (src);
  PCREG += 2; return;
}

static void
decode_LDSTpmod_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* LDSTpmod
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int aop = ((iw0 >> 9) & 0x3);
  int idx = ((iw0 >> 3) & 0x7);
  int ptr = ((iw0 >> 0) & 0x7);
  int reg = ((iw0 >> 6) & 0x7);
  int W = ((iw0 >> 11) & 0x1);



  if ((aop == 1) && (W == 0) && (idx == ptr))
    {
      notethat ("dregs_lo = W [ pregs ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 0) && (idx == ptr))
    {
      notethat ("dregs_hi = W [ pregs ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 1) && (idx == ptr))
    {
      notethat ("W [ pregs ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 1) && (idx == ptr))
    {
      notethat ("W [ pregs ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      PCREG += 2; return;
    }
  else if ((aop == 0) && (W == 0))
    {
      notethat ("dregs = [ pregs ++ pregs ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 0))
    {
      notethat ("dregs_lo = W [ pregs ++ pregs ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 0))
    {
      notethat ("dregs_hi = W [ pregs ++ pregs ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 3) && (W == 0))
    {
      notethat ("dregs = W [ pregs ++ pregs ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "] (Z)");
      PCREG += 2; return;
    }
  else if ((aop == 3) && (W == 1))
    {
      notethat ("dregs = W [ pregs ++ pregs ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      PCREG += 2; return;
    }
  else if ((aop == 0) && (W == 1))
    {
      notethat ("[ pregs ++ pregs ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 1))
    {
      notethat (" W [ pregs ++ pregs ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 1))
    {
      notethat (" W[ pregs ++ pregs ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      PCREG += 2; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_dagMODim_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* dagMODim
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |.br| 1 | 1 |.op|.m.....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int i = ((iw0 >> 0) & 0x3);
  int br = ((iw0 >> 7) & 0x1);
  int m = ((iw0 >> 2) & 0x3);
  int op = ((iw0 >> 4) & 0x1);



  if ((op == 0) && (br == 1))
    {
      notethat ("iregs += mregs ( BREV )");
      OUTS (outf, iregs (i));
      OUTS (outf, "+=");
      OUTS (outf, mregs (m));
      OUTS (outf, "(");
      OUTS (outf, "BREV");
      OUTS (outf, ")");
      PCREG += 2; return;
    }
  else if ((op == 0))
    {
      notethat ("iregs += mregs");
      OUTS (outf, iregs (i));
      OUTS (outf, "+=");
      OUTS (outf, mregs (m));
      PCREG += 2; return;
    }
  else if ((op == 1))
    {
      notethat ("iregs -= mregs");
      OUTS (outf, iregs (i));
      OUTS (outf, "-=");
      OUTS (outf, mregs (m));
      PCREG += 2; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_dagMODik_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* dagMODik
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int i = ((iw0 >> 0) & 0x3);
  int op = ((iw0 >> 2) & 0x3);



  if ((op == 0))
    {
      notethat ("iregs += 2");
      OUTS (outf, iregs (i));
      OUTS (outf, "+=");
      OUTS (outf, "2");
      PCREG += 2; return;
    }
  else if ((op == 1))
    {
      notethat ("iregs -= 2");
      OUTS (outf, iregs (i));
      OUTS (outf, "-=");
      OUTS (outf, "2");
      PCREG += 2; return;
    }
  else if ((op == 2))
    {
      notethat ("iregs += 4");
      OUTS (outf, iregs (i));
      OUTS (outf, "+=");
      OUTS (outf, "4");
      PCREG += 2; return;
    }
  else if ((op == 3))
    {
      notethat ("iregs -= 4");
      OUTS (outf, iregs (i));
      OUTS (outf, "-=");
      OUTS (outf, "4");
      PCREG += 2; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_dspLDST_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* dspLDST
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int aop = ((iw0 >> 7) & 0x3);
  int i = ((iw0 >> 3) & 0x3);
  int m = ((iw0 >> 5) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);
  int W = ((iw0 >> 9) & 0x1);



  if ((aop == 0) && (W == 0) && (m == 0))
    {
      notethat ("dregs = [ iregs ++ ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 0) && (W == 0) && (m == 1))
    {
      notethat ("dregs_lo = W [ iregs ++ ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 0) && (W == 0) && (m == 2))
    {
      notethat ("dregs_hi = W [ iregs ++ ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 0) && (m == 0))
    {
      notethat ("dregs = [ iregs -- ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 0) && (m == 1))
    {
      notethat ("dregs_lo = W [ iregs -- ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 0) && (m == 2))
    {
      notethat ("dregs_hi = W [ iregs -- ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 0) && (m == 0))
    {
      notethat ("dregs = [ iregs ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 0) && (m == 1))
    {
      notethat ("dregs_lo = W [ iregs ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 0) && (m == 2))
    {
      notethat ("dregs_hi = W [ iregs ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 0) && (W == 1) && (m == 0))
    {
      notethat ("[ iregs ++ ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      PCREG += 2; return;
    }
  else if ((aop == 0) && (W == 1) && (m == 1))
    {
      notethat ("W [ iregs ++ ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      PCREG += 2; return;
    }
  else if ((aop == 0) && (W == 1) && (m == 2))
    {
      notethat ("W [ iregs ++ ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 1) && (m == 0))
    {
      notethat ("[ iregs -- ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 1) && (m == 1))
    {
      notethat ("W [ iregs -- ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      PCREG += 2; return;
    }
  else if ((aop == 1) && (W == 1) && (m == 2))
    {
      notethat ("W [ iregs -- ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 1) && (m == 0))
    {
      notethat ("[ iregs ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 1) && (m == 1))
    {
      notethat (" W [ iregs ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      PCREG += 2; return;
    }
  else if ((aop == 2) && (W == 1) && (m == 2))
    {
      notethat (" W [ iregs ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      PCREG += 2; return;
    }
  else if ((aop == 3) && (W == 0))
    {
      notethat ("dregs = [ iregs ++ mregs ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, mregs (m));
      OUTS (outf, "]");
      PCREG += 2; return;
    }
  else if ((aop == 3) && (W == 1))
    {
      notethat ("[ iregs ++ mregs ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, mregs (m));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      PCREG += 2; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_LDST_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* LDST
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
  */
  int aop = ((iw0 >> 7) & 0x3);
  int Z = ((iw0 >> 6) & 0x1);
  int sz = ((iw0 >> 10) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);
  int ptr = ((iw0 >> 3) & 0x7);
  int W = ((iw0 >> 9) & 0x1);

  if (aop == 3)
    unhandled_instruction ();

  if (W == 0)
    {
      if (aop != 2 && sz == 0 && Z == 1)
	if (ptr == reg)
	  unhandled_instruction ();

      if ((sz == 0) && (Z == 0))
	{
	  notethat ("dregs = [ pregs ]");
	  DREG (reg) = get_long (saved_state.memory, PREG (ptr));
	}
      else if ((sz == 0) && (Z == 1))
	{
	  notethat ("pregs = [ pregs ]");
	  PREG (reg) = get_long (saved_state.memory, PREG (ptr));
	}
      else if ((sz == 1) && (Z == 0))
	{
	  notethat ("dregs = W [ pregs ] (z)");
	  DREG (reg) = get_word (saved_state.memory, PREG (ptr));
	}
      else if ((sz == 1) && (Z == 1))
	{
	  notethat ("dregs = W [ pregs ] (X)");
	  DREG (reg) = (bs32) (bs16) get_word (saved_state.memory, PREG (ptr));
	}
      else if ((sz == 2) && (Z == 0))
	{
	  notethat ("dregs = B [ pregs ] (Z)");
	  DREG (reg) = get_byte (saved_state.memory, PREG (ptr));
	}
      else if ((sz == 2) && (Z == 1))
	{
	  notethat ("dregs = B [ pregs ] (X)");
	  DREG (reg) = (bs32) (bs8) get_byte (saved_state.memory, PREG (ptr));
	}

      if (aop == 0)
	PREG (ptr) += sz == 0 ? 4 : sz == 1 ? 2 : 1;
      if (aop == 1)
	PREG (ptr) -= sz == 0 ? 4 : sz == 1 ? 2 : 1;
    }
  else
    {
      if (sz != 0 && Z == 1)
	unhandled_instruction ();

      if ((sz == 0) && (Z == 0))
	{
	  notethat ("[ pregs ] = dregs");
	  put_long (saved_state.memory, PREG (ptr), DREG (reg));
	}
      else if ((sz == 0) && (Z == 1))
	{
	  notethat ("[ pregs ] = pregs");
	  put_long (saved_state.memory, PREG (ptr), PREG (reg));
	}
      else if ((sz == 1) && (Z == 0))
	{
	  notethat ("W [ pregs ] = dregs");
	  put_word (saved_state.memory, PREG (ptr), DREG (reg));
	}
      else if ((sz == 2) && (Z == 0))
	{
	  notethat ("B [ pregs ] = dregs");
	  put_byte (saved_state.memory, PREG (ptr), DREG (reg));
	}

      if (aop == 0)
	PREG (ptr) += sz == 0 ? 4 : sz == 1 ? 2 : 1;
      if (aop == 1)
	PREG (ptr) -= sz == 0 ? 4 : sz == 1 ? 2 : 1;
    }      

  PCREG += 2; return;
}

static void
decode_LDSTiiFP_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* LDSTiiFP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 | 1 | 1 | 0 |.W.|.offset............|.reg...........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int reg = ((iw0 >> 0) & 0xf);
  int offset = ((iw0 >> 4) & 0x1f);
  int W = ((iw0 >> 9) & 0x1);
  bu32 ea = PREG (7) + negimm5s4 (offset);

  if (W == 0)
    DPREG (reg) = get_long (saved_state.memory, ea);
  else
    put_long (saved_state.memory, ea, DPREG (reg));
  PCREG += 2; return;
}

static void
decode_LDSTii_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* LDSTii
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
  */
  int reg = ((iw0 >> 0) & 0x7);
  int ptr = ((iw0 >> 3) & 0x7);
  int offset = ((iw0 >> 6) & 0xf);
  int op = ((iw0 >> 10) & 0x3);
  int W = ((iw0 >> 12) & 0x1);
  bu32 ea = PREG (ptr) + (op == 0 || op == 3 ? uimm4s4 (offset) 
			  : uimm4s2 (offset));

  if (W == 1 && op == 2)
    unhandled_instruction ();

  if (W == 0)
    { 
      if (op == 0)
	{
	  notethat ("dregs = [ pregs + uimm4s4 ]");
	  DREG (reg) = get_long (saved_state.memory, ea);
	}
      else if (op == 1)
	{
	  notethat ("dregs = W [ pregs + uimm4s2 ] (Z)");
	  DREG (reg) = get_word (saved_state.memory, ea);
	}
      else if (op == 2)
	{
	  notethat ("dregs = W [ pregs + uimm4s2 ] (X)");
	  DREG (reg) = (bs32) (bs16) get_word (saved_state.memory, ea);
	}
      else if (op == 3)
	{
	  notethat ("pregs = [ pregs + uimm4s4 ]");
	  PREG (reg) = get_long (saved_state.memory, ea);
	}
    }
  else
    {
      if (op == 0)
	{
	  notethat ("[ pregs + uimm4s4 ] = dregs");
	  put_long (saved_state.memory, ea, DREG (reg));
	}
      else if (op == 1)
	{
	  notethat ("W [ pregs + uimm4s2 ] = dregs");
	  put_word (saved_state.memory, ea, DREG (reg));
	}
      else if (op == 3)
	{
	  notethat ("[ pregs + uimm4s4 ] = pregs");
	  put_long (saved_state.memory, ea, PREG (reg));
	}
    }
  PCREG += 2;
}

static void
decode_LoopSetup_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* LoopSetup
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |.rop...|.c.|.soffset.......|
|.reg...........| - | - |.eoffset...............................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int rop = ((iw0 >> 5) & 0x3);
  int soffset = ((iw0 >> 0) & 0xf);
  int c = ((iw0 >> 4) & 0x1);
  int eoffset = ((iw1 >> 0) & 0x3ff);
  int reg = ((iw1 >> 12) & 0xf);

  if ((rop == 0))
    {
      notethat ("LSETUP ( pcrel4 , lppcrel10 ) counters");
      saved_state.lt[c] = PCREG + pcrel4 (soffset);
      saved_state.lb[c] = PCREG + lppcrel10 (eoffset);
      PCREG += 4; return;
    }
  else if ((rop == 1))
    {
      notethat ("LSETUP ( pcrel4 , lppcrel10 ) counters = pregs");
      saved_state.lt[c] = PCREG + pcrel4 (soffset);
      saved_state.lb[c] = PCREG + lppcrel10 (eoffset);
      saved_state.lc[c] = PREG (reg);
      PCREG += 4; return;
    }
  else if ((rop == 3))
    {
      notethat ("LSETUP ( pcrel4 , lppcrel10 ) counters = pregs >> 1");
      saved_state.lt[c] = PCREG + pcrel4 (soffset);
      saved_state.lb[c] = PCREG + lppcrel10 (eoffset);
      saved_state.lc[c] = PREG (reg) >> 1;
      PCREG += 4; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_LDIMMhalf_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* LDIMMhalf
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int H = ((iw0 >> 6) & 0x1);
  int grp = ((iw0 >> 3) & 0x3);
  int Z = ((iw0 >> 7) & 0x1);
  int S = ((iw0 >> 5) & 0x1);
  int hword = ((iw1 >> 0) & 0xffff);
  int reg = ((iw0 >> 0) & 0x7);

  if ((H == 0) && (S == 1) && (Z == 0))
    {
      int *pval = get_allreg (grp, reg);
      notethat ("regs = imm16 (x)");
      *pval = imm16 (hword);
    }
  else if ((H == 0) && (S == 0) && (Z == 1))
    {
      int *pval = get_allreg (grp, reg);
      notethat ("regs = luimm16 (Z)");
      *pval = luimm16 (hword);
    }
  else if ((H == 0) && (S == 0) && (Z == 0))
    {
      int *pval = get_allreg (grp, reg);
      notethat ("regs_lo = luimm16");
      *pval &= 0xFFFF0000;
      *pval |= luimm16 (hword);
    }
  else if ((H == 1) && (S == 0) && (Z == 0))
    {
      int *pval = get_allreg (grp, reg);
      notethat ("regs_hi = huimm16");
      *pval &= 0xFFFF;
      *pval |= luimm16 (hword) << 16;
    }
  else
    unhandled_instruction ();
  PCREG += 4; return;
}

static void
decode_CALLa_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* CALLa
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 1 |.S.|.msw...........................|
|.lsw...........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int S = ((iw0 >> 8) & 0x1);
  int lsw = ((iw1 >> 0) & 0xffff);
  int msw = ((iw0 >> 0) & 0xff);

  if ((S == 1))
    {
      notethat ("CALL  pcrel24");
      saved_state.rets = PCREG + 4;
    }
  else
    notethat ("JUMP.L  pcrel24");
  PCREG += pcrel24 (((msw) << 16) | (lsw));
}

static void
decode_LDSTidxI_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* LDSTidxI
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
     |.offset........................................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
  */
  int Z = ((iw0 >> 8) & 0x1);
  int sz = ((iw0 >> 6) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);
  int ptr = ((iw0 >> 3) & 0x7);
  int offset = ((iw1 >> 0) & 0xffff);
  int W = ((iw0 >> 9) & 0x1);

  if (sz == 3)
    unhandled_instruction ();

  if (W == 0)
    {
      if ((sz == 0) && (Z == 0))
	{
	  notethat ("dregs = [ pregs + imm16s4 ]");
	  DREG (reg) = get_long (saved_state.memory, PREG (ptr) + imm16s4 (offset));
	}
      else if ((sz == 0) && (Z == 1))
	{
	  notethat ("pregs = [ pregs + imm16s4 ]");
	  PREG (reg) = get_long (saved_state.memory, PREG (ptr) + imm16s4 (offset));
	}
      else if ((sz == 1) && (Z == 0))
	{
	  notethat ("dregs = W [ pregs + imm16s2 ] (Z)");
	  DREG (reg) = get_word (saved_state.memory, PREG (ptr) + imm16s2 (offset));
	}
      else if ((sz == 1) && (Z == 1))
	{
	  notethat ("dregs = W [ pregs + imm16s2 ] (X)");
	  DREG (reg) = (bs32) (bs16) get_word (saved_state.memory, PREG (ptr) + imm16s2 (offset));
	}
      else if ((sz == 2) && (Z == 0))
	{
	  notethat ("dregs = B [ pregs + imm16 ] (Z)");
	  DREG (reg) = get_byte (saved_state.memory, PREG (ptr) + imm16 (offset));
	}
      else if ((sz == 2) && (Z == 1))
	{
	  notethat ("dregs = B [ pregs + imm16 ] (X)");
	  DREG (reg) = (bs32) (bs8) get_byte (saved_state.memory, PREG (ptr) + imm16 (offset));
	}
    }
  else {
    if (sz != 0 && Z != 0)
      unhandled_instruction ();

    if ((sz == 0) && (Z == 0))
      {
	notethat ("[ pregs + imm16s4 ] = dregs");
	put_long (saved_state.memory, PREG (ptr) + imm16s4 (offset), DREG (reg));
      }
    else if ((sz == 0) && (Z == 1))
      {
	notethat ("[ pregs + imm16s4 ] = pregs");
	put_long (saved_state.memory, PREG (ptr) + imm16s4 (offset), PREG (reg));
      }
    else if ((sz == 1) && (Z == 0))
      {
	notethat ("W [ pregs + imm16s2 ] = dregs");
	put_word (saved_state.memory, PREG (ptr) + imm16s2 (offset), DREG (reg));
      }
    else if ((sz == 2) && (Z == 0))
      {
	notethat ("B [ pregs + imm16 ] = dregs");
	put_byte (saved_state.memory, PREG (ptr) + imm16 (offset), DREG (reg));
      }
  }
  PCREG += 4; return;
}

static void
decode_linkage_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* linkage
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.R.|
|.framesize.....................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int R = ((iw0 >> 0) & 0x1);
  int framesize = ((iw1 >> 0) & 0xffff);

  if ((R == 0))
    {
      bu32 sp = PREG (6);
      notethat ("LINK uimm16s4");
      sp -= 4;
      put_long (saved_state.memory, sp, saved_state.rets);
      sp -= 4;
      put_long (saved_state.memory, sp, PREG (7));
      PREG (7) = sp;
      sp -= uimm16s4 (framesize);
      PREG (6) = sp;
    }
  else
    {
      /* Restore SP from FP.  */
      bu32 sp = PREG (7);
      notethat ("UNLINK");
      PREG (7) = get_long (saved_state.memory, sp);
      sp += 4;
      saved_state.rets = get_long (saved_state.memory, sp);
      sp += 4;
      PREG (6) = sp;
    }
  PCREG += 4; return;
}

static void
decode_dsp32mac_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* dsp32mac
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int op1 = ((iw0 >> 0) & 0x3);
  int P = ((iw0 >> 3) & 0x1);
  int w0 = ((iw1 >> 13) & 0x1);
  int src0 = ((iw1 >> 3) & 0x7);
  int h00 = ((iw1 >> 10) & 0x1);
  int w1 = ((iw0 >> 2) & 0x1);
  int src1 = ((iw1 >> 0) & 0x7);
  int h10 = ((iw1 >> 9) & 0x1);
  int h01 = ((iw1 >> 15) & 0x1);
  int MM = ((iw0 >> 4) & 0x1);
  int h11 = ((iw1 >> 14) & 0x1);
  int dst = ((iw1 >> 6) & 0x7);
  int M = ((iw0 >> 11) & 0x1);
  int mmod = ((iw0 >> 5) & 0xf);
  int op0 = ((iw1 >> 11) & 0x3);

  if ((w0 == 0) && (w1 == 0) && (P == 0) && (op1 != 3) && (op0 != 3))
    {
      notethat ("A1macfunc mxd_mod , A0macfunc macmod_accm");
      A1macfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, " ");
      mxd_mod (MM, pc);
      OUTS (outf, ",");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, " ");
      macmod_accm (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 0) && (w1 == 0) && (P == 0) && (op1 != 3) && (op0 == 3))
    {
      notethat ("A1macfunc mxd_mod");
      A1macfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, " ");
      mxd_mod (MM, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 0) && (w1 == 0) && (P == 0) && (op1 == 3) && (op0 != 3))
    {
      notethat ("A0macfunc macmod_accm");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, " ");
      macmod_accm (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 0) && (w1 == 1) && (P == 0) && (op0 != 3) && (op1 != 3))
    {
      notethat ("dregs_hi = ( A1macfunc ) mxd_mod , A0macfunc macmod_hmove");
      OUTS (outf, dregs_hi (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A1macfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, ") ");
      mxd_mod (MM, pc);
      OUTS (outf, ",");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, " ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 0) && (P == 0) && (op0 != 3) && (op1 != 3))
    {
      notethat ("A1macfunc mxd_mod , dregs_lo = ( A0macfunc ) macmod_hmove");
      A1macfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, " ");
      mxd_mod (MM, pc);
      OUTS (outf, ", ");
      OUTS (outf, dregs_lo (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, ") ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 1) && (P == 0) && (op0 != 3) && (op1 != 3))
    {
      notethat
	("dregs_hi = ( A1macfunc) mxd_mod , dregs_lo = (A0macfunc ) macmod_hmove");
      OUTS (outf, dregs_hi (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A1macfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, ") ");
      mxd_mod (MM, pc);
      OUTS (outf, ", ");
      OUTS (outf, dregs_lo (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, ") ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 0) && (P == 0) && (op0 != 3) && (op1 == 3))
    {
      notethat ("dregs_lo = (A0macfunc ) macmod_hmove");
      OUTS (outf, dregs_lo (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, ") ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 0) && (w1 == 1) && (P == 1) && (op0 != 3) && (op1 != 3))
    {
      notethat ("dregs = ( A1macfunc ) mxd_mod , A0macfunc macmod_hmove");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A1macfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, ") ");
      mxd_mod (MM, pc);
      OUTS (outf, ",");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, " ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 0) && (P == 1) && (op0 != 3) && (op1 != 3))
    {
      notethat ("A1macfunc mxd_mod , dregs = ( A0macfunc ) macmod_hmove");
      A1macfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, " ");
      mxd_mod (MM, pc);
      OUTS (outf, ", ");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, ") ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 1) && (P == 0) && (op0 != 3) && (op1 == 3))
    {
      notethat ("dregs = ( A0macfunc ) macmod_hmove");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, ") ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 1) && (P == 1) && (op0 != 3) && (op1 != 3))
    {
      notethat
	("dregs = ( A1macfunc) mxd_mod , dregs = (A0macfunc ) macmod_hmove");
      OUTS (outf, dregs (dst + 1));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A1macfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, ") ");
      mxd_mod (MM, pc);
      OUTS (outf, ", ");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      A0macfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, ") ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_dsp32mult_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* dsp32mult
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int op1 = ((iw0 >> 0) & 0x3);
  int P = ((iw0 >> 3) & 0x1);
  int w0 = ((iw1 >> 13) & 0x1);
  int src0 = ((iw1 >> 3) & 0x7);
  int h00 = ((iw1 >> 10) & 0x1);
  int w1 = ((iw0 >> 2) & 0x1);
  int src1 = ((iw1 >> 0) & 0x7);
  int h10 = ((iw1 >> 9) & 0x1);
  int h01 = ((iw1 >> 15) & 0x1);
  int MM = ((iw0 >> 4) & 0x1);
  int h11 = ((iw1 >> 14) & 0x1);
  int dst = ((iw1 >> 6) & 0x7);
  int M = ((iw0 >> 11) & 0x1);
  int mmod = ((iw0 >> 5) & 0xf);
  int op0 = ((iw1 >> 11) & 0x3);



  if ((w0 == 0) && (w1 == 1) && (P == 0) && (MM == 0))
    {
      notethat ("dregs_hi = multfunc macmod_hmove");
      OUTS (outf, dregs_hi (dst));
      OUTS (outf, "=");
      multfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, " ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 0) && (P == 0) && (MM == 0))
    {
      notethat ("dregs_lo = multfunc macmod_hmove");
      OUTS (outf, dregs_lo (dst));
      OUTS (outf, "=");
      multfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, " ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 0) && (w1 == 1) && (P == 1) && (MM == 0))
    {
      notethat ("dregs (odd) =  multfunc macmod_hmove");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      multfunc (iw0, iw1, op1, h01, h11, pc);
      OUTS (outf, " ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 0) && (P == 1) && (MM == 0))
    {
      notethat ("dregs (even) =  multfunc macmod_hmove");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      multfunc (iw0, iw1, op0, h00, h10, pc);
      OUTS (outf, " ");
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 1) && (P == 0))
    {
      notethat
	("dregs_hi = multfunc mxd_mod , dregs_lo = multfunc macmod_hmove");
      OUTS (outf, dregs_hi (dst));
      OUTS (outf, "=");
      multfunc (iw0, iw1, op1, h01, h11, pc);
      mxd_mod (MM, pc);
      OUTS (outf, ", ");
      OUTS (outf, dregs_lo (dst));
      OUTS (outf, "= ");
      multfunc (iw0, iw1, op0, h00, h10, pc);
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else if ((w0 == 1) && (w1 == 1) && (P == 1))
    {
      notethat ("dregs = multfunc mxd_mod , dregs = multfunc macmod_hmove");
      OUTS (outf, dregs (1 + dst));
      OUTS (outf, "=");
      multfunc (iw0, iw1, op1, h01, h11, pc);
      mxd_mod (MM, pc);
      OUTS (outf, ", ");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      multfunc (iw0, iw1, op0, h00, h10, pc);
      macmod_hmove (mmod, pc);
      PCREG += 4; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_dsp32alu_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* dsp32alu
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int aop = ((iw1 >> 14) & 0x3);
  int s = ((iw1 >> 13) & 0x1);
  int HL = ((iw0 >> 5) & 0x1);
  int x = ((iw1 >> 12) & 0x1);
  int src0 = ((iw1 >> 3) & 0x7);
  int src1 = ((iw1 >> 0) & 0x7);
  int dst0 = ((iw1 >> 9) & 0x7);
  int aopcde = ((iw0 >> 0) & 0x1f);
  int dst1 = ((iw1 >> 6) & 0x7);
  int M = ((iw0 >> 11) & 0x1);



  if ((aop == 0) && (aopcde == 9) && (HL == 0) && (s == 0))
    {
      notethat ("A0.L = dregs_lo");
      OUTS (outf, "A0.L");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 9) && (HL == 1) && (s == 0))
    {
      notethat ("A1.H = dregs_hi");
      OUTS (outf, "A1.H");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 9) && (HL == 0) && (s == 0))
    {
      notethat ("A1.L = dregs_lo");
      OUTS (outf, "A1.L");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 9) && (HL == 1) && (s == 0))
    {
      notethat ("A0.H = dregs_hi");
      OUTS (outf, "A0.H");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      PCREG += 4; return;
    }
  else if ((x == 1) && (HL == 1) && (aop == 3) && (aopcde == 5))
    {
      notethat ("dregs_hi = dregs - dregs (RND20)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs (src1));
      OUTS (outf, "(");
      OUTS (outf, "RND20");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((x == 1) && (HL == 1) && (aop == 2) && (aopcde == 5))
    {
      notethat ("dregs_hi = dregs + dregs (RND20)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs (src1));
      OUTS (outf, "(");
      OUTS (outf, "RND20");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((x == 0) && (HL == 0) && (aop == 1) && (aopcde == 5))
    {
      notethat ("dregs_lo = dregs - dregs (RND12)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs (src1));
      OUTS (outf, "(");
      OUTS (outf, "RND12");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((x == 0) && (HL == 0) && (aop == 0) && (aopcde == 5))
    {
      notethat ("dregs_lo = dregs + dregs (RND12)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs (src1));
      OUTS (outf, "(");
      OUTS (outf, "RND12");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((x == 1) && (HL == 0) && (aop == 3) && (aopcde == 5))
    {
      notethat ("dregs_lo = dregs - dregs (RND20)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs (src1));
      OUTS (outf, "(");
      OUTS (outf, "RND20");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((x == 0) && (HL == 1) && (aop == 0) && (aopcde == 5))
    {
      notethat ("dregs_hi = dregs + dregs (RND12)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs (src1));
      OUTS (outf, "(");
      OUTS (outf, "RND12");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((x == 1) && (HL == 0) && (aop == 2) && (aopcde == 5))
    {
      notethat ("dregs_lo = dregs + dregs (RND20)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs (src1));
      OUTS (outf, "(");
      OUTS (outf, "RND20");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((x == 0) && (HL == 1) && (aop == 1) && (aopcde == 5))
    {
      notethat ("dregs_hi = dregs - dregs (RND12)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs (src1));
      OUTS (outf, "(");
      OUTS (outf, "RND12");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 0) && (aopcde == 2))
    {
      notethat ("dregs_hi = dregs_lo + dregs_lo amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 1) && (aopcde == 2))
    {
      notethat ("dregs_hi = dregs_lo + dregs_hi amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 2) && (aopcde == 2))
    {
      notethat ("dregs_hi = dregs_hi + dregs_lo amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 3) && (aopcde == 2))
    {
      notethat ("dregs_hi = dregs_hi + dregs_hi amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 0) && (aopcde == 3))
    {
      notethat ("dregs_lo = dregs_lo - dregs_lo amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 1) && (aopcde == 3))
    {
      notethat ("dregs_lo = dregs_lo - dregs_hi amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 3) && (aopcde == 2))
    {
      notethat ("dregs_lo = dregs_hi + dregs_hi amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 0) && (aopcde == 3))
    {
      notethat ("dregs_hi = dregs_lo - dregs_lo amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 1) && (aopcde == 3))
    {
      notethat ("dregs_hi = dregs_lo - dregs_hi amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 2) && (aopcde == 3))
    {
      notethat ("dregs_hi = dregs_hi - dregs_lo amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 3) && (aopcde == 3))
    {
      notethat ("dregs_hi = dregs_hi - dregs_hi amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 2) && (aopcde == 2))
    {
      notethat ("dregs_lo = dregs_hi + dregs_lo amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 1) && (aopcde == 2))
    {
      notethat ("dregs_lo = dregs_lo + dregs_hi amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 2) && (aopcde == 3))
    {
      notethat ("dregs_lo = dregs_hi - dregs_lo amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 3) && (aopcde == 3))
    {
      notethat ("dregs_lo = dregs_hi - dregs_hi amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 0) && (aopcde == 2))
    {
      notethat ("dregs_lo = dregs_lo + dregs_lo amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 9) && (s == 1))
    {
      notethat ("A0 = dregs");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      PCREG += 4; return;
    }
  else if ((aop == 3) && (aopcde == 11) && (s == 0))
    {
      notethat ("A0 -= A1");
      OUTS (outf, "A0");
      OUTS (outf, "-=");
      OUTS (outf, "A1");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (aopcde == 11) && (s == 1))
    {
      notethat ("A0 -= A1 (W32)");
      OUTS (outf, "A0");
      OUTS (outf, "-=");
      OUTS (outf, "A1");
      OUTS (outf, "(W32)");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (aopcde == 22) && (HL == 1))
    {
      notethat ("dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TH , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP2M");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "TH");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (aopcde == 22) && (HL == 0))
    {
      notethat ("dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TL , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP2M");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "TL");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 22) && (HL == 1))
    {
      notethat ("dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (RNDH , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP2M");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "RNDH");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 22) && (HL == 0))
    {
      notethat ("dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (RNDL , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP2M");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "RNDL");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 22) && (HL == 1))
    {
      notethat ("dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TH , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP2P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "TH");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 22) && (HL == 0))
    {
      notethat ("dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TL , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP2P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "TL");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 22) && (HL == 1))
    {
      notethat ("dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDH , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP2P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "RNDH");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 22) && (HL == 0))
    {
      notethat
	("dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDL , aligndir)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP2P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "RNDL");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (s == 0) && (aopcde == 8))
    {
      notethat ("A0 = 0");
      saved_state.a0 = 0;
      PCREG += 4; return;
    }
  else if ((aop == 0) && (s == 1) && (aopcde == 8))
    {
      notethat ("A0 = A0 (S)");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (s == 0) && (aopcde == 8))
    {
      notethat ("A1 = 0");
      saved_state.a1 = 0;
      PCREG += 4; return;
    }
  else if ((aop == 1) && (s == 1) && (aopcde == 8))
    {
      notethat ("A1 = A1 (S)");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((aop == 2) && (s == 0) && (aopcde == 8))
    {
      notethat ("A1 = A0 = 0");
      saved_state.a1 = saved_state.a0 = 0;
      PCREG += 4; return;
    }
  else if ((aop == 2) && (s == 1) && (aopcde == 8))
    {
      notethat ("A1 = A1 (S) , A0 = A0 (S)");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, "(S)");
      OUTS (outf, ",");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (s == 0) && (aopcde == 8))
    {
      notethat ("A0 = A1");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (s == 1) && (aopcde == 8))
    {
      notethat ("A1 = A0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 9) && (s == 0))
    {
      notethat ("A0.x = dregs_lo");
      OUTS (outf, "A0.x");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((aop == 1) && (HL == 0) && (aopcde == 11))
    {
      notethat ("dregs_lo = ( A0 += A1 )");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (HL == 0) && (aopcde == 16))
    {
      notethat ("A1 = ABS A1, A0 = ABS A0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A0");
      OUTS (outf, ",");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A0");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 23) && (HL == 1))
    {
      notethat ("dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (HI , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP3P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "HI");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (aopcde == 9) && (s == 0))
    {
      notethat ("A1.x = dregs_lo");
      OUTS (outf, "A1.x");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((aop == 1) && (HL == 1) && (aopcde == 16))
    {
      notethat ("A1 = ABS A1");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A1");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (HL == 1) && (aopcde == 16))
    {
      notethat ("A1 = ABS A0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A0");
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 9) && (s == 1))
    {
      notethat ("A1 = dregs");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aop == 3) && (aopcde == 12))
    {
      notethat ("dregs_lo = dregs (RND)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(RND)");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (HL == 0) && (aopcde == 16))
    {
      notethat ("A0 = ABS A1");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A1");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (HL == 0) && (aopcde == 16))
    {
      notethat ("A0 = ABS A0");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A0");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (HL == 0) && (aopcde == 15))
    {
      notethat ("dregs = - dregs (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(V)");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (HL == 1) && (aopcde == 11))
    {
      notethat ("dregs_hi = ( A0 += A1 )");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 11) && (s == 0))
    {
      notethat ("A0 += A1");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 11) && (s == 1))
    {
      notethat ("A0 += A1 (W32)");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      OUTS (outf, "(W32)");
      PCREG += 4; return;
    }
  else if ((aop == 3) && (HL == 0) && (aopcde == 14))
    {
      notethat ("A1 = - A1 , A0 = - A0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A1");
      OUTS (outf, ",");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A0");
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aop == 3) && (aopcde == 12))
    {
      notethat ("dregs_hi = dregs (RND)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(RND)");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 23) && (HL == 0))
    {
      notethat ("dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (LO , R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP3P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "LO");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (HL == 0) && (aopcde == 14))
    {
      notethat ("A0 = - A0");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A0");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (HL == 0) && (aopcde == 14))
    {
      notethat ("A0 = - A1");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A1");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (HL == 1) && (aopcde == 14))
    {
      notethat ("A1 = - A0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A0");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (HL == 1) && (aopcde == 14))
    {
      notethat ("A1 = - A1");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A1");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 12))
    {
      notethat
	("dregs_hi=dregs_lo=SIGN(dregs_hi)*dregs_hi + SIGN(dregs_lo)*dregs_lo)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGN");
      OUTS (outf, "(");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, ")");
      OUTS (outf, "*");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "+");
      OUTS (outf, "SIGN");
      OUTS (outf, "(");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      OUTS (outf, "*");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 0))
    {
      notethat ("dregs = dregs -|+ dregs amod0");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-|+");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod0 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 12))
    {
      notethat ("dregs = A1.L + A1.H , dregs = A0.L + A0.H");
      OUTS (outf, dregs (dst1));
      OUTS (outf, "=");
      OUTS (outf, "A1.L");
      OUTS (outf, "+");
      OUTS (outf, "A1.H");
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "A0.L");
      OUTS (outf, "+");
      OUTS (outf, "A0.H");
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 4))
    {
      notethat ("dregs = dregs + dregs , dregs = dregs - dregs amod1");
      OUTS (outf, dregs (dst1));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((HL == 0) && (aopcde == 1))
    {
      notethat
	("dregs = dregs +|+ dregs , dregs = dregs -|- dregs (amod0, amod2)");
      OUTS (outf, dregs (dst1));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+|+");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-|-");
      OUTS (outf, dregs (src1));
      if ((s == 1) && (x == 0) && (aop == 2))
	OUTS (outf, "(S, ASR)");
      else if ((s == 1) && (x == 0) && (aop == 3))
	OUTS (outf, "(S, ASL)");
      else if ((s == 0) && (x == 0) && (aop == 2))
	OUTS (outf, "(ASR)");
      else if ((s == 0) && (x == 0) && (aop == 3))
	OUTS (outf, "(ASL)");
      else
	OUTS (outf, "");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 11))
    {
      notethat ("dregs = ( A0 += A1 )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 10))
    {
      notethat ("dregs_lo = A0.x");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "A0.x");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 10))
    {
      notethat ("dregs_lo = A1.x");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "A1.x");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 0))
    {
      notethat ("dregs = dregs +|- dregs amod0");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+|-");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod0 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 3) && (aopcde == 0))
    {
      notethat ("dregs = dregs -|- dregs amod0");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-|-");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod0 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 4))
    {
      notethat ("dregs = dregs - dregs amod1");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 17))
    {
      notethat ("dregs = A1 + A0, dregs = A1 - A0 amod1");
      OUTS (outf, dregs (dst1));
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, "+");
      OUTS (outf, "A0");
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, "-");
      OUTS (outf, "A0");
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 17))
    {
      notethat ("dregs = A0 + A1, dregs = A0 - A1 amod1");
      OUTS (outf, dregs (dst1));
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "+");
      OUTS (outf, "A1");
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "-");
      OUTS (outf, "A1");
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 18))
    {
      notethat ("SAA ( dregs_pair , dregs_pair ) aligndir");
      OUTS (outf, "SAA");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ") ");
      aligndir (s, pc);
      PCREG += 4; return;
    }
  else if ((aop == 3) && (aopcde == 18))
    {
      notethat ("DISALGNEXCPT");
      OUTS (outf, "DISALGNEXCPT");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 20))
    {
      notethat ("dregs = BYTEOP1P ( dregs_pair , dregs_pair ) aligndir");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP1P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ") ");
      aligndir (s, pc);
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 20))
    {
      notethat ("dregs = BYTEOP1P ( dregs_pair , dregs_pair ) (T, R)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP1P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "T");
      if (s == 1)
	OUTS (outf, ", R)");
      else
	OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 21))
    {
      notethat
	("( dregs , dregs ) = BYTEOP16P ( dregs_pair , dregs_pair ) aligndir");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst1));
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, ")");
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP16P");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ") ");
      aligndir (s, pc);
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 21))
    {
      notethat
	("( dregs , dregs ) = BYTEOP16M ( dregs_pair , dregs_pair ) aligndir");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst1));
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, ")");
      OUTS (outf, "=");
      OUTS (outf, "BYTEOP16M");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src1 - 1));
      OUTS (outf, ") ");
      aligndir (s, pc);
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 7))
    {
      bu32 val = DREG (src0);
      notethat ("dregs = ABS dregs");
      if (val >> 31)
	val = -val;
      /* @@@ The manual is talking about saturation.  Check what the hardware
	 does when it gets 0x80000000.  */
      setflags_logical (val);
      DREG (dst0) = val;
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 7))
    {
      notethat ("dregs = MIN ( dregs , dregs )");
      DREG (dst0) = min32 (DREG (src0), DREG (src1));
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 7))
    {
      notethat ("dregs = MAX ( dregs , dregs )");
      DREG (dst0) = max32 (DREG (src0), DREG (src1));
      PCREG += 4; return;
    }
  else if ((aop == 2) && (aopcde == 6))
    {
      notethat ("dregs = ABS dregs (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(V)");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 6))
    {
      notethat ("dregs = MIN ( dregs , dregs ) (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "MIN");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ")(V)");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 6))
    {
      notethat ("dregs = MAX ( dregs , dregs ) (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "MAX");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ")(V)");
      PCREG += 4; return;
    }
  else if ((HL == 1) && (aopcde == 1))
    {
      notethat
	("dregs = dregs +|- dregs, dregs = dregs -|+ dregs (amod0, amod2)");
      OUTS (outf, dregs (dst1));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+|-");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-|+");
      OUTS (outf, dregs (src1));
      if ((s == 1) && (x == 0) && (aop == 2))
	OUTS (outf, "(S, ASR)");
      else if ((s == 1) && (x == 0) && (aop == 3))
	OUTS (outf, "(S, ASL)");
      else if ((s == 0) && (x == 0) && (aop == 2))
	OUTS (outf, "(ASR)");
      else if ((s == 0) && (x == 0) && (aop == 3))
	OUTS (outf, "(ASL)");
      else
	OUTS (outf, "");
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 4))
    {
      notethat ("dregs = dregs + dregs amod1");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod1 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 0))
    {
      notethat ("dregs = dregs +|+ dregs amod0");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+|+");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod0 (s, x, pc);
      PCREG += 4; return;
    }
  else if ((aop == 0) && (aopcde == 24))
    {
      notethat ("dregs = BYTEPACK ( dregs , dregs )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "BYTEPACK");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((aop == 1) && (aopcde == 24))
    {
      notethat ("( dregs , dregs ) = BYTEUNPACK dregs_pair aligndir");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst1));
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, ")");
      OUTS (outf, "=");
      OUTS (outf, "BYTEUNPACK");
      OUTS (outf, dregs (src0));
      OUTS (outf, ":");
      OUTS (outf, imm5 (src0 - 1));
      OUTS (outf, " ");
      aligndir (s, pc);
      PCREG += 4; return;
    }
  else if ((aopcde == 13))
    {
      notethat ("( dregs , dregs ) = SEARCH dregs (searchmod)");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst1));
      OUTS (outf, ",");
      OUTS (outf, dregs (dst0));
      OUTS (outf, ")");
      OUTS (outf, "=");
      OUTS (outf, "SEARCH");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(");
      searchmod (aop, pc);
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_dsp32shift_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* dsp32shift
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src0 = ((iw1 >> 3) & 0x7);
  int src1 = ((iw1 >> 0) & 0x7);
  int sop = ((iw1 >> 14) & 0x3);
  int dst0 = ((iw1 >> 9) & 0x7);
  int M = ((iw0 >> 11) & 0x1);
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);



  if ((HLs == 0) && (sop == 0) && (sopcde == 0))
    {
      notethat ("dregs_lo = ASHIFT dregs_lo BY dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((HLs == 1) && (sop == 0) && (sopcde == 0))
    {
      notethat ("dregs_lo = ASHIFT dregs_hi BY dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((HLs == 2) && (sop == 0) && (sopcde == 0))
    {
      notethat ("dregs_hi = ASHIFT dregs_lo BY dregs_lo");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((HLs == 3) && (sop == 0) && (sopcde == 0))
    {
      notethat ("dregs_hi = ASHIFT dregs_hi BY dregs_lo");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((HLs == 0) && (sop == 1) && (sopcde == 0))
    {
      notethat ("dregs_lo = ASHIFT dregs_lo BY dregs_lo (S)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(");
      OUTS (outf, "S");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((HLs == 1) && (sop == 1) && (sopcde == 0))
    {
      notethat ("dregs_lo = ASHIFT dregs_hi BY dregs_lo (S)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((HLs == 2) && (sop == 1) && (sopcde == 0))
    {
      notethat ("dregs_hi = ASHIFT dregs_lo BY dregs_lo (S)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((HLs == 3) && (sop == 1) && (sopcde == 0))
    {
      notethat ("dregs_hi = ASHIFT dregs_hi BY dregs_lo (S)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((HLs == 0) && (sop == 2) && (sopcde == 0))
    {
      notethat ("dregs_lo = LSHIFT dregs_lo BY dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((HLs == 1) && (sop == 2) && (sopcde == 0))
    {
      notethat ("dregs_lo = LSHIFT dregs_hi BY dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((HLs == 2) && (sop == 2) && (sopcde == 0))
    {
      notethat ("dregs_hi = LSHIFT dregs_lo BY dregs_lo");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((HLs == 3) && (sop == 2) && (sopcde == 0))
    {
      notethat ("dregs_hi = LSHIFT dregs_hi BY dregs_lo");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 3) && (HLs == 1))
    {
      notethat ("A1 = ROT A1 BY dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, "A1");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 3) && (HLs == 0))
    {
      notethat ("A0 = ASHIFT A0 BY dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, "A0");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 3) && (HLs == 1))
    {
      notethat ("A1 = ASHIFT A1 BY dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, "A1");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 3) && (HLs == 0))
    {
      notethat ("A0 = LSHIFT A0 BY dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, "A0");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 3) && (HLs == 1))
    {
      notethat ("A1 = LSHIFT A1 BY dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, "A1");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 3) && (HLs == 0))
    {
      notethat ("A0 = ROT A0 BY dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, "A0");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 1))
    {
      notethat ("dregs = ASHIFT dregs BY dregs_lo (V, S)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(");
      OUTS (outf, "V,S)");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 1))
    {
      notethat ("dregs = ASHIFT dregs BY dregs_lo (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(V)");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 2))
    {
      notethat ("dregs = ASHIFT dregs BY dregs_lo");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 2))
    {
      notethat ("dregs = ASHIFT dregs BY dregs_lo (S)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 2))
    {
      notethat ("dregs = SHIFT dregs BY dregs_lo");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 3) && (sopcde == 2))
    {
      notethat ("dregs = ROT dregs BY dregs_lo");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 1))
    {
      notethat ("dregs = SHIFT dregs BY dregs_lo (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(V)");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 4))
    {
      notethat ("dregs = PACK ( dregs_lo , dregs_lo )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "PACK");
      OUTS (outf, "(");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 4))
    {
      notethat ("dregs = PACK ( dregs_lo , dregs_hi )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "PACK");
      OUTS (outf, "(");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 4))
    {
      notethat ("dregs = PACK ( dregs_hi , dregs_lo )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "PACK");
      OUTS (outf, "(");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 3) && (sopcde == 4))
    {
      notethat ("dregs = PACK ( dregs_hi , dregs_hi )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "PACK");
      OUTS (outf, "(");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 5))
    {
      notethat ("dregs_lo = SIGNBITS dregs");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, dregs (src1));
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 5))
    {
      notethat ("dregs_lo = SIGNBITS dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, dregs_lo (src1));
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 5))
    {
      notethat ("dregs_lo = SIGNBITS dregs_hi");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, dregs_hi (src1));
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 6))
    {
      notethat ("dregs_lo = SIGNBITS A0");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, "A0");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 6))
    {
      notethat ("dregs_lo = SIGNBITS A1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, "A1");
      PCREG += 4; return;
    }
  else if ((sop == 3) && (sopcde == 6))
    {
      notethat ("dregs_lo = ONES dregs");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ONES");
      OUTS (outf, dregs (src1));
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 7))
    {
      notethat ("dregs_lo = EXPADJ (dregs , dregs_lo)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXPADJ (");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 7))
    {
      notethat ("dregs_lo = EXPADJ (dregs , dregs_lo) (V)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXPADJ (");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ") (V)");
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 7))
    {
      notethat ("dregs_lo = EXPADJ (dregs_lo , dregs_lo)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXPADJ (");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 3) && (sopcde == 7))
    {
      notethat ("dregs_lo = EXPADJ (dregs_hi , dregs_lo)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXPADJ (");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 8))
    {
      notethat ("BITMUX (dregs , dregs , A0) (ASR)");
      OUTS (outf, "BITMUX (");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, "A0 )");
      OUTS (outf, "(ASR)");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 8))
    {
      notethat ("BITMUX (dregs , dregs , A0) (ASL)");
      OUTS (outf, "BITMUX (");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, "A0 )");
      OUTS (outf, "(ASL)");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 9))
    {
      notethat ("dregs_lo = VIT_MAX (dregs) (ASL)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "VIT_MAX (");
      OUTS (outf, dregs (src1));
      OUTS (outf, ") (ASL)");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 9))
    {
      notethat ("dregs_lo = VIT_MAX (dregs) (ASR)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "VIT_MAX (");
      OUTS (outf, dregs (src1));
      OUTS (outf, ") (ASR)");
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 9))
    {
      notethat ("dregs = VIT_MAX ( dregs , dregs ) (ASL)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "VIT_MAX");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "ASL");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 3) && (sopcde == 9))
    {
      notethat ("dregs = VIT_MAX ( dregs , dregs ) (ASR)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "VIT_MAX");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      OUTS (outf, "(");
      OUTS (outf, "ASR");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 10))
    {
      notethat ("dregs = EXTRACT ( dregs , dregs_lo ) (Z)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXTRACT");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ") (Z)");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 10))
    {
      notethat ("dregs = EXTRACT ( dregs , dregs_lo ) (X)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXTRACT");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      OUTS (outf, "(X)");
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 10))
    {
      notethat ("dregs = DEPOSIT ( dregs , dregs )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "DEPOSIT");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 3) && (sopcde == 10))
    {
      notethat ("dregs = DEPOSIT ( dregs , dregs ) (X)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "DEPOSIT");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      OUTS (outf, "(X)");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 11))
    {
      notethat ("dregs_lo = CC = BXORSHIFT ( A0 , dregs )");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, "BXORSHIFT");
      OUTS (outf, "(");
      OUTS (outf, "A0");
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 11))
    {
      notethat ("dregs_lo = CC = BXOR (A0 , dregs)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, "BXOR");
      OUTS (outf, "(A0");
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 12))
    {
      notethat ("A0 = BXORSHIFT ( A0 , A1 , CC )");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "BXORSHIFT");
      OUTS (outf, "(");
      OUTS (outf, "A0");
      OUTS (outf, ",");
      OUTS (outf, "A1 ,");
      OUTS (outf, "CC");
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 12))
    {
      notethat ("dregs_lo = CC = BXOR (A0 , A1 , CC)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, "BXOR");
      OUTS (outf, "( A0");
      OUTS (outf, ",");
      OUTS (outf, "A1 ,");
      OUTS (outf, "CC )");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 13))
    {
      notethat ("dregs = ALIGN8 ( dregs , dregs )");
      DREG (dst0) = (DREG (src1) << 24) | (DREG (src0) >> 8);
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 13))
    {
      notethat ("dregs = ALIGN16 ( dregs , dregs )");
      DREG (dst0) = (DREG (src1) << 16) | (DREG (src0) >> 16);
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 13))
    {
      notethat ("dregs = ALIGN24 ( dregs , dregs )");
      DREG (dst0) = (DREG (src1) << 8) | (DREG (src0) >> 24);
      PCREG += 4; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_dsp32shiftimm_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* dsp32shiftimm
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src1 = ((iw1 >> 0) & 0x7);
  int sop = ((iw1 >> 14) & 0x3);
  int immag = ((iw1 >> 3) & 0x3f);
  int newimmag = (-(iw1 >> 3) & 0x3f);
  int dst0 = ((iw1 >> 9) & 0x7);
  int M = ((iw0 >> 11) & 0x1);
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);



  if ((HLs == 0) && (sop == 0) && (sopcde == 0))
    {
      notethat ("dregs_lo = dregs_lo << uimm5");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "<<");
      OUTS (outf, uimm5 (immag));
      PCREG += 4; return;
    }
  else if ((HLs == 1) && (sop == 0) && (sopcde == 0))
    {
      notethat ("dregs_lo = dregs_hi << uimm5");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "<<");
      OUTS (outf, uimm5 (immag));
      PCREG += 4; return;
    }
  else if ((HLs == 2) && (sop == 0) && (sopcde == 0))
    {
      notethat ("dregs_hi = dregs_lo << uimm5");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "<<");
      OUTS (outf, uimm5 (immag));
      PCREG += 4; return;
    }
  else if ((HLs == 3) && (sop == 0) && (sopcde == 0))
    {
      notethat ("dregs_hi = dregs_hi << uimm5");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "<<");
      OUTS (outf, uimm5 (immag));
      PCREG += 4; return;
    }
  else if ((HLs == 0) && (sop == 1) && (sopcde == 0))
    {
      notethat ("dregs_lo = dregs_lo << imm5 (S)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((HLs == 1) && (sop == 1) && (sopcde == 0))
    {
      notethat ("dregs_lo = dregs_hi << imm5 (S)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((HLs == 2) && (sop == 1) && (sopcde == 0))
    {
      notethat ("dregs_hi = dregs_lo << imm5 (S)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((HLs == 3) && (sop == 1) && (sopcde == 0))
    {
      notethat ("dregs_hi = dregs_hi << imm5 (S)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, "(S)");
      PCREG += 4; return;
    }
  else if ((HLs == 0) && (sop == 2) && (sopcde == 0))
    {
      notethat ("dregs_lo = dregs_lo >> uimm5");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ">>");
      OUTS (outf, uimm5 (newimmag));
      PCREG += 4; return;
    }
  else if ((HLs == 1) && (sop == 2) && (sopcde == 0))
    {
      notethat ("dregs_lo = dregs_hi >> uimm5");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, ">>");
      OUTS (outf, uimm5 (newimmag));
      PCREG += 4; return;
    }
  else if ((HLs == 2) && (sop == 2) && (sopcde == 0))
    {
      notethat ("dregs_hi = dregs_lo >> uimm5");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ">>");
      OUTS (outf, uimm5 (newimmag));
      PCREG += 4; return;
    }
  else if ((HLs == 3) && (sop == 2) && (sopcde == 0))
    {
      notethat ("dregs_hi = dregs_hi >> uimm5");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, ">>");
      OUTS (outf, uimm5 (newimmag));
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 3) && (HLs == 1))
    {
      notethat ("A1 = ROT A1 BY imm6");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, "A1");
      OUTS (outf, "BY");
      OUTS (outf, imm6 (immag));
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 3) && (HLs == 0))
    {
      notethat ("A0 = A0 << imm6");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "<<");
      OUTS (outf, imm6 (immag));
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 3) && (HLs == 1))
    {
      notethat ("A1 = A1 << imm6");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, "<<");
      OUTS (outf, imm6 (immag));
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 3) && (HLs == 0))
    {
      notethat ("A0 = A0 >> imm6");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, ">>");
      OUTS (outf, imm6 (newimmag));
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 3) && (HLs == 1))
    {
      notethat ("A1 = A1 >> imm6");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, ">>");
      OUTS (outf, imm6 (newimmag));
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 3) && (HLs == 0))
    {
      notethat ("A0 = ROT A0 BY imm6");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, "A0");
      OUTS (outf, "BY");
      OUTS (outf, imm6 (immag));
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 1))
    {
      notethat ("dregs = dregs >>> uimm5 (V, S)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, " >>> ");
      OUTS (outf, imm5 (-immag));
      OUTS (outf, " (V, ");
      OUTS (outf, "S)");
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 1))
    {
      notethat ("dregs = dregs >> uimm5 (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, " >> ");
      OUTS (outf, uimm5 (newimmag));
      OUTS (outf, " (V)");
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 1))
    {
      notethat ("dregs = dregs << imm5 (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, " (V)");
      PCREG += 4; return;
    }
  else if ((sop == 1) && (sopcde == 2))
    {
      notethat ("dregs = dregs << imm6 (S)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, "<<");
      OUTS (outf, imm6 (immag));
      OUTS (outf, "(");
      OUTS (outf, "S)");
      PCREG += 4; return;
    }
  else if ((sop == 2) && (sopcde == 2))
    {
      int count = imm6 (newimmag);
      notethat ("dregs = dregs >> imm6");
      if (count < 0)
	DREG (dst0) = lshift (DREG (src1), -count);
      else
	DREG (dst0) = lshiftrt (DREG (src1), count);
      PCREG += 4; return;
    }
  else if ((sop == 3) && (sopcde == 2))
    {
      notethat ("dregs = ROT dregs BY imm6");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, imm6 (immag));
      PCREG += 4; return;
    }
  else if ((sop == 0) && (sopcde == 2))
    {
      int count = imm6 (newimmag);
      notethat ("dregs = dregs >>> imm6");
      if (count < 0)
	DREG (dst0) = lshift (DREG (src1), -count);
      else
	DREG (dst0) = ashiftrt (DREG (src1), count);
      PCREG += 4; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_psedoDEBUG_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* psedoDEBUG
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int grp = ((iw0 >> 3) & 0x7);
  int fn = ((iw0 >> 6) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);



  if ((reg == 0) && (fn == 3))
    {
      notethat ("DBG A0");
      OUTS (outf, "DBG");
      OUTS (outf, "A0");
      PCREG += 2; return;
    }
  else if ((reg == 1) && (fn == 3))
    {
      notethat ("DBG A1");
      OUTS (outf, "DBG");
      OUTS (outf, "A1");
      PCREG += 2; return;
    }
  else if ((reg == 3) && (fn == 3))
    {
      notethat ("ABORT");
      OUTS (outf, "ABORT");
      PCREG += 2; return;
    }
  else if ((reg == 4) && (fn == 3))
    {
      notethat ("HLT");
      OUTS (outf, "HLT");
      PCREG += 2; return;
    }
  else if ((reg == 5) && (fn == 3))
    {
      notethat ("DBGHALT");
      OUTS (outf, "DBGHALT");
      PCREG += 2; return;
    }
  else if ((reg == 6) && (fn == 3))
    {
      notethat ("DBGCMPLX ( dregs )");
      OUTS (outf, "DBGCMPLX");
      OUTS (outf, "(");
      OUTS (outf, dregs (grp));
      OUTS (outf, ")");
      PCREG += 2; return;
    }
  else if ((reg == 7) && (fn == 3))
    {
      notethat ("DBG");
      OUTS (outf, "DBG");
      PCREG += 2; return;
    }
  else if ((grp == 0) && (fn == 2))
    {
      notethat ("OUTC dregs");
      OUTS (outf, "OUTC");
      OUTS (outf, dregs (reg));
      PCREG += 2; return;
    }
  else if ((fn == 0))
    {
      notethat ("DBG allregs");
      OUTS (outf, "DBG");
      OUTS (outf, allregs (reg, grp));
      PCREG += 2; return;
    }
  else if ((fn == 1))
    {
      notethat ("PRNT allregs");
      OUTS (outf, "PRNT");
      OUTS (outf, allregs (reg, grp));
      PCREG += 2; return;
    }
  else
    unhandled_instruction ();
}

static void
decode_psedoOChar_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* psedoOChar
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 |.ch............................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int ch = ((iw0 >> 0) & 0xff);



  notethat ("OUTC uimm8");
  OUTS (outf, "OUTC");
  OUTS (outf, uimm8 (ch));
  PCREG += 2; return;
}

static void
decode_psedodbg_assert_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
/* psedodbg_assert
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 0 | - | - | - | - | - |.dbgop.....|.regtest...|
|.expected......................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int expected = ((iw1 >> 0) & 0xffff);
  int dbgop = ((iw0 >> 3) & 0x7);
  int regtest = ((iw0 >> 0) & 0x7);

  if ((dbgop == 0))
    {
      notethat ("DBGA ( dregs_lo , uimm16 )");
      OUTS (outf, "DBGA");
      OUTS (outf, "(");
      OUTS (outf, dregs_lo (regtest));
      OUTS (outf, ",");
      OUTS (outf, uimm16 (expected));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((dbgop == 1))
    {
      notethat ("DBGA ( dregs_hi , uimm16 )");
      OUTS (outf, "DBGA");
      OUTS (outf, "(");
      OUTS (outf, dregs_hi (regtest));
      OUTS (outf, ",");
      OUTS (outf, uimm16 (expected));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((dbgop == 2))
    {
      notethat ("DBGAL ( dregs , uimm16 )");
      OUTS (outf, "DBGAL");
      OUTS (outf, "(");
      OUTS (outf, dregs (regtest));
      OUTS (outf, ",");
      OUTS (outf, uimm16 (expected));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else if ((dbgop == 3))
    {
      notethat ("DBGAH ( dregs , uimm16 )");
      OUTS (outf, "DBGAH");
      OUTS (outf, "(");
      OUTS (outf, dregs (regtest));
      OUTS (outf, ",");
      OUTS (outf, uimm16 (expected));
      OUTS (outf, ")");
      PCREG += 4; return;
    }
  else
    unhandled_instruction ();
}

int
_print_insn_bfin (bu32 pc)
{
  bu8 buf[4];
  bu16 iw0 = get_word (saved_state.memory, pc);
  bu16 iw1 = get_word (saved_state.memory, pc + 2);

  if ((iw0 & 0xFF00) == 0x0000)
    decode_ProgCtrl_0 (iw0, iw1, pc);
  else if ((iw0 & 0xFFC0) == 0x0240)
    decode_CaCTRL_0 (iw0, iw1, pc);
  else if ((iw0 & 0xFF80) == 0x0100)
    decode_PushPopReg_0 (iw0, iw1, pc);
  else if ((iw0 & 0xFE00) == 0x0400)
    decode_PushPopMultiple_0 (iw0, iw1, pc);
  else if ((iw0 & 0xFE00) == 0x0600)
    decode_ccMV_0 (iw0, iw1, pc);
  else if ((iw0 & 0xF800) == 0x0800)
    decode_CCflag_0 (iw0, iw1, pc);
  else if ((iw0 & 0xFFE0) == 0x0200)
    decode_CC2dreg_0 (iw0, iw1, pc);
  else if ((iw0 & 0xFF00) == 0x0300)
    decode_CC2stat_0 (iw0, iw1, pc);
  else if ((iw0 & 0xF000) == 0x1000)
    decode_BRCC_0 (iw0, iw1, pc);
  else if ((iw0 & 0xF000) == 0x2000)
    decode_UJUMP_0 (iw0, iw1, pc);
  else if ((iw0 & 0xF000) == 0x3000)
    decode_REGMV_0 (iw0, iw1, pc);
  else if ((iw0 & 0xFC00) == 0x4000)
    decode_ALU2op_0 (iw0, iw1, pc);
  else if ((iw0 & 0xFE00) == 0x4400)
    decode_PTR2op_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF800) == 0x4800))
    decode_LOGI2op_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF000) == 0x5000))
    decode_COMP3op_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF800) == 0x6000))
    decode_COMPI2opD_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF800) == 0x6800))
    decode_COMPI2opP_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF000) == 0x8000))
    decode_LDSTpmod_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFF60) == 0x9E60))
    decode_dagMODim_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFFF0) == 0x9F60))
    decode_dagMODik_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFC00) == 0x9C00))
    decode_dspLDST_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF000) == 0x9000))
    decode_LDST_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFC00) == 0xB800))
    decode_LDSTiiFP_0 (iw0, iw1, pc);
  else if (((iw0 & 0xE000) == 0xA000))
    decode_LDSTii_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFF80) == 0xE080) && ((iw1 & 0x0C00) == 0x0000))
    decode_LoopSetup_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFF00) == 0xE100) && ((iw1 & 0x0000) == 0x0000))
    decode_LDIMMhalf_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFE00) == 0xE200) && ((iw1 & 0x0000) == 0x0000))
    decode_CALLa_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFC00) == 0xE400) && ((iw1 & 0x0000) == 0x0000))
    decode_LDSTidxI_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFFFE) == 0xE800) && ((iw1 & 0x0000) == 0x0000))
    decode_linkage_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF600) == 0xC000) && ((iw1 & 0x0000) == 0x0000))
    decode_dsp32mac_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF600) == 0xC200) && ((iw1 & 0x0000) == 0x0000))
    decode_dsp32mult_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF7C0) == 0xC400) && ((iw1 & 0x0000) == 0x0000))
    decode_dsp32alu_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF7E0) == 0xC600) && ((iw1 & 0x01C0) == 0x0000))
    decode_dsp32shift_0 (iw0, iw1, pc);
  else if (((iw0 & 0xF7E0) == 0xC680) && ((iw1 & 0x0000) == 0x0000))
    decode_dsp32shiftimm_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFF00) == 0xF800))
    decode_psedoDEBUG_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFF00) == 0xF900))
    decode_psedoOChar_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFFC0) == 0xF000) && ((iw1 & 0x0000) == 0x0000))

    decode_psedodbg_assert_0 (iw0, iw1, pc);
  else
    unhandled_instruction ();
}
