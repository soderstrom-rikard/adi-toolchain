/*

    Copyright (c) 1990-1994,1997,1998,1999 Analog Devices Inc.,
	          All Rights Reserved

This material is considered highly CONFIDENTIAL and SENSITIVE
background Interlectual Property of Analog Devices Inc. Its recipient
is required to adhear to the LICENSE agreement.

This software is being provided to you, the LICENSEE, by Analog
Devices Inc (ADI) under the following license.  The following software
is proprietary background Intelectual Property of Analog Devices and
can not be used by its LICENSEE without written consent from ADI.

By obtaining, using and/or copying this software, you agree that you
have read, understood, and will comply with these terms and
conditions:

1. You may not, copy, modify or distribute, this software with out a
   written agreement from Analog Devices.


THIS SOFTWARE IS PROVIDED "AS IS", AND ADI MAKES NO REPRESENTATIONS
OR WARRANTIES, EXPRESS OR IMPLIED.  By way of example, but not
limitation, ADI MAKES NO REPRESENTATIONS OR WARRANTIES OF
MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE
OF THE LICENSED SOFTWARE OR DOCUMENTATION WILL NOT INFRINGE ANY THIRD
PARTY PATENTS, COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS.

*/
/* Defines needed when configuring for "bfin".
   Copyright (C) 1993 Free Software Foundation, Inc.

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */


#include "value.h"
#include "defs.h"
#include "symtab.h"
#include "frame.h"

/* Define the bit, byte, and word ordering of the machine.  */
#define TARGET_BYTE_ORDER LITTLE_ENDIAN

/* Immediately after a function call, return the saved pc.
   Can't always go through the frames for this because on some machines
   the new frame is not set up until the new function executes
   some instructions.  */
#define SAVED_PC_AFTER_CALL(frame) bfin_saved_pc_after_call(frame)

char **gdbtgt_regnames ();
int gdbtgt_nregs ();


#define REGISTER_NAMES  \
 {"syscfg", "orig_r0","r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", \
  "p0", "p1", "p2", "p3", "p4", "p5", "fp", "usp", \
  "i0", "i1", "i2", "i3", "m0", "m1", "m2", "m3", \
  "l0", "l1", "l2", "l3", "b0", "b1", "b2", "b3", \
  "a0x", "a0w", "a1x", "a1w", "lc0", "lc1", "lt0", "lt1",\
  "lb0", "lb1", "astat", "unk", "rets", "pc", "retx", "retn", \
  "rete", "seqstat", "ipend", "orig_pc",  "extra1", "extra2", "extra3"};

#define NUM_REGS 57	
#define NUM_FREGS	0

#define REGISTER_BYTES  (NUM_REGS *4)

/* Index within `registers' of the first byte of the space for
   register N.  */

#define REGISTER_BYTE(N)  ((N)*4)

/* Number of bytes of storage in the actual machine representation
   for register N.  On the z8k, all but the pc are 2 bytes, but we
   keep them all as 4 bytes and trim them on I/O */

#define REGISTER_RAW_SIZE(N) 4

/* Number of bytes of storage in the program's representation
   for register N.  */

#define REGISTER_VIRTUAL_SIZE(N) REGISTER_RAW_SIZE(N)

/* Largest value REGISTER_RAW_SIZE can have.  */

#define MAX_REGISTER_RAW_SIZE 4

/* Largest value REGISTER_VIRTUAL_SIZE can have.  */

// #define MAX_REGISTER_VIRTUAL_SIZE 4

/*#define INIT_FRAME_PC(x,y) init_frame_pc(x,y)*/
/* Initializer for an array of names of registers.
   Entries beyond the first NUM_REGS are ignored.  */

#if 0
/* Register numbers of various important registers.
   Note that some of these values are "real" register numbers,
   and correspond to the general registers of the machine,
   and some are "phony" register numbers which are too large
   to be actual register numbers as far as the user is concerned
   but do serve to get the desired values when passed to read_register.  */

#define R0_REGNUM	0	/* The return value register */
#define R2_REGNUM	2	/* The last argument in register */
#define R7_REGNUM 	7
#define P5_REGNUM 	13
#define SP_REGNUM 	14	/* Contains sp, whatever memory model */
#define FP_REGNUM 	15	/* Conatins fp, whatever memory model */

#define PC_REGNUM 	16	/* Contains program counter */
#define RETS_REGNUM	17
#endif

