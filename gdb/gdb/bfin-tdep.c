/* Common target dependent code for GDB on BFIN systems.
   Copyright 1988, 1989, 1991, 1992, 1993, 1995, 1996, 1998, 1999, 2000,
   2001, 2002, 2003 Free Software Foundation, Inc.

   This file is part of GDB.

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
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/*
  Analog Devices Blackfin architecture (bfin)
  Written and tested on BF533
  TODO :
  1. dummy frame stuff
  2. cache initialization of saved registers (analyze the prologue)
  3. is there a more elegant way of the address conversion.
     (We need it as we have no mmu)
     There is a function pointer_to_address that should be tried.
     Currently it is implemented quite kludgily ... the kernel returns
     pc with a decremented value while most other manipulations are
     done explicitly here. 
  4. Resolve the orig_r0 mystery. 
*/

#define NUM_PSEUDO_REGS (3)
#include "defs.h"
#include "frame.h"
#include "frame-base.h"
#include "frame-unwind.h"
#include "inferior.h"
#include "gdbcmd.h"
#include "gdbcore.h"
#include "symfile.h"
#include "gdb_string.h"
#include "dis-asm.h"		/* For register styles. */
#include "regcache.h"
#include "doublest.h"
#include "value.h"
#include "arch-utils.h"
#include "osabi.h"
#include "bfin-tdep.h"

#include "elf-bfd.h"

#include "gdb_assert.h"
#include "command.h"
#include "tm.h"

/* forward static declarations */
static struct type * bfin_register_type (struct gdbarch *gdbarch, int regnum);
static void bfin_frame_init_saved_regs (struct frame_info *fip);


//Following macro has been used by
//prologue functions
#define P_LINKAGE             0xE800  
#define P_MINUS_SP1           0x0140
#define P_MINUS_SP2           0x05C0
#define P_MINUS_SP3           0x0540
#define P_MINUS_SP4           0x04C0
#define P_SP_PLUS             0x6C06
#define P_P2_LOW              0xE10A
#define P_P2_HIGH             0XE14A
#define P_SP_EQ_SP_PLUS_P2    0X5BB2
#define P_SP_EQ_P2_PLUS_SP    0x5B96

#define BFIN_NOT_TESTED	      0	

/* Frame offsets */
#define OLD_FP_OFFSET		0
#define RETS_OFFSET		4

/* Each OS has a different mechanism for accessing the various
   registers stored in the sigcontext structure.

   SIGCONTEXT_REGISTER_ADDRESS should be defined to the name (or
   function pointer) which may be used to determine the addresses
   of the various saved registers in the sigcontext structure.

   For the BFIN target, there are three parameters to this function. 
   The first is the pc value of the frame under consideration, the
   second the stack pointer of this frame, and the last is the
   register number to fetch.  

   If the tm.h file does not define this macro, then it's assumed that
   no mechanism is needed and we define SIGCONTEXT_REGISTER_ADDRESS to
   be 0. 
   
   When it comes time to multi-arching this code, see the identically
   named machinery in ia64-tdep.c for an example of how it could be
   done.  It should not be necessary to modify the code below where
   this macro is used.  */

#ifdef SIGCONTEXT_REGISTER_ADDRESS
#ifndef SIGCONTEXT_REGISTER_ADDRESS_P
#define SIGCONTEXT_REGISTER_ADDRESS_P() 1
#endif
#else
#define SIGCONTEXT_REGISTER_ADDRESS(SP,PC,REG) 0
#define SIGCONTEXT_REGISTER_ADDRESS_P() 0
#endif


/* The list of available "set bfin ..." and "show bfin ..." commands.  */
static struct cmd_list_element *setbfincmdlist  = NULL;
static struct cmd_list_element *showbfincmdlist = NULL;


/* We have more registers than the disassembler as gdb can print the value
   of special registers as well.
   The general register names are overwritten by whatever is being used by
   the disassembler at the moment. We also adjust the case of cpsr and fps.  */

/* Initial value: Register names used in BFIN's ISA documentation.  */
static char *bfin_register_name_strings[] =
{ "syscfg", /*"orig_r0",*/ "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", 
  "p0", "p1", "p2", "p3", "p4", "p5","fp","usp",
  "i0", "i1", "i2", "i3", 
  "m0", "m1", "m2", "m3", 
  "l0", "l1", "l2", "l3",
  "b0", "b1", "b2", "b3",
  "a0x", "a0w", "a1x", "a1w", "lc0", "lc1", "lt0", "lt1", "lb0", "lb1", 
  "astat", "reserved", "rets", "pc", "retx", "retn", "rete", "seqstat",
   "ipend", "orig_pc", "extra1", "extra2", "extra3" }; 

