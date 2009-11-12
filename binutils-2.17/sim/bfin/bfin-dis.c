/* Simulator for Analog Devices Blackfin processer.

   Copyright (C) 2005 Free Software Foundation, Inc.
   Contributed by Analog Devices.

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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

#include "gdb/signals.h"
#include "opcode/bfin.h"
#include "bfin-sim.h"


#define M_S2RND 1
#define M_T     2
#define M_W32   3
#define M_FU    4
#define M_TFU   6
#define M_IS    8
#define M_ISS2  9
#define M_IH    11
#define M_IU    12

#define HOST_LONG_WORD_SIZE (sizeof(long)*8)

#define SIGNEXTEND(v, n) (((bs32)v << (HOST_LONG_WORD_SIZE - (n))) >> (HOST_LONG_WORD_SIZE - (n)))

/* For dealing with parallel instructions, we must avoid changing our register
   file until all parallel insns have been simulated.  This queue of stores
   can be used to delay a modification.
   @@@ Should go and convert all 32 bit insns to use this.  */
struct store {
  bu32 *addr;
  bu32 val;
};

struct store stores[20];
int n_stores;

#define STORE(X,Y) do { \
    stores[n_stores].addr = &(X); \
    stores[n_stores++].val = (Y); \
  } while (0)

static __attribute__ ((noreturn)) void
unhandled_instruction (char *insn)
{
  fprintf(stderr, "Unhandled instruction at 0x%08x\"%s\" ... aborting\n", PCREG, insn);
  raise (SIGILL);
  abort ();
}

