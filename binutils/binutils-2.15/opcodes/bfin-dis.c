/*
 * New Blackfin disassembler routines
 *
 * (c) 04/2004 Martin Strubel <hackfin@section5.ch>
 *
 *  based on original nisa-dis.c:
 *   Copyright (c) 2000, 2001 Analog Devices Inc.
 *   Copyright (c) 2003 Metrowerks
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "bfin-opcodes.h"
#include "dis-asm.h"
// TODO: Clean up redundancies in this file and this:
// #include "../gas/config/bfin-defs.h"

#define M_S2RND 1
#define M_T     2
#define M_W32   3
#define M_FU    4
#define M_TFU   6
#define M_IS    8
#define M_ISS2  9
#define M_IH    11
#define M_IU    12


#ifndef PRINTF
#define PRINTF printf
#endif

#ifndef EXIT
#define EXIT exit
#endif

int _bad_opcode(int is32, int i);
int _print_insn_bfin (bfd_vma pc, disassemble_info *outf);
int print_insn_bfin(bfd_vma pc, disassemble_info *outf);


typedef long TIword;

#define HOST_LONG_WORD_SIZE (sizeof(long)*8)

#define XFIELD(w,p,s) (((w)&((1<<(s))-1)<<(p))>>(p))

#define SIGNEXTEND(v, n) ((v << (HOST_LONG_WORD_SIZE - (n))) >> (HOST_LONG_WORD_SIZE - (n)))
#define MASKBITS(val, bits) (val & (( 1 << bits)-1))

typedef enum {
  c_0,     c_1,     c_4,     c_2,     c_uimm2, c_uimm3, c_imm3,  c_pcrel4, 
  c_imm4,  c_uimm4s4, c_uimm4, c_uimm4s2, c_negimm5s4, c_imm5,  c_uimm5, c_imm6,  
  c_imm7,  c_imm8,  c_uimm8, c_pcrel8, c_uimm8s4, c_pcrel8s4, c_lppcrel10, c_pcrel10, 
  c_pcrel12, c_imm16s4, c_luimm16, c_imm16, c_huimm16, c_rimm16, c_imm16s2, c_uimm16s4, 
  c_uimm16, c_pcrel24, 
  } const_forms_t;

static struct { 
    char *name; 
    int nbits; 
    char reloc;
    char issigned;
    char pcrel; 
    char scale;
    char offset; 
    char negative; 
    char positive; 
} constant_formats[] = {

  { "0", 0, 0, 1, 0, 0, 0, 0, 0 },
  { "1", 0, 0, 1, 0, 0, 0, 0, 0 },
  { "4", 0, 0, 1, 0, 0, 0, 0, 0 },
  { "2", 0, 0, 1, 0, 0, 0, 0, 0 },
  { "uimm2", 2, 0, 0, 0, 0, 0, 0, 0 },
  { "uimm3", 3, 0, 0, 0, 0, 0, 0, 0 },
  { "imm3", 3, 0, 1, 0, 0, 0, 0, 0 },
  { "pcrel4", 4, 1, 0, 1, 1, 0, 0, 0 },
  { "imm4", 4, 0, 1, 0, 0, 0, 0, 0 },
  { "uimm4s4", 4, 0, 0, 0, 2, 0, 0, 1 },
  { "uimm4", 4, 0, 0, 0, 0, 0, 0, 0 },
  { "uimm4s2", 4, 0, 0, 0, 1, 0, 0, 1 },
  { "negimm5s4", 5, 0, 1, 0, 2, 0, 1, 0 },
  { "imm5", 5, 0, 1, 0, 0, 0, 0, 0 },
  { "uimm5", 5, 0, 0, 0, 0, 0, 0, 0 },
  { "imm6", 6, 0, 1, 0, 0, 0, 0, 0 },
  { "imm7", 7, 0, 1, 0, 0, 0, 0, 0 },
  { "imm8", 8, 0, 1, 0, 0, 0, 0, 0 },
  { "uimm8", 8, 0, 0, 0, 0, 0, 0, 0 },
  { "pcrel8", 8, 1, 0, 1, 1, 0, 0, 0 },
  { "uimm8s4", 8, 0, 0, 0, 2, 0, 0, 0 },
  { "pcrel8s4", 8, 1, 1, 1, 2, 0, 0, 0 },
  { "lppcrel10", 10, 1, 0, 1, 1, 0, 0, 0 },
  { "pcrel10", 10, 1, 1, 1, 1, 0, 0, 0 },
  { "pcrel12", 12, 1, 1, 1, 1, 0, 0, 0 },
  { "imm16s4", 16, 0, 1, 0, 2, 0, 0, 0 },
  { "luimm16", 16, 1, 0, 0, 0, 0, 0, 0 },
  { "imm16", 16, 0, 1, 0, 0, 0, 0, 0 },
  { "huimm16", 16, 1, 0, 0, 0, 0, 0, 0 },
  { "rimm16", 16, 1, 1, 0, 0, 0, 0, 0 },
  { "imm16s2", 16, 0, 1, 0, 1, 0, 0, 0 },
  { "uimm16s4", 16, 0, 0, 0, 2, 0, 0, 0 },
  { "uimm16", 16, 0, 0, 0, 0, 0, 0, 0 },
  { "pcrel24", 24, 1, 1, 1, 1, 0, 0, 0 },
};

static char *fmtconst(const_forms_t cf, TIword x, bfd_vma pc, disassemble_info *outf)
{
    static char buf[60];

    if (constant_formats[cf].reloc) {
	bfd_vma ea = (((constant_formats[cf].pcrel
			? SIGNEXTEND(x, constant_formats[cf].nbits)
			: x) + constant_formats[cf].offset)
		      << constant_formats[cf].scale);
	if (constant_formats[cf].pcrel)	    ea += pc;

	outf->print_address_func (ea, outf);
	return "";
    }

    /* negative constants have an implied sign bit */
    if (constant_formats[cf].negative) {
      int nb = constant_formats[cf].nbits+1;
      x = x | (1<<constant_formats[cf].nbits);
      x = SIGNEXTEND (x , nb);
    } else
	x = constant_formats[cf].issigned
	    ? SIGNEXTEND(x, constant_formats[cf].nbits)
		: x;

    if (constant_formats[cf].offset)
		x += constant_formats[cf].offset;

    if (constant_formats[cf].scale)
		x <<= constant_formats[cf].scale;

	if (constant_formats[cf].issigned && x < 0)
		sprintf (buf, "%ld", x);
    else
		sprintf (buf, "0x%x", x);

    return buf;
}

#undef SIGNEXTEND
#undef MASKBITS
#undef HOST_LONG_WORD_SIZE
#define HOST_LONG_WORD_SIZE (sizeof(long)*8)
#define SIGNEXTEND(v, n) (((long)(v) << (HOST_LONG_WORD_SIZE - (n))) >> (HOST_LONG_WORD_SIZE - (n)))
#define MASKBITS(val, bits) (val & (( 1 << bits)-1))

enum machine_registers {
  REG_RL0,   REG_RL1,   REG_RL2,   REG_RL3,   REG_RL4,   REG_RL5,   REG_RL6,   REG_RL7,
  REG_RH0,   REG_RH1,   REG_RH2,   REG_RH3,   REG_RH4,   REG_RH5,   REG_RH6,   REG_RH7,
  REG_R0,    REG_R1,    REG_R2,    REG_R3,    REG_R4,    REG_R5,    REG_R6,    REG_R7,
  REG_R1_0,  REG_R3_2,  REG_R5_4,  REG_R7_6,  REG_P0,    REG_P1,    REG_P2,    REG_P3,
  REG_P4,    REG_P5,    REG_SP,    REG_FP,    REG_A0x,   REG_A1x,   REG_A0w,   REG_A1w,
  REG_A0,    REG_A1,    REG_I0,    REG_I1,    REG_I2,    REG_I3,    REG_M0,    REG_M1,
  REG_M2,    REG_M3,    REG_B0,    REG_B1,    REG_B2,    REG_B3,    REG_L0,    REG_L1,
  REG_L2,    REG_L3,
  REG_AZ,    REG_AN,    REG_AC0,   REG_AC1,   REG_AV0,   REG_AV1,  REG_AV0S,  REG_AV1S,
  REG_AQ,    REG_V,     REG_VS, 
  REG_sftreset, REG_omode, REG_excause, REG_emucause, REG_idle_req, REG_hwerrcause, REG_CC,    REG_LC0,
  REG_LC1,   REG_GP,    REG_ASTAT, REG_RETS,  REG_LT0,   REG_LB0,   REG_LT1,   REG_LB1,
  REG_CYCLES, REG_CYCLES2, REG_USP,   REG_SEQSTAT, REG_SYSCFG, REG_RETI,  REG_RETX,  REG_RETN,
  REG_RETE, REG_BR0,   REG_BR1,   REG_BR2,   REG_BR3,   REG_BR4,   REG_BR5,   REG_BR6,
  REG_BR7, REG_PL0, REG_PL1, REG_PL2, REG_PL3, REG_PL4, REG_PL5, REG_SLP, REG_FLP,
  REG_PH0, REG_PH1, REG_PH2, REG_PH3, REG_PH4, REG_PH5, REG_SHP, REG_FHP,
  REG_IL0, REG_IL1, REG_IL2, REG_IL3, REG_ML0, REG_ML1, REG_ML2, REG_ML3,
  REG_BL0, REG_BL1, REG_BL2, REG_BL3, REG_LL0, REG_LL1, REG_LL2, REG_LL3,
  REG_IH0, REG_IH1, REG_IH2, REG_IH3, REG_MH0, REG_MH1, REG_MH2, REG_MH3,
  REG_BH0, REG_BH1, REG_BH2, REG_BH3, REG_LH0, REG_LH1, REG_LH2, REG_LH3,
  REG_LASTREG,
  };


enum reg_class {
  rc_dregs_lo, rc_dregs_hi, rc_dregs,  rc_dregs_pair, rc_pregs,  rc_spfp,   rc_dregs_hilo, rc_accum_ext,
  rc_accum_word, rc_accum,  rc_iregs,  rc_mregs,  rc_bregs,  rc_lregs,  rc_dpregs, rc_gregs,
  rc_regs,   rc_statbits, rc_ignore_bits, rc_ccstat, rc_counters, rc_dregs2_sysregs1, rc_open,   rc_sysregs2,
  rc_sysregs3, rc_allregs,
    LIM_REG_CLASSES
};

