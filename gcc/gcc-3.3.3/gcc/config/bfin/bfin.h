/*
 * Copyright (c) 2000, 2001 Analog Devices Inc.,
 * Copyright (c) 2000, 2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001, 2002 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Ported for Blackfin/Frio Architecture by Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *                                          Tony Kou <tony.ko@arcturusnetworks.com>
 *                                          Faisal Akber <fakber@arcturusnetworks.com>
 */


#ifndef _BFIN_CONFIG
#define _BFIN_CONFIG

/* In order to use atof */
#include <stdlib.h>

#define USER_LABEL_PREFIX "_"

#define LOCAL_LABEL_PREFIX "L$"

#define OBJECT_FORMAT_ELF

#define BRT 1
#define BRF 0

/* Names to predefine in the preprocessor for this target machine.  */
#define BFIN 1
#define ADI_BFIN 1

/* Print subsidiary information on the compiler version in use.  */
#define TARGET_VERSION fprintf (stderr, " (BlackFin bfin)")

/* The TOOL_CHAIN can be ADE or VDSP. 
 * Assembler and Linker options depend on the tool chain
*/
#define ADE

#ifdef REG_OK_STRICT
# define STRICTNESS 1
#else
# define STRICTNESS 0
#endif

#define CONST_16BIT_IMM_P(VALUE) ((int)(VALUE) >= -32768 && (int)(VALUE) <= 32767)
#define CONST_7BIT_IMM_P(VALUE) ((int)(VALUE) >= -64 && (int)(VALUE) <= 63)
#define CONST_3BIT_IMM_P(VALUE) ((int)(VALUE) >= -4 && (int)(VALUE) <= 3)
#define CONST_3UBIT_IMM_P(VALUE) (/* RAJA : why unsigned (unsigned) (VALUE) >= 0 && */(unsigned) (VALUE) <= 7U)
#define CONST_4BIT_IMM_P(VALUE) ((int)(VALUE) >= -8 && (int)(VALUE) <= 7)
#define CONST_4UBIT_IMM_P(VALUE) (/* RAJA : why typecast to unsigned (unsigned)(VALUE) >= 0 && */(unsigned)(VALUE) <= 15U)
#define CONST_5UBIT_IMM_P(VALUE) (/* RAJA : why typecast to unsigned (unsigned)(VALUE) >= 0 && */(unsigned)(VALUE) < 32U)

/*
  The following set of defines, describe the commandline api.
*/
#define MASK_OMIT_LEAF_FRAME_POINTER 0x00000800 /* omit leaf frame pointers */
#define MASK_REG_ARGS                0x00001000 /* pass arguments in registers */
#define MASK_DEBUG_ARGS              0x00002000 /* debug argument passing */
/*#define MASK_OPT_PROLOGUE          0x00010000*/
#define MASK_SIMPLE_RTM              0x00020000
#define MASK_LOW_64K           	     0x00040000
#define MASK_NEW_PROLOGUE            0x00080000
#define MASK_ASM_DIR                 0x00100000 /* use alternative assembly ectives */
#define MASK_CMOV	             0x00200000 /* use conditional moves */
#define MASK_MINI_CONST_POOL	             0x00400000 /* one const pool per function */
#define MASK_UNIT_CONST_POOL         0x00800000 /* one const pool per 
						 * compilation unit */
#define MASK_PROFILE		     0x01000000 /* Instrument for NON GNU
						 * profiling */
#define MASK_NO_UNDERSCORE	     0x02000000 /* lacal label without underscore */

/* Run-time compilation parameters selecting different hardware subsets.  */

extern int target_flags;

/* Predefinition in the preprocessor for this target machine */
#ifndef CPP_PREDEFINES
#define CPP_PREDEFINES " -Dbfin -DBFIN -DFRIO -Dfrio"
#endif
#define CC1_SPEC  " -O2 "
#define ASM_SPEC " %{I*} -I include/asm%s "
#define LIB_SPEC " -lc "

/* Don't create frame pointers for leaf functions */
#define TARGET_OMIT_LEAF_FRAME_POINTER (target_flags & MASK_OMIT_LEAF_FRAME_POINTER)
#define TARGET_REGPARM                 (target_flags & MASK_REG_ARGS) /* never use */
#define TARGET_DEBUG_ARG	       (target_flags & MASK_DEBUG_ARGS)
#define TARGET_OPT_PROLOGUE            (target_flags & MASK_OPT_PROLOGUE)
#define TARGET_SIMPLE_RTM              (target_flags & MASK_SIMPLE_RTM)
#define TARGET_LOW_64K                 (target_flags & MASK_LOW_64K)
#define TARGET_NEW_PROLOGUE            (target_flags & MASK_NEW_PROLOGUE)
#define TARGET_ASM_DIR		       (target_flags & MASK_ASM_DIR)
#define TARGET_NO_UNDERSCORE	       (target_flags & MASK_NO_UNDERSCORE)

#define TARGET_HAS_SYMBOLIC_ADDRESSES  (0)
#define TARGET_MOVE                    (1)
/* Generate DSP instructions, like DSP halfword loads */
#define TARGET_DSP			(1)
/* #define TARGET_MOVSICC		(target_flags & MASK_CMOV) */
#define TARGET_MOVSICC			(1)
#define TARGET_MINI_CONST_POOL		(target_flags & MASK_MINI_CONST_POOL)
#define TARGET_UNIT_CONST_POOL		(target_flags & MASK_UNIT_CONST_POOL)
#define TARGET_CONST_POOL		(TARGET_MINI_CONST_POOL 	\
					|| TARGET_UNIT_CONST_POOL)
/* Non-gprof profiler	*/
#define TARGET_NON_GNU_PROFILE		(target_flags & MASK_PROFILE)

#define TARGET_SWITCHES  {\
  { "omit-leaf-frame-pointer",	  MASK_OMIT_LEAF_FRAME_POINTER,		\
    "Omit Frame Pointer for leaf functions" }, 				\
  { "no-omit-leaf-frame-pointer",-MASK_OMIT_LEAF_FRAME_POINTER,		\
    "Use Frame Pointer for leaf functions"},       			\
  { "reg-args",			  MASK_REG_ARGS,			\
    "Arguments are passed in registers (default)" }, 			\
  { "no-reg-args",		 -MASK_REG_ARGS,			\
    "Arguments are passed on stack" }, 			      		\
  { "debug-reg-args",		  MASK_DEBUG_ARGS,                      \
    "Debug info for register arguments" }, 				\
  { "no-debug-reg-args",	 -MASK_DEBUG_ARGS,			\
    "No debug info for register arguments" }, 		      		\
  { "nprologue",	          MASK_NEW_PROLOGUE,			\
    "Prologue with LINK/UNLNK and PUSHM/POPM" },			\
  { "no-nprologue",	         -MASK_NEW_PROLOGUE ,			\
    "Prologue with individual PUSH/POP"},				\
  { "simple-rtm",	          MASK_SIMPLE_RTM,			\
    "Use a subset of C run-time library" },				\
  { "no-simple-rtm",	         -MASK_SIMPLE_RTM,			\
    "Use full C run-time library" },					\
  { "low64k",	                  MASK_LOW_64K,				\
    "Program is located in low 64K of memory" },			\
  { "no-low64k",	         -MASK_LOW_64K,				\
    "Program is not located in low 64K of memory (default)"},		\
  { "asm-dir",		         MASK_ASM_DIR,				\
    "Alternative style of assembly directives"},			\
  { "no-asm-dir",		-MASK_ASM_DIR,				\
    "Alternative style of assembly directives"},			\
  { "cmov",		         MASK_CMOV,				\
    "Use conditional moves"},						\
  { "no-cmov",			-MASK_CMOV,				\
    "Do not generate conditional moves"},				\
  { "pool",		         MASK_MINI_CONST_POOL,			\
    "Use one constant pool per function"},				\
  { "no-pool",			-MASK_MINI_CONST_POOL,			\
    "Do not use function constant pools"},				\
  { "mini-pool",	         MASK_MINI_CONST_POOL,			\
    "Use one constant pool per function"},				\
  { "no-mini-pool",		-MASK_MINI_CONST_POOL,			\
    "Do not use function constant pools"},				\
  { "unit-pool",		 MASK_UNIT_CONST_POOL,			\
    "Use one constant pool per compilation unit"},			\
  { "no-unit-pool",		-MASK_UNIT_CONST_POOL,			\
    "Do not use compilation unit constant pools"},			\
  { "profile",		         MASK_PROFILE,				\
    "Non GNU Profiling"},						\
  { "no-profile",		-MASK_PROFILE,				\
    "NO Non GNU profiling"},						\
  { "no-underscore",		MASK_NO_UNDERSCORE,			\
    "No underscore fro local label definition"},			\
  { "", MASK_REG_ARGS | MASK_NEW_PROLOGUE  | MASK_CMOV,			\
    "default: reg-args, new-prologue"}}

