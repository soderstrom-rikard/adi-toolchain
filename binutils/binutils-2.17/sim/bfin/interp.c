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

#include "config.h"

#include <signal.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "sysdep.h"
#include "bfd.h"
#include "gdb/callback.h"
#include "bfin-sim.h"
#include "gdb/sim-bfin.h"

/* This file is local - if newlib changes, then so should this.  */
#include "syscall.h"

#include <math.h>

#ifdef _WIN32
#include <float.h>		/* Needed for _isnan().  */
#define isnan _isnan
#endif

#ifndef SIGBUS
#define SIGBUS SIGSEGV
#endif

#ifndef SIGQUIT
#define SIGQUIT SIGTERM
#endif

#ifndef SIGTRAP
#define SIGTRAP 5
#endif

/* Define the rate at which the simulator should poll the host
   for a quit. */
#define POLL_QUIT_INTERVAL 0x60000

saved_state_type saved_state;

static char **prog_argv;
static SIM_OPEN_KIND sim_kind;
static char *myname;
static int tracing = 0;
static host_callback *callback;

#if defined(__GO32__) || defined(_WIN32)
int sim_memory_size = 19;
#else
int sim_memory_size = 24;
#endif


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

/* This function exists mainly for the purpose of setting a breakpoint to
   catch simulated bus errors when running the simulator under GDB.  */

void
raise_exception (int x)
{
  saved_state.exception = x;
}

void
raise_buserror ()
{
  raise_exception (SIGBUS);
}

static int
get_now ()
{
  return time ((long *) 0);
}

static int
now_persec ()
{
  return 1;
}

/* Simulate a monitor trap, put the result into r0 and errno into r1
   return offset by which to adjust pc.  */

void
bfin_trap ()
{
  int reason = DREG (2);
  int sys = DREG (0);
  bu32 args = DREG (1);

  switch (sys)
    {
    case SYS_exit:
      saved_state.exception = SIGQUIT;
      DREG (0) = get_long (saved_state.memory, args);
      return;
    case SYS_open:
      {
	char *arg0 = (char *)(saved_state.memory + get_long (saved_state.memory, args));
	bu32 arg1 = get_long (saved_state.memory, args + 4);
	bu32 arg2 = get_long (saved_state.memory, args + 8);
	if (strcmp (arg0, ":tt") == 0)
	  DREG (0) = arg2 == 4 ? 0 : 1;
	else
	  DREG (0) = callback->open (callback, arg0, arg1);
      }
      return;

    case SYS_write:
      {
	bu32 arg0 = get_long (saved_state.memory, args);
	char *arg1 = (char *)(saved_state.memory + get_long (saved_state.memory, args + 4));
	bu32 arg2 = get_long (saved_state.memory, args + 8);
	DREG (0) = callback->write (callback, arg0, arg1, arg2);
      }
      return;

    case SYS_read:
      {
	bu32 arg0 = get_long (saved_state.memory, args);
	char *arg1 = (char *)(saved_state.memory + get_long (saved_state.memory, args + 4));
	bu32 arg2 = get_long (saved_state.memory, args + 8);
	DREG (0) = callback->read (callback, arg0, arg1, arg2);
      }
      return;
      
    case SYS_kill:
      printf ("Killing with signal %d\n", get_long (saved_state.memory, args + 4));
      raise (SIGABRT);

    case SYS_close:
      DREG (0) = callback->close (callback, get_long (saved_state.memory, args));
      return;
    case SYS_argc:
      DREG (0) = count_argc (prog_argv);
      break;
    case SYS_argnlen:
      {
	bu32 arg0 = get_long (saved_state.memory, args);
	if (arg0 < count_argc (prog_argv))
	  DREG (0) = strlen (prog_argv[arg0]);
	else
	  DREG (0) = -1;
      }
      return;
    case SYS_argn:
      {
	bu32 arg0 = get_long (saved_state.memory, args);
	char *arg1 = (char *)(saved_state.memory + get_long (saved_state.memory, args + 4));
	if (arg0 < count_argc (prog_argv))
	  {
	    /* Include the termination byte.  */
	    int i = strlen (prog_argv[arg0]) + 1;
	    DREG (0) = get_long (saved_state.memory, args + 4);
	    memcpy (arg1, prog_argv[arg0], i);
	  }
	else
	  DREG (0) = -1;
      }
      return;
    case SYS_time:
      DREG (0) = get_now ();
      return;
    default:
      abort ();
    }
}