static __attribute__ ((noreturn)) void
illegal_instruction ()
{
  fprintf(stderr, "Illegal instruction at 0x%08x... aborting\n", PCREG);
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
setflags_nz_2x16 (bu32 val)
{
  saved_state.an = (bs16)val < 0 || (bs16)(val >> 16) < 0;
  saved_state.az = (bs16)val == 0 || (bs16)(val >> 16) == 0;
}

static void
setflags_logical (bu32 val)
{
  setflags_nz (val);
  saved_state.ac0 = 0;
  saved_state.v = 0;
}

static int
dagadd (int dagno, bs32 modify)
{
  bs32 i, l, b, val;

  i = IREG (dagno);
  l = LREG (dagno);
  b = BREG (dagno);
  val = i;

  if (l)
    {
      if (i + modify - b - l < 0 && modify > 0
	  || i + modify - b >= 0 && modify < 0
	  || modify == 0)
	val = i + modify;
      else if (i + modify - b - l >= 0 && modify > 0)
	val = i + modify - l;
      else if (i + modify - b < 0 && modify < 0)
	val = i + modify + l;
    }
  else
    val = i + modify;

  STORE (IREG (dagno), val);
  return val;
}

static int
dagsub (int dagno, bs32 modify)
{
  bs32 i, l, b, val;

  i = IREG (dagno);
  l = LREG (dagno);
  b = BREG (dagno);
  val = i;

  if (l)
    {
      if (i - modify - b - l < 0 && modify < 0
	  || i - modify - b >= 0 && modify > 0
	  || modify == 0)
	val = i - modify;
      else if (i - modify - b - l >= 0 && modify < 0)
	val = i - modify - l;
      else if (i - modify - b < 0 && modify > 0)
	val = i - modify + l;
    }
  else
    val = i - modify;

  STORE (IREG (dagno), val);
  return val;
}

static bu32
ashiftrt (bu32 val, int cnt, int size)
{
  int real_cnt = cnt > size ? size : cnt;
  bu32 sgn = ~((val >> (size - 1)) - 1);
  int sgncnt = size - real_cnt;
  if (sgncnt > 16)
    sgn <<= 16, sgncnt -= 16;
  sgn <<= sgncnt;
  if (real_cnt > 16)
    val >>= 16, real_cnt -= 16;
  val >>= real_cnt;
  val |= sgn;
  saved_state.an = val >> (size - 1);
  saved_state.az = val == 0;
  /* @@@ */
  saved_state.v = 0;
  return val;
}

static bu32
lshiftrt (bu32 val, int cnt, int size)
{
  int real_cnt = cnt > size ? size : cnt;
  if (real_cnt > 16)
    val >>= 16, real_cnt -= 16;
  val >>= real_cnt;
  saved_state.an = val >> (size - 1);
  saved_state.az = val == 0;
  saved_state.v = 0;
  return val;
}

static bu32
lshift (bu32 val, int cnt, int size, int saturate)
{
  int real_cnt = cnt > size ? size : cnt;
  int mask_cnt = size - real_cnt;
  bu32 sgn = ~((val >> (size - 1)) - 1);
  bu32 masked;
  bu32 mask = ~0;
  if (mask_cnt > 16)
    mask <<= 16, sgn <<= 16, mask_cnt -= 16;
  mask <<= mask_cnt;
  sgn <<= mask_cnt;
  masked = val & mask;

  if (real_cnt > 16)
    val <<= 16, real_cnt -= 16;
  val <<= real_cnt;
  if (saturate && sgn != masked)
    {
      if (size == 32)
	val = sgn == 0 ? 0x7fffffff : 0x80000000;
      else
	val = sgn == 0 ? 0x7fff : 0x8000;
    }
  saved_state.an = val >> (size - 1);
  saved_state.az = val == 0;
  saved_state.v = 0;
  return val;
}

static bu32
add32 (bu32 a, bu32 b, int carry, int sat)
{
  int flgs = a >> 31;
  int flgo = b >> 31;
  bu32 v = a + b;
  int flgn = v >> 31;
  int overflow = (flgs ^ flgn) & (flgo ^ flgn);
  if (sat && overflow)
    {
      v = flgn ? 0x7fffffff : 0x80000000;
      /* Saturating insns are documented as not setting overflow.  */
      overflow = 0;
    }
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
sub32 (bu32 a, bu32 b, int carry, int sat)
{
  int flgs = a >> 31;
  int flgo = b >> 31;
  bu32 v = a - b;
  int flgn = v >> 31;
  int overflow = (flgs ^ flgo) & (flgn ^ flgs);
  if (sat && overflow)
    {
      v = flgn ? 0x7fffffff : 0x80000000;
      /* Saturating insns are documented as not setting overflow.  */
      overflow = 0;
    }
  saved_state.an = flgn;
  saved_state.vs |= overflow;
  saved_state.v = overflow;
  saved_state.v_internal |= overflow;
  saved_state.az = v == 0;
  if (carry)
    saved_state.ac0 = b <= a;
  return v;
}

static bu32
add16 (bu32 a, bu32 b, int *carry, int sat)
{
  int flgs = (a >> 15) & 1;
  int flgo = (b >> 15) & 1;
  bu32 v = a + b;
  int flgn = (v >> 15) & 1;
  int overflow = (flgs ^ flgn) & (flgo ^ flgn);
  if (sat && overflow)
    {
      v = flgn ? 0x7fff : 0x8000;
      /* Saturating insns are documented as not setting overflow.  */
      overflow = 0;
    }
  saved_state.an = flgn;
  saved_state.vs |= overflow;
  saved_state.v = overflow;
  saved_state.v_internal |= overflow;
  saved_state.az = v == 0;
  if (carry)
    *carry = (bu16)~a < (bu16)b;
  return v & 0xffff;
}

static bu32
sub16 (bu32 a, bu32 b, int *carry, int sat)
{
  int flgs = (a >> 15) & 1;
  int flgo = (b >> 15) & 1;
  bu32 v = a - b;
  int flgn = (v >> 15) & 1;
  int overflow = (flgs ^ flgo) & (flgn ^ flgs);
  if (sat && overflow)
    {
      v = flgn ? 0x7fff : 0x8000;
      /* Saturating insns are documented as not setting overflow.  */
      overflow = 0;
    }
  saved_state.an = flgn;
  saved_state.vs |= overflow;
  saved_state.v = overflow;
  saved_state.v_internal |= overflow;
  saved_state.az = v == 0;
  if (carry)
    *carry = (bu16)b <= (bu16)a;
  return v;
}

static bu32
addadd16 (bu32 a, bu32 b, int sat, int x)
{
  int c0 = 0, c1 = 0;
  bu32 x0, x1;
  x0 = add16 ((a >> 16) & 0xffff, (b >> 16) & 0xffff, &c0, sat) & 0xffff;
  x1 = add16 (a & 0xffff, b & 0xffff, &c1, sat) & 0xffff;
  if (x == 0)
    return (x0 << 16) | x1;
  else
    return (x1 << 16) | x0;
}

static bu32
subsub16 (bu32 a, bu32 b, int sat, int x)
{
  int c0 = 0, c1 = 0;
  bu32 x0, x1;
  x0 = sub16 ((a >> 16) & 0xffff, (b >> 16) & 0xffff, &c0, sat) & 0xffff;
  x1 = sub16 (a & 0xffff, b & 0xffff, &c1, sat) & 0xffff;
  if (x == 0)
    return (x0 << 16) | x1;
  else
    return (x1 << 16) | x0;
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
min2x16 (bu32 a, bu32 b)
{
  int val = a;
  if ((bs16)a > (bs16)b)
    val = (val & 0xFFFF0000) | (b & 0xFFFF);
  if ((bs16)(a >> 16) > (bs16)(b >> 16))
    val = (val & 0xFFFF) | (b & 0xFFFF0000);
  setflags_nz_2x16 (val);
  saved_state.v = 0;
  return val;
}

static bu32
max2x16 (bu32 a, bu32 b)
{
  int val = a;
  if ((bs16)a < (bs16)b)
    val = (val & 0xFFFF0000) | (b & 0xFFFF);
  if ((bs16)(a >> 16) < (bs16)(b >> 16))
    val = (val & 0xFFFF) | (b & 0xFFFF0000);
  setflags_nz_2x16 (val);
  saved_state.v = 0;
  return val;
}

static bu32
add_and_shift (bu32 a, bu32 b, int shift)
{
  int v;
  saved_state.v_internal = 0;
  v = add32 (a, b, 0, 0);
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

      return ea;
    }

  /* Negative constants have an implied sign bit.  */
  if (constant_formats[cf].negative)
    {
      int nb = constant_formats[cf].nbits + 1;
      x = x | (1 << constant_formats[cf].nbits);
      x = SIGNEXTEND (x, nb);
    }
  else if (constant_formats[cf].issigned)
    x = SIGNEXTEND (x, constant_formats[cf].nbits);

  x += constant_formats[cf].offset;
  x <<= constant_formats[cf].scale;

  return x;
}

#define uimm16s4(x) fmtconst(c_uimm16s4, x, 0)
#define pcrel4(x) fmtconst(c_pcrel4, x, pc)
#define pcrel8(x) fmtconst(c_pcrel8, x, pc)
#define pcrel8s4(x) fmtconst(c_pcrel8s4, x, pc)
#define pcrel10(x) fmtconst(c_pcrel10, x, pc)
#define pcrel12(x) fmtconst(c_pcrel12, x, pc)
#define negimm5s4(x) fmtconst(c_negimm5s4, x, 0)
#define rimm16(x) fmtconst(c_rimm16, x, 0)
#define huimm16(x) fmtconst(c_huimm16, x, 0)
#define imm16(x) fmtconst(c_imm16, x, 0)
#define uimm2(x) fmtconst(c_uimm2, x, 0)
#define uimm3(x) fmtconst(c_uimm3, x, 0)
#define luimm16(x) fmtconst(c_luimm16, x, 0)
#define uimm4(x) fmtconst(c_uimm4, x, 0)
#define uimm5(x) fmtconst(c_uimm5, x, 0)
#define imm16s2(x) fmtconst(c_imm16s2, x, 0)
#define uimm8(x) fmtconst(c_uimm8, x, 0)
#define imm16s4(x) fmtconst(c_imm16s4, x, 0)
#define uimm4s2(x) fmtconst(c_uimm4s2, x, 0)
#define uimm4s4(x) fmtconst(c_uimm4s4, x, 0)
#define lppcrel10(x) fmtconst(c_lppcrel10, x, pc)
#define imm3(x) fmtconst(c_imm3, x, 0)
#define imm4(x) fmtconst(c_imm4, x, 0)
#define uimm8s4(x) fmtconst(c_uimm8s4, x, 0)
#define imm5(x) fmtconst(c_imm5, x, 0)
#define imm6(x) fmtconst(c_imm6, x, 0)
#define imm7(x) fmtconst(c_imm7, x, 0)
#define imm8(x) fmtconst(c_imm8, x, 0)
#define pcrel24(x) fmtconst(c_pcrel24, x, pc)
#define uimm16(x) fmtconst(c_uimm16, x, 0)

static bu32 *
get_allreg (int grp, int reg)
{
  int fullreg = (grp << 3) | reg;
  /* REG_R0, REG_R1, REG_R2, REG_R3, REG_R4, REG_R5, REG_R6, REG_R7,
     REG_P0, REG_P1, REG_P2, REG_P3, REG_P4, REG_P5, REG_SP, REG_FP,
     REG_I0, REG_I1, REG_I2, REG_I3, REG_M0, REG_M1, REG_M2, REG_M3,
     REG_B0, REG_B1, REG_B2, REG_B3, REG_L0, REG_L1, REG_L2, REG_L3,
     REG_A0x, REG_A0w, REG_A1x, REG_A1w, , , REG_ASTAT, REG_RETS,
     , , , , , , , ,
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
	case 32: return &saved_state.a0x;
	case 33: return &saved_state.a0w;
	case 34: return &saved_state.a1x;
	case 35: return &saved_state.a1w;
	case 39: return &saved_state.rets;
	case 48: return &LC0REG;
	case 49: return &LT0REG;
	case 50: return &LB0REG;
	case 51: return &LC1REG;
	case 52: return &LT1REG;
	case 53: return &LB1REG;
	case 54: return &CYCLESREG;
	case 55: return &CYCLES2REG;
	case 56: return &USPREG;
	case 57: return &SEQSTATREG;
	case 58: return &SYSCFGREG;
	case 59: return &RETIREG;
	case 60: return &RETXREG;
	case 61: return &RETNREG;
	case 62: return &RETEREG;
	}
      return 0;
    }
}

static bu64
get_extended_acc0 (void)
{
  bu64 acc0 = saved_state.a0x;
  /* Sign extend accumulator values before adding.  */
  if (acc0 & 0x80)
    acc0 |= -0x80;
  else
    acc0 &= 0xFF;
  acc0 <<= 32;
  acc0 |= saved_state.a0w;
  return acc0;
}

static bu64
get_extended_acc1 (void)
{
  bu64 acc1 = saved_state.a1x;
  /* Sign extend accumulator values before adding.  */
  if (acc1 & 0x80)
    acc1 |= -0x80;
  else
    acc1 &= 0xFF;
  acc1 <<= 32;
  acc1 |= saved_state.a1w;
  return acc1;
}

/* Perform a multiplication of D registers SRC0 and SRC1, sign- or
   zero-extending the result to 64 bit.  H0 and H1 determine whether the
   high part or the low part of the source registers is used.  Store 1 in
   *PSAT if saturation occurs, 0 otherwise.  */
static bu64
decode_multfunc (int h0, int h1, int src0, int src1, int mmod, int MM,
		 int *psat)
{
  bu32 s0 = DREG (src0), s1 = DREG (src1);
  bu32 sgn0, sgn1;
  bu32 val;
  bu64 val1;

  if (h0)
    s0 >>= 16;

  if (h1)
    s1 >>= 16;

  s0 &= 0xffff;
  s1 &= 0xffff;

  sgn0 = -(s0 & 0x8000);
  sgn1 = -(s1 & 0x8000);

  if (MM)
    s0 |= sgn0;
  else switch (mmod)
    {
    case 0:
    case M_S2RND:
    case M_T:
    case M_IS:
    case M_ISS2:
    case M_IH:
      s0 |= sgn0;
      s1 |= sgn1;
      break;
    case M_FU:
    case M_IU:
    case M_TFU:
      break;
    default:
      abort ();
    }

  val = s0 * s1;
  /* Perform shift correction if appropriate for the mode.  */
  *psat = 0;
  if (!MM && (mmod == 0 || mmod == M_T || mmod == M_S2RND))
    {
      if (val == 0x40000000)
	val = 0x7fffffff, *psat = 1;
      else
	val <<= 1;
    }

  val1 = val;
  if (mmod == 0 || mmod == M_IS || mmod == M_T || mmod == M_S2RND
      || mmod == M_ISS2 || mmod == M_IH)
    val1 |= -(val1 & 0x80000000);

  return val1;
}

static bu32
saturate_s32 (bu64 val)
{
  if ((bs64)val < -0x80000000ll)
    return 0x80000000;
  if ((bs64)val > 0x7fffffff)
    return 0x7fffffff;
  return val;
}

static bu32
saturate_s16 (bu64 val)
{
  if ((bs64)val < -0x8000ll)
    return 0x8000;
  if ((bs64)val > 0x7fff)
    return 0x7fff;
  return val & 0xffff;
}

static bu32
saturate_u32 (bu64 val)
{
  if (val > 0xffffffff)
    return 0xffffffff;
  return val;
}

static bu32
saturate_u16 (bu64 val)
{
  if (val > 0xffff)
    return 0xffff;
  return val;
}

static bu64
rnd16 (bu64 val)
{
  bu64 sgnbits;

  /* FIXME: Should honour rounding mode.  */
  if ((val & 0xffff) > 0x8000
      || ((val & 0xffff) == 0x8000 && (val & 0x10000)))
    val += 0x8000;

  sgnbits = val & 0xffff000000000000ull;
  val >>= 16;
  return val | sgnbits;
}

static bu64
trunc16 (bu64 val)
{
  bu64 sgnbits = val & 0xffff000000000000ull;
  val >>= 16;
  return val | sgnbits;
}

static int
signbits (bu64 val, int size)
{
  bu64 mask = (bu64)1 << (size - 1);
  bu64 bit = val & mask;
  int count = 0;
  for (;;)
    {
      mask >>= 1;
      bit >>= 1;
      if (mask == 0)
	break;
      if ((val & mask) != bit)
	break;
      count++;
    }
  if (size == 40)
    count -= 8;

  return count;
}

/* Extract a 16 or 32 bit value from a 64 bit multiplication result.
   These 64 bits must be sign- or zero-extended properly from the source
   we want to extract, either a 32 bit multiply or a 40 bit accumulator.  */

static bu32
extract_mult (bu64 res, int mmod, int fullword)
{
  if (fullword)
    switch (mmod)
      {
      case 0:
      case M_IS:
	return saturate_s32 (res);
      case M_FU:
	return saturate_u32 (res);
      case M_S2RND:
      case M_ISS2:
	return saturate_s32 (res << 1);
      default:
	abort ();
      }
  else
    switch (mmod)
      {
      case 0:
      case M_IH:
	return saturate_s16 (rnd16 (res));
      case M_IS:
	return saturate_s16 (res);
      case M_FU:
	return saturate_u16 (rnd16 (res));
      case M_IU:
	return saturate_u16 (res);

      case M_T:
	return saturate_s16 (trunc16 (res));
      case M_TFU:
	return saturate_u16 (trunc16 (res));

      case M_S2RND:
	return saturate_s16 (rnd16 (res << 1));
      case M_ISS2:
	return saturate_s16 (res << 1);
      default:
	abort ();
      }
}

static bu32
decode_macfunc (int which, int op, int h0, int h1, int src0, int src1,
		int mmod, int MM, int fullword)
{
  bu32 *ax, *aw;
  bu64 acc;
  int sat = 0;

  ax = which ? &A1XREG : &A0XREG;
  aw = which ? &A1WREG : &A0WREG;
  acc = (((bu64)*ax << 32) | ((bu64)*aw)) & 0xFFFFFFFFFFull;

  /* Sign extend accumulator if necessary.  */
  if (mmod == 0 || mmod == M_T || mmod == M_IS || mmod == M_ISS2
      || mmod == M_S2RND)
    acc |= -(acc & 0x80000000);

  if (op != 3)
    {
      bu64 res = decode_multfunc (h0, h1, src0, src1, mmod, MM,
				  &sat);
      /* Perform accumulation.  */
      switch (op)
	{
	case 0:
	  acc = res;
	  break;
	case 1:
	  acc = acc + res;
	  break;
	case 2:
	  acc = acc - res;
	  break;
	}

      /* Saturate.  */
      switch (mmod)
	{
	case 0:
	case M_T:
	case M_IS:
	case M_ISS2:
	case M_S2RND:
	  if ((bs64)acc < -0x8000000000ll)
	    acc = -0x8000000000ull, sat = 1;
	  else if ((bs64)acc >= 0x7fffffffffll)
	    acc = 0x7fffffffffull, sat = 1;
	  break;
	case M_TFU:
	case M_FU:
	case M_IU:
	  if (acc > 0xFFFFFFFFFFull)
	    acc = 0xFFFFFFFFFFull, sat = 1;
	  break;
	default:
	  abort ();
	}
    }

  if (which)
    {
      STORE (A1XREG, (acc >> 32) & 0xff);
      STORE (A1WREG, acc & 0xffffffff);
      STORE (saved_state.av1, sat);
      STORE (saved_state.av1s, saved_state.av1s | sat);
    }
  else
    {
      STORE (A0XREG, (acc >> 32) & 0xff);
      STORE (A0WREG, acc & 0xffffffff);
      STORE (saved_state.av0, sat);
      STORE (saved_state.av0s, saved_state.av0s | sat);
    }

  return extract_mult (acc, mmod, fullword);
}

static void
decode_ProgCtrl_0 (bu16 iw0)
{
  /* ProgCtrl
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int poprnd = ((iw0 >> 0) & 0xf);
  int prgfunc = ((iw0 >> 4) & 0xf);

  if (prgfunc == 0 && poprnd == 0)
    /* NOP */
    PCREG += 2;
  else if (prgfunc == 1 && poprnd == 0)
    /* RTS */
    PCREG = saved_state.rets;
  else if (prgfunc == 1 && poprnd == 1)
    unhandled_instruction ("RTI");
  else if (prgfunc == 1 && poprnd == 2)
    unhandled_instruction ("RTX");
  else if (prgfunc == 1 && poprnd == 3)
    unhandled_instruction ("RTN");
  else if (prgfunc == 1 && poprnd == 4)
    unhandled_instruction ("RTE");
  else if (prgfunc == 2 && poprnd == 0)
    unhandled_instruction ("IDLE");
  else if (prgfunc == 2 && poprnd == 3)
    unhandled_instruction ("CSYNC");
  else if (prgfunc == 2 && poprnd == 4)
    unhandled_instruction ("SSYNC");
  else if (prgfunc == 2 && poprnd == 5)
    unhandled_instruction ("EMUEXCPT");
  else if (prgfunc == 3)
    unhandled_instruction ("CLI dregs");
  else if (prgfunc == 4)
    unhandled_instruction ("STI dregs");
  else if (prgfunc == 5)
    {
      /* JUMP (pregs) */
      PCREG = PREG (poprnd);
      did_jump = 1;
    }
  else if (prgfunc == 6)
    {
      /* CALL (pregs) */
      saved_state.rets = PCREG + 2;
      PCREG = PREG (poprnd);
      did_jump = 1;
    }
  else if (prgfunc == 7)
    {
      /* CALL (PC + pregs) */
      saved_state.rets = PCREG + 2;
      PCREG = PCREG + PREG (poprnd);
      did_jump = 1;
    }
  else if (prgfunc == 8)
    {
      /* JUMP (PC + pregs) */
      PCREG = PCREG + PREG (poprnd);
      did_jump = 1;
    }
  else if (prgfunc == 9)
    unhandled_instruction ("RAISE uimm4");
  else if (prgfunc == 10)
    {
      PCREG += 2;
      /* EXCPT uimm4 */
      if (uimm4 (poprnd) == 0)
	bfin_trap ();
      else if (uimm4 (poprnd) == 1)
	raise_exception(TARGET_SIGNAL_TRAP);
      else
	unhandled_instruction ("unhandled exception");
    }
  else if (prgfunc == 11)
    unhandled_instruction ("TESTSET");
  else
    illegal_instruction ();
}

static void
decode_CaCTRL_0 (bu16 iw0)
{
  /* CaCTRL
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int a = ((iw0 >> 5) & 0x1);
  int reg = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 3) & 0x3);

  if (a == 0 && op == 0)
    unhandled_instruction ("PREFETCH [pregs]");
  else if (a == 0 && op == 1)
    unhandled_instruction ("FLUSHINV [pregs]");
  else if (a == 0 && op == 2)
    unhandled_instruction ("FLUSH [pregs]");
  else if (a == 0 && op == 3)
    unhandled_instruction ("IFLUSH [pregs]");
  else if (a == 1 && op == 0)
    unhandled_instruction ("PREFETCH [pregs++]");
  else if (a == 1 && op == 1)
    unhandled_instruction ("FLUSHINV [pregs++]");
  else if (a == 1 && op == 2)
    unhandled_instruction ("FLUSH [pregs++]");
  else if (a == 1 && op == 3)
    unhandled_instruction ("IFLUSH [pregs++]");
  else
    illegal_instruction ();

  PCREG += 2;
}

static void
decode_PushPopReg_0 (bu16 iw0)
{
  /* PushPopReg
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.W.|.grp.......|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int grp = ((iw0 >> 3) & 0x7);
  int reg = ((iw0 >> 0) & 0x7);
  int W = ((iw0 >> 6) & 0x1);
  bu32 *whichreg = get_allreg (grp, reg);

  if (W == 0)
    {
      bu32 value = get_long (saved_state.memory, PREG (6));
      /* allregs = [SP++] */
      if (grp == 4 && reg == 6)
	SET_ASTAT (value);
      else  if (whichreg == 0)
	unhandled_instruction ("push/pop");
      else
	*whichreg = value;
      PREG (6) += 4;
    }
  else
    {
      bu32 value;
      /* [--SP] = allregs */
      PREG (6) -= 4;
      if (grp == 4 && reg == 6)
	value = ASTAT;
      else if (whichreg == 0)
	unhandled_instruction ("push/pop");
      else
	value = *whichreg;

      put_long (saved_state.memory, PREG (6), value);
    }
  PCREG += 2;
}

static void
decode_PushPopMultiple_0 (bu16 iw0)
{
  /* PushPopMultiple
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int p = ((iw0 >> 7) & 0x1);
  int pr = ((iw0 >> 0) & 0x7);
  int d = ((iw0 >> 8) & 0x1);
  int dr = ((iw0 >> 3) & 0x7);
  int W = ((iw0 >> 6) & 0x1);
  int i;
  bu32 sp = PREG (6);

  if ((d == 0 && p == 0)
      || (p && imm5 (pr) > 5))
    illegal_instruction ();

  if (W == 1)
    {
      if (d)
	for (i = dr; i < 8; i++)
	  {
	    sp -= 4;
	    put_long (saved_state.memory, sp, DREG (i));
	  }
      if (p)
	for (i = pr; i < 6; i++)
	  {
	    sp -= 4;
	    put_long (saved_state.memory, sp, PREG (i));
	  }
    }
  else
    {
      if (p)
	for (i = 5; i >= pr; i--)
	  {
	    PREG (i) = get_long (saved_state.memory, sp);
	    sp += 4;
	  }
      if (d)
	for (i = 7; i >= dr; i--)
	  {
	    DREG (i) = get_long (saved_state.memory, sp);
	    sp += 4;
	  }
    }      
  PREG (6) = sp;
  PCREG += 2;
}

static void
decode_ccMV_0 (bu16 iw0)
{
  /* ccMV
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.T.|.d.|.s.|.dst.......|.src.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src = ((iw0 >> 0) & 0x7);
  int dst = ((iw0 >> 3) & 0x7);
  int s = ((iw0 >> 6) & 0x1);
  int d = ((iw0 >> 7) & 0x1);
  int T = ((iw0 >> 8) & 0x1);
  int cond = T ? CCREG : ! CCREG;
  if (cond)
    GREG (dst, d) = GREG (src, s);
  PCREG += 2;
}

static void
decode_CCflag_0 (bu16 iw0)
{
  /* CCflag
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int x = ((iw0 >> 0) & 0x7);
  int y = ((iw0 >> 3) & 0x7);
  int I = ((iw0 >> 10) & 0x1);
  int opc = ((iw0 >> 7) & 0x7);
  int G = ((iw0 >> 6) & 0x1);

  if (opc > 4)
    {
      if (opc == 5 && I == 0 && G == 0)
	unhandled_instruction ("CC = A0 == A1");
      else if (opc == 6 && I == 0 && G == 0)
	unhandled_instruction ("CC = A0 < A1");
      else if (opc == 7 && I == 0 && G == 0)
	unhandled_instruction ("CC = A0 <= A1");
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
    }
  PCREG += 2;
}

static void
decode_CC2dreg_0 (bu16 iw0)
{
  /* CC2dreg
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |.op....|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int reg = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 3) & 0x3);

  if (op == 0)
    /* dregs = CC */
    DREG (reg) = CCREG;
  else if (op == 1)
    /* CC = dregs */
    CCREG = DREG (reg) != 0;
  else if (op == 3)
    /* CC = !CC */
    CCREG = !CCREG;
  else
    illegal_instruction ();
  PCREG += 2;
}

static void
decode_CC2stat_0 (bu16 iw0)
{
  /* CC2stat
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
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
      illegal_instruction ();
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
decode_BRCC_0 (bu16 iw0, bu32 pc)
{
  /* BRCC
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int B = ((iw0 >> 10) & 0x1);
  int T = ((iw0 >> 11) & 0x1);
  int offset = ((iw0 >> 0) & 0x3ff);

  /* B is just the branch predictor hint - we can ignore it.  */

  /* IF CC JUMP pcrel10 */
  if (CCREG == T)
    {
      PCREG += pcrel10 (offset);
      did_jump = 1;
    }
  else
    PCREG += 2;
}

static void
decode_UJUMP_0 (bu16 iw0, bu32 pc)
{
  /* UJUMP
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 1 | 0 |.offset........................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int offset = ((iw0 >> 0) & 0xfff);

  /* JUMP.S pcrel12 */
  PCREG += pcrel12 (offset);
  did_jump = 1;
}

static void
decode_REGMV_0 (bu16 iw0)
{
  /* REGMV
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 1 | 1 |.gd........|.gs........|.dst.......|.src.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src = ((iw0 >> 0) & 0x7);
  int gs = ((iw0 >> 6) & 0x7);
  int dst = ((iw0 >> 3) & 0x7);
  int gd = ((iw0 >> 9) & 0x7);
  bu32 *srcreg = get_allreg (gs, src);
  bu32 *dstreg = get_allreg (gd, dst);
  bu32 value;

  if (gs == 4 && src == 6)
    value = ASTAT;
  else if (srcreg == 0)
    unhandled_instruction ("reg move");
  else
    value = *srcreg;

  if (gd == 4 && dst == 6)
    SET_ASTAT (value);
  else if (dstreg == 0)
    unhandled_instruction ("reg move");
  else
    *dstreg = value;

  PCREG += 2;
}

static void
decode_ALU2op_0 (bu16 iw0)
{
  /* ALU2op
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src = ((iw0 >> 3) & 0x7);
  int opc = ((iw0 >> 6) & 0xf);
  int dst = ((iw0 >> 0) & 0x7);

  if (opc == 0)
    /* dregs >>>= dregs */
    DREG (dst) = ashiftrt (DREG (dst), DREG (src), 32);
  else if (opc == 1)
    /* dregs >>= dregs */
    DREG (dst) = lshiftrt (DREG (dst), DREG (src), 32);
  else if (opc == 2)
    /* dregs <<= dregs */
    DREG (dst) = lshift (DREG (dst), DREG (src), 32, 0);
  else if (opc == 3)
    /* dregs *= dregs */
    DREG (dst) *= DREG (src);
  else if (opc == 4)
    /* dregs = (dregs + dregs) << 1 */
    DREG (dst) = add_and_shift (DREG (dst), DREG (src), 1);
  else if (opc == 5)
    /* dregs = (dregs + dregs) << 2 */
    DREG (dst) = add_and_shift (DREG (dst), DREG (src), 2);
  else if (opc == 8)
    unhandled_instruction ("DIVQ (dregs , dregs)");
  else if (opc == 9)
    unhandled_instruction ("DIVS (dregs , dregs)");
  else if (opc == 10)
    {
      /* dregs = dregs_lo (X) */
      DREG (dst) = (bs32) (bs16) DREG (src);
      setflags_logical (DREG (dst));
    }
  else if (opc == 11)
    {
      /* dregs = dregs_lo (Z) */
      DREG (dst) = (bu32) (bu16) DREG (src);
      setflags_logical (DREG (dst));
    }
  else if (opc == 12)
    {
      /* dregs = dregs_byte (X) */
      DREG (dst) = (bs32) (bs8) DREG (src);
      setflags_logical (DREG (dst));
    }
  else if (opc == 13)
    {
      /* dregs = dregs_byte (Z) */
      DREG (dst) = (bu32) (bu8) DREG (src);
      setflags_logical (DREG (dst));
    }
  else if (opc == 14)
    {
      /* dregs = - dregs */
      bu32 val = DREG (src);
      DREG (dst) = -val;
      setflags_nz (DREG (dst));
      if (val == 0x80000000)
	saved_state.v = saved_state.vs = 1;
      /* @@@ Documentation isn't entirely clear about av0 and av1.  */
    }
  else if (opc == 15)
    {
      /* dregs = ~ dregs */
      DREG (dst) = ~DREG (src);
      setflags_logical (DREG (dst));
    }
  else
    illegal_instruction ();
  PCREG += 2;
}

static void
decode_PTR2op_0 (bu16 iw0)
{
  /* PTR2op
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src = ((iw0 >> 3) & 0x7);
  int opc = ((iw0 >> 6) & 0x7);
  int dst = ((iw0 >> 0) & 0x7);

  if (opc == 0)
    PREG (dst) -= PREG (src);
  else if (opc == 1)
    PREG (dst) = PREG (src) << 2;
  else if (opc == 3)
    PREG (dst) = PREG (src) >> 2;
  else if (opc == 4)
    PREG (dst) = PREG (src) >> 1;
  else if (opc == 5)
    unhandled_instruction ("pregs += pregs ( BREV )");
  else if (opc == 6)
    PREG (dst) = (PREG (dst) + PREG (src)) << 1;
  else if (opc == 7)
    PREG (dst) = (PREG (dst) + PREG (src)) << 2;
  else
    illegal_instruction ();

  PCREG += 2;
}

static void
decode_LOGI2op_0 (bu16 iw0)
{
  /* LOGI2op
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src = ((iw0 >> 3) & 0x1f);
  int opc = ((iw0 >> 8) & 0x7);
  int dst = ((iw0 >> 0) & 0x7);

  if (opc == 0)
    /* CC = ! BITTST (dregs, uimm5) */
    CCREG = (~DREG (dst) >> uimm5 (src)) & 1;
  else if (opc == 1)
    /* CC = BITTST (dregs, uimm5) */
    CCREG = (DREG (dst) >> uimm5 (src)) & 1;
  else if (opc == 2)
    {
      /* BITSET (dregs, uimm5) */
      DREG (dst) |= 1 << uimm5 (src);
      setflags_logical (DREG (dst));
    }
  else if (opc == 3)
    {
      /* BITTGL (dregs, uimm5) */
      DREG (dst) ^= 1 << uimm5 (src);
      setflags_logical (DREG (dst));
    }
  else if (opc == 4)
    {
      /* BITCLR (dregs, uimm5) */
      DREG (dst) &= ~(1 << uimm5 (src));
      setflags_logical (DREG (dst));
    }
  else if (opc == 5)
    /* dregs >>>= uimm5 */
    DREG (dst) = ashiftrt (DREG (dst), uimm5 (src), 32);
  else if (opc == 6)
    /* dregs >>= uimm5 */
    DREG (dst) = lshiftrt (DREG (dst), uimm5 (src), 32);
  else if (opc == 7)
    /* dregs <<= uimm5 */
    DREG (dst) = lshift (DREG (dst), uimm5 (src), 32, 0);

  PCREG += 2;
}

static void
decode_COMP3op_0 (bu16 iw0)
{
  /* COMP3op
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src0 = ((iw0 >> 0) & 0x7);
  int src1 = ((iw0 >> 3) & 0x7);
  int opc = ((iw0 >> 9) & 0x7);
  int dst = ((iw0 >> 6) & 0x7);

  if (opc == 0)
    /* dregs = dregs + dregs */
    DREG (dst) = add32 (DREG (src0), DREG (src1), 1, 0);
  else if (opc == 1)
    /* dregs = dregs - dregs */
    DREG (dst) = sub32 (DREG (src0), DREG (src1), 1, 0);
  else if (opc == 2)
    {
      /* dregs = dregs & dregs */
      DREG (dst) = DREG (src0) & DREG (src1);
      setflags_logical (DREG (dst));
    }
  else if (opc == 3)
    {
      /* dregs = dregs | dregs */
      DREG (dst) = DREG (src0) | DREG (src1);
      setflags_logical (DREG (dst));
    }
  else if (opc == 4)
    {
      /* dregs = dregs ^ dregs */
      DREG (dst) = DREG (src0) ^ DREG (src1);
      setflags_logical (DREG (dst));
    }
  else if (opc == 5)
    /* If src0 == src1 this is disassembled as a shift by 1, but this
       distinction doesn't matter for our purposes.  */
    PREG (dst) = PREG (src0) + PREG (src1);
  else if (opc == 6)
    PREG (dst) = PREG (src0) + (PREG (src1) << 1);
  else if (opc == 7)
    PREG (dst) = PREG (src0) + (PREG (src1) << 2);

  PCREG += 2;
}

static void
decode_COMPI2opD_0 (bu16 iw0)
{
  /* COMPI2opD
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 1 | 1 | 0 | 0 |.op|.isrc......................|.dst.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int isrc = ((iw0 >> 3) & 0x7f);
  int dst = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 10) & 0x1);

  if (op == 0)
    DREG (dst) = imm7 (isrc);
  else if (op == 1)
    DREG (dst) = add32 (DREG (dst), imm7 (isrc), 1, 0);
  PCREG += 2;
}

static void
decode_COMPI2opP_0 (bu16 iw0)
{
  /* COMPI2opP
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 1 | 1 | 0 | 1 |.op|.src.......................|.dst.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src = ((iw0 >> 3) & 0x7f);
  int dst = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 10) & 0x1);

  if (op == 0)
    PREG (dst) = imm7 (src);
  else if (op == 1)
    PREG (dst) += imm7 (src);
  PCREG += 2;
}

static void
decode_LDSTpmod_0 (bu16 iw0)
{
  /* LDSTpmod
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int aop = ((iw0 >> 9) & 0x3);
  int idx = ((iw0 >> 3) & 0x7);
  int ptr = ((iw0 >> 0) & 0x7);
  int reg = ((iw0 >> 6) & 0x7);
  int W = ((iw0 >> 11) & 0x1);
  bu32 addr, val;

  if (aop == 1 && W == 0 && idx == ptr)
    {
      /* dregs_lo = W[pregs] */
      addr = PREG (ptr);
      val = get_word (saved_state.memory, addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | val);
    }
  else if (aop == 2 && W == 0 && idx == ptr)
    {
      /* dregs_hi = W[pregs] */
      addr = PREG (ptr);
      val = get_word (saved_state.memory, addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (val << 16));
    }
  else if (aop == 1 && W == 1 && idx == ptr)
    {
      /* W[pregs] = dregs_lo */
      addr = PREG (ptr);
      put_word (saved_state.memory, addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && idx == ptr)
    {
      /* W[pregs] = dregs_hi */
      addr = PREG (ptr);
      put_word (saved_state.memory, addr, DREG (reg) >> 16);
    }
  else if (aop == 0 && W == 0)
    {
      /* dregs = [pregs ++ pregs] */
      addr = PREG (ptr);
      val = get_long (saved_state.memory, addr);
      STORE (DREG (reg), val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 1 && W == 0)
    {
      /* dregs_lo = W[pregs ++ pregs] */
      addr = PREG (ptr);
      val = get_word (saved_state.memory, addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 2 && W == 0)
    {
      /* dregs_hi = W[pregs ++ pregs] */
      addr = PREG (ptr);
      val = get_word (saved_state.memory, addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (val << 16));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 3 && W == 0)
    {
      /* dregs = W[pregs ++ pregs] (Z) */
      addr = PREG (ptr);
      val = get_word (saved_state.memory, addr);
      STORE (DREG (reg), val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 3 && W == 1)
    {
      /* dregs = W [ pregs ++ pregs ] (X) */
      addr = PREG (ptr);
      val = get_word (saved_state.memory, addr);
      STORE (DREG (reg), (bs32) (bs16) val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 0 && W == 1)
    {
      /* [pregs ++ pregs] = dregs */
      addr = PREG (ptr);
      put_long (saved_state.memory, addr, DREG (reg));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 1 && W == 1)
    {
      /* W[pregs ++ pregs] = dregs_lo */
      addr = PREG (ptr);
      put_word (saved_state.memory, addr, DREG (reg));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 2 && W == 1)
    {
      /* W[pregs ++ pregs] = dregs_hi */
      addr = PREG (ptr);
      put_word (saved_state.memory, addr, DREG (reg) >> 16);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else
    illegal_instruction ();

  PCREG += 2;
}

static void
decode_dagMODim_0 (bu16 iw0)
{
  /* dagMODim
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |.br| 1 | 1 |.op|.m.....|.i.....|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int i = ((iw0 >> 0) & 0x3);
  int br = ((iw0 >> 7) & 0x1);
  int m = ((iw0 >> 2) & 0x3);
  int op = ((iw0 >> 4) & 0x1);

  if (op == 0 && br == 1)
    unhandled_instruction ("iregs += mregs (BREV)");
  else if (op == 0)
    /* iregs += mregs */
    dagadd (i, MREG (m));
  else if (op == 1)
    /* iregs -= mregs */
    dagsub (i, MREG (m));
  else
    illegal_instruction ();
  PCREG += 2;
}

static void
decode_dagMODik_0 (bu16 iw0)
{
  /* dagMODik
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int i = ((iw0 >> 0) & 0x3);
  int op = ((iw0 >> 2) & 0x3);

  if (op == 0)
    /* iregs += 2 */
    dagadd (i, 2);
  else if (op == 1)
    /* iregs -= 2 */
    dagsub (i, 2);
  else if (op == 2)
    /* iregs += 4 */
    dagadd (i, 4);
  else if (op == 3)
    /* iregs -= 4 */
    dagsub (i, 4);
  else
    illegal_instruction ();
  PCREG += 2;
}

static void
decode_dspLDST_0 (bu16 iw0)
{
  /* dspLDST
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int aop = ((iw0 >> 7) & 0x3);
  int i = ((iw0 >> 3) & 0x3);
  int m = ((iw0 >> 5) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);
  int W = ((iw0 >> 9) & 0x1);
  bu32 addr;

  if (aop == 0 && W == 0 && m == 0)
    {
      /* dregs = [iregs++] */
      addr = IREG (i);
      dagadd (i, 4);
      STORE (DREG (reg), get_long (saved_state.memory, addr));
    }
  else if (aop == 0 && W == 0 && m == 1)
    {
      /* dregs_lo = W[iregs++] */
      addr = IREG (i);
      dagadd (i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | get_word (saved_state.memory, addr));
    }
  else if (aop == 0 && W == 0 && m == 2)
    {
      /* dregs_hi = W[iregs++] */
      addr = IREG (i);
      dagadd (i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (get_word (saved_state.memory, addr) << 16));
    }
  else if (aop == 1 && W == 0 && m == 0)
    {
      /* dregs = [iregs--] */
      addr = IREG (i);
      dagsub (i, 4);
      STORE (DREG (reg), get_long (saved_state.memory, addr));
    }
  else if (aop == 1 && W == 0 && m == 1)
    {
      /* dregs_lo = W[iregs--] */
      addr = IREG (i);
      dagsub (i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | get_word (saved_state.memory, addr));
    }
  else if (aop == 1 && W == 0 && m == 2)
    {
      /* dregs_hi = W[iregs--] */
      addr = IREG (i);
      dagsub (i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (get_word (saved_state.memory, addr) << 16));
    }
  else if (aop == 2 && W == 0 && m == 0)
    {
      /* dregs = [iregs] */
      addr = IREG (i);
      STORE (DREG (reg), get_long (saved_state.memory, addr));
    }
  else if (aop == 2 && W == 0 && m == 1)
    {
      /* dregs_lo = W[iregs] */
      addr = IREG (i);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | get_word (saved_state.memory, addr));
    }
  else if (aop == 2 && W == 0 && m == 2)
    {
      /* dregs_hi = W[iregs] */
      addr = IREG (i);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (get_word (saved_state.memory, addr) << 16));
    }
  else if (aop == 0 && W == 1 && m == 0)
    {
      /* [iregs++] = dregs */
      addr = IREG (i);
      dagadd (i, 4);
      put_long (saved_state.memory, addr, DREG (reg));
    }
  else if (aop == 0 && W == 1 && m == 1)
    {
      /* W[iregs++] = dregs_lo */
      addr = IREG (i);
      dagadd (i, 2);
      put_word (saved_state.memory, addr, DREG (reg));
    }
  else if (aop == 0 && W == 1 && m == 2)
    {
      /* W[iregs++] = dregs_hi */
      addr = IREG (i);
      dagadd (i, 2);
      put_word (saved_state.memory, addr, DREG (reg) >> 16);
    }
  else if (aop == 1 && W == 1 && m == 0)
    {
      /* [iregs--] = dregs */
      addr = IREG (i);
      dagsub (i, 4);
      put_long (saved_state.memory, addr, DREG (reg));
    }
  else if (aop == 1 && W == 1 && m == 1)
    {
      /* W[iregs--] = dregs_lo */
      addr = IREG (i);
      dagsub (i, 2);
      put_word (saved_state.memory, addr, DREG (reg));
    }
  else if (aop == 1 && W == 1 && m == 2)
    {
      /* W[iregs--] = dregs_hi */
      addr = IREG (i);
      dagsub (i, 2);
      put_word (saved_state.memory, addr, DREG (reg) >> 16);
    }
  else if (aop == 2 && W == 1 && m == 0)
    {
      /* [iregs] = dregs */
      addr = IREG (i);
      put_long (saved_state.memory, addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && m == 1)
    {
      /*  W[iregs] = dregs_lo */
      addr = IREG (i);
      put_word (saved_state.memory, addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && m == 2)
    {
      /*  W[iregs] = dregs_hi */
      addr = IREG (i);
      put_word (saved_state.memory, addr, DREG (reg) >> 16);
    }
  else if (aop == 3 && W == 0)
    {
      /* dregs = [iregs ++ mregs] */
      addr = IREG (i);
      dagadd (i, MREG (m));
      STORE (DREG (reg), get_long (saved_state.memory, addr));
    }
  else if (aop == 3 && W == 1)
    {
      /* [iregs ++ mregs] = dregs */
      addr = IREG (i);
      dagadd(i, MREG (m));
      put_long (saved_state.memory, addr, DREG (reg));
    }
  else
    illegal_instruction ();

  PCREG += 2;
}

static void
decode_LDST_0 (bu16 iw0)
{
  /* LDST
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int aop = ((iw0 >> 7) & 0x3);
  int Z = ((iw0 >> 6) & 0x1);
  int sz = ((iw0 >> 10) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);
  int ptr = ((iw0 >> 3) & 0x7);
  int W = ((iw0 >> 9) & 0x1);

  if (aop == 3)
    illegal_instruction ();

  if (W == 0)
    {
      if (aop != 2 && sz == 0 && Z == 1
	  && ptr == reg)
	illegal_instruction ();

      if (sz == 0 && Z == 0)
	/* dregs = [pregs] */
	DREG (reg) = get_long (saved_state.memory, PREG (ptr));
      else if (sz == 0 && Z == 1)
	/* pregs = [pregs] */
	PREG (reg) = get_long (saved_state.memory, PREG (ptr));
      else if (sz == 1 && Z == 0)
	/* dregs = W[pregs] (z) */
	DREG (reg) = get_word (saved_state.memory, PREG (ptr));
      else if (sz == 1 && Z == 1)
	/* dregs = W[pregs] (X) */
	DREG (reg) = (bs32) (bs16) get_word (saved_state.memory, PREG (ptr));
      else if (sz == 2 && Z == 0)
	/* dregs = B[pregs] (Z) */
	DREG (reg) = get_byte (saved_state.memory, PREG (ptr));
      else if (sz == 2 && Z == 1)
	/* dregs = B[pregs] (X) */
	DREG (reg) = (bs32) (bs8) get_byte (saved_state.memory, PREG (ptr));

      if (aop == 0)
	PREG (ptr) += sz == 0 ? 4 : sz == 1 ? 2 : 1;
      if (aop == 1)
	PREG (ptr) -= sz == 0 ? 4 : sz == 1 ? 2 : 1;
    }
  else
    {
      if (sz != 0 && Z == 1)
	illegal_instruction ();

      if (sz == 0 && Z == 0)
	/* [pregs] = dregs */
	put_long (saved_state.memory, PREG (ptr), DREG (reg));
      else if (sz == 0 && Z == 1)
	/* [pregs] = pregs */
	put_long (saved_state.memory, PREG (ptr), PREG (reg));
      else if (sz == 1 && Z == 0)
	/* W[pregs] = dregs */
	put_word (saved_state.memory, PREG (ptr), DREG (reg));
      else if (sz == 2 && Z == 0)
	/* B[pregs] = dregs */
	put_byte (saved_state.memory, PREG (ptr), DREG (reg));

      if (aop == 0)
	PREG (ptr) += sz == 0 ? 4 : sz == 1 ? 2 : 1;
      if (aop == 1)
	PREG (ptr) -= sz == 0 ? 4 : sz == 1 ? 2 : 1;
    }      

  PCREG += 2;
}

static void
decode_LDSTiiFP_0 (bu16 iw0)
{
  /* LDSTiiFP
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 1 | 1 | 1 | 0 |.W.|.offset............|.reg...........|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int reg = ((iw0 >> 0) & 0xf);
  int offset = ((iw0 >> 4) & 0x1f);
  int W = ((iw0 >> 9) & 0x1);
  bu32 ea = PREG (7) + negimm5s4 (offset);

  if (W == 0)
    DPREG (reg) = get_long (saved_state.memory, ea);
  else
    put_long (saved_state.memory, ea, DPREG (reg));
  PCREG += 2;
}

static void
decode_LDSTii_0 (bu16 iw0)
{
  /* LDSTii
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int reg = ((iw0 >> 0) & 0x7);
  int ptr = ((iw0 >> 3) & 0x7);
  int offset = ((iw0 >> 6) & 0xf);
  int op = ((iw0 >> 10) & 0x3);
  int W = ((iw0 >> 12) & 0x1);
  bu32 ea = PREG (ptr) + (op == 0 || op == 3 ? uimm4s4 (offset) 
			  : uimm4s2 (offset));

  if (W == 1 && op == 2)
    illegal_instruction ();

  if (W == 0)
    { 
      if (op == 0)
	/* dregs = [pregs + uimm4s4] */
	DREG (reg) = get_long (saved_state.memory, ea);
      else if (op == 1)
	/* dregs = W[pregs + uimm4s2] (Z) */
	DREG (reg) = get_word (saved_state.memory, ea);
      else if (op == 2)
	/* dregs = W[pregs + uimm4s2] (X) */
	DREG (reg) = (bs32) (bs16) get_word (saved_state.memory, ea);
      else if (op == 3)
	/* pregs = [pregs + uimm4s4] */
	PREG (reg) = get_long (saved_state.memory, ea);
    }
  else
    {
      if (op == 0)
	/* [pregs + uimm4s4] = dregs */
	put_long (saved_state.memory, ea, DREG (reg));
      else if (op == 1)
	/* W[pregs + uimm4s2] = dregs */
	put_word (saved_state.memory, ea, DREG (reg));
      else if (op == 3)
	/* [pregs + uimm4s4] = pregs */
	put_long (saved_state.memory, ea, PREG (reg));
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
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int rop = ((iw0 >> 5) & 0x3);
  int soffset = ((iw0 >> 0) & 0xf);
  int c = ((iw0 >> 4) & 0x1);
  int eoffset = ((iw1 >> 0) & 0x3ff);
  int reg = ((iw1 >> 12) & 0xf);

  if (rop == 0)
    {
      /* LSETUP (pcrel4, lppcrel10) counters */
      saved_state.lt[c] = PCREG + pcrel4 (soffset);
      saved_state.lb[c] = PCREG + lppcrel10 (eoffset);
    }
  else if (rop == 1)
    {
      /* LSETUP (pcrel4, lppcrel10) counters = pregs */
      saved_state.lt[c] = PCREG + pcrel4 (soffset);
      saved_state.lb[c] = PCREG + lppcrel10 (eoffset);
      saved_state.lc[c] = PREG (reg);
    }
  else if (rop == 3)
    {
      /* LSETUP (pcrel4, lppcrel10) counters = pregs >> 1 */
      saved_state.lt[c] = PCREG + pcrel4 (soffset);
      saved_state.lb[c] = PCREG + lppcrel10 (eoffset);
      saved_state.lc[c] = PREG (reg) >> 1;
    }
  else
    illegal_instruction ();

  PCREG += 4;
}

static void
decode_LDIMMhalf_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* LDIMMhalf
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
     |.hword.........................................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int H = ((iw0 >> 6) & 0x1);
  int grp = ((iw0 >> 3) & 0x3);
  int Z = ((iw0 >> 7) & 0x1);
  int S = ((iw0 >> 5) & 0x1);
  int hword = ((iw1 >> 0) & 0xffff);
  int reg = ((iw0 >> 0) & 0x7);

  if (H == 0 && S == 1 && Z == 0)
    {
      bu32 *pval = get_allreg (grp, reg);
      /* regs = imm16 (x) */
      *pval = imm16 (hword);
    }
  else if (H == 0 && S == 0 && Z == 1)
    {
      bu32 *pval = get_allreg (grp, reg);
      /* regs = luimm16 (Z) */
      *pval = luimm16 (hword);
    }
  else if (H == 0 && S == 0 && Z == 0)
    {
      bu32 *pval = get_allreg (grp, reg);
      /* regs_lo = luimm16 */
      *pval &= 0xFFFF0000;
      *pval |= luimm16 (hword);
    }
  else if (H == 1 && S == 0 && Z == 0)
    {
      bu32 *pval = get_allreg (grp, reg);
      /* regs_hi = huimm16 */
      *pval &= 0xFFFF;
      *pval |= luimm16 (hword) << 16;
    }
  else
    illegal_instruction ();
  PCREG += 4;
}

static void
decode_CALLa_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* CALLa
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 0 | 0 | 0 | 1 |.S.|.msw...........................|
     |.lsw...........................................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+   */
  int S = ((iw0 >> 8) & 0x1);
  int lsw = ((iw1 >> 0) & 0xffff);
  int msw = ((iw0 >> 0) & 0xff);

  if (S == 1)
    /* CALL  pcrel24 */
    saved_state.rets = PCREG + 4;
  /* JUMP.L  pcrel24 */
  PCREG += pcrel24 (((msw) << 16) | (lsw));
}

static void
decode_LDSTidxI_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* LDSTidxI
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
     |.offset........................................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int Z = ((iw0 >> 8) & 0x1);
  int sz = ((iw0 >> 6) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);
  int ptr = ((iw0 >> 3) & 0x7);
  int offset = ((iw1 >> 0) & 0xffff);
  int W = ((iw0 >> 9) & 0x1);

  if (sz == 3)
    illegal_instruction ();

  if (W == 0)
    {
      if (sz == 0 && Z == 0)
	/* dregs = [pregs + imm16s4] */
	DREG (reg) = get_long (saved_state.memory, PREG (ptr) + imm16s4 (offset));
      else if (sz == 0 && Z == 1)
	/* pregs = [pregs + imm16s4] */
	PREG (reg) = get_long (saved_state.memory, PREG (ptr) + imm16s4 (offset));
      else if (sz == 1 && Z == 0)
	/* dregs = W[pregs + imm16s2] (Z) */
	DREG (reg) = get_word (saved_state.memory, PREG (ptr) + imm16s2 (offset));
      else if (sz == 1 && Z == 1)
	/* dregs = W[pregs + imm16s2] (X) */
	DREG (reg) = (bs32) (bs16) get_word (saved_state.memory, PREG (ptr) + imm16s2 (offset));
      else if (sz == 2 && Z == 0)
	/* dregs = B[pregs + imm16] (Z) */
	DREG (reg) = get_byte (saved_state.memory, PREG (ptr) + imm16 (offset));
      else if (sz == 2 && Z == 1)
	/* dregs = B[pregs + imm16] (X) */
	DREG (reg) = (bs32) (bs8) get_byte (saved_state.memory, PREG (ptr) + imm16 (offset));
    }
  else
    {
      if (sz != 0 && Z != 0)
	illegal_instruction ();

      if (sz == 0 && Z == 0)
	/* [pregs + imm16s4] = dregs */
	put_long (saved_state.memory, PREG (ptr) + imm16s4 (offset), DREG (reg));
      else if (sz == 0 && Z == 1)
	/* [pregs + imm16s4] = pregs */
	put_long (saved_state.memory, PREG (ptr) + imm16s4 (offset), PREG (reg));
      else if (sz == 1 && Z == 0)
	/* W[pregs + imm16s2] = dregs */
	put_word (saved_state.memory, PREG (ptr) + imm16s2 (offset), DREG (reg));
      else if (sz == 2 && Z == 0)
	/* B[pregs + imm16] = dregs */
	put_byte (saved_state.memory, PREG (ptr) + imm16 (offset), DREG (reg));
    }
  PCREG += 4;
}

static void
decode_linkage_0 (bu16 iw0, bu16 iw1)
{
  /* linkage
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.R.|
     |.framesize.....................................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int R = ((iw0 >> 0) & 0x1);
  int framesize = ((iw1 >> 0) & 0xffff);

  if (R == 0)
    {
      bu32 sp = PREG (6);
      /* LINK uimm16s4 */
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
      /* UNLINK */
      PREG (7) = get_long (saved_state.memory, sp);
      sp += 4;
      saved_state.rets = get_long (saved_state.memory, sp);
      sp += 4;
      PREG (6) = sp;
    }
  PCREG += 4;
}

