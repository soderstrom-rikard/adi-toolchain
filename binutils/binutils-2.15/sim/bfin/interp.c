/* Simulator for the Renesas (formerly Hitachi) / SuperH Inc. SH architecture.

   Written by Steve Chamberlain of Cygnus Support.
   sac@cygnus.com

   This file is part of SH sim


		THIS SOFTWARE IS NOT COPYRIGHTED

   Cygnus offers the following for use in the public domain.  Cygnus
   makes no warranty with regard to the software or it's performance
   and the user accepts the software "AS IS" with all faults.

   CYGNUS DISCLAIMS ANY WARRANTIES, EXPRESS OR IMPLIED, WITH REGARD TO
   THIS SOFTWARE INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

*/

#include "config.h"

#include <signal.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "sysdep.h"
#include "bfd.h"
#include "gdb/callback.h"
#include "gdb/remote-sim.h"
#include "bfin-sim.h"
#include "gdb/sim-bfin.h"

/* This file is local - if newlib changes, then so should this.  */
#include "syscall.h"

#include <math.h>

#ifdef _WIN32
#include <float.h>		/* Needed for _isnan() */
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

int sim_write (SIM_DESC sd, SIM_ADDR addr, unsigned char *buffer, int size);

#define O_RECOMPILE 85
#define DEFINE_TABLE
#define DISASSEMBLER_TABLE

/* Define the rate at which the simulator should poll the host
   for a quit. */
#define POLL_QUIT_INTERVAL 0x60000

saved_state_type saved_state;

struct loop_bounds { unsigned char *start, *end; };

/* These variables are at file scope so that functions other than
   sim_resume can use the fetch/store macros */

static int target_little_endian;
static int global_endianw, endianb;
static int target_dsp;
static char **prog_argv;

static int maskw = 0;
static int maskl = 0;

static SIM_OPEN_KIND sim_kind;
static char *myname;
static int   tracing = 0;


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

int 
fail ()
{
  abort ();
}

/* This function exists mainly for the purpose of setting a breakpoint to
   catch simulated bus errors when running the simulator under GDB.  */

void
raise_exception (x)
     int x;
{
  //raise (x);
  saved_state.exception = x;
  if(x != SIGTRAP){
    raise(x);
  }
}

void
raise_buserror ()
{
  raise_exception (SIGBUS);
}


/* FIXME: sim_resume should be renamed to sim_engine_run.  sim_resume
   being implemented by ../common/sim_resume.c and the below should
   make a call to sim_engine_halt */

#define BUSERROR(addr, mask) ((addr) & (mask))

#define WRITE_BUSERROR(addr, mask, data, addr_func) \
  do \
    { \
      if (addr & mask) \
	{ \
	  raise (SIGBUS); \
	  return; \
	} \
    } \
  while (0)

#define READ_BUSERROR(addr, mask, addr_func) \
  do \
    { \
      if (addr & mask) \
	raise (SIGBUS); \
    } \
  while (0)

/* Define this to enable register lifetime checking.
   The compiler generates "add #0,rn" insns to mark registers as invalid,
   the simulator uses this info to call fail if it finds a ref to an invalid
   register before a def

   #define PARANOID
*/

static void parse_and_set_memory_size PARAMS ((char *str));
static int IOMEM PARAMS ((int addr, int write, int value));
static struct loop_bounds get_loop_bounds PARAMS ((int, int, unsigned char *,
						   unsigned char *, int, int));
static void INLINE wlat_fast PARAMS ((unsigned char *, int, int, int));
static void INLINE wwat_fast PARAMS ((unsigned char *, int, int, int, int));
static void INLINE wbat_fast PARAMS ((unsigned char *, int, int, int));
static int INLINE rlat_fast PARAMS ((unsigned char *, int, int));
static int INLINE rwat_fast PARAMS ((unsigned char *, int, int, int));
static int INLINE rbat_fast PARAMS ((unsigned char *, int, int));

static host_callback *callback;

static void INLINE 
wlat_fast (memory, x, value, maskl)
     unsigned char *memory;
{
  int v = value;
  unsigned int *p = (unsigned int *) (memory + x);
  WRITE_BUSERROR (x, maskl, v, process_wlat_addr);
  *p = v;
}

