/*  
    marc.hoffman@analog.com				Sept 1999

@section Remote Embedded Debug Monitor

This is a FRIO resident debug monitor, it executes simple commands
like dump memory, single step processor, set break points, continue
execution, modify register values etc...  This monitor is intrusive
and interrupts will be disabled while debugging the users application.
It's not intended to be a replacment for an ICE in any means but it
will help to get application running and when the HARDWARE becomes
available this debugger will hopefully serve as a useful tool in
narrowing down and determining how to resolve difficult issues.

requirment: 

We rely on the compiler to do context saves and restores. otherwise we
would have to write the exception handler entry an exit code by hand.
Considering that things are up in the air and that I have a terible
memory and always make mistakes this is probably a benifitial thing.
  
This module is to be linked into a system as the first module, and it
contains the CRT setup and exception handler setup code.  To link this
module with your module it must apear as the first file on the command
line to the compiler:

@display  
      gcc-bfin crtdbg.o
@end display

You must tell the compiler not to include any other startup files this
is accomplished with -nostartfiles:

@display  
      gcc-bfin -nostartfiles crtdbg.o 
@end display

Then your application modules apear next.

@display  
      gcc-bfin -nostartfiles crtdbg.o myfoo.o x.o .... -lblah -lblah -lblah
@end display

You get the picture.

This module sets up the C-stack to be very high in memory at
0x05000000 and then installs an exception handler.  It runs FRIO in
true user mode it accomplishes the switch from supervisor mode to user
mode with:

@example
	lz(p0)=ustart;
	reti=p0;
	rti;

    ustart:
@end example

The reti register is loaded with the first instruction that is to be
executed in usermode typically this is referred to as
USER-MODE-POINT-ENTRY.  The first instruction that is executed in user
mode is an excpt 0xe which pushes us back to supervisor mode
specifically executing the evsw_handler.  The evsw_handler is an
exception handler that saves all of machine state on the stack.  The
declaration

@example
     int evsw_handler () __attribute__ ((exception_handler,saveall));
@end example

tells the compiler that the function is an exception_handler and that
the compiler needs to save all known architected machine state.
Currently, the compiler doesn't save LOOP COUNTER registers.


Well now that we have entered the evsw_handler, the first thing we do
is make the RETX register visible to the handler this is actually
really important.  We use the retx variable to interpret the code that
was executing when then exception occurred.  Think of retx as a straw
that allows us to peer into the running program.
  
Another, important point is that the compiler has made arrangements
for several things to be available to us.

@example
    evsw_handler (int excause, long *regsp, int _dummy2, int arg1, int arg2, int arg3)
@end example

The first argument is 'excause' it contains the reason for our
exception it is the key for evsw_handler code to interpret why we
actually took an exception.  The second argument is 'regsp' which the
compiler conveniently passed to us.  With out this having the compiler
saveall the registers for us would be futile.  The compiler
environment also provides a system include file called regs.h which
describes how to interpret the registers pointed to by regsp.
Finally, if this was a software exception i.e. 'excpt n' instruction
if arguments where pushed on the stack then they will apear in the
arg1 arg2 etc. Actually, if you need to pass more arguments fell free
to extend it they come in the natural order as arg1 .... argn.

Now close inspection of the evsw routine reveals that it is a pair of
switch statement that determines how we got here.  The first switch
statment determines how to deal with application specific events.

@example
       0:  -- halt 
       1:  -- abort
       2:  -- dbga support for handling dbga
       3:  -- core dump
       4:  
       5:  -- software exception initied by fileio routines
       6:
       7:
       8:
       9:
       10:  -- call function in supervisor mode 
       11:
       12:
       13:
       14:  -- breakpoint for resident monitro
       15:  -- reserved for external debugger.
@end example

Although, the processor doesn't put any requirments on how you
allocate the software exceptions, it is all determined by application
policy.  Because, I now have a couple of these handlers floating
around and by the cut and paste rule policy is being implemented quite
nicely.  (1,2) -- are not required and will be removed (2) is required
for testing infastructure and validation of the processor.
  
The next switch statement handles processor exceptions, most of which
just produce an error message.  The two of interest are 0x10 which is
SSTEP which we will get to in a moment.  The EXCPT_PROTVIOL, makes it
legal for user mode applications to issue the halt instruction.  This
is done by using the straw 'retx' and reading a single 16-bit word
from memory and asserting that it is actually a halt instruction.
This is probably not acceptable in a true application but for the
simulator it works out very nicely.  Now, we've been writing tests for
FRIO for well over a year since JUNE98 and let me tell you every
single one of them has a halt instruction in it.  One of our goals is
to be able to run the test suite in user mode, supervisor mode, or
ring-15 and have it pass.  Ring-15, is what what we call an
application that runs in supervisor mode at the lowest priority level
15.


Okay, back to the monitor we enter the debug monitor by causing a
software exception 14.  Which we have dubbed BREAK-POINT, the excpt 14
instruction is actually placed into the running application by the
debug monitor at locations requested by the user.  But, for now we use
it to get us there the first time which allows us to walk through the
user application and examine its execution.


The debug monitor takes a single argument which is how we entered the
monitor there are currently 3 reasons for enterning the monitor: a
breakpoint was hit, a single step has finished, or an unhandled
exception was envoked.  These states are critical for the debug
monitor because the monitor needs to know what to do when it enters.

If we are entering from a breakpoint exception then we need to unwind
the retx register so that we can execute the real application
instruction.  This is always true accept for the first time which
rewinding the retx register would cause an infinite loop to occur.  So
special state is maintained about first time entry, and no rewind is
performed.

If we are entering from a coredump which is my way of handling a
hardware exception we just enter no special action is performed with
regards to retx.

If we are entering from a single step that was initiated prior to a
continuation then we down load the break points into the application
and return which causes the application to run.  It's critical that we
actually do this consider what would happen if we had just hit a break
point then down loading the break points and continuing would cause an
infinite loop to occur.


Now the hard parts done. All we need to do is connect to some IO
peripheral that gives us kbd input of kind and process commands.  To
connect a kbd to the FRIO core (simulator) we execute the simulator
with a device connect to the host key board.  The kbd must be mapped
to 0xFFC00000, it just so happens that such a host peripheral is
available its called kbd.so.  To use it we envoke the application with
the following command line.

@display
    runbfin app -L kbd.so:0xFFC00000
@end display

Actually the 0xFFC0000 is optional because the kbd driver has been
compiled to default to this address.  The -L is a simulator command
line option which specifies that the next argument is to be
dynamically linked into the simulator.  The kbd driver is a very simple
peripheral thats implementation is as follows.

@example
     #include <stdio.h>
     #include "targtrac.h"
     #include "generat.h"

     int kbd (void **data, unsigned long addr, void *buf, int nunits, int mode)
     {
       char val;
       int status;
       switch (mode) {
       case GENERATOR_READ:
	   if (nunits == 1) *(char *)buf = getchar ();
       }
       return 1;
     }

     int init (TARGETID tid, TARGETTRACE_PROC tproc, char *args) {
	 unsigned long adr = 0xFFC00000;
	 if (args) sscanf (args, "%x", &adr);
	 fprintf (stderr, "<kbd> installed at %08X\n", adr);
	 tproc (tid, TGTSIM_HOOK_ADDRESS, 0, adr, kbd);
     }
@end example

To compile the peripheral it must be compiled as dynamically loadable
module on linux that means -shared, on solaris that means -fPIC
-shared.  Baiscally, the init routine is envoked when the module is
loaded and bound into the simulator.  The only action that init
performs is to hook a single memory location with the kbd generator
function.  A generator function is a function that creates data for a
running simulation when it reads from a particular memory location.

Close inspection of the code will reveal the use of a very large straw
which we would not have access to if there were a TLB in the system.
We would not be able to just look at memory the way we are looking at
memory if we had virtual memory in the system.  If this were the case
we would need to call a function that would do a physical to logical
mapping.


The user interface:

@display
     [mmh@@lbear ints]$ x -L kbd.so
     <kbd> installed at FFC00000
     debugger entered (first-time)
     breakpoint
     PC: 00000020    FP: 04FFFFF8    ASTAT: 0000
     R0: 00000000    R1: 00000000    R2: 00000000    R3: 00000000
     R4: 00000000    R5: 00000000    R6: 00000000    R7: 00000000
     P0: 0000001E    P1: 005001BC    P2: 00000000
     P3: 00000000    P4: 00000000    P5: 00000000

     A1: 0000000000  A0: 0000000000
     I0: 00000000    B0: 00000000    L0: 00000000
     I1: 00000000    B1: 00000000    L1: 00000000
     I2: 00000000    B2: 00000000    L2: 00000000
     I3: 00000000    B3: 00000000    L3: 00000000
     M0: 00000000    M1: 00000000    M2: 00000000    M3: 00000000
     00000020: 0a00 0003 00a0 0000 0b88 01c8 9000 9001 
     FRIO mon pc:00000020] h
     Frio resident debug monitor
     s          -- single step
     b address  -- set break point
     bl         -- list break point table
     bd num     -- delete break point by number
     c          -- continue execution
     m addr len -- dump memory
     $reg       -- print register value
     $reg = val -- set register to value
     q          -- execute halt instruction
@end display

Simple yet sufficient, all the tools needed for hardcore debugging are
right at your finger tips. When the monitor enters it always dumps the
state, and the last line of the state is a dump of the next 8 words to
be executed in hex.  Yep, you guessed it:

@example
     00000020: 0a00 0003 00a0 0000 0b88 01c8 9000 9001 
@end example

The 20: is the pc and the 0a00 0003 ... is the call to main.  The only
disappointment to note is that decoding the stream is pretty much an
art.  The easiest way to remember it is uabfin x |more in another
window and wolla assembler level debugging.


Have fun and remember debugging is fun.

@example */