void
control_c (int sig)
{
  raise_exception (SIGINT);
}

/* Set the memory size to the power of two provided. */

void
sim_size (int power)
{
  saved_state.msize = 1 << power;

  sim_memory_size = power;

  if (saved_state.memory)
    free (saved_state.memory);

  saved_state.memory =
    (unsigned char *) calloc (64, saved_state.msize / 64);

  if (!saved_state.memory)
    {
      fprintf (stderr,
	       "Not enough VM for simulation of %d bytes of RAM\n",
	       saved_state.msize);

      saved_state.msize = 1;
      saved_state.memory = (unsigned char *) calloc (1, 1);
    }
}

static void
init_pointers ()
{
  if (saved_state.msize != 1 << sim_memory_size)
    sim_size (sim_memory_size);
}

#define MMASKB ((saved_state.msize -1) & ~0)

int
sim_stop (SIM_DESC sd)
{
  raise_exception (SIGINT);
  return 1;
}

/* Set by an instruction emulation function if we performed a jump.  */
int did_jump;

/* Execute a single instruction.  */

static void
step_once (SIM_DESC sd)
{
  bu32 oldpc = PCREG;

  if (tracing)
    fprintf (stderr, "PC: %08x, insn: %04x\n", PCREG,
	     get_word (saved_state.memory, PCREG));

  did_jump = 0;
  interp_insn_bfin (PCREG);

  /* @@@ Not sure how the hardware really behaves when the last insn
     of a loop is a jump.  */
  if (!did_jump)
    {
      if (LC1REG && oldpc == LB1REG && --LC1REG)
	PCREG = LT1REG;
      else if (LC0REG && oldpc == LB0REG && --LC0REG)
	PCREG = LT0REG;
    }
}

void
sim_resume (SIM_DESC sd, int step, int siggnal)
{
  register int insts = 0;

  int tick_start = get_now ();
  void (*prev) () = signal (SIGINT, control_c);
  void (*prev_fpe) () = signal (SIGFPE, SIG_IGN);

  init_pointers ();

  /* clear exceptions else it will stop */
  saved_state.exception = 0;

  if(step)
    {
      while(step && saved_state.exception == 0)
	{
	  /* not clear if this will be > 1. Potential problem area */
	  step_once(sd);
	  step--;
	}
      /* Emulate a hardware single step ... raise an exception */
      saved_state.exception = SIGTRAP;
    }
  else
    while (saved_state.exception == 0)
      step_once(sd);

  saved_state.ticks += get_now () - tick_start;
  saved_state.insts += insts;

  signal (SIGFPE, prev_fpe);
  signal (SIGINT, prev);
}

int
sim_write (SIM_DESC sd, SIM_ADDR addr, unsigned char *buffer, int size)
{
  int i;

  init_pointers ();

  for (i = 0; i < size; i++)
    saved_state.memory[(MMASKB & (addr + i))] = buffer[i];

  return size;
}

int
sim_read (SIM_DESC sd, SIM_ADDR addr, unsigned char *buffer, int size)
{
  int i;

  init_pointers ();

  for (i = 0; i < size; i++)
    buffer[i] = saved_state.memory[(MMASKB & (addr + i))];

  return size;
}

int
sim_trace (SIM_DESC sd)
{
  tracing = 1;
  sim_resume (sd, 0, 0);
  tracing = 0;
  return 1;
}

void
sim_stop_reason (SIM_DESC sd, enum sim_stop *reason, int *sigrc)
{
  if (saved_state.exception == SIGQUIT)
    {
      *reason = sim_exited;
      *sigrc = DREG (0);
    }
  else
    {
      *reason = sim_stopped;
      *sigrc = saved_state.exception;
    }
}

