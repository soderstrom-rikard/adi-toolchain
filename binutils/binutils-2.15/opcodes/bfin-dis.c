/* 
 *   Copyright (c) 2000, 2001 Analog Devices Inc.
 *   Copyright (c) 2003 Metrowerks
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "bfin-opcodes.h"

#ifndef PRINTF
#define PRINTF printf
#endif

#ifndef EXIT
#define EXIT exit
#endif

typedef long TIword;

#define HOST_LONG_WORD_SIZE (sizeof(long)*8)

#define XFIELD(w,p,s) (((w)&((1<<(s))-1)<<(p))>>(p))

#define SIGNEXTEND(v, n) ((v << (HOST_LONG_WORD_SIZE - (n))) >> (HOST_LONG_WORD_SIZE - (n)))
#define MASKBITS(val, bits) (val & (( 1 << bits)-1))

#if 0				/* commented out as it not currently using */
static int
xfield (TIword w, int p, int s)
{
  return XFIELD (w, p, s);
}
#endif

#include "dis-asm.h"
typedef enum
{
  c_0, c_1, c_4, c_2, c_uimm2, c_uimm3, c_imm3, c_pcrel4,
  c_imm4, c_uimm4s4, c_uimm4, c_uimm4s2, c_negimm5s4, c_imm5, c_uimm5, c_imm6,
  c_imm7, c_imm8, c_uimm8, c_pcrel8, c_uimm8s4, c_pcrel8s4, c_lppcrel10, c_pcrel10,
  c_pcrel12, c_imm16s4, c_luimm16, c_imm16, c_huimm16, c_rimm16, c_imm16s2, c_uimm16s4,
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
  { "pcrel24", 24, 1, 1, 1, 1, 0, 0, 0}
};

int _print_insn_bfin (bfd_vma pc, disassemble_info * outf);
int print_insn_bfin (bfd_vma pc, disassemble_info * outf);

static char *
fmtconst (const_forms_t cf, TIword x, bfd_vma pc, disassemble_info * outf)
{
  static char buf[60];

  if (constant_formats[cf].reloc)
    {
      bfd_vma ea = (((constant_formats[cf].pcrel ? SIGNEXTEND (x, constant_formats[cf].nbits)
		      : x) + constant_formats[cf].offset) << constant_formats[cf].scale);
      if (constant_formats[cf].pcrel)
	ea += pc;

      outf->print_address_func (ea, outf);
      return "";
    }

  /* negative constants have an implied sign bit */
  if (constant_formats[cf].negative)
    {
      int nb = constant_formats[cf].nbits + 1;
      x = x | (1 << constant_formats[cf].nbits);
      x = SIGNEXTEND (x, nb);
    }
  else
    x = constant_formats[cf].issigned ? SIGNEXTEND (x, constant_formats[cf].nbits) : x;

  if (constant_formats[cf].offset)
    x += constant_formats[cf].offset;

  if (constant_formats[cf].scale)
    x <<= constant_formats[cf].scale;

  if (constant_formats[cf].issigned && x < 0)
    sprintf (buf, "%ld", x);
  else
    sprintf (buf, "0x%lx", x);

  return buf;
}

#undef SIGNEXTEND
#undef MASKBITS
#undef HOST_LONG_WORD_SIZE
#define HOST_LONG_WORD_SIZE (sizeof(long)*8)
#define SIGNEXTEND(v, n) (((long)(v) << (HOST_LONG_WORD_SIZE - (n))) >> (HOST_LONG_WORD_SIZE - (n)))
#define MASKBITS(val, bits) (val & (( 1 << bits)-1))

enum machine_registers
{
  REG_RL0, REG_RL1, REG_RL2, REG_RL3, REG_RL4, REG_RL5, REG_RL6, REG_RL7,
  REG_RH0, REG_RH1, REG_RH2, REG_RH3, REG_RH4, REG_RH5, REG_RH6, REG_RH7,
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_R1_0, REG_R3_2, REG_R5_4, REG_R7_6, REG_P0, REG_P1, REG_P2, REG_P3,
  REG_P4, REG_P5, REG_SP, REG_FP, REG_A0x, REG_A1x, REG_A0w, REG_A1w,
  REG_A0, REG_A1, REG_I0, REG_I1, REG_I2, REG_I3, REG_M0, REG_M1,
  REG_M2, REG_M3, REG_B0, REG_B1, REG_B2, REG_B3, REG_L0, REG_L1,
  REG_L2, REG_L3,
  REG_AZ, REG_AN, REG_AC0, REG_AC1, REG_AV0, REG_AV1, REG_AV0S, REG_AV1S,
  REG_AQ, REG_V, REG_VS,
  REG_sftreset, REG_omode, REG_excause, REG_emucause, REG_idle_req, REG_hwerrcause, REG_CC, REG_LC0,
  REG_LC1, REG_GP, REG_ASTAT, REG_RETS, REG_LT0, REG_LB0, REG_LT1, REG_LB1,
  REG_CYCLES, REG_CYCLES2, REG_USP, REG_SEQSTAT, REG_SYSCFG, REG_RETI, REG_RETX, REG_RETN,
  REG_RETE, REG_BR0, REG_BR1, REG_BR2, REG_BR3, REG_BR4, REG_BR5, REG_BR6,
  REG_BR7, REG_PL0, REG_PL1, REG_PL2, REG_PL3, REG_PL4, REG_PL5, REG_SLP, REG_FLP,
  REG_PH0, REG_PH1, REG_PH2, REG_PH3, REG_PH4, REG_PH5, REG_SHP, REG_FHP,
  REG_IL0, REG_IL1, REG_IL2, REG_IL3, REG_ML0, REG_ML1, REG_ML2, REG_ML3,
  REG_BL0, REG_BL1, REG_BL2, REG_BL3, REG_LL0, REG_LL1, REG_LL2, REG_LL3,
  REG_IH0, REG_IH1, REG_IH2, REG_IH3, REG_MH0, REG_MH1, REG_MH2, REG_MH3,
  REG_BH0, REG_BH1, REG_BH2, REG_BH3, REG_LH0, REG_LH1, REG_LH2, REG_LH3,
  REG_LASTREG,
};

enum reg_class
{
  rc_dregs_lo, rc_dregs_hi, rc_dregs, rc_dregs_pair, rc_pregs, rc_spfp, rc_dregs_hilo, rc_accum_ext,
  rc_accum_word, rc_accum, rc_iregs, rc_mregs, rc_bregs, rc_lregs, rc_dpregs, rc_gregs,
  rc_regs, rc_statbits, rc_ignore_bits, rc_ccstat, rc_counters, rc_dregs2_sysregs1, rc_open, rc_sysregs2,
  rc_sysregs3, rc_allregs,
  LIM_REG_CLASSES
};