#define NUM_BFIN_REGNAMES (sizeof(bfin_register_name_strings)/sizeof(char *))
/***************************************************************************
In this diagram successive memory locations increase downwards or the
stack grows upwards with negative indices. (PUSH analogy for stack.)

The top frame is the "frame" of the current function being executed.
+--------------+ SP    -
|  local vars  |       ^
+--------------+       |
|  save regs   |       |
+--------------+ FP    |
|   old FP    -|--    top
+--------------+  |  frame
|    RETS      |  |    |
+--------------+  |    |
|   param 1    |  |    |
|   param 2    |  |    |
|    ...       |  |    V
+--------------+  |    -
|  local vars  |  |    ^
+--------------+  |    |
|  save regs   |  |    |
+--------------+<-     |
|   old FP    -|--   next
+--------------+  |  frame
|    RETS      |  |    |
+--------------+  |    |
|   param 1    |  |    |
|   param 2    |  |    |
|    ...       |  |    V
+--------------+  |    -
|  local vars  |  |    ^
+--------------+  |    |
|  save regs   |  |    |
+--------------+<-  next frame
|   old FP     |       |
+--------------+       |
|    RETS      |       V
+--------------+       -

Take the example
main()
{
  ...
  func();
}

func()
{
   ...
   func2(10, 4);
}
func2 (int a, int b)
{
   ...
   func3(a, b, c);
}

The frame at the point in func2 before call to func3
would have frame for func2 at the top, func below it and main at the bottom.
Without having access to source code of any type, you can trace back through
FP
to get a linked list (or a frame chain).
FP has the topmost frame.
FP + 4 has the previous FP and so on.

Number and type of parameters is not directly known. Hence, you need help
from the client side gdb which gets the information from the debug info
stored in the hello_debug type of file. However, we know given a parameter
type
and index where to find it ... FP relative. gdb knows this and hence it took
the
offset from FP where parameters are stored (=8).
Similarly, local variables are known as an index from FP.

Also note the RETS tells a different story ... of which point in the code
the calls were made. Again, the debug info helps to map from code to source.
RETS is also called the caller's PC or old PC.

Thus gdb gathers the information from the debug info from the debug file and
the realtime information from the process being run to provide you complete
information of the frame.

Thus your stack trace would be
func2(a=10, b=4)
func()
main()



***************************************************************************/
struct bfin_frame_cache
{
  /* Base address.  */
  CORE_ADDR base;
  CORE_ADDR sp_offset;
  CORE_ADDR pc;
  int frameless_pc_value;

  /* Saved registers.  */
  CORE_ADDR saved_regs[BFIN_NUM_REGS];
  CORE_ADDR saved_sp;

  /* Stack space reserved for local variables.  */
  long locals;
};

/* Allocate and initialize a frame cache.  */
static struct bfin_frame_cache *
bfin_alloc_frame_cache (void)
{
  struct bfin_frame_cache *cache;
  int i;

  cache = FRAME_OBSTACK_ZALLOC (struct bfin_frame_cache);

  /* Base address.  */
  cache->base = 0;
  cache->sp_offset = -4;
  cache->pc = 0;
  cache->frameless_pc_value = 0;

  for (i = 0; i < BFIN_NUM_REGS; i++)
    cache->saved_regs[i] = -1;

  /* Frameless until proven otherwise.  */
  cache->locals = -1;

  return cache;
}

CORE_ADDR text_addr = 0;

static struct bfin_frame_cache *
bfin_frame_cache (struct frame_info *next_frame, void **this_cache)
{
  struct bfin_frame_cache *cache;
  char buf[4];
  int i;
  if(0 == text_addr)
  {
         text_addr = read_register(BFIN_EXTRA1) ;
#ifdef DEBUG
         fprintf(stderr, "JYOTIK DEBUG: text addr found = 0x%x\n", text_addr);
#endif
  }
  if (*this_cache)
    return *this_cache;

  cache = bfin_alloc_frame_cache ();
  *this_cache = cache;


  frame_unwind_register (next_frame, BFIN_FP_REGNUM, buf);
  cache->base = extract_unsigned_integer (buf, 4);
 
  cache->base -=  text_addr;
  if (cache->base == 0)
    return cache;

  /* For normal frames, PC is stored at [FP + 4].  */
  cache->saved_regs[BFIN_PC_REGNUM] = 4;
  cache->saved_regs[BFIN_FP_REGNUM] = 0;
 
  /* Adjust all the saved registers such that they contain addresses
     instead of offsets.  */
  for (i = 0; i < BFIN_NUM_REGS; i++)
    if (cache->saved_regs[i] != -1)
      cache->saved_regs[i] += cache->base;

  cache->pc = frame_func_unwind (next_frame) ;
  if(cache->pc == frame_pc_unwind (next_frame)){
    /* func unwind and pc unwind are same ... either there is no
       prologue (frameless function) or we are at the start of a function,
       In short we do not have a frame! pc is stored in rets register
       FP points to previous frame.
    */
    cache->saved_regs[BFIN_PC_REGNUM] = 
       read_register(BFIN_RETS_REGNUM) - text_addr;
    cache->frameless_pc_value = 1;
  }
  else{
    cache->frameless_pc_value = 0;
  }
#if 0 //TODO : Need to analyze and fill in the offsets of registers
  if (cache->pc != 0)
    bfin_analyze_prologue (cache->pc, frame_pc_unwind (next_frame), cache);
  if (cache->locals < 0)
    {

      frame_unwind_register (next_frame, BFIN_SP_REGNUM, buf);
      cache->base = extract_unsigned_integer (buf, 4) + cache->sp_offset;
    }
#endif
  /* Now that we have the base address for the stack frame we can
     calculate the value of SP in the calling frame.  */
  cache->saved_sp = cache->base + 8;

  return cache;
}