void
sim_info (SIM_DESC sd, int verbose)
{
  double timetaken = 
    (double) saved_state.ticks / (double) now_persec ();

  callback->printf_filtered (callback, "\n\n# instructions executed  %10d\n", 
			     saved_state.insts);
  callback->printf_filtered (callback, "# real time taken        %10.4f\n",
			     timetaken);
}

static void
parse_and_set_memory_size (char *str)
{
  int n;

  n = strtol (str, NULL, 10);
  if (n > 0 && n <= 24)
    sim_memory_size = n;
  else
    callback->printf_filtered (callback,
			"Bad memory size %d; must be 1 to 24, inclusive\n", n);
}

SIM_DESC
sim_open (SIM_OPEN_KIND kind, host_callback *cb,
	  struct bfd *abfd, char **argv)
{
  char **p;

  sim_kind = kind;
  myname = argv[0];
  callback = cb;

  for (p = argv + 1; *p != NULL; ++p)
    if (isdigit (**p))
      parse_and_set_memory_size (*p);

  /* fudge our descriptor for now */
  return (SIM_DESC) 1;
}

void
sim_close (SIM_DESC sd, int quitting)
{
  /* Nothing to do.  */
}

SIM_RC
sim_load (SIM_DESC sd, char *prog, bfd *abfd, int from_tty)
{
  extern bfd *sim_load_file (); /* ??? Don't know where this should live.  */
  bfd *prog_bfd;

  prog_bfd = sim_load_file (sd, myname, callback, prog, abfd,
			    sim_kind == SIM_OPEN_DEBUG,
			    0, sim_write);

  /* Set the bfd machine type.  */
  if (prog_bfd)
    saved_state.bfd_mach = bfd_get_mach (prog_bfd);
  else if (abfd)
    saved_state.bfd_mach = bfd_get_mach (abfd);
  else
    saved_state.bfd_mach = 0;

  if (prog_bfd == NULL)
    return SIM_RC_FAIL;
  if (abfd == NULL)
    bfd_close (prog_bfd);
  return SIM_RC_OK;
}

SIM_RC
sim_create_inferior (SIM_DESC sd, struct bfd *prog_bfd,
		     char **argv, char **env)
{
  /* Clear the registers.  */
  memset (&saved_state, 0,
	  (char*) &saved_state.end_of_registers - (char*) &saved_state);

  /* Set the PC.  */
  if (prog_bfd != NULL)
    saved_state.pc = bfd_get_start_address (prog_bfd);

  SPREG = saved_state.msize;
  /* Set the bfd machine type.  */
  if (prog_bfd != NULL)
    saved_state.bfd_mach = bfd_get_mach (prog_bfd);

  /* Record the program's arguments.  */
  prog_argv = argv;

  return SIM_RC_OK;
}

void
sim_do_command (SIM_DESC sd, char *cmd)
{
  char *sms_cmd = "set-memory-size";
  int cmdsize;

  if (cmd == NULL || *cmd == '\0')
    cmd = "help";

  cmdsize = strlen (sms_cmd);
  if (strncmp (cmd, sms_cmd, cmdsize) == 0 
      && strchr (" \t", cmd[cmdsize]) != NULL)
    parse_and_set_memory_size (cmd + cmdsize + 1);
  else if (strcmp (cmd, "help") == 0)
    {
      (callback->printf_filtered) (callback, 
				   "List of Blackfin simulator commands:\n\n");
      (callback->printf_filtered) (callback, "help <n> -- Display this information\n");
      (callback->printf_filtered) (callback, "set-memory-size <n> -- Set the number of address bits to use\n");
      (callback->printf_filtered) (callback, "\n");
    }
  else
    (callback->printf_filtered) (callback, "Error: \"%s\" is not a valid Blackfin simulator command.\n", cmd);
}

void
sim_set_callbacks (host_callback *p)
{
  callback = p;
}

static bu32
bfin_extract_unsigned_integer (unsigned char *addr, int len)
{
  bu32 retval;
  unsigned char * p;
  unsigned char * startaddr = (unsigned char *)addr;
  unsigned char * endaddr = startaddr + len;
 
  retval = 0;

  for (p = endaddr; p > startaddr;)
    retval = (retval << 8) | *--p;
 
  return retval;
}

