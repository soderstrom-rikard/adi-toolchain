/* Definitions for the Blackfin port.
   Copyright (C) 2005, 2007, 2008 Free Software Foundation, Inc.
   Contributed by Analog Devices.

   This file is part of GCC.

   GCC is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published
   by the Free Software Foundation; either version 3, or (at your
   option) any later version.

   GCC is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
   License for more details.

   You should have received a copy of the GNU General Public License
   along with GCC; see the file COPYING3.  If not see
   <http://www.gnu.org/licenses/>.  */

#ifndef _BFIN_CONFIG
#define _BFIN_CONFIG

#define OBJECT_FORMAT_ELF

#define BRT 1
#define BRF 0

/* CPU type.  */
typedef enum bfin_cpu_type
{
  BFIN_CPU_UNKNOWN,
  BFIN_CPU_BF504,
  BFIN_CPU_BF506,
  BFIN_CPU_BF512,
  BFIN_CPU_BF514,
  BFIN_CPU_BF516,
  BFIN_CPU_BF518,
  BFIN_CPU_BF522,
  BFIN_CPU_BF523,
  BFIN_CPU_BF524,
  BFIN_CPU_BF525,
  BFIN_CPU_BF526,
  BFIN_CPU_BF527,
  BFIN_CPU_BF531,
  BFIN_CPU_BF532,
  BFIN_CPU_BF533,
  BFIN_CPU_BF534,
  BFIN_CPU_BF536,
  BFIN_CPU_BF537,
  BFIN_CPU_BF538,
  BFIN_CPU_BF539,
  BFIN_CPU_BF542,
  BFIN_CPU_BF542M,
  BFIN_CPU_BF544,
  BFIN_CPU_BF544M,
  BFIN_CPU_BF547,
  BFIN_CPU_BF547M,
  BFIN_CPU_BF548,
  BFIN_CPU_BF548M,
  BFIN_CPU_BF549,
  BFIN_CPU_BF549M,
  BFIN_CPU_BF561,
  BFIN_CPU_BF592,
  BFIN_CPU_BF606,
  BFIN_CPU_BF607,
  BFIN_CPU_BF608,
  BFIN_CPU_BF609
} bfin_cpu_t;

/* Value of -mcpu= */
extern bfin_cpu_t bfin_cpu_type;

/* Value of -msi-revision= */
extern int bfin_si_revision;

extern unsigned int bfin_workarounds;

/* Print subsidiary information on the compiler version in use.  */
#define TARGET_VERSION fprintf (stderr, " (BlackFin bfin)")

/* Run-time compilation parameters selecting different hardware subsets.  */

extern int target_flags;

/* Predefinition in the preprocessor for this target machine */
#ifndef TARGET_CPU_CPP_BUILTINS
#define TARGET_CPU_CPP_BUILTINS()		\
  do						\
    {						\
      builtin_define_std ("bfin");		\
      builtin_define_std ("BFIN");		\
      builtin_define ("__ADSPBLACKFIN__");	\
      builtin_define ("__ADSPLPBLACKFIN__");	\
						\
      switch (bfin_cpu_type)			\
	{					\
	case BFIN_CPU_BF504:			\
	  builtin_define ("__ADSPBF504__");	\
	  builtin_define ("__ADSPBF50x__");	\
	  break;				\
	case BFIN_CPU_BF506:			\
	  builtin_define ("__ADSPBF506__");	\
	  builtin_define ("__ADSPBF50x__");	\
	  break;				\
	case BFIN_CPU_BF512:			\
	  builtin_define ("__ADSPBF512__");	\
	  builtin_define ("__ADSPBF51x__");	\
	  break;				\
	case BFIN_CPU_BF514:			\
	  builtin_define ("__ADSPBF514__");	\
	  builtin_define ("__ADSPBF51x__");	\
	  break;				\
	case BFIN_CPU_BF516:			\
	  builtin_define ("__ADSPBF516__");	\
	  builtin_define ("__ADSPBF51x__");	\
	  break;				\
	case BFIN_CPU_BF518:			\
	  builtin_define ("__ADSPBF518__");	\
	  builtin_define ("__ADSPBF51x__");	\
	  break;				\
	case BFIN_CPU_BF522:			\
	  builtin_define ("__ADSPBF522__");	\
	  builtin_define ("__ADSPBF52x__");	\
	  break;				\
	case BFIN_CPU_BF523:			\
	  builtin_define ("__ADSPBF523__");	\
	  builtin_define ("__ADSPBF52x__");	\
	  break;				\
	case BFIN_CPU_BF524:			\
	  builtin_define ("__ADSPBF524__");	\
	  builtin_define ("__ADSPBF52x__");	\
	  break;				\
	case BFIN_CPU_BF525:			\
	  builtin_define ("__ADSPBF525__");	\
	  builtin_define ("__ADSPBF52x__");	\
	  break;				\
	case BFIN_CPU_BF526:			\
	  builtin_define ("__ADSPBF526__");	\
	  builtin_define ("__ADSPBF52x__");	\
	  break;				\
	case BFIN_CPU_BF527:			\
	  builtin_define ("__ADSPBF527__");	\
	  builtin_define ("__ADSPBF52x__");	\
	  break;				\
	case BFIN_CPU_BF531:			\
	  builtin_define ("__ADSPBF531__");	\
	  break;				\
	case BFIN_CPU_BF532:			\
	  builtin_define ("__ADSPBF532__");	\
	  break;				\
	case BFIN_CPU_BF533:			\
	  builtin_define ("__ADSPBF533__");	\
	  break;				\
	case BFIN_CPU_BF534:			\
	  builtin_define ("__ADSPBF534__");	\
	  break;				\
	case BFIN_CPU_BF536:			\
	  builtin_define ("__ADSPBF536__");	\
	  break;				\
	case BFIN_CPU_BF537:			\
	  builtin_define ("__ADSPBF537__");	\
	  break;				\
	case BFIN_CPU_BF538:			\
	  builtin_define ("__ADSPBF538__");	\
	  break;				\
	case BFIN_CPU_BF539:			\
	  builtin_define ("__ADSPBF539__");	\
	  break;				\
	case BFIN_CPU_BF542M:			\
	  builtin_define ("__ADSPBF542M__");	\
	case BFIN_CPU_BF542:			\
	  builtin_define ("__ADSPBF542__");	\
	  builtin_define ("__ADSPBF54x__");	\
	  break;				\
	case BFIN_CPU_BF544M:			\
	  builtin_define ("__ADSPBF544M__");	\
	case BFIN_CPU_BF544:			\
	  builtin_define ("__ADSPBF544__");	\
	  builtin_define ("__ADSPBF54x__");	\
	  break;				\
	case BFIN_CPU_BF547M:			\
	  builtin_define ("__ADSPBF547M__");	\
	case BFIN_CPU_BF547:			\
	  builtin_define ("__ADSPBF547__");	\
	  builtin_define ("__ADSPBF54x__");	\
	  break;				\
	case BFIN_CPU_BF548M:			\
	  builtin_define ("__ADSPBF548M__");	\
	case BFIN_CPU_BF548:			\
	  builtin_define ("__ADSPBF548__");	\
	  builtin_define ("__ADSPBF54x__");	\
	  break;				\
	case BFIN_CPU_BF549M:			\
	  builtin_define ("__ADSPBF549M__");	\
	case BFIN_CPU_BF549:			\
	  builtin_define ("__ADSPBF549__");	\
	  builtin_define ("__ADSPBF54x__");	\
	  break;				\
	case BFIN_CPU_BF561:			\
	  builtin_define ("__ADSPBF561__");	\
	  break;				\
	case BFIN_CPU_BF592:			\
	  builtin_define ("__ADSPBF592__");	\
	  builtin_define ("__ADSPBF59x__");	\
	  break;				\
	case BFIN_CPU_BF606:			\
	  builtin_define ("__ADSPBF606__");	\
	  builtin_define ("__ADSPBF60x__");	\
	  break;				\
	case BFIN_CPU_BF607:			\
	  builtin_define ("__ADSPBF607__");	\
	  builtin_define ("__ADSPBF60x__");	\
	  break;				\
	case BFIN_CPU_BF608:			\
	  builtin_define ("__ADSPBF608__");	\
	  builtin_define ("__ADSPBF60x__");	\
	  break;				\
	case BFIN_CPU_BF609:			\
	  builtin_define ("__ADSPBF609__");	\
	  builtin_define ("__ADSPBF60x__");	\
	  break;				\
	}					\
						\
      if (bfin_si_revision != -1)		\
	{					\
	  /* space of 0xnnnn and a NUL */	\
	  char *buf = alloca (7);		\
						\
	  sprintf (buf, "0x%04x", bfin_si_revision);			\
	  builtin_define_with_value ("__SILICON_REVISION__", buf, 0);	\
	}								\
									\
      if (bfin_workarounds)						\
	builtin_define ("__WORKAROUNDS_ENABLED");			\
      if (ENABLE_WA_SPECULATIVE_LOADS)					\
	builtin_define ("__WORKAROUND_SPECULATIVE_LOADS");		\
      if (ENABLE_WA_SPECULATIVE_SYNCS)					\
	builtin_define ("__WORKAROUND_SPECULATIVE_SYNCS");		\
      if (ENABLE_WA_INDIRECT_CALLS)					\
	builtin_define ("__WORKAROUND_INDIRECT_CALLS");			\
      if (ENABLE_WA_RETS)						\
	builtin_define ("__WORKAROUND_RETS");				\
      if (ENABLE_WA_UNSAFE_NULL_ADDR)						\
	builtin_define ("__WORKAROUND_UNSAFE_NULL_ADDR");				\
						\
      if (TARGET_FDPIC)				\
	{					\
	  builtin_define ("__BFIN_FDPIC__");	\
	  builtin_define ("__FDPIC__");		\
	}					\
      if (TARGET_ID_SHARED_LIBRARY		\
	  && !TARGET_SEP_DATA)			\
	builtin_define ("__ID_SHARED_LIB__");	\
      if (flag_no_builtin)			\
	builtin_define ("__NO_BUILTIN");	\
      if (TARGET_MULTICORE)			\
	builtin_define ("__BFIN_MULTICORE");	\
      if (TARGET_COREA)				\
	builtin_define ("__BFIN_COREA");	\
      if (TARGET_COREB)				\
	builtin_define ("__BFIN_COREB");	\
      if (TARGET_CORE0)				\
	builtin_define ("__BFIN_CORE0");	\
      if (TARGET_CORE1)				\
	builtin_define ("__BFIN_CORE1");	\
      if (TARGET_SDRAM)				\
	builtin_define ("__BFIN_SDRAM");	\
    }						\
  while (0)
