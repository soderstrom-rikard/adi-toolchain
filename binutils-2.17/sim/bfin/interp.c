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
#include <errno.h>
#include <unistd.h>	/* dup2 */

#include "gdb/callback.h"
#include "gdb/signals.h"
#include "sim-main.h"
#include "sim-hw.h"

/* XXX: common gdb code doesn't define these by default.  */
#define CB_SYS_argc    100
#define CB_SYS_argn    101
#define CB_SYS_argnlen 102
#include "targ-vals.h"

#define CB_SYS_ioctl 200 /* XXX: hack for simple uClibc stdio!  */
#define CB_SYS_mmap2 201 /* XXX: this gets us malloc()  */
#define CB_SYS_dup2  202
#include "targ-linux.h"

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

/* Count the number of arguments in an argv.  */
static int
count_argc (char * const *argv)
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

  TRACE_CORE (cpu, "DBUS FETCH (syscall) %i bytes @ 0x%08lx", bytes, taddr);

  return sim_core_read_buffer (sd, cpu, read_map, buf, taddr, bytes);
}

static int
syscall_write_mem (host_callback *cb, struct cb_syscall *sc,
		  unsigned long taddr, const char *buf, int bytes)
{
  SIM_DESC sd = (SIM_DESC) sc->p1;
  SIM_CPU *cpu = (SIM_CPU *) sc->p2;

  TRACE_CORE (cpu, "DBUS STORE (syscall) %i bytes @ 0x%08lx", bytes, taddr);

  return sim_core_write_buffer (sd, cpu, write_map, buf, taddr, bytes);
}

/* Simulate a monitor trap, put the result into r0 and errno into r1
   return offset by which to adjust pc.  */

void
bfin_syscall (SIM_CPU *cpu)
{
  SIM_DESC sd = CPU_STATE (cpu);
  char **argv = STATE_PROG_ARGV (sd);
  host_callback *cb = STATE_CALLBACK (sd);
  bu32 args[6];
  CB_SYSCALL sc;

  CB_SYSCALL_INIT (&sc);

  if (STATE_ENVIRONMENT (sd) == USER_ENVIRONMENT)
    {
      /* Linux syscall.  */
      sc.func = PREG (0);
      sc.arg1 = args[0] = DREG (0);
      sc.arg2 = args[1] = DREG (1);
      sc.arg3 = args[2] = DREG (2);
      sc.arg4 = args[3] = DREG (3);
      /*sc.arg5 =*/ args[4] = DREG (4);
      /*sc.arg6 =*/ args[5] = DREG (5);
    }
  else
    {
      /* libgloss syscall.  */
      sc.func = PREG (0);
      sc.arg1 = args[0] = GET_LONG (DREG (0));
      sc.arg2 = args[1] = GET_LONG (DREG (0) + 4);
      sc.arg3 = args[2] = GET_LONG (DREG (0) + 8);
      sc.arg4 = args[3] = GET_LONG (DREG (0) + 12);
      /*sc.arg5 =*/ args[4] = GET_LONG (DREG (0) + 16);
      /*sc.arg6 =*/ args[5] = GET_LONG (DREG (0) + 20);
    }
  sc.p1 = (PTR) sd;
  sc.p2 = (PTR) cpu;
  sc.read_mem = syscall_read_mem;
  sc.write_mem = syscall_write_mem;

  /* Common cb_syscall() handles most functions.  */
  switch (cb_target_to_host_syscall (cb, sc.func))
    {
    case CB_SYS_exit:
      sim_engine_halt (sd, cpu, NULL, PCREG, sim_exited, sc.arg1);

    case CB_SYS_argc:
      sc.result = count_argc (argv);
      break;
    case CB_SYS_argnlen:
      {
	if (sc.arg1 < count_argc (argv))
	  sc.result = strlen (argv[sc.arg1]);
	else
	  sc.result = -1;
      }
      break;
    case CB_SYS_argn:
      {
	if (sc.arg1 < count_argc (argv))
	  {
	    char *argn = argv[sc.arg1];
	    int len = strlen (argn);
	    int written = sc.write_mem (cb, &sc, sc.arg2, argn, len + 1);
	    if (written == len + 1)
	      sc.result = sc.arg2;
	    else
	      sc.result = -1;
	  }
	else
	  sc.result = -1;
      }
      break;

    case CB_SYS_ioctl:
      /* XXX: hack just enough to get basic stdio w/uClibc ...  */
      if (sc.arg2 == 0x5401)
	{
	  sc.result = !isatty (sc.arg1);
	  sc.errcode = 0;
	}
      else
	{
	  sc.result = -1;
	  sc.errcode = TARGET_EINVAL;
	}
      break;

    case CB_SYS_mmap2:
      /* XXX: support enough of mmap to get malloc()  */
      if (sc.arg4 & 0x20 /*MAP_ANONYMOUS*/)
	{
	  static bu32 heap = BFIN_DEFAULT_MEM_SIZE / 2;
	  sc.result = heap;
	  heap += (sc.arg2 & ~31) + 31;
	}
      else
	{
	  sc.result = -1;
	  sc.errcode = TARGET_ENOSYS;
	}
      break;

    case CB_SYS_dup2:
      sc.result = dup2 (sc.arg1, sc.arg2);
      if (sc.result == -1)
	sc.errcode = cb->get_errno (cb);
      break;

    default:
      cb_syscall (cb, &sc);
    }

  TRACE_EVENTS (cpu, "syscall_%i(%#x, %#x, %#x, %#x, %#x, %#x) = %li (error = %i)",
		PREG (0), args[0], args[1], args[2], args[3], args[4], args[5],
		sc.result, sc.errcode);

  if (STATE_ENVIRONMENT (sd) == USER_ENVIRONMENT)
    {
      if (sc.result == -1)
	SET_DREG (0, -cb_host_to_target_errno (cb, ENOSYS));
      else
	SET_DREG (0, sc.result);
    }
  else
    {
      SET_DREG (0, sc.result);
      /* Blackfin libgloss only expects R0 to be updated, not R1.  */
      /*SET_DREG (1, sc.errcode);*/
    }
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
  bu32 insn_len, oldpc = PCREG;

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
  BFIN_CPU_STATE.flow_change = false;

  insn_len = interp_insn_bfin (cpu, oldpc);

  /* Only process the hwloop if we didn't arrive here out of order.
     i.e. We jumped to this address, so we need to execute it.  */
  if (!BFIN_CPU_STATE.did_jump && !BFIN_CPU_STATE.flow_change)
    SET_PCREG (hwloop_get_next_pc (cpu, oldpc, insn_len));

  return oldpc;
}