static void
bfin_store_unsigned_integer (unsigned char *addr, int len, bu32 val)
{
  unsigned char *p;
  unsigned char *startaddr = addr;
  unsigned char *endaddr = startaddr + len;

  for (p = startaddr; p < endaddr;)
    {
      *p++ = val & 0xff;
      val >>= 8;
    }
}

int
sim_fetch_register (SIM_DESC sd, int rn, unsigned char *memory, int length)
{
  bu32 value;

  init_pointers ();
  switch (rn)
    {
    case SIM_BFIN_R0_REGNUM : value = DREG(0); break;
    case SIM_BFIN_R1_REGNUM : value = DREG(1); break;
    case SIM_BFIN_R2_REGNUM : value = DREG(2); break;
    case SIM_BFIN_R3_REGNUM : value = DREG(3); break;
    case SIM_BFIN_R4_REGNUM : value = DREG(4); break;
    case SIM_BFIN_R5_REGNUM : value = DREG(5); break;
    case SIM_BFIN_R6_REGNUM : value = DREG(6); break;
    case SIM_BFIN_R7_REGNUM : value = DREG(7); break;
    case SIM_BFIN_P0_REGNUM : value = PREG(0); break;
    case SIM_BFIN_P1_REGNUM : value = PREG(1); break;
    case SIM_BFIN_P2_REGNUM : value = PREG(2); break;
    case SIM_BFIN_P3_REGNUM : value = PREG(3); break;
    case SIM_BFIN_P4_REGNUM : value = PREG(4); break;
    case SIM_BFIN_P5_REGNUM : value = PREG(5); break;
    case SIM_BFIN_SP_REGNUM : value = SPREG; break;
    case SIM_BFIN_FP_REGNUM : value = FPREG; break;
    case SIM_BFIN_I0_REGNUM : value = IREG(0); break;
    case SIM_BFIN_I1_REGNUM : value = IREG(1); break;
    case SIM_BFIN_I2_REGNUM : value = IREG(2); break;
    case SIM_BFIN_I3_REGNUM : value = IREG(3); break;
    case SIM_BFIN_M0_REGNUM : value = MREG(0); break;
    case SIM_BFIN_M1_REGNUM : value = MREG(1); break;
    case SIM_BFIN_M2_REGNUM : value = MREG(2); break;
    case SIM_BFIN_M3_REGNUM : value = MREG(3); break;
    case SIM_BFIN_B0_REGNUM : value = BREG(0); break;
    case SIM_BFIN_B1_REGNUM : value = BREG(1); break;
    case SIM_BFIN_B2_REGNUM : value = BREG(2); break;
    case SIM_BFIN_B3_REGNUM : value = BREG(3); break;
    case SIM_BFIN_L0_REGNUM : value = LREG(0); break;
    case SIM_BFIN_L1_REGNUM : value = LREG(1); break;
    case SIM_BFIN_L2_REGNUM : value = LREG(2); break;
    case SIM_BFIN_L3_REGNUM : value = LREG(3); break;
    case SIM_BFIN_RETS_REGNUM : value = RETSREG; break;
    case SIM_BFIN_A0_DOT_X_REGNUM : value = A0XREG; break;
    case SIM_BFIN_AO_DOT_W_REGNUM : value = A0WREG; break;
    case SIM_BFIN_A1_DOT_X_REGNUM : value = A1XREG; break;
    case SIM_BFIN_A1_DOT_W_REGNUM : value = A1WREG; break;
    case SIM_BFIN_LC0_REGNUM : value = LC0REG; break;
    case SIM_BFIN_LT0_REGNUM : value = LT0REG; break;
    case SIM_BFIN_LB0_REGNUM : value = LB0REG; break;
    case SIM_BFIN_LC1_REGNUM : value = LC1REG; break;
    case SIM_BFIN_LT1_REGNUM : value = LT1REG; break;
    case SIM_BFIN_LB1_REGNUM : value = LB1REG; break;
    case SIM_BFIN_PC_REGNUM : value = PCREG; break;
    case SIM_BFIN_CC_REGNUM : value = CCREG; break;
    default :
      return 0; // will be an error in gdb
      break;
  }

  bfin_store_unsigned_integer (memory, 4, value);

  return -1; // disables size checking in gdb
}