#endif

#define DRIVER_SELF_SPECS SUBTARGET_DRIVER_SELF_SPECS	"\
 %{mleaf-id-shared-library:%{!mid-shared-library:-mid-shared-library}} \
 %{mfdpic:%{!fpic:%{!fpie:%{!fPIC:%{!fPIE:\
   	    %{!fno-pic:%{!fno-pie:%{!fno-PIC:%{!fno-PIE:-fpie}}}}}}}}} \
"
#ifndef SUBTARGET_DRIVER_SELF_SPECS
# define SUBTARGET_DRIVER_SELF_SPECS
#endif

#define LINK_GCC_C_SEQUENCE_SPEC "\
  %{mfast-fp:-lbffastfp} %G %L %{mfast-fp:-lbffastfp} %G \
"

/* A C string constant that tells the GCC driver program options to pass to
   the assembler.  It can also specify how to translate options you give to GNU
   CC into options for GCC to pass to the assembler.  See the file `sun3.h'
   for an example of this.

   Do not define this macro if it does not need to do anything.

   Defined in svr4.h.  */
#undef  ASM_SPEC
#define ASM_SPEC "\
%{G*} %{v} %{n} %{T} %{Ym,*} %{Yd,*} %{Wa,*:%*} \
    %{mno-fdpic:-mnopic} %{mfdpic} %{mcpu=*}"

#define LINK_SPEC "\
%{h*} %{v:-V} \
%{b} \
%{mfdpic:-melf32bfinfd -z text} \
%{static:-dn -Bstatic} \
%{shared:-G -Bdynamic} \
%{symbolic:-Bsymbolic} \
%{G*} \
%{YP,*} \
%{Qy:} %{!Qn:-Qy} \
-init __init -fini __fini "

/* Generate DSP instructions, like DSP halfword loads */
#define TARGET_DSP			(1)

#define TARGET_DEFAULT 0

/* Maximum number of library ids we permit */
#define MAX_LIBRARY_ID 255

extern const char *bfin_library_id_string;

/* Sometimes certain combinations of command options do not make
   sense on a particular target machine.  You can define a macro
   `OVERRIDE_OPTIONS' to take account of this.  This macro, if
   defined, is executed once just after all the command options have
   been parsed.
 
   Don't use this macro to turn on various extra optimizations for
   `-O'.  That is what `OPTIMIZATION_OPTIONS' is for.  */
 
#define OVERRIDE_OPTIONS override_options ()

#define FUNCTION_MODE    SImode
#define Pmode            SImode

/* store-condition-codes instructions store 0 for false
   This is the value stored for true.  */
#define STORE_FLAG_VALUE 1

/* Define this if pushing a word on the stack
   makes the stack pointer a smaller address.  */
#define STACK_GROWS_DOWNWARD

#define STACK_PUSH_CODE PRE_DEC

/* Define this to nonzero if the nominal address of the stack frame
   is at the high-address end of the local variables;
   that is, each additional local variable allocated
   goes at a more negative offset in the frame.  */
#define FRAME_GROWS_DOWNWARD 1

/* We define a dummy ARGP register; the parameters start at offset 0 from
   it. */
#define FIRST_PARM_OFFSET(DECL) 0

/* Offset within stack frame to start allocating local variables at.
   If FRAME_GROWS_DOWNWARD, this is the offset to the END of the
   first local allocated.  Otherwise, it is the offset to the BEGINNING
   of the first local allocated.  */
#define STARTING_FRAME_OFFSET 0

/* Register to use for pushing function arguments.  */
#define STACK_POINTER_REGNUM REG_P6

/* Base register for access to local variables of the function.  */
#define FRAME_POINTER_REGNUM REG_P7

/* A dummy register that will be eliminated to either FP or SP.  */
#define ARG_POINTER_REGNUM REG_ARGP

/* `PIC_OFFSET_TABLE_REGNUM'
     The register number of the register used to address a table of
     static data addresses in memory.  In some cases this register is
     defined by a processor's "application binary interface" (ABI).
     When this macro is defined, RTL is generated for this register
     once, as with the stack pointer and frame pointer registers.  If
     this macro is not defined, it is up to the machine-dependent files
     to allocate such a register (if necessary). */
#define PIC_OFFSET_TABLE_REGNUM (REG_P5)

#define FDPIC_FPTR_REGNO REG_P1
#define FDPIC_REGNO REG_P3
#define OUR_FDPIC_REG	get_hard_reg_initial_val (SImode, FDPIC_REGNO)

/* A static chain register for nested functions.  We need to use a
   call-clobbered register for this.  */
#define STATIC_CHAIN_REGNUM REG_P2

/* Define this if functions should assume that stack space has been
   allocated for arguments even when their values are passed in
   registers.

   The value of this macro is the size, in bytes, of the area reserved for
   arguments passed in registers.

   This space can either be allocated by the caller or be a part of the
   machine-dependent stack frame: `OUTGOING_REG_PARM_STACK_SPACE'
   says which.  */
#define FIXED_STACK_AREA 12
#define REG_PARM_STACK_SPACE(FNDECL) FIXED_STACK_AREA

/* Define this if the above stack space is to be considered part of the
 * space allocated by the caller.  */
#define OUTGOING_REG_PARM_STACK_SPACE 1
	  
