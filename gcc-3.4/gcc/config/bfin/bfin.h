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
/* #include <stdlib.h>	*/

#define OBJECT_FORMAT_ELF

#define BRT 1
#define BRF 0

/* Print subsidiary information on the compiler version in use.  */
#define TARGET_VERSION fprintf (stderr, " (BlackFin bfin)")

/*
  The following set of defines, describe the commandline api.
*/
#define MASK_OMIT_LEAF_FRAME_POINTER 0x00000800 /* omit leaf frame pointers */
#define MASK_CSYNC                   0x00010000
#define MASK_SIMPLE_RTM              0x00020000
#define MASK_LOW_64K           	     0x00040000
#define MASK_CMOV	             0x00200000 /* use conditional moves */
#define MASK_LONG_CALLS	             0x00400000 /* use long calls */
#define MASK_PROFILE		     0x01000000 /* Instrument for NON GNU
						 * profiling */
#define MASK_NO_UNDERSCORE	     0x02000000 /* lacal label without underscore */

/* Compile using library ID based shared libraries.
 * Set a specific ID using the -mshared-library-id=xxx option.
 */
#define MASK_ID_SHARED_LIBRARY	(1<<18)

/* Run-time compilation parameters selecting different hardware subsets.  */

extern int target_flags;

/* Predefinition in the preprocessor for this target machine */
#ifndef TARGET_CPU_CPP_BUILTINS
#define TARGET_CPU_CPP_BUILTINS()               \
  do                                            \
    {                                           \
      builtin_define ("bfin");                  \
      builtin_define ("BFIN");                  \
      builtin_define ("FRIO");                  \
      builtin_define ("frio");                  \
    }                                           \
  while (0)
#endif

#ifndef CC1_SPEC
#define CC1_SPEC ""
#endif

#ifndef ASM_SPEC
#define ASM_SPEC ""
#endif

#undef  LIB_SPEC
#define LIB_SPEC "-lc"

/* Don't create frame pointers for leaf functions */
#define TARGET_OMIT_LEAF_FRAME_POINTER (target_flags & MASK_OMIT_LEAF_FRAME_POINTER)
#define TARGET_DEBUG_ARG	       (target_flags & MASK_DEBUG_ARGS)
#define TARGET_SIMPLE_RTM              (target_flags & MASK_SIMPLE_RTM)
#define TARGET_LOW_64K                 (target_flags & MASK_LOW_64K)
#define TARGET_CSYNC		       (target_flags & MASK_CSYNC)
#define TARGET_LONG_CALLS	       (target_flags & MASK_LONG_CALLS)
#define TARGET_NO_UNDERSCORE	       (target_flags & MASK_NO_UNDERSCORE)
#define TARGET_ID_SHARED_LIBRARY       (target_flags & MASK_ID_SHARED_LIBRARY)

#define TARGET_HAS_SYMBOLIC_ADDRESSES  (0)
#define TARGET_MOVE                    (1)
/* Generate DSP instructions, like DSP halfword loads */
#define TARGET_DSP			(1)
/* #define TARGET_MOVSICC		(target_flags & MASK_CMOV) */
#define TARGET_MOVSICC			(1)

/* Non-gprof profiler	*/
#define TARGET_NON_GNU_PROFILE		(target_flags & MASK_PROFILE)