static void
bfin_frame_this_id (struct frame_info *next_frame, void **this_cache,
                    struct frame_id *this_id)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);
  /* This marks the outermost frame.  */
  if (cache->base == 0){
    *this_id =  frame_id_build (cache->base + 4, cache->pc + 8);
  }
  else{
   *this_id = frame_id_build (cache->base + 8, cache->pc);
  }
}

static void
bfin_frame_prev_register (struct frame_info *next_frame, void **this_cache,
                          int regnum, int *optimizedp,
                          enum lval_type *lvalp, CORE_ADDR *addrp,
                          int *realnump, void *valuep)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);
  gdb_assert (regnum >= 0);

  if (regnum == BFIN_SP_REGNUM && cache->saved_sp)
    {
      *optimizedp = 0;
      *lvalp = not_lval;
      *addrp = 0;
      *realnump = -1;
      if (valuep)
        {
          /* Store the value.  */
          store_unsigned_integer (valuep, 4, cache->saved_sp);
        }
      return;
    }
    if (regnum < BFIN_NUM_REGS && cache->saved_regs[regnum] != -1)
    {
      *optimizedp = 0;
      *lvalp = lval_memory;
      *addrp = cache->saved_regs[regnum];
      *realnump = -1;
      if (valuep)
        {
          /* Read the value in from memory.  */
           if(regnum == BFIN_PC_REGNUM){
            int *pi = (int *)valuep;
            if(cache->frameless_pc_value){
              /* Blackfin stores the value of the return pc on
                 a register not a stack. A LINK command will 
                 save it on the stack. 
              */
              *pi = *addrp;
            }
            else{
              *pi = read_memory_integer (*addrp, 4) - text_addr;
            }
          }
          else if(regnum == BFIN_FP_REGNUM){
             int *pi = (int *)valuep;
             *pi = read_memory_integer (*addrp, 4);
          }
          else{
              read_memory (*addrp, valuep,
                       register_size (current_gdbarch, regnum));
          }
        }
      return;
    }

  frame_register_unwind (next_frame, regnum,
                         optimizedp, lvalp, addrp, realnump, valuep);
}


CORE_ADDR
bfin_frame_chain (frame_ptr)
     struct frame_info *frame_ptr;
{
  return read_memory_unsigned_integer (get_frame_base(frame_ptr), 4);
}



static const struct frame_unwind bfin_frame_unwind =
{
  NORMAL_FRAME,
  bfin_frame_this_id,
  bfin_frame_prev_register
};

static const struct frame_unwind *
bfin_frame_p (CORE_ADDR pc)
{
  return &bfin_frame_unwind;
}

//#define _DEBUG
/* The following functions are for function prolog length calculations */
static int is_minus_minus_sp(int op)
{
      op &= 0xFFC0; 
      if((op == P_MINUS_SP1) ||
         (op == P_MINUS_SP2) ||
         (op == P_MINUS_SP3) ||
         (op == P_MINUS_SP4)) {
        return 1;
       }
       return 0;
}
static CORE_ADDR skip_sp_plus(CORE_ADDR pc)
{
    register int op = read_memory_unsigned_integer(pc, 2);
    if((op & P_SP_PLUS) == P_SP_PLUS) {
#ifdef _DEBUG
         fprintf(stderr, "Incrementing PC by 2 as opcode for SP+=N found\n");
#endif //_DEBUG 
         return pc + 2;
    }
   //Flow may not have SP+=N opcode if there is no function call
   //So, it's okay to be continued
    return pc;

}
static CORE_ADDR skip_minus_minus_sp(CORE_ADDR pc)
{
    register int op = read_memory_unsigned_integer(pc, 2);
       if(!is_minus_minus_sp(op))
       {
	  fprintf(stderr, "Error: Expecting [--SP] code but found %d at PC: %d\n",
                   op, (int)pc);
          return pc;
        }
       while(is_minus_minus_sp(op))
       {
           pc += 2;
           op = read_memory_unsigned_integer(pc, 2);
       }
       return skip_sp_plus(pc);
}
static CORE_ADDR skip_blob(CORE_ADDR pc)
{
	register int op1 = read_memory_unsigned_integer(pc, 2);
        register int op2 = read_memory_unsigned_integer(pc+4, 2);
        if(((op1 == P_P2_LOW) && (op2 == P_P2_HIGH)) ||  
           ((op2 == P_P2_LOW) && (op1 == P_P2_HIGH)))  {
              pc += 8;
             op1 = read_memory_unsigned_integer(pc, 2);
             if((op1 == P_SP_EQ_SP_PLUS_P2) || (op1 == P_SP_EQ_P2_PLUS_SP)) {
                op2 = read_memory_unsigned_integer(pc + 2, 2);
                if(is_minus_minus_sp(op2))
                    return skip_minus_minus_sp(pc +2); 
                return skip_sp_plus(pc + 2);
             }
            fprintf(stderr, "Error: Expecting SP= SP + P2 code but found %d at PC: %d\n",
                   op1, (int)pc);

        }
        else  {
         fprintf(stderr, "Error: Expecting P2.L=X1 & P2.H = X2 code but found %d and %d at PC: %d\n",
                   op1, op2, (int)pc);

         }
    return pc;
}