/* Define this if the maximum size of all the outgoing args is to be
   accumulated and pushed during the prologue.  The amount can be
   found in the variable current_function_outgoing_args_size. */ 
#define ACCUMULATE_OUTGOING_ARGS 1

/* Value should be nonzero if functions must have frame pointers.
   Zero means the frame pointer need not be set up (and parms
   may be accessed via the stack pointer) in functions that seem suitable.
   This is computed in `reload', in reload1.c.  
*/
#define FRAME_POINTER_REQUIRED (bfin_frame_pointer_required ())

/*#define DATA_ALIGNMENT(TYPE, BASIC-ALIGN) for arrays.. */

/* If defined, a C expression to compute the alignment for a local
   variable.  TYPE is the data type, and ALIGN is the alignment that
   the object would ordinarily have.  The value of this macro is used
   instead of that alignment to align the object.

   If this macro is not defined, then ALIGN is used.

   One use of this macro is to increase alignment of medium-size
   data to make it all fit in fewer cache lines.  */

#define LOCAL_ALIGNMENT(TYPE, ALIGN) bfin_local_alignment ((TYPE), (ALIGN))

/* Make strings word-aligned so strcpy from constants will be faster.  */
#define CONSTANT_ALIGNMENT(EXP, ALIGN)  \
  (TREE_CODE (EXP) == STRING_CST        \
   && (ALIGN) < BITS_PER_WORD ? BITS_PER_WORD : (ALIGN))    

#define TRAMPOLINE_SIZE (TARGET_FDPIC ? 30 : 18)
#define TRAMPOLINE_TEMPLATE(FILE)                                       \
  if (TARGET_FDPIC)							\
    {									\
      fprintf(FILE, "\t.dd\t0x00000000\n"); /* 0 */			\
      fprintf(FILE, "\t.dd\t0x00000000\n"); /* 0 */			\
      fprintf(FILE, "\t.dd\t0x0000e109\n"); /* p1.l = fn low */		\
      fprintf(FILE, "\t.dd\t0x0000e149\n"); /* p1.h = fn high */	\
      fprintf(FILE, "\t.dd\t0x0000e10a\n"); /* p2.l = sc low */		\
      fprintf(FILE, "\t.dd\t0x0000e14a\n"); /* p2.h = sc high */	\
      fprintf(FILE, "\t.dw\t0xac4b\n"); /* p3 = [p1 + 4] */		\
      fprintf(FILE, "\t.dw\t0x9149\n"); /* p1 = [p1] */			\
      fprintf(FILE, "\t.dw\t0x0051\n"); /* jump (p1)*/			\
    }									\
  else									\
    {									\
      fprintf(FILE, "\t.dd\t0x0000e109\n"); /* p1.l = fn low */		\
      fprintf(FILE, "\t.dd\t0x0000e149\n"); /* p1.h = fn high */	\
      fprintf(FILE, "\t.dd\t0x0000e10a\n"); /* p2.l = sc low */		\
      fprintf(FILE, "\t.dd\t0x0000e14a\n"); /* p2.h = sc high */	\
      fprintf(FILE, "\t.dw\t0x0051\n"); /* jump (p1)*/			\
    }

#define INITIALIZE_TRAMPOLINE(TRAMP, FNADDR, CXT) \
  initialize_trampoline (TRAMP, FNADDR, CXT)

/* Definitions for register eliminations.

   This is an array of structures.  Each structure initializes one pair
   of eliminable registers.  The "from" register number is given first,
   followed by "to".  Eliminations of the same "from" register are listed
   in order of preference.

   There are two registers that can always be eliminated on the i386.
   The frame pointer and the arg pointer can be replaced by either the
   hard frame pointer or to the stack pointer, depending upon the
   circumstances.  The hard frame pointer is not used before reload and
   so it is not eligible for elimination.  */

#define ELIMINABLE_REGS				\
{{ ARG_POINTER_REGNUM, STACK_POINTER_REGNUM},	\
 { ARG_POINTER_REGNUM, FRAME_POINTER_REGNUM},	\
 { FRAME_POINTER_REGNUM, STACK_POINTER_REGNUM}}	\

/* Given FROM and TO register numbers, say whether this elimination is
   allowed.  Frame pointer elimination is automatically handled.

   All other eliminations are valid.  */

#define CAN_ELIMINATE(FROM, TO) \
  ((TO) == STACK_POINTER_REGNUM ? ! frame_pointer_needed : 1)

/* Define the offset between two registers, one to be eliminated, and the other
   its replacement, at the start of a routine.  */

#define INITIAL_ELIMINATION_OFFSET(FROM, TO, OFFSET) \
  ((OFFSET) = bfin_initial_elimination_offset ((FROM), (TO)))

/* This processor has
   8 data register for doing arithmetic
   8  pointer register for doing addressing, including
      1  stack pointer P6
      1  frame pointer P7
   4 sets of indexing registers (I0-3, B0-3, L0-3, M0-3)
   1  condition code flag register CC
   5  return address registers RETS/I/X/N/E
   1  arithmetic status register (ASTAT).  */

#define FIRST_PSEUDO_REGISTER 50

#define D_REGNO_P(X) ((X) <= REG_R7)
#define P_REGNO_P(X) ((X) >= REG_P0 && (X) <= REG_P7)
#define I_REGNO_P(X) ((X) >= REG_I0 && (X) <= REG_I3)
#define DP_REGNO_P(X) (D_REGNO_P (X) || P_REGNO_P (X))
#define ADDRESS_REGNO_P(X) ((X) >= REG_P0 && (X) <= REG_M3)
#define DREG_P(X) (REG_P (X) && D_REGNO_P (REGNO (X)))
#define PREG_P(X) (REG_P (X) && P_REGNO_P (REGNO (X)))
#define IREG_P(X) (REG_P (X) && I_REGNO_P (REGNO (X)))
#define DPREG_P(X) (REG_P (X) && DP_REGNO_P (REGNO (X)))

#define REGISTER_NAMES { \
  "R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7", \
  "P0", "P1", "P2", "P3", "P4", "P5", "SP", "FP", \
  "I0", "I1", "I2", "I3", "B0", "B1", "B2", "B3", \
  "L0", "L1", "L2", "L3", "M0", "M1", "M2", "M3", \
  "A0", "A1", \
  "CC", \
  "RETS", "RETI", "RETX", "RETN", "RETE", "ASTAT", "SEQSTAT", "USP", \
  "ARGP", \
  "LT0", "LT1", "LC0", "LC1", "LB0", "LB1" \
}

#define SHORT_REGISTER_NAMES { \
	"R0.L",	"R1.L",	"R2.L",	"R3.L", "R4.L", "R5.L", "R6.L", "R7.L", \
	"P0.L",	"P1.L",	"P2.L",	"P3.L", "P4.L", "P5.L", "SP.L", "FP.L", \
	"I0.L",	"I1.L", "I2.L",	"I3.L",	"B0.L",	"B1.L",	"B2.L",	"B3.L", \
	"L0.L",	"L1.L",	"L2.L",	"L3.L",	"M0.L",	"M1.L",	"M2.L",	"M3.L", }

#define HIGH_REGISTER_NAMES { \
	"R0.H",	"R1.H",	"R2.H",	"R3.H", "R4.H", "R5.H", "R6.H", "R7.H", \
	"P0.H",	"P1.H",	"P2.H",	"P3.H", "P4.H", "P5.H", "SP.H", "FP.H", \
	"I0.H",	"I1.H",	"I2.H",	"I3.H",	"B0.H",	"B1.H",	"B2.H",	"B3.H", \
	"L0.H",	"L1.H",	"L2.H",	"L3.H",	"M0.H",	"M1.H",	"M2.H",	"M3.H", }

#define DREGS_PAIR_NAMES { \
  "R1:0.p", 0, "R3:2.p", 0, "R5:4.p", 0, "R7:6.p", 0,  }

#define BYTE_REGISTER_NAMES { \
  "R0.B", "R1.B", "R2.B", "R3.B", "R4.B", "R5.B", "R6.B", "R7.B",  }


