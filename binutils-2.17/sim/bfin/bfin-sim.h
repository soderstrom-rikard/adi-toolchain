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

#include "gdb/callback.h"
#include "gdb/remote-sim.h"
#include "sim-config.h"
#include "sim-types.h"

typedef unsigned8 bu8;
typedef unsigned16 bu16;
typedef unsigned32 bu32;
typedef unsigned64 bu64;
typedef signed8 bs8;
typedef signed16 bs16;
typedef signed32 bs32;
typedef signed64 bs64;

typedef struct
{
  bu32 dpregs[16], iregs[4], mregs[4], bregs[4], lregs[4], cycles[2];
  bu32 a0x, a0w, a1x, a1w;
  bu32 lt[2], lc[2], lb[2];
  int ac0, ac0_copy, ac1, an, aq;
  int av0, av0s, av1, av1s, az, cc, v, v_copy, vs;
  int rnd_mod;
  int v_internal;
  bu32 pc, rets, reti, retx, retn, rete;
  bu32 usp, seqstat, syscfg;

  int ticks;
  int insts;

  int exception;

  int end_of_registers;

  int msize;
  unsigned char *memory;
  unsigned long bfd_mach;
} saved_state_type;

extern saved_state_type saved_state;

#define GREG(x,i)	DPREG ((x) | (i << 3))
#define DPREG(x)	(saved_state.dpregs[x])
#define DREG(x)		(saved_state.dpregs[x])
#define PREG(x)		(saved_state.dpregs[x + 8])
#define SPREG		PREG (6)
#define FPREG		PREG (7)
#define IREG(x)		(saved_state.iregs[x])
#define MREG(x)		(saved_state.mregs[x])
#define BREG(x)		(saved_state.bregs[x])
#define LREG(x)		(saved_state.lregs[x])
#define A0XREG		(saved_state.a0x)
#define A0WREG		(saved_state.a0w)
#define A1XREG		(saved_state.a1x)
#define A1WREG		(saved_state.a1w)
#define CCREG		(saved_state.cc)
#define LC0REG		(saved_state.lc[0])
#define LT0REG		(saved_state.lt[0])
#define LB0REG		(saved_state.lb[0])
#define LC1REG		(saved_state.lc[1])
#define LT1REG		(saved_state.lt[1])
#define LB1REG		(saved_state.lb[1])
#define CYCLESREG	(saved_state.cycles[0])
#define CYCLES2REG	(saved_state.cycles[1])
#define USPREG		(saved_state.usp)
#define SEQSTATREG	(saved_state.seqstat)
#define SYSCFGREG	(saved_state.syscfg)
#define RETSREG		(saved_state.rets)
#define RETIREG		(saved_state.reti)
#define RETXREG		(saved_state.retx)
#define RETNREG		(saved_state.retn)
#define RETEREG		(saved_state.rete)
#define PCREG		(saved_state.pc)

#define AZ_BIT		0
#define AN_BIT		1
#define AC0_COPY_BIT	2
#define V_COPY_BIT	3
#define CC_BIT		5
#define AQ_BIT		6
#define RND_MOD_BIT	8
#define AC0_BIT		12
#define AC1_BIT		13
#define AV0_BIT		16
#define AV0S_BIT	17
#define AV1_BIT		18
#define AV1S_BIT	19
#define V_BIT		24
#define VS_BIT		25

#define ASTAT		(saved_state.az << AZ_BIT \
			 | saved_state.an << AN_BIT \
			 | saved_state.ac0_copy << AC0_COPY_BIT \
			 | saved_state.v_copy << V_COPY_BIT \
			 | saved_state.cc << CC_BIT \
			 | saved_state.aq << AQ_BIT \
			 | saved_state.rnd_mod << RND_MOD_BIT \
			 | saved_state.ac0 << AC0_BIT \
			 | saved_state.ac1 << AC1_BIT \
			 | saved_state.av0 << AV0_BIT \
			 | saved_state.av0s << AV0S_BIT \
			 | saved_state.av1 << AV1_BIT \
			 | saved_state.av1s << AV1S_BIT \
			 | saved_state.v << V_BIT \
			 | saved_state.vs << VS_BIT)

#define SET_ASTAT(a)						\
  do								\
    {								\
      saved_state.az = a >> AZ_BIT & 1;				\
      saved_state.an = a >> AN_BIT & 1;				\
      saved_state.ac0_copy = a >> AC0_COPY_BIT & 1;		\
      saved_state.v_copy = a >> V_COPY_BIT & 1;			\
      saved_state.cc = a >> CC_BIT & 1;				\
      saved_state.aq = a >> AQ_BIT & 1;				\
      saved_state.rnd_mod = a >> RND_MOD_BIT & 1;		\
      saved_state.ac0 = a >> AC0_BIT & 1;			\
      saved_state.ac1 = a >> AC1_BIT & 1;			\
      saved_state.av0 = a >> AV0_BIT & 1;			\
      saved_state.av0s = a >> AV0S_BIT & 1;			\
      saved_state.av1 = a >> AV1_BIT & 1;			\
      saved_state.av1s = a >> AV1S_BIT & 1;			\
      saved_state.v = a >> V_BIT & 1;				\
      saved_state.vs = a >> VS_BIT & 1;				\
    }								\
  while (0)

extern int did_jump;

static inline void put_byte (unsigned char *memory, bu32 addr, bu8 v)
{
  memory[addr] = v;
}

static inline void put_word (unsigned char *memory, bu32 addr, bu16 v)
{
  memory[addr] = v;
  memory[addr + 1] = v >> 8;
}

static inline void put_long (unsigned char *memory, bu32 addr, bu32 v)
{
  memory[addr] = v;
  memory[addr + 1] = v >> 8;
  memory[addr + 2] = v >> 16;
  memory[addr + 3] = v >> 24;
}

static inline bu8 get_byte (unsigned char *memory, bu32 addr)
{
  return memory[addr];
}

static inline bu16 get_word (unsigned char *memory, bu32 addr)
{
  return (memory[addr] | (memory[addr + 1] << 8));
}

static inline bu32 get_long (unsigned char *memory, bu32 addr)
{
  return (memory[addr] | (memory[addr + 1] << 8)
	  | (memory[addr + 2] << 16) | (memory[addr + 3] << 24));
}

extern void interp_insn_bfin (bu32);

