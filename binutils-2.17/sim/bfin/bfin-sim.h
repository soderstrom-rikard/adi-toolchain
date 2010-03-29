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

#ifndef _BFIN_SIM_H_
#define _BFIN_SIM_H_

#include <stdbool.h>

typedef unsigned8 bu8;
typedef unsigned16 bu16;
typedef unsigned32 bu32;
typedef unsigned64 bu40;
typedef unsigned64 bu64;
typedef signed8 bs8;
typedef signed16 bs16;
typedef signed32 bs32;
typedef signed64 bs40;
typedef signed64 bs64;

/* For dealing with parallel instructions, we must avoid changing our register
   file until all parallel insns have been simulated.  This queue of stores
   can be used to delay a modification.
   @@@ Should go and convert all 32 bit insns to use this.  */
struct store {
  bu32 *addr;
  bu32 val;
};
#define STORE(X, Y) \
  do { \
    if (BFIN_CPU_STATE.n_stores == 20) abort (); \
    BFIN_CPU_STATE.stores[BFIN_CPU_STATE.n_stores].addr = (bu32 *)&(X); \
    BFIN_CPU_STATE.stores[BFIN_CPU_STATE.n_stores++].val = (Y); \
  } while (0)

struct bfin_cpu_state
{
  bu32 dpregs[16], iregs[4], mregs[4], bregs[4], lregs[4], cycles[3];
  bu32 ax[2], aw[2];
  bu32 lt[2], lc[2], lb[2];
  int ac0, ac0_copy, ac1, an, aq;
  int av0, av0s, av1, av1s, az, cc, v, v_copy, vs;
  int rnd_mod;
  int v_internal;
  bu32 pc, rets, reti, retx, retn, rete;
  bu32 usp, seqstat, syscfg;
  bu32 emudat[2];

  /* Set by an instruction emulation function if we performed a jump.  */
  bool did_jump;

  /* See notes above for struct store.  */
  struct store stores[20];
  int n_stores;
};

#define REG_H_L(h, l)	(((h) & 0xffff0000) | ((l) & 0x0000ffff))

#define DREG(x)		(BFIN_CPU_STATE.dpregs[x])
#define PREG(x)		(BFIN_CPU_STATE.dpregs[x + 8])
#define SPREG		PREG (6)
#define FPREG		PREG (7)
#define IREG(x)		(BFIN_CPU_STATE.iregs[x])
#define MREG(x)		(BFIN_CPU_STATE.mregs[x])
#define BREG(x)		(BFIN_CPU_STATE.bregs[x])
#define LREG(x)		(BFIN_CPU_STATE.lregs[x])
#define AXREG(x)	(BFIN_CPU_STATE.ax[x])
#define AWREG(x)	(BFIN_CPU_STATE.aw[x])
#define A0XREG		AXREG (0)
#define A0WREG		AWREG (0)
#define A1XREG		AXREG (1)
#define A1WREG		AWREG (1)
#define CCREG		(BFIN_CPU_STATE.cc)
#define LCREG(x)	(BFIN_CPU_STATE.lc[x])
#define LTREG(x)	(BFIN_CPU_STATE.lt[x])
#define LBREG(x)	(BFIN_CPU_STATE.lb[x])
#define CYCLESREG	(BFIN_CPU_STATE.cycles[0])
#define CYCLES2REG	(BFIN_CPU_STATE.cycles[1])
#define CYCLES2SHDREG	(BFIN_CPU_STATE.cycles[2])
#define USPREG		(BFIN_CPU_STATE.usp)
#define SEQSTATREG	(BFIN_CPU_STATE.seqstat)
#define SYSCFGREG	(BFIN_CPU_STATE.syscfg)
#define RETSREG		(BFIN_CPU_STATE.rets)
#define RETIREG		(BFIN_CPU_STATE.reti)
#define RETXREG		(BFIN_CPU_STATE.retx)
#define RETNREG		(BFIN_CPU_STATE.retn)
#define RETEREG		(BFIN_CPU_STATE.rete)
#define PCREG		(BFIN_CPU_STATE.pc)
#define EMUDAT_INREG	(BFIN_CPU_STATE.emudat[0])
#define EMUDAT_OUTREG	(BFIN_CPU_STATE.emudat[1])