/* 1 for registers that have pervasive standard uses
   and are not available for the register allocator.  */

#define FIXED_REGISTERS \
/*r0 r1 r2 r3 r4 r5 r6 r7   p0 p1 p2 p3 p4 p5 p6 p7 */ \
{ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 1, 0,    \
/*i0 i1 i2 i3 b0 b1 b2 b3   l0 l1 l2 l3 m0 m1 m2 m3 */ \
  0, 0, 0, 0, 0, 0, 0, 0,   1, 1, 1, 1, 0, 0, 0, 0,    \
/*a0 a1 cc rets/i/x/n/e     astat seqstat usp argp lt0/1 lc0/1 */ \
  0, 0, 0, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,    \
/*lb0/1 */ \
  1, 1  \
}

/* 1 for registers not available across function calls.
   These must include the FIXED_REGISTERS and also any
   registers that can be used without being saved.
   The latter must include the registers where values are returned
   and the register where structure-value addresses are passed.
   Aside from that, you can include as many other registers as you like.  */

#define CALL_USED_REGISTERS \
/*r0 r1 r2 r3 r4 r5 r6 r7   p0 p1 p2 p3 p4 p5 p6 p7 */ \
{ 1, 1, 1, 1, 0, 0, 0, 0,   1, 1, 1, 0, 0, 0, 1, 0, \
/*i0 i1 i2 i3 b0 b1 b2 b3   l0 l1 l2 l3 m0 m1 m2 m3 */ \
  1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,   \
/*a0 a1 cc rets/i/x/n/e     astat seqstat usp argp lt0/1 lc0/1 */ \
  1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1, \
/*lb0/1 */ \
  1, 1  \
}

/* Order in which to allocate registers.  Each register must be
   listed once, even those in FIXED_REGISTERS.  List frame pointer
   late and fixed registers last.  Note that, in general, we prefer
   registers listed in CALL_USED_REGISTERS, keeping the others
   available for storage of persistent values. */

#define REG_ALLOC_ORDER \
{ REG_R0, REG_R1, REG_R2, REG_R3, REG_R7, REG_R6, REG_R5, REG_R4, \
  REG_P2, REG_P1, REG_P0, REG_P5, REG_P4, REG_P3, REG_P6, REG_P7, \
  REG_A0, REG_A1, \
  REG_I0, REG_I1, REG_I2, REG_I3, REG_B0, REG_B1, REG_B2, REG_B3, \
  REG_L0, REG_L1, REG_L2, REG_L3, REG_M0, REG_M1, REG_M2, REG_M3, \
  REG_RETS, REG_RETI, REG_RETX, REG_RETN, REG_RETE,		  \
  REG_ASTAT, REG_SEQSTAT, REG_USP, 				  \
  REG_CC, REG_ARGP,						  \
  REG_LT0, REG_LT1, REG_LC0, REG_LC1, REG_LB0, REG_LB1		  \
}

/* Macro to conditionally modify fixed_regs/call_used_regs.  */
#define CONDITIONAL_REGISTER_USAGE			\
  {							\
    conditional_register_usage();                       \
    if (TARGET_FDPIC)					\
      call_used_regs[FDPIC_REGNO] = 1;			\
    if (!TARGET_FDPIC && flag_pic)			\
      {							\
	fixed_regs[PIC_OFFSET_TABLE_REGNUM] = 1;	\
	call_used_regs[PIC_OFFSET_TABLE_REGNUM] = 1;	\
      }							\
  }

/* Define the classes of registers for register constraints in the
   machine description.  Also define ranges of constants.

   One of the classes must always be named ALL_REGS and include all hard regs.
   If there is more than one class, another class must be named NO_REGS
   and contain no registers.

   The name GENERAL_REGS must be the name of a class (or an alias for
   another name such as ALL_REGS).  This is the class of registers
   that is allowed by "g" or "r" in a register constraint.
   Also, registers outside this class are allocated only when
   instructions express preferences for them.

   The classes must be numbered in nondecreasing order; that is,
   a larger-numbered class must never be contained completely
   in a smaller-numbered class.

   For any two classes, it is very desirable that there be another
   class that represents their union. */


enum reg_class
{
  NO_REGS,
  IREGS,
  BREGS,
  LREGS,
  MREGS,
  CIRCREGS, /* Circular buffering registers, Ix, Bx, Lx together form.  See Automatic Circular Buffering.  */
  DAGREGS,
  EVEN_AREGS,
  ODD_AREGS,
  AREGS,
  CCREGS,
  EVEN_DREGS,
  ODD_DREGS,
  D0REGS,
  D1REGS,
  D2REGS,
  D3REGS,
  D4REGS,
  D5REGS,
  D6REGS,
  D7REGS,
  DREGS,
  P0REGS,
  FDPIC_REGS,
  FDPIC_FPTR_REGS,
  PREGS_CLOBBERED,
  PREGS,
  IPREGS,
  DPREGS,
  MOST_REGS,
  LT_REGS,
  LC_REGS,
  LB_REGS,
  PROLOGUE_REGS,
  NON_A_CC_REGS,
  ALL_REGS, LIM_REG_CLASSES
};

#define N_REG_CLASSES ((int)LIM_REG_CLASSES)

#define GENERAL_REGS DPREGS

/* Give names of register classes as strings for dump file.   */

#define REG_CLASS_NAMES \
{  "NO_REGS",		\
   "IREGS",		\
   "BREGS",		\
   "LREGS",		\
   "MREGS",		\
   "CIRCREGS",		\
   "DAGREGS",		\
   "EVEN_AREGS",	\
   "ODD_AREGS",		\
   "AREGS",		\
   "CCREGS",		\
   "EVEN_DREGS",	\
   "ODD_DREGS",		\
   "D0REGS",		\
   "D1REGS",		\
   "D2REGS",		\
   "D3REGS",		\
   "D4REGS",		\
   "D5REGS",		\
   "D6REGS",		\
   "D7REGS",		\
   "DREGS",		\
   "P0REGS",		\
   "FDPIC_REGS",	\
   "FDPIC_FPTR_REGS",	\
   "PREGS_CLOBBERED",	\
   "PREGS",		\
   "IPREGS",		\
   "DPREGS",		\
   "MOST_REGS",		\
   "LT_REGS",		\
   "LC_REGS",		\
   "LB_REGS",		\
   "PROLOGUE_REGS",	\
   "NON_A_CC_REGS",	\
   "ALL_REGS" }

/* An initializer containing the contents of the register classes, as integers
   which are bit masks.  The Nth integer specifies the contents of class N.
   The way the integer MASK is interpreted is that register R is in the class
   if `MASK & (1 << R)' is 1.

   When the machine has more than 32 registers, an integer does not suffice.
   Then the integers are replaced by sub-initializers, braced groupings
   containing several integers.  Each sub-initializer must be suitable as an
   initializer for the type `HARD_REG_SET' which is defined in
   `hard-reg-set.h'.  */

/* NOTE: DSP registers, IREGS - AREGS, are not GENERAL_REGS.  We use
   MOST_REGS as the union of DPREGS and DAGREGS.  */

