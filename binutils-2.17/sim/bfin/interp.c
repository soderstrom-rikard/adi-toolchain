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

#include "config.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

#include "gdb/callback.h"
#include "gdb/signals.h"
#include "sim-main.h"
#include "sim-hw.h"
#include "targ-vals.h"

#include "devices.h"
#include "dv-bfin_cec.h"
#include "dv-bfin_ctimer.h"
#include "dv-bfin_ebiu_amc.h"
#include "dv-bfin_ebiu_sdc.h"
#include "dv-bfin_evt.h"
#include "dv-bfin_mmu.h"
#include "dv-bfin_pll.h"
#include "dv-bfin_sic.h"
#include "dv-bfin_trace.h"
#include "dv-bfin_uart.h"

static char **prog_argv;

/* Count the number of arguments in an argv.  */
static int
count_argc (char **argv)
{
  int i;

  if (! argv)
    return -1;

  for (i = 0; argv[i] != NULL; ++i)
    continue;
  return i;
}

/* Read/write functions for system call interface.  */

static int
syscall_read_mem (host_callback *cb, struct cb_syscall *sc,
		  unsigned long taddr, char *buf, int bytes)
{
  SIM_DESC sd = (SIM_DESC) sc->p1;
  SIM_CPU *cpu = (SIM_CPU *) sc->p2;

  return sim_core_read_buffer (sd, cpu, read_map, buf, taddr, bytes);
}

static int
syscall_write_mem (host_callback *cb, struct cb_syscall *sc,
		  unsigned long taddr, const char *buf, int bytes)
{
  SIM_DESC sd = (SIM_DESC) sc->p1;
  SIM_CPU *cpu = (SIM_CPU *) sc->p2;

  return sim_core_write_buffer (sd, cpu, write_map, buf, taddr, bytes);
}

/* Simulate a monitor trap, put the result into r0 and errno into r1
   return offset by which to adjust pc.  */

void
bfin_trap (SIM_CPU *cpu)
{
  SIM_DESC sd = CPU_STATE (cpu);
  char **argv = prog_argv /*STATE_PROG_ARGV (sd)*/;
  host_callback *cb = STATE_CALLBACK (sd);
  CB_SYSCALL sc;

  CB_SYSCALL_INIT (&sc);
  sc.func = PREG (0);
#if 0 /* this isnt the linux system call interface */
  sc.arg1 = DREG (0);
  sc.arg2 = DREG (1);
  sc.arg3 = DREG (2);
  sc.arg4 = DREG (3);
  /*sc.arg5 = DREG (4);*/
  /*sc.arg6 = DREG (5);*/
#else
  sc.arg1 = GET_LONG (DREG (0));
  sc.arg2 = GET_LONG (DREG (0) + 4);
  sc.arg3 = GET_LONG (DREG (0) + 8);
  sc.arg4 = GET_LONG (DREG (0) + 12);
#endif
  sc.p1 = (PTR) sd;
  sc.p2 = (PTR) cpu;
  sc.read_mem = syscall_read_mem;
  sc.write_mem = syscall_write_mem;

  /* Common cb_syscall() handles most functions.  */
  switch (sc.func)
    {
    case TARGET_SYS_exit:
      sim_engine_halt (sd, cpu, NULL, PCREG, sim_exited, sc.arg1);

    case TARGET_SYS_argc:
      sc.result = count_argc (argv);
      break;
    case TARGET_SYS_argnlen:
      {
	if (sc.arg1 < count_argc (argv))
	  sc.result = strlen (argv[sc.arg1]);
	else
	  sc.result = -1;
      }
      break;
    case TARGET_SYS_argn:
      {
	if (sc.arg1 < count_argc (argv))
	  {
	    char *argn = argv[sc.arg1];
	    int len = strlen (argn);
	    int written = sc.write_mem (cb, &sc, sc.arg2, argn, len + 1);
	    if (written == len)
	      sc.result = sc.arg2;
	    else
	      sc.result = -1;
	  }
	else
	  sc.result = -1;
      }
      break;

    default:
      cb_syscall (cb, &sc);
    }

  SET_DREG (0, sc.result);
  /*SET_DREG (1, sc.errcode);*/
}