static void INLINE 
wwat_fast (memory, x, value, maskw, endianw)
     unsigned char *memory;
{
  int v = value;
  unsigned short *p = (unsigned short *) (memory + (x ^ endianw));
  WRITE_BUSERROR (x, maskw, v, process_wwat_addr);
  *p = v;
}

static void INLINE 
wbat_fast (memory, x, value, maskb)
     unsigned char *memory;
{
  unsigned char *p = memory + (x ^ endianb);
  WRITE_BUSERROR (x, maskb, value, process_wbat_addr);

  p[0] = value;
}

/* Read functions */

static int INLINE 
rlat_fast (memory, x, maskl)
     unsigned char *memory;
{
  unsigned int *p = (unsigned int *) (memory + x);
  READ_BUSERROR (x, maskl, process_rlat_addr);

  return *p;
}

static int INLINE 
rwat_fast (memory, x, maskw, endianw)
     unsigned char *memory;
     int x, maskw, endianw;
{
  unsigned short *p = (unsigned short *) (memory + (x ^ endianw));
  READ_BUSERROR (x, maskw, process_rwat_addr);

  return *p;
}

static int INLINE 
riat_fast (insn_ptr, endianw)
     unsigned char *insn_ptr;
{
  unsigned short *p = (unsigned short *) ((size_t) insn_ptr ^ endianw);

  return *p;
}

static int INLINE 
rbat_fast (memory, x, maskb)
     unsigned char *memory;
{
  unsigned char *p = memory + (x ^ endianb);
  READ_BUSERROR (x, maskb, process_rbat_addr);

  return *p;
}

#define RWAT(x) 	(rwat_fast (memory, x, maskw, endianw))
#define RLAT(x) 	(rlat_fast (memory, x, maskl))
#define RBAT(x)         (rbat_fast (memory, x, maskb))
#define RIAT(p)		(riat_fast ((p), endianw))
#define WWAT(x,v) 	(wwat_fast (memory, x, v, maskw, endianw))
#define WLAT(x,v) 	(wlat_fast (memory, x, v, maskl))
#define WBAT(x,v)       (wbat_fast (memory, x, v, maskb))

#define RUWAT(x)  (RWAT (x) & 0xffff)
#define RSWAT(x)  ((short) (RWAT (x)))
#define RSLAT(x)  ((long) (RLAT (x)))
#define RSBAT(x)  (SEXT (RBAT (x)))

#if defined(__GO32__) || defined(_WIN32)
int sim_memory_size = 19;
#else
int sim_memory_size = 24;
#endif

static int sim_profile_size = 17;
static int nsamples;

#undef TB
#define TB(x,y)

#define SMR1 (0x05FFFEC8)	/* Channel 1  serial mode register */
#define BRR1 (0x05FFFEC9)	/* Channel 1  bit rate register */
#define SCR1 (0x05FFFECA)	/* Channel 1  serial control register */
#define TDR1 (0x05FFFECB)	/* Channel 1  transmit data register */
#define SSR1 (0x05FFFECC)	/* Channel 1  serial status register */
#define RDR1 (0x05FFFECD)	/* Channel 1  receive data register */

#define SCI_RDRF  	 0x40	/* Recieve data register full */
#define SCI_TDRE	0x80	/* Transmit data register empty */

