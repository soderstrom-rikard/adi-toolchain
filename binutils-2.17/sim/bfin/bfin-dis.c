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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

#include "gdb/signals.h"
#include "opcode/bfin.h"
#include "sim-main.h"
#include "dv-bfin_cec.h"

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

static __attribute__ ((noreturn)) void
illegal_instruction (SIM_CPU *cpu)
{
  while (1) /* avoid gcc warnings about returning */
    cec_exception (cpu, VEC_UNDEF_I);
}

static __attribute__ ((noreturn)) void
unhandled_instruction (SIM_CPU *cpu, char *insn)
{
  bu16 iw0 = GET_WORD (PCREG);
  bu16 iw1 = GET_WORD (PCREG + 2);
  bu32 iw2 = ((bu32)iw0 << 16) | iw1;

  fprintf(stderr, "Unhandled instruction at 0x%08x (%s opcode 0x", PCREG, insn);
  if ((iw0 & 0xc000) == 0xc000)
    fprintf(stderr, "%08x", iw2);
  else
     fprintf(stderr, "%04x", iw0);

  fprintf(stderr, ") ... aborting\n");

  illegal_instruction (cpu);
}

static void
setflags_nz (SIM_CPU *cpu, bu32 val)
{
  ASTATREG (az) = val == 0;
  ASTATREG (an) = val >> 31;
}

static void
setflags_nz_2x16 (SIM_CPU *cpu, bu32 val)
{
  ASTATREG (an) = (bs16)val < 0 || (bs16)(val >> 16) < 0;
  ASTATREG (az) = (bs16)val == 0 || (bs16)(val >> 16) == 0;
}

static void
setflags_logical (SIM_CPU *cpu, bu32 val)
{
  setflags_nz (cpu, val);
  ASTATREG (ac0) = 0;
  ASTATREG (v) = 0;
}

static int
dagadd_brev(SIM_CPU *cpu, int dagno, bs32 modify)
{
  bs32 i, l, b, val;

  i = IREG (dagno);
  l = LREG (dagno);
  b = BREG (dagno);
  val = i;

  if (l)
    {
      if ((i + modify - b - l < 0 && modify > 0)
	  || (i + modify - b >= 0 && modify < 0))
	val = i + modify;
      else if (i + modify - b - l >= 0 && modify >= 0)
	val = i + modify - l;
      else if (i + modify - b < 0 && modify <= 0)
	val = i + modify + l;
    }
  else
    val = i + modify;

  STORE (IREG (dagno), val);
  return val;
}

static int
dagadd (SIM_CPU *cpu, int dagno, bs32 modify)
{
  bs32 i, l, b, val;

  i = IREG (dagno);
  l = LREG (dagno);
  b = BREG (dagno);
  val = i;

  if (l)
    {
      if ((i + modify - b - l < 0 && modify > 0)
	  || (i + modify - b >= 0 && modify < 0))
	val = i + modify;
      else if (i + modify - b - l >= 0 && modify >= 0)
	val = i + modify - l;
      else if (i + modify - b < 0 && modify <= 0)
	val = i + modify + l;
    }
  else
    val = i + modify;

  STORE (IREG (dagno), val);
  return val;
}

static int
dagsub (SIM_CPU *cpu, int dagno, bs32 modify)
{
  bs32 i, l, b, val;

  i = IREG (dagno);
  l = LREG (dagno);
  b = BREG (dagno);
  val = i;

  if (l)
    {
      if ((i - modify - b - l < 0 && modify < 0)
	  || (i - modify - b >= 0 && modify > 0)
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
ashiftrt (SIM_CPU *cpu, bu32 val, int cnt, int size)
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
  ASTATREG (an) = val >> (size - 1);
  ASTATREG (az) = val == 0;
  /* @@@ */
  ASTATREG (v) = 0;
  return val;
}

static bu32
lshiftrt (SIM_CPU *cpu, bu32 val, int cnt, int size)
{
  int real_cnt = cnt > size ? size : cnt;
  if (real_cnt > 16)
    val >>= 16, real_cnt -= 16;
  val >>= real_cnt;
  ASTATREG (an) = val >> (size - 1);
  ASTATREG (az) = val == 0;
  ASTATREG (v) = 0;
  return val;
}

static bu32
lshift (SIM_CPU *cpu, bu32 val, int cnt, int size, int saturate)
{
  int real_cnt = cnt > size ? size : cnt;
  bu32 sgn = ~((val >> (size - 1)) - 1);
  int mask_cnt = size - real_cnt - !sgn;
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
  ASTATREG (an) = val >> (size - 1);
  ASTATREG (az) = val == 0;
  ASTATREG (v) = 0;
  return val;
}

static bu32
add32 (SIM_CPU *cpu, bu32 a, bu32 b, int carry, int sat)
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
  ASTATREG (an) = flgn;
  ASTATREG (vs) |= overflow;
  ASTATREG (v) = overflow;
  ASTATREG (v_internal) |= overflow;
  ASTATREG (az) = v == 0;
  if (carry)
    ASTATREG (ac0) = ~a < b;
  return v;
}

static bu32
sub32 (SIM_CPU *cpu, bu32 a, bu32 b, int carry, int sat)
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
  ASTATREG (an) = flgn;
  ASTATREG (vs) |= overflow;
  ASTATREG (v) = overflow;
  ASTATREG (v_internal) |= overflow;
  ASTATREG (az) = v == 0;
  if (carry)
    ASTATREG (ac0) = b <= a;
  return v;
}

static bu32
add16 (SIM_CPU *cpu, bu32 a, bu32 b, int *carry, int sat)
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
  ASTATREG (an) = flgn;
  ASTATREG (vs) |= overflow;
  ASTATREG (v) = overflow;
  ASTATREG (v_internal) |= overflow;
  ASTATREG (az) = v == 0;
  if (carry)
    *carry = (bu16)~a < (bu16)b;
  return v & 0xffff;
}

static bu32
sub16 (SIM_CPU *cpu, bu32 a, bu32 b, int *carry, int sat)
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
  ASTATREG (an) = flgn;
  ASTATREG (vs) |= overflow;
  ASTATREG (v) = overflow;
  ASTATREG (v_internal) |= overflow;
  ASTATREG (az) = v == 0;
  if (carry)
    *carry = (bu16)b <= (bu16)a;
  return v;
}

static bu32
addadd16 (SIM_CPU *cpu, bu32 a, bu32 b, int sat, int x)
{
  int c0 = 0, c1 = 0;
  bu32 x0, x1;
  x0 = add16 (cpu, (a >> 16) & 0xffff, (b >> 16) & 0xffff, &c0, sat) & 0xffff;
  x1 = add16 (cpu, a & 0xffff, b & 0xffff, &c1, sat) & 0xffff;
  if (x == 0)
    return (x0 << 16) | x1;
  else
    return (x1 << 16) | x0;
}

static bu32
subsub16 (SIM_CPU *cpu, bu32 a, bu32 b, int sat, int x)
{
  int c0 = 0, c1 = 0;
  bu32 x0, x1;
  x0 = sub16 (cpu, (a >> 16) & 0xffff, (b >> 16) & 0xffff, &c0, sat) & 0xffff;
  x1 = sub16 (cpu, a & 0xffff, b & 0xffff, &c1, sat) & 0xffff;
  if (x == 0)
    return (x0 << 16) | x1;
  else
    return (x1 << 16) | x0;
}

static bu32
min32 (SIM_CPU *cpu, bu32 a, bu32 b)
{
  int val = a;
  if ((bs32)a > (bs32)b)
    val = b;
  setflags_nz (cpu, val);
  ASTATREG (v) = 0;
  return val;
}

static bu32
max32 (SIM_CPU *cpu, bu32 a, bu32 b)
{
  int val = a;
  if ((bs32)a < (bs32)b)
    val = b;
  setflags_nz (cpu, val);
  ASTATREG (v) = 0;
  return val;
}

static bu32
min2x16 (SIM_CPU *cpu, bu32 a, bu32 b)
{
  int val = a;
  if ((bs16)a > (bs16)b)
    val = (val & 0xFFFF0000) | (b & 0xFFFF);
  if ((bs16)(a >> 16) > (bs16)(b >> 16))
    val = (val & 0xFFFF) | (b & 0xFFFF0000);
  setflags_nz_2x16 (cpu, val);
  ASTATREG (v) = 0;
  return val;
}

static bu32
max2x16 (SIM_CPU *cpu, bu32 a, bu32 b)
{
  int val = a;
  if ((bs16)a < (bs16)b)
    val = (val & 0xFFFF0000) | (b & 0xFFFF);
  if ((bs16)(a >> 16) < (bs16)(b >> 16))
    val = (val & 0xFFFF) | (b & 0xFFFF0000);
  setflags_nz_2x16 (cpu, val);
  ASTATREG (v) = 0;
  return val;
}

static bu32
add_and_shift (SIM_CPU *cpu, bu32 a, bu32 b, int shift)
{
  int v;
  ASTATREG (v_internal) = 0;
  v = add32 (cpu, a, b, 0, 0);
  while (shift-- > 0)
    {
      int x = v >> 30;
      if (x == 1 || x == 2)
	ASTATREG (v_internal) = 1;
      v <<= 1;
    }
  ASTATREG (v) = ASTATREG (v_internal);
  ASTATREG (vs) |= ASTATREG (v);
  return v;
}

/* DIVS ( Dreg, Dreg ) ;
 * Initialize for DIVQ. Set the AQ status bit based on the signs of
 * the 32-bit dividend and the 16-bit divisor. Left shift the dividend
 * one bit. Copy AQ into the dividend LSB.
 */
static bu32
divs (SIM_CPU *cpu, bu32 pquo, bu16 divisor)
{
  bu16 r = pquo >> 16;
  int aq;

  aq = (r ^ divisor) >> 15;  /* extract msb's and compute quotient bit */
  ASTATREG (aq) = aq;         /* update global quotient state */

  pquo <<= 1;
  pquo |= aq;
  pquo = pquo & 0x1FFFF | (r << 17);
  return pquo;
}

/* DIVQ ( Dreg, Dreg ) ;
 * Based on AQ status bit, either add or subtract the divisor from
 * the dividend. Then set the AQ status bit based on the MSBs of the
 * 32-bit dividend and the 16-bit divisor. Left shift the dividend one
 * bit. Copy the logical inverse of AQ into the dividend LSB.
 */
static bu32
divq (SIM_CPU *cpu, bu32 pquo, bu16 divisor)
{
  unsigned short af = pquo >> 16;
  unsigned short r;
  int aq;

  if (ASTATREG (aq))
    r = divisor + af;
  else
    r = af - divisor;

  aq = (r ^ divisor) >> 15;  /* extract msb's and compute quotient bit */
  ASTATREG (aq) = aq;         /* update global quotient state */

  pquo <<= 1;
  pquo |= !aq;
  pquo = pquo & 0x1FFFF | (r << 17);
  return pquo;
}

/* ONES ( Dreg ) ;
 * Count the number of bits set to 1 in the 32bit value.
 */