static char *reg_names[] =
{
  "R0.L", "R1.L", "R2.L", "R3.L", "R4.L", "R5.L", "R6.L", "R7.L",
  "R0.H", "R1.H", "R2.H", "R3.H", "R4.H", "R5.H", "R6.H", "R7.H",
  "R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7",
  "R1:0", "R3:2", "R5:4", "R7:6", "P0", "P1", "P2", "P3",
  "P4", "P5", "SP", "FP", "A0.x", "A1.x", "A0.w", "A1.w",
  "A0", "A1", "I0", "I1", "I2", "I3", "M0", "M1",
  "M2", "M3", "B0", "B1", "B2", "B3", "L0", "L1",
  "L2", "L3",
  "AZ", "AN", "AC0", "AC1", "AV0", "AV1", "AV0S", "AV1S",
  "AQ", "V", "VS",
  "sftreset", "omode", "excause", "emucause", "idle_req", "hwerrcause", "CC", "LC0",
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

#define dregs_lo(x) REGNAME(decode_dregs_lo[(x) & 7])

/* RH(0..7)  */
static enum machine_registers decode_dregs_hi[] =
{
  REG_RH0, REG_RH1, REG_RH2, REG_RH3, REG_RH4, REG_RH5, REG_RH6, REG_RH7,
};

#define dregs_hi(x) REGNAME(decode_dregs_hi[(x) & 7])

/* R(0..7)  */
static enum machine_registers decode_dregs[] =
{
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
};

#define dregs(x) REGNAME(decode_dregs[(x) & 7])

/* R BYTE(0..7)  */
static enum machine_registers decode_dregs_byte[] =
{
  REG_BR0, REG_BR1, REG_BR2, REG_BR3, REG_BR4, REG_BR5, REG_BR6, REG_BR7,
};

#define dregs_byte(x) REGNAME(decode_dregs_byte[(x) & 7])

#if 0				/* commented it currently as not used currently */

/* R1:0 - R3:2 - R5:4 - R7:6 -  */
static enum machine_registers decode_dregs_pair[] =
{
  REG_R1_0, REG_LASTREG, REG_R3_2, REG_LASTREG, REG_R5_4, REG_LASTREG, REG_R7_6, REG_LASTREG,
};
#endif

#define dregs_pair(x) REGNAME(decode_dregs_pair[(x) & 7])

/* P(0..5) SP FP  */
static enum machine_registers decode_pregs[] =
{
  REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
};

#define pregs(x) REGNAME(decode_pregs[(x) & 7])


#if 0				/* commented it currently as not used currently */
/* SP FP  */
static enum machine_registers decode_spfp[] =
{
  REG_SP, REG_FP,
};
#endif

#define spfp(x) REGNAME(decode_spfp[(x) & 1])

#if 0				/* commented it currently as not used currently */
/* [dregs_lo dregs_hi]  */
static enum machine_registers decode_dregs_hilo[] =
{
  REG_RL0, REG_RL1, REG_RL2, REG_RL3, REG_RL4, REG_RL5, REG_RL6, REG_RL7,
  REG_RH0, REG_RH1, REG_RH2, REG_RH3, REG_RH4, REG_RH5, REG_RH6, REG_RH7,
};
#endif

#define dregs_hilo(x,i) REGNAME(decode_dregs_hilo[((i)<<3)|x])

#if 0				/* commented it currently as not used currently */
/* A0x A1x  */
static enum machine_registers decode_accum_ext[] =
{
  REG_A0x, REG_A1x,
};
#endif

#define accum_ext(x) REGNAME(decode_accum_ext[(x) & 1])

#if 0				/* commented it currently as not used currently */
/* A0w A1w  */
static enum machine_registers decode_accum_word[] =
{
  REG_A0w, REG_A1w,
};
#endif

#define accum_word(x) REGNAME(decode_accum_word[(x) & 1])

#if 0				/* commented it currently as not used currently */
/* A0 A1  */
static enum machine_registers decode_accum[] =
{
  REG_A0, REG_A1,
};
#endif

#define accum(x) REGNAME(decode_accum[(x) & 1])

/* I(0..3)   */
static enum machine_registers decode_iregs[] =
{
  REG_I0, REG_I1, REG_I2, REG_I3,
};

#define iregs(x) REGNAME(decode_iregs[(x) & 3])

/* M(0..3)   */
static enum machine_registers decode_mregs[] =
{
  REG_M0, REG_M1, REG_M2, REG_M3,
};

#define mregs(x) REGNAME(decode_mregs[(x) & 3])

#if 0				/* commented it currently as not used currently */
/* B(0..3)  */
static enum machine_registers decode_bregs[] =
{
  REG_B0, REG_B1, REG_B2, REG_B3,
};
#endif

#define bregs(x) REGNAME(decode_bregs[(x) & 3])

#if 0				/* commented it currently as not used currently */
/* L(0..3)  */
static enum machine_registers decode_lregs[] =
{
  REG_L0, REG_L1, REG_L2, REG_L3,
};
#endif

#define lregs(x) REGNAME(decode_lregs[(x) & 3])

/* dregs pregs  */
static enum machine_registers decode_dpregs[] =
{
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
};

#define dpregs(x) REGNAME(decode_dpregs[(x) & 15])

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

static enum machine_registers decode_statbits[] =
{
  REG_AZ, REG_AN, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_AQ, REG_LASTREG,
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_AC0, REG_AC1, REG_LASTREG, REG_LASTREG,
  REG_AV0, REG_AV0S, REG_AV1, REG_AV1S, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
  REG_V, REG_VS, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
};

#define statbits(x) REGNAME(decode_statbits[(x) & 31])

#if 0				/* commented it currently as not used currently */
/* sftreset omode excause emucause idle_req hwerrcause */
static enum machine_registers decode_ignore_bits[] =
{
  REG_sftreset, REG_omode, REG_excause, REG_emucause, REG_idle_req, REG_hwerrcause,
};
#endif

#define ignore_bits(x) REGNAME(decode_ignore_bits[(x) & 7])

#if 0				/* commented it currently as not used currently */
/* CC  */
static enum machine_registers decode_ccstat[] =
{
  REG_CC,
};
#endif

#define ccstat(x) REGNAME(decode_ccstat[(x) & 0])

/* LC0 LC1  */
static enum machine_registers decode_counters[] =
{
  REG_LC0, REG_LC1,
};

#define counters(x) REGNAME(decode_counters[(x) & 1])

#if 0				/* commented it currently as not used currently */
/* A0x A0w A1x A1w GP - ASTAT RETS  */
static enum machine_registers decode_dregs2_sysregs1[] =
{
  REG_A0x, REG_A0w, REG_A1x, REG_A1w, REG_GP, REG_LASTREG, REG_ASTAT, REG_RETS,
};

#define dregs2_sysregs1(x) REGNAME(decode_dregs2_sysregs1[(x) & 7])

/* - - - - - - - - */
static enum machine_registers decode_open[] =
{
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
};

#define open(x) REGNAME(decode_open[(x) & 7])

/* LC0 LT0 LB0 LC1 LT1 LB1 CYCLES CYCLES2 */
static enum machine_registers decode_sysregs2[] =
{
  REG_LC0, REG_LT0, REG_LB0, REG_LC1, REG_LT1, REG_LB1, REG_CYCLES, REG_CYCLES2,
};

#define sysregs2(x) REGNAME(decode_sysregs2[(x) & 7])

/* USP SEQSTAT SYSCFG RETI RETX RETN RETE - */
static enum machine_registers decode_sysregs3[] =
{
  REG_USP, REG_SEQSTAT, REG_SYSCFG, REG_RETI, REG_RETX, REG_RETN, REG_RETE, REG_LASTREG,
};

#define sysregs3(x) REGNAME(decode_sysregs3[(x) & 7])
#endif

/* [dregs pregs (iregs mregs) (bregs lregs) 	         dregs2_sysregs1 open sysregs2 sysregs3] */
static enum machine_registers decode_allregs[] =
{
  REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
  REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
  REG_I0, REG_I1, REG_I2, REG_I3, REG_M0, REG_M1, REG_M2, REG_M3,
  REG_B0, REG_B1, REG_B2, REG_B3, REG_L0, REG_L1, REG_L2, REG_L3,
  REG_A0x, REG_A0w, REG_A1x, REG_A1w, REG_GP, REG_LASTREG, REG_ASTAT, REG_RETS,
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
  REG_LC0, REG_LT0, REG_LB0, REG_LC1, REG_LT1, REG_LB1, REG_CYCLES, REG_CYCLES2,
  REG_USP, REG_SEQSTAT, REG_SYSCFG, REG_RETI, REG_RETX, REG_RETN, REG_RETE, REG_LASTREG,
};

#define allregs(x,i) REGNAME(decode_allregs[((i)<<3)|x])
#define uimm16s4(x) fmtconst(c_uimm16s4, x, 0, outf)
#define pcrel4(x) fmtconst(c_pcrel4, x, pc, outf)
#define pcrel8(x) fmtconst(c_pcrel8, x, pc, outf)
#define pcrel8s4(x) fmtconst(c_pcrel8s4, x, pc, outf)
#define pcrel10(x) fmtconst(c_pcrel10, x, pc, outf)
#define pcrel12(x) fmtconst(c_pcrel12, x, pc, outf)
#define negimm5s4(x) fmtconst(c_negimm5s4, x, 0, outf)
#define rimm16(x) fmtconst(c_rimm16, x, 0, outf)
#define huimm16(x) fmtconst(c_huimm16, x, 0, outf)
#define imm16(x) fmtconst(c_imm16, x, 0, outf)
#define uimm2(x) fmtconst(c_uimm2, x, 0, outf)
#define uimm3(x) fmtconst(c_uimm3, x, 0, outf)
#define luimm16(x) fmtconst(c_luimm16, x, 0, outf)
#define uimm4(x) fmtconst(c_uimm4, x, 0, outf)
#define uimm5(x) fmtconst(c_uimm5, x, 0, outf)
#define imm16s2(x) fmtconst(c_imm16s2, x, 0, outf)
#define uimm8(x) fmtconst(c_uimm8, x, 0, outf)
#define imm16s4(x) fmtconst(c_imm16s4, x, 0, outf)
#define uimm4s2(x) fmtconst(c_uimm4s2, x, 0, outf)
#define uimm4s4(x) fmtconst(c_uimm4s4, x, 0, outf)
#define lppcrel10(x) fmtconst(c_lppcrel10, x, pc, outf)
#define imm3(x) fmtconst(c_imm3, x, 0, outf)
#define imm4(x) fmtconst(c_imm4, x, 0, outf)
#define uimm8s4(x) fmtconst(c_uimm8s4, x, 0, outf)
#define imm5(x) fmtconst(c_imm5, x, 0, outf)
#define imm6(x) fmtconst(c_imm6, x, 0, outf)
#define imm7(x) fmtconst(c_imm7, x, 0, outf)
#define imm8(x) fmtconst(c_imm8, x, 0, outf)
#define pcrel24(x) fmtconst(c_pcrel24, x, pc, outf)
#define uimm16(x) fmtconst(c_uimm16, x, 0, outf)

/* (arch.pm)arch_disassembler_functions */
#define notethat(x)

#ifndef OUTS
#define OUTS(p,txt) ((p)?(((txt)[0])?(p->fprintf_func)(p->stream, txt):0):0)
#endif


static void
amod0 (int s0, int x0, disassemble_info *outf)
{
  if (s0 == 0 && x0 == 0)
    {
      notethat ("(NS)");
      return;
    }
  else if (s0 == 1 && x0 == 0)
    {
      notethat ("(S)");
      OUTS (outf, "(S)");
      return;
    }
  else if (s0 == 0 && x0 == 1)
    {
      notethat ("(CO)");
      OUTS (outf, "(CO)");
      return;
    }
  else if (s0 == 1 && x0 == 1)
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
amod1 (int s0, int x0, disassemble_info *outf)
{
  if (s0 == 0 && x0 == 0)
    {
      notethat ("(NS)");
      OUTS (outf, "(NS)");
      return;
    }
  else if (s0 == 1 && x0 == 0)
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
macmod_accm (int mod, disassemble_info *outf)
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
searchmod (int r0, disassemble_info *outf)
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
mxd_mod (int mod, disassemble_info *outf)
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
aligndir (int r0, disassemble_info *outf)
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

static int
decode_multfunc (int h0, int h1, int src0, int src1, disassemble_info * outf)
{
  char *s0, *s1;

  if (h0)
    s0 = dregs_hi (src0);
  else
    s0 = dregs_lo (src0);

  if (h1)
    s1 = dregs_hi (src1);
  else
    s1 = dregs_lo (src1);

  OUTS (outf, s0);
  OUTS (outf, " * ");
  OUTS (outf, s1);
  return 0;
}

static int
decode_macfunc (int which, int op, int h0, int h1, int src0, int src1, disassemble_info * outf)
{
  char *a;
  char *sop = "<unknown op>";

  if (which)
    a = "a1";
  else
    a = "a0";

  if (op == 3)
    {				// no macfunc, just assign
      OUTS (outf, a);
      return 0;
    }

  switch (op)
    {
    case 0:
      sop = "=";
      break;
    case 1:
      sop = "+=";
      break;
    case 2:
      sop = "-=";
      break;
    }

  OUTS (outf, a);
  OUTS (outf, " ");
  OUTS (outf, sop);
  OUTS (outf, " ");
  decode_multfunc (h0, h1, src0, src1, outf);

  return 0;
}

static void
decode_optmode (int mod, int MM, disassemble_info *outf)
{
  if (mod == 0 && MM == 0)
    return;

  OUTS (outf, " (");

  if (MM)
    OUTS (outf, "M, ");
  
  if (mod == 1)
    OUTS (outf, "S2RND");
  else if (mod == 2)
    OUTS (outf, "T");
  else if (mod == 4)
    OUTS (outf, "FU");
  else if (mod == 6)
    OUTS (outf, "TFU");
  else if (mod == 8)
    OUTS (outf, "IS");
  else if (mod == 9)
    OUTS (outf, "ISS2");
  else if (mod == 11)
    OUTS (outf, "IH");
  else if (mod == 12)
    OUTS (outf, "IU");
  else
    abort ();

  OUTS (outf, ")");
}

static int
decode_ProgCtrl_0 (TIword iw0, disassemble_info *outf)
{
/* ProgCtrl
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int poprnd = ((iw0 >> 0) & 0xf);
  int prgfunc = ((iw0 >> 4) & 0xf);

  if (prgfunc == 0 && poprnd == 0)
    {
      notethat ("NOP");
      OUTS (outf, "NOP");
      return 1 * 2;
    }
  else if (prgfunc == 1 && poprnd == 0)
    {
      notethat ("RTS");
      OUTS (outf, "RTS");
      return 1 * 2;
    }
  else if (prgfunc == 1 && poprnd == 1)
    {
      notethat ("RTI");
      OUTS (outf, "RTI");
      return 1 * 2;
    }
  else if (prgfunc == 1 && poprnd == 2)
    {
      notethat ("RTX");
      OUTS (outf, "RTX");
      return 1 * 2;
    }
  else if (prgfunc == 1 && poprnd == 3)
    {
      notethat ("RTN");
      OUTS (outf, "RTN");
      return 1 * 2;
    }
  else if (prgfunc == 1 && poprnd == 4)
    {
      notethat ("RTE");
      OUTS (outf, "RTE");
      return 1 * 2;
    }
  else if (prgfunc == 2 && poprnd == 0)
    {
      notethat ("IDLE");
      OUTS (outf, "IDLE");
      return 1 * 2;
    }
  else if (prgfunc == 2 && poprnd == 3)
    {
      notethat ("CSYNC");
      OUTS (outf, "CSYNC");
      return 1 * 2;
    }
  else if (prgfunc == 2 && poprnd == 4)
    {
      notethat ("SSYNC");
      OUTS (outf, "SSYNC");
      return 1 * 2;
    }
  else if (prgfunc == 2 && poprnd == 5)
    {
      notethat ("EMUEXCPT");
      OUTS (outf, "EMUEXCPT");
      return 1 * 2;
    }
  else if (prgfunc == 3)
    {
      notethat ("CLI dregs");
      OUTS (outf, "CLI  ");
      OUTS (outf, dregs (poprnd));
      return 1 * 2;
    }
  else if (prgfunc == 4)
    {
      notethat ("STI dregs");
      OUTS (outf, "STI  ");
      OUTS (outf, dregs (poprnd));
      return 1 * 2;
    }
  else if (prgfunc == 5)
    {
      notethat ("JUMP ( pregs )");
      OUTS (outf, "JUMP  ");
      OUTS (outf, "(");
      OUTS (outf, pregs (poprnd));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (prgfunc == 6)
    {
      notethat ("CALL ( pregs )");
      OUTS (outf, "CALL  ");
      OUTS (outf, "(");
      OUTS (outf, pregs (poprnd));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (prgfunc == 7)
    {
      notethat ("CALL ( PC + pregs )");
      OUTS (outf, "CALL  ");
      OUTS (outf, "(");
      OUTS (outf, "PC");
      OUTS (outf, "+");
      OUTS (outf, pregs (poprnd));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (prgfunc == 8)
    {
      notethat ("JUMP ( PC + pregs )");
      OUTS (outf, "JUMP  ");
      OUTS (outf, "(");
      OUTS (outf, "PC");
      OUTS (outf, "+");
      OUTS (outf, pregs (poprnd));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (prgfunc == 9)
    {
      notethat ("RAISE uimm4");
      OUTS (outf, "RAISE  ");
      OUTS (outf, uimm4 (poprnd));
      return 1 * 2;
    }
  else if (prgfunc == 10)
    {
      notethat ("EXCPT uimm4");
      OUTS (outf, "EXCPT  ");
      OUTS (outf, uimm4 (poprnd));
      return 1 * 2;
    }
  else if (prgfunc == 11)
    {
      notethat ("TESTSET ( pregs )");
      OUTS (outf, "TESTSET  ");
      OUTS (outf, "(");
      OUTS (outf, pregs (poprnd));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_CaCTRL_0 (TIword iw0, disassemble_info *outf)
{
/* CaCTRL
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int a = ((iw0 >> 5) & 0x1);
  int reg = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 3) & 0x3);



  if (a == 0 && op == 0)
    {
      notethat ("PREFETCH [ pregs ]");
      OUTS (outf, "PREFETCH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (a == 0 && op == 1)
    {
      notethat ("FLUSHINV [ pregs ]");
      OUTS (outf, "FLUSHINV");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (a == 0 && op == 2)
    {
      notethat ("FLUSH [ pregs ]");
      OUTS (outf, "FLUSH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (a == 0 && op == 3)
    {
      notethat ("IFLUSH [ pregs ]");
      OUTS (outf, "IFLUSH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (a == 1 && op == 0)
    {
      notethat ("PREFETCH [ pregs ++ ]");
      OUTS (outf, "PREFETCH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (a == 1 && op == 1)
    {
      notethat ("FLUSHINV [ pregs ++ ]");
      OUTS (outf, "FLUSHINV");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (a == 1 && op == 2)
    {
      notethat ("FLUSH [ pregs ++ ]");
      OUTS (outf, "FLUSH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (a == 1 && op == 3)
    {
      notethat ("IFLUSH [ pregs ++ ]");
      OUTS (outf, "IFLUSH");
      OUTS (outf, "[");
      OUTS (outf, pregs (reg));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_PushPopReg_0 (TIword iw0, disassemble_info *outf)
{

/* PushPopReg
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.W.|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int grp = ((iw0 >> 3) & 0x7);
  int reg = ((iw0 >> 0) & 0x7);
  int W = ((iw0 >> 6) & 0x1);

  if (W == 0)
    {
      notethat ("allregs = [ SP ++ ]");
      OUTS (outf, allregs (reg, grp));
      OUTS (outf, " = ");
      OUTS (outf, "[");
      OUTS (outf, "SP");
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (W == 1)
    {
      notethat ("[ -- SP ] = allregs");
      OUTS (outf, "[");
      OUTS (outf, "--");
      OUTS (outf, "SP");
      OUTS (outf, "]");
      OUTS (outf, " = ");
      OUTS (outf, allregs (reg, grp));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_PushPopMultiple_0 (TIword iw0, disassemble_info *outf)
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
  char ps[5], ds[5];
  sprintf (ps, "%d", pr);
  sprintf (ds, "%d", dr);

  if (W == 1 && d == 1 && p == 1)
    {
      notethat ("[ -- SP ] = ( R7 : reglim , P5 : reglim )");
      OUTS (outf, "[SP--] = (R7:");
      OUTS (outf, ds);
      OUTS (outf, ", P5:");
      OUTS (outf, ps);
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (W == 1 && d == 1 && p == 0)
    {
      notethat ("[ -- SP ] = ( R7 : reglim )");
      OUTS (outf, "[--SP] = (R7:");
      OUTS (outf, ds);
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (W == 1 && d == 0 && p == 1)
    {
      notethat ("[ -- SP ] = ( P5 : reglim )");
      OUTS (outf, "[--SP] = (P5:");
      OUTS (outf, ps);
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (W == 0 && d == 1 && p == 1)
    {
      notethat ("( R7 : reglim , P5 : reglim ) = [ SP ++ ]");
      OUTS (outf, "(R7:");
      OUTS (outf, ds);
      OUTS (outf, ", P5:");
      OUTS (outf, ps);
      OUTS (outf, ") = [SP++]");
      return 1 * 2;
    }
  else if (W == 0 && d == 1 && p == 0)
    {
      notethat ("( R7 : reglim ) = [ SP ++ ]");
      OUTS (outf, "(R7:");
      OUTS (outf, ds);
      OUTS (outf, ") = [SP++]");
      return 1 * 2;
    }
  else if (W == 0 && d == 0 && p == 1)
    {
      notethat ("( P5 : reglim ) = [ SP ++ ]");
      OUTS (outf, "(P5:");
      OUTS (outf, ps);
      OUTS (outf, ") = [SP++]");
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_ccMV_0 (TIword iw0, disassemble_info *outf)
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



  if (T == 1)
    {
      notethat ("IF CC gregs = gregs");
      OUTS (outf, "IF");
      OUTS (outf, " CC ");
      OUTS (outf, gregs (dst, d));
      OUTS (outf, " = ");
      OUTS (outf, gregs (src, s));
      return 1 * 2;
    }
  else if (T == 0)
    {
      notethat ("IF ! CC gregs = gregs");
      OUTS (outf, "IF");
      OUTS (outf, " ! ");
      OUTS (outf, "CC ");
      OUTS (outf, gregs (dst, d));
      OUTS (outf, " = ");
      OUTS (outf, gregs (src, s));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_CCflag_0 (TIword iw0, disassemble_info *outf)
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



  if (opc == 0 && I == 0 && G == 0)
    {
      notethat ("CC = dregs == dregs");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "==");
      OUTS (outf, dregs (y));
      return 1 * 2;
    }
  else if (opc == 1 && I == 0 && G == 0)
    {
      notethat ("CC = dregs < dregs");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "<");
      OUTS (outf, dregs (y));
      return 1 * 2;
    }
  else if (opc == 2 && I == 0 && G == 0)
    {
      notethat ("CC = dregs <= dregs");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "<=");
      OUTS (outf, dregs (y));
      return 1 * 2;
    }
  else if (opc == 3 && I == 0 && G == 0)
    {
      notethat ("CC = dregs < dregs ( IU )");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "<");
      OUTS (outf, dregs (y));
      OUTS (outf, "(");
      OUTS (outf, "IU");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 4 && I == 0 && G == 0)
    {
      notethat ("CC = dregs <= dregs ( IU )");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "<=");
      OUTS (outf, dregs (y));
      OUTS (outf, "(");
      OUTS (outf, "IU");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 0 && I == 1 && G == 0)
    {
      notethat ("CC = dregs == imm3");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "==");
      OUTS (outf, imm3 (y));
      return 1 * 2;
    }
  else if (opc == 1 && I == 1 && G == 0)
    {
      notethat ("CC = dregs < imm3");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "<");
      OUTS (outf, imm3 (y));
      return 1 * 2;
    }
  else if (opc == 2 && I == 1 && G == 0)
    {
      notethat ("CC = dregs <= imm3");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "<=");
      OUTS (outf, imm3 (y));
      return 1 * 2;
    }
  else if (opc == 3 && I == 1 && G == 0)
    {
      notethat ("CC = dregs < uimm3 ( IU )");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "<");
      OUTS (outf, uimm3 (y));
      OUTS (outf, "(");
      OUTS (outf, "IU");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 4 && I == 1 && G == 0)
    {
      notethat ("CC = dregs <= uimm3 ( IU )");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (x));
      OUTS (outf, "<=");
      OUTS (outf, uimm3 (y));
      OUTS (outf, "(");
      OUTS (outf, "IU");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 0 && I == 0 && G == 1)
    {
      notethat ("CC = pregs == pregs");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "==");
      OUTS (outf, pregs (y));
      return 1 * 2;
    }
  else if (opc == 1 && I == 0 && G == 1)
    {
      notethat ("CC = pregs < pregs");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "<");
      OUTS (outf, pregs (y));
      return 1 * 2;
    }
  else if (opc == 2 && I == 0 && G == 1)
    {
      notethat ("CC = pregs <= pregs");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "<=");
      OUTS (outf, pregs (y));
      return 1 * 2;
    }
  else if (opc == 3 && I == 0 && G == 1)
    {
      notethat ("CC = pregs < pregs ( IU )");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "<");
      OUTS (outf, pregs (y));
      OUTS (outf, "(");
      OUTS (outf, "IU");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 4 && I == 0 && G == 1)
    {
      notethat ("CC = pregs <= pregs ( IU )");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "<=");
      OUTS (outf, pregs (y));
      OUTS (outf, "(");
      OUTS (outf, "IU");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 0 && I == 1 && G == 1)
    {
      notethat ("CC = pregs == imm3");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "==");
      OUTS (outf, imm3 (y));
      return 1 * 2;
    }
  else if (opc == 1 && I == 1 && G == 1)
    {
      notethat ("CC = pregs < imm3");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "<");
      OUTS (outf, imm3 (y));
      return 1 * 2;
    }
  else if (opc == 2 && I == 1 && G == 1)
    {
      notethat ("CC = pregs <= imm3");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "<=");
      OUTS (outf, imm3 (y));
      return 1 * 2;
    }
  else if (opc == 3 && I == 1 && G == 1)
    {
      notethat ("CC = pregs < uimm3 ( IU )");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "<");
      OUTS (outf, uimm3 (y));
      OUTS (outf, "(");
      OUTS (outf, "IU");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 4 && I == 1 && G == 1)
    {
      notethat ("CC = pregs <= uimm3 ( IU )");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, pregs (x));
      OUTS (outf, "<=");
      OUTS (outf, uimm3 (y));
      OUTS (outf, "(");
      OUTS (outf, "IU");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 5 && I == 0 && G == 0)
    {
      notethat ("CC = A0 == A1");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "==");
      OUTS (outf, "A1");
      return 1 * 2;
    }
  else if (opc == 6 && I == 0 && G == 0)
    {
      notethat ("CC = A0 < A1");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "<");
      OUTS (outf, "A1");
      return 1 * 2;
    }
  else if (opc == 7 && I == 0 && G == 0)
    {
      notethat ("CC = A0 <= A1");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "<=");
      OUTS (outf, "A1");
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_CC2dreg_0 (TIword iw0, disassemble_info *outf)
{
/* CC2dreg
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int reg = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 3) & 0x3);



  if (op == 0)
    {
      notethat ("dregs = CC");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "CC");
      return 1 * 2;
    }
  else if (op == 1)
    {
      notethat ("CC = dregs");
      OUTS (outf, "CC");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (op == 3)
    {
      notethat ("CC =! CC");
      OUTS (outf, "CC");
      OUTS (outf, "=!");
      OUTS (outf, "CC");
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_CC2stat_0 (TIword iw0, disassemble_info *outf)
{
/* CC2stat
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int cbit = ((iw0 >> 0) & 0x1f);
  int D = ((iw0 >> 7) & 0x1);
  int op = ((iw0 >> 5) & 0x3);



  if (op == 0 && D == 0)
    {
      notethat ("CC = statbits");
      OUTS (outf, "CC");
      OUTS (outf, " = ");
      /* printf ("\n\n STATBIT ----> %d \n\n",cbit); */
      OUTS (outf, statbits (cbit));
      return 1 * 2;
    }
  else if (op == 1 && D == 0)
    {
      notethat ("CC |= statbits");
      OUTS (outf, "CC");
      OUTS (outf, "|=");
      OUTS (outf, statbits (cbit));
      return 1 * 2;
    }
  else if (op == 2 && D == 0)
    {
      notethat ("CC &= statbits");
      OUTS (outf, "CC");
      OUTS (outf, "&=");
      OUTS (outf, statbits (cbit));
      return 1 * 2;
    }
  else if (op == 3 && D == 0)
    {
      notethat ("CC ^= statbits");
      OUTS (outf, "CC");
      OUTS (outf, "^=");
      OUTS (outf, statbits (cbit));
      return 1 * 2;
    }
  else if (op == 0 && D == 1)
    {
      notethat ("statbits = CC");
      OUTS (outf, statbits (cbit));
      OUTS (outf, "=");
      OUTS (outf, "CC");
      return 1 * 2;
    }
  else if (op == 1 && D == 1)
    {
      notethat ("statbits |= CC");
      OUTS (outf, statbits (cbit));
      OUTS (outf, "|=");
      OUTS (outf, "CC");
      return 1 * 2;
    }
  else if (op == 2 && D == 1)
    {
      notethat ("statbits &= CC");
      OUTS (outf, statbits (cbit));
      OUTS (outf, "&=");
      OUTS (outf, "CC");
      return 1 * 2;
    }
  else if (op == 3 && D == 1)
    {
      notethat ("statbits ^= CC");
      OUTS (outf, statbits (cbit));
      OUTS (outf, "^=");
      OUTS (outf, "CC");
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_BRCC_0 (TIword iw0, bfd_vma pc, disassemble_info *outf)
{
/* BRCC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int B = ((iw0 >> 10) & 0x1);
  int T = ((iw0 >> 11) & 0x1);
  int offset = ((iw0 >> 0) & 0x3ff);



  if (T == 1 && B == 1)
    {
      notethat ("IF CC JUMP pcrel10 ( BP )");
      OUTS (outf, "IF CC JUMP ");
      OUTS (outf, pcrel10 (offset));
      OUTS (outf, "(");
      OUTS (outf, "BP");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (T == 0 && B == 1)
    {
      notethat ("IF !CC JUMP pcrel10 ( BP )");
      OUTS (outf, "IF ! CC JUMP ");
      OUTS (outf, pcrel10 (offset));
      OUTS (outf, "(");
      OUTS (outf, "BP");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (T == 1)
    {
      notethat ("IF CC JUMP pcrel10");
      OUTS (outf, "IF CC JUMP ");
      OUTS (outf, pcrel10 (offset));
      return 1 * 2;
    }
  else if (T == 0)
    {
      notethat ("IF !CC JUMP pcrel10");
      OUTS (outf, "IF ! CC JUMP ");
      OUTS (outf, pcrel10 (offset));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_UJUMP_0 (TIword iw0, bfd_vma pc, disassemble_info *outf)
{
/* UJUMP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 0 |.offset........................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int offset = ((iw0 >> 0) & 0xfff);


  notethat ("JUMP.S pcrel12");
  OUTS (outf, "JUMP.S  ");
  OUTS (outf, pcrel12 (offset));
  return 1 * 2;
}

static int
decode_REGMV_0 (TIword iw0, disassemble_info *outf)
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



/*printf ("\ngd = %d ", gd);
printf ("\ngs = %d ", gs);
printf ("\ndst = %d ", dst);
printf ("\nsrc = %d \n", src);*/
  notethat ("allregs = allregs");
  OUTS (outf, allregs (dst, gd));
  OUTS (outf, "=");
  OUTS (outf, allregs (src, gs));
  return 1 * 2;
}

static int
decode_ALU2op_0 (TIword iw0, disassemble_info *outf)
{
/* ALU2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src = ((iw0 >> 3) & 0x7);
  int opc = ((iw0 >> 6) & 0xf);
  int dst = ((iw0 >> 0) & 0x7);



  if (opc == 0)
    {
      notethat ("dregs >>>= dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, ">>>=");
      OUTS (outf, dregs (src));
      return 1 * 2;
    }
  else if (opc == 1)
    {
      notethat ("dregs >>= dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, ">>=");
      OUTS (outf, dregs (src));
      return 1 * 2;
    }
  else if (opc == 2)
    {
      notethat ("dregs <<= dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "<<=");
      OUTS (outf, dregs (src));
      return 1 * 2;
    }
  else if (opc == 3)
    {
      notethat ("dregs *= dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "*=");
      OUTS (outf, dregs (src));
      return 1 * 2;
    }
  else if (opc == 4)
    {
      notethat ("dregs = (dregs + dregs) << 1");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, "+");
      OUTS (outf, dregs (src));
      OUTS (outf, ")");
      OUTS (outf, "<<");
      OUTS (outf, "1");
      return 1 * 2;
    }
  else if (opc == 5)
    {
      notethat ("dregs = (dregs + dregs) << 2");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, "+");
      OUTS (outf, dregs (src));
      OUTS (outf, ")");
      OUTS (outf, "<<");
      OUTS (outf, "2");
      return 1 * 2;
    }
  else if (opc == 8)
    {
      notethat ("DIVQ (dregs , dregs)");
      OUTS (outf, "DIVQ");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, dregs (src));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 9)
    {
      notethat ("DIVS (dregs , dregs)");
      OUTS (outf, "DIVS");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, dregs (src));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 10)
    {
      notethat ("dregs = dregs_lo (X)");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src));
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 11)
    {
      notethat ("dregs = dregs_lo (Z)");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src));
      OUTS (outf, "(");
      OUTS (outf, "Z");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 12)
    {
      notethat ("dregs = dregs_byte (X)");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs_byte (src));
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 13)
    {
      notethat ("dregs = dregs_byte (Z)");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs_byte (src));
      OUTS (outf, "(");
      OUTS (outf, "Z");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 14)
    {
      notethat ("dregs = - dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, dregs (src));
      return 1 * 2;
    }
  else if (opc == 15)
    {
      notethat ("dregs = ~ dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "~");
      OUTS (outf, dregs (src));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_PTR2op_0 (TIword iw0, disassemble_info *outf)
{
/* PTR2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src = ((iw0 >> 3) & 0x7);
  int opc = ((iw0 >> 6) & 0x7);
  int dst = ((iw0 >> 0) & 0x7);



  if (opc == 0)
    {
      notethat ("pregs -= pregs");
      OUTS (outf, pregs (dst));
      OUTS (outf, "-=");
      OUTS (outf, pregs (src));
      return 1 * 2;
    }
  else if (opc == 1)
    {
      notethat ("pregs = pregs << 2");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, pregs (src));
      OUTS (outf, "<<");
      OUTS (outf, "2");
      return 1 * 2;
    }
  else if (opc == 3)
    {
      notethat ("pregs = pregs >> 2");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, pregs (src));
      OUTS (outf, ">>");
      OUTS (outf, "2");
      return 1 * 2;
    }
  else if (opc == 4)
    {
      notethat ("pregs = pregs >> 1");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, pregs (src));
      OUTS (outf, ">>");
      OUTS (outf, "1");
      return 1 * 2;
    }
  else if (opc == 5)
    {
      notethat ("pregs += pregs ( BREV )");
      OUTS (outf, pregs (dst));
      OUTS (outf, "+=");
      OUTS (outf, pregs (src));
      OUTS (outf, "(");
      OUTS (outf, "BREV");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 6)
    {
      notethat ("pregs = (pregs + pregs) << 1");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, pregs (dst));
      OUTS (outf, "+");
      OUTS (outf, pregs (src));
      OUTS (outf, ")");
      OUTS (outf, "<<");
      OUTS (outf, "1");
      return 1 * 2;
    }
  else if (opc == 7)
    {
      notethat ("pregs = (pregs + pregs) << 2");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, pregs (dst));
      OUTS (outf, "+");
      OUTS (outf, pregs (src));
      OUTS (outf, ")");
      OUTS (outf, "<<");
      OUTS (outf, "2");
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_LOGI2op_0 (TIword iw0, disassemble_info *outf)
{
/* LOGI2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int src = ((iw0 >> 3) & 0x1f);
  int opc = ((iw0 >> 8) & 0x7);
  int dst = ((iw0 >> 0) & 0x7);



  if (opc == 0)
    {
      notethat ("CC = ! BITTST ( dregs , uimm5 )");
      OUTS (outf, "CC");
      OUTS (outf, " = ");
      OUTS (outf, "!");
      OUTS (outf, " BITTST ");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, uimm5 (src));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 1)
    {
      notethat ("CC = BITTST ( dregs , uimm5 )");
      OUTS (outf, "CC");
      OUTS (outf, " = ");
      OUTS (outf, "BITTST ");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, uimm5 (src));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 2)
    {
      notethat ("BITSET ( dregs , uimm5 )");
      OUTS (outf, "BITSET ");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, uimm5 (src));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 3)
    {
      notethat ("BITTGL ( dregs , uimm5 )");
      OUTS (outf, "BITTGL ");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, uimm5 (src));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 4)
    {
      notethat ("BITCLR ( dregs , uimm5 )");
      OUTS (outf, "BITCLR ");
      OUTS (outf, "(");
      OUTS (outf, dregs (dst));
      OUTS (outf, ",");
      OUTS (outf, uimm5 (src));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 5)
    {
      notethat ("dregs >>>= uimm5");
      OUTS (outf, dregs (dst));
      OUTS (outf, ">>>=");
      OUTS (outf, uimm5 (src));
      return 1 * 2;
    }
  else if (opc == 6)
    {
      notethat ("dregs >>= uimm5");
      OUTS (outf, dregs (dst));
      OUTS (outf, ">>=");
      OUTS (outf, uimm5 (src));
      return 1 * 2;
    }
  else if (opc == 7)
    {
      notethat ("dregs <<= uimm5");
      OUTS (outf, dregs (dst));
      OUTS (outf, "<<=");
      OUTS (outf, uimm5 (src));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_COMP3op_0 (TIword iw0, disassemble_info *outf)
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



  if (opc == 5 && src1 == src0)
    {
      notethat ("pregs = pregs << 1");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, pregs (src0));
      OUTS (outf, "<<");
      OUTS (outf, "1");
      return 1 * 2;
    }
  else if (opc == 1)
    {
      notethat ("dregs = dregs - dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs (src1));
      return 1 * 2;
    }
  else if (opc == 2)
    {
      notethat ("dregs = dregs & dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "&");
      OUTS (outf, dregs (src1));
      return 1 * 2;
    }
  else if (opc == 3)
    {
      notethat ("dregs = dregs | dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "|");
      OUTS (outf, dregs (src1));
      return 1 * 2;
    }
  else if (opc == 4)
    {
      notethat ("dregs = dregs ^ dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "^");
      OUTS (outf, dregs (src1));
      return 1 * 2;
    }
  else if (opc == 5)
    {
      notethat ("pregs = pregs + pregs");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, pregs (src0));
      OUTS (outf, "+");
      OUTS (outf, pregs (src1));
      return 1 * 2;
    }
  else if (opc == 6)
    {
      notethat ("pregs = pregs + (pregs << 1)");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, pregs (src0));
      OUTS (outf, "+");
      OUTS (outf, "(");
      OUTS (outf, pregs (src1));
      OUTS (outf, "<<");
      OUTS (outf, "1");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 7)
    {
      notethat ("pregs = pregs + (pregs << 2)");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, pregs (src0));
      OUTS (outf, "+");
      OUTS (outf, "(");
      OUTS (outf, pregs (src1));
      OUTS (outf, "<<");
      OUTS (outf, "2");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (opc == 0)
    {
      notethat ("dregs = dregs + dregs");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs (src1));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_COMPI2opD_0 (TIword iw0, disassemble_info *outf)
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
    {
      notethat ("dregs = imm7 (x)");
      OUTS (outf, dregs (dst));
      OUTS (outf, "=");
      OUTS (outf, imm7 (isrc));
      OUTS (outf, "(x)");
      return 1 * 2;
    }
  else if (op == 1)
    {
      notethat ("dregs += imm7");
      OUTS (outf, dregs (dst));
      OUTS (outf, "+=");
      OUTS (outf, imm7 (isrc));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_COMPI2opP_0 (TIword iw0, disassemble_info *outf)
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
    {
      notethat ("pregs = imm7");
      OUTS (outf, pregs (dst));
      OUTS (outf, "=");
      OUTS (outf, imm7 (src));
      return 1 * 2;
    }
  else if (op == 1)
    {
      notethat ("pregs += imm7");
      OUTS (outf, pregs (dst));
      OUTS (outf, "+=");
      OUTS (outf, imm7 (src));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_LDSTpmod_0 (TIword iw0, disassemble_info *outf)
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



  if (aop == 1 && W == 0 && idx == ptr)
    {
      notethat ("dregs_lo = W [ pregs ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 2 && W == 0 && idx == ptr)
    {
      notethat ("dregs_hi = W [ pregs ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 1 && W == 1 && idx == ptr)
    {
      notethat ("W [ pregs ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      return 1 * 2;
    }
  else if (aop == 2 && W == 1 && idx == ptr)
    {
      notethat ("W [ pregs ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      return 1 * 2;
    }
  else if (aop == 0 && W == 0)
    {
      notethat ("dregs = [ pregs ++ pregs ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 1 && W == 0)
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
      return 1 * 2;
    }
  else if (aop == 2 && W == 0)
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
      return 1 * 2;
    }
  else if (aop == 3 && W == 0)
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
      return 1 * 2;
    }
  else if (aop == 3 && W == 1)
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
      return 1 * 2;
    }
  else if (aop == 0 && W == 1)
    {
      notethat ("[ pregs ++ pregs ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, pregs (idx));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 1 && W == 1)
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
      return 1 * 2;
    }
  else if (aop == 2 && W == 1)
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
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_dagMODim_0 (TIword iw0, disassemble_info *outf)
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



  if (op == 0 && br == 1)
    {
      notethat ("iregs += mregs ( BREV )");
      OUTS (outf, iregs (i));
      OUTS (outf, "+=");
      OUTS (outf, mregs (m));
      OUTS (outf, "(");
      OUTS (outf, "BREV");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (op == 0)
    {
      notethat ("iregs += mregs");
      OUTS (outf, iregs (i));
      OUTS (outf, "+=");
      OUTS (outf, mregs (m));
      return 1 * 2;
    }
  else if (op == 1)
    {
      notethat ("iregs -= mregs");
      OUTS (outf, iregs (i));
      OUTS (outf, "-=");
      OUTS (outf, mregs (m));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_dagMODik_0 (TIword iw0, disassemble_info *outf)
{
/* dagMODik
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int i = ((iw0 >> 0) & 0x3);
  int op = ((iw0 >> 2) & 0x3);



  if (op == 0)
    {
      notethat ("iregs += 2");
      OUTS (outf, iregs (i));
      OUTS (outf, "+=");
      OUTS (outf, "2");
      return 1 * 2;
    }
  else if (op == 1)
    {
      notethat ("iregs -= 2");
      OUTS (outf, iregs (i));
      OUTS (outf, "-=");
      OUTS (outf, "2");
      return 1 * 2;
    }
  else if (op == 2)
    {
      notethat ("iregs += 4");
      OUTS (outf, iregs (i));
      OUTS (outf, "+=");
      OUTS (outf, "4");
      return 1 * 2;
    }
  else if (op == 3)
    {
      notethat ("iregs -= 4");
      OUTS (outf, iregs (i));
      OUTS (outf, "-=");
      OUTS (outf, "4");
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_dspLDST_0 (TIword iw0, disassemble_info *outf)
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



  if (aop == 0 && W == 0 && m == 0)
    {
      notethat ("dregs = [ iregs ++ ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 0 && W == 0 && m == 1)
    {
      notethat ("dregs_lo = W [ iregs ++ ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 0 && W == 0 && m == 2)
    {
      notethat ("dregs_hi = W [ iregs ++ ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 1 && W == 0 && m == 0)
    {
      notethat ("dregs = [ iregs -- ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 1 && W == 0 && m == 1)
    {
      notethat ("dregs_lo = W [ iregs -- ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 1 && W == 0 && m == 2)
    {
      notethat ("dregs_hi = W [ iregs -- ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 2 && W == 0 && m == 0)
    {
      notethat ("dregs = [ iregs ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 2 && W == 0 && m == 1)
    {
      notethat ("dregs_lo = W [ iregs ]");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 2 && W == 0 && m == 2)
    {
      notethat ("dregs_hi = W [ iregs ]");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 0 && W == 1 && m == 0)
    {
      notethat ("[ iregs ++ ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 0 && W == 1 && m == 1)
    {
      notethat ("W [ iregs ++ ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      return 1 * 2;
    }
  else if (aop == 0 && W == 1 && m == 2)
    {
      notethat ("W [ iregs ++ ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      return 1 * 2;
    }
  else if (aop == 1 && W == 1 && m == 0)
    {
      notethat ("[ iregs -- ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 1 && W == 1 && m == 1)
    {
      notethat ("W [ iregs -- ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      return 1 * 2;
    }
  else if (aop == 1 && W == 1 && m == 2)
    {
      notethat ("W [ iregs -- ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      return 1 * 2;
    }
  else if (aop == 2 && W == 1 && m == 0)
    {
      notethat ("[ iregs ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 2 && W == 1 && m == 1)
    {
      notethat (" W [ iregs ] = dregs_lo");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (reg));
      return 1 * 2;
    }
  else if (aop == 2 && W == 1 && m == 2)
    {
      notethat (" W [ iregs ] = dregs_hi");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (reg));
      return 1 * 2;
    }
  else if (aop == 3 && W == 0)
    {
      notethat ("dregs = [ iregs ++ mregs ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, mregs (m));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 3 && W == 1)
    {
      notethat ("[ iregs ++ mregs ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, iregs (i));
      OUTS (outf, "++");
      OUTS (outf, mregs (m));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_LDST_0 (TIword iw0, disassemble_info *outf)
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



  if (aop == 0 && sz == 0 && Z == 0 && W == 0)
    {
      notethat ("dregs = [ pregs ++ ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 0 && sz == 0 && Z == 1 && W == 0)
    {
      notethat ("pregs = [ pregs ++ ]");
      OUTS (outf, pregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 0 && sz == 1 && Z == 0 && W == 0)
    {
      notethat ("dregs = W [ pregs ++ ] (z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "] (Z)");
      return 1 * 2;
    }
  else if (aop == 0 && sz == 1 && Z == 1 && W == 0)
    {
      notethat ("dregs = W [ pregs ++ ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (aop == 0 && sz == 2 && Z == 0 && W == 0)
    {
      notethat ("dregs = B [ pregs ++ ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "] (Z)");
      return 1 * 2;
    }
  else if (aop == 0 && sz == 2 && Z == 1 && W == 0)
    {
      notethat ("dregs = B [ pregs ++ ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (aop == 1 && sz == 0 && Z == 0 && W == 0)
    {
      notethat ("dregs = [ pregs -- ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 1 && sz == 0 && Z == 1 && W == 0)
    {
      notethat ("pregs = [ pregs -- ]");
      OUTS (outf, pregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 1 && sz == 1 && Z == 0 && W == 0)
    {
      notethat ("dregs = W [ pregs -- ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "] (Z)");
      return 1 * 2;
    }
  else if (aop == 1 && sz == 1 && Z == 1 && W == 0)
    {
      notethat ("dregs = W [ pregs -- ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (aop == 1 && sz == 2 && Z == 0 && W == 0)
    {
      notethat ("dregs = B [ pregs -- ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "] (Z)");
      return 1 * 2;
    }
  else if (aop == 1 && sz == 2 && Z == 1 && W == 0)
    {
      notethat ("dregs = B [ pregs -- ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (aop == 2 && sz == 0 && Z == 0 && W == 0)
    {
      notethat ("dregs = [ pregs ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 2 && sz == 0 && Z == 1 && W == 0)
    {
      notethat ("pregs = [ pregs ]");
      OUTS (outf, pregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (aop == 2 && sz == 1 && Z == 0 && W == 0)
    {
      notethat ("dregs = W [ pregs ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "] (Z)");
      return 1 * 2;
    }
  else if (aop == 2 && sz == 1 && Z == 1 && W == 0)
    {
      notethat ("dregs = W [ pregs ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (aop == 2 && sz == 2 && Z == 0 && W == 0)
    {
      notethat ("dregs = B [ pregs ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "] (Z)");
      return 1 * 2;
    }
  else if (aop == 2 && sz == 2 && Z == 1 && W == 0)
    {
      notethat ("dregs = B [ pregs ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (aop == 0 && sz == 0 && Z == 0 && W == 1)
    {
      notethat ("[ pregs ++ ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 0 && sz == 0 && Z == 1 && W == 1)
    {
      notethat ("[ pregs ++ ] = pregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, pregs (reg));
      return 1 * 2;
    }
  else if (aop == 0 && sz == 1 && Z == 0 && W == 1)
    {
      notethat ("W [ pregs ++ ] = dregs");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 0 && sz == 2 && Z == 0 && W == 1)
    {
      notethat ("B [ pregs ++ ] = dregs");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "++");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 1 && sz == 0 && Z == 0 && W == 1)
    {
      notethat ("[ pregs -- ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 1 && sz == 0 && Z == 1 && W == 1)
    {
      notethat ("[ pregs -- ] = pregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, pregs (reg));
      return 1 * 2;
    }
  else if (aop == 1 && sz == 1 && Z == 0 && W == 1)
    {
      notethat ("W [ pregs -- ] = dregs");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 1 && sz == 2 && Z == 0 && W == 1)
    {
      notethat ("B [ pregs -- ] = dregs");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "--");
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 2 && sz == 0 && Z == 0 && W == 1)
    {
      notethat ("[ pregs ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 2 && sz == 0 && Z == 1 && W == 1)
    {
      notethat ("[ pregs ] = pregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, pregs (reg));
      return 1 * 2;
    }
  else if (aop == 2 && sz == 1 && Z == 0 && W == 1)
    {
      notethat ("W [ pregs ] = dregs");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (aop == 2 && sz == 2 && Z == 0 && W == 1)
    {
      notethat ("B [ pregs ] = dregs");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_LDSTiiFP_0 (TIword iw0, disassemble_info *outf)
{
/* LDSTiiFP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 | 1 | 1 | 0 |.W.|.offset............|.reg...........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int reg = ((iw0 >> 0) & 0xf);
  int offset = ((iw0 >> 4) & 0x1f);
  int W = ((iw0 >> 9) & 0x1);



  if (W == 0)
    {
      notethat ("dpregs = [ FP - negimm5s4 ]");
      OUTS (outf, dpregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, "FP");
      /* negimm5s4 will print the minus sign; no need to print anything
         here.  */
      OUTS (outf, negimm5s4 (offset));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (W == 1)
    {
      notethat ("[ FP - negimm5s4 ] = dpregs");
      OUTS (outf, "[");
      OUTS (outf, "FP");
      /* negimm5s4 will print the minus sign; no need to print anything
         here.  */
      OUTS (outf, negimm5s4 (offset));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dpregs (reg));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_LDSTii_0 (TIword iw0, disassemble_info *outf)
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



  if (W == 0 && op == 0)
    {
      notethat ("dregs = [ pregs + uimm4s4 ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, uimm4s4 (offset));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (W == 0 && op == 1)
    {
      notethat ("dregs = W [ pregs + uimm4s2 ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, uimm4s2 (offset));
      OUTS (outf, "] (Z)");
      return 1 * 2;
    }
  else if (W == 0 && op == 2)
    {
      notethat ("dregs = W [ pregs + uimm4s2 ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, uimm4s2 (offset));
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (W == 0 && op == 3)
    {
      notethat ("pregs = [ pregs + uimm4s4 ]");
      OUTS (outf, pregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, uimm4s4 (offset));
      OUTS (outf, "]");
      return 1 * 2;
    }
  else if (W == 1 && op == 0)
    {
      notethat ("[ pregs + uimm4s4 ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, uimm4s4 (offset));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (W == 1 && op == 1)
    {
      notethat ("W [ pregs + uimm4s2 ] = dregs");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, uimm4s2 (offset));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (W == 1 && op == 3)
    {
      notethat ("[ pregs + uimm4s4 ] = pregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, uimm4s4 (offset));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, pregs (reg));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_LoopSetup_0 (TIword iw0, TIword iw1, bfd_vma pc, disassemble_info *outf)
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



  if (rop == 0)
    {
      notethat ("LSETUP ( pcrel4 , lppcrel10 ) counters");
      OUTS (outf, "LSETUP");
      OUTS (outf, "(");
      OUTS (outf, pcrel4 (soffset));
      OUTS (outf, ",");
      OUTS (outf, lppcrel10 (eoffset));
      OUTS (outf, ")");
      OUTS (outf, counters (c));
      return 2 * 2;
    }
  else if (rop == 1)
    {
      notethat ("LSETUP ( pcrel4 , lppcrel10 ) counters = pregs");
      OUTS (outf, "LSETUP");
      OUTS (outf, "(");
      OUTS (outf, pcrel4 (soffset));
      OUTS (outf, ",");
      OUTS (outf, lppcrel10 (eoffset));
      OUTS (outf, ")");
      OUTS (outf, counters (c));
      OUTS (outf, "=");
      OUTS (outf, pregs (reg));
      return 2 * 2;
    }
  else if (rop == 3)
    {
      notethat ("LSETUP ( pcrel4 , lppcrel10 ) counters = pregs >> 1");
      OUTS (outf, "LSETUP");
      OUTS (outf, "(");
      OUTS (outf, pcrel4 (soffset));
      OUTS (outf, ",");
      OUTS (outf, lppcrel10 (eoffset));
      OUTS (outf, ")");
      OUTS (outf, counters (c));
      OUTS (outf, "=");
      OUTS (outf, pregs (reg));
      OUTS (outf, ">>");
      OUTS (outf, "1");
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_LDIMMhalf_0 (TIword iw0, TIword iw1, disassemble_info *outf)
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



  if (grp == 0 && H == 0 && S == 0 && Z == 0)
    {
      notethat ("dregs_lo = imm16");
      OUTS (outf, dregs_lo (reg));
      OUTS (outf, "=");
      OUTS (outf, imm16 (hword));
      return 2 * 2;
    }
  else if (grp == 0 && H == 1 && S == 0 && Z == 0)
    {
      notethat ("dregs_hi = imm16");
      OUTS (outf, dregs_hi (reg));
      OUTS (outf, "=");
      OUTS (outf, imm16 (hword));
      return 2 * 2;
    }
  else if (grp == 0 && H == 0 && S == 1 && Z == 0)
    {
      notethat ("dregs = imm16 (x)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, imm16 (hword));
      OUTS (outf, " (X)");
      return 2 * 2;
    }
  else if (H == 0 && S == 1 && Z == 0)
    {
      notethat ("regs = imm16 (x)");
      OUTS (outf, regs (reg, grp));
      OUTS (outf, "=");
      OUTS (outf, imm16 (hword));
      OUTS (outf, " (X)");
      return 2 * 2;
    }
  else if (H == 0 && S == 0 && Z == 1)
    {
      notethat ("regs = luimm16 (Z)");
      OUTS (outf, regs (reg, grp));
      OUTS (outf, "=");
      OUTS (outf, luimm16 (hword));
      OUTS (outf, "(");
      OUTS (outf, "Z");
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (H == 0 && S == 0 && Z == 0)
    {
      notethat ("regs_lo = luimm16");
      OUTS (outf, regs_lo (reg, grp));
      OUTS (outf, "=");
      OUTS (outf, luimm16 (hword));
      return 2 * 2;
    }
  else if (H == 1 && S == 0 && Z == 0)
    {
      notethat ("regs_hi = huimm16");
      OUTS (outf, regs_hi (reg, grp));
      OUTS (outf, "=");
      OUTS (outf, huimm16 (hword));
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_CALLa_0 (TIword iw0, TIword iw1, bfd_vma pc, disassemble_info *outf)
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



/*printf ("\nLOW OFFSET = %d \n", lsw);
printf ("\nHIGH OFFSET = %d \n", msw);*/
  if (S == 1)
    {
      notethat ("CALL  pcrel24");
      OUTS (outf, "CALL  ");
      OUTS (outf, pcrel24 (((msw) << 16) | (lsw)));
      return 2 * 2;
    }
  else if (S == 0)
    {
      notethat ("JUMP.L  pcrel24");
      OUTS (outf, "JUMP.L  ");
      OUTS (outf, pcrel24 (((msw) << 16) | (lsw)));
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_LDSTidxI_0 (TIword iw0, TIword iw1, disassemble_info *outf)
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



  if (W == 0 && sz == 0 && Z == 0)
    {
      notethat ("dregs = [ pregs + imm16s4 ]");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16s4 (offset));
      OUTS (outf, "]");
      return 2 * 2;
    }
  else if (W == 0 && sz == 0 && Z == 1)
    {
      notethat ("pregs = [ pregs + imm16s4 ]");
      OUTS (outf, pregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16s4 (offset));
      OUTS (outf, "]");
      return 2 * 2;
    }
  else if (W == 0 && sz == 1 && Z == 0)
    {
      notethat ("dregs = W [ pregs + imm16s2 ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16s2 (offset));
      OUTS (outf, "] (Z)");
      return 2 * 2;
    }
  else if (W == 0 && sz == 1 && Z == 1)
    {
      notethat ("dregs = W [ pregs + imm16s2 ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16s2 (offset));
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (W == 0 && sz == 2 && Z == 0)
    {
      notethat ("dregs = B [ pregs + imm16 ] (Z)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16 (offset));
      OUTS (outf, "] (Z)");
      return 2 * 2;
    }
  else if (W == 0 && sz == 2 && Z == 1)
    {
      notethat ("dregs = B [ pregs + imm16 ] (X)");
      OUTS (outf, dregs (reg));
      OUTS (outf, "=");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16 (offset));
      OUTS (outf, "]");
      OUTS (outf, "(");
      OUTS (outf, "X");
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (W == 1 && sz == 0 && Z == 0)
    {
      notethat ("[ pregs + imm16s4 ] = dregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16s4 (offset));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 2 * 2;
    }
  else if (W == 1 && sz == 0 && Z == 1)
    {
      notethat ("[ pregs + imm16s4 ] = pregs");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16s4 (offset));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, pregs (reg));
      return 2 * 2;
    }
  else if (W == 1 && sz == 1 && Z == 0)
    {
      notethat ("W [ pregs + imm16s2 ] = dregs");
      OUTS (outf, "W");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16s2 (offset));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 2 * 2;
    }
  else if (W == 1 && sz == 2 && Z == 0)
    {
      notethat ("B [ pregs + imm16 ] = dregs");
      OUTS (outf, "B");
      OUTS (outf, "[");
      OUTS (outf, pregs (ptr));
      OUTS (outf, "+");
      OUTS (outf, imm16 (offset));
      OUTS (outf, "]");
      OUTS (outf, "=");
      OUTS (outf, dregs (reg));
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_linkage_0 (TIword iw0, TIword iw1, disassemble_info *outf)
{
/* linkage
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.R.|
|.framesize.....................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int R = ((iw0 >> 0) & 0x1);
  int framesize = ((iw1 >> 0) & 0xffff);



  if (R == 0)
    {
      notethat ("LINK uimm16s4");
      OUTS (outf, "LINK ");
      OUTS (outf, uimm16s4 (framesize));
      return 2 * 2;
    }
  else if (R == 1)
    {
      notethat ("UNLINK");
      OUTS (outf, "UNLINK");
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_dsp32mac_0 (TIword iw0, TIword iw1, disassemble_info *outf)
{
/* dsp32mac
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int op1 = ((iw0 >> 0) & 0x3);
  int w1 = ((iw0 >> 2) & 0x1);
  int P = ((iw0 >> 3) & 0x1);
  int MM = ((iw0 >> 4) & 0x1);
  int mmod = ((iw0 >> 5) & 0xf);
  int M = ((iw0 >> 11) & 0x1);

  int w0 = ((iw1 >> 13) & 0x1);
  int src1 = ((iw1 >> 0) & 0x7);
  int src0 = ((iw1 >> 3) & 0x7);
  int dst = ((iw1 >> 6) & 0x7);
  int h10 = ((iw1 >> 9) & 0x1);
  int h00 = ((iw1 >> 10) & 0x1);
  int op0 = ((iw1 >> 11) & 0x3);
  int h11 = ((iw1 >> 14) & 0x1);
  int h01 = ((iw1 >> 15) & 0x1);

  if (w0 == 0 && w1 == 0 && op1 == 3 && op0 == 3)
    return 0;

  if ((op1 == 3 || w1 == 0) && MM)
    return 0;

  if (((1 << mmod) & (P ? 0x313 : 0x1b57)) == 0)
    return 0;

  if (w1 == 1 || op1 != 3)
    {
      if (w1)
	OUTS (outf, P ? dregs (dst + 1) : dregs_hi (dst));

      if (op1 == 3)
	OUTS (outf, " = A1");
      else
	{
	  if (w1)
	    OUTS (outf, " = (");
	  decode_macfunc (1, op1, h01, h11, src0, src1, outf);
	  if (w1)
	    OUTS (outf, ")");
	}

      if (w0 == 1 || op0 != 3)
	{
	  if (MM)
	    OUTS (outf, " (M)");
	  MM = 0;
	  OUTS (outf, ", ");
	}
    }

  if (w0 == 1 || op0 != 3)
    {
      if (w0)
	OUTS (outf, P ? dregs (dst) : dregs_lo (dst));

      if (op0 == 3)
	OUTS (outf, " = A0");
      else
	{
	  if (w0)
	    OUTS (outf, " = (");
	  decode_macfunc (0, op0, h00, h10, src0, src1, outf);
	  if (w0)
	    OUTS (outf, ")");
	}
    }

  decode_optmode (mmod, MM, outf);

  return 4;
}

static int
decode_dsp32mult_0 (TIword iw0, TIword iw1, disassemble_info *outf)
{
/* dsp32mult
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int op1 = ((iw0 >> 0) & 0x3);
  int w1 = ((iw0 >> 2) & 0x1);
  int P = ((iw0 >> 3) & 0x1);
  int MM = ((iw0 >> 4) & 0x1);
  int mmod = ((iw0 >> 5) & 0xf);
  int M = ((iw0 >> 11) & 0x1);

  int src1 = ((iw1 >> 0) & 0x7);
  int src0 = ((iw1 >> 3) & 0x7);
  int dst = ((iw1 >> 6) & 0x7);
  int h10 = ((iw1 >> 9) & 0x1);
  int h00 = ((iw1 >> 10) & 0x1);
  int op0 = ((iw1 >> 11) & 0x3);
  int w0 = ((iw1 >> 13) & 0x1);
  int h01 = ((iw1 >> 15) & 0x1);
  int h11 = ((iw1 >> 14) & 0x1);

  if (w1 == 0 && w0 == 0)
    return 0;
  if (((1 << mmod) & (P ? 0x313 : 0x1b57)) == 0)
    return 0;
  
  if (w1)
    {			// odd dreg assignment
      OUTS (outf, P ? dregs (dst | 1) : dregs_hi (dst));
      OUTS (outf, " = ");
      decode_multfunc (h01, h11, src0, src1, outf);

      if (w0)
	{
	  if (MM)
	    OUTS (outf, " (M)");
	  MM = 0;
	  OUTS (outf, ", ");
	}
    }

  if (w0)
    {
      OUTS (outf, dregs (dst));
      OUTS (outf, " = ");
      decode_multfunc (h00, h10, src0, src1, outf);
    }

  decode_optmode (mmod, MM, outf);
  return 4;
}

static int
decode_dsp32alu_0 (TIword iw0, TIword iw1, disassemble_info *outf)
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
#if 0				/* commented out as it is not used currently */
  int M = ((iw0 >> 11) & 0x1);
#endif



  if (aop == 0 && aopcde == 9 && HL == 0 && s == 0)
    {
      notethat ("A0.L = dregs_lo");
      OUTS (outf, "A0.L");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 9 && HL == 1 && s == 0)
    {
      notethat ("A1.H = dregs_hi");
      OUTS (outf, "A1.H");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 9 && HL == 0 && s == 0)
    {
      notethat ("A1.L = dregs_lo");
      OUTS (outf, "A1.L");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 9 && HL == 1 && s == 0)
    {
      notethat ("A0.H = dregs_hi");
      OUTS (outf, "A0.H");
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      return 2 * 2;
    }
  else if (x == 1 && HL == 1 && aop == 3 && aopcde == 5)
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
      return 2 * 2;
    }
  else if (x == 1 && HL == 1 && aop == 2 && aopcde == 5)
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
      return 2 * 2;
    }
  else if (x == 0 && HL == 0 && aop == 1 && aopcde == 5)
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
      return 2 * 2;
    }
  else if (x == 0 && HL == 0 && aop == 0 && aopcde == 5)
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
      return 2 * 2;
    }
  else if (x == 1 && HL == 0 && aop == 3 && aopcde == 5)
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
      return 2 * 2;
    }
  else if (x == 0 && HL == 1 && aop == 0 && aopcde == 5)
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
      return 2 * 2;
    }
  else if (x == 1 && HL == 0 && aop == 2 && aopcde == 5)
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
      return 2 * 2;
    }
  else if (x == 0 && HL == 1 && aop == 1 && aopcde == 5)
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
      return 2 * 2;
    }
  else if (HL == 1 && aop == 0 && aopcde == 2)
    {
      notethat ("dregs_hi = dregs_lo + dregs_lo amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 1 && aop == 1 && aopcde == 2)
    {
      notethat ("dregs_hi = dregs_lo + dregs_hi amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 1 && aop == 2 && aopcde == 2)
    {
      notethat ("dregs_hi = dregs_hi + dregs_lo amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 1 && aop == 3 && aopcde == 2)
    {
      notethat ("dregs_hi = dregs_hi + dregs_hi amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aop == 0 && aopcde == 3)
    {
      notethat ("dregs_lo = dregs_lo - dregs_lo amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aop == 1 && aopcde == 3)
    {
      notethat ("dregs_lo = dregs_lo - dregs_hi amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aop == 3 && aopcde == 2)
    {
      notethat ("dregs_lo = dregs_hi + dregs_hi amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 1 && aop == 0 && aopcde == 3)
    {
      notethat ("dregs_hi = dregs_lo - dregs_lo amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 1 && aop == 1 && aopcde == 3)
    {
      notethat ("dregs_hi = dregs_lo - dregs_hi amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 1 && aop == 2 && aopcde == 3)
    {
      notethat ("dregs_hi = dregs_hi - dregs_lo amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 1 && aop == 3 && aopcde == 3)
    {
      notethat ("dregs_hi = dregs_hi - dregs_hi amod1");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aop == 2 && aopcde == 2)
    {
      notethat ("dregs_lo = dregs_hi + dregs_lo amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aop == 1 && aopcde == 2)
    {
      notethat ("dregs_lo = dregs_lo + dregs_hi amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aop == 2 && aopcde == 3)
    {
      notethat ("dregs_lo = dregs_hi - dregs_lo amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aop == 3 && aopcde == 3)
    {
      notethat ("dregs_lo = dregs_hi - dregs_hi amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aop == 0 && aopcde == 2)
    {
      notethat ("dregs_lo = dregs_lo + dregs_lo amod1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 9 && s == 1)
    {
      notethat ("A0 = dregs");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      return 2 * 2;
    }
  else if (aop == 3 && aopcde == 11 && s == 0)
    {
      notethat ("A0 -= A1");
      OUTS (outf, "A0");
      OUTS (outf, "-=");
      OUTS (outf, "A1");
      return 2 * 2;
    }
  else if (aop == 3 && aopcde == 11 && s == 1)
    {
      notethat ("A0 -= A1 (W32)");
      OUTS (outf, "A0");
      OUTS (outf, "-=");
      OUTS (outf, "A1");
      OUTS (outf, "(W32)");
      return 2 * 2;
    }
  else if (aop == 3 && aopcde == 22 && HL == 1)
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
      return 2 * 2;
    }
  else if (aop == 3 && aopcde == 22 && HL == 0)
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
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 22 && HL == 1)
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
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 22 && HL == 0)
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
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 22 && HL == 1)
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
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 22 && HL == 0)
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
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 22 && HL == 1)
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
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 22 && HL == 0)
    {
      notethat ("dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDL , aligndir)");
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
      return 2 * 2;
    }
  else if (aop == 0 && s == 0 && aopcde == 8)
    {
      notethat ("A0 = 0");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "0");
      return 2 * 2;
    }
  else if (aop == 0 && s == 1 && aopcde == 8)
    {
      notethat ("A0 = A0 (S)");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (aop == 1 && s == 0 && aopcde == 8)
    {
      notethat ("A1 = 0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "0");
      return 2 * 2;
    }
  else if (aop == 1 && s == 1 && aopcde == 8)
    {
      notethat ("A1 = A1 (S)");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (aop == 2 && s == 0 && aopcde == 8)
    {
      notethat ("A1 = A0 = 0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "0");
      return 2 * 2;
    }
  else if (aop == 2 && s == 1 && aopcde == 8)
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
      return 2 * 2;
    }
  else if (aop == 3 && s == 0 && aopcde == 8)
    {
      notethat ("A0 = A1");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      return 2 * 2;
    }
  else if (aop == 3 && s == 1 && aopcde == 8)
    {
      notethat ("A1 = A0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 9 && s == 0)
    {
      notethat ("A0.x = dregs_lo");
      OUTS (outf, "A0.x");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (aop == 1 && HL == 0 && aopcde == 11)
    {
      notethat ("dregs_lo = ( A0 += A1 )");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (aop == 3 && HL == 0 && aopcde == 16)
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
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 23 && HL == 1)
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
      return 2 * 2;
    }
  else if (aop == 3 && aopcde == 9 && s == 0)
    {
      notethat ("A1.x = dregs_lo");
      OUTS (outf, "A1.x");
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (aop == 1 && HL == 1 && aopcde == 16)
    {
      notethat ("A1 = ABS A1");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A1");
      return 2 * 2;
    }
  else if (aop == 0 && HL == 1 && aopcde == 16)
    {
      notethat ("A1 = ABS A0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A0");
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 9 && s == 1)
    {
      notethat ("A1 = dregs");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      return 2 * 2;
    }
  else if (HL == 0 && aop == 3 && aopcde == 12)
    {
      notethat ("dregs_lo = dregs (RND)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(RND)");
      return 2 * 2;
    }
  else if (aop == 1 && HL == 0 && aopcde == 16)
    {
      notethat ("A0 = ABS A1");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A1");
      return 2 * 2;
    }
  else if (aop == 0 && HL == 0 && aopcde == 16)
    {
      notethat ("A0 = ABS A0");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, "A0");
      return 2 * 2;
    }
  else if (aop == 3 && HL == 0 && aopcde == 15)
    {
      notethat ("dregs = - dregs (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(V)");
      return 2 * 2;
    }
  else if (aop == 1 && HL == 1 && aopcde == 11)
    {
      notethat ("dregs_hi = ( A0 += A1 )");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 11 && s == 0)
    {
      notethat ("A0 += A1");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 11 && s == 1)
    {
      notethat ("A0 += A1 (W32)");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      OUTS (outf, "(W32)");
      return 2 * 2;
    }
  else if (aop == 3 && HL == 0 && aopcde == 14)
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
      return 2 * 2;
    }
  else if (HL == 1 && aop == 3 && aopcde == 12)
    {
      notethat ("dregs_hi = dregs (RND)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(RND)");
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 23 && HL == 0)
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
      return 2 * 2;
    }
  else if (aop == 0 && HL == 0 && aopcde == 14)
    {
      notethat ("A0 = - A0");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A0");
      return 2 * 2;
    }
  else if (aop == 1 && HL == 0 && aopcde == 14)
    {
      notethat ("A0 = - A1");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A1");
      return 2 * 2;
    }
  else if (aop == 0 && HL == 1 && aopcde == 14)
    {
      notethat ("A1 = - A0");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A0");
      return 2 * 2;
    }
  else if (aop == 1 && HL == 1 && aopcde == 14)
    {
      notethat ("A1 = - A1");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "-");
      OUTS (outf, "A1");
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 12)
    {
      notethat ("dregs_hi=dregs_lo=SIGN(dregs_hi)*dregs_hi + SIGN(dregs_lo)*dregs_lo)");
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
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 0)
    {
      notethat ("dregs = dregs -|+ dregs amod0");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-|+");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod0 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 12)
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
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 4)
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
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (HL == 0 && aopcde == 1)
    {
      notethat ("dregs = dregs +|+ dregs , dregs = dregs -|- dregs (amod0, amod2)");
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
      if (s == 1 && x == 0 && aop == 2)
	OUTS (outf, "(S, ASR)");
      else if (s == 1 && x == 0 && aop == 3)
	OUTS (outf, "(S, ASL)");
      else if (s == 0 && x == 0 && aop == 2)
	OUTS (outf, "(ASR)");
      else if (s == 0 && x == 0 && aop == 3)
	OUTS (outf, "(ASL)");
      else
	OUTS (outf, "");
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 11)
    {
      notethat ("dregs = ( A0 += A1 )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "(");
      OUTS (outf, "A0");
      OUTS (outf, "+=");
      OUTS (outf, "A1");
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 10)
    {
      notethat ("dregs_lo = A0.x");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "A0.x");
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 10)
    {
      notethat ("dregs_lo = A1.x");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "A1.x");
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 0)
    {
      notethat ("dregs = dregs +|- dregs amod0");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+|-");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod0 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 3 && aopcde == 0)
    {
      notethat ("dregs = dregs -|- dregs amod0");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-|-");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod0 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 4)
    {
      notethat ("dregs = dregs - dregs amod1");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "-");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 17)
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
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 17)
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
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 18)
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
      aligndir (s, outf);
      return 2 * 2;
    }
  else if (aop == 3 && aopcde == 18)
    {
      notethat ("DISALGNEXCPT");
      OUTS (outf, "DISALGNEXCPT");
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 20)
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
      aligndir (s, outf);
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 20)
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
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 21)
    {
      notethat ("( dregs , dregs ) = BYTEOP16P ( dregs_pair , dregs_pair ) aligndir");
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
      aligndir (s, outf);
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 21)
    {
      notethat ("( dregs , dregs ) = BYTEOP16M ( dregs_pair , dregs_pair ) aligndir");
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
      aligndir (s, outf);
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 7)
    {
      notethat ("dregs = ABS dregs");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, dregs (src0));
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 7)
    {
      notethat ("dregs = MIN ( dregs , dregs )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "MIN");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 7)
    {
      notethat ("dregs = MAX ( dregs , dregs )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "MAX");
      OUTS (outf, "(");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (aop == 2 && aopcde == 6)
    {
      notethat ("dregs = ABS dregs (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ABS");
      OUTS (outf, dregs (src0));
      OUTS (outf, "(V)");
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 6)
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
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 6)
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
      return 2 * 2;
    }
  else if (HL == 1 && aopcde == 1)
    {
      notethat ("dregs = dregs +|- dregs, dregs = dregs -|+ dregs (amod0, amod2)");
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
      if (s == 1 && x == 0 && aop == 2)
	OUTS (outf, "(S, ASR)");
      else if (s == 1 && x == 0 && aop == 3)
	OUTS (outf, "(S, ASL)");
      else if (s == 0 && x == 0 && aop == 2)
	OUTS (outf, "(ASR)");
      else if (s == 0 && x == 0 && aop == 3)
	OUTS (outf, "(ASL)");
      else
	OUTS (outf, "");
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 4)
    {
      notethat ("dregs = dregs + dregs amod1");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod1 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 0)
    {
      notethat ("dregs = dregs +|+ dregs amod0");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src0));
      OUTS (outf, "+|+");
      OUTS (outf, dregs (src1));
      OUTS (outf, " ");
      amod0 (s, x, outf);
      return 2 * 2;
    }
  else if (aop == 0 && aopcde == 24)
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
      return 2 * 2;
    }
  else if (aop == 1 && aopcde == 24)
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
      aligndir (s, outf);
      return 2 * 2;
    }
  else if (aopcde == 13)
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
      searchmod (aop, outf);
      OUTS (outf, ")");
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_dsp32shift_0 (TIword iw0, TIword iw1, disassemble_info *outf)
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
#if 0				/* commented out as it is not used currently */
  int M = ((iw0 >> 11) & 0x1);
#endif
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);



  if (HLs == 0 && sop == 0 && sopcde == 0)
    {
      notethat ("dregs_lo = ASHIFT dregs_lo BY dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (HLs == 1 && sop == 0 && sopcde == 0)
    {
      notethat ("dregs_lo = ASHIFT dregs_hi BY dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (HLs == 2 && sop == 0 && sopcde == 0)
    {
      notethat ("dregs_hi = ASHIFT dregs_lo BY dregs_lo");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (HLs == 3 && sop == 0 && sopcde == 0)
    {
      notethat ("dregs_hi = ASHIFT dregs_hi BY dregs_lo");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (HLs == 0 && sop == 1 && sopcde == 0)
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
      return 2 * 2;
    }
  else if (HLs == 1 && sop == 1 && sopcde == 0)
    {
      notethat ("dregs_lo = ASHIFT dregs_hi BY dregs_lo (S)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (HLs == 2 && sop == 1 && sopcde == 0)
    {
      notethat ("dregs_hi = ASHIFT dregs_lo BY dregs_lo (S)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (HLs == 3 && sop == 1 && sopcde == 0)
    {
      notethat ("dregs_hi = ASHIFT dregs_hi BY dregs_lo (S)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (HLs == 0 && sop == 2 && sopcde == 0)
    {
      notethat ("dregs_lo = LSHIFT dregs_lo BY dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (HLs == 1 && sop == 2 && sopcde == 0)
    {
      notethat ("dregs_lo = LSHIFT dregs_hi BY dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (HLs == 2 && sop == 2 && sopcde == 0)
    {
      notethat ("dregs_hi = LSHIFT dregs_lo BY dregs_lo");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (HLs == 3 && sop == 2 && sopcde == 0)
    {
      notethat ("dregs_hi = LSHIFT dregs_hi BY dregs_lo");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 3 && HLs == 1)
    {
      notethat ("A1 = ROT A1 BY dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, "A1");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 3 && HLs == 0)
    {
      notethat ("A0 = ASHIFT A0 BY dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, "A0");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 3 && HLs == 1)
    {
      notethat ("A1 = ASHIFT A1 BY dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, "A1");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 3 && HLs == 0)
    {
      notethat ("A0 = LSHIFT A0 BY dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, "A0");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 3 && HLs == 1)
    {
      notethat ("A1 = LSHIFT A1 BY dregs_lo");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "LSHIFT");
      OUTS (outf, "A1");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 3 && HLs == 0)
    {
      notethat ("A0 = ROT A0 BY dregs_lo");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, "A0");
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 1)
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
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 1)
    {
      notethat ("dregs = ASHIFT dregs BY dregs_lo (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(V)");
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 2)
    {
      notethat ("dregs = ASHIFT dregs BY dregs_lo");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 2)
    {
      notethat ("dregs = ASHIFT dregs BY dregs_lo (S)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ASHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 2)
    {
      notethat ("dregs = SHIFT dregs BY dregs_lo");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 3 && sopcde == 2)
    {
      notethat ("dregs = ROT dregs BY dregs_lo");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 1)
    {
      notethat ("dregs = SHIFT dregs BY dregs_lo (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SHIFT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, "(V)");
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 4)
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
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 4)
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
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 4)
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
      return 2 * 2;
    }
  else if (sop == 3 && sopcde == 4)
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
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 5)
    {
      notethat ("dregs_lo = SIGNBITS dregs");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, dregs (src1));
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 5)
    {
      notethat ("dregs_lo = SIGNBITS dregs_lo");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, dregs_lo (src1));
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 5)
    {
      notethat ("dregs_lo = SIGNBITS dregs_hi");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, dregs_hi (src1));
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 6)
    {
      notethat ("dregs_lo = SIGNBITS A0");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, "A0");
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 6)
    {
      notethat ("dregs_lo = SIGNBITS A1");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "SIGNBITS");
      OUTS (outf, "A1");
      return 2 * 2;
    }
  else if (sop == 3 && sopcde == 6)
    {
      notethat ("dregs_lo = ONES dregs");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ONES");
      OUTS (outf, dregs (src1));
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 7)
    {
      notethat ("dregs_lo = EXPADJ (dregs , dregs_lo)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXPADJ (");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 7)
    {
      notethat ("dregs_lo = EXPADJ (dregs , dregs_lo) (V)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXPADJ (");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ") (V)");
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 7)
    {
      notethat ("dregs_lo = EXPADJ (dregs_lo , dregs_lo)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXPADJ (");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (sop == 3 && sopcde == 7)
    {
      notethat ("dregs_lo = EXPADJ (dregs_hi , dregs_lo)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "EXPADJ (");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs_lo (src0));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 8)
    {
      notethat ("BITMUX (dregs , dregs , A0) (ASR)");
      OUTS (outf, "BITMUX (");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, "A0 )");
      OUTS (outf, "(ASR)");
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 8)
    {
      notethat ("BITMUX (dregs , dregs , A0) (ASL)");
      OUTS (outf, "BITMUX (");
      OUTS (outf, dregs (src0));
      OUTS (outf, ",");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, "A0 )");
      OUTS (outf, "(ASL)");
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 9)
    {
      notethat ("dregs_lo = VIT_MAX (dregs) (ASL)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "VIT_MAX (");
      OUTS (outf, dregs (src1));
      OUTS (outf, ") (ASL)");
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 9)
    {
      notethat ("dregs_lo = VIT_MAX (dregs) (ASR)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, "VIT_MAX (");
      OUTS (outf, dregs (src1));
      OUTS (outf, ") (ASR)");
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 9)
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
      return 2 * 2;
    }
  else if (sop == 3 && sopcde == 9)
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
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 10)
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
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 10)
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
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 10)
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
      return 2 * 2;
    }
  else if (sop == 3 && sopcde == 10)
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
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 11)
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
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 11)
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
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 12)
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
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 12)
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
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 13)
    {
      notethat ("dregs = ALIGN8 ( dregs , dregs )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ALIGN8");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 13)
    {
      notethat ("dregs = ALIGN16 ( dregs , dregs )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ALIGN16");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 13)
    {
      notethat ("dregs = ALIGN24 ( dregs , dregs )");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ALIGN24");
      OUTS (outf, "(");
      OUTS (outf, dregs (src1));
      OUTS (outf, ",");
      OUTS (outf, dregs (src0));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_dsp32shiftimm_0 (TIword iw0, TIword iw1, disassemble_info *outf)
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
#if 0				/* commented out as it is not used currently */
  int M = ((iw0 >> 11) & 0x1);
#endif
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);



  if (HLs == 0 && sop == 0 && sopcde == 0)
    {
      notethat ("dregs_lo = dregs_lo << uimm5");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "<<");
      OUTS (outf, uimm5 (immag));
      return 2 * 2;
    }
  else if (HLs == 1 && sop == 0 && sopcde == 0)
    {
      notethat ("dregs_lo = dregs_hi << uimm5");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "<<");
      OUTS (outf, uimm5 (immag));
      return 2 * 2;
    }
  else if (HLs == 2 && sop == 0 && sopcde == 0)
    {
      notethat ("dregs_hi = dregs_lo << uimm5");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, "<<");
      OUTS (outf, uimm5 (immag));
      return 2 * 2;
    }
  else if (HLs == 3 && sop == 0 && sopcde == 0)
    {
      notethat ("dregs_hi = dregs_hi << uimm5");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, "<<");
      OUTS (outf, uimm5 (immag));
      return 2 * 2;
    }
  else if (HLs == 0 && sop == 1 && sopcde == 0)
    {
      notethat ("dregs_lo = dregs_lo << imm5 (S)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (HLs == 1 && sop == 1 && sopcde == 0)
    {
      notethat ("dregs_lo = dregs_hi << imm5 (S)");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (HLs == 2 && sop == 1 && sopcde == 0)
    {
      notethat ("dregs_hi = dregs_lo << imm5 (S)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (HLs == 3 && sop == 1 && sopcde == 0)
    {
      notethat ("dregs_hi = dregs_hi << imm5 (S)");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, "(S)");
      return 2 * 2;
    }
  else if (HLs == 0 && sop == 2 && sopcde == 0)
    {
      notethat ("dregs_lo = dregs_lo >> uimm5");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ">>");
      OUTS (outf, uimm5 (newimmag));
      return 2 * 2;
    }
  else if (HLs == 1 && sop == 2 && sopcde == 0)
    {
      notethat ("dregs_lo = dregs_hi >> uimm5");
      OUTS (outf, dregs_lo (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, ">>");
      OUTS (outf, uimm5 (newimmag));
      return 2 * 2;
    }
  else if (HLs == 2 && sop == 2 && sopcde == 0)
    {
      notethat ("dregs_hi = dregs_lo >> uimm5");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_lo (src1));
      OUTS (outf, ">>");
      OUTS (outf, uimm5 (newimmag));
      return 2 * 2;
    }
  else if (HLs == 3 && sop == 2 && sopcde == 0)
    {
      notethat ("dregs_hi = dregs_hi >> uimm5");
      OUTS (outf, dregs_hi (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs_hi (src1));
      OUTS (outf, ">>");
      OUTS (outf, uimm5 (newimmag));
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 3 && HLs == 1)
    {
      notethat ("A1 = ROT A1 BY imm6");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, "A1");
      OUTS (outf, "BY");
      OUTS (outf, imm6 (immag));
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 3 && HLs == 0)
    {
      notethat ("A0 = A0 << imm6");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, "<<");
      OUTS (outf, imm6 (immag));
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 3 && HLs == 1)
    {
      notethat ("A1 = A1 << imm6");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, "<<");
      OUTS (outf, imm6 (immag));
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 3 && HLs == 0)
    {
      notethat ("A0 = A0 >> imm6");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "A0");
      OUTS (outf, ">>");
      OUTS (outf, imm6 (newimmag));
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 3 && HLs == 1)
    {
      notethat ("A1 = A1 >> imm6");
      OUTS (outf, "A1");
      OUTS (outf, "=");
      OUTS (outf, "A1");
      OUTS (outf, ">>");
      OUTS (outf, imm6 (newimmag));
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 3 && HLs == 0)
    {
      notethat ("A0 = ROT A0 BY imm6");
      OUTS (outf, "A0");
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, "A0");
      OUTS (outf, "BY");
      OUTS (outf, imm6 (immag));
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 1)
    {
      notethat ("dregs = dregs >>> uimm5 (V, S)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, " >>> ");
      OUTS (outf, imm5 (-immag));
      OUTS (outf, " (V, ");
      OUTS (outf, "S)");
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 1)
    {
      notethat ("dregs = dregs >> uimm5 (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, " >> ");
      OUTS (outf, uimm5 (newimmag));
      OUTS (outf, " (V)");
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 1)
    {
      notethat ("dregs = dregs << imm5 (V)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, " << ");
      OUTS (outf, imm5 (immag));
      OUTS (outf, " (V)");
      return 2 * 2;
    }
  else if (sop == 1 && sopcde == 2)
    {
      notethat ("dregs = dregs << imm6 (S)");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, "<<");
      OUTS (outf, imm6 (immag));
      OUTS (outf, "(");
      OUTS (outf, "S)");
      return 2 * 2;
    }
  else if (sop == 2 && sopcde == 2)
    {
      notethat ("dregs = dregs >> imm6");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, ">>");
      OUTS (outf, imm6 (newimmag));
      return 2 * 2;
    }
  else if (sop == 3 && sopcde == 2)
    {
      notethat ("dregs = ROT dregs BY imm6");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, "ROT");
      OUTS (outf, dregs (src1));
      OUTS (outf, "BY");
      OUTS (outf, imm6 (immag));
      return 2 * 2;
    }
  else if (sop == 0 && sopcde == 2)
    {
      notethat ("dregs = dregs >>> imm6");
      OUTS (outf, dregs (dst0));
      OUTS (outf, "=");
      OUTS (outf, dregs (src1));
      OUTS (outf, " >>> ");
      OUTS (outf, imm6 (newimmag));
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_psedoDEBUG_0 (TIword iw0, disassemble_info *outf)
{
/* psedoDEBUG
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
  int grp = ((iw0 >> 3) & 0x7);
  int fn = ((iw0 >> 6) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);

  if (reg == 0 && fn == 3)
    {
      notethat ("DBG A0");
      OUTS (outf, "DBG");
      OUTS (outf, "A0");
      return 1 * 2;
    }
  else if (reg == 1 && fn == 3)
    {
      notethat ("DBG A1");
      OUTS (outf, "DBG");
      OUTS (outf, "A1");
      return 1 * 2;
    }
  else if (reg == 3 && fn == 3)
    {
      notethat ("ABORT");
      OUTS (outf, "ABORT");
      return 1 * 2;
    }
  else if (reg == 4 && fn == 3)
    {
      notethat ("HLT");
      OUTS (outf, "HLT");
      return 1 * 2;
    }
  else if (reg == 5 && fn == 3)
    {
      notethat ("DBGHALT");
      OUTS (outf, "DBGHALT");
      return 1 * 2;
    }
  else if (reg == 6 && fn == 3)
    {
      notethat ("DBGCMPLX ( dregs )");
      OUTS (outf, "DBGCMPLX");
      OUTS (outf, "(");
      OUTS (outf, dregs (grp));
      OUTS (outf, ")");
      return 1 * 2;
    }
  else if (reg == 7 && fn == 3)
    {
      notethat ("DBG");
      OUTS (outf, "DBG");
      return 1 * 2;
    }
  else if (grp == 0 && fn == 2)
    {
      notethat ("OUTC dregs");
      OUTS (outf, "OUTC");
      OUTS (outf, dregs (reg));
      return 1 * 2;
    }
  else if (fn == 0)
    {
      notethat ("DBG allregs");
      OUTS (outf, "DBG");
      OUTS (outf, allregs (reg, grp));
      return 1 * 2;
    }
  else if (fn == 1)
    {
      notethat ("PRNT allregs");
      OUTS (outf, "PRNT");
      OUTS (outf, allregs (reg, grp));
      return 1 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

static int
decode_psedoOChar_0 (TIword iw0, disassemble_info *outf)
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
  return 1 * 2;
}

static int
decode_psedodbg_assert_0 (TIword iw0, TIword iw1, disassemble_info *outf)
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

  if (dbgop == 0)
    {
      notethat ("DBGA ( dregs_lo , uimm16 )");
      OUTS (outf, "DBGA");
      OUTS (outf, "(");
      OUTS (outf, dregs_lo (regtest));
      OUTS (outf, ",");
      OUTS (outf, uimm16 (expected));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (dbgop == 1)
    {
      notethat ("DBGA ( dregs_hi , uimm16 )");
      OUTS (outf, "DBGA");
      OUTS (outf, "(");
      OUTS (outf, dregs_hi (regtest));
      OUTS (outf, ",");
      OUTS (outf, uimm16 (expected));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (dbgop == 2)
    {
      notethat ("DBGAL ( dregs , uimm16 )");
      OUTS (outf, "DBGAL");
      OUTS (outf, "(");
      OUTS (outf, dregs (regtest));
      OUTS (outf, ",");
      OUTS (outf, uimm16 (expected));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else if (dbgop == 3)
    {
      notethat ("DBGAH ( dregs , uimm16 )");
      OUTS (outf, "DBGAH");
      OUTS (outf, "(");
      OUTS (outf, dregs (regtest));
      OUTS (outf, ",");
      OUTS (outf, uimm16 (expected));
      OUTS (outf, ")");
      return 2 * 2;
    }
  else
    goto illegal_instruction;
illegal_instruction:
  return 0;
}

int
_print_insn_bfin (bfd_vma pc, disassemble_info *outf)
{

  bfd_byte buf[4];
  TIword iw0;
  TIword iw1;
  int status;
  status = (*outf->read_memory_func) (pc & ~0x1, buf, 2, outf);
  status = (*outf->read_memory_func) ((pc + 2) & ~0x1, buf + 2, 2, outf);

  iw0 = bfd_getl16 (buf);
  iw1 = bfd_getl16 (buf + 2);

  if (iw0 == 0xc803 && iw1 == 0x1800)
    {
      OUTS (outf, "mnop");
      return 4;
    }
  else if ((iw0 & 0xff00) == 0x0000)
    {
      int rv = decode_ProgCtrl_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xffc0) == 0x0240)
    {
      int rv = decode_CaCTRL_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xff80) == 0x0100)
    {
      int rv = decode_PushPopReg_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfe00) == 0x0400)
    {
      int rv = decode_PushPopMultiple_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfe00) == 0x0600)
    {
      int rv = decode_ccMV_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf800) == 0x0800)
    {
      int rv = decode_CCflag_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xffe0) == 0x0200)
    {
      int rv = decode_CC2dreg_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xff00) == 0x0300)
    {
      int rv = decode_CC2stat_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf000) == 0x1000)
    {
      int rv = decode_BRCC_0 (iw0, pc, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf000) == 0x2000)
    {
      int rv = decode_UJUMP_0 (iw0, pc, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf000) == 0x3000)
    {
      int rv = decode_REGMV_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfc00) == 0x4000)
    {
      int rv = decode_ALU2op_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfe00) == 0x4400)
    {
      int rv = decode_PTR2op_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf800) == 0x4800)
    {
      int rv = decode_LOGI2op_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf000) == 0x5000)
    {
      int rv = decode_COMP3op_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf800) == 0x6000)
    {
      int rv = decode_COMPI2opD_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf800) == 0x6800)
    {
      int rv = decode_COMPI2opP_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf000) == 0x8000)
    {
      int rv = decode_LDSTpmod_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xff60) == 0x9e60)
    {
      int rv = decode_dagMODim_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfff0) == 0x9f60)
    {
      int rv = decode_dagMODik_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfc00) == 0x9c00)
    {
      int rv = decode_dspLDST_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf000) == 0x9000)
    {
      int rv = decode_LDST_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfc00) == 0xb800)
    {
      int rv = decode_LDSTiiFP_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xe000) == 0xA000)
    {
      int rv = decode_LDSTii_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xff80) == 0xe080 && (iw1 & 0x0C00) == 0x0000)
    {
      int rv = decode_LoopSetup_0 (iw0, iw1, pc, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xff00) == 0xe100 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_LDIMMhalf_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfe00) == 0xe200 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_CALLa_0 (iw0, iw1, pc, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfc00) == 0xe400 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_LDSTidxI_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xfffe) == 0xe800 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_linkage_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf600) == 0xc000 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_dsp32mac_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf600) == 0xc200 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_dsp32mult_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf7c0) == 0xc400 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_dsp32alu_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf780) == 0xc600 && (iw1 & 0x01c0) == 0x0000)
    {
      int rv = decode_dsp32shift_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xf780) == 0xc680 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_dsp32shiftimm_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }
  else if ((iw0 & 0xff00) == 0xf800)
    {
      int rv = decode_psedoDEBUG_0 (iw0, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
#if 0
    }
  else if ((iw0 & 0xFF00) == 0xF900)
    {

      int rv = decode_psedoOChar_0 (iw0, iw1, pc, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
#endif
    }
  else if ((iw0 & 0xFFC0) == 0xf000 && (iw1 & 0x0000) == 0x0000)
    {
      int rv = decode_psedodbg_assert_0 (iw0, iw1, outf);
      if (rv)
	return rv;
      goto illegal_instruction;
    }

illegal_instruction:
  return 0;
}


int
print_insn_bfin (bfd_vma pc, disassemble_info *outf)
{
  short iw0 = 0;
  int status = 0;
  int count = 0;
  status = (*outf->read_memory_func) (pc & ~0x01, (bfd_byte *) & iw0, 2, outf);

  count += _print_insn_bfin (pc, outf);
  // Proper display of multiple issue instructions
  if ((iw0 & 0xc000) == 0xc000 && (iw0 & BIT_MULTI_INS)
      && ((iw0 & 0xe800) != 0xe800 /* not Linkage */ ))
    {
      outf->fprintf_func (outf->stream, " || ");
      count += _print_insn_bfin (pc + 4, outf);
      outf->fprintf_func (outf->stream, " || ");
      count += _print_insn_bfin (pc + 6, outf);
    }
  if (count == 0)
    {
      outf->fprintf_func (outf->stream, "ILLEGAL");
      return 2;
    }
  outf->fprintf_func (outf->stream, ";");
  return count;
}