static int
IOMEM (addr, write, value)
     int addr;
     int write;
     int value;
{
  if (write)
    {
      switch (addr)
	{
	case TDR1:
	  if (value != '\r')
	    {
	      putchar (value);
	      fflush (stdout);
	    }
	  break;
	}
    }
  else
    {
      switch (addr)
	{
	case RDR1:
	  return getchar ();
	}
    }
  return 0;
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

static FILE *profile_file;

static unsigned INLINE
swap (n)
     unsigned n;
{
  if (endianb)
    n = (n << 24 | (n & 0xff00) << 8
	 | (n & 0xff0000) >> 8 | (n & 0xff000000) >> 24);
  return n;
}

static unsigned short INLINE
swap16 (n)
     unsigned short n;
{
  if (endianb)
    n = n << 8 | (n & 0xff00) >> 8;
  return n;
}

static void
swapout (n)
     int n;
{
  if (profile_file)
    {
      union { char b[4]; int n; } u;
      u.n = swap (n);
      fwrite (u.b, 4, 1, profile_file);
    }
}

static void
swapout16 (n)
     int n;
{
  union { char b[4]; int n; } u;
  u.n = swap16 (n);
  fwrite (u.b, 2, 1, profile_file);
}

/* Turn a pointer in a register into a pointer into real memory. */

static char *
ptr (x)
     int x;
{
  return (char *) (x + saved_state.memory);
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
      exit (get_long (saved_state.memory, args));
      return;
    case SYS_open:
      {
	char *arg0 = saved_state.memory + get_long (saved_state.memory, args);
	bu32 arg1 = get_long (saved_state.memory, args + 4);
	bu32 arg2 = get_long (saved_state.memory, args + 8);
	if (strcmp (arg0, ":tt") == 0)
	  {
	    DREG (0) = arg2 == 3 ? 0 : 1;
	  }
	else
	  DREG (0) = callback->open (callback, arg0, arg1);
      }
      return;

    case SYS_write:
      {
	bu32 arg0 = get_long (saved_state.memory, args);
	char *arg1 = saved_state.memory + get_long (saved_state.memory, args + 4);
	bu32 arg2 = get_long (saved_state.memory, args + 8);
	DREG (0) = callback->write (callback, arg0, arg1, arg2);
      }
      return;
      
    case SYS_kill:
      printf ("Killing with signal %d\n", get_long (saved_state.memory, args + 4));
      raise (SIGABRT);

    case SYS_close:
      printf ("Closing %d\n", get_long (saved_state.memory, args));
      DREG (0) = callback->close (callback, get_long (saved_state.memory, args));
      return;
    default:
      abort ();
    }

#if 0
  switch (i)
    {
    case 1:
      printf ("%c", regs[0]);
      break;
    case 2:
      raise_exception (SIGQUIT);
      break;
    case 34:
      {
	extern int errno;
	int perrno = errno;
	errno = 0;

	switch (regs[4])
	  {

#if !defined(__GO32__) && !defined(_WIN32)
	  case SYS_fork:
	    regs[0] = fork ();
	    break;
/* This would work only if endianness matched between host and target.
   Besides, it's quite dangerous.  */
#if 0
	  case SYS_execve:
	    regs[0] = execve (ptr (regs[5]), (char **) ptr (regs[6]), 
			      (char **) ptr (regs[7]));
	    break;
	  case SYS_execv:
	    regs[0] = execve (ptr (regs[5]), (char **) ptr (regs[6]), 0);
	    break;
#endif
	  case SYS_pipe:
	    {
	      regs[0] = (BUSERROR (regs[5], maskl)
			 ? -EINVAL
			 : pipe ((int *) ptr (regs[5])));
	    }
	    break;

	  case SYS_wait:
	    regs[0] = wait (ptr (regs[5]));
	    break;
#endif /* !defined(__GO32__) && !defined(_WIN32) */

	  case SYS_read:
	    regs[0]
	      = callback->read (callback, regs[5], ptr (regs[6]), regs[7]);
	    break;
	  case SYS_write:
	    if (regs[5] == 1)
	      regs[0] = (int) callback->write_stdout (callback, 
						      ptr (regs[6]), regs[7]);
	    else
	      regs[0] = (int) callback->write (callback, regs[5], 
					       ptr (regs[6]), regs[7]);
	    break;
	  case SYS_lseek:
	    regs[0] = callback->lseek (callback,regs[5], regs[6], regs[7]);
	    break;
	  case SYS_close:
	    regs[0] = callback->close (callback,regs[5]);
	    break;
	  case SYS_open:
	    {
	      regs[0] = callback->open (callback, ptr (regs[5]), regs[6]);
	      break;
	    }
	  case SYS_exit:
	    /* EXIT - caller can look in r5 to work out the reason */
	    raise_exception (SIGQUIT);
	    regs[0] = regs[5];
	    break;

	  case SYS_stat:	/* added at hmsi */
	    /* stat system call */
	    {
	      struct stat host_stat;
	      int buf;

	      regs[0] = stat (ptr (regs[5]), &host_stat);

	      buf = regs[6];

	      put_word (saved_state.memory, buf, host_stat.st_dev);
	      buf += 2;
	      put_word (saved_state.memory, buf, host_stat.st_ino);
	      buf += 2;
	      WLAT (buf, host_stat.st_mode);
	      buf += 4;
	      put_word (saved_state.memory, buf, host_stat.st_nlink);
	      buf += 2;
	      put_word (saved_state.memory, buf, host_stat.st_uid);
	      buf += 2;
	      put_word (saved_state.memory, buf, host_stat.st_gid);
	      buf += 2;
	      put_word (saved_state.memory, buf, host_stat.st_rdev);
	      buf += 2;
	      put_long (saved_state.memory, buf, host_stat.st_size);
	      buf += 4;
	      put_long (saved_state.memory, buf, host_stat.st_atime);
	      buf += 4;
	      put_long (saved_state.memory, buf, 0);
	      buf += 4;
	      put_long (saved_state.memory, buf, host_stat.st_mtime);
	      buf += 4;
	      put_long (saved_state.memory, buf, 0);
	      buf += 4;
	      put_long (saved_state.memory, buf, host_stat.st_ctime);
	      buf += 4;
	      put_long (saved_state.memory, buf, 0);
	      buf += 4;
	      put_long (saved_state.memory, buf, 0);
	      buf += 4;
	      put_long (saved_state.memory, buf, 0);
	      buf += 4;
	    }
	    break;

#ifndef _WIN32
	  case SYS_chown:
	    {
	      regs[0] = chown (ptr (regs[5]), regs[6], regs[7]);
	      break;
	    }
#endif /* _WIN32 */
	  case SYS_chmod:
	    {
	      regs[0] = chmod (ptr (regs[5]), regs[6]);
	      break;
	    }
	  case SYS_utime:
	    {
	      /* Cast the second argument to void *, to avoid type mismatch
		 if a prototype is present.  */

	      regs[0] = utime (ptr (regs[5]), (void *) ptr (regs[6]));
	      break;
	    }
	  case SYS_argc:
	    regs[0] = count_argc (prog_argv);
	    break;
	  case SYS_argnlen:
	    if (regs[5] < count_argc (prog_argv))
	      regs[0] = strlen (prog_argv[regs[5]]);
	    else
	      regs[0] = -1;
	    break;
	  case SYS_argn:
	    if (regs[5] < count_argc (prog_argv))
	      {
		/* Include the termination byte.  */
		int i = strlen (prog_argv[regs[5]]) + 1;
		regs[0] = sim_write (0, regs[6], prog_argv[regs[5]], i);
	      }
	    else
	      regs[0] = -1;
	    break;
	  case SYS_time:
	    regs[0] = get_now ();
	    break;
	  case SYS_ftruncate:
	    regs[0] = callback->ftruncate (callback, regs[5], regs[6]);
	    break;
	  case SYS_truncate:
	    {
	      regs[0] = callback->truncate (callback, ptr (regs[5]), regs[6]);
	      break;
	    }
	  default:
	    regs[0] = -1;
	    break;
	  }
	regs[1] = callback->get_errno (callback);
	errno = perrno;
      }
      break;

    case 0xc3:
    case 255:
      raise_exception (SIGTRAP);
      if (i == 0xc3)
	return -2;
      break;
    }
#endif
}