static bu32
ones (bu32 val)
{
  bu32 i;
  bu32 ret;

  ret = 0;
  for (i = 0; i < 32; ++i)
    ret += !!(val & (1 << i));

  return ret;
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

static const struct
{
  const char *name;
  const int nbits;
  const char reloc;
  const char issigned;
  const char pcrel;
  const char scale;
  const char offset;
  const char negative;
  const char positive;
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
  { "pcrel24", 24, 1, 1, 1, 1, 0, 0, 0},
};

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

#define DREG_GRP 0
#define PREG_GRP 2
static bu32 *
get_allreg (SIM_CPU *cpu, int grp, int reg)
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
    case 0: case 1: return &DREG (reg);
    case 2: case 3: return &PREG (reg);
    case 4: return &IREG (reg & 3);
    case 5: return &MREG (reg & 3);
    case 6: return &BREG (reg & 3);
    case 7: return &LREG (reg & 3);
    default:
      switch (fullreg)
	{
	case 32: return &A0XREG;
	case 33: return &A0WREG;
	case 34: return &A1XREG;
	case 35: return &A1WREG;
	case 39: return &RETSREG;
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
#define REQUIRE_SUPERVISOR() cec_get_ivg (cpu)
static int
reg_requires_sup (SIM_CPU *cpu, bu32 *whichreg)
{
  return (whichreg == &RETIREG ||
	  whichreg == &RETXREG ||
	  whichreg == &RETNREG ||
	  whichreg == &RETEREG ||
	  whichreg == &USPREG ||
	  whichreg == &SEQSTATREG ||
	  whichreg == &SYSCFGREG);
}

static bu64
get_extended_acc0 (SIM_CPU *cpu)
{
  bu64 acc0 = A0XREG;
  /* Sign extend accumulator values before adding.  */
  if (acc0 & 0x80)
    acc0 |= -0x80;
  else
    acc0 &= 0xFF;
  acc0 <<= 32;
  acc0 |= A0WREG;
  return acc0;
}

static bu64
get_extended_acc1 (SIM_CPU *cpu)
{
  bu64 acc1 = A1XREG;
  /* Sign extend accumulator values before adding.  */
  if (acc1 & 0x80)
    acc1 |= -0x80;
  else
    acc1 &= 0xFF;
  acc1 <<= 32;
  acc1 |= A1WREG;
  return acc1;
}

/* Perform a multiplication of D registers SRC0 and SRC1, sign- or
   zero-extending the result to 64 bit.  H0 and H1 determine whether the
   high part or the low part of the source registers is used.  Store 1 in
   *PSAT if saturation occurs, 0 otherwise.  */
static bu64
decode_multfunc (SIM_CPU *cpu, int h0, int h1, int src0, int src1, int mmod,
		 int MM, int *psat)
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
      illegal_instruction (cpu);
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
extract_mult (SIM_CPU *cpu, bu64 res, int mmod, int fullword)
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
	illegal_instruction (cpu);
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
	illegal_instruction (cpu);
      }
}

static bu32
decode_macfunc (SIM_CPU *cpu, int which, int op, int h0, int h1, int src0,
		int src1, int mmod, int MM, int fullword)
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
      bu64 res = decode_multfunc (cpu, h0, h1, src0, src1, mmod,
				  MM, &sat);
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
	  unhandled_instruction (cpu, "macfunc");
	}
    }

  if (which)
    {
      STORE (A1XREG, (acc >> 32) & 0xff);
      STORE (A1WREG, acc & 0xffffffff);
      STORE (ASTATREG (av1), sat);
      STORE (ASTATREG (av1s), ASTATREG (av1s) | sat);
    }
  else
    {
      STORE (A0XREG, (acc >> 32) & 0xff);
      STORE (A0WREG, acc & 0xffffffff);
      STORE (ASTATREG (av0), sat);
      STORE (ASTATREG (av0s), ASTATREG (av0s) | sat);
    }

  return extract_mult (cpu, acc, mmod, fullword);
}

static void
decode_ProgCtrl_0 (SIM_CPU *cpu, bu16 iw0)
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
    PCREG = RETSREG;
  else if (prgfunc == 1 && poprnd == 1)
   /* RTI */
   cec_return (cpu, -1);
  else if (prgfunc == 1 && poprnd == 2)
   /* RTX */
   cec_return (cpu, IVG_EVX);
  else if (prgfunc == 1 && poprnd == 3)
   /* RTN */
   cec_return (cpu, IVG_NMI);
  else if (prgfunc == 1 && poprnd == 4)
   /* RTE */
   cec_return (cpu, IVG_EMU);
  else if (prgfunc == 2 && poprnd == 0)
    {
      /* IDLE */
      PCREG += 2;
      /* XXX: in supervisor mode, utilizes wake up sources
         in user mode, it's a NOP */
    }
  else if (prgfunc == 2 && poprnd == 3)
    /* CSYNC -- just NOP it */
    PCREG += 2;
  else if (prgfunc == 2 && poprnd == 4)
    /* SSYNC -- just NOP it */
    PCREG += 2;
  else if (prgfunc == 2 && poprnd == 5)
    {
      /* EMUEXCPT */
      PCREG += 2;
      cec_raise (cpu, IVG_EMU);
    }
  else if (prgfunc == 3)
    {
      /* CLI dregs */
      bu32 *whichreg = get_allreg (cpu, DREG_GRP, poprnd);
      *whichreg = cec_cli (cpu);
      PCREG += 2;
    }
  else if (prgfunc == 4)
    {
      /* STI dregs */
      bu32 *whichreg = get_allreg (cpu, DREG_GRP, poprnd);
      cec_sti (cpu, *whichreg);
      PCREG += 2;
      /* XXX: what about IPEND[4] ?  */
    }
  else if (prgfunc == 5)
    {
      /* JUMP (pregs) */
      PCREG = PREG (poprnd);
      BFIN_CPU_STATE.did_jump = true;
    }
  else if (prgfunc == 6)
    {
      /* CALL (pregs) */
      RETSREG = PCREG + 2;
      PCREG = PREG (poprnd);
      BFIN_CPU_STATE.did_jump = true;
    }
  else if (prgfunc == 7)
    {
      /* CALL (PC + pregs) */
      RETSREG = PCREG + 2;
      PCREG += PREG (poprnd);
      BFIN_CPU_STATE.did_jump = true;
    }
  else if (prgfunc == 8)
    {
      /* JUMP (PC + pregs) */
      PCREG += PREG (poprnd);
      BFIN_CPU_STATE.did_jump = true;
    }
  else if (prgfunc == 9)
    {
      /* RAISE */
      PCREG += 2;
      cec_raise (cpu, uimm4 (poprnd));
    }
  else if (prgfunc == 10)
    {
      /* EXCPT uimm4 */
      /* XXX: see comments in cec_exception() */
      PCREG += 2;
      cec_exception (cpu, uimm4 (poprnd));
    }
  else if (prgfunc == 11)
    unhandled_instruction (cpu, "TESTSET");
  else
    illegal_instruction (cpu);
}

static void
decode_CaCTRL_0 (SIM_CPU *cpu, bu16 iw0)
{
  /* CaCTRL
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int a = ((iw0 >> 5) & 0x1);
  int reg = ((iw0 >> 0) & 0x7);
  int op = ((iw0 >> 3) & 0x3);
  bu32 *whichreg = get_allreg (cpu, PREG_GRP, reg);

  /* No cache simulation, so these are (mostly) all NOPs.
     XXX: The hardware takes care of masking to cache lines, but need
     to check behavior of the post increment.  Should we be aligning
     the value to the cache line before adding the cache line size, or
     do we just add the cache line size ?  */
  if (a == 0 && op == 0)
    {
      /* PREFETCH [pregs] -- implicit read which may trigger CPLB miss.  */
      GET_BYTE (*whichreg);
    }
  else if (a == 0 && op == 1)
    /* FLUSHINV [pregs] */;
  else if (a == 0 && op == 2)
    /* FLUSH [pregs] */;
  else if (a == 0 && op == 3)
    /* IFLUSH [pregs] */;
  else if (a == 1 && op == 0)
    {
      /* PREFETCH [pregs++] */
      *whichreg += BFIN_L1_CACHE_BYTES;
    }
  else if (a == 1 && op == 1)
    {
      /* FLUSHINV [pregs++] */
      *whichreg += BFIN_L1_CACHE_BYTES;
    }
  else if (a == 1 && op == 2)
    {
      /* FLUSH [pregs++] */
      *whichreg += BFIN_L1_CACHE_BYTES;
    }
  else if (a == 1 && op == 3)
    {
      /* IFLUSH [pregs++] */
      *whichreg += BFIN_L1_CACHE_BYTES;
    }
  else
    illegal_instruction (cpu);

  PCREG += 2;
}

static void
decode_PushPopReg_0 (SIM_CPU *cpu, bu16 iw0)
{
  /* PushPopReg
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.W.|.grp.......|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int grp = ((iw0 >> 3) & 0x7);
  int reg = ((iw0 >> 0) & 0x7);
  int W = ((iw0 >> 6) & 0x1);
  bu32 *whichreg = get_allreg (cpu, grp, reg);

  if (W == 0)
    {
      bu32 value = GET_LONG (SPREG);
      /* allregs = [SP++] */
      if (grp == 4 && reg == 6)
	SET_ASTAT (value);
      else if (whichreg == 0)
	/* XXX: EMUDAT writes go to JTAG chain.  */
	unhandled_instruction (cpu, "EMUDAT = [SP++]");
      else
	{
	  if (reg_requires_sup (cpu, whichreg))
	    REQUIRE_SUPERVISOR ();
	  *whichreg = value;
	  /* XXX: Need to check hardware with popped RETI value
	     and bit 1 is set (when handling nested interrupts).
	     Also need to check behavior wrt SNEN in SYSCFG.  */
	  if (whichreg == &RETIREG)
	    cec_pop_reti (cpu);
	}
      SPREG += 4;
    }
  else
    {
      bu32 value;
      /* [--SP] = allregs */
      SPREG -= 4;
      if (grp == 4 && reg == 6)
	value = ASTAT;
      else if (whichreg == 0)
	/* XXX: EMUDAT reads come from JTAG chain.  */
	unhandled_instruction (cpu, "[--SP] = EMUDAT");
      else
	{
	  if (reg_requires_sup (cpu, whichreg))
	    REQUIRE_SUPERVISOR ();
	  value = *whichreg;
	  /* XXX: Need to check hardware with popped RETI value
	     and bit 1 is set (when handling nested interrupts).
	     Also need to check behavior wrt SNEN in SYSCFG.  */
	  if (whichreg == &RETIREG)
	    cec_push_reti (cpu);
	}

      PUT_LONG (SPREG, value);
    }
  PCREG += 2;
}

static void
decode_PushPopMultiple_0 (SIM_CPU *cpu, bu16 iw0)
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
  bu32 sp = SPREG;

  if ((d == 0 && p == 0)
      || (p && imm5 (pr) > 5))
    illegal_instruction (cpu);

  if (W == 1)
    {
      if (d)
	for (i = dr; i < 8; i++)
	  {
	    sp -= 4;
	    PUT_LONG (sp, DREG (i));
	  }
      if (p)
	for (i = pr; i < 6; i++)
	  {
	    sp -= 4;
	    PUT_LONG (sp, PREG (i));
	  }
    }
  else
    {
      if (p)
	for (i = 5; i >= pr; i--)
	  {
	    PREG (i) = GET_LONG (sp);
	    sp += 4;
	  }
      if (d)
	for (i = 7; i >= dr; i--)
	  {
	    DREG (i) = GET_LONG (sp);
	    sp += 4;
	  }
    }
  SPREG = sp;
  PCREG += 2;
}

static void
decode_ccMV_0 (SIM_CPU *cpu, bu16 iw0)
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
decode_CCflag_0 (SIM_CPU *cpu, bu16 iw0)
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
	unhandled_instruction (cpu, "CC = A0 == A1");
      else if (opc == 6 && I == 0 && G == 0)
	unhandled_instruction (cpu, "CC = A0 < A1");
      else if (opc == 7 && I == 0 && G == 0)
	unhandled_instruction (cpu, "CC = A0 <= A1");
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
      int az = result == 0;
      int ac0 = srcop < dstop;

      /* Pointer compares only touch CC.  */
      if (!G)
	{
	  ASTATREG (az) = az;
	  ASTATREG (an) = flgn;
	  ASTATREG (ac0) = ac0;
	}
      switch (opc)
	{
	case 0: /* == */
	  CCREG = az;
	  break;
	case 1: /* <, signed */
	  CCREG = (flgn && !overflow) || (!flgn && overflow);
	  break;
	case 2: /* <=, signed */
	  CCREG = (flgn && !overflow) || (!flgn && overflow) || az;
	  break;
	case 3: /* <, unsigned */
	  CCREG = ac0;
	  break;
	case 4: /* <=, unsigned */
	  CCREG = ac0 | az;
	  break;
	}
    }
  PCREG += 2;
}

