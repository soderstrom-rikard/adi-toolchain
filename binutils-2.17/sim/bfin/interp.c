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
#include <fcntl.h>
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

#define CB_SYS_ioctl    200 /* XXX: hack for simple uClibc stdio!  */
#define CB_SYS_mmap2    201 /* XXX: this gets us malloc()  */
#define CB_SYS_dup2     202
#define CB_SYS_getuid   203
#define CB_SYS_getuid32 205
#define CB_SYS_getgid   206
#define CB_SYS_getgid32 207
#define CB_SYS_setuid   208
#define CB_SYS_setuid32 209
#define CB_SYS_setgid   210
#define CB_SYS_setgid32 211
#include "targ-linux.h"

#include "elf/common.h"
#include "elf/external.h"
#include "elf/internal.h"
#include "elf/bfin.h"

#include "dv-bfin_cec.h"
#include "dv-bfin_mmu.h"

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

  MAYBE_TRACE (CORE, cpu, "DBUS FETCH (syscall) %i bytes @ 0x%08lx", bytes, taddr);

  return sim_core_read_buffer (sd, cpu, read_map, buf, taddr, bytes);
}

static int
syscall_write_mem (host_callback *cb, struct cb_syscall *sc,
		  unsigned long taddr, const char *buf, int bytes)
{
  SIM_DESC sd = (SIM_DESC) sc->p1;
  SIM_CPU *cpu = (SIM_CPU *) sc->p2;

  MAYBE_TRACE (CORE, cpu, "DBUS STORE (syscall) %i bytes @ 0x%08lx", bytes, taddr);

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
      /* XXX: Support enough of mmap to get malloc().  No one checks
              munmap() return value in malloc(), so skip that syscall.  */
      if (sc.arg4 & 0x20 /*MAP_ANONYMOUS*/)
	{
	  static bu32 heap = BFIN_DEFAULT_MEM_SIZE / 2;
	  sc.result = heap;
	  heap += sc.arg2;
	  /* Keep it page aligned.  */
	  heap = ALIGN (heap, 4096);
	}
      else
	{
	  sc.result = -1;
	  sc.errcode = TARGET_ENOSYS;
	}
      break;

    case CB_SYS_dup2:
      sc.result = dup2 (sc.arg1, sc.arg2);
      goto sys_finish;

    case CB_SYS_getuid:
    case CB_SYS_getuid32:
      sc.result = getuid ();
      goto sys_finish;
    case CB_SYS_getgid:
    case CB_SYS_getgid32:
      sc.result = getgid ();
      goto sys_finish;
    case CB_SYS_setuid:
      sc.arg1 &= 0xffff;
    case CB_SYS_setuid32:
      sc.result = setuid (sc.arg1);
      goto sys_finish;
    case CB_SYS_setgid:
      sc.arg1 &= 0xffff;
    case CB_SYS_setgid32:
      sc.result = setgid (sc.arg1);
      goto sys_finish;

    default:
      cb_syscall (cb, &sc);
      break;

    sys_finish:
      if (sc.result == -1)
	sc.errcode = cb->get_errno (cb);
    }

  TRACE_EVENTS (cpu, "syscall_%i(%#x, %#x, %#x, %#x, %#x, %#x) = %li (error = %i)",
		sc.func, args[0], args[1], args[2], args[3], args[4], args[5],
		sc.result, sc.errcode);

  if (STATE_ENVIRONMENT (sd) == USER_ENVIRONMENT)
    {
      if (sc.result == -1)
	{
	  if (sc.errcode == cb_host_to_target_errno (cb, ENOSYS))
	    sim_io_eprintf (sd, "bfin-sim: unimplemented syscall %i\n", sc.func);
	  SET_DREG (0, -sc.errcode);
	}
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

  ++ PROFILE_TOTAL_INSN_COUNT (CPU_PROFILE_DATA (cpu));

  return oldpc;
}