#define REG_CLASS_CONTENTS \
    /* 31 - 0       63-32   */ \
{   { 0x00000000,    0 },		/* NO_REGS */	\
    { 0x000f0000,    0 },		/* IREGS */	\
    { 0x00f00000,    0 },		/* BREGS */		\
    { 0x0f000000,    0 },		/* LREGS */	\
    { 0xf0000000,    0 },		/* MREGS */   \
    { 0x0fff0000,    0 },		/* CIRCREGS */   \
    { 0xffff0000,    0 },		/* DAGREGS */   \
    { 0x00000000,    0x1 },		/* EVEN_AREGS */   \
    { 0x00000000,    0x2 },		/* ODD_AREGS */   \
    { 0x00000000,    0x3 },		/* AREGS */   \
    { 0x00000000,    0x4 },		/* CCREGS */  \
    { 0x00000055,    0 },		/* EVEN_DREGS */   \
    { 0x000000aa,    0 },		/* ODD_DREGS */   \
    { 0x00000001,    0 },		/* D0REGS */   \
    { 0x00000002,    0 },		/* D1REGS */   \
    { 0x00000004,    0 },		/* D2REGS */   \
    { 0x00000008,    0 },		/* D3REGS */   \
    { 0x00000010,    0 },		/* D4REGS */   \
    { 0x00000020,    0 },		/* D5REGS */   \
    { 0x00000040,    0 },		/* D6REGS */   \
    { 0x00000080,    0 },		/* D7REGS */   \
    { 0x000000ff,    0 },		/* DREGS */   \
    { 0x00000100,    0x000 },		/* P0REGS */   \
    { 0x00000800,    0x000 },		/* FDPIC_REGS */   \
    { 0x00000200,    0x000 },		/* FDPIC_FPTR_REGS */   \
    { 0x00004700,    0x800 },		/* PREGS_CLOBBERED */   \
    { 0x0000ff00,    0x800 },		/* PREGS */   \
    { 0x000fff00,    0x800 },		/* IPREGS */	\
    { 0x0000ffff,    0x800 },		/* DPREGS */   \
    { 0xffffffff,    0x800 },		/* MOST_REGS */\
    { 0x00000000,    0x3000 },		/* LT_REGS */\
    { 0x00000000,    0xc000 },		/* LC_REGS */\
    { 0x00000000,    0x30000 },		/* LB_REGS */\
    { 0x00000000,    0x3f7f8 },		/* PROLOGUE_REGS */\
    { 0xffffffff,    0x3fff8 },		/* NON_A_CC_REGS */\
    { 0xffffffff,    0x3ffff }}		/* ALL_REGS */

#define IREG_POSSIBLE_P(OUTER)				     \
  ((OUTER) == POST_INC || (OUTER) == PRE_INC		     \
   || (OUTER) == POST_DEC || (OUTER) == PRE_DEC		     \
   || (OUTER) == MEM || (OUTER) == ADDRESS)

#define MODE_CODE_BASE_REG_CLASS(MODE, OUTER, INDEX)			\
  ((MODE) == HImode && IREG_POSSIBLE_P (OUTER) ? IPREGS : PREGS)

#define INDEX_REG_CLASS         PREGS

#define REGNO_OK_FOR_BASE_STRICT_P(X, MODE, OUTER, INDEX)	\
  (P_REGNO_P (X) || (X) == REG_ARGP				\
   || (IREG_POSSIBLE_P (OUTER) && (MODE) == HImode		\
       && I_REGNO_P (X)))

#define REGNO_OK_FOR_BASE_NONSTRICT_P(X, MODE, OUTER, INDEX)	\
  ((X) >= FIRST_PSEUDO_REGISTER					\
   || REGNO_OK_FOR_BASE_STRICT_P (X, MODE, OUTER, INDEX))

#ifdef REG_OK_STRICT
#define REGNO_MODE_CODE_OK_FOR_BASE_P(X, MODE, OUTER, INDEX) \
  REGNO_OK_FOR_BASE_STRICT_P (X, MODE, OUTER, INDEX)
#else
#define REGNO_MODE_CODE_OK_FOR_BASE_P(X, MODE, OUTER, INDEX) \
  REGNO_OK_FOR_BASE_NONSTRICT_P (X, MODE, OUTER, INDEX)
#endif

#define REGNO_OK_FOR_INDEX_P(X)   0

/* The same information, inverted:
   Return the class number of the smallest class containing
   reg number REGNO.  This could be a conditional expression
   or could index an array.  */

#define REGNO_REG_CLASS(REGNO) \
((REGNO) == REG_R0 ? D0REGS				\
 : (REGNO) == REG_R1 ? D1REGS				\
 : (REGNO) == REG_R2 ? D2REGS				\
 : (REGNO) == REG_R3 ? D3REGS				\
 : (REGNO) == REG_R4 ? D4REGS				\
 : (REGNO) == REG_R5 ? D5REGS				\
 : (REGNO) == REG_R6 ? D6REGS				\
 : (REGNO) == REG_R7 ? D7REGS				\
 : (REGNO) == REG_P0 ? P0REGS				\
 : (REGNO) < REG_I0 ? PREGS				\
 : (REGNO) == REG_ARGP ? PREGS				\
 : (REGNO) >= REG_I0 && (REGNO) <= REG_I3 ? IREGS	\
 : (REGNO) >= REG_L0 && (REGNO) <= REG_L3 ? LREGS	\
 : (REGNO) >= REG_B0 && (REGNO) <= REG_B3 ? BREGS	\
 : (REGNO) >= REG_M0 && (REGNO) <= REG_M3 ? MREGS	\
 : (REGNO) == REG_A0 || (REGNO) == REG_A1 ? AREGS	\
 : (REGNO) == REG_LT0 || (REGNO) == REG_LT1 ? LT_REGS	\
 : (REGNO) == REG_LC0 || (REGNO) == REG_LC1 ? LC_REGS	\
 : (REGNO) == REG_LB0 || (REGNO) == REG_LB1 ? LB_REGS	\
 : (REGNO) == REG_CC ? CCREGS				\
 : (REGNO) >= REG_RETS ? PROLOGUE_REGS			\
 : NO_REGS)

/* When defined, the compiler allows registers explicitly used in the
   rtl to be used as spill registers but prevents the compiler from
   extending the lifetime of these registers. */
#define SMALL_REGISTER_CLASSES 1

#define CLASS_LIKELY_SPILLED_P(CLASS) \
    ((CLASS) == PREGS_CLOBBERED \
     || (CLASS) == PROLOGUE_REGS \
     || (CLASS) == P0REGS \
     || (CLASS) == D0REGS \
     || (CLASS) == D1REGS \
     || (CLASS) == D2REGS \
     || (CLASS) == CCREGS)

/* Do not allow to store a value in REG_CC for any mode */
/* Do not allow to store value in pregs if mode is not SI*/
#define HARD_REGNO_MODE_OK(REGNO, MODE) hard_regno_mode_ok((REGNO), (MODE))

/* Return the maximum number of consecutive registers
   needed to represent mode MODE in a register of class CLASS.  */
#define CLASS_MAX_NREGS(CLASS, MODE)					\
  ((MODE) == V2PDImode && (CLASS) == AREGS ? 2				\
   : ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD))

#define HARD_REGNO_NREGS(REGNO, MODE) \
  ((MODE) == PDImode && ((REGNO) == REG_A0 || (REGNO) == REG_A1) ? 1	\
   : (MODE) == V2PDImode && ((REGNO) == REG_A0 || (REGNO) == REG_A1) ? 2 \
   : CLASS_MAX_NREGS (GENERAL_REGS, MODE))

/* A C expression that is nonzero if hard register TO can be
   considered for use as a rename register for FROM register */
#define HARD_REGNO_RENAME_OK(FROM, TO) bfin_hard_regno_rename_ok (FROM, TO)

/* A C expression that is nonzero if it is desirable to choose
   register allocation so as to avoid move instructions between a
   value of mode MODE1 and a value of mode MODE2.

   If `HARD_REGNO_MODE_OK (R, MODE1)' and `HARD_REGNO_MODE_OK (R,
   MODE2)' are ever different for any R, then `MODES_TIEABLE_P (MODE1,
   MODE2)' must be zero. */
#define MODES_TIEABLE_P(MODE1, MODE2)			\
 ((MODE1) == (MODE2)					\
  || ((GET_MODE_CLASS (MODE1) == MODE_INT		\
       || GET_MODE_CLASS (MODE1) == MODE_FLOAT)		\
      && (GET_MODE_CLASS (MODE2) == MODE_INT		\
	  || GET_MODE_CLASS (MODE2) == MODE_FLOAT)	\
      && (MODE1) != BImode && (MODE2) != BImode		\
      && GET_MODE_SIZE (MODE1) <= UNITS_PER_WORD	\
      && GET_MODE_SIZE (MODE2) <= UNITS_PER_WORD))