static void
decode_CC2dreg_0 (SIM_CPU *cpu, bu16 iw0)
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
    illegal_instruction (cpu);
  PCREG += 2;
}

static void
decode_CC2stat_0 (SIM_CPU *cpu, bu16 iw0)
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
    case 0: pval = &ASTATREG (az); break;
    case 1: pval = &ASTATREG (an); break;
    case 6: pval = &ASTATREG (aq); break;
    case 12: pval = &ASTATREG (ac0); break;
    case 13: pval = &ASTATREG (ac1); break;
    case 16: pval = &ASTATREG (av0); break;
    case 17: pval = &ASTATREG (av0s); break;
    case 18: pval = &ASTATREG (av1); break;
    case 19: pval = &ASTATREG (av1s); break;
    case 24: pval = &ASTATREG (v); break;
    case 25: pval = &ASTATREG (vs); break;
    default:
      illegal_instruction (cpu);
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
decode_BRCC_0 (SIM_CPU *cpu, bu16 iw0, bu32 pc)
{
  /* BRCC
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  UNUSED int B = ((iw0 >> 10) & 0x1);
  int T = ((iw0 >> 11) & 0x1);
  int offset = ((iw0 >> 0) & 0x3ff);

  /* B is just the branch predictor hint - we can ignore it.  */

  /* IF CC JUMP pcrel10 */
  if (CCREG == T)
    {
      PCREG += pcrel10 (offset);
      BFIN_CPU_STATE.did_jump = true;
    }
  else
    PCREG += 2;
}

static void
decode_UJUMP_0 (SIM_CPU *cpu, bu16 iw0, bu32 pc)
{
  /* UJUMP
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 1 | 0 |.offset........................................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int offset = ((iw0 >> 0) & 0xfff);

  /* JUMP.S pcrel12 */
  PCREG += pcrel12 (offset);
  BFIN_CPU_STATE.did_jump = true;
}

static void
decode_REGMV_0 (SIM_CPU *cpu, bu16 iw0)
{
  /* REGMV
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 0 | 0 | 1 | 1 |.gd........|.gs........|.dst.......|.src.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int src = ((iw0 >> 0) & 0x7);
  int gs = ((iw0 >> 6) & 0x7);
  int dst = ((iw0 >> 3) & 0x7);
  int gd = ((iw0 >> 9) & 0x7);
  bu32 *srcreg = get_allreg (cpu, gs, src);
  bu32 *dstreg = get_allreg (cpu, gd, dst);
  bu32 value;

  if (gs == 4 && src == 6)
    value = ASTAT;
  else if (srcreg == 0)
    unhandled_instruction (cpu, "xxx = EMUDAT;");
  else
    {
      /* XXX: reads of CYCLES2 should come from shadow copy */
      if (reg_requires_sup (cpu, srcreg))
	REQUIRE_SUPERVISOR ();
      value = *srcreg;
    }

  if (gd == 4 && dst == 6)
    SET_ASTAT (value);
  else if (dstreg == 0)
    unhandled_instruction (cpu, "EMUDAT = xxx;");
  else
    {
      if (reg_requires_sup (cpu, dstreg))
	REQUIRE_SUPERVISOR ();
      if(dstreg == &A1XREG || dstreg == &A0XREG)
	*dstreg = value & 0xFF;
      else
	*dstreg = value;
    }

  PCREG += 2;
}

static void
decode_ALU2op_0 (SIM_CPU *cpu, bu16 iw0)
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
    DREG (dst) = ashiftrt (cpu, DREG (dst), DREG (src), 32);
  else if (opc == 1)
    /* dregs >>= dregs */
    DREG (dst) = lshiftrt (cpu, DREG (dst), DREG (src), 32);
  else if (opc == 2)
    /* dregs <<= dregs */
    DREG (dst) = lshift (cpu, DREG (dst), DREG (src), 32, 0);
  else if (opc == 3)
    /* dregs *= dregs */
    DREG (dst) *= DREG (src);
  else if (opc == 4)
    /* dregs = (dregs + dregs) << 1 */
    DREG (dst) = add_and_shift (cpu, DREG (dst), DREG (src), 1);
  else if (opc == 5)
    /* dregs = (dregs + dregs) << 2 */
    DREG (dst) = add_and_shift (cpu, DREG (dst), DREG (src), 2);
  else if (opc == 8)
    DREG (dst) = divq (cpu, DREG (dst), (bu16)DREG (src));
  else if (opc == 9)
    DREG (dst) = divs (cpu, DREG (dst), (bu16)DREG (src));
  else if (opc == 10)
    {
      /* dregs = dregs_lo (X) */
      DREG (dst) = (bs32) (bs16) DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 11)
    {
      /* dregs = dregs_lo (Z) */
      DREG (dst) = (bu32) (bu16) DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 12)
    {
      /* dregs = dregs_byte (X) */
      DREG (dst) = (bs32) (bs8) DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 13)
    {
      /* dregs = dregs_byte (Z) */
      DREG (dst) = (bu32) (bu8) DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 14)
    {
      /* dregs = - dregs */
      bu32 val = DREG (src);
      DREG (dst) = -val;
      setflags_nz (cpu, DREG (dst));
      if (val == 0x80000000)
	{
	  ASTATREG (v) = 1;
	  ASTATREG (v_copy) = 1;
	  ASTATREG (vs) = 1;
	}
      else
	{
	  ASTATREG (v) = 0;
	  ASTATREG (v_copy) = 0;
	}
      if (val == 0x0)
	{
	  ASTATREG (ac0) = 1;
	  ASTATREG (ac0_copy) = 1;
	}
      else
	{
	  ASTATREG (ac0) = 0;
	  ASTATREG (ac0_copy) = 0;
	}
      /* @@@ Documentation isn't entirely clear about av0 and av1.  */
    }
  else if (opc == 15)
    {
      /* dregs = ~ dregs */
      DREG (dst) = ~DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else
    illegal_instruction (cpu);
  PCREG += 2;
}

static void
decode_PTR2op_0 (SIM_CPU *cpu, bu16 iw0)
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
    unhandled_instruction (cpu, "pregs += pregs ( BREV )");
  else if (opc == 6)
    PREG (dst) = (PREG (dst) + PREG (src)) << 1;
  else if (opc == 7)
    PREG (dst) = (PREG (dst) + PREG (src)) << 2;
  else
    illegal_instruction (cpu);

  PCREG += 2;
}

static void
decode_LOGI2op_0 (SIM_CPU *cpu, bu16 iw0)
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
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 3)
    {
      /* BITTGL (dregs, uimm5) */
      DREG (dst) ^= 1 << uimm5 (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 4)
    {
      /* BITCLR (dregs, uimm5) */
      DREG (dst) &= ~(1 << uimm5 (src));
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 5)
    /* dregs >>>= uimm5 */
    DREG (dst) = ashiftrt (cpu, DREG (dst), uimm5 (src), 32);
  else if (opc == 6)
    /* dregs >>= uimm5 */
    DREG (dst) = lshiftrt (cpu, DREG (dst), uimm5 (src), 32);
  else if (opc == 7)
    /* dregs <<= uimm5 */
    DREG (dst) = lshift (cpu, DREG (dst), uimm5 (src), 32, 0);

  PCREG += 2;
}

static void
decode_COMP3op_0 (SIM_CPU *cpu, bu16 iw0)
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
    DREG (dst) = add32 (cpu, DREG (src0), DREG (src1), 1, 0);
  else if (opc == 1)
    /* dregs = dregs - dregs */
    DREG (dst) = sub32 (cpu, DREG (src0), DREG (src1), 1, 0);
  else if (opc == 2)
    {
      /* dregs = dregs & dregs */
      DREG (dst) = DREG (src0) & DREG (src1);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 3)
    {
      /* dregs = dregs | dregs */
      DREG (dst) = DREG (src0) | DREG (src1);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 4)
    {
      /* dregs = dregs ^ dregs */
      DREG (dst) = DREG (src0) ^ DREG (src1);
      setflags_logical (cpu, DREG (dst));
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
decode_COMPI2opD_0 (SIM_CPU *cpu, bu16 iw0)
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
    DREG (dst) = add32 (cpu, DREG (dst), imm7 (isrc), 1, 0);
  PCREG += 2;
}

static void
decode_COMPI2opP_0 (SIM_CPU *cpu, bu16 iw0)
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
decode_LDSTpmod_0 (SIM_CPU *cpu, bu16 iw0)
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
      val = GET_WORD (addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | val);
    }
  else if (aop == 2 && W == 0 && idx == ptr)
    {
      /* dregs_hi = W[pregs] */
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (val << 16));
    }
  else if (aop == 1 && W == 1 && idx == ptr)
    {
      /* W[pregs] = dregs_lo */
      addr = PREG (ptr);
      PUT_WORD (addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && idx == ptr)
    {
      /* W[pregs] = dregs_hi */
      addr = PREG (ptr);
      PUT_WORD (addr, DREG (reg) >> 16);
    }
  else if (aop == 0 && W == 0)
    {
      /* dregs = [pregs ++ pregs] */
      addr = PREG (ptr);
      val = GET_LONG (addr);
      STORE (DREG (reg), val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 1 && W == 0)
    {
      /* dregs_lo = W[pregs ++ pregs] */
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 2 && W == 0)
    {
      /* dregs_hi = W[pregs ++ pregs] */
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (val << 16));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 3 && W == 0)
    {
      /* dregs = W[pregs ++ pregs] (Z) */
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 3 && W == 1)
    {
      /* dregs = W [ pregs ++ pregs ] (X) */
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (bs32) (bs16) val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 0 && W == 1)
    {
      /* [pregs ++ pregs] = dregs */
      addr = PREG (ptr);
      PUT_LONG (addr, DREG (reg));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 1 && W == 1)
    {
      /* W[pregs ++ pregs] = dregs_lo */
      addr = PREG (ptr);
      PUT_WORD (addr, DREG (reg));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 2 && W == 1)
    {
      /* W[pregs ++ pregs] = dregs_hi */
      addr = PREG (ptr);
      PUT_WORD (addr, DREG (reg) >> 16);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else
    illegal_instruction (cpu);

  PCREG += 2;
}

static void
decode_dagMODim_0 (SIM_CPU *cpu, bu16 iw0)
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
    /*iregs += mregs (BREV) */
    dagadd_brev (cpu, i, MREG (m));
  else if (op == 0)
    /* iregs += mregs */
    dagadd (cpu, i, MREG (m));
  else if (op == 1)
    /* iregs -= mregs */
    dagsub (cpu, i, MREG (m));
  else
    illegal_instruction (cpu);
  PCREG += 2;
}

static void
decode_dagMODik_0 (SIM_CPU *cpu, bu16 iw0)
{
  /* dagMODik
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int i = ((iw0 >> 0) & 0x3);
  int op = ((iw0 >> 2) & 0x3);

  if (op == 0)
    /* iregs += 2 */
    dagadd (cpu, i, 2);
  else if (op == 1)
    /* iregs -= 2 */
    dagsub (cpu, i, 2);
  else if (op == 2)
    /* iregs += 4 */
    dagadd (cpu, i, 4);
  else if (op == 3)
    /* iregs -= 4 */
    dagsub (cpu, i, 4);
  else
    illegal_instruction (cpu);
  PCREG += 2;
}