#define TARGET_SWITCHES  {\
  { "omit-leaf-frame-pointer",	  MASK_OMIT_LEAF_FRAME_POINTER,		\
    "Omit Frame Pointer for leaf functions" }, 				\
  { "no-omit-leaf-frame-pointer",-MASK_OMIT_LEAF_FRAME_POINTER,		\
    "Use Frame Pointer for leaf functions"},       			\
  { "simple-rtm",	          MASK_SIMPLE_RTM,			\
    "Use a subset of C run-time library" },				\
  { "no-simple-rtm",	         -MASK_SIMPLE_RTM,			\
    "Use full C run-time library" },					\
  { "low64k",	                  MASK_LOW_64K,				\
    "Program is located in low 64K of memory" },			\
  { "no-low64k",	         -MASK_LOW_64K,				\
    "Program is not located in low 64K of memory (default)"},		\
  { "cmov",		         MASK_CMOV,				\
    "Use conditional moves"},						\
  { "no-cmov",			-MASK_CMOV,				\
    "Do not generate conditional moves"},				\
  { "long-calls",	         MASK_LONG_CALLS,			\
    "Don't generate PC-relative calls, use indirection"},		\
  { "no-cmov",			-MASK_LONG_CALLS,			\
    "Don't use long calls by default"},					\
  { "csync",		         MASK_CSYNC,				\
    "Avoid speculative loads by inserting CSYNC or equivalent"},	\
  { "no-csync",			-MASK_CSYNC,				\
    "Do not generate extra code to avoid speculative loads"},		\
  { "profile",		         MASK_PROFILE,				\
    "Non GNU Profiling"},						\
  { "no-profile",		-MASK_PROFILE,				\
    "NO Non GNU profiling"},						\
  { "id-shared-library", MASK_ID_SHARED_LIBRARY,			\
    "Enable ID based shared library" },					\
  { "no-id-shared-library", -MASK_ID_SHARED_LIBRARY,			\
    "Disable ID based shared library" },				\
  { "no-underscore",		MASK_NO_UNDERSCORE,			\
    "No underscore fro local label definition"},			\
  { "", MASK_CMOV | MASK_CSYNC,						\
    "default: cmov, csync"}}

/* This macro is similar to `TARGET_SWITCHES' but defines names of
   command options that have values.  Its definition is an
   initializer with a subgrouping for each command option.

   Each subgrouping contains a string constant, that defines the
   fixed part of the option name, and the address of a variable.  The
   variable, type `char *', is set to the variable part of the given
   option if the fixed part matches.  The actual option name is made
   by appending `-m' to the specified name.  */
#define TARGET_OPTIONS							\
{ { "shared-library-id=",	&bfin_library_id_string,		\
    "ID of shared library to build", 0}					\
}

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

#define VECTOR_MODE_SUPPORTED_P(MODE) ((MODE) == V2HImode)

/* store-condition-codes instructions store 0 for false
   This is the value stored for true.  */
#define STORE_FLAG_VALUE 1

/* Define this if pushing a word on the stack
   makes the stack pointer a smaller address.  */
#define STACK_GROWS_DOWNWARD

#define STACK_PUSH_CODE PRE_DEC

/* Define this if the nominal address of the stack frame
   is at the high-address end of the local variables;
   that is, each additional local variable allocated
   goes at a more negative offset in the frame.  */
#define FRAME_GROWS_DOWNWARD

/* We define a dummy ARGP register; the parameters start at offset 0 from
   it. */
#define FIRST_PARM_OFFSET(decl) 0

/* Offset within stack frame to start allocating local variables at.
   If FRAME_GROWS_DOWNWARD, this is the offset to the END of the
   first local allocated.  Otherwise, it is the offset to the BEGINNING
   of the first local allocated.  */
#define STARTING_FRAME_OFFSET 0

/*  Define this macro if an argument declared in a prototype as an
    integral type smaller than `int' should actually be passed as an
    `int'.  In addition to avoiding errors in certain cases of
    mismatch, it also makes for better code on certain machines.   */
#define PROMOTE_PROTOTYPES 1

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
#define OUTGOING_REG_PARM_STACK_SPACE
	  
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

#define PARM_BOUNDRY            32

#define STACK_BOUNDRY           32

/*#define DATA_ALIGNMENT(TYPE, BASIC-ALIGN) for arrays.. */

/* Make strings word-aligned so strcpy from constants will be faster.  */
#define CONSTANT_ALIGNMENT(EXP, ALIGN)  \
  (TREE_CODE (EXP) == STRING_CST        \
   && (ALIGN) < BITS_PER_WORD ? BITS_PER_WORD : (ALIGN))    

#define TRAMPOLINE_SIZE 18
#define TRAMPOLINE_TEMPLATE(FILE)                                       \
  fprintf(FILE, "\t.dd\t0x0000e109\n"); /* p1.l = fn low */		\
  fprintf(FILE, "\t.dd\t0x0000e149\n"); /* p1.h = fn high */;		\
  fprintf(FILE, "\t.dd\t0x0000e10a\n"); /* p2.l = sc low */;		\
  fprintf(FILE, "\t.dd\t0x0000e14a\n"); /* p2.h = sc high */;		\
  fprintf(FILE, "\t.dw\t0x0051\n"); /* jump (p1)*/

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