/* Sometimes certain combinations of command options do not make
   sense on a particular target machine.  You can define a macro
   `OVERRIDE_OPTIONS' to take account of this.  This macro, if
   defined, is executed once just after all the command options have
   been parsed.
 
   Don't use this macro to turn on various extra optimizations for
   `-O'.  That is what `OPTIMIZATION_OPTIONS' is for.  */
 
#define OVERRIDE_OPTIONS override_options ()
#if 0
#define OPTIMIZATION_OPTIONS(optimize,space) (optimize=2)
#endif

typedef struct snm {
	const char *dir_name;
	const char *sect_name;
} SECT_NM_T;
extern SECT_NM_T section_names[];

extern const char * directive_names[];

#define TARGET_OPTIONS {\
	{ "text=", (const char **)&section_names[CODE_DIR].sect_name, 	\
	  "Name of text section" },			\
	{ "data=", (const char **)&section_names[DATA_DIR].sect_name,	\
	  "Name of data section"} }

#define FUNCTION_MODE    SImode
#define Pmode            SImode
/* store-condition-codes instructions store 0 for false
   This is the value stored for true.  */
#define STORE_FLAG_VALUE 1

/* Define this if pushing a word on the stack
   makes the stack pointer a smaller address.  */
#define STACK_GROWS_DOWNWARD

#define STACK_PUSH_CODE PRE_DEC

/* Define this macro if successive arguments to a function occupy
   decreasing addresses on the stack. 
#define ARGS_GROW_DOWNWARD
*/

/* Define this if the nominal address of the stack frame
   is at the high-address end of the local variables;
   that is, each additional local variable allocated
   goes at a more negative offset in the frame.  */
#define FRAME_GROWS_DOWNWARD

/* Activation Record Stack/Frame.. */
#define FIRST_PARM_OFFSET(decl) (FRAME_POINTER_REQUIRED ? 8 : 0)

#define STARTING_FRAME_OFFSET   0 /*offset to first local*/


/*
     Define this macro if an argument declared in a prototype as an
     integral type smaller than `int' should actually be passed as an
     `int'.  In addition to avoiding errors in certain cases of
     mismatch, it also makes for better code on certain machines.   */
#define PROMOTE_PROTOTYPES 1


/* Register to use for pushing function arguments.  */
#define STACK_POINTER_REGNUM REG_P6

/* Base register for access to local variables of the function.  */
#define FRAME_POINTER_REGNUM REG_P7

#define ARG_POINTER_REGNUM      FRAME_POINTER_REGNUM

/* `PIC_OFFSET_TABLE_REGNUM'
     The register number of the register used to address a table of
     static data addresses in memory.  In some cases this register is
     defined by a processor's "application binary interface" (ABI).
     When this macro is defined, RTL is generated for this register
     once, as with the stack pointer and frame pointer registers.  If
     this macro is not defined, it is up to the machine-dependent files
     to allocate such a register (if necessary). */
#define PIC_OFFSET_TABLE_REGNUM (REG_P5)

/* SFA - STATIC_CHAIN for trampolines .... */
#define STATIC_CHAIN_REGNUM REG_P4

/* Define this if functions should assume that stack space has been
 * allocated for arguments even when their values are passed in
 * registers.
 *
 * The value of this macro is the size, in bytes, of the area reserved for
 * arguments passed in registers.
 *
 * This space can either be allocated by the caller or be a part of the
 * machine-dependent stack frame: `OUTGOING_REG_PARM_STACK_SPACE'
 * says which.  */
#define FIXED_STACK_AREA 12
#define REG_PARM_STACK_SPACE(FNDECL, LIBCALL) ((LIBCALL) ? 0 : FIXED_STACK_AREA)

/* Define this if the above stack space is to be considered part of the
 * space allocated by the caller.  */
#define OUTGOING_REG_PARM_STACK_SPACE
	  
 /*If we generate an insn to push BYTES bytes, this says how many the
   stack pointer really advances by.  On Hummingbird pushw decrements
   by exactly 2 no matter what the position was.   
#define PUSH_ROUNDING(BYTES) (((BYTES) + 3) & (~3))*/

/* Define this if the maximum size of all the outgoing args is to be
 *    accumulated and pushed during the prologue.  The amount can be
 *       found in the variable current_function_outgoing_args_size. */ 
#define ACCUMULATE_OUTGOING_ARGS 1

/* Value should be nonzero if functions must have frame pointers.
   Zero means the frame pointer need not be set up (and parms
   may be accessed via the stack pointer) in functions that seem suitable.
   This is computed in `reload', in reload1.c.  
*/
#define FRAME_POINTER_REQUIRED (frame_pointer_required ())

/* `INITIAL_FRAME_POINTER_OFFSET (DEPTH-VAR)'
     A C statement to store in the variable DEPTH-VAR the difference
     between the frame pointer and the stack pointer values immediately
     after the function prologue.  The value would be computed from
     information such as the result of `get_frame_size ()' and the
     tables of registers `regs_ever_live' and `call_used_regs'.

     If `ELIMINABLE_REGS' is defined, this macro will be not be used and
     need not be defined.  Otherwise, it must be defined even if
     `FRAME_POINTER_REQUIRED' is defined to always be true; in that
     case, you may set DEPTH-VAR to anything.
*/
#define INITIAL_FRAME_POINTER_OFFSET(DEPTH) { (DEPTH) = 	\
    FRAME_POINTER_REQUIRED ? 0 : get_frame_size (); }

#define PARM_BOUNDRY            32

#define STACK_BOUNDRY           32

/*#define DATA_ALIGNMENT(TYPE, BASIC-ALIGN) for arrays.. */

#define STRUCTURE_SIZE_BOUNDARY	32 /*RAJA biggest_alignment old - 8*/

/* Make strings word-aligned so strcpy from constants will be faster.  */
#define CONSTANT_ALIGNMENT(EXP, ALIGN)  \
  (TREE_CODE (EXP) == STRING_CST        \
   && (ALIGN) < BITS_PER_WORD ? BITS_PER_WORD : (ALIGN))    

/* Register in which address to store a structure value
   is passed to a function.  */
#define STRUCT_VALUE_REGNUM REG_P0
#define DEFAULT_PCC_STRUCT_RETURN 0
#define RETURN_IN_MEMORY(TYPE) bfin_return_in_memory(TYPE)

/*vararg implementation */

#define SETUP_INCOMING_VARARGS(CUM,MODE,TYPE,PRETEND_SIZE,NO_RTL) \
  setup_incoming_varargs (&CUM, MODE, TYPE, &PRETEND_SIZE, NO_RTL)