static void
decode_dspLDST_0 (SIM_CPU *cpu, bu16 iw0)
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
      dagadd (cpu, i, 4);
      STORE (DREG (reg), GET_LONG (addr));
    }
  else if (aop == 0 && W == 0 && m == 1)
    {
      /* dregs_lo = W[iregs++] */
      addr = IREG (i);
      dagadd (cpu, i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | GET_WORD (addr));
    }
  else if (aop == 0 && W == 0 && m == 2)
    {
      /* dregs_hi = W[iregs++] */
      addr = IREG (i);
      dagadd (cpu, i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (GET_WORD (addr) << 16));
    }
  else if (aop == 1 && W == 0 && m == 0)
    {
      /* dregs = [iregs--] */
      addr = IREG (i);
      dagsub (cpu, i, 4);
      STORE (DREG (reg), GET_LONG (addr));
    }
  else if (aop == 1 && W == 0 && m == 1)
    {
      /* dregs_lo = W[iregs--] */
      addr = IREG (i);
      dagsub (cpu, i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | GET_WORD (addr));
    }
  else if (aop == 1 && W == 0 && m == 2)
    {
      /* dregs_hi = W[iregs--] */
      addr = IREG (i);
      dagsub (cpu, i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (GET_WORD (addr) << 16));
    }
  else if (aop == 2 && W == 0 && m == 0)
    {
      /* dregs = [iregs] */
      addr = IREG (i);
      STORE (DREG (reg), GET_LONG (addr));
    }
  else if (aop == 2 && W == 0 && m == 1)
    {
      /* dregs_lo = W[iregs] */
      addr = IREG (i);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | GET_WORD (addr));
    }
  else if (aop == 2 && W == 0 && m == 2)
    {
      /* dregs_hi = W[iregs] */
      addr = IREG (i);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (GET_WORD (addr) << 16));
    }
  else if (aop == 0 && W == 1 && m == 0)
    {
      /* [iregs++] = dregs */
      addr = IREG (i);
      dagadd (cpu, i, 4);
      PUT_LONG (addr, DREG (reg));
    }
  else if (aop == 0 && W == 1 && m == 1)
    {
      /* W[iregs++] = dregs_lo */
      addr = IREG (i);
      dagadd (cpu, i, 2);
      PUT_WORD (addr, DREG (reg));
    }
  else if (aop == 0 && W == 1 && m == 2)
    {
      /* W[iregs++] = dregs_hi */
      addr = IREG (i);
      dagadd (cpu, i, 2);
      PUT_WORD (addr, DREG (reg) >> 16);
    }
  else if (aop == 1 && W == 1 && m == 0)
    {
      /* [iregs--] = dregs */
      addr = IREG (i);
      dagsub (cpu, i, 4);
      PUT_LONG (addr, DREG (reg));
    }
  else if (aop == 1 && W == 1 && m == 1)
    {
      /* W[iregs--] = dregs_lo */
      addr = IREG (i);
      dagsub (cpu, i, 2);
      PUT_WORD (addr, DREG (reg));
    }
  else if (aop == 1 && W == 1 && m == 2)
    {
      /* W[iregs--] = dregs_hi */
      addr = IREG (i);
      dagsub (cpu, i, 2);
      PUT_WORD (addr, DREG (reg) >> 16);
    }
  else if (aop == 2 && W == 1 && m == 0)
    {
      /* [iregs] = dregs */
      addr = IREG (i);
      PUT_LONG (addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && m == 1)
    {
      /*  W[iregs] = dregs_lo */
      addr = IREG (i);
      PUT_WORD (addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && m == 2)
    {
      /*  W[iregs] = dregs_hi */
      addr = IREG (i);
      PUT_WORD (addr, DREG (reg) >> 16);
    }
  else if (aop == 3 && W == 0)
    {
      /* dregs = [iregs ++ mregs] */
      addr = IREG (i);
      dagadd (cpu, i, MREG (m));
      STORE (DREG (reg), GET_LONG (addr));
    }
  else if (aop == 3 && W == 1)
    {
      /* [iregs ++ mregs] = dregs */
      addr = IREG (i);
      dagadd (cpu, i, MREG (m));
      PUT_LONG (addr, DREG (reg));
    }
  else
    illegal_instruction (cpu);

  PCREG += 2;
}

static void
decode_LDST_0 (SIM_CPU *cpu, bu16 iw0)
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
    illegal_instruction (cpu);

  if (W == 0)
    {
      if (aop != 2 && sz == 0 && Z == 1
	  && ptr == reg)
	illegal_instruction (cpu);

      if (sz == 0 && Z == 0)
	/* dregs = [pregs] */
	DREG (reg) = GET_LONG (PREG (ptr));
      else if (sz == 0 && Z == 1)
	/* pregs = [pregs] */
	PREG (reg) = GET_LONG (PREG (ptr));
      else if (sz == 1 && Z == 0)
	/* dregs = W[pregs] (z) */
	DREG (reg) = GET_WORD (PREG (ptr));
      else if (sz == 1 && Z == 1)
	/* dregs = W[pregs] (X) */
	DREG (reg) = (bs32) (bs16) GET_WORD (PREG (ptr));
      else if (sz == 2 && Z == 0)
	/* dregs = B[pregs] (Z) */
	DREG (reg) = GET_BYTE (PREG (ptr));
      else if (sz == 2 && Z == 1)
	/* dregs = B[pregs] (X) */
	DREG (reg) = (bs32) (bs8) GET_BYTE (PREG (ptr));

      if (aop == 0)
	PREG (ptr) += sz == 0 ? 4 : sz == 1 ? 2 : 1;
      if (aop == 1)
	PREG (ptr) -= sz == 0 ? 4 : sz == 1 ? 2 : 1;
    }
  else
    {
      if (sz != 0 && Z == 1)
	illegal_instruction (cpu);

      if (sz == 0 && Z == 0)
	/* [pregs] = dregs */
	PUT_LONG (PREG (ptr), DREG (reg));
      else if (sz == 0 && Z == 1)
	/* [pregs] = pregs */
	PUT_LONG (PREG (ptr), PREG (reg));
      else if (sz == 1 && Z == 0)
	/* W[pregs] = dregs */
	PUT_WORD (PREG (ptr), DREG (reg));
      else if (sz == 2 && Z == 0)
	/* B[pregs] = dregs */
	PUT_BYTE (PREG (ptr), DREG (reg));

      if (aop == 0)
	PREG (ptr) += sz == 0 ? 4 : sz == 1 ? 2 : 1;
      if (aop == 1)
	PREG (ptr) -= sz == 0 ? 4 : sz == 1 ? 2 : 1;
    }

  PCREG += 2;
}

static void
decode_LDSTiiFP_0 (SIM_CPU *cpu, bu16 iw0)
{
  /* LDSTiiFP
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 0 | 1 | 1 | 1 | 0 |.W.|.offset............|.reg...........|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int reg = ((iw0 >> 0) & 0xf);
  int offset = ((iw0 >> 4) & 0x1f);
  int W = ((iw0 >> 9) & 0x1);
  bu32 ea = FPREG + negimm5s4 (offset);

  if (W == 0)
    DPREG (reg) = GET_LONG (ea);
  else
    PUT_LONG (ea, DPREG (reg));
  PCREG += 2;
}

static void
decode_LDSTii_0 (SIM_CPU *cpu, bu16 iw0)
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
    illegal_instruction (cpu);

  if (W == 0)
    {
      if (op == 0)
	/* dregs = [pregs + uimm4s4] */
	DREG (reg) = GET_LONG (ea);
      else if (op == 1)
	/* dregs = W[pregs + uimm4s2] (Z) */
	DREG (reg) = GET_WORD (ea);
      else if (op == 2)
	/* dregs = W[pregs + uimm4s2] (X) */
	DREG (reg) = (bs32) (bs16) GET_WORD (ea);
      else if (op == 3)
	/* pregs = [pregs + uimm4s4] */
	PREG (reg) = GET_LONG (ea);
    }
  else
    {
      if (op == 0)
	/* [pregs + uimm4s4] = dregs */
	PUT_LONG (ea, DREG (reg));
      else if (op == 1)
	/* W[pregs + uimm4s2] = dregs */
	PUT_WORD (ea, DREG (reg));
      else if (op == 3)
	/* [pregs + uimm4s4] = pregs */
	PUT_LONG (ea, PREG (reg));
    }
  PCREG += 2;
}

static void
decode_LoopSetup_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
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
      LTREG (c) = PCREG + pcrel4 (soffset);
      LBREG (c) = PCREG + lppcrel10 (eoffset);
    }
  else if (rop == 1)
    {
      /* LSETUP (pcrel4, lppcrel10) counters = pregs */
      LTREG (c) = PCREG + pcrel4 (soffset);
      LBREG (c) = PCREG + lppcrel10 (eoffset);
      LCREG (c) = PREG (reg);
    }
  else if (rop == 3)
    {
      /* LSETUP (pcrel4, lppcrel10) counters = pregs >> 1 */
      LTREG (c) = PCREG + pcrel4 (soffset);
      LBREG (c) = PCREG + lppcrel10 (eoffset);
      LCREG (c) = PREG (reg) >> 1;
    }
  else
    illegal_instruction (cpu);

  PCREG += 4;
}

static void
decode_LDIMMhalf_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
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

  /* XXX: writing RET{I,X,N,E}, USP, SEQSTAT, SYSCFG requires supervisor mode. */

  if (H == 0 && S == 1 && Z == 0)
    {
      bu32 *pval = get_allreg (cpu, grp, reg);
      /* regs = imm16 (x) */
      *pval = imm16 (hword);
    }
  else if (H == 0 && S == 0 && Z == 1)
    {
      bu32 *pval = get_allreg (cpu, grp, reg);
      /* regs = luimm16 (Z) */
      *pval = luimm16 (hword);
    }
  else if (H == 0 && S == 0 && Z == 0)
    {
      bu32 *pval = get_allreg (cpu, grp, reg);
      /* regs_lo = luimm16 */
      *pval &= 0xFFFF0000;
      *pval |= luimm16 (hword);
    }
  else if (H == 1 && S == 0 && Z == 0)
    {
      bu32 *pval = get_allreg (cpu, grp, reg);
      /* regs_hi = huimm16 */
      *pval &= 0xFFFF;
      *pval |= luimm16 (hword) << 16;
    }
  else
    illegal_instruction (cpu);
  PCREG += 4;
}

static void
decode_CALLa_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
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
    RETSREG = PCREG + 4;
  /* JUMP.L  pcrel24 */
  PCREG += pcrel24 (((msw) << 16) | (lsw));
}