#define FIRST_PSEUDO_REGISTER 44

#define PREG_P(X) (REG_P (X) && REGNO (X) >= REG_P0 && REGNO (X) <= REG_P7)
#define ADDRESS_REGNO_P(X) ((X) >= REG_P0 && (X) <= REG_M3)
#define D_REGNO_P(X) ((X) <= REG_R7)

#define REGISTER_NAMES { \
  "R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7", \
  "P0", "P1", "P2", "P3", "P4", "P5", "SP", "FP", \
  "I0", "B0", "L0", "I1", "B1", "L1", "I2", "B2", \
  "L2", "I3", "B3", "L3", "M0", "M1", "M2", "M3", \
  "A0", "A1", \
  "CC", \
  "RETS", "RETI", "RETX", "RETN", "RETE", "ASTAT", "SEQSTAT", "USP", \
  "ARGP" \
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
  "R1:0.p", 0, "R3:2.p", 0, "R5:4.p", 0, "R7:6.p", 0,  }

#define BYTE_REGISTER_NAMES { \
  "R0.B", "R1.B", "R2.B", "R3.B", "R4.B", "R5.B", "R6.B", "R7.B",  }


/* 1 for registers that have pervasive standard uses
   and are not available for the register allocator.  */

#define FIXED_REGISTERS \
/*r0 r1 r2 r3 r4 r5 r6 r7   p0 p1 p2 p3 p4 p5 p6 p7 */ \
{ 0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 1, 0,    \
/*i0 b0 l0 i1 b1 l1 i2 b2   l2 i3 b3 l3 m0 m1 m2 m3 */ \
  0, 0, 1, 0, 0, 1, 0, 0,   1, 0, 0, 1, 0, 0, 0, 0,    \
/*a0 a1 cc rets/i/x/n/e     astat seqstat usp argp */ \
  0, 0, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1	 \
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
/*i0 b0 l0 i1 b1 l1 i2 b2   l2 i3 b3 l3 m0 m1 m2 m3 */ \
  1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,   \
/*a0 a1 cc rets/i/x/n/e     astat seqstat usp argp */ \
  1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1	 \
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
  REG_I0, REG_B0, REG_L0, REG_I1, REG_B1, REG_L1, REG_I2, REG_B2, \
  REG_L2, REG_I3, REG_B3, REG_L3, REG_M0, REG_M1, REG_M2, REG_M3, \
  REG_RETS, REG_RETI, REG_RETX, REG_RETN, REG_RETE,		  \
  REG_ASTAT, REG_SEQSTAT, REG_USP, 				  \
  REG_CC, REG_ARGP						  \
}

/* Macro to conditionally modify fixed_regs/call_used_regs.  */
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
  IREGS,
  BREGS,
  LREGS,
  MREGS,
  CIRCREGS, /* Circular buffering registers, Ix, Bx, Lx together form. See Automatic Circlur Buffering */
  DAGREGS,
  EVEN_AREGS,
  ODD_AREGS,
  AREGS,
  CCREGS,
  EVEN_DREGS,
  ODD_DREGS,
  DREGS,
  PREGS_CLOBBERED,
  PREGS,
  DPREGS,
  MOST_REGS,
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
   "DREGS",		\
   "PREGS_CLOBBERED",	\
   "PREGS",		\
   "DPREGS",		\
   "MOST_REGS",		\
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
    { 0x02490000,    0 },		/* IREGS */	\
    { 0x04920000,    0 },		/* BREGS */		\
    { 0x09240000,    0 },		/* LREGS */	\
    { 0xf0000000,    0 },		/* MREGS */   \
    { 0x0fff0000,    0 },		/* CIRCREGS */   \
    { 0xffff0000,    0 },		/* DAGREGS */   \
    { 0x00000000,    0x1 },		/* EVEN_AREGS */   \
    { 0x00000000,    0x2 },		/* ODD_AREGS */   \
    { 0x00000000,    0x3 },		/* AREGS */   \
    { 0x00000000,    0x4 },		/* CCREGS */  \
    { 0x00000055,    0 },		/* EVEN_DREGS */   \
    { 0x000000aa,    0 },		/* ODD_DREGS */   \
    { 0x000000ff,    0 },		/* DREGS */   \
    { 0x00004700,    0x800 },		/* PREGS_CLOBBERED */   \
    { 0x0000ff00,    0x800 },		/* PREGS */   \
    { 0x0000ffff,    0x800 },		/* DPREGS */   \
    { 0xffffffff,    0x800 },		/* MOST_REGS */\
    { 0x00000000,    0x7f8 },		/* PROLOGUE_REGS */\
    { 0xffffffff,    0xff8 },		/* NON_A_CC_REGS */\
    { 0xffffffff,    0xfff }}		/* ALL_REGS */