#define TRAMPOLINE_SIZE 18
#define TRAMPOLINE_TEMPLATE(FILE)                                       \
      fprintf(FILE, "\t.word\t0xe10c0000\n\t\t# p3.l = fn low");        \
      fprintf(FILE, "\n\t.word\t0xe12c0000\n\t\t# p3.h = fn high");     \
      fprintf(FILE, "\n\t.word\t0xe10d0000\n\t\t# p4.l = sc low");      \
      fprintf(FILE, "\n\t.word\t0xe12d0000\n\t\t# p4.h = sc high");     \
      fprintf(FILE, "\n\t.word\t0x0083\n\t\t# jump (p3)");

#define INITIALIZE_TRAMPOLINE(TRAMP, FNADDR, CXT)  \
{                                                                       \
  emit_move_insn (gen_rtx_MEM (HImode, plus_constant ((TRAMP),  2)),    \
                  GEN_INT ((((int) FNADDR) & 0x0000ffff)));             \
  emit_move_insn (gen_rtx_MEM (HImode, plus_constant ((TRAMP),  6)),    \
                  GEN_INT (((((int) FNADDR) & 0xffff0000) >> 16)));     \
  emit_move_insn (gen_rtx_MEM (HImode, plus_constant ((TRAMP), 10)),    \
                  GEN_INT ((((int) CXT) & 0x0000ffff)));                \
  emit_move_insn (gen_rtx_MEM (HImode, plus_constant ((TRAMP), 14)),    \
                  GEN_INT (((((int) (CXT)) & 0xffff0000) >> 16)));      \
}

/* Number of actual hardware registers.
   The hardware registers are assigned numbers for the compiler
   from 0 to just below FIRST_PSEUDO_REGISTER.
   All registers that the compiler knows about must be given numbers,
   even those that are not normally considered general registers.

   This processor has
       8 data register for doing arithmetic
       8  pointer register for doing addressing
          including 1  stack pointer P6
                    1  frame pointer P7
       4 sets of indexing registers (I0-3, B0-3, L0-3, M0-3
       1  condition code flag register CC
*/

/* Register Enumerarion */
#define REG_R0 0
#define REG_R1 1
#define REG_R2 2
#define REG_R3 3
#define REG_R4 4
#define REG_R5 5
#define REG_R6 6
#define REG_R7 7

#define REG_P0 8
#define REG_P1 9
#define REG_P2 10
#define REG_P3 11
#define REG_P4 12
#define REG_P5 13
#define REG_P6 14
#define REG_P7 15

#define REG_I0 16
#define REG_B0 17
#define REG_L0 18
#define REG_I1 19
#define REG_B1 20
#define REG_L1 21
#define REG_I2 22
#define REG_B2 23
#define REG_L2 24
#define REG_I3 25
#define REG_B3 26
#define REG_L3 27

#define REG_M0 28
#define REG_M1 29
#define REG_M2 30
#define REG_M3 31

#define REG_A0 32
#define REG_A1 33

#define REG_CC 34


#define FIRST_PSEUDO_REGISTER 35

#define LAST_USER_DREG REG_R7
#define LAST_USER_PREG REG_P5

#define REGISTER_NAMES { \
  "R0",      "R1",      "R2",      "R3",      "R4",      "R5",      "R6",      "R7",  \
  "P0",      "P1",      "P2",      "P3",      "P4",      "P5",      "SP",      "FP",  \
  "I0",      "B0",      "L0",      "I1",      "B1",      "L1",      "I2",      "B2",  \
  "L2",      "I3",      "B3",      "L3",      "M0",      "M1",      "M2",      "M3",  \
  "A0",      "A1",      "CC", \
}



#define SHORT_REGISTER_NAMES { \
	"R0.L",	"R1.L",	"R2.L",	"R3.L", "R4.L", "R5.L", "R6.L", "R7.L", \
	"P0.L",	"P1.L",	"P2.L",	"P3.L", "P4.L", "P5.L", "SP.L", "FP.L", \
	"I0.L",	"B0.L", "L0.L",	"I1.L",	"B1.L",	"L1.L",	"I2.L",	"B2.L", \
	"L2.L",	"I3.L",	"B3.L",	"L3.L",	"M0.L",	"M1.L",	"M2.L",	"M3.L", }


#define HIGH_REGISTER_NAMES { \
	"R0.H",	"R1.H",	"R2.H",	"R3.H", "R4.H", "R5.H", "R6.H", "R7.H", \
	"P0.H",	"P1.H",	"P2.H",	"P3.H", "P4.H", "P5.H", "SP.H", "FP.H", \
	"I0.H",	"B0.H",	"L0.H",	"I1.H",	"B1.H",	"L1.H",	"I2.H",	"B2.H", \
	"L2.H",	"I3.H",	"B3.H",	"L3.H",	"M0.H",	"M1.H",	"M2.H",	"M3.H", }

#define DREGS_PAIR_NAMES { \
  "R1:0.p",0,     "R3:2.p",0,     "R5:4.p",0,    "R7:6.p",0,  }

#define BYTE_REGISTER_NAMES { \
  "R0.B",     "R1.B",     "R2.B",    "R3.B",     "R4.B",     "R5.B",     "R6.B",     "R7.B",  }


/* The Nth number is 1 if register N is fixed i.e. has a 
   fixed predefined use and cannot be touched by gcc for
   general purpose, 0 otherwise
*/
#define FIXED_REGISTERS \
/*r0 r1 r2 r3 r4 r5 r6 r7   p0 p1 p2 p3 p4 p5 p6 p7 */ \
{ 0, 0, 0, 1, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 1, 1,    \
/*i0 b0 l0 i1 b1 l1 i2 b2   l2 i3 b3 l3 m0 m1 m2 m3 */ \
  0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 1,    \
/*a0 a1 cc */ \
  0, 0, 1,   \
}

/* the registers that are not available for general 
   allocation of values that must live across 
   function calls.
   If a register has 0 in `CALL_USED_REGISTERS', the compiler
   automatically saves it on function entry and restores it on
   function exit, if the register is used within the function.

   Refer page ,VDSP++ 3.5 C/C++ compiler Manual
*/
#define CALL_USED_REGISTERS \
/*r0 r1 r2 r3 r4 r5 r6 r7   p0 p1 p2 p3 p4 p5 p6 p7 */ \
{ 1, 1, 1, 1, 0, 0, 0, 0,   1, 1, 1, 0, 0, 0, 1, 1, \
/*i0 b0 l0 i1 b1 l1 i2 b2   l2 i3 b3 l3 m0 m1 m2 m3 */ \
  1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,   \
/*a0 a1 cc */ \
  1, 1, 1, \
}


/* Order in which to allocate registers.  Each register must be
   listed once, even those in FIXED_REGISTERS.  List frame pointer
   late and fixed registers last.  Note that, in general, we prefer
   registers listed in CALL_USED_REGISTERS, keeping the others
   available for storage of persistent values. */
#define REG_NO FIRST_PSEUDO_REGISTER

#define REG_ALLOC_ORDER \
{ REG_R0, REG_R1, REG_R2, REG_R3, REG_R7, REG_R6, REG_R5, REG_R4, \
  REG_P2, REG_P1, REG_P0, REG_P5, REG_P4, REG_P3, REG_P6, REG_P7, \
  REG_A0, REG_A1, \
  REG_I0, REG_B0, REG_L0, REG_I1, REG_B1, REG_L1, REG_I2, REG_B2, \
  REG_L2, REG_I3, REG_B3, REG_L3, REG_M0, REG_M1, REG_M2, REG_M3, \
       REG_NO, \
}