static void
decode_LDSTidxI_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
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
    illegal_instruction (cpu);

  if (W == 0)
    {
      if (sz == 0 && Z == 0)
	/* dregs = [pregs + imm16s4] */
	DREG (reg) = GET_LONG (PREG (ptr) + imm16s4 (offset));
      else if (sz == 0 && Z == 1)
	/* pregs = [pregs + imm16s4] */
	PREG (reg) = GET_LONG (PREG (ptr) + imm16s4 (offset));
      else if (sz == 1 && Z == 0)
	/* dregs = W[pregs + imm16s2] (Z) */
	DREG (reg) = GET_WORD (PREG (ptr) + imm16s2 (offset));
      else if (sz == 1 && Z == 1)
	/* dregs = W[pregs + imm16s2] (X) */
	DREG (reg) = (bs32) (bs16) GET_WORD (PREG (ptr) + imm16s2 (offset));
      else if (sz == 2 && Z == 0)
	/* dregs = B[pregs + imm16] (Z) */
	DREG (reg) = GET_BYTE (PREG (ptr) + imm16 (offset));
      else if (sz == 2 && Z == 1)
	/* dregs = B[pregs + imm16] (X) */
	DREG (reg) = (bs32) (bs8) GET_BYTE (PREG (ptr) + imm16 (offset));
    }
  else
    {
      if (sz != 0 && Z != 0)
	illegal_instruction (cpu);

      if (sz == 0 && Z == 0)
	/* [pregs + imm16s4] = dregs */
	PUT_LONG (PREG (ptr) + imm16s4 (offset), DREG (reg));
      else if (sz == 0 && Z == 1)
	/* [pregs + imm16s4] = pregs */
	PUT_LONG (PREG (ptr) + imm16s4 (offset), PREG (reg));
      else if (sz == 1 && Z == 0)
	/* W[pregs + imm16s2] = dregs */
	PUT_WORD (PREG (ptr) + imm16s2 (offset), DREG (reg));
      else if (sz == 2 && Z == 0)
	/* B[pregs + imm16] = dregs */
	PUT_BYTE (PREG (ptr) + imm16 (offset), DREG (reg));
    }
  PCREG += 4;
}

static void
decode_linkage_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1)
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
      bu32 sp = SPREG;
      /* LINK uimm16s4 */
      sp -= 4;
      PUT_LONG (sp, RETSREG);
      sp -= 4;
      PUT_LONG (sp, FPREG);
      FPREG = sp;
      sp -= uimm16s4 (framesize);
      SPREG = sp;
    }
  else
    {
      /* Restore SP from FP.  */
      bu32 sp = FPREG;
      /* UNLINK */
      FPREG = GET_LONG (sp);
      sp += 4;
      RETSREG = GET_LONG (sp);
      sp += 4;
      SPREG = sp;
    }
  PCREG += 4;
}

static void
decode_dsp32mac_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
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
  UNUSED int M = ((iw0 >> 11) & 0x1);

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
    illegal_instruction (cpu);

  if (op1 == 3 && MM)
    illegal_instruction (cpu);

  if (((1 << mmod) & (P ? 0x313 : 0x1b57)) == 0)
    illegal_instruction (cpu);

  if (w1 == 1 || op1 != 3)
    res1 = decode_macfunc (cpu, 1, op1, h01, h11, src0, src1, mmod, MM, P);

  if (w0 == 1 || op0 != 3)
    res0 = decode_macfunc (cpu, 0, op0, h00, h10, src0, src1, mmod, 0, P);

  if (w0)
    {
      if (P)
	DREG (dst) = res0;
      else
	{
	  if (res0 & 0xffff0000)
	    unhandled_instruction (cpu, "dsp32mac0");
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
	    unhandled_instruction (cpu, "dsp32mac1");
	  DREG (dst) = (DREG (dst) & 0xFFFF) | (res1 << 16);
	}
    }

  PCREG += 4;
}

