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

static void
illegal_instruction (SIM_CPU *cpu)
{
  cec_exception (cpu, VEC_UNDEF_I);
}

static __attribute__ ((noreturn)) void
unhandled_instruction (SIM_CPU *cpu, char *insn)
{
  bu16 iw0, iw1;
  bu32 iw2;

  TRACE_EVENTS (cpu, "unhandled instruction");

  iw0 = IFETCH (PCREG);
  iw1 = IFETCH (PCREG + 2);
  iw2 = ((bu32)iw0 << 16) | iw1;

  fprintf (stderr, "Unhandled instruction at 0x%08x (%s opcode 0x", PCREG, insn);
  if ((iw0 & 0xc000) == 0xc000)
    fprintf (stderr, "%08x", iw2);
  else
     fprintf (stderr, "%04x", iw0);

  fprintf (stderr, ") ... aborting\n");

  while (1)
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
  ASTATREG (ac0) = ASTATREG (ac0_copy) = 0;
  ASTATREG (v) = ASTATREG (v_copy) = 0;
}

static bu32
add_brev (SIM_CPU *cpu, bu32 addend1, bu32 addend2)
{
  bu32 mask, b, r;
  int i, cy;

  mask = 0x80000000;
  r = 0;
  cy = 0;

  for (i = 31; i >= 0; --i)
    {
      b = ((addend1 & mask) >> i) + ((addend2 & mask) >> i);
      b += cy;
      cy = b >> 1;
      b &= 1;
      r |= b << i;
      mask >>= 1;
    }

  return r;
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
  ASTATREG (v) = ASTATREG (v_copy) = 0;
  return val;
}

static bu64
lshiftrt (SIM_CPU *cpu, bu64 val, int cnt, int size)
{
  int real_cnt = cnt > size ? size : cnt;
  if (real_cnt > 16)
    val >>= 16, real_cnt -= 16;
  val >>= real_cnt;
  switch (size)
    {
    case 16:
      val &= 0xFFFF;
      break;
    case 32:
      val &= 0xFFFFFFFF;
      break;
    case 40:
      val &= 0xFFFFFFFFFF;
      break;
    default:
      illegal_instruction (cpu);
      break;
    }
  ASTATREG (an) = val >> (size - 1);
  ASTATREG (az) = val == 0;
  ASTATREG (v) = ASTATREG (v_copy) = 0;
  return val;
}

static bu64
lshift (SIM_CPU *cpu, bu64 val, int cnt, int size, bool saturate)
{
  int i, j, real_cnt = cnt > size ? size : cnt;
  bu64 sgn = ~((val >> (size - 1)) - 1);
  int mask_cnt = size - 1; // - real_cnt
  bu64 masked, new_val = val, tmp;
  bu64 mask = ~0;

  mask <<= mask_cnt;
  sgn <<= mask_cnt;
  masked = val & mask;

  if (real_cnt > 16)
    new_val <<= 16, real_cnt -= 16;

  new_val <<= real_cnt;

  masked = new_val & mask;

  /* If an operation would otherwise cause a positive value to overflow
   * and become negative, instead, saturation limits the result to the
   * maximum positive value for the size register being used.
   *
   * Conversely, if an operation would otherwise cause a negative value
   * to overflow and become positive, saturation limits the result to the
   * maximum negative value for the register size.
   */
  tmp = (new_val & mask);
  tmp >>= mask_cnt;

  j = !(tmp & 0x1);
  for (i = 0; i <= real_cnt; i++)
    {
      if (tmp & 0x1 && !(tmp & 0x2))
	j++;
      tmp >>= 1;
    }
  saturate &= (j > 1) ||
	(!sgn && (new_val & (1 << mask_cnt))) ||
	(sgn && !(new_val & (1 << mask_cnt)));

  switch (size)
    {
    case 16:
      if (saturate && (new_val & mask))
	new_val = sgn == 0 ? 0x7fff : 0x8000;
      new_val &= 0xFFFF;
      break;
    case 32:
      new_val &= 0xFFFFFFFF;
      masked &= 0xFFFFFFFF;
      if (saturate && ((sgn != masked) || (!sgn && new_val == 0)))
	new_val = sgn == 0 ? 0x7fffffff : 0x80000000;
      break;
    case 40:
      new_val &= 0xFFFFFFFFFF;
      masked &= 0xFFFFFFFFFF;
      break;
    default:
      illegal_instruction (cpu);
      break;
    }

  ASTATREG (an) = new_val >> (size - 1);
  ASTATREG (az) = new_val == 0;
  ASTATREG (v) = ASTATREG (v_copy) = 0;
  return new_val;
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
  ASTATREG (v) = ASTATREG (v_copy) = overflow;
  ASTATREG (v_internal) |= overflow;
  ASTATREG (az) = v == 0;
  if (carry)
    ASTATREG (ac0) = ASTATREG (ac0_copy) = ~a < b;
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
  ASTATREG (v) = ASTATREG (v_copy) = overflow;
  ASTATREG (v_internal) |= overflow;
  ASTATREG (az) = v == 0;
  if (carry)
    ASTATREG (ac0) = ASTATREG (ac0_copy) = b <= a;
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
  ASTATREG (v) = ASTATREG (v_copy) = overflow;
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
  ASTATREG (v) = ASTATREG (v_copy) = overflow;
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
  ASTATREG (v) = ASTATREG (v_copy) = 0;
  return val;
}

static bu32
max32 (SIM_CPU *cpu, bu32 a, bu32 b)
{
  int val = a;
  if ((bs32)a < (bs32)b)
    val = b;
  setflags_nz (cpu, val);
  ASTATREG (v) = ASTATREG (v_copy) = 0;
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
  ASTATREG (v) = ASTATREG (v_copy) = 0;
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
  ASTATREG (v) = ASTATREG (v_copy) = 0;
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
  ASTATREG (v) = ASTATREG (v_copy) = ASTATREG (v_internal);
  ASTATREG (vs) |= ASTATREG (v);
  return v;
}

static bu32
xor_reduce (bu64 acc0, bu64 acc1)
{
  int i;
  bu32 v = 0;
  for (i = 0; i < 40; ++i)
    {
      v ^= (acc0 & acc1 & 1);
      acc0 >>= 1;
      acc1 >>= 1;
    }
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

/* Table C-4. Core Register Encoding Map */
const char * const greg_names[] =
{
  "R0",    "R1",      "R2",     "R3",    "R4",    "R5",    "R6",     "R7",
  "P0",    "P1",      "P2",     "P3",    "P4",    "P5",    "SP",     "FP",
  "I0",    "I1",      "I2",     "I3",    "M0",    "M1",    "M2",     "M3",
  "B0",    "B1",      "B2",     "B3",    "L0",    "L1",    "L2",     "L3",
  "A0.X",  "A0.W",    "A1.X",   "A1.W",  "<res>", "<res>", "ASTAT",  "RETS",
  "<res>", "<res>",   "<res>",  "<res>", "<res>", "<res>", "<res>",  "<res>",
  "LC0",   "LT0",     "LB0",    "LC1",   "LT1",   "LB1",   "CYCLES", "CYCLES2",
  "USP",   "SEQSTAT", "SYSCFG", "RETI",  "RETX",  "RETN",  "RETE",   "EMUDAT",
};
static const char *
get_allreg_name (int grp, int reg)
{
  return greg_names[(grp << 3) | reg];
}

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
	case 63: return &EMUDAT_INREG;
	}
      return 0;
    }
}

#define REQUIRE_SUPERVISOR() cec_get_ivg (cpu)
static int
reg_requires_sup (SIM_CPU *cpu, int grp, int reg)
{
  return grp == 7 && reg != 7;	/* XXX: EMUDAT safe to RW from user ?  */
}

static void
reg_write (SIM_CPU *cpu, int grp, int reg, bu32 value)
{
  bu32 *whichreg;

  if (reg_requires_sup (cpu, grp, reg))
    REQUIRE_SUPERVISOR ();

  /* ASTAT is special!  */
  if (grp == 4 && reg == 6)
    {
      SET_ASTAT (value);
      return;
    }

  whichreg = get_allreg (cpu, grp, reg);

  if (whichreg == &CYCLES2REG)
    /* Writes to CYCLES2 goes to the shadow.  */
    whichreg = &CYCLES2SHDREG;
  else if (whichreg == &SEQSTATREG)
    /* Register is read only -- discard writes.  */
    return;
  else if (whichreg == &EMUDAT_INREG)
    /* Writes to EMUDAT goes to the output.  */
    whichreg = &EMUDAT_OUTREG;
  else if (whichreg == &A0XREG || whichreg == &A1XREG)
    value &= 0xFF;

  TRACE_CORE (cpu, "wrote %s = %#x", get_allreg_name (grp, reg), value);

  *whichreg = value;
}

static bu32
reg_read (SIM_CPU *cpu, int grp, int reg)
{
  bu32 *whichreg;
  bu32 value;

  if (reg_requires_sup (cpu, grp, reg))
    REQUIRE_SUPERVISOR ();

  /* ASTAT is special!  */
  if (grp == 4 && reg == 6)
    return ASTAT;

  whichreg = get_allreg (cpu, grp, reg);
  value = *whichreg;

  if (whichreg == &CYCLESREG)
    /* Reads of CYCLES reloads CYCLES2 from the shadow.  */
    CYCLES2REG = CYCLES2SHDREG;
  else if ((whichreg == &A1XREG || whichreg == &A0XREG) && (value & 0x80))
    /* sign extend if necessary */
    value |= 0xFFFFFF00;

  return value;
}

static bu64
get_extended_cycles (SIM_CPU *cpu)
{
  return ((bu64)CYCLES2SHDREG << 32) | CYCLESREG;
}

static void
cycles_inc (SIM_CPU *cpu, bu32 inc)
{
  bu64 cycles;

  if (!(SYSCFGREG & SYSCFG_CCEN))
    return;

  cycles = get_extended_cycles (cpu) + inc;
  CYCLESREG = cycles;
  CYCLES2SHDREG = cycles >> 32;
}

static bu64
get_unextended_acc (SIM_CPU *cpu, int which)
{
  return ((bu64)AXREG (which) << 32) | AWREG (which);
}