static char *reg_names[] = {
  "r0.l",     "r1.l",     "r2.l",     "r3.l",     "r4.l",     "r5.l",     "r6.l",     "r7.l",
  "r0.h",     "r1.h",     "r2.h",     "r3.h",     "r4.h",     "r5.h",     "r6.h",     "r7.h",
  "r0",      "r1",      "r2",      "r3",      "r4",      "r5",      "r6",      "r7",
  "r1:0",    "r3:2",    "r5:4",    "r7:6",    "p0",      "p1",      "p2",      "p3",
  "p4",      "p5",      "sp",      "fp",      "a0.x",     "a1.x",     "a0.w",     "a1.w",
  "a0",      "a1",      "i0",      "i1",      "i2",      "i3",      "m0",      "m1",
  "m2",      "m3",      "b0",      "b1",      "b2",      "b3",      "l0",      "l1",
  "l2",      "l3",
  "az",      "an",      "ac0",     "ac1",     "av0",     "av1",     "av0s",    "av1s",
  "aq",      "v",       "vs",
  "sftreset", "omode",   "excause", "emucause", "idle_req", "hwerrcause", "cc",      "lc0",
  "lc1",     "gp",      "astat",   "rets",    "lt0",     "lb0",     "lt1",     "lb1",
  "cycles",  "cycles2", "usp",     "seqstat", "syscfg",  "reti",    "retx",    "retn",
  "rete", 
  "r0.b",   "r1.b",   "r2.b",   "r3.b",   "r4.b",   "r5.b",   "r6.b",  "r7.b",
  "p0.l",   "p1.l",   "p2.l",   "p3.l",   "p4.l",   "p5.l",   "sp.l",  "fp.l",
  "p0.h",   "p1.h",   "p2.h",   "p3.h",   "p4.h",   "p5.h",   "sp.h",  "fp.h",
  "i0.l",   "i1.l",   "i2.l",   "i3.l",   "m0.l",   "m1.l",   "m2.l",  "m3.l",
  "b0.l",   "b1.l",   "b2.l",   "b3.l",   "l0.l",   "l1.l",   "l2.l",  "l3.l",
  "i0.h",   "i1.h",   "i2.h",   "i3.h",   "m0.h",   "m1.h",   "m2.h",  "m3.h",
  "b0.h",   "b1.h",   "b2.h",   "b3.h",   "l0.h",   "l1.h",   "l2.h",  "l3.h",
  "lastreg",
    0
};

static char *sreg_names[] = {
	"az", "an", "", "", "", "", "aq", "",
	"", "", "", "", "ac0", "ac1", "", "",
	"av0", "av0s", "av1", "av1s", "", "", "", "",
	"v", "vs", "", "", "", "", "", ""
};

#define REGNAME(x) ((x) < REG_LASTREG ? (reg_names[x]) : "...... Illegal register .......")

#define STATREGNAME(x) (sreg_names[x])

/* RL(0..7)  */
static enum machine_registers decode_dregs_lo[] = {
  REG_RL0,     REG_RL1,     REG_RL2,     REG_RL3,     REG_RL4,     REG_RL5,     REG_RL6,     REG_RL7,
  };

#define dregs_lo(x) REGNAME(decode_dregs_lo[(x) & 7])

/* RH(0..7)  */
static enum machine_registers decode_dregs_hi[] = {
  REG_RH0,     REG_RH1,     REG_RH2,     REG_RH3,     REG_RH4,     REG_RH5,     REG_RH6,     REG_RH7,
  };

#define dregs_hi(x) REGNAME(decode_dregs_hi[(x) & 7])

/* R(0..7)  */
static enum machine_registers decode_dregs[] = {
  REG_R0,      REG_R1,      REG_R2,      REG_R3,      REG_R4,      REG_R5,      REG_R6,      REG_R7,
  };

#define dregs(x) REGNAME(decode_dregs[(x) & 7])

/* R BYTE(0..7)  */
static enum machine_registers decode_dregs_byte[] = {
  REG_BR0,     REG_BR1,     REG_BR2,     REG_BR3,     REG_BR4,     REG_BR5,     REG_BR6,     REG_BR7,
  };

#define dregs_byte(x) REGNAME(decode_dregs_byte[(x) & 7])


/* P(0..5) SP FP  */
static enum machine_registers decode_pregs[] = {
  REG_P0,      REG_P1,      REG_P2,      REG_P3,      REG_P4,      REG_P5,      REG_SP,      REG_FP,
  };

#define pregs(x) REGNAME(decode_pregs[(x) & 7])

/* SP FP  */
/* I(0..3)   */
static enum machine_registers decode_iregs[] = {
  REG_I0,      REG_I1,      REG_I2,      REG_I3,
  };

#define iregs(x) REGNAME(decode_iregs[(x) & 3])

/* M(0..3)   */
static enum machine_registers decode_mregs[] = {
  REG_M0,      REG_M1,      REG_M2,      REG_M3,
  };

#define mregs(x) REGNAME(decode_mregs[(x) & 3])


/* dregs pregs  */
static enum machine_registers decode_dpregs[] = {
  REG_R0,      REG_R1,      REG_R2,      REG_R3,      REG_R4,      REG_R5,      REG_R6,      REG_R7,
  REG_P0,      REG_P1,      REG_P2,      REG_P3,      REG_P4,      REG_P5,      REG_SP,      REG_FP,
  };

#define dpregs(x) REGNAME(decode_dpregs[(x) & 15])

/* [dregs pregs] */
static enum machine_registers decode_gregs[] = {
  REG_R0,      REG_R1,      REG_R2,      REG_R3,      REG_R4,      REG_R5,      REG_R6,      REG_R7,
  REG_P0,      REG_P1,      REG_P2,      REG_P3,      REG_P4,      REG_P5,      REG_SP,      REG_FP,
  };

#define gregs(x,i) REGNAME(decode_gregs[((i) << 3) | (x)])

/* [dregs pregs (iregs mregs) (bregs lregs)]  */
static enum machine_registers decode_regs[] = {
  REG_R0,      REG_R1,      REG_R2,      REG_R3,      REG_R4,      REG_R5,      REG_R6,      REG_R7,
  REG_P0,      REG_P1,      REG_P2,      REG_P3,      REG_P4,      REG_P5,      REG_SP,      REG_FP,
  REG_I0,      REG_I1,      REG_I2,      REG_I3,      REG_M0,      REG_M1,      REG_M2,      REG_M3,
  REG_B0,      REG_B1,      REG_B2,      REG_B3,      REG_L0,      REG_L1,      REG_L2,      REG_L3,
  };

#define regs(x,i) REGNAME(decode_regs[((i) << 3)| (x)])

/* [dregs pregs (iregs mregs) (bregs lregs) Low Half]  */
static enum machine_registers decode_regs_lo[] = {
  REG_RL0,     REG_RL1,     REG_RL2,     REG_RL3,     REG_RL4,     REG_RL5,     REG_RL6,     REG_RL7,
  REG_PL0,     REG_PL1,     REG_PL2,     REG_PL3,     REG_PL4,     REG_PL5,     REG_SLP,     REG_FLP,
  REG_IL0,     REG_IL1,     REG_IL2,     REG_IL3,     REG_ML0,     REG_ML1,     REG_ML2,     REG_ML3,
  REG_BL0,     REG_BL1,     REG_BL2,     REG_BL3,     REG_LL0,     REG_LL1,     REG_LL2,     REG_LL3,
  };
#define regs_lo(x,i) REGNAME(decode_regs_lo[((i) << 3) | (x)])
/* [dregs pregs (iregs mregs) (bregs lregs) High Half]  */
static enum machine_registers decode_regs_hi[] = {
  REG_RH0,     REG_RH1,     REG_RH2,     REG_RH3,     REG_RH4,     REG_RH5,     REG_RH6,     REG_RH7,
  REG_PH0,     REG_PH1,     REG_PH2,     REG_PH3,     REG_PH4,     REG_PH5,     REG_SHP,     REG_FHP,
  REG_IH0,     REG_IH1,     REG_IH2,     REG_IH3,     REG_MH0,     REG_MH1,     REG_LH2,     REG_MH3,
  REG_BH0,     REG_BH1,     REG_BH2,     REG_BH3,     REG_LH0,     REG_LH1,     REG_LH2,     REG_LH3,
  };
#define regs_hi(x,i) REGNAME(decode_regs_hi[((i) << 3) | (x)])


#define statbits(x) STATREGNAME(x & 0x1f)


/* sftreset omode excause emucause idle_req hwerrcause */

/* LC0 LC1  */
static enum machine_registers decode_counters[] = {
  REG_LC0,     REG_LC1,     
  };

#define counters(x) REGNAME(decode_counters[(x) & 1])

/* [dregs pregs (iregs mregs) (bregs lregs) 	         dregs2_sysregs1 open sysregs2 sysregs3] */
static enum machine_registers decode_allregs[] = {
  REG_R0,      REG_R1,      REG_R2,      REG_R3,      REG_R4,      REG_R5,      REG_R6,      REG_R7,      
  REG_P0,      REG_P1,      REG_P2,      REG_P3,      REG_P4,      REG_P5,      REG_SP,      REG_FP,      
  REG_I0,      REG_I1,      REG_I2,      REG_I3,      REG_M0,      REG_M1,      REG_M2,      REG_M3,      
  REG_B0,      REG_B1,      REG_B2,      REG_B3,      REG_L0,      REG_L1,      REG_L2,      REG_L3,      
  REG_A0x,     REG_A0w,     REG_A1x,     REG_A1w,     REG_GP,      REG_LASTREG, REG_ASTAT,   REG_RETS,    
  REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG, REG_LASTREG,
  REG_LC0,     REG_LT0,     REG_LB0,     REG_LC1,     REG_LT1,     REG_LB1,     REG_CYCLES,  REG_CYCLES2,
  REG_USP,     REG_SEQSTAT, REG_SYSCFG,  REG_RETI,    REG_RETX,    REG_RETN,    REG_RETE,    REG_LASTREG,
  };

#define allregs(x,i) REGNAME(decode_allregs[((i) << 3) | (x)])
#define uimm16s4(x) fmtconst(c_uimm16s4, x , pc, outf)
#define pcrel4(x) fmtconst(c_pcrel4, x , pc, outf)
#define pcrel8(x) fmtconst(c_pcrel8, x , pc, outf)
#define pcrel8s4(x) fmtconst(c_pcrel8s4, x , pc, outf)
#define pcrel10(x) fmtconst(c_pcrel10, x , pc, outf)
#define pcrel12(x) fmtconst(c_pcrel12, x , pc, outf)
#define negimm5s4(x) fmtconst(c_negimm5s4, x , pc, outf)
#define rimm16(x) fmtconst(c_rimm16, x , pc, outf)
#define huimm16(x) fmtconst(c_huimm16, x , pc, outf)
#define imm16(x) fmtconst(c_imm16, x , pc, outf)
#define uimm2(x) fmtconst(c_uimm2, x , pc, outf)
#define uimm3(x) fmtconst(c_uimm3, x , pc, outf)
#define luimm16(x) fmtconst(c_luimm16, x , pc, outf)
#define uimm4(x) fmtconst(c_uimm4, x , pc, outf)
#define uimm5(x) fmtconst(c_uimm5, x , pc, outf)
#define imm16s2(x) fmtconst(c_imm16s2, x , pc, outf)
#define uimm8(x) fmtconst(c_uimm8, x , pc, outf)
#define imm16s4(x) fmtconst(c_imm16s4, x , pc, outf)
#define uimm4s2(x) fmtconst(c_uimm4s2, x , pc, outf)
#define uimm4s4(x) fmtconst(c_uimm4s4, x , pc, outf)
#define lppcrel10(x) fmtconst(c_lppcrel10, x , pc, outf)
#define imm3(x) fmtconst(c_imm3, x , pc, outf)
#define imm4(x) fmtconst(c_imm4, x , pc, outf)
#define uimm8s4(x) fmtconst(c_uimm8s4, x , pc, outf)
#define imm5(x) fmtconst(c_imm5, x , pc, outf)
#define imm6(x) fmtconst(c_imm6, x , pc, outf)
#define imm7(x) fmtconst(c_imm7, x , pc, outf)
#define imm8(x) fmtconst(c_imm8, x , pc, outf)
#define pcrel24(x) fmtconst(c_pcrel24, x , pc, outf)
#define uimm16(x) fmtconst(c_uimm16, x , pc, outf)