static void
decode_dsp32mult_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
{
  /* dsp32mult
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
     |.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  UNUSED int op1 = ((iw0 >> 0) & 0x3);
  int w1 = ((iw0 >> 2) & 0x1);
  int P = ((iw0 >> 3) & 0x1);
  int MM = ((iw0 >> 4) & 0x1);
  int mmod = ((iw0 >> 5) & 0xf);
  UNUSED int M = ((iw0 >> 11) & 0x1);

  int src1 = ((iw1 >> 0) & 0x7);
  int src0 = ((iw1 >> 3) & 0x7);
  int dst = ((iw1 >> 6) & 0x7);
  int h10 = ((iw1 >> 9) & 0x1);
  int h00 = ((iw1 >> 10) & 0x1);
  UNUSED int op0 = ((iw1 >> 11) & 0x3);
  int w0 = ((iw1 >> 13) & 0x1);
  int h01 = ((iw1 >> 15) & 0x1);
  int h11 = ((iw1 >> 14) & 0x1);

  bu32 res0, res1;

  if (w1 == 0 && w0 == 0)
    illegal_instruction (cpu);
  if (((1 << mmod) & (P ? 0x313 : 0x1b57)) == 0)
    illegal_instruction (cpu);

  if (w1)
    {
      int sat;
      bu64 r = decode_multfunc (cpu, h01, h11, src0, src1, mmod, MM, &sat);
      STORE (ASTATREG (av1), sat);
      STORE (ASTATREG (av1s), ASTATREG (av1s) | sat);
      res1 = extract_mult (cpu, r, mmod, P);
    }

  if (w0)
    {
      int sat;
      bu64 r = decode_multfunc (cpu, h00, h10, src0, src1, mmod, 0, &sat);
      STORE (ASTATREG (av0), sat);
      STORE (ASTATREG (av0s), ASTATREG (av0s) | sat);
      res0 = extract_mult (cpu, r, mmod, P);
    }

  if (w0)
    {
      if (P)
	DREG (dst) = res0;
      else
	{
	  if (res0 & 0xFFFF0000)
	    illegal_instruction (cpu);
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
	    illegal_instruction (cpu);
	  DREG (dst) = (DREG (dst) & 0xFFFF) | (res1 << 16);
	}
    }

  PCREG += 4;
}

static void
decode_dsp32alu_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
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
  UNUSED int M = ((iw0 >> 11) & 0x1);

  if (aop == 0 && aopcde == 9 && HL == 0 && s == 0)
    {
      /* A0.L = dregs_lo; */
      A0WREG = REG_H_L (A0WREG, DREG (src0));
    }
  else if (aop == 2 && aopcde == 9 && HL == 1 && s == 0)
    {
      /* A1.H = dregs_hi; */
      A1WREG = REG_H_L (DREG (src0), A1WREG);
    }
  else if (aop == 2 && aopcde == 9 && HL == 0 && s == 0)
    {
      /* A1.L = dregs_lo; */
      A1WREG = REG_H_L (A1WREG, DREG (src0));
    }
  else if (aop == 0 && aopcde == 9 && HL == 1 && s == 0)
    {
      /* A0.H = dregs_hi; */
      A0WREG = REG_H_L (DREG (src0), A0WREG);
    }
  else if (x == 1 && HL == 1 && aop == 3 && aopcde == 5)
    unhandled_instruction (cpu, "dregs_hi = dregs - dregs (RND20)");
  else if (x == 1 && HL == 1 && aop == 2 && aopcde == 5)
    unhandled_instruction (cpu, "dregs_hi = dregs + dregs (RND20)");
  else if (x == 0 && HL == 0 && aop == 1 && aopcde == 5)
    unhandled_instruction (cpu, "dregs_lo = dregs - dregs (RND12)");
  else if (x == 0 && HL == 0 && aop == 0 && aopcde == 5)
    unhandled_instruction (cpu, "dregs_lo = dregs + dregs (RND12)");
  else if (x == 1 && HL == 0 && aop == 3 && aopcde == 5)
    unhandled_instruction (cpu, "dregs_lo = dregs - dregs (RND20)");
  else if (x == 0 && HL == 1 && aop == 0 && aopcde == 5)
    unhandled_instruction (cpu, "dregs_hi = dregs + dregs (RND12)");
  else if (x == 1 && HL == 0 && aop == 2 && aopcde == 5)
    unhandled_instruction (cpu, "dregs_lo = dregs + dregs (RND20)");
  else if (x == 0 && HL == 1 && aop == 1 && aopcde == 5)
    unhandled_instruction (cpu, "dregs_hi = dregs - dregs (RND12)");
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
	val = add16 (cpu, s1, s2, &ASTATREG (ac0), s);
      else
	val = sub16 (cpu, s1, s2, &ASTATREG (ac0), s);
      if (HL)
	DREG (dst0) = (DREG (dst0) & 0xFFFF) | (val << 16);
      else
	DREG (dst0) = (DREG (dst0) & 0xFFFF0000) | val;
    }
  else if (aop == 0 && aopcde == 9 && s == 1)
    {
      A0WREG = DREG (src0);
      A0XREG = -(A1WREG >> 31);
    }
  else if (aop == 1 && aopcde == 9 && s == 0)
    A0XREG = (bs32)(bs8)DREG (src0);
  else if (aop == 2 && aopcde == 9 && s == 1)
    {
      A1WREG = DREG (src0);
      A1XREG = -(A1WREG >> 31);
    }
  else if (aop == 3 && aopcde == 9 && s == 0)
    A1XREG = (bs32)(bs8)DREG (src0);
  else if (aop == 3 && aopcde == 11 && (s == 0 || s == 1))
    { /* A0 -= A1 */
      bu64 acc0 = get_extended_acc0 (cpu);
      bu64 acc1 = get_extended_acc1 (cpu);

      acc0 -= acc1;
      if ((bs64)acc0 < -0x8000000000ll)
        acc0 = -0x8000000000ull;
      else if ((bs64)acc0 >= 0x7fffffffffll)
        acc0 = 0x7fffffffffull;
      STORE (A0XREG, (acc0 >> 32) & 0xff);
      STORE (A0WREG, acc0 & 0xffffffff);
      if (s == 1) {
        /* A0 -= A1 (W32) */
        if(acc0 & 0x8000000000)
          STORE (A0XREG, 0x80);
        else
          STORE (A0XREG, 0x0);
      }
    }
  else if (aop == 3 && aopcde == 22 && HL == 1)
    unhandled_instruction (cpu, "dregs = BYTEOP2M (dregs_pair, dregs_pair) (TH,R)");
  else if (aop == 3 && aopcde == 22 && HL == 0)
    unhandled_instruction (cpu, "dregs = BYTEOP2M (dregs_pair, dregs_pair) (TL,R)");
  else if (aop == 2 && aopcde == 22 && HL == 1)
    unhandled_instruction (cpu, "dregs = BYTEOP2M (dregs_pair, dregs_pair) (RNDH,R)");
  else if (aop == 2 && aopcde == 22 && HL == 0)
    unhandled_instruction (cpu, "dregs = BYTEOP2M (dregs_pair, dregs_pair) (RNDL,R)");
  else if (aop == 1 && aopcde == 22 && HL == 1)
    unhandled_instruction (cpu, "dregs = BYTEOP2P (dregs_pair, dregs_pair) (TH ,R)");
  else if (aop == 1 && aopcde == 22 && HL == 0)
    unhandled_instruction (cpu, "dregs = BYTEOP2P (dregs_pair, dregs_pair) (TL ,R)");
  else if (aop == 0 && aopcde == 22 && HL == 1)
    unhandled_instruction (cpu, "dregs = BYTEOP2P (dregs_pair, dregs_pair) (RNDH,R)");
  else if (aop == 0 && aopcde == 22 && HL == 0)
    unhandled_instruction (cpu, "dregs = BYTEOP2P (dregs_pair, dregs_pair) (RNDL,aligndir)");
  else if ((aop == 0 || aop == 1) && s == 0 && aopcde == 8)
    {
      /* A0 = 0; */
      /* A1 = 0; */
      AXREG (aop) = 0;
      AWREG (aop) = 0;
    }
  else if (aop == 2 && s == 0 && aopcde == 8)
    {
      /* A1 = A0 = 0; */
      A1XREG = A0XREG = 0;
      A1WREG = A0WREG = 0;
    }
  else if ((aop == 0 || aop == 1) && s == 1 && aopcde == 8)
    {
      AXREG (aop) = -(AWREG (aop) >> 31);
    }
  else if (aop == 2 && s == 1 && aopcde == 8)
    {
      A0XREG = -(A0WREG >> 31);
      A1XREG = -(A1WREG >> 31);
    }
  else if (aop == 3 && (s == 0 || s == 1) && aopcde == 8)
    {
      /* A0 = A1; */
      /* A1 = A0; */
      AXREG (s) = AXREG (!s);
      AWREG (s) = AWREG (!s);
    }
  else if (aop == 3 && HL == 0 && aopcde == 16)
    {
      /* A1 = ABS 1 , A0 = ABS A0 ; */
      int i;
      for (i = 0; i < 2; ++i)
	{
	  bu32 aw = AWREG (i);
	  bu8 ax = AXREG (i);
	  if (ax & 0x80)
	    aw = -aw, ax = -ax;
	  AWREG (i) = aw;
	  AXREG (i) = ax;
	}
      /* XXX: what ASTAT flags need updating ?  */
    }
  else if (aop == 0 && aopcde == 23 && HL == 1)
    unhandled_instruction (cpu, "dregs = BYTEOP3P (dregs_pair, dregs_pair) (HI,R)");
  else if ((aop == 0 || aop == 1) && (HL == 0 || HL == 1) && aopcde == 16)
    {
      /* A0 = ABS A0; */
      /* A0 = ABS A1; */
      /* A1 = ABS A0; */
      /* A1 = ABS A1; */
      bu32 aw = AWREG (aop);
      bu8 ax = AXREG (aop);
      if (ax & 0x80)
	aw = -aw, ax = -ax;
      AWREG (HL) = aw;
      AXREG (HL) = ax;

      ASTATREG (az) = AWREG (HL) == 0 && AXREG (HL) == 0;
      ASTATREG (an) = 0;
      /* XXX: need to check AV[01] and AV[01]S */
    }
  else if (HL == 0 && aop == 3 && aopcde == 12)
    {
      /* dregs_lo = dregs (RND) */
      bu32 val = (DREG(src0) & 0x7FFFFFFF);

      val += 0x8000;

      DREG(dst0) = (DREG(dst0) & 0xFFFF0000) | (val >> 16) | ((DREG(src0) & 0x80000000) >> 16);
      /* XXX : ASTAT ? */
    }
  else if (aop == 3 && HL == 0 && aopcde == 15)
    {
      /* Vector NEG.  */
      bu32 hi = (-(bs16)(DREG (src0) >> 16)) << 16;
      bu32 lo = (-(bs16)(DREG (src0) & 0xFFFF)) & 0xFFFF;

      ASTATREG (v) = 0;
      ASTATREG (v_copy) = 0;
      ASTATREG (ac0) = 0;
      ASTATREG (ac0_copy) = 0;
      ASTATREG (ac1) = 0;

      if (hi == 0x80000000)
	{
	  hi = 0x7fff0000;
	  ASTATREG (v) = 1;
	  ASTATREG (v_copy) = 1;
	  ASTATREG (vs) = 1;
	}
      else if (hi == 0)
	ASTATREG (ac1) = 1;

      if (lo == 0x8000)
	{
	  lo = 0x7fff;
	  ASTATREG (v) = 1;
	  ASTATREG (v_copy) = 1;
	  ASTATREG (vs) = 1;
	}
      else if (lo == 0)
	{
	  ASTATREG (ac0) = 1;
	  ASTATREG (ac0_copy) = 1;
	}
      DREG (dst0) = hi | lo;
      setflags_nz_2x16 (cpu, DREG (dst0));
    }
  else if (aop == 3 && HL == 0 && aopcde == 14)
    {
      /* A1 = - A1 , A0 = - A0 ; */
      AWREG (0) = -AWREG (0);
      AXREG (0) = -AXREG (0);
      AWREG (1) = -AWREG (1);
      AXREG (1) = -AXREG (1);
      /* XXX: what ASTAT flags need updating ?  */
    }
  else if (HL == 1 && aop == 3 && aopcde == 12)
    {
      /* dregs_hi = dregs (RND) */
      bu32 val = (DREG(src0) & 0x7FFFFFFF);

      val += 0x8000;

      DREG(dst0) = (DREG(dst0) & 0xFFFF) | (val & 0x7FFF0000) | (DREG(src0) & 0x80000000);
      /* XXX: what ASTAT flags need updating ?  */
    }
  else if (aop == 0 && aopcde == 23 && HL == 0)
    unhandled_instruction (cpu, "dregs = BYTEOP3P (dregs_pair, dregs_pair) (LO,R)");
  else if ((aop == 0 || aop == 1) && (HL == 0 || HL == 1) && aopcde == 14)
    {
      /* A0 = - A0; */
      /* A0 = - A1; */
      /* A1 = - A0; */
      /* A1 = - A1; */
      bu32 aw = AWREG (aop);
      bu32 ax = AXREG (aop);
      AWREG (HL) = -AWREG (aop);
      AXREG (HL) = -AXREG (aop);

      ASTATREG (az) = AWREG (HL) == 0 && AXREG (HL) == 0;
      ASTATREG (an) = AXREG (HL) >> 7;
      ASTATREG (ac0) = aw == 0 && ax == 0;
      ASTATREG (ac0_copy) = ASTATREG (ac0);
      if (HL == 0)
	{
	  ASTATREG (av0) = ax >> 7;
	  if (ASTATREG (av0))
	    ASTATREG (av0s) = 1;
	}
      else
	{
	  ASTATREG (av1) = ax >> 7;
	  if (ASTATREG (av1))
	    ASTATREG (av1s) = 1;
	}
    }
  else if (aop == 0 && aopcde == 12)
    unhandled_instruction (cpu, "dregs_hi=dregs_lo=SIGN(dregs_hi)*dregs_hi + SIGN(dregs_lo)*dregs_lo)");
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
	t0 = sub16 (cpu, s0h, s1h, &ASTATREG (ac1), s);
      else
	t0 = add16 (cpu, s0h, s1h, &ASTATREG (ac1), s);
      if (aop & 1)
	t1 = sub16 (cpu, s0l, s1l, &ASTATREG (ac0), s);
      else
	t1 = add16 (cpu, s0l, s1l, &ASTATREG (ac0), s);
      t0 &= 0xFFFF;
      t1 &= 0xFFFF;
      if (x)
	DREG (dst0) = (t1 << 16) | t0;
      else
	DREG (dst0) = (t0 << 16) | t1;
    }
  else if (aop == 1 && aopcde == 12)
    unhandled_instruction (cpu, "dregs = A1.L + A1.H , dregs = A0.L + A0.H");
  else if (HL == 0 && aopcde == 1)
    {
      if (aop == 0)
	{
	  /* dregs = dregs +|+ dregs, dregs = dregs -|- dregs (amod0) */
	  bu32 d0, d1;
	  d1 = addadd16 (cpu, DREG (src0), DREG (src1), s, 0);
	  d0 = subsub16 (cpu, DREG (src0), DREG (src1), s, x);
	  STORE (DREG (dst0), d0);
	  STORE (DREG (dst1), d1);
	}
      else
	unhandled_instruction (cpu,
	  "dregs = dregs +|+ dregs, dregs = dregs -|- dregs (amod0, amod2)");
    }
  else if (aop == 1 && HL == 0 && aopcde == 11)
    unhandled_instruction (cpu, "dregs_lo = (A0 += A1)");
  else if (aop == 1 && HL == 1 && aopcde == 11)
    unhandled_instruction (cpu, "dregs_hi = (A0 += A1)");
  else if ((aop == 0 || aop == 2) && aopcde == 11)
    {
      /* A0 += A1 */
      bu64 acc0 = get_extended_acc0 (cpu);
      bu64 acc1 = get_extended_acc1 (cpu);

      acc0 += acc1;
      if ((bs64)acc0 < -0x8000000000ll)
	acc0 = -0x8000000000ull;
      else if ((bs64)acc0 >= 0x7fffffffffll)
	acc0 = 0x7fffffffffull;
      STORE (A0XREG, (acc0 >> 32) & 0xff);
      STORE (A0WREG, acc0 & 0xffffffff);
      if (aop == 2 && s == 1)
      { /* A0 += A1 (W32) */
	if(acc0 & 0x8000000000)
	  STORE (A0XREG, 0x80);
	else
	  STORE (A0XREG, 0x0);
      }
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
      DREG (dst0) |= A0XREG & 0xFFFF;
    }
  else if (aop == 1 && aopcde == 10)
    {
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= A1XREG & 0xFFFF;
    }
  else if (aop == 0 && aopcde == 4)
    DREG (dst0) = add32 (cpu, DREG (src0), DREG (src1), 1, s);
  else if (aop == 1 && aopcde == 4)
    DREG (dst0) = sub32 (cpu, DREG (src0), DREG (src1), 1, s);
  else if (aop == 2 && aopcde == 4)
    unhandled_instruction (cpu, "dregs = dregs + dregs , dregs = dregs - dregs amod1");
  else if (aop == 0 && aopcde == 17)
    unhandled_instruction (cpu, "dregs = A1 + A0, dregs = A1 - A0 amod1");
  else if (aop == 1 && aopcde == 17)
    unhandled_instruction (cpu, "dregs = A0 + A1, dregs = A0 - A1 amod1");
  else if (aop == 0 && aopcde == 18)
    unhandled_instruction (cpu, "SAA (dregs_pair, dregs_pair) aligndir");
  else if (aop == 3 && aopcde == 18)
    unhandled_instruction (cpu, "DISALGNEXCPT");
  else if (aop == 0 && aopcde == 20)
    unhandled_instruction (cpu, "dregs = BYTEOP1P (dregs_pair, dregs_pair) aligndir");
  else if (aop == 1 && aopcde == 20)
    unhandled_instruction (cpu, "dregs = BYTEOP1P (dregs_pair, dregs_pair) (T, R)");
  else if (aop == 0 && aopcde == 21)
    unhandled_instruction (cpu, "(dregs, dregs) = BYTEOP16P (dregs_pair, dregs_pair) aligndir");
  else if (aop == 1 && aopcde == 21)
    unhandled_instruction (cpu, "(dregs, dregs) = BYTEOP16M (dregs_pair, dregs_pair) aligndir");
  else if (aop == 1 && aopcde == 7)
    /* dregs = MIN (dregs, dregs) */
    DREG (dst0) = min32 (cpu, DREG (src0), DREG (src1));
  else if (aop == 0 && aopcde == 7)
    /* dregs = MAX (dregs, dregs) */
    DREG (dst0) = max32 (cpu, DREG (src0), DREG (src1));
  else if (aop == 2 && aopcde == 7)
    {
      bu32 val = DREG (src0);
      /* dregs = ABS dregs */
      if (val >> 31)
	val = -val;
      if (val == 0x80000000)
	{
	  val = 0x7fffffff;
	  ASTATREG (v) = 1;
	  ASTATREG (vs) = 1;
	  ASTATREG (v_copy) = 1;
	}
      else
	{
	  ASTATREG (v) = 0;
	  ASTATREG (v_copy) = 0;
	}
      setflags_nz (cpu, val);
      DREG (dst0) = val;
    }
  else if (aop == 3 && aopcde == 7)
    {
      bu32 val = DREG (src0);
      /* dregs = - dregs (opt_sat) */
      ASTATREG (v) = val == 0x8000;
      if (ASTATREG (v))
	ASTATREG (vs) = 1;
      if (val == 0x80000000)
	val = 0x7fffffff;
      else
	val = -val;
      setflags_logical (cpu, val);
      DREG (dst0) = val;
    }
  else if (aop == 2 && aopcde == 6)
    {
      /* Vector ABS.  */
      bu32 in = DREG (src0);
      bu32 hi = (in & 0x80000000 ? -(bs16)(in >> 16) : in >> 16) << 16;
      bu32 lo = (in & 0x8000 ? -(bs16)(in & 0xFFFF) : in) & 0xFFFF;

      ASTATREG (v) = 0;
      ASTATREG (v_copy) = 0;
      if (hi == 0x80000000)
	{
	  hi = 0x7fff0000;
	  ASTATREG (v) = 1;
	  ASTATREG (v_copy) = 1;
	  ASTATREG (vs) = 1;
	}
      if (lo == 0x8000)
	{
	  lo = 0x7fff;
	  ASTATREG (v) = 1;
	  ASTATREG (v_copy) = 1;
	  ASTATREG (vs) = 1;
	}
      DREG (dst0) = hi | lo;
      setflags_nz_2x16 (cpu, DREG (dst0));
    }
  else if (aop == 1 && aopcde == 6)
    DREG (dst0) = min2x16 (cpu, DREG (src0), DREG (src1));
  else if (aop == 0 && aopcde == 6)
    DREG (dst0) = max2x16 (cpu, DREG (src0), DREG (src1));
  else if (HL == 1 && aopcde == 1)
    unhandled_instruction (cpu, "dregs = dregs +|- dregs, dregs = dregs -|+ dregs (amod0, amod2)");
  else if (aop == 0 && aopcde == 24)
    unhandled_instruction (cpu, "dregs = BYTEPACK (dregs, dregs)");
  else if (aop == 1 && aopcde == 24)
    unhandled_instruction (cpu, "(dregs, dregs) = BYTEUNPACK dregs_pair aligndir");
  else if (aopcde == 13)
    unhandled_instruction (cpu, "(dregs, dregs) = SEARCH dregs (searchmod)");
  else
    illegal_instruction (cpu);
  PCREG += 4;
}