static CORE_ADDR skip_link(CORE_ADDR pc)
{
    //caller has already verified so no need of verification
    register int op = read_memory_unsigned_integer(pc+4, 2);
#ifdef _DEBUG
         fprintf(stderr, "Incrementing PC(0x%x) by 4 as opcode for LINK found\n", (int)pc);
#endif //_DEBUG 
    pc += 4;
    if((op & P_SP_PLUS) == P_SP_PLUS) {
          pc = skip_sp_plus(pc); 
     }
    else if (((op & P_P2_LOW) == P_P2_LOW) ||
             ((op & P_P2_HIGH) == P_P2_HIGH)) {
          pc = skip_blob(pc);
    }
    else if(is_minus_minus_sp(op)){ //assume it's [--sp]
       pc = skip_minus_minus_sp(pc);
    }
   return pc;
}

CORE_ADDR
bfin_skip_prologue (pc)
     CORE_ADDR pc;
{
  int op = read_memory_unsigned_integer (pc, 2);

  if (op == P_LINKAGE) {
     pc = skip_link(pc);
  }
  else {
     // assume otherwise it's [--SP]. 
     // skip_minus_minus_sp will verify
     pc = skip_minus_minus_sp(pc);
  } 
        
#ifdef _DEBUG
  printf("Value of PC after prologue = 0x%x\n", (int)pc);
#endif //_DEBUG 
  return pc;
}


/* Find REGNUM on the stack.  Otherwise, it's in an active register.
   One thing we might want to do here is to check REGNUM against the
   clobber mask, and somehow flag it as invalid if it isn't saved on
   the stack somewhere.  This would provide a graceful failure mode
   when trying to get the value of caller-saves registers for an inner
   frame.  */

static CORE_ADDR
bfin_find_callers_reg (struct frame_info *fi, int regnum)
{
#if 0
  /* NOTE: cagney/2002-05-03: This function really shouldn't be
     needed.  Instead the (still being written) register unwind
     function could be called directly.  */
  for (; fi; fi = get_next_frame (fi))
    {
      if (DEPRECATED_PC_IN_CALL_DUMMY (get_frame_pc (fi), 0, 0))
	{
	  return deprecated_read_register_dummy (get_frame_pc (fi),
						 get_frame_base (fi), regnum);
	}
      else if (get_frame_saved_regs (fi)[regnum] != 0)
	{
	  /* NOTE: cagney/2002-05-03: This would normally need to
             handle BFIN_SP_REGNUM as a special case as, according to
             the frame.h comments, saved_regs[SP_REGNUM] contains the
             SP value not its address.  It appears that the BFIN isn't
             doing this though.  */
	  return read_memory_integer (get_frame_saved_regs (fi)[regnum],
				      REGISTER_RAW_SIZE (regnum));
	}
    }
  return read_register (regnum);
#endif
#ifdef BFIN_NOT_TESTED
printf("bfin_find_callers_reg needs to be defined\n");
#endif 

  return 0;
}


/* This function actually figures out the frame address for a given pc
   and sp.  This is tricky because we sometimes don't use an explicit
   frame pointer, and the previous stack pointer isn't necessarily
   recorded on the stack.  The only reliable way to get this info is
   to examine the prologue.  FROMLEAF is a little confusing, it means
   this is the next frame up the chain AFTER a frameless function.  If
   this is true, then the frame value for this frame is still in the
   fp register.  */

static void
bfin_init_extra_frame_info (int fromleaf, struct frame_info *fi)
{
#ifdef BFIN_NOT_TESTED
printf("bfin_init_extra_frame_info called\n");
#endif 
}

/* Return the GDB type object for the "standard" data type of data in
   register N.  This should be void pointer for P0-P5, SP, FP
   void pointer to function for PC
   int otherwise.
*/

static struct type *
bfin_register_type (struct gdbarch *gdbarch, int regnum)
{
  if (regnum >= BFIN_P0_REGNUM && regnum <= BFIN_SP_REGNUM)
    return builtin_type_void_data_ptr;

  if (regnum == BFIN_PC_REGNUM || regnum == BFIN_RETS_REGNUM)
    return builtin_type_void_func_ptr;

  return builtin_type_int32;
}