#define _SET_CORE32REG_IDX(reg, p, x, val) \
  do \
    { \
      bu32 __v = (val); \
      TRACE_REGISTER (cpu, "wrote "#p"%i = %#x", x, __v); \
      reg = __v; \
    } \
  while (0)
#define SET_DREG(x, val) _SET_CORE32REG_IDX (DREG (x), R, x, val)
#define SET_PREG(x, val) _SET_CORE32REG_IDX (PREG (x), P, x, val)
#define SET_IREG(x, val) _SET_CORE32REG_IDX (IREG (x), I, x, val)
#define SET_MREG(x, val) _SET_CORE32REG_IDX (MREG (x), M, x, val)
#define SET_BREG(x, val) _SET_CORE32REG_IDX (BREG (x), B, x, val)
#define SET_LREG(x, val) _SET_CORE32REG_IDX (LREG (x), L, x, val)
#define SET_LCREG(x, val) _SET_CORE32REG_IDX (LCREG (x), LC, x, val)
#define SET_LTREG(x, val) _SET_CORE32REG_IDX (LTREG (x), LT, x, val)
#define SET_LBREG(x, val) _SET_CORE32REG_IDX (LBREG (x), LB, x, val)

#define SET_DREG_L_H(x, l, h) SET_DREG (x, REG_H_L (h, l))
#define SET_DREG_L(x, l) SET_DREG (x, REG_H_L (DREG (x), l))
#define SET_DREG_H(x, h) SET_DREG (x, REG_H_L (h, DREG (x)))

#define _SET_CORE32REG_ALU(reg, p, x, val) \
  do \
    { \
      bu32 __v = (val); \
      TRACE_REGISTER (cpu, "wrote A%i"#p" = %#x", x, __v); \
      reg = __v; \
    } \
  while (0)
#define SET_AXREG(x, val) _SET_CORE32REG_ALU (AXREG (x), X, x, val)
#define SET_AWREG(x, val) _SET_CORE32REG_ALU (AWREG (x), W, x, val)

#define SET_AREG(x, val) \
  do \
    { \
      bu40 __a = (val); \
      SET_AXREG (x, (__a >> 32) & 0xff); \
      SET_AWREG (x, __a); \
    } \
  while (0)
#define SET_AREG32(x, val) \
  do \
    { \
      SET_AWREG (x, val); \
      SET_AXREG (x, -(AWREG (x) >> 31)); \
    } \
  while (0)

#define _SET_CORE32REG(reg, val) \
  do \
    { \
      bu32 __v = (val); \
      TRACE_REGISTER (cpu, "wrote "#reg" = %#x", __v); \
      reg##REG = __v; \
    } \
  while (0)
#define SET_FPREG(val) _SET_CORE32REG (FP, val)
#define SET_SPREG(val) _SET_CORE32REG (SP, val)
#define SET_CYCLESREG(val) _SET_CORE32REG (CYCLES, val)
#define SET_CYCLES2REG(val) _SET_CORE32REG (CYCLES2, val)
#define SET_CYCLES2SHDREG(val) _SET_CORE32REG (CYCLES2SHD, val)
#define SET_USP(val) _SET_CORE32REG (USP, val)
#define SET_SEQSTATREG(val) _SET_CORE32REG (SEQSTAT, val)
#define SET_SYSCFGREG(val) _SET_CORE32REG (SYSCFG, val)
#define SET_RETSREG(val) _SET_CORE32REG (RETS, val)
#define SET_RETIREG(val) _SET_CORE32REG (RETI, val)
#define SET_RETXREG(val) _SET_CORE32REG (RETX, val)
#define SET_RETNREG(val) _SET_CORE32REG (RETN, val)
#define SET_RETEREG(val) _SET_CORE32REG (RETE, val)
#define SET_PCREG(val) _SET_CORE32REG (PC, val)
#define INC_PCREG(val) _SET_CORE32REG (PC, PCREG + (val))

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

#define ASTATREG(field) (BFIN_CPU_STATE.field)
#define ASTAT_DEPOSIT(field, bit) (ASTATREG(field) << (bit))
#define ASTAT \
	(ASTAT_DEPOSIT(az,       AZ_BIT)       \
	|ASTAT_DEPOSIT(an,       AN_BIT)       \
	|ASTAT_DEPOSIT(ac0_copy, AC0_COPY_BIT) \
	|ASTAT_DEPOSIT(v_copy,   V_COPY_BIT)   \
	|ASTAT_DEPOSIT(cc,       CC_BIT)       \
	|ASTAT_DEPOSIT(aq,       AQ_BIT)       \
	|ASTAT_DEPOSIT(rnd_mod,  RND_MOD_BIT)  \
	|ASTAT_DEPOSIT(ac0,      AC0_BIT)      \
	|ASTAT_DEPOSIT(ac1,      AC1_BIT)      \
	|ASTAT_DEPOSIT(av0,      AV0_BIT)      \
	|ASTAT_DEPOSIT(av0s,     AV0S_BIT)     \
	|ASTAT_DEPOSIT(av1,      AV1_BIT)      \
	|ASTAT_DEPOSIT(av1s,     AV1S_BIT)     \
	|ASTAT_DEPOSIT(v,        V_BIT)        \
	|ASTAT_DEPOSIT(vs,       VS_BIT))

#define ASTAT_EXTRACT(a, bit)     (((a) >> bit) & 1)
#define _SET_ASTAT(a, field, bit) (ASTATREG(field) = ASTAT_EXTRACT(a, bit))
#define SET_ASTAT(a) \
  do \
    { \
      TRACE_REGISTER (cpu, "wrote ASTAT = %#x", a); \
      _SET_ASTAT(a, az,       AZ_BIT); \
      _SET_ASTAT(a, an,       AN_BIT); \
      _SET_ASTAT(a, ac0_copy, AC0_COPY_BIT); \
      _SET_ASTAT(a, v_copy,   V_COPY_BIT); \
      _SET_ASTAT(a, cc,       CC_BIT); \
      _SET_ASTAT(a, aq,       AQ_BIT); \
      _SET_ASTAT(a, rnd_mod,  RND_MOD_BIT); \
      _SET_ASTAT(a, ac0,      AC0_BIT); \
      _SET_ASTAT(a, ac1,      AC1_BIT); \
      _SET_ASTAT(a, av0,      AV0_BIT); \
      _SET_ASTAT(a, av0s,     AV0S_BIT); \
      _SET_ASTAT(a, av1,      AV1_BIT); \
      _SET_ASTAT(a, av1s,     AV1S_BIT); \
      _SET_ASTAT(a, v,        V_BIT); \
      _SET_ASTAT(a, vs,       VS_BIT); \
    } \
  while (0)
#define SET_ASTATREG(field, val) \
  do \
    { \
      int __v = (val); \
      TRACE_REGISTER (cpu, "wrote ASTAT["#field"] = %i", __v); \
      ASTATREG (field) = __v; \
      if (&ASTATREG (field) == &ASTATREG (ac0)) \
	ASTATREG (ac0_copy) = __v; \
      else if (&ASTATREG (field) == &ASTATREG (v)) \
	ASTATREG (v_copy) = __v; \
    } \
  while (0)
#define SET_CCREG(val) SET_ASTATREG (cc, val)

#define SYSCFG_SSSTEP	(1 << 0)
#define SYSCFG_CCEN	(2 << 0)
#define SYSCFG_SNEN	(3 << 0)

#define __PUT_MEM(taddr, v, size) \
do { \
  bu##size __v = (v); \
  bu32 __taddr = (taddr); \
  int __cnt, __bytes = size / 8; \
  mmu_check_addr (cpu, __taddr, true, false, __bytes); \
  __cnt = sim_core_write_buffer (CPU_STATE(cpu), cpu, write_map, \
				 (void *)&__v, __taddr, __bytes); \
  if (__cnt != __bytes) \
    mmu_process_fault (cpu, __taddr, true, false, false); \
  TRACE_CORE (cpu, "DBUS STORE %i bytes @ 0x%08x: 0x%0*x", \
	      size / 8, __taddr, size / 4, __v); \
} while (0)
#define PUT_BYTE(taddr, v) __PUT_MEM(taddr, v, 8)
#define PUT_WORD(taddr, v) __PUT_MEM(taddr, v, 16)
#define PUT_LONG(taddr, v) __PUT_MEM(taddr, v, 32)

#define __GET_MEM(taddr, size, inst) \
({ \
  bu##size __ret; \
  bu32 __taddr = (taddr); \
  int __cnt, __bytes = size / 8; \
  mmu_check_addr (cpu, __taddr, false, inst, __bytes); \
  __cnt = sim_core_read_buffer (CPU_STATE(cpu), cpu, read_map, \
				(void *)&__ret, __taddr, __bytes); \
  if (__cnt != __bytes) \
    mmu_process_fault (cpu, __taddr, false, inst, false); \
  TRACE_CORE (cpu, "%cBUS FETCH %i bytes @ 0x%08x: 0x%0*x", \
	      inst ? 'I' : 'D', \
	      size / 8, __taddr, size / 4, __ret); \
  __ret; \
})
#define _GET_MEM(taddr, size) __GET_MEM(taddr, size, false)
#define GET_BYTE(taddr) _GET_MEM(taddr, 8)
#define GET_WORD(taddr) _GET_MEM(taddr, 16)
#define GET_LONG(taddr) _GET_MEM(taddr, 32)

#define IFETCH(taddr) __GET_MEM(taddr, 16, true)

extern void interp_insn_bfin (SIM_CPU *, bu32);

/* Defines for Blackfin memory layouts.  */
#define BFIN_ASYNC_BASE           0x20000000
#define BFIN_SYSTEM_MMR_BASE      0xFFC00000
#define BFIN_CORE_MMR_BASE        0xFFE00000
#define BFIN_L1_SRAM_SCRATCH      0xFFB00000
#define BFIN_L1_SRAM_SCRATCH_SIZE 0x1000
#define BFIN_L1_SRAM_SCRATCH_END  (BFIN_L1_SRAM_SCRATCH + BFIN_L1_SRAM_SCRATCH_SIZE)

#define BFIN_L1_CACHE_BYTES       32

#endif