/* (arch.pm)arch_disassembler_functions */
#define notethat(x)

#ifndef OUTS
#define OUTS(p,txt) ((p)?(((txt)[0])?(p->fprintf_func)(p->stream, txt):0):0)
#endif


////////////////////////////////////////////////////////////////////////////
// AUXILIARIES


#define _DECL16(x, l) x c; c.opcode = l;
#define _DECL32(x, h, l) x c; c.opcode = ( ((h) << 16) | (l));
#define _W c.bits
#define _P(x) OUTS(outf, x)

#define bad_opcode(x) _bad_opcode(x, __LINE__)

int _bad_opcode(int is32, int i)
{
	printf("<%d> Illegal opcode\n", i);
	if (is32)
		return 4;
	else
		return 2;
}

// Auxiliaries for DSP32 mac/mult
static void decode_op_bar_op(int aop, disassemble_info *outf)
{
	switch (aop) {
		case 0: _P("+|+"); break;
		case 1: _P("+|-"); break;
		case 2: _P("-|+"); break;
		case 3: _P("-|-"); break;
	}
}

static void decode_searchmod (int r0, disassemble_info *outf)
{
	if (r0==0) {
		_P(" (gt)");
	} else if (r0==1) {
		_P(" (ge)");
	} else if (r0==2) {
		_P(" (lt)");
	} else if (r0==3) {
		_P(" (le)");
	}
}

static int decode_multfunc(int h0, int h1, int src0, int src1, disassemble_info *outf)
{
	char *s0, *s1;

	if (h0) s0 = dregs_hi(src0);
	else    s0 = dregs_lo(src0);

	if (h1) s1 = dregs_hi(src1);
	else    s1 = dregs_lo(src1);

	_P(s0); _P(" * "); _P(s1);
	return 0;
}

static int decode_macfunc(int which, int op, int h0, int h1, int src0, int src1, disassemble_info *outf)
{
	char *a;
	char *sop = "<unknown op>";

	if (which)
		a = "a1";
	else
		a = "a0";

	if (op == 3) {  // no macfunc, just assign
		_P(a);
		return 0;
	}

	switch (op) {
		case 0: sop = "="; break;
		case 1: sop = "+="; break;
		case 2: sop = "-="; break;
	}

	_P(a); _P(" "); _P(sop); _P(" ");
	decode_multfunc(h0, h1, src0, src1, outf);

	return 0;
}


static int decode_optmode(int mmod, disassemble_info *outf)
{
	switch (mmod) {
		case 0: break;
		case M_S2RND: _P(" (s2rnd)"); break;
		case M_T:     _P(" (iu)"); break;
		case M_W32:   _P(" (w32)"); break;
		case M_FU:    _P(" (fu)"); break;
		case M_TFU:   _P(" (tfu)"); break;
		case M_IS:    _P(" (is)"); break;
		case M_ISS2:  _P(" (iss2)"); break;
		case M_IH:    _P(" (ih)"); break;
		case M_IU:    _P(" (iu)"); break;
		default: break;
	}
	return 0;
}


static void amod0(int s0,int x0, disassemble_info *outf)
{
	if ((s0==0) && (x0==0)) {
		_P(" (ns)");
		return;
	} else if ((s0==1) && (x0==0)) {
		_P(" (s)");
		return;
	} else if ((s0==0) && (x0==1)) {
		_P(" (co)");
		return;
	} else if ((s0==1) && (x0==1)) {
		_P(" (sco)");
		return;
	} 
}

static int decode_amod1(int s0, int x0, disassemble_info *outf)
{
	if (x0 != 0) return bad_opcode(0);

	if (s0==0) {
		_P(" (ns)");
	} else {
		_P(" (s)");
	}
	return 1;
}

static void decode_amod2(int s0, int x0, int aop, disassemble_info *outf)
{
	int sco = ( (1 << x0) | s0 );

	if (sco == 0 && aop == 0) return;

	_P(" (");

	switch (sco) {
		case 0: break;
		case 1: _P("s"); break;
		case 2: _P("co"); break;
		case 3: _P("sco"); break;
	}
	
	if (aop & 2) {
		if (sco) _P(", ");
		
		if (aop & 1) _P("asl");
		else         _P("asr");

	}

	_P(")");
}

////////////////////////////////////////////////////////////////////////////


static int decode_ProgCtrl_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL16(ProgCtrl, iw0);

	switch (_W.prgfunc) {
		case 0:
			if (_W.poprnd == 0)
				_P("nop");
			break;
		case 1:
			switch (_W.poprnd) {
				case 0:
					_P("rts"); break;
				case 1:
					_P("rti"); break;
				case 2:
					_P("rtx"); break;
				case 3:
					_P("rtn"); break;
				case 4:
					_P("rte"); break;
				default:
					return bad_opcode(0);
			}
			break;
		case 2:
			switch (_W.poprnd) {
				case 0:
					_P("idle"); break;
				case 3:
					_P("csync"); break;
				case 4:
					_P("ssync"); break;
				case 5:
					_P("emuexcpt"); break;
			}
			break;
		case 3:
			_P("cli ");
			_P(dregs(_W.poprnd));
			break;
		case 4:
			_P("sti ");
			_P(dregs(_W.poprnd));
			break;
		case 5:
			_P("jump (");
			_P(pregs(_W.poprnd));
			_P(")");
			break;
		case 6:
			_P("call (");
			_P(pregs(_W.poprnd));
			_P(")");
			break;
		case 7:
			_P("call (pc + ");
			_P(pregs(_W.poprnd));
			_P(")");
			break;
		case 8:
			_P("jump (pc + ");
			_P(pregs(_W.poprnd));
			_P(")");
			break;
		case 9:
			_P("raise ");
			_P(uimm4(_W.poprnd));
			_P(")");
			break;
		case 10:
			_P("excpt ");
			_P(uimm4(_W.poprnd));
			_P(")");
			break;
		case 11:
			_P("testset ");
			_P(pregs(_W.poprnd));
			_P(")");
			break;
		default:
			return bad_opcode(0);
		}
	return 2;
}

static int decode_CaCTRL_0 (TIword iw0,
		disassemble_info *outf)
{
	_DECL16(CaCTRL, iw0);

	switch (_W.a) {
		case 0:
			switch (_W.op) {
				case 0:
					_P("prefetch ["); _P(pregs(_W.reg)); _P("]");
					break;
				case 1:
					_P("flushinv ["); _P(pregs(_W.reg)); _P("]");
					break;
				case 2:
					_P("flush [");    _P(pregs(_W.reg)); _P("]");
					break;
				case 3:
					_P("iflush [");   _P(pregs(_W.reg)); _P("]");
					break;
			}
			break;
		case 1:
			switch (_W.op) {
				case 0:
					_P("prefetch ["); _P(pregs(_W.reg)); _P("++]");
					break;
				case 1:
					_P("flushinv ["); _P(pregs(_W.reg)); _P("++]");
					break;
				case 2:
					_P("flush [");    _P(pregs(_W.reg)); _P("++]");
					break;
				case 3:
					_P("iflush [");    _P(pregs(_W.reg)); _P("++]");
					break;
			}
			break;
		default:
			return bad_opcode(0);
	}
	return 2;
}

static int decode_PushPopReg_0 (TIword iw0,
		disassemble_info *outf)
{
	_DECL16(PushPopReg, iw0);

	if (_W.W) {
		_P("[--sp] = ");
		_P(allregs(_W.reg, _W.grp));
	} else {
		_P(allregs(_W.reg, _W.grp));
		_P(" = [sp++]");
	}
	return 2;
}


static int decode_PushPopMultiple_0 (TIword iw0,
		disassemble_info *outf)
{
	char rrange[16];
	_DECL16(PushPopMultiple, iw0);

	if (_W.d) {
		if (_W.p) {
			sprintf(rrange, "r7:%d, p5:%d", _W.dr, _W.pr);
		} else {
			sprintf(rrange, "r7:%d", _W.dr);
		}
	} else {
		sprintf(rrange, "p5:%d", _W.pr);
	}

	if (_W.W) {
        _P("[--sp] = (");
		_P(rrange);
		_P(")");
  	} else {
		_P("(");
		_P(rrange);
		_P(") = [sp++]");
	}
	return 2;
}

static int decode_ccMV_0 (TIword iw0,
		disassemble_info *outf)
{
	_DECL16(CCmv, iw0);

	if (_W.T) {
		_P("if cc ");
		_P(gregs(_W.dst, _W.d));
		_P(" = ");
		_P(gregs(_W.src, _W.s));
	} else {
		_P("if !cc ");
		_P(gregs(_W.dst, _W.d));
		_P(" = ");
		_P(gregs(_W.src, _W.s));
	}

	return 2;
}

static int decode_CCflag_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	char *op = "";
	char *mod = "";
	_DECL16(CCflag, iw0);

	switch (_W.opc) {
		case 0: op = "=="; break;
		case 1: op = "<";  break;
		case 2: op = "<="; break;
		case 3: op = "<"; mod = "(iu)"; break;
		case 4: op = "<="; mod = "(iu)"; break;
		case 5: op = "=="; break;
		case 6: op = "<"; break;
		case 7: op = "<="; break;
	}
	if (_W.opc < 5) { // P or R compare 
		if (_W.G) { // preg
			_P("cc = "); _P(pregs(_W.x));
		} else {
			_P("cc = "); _P(dregs(_W.x));
		}

		_P(" "); _P(op); _P(" ");

		if (_W.I) { // imm constant
			if (_W.opc < 3) {
				_P(imm3(_W.y));
			} else {
				_P(uimm3(_W.y));
			}
		} else {
			if (_W.G) {
				_P(pregs(_W.y));
			} else {
				_P(dregs(_W.y));
			}
		}
		_P(mod);
	} else {  // A compare
		if (_W.G || _W.I) return bad_opcode(0);
		_P("cc = a0");
		_P(" "); _P(op); _P(" ");
		_P("a1");
	}

	return 2;
}