static void
decode_dsp32mac_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* dsp32mac
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
     |.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
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

  bu32 res0, res1;

  if (w0 == 0 && w1 == 0 && op1 == 3 && op0 == 3)
    illegal_instruction ();

  if (op1 == 3 && MM)
    illegal_instruction ();

  if (((1 << mmod) & (P ? 0x313 : 0x1b57)) == 0)
    illegal_instruction ();

  if (w1 == 1 || op1 != 3)
    res1 = decode_macfunc (1, op1, h01, h11, src0, src1, mmod, MM, P);

  if (w0 == 1 || op0 != 3)
    res0 = decode_macfunc (0, op0, h00, h10, src0, src1, mmod, 0, P);

  if (w0)
    {
      if (P)
	DREG (dst) = res0;
      else
	{
	  if (res0 & 0xffff0000)
	    abort ();
	  DREG (dst) = (DREG (dst) & 0xFFFF0000) | res0;
	}
    }

  if (w1)
    {
      if (P)
	DREG (dst + 1) = res1;
      else
	{
	  if (res1 & 0xffff0000)
	    abort ();
	  DREG (dst) = (DREG (dst) & 0xFFFF) | (res1 << 16);
	}
    }

  PCREG += 4;
}

static void
decode_dsp32mult_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* dsp32mult
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
     |.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
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

  bu32 res0, res1;

  if (w1 == 0 && w0 == 0)
    illegal_instruction ();
  if (((1 << mmod) & (P ? 0x313 : 0x1b57)) == 0)
    illegal_instruction ();

  if (w1)
    {
      int sat;
      bu64 r = decode_multfunc (h01, h11, src0, src1, mmod, MM, &sat);
      STORE (saved_state.av1, sat);
      STORE (saved_state.av1s, saved_state.av1s | sat);
      res1 = extract_mult (r, mmod, P);
    }

  if (w0)
    {
      int sat;
      bu64 r = decode_multfunc (h00, h10, src0, src1, mmod, 0, &sat);
      STORE (saved_state.av0, sat);
      STORE (saved_state.av0s, saved_state.av0s | sat);
      res0 = extract_mult (r, mmod, P);
    }

  if (w0)
    {
      if (P)
	DREG (dst) = res0;
      else
	{
	  if (res0 & 0xFFFF0000)
	    abort ();
	  DREG (dst) = (DREG (dst) & 0xFFFF0000) | res0;
	}
    }

  if (w1)
    {
      if (P)
	DREG (dst + 1) = res1;
      else
	{
	  if (res1 & 0xFFFF0000)
	    abort ();
	  DREG (dst) = (DREG (dst) & 0xFFFF) | (res1 << 16);
	}
    }

  PCREG += 4;
}