#define CONDITIONAL_REGISTER_USAGE			\
  {							\
    conditional_register_usage();                       \
    if (flag_pic)					\
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
  DREGS,
  DREGS_PAIR,
  PREGS,
  DPREGS,
  IREGS,
  BREGS,
  LREGS,
  CIRCREGS, /* Circular buffering registers, Ix, Bx, Lx together form. See Automatic Circlur Buffering */
  MREGS,
  DAGREGS,
  AREGS,
  CCREGS,
  GENERAL_REGS,
  ALL_REGS, LIM_REG_CLASSES
};
#define N_REG_CLASSES ((int)LIM_REG_CLASSES)

/* Give names of register classes as strings for dump file.   */

#define REG_CLASS_NAMES \
{  "NO_REGS",		\
   "DREGS",		\
   "DREGS_PAIR",	\
   "PREGS",		\
   "DPREGS",		\
   "IREGS",		\
   "BREGS",		\
   "LREGS",		\
   "CIRCREGS",		\
   "MREGS",		\
   "DAGREGS",		\
   "AREGS",		\
   "CCREGS",		\
   "GENERAL_REGS",	\
   "ALL_REGS" }


/* Define which registers fit in which classes.
   This is an initializer for a vector of HARD_REG_SET
   of length N_REG_CLASSES.  
   The way the integer MASK is interpreted is 
   that register R is in the class if `MASK & (1 << R)' is 1
   where R is the define in register enumeration such as REG_I0 */
/* Since we have more than 32 registers a longer version is used below */
/* NOTE: DSP registers, IREGS - AREGS, are not GENERAL_REGS */

#define REG_CLASS_CONTENTS \
    /* 31 - 0       63-32   */ \
{    0x00000000,    0,		/* NO_REGS */ \
     0x000000ff,    0,		/* DREGS */   \
     0x00000055,    0,		/* DREGS_PAIR */   \
     0x0000ff00,    0,		/* PREGS */   \
     0x0000ffff,    0,		/* DPREGS */   \
     0x02490000,    0,		/* IREGS */   \
     0x04920000,    0,		/* BREGS */   \
     0x09240000,    0,		/* LREGS */   \
     0x0fff0000,    0,		/* CIRCREGS */   \
     0xf0000000,    0,		/* MREGS */   \
     0xffff0000,    0,		/* DAGREGS */   \
     0x00000000,    0x3,	/* AREGS */   \
     0x00000000,    0x4,        /* CCREGS */  \
     0x0000ffff,    0x0,	/* GENERAL_REGS */\
     0xffffffff,    0x7,	/* ALL_REGS */\
     /*0xffffffff,    0x3, */	}

#define BASE_REG_CLASS          PREGS
#define INDEX_REG_CLASS         PREGS

#ifdef REG_OK_STRICT
#define REGNO_OK_FOR_BASE_P(x)  (REGNO_REG_CLASS (x) == BASE_REG_CLASS)
#define REGNO_OK_FOR_INDEX_P(x) (REGNO_REG_CLASS (x) == INDEX_REG_CLASS)
#else
#define REGNO_OK_FOR_BASE_P(x)  \
 (((x) >= FIRST_PSEUDO_REGISTER) \
  || (REGNO_REG_CLASS (x) == BASE_REG_CLASS))
#define REGNO_OK_FOR_INDEX_P(x) \
     (((x) >= FIRST_PSEUDO_REGISTER) \
      || (REGNO_REG_CLASS (x) == INDEX_REG_CLASS))
#endif

#define REG_OK_FOR_BASE_P(X)    (REG_P(X) && REGNO_OK_FOR_BASE_P (REGNO(X)))
#define REG_OK_FOR_INDEX_P(X)   (REG_P(X) && REGNO_OK_FOR_INDEX_P (REGNO(X)))

/* Get reg_class from a letter such as appears in the machine description.  */

#define REG_CLASS_FROM_LETTER(LETTER)	\
  ((LETTER) == 'a' ? PREGS :            \
   (LETTER) == 'd' ? DREGS : 		\
   (LETTER) == 'D' ? DREGS_PAIR : 	\
   (LETTER) == 'e' ? AREGS : 		\
   (LETTER) == 'b' ? IREGS :            \
   (LETTER) == 'B' ? BREGS :            \
   (LETTER) == 'f' ? MREGS : 		\
   (LETTER) == 'c' ? CIRCREGS :         \
   (LETTER) == 'C' ? CCREGS : 		\
   NO_REGS)

/* The same information, inverted:
   Return the class number of the smallest class containing
   reg number REGNO.  This could be a conditional expression
   or could index an array.  */
#define REGNO_REG_CLASS(REGNO) \
 ((REGNO)<REG_P0 ? DREGS       \
 : (REGNO)<REG_I0 ? PREGS      \
 : ((REGNO)==REG_I0 || (REGNO)==REG_I1 || (REGNO)==REG_I2 || (REGNO)==REG_I3)\
   ? IREGS \
 : ((REGNO)==REG_L0 || (REGNO)==REG_L1 || (REGNO)==REG_L2 || (REGNO)==REG_L3)\
   ? LREGS \
 : ((REGNO)==REG_B0 || (REGNO)==REG_B1 || (REGNO)==REG_B2 || (REGNO)==REG_B3)\
   ? BREGS \
 : ((REGNO)<=REG_M3 && (REGNO)>=REG_M0) ? MREGS \
 : ((REGNO)==REG_A0 || (REGNO)==REG_A1) ? AREGS \
 : (REGNO)==REG_CC ? CCREGS 			\
 : NO_REGS)

/* When defined, the compiler allows registers explicitly used in the
   rtl to be used as spill registers but prevents the compiler from
   extending the lifetime of these registers. */
 
/* It makes the following test to work in combiner and reload
 * m(int a, int b) {return a<b; }
 * It allows the hard registers which appear in rtl to be used for spills.
 * See reload1.c, function reload()
 */
#define SMALL_REGISTER_CLASSES 1


/* Do not allow to store a value in REG_CC for any mode */
/* Do not allow to store value in pregs if mode is not SI*/
#define HARD_REGNO_MODE_OK(REGNO, MODE) hard_regno_mode_ok((REGNO), (MODE))

/* Return the maximum number of consecutive registers
   needed to represent mode MODE in a register of class CLASS.  */
#define CLASS_MAX_NREGS(CLASS, MODE)	\
  ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD)

#define HARD_REGNO_NREGS(REGNO, MODE) CLASS_MAX_NREGS(GENERAL_REGS, MODE)

/* A C expression that is nonzero if it is desirable to choose
   register allocation so as to avoid move instructions between a
   value of mode MODE1 and a value of mode MODE2.

   If `HARD_REGNO_MODE_OK (R, MODE1)' and `HARD_REGNO_MODE_OK (R,
   MODE2)' are ever different for any R, then `MODES_TIEABLE_P (MODE1,
   MODE2)' must be zero. */
#define MODES_TIEABLE_P(MODE1, MODE2) ((MODE1) == (MODE2))

/* `PREFERRED_RELOAD_CLASS (X, CLASS)'
     A C expression that places additional restrictions on the register
     class to use when it is necessary to copy value X into a register
     in class CLASS.  The value is a register class; perhaps CLASS, or
     perhaps another, smaller class.
*/
#define PREFERRED_RELOAD_CLASS(X, CLASS) \
    ((GET_MODE(X) == HImode || GET_MODE(X) == QImode) ? DREGS \
	: REGNO_REG_CLASS(REGNO(X)) == CCREGS ? DREGS : CLASS)

#define PREFERRED_OUTPUT_RELOAD_CLASS(X, CLASS) PREFERRED_RELOAD_CLASS(X, CLASS)