static int decode_CC2dreg_0 (TIword iw0,
		disassemble_info *outf)
{
	_DECL16(CC2dreg, iw0);

	switch (_W.op) {
		case 0:
			_P(dregs(_W.reg)); _P(" = cc"); break;
		case 1:
			_P("cc = "); _P(dregs(_W.reg)); break;
		case 3:
			_P("cc = !cc");
		default:
			return bad_opcode(0);
	}
	return 2;
}

static int decode_CC2stat_0 (TIword iw0,
		disassemble_info *outf)
{
	char *op = "<unknown op>";
	_DECL16(CC2stat, iw0);

	switch (_W.op) {
		case 0: op = " = "; break;
		case 1: op = " |= "; break;
		case 2: op = " &= "; break;
		case 3: op = " ^= "; break;
	}

	if (_W.D) {
		_P(statbits(_W.cbit)); _P(op); _P("cc");
	} else {
		_P("cc"); _P(op); _P(statbits(_W.cbit));
	}

	return 2;
}

static int decode_BRCC_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL16(BRCC, iw0);

	if (_W.T) {
		_P("if cc jump "); _P(pcrel10(_W.offset));
	} else {
		_P("if !cc jump "); _P(pcrel10(_W.offset));
	}
	if (_W.B) {
		_P(" (bp)");
	}
	return 2;
}

static int decode_UJUMP_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL16(UJump, iw0);
	_P("jump.s ");
	_P(pcrel12(_W.offset));
	return 2;
}

static int decode_REGMV_0 (TIword iw0,
		disassemble_info *outf)
{
	_DECL16(RegMv, iw0);

	_P(allregs(_W.dst, _W.gd));
	_P(" = ");
	_P(allregs(_W.src, _W.gs));
	return 2;
}

static int decode_ALU2op_0 (TIword iw0,
		disassemble_info *outf)
{
	char *op;
	int type = 0;
	_DECL16(ALU2op, iw0);


	switch (_W.opc) {
		case 0:
			op = ">>>="; break;
		case 1:
			op = ">>="; break;
		case 2:
			op = "<<="; break;
		case 3:
			op = "*="; break;
		case 4:
			type = 1; op = "1"; break;
		case 5:
			type = 1; op = "2"; break;
		case 8:
			type = 2; op = "q"; break;
		case 9:
			type = 2; op = "s"; break;
		case 10:
			type = 3; op = "(x)"; break;
		case 11:
			type = 3; op = "(z)"; break;
		case 12:
			type = 4; op = "(x)"; break;
		case 13:
			type = 4; op = "(z)"; break;
		case 14:
			type = 5; op = "-"; break;
		case 15:
			type = 5; op = "~"; break;
		default:
			return bad_opcode(0);
	}

	switch (type) {
		case 0:
			_P(dregs(_W.dst)); _P(" ");  _P(op); _P(" "); _P(dregs(_W.src));
			break;
		case 1:
			_P(dregs(_W.dst));
			_P(" = ("); _P(dregs(_W.dst)); _P(" + ");
			_P(dregs(_W.src)); _P(") << ");
			_P(op);
			break;
		case 2:
			_P("div"); _P(op); _P(" (");
			_P(dregs(_W.dst));
			_P(", ");
			_P(dregs(_W.src));
			_P(")");
			break;
		case 3:
			_P(dregs(_W.dst));
			_P(" = ");
			_P(dregs_lo(_W.src));
			_P(" ");
			_P(op);
			break;
		case 4:
			_P(dregs(_W.dst));
			_P(" = ");
			_P(dregs_byte(_W.src));
			_P(" ");
			_P(op);
			break;
		case 5:
			_P(dregs(_W.dst));
			_P(" = "); _P(op);
			_P(dregs(_W.src));
			break;
	}
	return 2;
}


static int decode_PTR2op_0 (TIword iw0,
		disassemble_info *outf)
{
	char *op = "<unknown op>";
	_DECL16(PTR2op, iw0);

	switch (_W.opc) {
		case 0:
			op = "-=";
			_P(pregs(_W.dst)); _P(" -= "); _P(pregs(_W.src));
			break;
		case 1:
			_P(pregs(_W.dst)); _P(" = "); _P(pregs(_W.src));
			_P(" << 2");
			break;
		case 3:
			_P(pregs(_W.dst)); _P(" = "); _P(pregs(_W.src));
			_P(" >> 2");
			break;
		case 4:
			_P(pregs(_W.dst)); _P(" = "); _P(pregs(_W.src));
			_P(" >> 1");
			break;
		case 5:
			_P(pregs(_W.dst)); _P(" += "); _P(pregs(_W.src));
			_P(" (brev)");
			break;
		case 6:
			_P(pregs(_W.dst)); _P(" = (");
			_P(pregs(_W.dst)); _P(" + "); _P(pregs(_W.src));
			_P(")");
			_P(" << 1");
			break;
		case 7:
			_P(pregs(_W.dst)); _P(" = (");
			_P(pregs(_W.dst)); _P(" + "); _P(pregs(_W.src));
			_P(")");
			_P(" << 2");
			break;
		default:
			return bad_opcode(0);
	}
	return 2;
}

static int decode_LOGI2op_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	char *op = "<unknown op>";
	int type = 0;
	_DECL16(LOGI2op, iw0);

	switch (_W.opc) {
		case 0:
			op = "!bittst"; break;
		case 1:
			op = "bittst"; break;
		case 2:
			type = 1; op = "bitset"; break;
		case 3:
			type = 1; op = "bittgl"; break;
		case 4:
			type = 1; op = "bitclr"; break;
		case 5:
			type = 2; op = ">>>="; break;
		case 6:
			type = 2; op = ">>="; break;
		case 7:
			type = 2; op = "<<="; break;
	}

	switch (type) {
		case 0:
			_P("cc = ");
		case 1:
			_P(op);
			_P("("); _P(dregs(_W.dst)); _P(", "); _P(uimm5(_W.src));
			_P(")");
			break;
		case 2:
			_P(dregs(_W.dst));
			_P(" "); _P(op); _P(" ");
			_P(uimm5(_W.src));
	}

	return 2;
}


static int decode_COMP3op_0 (TIword iw0,
		disassemble_info *outf)
{
	int type = 0;
	char *op = "<unknown op>";
	_DECL16(COMP3op, iw0);

	switch (_W.opc) {
		case 0:
			op = "+"; break;
		case 1:
			op = "-"; break;
		case 2:
			op = "&"; break;
		case 3:
			op = "|"; break;
		case 4:
			op = "^"; break;
		case 5: // pregs
			type = 1; op = "+"; break;
		case 6:
			type = 2; op = "1"; break;
		case 7:
			type = 2; op = "2"; break;
	}

	switch (type) {
		case 0:
			_P(dregs(_W.dst)); _P(" = ");
			_P(dregs(_W.src0));
			_P(" "); _P(op); _P(" ");
			_P(dregs(_W.src1));
			break;
		case 1:
			_P(pregs(_W.dst)); _P(" = ");
			_P(pregs(_W.src0));
			_P(" "); _P(op); _P(" ");
			_P(pregs(_W.src1));
			break;
		case 2:
			_P(pregs(_W.dst)); _P(" = ");
			_P(pregs(_W.src0));
			_P(" + (");
			_P(pregs(_W.src1));
			_P(" << "); _P(op);
			_P(")");
			break;
	}
	return 2;
}

static int decode_COMPI2opD_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL16(COMPI2opD, iw0);

	if (_W.op) {
		_P(dregs(_W.dst)); _P(" += ");
		_P(imm7(_W.src));
	} else {
		_P(dregs(_W.dst)); _P(" = ");
		_P(imm7(_W.src));
		_P(" (x)");
	}

	return 2;
}
	

static int decode_COMPI2opP_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL16(COMPI2opP, iw0);

	if (_W.op) {
		_P(pregs(_W.dst)); _P(" += ");
		_P(imm7(_W.src));
	} else {
		_P(pregs(_W.dst)); _P(" = ");
		_P(imm7(_W.src));
		_P(" (x)");
	}

	return 2;
}

static int decode_LDSTpmod_0 (TIword iw0,
		disassemble_info *outf)
{
	_DECL16(LDSTpmod, iw0);

	if (_W.W) { // store (or sign expand modifier)
		switch (_W.aop) {
			case 0:
				_P("[");
				_P(pregs(_W.ptr));
				if (_W.idx != _W.ptr) {
					 _P(" ++ ");
					_P(pregs(_W.idx));
				}
				_P("] = ");
				_P(dregs(_W.reg)); 
				break;
			case 1:
				_P("w [");
				_P(pregs(_W.ptr));
				if (_W.idx != _W.ptr) {
					_P(" ++ ");
					_P(pregs(_W.idx));
				}
				_P("] = ");
				_P(dregs_lo(_W.reg)); 
				break;
			case 2:
				_P("w [");
				_P(pregs(_W.ptr));
				if (_W.idx != _W.ptr) {
					_P(" ++ ");
					_P(pregs(_W.idx));
				}
				_P("] = ");
				_P(dregs_hi(_W.reg)); 
				break;
			case 3: // special meaning here:
				_P(dregs(_W.reg)); _P(" = w [");
				_P(pregs(_W.ptr));
				if (_W.idx != _W.ptr) {
					_P(" ++ ");
					_P(pregs(_W.idx));
				}
				_P("] (x)");
				break;
		}
	} else { // load or zero expand modifier
		switch (_W.aop) {
			case 0:
				_P(dregs(_W.reg)); _P(" = [");
				_P(pregs(_W.ptr));
				if (_W.idx != _W.ptr) {
					_P(" ++ ");
					_P(pregs(_W.idx));
				}
				_P("]");
				break;
			case 1:
				_P(dregs_lo(_W.reg)); _P(" = w [");
				_P(pregs(_W.ptr));
				if (_W.idx != _W.ptr) {
					_P(" ++ ");
					_P(pregs(_W.idx));
				}
				_P("]");

				break;
			case 2:
				_P(dregs_hi(_W.reg)); _P(" = w [");
				_P(pregs(_W.ptr));
				if (_W.idx != _W.ptr) {
					_P(" ++ ");
					_P(pregs(_W.idx));
				}
				_P("]");
				break;
			case 3:
				_P(dregs(_W.reg)); _P(" = w [");
				_P(pregs(_W.ptr));
				if (_W.idx != _W.ptr) {
					_P(" ++ ");
					_P(pregs(_W.idx));
				}
				_P("] (z)");
				break;
		}
	}
	return 2;
}