/* `PREFERRED_RELOAD_CLASS (X, CLASS)'
   A C expression that places additional restrictions on the register
   class to use when it is necessary to copy value X into a register
   in class CLASS.  The value is a register class; perhaps CLASS, or
   perhaps another, smaller class.  */
#define PREFERRED_RELOAD_CLASS(X, CLASS)		\
  (GET_CODE (X) == POST_INC				\
   || GET_CODE (X) == POST_DEC				\
   || GET_CODE (X) == PRE_DEC ? PREGS : (CLASS))

/* Function Calling Conventions. */

/* The type of the current function; normal functions are of type
   SUBROUTINE.  */
typedef enum {
  SUBROUTINE, INTERRUPT_HANDLER, EXCPT_HANDLER, NMI_HANDLER
} e_funkind;
#define FUNCTION_RETURN_REGISTERS { REG_RETS, REG_RETI, REG_RETX, REG_RETN }

#define FUNCTION_ARG_REGISTERS { REG_R0, REG_R1, REG_R2, -1 }

/* Flags for the call/call_value rtl operations set up by function_arg */
#define CALL_NORMAL		0x00000000	/* no special processing */
#define CALL_LONG		0x00000001	/* always call indirect */
#define CALL_SHORT		0x00000002	/* always call by symbol */

typedef struct {
  int words;			/* # words passed so far */
  int nregs;			/* # registers available for passing */
  int *arg_regs;		/* array of register -1 terminated */
  int call_cookie;		/* Do special things for this call */
} CUMULATIVE_ARGS;

/* Define where to put the arguments to a function.
   Value is zero to push the argument on the stack,
   or a hard register in which to store the argument.

   MODE is the argument's machine mode.
   TYPE is the data type of the argument (as a tree).
    This is null for libcalls where that information may
    not be available.
   CUM is a variable of type CUMULATIVE_ARGS which gives info about
    the preceding args and about the function being called.
   NAMED is nonzero if this argument is a named parameter
    (otherwise it is an extra parameter matching an ellipsis).  */

#define FUNCTION_ARG(CUM, MODE, TYPE, NAMED) \
  (function_arg (&CUM, MODE, TYPE, NAMED))

#define FUNCTION_ARG_REGNO_P(REGNO) function_arg_regno_p (REGNO)


/* Initialize a variable CUM of type CUMULATIVE_ARGS
   for a call to a function whose data type is FNTYPE.
   For a library call, FNTYPE is 0.  */
#define INIT_CUMULATIVE_ARGS(CUM,FNTYPE,LIBNAME,INDIRECT, N_NAMED_ARGS)	\
  (init_cumulative_args (&CUM, FNTYPE, LIBNAME))

/* Update the data in CUM to advance over an argument
   of mode MODE and data type TYPE.
   (TYPE is null for libcalls where that information may not be available.)  */
#define FUNCTION_ARG_ADVANCE(CUM, MODE, TYPE, NAMED)	\
  (function_arg_advance (&CUM, MODE, TYPE, NAMED))

#define RETURN_POPS_ARGS(FDECL, FUNTYPE, STKSIZE) 0

/* Define how to find the value returned by a function.
   VALTYPE is the data type of the value (as a tree).
   If the precise function being called is known, FUNC is its FUNCTION_DECL;
   otherwise, FUNC is 0.
*/

#define VALUE_REGNO(MODE) (REG_R0)

#define FUNCTION_VALUE(VALTYPE, FUNC)		\
  gen_rtx_REG (TYPE_MODE (VALTYPE),		\
	       VALUE_REGNO(TYPE_MODE(VALTYPE)))

/* Define how to find the value returned by a library function
   assuming the value has mode MODE.  */

#define LIBCALL_VALUE(MODE)  gen_rtx_REG (MODE, VALUE_REGNO(MODE))

#define FUNCTION_VALUE_REGNO_P(N) ((N) == REG_R0)

#define DEFAULT_PCC_STRUCT_RETURN 0
#define RETURN_IN_MEMORY(TYPE) bfin_return_in_memory(TYPE)

/* Before the prologue, the return address is in the RETS register.  */
#define INCOMING_RETURN_ADDR_RTX gen_rtx_REG (Pmode, REG_RETS)

#define RETURN_ADDR_RTX(COUNT, FRAME) bfin_return_addr_rtx (COUNT)

#define DWARF_FRAME_RETURN_COLUMN DWARF_FRAME_REGNUM (REG_RETS)

/* Call instructions don't modify the stack pointer on the Blackfin.  */
#define INCOMING_FRAME_SP_OFFSET 0

/* Describe how we implement __builtin_eh_return.  */
#define EH_RETURN_DATA_REGNO(N)	((N) < 2 ? (N) : INVALID_REGNUM)
#define EH_RETURN_STACKADJ_RTX	gen_rtx_REG (Pmode, REG_P2)
#define EH_RETURN_HANDLER_RTX \
    gen_frame_mem (Pmode, plus_constant (frame_pointer_rtx, UNITS_PER_WORD))

/* Addressing Modes */

/* Recognize any constant value that is a valid address.  */
#define CONSTANT_ADDRESS_P(X)	(CONSTANT_P (X))

/* Nonzero if the constant value X is a legitimate general operand.
   symbol_ref are not legitimate and will be put into constant pool.
   See force_const_mem().
   If -mno-pool, all constants are legitimate.
 */
#define LEGITIMATE_CONSTANT_P(X) bfin_legitimate_constant_p (X)

/*   A number, the maximum number of registers that can appear in a
     valid memory address.  Note that it is up to you to specify a
     value equal to the maximum number that `GO_IF_LEGITIMATE_ADDRESS'
     would ever accept. */
#define MAX_REGS_PER_ADDRESS 1

/* GO_IF_LEGITIMATE_ADDRESS recognizes an RTL expression
   that is a valid memory address for an instruction.
   The MODE argument is the machine mode for the MEM expression
   that wants to use this address. 

   Blackfin addressing modes are as follows:

      [preg]
      [preg + imm16]

      B [ Preg + uimm15 ]
      W [ Preg + uimm16m2 ]
      [ Preg + uimm17m4 ] 

      [preg++]
      [preg--]
      [--sp]
*/

#define LEGITIMATE_MODE_FOR_AUTOINC_P(MODE) \
      (GET_MODE_SIZE (MODE) <= 4 || (MODE) == PDImode)

#ifdef REG_OK_STRICT
#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, WIN)		\
  do {							\
    if (bfin_legitimate_address_p (MODE, X, 1))		\
      goto WIN;						\
  } while (0);
#else
#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, WIN)		\
  do {							\
    if (bfin_legitimate_address_p (MODE, X, 0))		\
      goto WIN;						\
  } while (0);
#endif

/* Try machine-dependent ways of modifying an illegitimate address
   to be legitimate.  If we find one, return the new, valid address.
   This macro is used in only one place: `memory_address' in explow.c.

   OLDX is the address as it was before break_out_memory_refs was called.
   In some cases it is useful to look at this to decide what needs to be done.

   MODE and WIN are passed so that this macro can use
   GO_IF_LEGITIMATE_ADDRESS.

   It is always safe for this macro to do nothing.  It exists to recognize
   opportunities to optimize the output.
 */
#define LEGITIMIZE_ADDRESS(X,OLDX,MODE,WIN)    \
do {					       \
   rtx _q = legitimize_address(X, OLDX, MODE); \
   if (_q) { X = _q; goto WIN; }	       \
} while (0)

#define HAVE_POST_INCREMENT 1
#define HAVE_POST_DECREMENT 1

/* `LEGITIMATE_PIC_OPERAND_P (X)'
     A C expression that is nonzero if X is a legitimate immediate
     operand on the target machine when generating position independent
     code.  You can assume that X satisfies `CONSTANT_P', so you need
     not check this.  You can also assume FLAG_PIC is true, so you need
     not check it either.  You need not define this macro if all
     constants (including `SYMBOL_REF') can be immediate operands when
     generating position independent code. */
#define LEGITIMATE_PIC_OPERAND_P(X) ! SYMBOLIC_CONST (X)