/* Return the saved PC from this frame.
   Assumes LINK is used in every function.
*/
CORE_ADDR
bfin_frame_saved_pc (frame)
     struct frame_info *frame;
{

    return (read_memory_unsigned_integer ( get_frame_base(frame) + RETS_OFFSET, 4));
}


/* Return the frame address.  */
static CORE_ADDR
bfin_read_fp (void)
{
    return read_register (BFIN_FP_REGNUM);
}

/* Store into a struct frame_saved_regs the addresses of the saved
   registers of frame described by FRAME_INFO.  This includes special
   registers such as PC and FP saved in special ways in the stack
   frame.  SP is even more special: the address we return for it IS
   the sp for the next frame.  */

static void
bfin_frame_init_saved_regs (struct frame_info *fip)
{
  if (get_frame_saved_regs (fip))
    return;

  bfin_init_extra_frame_info (0, fip);
}

  

/* Adjust the call_dummy_breakpoint_offset for the bp_call_dummy
   breakpoint to the proper address in the call dummy, so that
   `finish' after a stop in a call dummy works.

   FIXME rearnsha 2002-02018: Tweeking current_gdbarch is not an
   optimal solution, but the call to bfin_fix_call_dummy is immediately
   followed by a call to call_function_by_hand, which is the only
   function where call_dummy_breakpoint_offset is actually used.  */


static void
bfin_set_call_dummy_breakpoint_offset (void)
{
   
#ifdef BFIN_NOT_TESTED
   printf("Need to see definition of \"set_gdbarch_deprecated_call_dummy_breakpoint_offset\"\n");
#endif 
   // set_gdbarch_deprecated_call_dummy_breakpoint_offset (current_gdbarch, 8);
}

static void
bfin_fix_call_dummy (char *dummy, CORE_ADDR pc, CORE_ADDR fun, int nargs,
		    struct value **args, struct type *type, int gcc_p)
{

#ifdef BFIN_NOT_TESTED
  fprintf(stderr, "bfin_fix_call_dummy is not tested\n");
#endif 

  bfin_set_call_dummy_breakpoint_offset ();
}

/* Used to remove a stack frame. */
void
bfin_pop_frame ()
{
  struct frame_info *frame = get_current_frame ();
  CORE_ADDR fp;
  int regnum;
  char regbuf[MAX_REGISTER_RAW_SIZE];
                                                                                                         
  fp = get_frame_base (frame);

  bfin_frame_init_saved_regs (frame);
                                                                                                         
  for (regnum = 0; regnum < NUM_REGS; regnum++)
  {
    CORE_ADDR adr = 0;
#ifdef BFIN_NOT_TESTED
printf("BFIN DEBUG : Review definition of \"bfin_pop_frame\" in file %s at line %d\n", 
             __FILE__, __LINE__);
#endif
   // adr = deprecated_get_frame_saved_regs_by_regnum (frame, regnum);
    if (adr)
    {
      read_memory (adr, regbuf, REGISTER_RAW_SIZE (regnum));
      write_register_bytes (REGISTER_BYTE (regnum), regbuf,
        REGISTER_RAW_SIZE (regnum));
    }
  }
  write_register (BFIN_FP_REGNUM, read_memory_integer (fp, 4));
  write_register (BFIN_PC_REGNUM, read_memory_integer (fp + 4, 4));
  write_register (SP_REGNUM, fp + 8);
  flush_cached_frames ();
}



/* When arguments must be pushed onto the stack, they go on in reverse
   order.  The code below implements a FILO (stack) to do this.  */

struct stack_item
{
  int len;
  struct stack_item *prev;
  void *data;
};

static struct stack_item *
push_stack_item (struct stack_item *prev, void *contents, int len)
{
  struct stack_item *si;
  si = xmalloc (sizeof (struct stack_item));
  si->data = xmalloc (len);
  si->len = len;
  si->prev = prev;
  memcpy (si->data, contents, len);
  return si;
}

static struct stack_item *
pop_stack_item (struct stack_item *si)
{
  struct stack_item *dead = si;
  si = si->prev;
  xfree (dead->data);
  xfree (dead);
  return si;
}

/* We currently only support passing parameters in integer registers.  This
   conforms with GCC's default model.  Several other variants exist and
   we should probably support some of them based on the selected ABI.  */