#define BASE_REG_CLASS          PREGS
#define INDEX_REG_CLASS         PREGS

#define REGNO_OK_FOR_BASE_STRICT_P(X) (REGNO_REG_CLASS (X) == BASE_REG_CLASS)
#define REGNO_OK_FOR_BASE_NONSTRICT_P(X)  \
 (((X) >= FIRST_PSEUDO_REGISTER) || REGNO_REG_CLASS (X) == BASE_REG_CLASS)

#ifdef REG_OK_STRICT
#define REGNO_OK_FOR_BASE_P(X) REGNO_OK_FOR_BASE_STRICT_P (X)
#else
#define REGNO_OK_FOR_BASE_P(X) REGNO_OK_FOR_BASE_NONSTRICT_P (X)
#endif

#define REG_OK_FOR_BASE_P(X)    (REG_P (X) && REGNO_OK_FOR_BASE_P (REGNO (X)))
#define REG_OK_FOR_INDEX_P(X)   0
#define REGNO_OK_FOR_INDEX_P(X)   0

/* Get reg_class from a letter such as appears in the machine description.  */

#define REG_CLASS_FROM_LETTER(LETTER)	\
  ((LETTER) == 'a' ? PREGS :            \
   (LETTER) == 'd' ? DREGS : 		\
   (LETTER) == 'z' ? PREGS_CLOBBERED :	\
   (LETTER) == 'D' ? EVEN_DREGS : 	\
   (LETTER) == 'W' ? ODD_DREGS : 	\
   (LETTER) == 'e' ? AREGS : 		\
   (LETTER) == 'A' ? EVEN_AREGS : 	\
   (LETTER) == 'B' ? ODD_AREGS : 	\
   (LETTER) == 'b' ? IREGS :            \
   (LETTER) == 'B' ? BREGS :            \
   (LETTER) == 'f' ? MREGS : 		\
   (LETTER) == 'c' ? CIRCREGS :         \
   (LETTER) == 'C' ? CCREGS : 		\
   (LETTER) == 'x' ? MOST_REGS :	\
   (LETTER) == 'y' ? PROLOGUE_REGS :	\
   (LETTER) == 'w' ? NON_A_CC_REGS :	\
   NO_REGS)

/* The same information, inverted:
   Return the class number of the smallest class containing
   reg number REGNO.  This could be a conditional expression
   or could index an array.  */

#define REGNO_REG_CLASS(REGNO) \
 ((REGNO) < REG_P0 ? DREGS				\
 : (REGNO) < REG_I0 ? PREGS				\
 : (REGNO) == REG_ARGP ? BASE_REG_CLASS			\
 : (REGNO) >= REG_I0 && (REGNO) <= REG_I3 ? IREGS	\
 : (REGNO) >= REG_L0 && (REGNO) <= REG_L3 ? LREGS	\
 : (REGNO) >= REG_B0 && (REGNO) <= REG_B3 ? BREGS	\
 : (REGNO) >= REG_M0 && (REGNO) <= REG_M3 ? MREGS	\
 : (REGNO) == REG_A0 || (REGNO) == REG_A1 ? AREGS	\
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
     || (CLASS) == CCREGS)