#define  SECONDARY_OUTPUT_RELOAD_CLASS(class,mode,x) \
    secondary_output_reload_class(class,mode,x)
#define  SECONDARY_INPUT_RELOAD_CLASS(class,mode,x)  \
    secondary_input_reload_class(class,mode,x)

/* Function Calling Conventions. */
#define FUNCTION_ARG_REGISTERS { REG_R0, REG_R1, REG_R2, -1 }

typedef struct {
  int words;			/* # words passed so far */
  int nregs;			/* # registers available for passing */
  int *arg_regs;		/* array of register -1 terminated */
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

/* For an arg passed partly in registers and partly in memory,
   this is the number of registers used.
   For args passed entirely in registers or entirely in memory, zero.  */

#define FUNCTION_ARG_PARTIAL_NREGS(CUM, MODE, TYPE, NAMED) \
  (function_arg_partial_nregs (&CUM, MODE, TYPE, NAMED))

#define FUNCTION_ARG_REGNO_P(REGNO) function_arg_regno_p (REGNO)


/* Initialize a variable CUM of type CUMULATIVE_ARGS
   for a call to a function whose data type is FNTYPE.
   For a library call, FNTYPE is 0.  */
#define INIT_CUMULATIVE_ARGS(CUM,FNTYPE,LIBNAME,INDIRECT)	\
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

#define FUNCTION_VALUE(VALTYPE, FUNC)      \
  gen_rtx (REG, TYPE_MODE (VALTYPE),       \
            VALUE_REGNO(TYPE_MODE(VALTYPE)))

/* Define how to find the value returned by a library function
   assuming the value has mode MODE.  */

#define LIBCALL_VALUE(MODE)  gen_rtx (REG, MODE, VALUE_REGNO(MODE))

#define FUNCTION_VALUE_REGNO_P(N) ((N) == REG_R0)


/* Addressing Modes */

/* Recognize any constant value that is a valid address. If a constant
 * address is in a register, updating this register to get memory address
 * is not needed. 
 */
#define BFIN_POOL_ADDRESS_P(x)				\
    (TARGET_MINI_CONST_POOL && (GET_CODE (x) == SYMBOL_REF	\
	&& CONSTANT_POOL_ADDRESS_P (x)))

#ifdef TARGET_HAS_SYMBOLIC_ADDRESSES
#define CONSTANT_ADDRESS_P(x) CONSTANT_P (x)
#else
#define CONSTANT_ADDRESS_P(x)                    		\
    (GET_CODE (x) == CONST || (GET_CODE (x) == CONST_INT	\
	&& CONST_16BIT_IMM_P(INTVAL (x)))			\
    || BFIN_POOL_ADDRESS_P (x))
#endif

/* Nonzero if the constant value X is a legitimate general operand.
   symbol_ref are not legitimate and will be put into constant pool.
   See force_const_mem().
   If -mno-pool, all constants are legitimate.
 */
#define LEGITIMATE_CONSTANT_P(x)				\
    (!TARGET_MINI_CONST_POOL						\
	|| GET_CODE (x) == CONST_INT || GET_CODE (x) == CONST	\
	|| GET_CODE (x) == CONST_DOUBLE 			\
	|| BFIN_POOL_ADDRESS_P (x))

/*   A number, the maximum number of registers that can appear in a
     valid memory address.  Note that it is up to you to specify a
     value equal to the maximum number that `GO_IF_LEGITIMATE_ADDRESS'
     would ever accept. */
#define MAX_REGS_PER_ADDRESS 2

/* GO_IF_LEGITIMATE_ADDRESS recognizes an RTL expression
   that is a valid memory address for an instruction.
   The MODE argument is the machine mode for the MEM expression
   that wants to use this address. 
   
   bfin addressing modes are as follows:
   
      [preg]
      [preg + imm16]
      [preg++]
      [preg--]
      [--sp]
*/
#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, WIN) do {            \
/* This is PC relative data before MACHINE_DEPENDENT_REORG runs.*/ \
  if (GET_MODE_SIZE (MODE) >= 4 && TARGET_MINI_CONST_POOL && CONSTANT_P (X) \
    && CONSTANT_POOL_ADDRESS_P (X))				\
    goto WIN;							\
  /* This is PC relative data after MACHINE_DEPENDENT_REORG runs.*/ \
  else if (TARGET_MINI_CONST_POOL && GET_MODE_SIZE (MODE) >= 4	\
    && reload_completed						\
    && (GET_CODE (X) == LABEL_REF				\
       || (GET_CODE (X) == CONST				\
           && GET_CODE (XEXP (X, 0)) == PLUS			\
           && GET_CODE (XEXP (XEXP (X, 0), 0)) == LABEL_REF	\
           && GET_CODE (XEXP (XEXP (X, 0), 1)) == CONST_INT)))	\
    goto WIN;							\
  switch (GET_CODE (X)) {			 	       \
  case REG:						       \
    if (REGNO_OK_FOR_BASE_P (REGNO (X)))		       \
      goto WIN;						       \
    break;						       \
  case PLUS:						       \
    if (REG_OK_FOR_BASE_P (XEXP (X, 0))			       \
	&& (GET_CODE (XEXP (X, 1)) == CONST_INT	       	       \
		&& CONST_16BIT_IMM_P(INTVAL (XEXP (X,1)))))    \
      goto WIN;						       \
    break;						       \
  case POST_INC:					       \
  case POST_DEC:					       \
    if (REG_OK_FOR_BASE_P (XEXP (X, 0)))	               \
      goto WIN;						       \
  case PRE_DEC:						       \
    if (XEXP (X, 0) == stack_pointer_rtx		       \
        && REG_OK_FOR_BASE_P (XEXP (X, 0)))	               \
      goto WIN;						       \
    break;						       \
  default:						       \
	break;/*RAJA */					       \
  }							       \
} while (0)

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
#define LEGITIMIZE_ADDRESS(X,OLDX,MODE,WIN) {\
   rtx _q;\
   if((_q = legitimize_address(X,OLDX,MODE))) { X = _q; goto WIN;}}

#define HAVE_POST_INCREMENT 1
#define HAVE_POST_DECREMENT 1
#define HAVE_PRE_DECREMENT  1

/* `LEGITIMATE_PIC_OPERAND_P (X)'
     A C expression that is nonzero if X is a legitimate immediate
     operand on the target machine when generating position independent
     code.  You can assume that X satisfies `CONSTANT_P', so you need
     not check this.  You can also assume FLAG_PIC is true, so you need
     not check it either.  You need not define this macro if all
     constants (including `SYMBOL_REF') can be immediate operands when
     generating position independent code. */
#define LEGITIMATE_PIC_OPERAND_P(X) \
  (! SYMBOLIC_CONST (X)							\
   || (GET_CODE (X) == SYMBOL_REF && CONSTANT_POOL_ADDRESS_P (X)))

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
#define GO_IF_MODE_DEPENDENT_ADDRESS(ADDR,LABEL)  \
do {                                              \
 if (GET_CODE (ADDR) == POST_INC                  \
     || GET_CODE (ADDR) == POST_DEC               \
     || GET_CODE (ADDR) == PRE_DEC)               \
   goto LABEL;					  \
} while (0)

#define NOTICE_UPDATE_CC(EXPR, INSN) 0

/* Value is 1 if truncating an integer of INPREC bits to OUTPREC bits
   is done just by pretending it is already truncated.  */
#define TRULY_NOOP_TRUNCATION(OUTPREC, INPREC) 1

/* Max number of bytes we can move from memory to memory
   in one reasonably fast instruction.  */
#define MOVE_MAX UNITS_PER_WORD


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

#define MINIMUM_ATOMIC_ALIGNMENT BITS_PER_UNIT

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