void
trace_register (SIM_DESC sd,
		sim_cpu *cpu,
		const char *fmt,
		...)
{
  va_list ap;
  trace_printf (sd, cpu, "%s %s",
		"reg:     ",
		TRACE_PREFIX (CPU_TRACE_DATA (cpu)));
  va_start (ap, fmt);
  trace_vprintf (sd, cpu, fmt, ap);
  va_end (ap);
  trace_printf (sd, cpu, "\n");
}

/* Execute a single instruction.  */

static sim_cia
step_once (SIM_CPU *cpu)
{
  bu32 oldpc = PCREG;

  if (TRACE_ANY_P (cpu))
    trace_prefix (CPU_STATE (cpu), cpu, NULL_CIA, oldpc, TRACE_LINENUM_P (cpu),
		  NULL, 0, "");

  if (oldpc & 0x1)
    cec_exception (cpu, VEC_MISALI_I);

#if 0
  /* XXX: Is this what happens on the hardware ?  */
  if (cec_get_ivg (cpu) == EVT_EMU)
    cec_return (cpu, EVT_EMU);
#endif

  BFIN_CPU_STATE.did_jump = false;
  interp_insn_bfin (cpu, oldpc);

  /* @@@ Not sure how the hardware really behaves when the last insn
     of a loop is a jump.  */
  if (!BFIN_CPU_STATE.did_jump)
    {
      int i;
      for (i = 1; i >= 0; --i)
	{
	  if (LCREG (i) && oldpc == LBREG (i) && --LCREG (i))
	    {
	      SET_PCREG (LTREG (i));
	      TRACE_BRANCH (cpu, "Hardware loop %i to %#x (%#x iters left)",
			    i, PCREG, LCREG (i));
	      break;
	    }
	}
    }

  return oldpc;
}

void
sim_engine_run (SIM_DESC sd,
		int next_cpu_nr, /* ignore */
		int nr_cpus, /* ignore */
		int siggnal) /* ignore */
{
  sim_cia cia;
  sim_cpu *cpu;
  SIM_ASSERT (STATE_MAGIC (sd) == SIM_MAGIC_NUMBER);
  cpu = STATE_CPU (sd, 0);
  cia = CIA_GET (cpu);
  while (1)
    {
      cia = step_once (cpu);
      /* process any events */
      if (sim_events_tick (sd))
	{
	  /* XXX: a lot of things fail with this:
	     - single stepping
	     - stepping over break points
	     - restarting the same instruction after an event
	  CIA_SET (cpu, cia); */
	  sim_events_process (sd);
	}
    }
}

/* Cover function of sim_state_free to free the cpu buffers as well.  */

static void
free_state (SIM_DESC sd)
{
  if (STATE_MODULES (sd) != NULL)
    sim_module_uninstall (sd);
  sim_cpu_free_all (sd);
  sim_state_free (sd);
}

/* Create an instance of the simulator.  */

static void
bfin_map_layout (SIM_DESC sd, SIM_CPU *cpu, size_t count,
                 const struct bfin_memory_layout *mem)
{
  size_t idx;
  for (idx = 0; idx < count; ++idx)
    sim_core_attach (sd, NULL, 0, mem[idx].mask, 0, mem[idx].addr,
                     mem[idx].len, 0, NULL, NULL);
}

static void
bfin_hw_tree_init (SIM_DESC sd)
{
  dv_bfin_hw_parse (sd, cec, CEC);
  dv_bfin_hw_parse (sd, ctimer, CTIMER);
  dv_bfin_hw_parse (sd, evt, EVT);
  dv_bfin_hw_parse (sd, mmu, MMU);
  dv_bfin_hw_parse (sd, trace, TRACE);

  dv_bfin_hw_parse (sd, ebiu_amc, EBIU_AMC);
  dv_bfin_hw_parse (sd, ebiu_sdc, EBIU_SDC);
  dv_bfin_hw_parse (sd, pll, PLL);
  dv_bfin_hw_parse (sd, sic, SIC);
  dv_bfin_hw_parse (sd, uart, UART);
}