/* Do not allow to store a value in REG_CC for any mode */
/* Do not allow to store value in pregs if mode is not SI*/
#define HARD_REGNO_MODE_OK(REGNO, MODE) hard_regno_mode_ok((REGNO), (MODE))

/* Return the maximum number of consecutive registers
   needed to represent mode MODE in a register of class CLASS.  */
#define CLASS_MAX_NREGS(CLASS, MODE)	\
  ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1) / UNITS_PER_WORD)

#define HARD_REGNO_NREGS(REGNO, MODE) \
((MODE) == PDImode && ((REGNO) == REG_A0 || (REGNO) == REG_A1) \
 ? 1 : CLASS_MAX_NREGS (GENERAL_REGS, MODE))

/* A C expression that is nonzero if hard register TO can be
   considered for use as a rename register for FROM register */
#define HARD_REGNO_RENAME_OK(FROM, TO) bfin_hard_regno_rename_ok (FROM, TO)

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
   perhaps another, smaller class.  */
#define PREFERRED_RELOAD_CLASS(X, CLASS) (CLASS)

#define  SECONDARY_OUTPUT_RELOAD_CLASS(class,mode,x) \
    secondary_output_reload_class(class,mode,x)
#define  SECONDARY_INPUT_RELOAD_CLASS(class,mode,x)  \
    secondary_input_reload_class(class,mode,x)

/* Function Calling Conventions. */

/* The type of the current function; normal functions are of type
   SUBROUTINE.  */
typedef enum {
  SUBROUTINE, INTERRUPT_HANDLER, EXCPT_HANDLER, NMI_HANDLER
} e_funkind;

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
#define INIT_CUMULATIVE_ARGS(CUM,FNTYPE,LIBNAME,INDIRECT, N_NAMED_ARGS)	\
  (init_cumulative_args (&CUM, FNTYPE, LIBNAME))

/* Update the data in CUM to advance over an argument
   of mode MODE and data type TYPE.
   (TYPE is null for libcalls where that information may not be available.)  */
#define FUNCTION_ARG_ADVANCE(CUM, MODE, TYPE, NAMED)	\
  (function_arg_advance (&CUM, MODE, TYPE, NAMED))

/* Pass variable size arguments by reference for simplicity.  */
#define FUNCTION_ARG_PASS_BY_REFERENCE(CUM, MODE, TYPE, NAMED) \
    ((MODE) == BLKmode && TREE_CODE (TYPE_SIZE (TYPE)) != INTEGER_CST)

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

/* Register in which address to store a structure value
   is passed to a function.  */
#define STRUCT_VALUE_REGNUM REG_P0
#define DEFAULT_PCC_STRUCT_RETURN 0
#define RETURN_IN_MEMORY(TYPE) bfin_return_in_memory(TYPE)

/*vararg implementation */

#define SETUP_INCOMING_VARARGS(CUM,MODE,TYPE,PRETEND_SIZE,NO_RTL) \
  setup_incoming_varargs (&CUM, MODE, TYPE, &PRETEND_SIZE, NO_RTL)

/* Implement `va_arg'.  */
#define EXPAND_BUILTIN_VA_ARG(VALIST, TYPE) \
  bfin_va_arg ((VALIST), (TYPE))

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
    gen_rtx_MEM (Pmode, plus_constant (frame_pointer_rtx, UNITS_PER_WORD))

/* Addressing Modes */

/* Recognize any constant value that is a valid address.  */
#define CONSTANT_ADDRESS_P(X)	(CONSTANT_P (X))

/* Nonzero if the constant value X is a legitimate general operand.
   symbol_ref are not legitimate and will be put into constant pool.
   See force_const_mem().
   If -mno-pool, all constants are legitimate.
 */
#define LEGITIMATE_CONSTANT_P(x) 1

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
#define HAVE_PRE_DECREMENT  1

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

/* Size of a vector for autovectorization.  */
#define UNITS_PER_SIMD_WORD 4

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

/* Define this macro if the promotion described by `PROMOTE_MODE'
   should also be done for outgoing function arguments.  */
/* This is required to ensure that push insns always push a word. */ 
#define PROMOTE_FUNCTION_ARGS
#define PROMOTE_FUNCTION_RETURN