void
control_c (sig, code, scp, addr)
     int sig;
     int code;
     char *scp;
     char *addr;
{
  raise_exception (SIGINT);
}

/* Set the memory size to the power of two provided. */

void
sim_size (power)
     int power;

{
  saved_state.msize = 1 << power;

  sim_memory_size = power;

  if (saved_state.memory)
    {
      free (saved_state.memory);
    }

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
    {
      sim_size (sim_memory_size);
    }

  if (saved_state.profile && !profile_file)
    {
      profile_file = fopen ("gmon.out", "wb");
      /* Seek to where to put the call arc data */
      nsamples = (1 << sim_profile_size);

      fseek (profile_file, nsamples * 2 + 12, 0);

      if (!profile_file)
	{
	  fprintf (stderr, "Can't open gmon.out\n");
	}
      else
	{
	  saved_state.profile_hist =
	    (unsigned short *) calloc (64, (nsamples * sizeof (short) / 64));
	}
    }
}

static void
dump_profile ()
{
  unsigned int minpc;
  unsigned int maxpc;
  unsigned short *p;
  int i;

  p = saved_state.profile_hist;
  minpc = 0;
  maxpc = (1 << sim_profile_size);

  fseek (profile_file, 0L, 0);
  swapout (minpc << PROFILE_SHIFT);
  swapout (maxpc << PROFILE_SHIFT);
  swapout (nsamples * 2 + 12);
  for (i = 0; i < nsamples; i++)
    swapout16 (saved_state.profile_hist[i]);

}