/* Define this macro if the promotion described by `PROMOTE_MODE'
   should also be done for outgoing function arguments.  */
/* This is required to ensure that push insns always push a word. */ 
#define PROMOTE_FUNCTION_ARGS
#define PROMOTE_FUNCTION_RETURN

/* Define the codes that are matched by predicates in bfin.c.  */
#define PREDICATE_CODES                                                 	\
  {"cc_operand", {REG}},					        	\
  {"simple_reg_operand", {SUBREG, REG, ADDRESSOF}},        			\
  {"scale_by_operand", {CONST_INT}},						\
  {"pos_scale_operand", {CONST_INT}},                                   	\
  {"regorbitclr_operand", {CONST_INT, SUBREG, REG, ADDRESSOF}},         	\
  {"regorlog2_operand", {CONST_INT, SUBREG, REG, ADDRESSOF}},           	\
  {"nonmemory_or_sym_operand", {CONST_INT, CONST_DOUBLE, CONST,			\
			 SYMBOL_REF, LABEL_REF, SUBREG, REG, ADDRESSOF}},	\



/* Describing Relative Costs of Operations */

/* Do not put function addr into constant pool */
#define NO_FUNCTION_CSE 1
#define NO_RECURSIVE_FUNCTION_CSE 1

/* `RTX_COSTS (X, CODE, OUTER_CODE)'
   Like `CONST_COSTS' but applies to nonconstant RTL expressions.
   This can be used, for example, to indicate how costly a multiply
   instruction is.  In writing this macro, you can use the construct
   `COSTS_N_INSNS (N)' to specify a cost equal to N fast
   instructions.  OUTER_CODE is the code of the expression in which X
   is contained.

   This macro is optional; do not define it if the default cost
   assumptions are adequate for the target machine.
#define DEFAULT_RTX_COSTS(X, CODE, OUTER_CODE) (bfin_rtx_costs ((X), (CODE), (OUTER_CODE)))
*/


/* Define the cost of moving between registers of various classes.
   If we want to avoid some moves, we will make them expensive.
   Moves from dpregs to aregs take one extra cycle.
   */
 
#define REGISTER_MOVE_COST(MODE, CLASS1, CLASS2) register_move_cost((CLASS1), (CLASS2))

/* The relative costs of various types of constants. */
#define CONST_COSTS(RTX, CODE, OUTER_CODE)                      \
  case CONST_INT:                                               \
    if ((OUTER_CODE)==SET || (OUTER_CODE)==PLUS)		\
        return CONST_7BIT_IMM_P(INTVAL(RTX)) ?			\
	0 : 2;                                 			\
    else if ((OUTER_CODE)==AND) 				\
	return (CONST_7BIT_IMM_P(INTVAL(RTX)) || 		\
	    log2constp (1+INTVAL(RTX)) || log2constp (-INTVAL(RTX)))?\
	0 : 2;                                 			\
    else if ((OUTER_CODE)==LE || (OUTER_CODE)==LT 		\
		|| (OUTER_CODE)==EQ)				\
	return (INTVAL (RTX) >= -4 && INTVAL (RTX) <= 3) ?	\
	0 : 2;							\
    else if ((OUTER_CODE)==LEU || (OUTER_CODE)==LTU)		\
	return (INTVAL (RTX) >= 0 && INTVAL (RTX) <= 7) ?	\
	0 : 2;							\
    else if ((OUTER_CODE)==MULT)				\
	return ((INTVAL (RTX)==2 || INTVAL (RTX)==4)) ?		\
	0 : 2;							\
    else if ((OUTER_CODE)==ASHIFT && 				\
	(INTVAL (RTX) == 1 && INTVAL (RTX) == 2)) 		\
	return 0;						\
    else if ((OUTER_CODE)==ASHIFT || (OUTER_CODE)==ASHIFTRT     \
	|| (OUTER_CODE)==LSHIFTRT)                              \
	return (INTVAL (RTX) >= 0 && INTVAL (RTX) <= 31) ?      \
	0 : 2;                                   		\
    else if ((OUTER_CODE)==IOR || (OUTER_CODE)==XOR)    	\
	return ((INTVAL (RTX) >= 0 && INTVAL (RTX) <= 31) &&	\
	(INTVAL (RTX) & (INTVAL (RTX) - 1)) == 0) ?      	\
	0 : 2;                                   		\
    else                                                        \
      return 2;                                  		\
  case CONST:                                                   \
  case LABEL_REF:                                               \
  case SYMBOL_REF:                                              \
  case CONST_DOUBLE:                                            \
    return 4;


#if 0
#define CONST_COSTS(RTX, CODE, OUTER_CODE) 			\
  case CONST_INT:						\
    if (CONST_OK_FOR_LETTER_P (INTVAL (RTX), 'I')) 		\
       return 1;    						\
    else if (CONST_16BIT_IMM_P(INTVAL (RTX)))      	 	\
       return 2;    						\
    return 4;     						\
  case CONST:							\
  case LABEL_REF:						\
  case SYMBOL_REF:						\
    return 4;							\
  case CONST_DOUBLE:						\
    return 10;
#endif


/* `ADDRESS_COST (ADDRESS)'
     An expression giving the cost of an addressing mode that contains
     ADDRESS.  If not defined, the cost is computed from the ADDRESS
     expression and the `CONST_COSTS' values.

     For most CISC machines, the default cost is a good approximation
     of the true cost of the addressing mode.  However, on RISC
     machines, all instructions normally have the same length and
     execution time.  Hence all addresses will have equal costs.

     In cases where more than one form of an address is known, the form
     with the lowest cost will be used.  If multiple forms have the
     same, lowest, cost, the one that is the most complex will be used.

     For example, suppose an address that is equal to the sum of a
     register and a constant is used twice in the same basic block.
     When this macro is not defined, the address will be computed in a
     register and memory references will be indirect through that
     register.  On machines where the cost of the addressing mode
     containing the sum is no higher than that of a simple indirect
     reference, this will produce an additional instruction and
     possibly require an additional register.  Proper specification of
     this macro eliminates this overhead for such machines.

     Similar use of this macro is made in strength reduction of loops.

     ADDRESS need not be valid as an address.  In such a case, the cost
     is not relevant and can be any value; invalid addresses need not be
     assigned a different cost.

     On machines where an address involving more than one register is as
     cheap as an address computation involving only one register,
     defining `ADDRESS_COST' to reflect this can cause two registers to
     be live over a region of code where only one would have been if
     `ADDRESS_COST' were not defined in that manner.  This effect should
     be considered in the definition of this macro.  Equivalent costs
     should probably only be given to addresses with different numbers
     of registers on machines with lots of registers.

     This macro will normally either not be defined or be defined as a
     constant. */

#define ADDRESS_COST(ADDR) bfin_address_cost(ADDR)

/* Define as C expression which evaluates to nonzero if the tablejump
   instruction expects the table to contain offsets from the address of the
   table.
   Do not define this if the table should contain absolute addresses.
#define CASE_VECTOR_PC_RELATIVE 1
*/
 
/* Specify the machine mode that this machine uses
   for the index in the tablejump instruction.  */
#ifdef CASE_VECTOR_PC_RELATIVE
#define CASE_VECTOR_MODE HImode
#else
#define CASE_VECTOR_MODE SImode
#endif

/* Define if operations between registers always perform the operation
   on the full register even if a narrower mode is specified. 
#define WORD_REGISTER_OPERATIONS
*/
 