#define SYMBOLIC_CONST(X)	\
(GET_CODE (X) == SYMBOL_REF						\
 || GET_CODE (X) == LABEL_REF						\
 || (GET_CODE (X) == CONST && symbolic_reference_mentioned_p (X)))

/*
     A C statement or compound statement with a conditional `goto
     LABEL;' executed if memory address X (an RTX) can have different
     meanings depending on the machine mode of the memory reference it
     is used for or if the address is valid for some modes but not
     others.

     Autoincrement and autodecrement addresses typically have
     mode-dependent effects because the amount of the increment or
     decrement is the size of the operand being addressed.  Some
     machines have other mode-dependent addresses.  Many RISC machines
     have no mode-dependent addresses.

     You may assume that ADDR is a valid address for the machine.
*/
#define GO_IF_MODE_DEPENDENT_ADDRESS(ADDR,LABEL)

#define NOTICE_UPDATE_CC(EXPR, INSN) 0

/* Value is 1 if truncating an integer of INPREC bits to OUTPREC bits
   is done just by pretending it is already truncated.  */
#define TRULY_NOOP_TRUNCATION(OUTPREC, INPREC) 1

/* Max number of bytes we can move from memory to memory
   in one reasonably fast instruction.  */
#define MOVE_MAX UNITS_PER_WORD

/* If a memory-to-memory move would take MOVE_RATIO or more simple
   move-instruction pairs, we will do a movmem or libcall instead.  */

#define MOVE_RATIO 5

/* STORAGE LAYOUT: target machine storage layout
   Define this macro as a C expression which is nonzero if accessing
   less than a word of memory (i.e. a `char' or a `short') is no
   faster than accessing a word of memory, i.e., if such access
   require more than one instruction or if there is no difference in
   cost between byte and (aligned) word loads.

   When this macro is not defined, the compiler will access a field by
   finding the smallest containing object; when it is defined, a
   fullword load will be used if alignment permits.  Unless bytes
   accesses are faster than word accesses, using word accesses is
   preferable since it may eliminate subsequent memory access if
   subsequent accesses occur to other fields in the same word of the
   structure, but to different bytes.  */
#define SLOW_BYTE_ACCESS  0
#define SLOW_SHORT_ACCESS 0

/* Define this if most significant bit is lowest numbered
   in instructions that operate on numbered bit-fields. */
#define BITS_BIG_ENDIAN  0

/* Define this if most significant byte of a word is the lowest numbered.
   We can't access bytes but if we could we would in the Big Endian order. */
#define BYTES_BIG_ENDIAN 0

/* Define this if most significant word of a multiword number is numbered. */
#define WORDS_BIG_ENDIAN 0

/* number of bits in an addressable storage unit */
#define BITS_PER_UNIT 8

/* Width in bits of a "word", which is the contents of a machine register.
   Note that this is not necessarily the width of data type `int';
   if using 16-bit ints on a 68000, this would still be 32.
   But on a machine with 16-bit registers, this would be 16.  */
#define BITS_PER_WORD 32

/* Width of a word, in units (bytes).  */
#define UNITS_PER_WORD 4

/* Width in bits of a pointer.
   See also the macro `Pmode1' defined below.  */
#define POINTER_SIZE 32

/* Allocation boundary (in *bits*) for storing pointers in memory.  */
#define POINTER_BOUNDARY 32

/* Allocation boundary (in *bits*) for storing arguments in argument list.  */
#define PARM_BOUNDARY 32

/* Boundary (in *bits*) on which stack pointer should be aligned.  */
#define STACK_BOUNDARY 32

/* Allocation boundary (in *bits*) for the code of a function.  */
#define FUNCTION_BOUNDARY 32

/* Alignment of field after `int : 0' in a structure.  */
#define EMPTY_FIELD_BOUNDARY BITS_PER_WORD

/* No data type wants to be aligned rounder than this.  */
#define BIGGEST_ALIGNMENT 32

/* Define this if move instructions will actually fail to work
   when given unaligned data.  */
#define STRICT_ALIGNMENT 1

/* (shell-command "rm c-decl.o stor-layout.o")
 *  never define PCC_BITFIELD_TYPE_MATTERS
 *  really cause some alignment problem
 */

#define UNITS_PER_FLOAT  ((FLOAT_TYPE_SIZE  + BITS_PER_UNIT - 1) / \
			   BITS_PER_UNIT)

#define UNITS_PER_DOUBLE ((DOUBLE_TYPE_SIZE + BITS_PER_UNIT - 1) / \
 			   BITS_PER_UNIT)


/* what is the 'type' of size_t */
#define SIZE_TYPE "long unsigned int"

/* Define this as 1 if `char' should by default be signed; else as 0.  */
#define DEFAULT_SIGNED_CHAR 1
#define FLOAT_TYPE_SIZE BITS_PER_WORD
#define SHORT_TYPE_SIZE 16 
#define CHAR_TYPE_SIZE	8
#define INT_TYPE_SIZE	32
#define LONG_TYPE_SIZE	32
#define LONG_LONG_TYPE_SIZE 64 

/* Note: Fix this to depend on target switch. -- lev */

/* Note: Try to implement double and force long double. -- tonyko
 * #define __DOUBLES_ARE_FLOATS__
 * #define DOUBLE_TYPE_SIZE FLOAT_TYPE_SIZE
 * #define LONG_DOUBLE_TYPE_SIZE DOUBLE_TYPE_SIZE
 * #define DOUBLES_ARE_FLOATS 1
 */

#define DOUBLE_TYPE_SIZE	64
#define LONG_DOUBLE_TYPE_SIZE	64

/* `PROMOTE_MODE (M, UNSIGNEDP, TYPE)'
     A macro to update M and UNSIGNEDP when an object whose type is
     TYPE and which has the specified mode and signedness is to be
     stored in a register.  This macro is only called when TYPE is a
     scalar type.

     On most RISC machines, which only have operations that operate on
     a full register, define this macro to set M to `word_mode' if M is
     an integer mode narrower than `BITS_PER_WORD'.  In most cases,
     only integer modes should be widened because wider-precision
     floating-point operations are usually more expensive than their
     narrower counterparts.

     For most machines, the macro definition does not change UNSIGNEDP.
     However, some machines, have instructions that preferentially
     handle either signed or unsigned quantities of certain modes.  For
     example, on the DEC Alpha, 32-bit loads from memory and 32-bit add
     instructions sign-extend the result to 64 bits.  On such machines,
     set UNSIGNEDP according to which kind of extension is more
     efficient.

     Do not define this macro if it would never modify M.*/

#define BFIN_PROMOTE_MODE_P(MODE) \
    (!TARGET_DSP && GET_MODE_CLASS (MODE) == MODE_INT	\
      && GET_MODE_SIZE (MODE) < UNITS_PER_WORD)

#define PROMOTE_MODE(MODE, UNSIGNEDP, TYPE)     \
  if (BFIN_PROMOTE_MODE_P(MODE))		\
    {                                           \
      if (MODE == QImode)                       \
        UNSIGNEDP = 1;                          \
      else if (MODE == HImode)                  \
        UNSIGNEDP = 0;      			\
      (MODE) = SImode;                          \
    }

/* Describing Relative Costs of Operations */

/* Do not put function addr into constant pool */
#define NO_FUNCTION_CSE 1

/* A C expression for the cost of moving data from a register in class FROM to
   one in class TO.  The classes are expressed using the enumeration values
   such as `GENERAL_REGS'.  A value of 2 is the default; other values are
   interpreted relative to that.

   It is not required that the cost always equal 2 when FROM is the same as TO;
   on some machines it is expensive to move between registers if they are not
   general registers.  */

#define REGISTER_MOVE_COST(MODE, CLASS1, CLASS2) \
   bfin_register_move_cost ((MODE), (CLASS1), (CLASS2))

/* A C expression for the cost of moving data of mode M between a
   register and memory.  A value of 2 is the default; this cost is
   relative to those in `REGISTER_MOVE_COST'.

   If moving between registers and memory is more expensive than
   between two registers, you should define this macro to express the
   relative cost.  */