static int decode_dagMODim_0 (TIword iw0,
		disassemble_info *outf)
{
	_DECL16(DagMODim, iw0);

	if (_W.op) {
		_P(iregs(_W.i)); _P(" -= ");
		_P(mregs(_W.m));
	} else {
		_P(iregs(_W.i)); _P(" += ");
		_P(mregs(_W.m));
	}
	if (_W.br)
		_P(" (brev)");
	return 2;
}

static int decode_dagMODik_0 (TIword iw0,
		disassemble_info *outf)
{
	char *op = "";
	_DECL16(DagMODik, iw0);

	switch (_W.op) {
		case 0: op = "+= 2"; break;
		case 1: op = "-= 2"; break;
		case 2: op = "+= 4"; break;
		case 3: op = "-= 4"; break;
	}

	_P(iregs(_W.i));
	_P(" "); _P(op);

	return 2;
}

static int decode_dspLDST_0 (TIword iw0,
		disassemble_info *outf)
{
	char *op = "";
	_DECL16(DspLDST, iw0);

	switch (_W.aop) {
		case 0: op = "++"; break;
		case 1: op = "--"; break;
		case 2: break;
		case 3: op = "++"; break;
	}

	if (_W.W) { // store
		if (_W.aop < 3) {
			switch (_W.m) {
				case 0:
					_P("["); _P(iregs(_W.i)); _P(op); _P("] = ");
					_P(dregs(_W.reg));
					break;
				case 1:
					_P("w ["); _P(iregs(_W.i)); _P(op); _P("] = ");
					_P(dregs_lo(_W.reg));
					break;
				case 2:
					_P("w ["); _P(iregs(_W.i)); _P(op); _P("] = ");
					_P(dregs_hi(_W.reg));
					break;
				default:
					return bad_opcode(0);
			}
		} else { // use mregs:
			_P("["); _P(iregs(_W.i)); _P(op); _P(mregs(_W.m)); _P("] = ");
			_P(dregs(_W.reg));
		}
	} else {
		if (_W.aop < 3) {
			switch (_W.m) {
				case 0:
					_P(dregs(_W.reg));
					_P(" = ["); _P(iregs(_W.i)); _P(op); _P("]");
					break;
				case 1:
					_P(dregs_lo(_W.reg));
					_P(" = w ["); _P(iregs(_W.i)); _P(op); _P("]");
					break;
				case 2:
					_P(dregs_hi(_W.reg));
					_P(" = w ["); _P(iregs(_W.i)); _P(op); _P("]");
					break;
				default:
					return bad_opcode(0);
			}
		} else { // use mregs:
			_P(dregs(_W.reg));
			_P(" = ["); _P(iregs(_W.i)); _P(op); _P(mregs(_W.m)); _P("]");
		}

	}
	return 2;
}

static int decode_LDST_0 (TIword iw0,
		disassemble_info *outf)
{
	char *op = "";
	char *size = "";
	_DECL16(LDST, iw0);

	switch (_W.aop) {
		case 0: op = "++"; break;
		case 1: op = "--"; break;
		case 2: break;
		default:
			return bad_opcode(0);
	}

	switch (_W.sz) { // size
		case 0: break;
		case 1: size = "w "; break;
		case 2: size = "b "; break;
		default:
			return bad_opcode(0);
	}


	if (_W.W) { // store ?
		_P(size); _P("["); _P(pregs(_W.ptr)); _P(op); _P("]");
		_P(" = ");
		if (_W.sz == 0 && _W.Z) 
			_P(pregs(_W.reg));
		else 
			_P(dregs(_W.reg));

	} else {
		if (_W.sz == 0 && _W.Z) 
			_P(pregs(_W.reg));
		else 
			_P(dregs(_W.reg));
		_P(" = ");
		_P(size); _P("["); _P(pregs(_W.ptr)); _P(op); _P("]");
		if (_W.sz != 0) {
			if (_W.Z) _P(" (x)");
			else      _P(" (z)");
		}
	}
	return 2;
}

static int decode_LDSTiiFP_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL16(LDSTiiFP, iw0);

	if (_W.W) { // store
		_P("["); _P("fp + "); _P(negimm5s4(_W.offset)); _P("]");
		_P(" = ");
		_P(dpregs(_W.reg));
	} else {
		_P(dpregs(_W.reg));
		_P(" = ");
		_P("["); _P("fp + "); _P(negimm5s4(_W.offset)); _P("]");
	}
	return 2;
}

static int decode_LDSTii_0 (TIword iw0,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL16(LDSTii, iw0);

	if (_W.W) {
		switch (_W.op) {
			case 0:
				_P("["); _P(pregs(_W.ptr)); 
				_P(" + "); _P(uimm4s4(_W.offset)); _P("]");
				_P(" = ");
				_P(dregs(_W.reg));
				break;
			case 1:
				_P("w ["); _P(pregs(_W.ptr)); 
				_P(" + "); _P(uimm4s2(_W.offset)); _P("]");
				_P(" = ");
				_P(dregs(_W.reg));
				break;
			case 3:
				_P("["); _P(pregs(_W.ptr)); 
				_P(" + "); _P(uimm4s4(_W.offset)); _P("]");
				_P(" = ");
				_P(pregs(_W.reg));
				break;
			default:
				return bad_opcode(0);
		}
	} else {
		switch (_W.op) {
			case 0:
				_P(dregs(_W.reg));
				_P(" = ");
				_P("["); _P(pregs(_W.ptr)); 
				_P(" + "); _P(uimm4s4(_W.offset)); _P("]");
				break;
			case 1:
				_P(dregs(_W.reg));
				_P(" = ");
				_P("w ["); _P(pregs(_W.ptr)); 
				_P(" + "); _P(uimm4s2(_W.offset)); _P("] (z)");
				break;
			case 2:
				_P(pregs(_W.reg));
				_P(" = ");
				_P("w ["); _P(pregs(_W.ptr)); 
				_P(" + "); _P(uimm4s2(_W.offset)); _P("] (x)");
				break;
			case 3:
				_P(pregs(_W.reg));
				_P(" = ");
				_P("["); _P(pregs(_W.ptr)); 
				_P(" + "); _P(uimm4s4(_W.offset)); _P("]");
				break;
		}
	}
	return 2;
}

static int decode_pseudoDEBUG_0 (TIword iw0,
		disassemble_info *outf)
{
	_DECL16(PseudoDbg, iw0);

	switch (_W.fn) {
		case 0:
			_P("dbg ");
			_P(allregs(_W.reg, _W.grp));
			break;
		case 1:
			_P("prnt ");
			_P(allregs(_W.reg, _W.grp));
			break;
		case 2:
			if (_W.grp != 0) return bad_opcode(0);
			_P("outc "); break;
			_P(dregs(_W.reg));
			break;
		case 3:
			switch (_W.reg) {
				case 0: _P("dbg a0");  break;
				case 1: _P("dbg a1");  break;
				case 3: _P("abort");   break;
				case 4: _P("hlt");     break;
				case 5: _P("dbghalt"); break;
				case 6:
					_P("dbgcmplx ");
					_P("(");
					_P(dregs(_W.grp));
					_P(")");
					break;
				case 7:
					_P("dbg");
					break;
				default: return bad_opcode(0);
			}
			break;
		default:
			return bad_opcode(0);
	}
	return 2;
}


////////////////////////////////////////////////////////////////////////////
// 32 BIT opcode
//

static int decode_LoopSetup_0 (TIword iw0, TIword iw1,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL32(LoopSetup, iw0, iw1);
	
	_P("lsetup (");
	_P(pcrel4(_W.soffset));
	_P(", ");
	_P(lppcrel10(_W.eoffset));
	_P(") ");
	_P(counters(_W.c));

	switch (_W.rop) {
		case 0: break;
		case 1: _P(" = "); _P(pregs(_W.reg)); break;
		case 3: _P(" = "); _P(pregs(_W.reg)); _P(" >> 1");  break;
		default: return bad_opcode(1);
	}
	return 4;
}

static int decode_LDIMMhalf_0 (TIword iw0, TIword iw1,
		bfd_vma pc,  disassemble_info *outf)
{

	_DECL32(LDIMMhalf, iw0, iw1);

	if (_W.S) { // saturate ?
		_P(regs(_W.reg, _W.grp));
        _P(" = ");
        _P(imm16(_W.hword));
        _P(" (x)");
	} else
	if (_W.Z) { // zero extend
		_P(regs(_W.reg, _W.grp));
        _P(" = ");
        _P(luimm16(_W.hword));
        _P(" (z)");

	} else 
	if (_W.Z == 0) {
		if (_W.H) {
			_P(regs_hi(_W.reg, _W.grp));
		} else {
			_P(regs_lo(_W.reg, _W.grp));
		}

        _P(" = ");
        _P(luimm16(_W.hword));
	} else {
		return bad_opcode(1);
	}
	return 4;
}

static int decode_CALLa_0 (TIword iw0, TIword iw1,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL32(CALLa, iw0, iw1);

	if (_W.S) {
		_P("call ");
		_P(pcrel24(_W.addr));
	} else {
		_P("jump.l ");
		_P(pcrel24(_W.addr));
	}
	return 4;
}

static int decode_LDSTidxI_0 (TIword iw0, TIword iw1,
		bfd_vma pc,  disassemble_info *outf)
{
	char *size = "";
	char *mod = "";
	_DECL32(LDSTidxI, iw0, iw1);

	switch (_W.sz) { // size
		case 0: break;
		case 1: size = "w "; break;
		case 2: size = "b "; break;
		default:
			return bad_opcode(1);
	}

	if (_W.sz != 0) {
		if (_W.Z) 
			mod = " (x)";
		else
			mod = " (z)";
	}

	if (_W.W) { // store
		_P(size); _P("[");
		_P(pregs(_W.ptr)); _P(" + ");
		switch (_W.sz) {
			case 0:
				_P(imm16s4(_W.offset)); break;
			case 1:
				_P(imm16s2(_W.offset)); break;
			case 2:
				_P(imm16(_W.offset)); break;
		}
		_P("]");
		_P(" = ");
		if (_W.sz == 0 && _W.Z) // special case pregs
			_P(pregs(_W.reg)); 
		else
			_P(dregs(_W.reg)); 
	} else { // load
		if (_W.sz == 0 && _W.Z) // special case pregs
			_P(pregs(_W.reg)); 
		else
			_P(dregs(_W.reg)); 
		_P(" = ");
		_P(size); _P("[");
		_P(pregs(_W.ptr)); _P(" + ");
		switch (_W.sz) {
			case 0:
				_P(imm16s4(_W.offset)); break;
			case 1:
				_P(imm16s2(_W.offset)); break;
			case 2:
				_P(imm16(_W.offset)); break;
		}
		_P("]"); _P(mod);
	}
	return 4;
}

static int decode_linkage_0 (TIword iw0, TIword iw1,
		bfd_vma pc,  disassemble_info *outf)
{

	_DECL32(Linkage, iw0, iw1);

	if (_W.R) {
		_P("unlink");
	} else {
		_P("link ");
        _P(uimm16s4(_W.framesize));
	}
	return 4;
}


