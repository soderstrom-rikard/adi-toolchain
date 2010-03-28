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

#ifndef _BFIN_MAIN_SIM_H_
#define _BFIN_MAIN_SIM_H_

#include "sim-basics.h"
#include "sim-signal.h"

typedef unsigned32 sim_cia;

#define CIA_GET(cpu)     CPU_PC_GET (cpu)
#define CIA_SET(cpu,val) CPU_PC_SET ((cpu), (val))

#include "machs.h"

#include "sim-base.h"

typedef struct _sim_cpu SIM_CPU;

#include "bfin-sim.h"

struct _sim_cpu {
   /* ... simulator specific members ... */
   struct bfin_cpu_state state;
   sim_cpu_base base;
};
#define BFIN_CPU_STATE ((cpu)->state)

struct sim_state {
  sim_cpu *cpu[MAX_NR_PROCESSORS];
#if (WITH_SMP)
#define STATE_CPU(sd,n) ((sd)->cpu[n])
#else
#define STATE_CPU(sd,n) ((sd)->cpu[0])
#endif
   /* ... simulator specific members ... */
  sim_state_base base;
};

#include "sim-config.h"
#include "sim-types.h"
#include "sim-engine.h"
#include "sim-options.h"
#include "run-sim.h"

#undef MAX
#undef MIN
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

#define MAYBE_TRACE(type, cpu, fmt, ...) \
  do { \
    if (TRACE_##type##_P (cpu)) \
      trace_generic (CPU_STATE (cpu), cpu, TRACE_##type##_IDX, \
		     fmt, ## __VA_ARGS__); \
  } while (0)
#define TRACE_INSN(cpu, fmt, ...) MAYBE_TRACE (INSN, cpu, fmt, ## __VA_ARGS__)
#define TRACE_DECODE(cpu, fmt, ...) MAYBE_TRACE (DECODE, cpu, fmt, ## __VA_ARGS__)
#define TRACE_EXTRACT(cpu, fmt, ...) MAYBE_TRACE (EXTRACT, cpu, fmt, ## __VA_ARGS__)
#define TRACE_CORE(cpu, fmt, ...) MAYBE_TRACE (CORE, cpu, fmt, ## __VA_ARGS__)
#define TRACE_EVENTS(cpu, fmt, ...) MAYBE_TRACE (EVENTS, cpu, fmt, ## __VA_ARGS__)
#define TRACE_BRANCH(cpu, fmt, ...) MAYBE_TRACE (BRANCH, cpu, fmt, ## __VA_ARGS__)

extern void trace_register PARAMS ((SIM_DESC sd,
				    sim_cpu *cpu,
				    const char *fmt,
				    ...))
     __attribute__((format (printf, 3, 4)));
#define TRACE_REGISTER(cpu, fmt, ...) \
  do { \
    if (TRACE_CORE_P (cpu)) \
      trace_register (CPU_STATE (cpu), cpu, fmt, ## __VA_ARGS__); \
  } while (0)
#define TRACE_REG(cpu, reg, val) TRACE_REGISTER (cpu, "wrote "#reg" = %#x", val)

/* Default memory size.  */
#define BFIN_DEFAULT_MEM_SIZE (64 * 1024 * 1024)

#endif