static void
gotcall (from, to)
     int from;
     int to;
{
  swapout (from);
  swapout (to);
  swapout (1);
}

#define MMASKB ((saved_state.msize -1) & ~0)

int
sim_stop (sd)
     SIM_DESC sd;
{
  raise_exception (SIGINT);
  return 1;
}

/* Set by an instruction emulation function if we performed a jump.  */
int did_jump;

/* Execute a single instruction.  */

static void
step_once (SIM_DESC sd, int pollcount)
{
  bu32 oldpc = PCREG;

  if (tracing)
    fprintf (stderr, "PC: %08x, insn: %04x\n", PCREG,
	     get_word (saved_state.memory, PCREG));

  did_jump = 0;
  _interp_insn_bfin (PCREG);

  /* @@@ Not sure how the hardware really behaves when the last insn
     of a loop is a jump.  */
  if (! did_jump)
    {
      if (LC1REG && oldpc == LB1REG && --LC1REG)
	PCREG = LT1REG;
      else if (LC0REG && oldpc == LB0REG && --LC0REG)
	PCREG = LT0REG;
    }

  if (--pollcount < 0)
    {
      pollcount = POLL_QUIT_INTERVAL;
      if ((*callback->poll_quit) != NULL
	  && (*callback->poll_quit) (callback))
	{
	  sim_stop (sd);
	}	    
    }
}

void
sim_resume (sd, step, siggnal)
     SIM_DESC sd;
     int step, siggnal;
{
  struct loop_bounds loop;
  register int cycles = 0;
  register int insts = 0;
  register int prevlock;
#if 1
  int thislock;
#else
  register int thislock;
#endif
  register unsigned int doprofile;
  register int pollcount = 0;

//tracing = 1;

  int tick_start = get_now ();
  void (*prev) () = signal (SIGINT, control_c);
  void (*prev_fpe) () = signal (SIGFPE, SIG_IGN);

  init_pointers ();

  /* clear exceptions else it will stop */
  saved_state.exception = 0;

  if(step){
    while(step){
      /* not clear if this will be > 1. Potential problem area */
      step_once(sd, pollcount);
      step--;
    }
    /* Emulate a hardware single step ... raise an exception */
    saved_state.exception = SIGTRAP;
  }
  else{
    while (saved_state.exception != SIGTRAP)
    {
	step_once(sd, pollcount);
    }
  }

  saved_state.ticks += get_now () - tick_start;
  saved_state.cycles += cycles;
  saved_state.insts += insts;

  saved_state.prevlock = prevlock;
  saved_state.thislock = thislock;

  if (profile_file)
    {
      dump_profile ();
    }

  signal (SIGFPE, prev_fpe);
  signal (SIGINT, prev);
}

int
sim_write (sd, addr, buffer, size)
     SIM_DESC sd;
     SIM_ADDR addr;
     unsigned char *buffer;
     int size;
{
  int i;

  init_pointers ();

  for (i = 0; i < size; i++)
    {
      saved_state.memory[(MMASKB & (addr + i))] = buffer[i];
    }
  return size;
}

int
sim_read (sd, addr, buffer, size)
     SIM_DESC sd;
     SIM_ADDR addr;
     unsigned char *buffer;
     int size;
{
  int i;

  init_pointers ();

  for (i = 0; i < size; i++)
    {
      buffer[i] = saved_state.memory[(MMASKB & (addr + i))];
    }
  return size;
}