static CORE_ADDR
bfin_push_dummy_call (struct gdbarch *gdbarch, CORE_ADDR func_addr,
		     struct regcache *regcache, CORE_ADDR bp_addr, int nargs,
		     struct value **args, CORE_ADDR sp, int struct_return,
		     CORE_ADDR struct_addr)
{
  struct gdbarch_tdep *tdep = gdbarch_tdep (gdbarch);
  char buf[4];
  int i;


#ifdef BFIN_NOT_TESTED
  fprintf(stderr, "bfin_push_dummy_call not tested on bfin\n");
#endif 
  /* Push arguments in reverse order.  */
  for (i = nargs - 1; i >= 0; i--)
    {
      struct type *value_type = VALUE_ENCLOSING_TYPE (args[i]);
      int len = TYPE_LENGTH (value_type);
      int container_len = (len + 3) & ~3;
      int offset;

	/* TODO : Verify blackfin allignment requriements from Raja */
      /* Non-scalars bigger than 4 bytes are left aligned, others are
         right aligned.  */
      if ((TYPE_CODE (value_type) == TYPE_CODE_STRUCT
           || TYPE_CODE (value_type) == TYPE_CODE_UNION
           || TYPE_CODE (value_type) == TYPE_CODE_ARRAY)
          && len > 4)
        offset = 0;
      else
        offset = container_len - len;
      sp -= container_len;
      write_memory (sp + offset, VALUE_CONTENTS_ALL (args[i]), len);
    }

  /* Store struct value address.  */
  if (struct_return)
    {
      store_unsigned_integer (buf, 4, struct_addr);
      regcache_cooked_write (regcache, tdep->struct_value_regnum, buf);
    }

  /* Store return address.  */
  sp -= 4;
  store_unsigned_integer (buf, 4, bp_addr);
  write_memory (sp, buf, 4);

  /* Finally, update the stack pointer...  */
  store_unsigned_integer (buf, 4, sp);
  regcache_cooked_write (regcache, BFIN_SP_REGNUM, buf);

  /* ...and fake a frame pointer.  */
  regcache_cooked_write (regcache, BFIN_FP_REGNUM, buf);

  /* DWARF2/GCC uses the stack address *before* the function call as a
     frame's CFA.  */
  return sp + 8;
}

#include "bfd-in2.h"

static int
gdb_print_insn_bfin (bfd_vma memaddr, disassemble_info *info)
{
    return print_insn_bfin (memaddr, info);
}


/* This function implements the BREAKPOINT_FROM_PC macro.  It uses the
   program counter value to determine whether a 16-bit or 32-bit
   breakpoint should be used.  It returns a pointer to a string of
   bytes that encode a breakpoint instruction, stores the length of
   the string to *lenptr, and adjusts the program counter (if
   necessary) to point to the actual memory location where the
   breakpoint should be inserted.  */
                                                                                                         
const unsigned char *
bfin_breakpoint_from_pc (CORE_ADDR *pcptr, int *lenptr)
{
  static char bfin_breakpoint[] = REMOTE_BREAKPOINT;
                                                                                                         
  *lenptr = sizeof (bfin_breakpoint);
  return bfin_breakpoint;
}


/* Extract from an array REGBUF containing the (raw) register state a
   function return value of type TYPE, and copy that, in virtual
   format, into VALBUF.  */

static void
bfin_extract_return_value (struct type *type,
			  struct regcache *regs,
			  void *dst)
{
  bfd_byte *valbuf = dst;

  /* If the the type is a plain integer, then the access is
     straight-forward.  Otherwise we have to play around a bit more.  */
  int len = TYPE_LENGTH (type);
  int regno = BFIN_R0_REGNUM;
  ULONGEST tmp;

  /* this is only for scalar types.
     Need to investigate the return value mechanism for structures.
     The caller is allocating space and using a pointer register
  */
  if (TYPE_CODE (type) == TYPE_CODE_INT
	   || TYPE_CODE (type) == TYPE_CODE_CHAR
	   || TYPE_CODE (type) == TYPE_CODE_BOOL
	   || TYPE_CODE (type) == TYPE_CODE_PTR
	   || TYPE_CODE (type) == TYPE_CODE_REF
	   || TYPE_CODE (type) == TYPE_CODE_ENUM)
  {
    while (len > 0)
    {
	/* By using store_unsigned_integer we avoid having to do
	   anything special for small big-endian values.  */
	regcache_cooked_read_unsigned (regs, regno++, &tmp);
	store_unsigned_integer (valbuf, 
		(len > INT_REGISTER_RAW_SIZE
		? INT_REGISTER_RAW_SIZE : len),
		tmp);
	len -= INT_REGISTER_RAW_SIZE;
	valbuf += INT_REGISTER_RAW_SIZE;
    }
  }
  else{
#ifdef BFIN_NOT_TESTED
fprintf(stderr, "need to figure out how structures are returned in bfin\n");
#endif 
  }
}

/* Extract from an array REGBUF containing the (raw) register state
   the address in which a function should return its structure value.  */

static CORE_ADDR
bfin_extract_struct_value_address (struct regcache *regcache)
{
  ULONGEST ret;

  regcache_cooked_read_unsigned (regcache, BFIN_R1_REGNUM, &ret);
  return ret;
}


/* Write into appropriate registers a function return value of type
   TYPE, given in virtual format.  */