static void
decode_dsp32shift_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
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
  UNUSED int M = ((iw0 >> 11) & 0x1);
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);

  if (HLs == 0 && sop == 0 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_lo = ASHIFT dregs_lo BY dregs_lo");
  else if (HLs == 1 && sop == 0 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_lo = ASHIFT dregs_hi BY dregs_lo");
  else if (HLs == 2 && sop == 0 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_hi = ASHIFT dregs_lo BY dregs_lo");
  else if (HLs == 3 && sop == 0 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_hi = ASHIFT dregs_hi BY dregs_lo");
  else if (HLs == 0 && sop == 1 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_lo = ASHIFT dregs_lo BY dregs_lo (S)");
  else if (HLs == 1 && sop == 1 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_lo = ASHIFT dregs_hi BY dregs_lo (S)");
  else if (HLs == 2 && sop == 1 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_hi = ASHIFT dregs_lo BY dregs_lo (S)");
  else if (HLs == 3 && sop == 1 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_hi = ASHIFT dregs_hi BY dregs_lo (S)");
  else if (HLs == 0 && sop == 2 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_lo = LSHIFT dregs_lo BY dregs_lo");
  else if (HLs == 1 && sop == 2 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_lo = LSHIFT dregs_hi BY dregs_lo");
  else if (HLs == 2 && sop == 2 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_hi = LSHIFT dregs_lo BY dregs_lo");
  else if (HLs == 3 && sop == 2 && sopcde == 0)
    unhandled_instruction (cpu, "dregs_hi = LSHIFT dregs_hi BY dregs_lo");
  else if (sop == 2 && sopcde == 3 && HLs == 1)
    unhandled_instruction (cpu, "A1 = ROT A1 BY dregs_lo");
  else if (sop == 0 && sopcde == 3 && HLs == 0)
    unhandled_instruction (cpu, "A0 = ASHIFT A0 BY dregs_lo");
  else if (sop == 0 && sopcde == 3 && HLs == 1)
    unhandled_instruction (cpu, "A1 = ASHIFT A1 BY dregs_lo");
  else if (sop == 1 && sopcde == 3 && HLs == 0)
    unhandled_instruction (cpu, "A0 = LSHIFT A0 BY dregs_lo");
  else if (sop == 1 && sopcde == 3 && HLs == 1)
    unhandled_instruction (cpu, "A1 = LSHIFT A1 BY dregs_lo");
  else if (sop == 2 && sopcde == 3 && HLs == 0)
    unhandled_instruction (cpu, "A0 = ROT A0 BY dregs_lo");
  else if (sop == 1 && sopcde == 1)
    unhandled_instruction (cpu, "dregs = ASHIFT dregs BY dregs_lo (V,S)");
  else if (sop == 0 && sopcde == 1)
    unhandled_instruction (cpu, "dregs = ASHIFT dregs BY dregs_lo (V)");
  else if ((sop == 0 || sop == 1 || sop == 2) && sopcde == 2)
    {
      /* dregs = [LA]SHIFT dregs BY dregs_lo (opt_S) */
      bu32 v = DREG (src1);
      /* LSHIFT uses sign extended low 6 bits of dregs_lo.  */
      bs32 shft = (bs8)(DREG (src0) << 2) >> 2;
      if (shft < 0)
	{
	  if (sop == 2)
	    DREG (dst0) = lshiftrt (cpu, v, -shft, 32);
	  else
	    DREG (dst0) = ashiftrt (cpu, v, -shft, 32);
	}
      else
	{
	  DREG (dst0) = lshift (cpu, v, shft, 32, sop == 1);
	}
    }
  else if (sop == 3 && sopcde == 2)
    {
     /*dregs = ROT dregs BY dregs_lo */
      int t = imm6 (DREG(src0) & 0xFFFF);

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
  else if (sop == 2 && sopcde == 1)
    unhandled_instruction (cpu, "dregs = LSHIFT dregs BY dregs_lo (V)");
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
  else if ((sop == 0 || sop == 1) && sopcde == 6)
    {
      bu64 acc = AXREG (sop);
      acc <<= 32;
      acc |= AWREG (sop);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= (signbits (acc, 40) & 0xFFFF);
    }
  else if (sop == 3 && sopcde == 6)
    {
      /* dregs_lo = ONES dreg; */
      bu32 v = ones (DREG (src1));
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= v;
    }
  else if (sop == 0 && sopcde == 7)
    unhandled_instruction (cpu, "dregs_lo = EXPADJ (dregs, dregs_lo)");
  else if (sop == 1 && sopcde == 7)
    unhandled_instruction (cpu, "dregs_lo = EXPADJ (dregs, dregs_lo) (V)");
  else if (sop == 2 && sopcde == 7)
    unhandled_instruction (cpu, "dregs_lo = EXPADJ (dregs_lo, dregs_lo)");
  else if (sop == 3 && sopcde == 7)
    unhandled_instruction (cpu, "dregs_lo = EXPADJ (dregs_hi, dregs_lo)");
  else if (sop == 0 && sopcde == 8)
    unhandled_instruction (cpu, "BITMUX (dregs, dregs, A0) (ASR)");
  else if (sop == 1 && sopcde == 8)
    unhandled_instruction (cpu, "BITMUX (dregs, dregs, A0) (ASL)");
  else if (sop == 0 && sopcde == 9)
    unhandled_instruction (cpu, "dregs_lo = VIT_MAX (dregs) (ASL)");
  else if (sop == 1 && sopcde == 9)
    unhandled_instruction (cpu, "dregs_lo = VIT_MAX (dregs) (ASR)");
  else if (sop == 2 && sopcde == 9)
    unhandled_instruction (cpu, "dregs = VIT_MAX (dregs, dregs) (ASL)");
  else if (sop == 3 && sopcde == 9)
    unhandled_instruction (cpu, "dregs = VIT_MAX (dregs, dregs) (ASR)");
  else if (sop == 0 && sopcde == 10)
    {
      /* dregs = EXTRACT (dregs, dregs_lo) (Z) */
      bu32 v = DREG (src0);
      bu32 x = DREG (src1);
      bu32 mask = (1 << (v & 0x1f)) - 1;
      x >>= ((v >> 8) & 0x1f);
      DREG (dst0) = x & mask;
      setflags_logical (cpu, DREG (dst0));
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
      setflags_logical (cpu, DREG (dst0));
    }
  else if ((sop == 2 || sop == 3) && sopcde == 10)
    {
      /* dregs = DEPOSIT (dregs, dregs) */
      /* dregs = DEPOSIT (dregs, dregs) (X) */
      /* The first dregs is the "background" while the second dregs is the
       * "foreground".  The fg reg is used to overlay the bg reg and is:
       * | nnnn nnnn | nnnn nnnn | xxxp pppp | xxxL LLLL |
       *  n = the fg bit field
       *  p = bit position in bg reg to start LSB of fg field
       *  L = number of fg bits to extract
       * Using (X) sign-extends the fg bit field.
       */
      bu32 fg = DREG (src0);
      bu32 bg = DREG (src1);
      bu32 len = fg & 0x1f;
      bu32 mask = (1 << len) - 1;
      bu32 fgnd = (fg >> 16) & mask;
      int shft = ((fg >> 8) & 0x1f);
      if (len > 16)
	illegal_instruction (cpu);
      if (sop == 3)
	{
	  /* Sign extend the fg bit field.  */
	  mask = -1;
	  fgnd = ((bs32)(bs16)(fgnd << (16 - len))) >> (16 - len);
	}
      fgnd <<= shft;
      mask <<= shft;
      bg &= ~mask;
      DREG (dst0) = bg | fgnd;
      setflags_logical (cpu, DREG (dst0));
    }
  else if (sop == 0 && sopcde == 11)
    unhandled_instruction (cpu, "dregs_lo = CC = BXORSHIFT (A0, dregs)");
  else if (sop == 1 && sopcde == 11)
    unhandled_instruction (cpu, "dregs_lo = CC = BXOR (A0, dregs)");
  else if (sop == 0 && sopcde == 12)
    unhandled_instruction (cpu, "A0 = BXORSHIFT (A0, A1, CC)");
  else if (sop == 1 && sopcde == 12)
    unhandled_instruction (cpu, "dregs_lo = CC = BXOR (A0, A1, CC)");
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
    illegal_instruction (cpu);
  PCREG += 4;
}

static void
decode_dsp32shiftimm_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1, bu32 pc)
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
  UNUSED int M = ((iw0 >> 11) & 0x1);
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);
  int bit8 = immag >> 5;

  if (sopcde == 0)
    {
      bu16 in = DREG (src1) >> ((HLs & 1) ? 16 : 0);
      bu16 result;
      bu32 v;
      if (sop == 0 && bit8)
	result = ashiftrt (cpu, in, newimmag, 16);
      else if (sop == 1 && bit8)
	result = lshift (cpu, in, immag, 16, 1);
      else if (sop == 2 && bit8)
	result = lshiftrt (cpu, in, newimmag, 16);
      else if (sop == 2)
	result = lshift (cpu, in, immag, 16, 0);
      else
	unhandled_instruction (cpu, "dsp32shiftimm_0");
      v = DREG (dst0);
      if (HLs & 2)
	STORE (DREG (dst0), (v & 0xFFFF) | (result << 16));
      else
	STORE (DREG (dst0), (v & 0xFFFF0000) | result);
    }
  else if (sop == 2 && sopcde == 3 && HLs == 1)
    unhandled_instruction (cpu, "A1 = ROT A1 BY imm6");
  else if (sop == 0 && sopcde == 3 && bit8 == 1)
    {
      /* An = An >>> uimm5 */
      /* Arithmetic shift, so shift in sign bit copies.  */
      bu64 acc = HLs ? get_extended_acc1 (cpu) : get_extended_acc0 (cpu);
      acc >>= uimm5 (newimmag);
      /* Sign extend again.  */
      if (acc & (1ULL << 39))
	acc |= -(1ULL << 39);
      else
	acc &= ~(-(1ULL << 39));
      if (HLs)
	{
	  STORE (A1XREG, (acc >> 32) & 0xFF);
	  STORE (A1WREG, acc & 0xFFFFFFFF);
	}
      else
	{
	  STORE (A0XREG, (acc >> 32) & 0xFF);
	  STORE (A0WREG, acc & 0xFFFFFFFF);
	}
    }
  else if ((sop == 0 && sopcde == 3 && bit8 == 0)
	   || (sop == 1 && sopcde == 3))
    {
      /* An = An << uimm5 */
      /* An = An >> uimm5 */
      bu64 acc = HLs ? A1XREG : A0XREG;
      /* Logical shift, so shift in zeroes.  */
      acc &= 0xFF;
      acc <<= 32;
      acc |= HLs ? A1WREG : A0WREG;

      if (sop == 0)
	acc <<= uimm5 (immag);
      else
	acc >>= uimm5 (newimmag);
      if (HLs)
	{
	  A1XREG = (acc >> 32) & 0xFF;
	  A1WREG = acc;
	}
      else
	{
	  A0XREG = (acc >> 32) & 0xFF;
	  A0WREG = acc;
	}
    }
  else if (sop == 2 && sopcde == 3 && HLs == 0)
    unhandled_instruction (cpu, "A0 = ROT A0 BY imm6");
  else if (sop == 1 && sopcde == 1)
    unhandled_instruction (cpu, "dregs = dregs >>> uimm5 (V,S)");
  else if (sop == 2 && sopcde == 1)
    unhandled_instruction (cpu, "dregs = dregs >> uimm5 (V)");
  else if (sop == 0 && sopcde == 1)
    unhandled_instruction (cpu, "dregs = dregs << imm5 (V)");
  else if (sop == 1 && sopcde == 2)
    {
      int count = imm6 (immag);
      /* dregs = dregs << imm6 (S) */
      if (count >= 0)
        STORE (DREG (dst0), lshift (cpu, DREG (src1), count, 32, 1));
      else
        unhandled_instruction (cpu, "dsp32shiftimm_0_1");
    }
  else if (sop == 2 && sopcde == 2)
    {
      int count = imm6 (newimmag);
      /* dregs = dregs >> imm6 */
      if (count < 0)
	STORE (DREG (dst0), lshift (cpu, DREG (src1), -count, 32, 0));
      else
	STORE (DREG (dst0), lshiftrt (cpu, DREG (src1), count, 32));
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
	STORE (DREG (dst0), lshift (cpu, DREG (src1), -count, 32, 0));
      else
	STORE (DREG (dst0), ashiftrt (cpu, DREG (src1), count, 32));
    }
  else
    illegal_instruction (cpu);

  PCREG += 4;
}

static void
decode_psedoDEBUG_0 (SIM_CPU *cpu, bu16 iw0)
{
  /* psedoDEBUG
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  int grp = ((iw0 >> 3) & 0x7);
  int fn = ((iw0 >> 6) & 0x3);
  int reg = ((iw0 >> 0) & 0x7);

  if (reg == 0 && fn == 3)
    unhandled_instruction (cpu, "DBG A0");
  else if (reg == 1 && fn == 3)
    unhandled_instruction (cpu, "DBG A1");
  else if (reg == 3 && fn == 3)
    unhandled_instruction (cpu, "ABORT");
  else if (reg == 4 && fn == 3)
    {
      /* HLT */
      cec_exception (cpu, VEC_SIM_HLT);
      DREG (0) = 0;
    }
  else if (reg == 5 && fn == 3)
    unhandled_instruction (cpu, "DBGHALT");
  else if (reg == 6 && fn == 3)
    unhandled_instruction (cpu, "DBGCMPLX (dregs)");
  else if (reg == 7 && fn == 3)
    unhandled_instruction (cpu, "DBG");
  else if (grp == 0 && fn == 2)
    unhandled_instruction (cpu, "OUTC dregs");
  else if (fn == 0)
    unhandled_instruction (cpu, "DBG allregs");
  else if (fn == 1)
    unhandled_instruction (cpu, "PRNT allregs");
  else
    illegal_instruction (cpu);

  PCREG += 2;
}

static void
decode_psedoOChar_0 (SIM_CPU *cpu, bu16 iw0)
{
  /* psedoOChar
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
     | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 |.ch............................|
     +---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+  */
  UNUSED int ch = ((iw0 >> 0) & 0xff);

  unhandled_instruction (cpu, "OUTC uimm8");
  PCREG += 2;
}

static void
decode_psedodbg_assert_0 (SIM_CPU *cpu, bu16 iw0, bu16 iw1)
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
  bu32 *reg = get_allreg (cpu, grp, regtest);

  char *reg_names[] =
{
  "R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7",
  "P0", "P1", "P2", "P3", "P4", "P5", "SP", "FP",
};


  if (dbgop == 0 || dbgop == 2)
    {
      /* DBGA ( regs_lo , uimm16 ) */
      /* DBGAL ( regs , uimm16 ) */
      if ((*reg & 0xffff) != expected)
	{
	  fprintf (stderr, "FAIL at 0x%x: DBGA (%s.L, 0x%04x), actual value 0x%x\n",
		  PCREG, reg_names[regtest + (grp * 8)], expected, *reg & 0xffff);
	  cec_exception (cpu, VEC_ILGAL_I);
	  DREG (0) = 1;
	}
    }
  else if (dbgop == 1 || dbgop == 3)
    {
      /* DBGA ( regs_hi , uimm16 ) */
      /* DBGAH ( regs , uimm16 ) */
      if ((*reg >> 16) != expected)
	{
	  fprintf (stderr, "FAIL at 0x%x: DBGA (%s.H, 0x%04x), actual value 0x%x\n",
		  PCREG, reg_names[regtest + (grp * 8)], expected, *reg >> 16);
	  cec_exception (cpu, VEC_ILGAL_I);
	  DREG (0) = 1;
	}
    }
  else
    illegal_instruction (cpu);
  PCREG += 4;
}

static void
_interp_insn_bfin (SIM_CPU *cpu, bu32 pc)
{
  bu16 iw0 = GET_WORD (pc);
  bu16 iw1 = GET_WORD (pc + 2);

  if ((iw0 & 0xf7ff) == 0xc003 && iw1 == 0x1800)
    {
      /* MNOP.  */
      PCREG += 4;
      return;
    }
  if ((iw0 & 0xFF00) == 0x0000)
    decode_ProgCtrl_0 (cpu, iw0);
  else if ((iw0 & 0xFFC0) == 0x0240)
    decode_CaCTRL_0 (cpu, iw0);
  else if ((iw0 & 0xFF80) == 0x0100)
    decode_PushPopReg_0 (cpu, iw0);
  else if ((iw0 & 0xFE00) == 0x0400)
    decode_PushPopMultiple_0 (cpu, iw0);
  else if ((iw0 & 0xFE00) == 0x0600)
    decode_ccMV_0 (cpu, iw0);
  else if ((iw0 & 0xF800) == 0x0800)
    decode_CCflag_0 (cpu, iw0);
  else if ((iw0 & 0xFFE0) == 0x0200)
    decode_CC2dreg_0 (cpu, iw0);
  else if ((iw0 & 0xFF00) == 0x0300)
    decode_CC2stat_0 (cpu, iw0);
  else if ((iw0 & 0xF000) == 0x1000)
    decode_BRCC_0 (cpu, iw0, pc);
  else if ((iw0 & 0xF000) == 0x2000)
    decode_UJUMP_0 (cpu, iw0, pc);
  else if ((iw0 & 0xF000) == 0x3000)
    decode_REGMV_0 (cpu, iw0);
  else if ((iw0 & 0xFC00) == 0x4000)
    decode_ALU2op_0 (cpu, iw0);
  else if ((iw0 & 0xFE00) == 0x4400)
    decode_PTR2op_0 (cpu, iw0);
  else if ((iw0 & 0xF800) == 0x4800)
    decode_LOGI2op_0 (cpu, iw0);
  else if ((iw0 & 0xF000) == 0x5000)
    decode_COMP3op_0 (cpu, iw0);
  else if ((iw0 & 0xF800) == 0x6000)
    decode_COMPI2opD_0 (cpu, iw0);
  else if ((iw0 & 0xF800) == 0x6800)
    decode_COMPI2opP_0 (cpu, iw0);
  else if ((iw0 & 0xF000) == 0x8000)
    decode_LDSTpmod_0 (cpu, iw0);
  else if ((iw0 & 0xFF60) == 0x9E60)
    decode_dagMODim_0 (cpu, iw0);
  else if ((iw0 & 0xFFF0) == 0x9F60)
    decode_dagMODik_0 (cpu, iw0);
  else if ((iw0 & 0xFC00) == 0x9C00)
    decode_dspLDST_0 (cpu, iw0);
  else if ((iw0 & 0xF000) == 0x9000)
    decode_LDST_0 (cpu, iw0);
  else if ((iw0 & 0xFC00) == 0xB800)
    decode_LDSTiiFP_0 (cpu, iw0);
  else if ((iw0 & 0xE000) == 0xA000)
    decode_LDSTii_0 (cpu, iw0);
  else if (((iw0 & 0xFF80) == 0xE080) && ((iw1 & 0x0C00) == 0x0000))
    decode_LoopSetup_0 (cpu, iw0, iw1, pc);
  else if (((iw0 & 0xFF00) == 0xE100) && ((iw1 & 0x0000) == 0x0000))
    decode_LDIMMhalf_0 (cpu, iw0, iw1, pc);
  else if (((iw0 & 0xFE00) == 0xE200) && ((iw1 & 0x0000) == 0x0000))
    decode_CALLa_0 (cpu, iw0, iw1, pc);
  else if (((iw0 & 0xFC00) == 0xE400) && ((iw1 & 0x0000) == 0x0000))
    decode_LDSTidxI_0 (cpu, iw0, iw1, pc);
  else if (((iw0 & 0xFFFE) == 0xE800) && ((iw1 & 0x0000) == 0x0000))
    decode_linkage_0 (cpu, iw0, iw1);
  else if (((iw0 & 0xF600) == 0xC000) && ((iw1 & 0x0000) == 0x0000))
    decode_dsp32mac_0 (cpu, iw0, iw1, pc);
  else if (((iw0 & 0xF600) == 0xC200) && ((iw1 & 0x0000) == 0x0000))
    decode_dsp32mult_0 (cpu, iw0, iw1, pc);
  else if (((iw0 & 0xF7C0) == 0xC400) && ((iw1 & 0x0000) == 0x0000))
    decode_dsp32alu_0 (cpu, iw0, iw1, pc);
  else if (((iw0 & 0xF7E0) == 0xC600) && ((iw1 & 0x01C0) == 0x0000))
    decode_dsp32shift_0 (cpu, iw0, iw1, pc);
  else if (((iw0 & 0xF7E0) == 0xC680) && ((iw1 & 0x0000) == 0x0000))
    decode_dsp32shiftimm_0 (cpu, iw0, iw1, pc);
  else if ((iw0 & 0xFF00) == 0xF800)
    decode_psedoDEBUG_0 (cpu, iw0);
  else if ((iw0 & 0xFF00) == 0xF900)
    decode_psedoOChar_0 (cpu, iw0);
  else if (((iw0 & 0xFF00) == 0xF000) && ((iw1 & 0x0000) == 0x0000))
    decode_psedodbg_assert_0 (cpu, iw0, iw1);
  else
    illegal_instruction (cpu);
}

void
interp_insn_bfin (SIM_CPU *cpu, bu32 pc)
{
  int i;
  bu16 iw0 = GET_WORD (pc);

  int is_multiinsn = ((iw0 & 0xc000) == 0xc000 && (iw0 & BIT_MULTI_INS)
		      && ((iw0 & 0xe800) != 0xe800 /* not linkage */));

  BFIN_CPU_STATE.n_stores = 0;

  _interp_insn_bfin (cpu, pc);

  /* Proper display of multiple issue instructions.  */
  if (is_multiinsn)
    {
      _interp_insn_bfin (cpu, pc + 4);
      _interp_insn_bfin (cpu, pc + 6);
    }
  for (i = 0; i < BFIN_CPU_STATE.n_stores; i++)
    *BFIN_CPU_STATE.stores[i].addr = BFIN_CPU_STATE.stores[i].val;
}