int
sim_store_register (SIM_DESC sd, int rn, unsigned char *memory, int length)
{
  bu32 value;

  value = bfin_extract_unsigned_integer (memory, 4);

  init_pointers ();
  switch (rn)
    {
    case SIM_BFIN_R0_REGNUM : DREG(0) = value; break;
    case SIM_BFIN_R1_REGNUM : DREG(1) = value; break;
    case SIM_BFIN_R2_REGNUM : DREG(2) = value; break;
    case SIM_BFIN_R3_REGNUM : DREG(3) = value; break;
    case SIM_BFIN_R4_REGNUM : DREG(4) = value; break;
    case SIM_BFIN_R5_REGNUM : DREG(5) = value; break;
    case SIM_BFIN_R6_REGNUM : DREG(6) = value; break;
    case SIM_BFIN_R7_REGNUM : DREG(7) = value; break;
    case SIM_BFIN_P0_REGNUM : PREG(0) = value; break;
    case SIM_BFIN_P1_REGNUM : PREG(1) = value; break;
    case SIM_BFIN_P2_REGNUM : PREG(2) = value; break;
    case SIM_BFIN_P3_REGNUM : PREG(3) = value; break;
    case SIM_BFIN_P4_REGNUM : PREG(4) = value; break;
    case SIM_BFIN_P5_REGNUM : PREG(5) = value; break;
    case SIM_BFIN_SP_REGNUM : SPREG = value; break;
    case SIM_BFIN_FP_REGNUM : FPREG = value; break;
    case SIM_BFIN_I0_REGNUM : IREG(0) = value; break;
    case SIM_BFIN_I1_REGNUM : IREG(1) = value; break;
    case SIM_BFIN_I2_REGNUM : IREG(2) = value; break;
    case SIM_BFIN_I3_REGNUM : IREG(3) = value; break;
    case SIM_BFIN_M0_REGNUM : MREG(0) = value; break;
    case SIM_BFIN_M1_REGNUM : MREG(1) = value; break;
    case SIM_BFIN_M2_REGNUM : MREG(2) = value; break;
    case SIM_BFIN_M3_REGNUM : MREG(3) = value; break;
    case SIM_BFIN_B0_REGNUM : BREG(0) = value; break;
    case SIM_BFIN_B1_REGNUM : BREG(1) = value; break;
    case SIM_BFIN_B2_REGNUM : BREG(2) = value; break;
    case SIM_BFIN_B3_REGNUM : BREG(3) = value; break;
    case SIM_BFIN_L0_REGNUM : LREG(0) = value; break;
    case SIM_BFIN_L1_REGNUM : LREG(1) = value; break;
    case SIM_BFIN_L2_REGNUM : LREG(2) = value; break;
    case SIM_BFIN_L3_REGNUM : LREG(3) = value; break;
    case SIM_BFIN_RETS_REGNUM : RETSREG = value; break;
    case SIM_BFIN_A0_DOT_X_REGNUM : A0XREG = value; break;
    case SIM_BFIN_AO_DOT_W_REGNUM : A0WREG = value; break;
    case SIM_BFIN_A1_DOT_X_REGNUM : A1XREG = value; break;
    case SIM_BFIN_A1_DOT_W_REGNUM : A1WREG = value; break;
    case SIM_BFIN_LC0_REGNUM : LC0REG = value; break;
    case SIM_BFIN_LT0_REGNUM : LT0REG = value; break;
    case SIM_BFIN_LB0_REGNUM : LB0REG = value; break;
    case SIM_BFIN_LC1_REGNUM : LC1REG = value; break;
    case SIM_BFIN_LT1_REGNUM : LT1REG = value; break;
    case SIM_BFIN_LB1_REGNUM : LB1REG = value; break;
    case SIM_BFIN_PC_REGNUM : PCREG = value; break;
    case SIM_BFIN_CC_REGNUM : CCREG = value; break;
    default :
      return 0; // will be an error in gdb
      break;
  }

  return -1; // disables size checking in gdb
}