static void
bfin_store_return_value (struct type *type, struct regcache *regs,
			const void *src)
{
  const bfd_byte *valbuf = src;

    if (TYPE_CODE (type)    == TYPE_CODE_INT
	   || TYPE_CODE (type) == TYPE_CODE_CHAR
	   || TYPE_CODE (type) == TYPE_CODE_BOOL
	   || TYPE_CODE (type) == TYPE_CODE_PTR
	   || TYPE_CODE (type) == TYPE_CODE_REF
	   || TYPE_CODE (type) == TYPE_CODE_ENUM)
    {
      if (TYPE_LENGTH (type) <= 4)
      {
	  /* Values of one word or less are zero/sign-extended and
	     returned in r0.  */
	  bfd_byte tmpbuf[INT_REGISTER_RAW_SIZE];
	  LONGEST val = unpack_long (type, valbuf);

	  store_signed_integer (tmpbuf, INT_REGISTER_RAW_SIZE, val);
	  regcache_cooked_write (regs, BFIN_R0_REGNUM, tmpbuf);
     }
      else
      {
	  /* Integral values greater than one word are stored in consecutive
	     registers starting with r0.  This will always be a multiple of
	     the regiser size.  */
	  int len = TYPE_LENGTH (type);
	  int regno = BFIN_R0_REGNUM;

	  while (len > 0)
	  {
	      regcache_cooked_write (regs, regno++, valbuf);
	      len -= INT_REGISTER_RAW_SIZE;
	      valbuf += INT_REGISTER_RAW_SIZE;
	  }
     }
  }
  else
    {
#ifdef BFIN_NOT_TESTED
      fprintf(stderr, "structure returning\n");
#endif 
    }
}

static int
bfin_get_longjmp_target (CORE_ADDR *pc)
{
  CORE_ADDR jb_addr;
  char buf[INT_REGISTER_RAW_SIZE];
  struct gdbarch_tdep *tdep = gdbarch_tdep (current_gdbarch);
  
  jb_addr = read_register (BFIN_R1_REGNUM);

  if (target_read_memory (jb_addr + tdep->jb_pc * tdep->jb_elt_size, buf,
			  INT_REGISTER_RAW_SIZE))
    return 0;

  *pc = extract_unsigned_integer (buf, INT_REGISTER_RAW_SIZE);
  return 1;
}


/* Return the BFIN register name corresponding to register I.  */
static const char *
bfin_register_name (int i)
{
#ifdef JYOTIK_DEBUG
   printf("Jyotik Debug: Accessing register name %s\n", bfin_register_name_strings[i]);
#endif 
   return bfin_register_name_strings[i];
}

/****************************************************/
/* FUNCTION : bfin_translate_address                */
/* ABSTRACT : Given a file local address tranlate   */
/*            to a process address                  */
/*            Basic logic :                         */
/*    if(addr is in text) new_addr = text + addr    */
/*    if(addr is in data) new_addr = data + addr    */
/*    where text and data are queried (once) from   */
/*    the remote server using a fake register val   */
/*    also queried would be text len to determine   */
/*    if text or data                               */
/****************************************************/
void
bfin_translate_address (struct gdbarch *gdbarch,
                                       struct regcache *regcache,
                                       CORE_ADDR gdb_addr, int gdb_len,
                                       CORE_ADDR * rem_addr, int *rem_len)
{
  static long text = 0;
  static long data = 0;
  static long text_len = 0;
  int text_regnum = 212;
  if(!text){
  }

  *rem_addr = gdb_addr + text;

  *rem_len  = gdb_len;
}

static CORE_ADDR
bfin_frame_base_address (struct frame_info *next_frame, void **this_cache)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);

  return cache->base;
}
static CORE_ADDR
bfin_frame_local_address (struct frame_info *next_frame, void **this_cache)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);

   fprintf(stderr, "JYOTIK DEBUG: LOCAL\n");
  return cache->base + 4;
}
static CORE_ADDR
bfin_frame_args_address (struct frame_info *next_frame, void **this_cache)
{
  struct bfin_frame_cache *cache = bfin_frame_cache (next_frame, this_cache);
   fprintf(stderr, "JYOTIK DEBUG: ARGS\n");
  return cache->base -4;
}

static const struct frame_base bfin_frame_base =
{
  &bfin_frame_unwind,
  bfin_frame_base_address,
  bfin_frame_local_address ,
  bfin_frame_args_address 
};

static struct frame_id
bfin_unwind_dummy_id (struct gdbarch *gdbarch, struct frame_info *next_frame)
{
  char buf[4];
  CORE_ADDR fp;

  frame_unwind_register (next_frame, BFIN_FP_REGNUM, buf);
  fp = extract_unsigned_integer (buf, 4);

  /* See the end of bfin_push_dummy_call.  */
  return frame_id_build (fp + 8, frame_pc_unwind (next_frame));
}

static CORE_ADDR
bfin_unwind_pc (struct gdbarch *gdbarch, struct frame_info *next_frame)
{
  char buf[8];
  int* pInt1 = (int*)buf;
  int* pInt2 = (int*)(buf +4);
  CORE_ADDR ret, start_code;
  frame_unwind_register (next_frame, PC_REGNUM , buf);
  return  extract_typed_address (buf, builtin_type_void_func_ptr);
}