static void
decode_dsp32alu_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* dsp32alu
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
     |.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
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

  if (aop == 0 && aopcde == 9 && HL == 0 && s == 0)
    unhandled_instruction ("A0.L = dregs_lo");
  else if (aop == 2 && aopcde == 9 && HL == 1 && s == 0)
    unhandled_instruction ("A1.H = dregs_hi");
  else if (aop == 2 && aopcde == 9 && HL == 0 && s == 0)
    unhandled_instruction ("A1.L = dregs_lo");
  else if (aop == 0 && aopcde == 9 && HL == 1 && s == 0)
    unhandled_instruction ("A0.H = dregs_hi");
  else if (x == 1 && HL == 1 && aop == 3 && aopcde == 5)
    unhandled_instruction ("dregs_hi = dregs - dregs (RND20)");
  else if (x == 1 && HL == 1 && aop == 2 && aopcde == 5)
    unhandled_instruction ("dregs_hi = dregs + dregs (RND20)");
  else if (x == 0 && HL == 0 && aop == 1 && aopcde == 5)
    unhandled_instruction ("dregs_lo = dregs - dregs (RND12)");
  else if (x == 0 && HL == 0 && aop == 0 && aopcde == 5)
    unhandled_instruction ("dregs_lo = dregs + dregs (RND12)");
  else if (x == 1 && HL == 0 && aop == 3 && aopcde == 5)
    unhandled_instruction ("dregs_lo = dregs - dregs (RND20)");
  else if (x == 0 && HL == 1 && aop == 0 && aopcde == 5)
    unhandled_instruction ("dregs_hi = dregs + dregs (RND12)");
  else if (x == 1 && HL == 0 && aop == 2 && aopcde == 5)
    unhandled_instruction ("dregs_lo = dregs + dregs (RND20)");
  else if (x == 0 && HL == 1 && aop == 1 && aopcde == 5)
    unhandled_instruction ("dregs_hi = dregs - dregs (RND12)");
  else if (aopcde == 2 || aopcde == 3)
    {
      bu32 s1 = DREG (src0);
      bu32 s2 = DREG (src1);
      bu16 val;
      if (aop & 1)
	s2 >>= 16;
      if (aop & 2)
	s1 >>= 16;
      if (aopcde == 2)
	val = add16 (s1, s2, &saved_state.ac0, s);
      else
	val = sub16 (s1, s2, &saved_state.ac0, s);
      if (HL)
	DREG (dst0) = (DREG (dst0) & 0xFFFF) | (val << 16);
      else
	DREG (dst0) = (DREG (dst0) & 0xFFFF0000) | val;
    }
  else if (aop == 0 && aopcde == 9 && s == 1)
    {
      saved_state.a0w = DREG (src0);
      saved_state.a0x = -(saved_state.a1w >> 31);
    }
  else if (aop == 1 && aopcde == 9 && s == 0)
    saved_state.a0x = (bs32)(bs8)DREG (src0);
  else if (aop == 2 && aopcde == 9 && s == 1)
    {
      saved_state.a1w = DREG (src0);
      saved_state.a1x = -(saved_state.a1w >> 31);
    }
  else if (aop == 3 && aopcde == 9 && s == 0)
    saved_state.a1x = (bs32)(bs8)DREG (src0);
  else if (aop == 3 && aopcde == 11 && s == 0)
    unhandled_instruction ("A0 -= A1");
  else if (aop == 3 && aopcde == 11 && s == 1)
    unhandled_instruction ("A0 -= A1 (W32)");
  else if (aop == 3 && aopcde == 22 && HL == 1)
    unhandled_instruction ("dregs = BYTEOP2M (dregs_pair, dregs_pair) (TH,R)");
  else if (aop == 3 && aopcde == 22 && HL == 0)
    unhandled_instruction ("dregs = BYTEOP2M (dregs_pair, dregs_pair) (TL,R)");
  else if (aop == 2 && aopcde == 22 && HL == 1)
    unhandled_instruction ("dregs = BYTEOP2M (dregs_pair, dregs_pair) (RNDH,R)");
  else if (aop == 2 && aopcde == 22 && HL == 0)
    unhandled_instruction ("dregs = BYTEOP2M (dregs_pair, dregs_pair) (RNDL,R)");
  else if (aop == 1 && aopcde == 22 && HL == 1)
    unhandled_instruction ("dregs = BYTEOP2P (dregs_pair, dregs_pair) (TH ,R)");
  else if (aop == 1 && aopcde == 22 && HL == 0)
    unhandled_instruction ("dregs = BYTEOP2P (dregs_pair, dregs_pair) (TL ,R)");
  else if (aop == 0 && aopcde == 22 && HL == 1)
    unhandled_instruction ("dregs = BYTEOP2P (dregs_pair, dregs_pair) (RNDH,R)");
  else if (aop == 0 && aopcde == 22 && HL == 0)
    unhandled_instruction ("dregs = BYTEOP2P (dregs_pair, dregs_pair) (RNDL,aligndir)");
  else if (aop == 0 && s == 0 && aopcde == 8)
    {
      /* A0 = 0 */
      saved_state.a0x = 0;
      saved_state.a0w = 0;
    }
  else if (aop == 1 && s == 0 && aopcde == 8)
    {
      /* A1 = 0 */
      saved_state.a1x = 0;
      saved_state.a1w = 0;
    }
  else if (aop == 2 && s == 0 && aopcde == 8)
    {
      /* A1 = A0 = 0 */
      saved_state.a1x = saved_state.a0x = 0;
      saved_state.a1w = saved_state.a0w = 0;
    }
  else if (aop == 0 && s == 1 && aopcde == 8)
    {
      saved_state.a0x = -(saved_state.a0w >> 31);
    }
  else if (aop == 1 && s == 1 && aopcde == 8)
    {
      saved_state.a1x = -(saved_state.a1w >> 31);
    }
  else if (aop == 2 && s == 1 && aopcde == 8)
    {
      saved_state.a0x = -(saved_state.a0w >> 31);
      saved_state.a1x = -(saved_state.a1w >> 31);
    }
  else if (aop == 3 && s == 0 && aopcde == 8)
    {
      saved_state.a0x = saved_state.a1x;
      saved_state.a0w = saved_state.a1w;
    }
  else if (aop == 3 && s == 1 && aopcde == 8)
    {
      saved_state.a1x = saved_state.a0x;
      saved_state.a1w = saved_state.a0w;
    }
  else if (aop == 3 && HL == 0 && aopcde == 16)
    unhandled_instruction ("A1 = ABS A1, A0 = ABS A0");
  else if (aop == 0 && aopcde == 23 && HL == 1)
    unhandled_instruction ("dregs = BYTEOP3P (dregs_pair, dregs_pair) (HI,R)");
  else if (aop == 1 && HL == 1 && aopcde == 16)
    unhandled_instruction ("A1 = ABS A1");
  else if (aop == 0 && HL == 1 && aopcde == 16)
    unhandled_instruction ("A1 = ABS A0");
  else if (HL == 0 && aop == 3 && aopcde == 12)
    unhandled_instruction ("dregs_lo = dregs (RND)");
  else if (aop == 1 && HL == 0 && aopcde == 16)
    unhandled_instruction ("A0 = ABS A1");
  else if (aop == 0 && HL == 0 && aopcde == 16)
    unhandled_instruction ("A0 = ABS A0");
  else if (aop == 3 && HL == 0 && aopcde == 15)
    {
      /* Vector NEG.  */
      bu32 hi = (-(bs16)(DREG (src0) >> 16)) << 16;
      bu32 lo = (-(bs16)(DREG (src0) & 0xFFFF)) & 0xFFFF;

      saved_state.v = 0;
      saved_state.v_copy = 0;
      saved_state.ac0 = 0;
      saved_state.ac0_copy = 0;
      saved_state.ac1 = 0;

      if (hi == 0x80000000)
	{
	  hi = 0x7fff0000;
	  saved_state.v = 1;
	  saved_state.v_copy = 1;
	  saved_state.vs = 1;
	}
      else if (hi == 0)
	saved_state.ac1 = 1;

      if (lo == 0x8000)
	{
	  lo = 0x7fff;
	  saved_state.v = 1;
	  saved_state.v_copy = 1;
	  saved_state.vs = 1;
	}
      else if (lo == 0)
	{
	  saved_state.ac0 = 1;
	  saved_state.ac0_copy = 1;
	}
      DREG (dst0) = hi | lo;
      setflags_nz_2x16 (DREG (dst0));
    }
  else if (aop == 3 && HL == 0 && aopcde == 14)
    unhandled_instruction ("A1 = - A1 , A0 = - A0");
  else if (HL == 1 && aop == 3 && aopcde == 12)
    unhandled_instruction ("dregs_hi = dregs (RND)");
  else if (aop == 0 && aopcde == 23 && HL == 0)
    unhandled_instruction ("dregs = BYTEOP3P (dregs_pair, dregs_pair) (LO,R)");
  else if (aop == 0 && HL == 0 && aopcde == 14)
    unhandled_instruction ("A0 = - A0");
  else if (aop == 1 && HL == 0 && aopcde == 14)
    unhandled_instruction ("A0 = - A1");
  else if (aop == 0 && HL == 1 && aopcde == 14)
    unhandled_instruction ("A1 = - A0");
  else if (aop == 1 && HL == 1 && aopcde == 14)
    unhandled_instruction ("A1 = - A1");
  else if (aop == 0 && aopcde == 12)
    unhandled_instruction ("dregs_hi=dregs_lo=SIGN(dregs_hi)*dregs_hi + SIGN(dregs_lo)*dregs_lo)");
  else if (aopcde == 0)
    {
      /* dregs = dregs +-|+- dregs amod0 */
      bu32 s0 = DREG (src0);
      bu32 s1 = DREG (src1);
      bu32 s0h = s0 >> 16;
      bu32 s0l = s0 & 0xFFFF;
      bu32 s1h = s1 >> 16;
      bu32 s1l = s1 & 0xFFFF;
      bu32 t0, t1;
      if (aop & 2)
	t0 = sub16 (s0h, s1h, &saved_state.ac1, s);
      else
	t0 = add16 (s0h, s1h, &saved_state.ac1, s);
      if (aop & 1)
	t1 = sub16 (s0l, s1l, &saved_state.ac0, s);
      else
	t1 = add16 (s0l, s1l, &saved_state.ac0, s);
      t0 &= 0xFFFF;
      t1 &= 0xFFFF;
      if (x)
	DREG (dst0) = (t1 << 16) | t0;
      else
	DREG (dst0) = (t0 << 16) | t1;
    }
  else if (aop == 1 && aopcde == 12)
    unhandled_instruction ("dregs = A1.L + A1.H , dregs = A0.L + A0.H");
  else if (HL == 0 && aopcde == 1)
    {
      if (aop == 0)
	{
	  /* dregs = dregs +|+ dregs, dregs = dregs -|- dregs (amod0) */
	  bu32 d0, d1;
	  d1 = addadd16 (DREG (src0), DREG (src1), s, 0);
	  d0 = subsub16 (DREG (src0), DREG (src1), s, x);
	  STORE (DREG (dst0), d0);
	  STORE (DREG (dst1), d1);
	}
      else
	unhandled_instruction
	  ("dregs = dregs +|+ dregs, dregs = dregs -|- dregs (amod0, amod2)");
    }
  else if (aop == 1 && HL == 0 && aopcde == 11)
    unhandled_instruction ("dregs_lo = (A0 += A1)");
  else if (aop == 1 && HL == 1 && aopcde == 11)
    unhandled_instruction ("dregs_hi = (A0 += A1)");
  else if ((aop == 0 || aop == 2) && aopcde == 11)
    {
      bu64 acc0 = get_extended_acc0 ();
      bu64 acc1 = get_extended_acc1 ();

      acc0 += acc1;
      if ((bs64)acc0 < -0x8000000000ll)
	acc0 = -0x8000000000ull;
      else if ((bs64)acc0 >= 0x7fffffffffll)
	acc0 = 0x7fffffffffull;
      STORE (A0XREG, (acc0 >> 32) & 0xff);
      STORE (A0WREG, acc0 & 0xffffffff);
      if (aop == 2 && s == 1)
	unhandled_instruction ("A0 += A1 (W32)");
      if (aop == 0)
	{
	  if ((bs64)acc0 < -0x80000000ll)
	    STORE (DREG (dst0), 0x80000000);
	  else if ((bs64)acc0 > 0x7fffffff)
	    STORE (DREG (dst0), 0x7fffffff);
	  else
	    STORE (DREG (dst0), acc0);
	}
    }
  else if (aop == 0 && aopcde == 10)
    {
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= saved_state.a0x & 0xFFFF;
    }
  else if (aop == 1 && aopcde == 10)
    {
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= saved_state.a1x & 0xFFFF;
    }
  else if (aop == 0 && aopcde == 4)
    DREG (dst0) = add32 (DREG (src0), DREG (src1), 1, s);
  else if (aop == 1 && aopcde == 4)
    DREG (dst0) = sub32 (DREG (src0), DREG (src1), 1, s);
  else if (aop == 2 && aopcde == 4)
    unhandled_instruction ("dregs = dregs + dregs , dregs = dregs - dregs amod1");
  else if (aop == 0 && aopcde == 17)
    unhandled_instruction ("dregs = A1 + A0, dregs = A1 - A0 amod1");
  else if (aop == 1 && aopcde == 17)
    unhandled_instruction ("dregs = A0 + A1, dregs = A0 - A1 amod1");
  else if (aop == 0 && aopcde == 18)
    unhandled_instruction ("SAA (dregs_pair, dregs_pair) aligndir");
  else if (aop == 3 && aopcde == 18)
    unhandled_instruction ("DISALGNEXCPT");
  else if (aop == 0 && aopcde == 20)
    unhandled_instruction ("dregs = BYTEOP1P (dregs_pair, dregs_pair) aligndir");
  else if (aop == 1 && aopcde == 20)
    unhandled_instruction ("dregs = BYTEOP1P (dregs_pair, dregs_pair) (T, R)");
  else if (aop == 0 && aopcde == 21)
    unhandled_instruction ("(dregs, dregs) = BYTEOP16P (dregs_pair, dregs_pair) aligndir");
  else if (aop == 1 && aopcde == 21)
    unhandled_instruction ("(dregs, dregs) = BYTEOP16M (dregs_pair, dregs_pair) aligndir");
  else if (aop == 1 && aopcde == 7)
    /* dregs = MIN (dregs, dregs) */
    DREG (dst0) = min32 (DREG (src0), DREG (src1));
  else if (aop == 0 && aopcde == 7)
    /* dregs = MAX (dregs, dregs) */
    DREG (dst0) = max32 (DREG (src0), DREG (src1));
  else if (aop == 2 && aopcde == 7)
    {
      bu32 val = DREG (src0);
      /* dregs = ABS dregs */
      if (val >> 31)
	val = -val;
      if (val == 0x80000000)
	{
	  val = 0x7fffffff;
	  saved_state.v = 1;
	  saved_state.vs = 1;
	  saved_state.v_copy = 1;
	}
      else
	{
	  saved_state.v = 0;
	  saved_state.v_copy = 0;
	}
      setflags_nz (val);
      DREG (dst0) = val;
    }
  else if (aop == 3 && aopcde == 7)
    {
      bu32 val = DREG (src0);
      /* dregs = - dregs (opt_sat) */
      saved_state.v = val == 0x8000;
      if (saved_state.v)
	saved_state.vs = 1;
      if (val == 0x80000000)
	val = 0x7fffffff;
      else
	val = -val;
      setflags_logical (val);
      DREG (dst0) = val;
    }
  else if (aop == 2 && aopcde == 6)
    {
      /* Vector ABS.  */
      bu32 in = DREG (src0);
      bu32 hi = (in & 0x80000000 ? -(bs16)(in >> 16) : in >> 16) << 16;
      bu32 lo = (in & 0x8000 ? -(bs16)(in & 0xFFFF) : in) & 0xFFFF;
      DREG (dst0) = hi | lo;
      setflags_nz_2x16 (DREG (dst0));
      saved_state.v = 0;
    }
  else if (aop == 1 && aopcde == 6)
    DREG (dst0) = min2x16 (DREG (src0), DREG (src1));
  else if (aop == 0 && aopcde == 6)
    DREG (dst0) = max2x16 (DREG (src0), DREG (src1));
  else if (HL == 1 && aopcde == 1)
    unhandled_instruction ("dregs = dregs +|- dregs, dregs = dregs -|+ dregs (amod0, amod2)");
  else if (aop == 0 && aopcde == 24)
    unhandled_instruction ("dregs = BYTEPACK (dregs, dregs)");
  else if (aop == 1 && aopcde == 24)
    unhandled_instruction ("(dregs, dregs) = BYTEUNPACK dregs_pair aligndir");
  else if (aopcde == 13)
    unhandled_instruction ("(dregs, dregs) = SEARCH dregs (searchmod)");
  else
    illegal_instruction ();
  PCREG += 4;
}