static int decode_dsp32mac_0 (TIword iw0, TIword iw1,
		disassemble_info *outf)
{
	_DECL32(DSP32Mac, iw0, iw1);

	if (_W.P) { // full reg mac
		if (_W.w1) {
			_P(dregs(_W.dst | 1)); _P(" = ");
		}
		if (_W.op1 != 3) {
			_P("(");
			decode_macfunc(1, _W.op1, _W.h01, _W.h11, _W.src0, _W.src1, outf);
			_P(")");
			if (_W.MM)
				_P(" (m)");
		} else if (_W.w1) {
			_P("a1");
		} 

		_P(", ");

		if (_W.w0) {
			_P(dregs(_W.dst)); _P(" = ");
		}
		if (_W.op0 != 3) {
			_P("(");
			decode_macfunc(0, _W.op0, _W.h00, _W.h10, _W.src0, _W.src1, outf);
			_P(")");
		} else if (_W.w0) {
			_P("a0");
		}
	
		decode_optmode(_W.mmod, outf);

	} else {

		if (_W.w1) {
			_P(dregs_hi(_W.dst)); _P(" = ");
		}
		if (_W.op1 != 3) {
			_P("(");
			decode_macfunc(1, _W.op1, _W.h01, _W.h11, _W.src0, _W.src1, outf);
			_P(")");
			if (_W.MM)
				_P(" (m)");
		} else if (_W.w1) {
			_P("a1");
		} 

		_P(", ");

		if (_W.w0) {
			_P(dregs_lo(_W.dst)); _P(" = ");
		}

		if (_W.op0 != 3) {
			_P("(");
			decode_macfunc(0, _W.op0, _W.h00, _W.h10, _W.src0, _W.src1, outf);
			_P(")");
		} else if (_W.w0) {
			_P("a0");
		}

		decode_optmode(_W.mmod, outf);

	}

	return 4;
}

static int decode_dsp32mult_0 (TIword iw0, TIword iw1,
		disassemble_info *outf)
{

	_DECL32(DSP32Mult, iw0, iw1);

	if (_W.P) { // full reg mac
		if (_W.w1) { // odd dreg assignment
			_P(dregs(_W.dst | 1)); _P(" = ");
			decode_multfunc(_W.h01, _W.h11, _W.src0, _W.src1, outf);
		}
		if (_W.MM)
			_P(" (m)");

		_P(", ");

		if (_W.w0) {
			_P(dregs(_W.dst)); _P(" = ");
			decode_multfunc(_W.h00, _W.h10, _W.src0, _W.src1, outf);
		}

		decode_optmode(_W.mmod, outf);

	} else {

		if (_W.w1) {
			_P(dregs_hi(_W.dst)); _P(" = ");
			decode_multfunc(_W.h01, _W.h11, _W.src0, _W.src1, outf);
		}

		if (_W.MM)
			_P(" (m)");

		_P(", ");

		if (_W.w0) {
			_P(dregs_lo(_W.dst)); _P(" = ");
			decode_multfunc(_W.h00, _W.h10, _W.src0, _W.src1, outf);
		}

		decode_optmode(_W.mmod, outf);

	}

	return 4;
}

static int decode_dsp32alu_0(TIword iw0, TIword iw1,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL32(DSP32Alu, iw0, iw1);

	// printf("dsp32alu: %d\n", _W.aopcde);

	switch (_W.aopcde) {
		case 0: // bar operation
			_P(dregs(_W.dst0));
			_P(" = ");
			_P(dregs(_W.src0));
			_P(" "); decode_op_bar_op(_W.aop, outf); _P(" ");
			_P(dregs(_W.src1));
			amod0(_W.s, _W.x, outf);
			break;

		case 1:
			_P(dregs(_W.dst1));
			_P(" = ");
			_P(dregs(_W.src0));
			if (_W.HL) {
				_P(" +|- ");
				_P(dregs(_W.src1));
				_P(", ");
				_P(dregs(_W.dst0));
				_P(" = ");
				_P(dregs(_W.src0));
				_P(" -|+ ");
			} else {
				_P(" +|+ ");
				_P(dregs(_W.src1));
				_P(", ");
				_P(dregs(_W.dst0));
				_P(" = ");
				_P(dregs(_W.src0));
				_P(" -|- ");
			}
			_P(dregs(_W.src1));
			decode_amod2(_W.s, _W.x, _W.aop, outf);
			break;

		case 2:
			if (_W.HL) _P(dregs_hi(_W.dst0));
			else      _P(dregs_lo(_W.dst0));
			_P(" = ");
			switch (_W.aop) {
				case 0:
					_P(dregs_lo(_W.src0)); _P(" + "); _P(dregs_lo(_W.src1));
					break;
				case 1:
					_P(dregs_lo(_W.src0)); _P(" + "); _P(dregs_hi(_W.src1));
					break;
				case 2:
					_P(dregs_hi(_W.src0)); _P(" + "); _P(dregs_lo(_W.src1));
					break;
				case 3:
					_P(dregs_hi(_W.src0)); _P(" + "); _P(dregs_hi(_W.src1));
					break;
			}
			decode_amod1(_W.s, _W.x, outf);
			break;

		case 3:

			if (_W.HL) _P(dregs_hi(_W.dst0));
			else      _P(dregs_lo(_W.dst0));
			_P(" = ");
			switch (_W.aop) {
				case 0:
					_P(dregs_lo(_W.src0)); _P(" - "); _P(dregs_lo(_W.src1));
					break;
				case 1:
					_P(dregs_lo(_W.src0)); _P(" - "); _P(dregs_hi(_W.src1));
					break;
				case 2:
					_P(dregs_hi(_W.src0)); _P(" - "); _P(dregs_lo(_W.src1));
					break;
				case 3:
					_P(dregs_hi(_W.src0)); _P(" - "); _P(dregs_hi(_W.src1));
					break;
			}
			decode_amod1(_W.s, _W.x, outf);
			break;


		case 4:
			if (_W.aop == 2) {
				_P(dregs(_W.dst1));
				_P(" = ");
				_P(dregs(_W.src1));
				_P(" + ");
				_P(dregs(_W.src0));
				_P(", ");
				_P(dregs(_W.src1));
				_P(" - ");
				_P(dregs(_W.src0));
				decode_amod1(_W.s, _W.x, outf);
			} else {
				_P(dregs(_W.dst0));
				_P(" = ");
				_P(dregs(_W.src0));
				if (_W.aop) _P(" - ");
				else        _P(" + ");
				_P(dregs(_W.src1));
				amod0(_W.s, _W.x, outf);
			}
			
			break;
		case 5:
			if (_W.HL) _P(dregs_hi(_W.dst0));
			else      _P(dregs_lo(_W.dst0));
			_P(" = ");

			_P(dregs(_W.src0));

			if (_W.aop & 1) _P(" - ");
			else           _P(" + ");

			_P(dregs(_W.src1));

			if (_W.aop & 2) 
				_P(" (rnd20)");
			else
				_P(" (rnd12)");
			break;

		case 6:
			if (_W.aop & 2) {
				_P(dregs(_W.dst0));
				_P(" = abs ");
				_P(dregs(_W.src0));
			} else {
				_P(dregs(_W.dst0));
				if (_W.aop & 1) _P(" = min ");
				else            _P(" = max ");
				_P("(");
				_P(dregs(_W.src0));
				_P(", ");
				_P(dregs(_W.src1));
				_P(")");
			}
			_P(" (v)");
			break;

		case 7:
			if (_W.aop & 2) {
				_P(dregs(_W.dst0));
				_P(" = abs ");
				_P(dregs(_W.src0));
			} else {
				_P(dregs(_W.dst0));
				if (_W.aop & 1) _P(" = min ");
				else            _P(" = max ");
				_P("(");
				_P(dregs(_W.src0));
				_P(", ");
				_P(dregs(_W.src1));
				_P(")");
			}

			break;

		case 8:
			if (_W.aop == 3) {
				if (_W.s)
					_P("a1 = a0");
				else 
					_P("a0 = a1");
			} else 
			if (_W.s == 1) {
				if (_W.aop == 2) {
					_P("a1 = a1 (s), ");
					_P("a0 = a0 (s)");
				} else
				if (_W.aop == 1)
					_P("a1 = a1 (s)");
				else
					_P("a0 = a0 (s)");
			} else 
			if (_W.aop == 2) {
				_P("a1 = a0 = 0");
			} else 
			if (_W.s == 0) {
				if (_W.aop & 1) _P("a1 = 0");
				else            _P("a0 = 0");
			} else
				return bad_opcode(1);

			break;

		case 9:
			if (_W.s) {
				if (_W.aop & 2) _P("a1 = ");
				else            _P("a0 = ");

				_P(dregs(_W.src0));

			} else {
				if (_W.aop & 1) {
					if (_W.aop & 2) _P("a1.x = ");
					else           _P("a0.x = ");

					_P(dregs_lo(_W.src0));

				} else {
					if (_W.aop & 2) _P("a1.");
					else            _P("a0.");
					if (_W.HL) _P("h");
					else       _P("l");
					_P(" = ");
					if (_W.HL) _P(dregs_hi(_W.src0));
					else      _P(dregs_lo(_W.src0));
				}
			}

			break;
		case 10:
			_P(dregs_lo(_W.dst0)); _P(" = ");
			if (_W.aop & 1) {
				_P("a1.x");
			} else {
				_P("a0.x");
			}
			break;

		case 11:
			if (_W.aop & 2) {
				_P("a0");
				if (_W.aop & 1) _P(" -= ");
				else            _P(" += ");
				_P("a1");
				if (_W.s) _P(" (w32)");
			} else
			if (_W.aop & 1) {
				if (_W.HL) {
					_P(dregs_hi(_W.dst0));
				} else {
					_P(dregs_lo(_W.dst0));
				}
				_P(" = (a0 += a1)");
			} else {
				_P(dregs(_W.dst0)); _P(" = (a0 += a1)");
			}
			break;

		case 12:
			if (_W.aop == 3) {
				if (_W.HL) _P(dregs_hi(_W.dst0));
				else      _P(dregs_lo(_W.dst0));

				_P(" = ");

				_P(dregs(_W.src0));
				_P(" (rnd)");

			} else if (_W.aop == 0) {
				_P(dregs_hi(_W.dst0)); _P(" = ");
				_P(dregs_lo(_W.dst1)); _P(" = ");
				_P("sign (");
				_P(dregs_hi(_W.src0));
				_P(") * ");
				_P(dregs_hi(_W.src1));
				_P(" + sign(");
				_P(dregs_lo(_W.src0));
				_P(") * ");
				_P(dregs_lo(_W.src1));
				break;
			} else {
				return bad_opcode(1);
			}
			break;

		case 13:
			_P("("); _P(dregs(_W.dst1)); _P(", "); _P(dregs(_W.dst0)); _P(")");
			_P(" = ");
			_P("search ");
			_P(dregs(_W.src0));
			decode_searchmod(_W.aop, outf);
			break;

		case 14:
			if (_W.aop & 1) _P("a1");
			else           _P("a0");
			_P(" = -");
			if (_W.aop & 1) _P("a1");
			else           _P("a0");
			break;

		case 15:
			_P(dregs(_W.dst0));
			_P(" = -");
			_P(dregs(_W.src0));

			if (_W.s) _P(" (s)");
			else      _P(" (v)");
			break;

		case 16:
			if (_W.aop == 3) {
				_P("a1 = abs a1, a0 = abs a0");
			} else {
				if (_W.HL & 1) _P("a1");
				else            _P("a0");
				_P(" = abs ");
				if (_W.aop & 1) _P("a1");
				else            _P("a0");
			}
			break;

		case 17:
			if (_W.aop == 1) {
				_P(dregs(_W.dst1));
				_P(" = ");
				_P("a0 + a1, ");
				_P(dregs(_W.dst0));
				_P(" = ");
				_P("a0 - a1");
				decode_amod1(_W.s, _W.x, outf);
			} else 
			if (_W.aop == 0) {
				_P(dregs(_W.dst1));
				_P(" = ");
				_P("a1 + a0, ");
				_P(dregs(_W.dst0));
				_P(" = ");
				_P("a1 - a0");
				decode_amod1(_W.s, _W.x, outf);
			} else {
				return bad_opcode(1);
			}
			break;

		case 18:
			if (_W.aop == 3) {
				_P("disalignexcpt");
			} else
			if (_W.aop == 0) {
				_P("saa ");
				_P("(");
				_P(dregs(_W.src0)); _P(":"); _P(imm5(_W.src0 - 1));
				_P(", ");
				_P(dregs(_W.src1)); _P(":"); _P(imm5(_W.src1 - 1));
				_P(")");

				if (_W.s) {
					_P(" (r)");
				}
			} else {
				return bad_opcode(1);
			}
			break;

		case 20:

			_P(dregs(_W.dst0));
			_P(" = ");
			_P("byteop1p");

			_P("(");
			_P(dregs(_W.src0)); _P(":"); _P(imm5(_W.src0 - 1));
			_P(", ");
			_P(dregs(_W.src1)); _P(":"); _P(imm5(_W.src1 - 1));
			_P(")");
			if (_W.aop) {
				if (_W.s)
					_P(" (t, r)");
				else
					_P(" (t)");
				break;
			} else {
				_P(" (r)");
			}
			break;

		case 21:
			_P("("); _P(dregs(_W.dst1)); _P(", "); _P(dregs(_W.dst0)); _P(")");
			_P(" = ");
			if (_W.aop) { 
				_P("byteop16m");
			} else {
				_P("byteop16p");
			}
			_P("(");
			_P(dregs(_W.src0)); _P(":"); _P(imm5(_W.src0 - 1));
			_P(", ");
			_P(dregs(_W.src1)); _P(":"); _P(imm5(_W.src1 - 1));
			_P(")");
			if (_W.s)
				_P(" (r)");

			break;

		case 22:
			_P(dregs(_W.dst0));
			_P(" = ");

			if (_W.aop & 2) {
				_P("byteop2p");
			} else {
				_P("byteop2m");
			}

			_P("(");
			_P(dregs(_W.src0)); _P(":"); _P(imm5(_W.src0 - 1));
			_P(", ");
			_P(dregs(_W.src1)); _P(":"); _P(imm5(_W.src1 - 1));
			_P(")");
			if (_W.aop & 1) {
				if (_W.HL) _P(" (th");
				else      _P(" (tl");
			} else {
				if (_W.HL) _P(" (rndh");
				else      _P(" (rndl");
			}

			if (_W.s) _P(", r)");
			else     _P(")");

			break;

		case 23:
			_P(dregs(_W.dst0));
			_P(" = ");

			_P("byteop3p");

			_P("(");
			_P(dregs(_W.src0)); _P(":"); _P(imm5(_W.src0 - 1));
			_P(", ");
			_P(dregs(_W.src1)); _P(":"); _P(imm5(_W.src1 - 1));
			_P(")");

			if (_W.HL)
				_P(" (lo");
			else
				_P(" (hi");

			if (_W.s)
				_P(", r)");
			else 
				_P(")");

			break;

		case 24:
			if (_W.aop == 1) {
			_P("("); _P(dregs(_W.dst1)); _P(", "); _P(dregs(_W.dst0)); _P(")");
			_P(" = ");
			_P("byteunpack");
			_P(dregs(_W.src0)); _P(":"); _P(imm5(_W.src0 - 1));
			if (_W.s)
				_P(" (r)");
			}
			break;
		default:
			printf("opcode: %d\n", _W.aopcde);
			return bad_opcode(1);
	}
	return 4;
}