/* The letters I, J, K, L and M in a register constraint string
   can be used to stand for particular ranges of immediate operands.
   This macro defines what the ranges are.
   C is the letter, and VALUE is a constant value.
   Return 1 if VALUE is in the range specified by C. 
   
   bfin constant operands are as follows
   
     I  -8 .. 7      4bit imm
     J  2**N         5bit imm scaled
     K  1, 2         scale by 2 or 4
     L  0..31
     M  -64 .. 63
     N  0 .. 7     3bit uimm
     O  -4 .. 3    3bit uimm
*/
#define CONST_OK_FOR_LETTER_P(VALUE, C)         	\
  ((C) == 'I' ? (CONST_4BIT_IMM_P(VALUE)) :		\
   (C) == 'J' ? (log2constp ((VALUE)) 			\
	&& CONST_5UBIT_IMM_P(exact_log2((VALUE)))) :	\
   (C) == 'K' ? ((VALUE) == 1 || (VALUE) == 2) :        \
   (C) == 'L' ? (CONST_5UBIT_IMM_P(VALUE)) :		\
   (C) == 'M' ? (CONST_7BIT_IMM_P(VALUE)) :		\
   (C) == 'N' ? (CONST_3UBIT_IMM_P(VALUE)) :		\
   (C) == 'O' ? (CONST_3BIT_IMM_P(VALUE)) :		\
   (C) == 'P' ? (VALUE) == 1 :				\
   0)

/* Note: need one general case for const interger. -- Tony */

#define EXTRA_CONSTRAINT(VALUE, C)         		\
   ((C) == 'Q' && GET_CODE (VALUE) == CONST_INT ? 	\
    	log2constp (~(INTVAL(VALUE))) :			\
   0)

     /*Constant Output Formats */
#define CONST_DOUBLE_OK_FOR_LETTER_P(VALUE, C)	\
  ((C) == 'H' ? 1 : 0)


/* `FINALIZE_PIC'
     By generating position-independent code, when two different
     programs (A and B) share a common library (libC.a), the text of
     the library can be shared whether or not the library is linked at
     the same address for both programs.  In some of these
     environments, position-independent code requires not only the use
     of different addressing modes, but also special code to enable the
     use of these addressing modes.

     The `FINALIZE_PIC' macro serves as a hook to emit these special
     codes once the function is being compiled into assembly code, but
     not before.  (It is not done before, because in the case of
     compiling an inline function, it would lead to multiple PIC
     prologues being included in functions which used inline functions
     and were compiled to assembly language.) */
#define FINALIZE_PIC  do {} while (0)


/* Define results of standard character escape sequences.  */
#define TARGET_BELL      007
#define TARGET_BS        010
#define TARGET_TAB       011
#define TARGET_NEWLINE   012
#define TARGET_VT        013
#define TARGET_FF        014
#define TARGET_CR        015
#define TARGET_ESC	 033

/*Initialize the GCC target structure.  */
#define TARGET_ASM_GLOBALIZE_LABEL bfin_globalize_label 

#define TARGET_ASM_OPEN_PAREN "("
#define TARGET_ASM_CLOSE_PAREN ")"

#define TARGET_ASM_FUNCTION_PROLOGUE bfin_function_prologue

#define TARGET_ASM_FUNCTION_EPILOGUE bfin_function_epilogue

/* Switch into a generic section.  */
#define TARGET_ASM_NAMED_SECTION  default_elf_asm_named_section


/* Assembler output */
#define PRINT_OPERAND_PUNCT_VALID_P(CODE)      index ("jJhXDQR", CODE)

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

#define TEXT_SECTION_ASM_OP section_asm_op (CODE_DIR)
#define DATA_SECTION_ASM_OP section_asm_op (DATA_DIR)

#define ASM_APP_ON  ""
#define ASM_APP_OFF ""

#define ASM_LONG  directive_names[LONG_CONST_DIR]
#define ASM_SHORT directive_names[SHORT_CONST_DIR]
#define ASM_BYTE directive_names[BYTE_CONST_DIR]
#define ASM_SPACE directive_names[SPACE_DIR]
#define ASM_INIT directive_names[INIT_DIR]

/* Output at beginning of assembler file.  */
#define ASM_FILE_START(FILE) output_file_start (FILE)


/* Switch into a generic section.
 *    This is currently only used to support section attributes.
 *
 *       We make the section read-only and executable for a function decl,
 *          read-only for a const data decl, and writable for a non-const data decl.  */
/* Support __attribute__ ((section("name")))  -- STChen */
#define ASM_OUTPUT_SECTION_NAME(FILE, DECL, NAME, RELOC) \
  fprintf (FILE, ".section\t%s,\"%s\",@progbits\n", NAME, \
             (DECL) && TREE_CODE (DECL) == FUNCTION_DECL ? "ax" : \
             (DECL) && DECL_READONLY_SECTION (DECL, RELOC) ? "a" : "aw")

    /* if (in_section == no_section) force_data_section ();*/

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
        fputc (':',FILE);			\
      } while (0)

#define ASM_OUTPUT_LABELREF(FILE,NAME) 	\
    do {  fprintf (FILE, ((TARGET_NO_UNDERSCORE)) ? "%s" : "_%s", NAME); \
        } while (0)

#if 0   /* temporarily not use, change for uclinux kernel */
#define ASM_OUTPUT_LABELREF(FILE,NAME) 	\
    do {  fprintf (FILE, "%s", NAME); \
        } while (0)
#endif

#define ASM_GENERATE_INTERNAL_LABEL(LABEL, PREFIX, NUM)\
     sprintf (LABEL, "*%s%s$%d", LOCAL_LABEL_PREFIX, PREFIX, (int) NUM)

#define ASM_OUTPUT_INTERNAL_LABEL(FILE, PREFIX, NUM) 	\
  do {  fprintf(FILE, "%s%s$%d:\n", LOCAL_LABEL_PREFIX, PREFIX, NUM);		\
      } while (0)


#define ASM_FORMAT_PRIVATE_NAME(OUTPUT, NAME, LABELNO)			\
  do {									\
    int len = strlen (NAME);						\
    char *temp = (char *) alloca (len + 4);				\
    temp[0] = 'L';							\
    temp[1] = '_';							\
    strcpy (&temp[2], (NAME));						\
    temp[len + 2] = '_';						\
    temp[len + 3] = 0;							\
    (OUTPUT) = (char *) alloca (strlen (NAME) + 13);			\
    sprintf (OUTPUT, "*%s$%d", temp, LABELNO);				\
  } while (0)

/* Output a label which precedes a jumptable.  Since
   instructions are 2 bytes, we need explicit alignment here.  */
 
#define ASM_OUTPUT_CASE_LABEL(FILE,PREFIX,NUM,JUMPTABLE)\
  do {  if (CASE_VECTOR_MODE == SImode)			\
	ASM_OUTPUT_ALIGN (FILE, 2);                     \
    ASM_OUTPUT_INTERNAL_LABEL (FILE, PREFIX, NUM);      \
  } while (0)

#define ASM_OUTPUT_ADDR_VEC_ELT(FILE, VALUE)    	\
do { char __buf[256];					\
     fprintf (FILE, "\t%s%s\t", ASM_LONG, ASM_INIT);	\
     ASM_GENERATE_INTERNAL_LABEL (__buf, "L", VALUE);	\
     assemble_name (FILE, __buf);			\
     fputc (';', FILE);					\
     fputc ('\n', FILE);				\
   } while (0)

#define ASM_OUTPUT_ADDR_DIFF_ELT(FILE, BODY, VALUE, REL) \
    MY_ASM_OUTPUT_ADDR_DIFF_ELT(FILE, VALUE, REL)

#define MY_ASM_OUTPUT_ADDR_DIFF_ELT(FILE, VALUE, REL) \
do { char __buf[256];					\
     fprintf (FILE, "\t%s%s\t", ASM_SHORT, ASM_INIT);	\
     ASM_GENERATE_INTERNAL_LABEL (__buf, "L", VALUE);	\
     assemble_name (FILE, __buf);			\
     fputs (" - ", FILE);					\
     ASM_GENERATE_INTERNAL_LABEL (__buf, "L", REL);	\
     assemble_name (FILE, __buf);			\
     fputc (';', FILE);					\
     fputc ('\n', FILE);				\
   } while (0)