static void
decode_dsp32shift_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* dsp32shift
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
     |.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src0 = ((iw1 >> 3) & 0x7);
  int src1 = ((iw1 >> 0) & 0x7);
  int sop = ((iw1 >> 14) & 0x3);
  int dst0 = ((iw1 >> 9) & 0x7);
  int M = ((iw0 >> 11) & 0x1);
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);

  if (HLs == 0 && sop == 0 && sopcde == 0)
    unhandled_instruction ("dregs_lo = ASHIFT dregs_lo BY dregs_lo");
  else if (HLs == 1 && sop == 0 && sopcde == 0)
    unhandled_instruction ("dregs_lo = ASHIFT dregs_hi BY dregs_lo");
  else if (HLs == 2 && sop == 0 && sopcde == 0)
    unhandled_instruction ("dregs_hi = ASHIFT dregs_lo BY dregs_lo");
  else if (HLs == 3 && sop == 0 && sopcde == 0)
    unhandled_instruction ("dregs_hi = ASHIFT dregs_hi BY dregs_lo");
  else if (HLs == 0 && sop == 1 && sopcde == 0)
    unhandled_instruction ("dregs_lo = ASHIFT dregs_lo BY dregs_lo (S)");
  else if (HLs == 1 && sop == 1 && sopcde == 0)
    unhandled_instruction ("dregs_lo = ASHIFT dregs_hi BY dregs_lo (S)");
  else if (HLs == 2 && sop == 1 && sopcde == 0)
    unhandled_instruction ("dregs_hi = ASHIFT dregs_lo BY dregs_lo (S)");
  else if (HLs == 3 && sop == 1 && sopcde == 0)
    unhandled_instruction ("dregs_hi = ASHIFT dregs_hi BY dregs_lo (S)");
  else if (HLs == 0 && sop == 2 && sopcde == 0)
    unhandled_instruction ("dregs_lo = LSHIFT dregs_lo BY dregs_lo");
  else if (HLs == 1 && sop == 2 && sopcde == 0)
    unhandled_instruction ("dregs_lo = LSHIFT dregs_hi BY dregs_lo");
  else if (HLs == 2 && sop == 2 && sopcde == 0)
    unhandled_instruction ("dregs_hi = LSHIFT dregs_lo BY dregs_lo");
  else if (HLs == 3 && sop == 2 && sopcde == 0)
    unhandled_instruction ("dregs_hi = LSHIFT dregs_hi BY dregs_lo");
  else if (sop == 2 && sopcde == 3 && HLs == 1)
    unhandled_instruction ("A1 = ROT A1 BY dregs_lo");
  else if (sop == 0 && sopcde == 3 && HLs == 0)
    unhandled_instruction ("A0 = ASHIFT A0 BY dregs_lo");
  else if (sop == 0 && sopcde == 3 && HLs == 1)
    unhandled_instruction ("A1 = ASHIFT A1 BY dregs_lo");
  else if (sop == 1 && sopcde == 3 && HLs == 0)
    unhandled_instruction ("A0 = LSHIFT A0 BY dregs_lo");
  else if (sop == 1 && sopcde == 3 && HLs == 1)
    unhandled_instruction ("A1 = LSHIFT A1 BY dregs_lo");
  else if (sop == 2 && sopcde == 3 && HLs == 0)
    unhandled_instruction ("A0 = ROT A0 BY dregs_lo");
  else if (sop == 1 && sopcde == 1)
    unhandled_instruction ("dregs = ASHIFT dregs BY dregs_lo (V,S)");
  else if (sop == 0 && sopcde == 1)
    unhandled_instruction ("dregs = ASHIFT dregs BY dregs_lo (V)");
  else if ((sop == 0 || sop == 1 || sop == 2) && sopcde == 2)
    {
      /* dregs = [LA]SHIFT dregs BY dregs_lo (opt_S) */
      bu32 v = DREG (src1);
      bs32 shft = (bs16)DREG (src0);
      if (shft < 0)
	{
	  if (sop == 2)
	    DREG (dst0) = lshiftrt (v, -shft, 32);
	  else
	    DREG (dst0) = ashiftrt (v, -shft, 32);
	}
      else
	{
	  DREG (dst0) = lshift (v, shft, 32, sop == 1);
	}
    }
  else if (sop == 3 && sopcde == 2)
    unhandled_instruction ("dregs = ROT dregs BY dregs_lo");
  else if (sop == 2 && sopcde == 1)
    unhandled_instruction ("dregs = SHIFT dregs BY dregs_lo (V)");
  else if (sopcde == 4)
    {
      bu32 sv0 = DREG (src0);
      bu32 sv1 = DREG (src1);
      if (sop & 1)
	sv0 >>= 16;
      if (sop & 2)
	sv1 >>= 16;
      DREG (dst0) = (sv1 << 16) | (sv0 & 0xFFFF);
    }
  else if (sop == 0 && sopcde == 5)
    {
      bu32 sv1 = DREG (src1);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= signbits (sv1, 32);
    }
  else if (sop == 1 && sopcde == 5)
    {
      bu32 sv1 = DREG (src1);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= signbits (sv1, 16);
    }
  else if (sop == 2 && sopcde == 5)
    {
      bu32 sv1 = DREG (src1);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= signbits (sv1 >> 16, 16);
    }
  else if (sop == 0 && sopcde == 6)
    {
      bu64 acc0 = saved_state.a0x;
      acc0 <<= 32;
      acc0 |= saved_state.a0w;
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= signbits (acc0, 40);
    }
  else if (sop == 1 && sopcde == 6)
    {
      bu64 acc1 = saved_state.a1x;
      acc1 <<= 32;
      acc1 |= saved_state.a1w;
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= signbits (acc1, 40);
    }
  else if (sop == 3 && sopcde == 6)
    unhandled_instruction ("dregs_lo = ONES dregs");
  else if (sop == 0 && sopcde == 7)
    unhandled_instruction ("dregs_lo = EXPADJ (dregs, dregs_lo)");
  else if (sop == 1 && sopcde == 7)
    unhandled_instruction ("dregs_lo = EXPADJ (dregs, dregs_lo) (V)");
  else if (sop == 2 && sopcde == 7)
    unhandled_instruction ("dregs_lo = EXPADJ (dregs_lo, dregs_lo)");
  else if (sop == 3 && sopcde == 7)
    unhandled_instruction ("dregs_lo = EXPADJ (dregs_hi, dregs_lo)");
  else if (sop == 0 && sopcde == 8)
    unhandled_instruction ("BITMUX (dregs, dregs, A0) (ASR)");
  else if (sop == 1 && sopcde == 8)
    unhandled_instruction ("BITMUX (dregs, dregs, A0) (ASL)");
  else if (sop == 0 && sopcde == 9)
    unhandled_instruction ("dregs_lo = VIT_MAX (dregs) (ASL)");
  else if (sop == 1 && sopcde == 9)
    unhandled_instruction ("dregs_lo = VIT_MAX (dregs) (ASR)");
  else if (sop == 2 && sopcde == 9)
    unhandled_instruction ("dregs = VIT_MAX (dregs, dregs) (ASL)");
  else if (sop == 3 && sopcde == 9)
    unhandled_instruction ("dregs = VIT_MAX (dregs, dregs) (ASR)");
  else if (sop == 0 && sopcde == 10)
    {
      /* dregs = EXTRACT (dregs, dregs_lo) (Z) */
      bu32 v = DREG (src0);
      bu32 x = DREG (src1);
      bu32 mask = (1 << (v & 0x1f)) - 1;
      x >>= ((v >> 8) & 0x1f);
      DREG (dst0) = x & mask;
      setflags_logical (DREG (dst0));
    }
  else if (sop == 1 && sopcde == 10)
    {
      /* dregs = EXTRACT (dregs, dregs_lo) (X) */
      bu32 v = DREG (src0);
      bu32 x = DREG (src1);
      bu32 sgn = (1 << (v & 0x1f)) >> 1;
      bu32 mask = (1 << (v & 0x1f)) - 1;
      x >>= ((v >> 8) & 0x1f);
      x &= mask;
      if (x & sgn)
	x |= ~mask;
      DREG (dst0) = x;
      setflags_logical (DREG (dst0));
    }
  else if (sop == 2 && sopcde == 10)
    {
      /* dregs = DEPOSIT (dregs, dregs) */
      bu32 v = DREG (src0);
      bu32 x = DREG (src1);
      bu32 mask = (1 << (v & 0x1f)) - 1;
      bu32 fgnd = (v >> 16) & mask;
      int shft = ((v >> 8) & 0x1f);
      fgnd <<= shft;
      mask <<= shft;
      x &= ~mask;
      DREG (dst0) = x | fgnd;
      setflags_logical (DREG (dst0));
    }
  else if (sop == 3 && sopcde == 10)
    {
      /* dregs = DEPOSIT (dregs, dregs) */
      bu32 v = DREG (src0);
      bu32 x = DREG (src1);
      bu32 mask = (1 << (v & 0x1f)) - 1;
      bu32 fgnd = ((bs32)(bs16)(v >> 16)) & mask;
      int shft = ((v >> 8) & 0x1f);
      fgnd <<= shft;
      mask <<= shft;
      x &= ~mask;
      DREG (dst0) = x | fgnd;
      setflags_logical (DREG (dst0));
    }
  else if (sop == 0 && sopcde == 11)
    unhandled_instruction ("dregs_lo = CC = BXORSHIFT (A0, dregs)");
  else if (sop == 1 && sopcde == 11)
    unhandled_instruction ("dregs_lo = CC = BXOR (A0, dregs)");
  else if (sop == 0 && sopcde == 12)
    unhandled_instruction ("A0 = BXORSHIFT (A0, A1, CC)");
  else if (sop == 1 && sopcde == 12)
    unhandled_instruction ("dregs_lo = CC = BXOR (A0, A1, CC)");
  else if (sop == 0 && sopcde == 13)
    /* dregs = ALIGN8 (dregs, dregs) */
    DREG (dst0) = (DREG (src1) << 24) | (DREG (src0) >> 8);
  else if (sop == 1 && sopcde == 13)
    /* dregs = ALIGN16 (dregs, dregs) */
    DREG (dst0) = (DREG (src1) << 16) | (DREG (src0) >> 16);
  else if (sop == 2 && sopcde == 13)
    /* dregs = ALIGN24 (dregs , dregs) */
    DREG (dst0) = (DREG (src1) << 8) | (DREG (src0) >> 24);
  else
    illegal_instruction ();
  PCREG += 4;
}