static bu64
get_extended_acc (SIM_CPU *cpu, int which)
{
  bu64 acc = AXREG (which);
  /* Sign extend accumulator values before adding.  */
  if (acc & 0x80)
    acc |= -0x80;
  else
    acc &= 0xFF;
  acc <<= 32;
  acc |= AWREG (which);
  return acc;
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
  else
    switch (mmod)
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
  bu64 acc = get_extended_acc (cpu, which);
  int sat = 0;

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

  TRACE_EXTRACT (cpu, "%s: poprnd:%i prgfunc:%i", __func__, poprnd, prgfunc);

  if (prgfunc == 0 && poprnd == 0)
    {
      TRACE_INSN (cpu, "NOP;");
      PCREG += 2;
    }
  else if (prgfunc == 1 && poprnd == 0)
    {
      bu32 newpc = RETSREG;
      TRACE_INSN (cpu, "RTS;");
      TRACE_BRANCH (cpu, "RTS to %#x", newpc);
      PCREG = newpc;
    }
  else if (prgfunc == 1 && poprnd == 1)
    {
      TRACE_INSN (cpu, "RTI;");
      TRACE_BRANCH (cpu, "RTI may change PC");
      cec_return (cpu, -1);
    }
  else if (prgfunc == 1 && poprnd == 2)
    {
      TRACE_INSN (cpu, "RTX;");
      TRACE_BRANCH (cpu, "RTX may change PC");
      cec_return (cpu, IVG_EVX);
    }
  else if (prgfunc == 1 && poprnd == 3)
    {
      TRACE_INSN (cpu, "RTN;");
      TRACE_BRANCH (cpu, "RTN may change PC");
      cec_return (cpu, IVG_NMI);
    }
  else if (prgfunc == 1 && poprnd == 4)
    {
      TRACE_INSN (cpu, "RTE;");
      TRACE_BRANCH (cpu, "RTE may change PC");
      cec_return (cpu, IVG_EMU);
    }
  else if (prgfunc == 2 && poprnd == 0)
    {
      TRACE_INSN (cpu, "IDLE;");
      PCREG += 2;
      /* XXX: in supervisor mode, utilizes wake up sources
       * in user mode, it's a NOP
       */
    }
  else if (prgfunc == 2 && poprnd == 3)
    {
      TRACE_INSN (cpu, "CSYNC;");
      /* just NOP it */
      PCREG += 2;
    }
  else if (prgfunc == 2 && poprnd == 4)
    {
      TRACE_INSN (cpu, "SSYNC;");
      /* just NOP it */
      PCREG += 2;
    }
  else if (prgfunc == 2 && poprnd == 5)
    {
      TRACE_INSN (cpu, "EMUEXCPT;");
      PCREG += 2;
      cec_raise (cpu, IVG_EMU);
    }
  else if (prgfunc == 3)
    {
      bu32 *whichreg = get_allreg (cpu, DREG_GRP, poprnd);
      TRACE_INSN (cpu, "CLI R%i;", poprnd);
      *whichreg = cec_cli (cpu);
      PCREG += 2;
    }
  else if (prgfunc == 4)
    {
      bu32 *whichreg = get_allreg (cpu, DREG_GRP, poprnd);
      TRACE_INSN (cpu, "STI R%i;", poprnd);
      cec_sti (cpu, *whichreg);
      PCREG += 2;
    }
  else if (prgfunc == 5)
    {
      bu32 newpc = PREG (poprnd);
      TRACE_INSN (cpu, "JUMP (P%i);", poprnd);
      TRACE_BRANCH (cpu, "JUMP (Preg) to %#x", newpc);
      PCREG = newpc;
      BFIN_CPU_STATE.did_jump = true;
    }
  else if (prgfunc == 6)
    {
      bu32 newpc = PREG (poprnd);
      TRACE_INSN (cpu, "CALL (P%i);", poprnd);
      TRACE_BRANCH (cpu, "CALL (Preg) to %#x", newpc);
      RETSREG = PCREG + 2;
      PCREG = newpc;
      BFIN_CPU_STATE.did_jump = true;
    }
  else if (prgfunc == 7)
    {
      bu32 newpc = PCREG + PREG (poprnd);
      TRACE_INSN (cpu, "CALL (PC + P%i);", poprnd);
      TRACE_BRANCH (cpu, "CALL (PC + Preg) to %#x", newpc);
      RETSREG = PCREG + 2;
      PCREG = newpc;
      BFIN_CPU_STATE.did_jump = true;
    }
  else if (prgfunc == 8)
    {
      bu32 newpc = PCREG + PREG (poprnd);
      TRACE_INSN (cpu, "JUMP (PC + P%i);", poprnd);
      TRACE_BRANCH (cpu, "JUMP (PC + Preg) to %#x", newpc);
      PCREG = newpc;
      BFIN_CPU_STATE.did_jump = true;
    }
  else if (prgfunc == 9)
    {
      int raise = uimm4 (poprnd);
      TRACE_INSN (cpu, "RAISE %i;", raise);
      TRACE_BRANCH (cpu, "RAISE may change PC");
      PCREG += 2;
      cec_raise (cpu, raise);
    }
  else if (prgfunc == 10)
    {
      int excpt = uimm4 (poprnd);
      TRACE_INSN (cpu, "EXCPT %i;", excpt);
      TRACE_BRANCH (cpu, "EXCPT may change PC");
      /* XXX: see comments in cec_exception() */
      PCREG += 2;
      cec_exception (cpu, excpt);
    }
  else if (prgfunc == 11)
    {
      bu32 addr = PREG (poprnd);
      bu8 byte;
      TRACE_INSN (cpu, "TESTSET (P%i);", poprnd);
      byte = GET_WORD (addr);
      CCREG = (byte == 0);
      PUT_BYTE (addr, byte | 0x80);
      PCREG += 2;
    }
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

  TRACE_EXTRACT (cpu, "%s: a:%i op:%i reg:%i", __func__, a, op, reg);
  TRACE_DECODE (cpu, "reg:%s", get_allreg_name (PREG_GRP, reg));

  /* No cache simulation, so these are (mostly) all NOPs.
     XXX: The hardware takes care of masking to cache lines, but need
     to check behavior of the post increment.  Should we be aligning
     the value to the cache line before adding the cache line size, or
     do we just add the cache line size ?  */
  if (a == 0 && op == 0)
    {
      TRACE_INSN (cpu, "PREFETCH [P%i];", reg);
      /* implicit read which may trigger CPLB miss.  */
      GET_BYTE (*whichreg);
    }
  else if (a == 0 && op == 1)
    {
      TRACE_INSN (cpu, "FLUSHINV [P%i];", reg);
    }
  else if (a == 0 && op == 2)
    {
      TRACE_INSN (cpu, "FLUSH [P%i];", reg);
    }
  else if (a == 0 && op == 3)
    {
      TRACE_INSN (cpu, "IFLUSH [P%i];", reg);
    }
  else if (a == 1 && op == 0)
    {
      TRACE_INSN (cpu, "PREFETCH [P%i++];", reg);
      *whichreg += BFIN_L1_CACHE_BYTES;
    }
  else if (a == 1 && op == 1)
    {
      TRACE_INSN (cpu, "FLUSHINV [P%i++];", reg);
      *whichreg += BFIN_L1_CACHE_BYTES;
    }
  else if (a == 1 && op == 2)
    {
      TRACE_INSN (cpu, "FLUSH [P%i++];", reg);
      *whichreg += BFIN_L1_CACHE_BYTES;
    }
  else if (a == 1 && op == 3)
    {
      TRACE_INSN (cpu, "IFLUSH [P%i++];", reg);
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
  const char *reg_name = get_allreg_name (grp, reg);

  TRACE_EXTRACT (cpu, "%s: W:%i grp:%i reg:%i", __func__, W, grp, reg);
  TRACE_DECODE (cpu, "%s: reg:%s", __func__, reg_name);

  if (W == 0)
    {
      bu32 value = GET_LONG (SPREG);
      TRACE_INSN (cpu, "%s = [SP++];", reg_name);
      /* XXX: If SP triggers an exception, should it be updated ?  */
      reg_write (cpu, grp, reg, value);
      if (grp == 7 && reg == 3)
	cec_pop_reti (cpu);
      SPREG += 4;
    }
  else
    {
      bu32 value;
      TRACE_INSN (cpu, "[--SP] = %s;", reg_name);
      /* XXX: If SP triggers an exception, should it be updated ?  */
      SPREG -= 4;
      value = reg_read (cpu, grp, reg);
      if (grp == 7 && reg == 3)
	cec_push_reti (cpu);

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

  TRACE_EXTRACT (cpu, "%s: d:%i p:%i W:%i dr:%i pr:%i",
		 __func__, d, p, W, dr, pr);

  if ((d == 0 && p == 0) || (p && imm5 (pr) > 5))
    illegal_instruction (cpu);

  if (W == 1)
    {
      if (d && p)
	TRACE_INSN (cpu, "[--SP] = (R7:%i, P5:%i);", dr, pr);
      else if (d)
	TRACE_INSN (cpu, "[--SP] = (R7:%i);", dr);
      else
	TRACE_INSN (cpu, "[--SP] = (P5:%i);", pr);

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
      if (d && p)
	TRACE_INSN (cpu, "(R7:%i, P5:%i) = [SP++];", dr, pr);
      else if (d)
	TRACE_INSN (cpu, "(R7:%i) = [SP++];", dr);
      else
	TRACE_INSN (cpu, "(P5:%i) = [SP++];", pr);

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

  TRACE_EXTRACT (cpu, "%s: T:%i d:%i s:%i dst:%i src:%i",
		 __func__, T, d, s, dst, src);

  TRACE_INSN (cpu, "IF %sCC %s = %s;", T ? "" : "! ",
	      get_allreg_name (d, dst),
	      get_allreg_name (s, src));

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

  TRACE_EXTRACT (cpu, "%s: I:%i opc:%i G:%i y:%i x:%i",
		 __func__, I, opc, G, y, x);

  if (opc > 4)
    {
      bs64 acc0 = get_extended_acc (cpu, 0);
      bs64 acc1 = get_extended_acc (cpu, 1);
      bs64 diff = acc0 - acc1;

      if (opc == 5 && I == 0 && G == 0)
	{
	  TRACE_INSN (cpu, "CC = A0 == A1;");
	  CCREG = acc0 == acc1;
	}
      else if (opc == 6 && I == 0 && G == 0)
	{
	  TRACE_INSN (cpu, "CC = A0 < A1");
	  CCREG = acc0 < acc1;
	}
      else if (opc == 7 && I == 0 && G == 0)
	{
	  TRACE_INSN (cpu, "CC = A0 <= A1");
	  CCREG = acc0 <= acc1;
	}
      else
	illegal_instruction (cpu);

      ASTATREG (az) = (diff == 0);
      ASTATREG (an) = (diff < 0);
      ASTATREG (ac0) = ASTATREG (ac0_copy) = (0); /* XXX: What is this ?  */
    }
  else
    {
      int issigned = opc < 3;
      const char *sign = issigned ? "" : " (IU)";
      bu32 srcop = G ? PREG (x) : DREG (x);
      char s = G ? 'P' : 'R';
      bu32 dstop = I ? (issigned ? imm3 (y) : uimm3 (y)) : G ? PREG (y) : DREG (y);
      const char *op;
      char d = G ? 'P' : 'R';
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
	  ASTATREG (ac0) = ASTATREG (ac0_copy) = ac0;
	}
      switch (opc)
	{
	case 0:
	  op = "==";
	  CCREG = az;
	  break;
	case 1:	/* signed */
	  op = "<";
	  CCREG = (flgn && !overflow) || (!flgn && overflow);
	  break;
	case 2:	/* signed */
	  op = "<=";
	  CCREG = (flgn && !overflow) || (!flgn && overflow) || az;
	  break;
	case 3:	/* unsigned */
	  op = "<";
	  CCREG = ac0;
	  break;
	case 4:	/* unsigned */
	  op = "<=";
	  CCREG = ac0 | az;
	  break;
	}

      if (I)
	TRACE_INSN (cpu, "CC = %c%i %s %#x%s;", s, x, op, dstop, sign);
      else
	TRACE_INSN (cpu, "CC = %c%i %s %c%i%s;", s, x, op, d, y, sign);
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

  TRACE_EXTRACT (cpu, "%s: op:%i reg:%i", __func__, op, reg);

  if (op == 0)
    {
      TRACE_INSN (cpu, "R%i = CC;", reg);
      DREG (reg) = CCREG;
    }
  else if (op == 1)
    {
      TRACE_INSN (cpu, "CC = R%i;", reg);
      CCREG = DREG (reg) != 0;
    }
  else if (op == 3)
    {
      TRACE_INSN (cpu, "CC = !CC;");
      CCREG = !CCREG;
    }
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

  const char * const op_names[] = { "", "|", "&", "^" } ;
  const char *astat_name;
  const char * const astat_names[] = {
    [ 0] = "AZ",
    [ 1] = "AN",
    [ 6] = "AQ",
    [12] = "AC0",
    [13] = "AC1",
    [16] = "AV0",
    [17] = "AV0S",
    [18] = "AV1",
    [19] = "AV1S",
    [24] = "V",
    [25] = "VS",
  };
  astat_name = cbit < ARRAY_SIZE (astat_names) ? astat_names[cbit] : NULL;
  if (!astat_name)
    astat_name = "INVALID";

  TRACE_EXTRACT (cpu, "%s: D:%i op:%i cbit:%i", __func__, D, op, cbit);

  TRACE_INSN (cpu, "%s %s= %s;", D ? astat_name : "CC",
	      op_names[op], D ? "CC" : astat_name);

  switch (cbit)
    {
    case  0: pval = &ASTATREG (az); break;
    case  1: pval = &ASTATREG (an); break;
    case  6: pval = &ASTATREG (aq); break;
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
      case 0: CCREG  = *pval; break;
      case 1: CCREG |= *pval; break;
      case 2: CCREG &= *pval; break;
      case 3: CCREG ^= *pval; break;
      }
  else
    switch (op)
      {
      case 0: *pval  = CCREG; break;
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
  int B = ((iw0 >> 10) & 0x1);
  int T = ((iw0 >> 11) & 0x1);
  int offset = ((iw0 >> 0) & 0x3ff);
  int cond = T ? CCREG : ! CCREG;
  int pcrel = pcrel10 (offset);

  /* B is just the branch predictor hint - we can ignore it.  */

  TRACE_EXTRACT (cpu, "%s: T:%i B:%i offset:%#x", __func__, T, B, offset);
  TRACE_DECODE (cpu, "%s: pcrel10:%#x", __func__, pcrel);

  TRACE_INSN (cpu, "IF %sCC JUMP %#x%s;", T ? "" : "! ",
	      pcrel, B ? " (bp)" : "");
  if (cond)
    {
      bu32 newpc = PCREG + pcrel;
      TRACE_BRANCH (cpu, "Conditional JUMP to %#x", newpc);
      PCREG = newpc;
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
  int pcrel = pcrel12 (offset);
  bu32 newpc = PCREG + pcrel;

  TRACE_EXTRACT (cpu, "%s: offset:%#x", __func__, offset);
  TRACE_DECODE (cpu, "%s: pcrel12:%#x", __func__, pcrel);

  TRACE_INSN (cpu, "JUMP.S %#x;", pcrel);
  TRACE_BRANCH (cpu, "JUMP.S to %#x", newpc);

  PCREG = newpc;
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
  const char *srcreg_name = get_allreg_name (gs, src);
  const char *dstreg_name = get_allreg_name (gd, dst);

  TRACE_EXTRACT (cpu, "%s: gd:%i gs:%i dst:%i src:%i",
		 __func__, gd, gs, dst, src);
  TRACE_DECODE (cpu, "%s: dst:%s src:%s", __func__, dstreg_name, srcreg_name);

  TRACE_INSN (cpu, "%s = %s;", dstreg_name, srcreg_name);

  reg_write (cpu, gd, dst, reg_read (cpu, gs, src));

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

  TRACE_EXTRACT (cpu, "%s: opc:%i src:%i dst:%i", __func__, opc, src, dst);

  if (opc == 0)
    {
      TRACE_INSN (cpu, "R%i >>>= R%i;", dst, src);
      DREG (dst) = ashiftrt (cpu, DREG (dst), DREG (src), 32);
    }
  else if (opc == 1)
    {
      TRACE_INSN (cpu, "R%i >>= R%i;", dst, src);
      DREG (dst) = lshiftrt (cpu, DREG (dst), DREG (src), 32);
    }
  else if (opc == 2)
    {
      TRACE_INSN (cpu, "R%i <<= R%i;", dst, src);
      DREG (dst) = lshift (cpu, DREG (dst), DREG (src), 32, 0);
    }
  else if (opc == 3)
    {
      TRACE_INSN (cpu, "R%i *= R%i;", dst, src);
      DREG (dst) *= DREG (src);
    }
  else if (opc == 4)
    {
      TRACE_INSN (cpu, "R%i = (R%i + R%i) << 1;", dst, dst, src);
      DREG (dst) = add_and_shift (cpu, DREG (dst), DREG (src), 1);
    }
  else if (opc == 5)
    {
      TRACE_INSN (cpu, "R%i = (R%i + R%i) << 2;", dst, dst, src);
      DREG (dst) = add_and_shift (cpu, DREG (dst), DREG (src), 2);
    }
  else if (opc == 8)
    {
      TRACE_INSN (cpu, "DIVQ ( R%i, R%i );", dst, src);
      DREG (dst) = divq (cpu, DREG (dst), (bu16)DREG (src));
    }
  else if (opc == 9)
    {
      TRACE_INSN (cpu, "DIVS ( R%i, R%i );", dst, src);
      DREG (dst) = divs (cpu, DREG (dst), (bu16)DREG (src));
    }
  else if (opc == 10)
    {
      TRACE_INSN (cpu, "R%i = R%i.L (X);", dst, src);
      DREG (dst) = (bs32) (bs16) DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 11)
    {
      TRACE_INSN (cpu, "R%i = R%i.L (Z);", dst, src);
      DREG (dst) = (bu32) (bu16) DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 12)
    {
      TRACE_INSN (cpu, "R%i = R%i.B (X);", dst, src);
      DREG (dst) = (bs32) (bs8) DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 13)
    {
      TRACE_INSN (cpu, "R%i = R%i.B (Z);", dst, src);
      DREG (dst) = (bu32) (bu8) DREG (src);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 14)
    {
      TRACE_INSN (cpu, "R%i = - R%i.B;", dst, src);
      bu32 val = DREG (src);
      DREG (dst) = -val;
      setflags_nz (cpu, DREG (dst));
      ASTATREG (v) = ASTATREG (v_copy) = (val == 0x80000000);
      ASTATREG (vs) |= ASTATREG (v);
      ASTATREG (ac0) = ASTATREG (ac0_copy) = (val == 0x0);
      /* @@@ Documentation isn't entirely clear about av0 and av1.  */
    }
  else if (opc == 15)
    {
      TRACE_INSN (cpu, "R%i = ~ R%i.B;", dst, src);
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

  TRACE_EXTRACT (cpu, "%s: opc:%i src:%i dst:%i", __func__, opc, src, dst);

  if (opc == 0)
    {
      TRACE_INSN (cpu, "P%i -= P%i", dst, src);
      PREG (dst) -= PREG (src);
    }
  else if (opc == 1)
    {
      TRACE_INSN (cpu, "P%i = P%i << 2", dst, src);
      PREG (dst) = PREG (src) << 2;
    }
  else if (opc == 3)
    {
      TRACE_INSN (cpu, "P%i = P%i >> 2", dst, src);
      PREG (dst) = PREG (src) >> 2;
    }
  else if (opc == 4)
    {
      TRACE_INSN (cpu, "P%i = P%i >> 1", dst, src);
      PREG (dst) = PREG (src) >> 1;
    }
  else if (opc == 5)
    {
      TRACE_INSN (cpu, "P%i += P%i (BREV)", dst, src);
      PREG (dst) = add_brev (cpu, PREG (dst), PREG (src));
    }
  else if (opc == 6)
    {
      TRACE_INSN (cpu, "P%i = (P%i + P%i) << 1", dst, dst, src);
      PREG (dst) = (PREG (dst) + PREG (src)) << 1;
    }
  else if (opc == 7)
    {
      TRACE_INSN (cpu, "P%i = (P%i + P%i) << 2", dst, dst, src);
      PREG (dst) = (PREG (dst) + PREG (src)) << 2;
    }
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
  int uimm = uimm5 (src);

  TRACE_EXTRACT (cpu, "%s: opc:%i src:%i dst:%i", __func__, opc, src, dst);
  TRACE_DECODE (cpu, "%s: uimm5:%#x", __func__, uimm);

  if (opc == 0)
    {
      TRACE_INSN (cpu, "CC = ! BITTST (R%i, %i);", dst, uimm);
      CCREG = (~DREG (dst) >> uimm) & 1;
    }
  else if (opc == 1)
    {
      TRACE_INSN (cpu, "CC = BITTST (R%i, %i);", dst, uimm);
      CCREG = (DREG (dst) >> uimm) & 1;
    }
  else if (opc == 2)
    {
      TRACE_INSN (cpu, "BITSET (R%i, %i);", dst, uimm);
      DREG (dst) |= 1 << uimm;
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 3)
    {
      TRACE_INSN (cpu, "BITTGL (R%i, %i);", dst, uimm);
      DREG (dst) ^= 1 << uimm;
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 4)
    {
      TRACE_INSN (cpu, "BITCLR (R%i, %i);", dst, uimm);
      DREG (dst) &= ~(1 << uimm);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 5)
    {
      TRACE_INSN (cpu, "R%i >>>= %i;", dst, uimm);
      DREG (dst) = ashiftrt (cpu, DREG (dst), uimm, 32);
    }
  else if (opc == 6)
    {
      TRACE_INSN (cpu, "R%i >>= %i;", dst, uimm);
      DREG (dst) = lshiftrt (cpu, DREG (dst), uimm, 32);
    }
  else if (opc == 7)
    {
      TRACE_INSN (cpu, "R%i <<= %i;", dst, uimm);
      DREG (dst) = lshift (cpu, DREG (dst), uimm, 32, 0);
    }

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

  TRACE_EXTRACT (cpu, "%s: opc:%i dst:%i src1:%i src0:%i",
		 __func__, opc, dst, src1, src0);

  if (opc == 0)
    {
      TRACE_INSN (cpu, "R%i = R%i + R%i;", dst, src0, src1);
      DREG (dst) = add32 (cpu, DREG (src0), DREG (src1), 1, 0);
    }
  else if (opc == 1)
    {
      TRACE_INSN (cpu, "R%i = R%i - R%i;", dst, src0, src1);
      DREG (dst) = sub32 (cpu, DREG (src0), DREG (src1), 1, 0);
    }
  else if (opc == 2)
    {
      TRACE_INSN (cpu, "R%i = R%i & R%i;", dst, src0, src1);
      DREG (dst) = DREG (src0) & DREG (src1);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 3)
    {
      TRACE_INSN (cpu, "R%i = R%i | R%i;", dst, src0, src1);
      DREG (dst) = DREG (src0) | DREG (src1);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 4)
    {
      TRACE_INSN (cpu, "R%i = R%i ^ R%i;", dst, src0, src1);
      DREG (dst) = DREG (src0) ^ DREG (src1);
      setflags_logical (cpu, DREG (dst));
    }
  else if (opc == 5)
    {
      /* If src0 == src1 this is disassembled as a shift by 1, but this
       * distinction doesn't matter for our purposes.
       */
      TRACE_INSN (cpu, "P%i = P%i + P%i;", dst, src0, src1);
      PREG (dst) = PREG (src0) + PREG (src1);
    }
  else if (opc == 6)
    {
      TRACE_INSN (cpu, "P%i = P%i + P%i << 0x1;", dst, src0, src1);
      PREG (dst) = PREG (src0) + (PREG (src1) << 1);
    }
  else if (opc == 7)
    {
      TRACE_INSN (cpu, "P%i = P%i + P%i << 0x2;", dst, src0, src1);
      PREG (dst) = PREG (src0) + (PREG (src1) << 2);
    }

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
  int imm = imm7 (isrc);

  TRACE_EXTRACT (cpu, "%s: op:%i isrc:%i dst:%i", __func__, op, isrc, dst);
  TRACE_DECODE (cpu, "%s: imm7:%#x", __func__, imm);

  if (op == 0)
    {
      TRACE_INSN (cpu, "R%i = 0x%x (X);", dst, imm);
      DREG (dst) = imm;
    }
  else if (op == 1)
    {
      TRACE_INSN (cpu, "R%i += 0x%x;", dst, imm);
      DREG (dst) = add32 (cpu, DREG (dst), imm, 1, 0);
    }

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
  int imm = imm7 (src);

  TRACE_EXTRACT (cpu, "%s: op:%i src:%i dst:%i", __func__, op, src, dst);
  TRACE_DECODE (cpu, "%s: imm:%#x", __func__, imm);

  if (op == 0)
    {
      TRACE_INSN (cpu, "P%i = %i;", dst, imm);
      PREG (dst) = imm;
    }
  else if (op == 1)
    {
      TRACE_INSN (cpu, "P%i += %i;", dst, imm);
      PREG (dst) += imm;
    }

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

  TRACE_EXTRACT (cpu, "%s: W:%i aop:%i reg:%i idx:%i ptr:%i",
		 __func__, W, aop, reg, idx, ptr);

  if (aop == 1 && W == 0 && idx == ptr)
    {
      TRACE_INSN (cpu, "R%i.L = W[P%i];", reg, ptr);
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | val);
    }
  else if (aop == 2 && W == 0 && idx == ptr)
    {
      TRACE_INSN (cpu, "R%i.H = W[P%i];", reg, ptr);
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (val << 16));
    }
  else if (aop == 1 && W == 1 && idx == ptr)
    {
      TRACE_INSN (cpu, "W[P%i] = R%i.L;", ptr, reg);
      addr = PREG (ptr);
      PUT_WORD (addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && idx == ptr)
    {
      TRACE_INSN (cpu, "W[P%i] = R%i.H;", ptr, reg);
      addr = PREG (ptr);
      PUT_WORD (addr, DREG (reg) >> 16);
    }
  else if (aop == 0 && W == 0)
    {
      TRACE_INSN (cpu, "R%i = [P%i ++ P%i];", reg, ptr, idx);
      /* dregs = [pregs ++ pregs] */
      addr = PREG (ptr);
      val = GET_LONG (addr);
      STORE (DREG (reg), val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 1 && W == 0)
    {
      TRACE_INSN (cpu, "R%i.L = W[P%i ++ P%i];", reg, ptr, idx);
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 2 && W == 0)
    {
      TRACE_INSN (cpu, "R%i.H = W[P%i ++ P%i];", reg, ptr, idx);
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (val << 16));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 3 && W == 0)
    {
      TRACE_INSN (cpu, "R%i = W[P%i ++ P%i] (Z);", reg, ptr, idx);
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 3 && W == 1)
    {
      TRACE_INSN (cpu, "R%i = W[P%i ++ P%i] (X);", reg, ptr, idx);
      addr = PREG (ptr);
      val = GET_WORD (addr);
      STORE (DREG (reg), (bs32) (bs16) val);
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 0 && W == 1)
    {
      TRACE_INSN (cpu, "[P%i ++ P%i] = R%i;", ptr, idx, reg);
      addr = PREG (ptr);
      PUT_LONG (addr, DREG (reg));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 1 && W == 1)
    {
      TRACE_INSN (cpu, "W[P%i ++ P%i] = R%i.L;", ptr, idx, reg);
      addr = PREG (ptr);
      PUT_WORD (addr, DREG (reg));
      STORE (PREG (ptr), addr + PREG (idx));
    }
  else if (aop == 2 && W == 1)
    {
      TRACE_INSN (cpu, "W[P%i ++ P%i] = R%i.H;", ptr, idx, reg);
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

  TRACE_EXTRACT (cpu, "%s: br:%i op:%i m:%i i:%i", __func__, br, op, m, i);

  if (op == 0 && br == 1)
    {
      TRACE_INSN (cpu, "I%i += M%i (BREV);", i, m);
      IREG (i) = add_brev (cpu, IREG (i), MREG (m));
    }
  else if (op == 0)
    {
      TRACE_INSN (cpu, "I%i += M%i;", i, m);
      dagadd (cpu, i, MREG (m));
    }
  else if (op == 1)
    {
      TRACE_INSN (cpu, "I%i -= M%i;", i, m);
      dagsub (cpu, i, MREG (m));
    }
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

  TRACE_EXTRACT (cpu, "%s: op:%i i:%i", __func__, op, i);

  if (op == 0)
    {
      TRACE_INSN (cpu, "I%i += 2;;", i);
      dagadd (cpu, i, 2);
    }
  else if (op == 1)
    {
      TRACE_INSN (cpu, "I%i -= 2;;", i);
      dagsub (cpu, i, 2);
    }
  else if (op == 2)
    {
      TRACE_INSN (cpu, "I%i += 4;;", i);
      dagadd (cpu, i, 4);
    }
  else if (op == 3)
    {
      TRACE_INSN (cpu, "I%i -= 4;;", i);
      dagsub (cpu, i, 4);
    }
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

  TRACE_EXTRACT (cpu, "%s: aop:%i m:%i i:%i reg:%i", __func__, aop, m, i, reg);

  if (aop == 0 && W == 0 && m == 0)
    {
      TRACE_INSN (cpu, "R%i = [I%i++];", reg, i);
      addr = IREG (i);
      dagadd (cpu, i, 4);
      STORE (DREG (reg), GET_LONG (addr));
    }
  else if (aop == 0 && W == 0 && m == 1)
    {
      TRACE_INSN (cpu, "R%i.L = W[I%i++];", reg, i);
      addr = IREG (i);
      dagadd (cpu, i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | GET_WORD (addr));
    }
  else if (aop == 0 && W == 0 && m == 2)
    {
      TRACE_INSN (cpu, "R%i.H = W[I%i++];", reg, i);
      addr = IREG (i);
      dagadd (cpu, i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (GET_WORD (addr) << 16));
    }
  else if (aop == 1 && W == 0 && m == 0)
    {
      TRACE_INSN (cpu, "R%i = [I%i--];", reg, i);
      addr = IREG (i);
      dagsub (cpu, i, 4);
      STORE (DREG (reg), GET_LONG (addr));
    }
  else if (aop == 1 && W == 0 && m == 1)
    {
      TRACE_INSN (cpu, "R%i.L = W[I%i--];", reg, i);
      addr = IREG (i);
      dagsub (cpu, i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | GET_WORD (addr));
    }
  else if (aop == 1 && W == 0 && m == 2)
    {
      TRACE_INSN (cpu, "R%i.H = W[I%i--];", reg, i);
      addr = IREG (i);
      dagsub (cpu, i, 2);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (GET_WORD (addr) << 16));
    }
  else if (aop == 2 && W == 0 && m == 0)
    {
      TRACE_INSN (cpu, "R%i = [I%i];", reg, i);
      addr = IREG (i);
      STORE (DREG (reg), GET_LONG (addr));
    }
  else if (aop == 2 && W == 0 && m == 1)
    {
      TRACE_INSN (cpu, "R%i.L = W[I%i];", reg, i);
      addr = IREG (i);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF0000) | GET_WORD (addr));
    }
  else if (aop == 2 && W == 0 && m == 2)
    {
      TRACE_INSN (cpu, "R%i.H = W[I%i];", reg, i);
      addr = IREG (i);
      STORE (DREG (reg), (DREG (reg) & 0xFFFF) | (GET_WORD (addr) << 16));
    }
  else if (aop == 0 && W == 1 && m == 0)
    {
      TRACE_INSN (cpu, "[I%i++] = R%i;", i, reg);
      addr = IREG (i);
      dagadd (cpu, i, 4);
      PUT_LONG (addr, DREG (reg));
    }
  else if (aop == 0 && W == 1 && m == 1)
    {
      TRACE_INSN (cpu, "W[I%i++] = R%i.L;", i, reg);
      addr = IREG (i);
      dagadd (cpu, i, 2);
      PUT_WORD (addr, DREG (reg));
    }
  else if (aop == 0 && W == 1 && m == 2)
    {
      TRACE_INSN (cpu, "W[I%i++] = R%i.H;", i, reg);
      addr = IREG (i);
      dagadd (cpu, i, 2);
      PUT_WORD (addr, DREG (reg) >> 16);
    }
  else if (aop == 1 && W == 1 && m == 0)
    {
      TRACE_INSN (cpu, "[I%i--] = R%i;", i, reg);
      addr = IREG (i);
      dagsub (cpu, i, 4);
      PUT_LONG (addr, DREG (reg));
    }
  else if (aop == 1 && W == 1 && m == 1)
    {
      TRACE_INSN (cpu, "W[I%i--] = R%i.L;", i, reg);
      addr = IREG (i);
      dagsub (cpu, i, 2);
      PUT_WORD (addr, DREG (reg));
    }
  else if (aop == 1 && W == 1 && m == 2)
    {
      TRACE_INSN (cpu, "W[I%i--] = R%i.H;", i, reg);
      addr = IREG (i);
      dagsub (cpu, i, 2);
      PUT_WORD (addr, DREG (reg) >> 16);
    }
  else if (aop == 2 && W == 1 && m == 0)
    {
      TRACE_INSN (cpu, "[I%i] = R%i;", i, reg);
      addr = IREG (i);
      PUT_LONG (addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && m == 1)
    {
      TRACE_INSN (cpu, "W[I%i] = R%i.L;", i, reg);
      addr = IREG (i);
      PUT_WORD (addr, DREG (reg));
    }
  else if (aop == 2 && W == 1 && m == 2)
    {
      TRACE_INSN (cpu, "W[I%i] = R%i.H;", i, reg);
      addr = IREG (i);
      PUT_WORD (addr, DREG (reg) >> 16);
    }
  else if (aop == 3 && W == 0)
    {
      TRACE_INSN (cpu, "R%i = [I%i ++ M%i];", reg, i, m);
      addr = IREG (i);
      dagadd (cpu, i, MREG (m));
      STORE (DREG (reg), GET_LONG (addr));
    }
  else if (aop == 3 && W == 1)
    {
      TRACE_INSN (cpu, "[I%i ++ M%i] = R%i;", i, m, reg);
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
  const char * const posts[] = { "++", "--", "" };
  const char *post = posts[aop];

  TRACE_EXTRACT (cpu, "%s: sz:%i W:%i aop:%i Z:%i ptr:%i reg:%i",
		 __func__, sz, W, aop, Z, ptr, reg);

  if (aop == 3)
    illegal_instruction (cpu);

  if (W == 0)
    {
      if (aop != 2 && sz == 0 && Z == 1 && ptr == reg)
	illegal_instruction (cpu);

      if (sz == 0 && Z == 0)
	{
	  TRACE_INSN (cpu, "R%i = [P%i%s];", reg, ptr, post);
	  DREG (reg) = GET_LONG (PREG (ptr));
	}
      else if (sz == 0 && Z == 1)
	{
	  TRACE_INSN (cpu, "P%i = [P%i%s];", reg, ptr, post);
	  PREG (reg) = GET_LONG (PREG (ptr));
	}
      else if (sz == 1 && Z == 0)
	{
	  TRACE_INSN (cpu, "R%i = W[P%i%s] (Z);", reg, ptr, post);
	  DREG (reg) = GET_WORD (PREG (ptr));
	}
      else if (sz == 1 && Z == 1)
	{
	  TRACE_INSN (cpu, "R%i = W[P%i%s] (X);", reg, ptr, post);
	  DREG (reg) = (bs32) (bs16) GET_WORD (PREG (ptr));
	}
      else if (sz == 2 && Z == 0)
	{
	  TRACE_INSN (cpu, "R%i = B[P%i%s] (Z);", reg, ptr, post);
	  DREG (reg) = GET_BYTE (PREG (ptr));
	}
      else if (sz == 2 && Z == 1)
	{
	  TRACE_INSN (cpu, "R%i = B[P%i%s] (X);", reg, ptr, post);
	  DREG (reg) = (bs32) (bs8) GET_BYTE (PREG (ptr));
	}

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
	{
	  TRACE_INSN (cpu, "[P%i%s] = R%i;", ptr, post, reg);
	  PUT_LONG (PREG (ptr), DREG (reg));
	}
      else if (sz == 0 && Z == 1)
	{
	  TRACE_INSN (cpu, "[P%i%s] = P%i;", ptr, post, reg);
	  PUT_LONG (PREG (ptr), PREG (reg));
	}
      else if (sz == 1 && Z == 0)
	{
	  TRACE_INSN (cpu, "W[P%i%s] = R%i;", ptr, post, reg);
	  PUT_WORD (PREG (ptr), DREG (reg));
	}
      else if (sz == 2 && Z == 0)
	{
	  TRACE_INSN (cpu, "B[P%i%s] = R%i;", ptr, post, reg);
	  PUT_BYTE (PREG (ptr), DREG (reg));
	}

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
  bu32 imm = negimm5s4 (offset);
  bu32 ea = FPREG + imm;

  TRACE_EXTRACT (cpu, "%s: W:%i offset:%#x reg:%i", __func__, W, offset, reg);
  TRACE_DECODE (cpu, "%s: negimm5s4:%#x", __func__, imm);

  if (W == 0)
    {
      TRACE_INSN (cpu, "%s = [FP + %#x];", get_allreg_name (0, reg), imm);
      DPREG (reg) = GET_LONG (ea);
    }
  else
    {
      TRACE_INSN (cpu, "[FP + %#x] = %s;", imm, get_allreg_name (0, reg));
      PUT_LONG (ea, DPREG (reg));
    }

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
  bu32 imm = (op == 0 || op == 3 ? uimm4s4 (offset) : uimm4s2 (offset));
  bu32 ea = PREG (ptr) + imm;

  TRACE_EXTRACT (cpu, "%s: W:%i op:%i offset:%#x ptr:%i reg:%i",
		 __func__, W, op, offset, ptr, reg);
  TRACE_DECODE (cpu, "%s: uimm4s4/uimm4s2:%#x", __func__, imm);

  if (W == 1 && op == 2)
    illegal_instruction (cpu);

  if (W == 0)
    {
      if (op == 0)
	{
	  TRACE_INSN (cpu, "R%i = [P%i + %#x];", reg, ptr, imm);
	  DREG (reg) = GET_LONG (ea);
	}
      else if (op == 1)
	{
	  TRACE_INSN (cpu, "R%i = W[P%i + %#x] (Z);", reg, ptr, imm);
	  DREG (reg) = GET_WORD (ea);
	}
      else if (op == 2)
	{
	  TRACE_INSN (cpu, "R%i = W[P%i + %#x] (X);", reg, ptr, imm);
	  DREG (reg) = (bs32) (bs16) GET_WORD (ea);
	}
      else if (op == 3)
	{
	  TRACE_INSN (cpu, "P%i = [P%i + %#x];", reg, ptr, imm);
	  PREG (reg) = GET_LONG (ea);
	}
    }
  else
    {
      if (op == 0)
	{
	  TRACE_INSN (cpu, "[P%i + %#x] = R%i;", ptr, imm, reg);
	  PUT_LONG (ea, DREG (reg));
	}
      else if (op == 1)
	{
	  TRACE_INSN (cpu, "W[P%i + %#x] = R%i;", ptr, imm, reg);
	  PUT_WORD (ea, DREG (reg));
	}
      else if (op == 3)
	{
	  TRACE_INSN (cpu, "[P%i + %#x] = P%i;", ptr, imm, reg);
	  PUT_LONG (ea, PREG (reg));
	}
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
  int spcrel = pcrel4 (soffset);
  int epcrel = lppcrel10 (eoffset);

  TRACE_EXTRACT (cpu, "%s: rop:%i c:%i soffset:%i reg:%i eoffset:%i",
		 __func__, rop, c, soffset, reg, eoffset);
  TRACE_DECODE (cpu, "%s: s_pcrel4:%#x e_lppcrel10:%#x",
		__func__, spcrel, epcrel);

  if (rop == 0)
    {
      TRACE_INSN (cpu, "LSETUP (%#x, %#x) LC%i;", spcrel, epcrel, c);
    }
  else if (rop == 1)
    {
      TRACE_INSN (cpu, "LSETUP (%#x, %#x) LC%i = P%i;", spcrel, epcrel, c, reg);
      LCREG (c) = PREG (reg);
    }
  else if (rop == 3)
    {
      TRACE_INSN (cpu, "LSETUP (%#x, %#x) LC%i = P%i >> 1;", spcrel, epcrel, c, reg);
      LCREG (c) = PREG (reg) >> 1;
    }
  else
    illegal_instruction (cpu);
  LTREG (c) = PCREG + spcrel;
  LBREG (c) = PCREG + epcrel;

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
  bu32 *pval = get_allreg (cpu, grp, reg);
  bu32 val;
  const char *reg_name = get_allreg_name (grp, reg);

  TRACE_EXTRACT (cpu, "%s: Z:%i H:%i S:%i grp:%i reg:%i hword:%#x",
		 __func__, Z, H, S, grp, reg, hword);
  TRACE_DECODE (cpu, "%s: reg:%s", __func__, reg_name);

  /* XXX: writing RET{I,X,N,E}, USP, SEQSTAT, SYSCFG requires supervisor mode. */

  if (H == 0 && S == 1 && Z == 0)
    {
      val = imm16 (hword);
      TRACE_INSN (cpu, "%s = 0x%x (X);", reg_name, val);
      *pval = val;
    }
  else if (H == 0 && S == 0 && Z == 1)
    {
      val = luimm16 (hword);
      TRACE_INSN (cpu, "%s = 0x%x (Z);", reg_name, val);
      *pval = val;
    }
  else if (H == 0 && S == 0 && Z == 0)
    {
      val = luimm16 (hword);
      TRACE_INSN (cpu, "%s.L = 0x%x;", reg_name, val);
      *pval &= 0xFFFF0000;
      *pval |= val;
    }
  else if (H == 1 && S == 0 && Z == 0)
    {
      val = luimm16 (hword);
      TRACE_INSN (cpu, "%s.H = 0x%x;", reg_name, val);
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
  int pcrel = pcrel24 (((msw) << 16) | (lsw));
  bu32 newpc = PCREG + pcrel;

  TRACE_EXTRACT (cpu, "%s: S:%i msw:%#x lsw:%#x", __func__, S, msw, lsw);
  TRACE_DECODE (cpu, "%s: pcrel24:%#x", __func__, pcrel);

  TRACE_INSN (cpu, "%s %#x;", S ? "CALL" : "JUMP.L", pcrel);

  if (S == 1)
    {
      TRACE_BRANCH (cpu, "CALL to %#x", newpc);
      RETSREG = PCREG + 4;
    }
  else
    TRACE_BRANCH (cpu, "JUMP.L to %#x", newpc);

  PCREG += pcrel;
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

  TRACE_EXTRACT (cpu, "%s: W:%i Z:%i sz:%i ptr:%i reg:%i offset:%#x",
		 __func__, W, Z, sz, ptr, reg, offset);

  if (sz == 3)
    illegal_instruction (cpu);

  if (W == 0)
    {
      bu32 imm_16s4 = imm16s4 (offset);
      bu32 imm_16s2 = imm16s2 (offset);
      bu32 imm_16 = imm16 (offset);

      if (sz == 0 && Z == 0)
	{
	  TRACE_INSN (cpu, "R%i = [P%i + %#x];", reg, ptr, imm_16s4);
	  DREG (reg) = GET_LONG (PREG (ptr) + imm_16s4);
	}
      else if (sz == 0 && Z == 1)
	{
	  TRACE_INSN (cpu, "P%i = [P%i + %#x];", reg, ptr, imm_16s4);
	  PREG (reg) = GET_LONG (PREG (ptr) + imm_16s4);
	}
      else if (sz == 1 && Z == 0)
	{
	  TRACE_INSN (cpu, "R%i = W[P%i + %#x] (Z);", reg, ptr, imm_16s2);
	  DREG (reg) = GET_WORD (PREG (ptr) + imm_16s2);
	}
      else if (sz == 1 && Z == 1)
	{
	  TRACE_INSN (cpu, "R%i = W[P%i + %#x] (X);", reg, ptr, imm_16s2);
	  DREG (reg) = (bs32) (bs16) GET_WORD (PREG (ptr) + imm_16s2);
	}
      else if (sz == 2 && Z == 0)
	{
	  TRACE_INSN (cpu, "R%i = B[P%i + %#x] (Z);", reg, ptr, imm_16);
	  DREG (reg) = GET_BYTE (PREG (ptr) + imm_16);
	}
      else if (sz == 2 && Z == 1)
	{
	  TRACE_INSN (cpu, "R%i = B[P%i + %#x] (X);", reg, ptr, imm_16);
	  DREG (reg) = (bs32) (bs8) GET_BYTE (PREG (ptr) + imm_16);
	}
    }
  else
    {
      bu32 imm_16s4 = imm16s4 (offset);
      bu32 imm_16s2 = imm16s2 (offset);
      bu32 imm_16 = imm16 (offset);

      if (sz != 0 && Z != 0)
	illegal_instruction (cpu);

      if (sz == 0 && Z == 0)
	{
	  TRACE_INSN (cpu, "[P%i + %#x] = R%i;", ptr, imm_16s4, reg);
	  PUT_LONG (PREG (ptr) + imm_16s4, DREG (reg));
	}
      else if (sz == 0 && Z == 1)
	{
	  TRACE_INSN (cpu, "[P%i + %#x] = P%i;", ptr, imm_16s4, reg);
	  PUT_LONG (PREG (ptr) + imm_16s4, PREG (reg));
	}
      else if (sz == 1 && Z == 0)
	{
	  TRACE_INSN (cpu, "W[P%i + %#x] = R%i;", ptr, imm_16s2, reg);
	  PUT_WORD (PREG (ptr) + imm_16s2, DREG (reg));
	}
      else if (sz == 2 && Z == 0)
	{
	  TRACE_INSN (cpu, "B[P%i + %#x] = R%i;", ptr, imm_16, reg);
	  PUT_BYTE (PREG (ptr) + imm_16, DREG (reg));
	}
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

  TRACE_EXTRACT (cpu, "%s: R:%i framesize:%#x", __func__, R, framesize);

  if (R == 0)
    {
      bu32 sp = SPREG;
      int size = uimm16s4 (framesize);
      TRACE_INSN (cpu, "LINK %#x;", size);
      sp -= 4;
      PUT_LONG (sp, RETSREG);
      sp -= 4;
      PUT_LONG (sp, FPREG);
      FPREG = sp;
      sp -= size;
      SPREG = sp;
    }
  else
    {
      /* Restore SP from FP.  */
      bu32 sp = FPREG;
      TRACE_INSN (cpu, "UNLINK;");
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
     |.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1..|
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

  TRACE_EXTRACT (cpu, "%s: M:%i mmod:%i MM:%i P:%i w1:%i op1:%i h01:%i h11:%i "
		      "w0:%i op0:%i h00:%i h10:%i dst:%i src0:%i src1:%i",
		 __func__, M, mmod, MM, P, w1, op1, h01, h11, w0, op0, h00, h10,
		 dst, src0, src1);

  if (w0 == 0 && w1 == 0 && op1 == 3 && op0 == 3)
    illegal_instruction (cpu);

  if (op1 == 3 && MM)
    illegal_instruction (cpu);

  if (((1 << mmod) & (P ? 0x313 : 0x1b57)) == 0)
    unhandled_instruction (cpu, "dsp32mac");

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

  TRACE_EXTRACT (cpu, "%s: M:%i mmod:%i MM:%i P:%i w1:%i op1:%i h01:%i h11:%i "
		      "w0:%i op0:%i h00:%i h10:%i dst:%i src0:%i src1:%i",
		 __func__, M, mmod, MM, P, w1, op1, h01, h11, w0, op0, h00, h10,
		 dst, src0, src1);

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
  int M = ((iw0 >> 11) & 0x1);

  TRACE_EXTRACT (cpu, "%s: M:%i HL:%i aopcde:%i aop:%i s:%i x:%i dst0:%i "
		      "dst1:%i src0:%i src1:%i",
		 __func__, M, HL, aopcde, aop, s, x, dst0, dst1, src0, src1);

  if (aop == 0 && aopcde == 9 && HL == 0 && s == 0)
    {
      TRACE_INSN (cpu, "A0.L = R%i.L;", src0);
      A0WREG = REG_H_L (A0WREG, DREG (src0));
    }
  else if (aop == 2 && aopcde == 9 && HL == 1 && s == 0)
    {
      TRACE_INSN (cpu, "A1.H = R%i.H;", src0);
      A1WREG = REG_H_L (DREG (src0), A1WREG);
    }
  else if (aop == 2 && aopcde == 9 && HL == 0 && s == 0)
    {
      TRACE_INSN (cpu, "A1.L = R%i.L;", src0);
      A1WREG = REG_H_L (A1WREG, DREG (src0));
    }
  else if (aop == 0 && aopcde == 9 && HL == 1 && s == 0)
    {
      TRACE_INSN (cpu, "A0.H = R%i.H;", src0);
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
      ASTATREG (ac0_copy) = ASTATREG (ac0);
      if (HL)
	DREG (dst0) = (DREG (dst0) & 0xFFFF) | (val << 16);
      else
	DREG (dst0) = (DREG (dst0) & 0xFFFF0000) | val;
    }
  else if (aop == 0 && aopcde == 9 && s == 1)
    {
      TRACE_INSN (cpu, "A0 = R%i;", src0);
      A0WREG = DREG (src0);
      A0XREG = -(A0WREG >> 31);
    }
  else if (aop == 1 && aopcde == 9 && s == 0)
    {
      TRACE_INSN (cpu, "A0.X = R%i.L;", src0);
      A0XREG = (bs32)(bs8)DREG (src0);
    }
  else if (aop == 2 && aopcde == 9 && s == 1)
    {
      TRACE_INSN (cpu, "A1 = R%i;", src0);
      A1WREG = DREG (src0);
      A1XREG = -(A1WREG >> 31);
    }
  else if (aop == 3 && aopcde == 9 && s == 0)
    {
      TRACE_INSN (cpu, "A1.X = R%i.L;", src0);
      A1XREG = (bs32)(bs8)DREG (src0);
    }
  else if (aop == 3 && aopcde == 11 && (s == 0 || s == 1))
    {
      bu64 acc0 = get_extended_acc (cpu, 0);
      bu64 acc1 = get_extended_acc (cpu, 1);

      TRACE_INSN (cpu, "A0 -= A1;");

      acc0 -= acc1;
      if ((bs64)acc0 < -0x8000000000ll)
	acc0 = -0x8000000000ull;
      else if ((bs64)acc0 >= 0x7fffffffffll)
	acc0 = 0x7fffffffffull;
      STORE (A0XREG, (acc0 >> 32) & 0xff);
      STORE (A0WREG, acc0 & 0xffffffff);
      if (s == 1)
	{
	  /* A0 -= A1 (W32) */
	  if (acc0 & (bu64)0x8000000000)
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
      TRACE_INSN (cpu, "A%i = 0;", aop);
      AXREG (aop) = 0;
      AWREG (aop) = 0;
    }
  else if (aop == 2 && s == 0 && aopcde == 8)
    {
      TRACE_INSN (cpu, "A1 = A0 = 0;");
      A1XREG = A0XREG = 0;
      A1WREG = A0WREG = 0;
    }
  else if ((aop == 0 || aop == 1) && s == 1 && aopcde == 8)
    {
      TRACE_INSN (cpu, "A%i = A%i (S);", aop, aop);
      AXREG (aop) = -(AWREG (aop) >> 31);
    }
  else if (aop == 2 && s == 1 && aopcde == 8)
    {
      TRACE_INSN (cpu, "A1 = A1 (S) , A0 = A0 (S);");
      A0XREG = -(A0WREG >> 31);
      A1XREG = -(A1WREG >> 31);
    }
  else if (aop == 3 && (s == 0 || s == 1) && aopcde == 8)
    {
      TRACE_INSN (cpu, "A%i = A%i;", s, !s);
      AXREG (s) = AXREG (!s);
      AWREG (s) = AWREG (!s);
    }
  else if (aop == 3 && HL == 0 && aopcde == 16)
    {
      int i;
      TRACE_INSN (cpu, "A1 = ABS A1 , A0 = ABS A0;");
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
      bu32 aw = AWREG (aop);
      bu8 ax = AXREG (aop);
      TRACE_INSN (cpu, "A%i = ABS A%i;", HL, aop);
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
      bu32 val = (DREG (src0) & 0x7FFFFFFF);
      TRACE_INSN (cpu, "R%i.L = R%i (RND);", src0, dst0);

      val += 0x8000;

      DREG (dst0) = (DREG (dst0) & 0xFFFF0000) |
		    (val >> 16) |
		    ((DREG (src0) & 0x80000000) >> 16);
      /* XXX: ASTAT ? */
    }
  else if (aop == 3 && HL == 0 && aopcde == 15)
    {
      bu32 hi = (-(bs16)(DREG (src0) >> 16)) << 16;
      bu32 lo = (-(bs16)(DREG (src0) & 0xFFFF)) & 0xFFFF;

      TRACE_INSN (cpu, "R%i = -R%i (V);", dst0, src0);

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
      TRACE_INSN (cpu, "A1 = - A1 , A0 = - A0;");
      AWREG (0) = -AWREG (0);
      AXREG (0) = -AXREG (0);
      AWREG (1) = -AWREG (1);
      AXREG (1) = -AXREG (1);
      /* XXX: what ASTAT flags need updating ?  */
    }
  else if (HL == 1 && aop == 3 && aopcde == 12)
    {
      bu32 val = (DREG (src0) & 0x7FFFFFFF);
      TRACE_INSN (cpu, "R%i.H = R%i (RND);", src0, dst0);

      val += 0x8000;

      DREG (dst0) = (DREG (dst0) & 0xFFFF) |
		    (val & 0x7FFF0000) |
		    (DREG (src0) & 0x80000000);
      /* XXX: what ASTAT flags need updating ?  */
    }
  else if (aop == 0 && aopcde == 23 && HL == 0)
    unhandled_instruction (cpu, "dregs = BYTEOP3P (dregs_pair, dregs_pair) (LO,R)");
  else if ((aop == 0 || aop == 1) && (HL == 0 || HL == 1) && aopcde == 14)
    {
      bu32 aw = AWREG (aop);
      bu32 ax = AXREG (aop);
      TRACE_INSN (cpu, "A%i = - A%i;", HL, aop);
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
      bu32 s0 = DREG (src0);
      bu32 s1 = DREG (src1);
      bu32 s0h = s0 >> 16;
      bu32 s0l = s0 & 0xFFFF;
      bu32 s1h = s1 >> 16;
      bu32 s1l = s1 & 0xFFFF;
      bu32 t0, t1;
      TRACE_INSN (cpu, "R%i = R%i +-|+- R%i (amod0);", dst0, src0, src1);
      if (aop & 2)
	t0 = sub16 (cpu, s0h, s1h, &ASTATREG (ac1), s);
      else
	t0 = add16 (cpu, s0h, s1h, &ASTATREG (ac1), s);
      if (aop & 1)
	t1 = sub16 (cpu, s0l, s1l, &ASTATREG (ac0), s);
      else
	t1 = add16 (cpu, s0l, s1l, &ASTATREG (ac0), s);
      ASTATREG (ac0_copy) = ASTATREG (ac0);
      t0 &= 0xFFFF;
      t1 &= 0xFFFF;
      if (x)
	DREG (dst0) = (t1 << 16) | t0;
      else
	DREG (dst0) = (t0 << 16) | t1;
    }
  else if (aop == 1 && aopcde == 12)
    {
      bu32 val0 = ((A0WREG & 0xFFFF0000) >> 16) + (A0WREG & 0xFFFF);
      bu32 val1 = ((A1WREG & 0xFFFF0000) >> 16) + (A1WREG & 0xFFFF);

      TRACE_INSN (cpu, "R%i = A1.L + A1.H, R%i = A0.L + A0.H;", dst1, dst0);

      if (val0 & 0x8000)
	val0 |= 0xFFFF0000;

      if (val1 & 0x8000)
	val1 |= 0xFFFF0000;

      DREG (dst0) = val0;
      DREG (dst1) = val1;
      /* ASTAT ? */
    }
  else if (HL == 0 && aopcde == 1)
    {
      if (aop == 0)
	{
	  /* dregs = dregs +|+ dregs, dregs = dregs -|- dregs (amod0) */
	  bu32 d0, d1;
	  TRACE_INSN (cpu, "R%i = R%i +|+ R%i, R%i = R%i -|- R%i (amod0);",
		      dst1, src0, src1, dst0, src0, src1);
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
      bu64 acc0 = get_extended_acc (cpu, 0);
      bu64 acc1 = get_extended_acc (cpu, 1);

      TRACE_INSN (cpu, "A0 += A1;");

      acc0 += acc1;
      if ((bs64)acc0 < -0x8000000000ll)
	acc0 = -0x8000000000ull;
      else if ((bs64)acc0 >= 0x7fffffffffll)
	acc0 = 0x7fffffffffull;
      STORE (A0XREG, (acc0 >> 32) & 0xff);
      STORE (A0WREG, acc0 & 0xffffffff);
      if (aop == 2 && s == 1)
	{ /* A0 += A1 (W32) */
	  if (acc0 & (bu64)0x8000000000)
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
  else if ((aop == 0 || aop == 1) && aopcde == 10)
    {
      TRACE_INSN (cpu, "R%i = A%i.x;", dst0, aop);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= AXREG(aop) & 0xFFFF;
    }
  else if (aop == 0 && aopcde == 4)
    {
      TRACE_INSN (cpu, "R%i = R%i + R%i;", dst0, src0, src1);
      DREG (dst0) = add32 (cpu, DREG (src0), DREG (src1), 1, s);
    }
  else if (aop == 1 && aopcde == 4)
    {
      TRACE_INSN (cpu, "R%i = R%i - R%i;", dst0, src0, src1);
      DREG (dst0) = sub32 (cpu, DREG (src0), DREG (src1), 1, s);
    }
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
    {
      TRACE_INSN (cpu, "R%i = MIN (R%i, R%i);", dst0, src0, src1);
      DREG (dst0) = min32 (cpu, DREG (src0), DREG (src1));
    }
  else if (aop == 0 && aopcde == 7)
    {
      TRACE_INSN (cpu, "R%i = MAX (R%i, R%i);", dst0, src0, src1);
      DREG (dst0) = max32 (cpu, DREG (src0), DREG (src1));
    }
  else if (aop == 2 && aopcde == 7)
    {
      bu32 val = DREG (src0);
      TRACE_INSN (cpu, "R%i = ABS R%i;", dst0, src0);
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
      TRACE_INSN (cpu, "R%i = - R%i (opt_sat);", dst0, src0);
      ASTATREG (v) = ASTATREG (v_copy) = (val == 0x8000);
      ASTATREG (vs) |= ASTATREG (v);
      if (val == 0x80000000)
	val = 0x7fffffff;
      else
	val = -val;
      setflags_logical (cpu, val);
      DREG (dst0) = val;
    }
  else if (aop == 2 && aopcde == 6)
    {
      bu32 in = DREG (src0);
      bu32 hi = (in & 0x80000000 ? -(bs16)(in >> 16) : in >> 16) << 16;
      bu32 lo = (in & 0x8000 ? -(bs16)(in & 0xFFFF) : in) & 0xFFFF;

      TRACE_INSN (cpu, "R%i = ABS R%i (V);", dst0, src0);

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
    {
      TRACE_INSN (cpu, "R%i = MIN (R%i, R%i);", dst0, src0, src1);
      DREG (dst0) = min2x16 (cpu, DREG (src0), DREG (src1));
    }
  else if (aop == 0 && aopcde == 6)
    {
      TRACE_INSN (cpu, "R%i = MAX (R%i, R%i);", dst0, src0, src1);
      DREG (dst0) = max2x16 (cpu, DREG (src0), DREG (src1));
    }
  else if (HL == 1 && aopcde == 1)
    unhandled_instruction (cpu, "dregs = dregs +|- dregs, dregs = dregs -|+ dregs (amod0, amod2)");
  else if (aop == 0 && aopcde == 24)
    {
      TRACE_INSN (cpu, "R%i = BYTEPACK (R%i, R%i);", dst0, src0, src1);
      DREG (dst0) =
	(((DREG (src0) >>  0) & 0xff) <<  0) |
	(((DREG (src0) >> 16) & 0xff) <<  8) |
	(((DREG (src1) >>  0) & 0xff) << 16) |
	(((DREG (src1) >> 16) & 0xff) << 24);
    }
  else if (aop == 1 && aopcde == 24)
    {
      int order, lo, hi;
      bu64 comb_src;
      bu8 bytea, byteb, bytec, byted;

      TRACE_INSN (cpu, "(R%i, R%i) = BYTEUNPACK R%i:%i%s;",
		  dst1, dst0, src0 + 1, src0, s ? " (R)" : "");

      order = IREG (0) & 0x3;
      if (s)
	hi = src0, lo = src0 + 1;
      else
	hi = src0 + 1, lo = src0;
      comb_src = (((bu64)DREG (hi)) << 32) | DREG (lo);
      bytea = (comb_src >> (0 + 8 * order));
      byteb = (comb_src >> (8 + 8 * order));
      bytec = (comb_src >> (16 + 8 * order));
      byted = (comb_src >> (24 + 8 * order));
      DREG (dst0) = bytea | ((bu32)byteb << 16);
      DREG (dst1) = bytec | ((bu32)byted << 16);
    }
  else if (aopcde == 13)
    {
      const char *searchmodes[] = { "GT", "GE", "LT", "LE" };
      bool up_hi, up_lo;
      bs16 a0_lo, a1_lo, src_hi, src_lo, dst_hi, dst_lo;

      TRACE_INSN (cpu, "(R%i, R%i) = SEARCH R%i (%s);",
		  dst1, dst0, src0, searchmodes[aop]);

      up_hi = up_lo = false;
      a0_lo = AWREG (0);
      a1_lo = AWREG (1);
      src_lo = DREG (src0);
      src_hi = DREG (src0) >> 16;

      switch (aop)
	{
	case 0:
	  up_hi = (src_hi > a1_lo);
	  up_lo = (src_lo > a0_lo);
	  break;
	case 1:
	  up_hi = (src_hi >= a1_lo);
	  up_lo = (src_lo >= a0_lo);
	  break;
	case 2:
	  up_hi = (src_hi < a1_lo);
	  up_lo = (src_lo < a0_lo);
	  break;
	case 3:
	  up_hi = (src_hi <= a1_lo);
	  up_lo = (src_lo <= a0_lo);
	  break;
	}

      if (up_hi)
	{
	  AWREG (1) = REG_H_L (AWREG (1), src_hi);
	  DREG (dst1) = PREG (0);
	}
      if (up_lo)
	{
	  AWREG (0) = REG_H_L (AWREG (0), src_lo);
	  DREG (dst0) = PREG (0);
	}
    }
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
  int M = ((iw0 >> 11) & 0x1);
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);

  TRACE_EXTRACT (cpu, "%s: M:%i sopcde:%i sop:%i HLs:%i dst0:%i src0:%i src1:%i",
		__func__, M, sopcde, sop, HLs, dst0, src0, src1);

  if ((sop == 0 || sop == 1) && sopcde == 0)
    {
      /* HLs == 0 : dregs_lo = ASHIFT dregs_lo BY dregs_lo
       * HLs == 1 : dregs_lo = ASHIFT dregs_hi BY dregs_lo
       * HLs == 2 : dregs_hi = ASHIFT dregs_lo BY dregs_lo
       * HLs == 3 : dregs_hi = ASHIFT dregs_hi BY dregs_lo
       * if sop == 1, then saturate, otherwise not
       */
      bu16 val;
      bs32 shft = (bs8)(DREG (src0) << 2) >> 2;

      if ((HLs & 1) == 0)
	val = (bu16)(DREG (src1) & 0xFFFF);
      else
	val = (bu16)((DREG (src1) & 0xFFFF0000) >> 16);

      /* Positive shift magnitudes produce Logical Left shifts.
       * Negative shift magnitudes produce Arithmetic Right shifts.
       */
      if (shft <= 0)
	val = ashiftrt (cpu, val, -shft, 16);
      else
	val = lshift (cpu, val, shft, 16, sop == 1);

      if ((HLs & 2) == 0)
	STORE (DREG (dst0), DREG (dst0) & 0xFFFF0000 | val);
      else
	STORE (DREG (dst0), DREG (dst0) & 0xFFFF | (val << 16));
    }
  else if (sop == 2 && sopcde == 0)
    {
      /* HLs == 0  dregs_lo = LSHIFT dregs_lo BY dregs_lo
       * HLs == 1  dregs_lo = LSHIFT dregs_hi BY dregs_lo
       * HLs == 2  dregs_hi = LSHIFT dregs_lo BY dregs_lo
       * HLs == 3  dregs_hi = LSHIFT dregs_hi BY dregs_lo
       */
      bs32 shft = (bs8)(DREG (src0) << 2) >> 2;
      bu16 val;

      if ((HLs & 1) == 0)
	val = (bu16)(DREG (src1) & 0xFFFF);
      else
	val = (bu16)((DREG (src1) & 0xFFFF0000) >> 16);

      if (shft < 0)
	val = val >> (-1 * shft);
      else
	val = val << shft;

      if ((HLs & 2) == 0)
	DREG (dst0) = DREG (dst0) & 0xFFFF0000 | val;
      else
	DREG (dst0) = DREG (dst0) & 0xFFFF | (val << 16);

      /* XXX: ASTAT */
    }
  else if (sop == 2 && sopcde == 3 && HLs == 1)
    {
      /* HLs == 1 : A1 = ROT A1 BY dregs_lo
       * HLs == 0 : A0 = ROT A0 BY dregs_lo
       */
      unhandled_instruction (cpu, "An = ROT An BY dregs_lo");
    }
  else if (sop == 0 && sopcde == 3 && (HLs == 0 || HLs == 1))
    {
      /* HLs == 0 : A0 = ASHIFT A0 BY dregs_lo
       * HLs == 1 : A1 = ASHIFT A1 BY dregs_lo
       */
      bs32 shft = (bs8)(DREG (src0) << 2) >> 2;
      bu64 val;

      HLs = !!HLs;
      val = get_extended_acc (cpu, HLs);

      if (shft <= 0)
	val = ashiftrt (cpu, val, -shft, 40);
      else
	val = lshift (cpu, val, shft, 40, 0);

      STORE (AXREG (HLs), (val >> 32) & 0xff);
      STORE (AWREG (HLs), (val & 0xffffffff));
    }
  else if (sop == 1 && sopcde == 3 && (HLs == 0 || HLs == 1))
    {
      /* HLs == 0 : A0 = LSHIFT A0 BY dregs_lo
       * HLs == 1 : A1 = LSHIFT A1 BY dregs_lo
       */
      bs32 shft = (bs8)(DREG (src0) << 2) >> 2;
      bu64 val;

      HLs = !!HLs;
      val = get_extended_acc (cpu, HLs);

      if (shft <= 0)
	val = lshiftrt (cpu, val, -shft, 40);
      else
	val = lshift (cpu, val, shft, 40, 0);

      STORE (AXREG (HLs), (val >> 32) & 0xff);
      STORE (AWREG (HLs), (val & 0xffffffff));
    }
  else if ((sop == 0 || sop == 1) && sopcde == 1)
    {
      /* sop == 0 : dregs = ASHIFT dregs BY dregs_lo (V)
       * sop == 1 : dregs = ASHIFT dregs BY dregs_lo (V,S)
       */
      bs32 shft = (bs8)(DREG (src0) << 2) >> 2;
      bu16 val0, val1;

      val0 = (bu16)DREG (src1) & 0xFFFF;
      val1 = (bu16)((DREG (src1) & 0xFFFF0000) >> 16);

      if (shft <= 0)
	{
	  val0 = ashiftrt (cpu, val0, -shft, 16);
	  val1 = ashiftrt (cpu, val1, -shft, 16);
	}
      else
	{
	  val0 = lshift (cpu, val0, shft, 16, sop == 1);
	  val1 = lshift (cpu, val1, shft, 16, sop == 1);
	}
      STORE (DREG (dst0), (val1 << 16) | val0);
    }
  else if ((sop == 0 || sop == 1 || sop == 2) && sopcde == 2)
    {
      /* dregs = [LA]SHIFT dregs BY dregs_lo (opt_S) */
      /* sop == 1 : opt_S */
      bu32 v = DREG (src1);
      /* LSHIFT uses sign extended low 6 bits of dregs_lo.  */
      bs32 shft = (bs8)(DREG (src0) << 2) >> 2;
      if (shft < 0)
	{
	  if (sop == 2)
	    STORE (DREG (dst0), lshiftrt (cpu, v, -shft, 32));
	  else
	    STORE (DREG (dst0), ashiftrt (cpu, v, -shft, 32));
	}
      else
	STORE (DREG (dst0), lshift (cpu, v, shft, 32, sop == 1));
    }
  else if (sop == 3 && sopcde == 2)
    {
      int t = imm6 (DREG (src0) & 0xFFFF);

      TRACE_INSN (cpu, "R%i = ROT R%i BY R%i.L;", dst0, src1, src0);

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
    {
      bs32 shft = (bs8)(DREG (src0) << 2) >> 2;
      bu16 val0, val1;

      TRACE_INSN (cpu, "R%i = LSHIFT R%i BY R%i.L (V);", dst0, src1, src0);

      val0 = (bu16)DREG (src1) & 0xFFFF;
      val1 = (bu16)((DREG (src1) & 0xFFFF0000) >> 16);

      if (shft <= 0)
	{
	  val0 = lshiftrt (cpu, val0, -shft, 16);
	  val1 = lshiftrt (cpu, val1, -shft, 16);
	}
      else
	{
	  val0 = lshift (cpu, val0, shft, 16, 0);
	  val1 = lshift (cpu, val1, shft, 16, 0);
	}
      STORE (DREG (dst0), (val1 << 16) | val0);
    }
  else if (sopcde == 4)
    {
      bu32 sv0 = DREG (src0);
      bu32 sv1 = DREG (src1);
      TRACE_INSN (cpu, "R%i = PACK (R%i.%c, R%i.%c);", dst0,
		  src1, sop & 2 ? 'H' : 'L',
		  src0, sop & 1 ? 'H' : 'L');
      if (sop & 1)
	sv0 >>= 16;
      if (sop & 2)
	sv1 >>= 16;
      DREG (dst0) = (sv1 << 16) | (sv0 & 0xFFFF);
    }
  else if (sop == 0 && sopcde == 5)
    {
      bu32 sv1 = DREG (src1);
      TRACE_INSN (cpu, "R%i.L = SIGNBITS R%i;", dst0, src1);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= signbits (sv1, 32);
    }
  else if (sop == 1 && sopcde == 5)
    {
      bu32 sv1 = DREG (src1);
      TRACE_INSN (cpu, "R%i.L = SIGNBITS R%i.L;", dst0, src1);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= signbits (sv1, 16);
    }
  else if (sop == 2 && sopcde == 5)
    {
      bu32 sv1 = DREG (src1);
      TRACE_INSN (cpu, "R%i.L = SIGNBITS R%i.H;", dst0, src1);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= signbits (sv1 >> 16, 16);
    }
  else if ((sop == 0 || sop == 1) && sopcde == 6)
    {
      bu64 acc = AXREG (sop);
      TRACE_INSN (cpu, "R%i.L = SIGNBITS A%i;", dst0, sop);
      acc <<= 32;
      acc |= AWREG (sop);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= (signbits (acc, 40) & 0xFFFF);
    }
  else if (sop == 3 && sopcde == 6)
    {
      bu32 v = ones (DREG (src1));
      TRACE_INSN (cpu, "R%i.L = ONES R%i;", dst0, src1);
      DREG (dst0) &= 0xFFFF0000;
      DREG (dst0) |= v;
    }
  else if (sop == 0 && sopcde == 7)
    {
      bu16 sv1 = (bu16)signbits(DREG (src1), 32);
      bu16 sv0 = (bu16)(DREG (src0) & 0xffff);

      TRACE_INSN (cpu, "R%i.L = EXPADJ (R%i, R%i.L);", dst0, src1, src0);

      DREG (dst0) &= 0xFFFF0000;

      if ((sv1 & 0x1f) < (sv0 & 0x1f))
	DREG (dst0) |= sv1;
      else
	DREG (dst0) |= sv0;
    }
  else if (sop == 1 && sopcde == 7)
    {
      /*
       * Exponent adjust on two 16-bit inputs. Select smallest norm
       * among 3 inputs
       */
      bs16 src1_hi = (DREG (src1) & 0xFFFF0000) >> 16;
      bs16 src1_lo = (DREG (src1) & 0xFFFF);
      bu16 src0_lo = (DREG (src0) & 0xFFFF);
      bu16 tmp_hi, tmp_lo;

      TRACE_INSN (cpu, "R%i.L = EXPADJ (R%i, R%i.L) (V);", dst0, src1, src0);

      tmp_hi = signbits(src1_hi, 16);
      tmp_lo = signbits(src1_lo, 16);
      DREG (dst0) &= 0xFFFF0000;

      if ((tmp_hi & 0xf) < (tmp_lo & 0xf))
	if ((tmp_hi & 0xf) < (src0_lo & 0xf))
	  DREG (dst0) |= tmp_hi;
	else
	  DREG (dst0) |= src0_lo;
      else
	if ((tmp_lo & 0xf)  < (src0_lo & 0xf))
	  DREG (dst0) |= tmp_lo;
	else
	  DREG (dst0) |= src0_lo;
    }
  else if (sop == 2 && sopcde == 7)
    {
      /*
       * exponent adjust on single 16-bit register
       */
      bu16 tmp;
      bu16 src0_lo = (bu16)(DREG (src0) & 0xFFFF);

      TRACE_INSN (cpu, "R%i.L = EXPADJ (R%i.L, R%i.L);", dst0, src1, src0);

      tmp = signbits(DREG (src1) & 0xFFFF, 16);
      DREG (dst0) &= 0xFFFF0000;

      if ((tmp & 0xf) < (src0_lo & 0xf))
	DREG (dst0) |= tmp;
      else
	DREG (dst0) |= src0_lo;
    }
  else if (sop == 3 && sopcde == 7)
    {
      bu16 tmp;
      bu16 src0_lo = (bu16)(DREG (src0) & 0xFFFF);

      TRACE_INSN (cpu, "R%i.L = EXPADJ (R%i.H, R%i.L);", dst0, src1, src0);

      tmp = signbits((DREG (src1) & 0xFFFF0000) >> 16, 16);
      DREG (dst0) &= 0xFFFF0000;

      if ((tmp & 0xf) < (src0_lo & 0xf))
	DREG (dst0) |= tmp;
      else
	DREG (dst0) |= src0_lo;
    }
  else if (sop == 0 && sopcde == 8)
    {
      bu64 acc = get_unextended_acc (cpu, 0);

      TRACE_INSN (cpu, "BITMUX (R%i, R%i, A0) (ASR);", src0, src1);

      acc = (acc >> 2) |
	(((bu64)DREG (src0) & 1) << 38) |
	(((bu64)DREG (src1) & 1) << 39);
      DREG (src0) >>= 1;
      DREG (src1) >>= 1;

      A0XREG = (acc >> 32) & 0xff;
      A0WREG = acc;
    }
  else if (sop == 1 && sopcde == 8)
    {
      bu64 acc = get_unextended_acc (cpu, 0);

      TRACE_INSN (cpu, "BITMUX (R%i, R%i, A0) (ASL);", src0, src1);

      acc = (acc << 2) |
	((DREG (src0) >> 31) & 1) |
	((DREG (src1) >> 30) & 2);
      DREG (src0) <<= 1;
      DREG (src1) <<= 1;

      A0XREG = (acc >> 32) & 0xff;
      A0WREG = acc;
    }
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
      bu32 v = DREG (src0);
      bu32 x = DREG (src1);
      bu32 mask = (1 << (v & 0x1f)) - 1;
      TRACE_INSN (cpu, "R%i = EXTRACT (R%i, R%i.L) (Z);", dst0, src1, src0);
      x >>= ((v >> 8) & 0x1f);
      DREG (dst0) = x & mask;
      setflags_logical (cpu, DREG (dst0));
    }
  else if (sop == 1 && sopcde == 10)
    {
      bu32 v = DREG (src0);
      bu32 x = DREG (src1);
      bu32 sgn = (1 << (v & 0x1f)) >> 1;
      bu32 mask = (1 << (v & 0x1f)) - 1;
      TRACE_INSN (cpu, "R%i = EXTRACT (R%i, R%i.L) (X);", dst0, src1, src0);
      x >>= ((v >> 8) & 0x1f);
      x &= mask;
      if (x & sgn)
	x |= ~mask;
      DREG (dst0) = x;
      setflags_logical (cpu, DREG (dst0));
    }
  else if ((sop == 2 || sop == 3) && sopcde == 10)
    {
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
      TRACE_INSN (cpu, "R%i = DEPOSIT (R%i, R%i)%s;", dst0, src1, src0,
		  sop == 3 ? " (X)" : "");
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
    {
      bu64 acc0 = get_unextended_acc (cpu, 0);

      TRACE_INSN (cpu, "R%i.L = CC = BXORSHIFT (A0, R%i);", dst0, src0);

      acc0 <<= 1;
      CCREG = xor_reduce (acc0, DREG (src0));
      DREG (dst0) = REG_H_L (DREG (dst0), CCREG);
      A0XREG = (acc0 >> 32) & 0xff;
      A0WREG = acc0;
    }
  else if (sop == 1 && sopcde == 11)
    {
      bu64 acc0 = get_unextended_acc (cpu, 0);

      TRACE_INSN (cpu, "R%i.L = CC = BXOR (A0, R%i);", dst0, src0);

      CCREG = xor_reduce (acc0, DREG (src0));
      DREG (dst0) = REG_H_L (DREG (dst0), CCREG);
    }
  else if (sop == 0 && sopcde == 12)
    {
      bu64 acc0 = get_unextended_acc (cpu, 0);
      bu64 acc1 = get_unextended_acc (cpu, 1);

      TRACE_INSN (cpu, "A0 = BXORSHIFT (A0, A1, CC);");

      acc0 = (acc0 << 1) | (CCREG ^ xor_reduce (acc0, acc1));
      A0XREG = (acc0 >> 32) & 0xff;
      A0WREG = acc0;
    }
  else if (sop == 1 && sopcde == 12)
    {
      bu64 acc0 = get_unextended_acc (cpu, 0);
      bu64 acc1 = get_unextended_acc (cpu, 1);

      TRACE_INSN (cpu, "R%i.L = CC = BXOR (A0, A1, CC);", dst0);

      CCREG ^= xor_reduce (acc0, acc1);
      acc0 = (acc0 << 1) | CCREG;
      DREG (dst0) = REG_H_L (DREG (dst0), CCREG);
    }
  else if ((sop == 0 || sop == 1 || sop == 2) && sopcde == 13)
    {
      int shift = (sop + 1) * 8;
      TRACE_INSN (cpu, "R%i = ALIGN%i (R%i, R%i);", dst0, shift, src1, src0);
      DREG (dst0) = (DREG (src1) << (32 - shift)) | (DREG (src0) >> shift);
    }
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
  int M = ((iw0 >> 11) & 0x1);
  int sopcde = ((iw0 >> 0) & 0x1f);
  int HLs = ((iw1 >> 12) & 0x3);
  int bit8 = immag >> 5;

  TRACE_EXTRACT (cpu, "%s: M:%i sopcde:%i sop:%i HLs:%i dst0:%i immag:%#x src1:%i",
		 __func__, M, sopcde, sop, HLs, dst0, immag, src1);

  if (sopcde == 0)
    {
      bu16 in = DREG (src1) >> ((HLs & 1) ? 16 : 0);
      bu16 result;
      bu32 v;
      if (sop == 0)
	/* dregs_hi/lo = dregs_hi/lo >>> imm4 */
	/* XXX: TRACE_INSN (cpu, "???"); */
	result = ashiftrt (cpu, in, newimmag, 16);
      else if (sop == 1 && bit8 == 0)
	/*  dregs_hi/lo = dregs_hi/lo << imm4 (S) */
	result = lshift (cpu, in, immag, 16, 1);
      else if (sop == 1 && bit8)
	/* dregs_hi/lo = dregs_hi/lo >>> imm4 (S) */
	result = lshift (cpu, in, immag, 16, 1);
      else if (sop == 2 && bit8)
	/* dregs_hi/lo = dregs_hi/lo >> imm4 */
	result = lshiftrt (cpu, in, newimmag, 16);
      else if (sop == 2 && bit8 == 0)
	/* dregs_hi/lo = dregs_hi/lo << imm4 */
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
      /* Arithmetic shift, so shift in sign bit copies.  */
      bu64 acc;
      int shift = uimm5 (newimmag);
      HLs = !!HLs;

      TRACE_INSN (cpu, "A%i = A%i >>> %i;", HLs, HLs, shift);

      acc = get_extended_acc (cpu, HLs);
      acc >>= shift;
      /* Sign extend again.  */
      if (acc & (1ULL << 39))
	acc |= -(1ULL << 39);
      else
	acc &= ~(-(1ULL << 39));

      STORE (AXREG (HLs), (acc >> 32) & 0xFF);
      STORE (AWREG (HLs), acc & 0xFFFFFFFF);
    }
  else if ((sop == 0 && sopcde == 3 && bit8 == 0)
	   || (sop == 1 && sopcde == 3))
    {
      bu64 acc;
      int shiftup = uimm5 (immag);
      int shiftdn = uimm5 (newimmag);
      HLs = !!HLs;

      TRACE_INSN (cpu, "A%i = A%i %s %i;", HLs, HLs,
		  sop == 0 ? "<<" : ">>",
		  sop == 0 ? shiftup : shiftdn);

      acc = AXREG (HLs);
      /* Logical shift, so shift in zeroes.  */
      acc &= 0xFF;
      acc <<= 32;
      acc |= AWREG (HLs);

      if (sop == 0)
	acc <<= shiftup;
      else
	acc >>= shiftdn;

      AXREG (HLs) = (acc >> 32) & 0xFF;
      AWREG (HLs) = acc;
    }
  else if (sop == 2 && sopcde == 3 && HLs == 0)
    unhandled_instruction (cpu, "A0 = ROT A0 BY imm6");
  else if (sop == 1 && sopcde == 1 && bit8 == 0)
    {
      /* dregs = dregs << uimm5 (V,S) */
      int count = imm5 (immag);
      bu16 val0 = DREG (src1) >> 16;
      bu16 val1 = DREG (src1) & 0xFFFF;

      val0 = lshift (cpu, val0, count, 16, 1);
      val1 = lshift (cpu, val1, count, 16, 1);

      STORE (DREG (dst0), (val0 << 16) | val1);
    }
  else if (sop == 1 && sopcde == 1 && bit8 == 1)
    {
      /* dregs = dregs >>> uimm5 (V,S) */
      unhandled_instruction (cpu, "dregs = dregs >>> uimm5 (V,S)");
    }
  else if (sop == 2 && sopcde == 1 && bit8 == 1)
    {
      /* dregs = dregs >> uimm5 (V) */
      int count = imm5 (newimmag);
      bu16 val0 = DREG (src1) & 0xFFFF;
      bu16 val1 = DREG (src1) >> 16;

      TRACE_INSN (cpu, "R%i = R%i >> %i (V);", dst0, src1, count);
      val0 = lshiftrt (cpu, val0, count, 16);
      val1 = lshiftrt (cpu, val1, count, 16);

      STORE (DREG (dst0), val0 | (val1 << 16));
    }
  else if (sop == 2 && sopcde == 1 && bit8 == 0)
    {
      /* dregs = dregs << uimm5 (V) */
      int count = imm5 (immag);
      bu16 val0 = DREG (src1) & 0xFFFF;
      bu16 val1 = DREG (src1) >> 16;

      TRACE_INSN (cpu, "R%i = R%i << %i (V);", dst0, src1, count);
      val0 = lshift (cpu, val0, count, 16, 0);
      val1 = lshift (cpu, val1, count, 16, 0);

      STORE (DREG (dst0), val0 | (val1 << 16));
    }
  else if (sop == 0 && sopcde == 1)
    {
      int i, count = uimm5 (newimmag);
      bu32 val_l = 0, val_h = 0;

      TRACE_INSN (cpu, "R%i = R%i >>> %i (V);", dst0, src1, count);

      for (i = 0; i < count; i++)
	{
	  val_l |= (val_l | (DREG (src1) & 0x8000    )) >> 1;
	  val_h |= (val_h | (DREG (src1) & 0x80000000)) >> 1;
	}
      val_l |= DREG (src1) & 0x8000;
      val_h |= DREG (src1) & 0x80000000;

      DREG (dst0) = ((DREG (src1) & 0xFFFF) >> count) |
		    ((DREG (src1) >> count) & 0xFFFF0000) |
		    val_l | val_h;

      /* XXX: ASTAT? */
    }
  else if (sop == 1 && sopcde == 2)
    {
      int count = imm6 (immag);

      TRACE_INSN (cpu, "R%i = R%i << %i (S);", dst0, src1, count);

      if (count >= 0)
	STORE (DREG (dst0), lshift (cpu, DREG (src1), count, 32, 1));
      else
	unhandled_instruction (cpu, "dregs = dregs << imm6 (S)");
    }
  else if (sop == 2 && sopcde == 2)
    {
      int count = imm6 (newimmag);

      TRACE_INSN (cpu, "R%i = R%i >> %i;", dst0, src1, count);

      if (count < 0)
	STORE (DREG (dst0), lshift (cpu, DREG (src1), -count, 32, 0));
      else
	STORE (DREG (dst0), lshiftrt (cpu, DREG (src1), count, 32));
    }
  else if (sop == 3 && sopcde == 2)
    {
      int t = imm6 (immag);

      TRACE_INSN (cpu, "R%i = ROT R%i BY %i;", dst0, src1, t);

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

      TRACE_INSN (cpu, "R%i = R%i >>> %i;", dst0, src1, count);

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
outc (char ch)
{
  printf ("%c", ch);
  if (ch == '\n')
    fflush (stdout);
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

  TRACE_EXTRACT (cpu, "%s: fn:%i grp:%i reg:%i", __func__, fn, grp, reg);

  if (reg == 0 && fn == 3)
    unhandled_instruction (cpu, "DBG A0");
  else if (reg == 1 && fn == 3)
    unhandled_instruction (cpu, "DBG A1");
  else if (reg == 3 && fn == 3)
    {
      TRACE_INSN (cpu, "ABORT;");
      cec_exception (cpu, VEC_SIM_ABORT);
      DREG (0) = 1;
    }
  else if (reg == 4 && fn == 3)
    {
      TRACE_INSN (cpu, "HLT;");
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
    {
      TRACE_INSN (cpu, "OUTC R%i;", reg);
      outc (DREG (reg));
    }
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
  int ch = ((iw0 >> 0) & 0xff);

  TRACE_EXTRACT (cpu, "%s: ch:%#x", __func__, ch);
  TRACE_INSN (cpu, "OUTC %#x;", ch);

  outc (ch);

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
  bu16 actual;
  bu16 expected = ((iw1 >> 0) & 0xffff);
  int dbgop = ((iw0 >> 6) & 0x3);
  int grp = ((iw0 >> 3) & 0x7);
  int regtest = ((iw0 >> 0) & 0x7);
  bu32 *reg = get_allreg (cpu, grp, regtest);
  const char *reg_name = get_allreg_name (grp, regtest);
  const char *dbg_name, *dbg_appd;

  TRACE_EXTRACT (cpu, "%s: dbgop:%i grp:%i regtest:%i expected:%#x",
		 __func__, dbgop, grp, regtest, expected);

  if (dbgop == 0 || dbgop == 2)
    {
      dbg_name = dbgop == 0 ? "DBGA" : "DBGAL";
      dbg_appd = dbgop == 0 ? ".L" : "";
      actual = *reg & 0xffff;
    }
  else if (dbgop == 1 || dbgop == 3)
    {
      dbg_name = dbgop == 1 ? "DBGA" : "DBGAH";
      dbg_appd = dbgop == 1 ? ".H" : "";
      actual = *reg >> 16;
    }
  else
    illegal_instruction (cpu);

  TRACE_INSN (cpu, "%s (%s%s, 0x%x);", dbg_name, reg_name, dbg_appd, expected);
  if (actual != expected)
    {
      fprintf (stderr, "FAIL at 0x%x: %s (%s%s, 0x%04x), actual value 0x%x\n",
	       PCREG, dbg_name, reg_name, dbg_appd, expected, actual);
      cec_exception (cpu, VEC_ILGAL_I);
      DREG (0) = 1;
    }

  PCREG += 4;
}

static void
_interp_insn_bfin (SIM_CPU *cpu, bu32 pc, int *is_multiinsn)
{
  bu16 iw0 = IFETCH (pc), iw1;

  if ((iw0 & 0xc000) == 0xc000)
    {
      iw1 = IFETCH (pc + 2);
      TRACE_EXTRACT (cpu, "%s: iw0:%#x iw1:%#x", __func__, iw0, iw1);
    }
  else
    TRACE_EXTRACT (cpu, "%s: iw0:%#x", __func__, iw0);

  *is_multiinsn = ((iw0 & 0xc000) == 0xc000 && (iw0 & BIT_MULTI_INS)
		   && ((iw0 & 0xe800) != 0xe800 /* not linkage */));
  TRACE_DECODE (cpu, "%s: is_multiinsn:%i", __func__, *is_multiinsn);

  if ((iw0 & 0xf7ff) == 0xc003 && iw1 == 0x1800)
    {
      TRACE_INSN (cpu, "MNOP;");
      PCREG += 4;
    }
  else if ((iw0 & 0xFF00) == 0x0000)
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

  cycles_inc (cpu, 1);
}

void
interp_insn_bfin (SIM_CPU *cpu, bu32 pc)
{
  int i, is_multiinsn;
  bu32 old_astat = ASTAT;

  BFIN_CPU_STATE.n_stores = 0;

  _interp_insn_bfin (cpu, pc, &is_multiinsn);

  /* Proper display of multiple issue instructions.  */
  if (is_multiinsn)
    {
      _interp_insn_bfin (cpu, pc + 4, &is_multiinsn);
      _interp_insn_bfin (cpu, pc + 6, &is_multiinsn);
    }
  for (i = 0; i < BFIN_CPU_STATE.n_stores; i++)
    *BFIN_CPU_STATE.stores[i].addr = BFIN_CPU_STATE.stores[i].val;

  /* XXX: probably want to always show when an ASTAT bit is written, not
   * just changed ...
   */
  if (TRACE_CORE_P (cpu))
    {
#define COMPARE_ASTAT(bit, BIT) \
  if (ASTAT_EXTRACT (old_astat, BIT##_BIT) != ASTATREG (bit)) \
    TRACE_CORE (cpu, "ASTAT["#BIT"] changed to %i", ASTATREG (bit))
      COMPARE_ASTAT (az, AZ);
      COMPARE_ASTAT (an, AN);
      COMPARE_ASTAT (cc, CC);
      COMPARE_ASTAT (aq, AQ);
      COMPARE_ASTAT (rnd_mod, RND_MOD);
      COMPARE_ASTAT (ac0, AC0);
      COMPARE_ASTAT (ac1, AC1);
      COMPARE_ASTAT (av0, AV0);
      COMPARE_ASTAT (av0s, AV0S);
      COMPARE_ASTAT (av1, AV1);
      COMPARE_ASTAT (av1s, AV1S);
      COMPARE_ASTAT (v, V);
      COMPARE_ASTAT (vs, VS);
    }
}