static int decode_dsp32shift_0 (TIword iw0, TIword iw1,
		disassemble_info *outf)
{
	char *reg;
	_DECL32(DSP32Shift, iw0, iw1);

	switch (_W.sopcde)
	{
		case 0:
			// ("dregs_lo = ASHIFT dregs_lo BY dregs_lo");
			if (_W.HLs & 2) _P(dregs_hi(_W.dst0));
			else           _P(dregs_lo(_W.dst0));

			_P(" = ");
			if (_W.sop & 2) _P("lshift ");
			else            _P("ashift ");
			if (_W.HLs & 2) _P(dregs_hi(_W.src1));
			else           _P(dregs_lo(_W.src1));
			_P(" by ");
			_P(dregs_lo(_W.src0));
			if (_W.sop & 1)
				_P(" (s)");
			break;
		case 1:
		case 2:
			_P(dregs(_W.dst0));
			_P(" = ");
			if (_W.sop & 2) _P("lshift ");
			else            _P("ashift ");
			_P(dregs(_W.src1));

			_P(" by ");
			_P(dregs_lo(_W.src0));

			if (_W.sopcde == 1) {
				_P(" (v");
				if (_W.sop & 1)
					_P(", s)");
				else
					_P(")");
			} else
			if (_W.sop & 1) 
				_P(" (s)");

			break;
		case 3:
			switch (_W.sop) {
				case 0:
					if (_W.HLs & 1) reg = "a1";
					else            reg = "a0";

					_P(reg);
					_P(" = ashift ");
					_P(reg);

					_P(" by ");
					_P(dregs_lo(_W.src0));
					break;
				case 1:
					if (_W.HLs & 1) reg = "a1";
					else            reg = "a0";

					_P(reg);
					_P(" = lshift ");
					_P(reg);

					_P(" by ");
					_P(dregs_lo(_W.src0));
					break;
				case 2:
					if (_W.HLs & 1) reg = "a1";
					else           reg = "a0";

					_P(reg);
					_P(" = rot ");
					_P(reg);

					_P(" by ");
					_P(dregs_lo(_W.src0));
					break;
				case 3:
					_P(dregs(_W.dst0));
					_P(" = rot ");
					_P(dregs(_W.src1));

					_P(" by ");
					_P(dregs_lo(_W.src0));
					break;
			}
			break;

		case 4:
			_P(dregs(_W.dst0));
			_P(" = pack");
			_P("(");
			if (_W.sop & 2) _P(dregs_hi(_W.src1));
			else            _P(dregs_lo(_W.src1));
			_P(", ");
			if (_W.sop & 1) _P(dregs_hi(_W.src0));
			else            _P(dregs_lo(_W.src0));
			_P(")");
			break;
	
		case 5:
			_P(dregs_lo(_W.src1));
			_P(" = ");
			_P("signbits ");
			if (_W.sop == 0) {
				_P(dregs(_W.src1));
			} else
			if (_W.sop == 1) {
				_P(dregs_lo(_W.src1));
			} else 
			if (_W.sop == 2) {
				_P(dregs_hi(_W.src1));
			} else {
				return bad_opcode(1);
			}

			break;

		case 6:
			if (_W.sop == 3) {
				_P(dregs_lo(_W.dst0));
				_P(" = ");
				_P("ones ");
				_P(dregs(_W.src1));
			} else {
				_P(dregs_lo(_W.src1));
				_P(" = ");
				_P("signbits ");
				if (_W.sop == 0)
					_P("a0");
				else
				if (_W.sop == 1)
					_P("a1");
				else return bad_opcode(1);
			}

			break;



		case 7:
			_P(dregs_lo(_W.dst0));
			_P(" = expadj");
			_P("(");

			if (_W.sop & 2) {
				if (_W.sop & 1) _P(dregs_hi(_W.src1));
				else             _P(dregs_lo(_W.src1));
			} else {
				_P(dregs(_W.src1));
			}

			_P(", ");
			_P(dregs_lo(_W.src0));
			_P(")");

			if (_W.sop == 1)
				_P(" (v)");
			break;

		case 8:
			_P("bitmux ");
			_P("(");
				_P(dregs(_W.src0));
				_P(", ");
				_P(dregs(_W.src1));
				_P(", a0");
			_P(")");

			if (_W.sop & 1) _P(" (asl)");
			else            _P(" (asr)");
			break;
			
		case 9:
			if (_W.sop & 2) {
				_P(dregs_lo(_W.dst0));
				_P(" = ");
				_P("vit_max");
				_P("(");
				_P(dregs(_W.src1));
				_P(", ");
				_P(dregs(_W.src0));
				_P(")");
			} else {
				_P(dregs_lo(_W.dst0));
				_P(" = ");
				_P("vit_max");
				_P("(");
				_P(dregs(_W.src1));
				_P(")");
			}
			if (_W.sop & 1) _P(" (asr)");
			break;


		case 10:
			if (_W.sop & 2) {
				_P(dregs(_W.dst0));
				_P(" = ");
				_P("deposit");
				_P("(");
				_P(dregs(_W.src1));
				_P(", ");
				_P(dregs(_W.src0));
				_P(")");

			} else {
				_P(dregs(_W.dst0));
				_P(" = ");
				_P("extract");
				_P("(");
				_P(dregs(_W.src1));
				_P(", ");
				_P(dregs_lo(_W.src0));
				_P(")");

			}

			if (_W.sop & 1) _P(" (x)");
			break;

		case 11:
			_P(dregs_lo(_W.dst0));
			_P(" = ");
			_P("cc = ");
			if (_W.sop & 1) {
				_P("bxor");
			} else {
				_P("bxorshift");
			}
			_P("(");
			_P("a0");
			_P(", ");
			_P(dregs(_W.src0));
			_P(")");
			break;

		case 12:
			_P(dregs_lo(_W.dst0));
			_P(" = ");
			_P("cc = ");
			if (_W.sop & 1) {
				_P("bxor");
			} else {
				_P("bxorshift");
			}
			_P("(a0, a1, cc)");
			break;


		case 13:
			_P(dregs(_W.dst0));
			_P(" = ");
			_P("align8 ");
			_P("(");
			_P(dregs(_W.src1));
			_P(", ");
			_P(dregs(_W.src0));
			_P(")");
			break;
		default:
			return bad_opcode(1);
		}
	return 4;
}