static void
decode_dsp32shiftimm_0 (bu16 iw0, bu16 iw1, bu32 pc)
{
  /* dsp32shiftimm
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
     |.sop...|.HLs...|.dst0......|.immag.................|.src1......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src1 = ((iw1 >> 0) & 0x7);
  int sop = ((iw1 >> 14) & 0x3);
  int immag = ((iw1 >> 3) & 0x3f);
  int newimmag = (-(iw1 >> 3) & 0x3f);
  int dst0 = ((iw1 >> 9) & 0x7);
  int M = ((iw0 >> 11) & 0x1);
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);
  int bit8 = immag >> 5;

  if (sopcde == 0)
    {
      bu16 in = DREG (src1) >> ((HLs & 1) ? 16 : 0);
      bu16 result;
      bu32 v;
      if (sop == 0 && bit8)
	result = ashiftrt (in, newimmag, 16);
      else if (sop == 1 && bit8)
	result = lshift (in, immag, 16, 1);
      else if (sop == 2 && bit8)
	result = lshiftrt (in, newimmag, 16);
      else if (sop == 2)
	result = lshift (in, immag, 16, 0);
      else
	unhandled_instruction ("illegal DSP shift");
      v = DREG (dst0);
      if (HLs & 2)
	STORE (DREG (dst0), (v & 0xFFFF) | (result << 16));
      else
	STORE (DREG (dst0), (v & 0xFFFF0000) | result);
    }
  else if (sop == 2 && sopcde == 3 && HLs == 1)
    unhandled_instruction ("A1 = ROT A1 BY imm6");
  else if (sop == 0 && sopcde == 3 && bit8 == 0)
    unhandled_instruction ("An = An << imm6");
  else if (sop == 0 && sopcde == 3 && bit8 == 1)
    {
      /* Arithmetic shift, so shift in sign bit copies.  */
      bu64 acc = HLs ? get_extended_acc1 () : get_extended_acc0 ();
      acc >>= uimm5 (newimmag);
      /* Sign extend again.  */
      if (acc & (1ULL << 39))
	acc |= -(1ULL << 39);
      else
	acc &= ~(-(1ULL << 39));
      if (HLs)
	{
	  STORE (A1XREG, acc >> 32);
	  STORE (A1WREG, acc & 0xFFFFFFFF);
	}
      else
	{
	  STORE (A0XREG, acc >> 32);
	  STORE (A0WREG, acc & 0xFFFFFFFF);
	}
    }
  else if (sop == 1 && sopcde == 3)
    {
      bu64 acc = HLs ? saved_state.a1x : saved_state.a0x;
      /* Logical shift, so shift in zeroes.  */
      acc &= 0xFF;
      acc <<= 32;
      acc |= HLs ? saved_state.a1w : saved_state.a0w;

      acc >>= uimm5 (newimmag);
      if (HLs)
	{
	  saved_state.a1x = acc >> 32;
	  saved_state.a1w = acc;
	}
      else
	{
	  saved_state.a0x = acc >> 32;
	  saved_state.a0w = acc;
	}
    }
  else if (sop == 1 && sopcde == 3 && HLs == 1)
    unhandled_instruction ("A1 = A1 >> imm6");
  else if (sop == 2 && sopcde == 3 && HLs == 0)
    unhandled_instruction ("A0 = ROT A0 BY imm6");
  else if (sop == 1 && sopcde == 1)
    unhandled_instruction ("dregs = dregs >>> uimm5 (V,S)");
  else if (sop == 2 && sopcde == 1)
    unhandled_instruction ("dregs = dregs >> uimm5 (V)");
  else if (sop == 0 && sopcde == 1)
    unhandled_instruction ("dregs = dregs << imm5 (V)");
  else if (sop == 1 && sopcde == 2)
    {
      int count = imm6 (immag);
      /* dregs = dregs << imm6 (S) */
      if (count >= 0)
        STORE (DREG (dst0), lshift (DREG (src1), count, 32, 1));
      else
        illegal_instruction ();
    }
  else if (sop == 2 && sopcde == 2)
    {
      int count = imm6 (newimmag);
      /* dregs = dregs >> imm6 */
      if (count < 0)
	STORE (DREG (dst0), lshift (DREG (src1), -count, 32, 0));
      else
	STORE (DREG (dst0), lshiftrt (DREG (src1), count, 32));
    }
  else if (sop == 3 && sopcde == 2)
    {
      int t = imm6 (immag);
      /* dregs = ROT dregs BY imm6 */

      /* Reduce everything to rotate left.  */
      if (t < 0)
	t += 33;

      if (t > 0)
	{
	  int oldcc = CCREG;
	  bu32 srcval = DREG (src1);
	  bu32 result;
	  result = t == 32 ? 0 : srcval << t;
	  result |= t == 1 ? 0 : srcval >> (33 - t);
	  result |= oldcc << (t - 1);
	  STORE (DREG (dst0), result);
	  CCREG = (srcval >> (32 - t)) & 1;
	}
      else
	STORE (DREG (dst0), DREG (src1));
    }
  else if (sop == 0 && sopcde == 2)
    {
      int count = imm6 (newimmag);
      /* dregs = dregs >>> imm6 */
      if (count < 0)
	STORE (DREG (dst0), lshift (DREG (src1), -count, 32, 0));
      else
	STORE (DREG (dst0), ashiftrt (DREG (src1), count, 32));
    }
  else
    illegal_instruction ();

  PCREG += 4;
}