int
sim_trace (sd)
     SIM_DESC sd;
{
  tracing = 1;
  sim_resume (sd, 0, 0);
  tracing = 0;
  return 1;
}

void
sim_stop_reason (sd, reason, sigrc)
     SIM_DESC sd;
     enum sim_stop *reason;
     int *sigrc;
{
  /* The SH simulator uses SIGQUIT to indicate that the program has
     exited, so we must check for it here and translate it to exit.  */
  if (saved_state.exception == SIGQUIT)
    {
      *reason = sim_exited;
      *sigrc = saved_state.dpregs[5];
    }
  else
    {
      *reason = sim_stopped;
      *sigrc = saved_state.exception;
    }
}

void
sim_info (sd, verbose)
     SIM_DESC sd;
     int verbose;
{
  double timetaken = 
    (double) saved_state.ticks / (double) now_persec ();
  double virttime = saved_state.cycles / 36.0e6;

  callback->printf_filtered (callback, "\n\n# instructions executed  %10d\n", 
			     saved_state.insts);
  callback->printf_filtered (callback, "# cycles                 %10d\n",
			     saved_state.cycles);
  callback->printf_filtered (callback, "# real time taken        %10.4f\n",
			     timetaken);
  callback->printf_filtered (callback, "# virtual time taken     %10.4f\n",
			     virttime);
  callback->printf_filtered (callback, "# profiling size         %10d\n",
			     sim_profile_size);
  callback->printf_filtered (callback, "# profiling frequency    %10d\n",
			     saved_state.profile);
  callback->printf_filtered (callback, "# profile maxpc          %10x\n",
			     (1 << sim_profile_size) << PROFILE_SHIFT);

  if (timetaken != 0)
    {
      callback->printf_filtered (callback, "# cycles/second          %10d\n", 
				 (int) (saved_state.cycles / timetaken));
      callback->printf_filtered (callback, "# simulation ratio       %10.4f\n", 
				 virttime / timetaken);
    }
}

void
sim_set_profile (n)
     int n;
{
  saved_state.profile = n;
}

void
sim_set_profile_size (n)
     int n;
{
  sim_profile_size = n;
}

SIM_DESC
sim_open (kind, cb, abfd, argv)
     SIM_OPEN_KIND kind;
     host_callback *cb;
     struct bfd *abfd;
     char **argv;
{
  char **p;
  int endian_set = 0;

  sim_kind = kind;
  myname = argv[0];
  callback = cb;

  for (p = argv + 1; *p != NULL; ++p)
    {
      if (strcmp (*p, "-E") == 0)
	{
	  ++p;
	  if (*p == NULL)
	    {
	      /* FIXME: This doesn't use stderr, but then the rest of the
		 file doesn't either.  */
	      callback->printf_filtered (callback, "Missing argument to `-E'.\n");
	      return 0;
	    }
	  target_little_endian = strcmp (*p, "big") != 0;
          endian_set = 1;
	}
      else if (isdigit (**p))
	parse_and_set_memory_size (*p);
    }

  /* fudge our descriptor for now */
  return (SIM_DESC) 1;
}

static void
parse_and_set_memory_size (str)
     char *str;
{
  int n;

  n = strtol (str, NULL, 10);
  if (n > 0 && n <= 24)
    sim_memory_size = n;
  else
    callback->printf_filtered (callback, "Bad memory size %d; must be 1 to 24, inclusive\n", n);
}

void
sim_close (sd, quitting)
     SIM_DESC sd;
     int quitting;
{
  /* nothing to do */
}

SIM_RC
sim_load (sd, prog, abfd, from_tty)
     SIM_DESC sd;
     char *prog;
     bfd *abfd;
     int from_tty;
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
sim_create_inferior (sd, prog_bfd, argv, env)
     SIM_DESC sd;
     struct bfd *prog_bfd;
     char **argv;
     char **env;
{
  /* Clear the registers. */
  memset (&saved_state, 0,
	  (char*) &saved_state.end_of_registers - (char*) &saved_state);

  /* Set the PC.  */
  if (prog_bfd != NULL)
    saved_state.pc = bfd_get_start_address (prog_bfd);

  PREG (6) = saved_state.msize;
  /* Set the bfd machine type.  */
  if (prog_bfd != NULL)
    saved_state.bfd_mach = bfd_get_mach (prog_bfd);

  /* Record the program's arguments. */
  prog_argv = argv;

  return SIM_RC_OK;
}