static int decode_dsp32shiftimm_0 (TIword iw0, TIword iw1,
		bfd_vma pc,  disassemble_info *outf)
{
	char *reg;
	int immval;
	_DECL32(DSP32ShiftImm, iw0, iw1);

	immval = SIGNEXTEND(_W.immag, 6);
	switch (_W.sopcde) {
		case 0:
			if (_W.sop == 3) return bad_opcode(1);

			if (_W.HLs & 2) _P(dregs_hi(_W.dst0));
			else            _P(dregs_lo(_W.dst0));
			_P(" = ");
			if (_W.HLs & 1) _P(dregs_hi(_W.src1));
			else            _P(dregs_lo(_W.src1));
			if (_W.sop & 2) {
				_P(" >> "); _P(imm6(-_W.immag));
			} else {
				if (immval < 0) {
					_P(" >>> "); _P(imm6(-_W.immag));
				} else {
					_P(" << "); _P(imm6(_W.immag));
				}
			}


			if (_W.sop & 1) {
				_P(" (s)");
			}

			break;

		case 1:
			_P(dregs(_W.dst0));
			_P(" = ");
			_P(dregs(_W.src1));

			if (immval < 0) {
				_P(" >>> ");
				_P(uimm5(-_W.immag));
			} else {
				_P(" << ");
				_P(imm6(_W.immag));
			}

			if (_W.sop & 1)  _P(" (v, s)");
			else             _P(" (v)");
			break;
		
		case 2:
			_P(dregs(_W.dst0));
			_P(" = ");
			if (_W.sop == 3) {
				_P("rot ");
				_P(dregs(_W.src1));
				_P(" by ");
				_P(imm6(_W.immag));
			} else {
				_P(dregs(_W.src1));
				if (immval < 0) {
					_P(" >>> "); _P(imm6(-_W.immag));
				} else {
					_P(" << "); _P(imm6(_W.immag));
				}
			}

			if (_W.sop == 1) {
				_P(" (s)");
			}
			break;

		case 3:
			if (_W.HLs & 1) reg = "a1";
			else           reg = "a0";

			if (_W.sop == 0) {
				_P(reg); _P(" = "); _P(reg);
				if (immval < 0) {
					_P(" >>> "); _P(uimm5(-immval));
				} else {
					_P(" << "); _P(imm6(_W.immag));
				}
			} else
			if (_W.sop == 1) {
				_P(reg); _P(" = "); _P(reg);
				_P(" >> "); 
				_P(imm6(_W.immag));
			} else
			if (_W.sop == 2) {
				_P(reg); _P(" = rot "); _P(reg);
				_P(" by "); 
				_P(imm6(_W.immag));
			} else
				return bad_opcode(1);
			break;
		default:
			return bad_opcode(1);
	}
	return 4;
}



static int decode_psedodbg_assert_0 (TIword iw0, TIword iw1,
		bfd_vma pc,  disassemble_info *outf)
{
	_DECL32(PseudoDbg_Assert, iw0, iw1);

	switch (_W.dbgop) {
		case 0:
			_P("dbg "); 
			_P("("); 
			_P(dregs_lo(_W.regtest));
			_P(", "); 
			_P(uimm16(_W.expected));
			_P(")"); 
			break;
		case 1:
			_P("dbg "); 
			_P("("); 
			_P(dregs_hi(_W.regtest));
			_P(", "); 
			_P(uimm16(_W.expected));
			_P(")"); 
			break;
		case 2:
			_P("dbgal "); 
			_P("("); 
			_P(dregs(_W.regtest));
			_P(", "); 
			_P(uimm16(_W.expected));
			_P(")"); 
			break;
		case 3:
			_P("dbgah "); 
			_P("("); 
			_P(dregs(_W.regtest));
			_P(", "); 
			_P(uimm16(_W.expected));
			_P(")"); 
			break;
		default:
			return bad_opcode(1);
	}
	return 4;
}


////////////////////////////////////////////////////////////////////////////

int _print_insn_bfin (bfd_vma pc, disassemble_info *outf)
{

  bfd_byte buf[4];
    TIword iw0;
    TIword iw1;
    int status;
    status = (*outf->read_memory_func) (pc & ~ 0x1, buf, 2, outf);
    status = (*outf->read_memory_func) ((pc + 2) & ~ 0x1, buf + 2, 2, outf);

    iw0 = bfd_getl16 (buf);
    iw1 = bfd_getl16 (buf+2);

	if (/* mnop */ (iw0 == 0xc803) && (iw1 == 0x1800)) {
		_P("mnop");
		return 4;

	} else if (/* ProgCtrl */
	       ((iw0 & 0xff00) == 0x0000)) {

	  int rv = decode_ProgCtrl_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* CaCTRL */
	              ((iw0 & 0xffc0) == 0x0240)) {

	  int rv = decode_CaCTRL_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* PushPopReg */
	              ((iw0 & 0xff80) == 0x0100)) {

	  int rv = decode_PushPopReg_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* PushPopMultiple */
	              ((iw0 & 0xfe00) == 0x0400)) {

	  int rv = decode_PushPopMultiple_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* ccMV */
	              ((iw0 & 0xfe00) == 0x0600)) {

	  int rv = decode_ccMV_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* CCflag */
	              ((iw0 & 0xf800) == 0x0800)) {

	  int rv = decode_CCflag_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* CC2dreg */
	              ((iw0 & 0xffe0) == 0x0200)) {

	  int rv = decode_CC2dreg_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* CC2stat */
	              ((iw0 & 0xff00) == 0x0300)) {

	  int rv = decode_CC2stat_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* BRCC */
	              ((iw0 & 0xf000) == 0x1000)) {

	  int rv = decode_BRCC_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* UJUMP */
	              ((iw0 & 0xf000) == 0x2000)) {

	  int rv = decode_UJUMP_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* REGMV */
	              ((iw0 & 0xf000) == 0x3000)) {

	  int rv = decode_REGMV_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* ALU2op */
	              ((iw0 & 0xfc00) == 0x4000)) {

	  int rv = decode_ALU2op_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* PTR2op */
	              ((iw0 & 0xfe00) == 0x4400)) {

	  int rv = decode_PTR2op_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* LOGI2op */
	              ((iw0 & 0xf800) == 0x4800)) {

	  int rv = decode_LOGI2op_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* COMP3op */
	              ((iw0 & 0xf000) == 0x5000)) {

	  int rv = decode_COMP3op_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* COMPI2opD */
	              ((iw0 & 0xf800) == 0x6000)) {

	  int rv = decode_COMPI2opD_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* COMPI2opP */
	              ((iw0 & 0xf800) == 0x6800)) {

	  int rv = decode_COMPI2opP_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* LDSTpmod */
	              ((iw0 & 0xf000) == 0x8000)) {

	  int rv = decode_LDSTpmod_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* dagMODim */
	              ((iw0 & 0xff60) == 0x9e60)) {

	  int rv = decode_dagMODim_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* dagMODik */
	              ((iw0 & 0xfff0) == 0x9f60)) {

	  int rv = decode_dagMODik_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* dspLDST */
	              ((iw0 & 0xfc00) == 0x9c00)) {

	  int rv = decode_dspLDST_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* LDST */
	              ((iw0 & 0xf000) == 0x9000)) {

	  int rv = decode_LDST_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* LDSTiiFP */
	              ((iw0 & 0xfc00) == 0xb800)) {

	  int rv = decode_LDSTiiFP_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* LDSTii */
	              ((iw0 & 0xe000) == 0xA000)) {

	  int rv = decode_LDSTii_0 (iw0, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* LoopSetup */
	              ((iw0 & 0xff80) == 0xe080)
	           && ((iw1 & 0x0C00) == 0x0000)) {

	  int rv = decode_LoopSetup_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* LDIMMhalf */
	              ((iw0 & 0xff00) == 0xe100)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_LDIMMhalf_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* CALLa */
	              ((iw0 & 0xfe00) == 0xe200)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_CALLa_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* LDSTidxI */
	              ((iw0 & 0xfc00) == 0xe400)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_LDSTidxI_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* linkage */
	              ((iw0 & 0xfffe) == 0xe800)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_linkage_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	  /* <strubi> changes: add support for accu to half register moves, etc. */
	} else if (/* dsp32mac */
	              ((iw0 & 0xf600) == 0xc000)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_dsp32mac_0 (iw0, iw1, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* dsp32mult */
	              ((iw0 & 0xf600) == 0xc200)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_dsp32mult_0 (iw0, iw1, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* dsp32alu */
	              ((iw0 & 0xf7c0) == 0xc400)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_dsp32alu_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* dsp32shift */
	              ((iw0 & 0xf780) == 0xc600)
	           && ((iw1 & 0x01c0) == 0x0000)) {

	  int rv = decode_dsp32shift_0 (iw0, iw1, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

	} else if (/* dsp32shiftimm */
	              ((iw0 & 0xf780) == 0xc680)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_dsp32shiftimm_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;
	} else if (/* psedoDEBUG */
	              ((iw0 & 0xff00) == 0xf800)) {

	  int rv = decode_pseudoDEBUG_0 (iw0, outf);
	  if (rv) return rv;
	  goto illegal_instruction;

#if 0
	} else if (/* psedoOChar */
	              ((iw0 & 0xFF00) == 0xF900)) {

	  int rv = decode_psedoOChar_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;
#endif

	} else if (/* psedodbg_assert */
	              ((iw0 & 0xFFC0) == 0xf000)
	           && ((iw1 & 0x0000) == 0x0000)) {

	  int rv = decode_psedodbg_assert_0 (iw0, iw1, pc, outf);
	  if (rv) return rv;
	  goto illegal_instruction;
	}

illegal_instruction:
  return 0;
}

int print_insn_bfin(bfd_vma pc, disassemble_info *outf)
{
    short iw0  = 0;
    int status = 0;
    int count  = 0;
    status = (*outf->read_memory_func) (pc & ~0x01, (bfd_byte *) &iw0, 2, outf);
    
    count += _print_insn_bfin (pc, outf);
	// Proper display of multiple issue instructions
    if ((iw0 & 0xc000) == 0xc000 && (iw0 & BIT_MULTI_INS)
	 && ((iw0 & 0xe800) != 0xe800 /* not Linkage */ ) ) {
		outf->fprintf_func (outf->stream, " || ");
		count += _print_insn_bfin (pc+4, outf);
		outf->fprintf_func (outf->stream, " || ");
		count += _print_insn_bfin (pc+6, outf);
    }
    if (count == 0) {
	outf->fprintf_func (outf->stream, "ILLEGAL");
	return 2;
    }
    outf->fprintf_func (outf->stream, ";");
    return count;
}