static void
decode_psedoDEBUG_0 (bu16 iw0)
{
  /* psedoDEBUG
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int grp = ((iw0 >> 3) & 0x7);
  int fn = ((iw0 >> 6) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);

  if (reg == 0 && fn == 3)
    unhandled_instruction ("DBG A0");
  else if (reg == 1 && fn == 3)
    unhandled_instruction ("DBG A1");
  else if (reg == 3 && fn == 3)
    unhandled_instruction ("ABORT");
  else if (reg == 4 && fn == 3)
    {
      /* HLT */
      saved_state.exception = TARGET_SIGNAL_QUIT;
      DREG (0) = 0;
    }
  else if (reg == 5 && fn == 3)
    unhandled_instruction ("DBGHALT");
  else if (reg == 6 && fn == 3)
    unhandled_instruction ("DBGCMPLX (dregs)");
  else if (reg == 7 && fn == 3)
    unhandled_instruction ("DBG");
  else if (grp == 0 && fn == 2)
    unhandled_instruction ("OUTC dregs");
  else if (fn == 0)
    unhandled_instruction ("DBG allregs");
  else if (fn == 1)
    unhandled_instruction ("PRNT allregs");
  else
    illegal_instruction ();

  PCREG += 2;
}

static void
decode_psedoOChar_0 (bu16 iw0)
{
  /* psedoOChar
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 |.ch............................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int ch = ((iw0 >> 0) & 0xff);

  unhandled_instruction ("OUTC uimm8");
  PCREG += 2;
}

static void
decode_psedodbg_assert_0 (bu16 iw0, bu16 iw1)
{
  /* psedodbg_assert
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 1 | 0 | - | - | - | dbgop |.grp.......|.regtest...|
     |.expected......................................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  bu32 expected = ((iw1 >> 0) & 0xffff);
  int dbgop = ((iw0 >> 6) & 0x3);
  int grp = ((iw0 >> 3) & 0x7);
  int regtest = ((iw0 >> 0) & 0x7);
  bu32 *reg = get_allreg (grp, regtest);

  if (dbgop == 0 || dbgop == 2)
    {
      /* DBGA ( regs_lo , uimm16 ) */
      /* DBGAL ( regs , uimm16 ) */
      if ((*reg & 0xffff) != expected)
	{
	  fprintf(stderr, "DBGA/DBGAL failed at 0x%x: is 0x%x, should be 0x%x\n",
		  PCREG, *reg & 0xffff, expected);
	  saved_state.exception = TARGET_SIGNAL_QUIT;
	  DREG (0) = 1;
	}
    }
  else if (dbgop == 1 || dbgop == 3)
    {
      /* DBGA ( regs_hi , uimm16 ) */
      /* DBGAH ( regs , uimm16 ) */
      if ((*reg >> 16) != expected)
	{
	  fprintf(stderr, "DBGA/DBGAH failed at 0x%x: is 0x%x, should be 0x%x\n",
		  PCREG, *reg >> 16, expected);
	  saved_state.exception = TARGET_SIGNAL_QUIT;
	  DREG (0) = 1;
	}
    }
  else
    illegal_instruction ();
  PCREG += 4;
}