static const struct frame_unwind *
bfin_sigtramp_frame_p (CORE_ADDR pc)
{
  char *name;
#if 0 // I think it's irrelevent for us so ignoring for the time being -Jyotik
  /* We shouldn't even bother to try if the OSABI didn't register
     a get_sigtramp_info handler.  */
  if (!gdbarch_tdep (current_gdbarch)->get_sigtramp_info)
    return NULL;

  find_pc_partial_function (pc, &name, NULL, NULL);
  if (PC_IN_SIGTRAMP (pc, name))
    return &bfin_sigtramp_frame_unwind;
#endif 
  return NULL;
}

int bfin_frameless_func_invoke(struct frame_info *fi)
{
  if (get_frame_type (fi) == SIGTRAMP_FRAME)
    return 0;
  else
    return frameless_look_for_prologue (fi);
}

/* Initialize the current architecture based on INFO.  If possible,
   re-use an architecture from ARCHES, which is a list of
   architectures already created during this debugging session.

   Called e.g. at program startup, when reading a core file, and when
   reading a binary file.  */

static struct gdbarch *
bfin_gdbarch_init (struct gdbarch_info info, struct gdbarch_list *arches)
{
  struct gdbarch_tdep *tdep;
  struct gdbarch *gdbarch;

  /* Try to deterimine the ABI of the object we are loading.  */

  /* If there is already a candidate, use it.  */
  arches = gdbarch_list_lookup_by_info (arches, &info);
  if (arches != NULL)
    return arches->gdbarch;
  gdbarch = gdbarch_alloc (&info, NULL);
  
  /* Offset from address of function to start of its code.  */
  set_gdbarch_function_start_offset (gdbarch, 0);
  set_gdbarch_skip_prologue (gdbarch, bfin_skip_prologue);
  set_gdbarch_breakpoint_from_pc (gdbarch, bfin_breakpoint_from_pc);
  /* stack grows downwards */
  set_gdbarch_inner_than (gdbarch, core_addr_lessthan);
  set_gdbarch_parm_boundary (gdbarch, 32);

  set_gdbarch_believe_pcc_promotion (gdbarch, 1);
  set_gdbarch_decr_pc_after_break (gdbarch, 2);
  set_gdbarch_extract_return_value (gdbarch, bfin_extract_return_value);
  set_gdbarch_store_return_value (gdbarch, bfin_store_return_value);

  set_gdbarch_frameless_function_invocation(gdbarch, bfin_frameless_func_invoke); 
  set_gdbarch_frame_args_skip (gdbarch, FRAME_ARGS_SKIP);
  set_gdbarch_register_type (gdbarch, bfin_register_type);
  set_gdbarch_register_name (gdbarch, bfin_register_name);
  
  set_gdbarch_num_regs(gdbarch, BFIN_NUM_REGS);
  set_gdbarch_sp_regnum (gdbarch, BFIN_SP_REGNUM);
  set_gdbarch_pc_regnum(gdbarch, BFIN_PC_REGNUM);
  set_gdbarch_push_dummy_call (gdbarch, bfin_push_dummy_call);
  
  /* Disassembly.  */
  set_gdbarch_print_insn (gdbarch, gdb_print_insn_bfin);

  set_gdbarch_unwind_dummy_id (gdbarch, bfin_unwind_dummy_id);
  set_gdbarch_unwind_pc (gdbarch, bfin_unwind_pc);
  frame_base_set_default (gdbarch, &bfin_frame_base);

  set_gdbarch_get_longjmp_target (gdbarch, bfin_get_longjmp_target);
 
  frame_unwind_append_predicate (gdbarch, bfin_sigtramp_frame_p);
  frame_unwind_append_predicate (gdbarch, bfin_frame_p);

  /* currently dont expose psuedo regs
     we may give out text_start, data_start, bss_start
  */
  set_gdbarch_num_pseudo_regs (gdbarch, 0); 


  
 
  /* On BFIN targets char defaults to unsigned.  */
  set_gdbarch_char_signed (gdbarch, 0);

  /* do our address translations */
  set_gdbarch_remote_translate_xfer_address(gdbarch, bfin_translate_address);


  /* Frame handling.  */
  /* Frame unwinder.  */
  set_gdbarch_frame_args_skip (gdbarch, 0);


  /* Advance PC across function entry code.  */


  /* Breakpoint manipulation.  PC will get decremented in kernel */
  set_gdbarch_decr_pc_after_break (gdbarch, 0);


  return gdbarch;
}

static void
bfin_dump_tdep (struct gdbarch *current_gdbarch, struct ui_file *file)
{
  struct gdbarch_tdep *tdep = gdbarch_tdep (current_gdbarch);

  if (tdep == NULL)
    return;

}


extern initialize_file_ftype _initialize_bfin_tdep; /* -Wmissing-prototypes */

void
_initialize_bfin_tdep (void)
{
     gdbarch_register (bfd_arch_bfin, bfin_gdbarch_init, bfin_dump_tdep);
}