static void
bfin_initialize_cpu (SIM_DESC sd, SIM_CPU *cpu)
{
  struct bfin_model_data *mdata;

  memset (&cpu->state, 0, sizeof (cpu->state));

  mdata = CPU_MODEL_DATA (cpu);

  /* These memory maps are supposed to be cpu-specific, but the common sim
     code does not yet allow that (2nd arg is "cpu" rather than "NULL".  */
  sim_core_attach (sd, NULL, 0, access_read_write, 0, BFIN_L1_SRAM_SCRATCH,
		   BFIN_L1_SRAM_SCRATCH_SIZE, 0, NULL, NULL);

  /* Map in the on-chip memory (bootrom/sram/etc...).  */
  bfin_map_layout (sd, cpu, mdata->mem_count, mdata->mem);

  /* Set default stack to top of scratch pad.  */
  SET_SPREG (BFIN_DEFAULT_MEM_SIZE);

  /* This is what the hardware likes.  */
  SET_SYSCFGREG (0x30);
}

SIM_DESC
sim_open (SIM_OPEN_KIND kind, host_callback *callback,
	  struct bfd *abfd, char **argv)
{
  char c;
  int i;
  SIM_DESC sd = sim_state_alloc (kind, callback);

  /* The cpu data is kept in a separately allocated chunk of memory.  */
  if (sim_cpu_alloc_all (sd, 1, /*cgen_cpu_max_extra_bytes ()*/0) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  if (sim_pre_argv_init (sd, argv[0]) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* getopt will print the error message so we just have to exit if this fails.
     FIXME: Hmmm...  in the case of gdb we need getopt to call
     print_filtered.  */
  if (sim_parse_args (sd, argv) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* Need to set up the tree now before the sim_post_argv_init().  */
  bfin_hw_tree_init (sd);

  /* Allocate external memory if none specified by user.
     Use address 4 here in case the user wanted address 0 unmapped.  */
  if (sim_core_read_buffer (sd, NULL, read_map, &c, 4, 1) == 0)
    sim_do_commandf (sd, "memory region 0,0x%lx", BFIN_DEFAULT_MEM_SIZE);

  /* Check for/establish the a reference program image.  */
  if (sim_analyze_program (sd,
			   (STATE_PROG_ARGV (sd) != NULL
			    ? *STATE_PROG_ARGV (sd)
			    : NULL), abfd) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* Establish any remaining configuration options.  */
  if (sim_config (sd) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  if (sim_post_argv_init (sd) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* CPU specific initialization.  */
  for (i = 0; i < MAX_NR_PROCESSORS; ++i)
    {
      SIM_CPU *cpu = STATE_CPU (sd, i);
      bfin_initialize_cpu (sd, cpu);
    }

  return sd;
}

void
sim_close (SIM_DESC sd, int quitting)
{
  /* Nothing to do.  */
}

SIM_RC
sim_create_inferior (SIM_DESC sd, struct bfd *abfd,
		     char **argv, char **env)
{
  SIM_CPU *cpu = STATE_CPU (sd, 0);
  SIM_ADDR addr;

  /* Set the PC.  */
  if (abfd != NULL)
    addr = bfd_get_start_address (abfd);
  else
    addr = 0;
  sim_pc_set (cpu, addr);

  /* Record the program's arguments.  */
  /* STATE_PROG_ARGV (sd) = argv; */
  prog_argv = argv;

  return SIM_RC_OK;
}

void
sim_do_command (SIM_DESC sd, char *cmd)
{
  if (sim_args_command (sd, cmd) != SIM_RC_OK)
    sim_io_eprintf (sd, "Unknown command `%s'\n", cmd);
}