/* Define the codes that are matched by predicates in bfin.c.  */
#define PREDICATE_CODES                                                	\
  {"cc_operand", {REG}},				        	\
  {"bfin_cbranch_operator", {EQ, NE}},					\
  {"rhs_andsi3_operand", {SUBREG, REG, ADDRESSOF, CONST_INT}},		\
  {"call_insn_operand", {SUBREG, REG, SYMBOL_REF}},			\
  {"symbolic_operand", {CONST, SYMBOL_REF, LABEL_REF}},			\
  {"symbolic_or_const_operand",						\
      {CONST_INT, CONST_DOUBLE, CONST, SYMBOL_REF, LABEL_REF}},		\
  {"scale_by_operand", {CONST_INT}},					\
  {"pos_scale_operand", {CONST_INT}},                                  	\
  {"positive_immediate_operand", {CONST_INT}},				\
  {"reg_or_7bit_operand", {CONST_INT, SUBREG, REG, ADDRESSOF}},		\
  {"regorlog2_operand", {CONST_INT, SUBREG, REG, ADDRESSOF}},          	\

/* Describing Relative Costs of Operations */

/* Do not put function addr into constant pool */
#define NO_FUNCTION_CSE 1
#define NO_RECURSIVE_FUNCTION_CSE 1

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

#define CONST_18UBIT_IMM_P(VALUE) ((VALUE) >= 0 && (VALUE) <= 262140)
#define CONST_16BIT_IMM_P(VALUE) ((VALUE) >= -32768 && (VALUE) <= 32767)
#define CONST_16UBIT_IMM_P(VALUE) ((VALUE) >= 0 && (VALUE) <= 65535)
#define CONST_7BIT_IMM_P(VALUE) ((VALUE) >= -64 && (VALUE) <= 63)
#define CONST_7NBIT_IMM_P(VALUE) ((VALUE) >= -64 && (VALUE) <= 0)
#define CONST_5UBIT_IMM_P(VALUE) ((VALUE) >= 0 && (VALUE) <= 31)
#define CONST_4BIT_IMM_P(VALUE) ((VALUE) >= -8 && (VALUE) <= 7)
#define CONST_4UBIT_IMM_P(VALUE) ((VALUE) >= 0 && (VALUE) <= 15)
#define CONST_3BIT_IMM_P(VALUE) ((VALUE) >= -4 && (VALUE) <= 3)
#define CONST_3UBIT_IMM_P(VALUE) ((VALUE) >= 0 && (VALUE) <= 7)

#define CONSTRAINT_LEN(C, STR)			\
    ((C) == 'P' || (C) == 'M' || (C) == 'N' ? 2	\
     : (C) == 'K' ? 3				\
     : DEFAULT_CONSTRAINT_LEN ((C), (STR)))

#define CONST_OK_FOR_P(VALUE, STR)    \
    ((STR)[1] == '0' ? (VALUE) == 0   \
     : (STR)[1] == '1' ? (VALUE) == 1 \
     : (STR)[1] == '2' ? (VALUE) == 2 \
     : (STR)[1] == '3' ? (VALUE) == 3 \
     : (STR)[1] == '4' ? (VALUE) == 4 \
     : 0)

#define CONST_OK_FOR_K(VALUE, STR)			\
    ((STR)[1] == 'u'					\
     ? ((STR)[2] == '3' ? CONST_3UBIT_IMM_P (VALUE)	\
	: (STR)[2] == '4' ? CONST_4UBIT_IMM_P (VALUE)	\
	: (STR)[2] == '5' ? CONST_5UBIT_IMM_P (VALUE)	\
	: (STR)[2] == 'h' ? CONST_16UBIT_IMM_P (VALUE)	\
	: 0)						\
     : (STR)[1] == 's'					\
     ? ((STR)[2] == '3' ? CONST_3BIT_IMM_P (VALUE)	\
	: (STR)[2] == '4' ? CONST_4BIT_IMM_P (VALUE)	\
	: (STR)[2] == '7' ? CONST_7BIT_IMM_P (VALUE)	\
	: (STR)[2] == 'h' ? CONST_16BIT_IMM_P (VALUE)	\
	: 0)						\
     : (STR)[1] == 'n'					\
     ? ((STR)[2] == '7' ? CONST_7NBIT_IMM_P (VALUE)	\
	: 0)						\
     : 0)