/* Store the address of the place in which to copy the structure the
   subroutine will return.  This is called from call_function. */

#define STORE_STRUCT_RETURN(ADDR, SP) \
    write_register (BFIN_R0_REGNUM, ADDR)


/* Extract from an array REGBUF containing the (raw) register state
   the address in which a function should return its structure value,
   as a CORE_ADDR (or an expression that can be used as one).  */

#define EXTRACT_STRUCT_VALUE_ADDRESS(REGBUF) (*(CORE_ADDR *)(REGBUF))

/* Describe the pointer in each stack frame to the previous stack frame
   (its caller).  */

/* FRAME_CHAIN takes a frame's nominal address and produces the frame's
   chain-pointer.
   In the case of the blackfin, the frame's nominal address
   is the address of a ptr sized byte word containing the calling
   frame's address.  */

#define DEPRECATED_FRAME_CHAIN(thisframe) bfin_frame_chain(thisframe)

/* Define other aspects of the stack frame.  */

/* A macro that tells us whether the function invocation represented
   by FI does not have a frame on the stack associated with it.  If it
   does not, FRAMELESS is set to 1, else 0.  */
#define FRAMELESS_FUNCTION_INVOCATION(FI) frameless_look_for_prologue(FI)

#define FRAME_SAVED_PC(FRAME) bfin_frame_saved_pc(FRAME)

/* Set VAL to the number of args passed to frame described by FI.
   Can set VAL to -1, meaning no way to tell.  */

/* Need to research if this is possible, until then no
*/
#if !defined (FRAME_NUM_ARGS)
/* #define FRAME_NUM_ARGS(val,fi) (val = -1)	 */
#define FRAME_NUM_ARGS(fi)	-1
#define FRAME_NUM_ARGS_P() (0)
#endif

/* Return number of bytes at start of arglist that are not really args.  */
/* On a regular frame with a link command rets and old fp are stored     */
#define FRAME_ARGS_SKIP 8
//#define FRAME_ARGS_ADDRESS(fi) (get_frame_base (fi) - 4)
//#define FRAME_LOCALS_ADDRESS(fi) (get_frame_base (fi) + 4)

struct frame_info;

/* Things needed for making the inferior call functions.
   The CALL_DUMMY macro is the sequence of instructions, as disassembled
   by gdb itself:
   	
   	CALL 0x0 		; pcrel24 
	event 	; for breakpoint
*/
#define CALL_DUMMY { 0xe300, 0xa100 }
#define CALL_DUMMY_LENGTH 8		/* Size of CALL_DUMMY */
#define CALL_DUMMY_START_OFFSET 0       /* Start execution at beginning of dummy */
#define CALL_DUMMY_BREAKPOINT_OFFSET 4 

/* Insert the specified number of args and function address
   into a call sequence of the above form stored at DUMMYNAME.
   We use the BFD routines to store a little-endian value of known size.  */

#define FIX_CALL_DUMMY(dummyname, pc, fun, nargs, args, type, gcc_p)     \
{ \
  int from, to, delta, loc; \
  to = (int)(fun); \
  delta = to - (int)pc; \
  *((unsigned short *)(dummyname) + 1) = ((delta)>>1 & 0xffff); \
  *((unsigned short *)(dummyname)) |= ((delta >> 17) & 0xff); \
}

/* Push an empty stack frame, to record the current PC, etc.  */

#define PUSH_DUMMY_FRAME	{ bfin_push_dummy_frame (); }

extern void bfin_push_dummy_frame PARAMS ((void));

extern void bfin_pop_frame PARAMS ((void));

/* Discard from the stack the innermost frame, restoring all registers.  */

#define POP_FRAME		{ bfin_pop_frame (); }

/* Offset from SP to first arg on stack at first instruction of a function */
#define SP_ARG0 (0)

#define read_memory_short(x)  (read_memory_integer(x,2) & 0xffff)

#define NO_STD_REGS

#if 0
#define	PRINT_REGISTER_HOOK(regno) print_register_hook(regno)
#endif

#define REGISTER_SIZE 4


#if !defined (REMOTE_BREAKPOINT)
#define REMOTE_BREAKPOINT {0xa1, 0x00}
#endif

#define TARGET_BFIN

//#define GDBARCH_DEBUG 2
#define GDB_MULTI_ARCH GDB_MULTI_ARCH_PARTIAL