void
sim_do_command (sd, cmd)
     SIM_DESC sd;
     char *cmd;
{
  char *sms_cmd = "set-memory-size";
  int cmdsize;

  if (cmd == NULL || *cmd == '\0')
    {
      cmd = "help";
    }

  cmdsize = strlen (sms_cmd);
  if (strncmp (cmd, sms_cmd, cmdsize) == 0 
      && strchr (" \t", cmd[cmdsize]) != NULL)
    {
      parse_and_set_memory_size (cmd + cmdsize + 1);
    }
  else if (strcmp (cmd, "help") == 0)
    {
      (callback->printf_filtered) (callback, 
				   "List of SH simulator commands:\n\n");
      (callback->printf_filtered) (callback, "set-memory-size <n> -- Set the number of address bits to use\n");
      (callback->printf_filtered) (callback, "\n");
    }
  else
    {
      (callback->printf_filtered) (callback, "Error: \"%s\" is not a valid SH simulator command.\n", cmd);
    }
}

void
sim_set_callbacks (p)
     host_callback *p;
{
  callback = p;
}

/***************************************************************/
/* SIM debug support                                           */
/***************************************************************/
int
sim_fetch_register (sd, rn, memory, length)
     SIM_DESC sd;
     int rn;
     unsigned char *memory;
     int length;
{
  int value;

  init_pointers ();
  switch (rn)
    {
	case BFIN_R0_REGNUM : value = DREG(0); break;
	case BFIN_R1_REGNUM : value = DREG(1); break;
	case BFIN_R2_REGNUM : value = DREG(2); break;
	case BFIN_R3_REGNUM : value = DREG(3); break;
	case BFIN_R4_REGNUM : value = DREG(4); break;
	case BFIN_R5_REGNUM : value = DREG(5); break;
	case BFIN_R6_REGNUM : value = DREG(6); break;
	case BFIN_R7_REGNUM : value = DREG(7); break;
	case BFIN_P0_REGNUM : value = DREG(0); break;
	case BFIN_P1_REGNUM : value = PREG(1); break;
	case BFIN_P2_REGNUM : value = PREG(2); break;
	case BFIN_P3_REGNUM : value = PREG(3); break;
	case BFIN_P4_REGNUM : value = PREG(4); break;
	case BFIN_P5_REGNUM : value = PREG(5); break;
	case BFIN_FP_REGNUM : value = FPREG; break;
	case BFIN_SP_REGNUM : value = SPREG; break;
	case BFIN_I0_REGNUM : value = IREG(0); break;
	case BFIN_I1_REGNUM : value = IREG(1); break;
	case BFIN_I2_REGNUM : value = IREG(2); break;
	case BFIN_I3_REGNUM : value = IREG(3); break;
	case BFIN_M0_REGNUM : value = MREG(0); break;
	case BFIN_M1_REGNUM : value = MREG(1); break;
	case BFIN_M2_REGNUM : value = MREG(2); break;
	case BFIN_M3_REGNUM : value = MREG(3); break;
	case BFIN_L0_REGNUM : value = LREG(0); break;
	case BFIN_L1_REGNUM : value = LREG(1); break;
	case BFIN_L2_REGNUM : value = LREG(2); break;
	case BFIN_L3_REGNUM : value = LREG(3); break;
	case BFIN_B0_REGNUM : value = BREG(0); break;
	case BFIN_B1_REGNUM : value = BREG(1); break;
	case BFIN_B2_REGNUM : value = BREG(2); break;
	case BFIN_B3_REGNUM : value = BREG(3); break;
	case BFIN_A0_DOT_X_REGNUM : value = A0REG; break;
	case BFIN_AO_DOT_W_REGNUM : value = A0REG; break;
	case BFIN_A1_DOT_X_REGNUM : value = A1REG; break;
	case BFIN_A1_DOT_W_REGNUM : value = A1REG; break;
	case BFIN_LC0_REGNUM : value = LC0REG; break;
	case BFIN_LC1_REGNUM : value = LC1REG; break;
	case BFIN_LT0_REGNUM : value = LT0REG; break;
	case BFIN_LT1_REGNUM : value = LT1REG; break;
	case BFIN_LB0_REGNUM : value = LB0REG; break;
	case BFIN_LB1_REGNUM : value = LB1REG; break;
	case BFIN_RETS_REGNUM : value = RETSREG; break;
	case BFIN_PC_REGNUM : value = PCREG; break;
	default :
		return 0; // will be an error in gdb
      break;
   }

  * (int *) memory = value;
  return -1; // disables size checking in gdb
}