#define ASM_OUTPUT_ALIGN(FILE,LOG) 				\
    do {		 					\
     if (!TARGET_ASM_DIR) fprintf (FILE, ".align %d\n", LOG); 	\
     else fprintf (FILE, ".align %d;\n", 1 << LOG);		\
   } while (0)

#define ASM_OUTPUT_SKIP(FILE,SIZE) 	\
   do {  asm_output_skip (FILE, SIZE);	\
       } while (0)

#define ASM_OUTPUT_LOCAL(FILE, NAME, SIZE, ROUNDED) 	\
do { 						\
    data_section();				\
    if ((SIZE) >= 4 ) ASM_OUTPUT_ALIGN(FILE,2);	\
    if (!TARGET_ASM_DIR) {			\
	ASM_OUTPUT_LABEL (FILE, NAME); 		\
	fprintf (FILE, "%s %d;\n", ASM_SPACE, 	\
		(ROUNDED) > 1 ? (ROUNDED) : 1); \
    } else {					\
	char __buf[256];			\
	fprintf (FILE, "%s ", ASM_SPACE); 	\
	sprintf (__buf, "%s[%d]", (NAME), (ROUNDED) > 1 ? (ROUNDED) : 1);\
        assemble_name (FILE, __buf);            \
        fputc (';', FILE);                    	\
        fputc ('\n', FILE);                    	\
    }						\
} while (0)

#define ASM_OUTPUT_COMMON(FILE, NAME, SIZE, ROUNDED)	\
     do {						\
	ASM_GLOBALIZE_LABEL1(FILE,NAME); 		\
        ASM_OUTPUT_LOCAL (FILE, NAME, SIZE, ROUNDED); } while(0)
/*
     do {  fputs(".comm ", (FILE));			\
	   assemble_name ((FILE), (NAME));		\
	   fprintf((FILE), ",%u,%u;\n", (SIZE), (ROUNDED));	\
        } while (0)	
*/

#define ASM_OUTPUT_BYTE(FILE, VALUE)\
    fprintf(FILE, "\t%s%s 0x%x;\n", ".db", ASM_INIT, (VALUE));

#define ASM_OUTPUT_CHAR(FILE, VALUE)\
      do {fprintf (FILE, "\t%s%s", ASM_BYTE, ASM_INIT);	\
	  output_addr_const (FILE, (VALUE));	\
	  putc (';', FILE);			\
	  putc ('\n', FILE);			\
      } while (0)

#define ASM_OUTPUT_SHORT(FILE, VALUE)\
  do {fprintf (FILE, "\t%s%s", ASM_SHORT, ASM_INIT); \
      output_addr_const (FILE,(VALUE));	\
      putc(';',FILE);			\
      putc('\n',FILE);			\
  } while (0)


#define ASM_OUTPUT_INT(FILE, VALUE)\
  do { fprintf (FILE, "\t%s%s", ASM_LONG, ASM_INIT); \
       output_addr_const (FILE,(VALUE));     	\
       putc(';',FILE);                       	\
       putc('\n',FILE);				\
  } while (0)

#define ASM_OUTPUT_ASCII(FILE,STR,SZ) 		\
    do { asm_output_ascii (FILE,STR,SZ);	\
       } while (0)


#define ASM_COMMENT_START "//"

/* This is how to output an assembler line defining a `float' constant.  */
#define ASM_OUTPUT_FLOAT(FILE,VALUE)                    \
do { long l;                                            \
     char str[30];					\
     REAL_VALUE_TO_TARGET_SINGLE ((VALUE), l);          \
     REAL_VALUE_TO_DECIMAL ((VALUE), "%.20e", str);	\
     fprintf(FILE, "\t%s%s0x%lx;\t%s %s\n", ASM_LONG,	\
     ASM_INIT, l, ASM_COMMENT_START, str);		\
   } while (0)

/* This is how to output an assembler line defining a `double' constant.  */
#define ASM_OUTPUT_DOUBLE(FILE, VALUE) \
{                                                       \
  long t[2];                                            \
  char str[30];                                         \
  REAL_VALUE_TO_TARGET_DOUBLE ((VALUE), t);             \
  REAL_VALUE_TO_DECIMAL ((VALUE), "%.20e", str);        \
  fprintf (FILE, "\t%s\t0x%lx %s %s\n\t%s\t0x%lx\n",	\
           ASM_LONG, t[0], ASM_COMMENT_START, str, ASM_LONG, t[1]);         \
}  


#define FUNCTION_PROFILER(FILE, LABELNO) \
  do {\
    fprintf (FILE, "\tl(p1) =LP$%d; h(p1) =LP$%d; call mcount;\n", \
       LABELNO, LABELNO);\
  } while(0)

#define ASM_OUTPUT_REG_PUSH(FILE, REGNO) fprintf (FILE, "// push %s\n", reg_names[REGNO])
#define ASM_OUTPUT_REG_POP(FILE, REGNO)  fprintf (FILE, "// pop %s\n", reg_names[REGNO])

extern struct rtx_def *bfin_compare_op0, *bfin_compare_op1;
extern struct rtx_def *bfin_cc_rtx;

/*#define REAL_IS_NOT_DOUBLE
#define REAL_VALUE_TYPE float*/

/* This works for GAS and some other assemblers.  */
#define SET_ASM_OP              ".set "

#include <defaults.h>

#define RET  return ""        /* Used in machine description */

/* The literal pool needs to reside in the text area due to the
   limited PC addressing range: */
#define MACHINE_DEPENDENT_REORG(INSN) \
    if (TARGET_MINI_CONST_POOL) bfin_reorg ((INSN))

extern int bfin_lvno;

#define HANDLE_SYSV_PRAGMA 1

/* Debugging for dwarf-1 and dwarf-2 */
#define DWARF_DEBUGGING_INFO
#define DWARF2_DEBUGGING_INFO
#undef PREFERRED_DEBUGGING_TYPE
#define PREFERRED_DEBUGGING_TYPE DWARF2_DEBUG  

/* Don't know how to order these.  UNALIGNED_WORD_ASM_OP is in
   dwarf2.out. */
#define UNALIGNED_WORD_ASM_OP ".4byte"

#define ASM_OUTPUT_DWARF2_ADDR_CONST(FILE,ADDR)                  \
     fprintf ((FILE), "\t%s\t%s", UNALIGNED_WORD_ASM_OP, ADDR)

#define ASM_OUTPUT_DWARF_ADDR_CONST(FILE,RTX)                   \
do {                                                            \
  fprintf ((FILE), "\t%s\t", UNALIGNED_WORD_ASM_OP);            \
  output_addr_const ((FILE), (RTX));                            \
  fputc ('\n', (FILE));                                         \
} while (0) 


/* DBX register number for a given compiler register number */
#define DBX_REGISTER_NUMBER(REGNO)  (REGNO) 

/* This is how we tell the assembler that two symbols have the same value. 
#define ASM_OUTPUT_DEF(FILE,NAME1,NAME2) \
  do { assemble_name (FILE, NAME1);      \
       fputs (" = ", FILE);              \
       assemble_name (FILE, NAME2);      \
       fputc ('\n', FILE); } while (0) 
*/

/* This works for GAS and some other assemblers.  
#define SET_ASM_OP              ".set"
*/

/* Debugging for standard elf stabs */
#include "dbxelf.h"



#endif /*  _BFIN_CONFIG */
/* nothing should be placed after this point */