#define MEMORY_MOVE_COST(MODE, CLASS, IN)	\
  bfin_memory_move_cost ((MODE), (CLASS), (IN))

/* Specify the machine mode that this machine uses
   for the index in the tablejump instruction.  */
#define CASE_VECTOR_MODE SImode

#define JUMP_TABLES_IN_TEXT_SECTION flag_pic

/* Define if operations between registers always perform the operation
   on the full register even if a narrower mode is specified. 
#define WORD_REGISTER_OPERATIONS
*/

/* Evaluates to true if A and B are mac flags that can be used
   together in a single multiply insn.  That is the case if they are
   both the same flag not involving M, or if one is a combination of
   the other with M.  */
#define MACFLAGS_MATCH_P(A, B) \
 ((A) == (B) \
  || ((A) == MACFLAG_NONE && (B) == MACFLAG_M) \
  || ((A) == MACFLAG_M && (B) == MACFLAG_NONE) \
  || ((A) == MACFLAG_IS && (B) == MACFLAG_IS_M) \
  || ((A) == MACFLAG_IS_M && (B) == MACFLAG_IS))

/* Switch into a generic section.  */
#define TARGET_ASM_NAMED_SECTION  default_elf_asm_named_section

#define PRINT_OPERAND(FILE, RTX, CODE)	 print_operand (FILE, RTX, CODE)
#define PRINT_OPERAND_ADDRESS(FILE, RTX) print_address_operand (FILE, RTX)

typedef enum sections {
    CODE_DIR,
    DATA_DIR,
    LAST_SECT_NM
} SECT_ENUM_T;

typedef enum directives {
    LONG_CONST_DIR,
    SHORT_CONST_DIR,
    BYTE_CONST_DIR,
    SPACE_DIR,
    INIT_DIR,
    LAST_DIR_NM
} DIR_ENUM_T;

#define IS_ASM_LOGICAL_LINE_SEPARATOR(C, STR)	\
  ((C) == ';'					\
   || ((C) == '|' && (STR)[1] == '|'))

#define TEXT_SECTION_ASM_OP ".text;"
#define DATA_SECTION_ASM_OP ".data;"

#define ASM_APP_ON  ""
#define ASM_APP_OFF ""

#define ASM_GLOBALIZE_LABEL1(FILE, NAME) \
  do {  fputs (".global ", FILE);		\
        assemble_name (FILE, NAME);	        \
        fputc (';',FILE);			\
        fputc ('\n',FILE);			\
      } while (0)

#define ASM_DECLARE_FUNCTION_NAME(FILE,NAME,DECL) \
  do {					\
    fputs (".type ", FILE);           	\
    assemble_name (FILE, NAME);         \
    fputs (", STT_FUNC", FILE);         \
    fputc (';',FILE);                   \
    fputc ('\n',FILE);			\
    ASM_OUTPUT_LABEL(FILE, NAME);	\
  } while (0)

#define ASM_OUTPUT_LABEL(FILE, NAME)    \
  do {  assemble_name (FILE, NAME);		\
        fputs (":\n",FILE);			\
      } while (0)

#define ASM_OUTPUT_LABELREF(FILE,NAME) 	\
    do {  fprintf (FILE, "_%s", NAME); \
        } while (0)

#define ASM_OUTPUT_ADDR_VEC_ELT(FILE, VALUE)    	\
do { char __buf[256];					\
     fprintf (FILE, "\t.dd\t");				\
     ASM_GENERATE_INTERNAL_LABEL (__buf, "L", VALUE);	\
     assemble_name (FILE, __buf);			\
     fputc (';', FILE);					\
     fputc ('\n', FILE);				\
   } while (0)

#define ASM_OUTPUT_ADDR_DIFF_ELT(FILE, BODY, VALUE, REL) \
    MY_ASM_OUTPUT_ADDR_DIFF_ELT(FILE, VALUE, REL)

#define MY_ASM_OUTPUT_ADDR_DIFF_ELT(FILE, VALUE, REL)		\
    do {							\
	char __buf[256];					\
	fprintf (FILE, "\t.dd\t");				\
	ASM_GENERATE_INTERNAL_LABEL (__buf, "L", VALUE);	\
	assemble_name (FILE, __buf);				\
	fputs (" - ", FILE);					\
	ASM_GENERATE_INTERNAL_LABEL (__buf, "L", REL);		\
	assemble_name (FILE, __buf);				\
	fputc (';', FILE);					\
	fputc ('\n', FILE);					\
    } while (0)

#define ASM_OUTPUT_ALIGN(FILE,LOG) 				\
    do {							\
      if ((LOG) != 0)						\
	fprintf (FILE, "\t.align %d\n", 1 << (LOG));		\
    } while (0)

#define ASM_OUTPUT_SKIP(FILE,SIZE)		\
    do {					\
	asm_output_skip (FILE, SIZE);		\
    } while (0)

#define ASM_OUTPUT_LOCAL(FILE, NAME, SIZE, ROUNDED) 	\
do { 						\
    switch_to_section (data_section);				\
    if ((SIZE) >= (unsigned int) 4 ) ASM_OUTPUT_ALIGN(FILE,2);	\
    ASM_OUTPUT_SIZE_DIRECTIVE (FILE, NAME, SIZE);		\
    ASM_OUTPUT_LABEL (FILE, NAME);				\
    fprintf (FILE, "%s %ld;\n", ASM_SPACE,			\
	     (ROUNDED) > (unsigned int) 1 ? (ROUNDED) : 1);	\
} while (0)

#define ASM_OUTPUT_COMMON(FILE, NAME, SIZE, ROUNDED)	\
     do {						\
	ASM_GLOBALIZE_LABEL1(FILE,NAME); 		\
        ASM_OUTPUT_LOCAL (FILE, NAME, SIZE, ROUNDED); } while(0)

#define ASM_COMMENT_START "//"

#define PROFILE_BEFORE_PROLOGUE
#define FUNCTION_PROFILER(FILE, LABELNO)	\
  do {						\
    fprintf (FILE, "\t[--SP] = RETS;\n");	\
    if (TARGET_LONG_CALLS)			\
      {						\
	fprintf (FILE, "\tP2.h = __mcount;\n");	\
	fprintf (FILE, "\tP2.l = __mcount;\n");	\
	fprintf (FILE, "\tCALL (P2);\n");	\
      }						\
    else					\
      fprintf (FILE, "\tCALL __mcount;\n");	\
    fprintf (FILE, "\tRETS = [SP++];\n");	\
  } while(0)

#undef NO_PROFILE_COUNTERS
#define NO_PROFILE_COUNTERS 1

#define ASM_OUTPUT_REG_PUSH(FILE, REGNO) fprintf (FILE, "\t[--SP] = %s;\n", reg_names[REGNO])
#define ASM_OUTPUT_REG_POP(FILE, REGNO)  fprintf (FILE, "\t%s = [SP++];\n", reg_names[REGNO])

extern struct rtx_def *bfin_compare_op0, *bfin_compare_op1;
extern struct rtx_def *bfin_cc_rtx, *bfin_rets_rtx;

/* This works for GAS and some other assemblers.  */
#define SET_ASM_OP              ".set "

/* DBX register number for a given compiler register number */
#define DBX_REGISTER_NUMBER(REGNO)  (REGNO) 

#define SIZE_ASM_OP     "\t.size\t"

extern int splitting_for_sched, splitting_loops;

#define PRINT_OPERAND_PUNCT_VALID_P(CHAR) ((CHAR) == '!')

#ifndef TARGET_SUPPORTS_SYNC_CALLS
#define TARGET_SUPPORTS_SYNC_CALLS 0
#endif

/* To clear the instruction cache when a trampoline is initialized, define the following macro. 
   CLEAR_INSN_CACHE (beg, end)

   If defined, expands to a C expression clearing the instruction
   cache in the specified interval. The definition of this macro would
   typically be a series of asm statements. Both beg and end are both
   pointer expressions. */

#endif /*  _BFIN_CONFIG */