static inline void dbg  (int c) { asm ("dbg %0;" :: "r" (c)); }  // for testing

#include <stdio.h>
#include <sys/event.h>

extern int kprintf(char *, ...);

enum {
#undef REG
#define REG(name, pos) reg_##name,
#include <sys/regs.h>
};

#define INB *(char volatile *)0xFFC00000
#ifndef COMMAND_LINE_ARGS
#define COMMAND_LINE_ARGS     0x60000000
#endif

#define EXITCODE  *(char volatile *)0xFF7EEEEE

#ifdef ENABLE_DEBUG
#define BREAK_ON_START "excpt 14;"
#else
#define BREAK_ON_START ""
#endif


typedef enum { dbg_breakpoint, dbg_singlestep, dbg_coredump } dbg_pstate;

int evsw_handler () __attribute__ ((exception_handler,saveall,kspisusp));
int timer_handler () __attribute__ ((interrupt_handler, kspisusp));  // routine is in gmon.c

/* VDSP: Production assembly directives */
/*
define(IVBh,0xffe0)
define(IVBl,0x2000)
define(IMASK,0x40)
define(IV_EVSW,3)
define(IV_TIMR,6)
*/

#if !defined (VDSP)
asm("
#define IVBh 0xffe0
#define IVBl 0x2000
#define IMASK 0x40
#define IV_EVSW 3

.global start;
start:
	l(sp)=0x0000;
	h(sp)=0x0500;
        usp=sp;

	l(p0)=0x2000; h(p0)=0xffe0;
	h(p1)=_evsw_handler;
	l(p1)=_evsw_handler;
	[p0+12]=p1;

        h(p1)=_timer_handler;
        l(p1)=_timer_handler;
        [p0+24]=p1;

	lz(r0)=ustart;
	reti=r0;
	rti;

ustart: call __getargv;
        l(r1)=__Argv; h(r1)=__Argv;
" 
        BREAK_ON_START
"	call _main;"

#ifdef PROFILE
"       call __mcleanup;"
#endif

"       call _exit;
.global __exit;
__exit:
	excpt 0;
.code 0x500000
");
#else
asm("
#define IVBh 0xffe0
#define IVBl 0x2000
#define IMASK 0x40
#define IV_EVSW 3

.global start;
.section program;
start:
	l(sp)=0x0000;
	h(sp)=0x0500;
        usp=sp;

	l(p0)=IVBl; h(p0)=IVBh;
	h(p1)=_evsw_handler;
	l(p1)=_evsw_handler;
	[p0+(4*IV_EVSW)]=p1;

	lz(r0)=ustart;
	reti=r0;
	rti;

ustart: call __getargv;
        l(r1)=__Argv; h(r1)=__Argv;
" 
        BREAK_ON_START
"	call _main;
        call _exit;
.global __exit;
__exit:
	excpt 0;
.code 0x500000
");
#endif


char *_Argv[20];

static
_getargv ()
{
  int i;
  int argc;
  char *p=(char *)COMMAND_LINE_ARGS;
  argc=0;
  if (*p) {
    _Argv[argc++] = p;
    while (*p) {
      if (*p == ' ') {
        *p++ = 0;
        _Argv[argc++] = p;
      }
      p++;
    }
  }
  return argc;
}

flushio ()
{
#ifdef _IOFBF
  fflush (stdout);
  fflush (stderr);
#endif
}


int dbga_counter;

evsw_handler (int excause, long *regsp, int _dummy2, int arg1, int arg2, int arg3)
{
  unsigned long retx;
  unsigned short *IMASKP = (unsigned short *)0xffe02104;

  asm("%0=RETX;" : "=d" (retx));

  if (excause<0x10) {
    switch (excause) {

    case 0:  
      EXITCODE = regsp[reg_R0];
      asm ("hlt;");
      
    case 1:  asm ("abort;");

    case 2:
      {
	unsigned int x = arg1;
	unsigned int y;

	char k;
	int lineno;
	int dbg_kind;
	dbga_counter++;

	asm ( "p0=retx;
               %0=h[p0++];
               %1=h[p0++];
               %1<<=16;
               %0=%0|%1;
               %1=h[p0++];
               retx=p0;"
	      : "=d" (y), "=d" (lineno) : : "P0");

	dbg_kind = (lineno >> 14)&0x3;

	lineno &= ~0xc000;
	k = ' ';
	if (dbg_kind==3) {
	  x >>= 16;
	  k = 'h';
	} else if (dbg_kind==2) {
	  x &= 0xffff;
	  y &= 0xffff;
	  k = 'l';
	}
	  
	kprintf ("dbga %c (line %d, @%x: [%d] compare %x with expected %x) = %s\n",
		k,
		lineno, retx, dbga_counter, x, y,x==y?"true":"false");

	if (x!=y) {
	  core_dump (retx,regsp);
	  asm ("abort;");
	}
      }
      break;

    case 3: {
      core_dump (retx,regsp);
    }


    case 5:  // software exception
      switch (regsp[reg_R0]){
      case 0: {
	EXITCODE = regsp[reg_R0];
	asm ("hlt;");
	break;
      }
      case 1: {
	int (** ivt)()  = (void volatile *)0xFFFF8000;
	regsp[reg_R0] = ivt[arg1];
	ivt[arg1] = arg2;
	IMASK |= 1<<arg1;
	break;
      }

      /* timer interrupt handler initialization */
      case 6:         // enable
        *IMASKP |= 0x40;
	break;
      case 7:         // disable
	*IMASKP &= 0xffbf;
	break;


      case 10:
        regsp[reg_R0] = dev_open((char *)arg1, (int)arg2, (int)arg3);     
	break;
      case 11:
	regsp[reg_R0] = dev_close((int)arg1);
	break;
      case 12:
	regsp[reg_R0] = dev_write((int)arg1, (char *)arg2, (int)arg3);
	break;
      case 13:
	regsp[reg_R0] = dev_read((int)arg1, (char *)arg2, (int)arg3);
	break;
      case 14:
	regsp[reg_R0] = dev_seek((int)arg1, (int)arg2, (int)arg3);
	break;
      case 15:
	regsp[reg_R0] = dev_dup((int)arg1);
	break;
      default:
	regsp[reg_R0] = -1;   // invalid system call.
        break;
      }
      break;


    case 0xa:
      {
	int (* supervisor_call) () = (void *)arg1;
	supervisor_call ();
      }
      break;

    case 0xe:
	dbgmon_enter (dbg_breakpoint, &retx, regsp);
	return;
    default: ;
    }
    return;
  }



  switch (excause) {
  case EXCPT_SSTEP:
      dbgmon_enter (dbg_singlestep, &retx, regsp);
      return;


  case EXCPT_UNDEFINST:
    kprintf ("exception: at pc:%08x, undefined instruction error\n",retx);
    break;
  case EXCPT_ILLICOMB:
    kprintf ("exception: at pc:%08x, illegal instruction combination error\n",retx);
    break;
  case EXCPT_PROTVIOL: {
      short hlt = *(short *)retx;	
      if (hlt == 0xf8c4)
	  asm ("hlt;");
      kprintf ("exception: at pc:%08x, protection violation\n",retx);
    }
    break;
  case EXCPT_ALGN:
    kprintf ("exception: at pc:%08x, missaligned data access\n",retx);
    break;
  case EXCPT_UNRECOVER:
    kprintf ("exception: at pc:%08x, unrecoverable error, check heat sink\n",retx);
    break;
  case EXCPT_PGFALUT:
    kprintf ("page fault, at pc:%08x, a DSP flipping pages is new to me\n",retx);
    break;
  }
#ifndef ENABLE_DEBUG
  flushio ();
  EXITCODE = -1;
  asm ("dbg;abort;");
#else
  dbgmon_enter (dbg_coredump, &retx, regsp);
#endif
}

#define index strchr

char *reg_names[] = {
#undef REG
#define REG(name, pos) #name,
#include <sys/regs.h>
0
};

core_dump (unsigned short *retx, unsigned *regsp)
{
  int i;
  kprintf ("PC: %08X\tFP: %08X\tASTAT: %04X\n",
	  retx, regsp[reg_FP], regsp[reg_ASTAT]);

  kprintf ("R0: %08X\tR1: %08X\tR2: %08X\tR3: %08X\n",
	  regsp[reg_R0], regsp[reg_R1], regsp[reg_R2], regsp[reg_R3]);
  kprintf ("R4: %08X\tR5: %08X\tR6: %08X\tR7: %08X\n",
	  regsp[reg_R4], regsp[reg_R5], regsp[reg_R6], regsp[reg_R7]);
  kprintf ("P0: %08X\tP1: %08X\tP2: %08X\nP3: %08X\tP4: %08X\tP5: %08X\n\n",
	  regsp[reg_P0], regsp[reg_P1], regsp[reg_P2], regsp[reg_P3], 
	  regsp[reg_P4], regsp[reg_P5]);
  kprintf ("A1: %02X%08X\tA0: %02X%08X\n", 
	  regsp[reg_A1x], regsp[reg_A1w],
	  regsp[reg_A0x], regsp[reg_A0w]);
  kprintf ("I0: %08X\tB0: %08X\tL0: %08X\n", regsp[reg_I0], regsp[reg_B0], regsp[reg_L0]);
  kprintf ("I1: %08X\tB1: %08X\tL1: %08X\n", regsp[reg_I1], regsp[reg_B1], regsp[reg_L1]);
  kprintf ("I2: %08X\tB2: %08X\tL2: %08X\n", regsp[reg_I2], regsp[reg_B2], regsp[reg_L2]);
  kprintf ("I3: %08X\tB3: %08X\tL3: %08X\n", regsp[reg_I3], regsp[reg_B3], regsp[reg_L3]);
  kprintf ("M0: %08X\tM1: %08X\tM2: %08X\tM3: %08X\n", 
	  regsp[reg_M0], regsp[reg_M1], regsp[reg_M2], regsp[reg_M3]);

  kprintf ("%08X: ", retx);
  for (i=0;i<8;i++)
      dbgmon_print ('w', &retx);
  kprintf ("\n");
}

typedef unsigned long address_t;

unsigned
regid_by_name (char *name, int len)
{
    int i;
    for (i=0;reg_names[i]; i++) {
	if (strncmp (reg_names[i], name, len) == 0) {
	    return i;
	}
    }
    return -1;
}

static struct breakpoint {
  struct breakpoint *nxt;
  int                bnum;
  char               disabled;
  address_t          addr;
  short              data;
} *blist;

int bpidno;

/* Break Points */
static struct breakpoint *bp_find (address_t addr)
{
   struct breakpoint *b = blist;
   while (b) {                    
     if (b->addr == addr)
        return b;
     b = b->nxt;
   }            
   return NULL;
}

static struct breakpoint *bp_new (address_t addr)
{
  struct breakpoint *b = bp_find (addr);
  if (b)
    return b;
  else {
    struct breakpoint *new = 
	(struct breakpoint *)malloc (sizeof (struct breakpoint));
    new->bnum  = bpidno++;
    new->addr  = addr;
    new->nxt = blist; 
    blist = new;
    return new;
  }
}

static void bp_del (int num)
{
   struct breakpoint *b = blist, *p = 0;
   while (b) {                    
     if (b->bnum == num) {
        if (p) 
           p->nxt = b->nxt;
        else
           blist = b->nxt;
        free (b);
        break;
     }
     p = b;
     b = b->nxt;
   }            
}

static int toggle_bp (long addr)
{
  struct breakpoint *b = bp_find (addr);
  if (!b)
    b  = bp_new (addr);
  else
    b->disabled = !b->disabled;

  return 1;
}

static int bp_list ()
{
  struct breakpoint *b = blist;
  while (b) {
    int offset;
    char buf [40];
    printf ("%d: ", b->bnum);
    printf ("[%x] %s\n", b->addr, b->disabled ? "disabled" : "enabled");
    b = b->nxt;
  }
  return 1;
}

static int bpdownload ()
{
   struct breakpoint *b = blist;
   while (b) {      
       if (!b->disabled) {
	   b->data = *(short *)b->addr;
	   *(short *)b->addr = 0xAE;
	   INVALIDATE = b->addr;
       }
       b=b->nxt;
   }
   return 1;
}

static int bpupload ()
{
   struct breakpoint *b = blist;
   while (b) {      
     if (!b->disabled) {
       *(short *)b->addr = b->data;
       INVALIDATE = b->addr;
     }
     b = b->nxt;
   }
   return 1;
}


int dbgmon_readkb (char *command)
{
    char *bp=command;
    char c;
    *bp = 0;
    while ((c = INB) != -1) {
	if (c == '\n') {
	    *bp=0;
	    return command[0];
	}
	*bp++=c;
    }
    return c;
}

long dbgmon_parse_int (char **end)
{
  char fmt;
  int not_done = 1;
  int shiftvalue = 0;
  char * char_bag;
  long value = 0;
  char c;
  char *arg = *end;

  while (*arg && *arg == ' ') arg++;

  switch (*arg) {
    case '1':    case '2':    case '3':    case '4':
    case '5':    case '6':    case '7':    case '8':    case '9':
      fmt = 'd';
      break;

    case '0':  /* Accept diffrent formated integers hex octal and binary. */
      {
	c = *++arg; arg++;
	if (c == 'x' || c == 'X') /* hex input */
	  fmt = 'h';
	else if (c == 'b' || c == 'B')
	  fmt = 'b';
	else if (c == '.')
	  fmt = 'f';
	else {             /* octal */
	  arg--;
	  fmt = 'o';
	}
	break;
      }

    case 'd':    case 'D':    case 'h':    case 'H':
    case 'o':    case 'O':    case 'b':    case 'B':
    case 'f':    case 'F':
      {
	fmt = *arg++;
	if (*arg == '#')
	  arg++;
      }
  }

  switch (fmt) {
  case 'h':  case 'H':
    shiftvalue = 4;
    char_bag = "0123456789ABCDEFabcdef";
    break;

  case 'o':  case 'O':
    shiftvalue = 3;
    char_bag = "01234567";
    break;

  case 'b':  case 'B':
    shiftvalue = 1;
    char_bag = "01";
    break;

/*
The assembler allows for fractional constants to be created
by either the 0.xxxx or the f#xxxx format 

i.e.   0.5 would result in 0x4000

note .5 would result in the identifier .5.

The assembler converts to fractional format 1.15
by the simple rule.


value = (short)(finput*(1<<15))
*/
  case 'f':  case 'F':
  {
    float fval = 0.0;
    float pos = 10.0;
    while (1) {
      int c;
      c = *arg++;

      if (c >= '0' && c <= '9') {
        float digit = (c - '0') / pos;
        fval = fval + digit;
        pos = pos * 10.0;
      }
      else
      {
	*--arg = c;
        value = (short) (fval * (1 << 15));
        break;
      }
    }
    *end = arg+1;
    return value;
  }

  case 'd':  case 'D':
  default:
  {
    while (1) {
      int c;
      c = *arg++;
      if (c >= '0' && c <= '9')
        value = (value * 10) + (c - '0');
      else
      {
/* Constants that are suffixed with k|K are multiplied by 1024
   This suffix is only allowed on decimal constants. */
        if (c == 'k' || c == 'K')
          value *= 1024;
        else
          *--arg = c;
        break;
      }
    }
    *end = arg+1;
    return value;
  }
  }

  while (not_done) {
    char c;
    c = *arg++;
    if (c == 0 || !index (char_bag, c)) {
      not_done = 0;
      *--arg = c;
    }
    else
    {
      if (c >= 'a' && c <= 'z')
        c = c - ('a' - '9') + 1;
      else if (c >= 'A' && c <= 'Z')
        c = c - ('A' - '9') + 1;

      c -= '0';

      value = (value << shiftvalue) + c;
    }
  }
  *end = arg+1;
  return value;
}

dbgmon_print (unsigned how, char **adrp)
{
    char *adr = *adrp;
    int c;
    switch (how) {
    default:
    case 'b':
	c = *((unsigned char *)adr)++;
	printf ("%02x ", c);
	break;
    case 'w':
	c = *((unsigned short *)adr)++;
	printf ("%04x ", c);
	break;
    case 'r':
	c = *((unsigned short *)adr)++;
	printf ("%9.6r ", c);
	break;
    case 'l':
	c = *((unsigned long *)adr)++;
	printf ("%08x ", c);
	break;
    }
    *adrp = adr;
}

dbgmon_memdump (char **cmdp)
{
    unsigned adr;
    int   i, c;
    int   len;
    int   sz = 1;
    int   how = 'b';
    int   lnlen = 16;
    char *kind = "bytes";
    switch (how = **cmdp) {
    case 'l': (*cmdp)++; sz = 4; lnlen=8; kind="long";  break;
    case 'w': (*cmdp)++; sz = 2;          kind="short"; break;
    case 'r': (*cmdp)++; sz = 2; lnlen=8; kind="fract"; break;
    }
    adr = dbgmon_parse_int (cmdp);
    len = dbgmon_parse_int (cmdp);

    printf ("memdump %08X %d (%s) %c", adr, len, kind, how);
    adr = adr & ~(sz-1);
    if (len == 0) len = 32;

    for (i=0;i<len;i++) {

	if ((i&(lnlen-1)) == 0)
	    printf ("\n%08X: ", adr);

	dbgmon_print (how, (char **)&adr);
    }

    printf ("\n");
}
/*
  dbgmon_enter --
     this routine implements a very simple resident debug monitor.
     its arguments are 
         how    if brkpt, snglstp, error
	 retx   this is a pointer to the callees retx register
	        if modified the program stream changes.
	 regsp  a pointer to the machine state vector
*/
dbgmon_enter (dbg_pstate how, unsigned short **retx, unsigned *regsp)
{
    char command[100], *cmdp;
    int i, regid, adr, len, c, val;

    static int _continuation = 0;
    static int _first_time = 0;

    switch (how) {
    case dbg_coredump:
	printf ("coredump!\n");
	break;

    case dbg_singlestep:
	if (_continuation) {
	    bpdownload ();
	    _continuation = 0;
	    return;
	}
	break;

    case dbg_breakpoint:
	printf ("breakpoint-hit %08X\n", *retx);

	if (_first_time == 0)
	    printf ("debugger entered (first-time)\n");
        else {
	    *retx -= 1;
	    asm ("RETX=%0;" : : "d" (*retx));
        }
	bpupload ();
	break;
    }

    _first_time++;
    core_dump (*retx, regsp);
#ifdef _IOFBF
    fflush (stdout);
#endif
    while (1) {
	printf ("rmon %08X] ", *retx);

	cmdp = command;
	dbgmon_readkb (cmdp);
	switch (c = *cmdp++) {
	    

	case 'r': case 'c':	case 'R': case 'C':
	    _continuation = 1;

	case 's': case 'S': {
	    short lookingat = *(short *)*retx;
	    if ((lookingat & 0xFFF0) == 0x00A0) {
		printf ("can't single step through an 'excpt' instruction\n");
		break;
	    }
	    printf ("single stepping\n");
	    asm ("r0=SYSCFG; bitset(r0,1); SYSCFG=r0;" : : : "R0");
	    return;
	}

	case -1: case 'q': case 'Q':
	    asm ("hlt;");

	case 'b':
	    if (*cmdp == 'l') {
		bp_list ();
		break;
	    }
	    else if (*cmdp == 'd') {
		cmdp++;
		c = dbgmon_parse_int (&cmdp);
		bp_del (c);
		break;
	    }
	    adr = dbgmon_parse_int (&cmdp);
	    if (adr & 1) {
		printf ("not setting breakpoint at %08x its not aligned\n", adr);
		break;
	    }
	    printf ("setting breakpoint at %08X\n", adr);
	    bp_new (adr);
	    break;

	case 'm':
	    dbgmon_memdump (&cmdp);
	    break;

	case '$':
	    {
		char *p = cmdp;
		int len = 0;
		while (*p != 0) {
		    if (*p == ' ' || *p == '=')
			break;
		    p++;
		    len++;
		}

		regid = regid_by_name (cmdp, len);
	    }

	    if (regid>=0) {
		if (cmdp = (char *)index (cmdp, '=')) {
		    cmdp++;
		    val = dbgmon_parse_int (&cmdp);
		    regsp[regid] = val;
		}
		printf ("%s: %08X (%d)\n", reg_names[regid], 
			regsp[regid], regsp[regid]);
	    } else {
		printf ("%s??\n", command);
	    }
	    break;
	case 'h': case 'H': case '?':
	    printf ("Frio resident debug monitor\n"
		    "s          -- single step\n"
		    "b address  -- set break point\n"
		    "bl         -- list break point table\n"
		    "bd num     -- delete break point by number\n"
		    "c          -- continue execution\n"
		    "m addr len -- dump memory\n"
		    "$reg       -- print register value\n"
		    "$reg = val -- set register to value\n"
		    "q          -- execute halt instruction\n"
		    );

	}
    }
    asm ("hlt;");
}


#ifndef PROFILE
timer_handler(){
}
#endif


/*  
    All items above is exactly the same as crt0.c
    Because mcrt0.o is the compilation of both
    crt0.c and gmon.c, gmon.c was #include 'd to
    make things look cleaner.  -gy
*/

#ifdef PROFILE
#include "gmon.c"
#endif