int
sim_store_register (sd, rn, memory, length)
     SIM_DESC sd;
     int rn;
     unsigned char *memory;
     int length;
{
  int value = *((int *)memory);

  init_pointers ();
  switch (rn)
    {
	case BFIN_R0_REGNUM : DREG(0) = value; break;
	case BFIN_R1_REGNUM : DREG(1) = value; break;
	case BFIN_R2_REGNUM : DREG(2) = value; break;
	case BFIN_R3_REGNUM : DREG(3) = value; break;
	case BFIN_R4_REGNUM : DREG(4) = value; break;
	case BFIN_R5_REGNUM : DREG(5) = value; break;
	case BFIN_R6_REGNUM : DREG(6) = value; break;
	case BFIN_R7_REGNUM : DREG(7) = value; break;
	case BFIN_P0_REGNUM : DREG(0) = value; break;
	case BFIN_P1_REGNUM : PREG(1) = value; break;
	case BFIN_P2_REGNUM : PREG(2) = value; break;
	case BFIN_P3_REGNUM : PREG(3) = value; break;
	case BFIN_P4_REGNUM : PREG(4) = value; break;
	case BFIN_P5_REGNUM : PREG(5) = value; break;
	case BFIN_FP_REGNUM : FPREG = value; break;
	case BFIN_SP_REGNUM : SPREG = value; break;
	case BFIN_I0_REGNUM : IREG(0) = value; break;
	case BFIN_I1_REGNUM : IREG(1) = value; break;
	case BFIN_I2_REGNUM : IREG(2) = value; break;
	case BFIN_I3_REGNUM : IREG(3) = value; break;
	case BFIN_M0_REGNUM : MREG(0) = value; break;
	case BFIN_M1_REGNUM : MREG(1) = value; break;
	case BFIN_M2_REGNUM : MREG(2) = value; break;
	case BFIN_M3_REGNUM : MREG(3) = value; break;
	case BFIN_L0_REGNUM : LREG(0) = value; break;
	case BFIN_L1_REGNUM : LREG(1) = value; break;
	case BFIN_L2_REGNUM : LREG(2) = value; break;
	case BFIN_L3_REGNUM : LREG(3) = value; break;
	case BFIN_B0_REGNUM : BREG(0) = value; break;
	case BFIN_B1_REGNUM : BREG(1) = value; break;
	case BFIN_B2_REGNUM : BREG(2) = value; break;
	case BFIN_B3_REGNUM : BREG(3) = value; break;
	case BFIN_A0_DOT_X_REGNUM : A0REG = value; break;
	case BFIN_AO_DOT_W_REGNUM : A0REG = value; break;
	case BFIN_A1_DOT_X_REGNUM : A1REG = value; break;
	case BFIN_A1_DOT_W_REGNUM : A1REG = value; break;
	case BFIN_LC0_REGNUM : LC0REG = value; break;
	case BFIN_LC1_REGNUM : LC1REG = value; break;
	case BFIN_LT0_REGNUM : LT0REG = value; break;
	case BFIN_LT1_REGNUM : LT1REG = value; break;
	case BFIN_LB0_REGNUM : LB0REG = value; break;
	case BFIN_LB1_REGNUM : LB1REG = value; break;
	case BFIN_RETS_REGNUM : RETSREG = value; break;
	case BFIN_PC_REGNUM : PCREG = value; break;
	default :
		return 0; // will be an error in gdb
      break;
   }

  return -1; // disables size checking in gdb
}