#define CONST_OK_FOR_M(VALUE, STR)			\
    ((STR)[1] == '1' ? (VALUE) == 255			\
     : (STR)[1] == '2' ? (VALUE) == 65535		\
     : 0)

/* The letters I, J, K, L and M in a register constraint string
   can be used to stand for particular ranges of immediate operands.
   This macro defines what the ranges are.
   C is the letter, and VALUE is a constant value.
   Return 1 if VALUE is in the range specified by C. 
   
   bfin constant operands are as follows
   
     J   2**N       5bit imm scaled
     Ks7 -64 .. 63  signed 7bit imm
     Ku5 0..31      unsigned 5bit imm
     Ks4 -8 .. 7    signed 4bit imm
     Ks3 -4 .. 3    signed 3bit imm
     Ku3 0 .. 7     unsigned 3bit imm
     Pn  0, 1, 2    constants 0, 1 or 2, corresponding to n
*/
#define CONST_OK_FOR_CONSTRAINT_P(VALUE, C, STR)		\
  ((C) == 'I' ? (CONST_4BIT_IMM_P(VALUE)) 			\
   : (C) == 'J' ? (log2constp (VALUE))				\
   : (C) == 'K' ? CONST_OK_FOR_K (VALUE, STR)			\
   : (C) == 'L' ? log2constp (~(VALUE))				\
   : (C) == 'M' ? CONST_OK_FOR_M (VALUE, STR)			\
   : (C) == 'P' ? CONST_OK_FOR_P (VALUE, STR)			\
   : 0)

     /*Constant Output Formats */
#define CONST_DOUBLE_OK_FOR_LETTER_P(VALUE, C)	\
  ((C) == 'H' ? 1 : 0)

#define EXTRA_CONSTRAINT(VALUE, D) \
    ((D) == 'Q' ? GET_CODE (VALUE) == SYMBOL_REF : 0)

/* Codes for all the Blackfin builtins.  */
enum bfin_builtins
{
  BFIN_BUILTIN_CSYNC,
  BFIN_BUILTIN_SSYNC,
  BFIN_BUILTIN_MAX
};

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

#define TEXT_SECTION_ASM_OP ".text;"
#define DATA_SECTION_ASM_OP ".data;"

#define ASM_APP_ON  ""
#define ASM_APP_OFF ""

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
        fputs (":\n",FILE);			\
      } while (0)

#define ASM_OUTPUT_LABELREF(FILE,NAME) 	\
    do {  fprintf (FILE, ((TARGET_NO_UNDERSCORE)) ? "%s" : "_%s", NAME); \
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
    sprintf (OUTPUT, "_%s$%d", temp, LABELNO);				\
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
    data_section();				\
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

#define FUNCTION_PROFILER(FILE, LABELNO) \
  do {\
    fprintf (FILE, "\tP1.l =LP$%d; P1.h =LP$%d; call mcount;\n", \
       LABELNO, LABELNO);\
  } while(0)

#define ASM_OUTPUT_REG_PUSH(FILE, REGNO) fprintf (FILE, "// push %s\n", reg_names[REGNO])
#define ASM_OUTPUT_REG_POP(FILE, REGNO)  fprintf (FILE, "// pop %s\n", reg_names[REGNO])

extern struct rtx_def *bfin_compare_op0, *bfin_compare_op1;
extern struct rtx_def *bfin_cc_rtx, *bfin_rets_rtx;

/* This works for GAS and some other assemblers.  */
#define SET_ASM_OP              ".set "

/* Don't know how to order these.  UNALIGNED_WORD_ASM_OP is in
   dwarf2.out. */
#define UNALIGNED_WORD_ASM_OP ".4byte"

/* DBX register number for a given compiler register number */
#define DBX_REGISTER_NUMBER(REGNO)  (REGNO) 

#define SIZE_ASM_OP     "\t.size\t"

#endif /*  _BFIN_CONFIG */