void
sim_engine_run (SIM_DESC sd,
		int next_cpu_nr, /* ignore */
		int nr_cpus, /* ignore */
		int siggnal) /* ignore */
{
  int i;

  SIM_ASSERT (STATE_MAGIC (sd) == SIM_MAGIC_NUMBER);

  while (1)
    for (i = 0; i < MAX_NR_PROCESSORS; ++i)
      {
	SIM_CPU *cpu = STATE_CPU (sd, i);
	step_once (cpu);
	/* process any events */
	if (sim_events_tick (sd))
	  sim_events_process (sd);
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
  sim_hw_parse (sd, "/core/bfin_ctimer > ivtmr ivtmr /core/bfin_cec");
  dv_bfin_hw_parse (sd, evt, EVT);
  dv_bfin_hw_parse (sd, mmu, MMU);
  dv_bfin_hw_parse (sd, trace, TRACE);

  dv_bfin_hw_parse (sd, ebiu_amc, EBIU_AMC);
  dv_bfin_hw_parse (sd, ebiu_sdc, EBIU_SDC);
  dv_bfin_hw_parse (sd, pll, PLL);
  dv_bfin_hw_parse (sd, sic, SIC);
  dv_bfin_hw_parse (sd, uart, UART);

  /* XXX: Should be pushed to the model code.  */
  sim_hw_parse (sd, "/core/bfin_dma@0/reg %#x %i", 0xFFC00F00, 0x40); /* MDMA D0 */
  sim_hw_parse (sd, "/core/bfin_dma@0/peer /core/bfin_dma@1");
  sim_hw_parse (sd, "/core/bfin_dma@1/reg %#x %i", 0xFFC00F40, 0x40); /* MDMA S0 */
  sim_hw_parse (sd, "/core/bfin_dma@1/peer /core/bfin_dma@0");

  sim_hw_parse (sd, "/core/bfin_dma@2/reg %#x %i", 0xFFC00F80, 0x40); /* MDMA D1 */
  sim_hw_parse (sd, "/core/bfin_dma@2/peer /core/bfin_dma@3");
  sim_hw_parse (sd, "/core/bfin_dma@3/reg %#x %i", 0xFFC00FC0, 0x40); /* MDMA S1 */
  sim_hw_parse (sd, "/core/bfin_dma@3/peer /core/bfin_dma@2");
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

  {
    /* XXX: Only first core gets profiled ?  */
    SIM_CPU *cpu = STATE_CPU (sd, 0);
    STATE_WATCHPOINTS (sd)->pc = &PCREG;
    STATE_WATCHPOINTS (sd)->sizeof_pc = sizeof (PCREG);
  }

  if (sim_pre_argv_init (sd, argv[0]) != SIM_RC_OK)
    {
      free_state (sd);
      return 0;
    }

  /* XXX: Default to the Virtual environment.  */
  if (STATE_ENVIRONMENT (sd) == ALL_ENVIRONMENT)
    STATE_ENVIRONMENT (sd) = VIRTUAL_ENVIRONMENT;

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

static const char stat_map[] =
/* Linux kernel 32bit layout:  */
"st_dev,2:space,2:st_ino,4:st_mode,2:st_nlink,2:st_uid,2:st_gid,2:st_rdev,2:"
"space,2:st_size,4:st_blksize,4:st_blocks,4:st_atime,4:st_atimensec,4:"
"st_mtime,4:st_mtimensec,4:st_ctime,4:st_ctimensec,4:space,4:space,4";
/* uClibc public ABI 32bit layout:
"st_dev,8:space,2:space,2:st_ino,4:st_mode,4:st_nlink,4:st_uid,4:st_gid,4:"
"st_rdev,8:space,2:space,2:st_size,4:st_blksiez,4:st_blocks,4:st_atime,4:"
"st_atimensec,4:st_mtime,4:st_mtimensec,4:st_ctime,4:st_ctimensec,4:space,4:"
"space,4"; */

/* Some utils don't like having a NULL environ.  */
static char * const simple_env[] = { "HOME=/", "PATH=/bin", NULL };

static void
bfin_user_init (SIM_DESC sd, SIM_CPU *cpu, char * const *argv, char * const *env)
{
 /* Linux starts the user app with the stack:
       argc
       argv[0]       -- pointers to the actual strings
       argv[0..N]
       NULL
       env[0]
       env[0..N]
       NULL
       argv[0..N][0..M] -- actual strings
       env[0..N][0..M]
     So set things up the same way.  */
  int i, argc, envc;
  bu32 argv_flat, env_flat;
  bu32 sp, sp_flat;
  unsigned char null[4] = { 0, 0, 0, 0 };

  host_callback *cb = STATE_CALLBACK (sd);

  /* Figure out how much storage the argv/env strings need.  */
  argc = count_argc (argv);
  if (argc == -1)
    argc = 0;
  argv_flat = argc; /* NUL bytes */
  for (i = 0; i < argc; ++i)
    argv_flat += strlen (argv[i]);

  if (!env)
    env = simple_env;
  envc = count_argc (env);
  env_flat = envc; /* NUL bytes */
  for (i = 0; i < envc; ++i)
    env_flat += strlen (env[i]);

  /* Figure out how much stack space we need w/argc/argv/env.  */
  sp = SPREG - ((1 + argc + 1 + envc + 1) * 4) - argv_flat - env_flat;
  /* Align the SP.  */
  sp &= ~(4 - 1);
  SPREG = sp;

  /* First push the argc value.  */
  /* XXX: Missing host -> target endian ...  */
  sim_write (sd, sp, (void *)&argc, 4);
  sp += 4;

  /* Then the actual argv strings so we know where to point argv[].  */
  sp_flat = sp + ((argc + 1 + envc + 1) * 4);
  for (i = 0; i < argc; ++i)
    {
      unsigned len = strlen (argv[i]) + 1;
      sim_write (sd, sp_flat, argv[i], len);
      sim_write (sd, sp, (void *)&sp_flat, 4);
      sp_flat += len;
      sp += 4;
    }
  sim_write (sd, sp, null, 4);
  sp += 4;

  /* Then the actual env strings so we know where to point env[].  */
  for (i = 0; i < envc; ++i)
    {
      unsigned len = strlen (env[i]) + 1;
      sim_write (sd, sp_flat, env[i], len);
      sim_write (sd, sp, (void *)&sp_flat, 4);
      sp_flat += len;
      sp += 4;
    }

  /* Set some callbacks.  */
  cb->syscall_map = cb_linux_syscall_map;
  cb->errno_map = cb_linux_errno_map;
  cb->open_map = cb_linux_open_map;
  cb->signal_map = cb_linux_signal_map;
  cb->stat_map = stat_map;
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

  /* Standalone mode (i.e. `bfin-...-run`) will take care of the argv
     for us in sim_open() -> sim_parse_args().  But in debug mode (i.e.
     'target sim' with `bfin-...-gdb`), we need to handle it.  */
  if (STATE_OPEN_KIND (sd) == SIM_OPEN_DEBUG)
    {
      free (STATE_PROG_ARGV (sd));
      STATE_PROG_ARGV (sd) = dupargv (argv);
    }

  switch (STATE_ENVIRONMENT (sd))
    {
    case USER_ENVIRONMENT:
      bfin_user_init (sd, cpu, argv, env);
      break;
    }

  return SIM_RC_OK;
}

void
sim_do_command (SIM_DESC sd, char *cmd)
{
  if (sim_args_command (sd, cmd) != SIM_RC_OK)
    sim_io_eprintf (sd, "Unknown command `%s'\n", cmd);
}