static void
_interp_insn_bfin (bu32 pc)
{
  bu8 buf[4];
  bu16 iw0 = get_word (saved_state.memory, pc);
  bu16 iw1 = get_word (saved_state.memory, pc + 2);

  if ((iw0 & 0xf7ff) == 0xc003 && iw1 == 0x1800)
    {
      /* MNOP.  */
      PCREG += 4;
      return;
    }
  if ((iw0 & 0xFF00) == 0x0000)
    decode_ProgCtrl_0 (iw0);
  else if ((iw0 & 0xFFC0) == 0x0240)
    decode_CaCTRL_0 (iw0);
  else if ((iw0 & 0xFF80) == 0x0100)
    decode_PushPopReg_0 (iw0);
  else if ((iw0 & 0xFE00) == 0x0400)
    decode_PushPopMultiple_0 (iw0);
  else if ((iw0 & 0xFE00) == 0x0600)
    decode_ccMV_0 (iw0);
  else if ((iw0 & 0xF800) == 0x0800)
    decode_CCflag_0 (iw0);
  else if ((iw0 & 0xFFE0) == 0x0200)
    decode_CC2dreg_0 (iw0);
  else if ((iw0 & 0xFF00) == 0x0300)
    decode_CC2stat_0 (iw0);
  else if ((iw0 & 0xF000) == 0x1000)
    decode_BRCC_0 (iw0, pc);
  else if ((iw0 & 0xF000) == 0x2000)
    decode_UJUMP_0 (iw0, pc);
  else if ((iw0 & 0xF000) == 0x3000)
    decode_REGMV_0 (iw0);
  else if ((iw0 & 0xFC00) == 0x4000)
    decode_ALU2op_0 (iw0);
  else if ((iw0 & 0xFE00) == 0x4400)
    decode_PTR2op_0 (iw0);
  else if (((iw0 & 0xF800) == 0x4800))
    decode_LOGI2op_0 (iw0);
  else if (((iw0 & 0xF000) == 0x5000))
    decode_COMP3op_0 (iw0);
  else if (((iw0 & 0xF800) == 0x6000))
    decode_COMPI2opD_0 (iw0);
  else if (((iw0 & 0xF800) == 0x6800))
    decode_COMPI2opP_0 (iw0);
  else if (((iw0 & 0xF000) == 0x8000))
    decode_LDSTpmod_0 (iw0);
  else if (((iw0 & 0xFF60) == 0x9E60))
    decode_dagMODim_0 (iw0);
  else if (((iw0 & 0xFFF0) == 0x9F60))
    decode_dagMODik_0 (iw0);
  else if (((iw0 & 0xFC00) == 0x9C00))
    decode_dspLDST_0 (iw0);
  else if (((iw0 & 0xF000) == 0x9000))
    decode_LDST_0 (iw0);
  else if (((iw0 & 0xFC00) == 0xB800))
    decode_LDSTiiFP_0 (iw0);
  else if (((iw0 & 0xE000) == 0xA000))
    decode_LDSTii_0 (iw0);
  else if (((iw0 & 0xFF80) == 0xE080) && ((iw1 & 0x0C00) == 0x0000))
    decode_LoopSetup_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFF00) == 0xE100) && ((iw1 & 0x0000) == 0x0000))
    decode_LDIMMhalf_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFE00) == 0xE200) && ((iw1 & 0x0000) == 0x0000))
    decode_CALLa_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFC00) == 0xE400) && ((iw1 & 0x0000) == 0x0000))
    decode_LDSTidxI_0 (iw0, iw1, pc);
  else if (((iw0 & 0xFFFE) == 0xE800) && ((iw1 & 0x0000) == 0x0000))
    decode_linkage_0 (iw0, iw1);
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
    decode_psedoDEBUG_0 (iw0);
  else if (((iw0 & 0xFF00) == 0xF900))
    decode_psedoOChar_0 (iw0);
  else if (((iw0 & 0xFF00) == 0xF000) && ((iw1 & 0x0000) == 0x0000))
    decode_psedodbg_assert_0 (iw0, iw1);
  else
    illegal_instruction ();
}

void
interp_insn_bfin (bu32 pc)
{
  int i;
  bu16 iw0 = get_word (saved_state.memory, pc);
  
  int is_multiinsn = ((iw0 & 0xc000) == 0xc000 && (iw0 & BIT_MULTI_INS)
		      && ((iw0 & 0xe800) != 0xe800 /* not linkage */));

  n_stores = 0;

  _interp_insn_bfin (pc);
  
  /* Proper display of multiple issue instructions.  */
  if (is_multiinsn)
    {
      _interp_insn_bfin (pc + 4);
      _interp_insn_bfin (pc + 6);
    }
  for (i = 0; i < n_stores; i++)
    *stores[i].addr = stores[i].val;
}