void
sim_engine_run (SIM_DESC sd,
		int next_cpu_nr, /* ignore */
		int nr_cpus, /* ignore */
		int siggnal) /* ignore */
{
  bu32 ticks;
  SIM_CPU *cpu;

  SIM_ASSERT (STATE_MAGIC (sd) == SIM_MAGIC_NUMBER);

  cpu = STATE_CPU (sd, 0);

  while (1)
    {
      step_once (cpu);
      /* Process any events -- can't use tickn because it may
         advance right over the next event.  */
      for (ticks = 0; ticks < CYCLE_DELAY; ++ticks)
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
bfin_initialize_cpu (SIM_DESC sd, SIM_CPU *cpu)
{
  memset (&cpu->state, 0, sizeof (cpu->state));

  PROFILE_TOTAL_INSN_COUNT (CPU_PROFILE_DATA (cpu)) = 0;

  bfin_model_cpu_init (sd, cpu);

  /* Set default stack to top of scratch pad.  */
  SET_SPREG (BFIN_DEFAULT_MEM_SIZE);
  SET_KSPREG (BFIN_DEFAULT_MEM_SIZE);
  SET_USPREG (BFIN_DEFAULT_MEM_SIZE);

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

  /* Allocate external memory if none specified by user.
     Use address 4 here in case the user wanted address 0 unmapped.  */
  if (sim_core_read_buffer (sd, NULL, read_map, &c, 4, 1) == 0)
    sim_do_commandf (sd, "memory-size 0x%lx", BFIN_DEFAULT_MEM_SIZE);

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
bfin_user_init (SIM_DESC sd, SIM_CPU *cpu, struct bfd *abfd,
		char * const *argv, char * const *env)
{
  /* XXX: Missing host -> target endian ...  */
  /* Linux starts the user app with the stack:
       argc
       argv[0]          -- pointers to the actual strings
       argv[1..N]
       NULL
       env[0]
       env[1..N]
       NULL
       auxvt[0].type    -- ELF Auxiliary Vector Table
       auxvt[0].value
       auxvt[1..N]
       AT_NULL
       0
       argv[0..N][0..M] -- actual argv/env strings
       env[0..N][0..M]
       FDPIC loadmaps   -- for FDPIC apps
     So set things up the same way.  */
  int i, argc, envc;
  bu32 argv_flat, env_flat;

  bu32 sp, sp_flat;

  Elf32_External_Ehdr ehdr;
  Elf_Internal_Phdr *phdrs;
  long phdr_size;
  int phdrc;
  bu32 fdpic, pt_dynamic;
  bu32 auxvt, auxvt_size;

  unsigned char null[4] = { 0, 0, 0, 0 };

  host_callback *cb = STATE_CALLBACK (sd);

  /* See if this an FDPIC ELF.  */
  phdrs = NULL;
  auxvt = 0;
  if (!abfd)
    goto skip_fdpic_init;
  if (bfd_seek (abfd, 0, SEEK_SET) != 0)
    goto skip_fdpic_init;
  if (bfd_bread (&ehdr, sizeof (ehdr), abfd) != sizeof (ehdr))
    goto skip_fdpic_init;
  if (!(ehdr.e_flags[0] & EF_BFIN_FDPIC))
    goto skip_fdpic_init;

  /* Grab the Program Headers to set up the loadsegs on the stack.  */
  phdr_size = bfd_get_elf_phdr_upper_bound (abfd);
  if (phdr_size == -1)
    goto skip_fdpic_init;
  phdrs = xmalloc (phdr_size);
  phdrc = bfd_get_elf_phdrs (abfd, phdrs);
  if (phdrc == -1)
    goto skip_fdpic_init;
  sp = SPREG;
  /* XXX: Static FDPIC loads with lma==vma.  */
  fdpic = 0;
  for (i = phdrc; i >= 0; --i)
    if (phdrs[i].p_type == PT_LOAD)
      {
	bu32 v;
	sp -= 12;
	v = phdrs[i].p_paddr;
	sim_write (sd, sp+0, (void *)&v, 4); /* loadseg.addr */
	v = phdrs[i].p_vaddr;
	sim_write (sd, sp+4, (void *)&v, 4); /* loadseg.p_vaddr */
	v = phdrs[i].p_memsz;
	sim_write (sd, sp+8, (void *)&v, 4); /* loadseg.p_memsz */
	++fdpic;
      }
    else if (phdrs[i].p_type == PT_DYNAMIC)
      pt_dynamic = phdrs[i].p_paddr;
    else if (phdrs[i].p_type == PT_INTERP)
      sim_io_eprintf (sd, "bfin-sim: dynamic FDPIC not supported\n");

  /* Push the summary loadmap info onto the stack last.  */
  sp -= 4;
  sim_write (sd, sp+0, null, 2); /* loadmap.version */
  sim_write (sd, sp+2, (void *)&fdpic, 2); /* loadmap.nsegs */

  /* Finally setup the registers required by the FDPIC ABI.  */
  SET_DREG (7, 0); /* Zero out FINI funcptr -- ldso will set this up.  */
  SET_PREG (0, sp); /* Exec loadmap addr.  */
  /* XXX: Only static FDPIC is supported atm.  */
  SET_PREG (1, 0); /* Interp loadmap addr.  */
  SET_PREG (2, pt_dynamic); /* PT_DYNAMIC map addr.  */

  auxvt = 1;
  SET_SPREG (sp);
 skip_fdpic_init:
  free (phdrs);

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

  /* Push the Auxiliary Vector Table between argv/env and actual strings.  */
  sp_flat = sp = ALIGN (SPREG - argv_flat - env_flat - 4, 4);
  if (auxvt)
    {
# define AT_PUSH(at, val) \
  auxvt_size += 8; \
  sp -= 4; \
  auxvt = (val); \
  sim_write (sd, sp, (void *)&auxvt, 4); \
  sp -= 4; \
  auxvt = (at); \
  sim_write (sd, sp, (void *)&auxvt, 4)
  auxvt_size = 0;
      AT_PUSH (AT_NULL, 0);
      AT_PUSH (AT_PAGESZ, 4096);
      AT_PUSH (AT_UID, getuid ());
      AT_PUSH (AT_GID, getgid ());
      AT_PUSH (AT_EUID, geteuid ());
      AT_PUSH (AT_EGID, getegid ());
      AT_PUSH (AT_HWCAP, 0);
      AT_PUSH (AT_FLAGS, 0);
      AT_PUSH (AT_PHDR, 0 /* addr where PT's are mapped */);
      AT_PUSH (AT_PHNUM, 0 /*phdrc*/);
      /*AT_PUSH (AT_ENTRY, ehdr.e_entry);*/
      AT_PUSH (AT_BASE, 0 /* addr wheer Ehdr is mapped */);
      AT_PUSH (AT_CLKTCK, 100); /* XXX: This ever not 100 ?  */
#undef AT_PUSH
    }
  SET_SPREG (sp);

  /* Push the argc/argv/env after the auxvt.  */
  sp -= ((1 + argc + 1 + envc + 1) * 4);
  SET_SPREG (sp);

  /* First push the argc value.  */
  sim_write (sd, sp, (void *)&argc, 4);
  sp += 4;

  /* Then the actual argv strings so we know where to point argv[].  */
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

static void
bfin_os_init (SIM_DESC sd, SIM_CPU *cpu, char * const *argv)
{
  /* Pass the command line via a string in R0 like Linux expects.  */
  int i;
  bu8 byte;
  bu32 cmdline = BFIN_L1_SRAM_SCRATCH;

  SET_DREG (0, cmdline);
  if (argv[0])
    {
      i = 1;
      byte = ' ';
      while (argv[i])
	{
	  bu32 len = strlen (argv[i]);
	  sim_write (sd, cmdline, argv[i], len);
	  cmdline += len;
	  sim_write (sd, cmdline, &byte, 1);
	  ++cmdline;
	  ++i;
	}
    }
  byte = 0;
  sim_write (sd, cmdline, &byte, 1);
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
      bfin_user_init (sd, cpu, abfd, argv, env);
      break;
    case OPERATING_ENVIRONMENT:
      bfin_os_init (sd, cpu, argv);
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
