/*
 * Copyright (c) 2000, 2001 Analog Devices Inc.,
 * Copyright (c) 2000, 2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Ported for Blackfin/Frio Architecture by Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *                                          Tony Kou <tony.ko@arcturusnetworks.com>
 */


/* The BFIN code generation auxilary output file */

#include <stdio.h>
#include "config.h"
#include <setjmp.h>
#include <safe-ctype.h>
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h"
#include "regs.h"
#include "hard-reg-set.h"
#include "real.h"
#include "insn-config.h"
#include "conditions.h"
#include "insn-flags.h"
#include "output.h"
#include "insn-attr.h"
#include "tree.h"
#include "flags.h"
#include "except.h"
#include "function.h"
#include "input.h"
#include "target.h"
#include "target-def.h"
#include "expr.h"
#include "toplev.h"
#include "recog.h"
#include "ggc.h"
#include "bfin-protos.h"
#include "gt-bfin.h"

#undef REAL_VALUE_ATOF
#define REAL_VALUE_ATOF(v,t) atof(v)

#define SP_SIZE 62

void print_operand (FILE *file,  rtx x,  char code);

char *bfin_ver_str= (char *)
#include "version.h"
extern const char version_string[];
extern rtx *reg_equiv_mem;

rtx bfin_compare_op0, bfin_compare_op1;

/* RTX for condition code flag register and RETS register */
extern GTY(()) rtx bfin_cc_rtx;
extern GTY(()) rtx bfin_rets_rtx;
rtx bfin_cc_rtx, bfin_rets_rtx;

#ifndef assert
#define assert(x) ((x)?0:abort())
#endif

int include_rtm = 0;
int max_arg_registers = 0;

const char *short_reg_names[]  =  SHORT_REGISTER_NAMES;
const char *high_reg_names[]   =  HIGH_REGISTER_NAMES;
const char *dregs_pair_names[] =  DREGS_PAIR_NAMES;
const char *byte_reg_names[]   =  BYTE_REGISTER_NAMES;

int out_bytes = 0;
int out_ind = 0;

void bfin_globalize_label PARAMS ((FILE *, const char *));
void output_file_start PARAMS ((void));

extern int fputs_unlocked (const char *, FILE *);

void
bfin_globalize_label (FILE *stream, const char *name)
{
	fputs (".global ", stream);
        assemble_name (stream, name);
	fputc (';',stream);
        fputc ('\n',stream);
}

static int arg_regs[] = FUNCTION_ARG_REGISTERS;


void 
output_file_start (void) 
{
  FILE *file = asm_out_file;
  int i;

  if (optimize_size)
    fprintf (file, "// gcc version %s bfin version %s opt -Os\n", 
           version_string, bfin_ver_str);
  else
    fprintf (file, "// gcc version %s bfin version %s opt -O%d\n", 
           version_string, bfin_ver_str, optimize);
  fprintf (file, ".file \"%s\";\n", input_filename);
  if (TARGET_SIMPLE_RTM)
    fprintf (file,"\nsimple_rtm:\nl(SP) =0xFFFC; h(SP) =0x4000;\nFP =SP;\ncall _main;\nhlt;\n___main:\n\nrts;\n\n");
  
  for (i = 0; arg_regs[i] >= 0; i++)
      ;
  max_arg_registers = i;	/* how many arg reg used  */
}

static int const_fits_p (rtx expr, int sz, int scale, int issigned)
{
  if (sz < 32) {
    long mask   = (1l<<sz)-1;
    long minint = (-1l<<(sz-1));
    long maxint = (1l<<(sz-1));
    
    long v = INTVAL (expr);
    
    if (scale) {
      long temp = v >> scale;
      /* This is to ensure that constants that are not
         rounded up to the correct bit position
         are not excepted by const_fits.*/
      if (v != (temp << scale))
	return 0;
      v = temp;
    }
    
    return (!issigned && (v & ~mask) == 0)
      || ((minint <= v) && (v < maxint));
  }
  return 1;
}
/*
SECT_NM_T section_names[LAST_SECT_NM] = {
	[CODE_DIR] = {.sect_name = "$code", .dir_name = ".text"},
	[DATA_DIR] = {.sect_name = "$data", .dir_name = ".data"}
};
*/

SECT_NM_T section_names[LAST_SECT_NM] = {
         {".text", "$code"},
         {".data", "$data"}
};

const char * directive_names[LAST_DIR_NM] = {
	".dd", ".dw", ".db", ".space", "\t"};

int bfin_lvno; /* internal labelno for .var/.byte directives */

#define DIR_DEL '/'

/* sect_prefix cannot be a hex number, [Aa-Ff]+ */
const char *sect_prefix = "$";
char *section_asm_op_1 (SECT_ENUM_T dir) {
    const char *dir_nm = section_names[dir].dir_name;
    const char *name = section_names[dir].sect_name ? 
			section_names[dir].sect_name :
			input_filename;
    const char *cp;
    char *s, *sectnm;
    int len, c;

    c = DIR_DEL;
    cp = (char *) strrchr (name, c);
    cp = cp ? cp+1: name;
    
    len = strlen(cp)+1;
    sectnm = (char *) xmalloc (len);

    memcpy (sectnm, cp, len);
    strip_off_ending (sectnm, len);
    s = (char *) xmalloc (len + strlen(dir_nm) + strlen(sect_prefix) + 3);
/*    sprintf (s, "%s %s%s;", dir_nm, sect_prefix, sectnm);  */
    sprintf (s, "%s;", dir_nm); 
    return s;
}

char *section_asm_op (SECT_ENUM_T dir) {
    const char *dir_nm = section_names[dir].dir_name;
    const char *name = section_names[dir].sect_name;
    char *s;
    s = (char *) xmalloc (strlen (name) + strlen(dir_nm) + 3);
/*    sprintf (s, "%s %s;", dir_nm, name);	*/
    sprintf (s, "%s;", dir_nm);
    return s;
}

/* Examine machine-dependent attributes of function FUNDECL and return its
   type.  See the definition of E_FUNKIND.  */

static e_funkind funkind (tree fundecl)
{
  tree attrs = TYPE_ATTRIBUTES (TREE_TYPE (fundecl));
  if (lookup_attribute ("interrupt_handler", attrs))
    return INTERRUPT_HANDLER;
  else if (lookup_attribute ("exception_handler", attrs))
    return EXCPT_HANDLER;
  else if (lookup_attribute ("nmi_handler", attrs))
    return NMI_HANDLER;
  else
    return SUBROUTINE;
}

/* Register Layout.. */
/* Standard register usage.  */
/*
 * CRTM:
 *  marc hoffman  Aug 27,1998
 *
 * Register passing is done in the registers: 
 *            R0-R4.
 *
 *      +------------+	    ^                   FP=P13
 *	|  an	     |	    |			SP=P14
 *	|  ...	     |	    |			GP=P12
 *    	|  a1 	     |	    |
 *	|  a0  	     |	    |
 *	+------------+	    |
 *    	|   return ""ADDR  |	    |
 *     	+------------+	    |
 *  FP->|  OLD FRAME |------+
 *    	+------------+
 *	|  l0  	     |          non-leaf environment
 *	|  l1	     |            prologue:
 *    	|  ....	     |              dm[sp--]       = retaddr;
 *	|  ln  	     |              dm[sp-=size+1] = fp;
 *	+------------+              save r15-dx, p15-px;
 *    	|  spill     |
 *	|	     |            epilogue:
 *	|	     |              load r15-dx, p15-px;
 *    	+------------+              sp=fp;
 *		                    fp = dm[fp];
 *				    retaddr = dm[++sp];
 *                                  ret;
 *
 *
 * This frame layout was considered because, it keeps locals and
 * arguments to functions in the neighboorhood of the frame
 * pointer. close to frame pointer is important when the offset used
 * to access locals is small.
 *
 *
 *      +------------+	                        FP=P13
 *	|  an	     |	     			SP=P14
 *	|  ...	     |	     			GP=P12
 *    	|  a1 	     |
 *	|  a0  	     |
 *	+------------+
 *	|  l0  	     |          leaf environment
 *	|  l1	     |            prologue:
 *    	|  ....	     |              sp -=size;
 *	|  ln  	     |              save r15-dx, p15-px;
 *	+------------+              
 *    	|  spill     |
 *	|	     |            epilogue:
 *	|	     |              load r15-dx, p15-px;
 *    	+------------+		    sp += size;
 *                                  ret;
 *
 *
 */

/* Compute the number of DREGS to save with a push_multiple operation.
   This could include registers that aren't modified in the function,
   since push_multiple only takes a range of registers.  */

static int
n_dregs_to_save (void)
{
  int i;

  for (i = REG_R1; i <= REG_R7; i++)
    if (regs_ever_live[i] && ! call_used_regs[i])
      return REG_R7 - i + 1;
  return 0;
}

/* Like n_dregs_to_save, but compute number of PREGS to save.  */

static int
n_pregs_to_save (void)
{
  int i;

  for (i = REG_P0; i <= REG_P5; i++)
    if (regs_ever_live[i] && ! call_used_regs[i])
      return REG_P5 - i + 1;
  return 0;
}

/* Determine if we are going to save the frame pointer in the prologue.  */

static int
must_save_fp_p (void)
{
  return (frame_pointer_needed || regs_ever_live[REG_FP]);
}

/* Emit code to save registers in the prologue.  SAVEALL is nonzero if we
   must save all registers; this is used for interrupt handlers.
   SPREG contains (reg:SI REG_SP).  */

static void
expand_prologue_reg_save (rtx spreg, int saveall)
{
  int ndregs = saveall ? 8 : n_dregs_to_save ();
  int npregs = saveall ? 6 : n_pregs_to_save ();
  int dregno = REG_R7 + 1 - ndregs;
  int pregno = REG_P5 + 1 - npregs;
  int total = ndregs + npregs;
  int i;
  rtx pat, insn;

  if (total == 0)
    return;

  pat = gen_rtx_PARALLEL (VOIDmode, rtvec_alloc (total + 1));
  XVECEXP (pat, 0, 0) = gen_rtx_SET (VOIDmode, spreg,
				     gen_rtx_PLUS (Pmode, spreg,
						   GEN_INT (-total * 4)));

  for (i = 0; i < total; i++)
    {
      rtx memref = gen_rtx_MEM (word_mode,
				gen_rtx_PLUS (Pmode, spreg,
					      GEN_INT (- i * 4 - 4)));
      if (ndregs > 0)
	{
	  XVECEXP (pat, 0, i + 1)
	    = gen_rtx_SET (VOIDmode, memref, gen_rtx_REG (word_mode,
							  dregno++));
	  ndregs--;
	}
      else
	{
	  XVECEXP (pat, 0, i + 1)
	    = gen_rtx_SET (VOIDmode, memref, gen_rtx_REG (word_mode,
							  pregno++));
	  npregs++;
	}
    }
  insn = emit_insn (pat);
  RTX_FRAME_RELATED_P (insn) = 1;
}

/* Emit code to restore registers in the epilogue.  SAVEALL is nonzero if we
   must save all registers; this is used for interrupt handlers.
   SPREG contains (reg:SI REG_SP).  */

static void
expand_epilogue_reg_restore (rtx spreg, int saveall)
{
  int ndregs = saveall ? 8 : n_dregs_to_save ();
  int npregs = saveall ? 6 : n_pregs_to_save ();
  int total = ndregs + npregs;
  int i, regno;
  rtx pat, insn;

  if (total == 0)
    return;

  pat = gen_rtx_PARALLEL (VOIDmode, rtvec_alloc (total + 1));
  XVECEXP (pat, 0, 0) = gen_rtx_SET (VOIDmode, spreg,
				     gen_rtx_PLUS (Pmode, spreg,
						   GEN_INT (total * 4)));

  if (npregs > 0)
    regno = REG_P5 + 1;
  else
    regno = REG_R7 + 1;

  for (i = 0; i < total; i++)
    {
      rtx addr = (i > 0
		  ? gen_rtx_PLUS (Pmode, spreg, GEN_INT (i * 4))
		  : spreg);
      rtx memref = gen_rtx_MEM (word_mode, addr);

      regno--;
      XVECEXP (pat, 0, i + 1)
	= gen_rtx_SET (VOIDmode, gen_rtx_REG (word_mode, regno), memref);

      if (npregs > 0)
	{
	  if (--npregs == 0)
	    regno = REG_R7 + 1;
	}
    }

  insn = emit_insn (pat);
  RTX_FRAME_RELATED_P (insn) = 1;
}

/* Perform any needed actions needed for a function that is receiving a
   variable number of arguments.

   CUM is as above.

   MODE and TYPE are the mode and type of the current parameter.

   PRETEND_SIZE is a variable that should be set to the amount of stack
   that must be pushed by the prolog to pretend that our caller pushed
   it.

   Normally, this macro will push all remaining incoming registers on the
   stack and set PRETEND_SIZE to the length of the registers pushed.  

   Blackfin specific :
   - VDSP C compiler manual (our ABI) says that a variable args function
     should save the R0, R1 and R2 registers in the stack.
   - The caller will always leave space on the stack for the
     arguments that are passed in registers, so we dont have
     to leave any extra space.
   - now, the vastart pointer can access all arguments from the stack.  */

void
setup_incoming_varargs (CUMULATIVE_ARGS *cum,
			enum machine_mode mode ATTRIBUTE_UNUSED,
			tree type ATTRIBUTE_UNUSED, int *pretend_size,
			int no_rtl)
{
  rtx mem;
  int i;

  if (no_rtl)
    return;

  /* The move for named arguments will be generated automatically by the
     compiler.  We need to generate the move rtx for the unnamed arguments
     if they are in the first 3 words.  We assume atleast 1 named argument
     exists, so we never generate [ARGP] = R0 here.  */

  for (i = cum->words + 1; i < max_arg_registers; i++)
    {
      mem = gen_rtx_MEM (Pmode,
			 plus_constant (arg_pointer_rtx, (i * UNITS_PER_WORD)));
      emit_move_insn (mem, gen_rtx_REG (Pmode, i));
    }

  *pretend_size = 0;
}

/* Implement `va_arg'.  We only need to do something about variable size types,
   which we pass by reference.  */

rtx
bfin_va_arg (tree va_list, tree type)
{
  tree type_ptr;
  tree type_ptr_ptr;
  tree t;

  if (int_size_in_bytes (type) >= 0)
    return std_expand_builtin_va_arg (va_list, type);

  type_ptr     = build_pointer_type (type);
  type_ptr_ptr = build_pointer_type (type_ptr);

  t = build (POSTINCREMENT_EXPR, va_list_type_node, va_list, build_int_2 (UNITS_PER_WORD, 0));
  TREE_SIDE_EFFECTS (t) = 1;
  t = build1 (NOP_EXPR, type_ptr_ptr, t);
  TREE_SIDE_EFFECTS (t) = 1;
  t = build1 (INDIRECT_REF, type_ptr, t);

  return expand_expr (t, NULL_RTX, Pmode, EXPAND_NORMAL);
}

/* Value should be nonzero if functions must have frame pointers.
   Zero means the frame pointer need not be set up (and parms may
   be accessed via the stack pointer) in functions that seem suitable.  */

int
bfin_frame_pointer_required (void) 
{
  e_funkind fkind = funkind (current_function_decl);

  if (TARGET_NON_GNU_PROFILE || fkind != SUBROUTINE)
    return 1;

  /* We turn on on -fomit-frame-pointer if -momit-leaf-frame-pointer is used,
     so we have to override it for non-leaf functions.  */
  if (TARGET_OMIT_LEAF_FRAME_POINTER && ! current_function_is_leaf)
    return 1;

  return 0;
}

/* Return the offset between two registers, one to be eliminated, and the other
   its replacement, at the start of a routine.  */

HOST_WIDE_INT
bfin_initial_elimination_offset (int from, int to)
{
  HOST_WIDE_INT offset = 0;

  if (from == ARG_POINTER_REGNUM)
    offset = to == STACK_POINTER_REGNUM && ! must_save_fp_p () ? 4 : 8;

  if (to == STACK_POINTER_REGNUM)
    {
      if (current_function_outgoing_args_size >= FIXED_STACK_AREA)
	offset += current_function_outgoing_args_size;
      else if (current_function_outgoing_args_size)
	offset += FIXED_STACK_AREA;

      offset += get_frame_size ();
      offset += (n_dregs_to_save () + n_pregs_to_save ()) * 4;
    }
  return offset;
}

/* Generate a LINK insn for a frame sized FRAME_SIZE.  If this constant
   is too large, generate a sequence of insns that has the same effect.
   SPREG contains (reg:SI REG_SP).  */

static void
emit_link_insn (rtx spreg, HOST_WIDE_INT frame_size)
{
  HOST_WIDE_INT link_size = frame_size;
  rtx insn;

  if (link_size > 262140)
    link_size = 262140;

  /* Use a LINK insn with as big a constant as possible, then subtract
     any remaining size from the SP.  */
  insn = emit_insn (gen_link (GEN_INT (link_size)));
  RTX_FRAME_RELATED_P (insn) = 1;
  frame_size -= link_size;

  if (frame_size > 0)
    {
      /* Must use a call-clobbered PREG that isn't the static chain.  */
      rtx tmpreg = gen_rtx_REG (Pmode, REG_P1);
      rtx size = GEN_INT (-frame_size);

      insn = emit_move_insn (tmpreg, size);
      RTX_FRAME_RELATED_P (insn) = 1;

      insn = emit_insn (gen_addsi3 (spreg, spreg, tmpreg));
      RTX_FRAME_RELATED_P (insn) = 1;
    }
}

/* Generate a prologue suitable for a function of kind FKIND.  This is
   called for interrupt and exception handler prologues.
   SPREG contains (reg:SI REG_SP).  */

static void
expand_interrupt_handler_prologue (rtx spreg, e_funkind fkind)
{
  int i;
  HOST_WIDE_INT frame_size = get_frame_size ();
  rtx predec1 = gen_rtx_PRE_DEC (SImode, spreg);
  rtx predec = gen_rtx_MEM (SImode, predec1);
  rtx insn;
  tree attrs = TYPE_ATTRIBUTES (TREE_TYPE (current_function_decl));
  tree all = lookup_attribute ("saveall", attrs);
  tree kspisusp = lookup_attribute ("kspisusp", attrs);

  if (kspisusp)
    {
      insn = emit_move_insn (spreg, gen_rtx_REG (Pmode, REG_USP));
      RTX_FRAME_RELATED_P (insn) = 1;
    }

  /* We need space on the stack in case we need to save the argument
     registers.  */
  if (fkind == EXCPT_HANDLER)
    {
      insn = emit_insn (gen_addsi3 (spreg, spreg, GEN_INT (-12)));
      RTX_FRAME_RELATED_P (insn) = 1;
    }

  emit_link_insn (spreg, frame_size);
  insn = emit_move_insn (predec, gen_rtx_REG (SImode, REG_ASTAT));
  RTX_FRAME_RELATED_P (insn) = 1;

  if (lookup_attribute ("nesting", 
			TYPE_ATTRIBUTES(TREE_TYPE(current_function_decl))))
    {
      rtx srcreg = gen_rtx_REG (Pmode, (fkind == EXCPT_HANDLER ? REG_RETX
					: fkind == NMI_HANDLER ? REG_RETN
					: REG_RETI));
      insn = emit_move_insn (predec, srcreg);
      RTX_FRAME_RELATED_P (insn) = 1;
    }

  expand_prologue_reg_save (spreg, all != NULL_TREE);

  for (i = REG_P7 + 1; i < REG_CC; i++)
    if (all 
	|| regs_ever_live[i]
	|| (!leaf_function_p () && call_used_regs[i]))
      {
	if (i == REG_A0 || i == REG_A1)
	  insn = emit_move_insn (gen_rtx_MEM (PDImode, predec1),
				 gen_rtx_REG (PDImode, i));
	else
	  insn = emit_move_insn (predec, gen_rtx_REG (SImode, i));
	RTX_FRAME_RELATED_P (insn) = 1;
      }

  if (fkind == EXCPT_HANDLER)
    {
      rtx r0reg = gen_rtx_REG (SImode, REG_R0);
      rtx r1reg = gen_rtx_REG (SImode, REG_R1);
      rtx r2reg = gen_rtx_REG (SImode, REG_R2);
      rtx insn;

      insn = emit_move_insn (r0reg, gen_rtx_REG (SImode, REG_SEQSTAT));
      REG_NOTES (insn) = gen_rtx_EXPR_LIST (REG_MAYBE_DEAD, const0_rtx,
					    NULL_RTX);
      insn = emit_insn (gen_ashrsi3 (r0reg, r0reg, GEN_INT (26)));
      REG_NOTES (insn) = gen_rtx_EXPR_LIST (REG_MAYBE_DEAD, const0_rtx,
					    NULL_RTX);
      insn = emit_insn (gen_ashlsi3 (r0reg, r0reg, GEN_INT (26)));
      REG_NOTES (insn) = gen_rtx_EXPR_LIST (REG_MAYBE_DEAD, const0_rtx,
					    NULL_RTX);
      insn = emit_move_insn (r1reg, spreg);
      REG_NOTES (insn) = gen_rtx_EXPR_LIST (REG_MAYBE_DEAD, const0_rtx,
					    NULL_RTX);
      insn = emit_move_insn (r2reg, gen_rtx_REG (Pmode, REG_FP));
      REG_NOTES (insn) = gen_rtx_EXPR_LIST (REG_MAYBE_DEAD, const0_rtx,
					    NULL_RTX);
      insn = emit_insn (gen_addsi3 (r2reg, r2reg, GEN_INT (8)));
      REG_NOTES (insn) = gen_rtx_EXPR_LIST (REG_MAYBE_DEAD, const0_rtx,
					    NULL_RTX);
    }
}

/* Generate an epilogue suitable for a function of kind FKIND.  This is
   called for interrupt and exception handler epilogues.
   SPREG contains (reg:SI REG_SP).  */

static void
expand_interrupt_handler_epilogue (rtx spreg, e_funkind fkind) 
{
  int i;
  rtx postinc1 = gen_rtx_POST_INC (SImode, spreg);
  rtx postinc = gen_rtx_MEM (SImode, postinc1);
  tree attrs = TYPE_ATTRIBUTES (TREE_TYPE (current_function_decl));
  tree all = lookup_attribute ("saveall", attrs);

  /* A slightly crude technique to stop flow from trying to delete "dead"
     insns.  */
  MEM_VOLATILE_P (postinc) = 1;

  for (i = REG_CC - 1; i > REG_P7; i--)
    if (all
	|| regs_ever_live[i] 
	|| (!leaf_function_p () && call_used_regs[i]))
      {
	if (i == REG_A0 || i == REG_A1)
	  emit_move_insn (gen_rtx_REG (PDImode, i),
			  gen_rtx_MEM (PDImode, postinc1));
	else
	  emit_move_insn (gen_rtx_REG (SImode, i), postinc);
      }

  expand_epilogue_reg_restore (spreg, all != NULL_TREE);

  if (lookup_attribute ("nesting",
			TYPE_ATTRIBUTES(TREE_TYPE(current_function_decl))))
    {
      rtx srcreg = gen_rtx_REG (Pmode, (fkind == EXCPT_HANDLER ? REG_RETX
					: fkind == NMI_HANDLER ? REG_RETN
					: REG_RETI));
      emit_move_insn (srcreg, postinc);
    }

  emit_move_insn (gen_rtx_REG (SImode, REG_ASTAT), postinc);
  emit_insn (gen_unlink ());

  /* Deallocate any space we left on the stack in case we needed to save the
     argument registers.  */
  if (fkind == EXCPT_HANDLER)
    emit_insn (gen_addsi3 (spreg, spreg, GEN_INT (12)));

  emit_jump_insn (gen_return_internal (GEN_INT (fkind)));
}

/* Generate efficient code to add a value to the frame pointer.  We
   can use P1 as a scratch register.  Set RTX_FRAME_RELATED_P on the
   generated insns if FRAME is nonzero.  */

static void
add_to_sp (rtx spreg, HOST_WIDE_INT value, int frame)
{
  if (value == 0)
    return;

  /* Choose whether to use a sequence using a temporary register, or
     a sequence with multiple adds.  We can add a signed 7 bit value
     in one instruction.  */
  if (value > 120 || value < -124)
    {
      rtx tmpreg = gen_rtx_REG (SImode, REG_P1);
      rtx insn;

      insn = emit_move_insn (tmpreg, GEN_INT (value));
      if (frame)
	RTX_FRAME_RELATED_P (insn) = 1;
      insn = emit_insn (gen_addsi3 (spreg, spreg, tmpreg));
      if (frame)
	RTX_FRAME_RELATED_P (insn) = 1;
    }
  else
      do 
	{
	  int size = value;
	  rtx insn;

	  if (size > 60)
	    size = 60;
	  else if (size < -62)
	    size = -62;

	  insn = emit_insn (gen_addsi3 (spreg, spreg, GEN_INT (size)));
	  if (frame)
	    RTX_FRAME_RELATED_P (insn) = 1;
	  value -= size;
	}
      while (value != 0);
}

/* Generate RTL for the prologue of the current function.  */

void
bfin_expand_prologue (void)
{
  rtx insn;
  HOST_WIDE_INT arg_size;
  HOST_WIDE_INT frame_size = get_frame_size ();
  int is_leaf_function = leaf_function_p ();
  rtx spreg = gen_rtx_REG (Pmode, REG_SP);
  e_funkind fkind = funkind (current_function_decl);

  if (fkind != SUBROUTINE) {
    expand_interrupt_handler_prologue (spreg, fkind);
    return;
  }

  if (! must_save_fp_p ())
    {
      rtx pat = gen_movsi (gen_rtx_MEM (Pmode,
					gen_rtx_PRE_DEC (Pmode, spreg)),
			   bfin_rets_rtx);
      insn = emit_insn (pat);
      RTX_FRAME_RELATED_P (insn) = 1;
      add_to_sp (spreg, -frame_size, 1);
    }
  else
    emit_link_insn (spreg, frame_size);

#if 0
  if (TARGET_NON_GNU_PROFILE)
    fprintf (file, "\tcall mcount_entry;\n");
#endif

  expand_prologue_reg_save (spreg, 0);

  if (current_function_outgoing_args_size)
    {
      if (current_function_outgoing_args_size >= FIXED_STACK_AREA)
	arg_size = current_function_outgoing_args_size;
      else
	arg_size = FIXED_STACK_AREA;

      add_to_sp (spreg, -arg_size, 1);
    }
}

/* Generate RTL for the epilogue of the current function.  */

void
bfin_expand_epilogue (void)
{
  rtx spreg = gen_rtx_REG (Pmode, REG_SP);
  e_funkind fkind = funkind (current_function_decl);

  if (fkind != SUBROUTINE)
    {
      expand_interrupt_handler_epilogue (spreg, fkind);
      return;
    }

  if (current_function_outgoing_args_size)
    {
      HOST_WIDE_INT arg_size;
      if (current_function_outgoing_args_size >= FIXED_STACK_AREA)
	arg_size = current_function_outgoing_args_size;
      else
	arg_size = FIXED_STACK_AREA;

      add_to_sp (spreg, arg_size, 0);
    }


  expand_epilogue_reg_restore (spreg, 0);
#if 0
  if (TARGET_NON_GNU_PROFILE)
    fprintf (file, "\tcall mcount_exit;\n");
#endif

  if (! frame_pointer_needed)
    {
      rtx postinc = gen_rtx_MEM (Pmode, gen_rtx_POST_INC (Pmode, spreg));
      HOST_WIDE_INT frame_size = get_frame_size ();
      add_to_sp (spreg, frame_size, 0);
      if (must_save_fp_p ())
	{
	  rtx fpreg = gen_rtx_REG (Pmode, REG_FP);
	  emit_move_insn (fpreg, postinc);
	  emit_insn (gen_rtx_USE (VOIDmode, fpreg));
	}
      emit_move_insn (bfin_rets_rtx, postinc);
      emit_insn (gen_rtx_USE (VOIDmode, bfin_rets_rtx));
    }
  else
    emit_insn (gen_unlink ());

  emit_jump_insn (gen_return_internal (GEN_INT (SUBROUTINE)));
}

rtx
legitimize_address (rtx x ATTRIBUTE_UNUSED, rtx oldx ATTRIBUTE_UNUSED, enum machine_mode mode ATTRIBUTE_UNUSED)
{
  return NULL_RTX;
}

#if 0
int 
go_if_legitimate_address (enum machine_mode mode, rtx x, int strict_p)
{

  
  switch (GET_CODE (x)) {
  case REG:
    return REGNO_OK_FOR_BASE_P (REGNO (x));

  case PLUS:
    return (REG_P (XEXP (x, 0))
	    && (REG_P (XEXP (x, 1))
		|| CONSTANT_P (XEXP (x, 1))));


#ifdef HAVE_POST_INCREMENT
  case POST_INC:
    if (register_operand (XEXP (x, 0), Pmode)
	&& (strict_p ? REG_OK_FOR_BASE_P (XEXP (x, 0)) : 1))
      return 1;
#endif

#ifdef HAVE_PRE_DECREMENT
  case PRE_DEC:
    if (register_operand (XEXP (x, 0), Pmode)
	&& (strict_p ? REG_OK_FOR_BASE_P (XEXP (x, 0)) : 1))
      return 1;
#endif

  }
  return 0;
}
#endif

/*
  This predicate is used to compute the lenght of a 
  load/store instruction.
  The placement of this code next go_if_legitimate_address
  is for helping the maintability of the routine.
*/
int effective_address_32bit_p (rtx op, enum machine_mode mode) 
{
  op = XEXP (op, 0);
  switch (GET_CODE (op))
    {
    case REG:
    case PRE_DEC:
    case POST_INC:
      return 0;
    case PLUS:
      if (XEXP (op,0) == frame_pointer_rtx)
	if (GET_MODE_SIZE (mode) == 4
	    && const_fits_p (XEXP (op,1), 6, 2, 1))
	  return 0;
	else
	  return 1;
      else
	if (GET_MODE_SIZE (mode) == 4
	    && const_fits_p (XEXP (op,1), 4, 2, 1))
	  return 0;
	else if (GET_MODE_SIZE (mode) == 2
		 && const_fits_p (XEXP (op,1), 4, 1, 1))
	  return 0;
	else
	  return 1;
    default:
      return 1;
    }
}

/* Returns 1 if OP is a symbolic operand, i.e. a symbol_ref or a label_ref,
   possibly with an offset.  */

int
symbolic_operand (rtx op, enum machine_mode mode)
{
  if (mode != VOIDmode && GET_MODE (op) != VOIDmode && mode != GET_MODE (op))
    return 0;
  if (GET_CODE (op) == SYMBOL_REF || GET_CODE (op) == LABEL_REF)
    return 1;
  if (GET_CODE (op) == CONST
      && GET_CODE (XEXP (op,0)) == PLUS
      && GET_CODE (XEXP (XEXP (op,0), 0)) == SYMBOL_REF
      && GET_CODE (XEXP (XEXP (op,0), 1)) == CONST_INT)
    return 1;
  return 0;
}

int symbolic_or_const_operand_p (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) 
{
  switch (GET_CODE (op)) {
  case SYMBOL_REF:
  case LABEL_REF:
  case CONST_INT:
  case CONST_DOUBLE:
    return 1;
  case CONST:
    op = XEXP (op, 0);
    return ((GET_CODE (XEXP (op, 0)) == SYMBOL_REF
	     || GET_CODE (XEXP (op, 0)) == LABEL_REF)
	    && GET_CODE (XEXP (op, 1)) == CONST_INT);
  default:
    return 0;
  }
}

int imm7bit_operand_p (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) 
{
  return GET_CODE (op) == CONST_INT && CONST_7BIT_IMM_P (INTVAL (op));
}

int imm16bit_operand_p (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) 
{
  return GET_CODE (op) == CONST_INT && CONST_16BIT_IMM_P (INTVAL (op));
}

int
bfin_address_cost (rtx addr)
{
  return 1;
}

void
print_address_operand (FILE *file, rtx x)
{
  if (GET_CODE (x) == MEM) 
	x = XEXP (x,0);
  switch (GET_CODE (x)) {
  case PLUS:
    output_address (XEXP (x, 0));
    fprintf (file, "+");
    output_address (XEXP (x, 1));
    break;

  case PRE_DEC:
    fprintf (file, "--");
    output_address (XEXP (x, 0));    
    break;
  case POST_INC:
    output_address (XEXP (x, 0));
    fprintf (file, "++");
    break;
  case POST_DEC:
    output_address (XEXP (x, 0));
    fprintf (file, "--");
    break;

  default:
    print_operand (file, x, 0);
  }
}

/* Adding intp DImode support by Tony
 * -- Q: (low  word)
 * -- R: (high word)
 */

void print_operand (FILE *file,  rtx x,  char code)
{
  enum machine_mode mode = GET_MODE(x);

  switch (code) {
  case 'j':
    switch (GET_CODE (x)) {
      case EQ:	fprintf (file, "e");	break;
      case NE:	fprintf (file, "ne");	break;
      case GT:	fprintf (file, "g");	break;
      case LT:	fprintf (file, "l");	break;
      case GE:	fprintf (file, "ge");	break;
      case LE:	fprintf (file, "le");	break;
      case GTU:	fprintf (file, "g");	break;
      case LTU:	fprintf (file, "l");	break;
      case GEU:	fprintf (file, "ge");	break;
      case LEU:	fprintf (file, "le");	break;
      default:
	output_operand_lossage ("invalid %%j value");
      }
    break;
    
  case 'J':					 /* reverse logic */
    switch (GET_CODE(x)) {
      case EQ:	fprintf (file, "ne");	break;
      case NE:	fprintf (file, "e");	break;
      case GT:	fprintf (file, "le");	break;
      case LT:	fprintf (file, "ge");	break;
      case GE:	fprintf (file, "l");	break;
      case LE:	fprintf (file, "g");	break;
      case GTU:	fprintf (file, "le");	break;
      case LTU:	fprintf (file, "ge");	break;
      case GEU:	fprintf (file, "l");	break;
      case LEU:	fprintf (file, "g");	break;
      default:
	output_operand_lossage("invalid %%J value");
      }
    break;

  default:
    switch (GET_CODE (x)) {
    case REG:
      if (code == 'h') {
	assert ((REGNO (x) < 32));
	fprintf (file, "%s", short_reg_names[REGNO(x)]);
	/*fprintf (file, "\n%d\n ", REGNO(x));*/
	break;
      }
      else if (code == 'd') {
	assert ((REGNO (x) < 32));
	fprintf (file, "%s", high_reg_names[REGNO(x)]);
	break;
      }
      else if (code == 'w') {
	assert (REGNO (x) == REG_A0 || REGNO (x) == REG_A1);
	fprintf (file, "%s.w", reg_names[REGNO(x)]);
      }
      else if (code == 'x') {
	assert (REGNO (x) == REG_A0 || REGNO (x) == REG_A1);
	fprintf (file, "%s.x", reg_names[REGNO(x)]);
      }
      else if (code == 'D') {
	fprintf (file, "%s", dregs_pair_names[REGNO(x)]);
      }
      /* Write second word of DImode or DFmode reference, 
       * register or memory. -- Tony
       */
      else if (code == 'H') {
        assert (mode == DImode || mode == DFmode);
	if (GET_CODE(x) == REG)
	   fprintf (file, "%s", reg_names[REGNO(x)+1]);
	else if (GET_CODE(x) == MEM)
	  {
	    fputc ('[', file);
	    /* Handle possible auto-increment.  Since it is pre-increment and
               we have already done it, we can just use an offset of four.  */ 
	    if (GET_CODE (XEXP (x, 0)) == PRE_INC
                || GET_CODE (XEXP (x, 0)) == PRE_DEC)
               output_address (plus_constant (XEXP (XEXP (x, 0), 0), 4));
            else
               output_address (plus_constant (XEXP (x, 0), 4));
            fputc (']', file);
	 }

      }
      else if (code == 'Q') {
        /*assert (mode == DImode);*/
        if (REGNO(x) > 7)
            abort();
        fprintf(file,"%s", reg_names[REGNO(x)]);
      }
      else if (code == 'R') {
        /*assert (mode == DImode);*/
        if (REGNO(x) > 7)
            abort();
        fprintf(file,"%s", reg_names[REGNO(x)+1]);
      }
      else if (code == 'T') {
        /*Byte mode selection Akbar Hussain Oct. 02 2001*/
        if (REGNO(x) > 7)
            abort();
        fprintf(file,"%s", byte_reg_names[REGNO(x)]);
      }
      else 
	fprintf (file, "%s", reg_names[REGNO(x)]);
      break;

    case MEM:
      fputc ('[', file);
      x = XEXP (x,0);
      print_address_operand (file, x);
      fputc (']', file);
      break;
    
    case CONST_INT:
      if (code == 'X') {
	x = GEN_INT (exact_log2 (INTVAL (x)));
      } else if (code == 'Y') {
	x = GEN_INT (exact_log2 (~INTVAL (x)));
      }
    case SYMBOL_REF:
      output_addr_const(file, x);
      break;
    case CONST_DOUBLE:
      output_operand_lossage ("invalid const_double operand");
      break;
    default:
      output_addr_const(file, x);
    }
  }
}


int extract_const_double (rtx x)
{
  if (GET_CODE (x) == CONST_DOUBLE && GET_MODE(x) != DImode)
  {
    union { double d; int    i[2]; } u;
    union { float f; int i; } u1;

      if ( GET_MODE(x) == VOIDmode)
        {
          u.i[0] = CONST_DOUBLE_LOW (x);
          u.i[1] = CONST_DOUBLE_HIGH (x);
        }
      else
        {
	  long l[2];
      	  REAL_VALUE_TYPE rv;
          int endian = (WORDS_BIG_ENDIAN == 0);
	  REAL_VALUE_FROM_CONST_DOUBLE (rv, x);
          REAL_VALUE_TO_TARGET_DOUBLE (rv, l);
          u.i[0] = l[1 - endian];
          u.i[1] = l[endian];
        }
    u1.f = u.d;
    return u1.i;
  } 
  else 
    output_operand_lossage ("unsupported mode DI");
  return 0;
}
	

int
signed_comparison_operator (rtx op, enum machine_mode mode)
{
  switch (GET_CODE(op))
    {
    case LEU:
    case LTU:
    case GTU:
    case GEU:
      return 0;
    default:
      return comparison_operator (op, mode);
    }
    return 0;
}

/* Argument support functions.  */

/* Initialize a variable CUM of type CUMULATIVE_ARGS
   for a call to a function whose data type is FNTYPE.
   For a library call, FNTYPE is 0.  
   VDSP C Compiler manual, our ABI says that
   first 3 words of arguments will use R0, R1 and R2.
*/

void
init_cumulative_args (CUMULATIVE_ARGS *cum, tree fntype ATTRIBUTE_UNUSED,
		      rtx libname ATTRIBUTE_UNUSED)
{
  static CUMULATIVE_ARGS zero_cum;

  *cum = zero_cum;

  /* Set up the number of registers to use for passing arguments.  */

  cum->nregs = max_arg_registers;
  cum->arg_regs = arg_regs;


  return;
}

/* Update the data in CUM to advance over an argument
   of mode MODE and data type TYPE.
   (TYPE is null for libcalls where that information may not be available.)  */

void
function_arg_advance (CUMULATIVE_ARGS *cum, enum machine_mode mode, tree type,
		      int named ATTRIBUTE_UNUSED)
{
  int count, bytes, words;

  bytes = (mode == BLKmode) ? int_size_in_bytes (type) : GET_MODE_SIZE (mode);
  words = (bytes + UNITS_PER_WORD - 1) / UNITS_PER_WORD;

  cum->words += words;
  cum->nregs -= words;

  if (cum->nregs <= 0) {
      cum->nregs = 0;
      cum->arg_regs = NULL;
  }
  else {
      for (count = 1; count <= words; count++)
        cum->arg_regs++;
  }

  return;
}

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

struct rtx_def *
function_arg (CUMULATIVE_ARGS *cum, enum machine_mode mode, tree type,
	      int named ATTRIBUTE_UNUSED)
{
  int bytes
    = (mode == BLKmode) ? int_size_in_bytes (type) : GET_MODE_SIZE (mode);
  int words = (bytes + UNITS_PER_WORD - 1) / UNITS_PER_WORD;

  if (bytes == -1)
    return NULL_RTX;

  if (cum->nregs)
    return gen_rtx (REG, mode, *(cum->arg_regs));

  return NULL_RTX;
}

/* For an arg passed partly in registers and partly in memory,
   this is the number of registers used.
   For args passed entirely in registers or entirely in memory, zero.  
   Refer VDSP C Compiler manual, our ABI.
   First 3 words are in registers. So, if a an argument is larger
   than the registers available, it will span the register and
   stack. 
*/

int
function_arg_partial_nregs (CUMULATIVE_ARGS *cum ,	/* current arg information */
			     enum machine_mode mode ,	/* current arg mode */
			     tree type ATTRIBUTE_UNUSED,		/* type of the argument or 0 if lib support */
			     int named	 ATTRIBUTE_UNUSED		/* != 0 for normal args, == 0 for ... args */)
{
  int bytes
    = (mode == BLKmode) ? int_size_in_bytes (type) : GET_MODE_SIZE (mode);
  int words = (bytes + UNITS_PER_WORD - 1) / UNITS_PER_WORD;
  int arg_num = *cum->arg_regs;
  int ret, last_reg_num;

  if (bytes == -1)
    return 0;
  
  last_reg_num = max_arg_registers - 1;
  ret = ((arg_num <= last_reg_num && 
         ((arg_num + words) > (last_reg_num + 1)))
         ? last_reg_num - arg_num + 1
         : 0);

  return ret;
}


int 
function_arg_regno_p(int n)
{
  int i;
  for (i = 0; arg_regs[i] != -1; i++)
    if (n == arg_regs[i])
      return 1;
  return 0;
}


/* Returns 1 if OP contains a symbol reference */

int
symbolic_reference_mentioned_p (rtx op)
{
  register const char *fmt;
  register int i;

  if (GET_CODE (op) == SYMBOL_REF || GET_CODE (op) == LABEL_REF)
    return 1;

  fmt = GET_RTX_FORMAT (GET_CODE (op));
  for (i = GET_RTX_LENGTH (GET_CODE (op)) - 1; i >= 0; i--)
    {
      if (fmt[i] == 'E')
	{
	  register int j;

	  for (j = XVECLEN (op, i) - 1; j >= 0; j--)
	    if (symbolic_reference_mentioned_p (XVECEXP (op, i, j)))
	      return 1;
	}

      else if (fmt[i] == 'e' && symbolic_reference_mentioned_p (XEXP (op, i)))
	return 1;
    }

  return 0;
}

void
initialize_trampoline (tramp, fnaddr, cxt)
     rtx tramp, fnaddr, cxt;
{
  rtx t1 = copy_to_reg (fnaddr);
  rtx t2 = copy_to_reg (cxt);
  rtx addr;

  addr = memory_address (Pmode, plus_constant (tramp, 2));
  emit_move_insn (gen_rtx_MEM (HImode, addr), gen_lowpart (HImode, t1));
  emit_insn (gen_ashrsi3 (t1, t1, GEN_INT (16)));
  addr = memory_address (Pmode, plus_constant (tramp, 6));
  emit_move_insn (gen_rtx_MEM (HImode, addr), gen_lowpart (HImode, t1));

  addr = memory_address (Pmode, plus_constant (tramp, 10));
  emit_move_insn (gen_rtx_MEM (HImode, addr), gen_lowpart (HImode, t2));
  emit_insn (gen_ashrsi3 (t2, t2, GEN_INT (16)));
  addr = memory_address (Pmode, plus_constant (tramp, 14));
  emit_move_insn (gen_rtx_MEM (HImode, addr), gen_lowpart (HImode, t2));
}

/* Return a legitimate reference for ORIG (an address) using the
   register REG.  If REG is 0, a new pseudo is generated.

   There are three types of references that must be handled:

   1. Global data references must load the address from the GOT, via
      the PIC reg.  An insn is emitted to do this load, and the reg is
      returned.

   2. Static data references must compute the address as an offset
      from the GOT, whose base is in the PIC reg.  An insn is emitted to
      compute the address into a reg, and the reg is returned.  Static
      data objects have SYMBOL_REF_FLAG set to differentiate them from
      global data objects.

   3. Constant pool addresses must be handled special.  They are
      considered legitimate addresses, but only if not used with regs.
      When printed, the output routines know to print the reference with the
      PIC reg, even though the PIC reg doesn't appear in the RTL.

   GO_IF_LEGITIMATE_ADDRESS rejects symbolic references unless the PIC
   reg also appears in the address (except for constant pool references,
   noted above).

   "switch" statements also require special handling when generating
   PIC code.  See comments by the `casesi' insn in i386.md for details.  */

rtx
legitimize_pic_address (rtx orig, rtx reg)
{
  rtx addr = orig;
  rtx new = orig;

  if (GET_CODE (addr) == SYMBOL_REF || GET_CODE (addr) == LABEL_REF)
    {
      if (GET_CODE (addr) == SYMBOL_REF && CONSTANT_POOL_ADDRESS_P (addr))
	reg = new = orig;
      else
	{
	  if (reg == 0)
	    reg = gen_reg_rtx (Pmode);

	  if ((GET_CODE (addr) == SYMBOL_REF && SYMBOL_REF_FLAG (addr))
	      || GET_CODE (addr) == LABEL_REF)
	    new = gen_rtx (PLUS, Pmode, pic_offset_table_rtx, orig);
	  else
	    new = gen_rtx (MEM, Pmode,
			   gen_rtx (PLUS, Pmode, pic_offset_table_rtx, orig));
	  emit_move_insn (reg, new);
	}
      current_function_uses_pic_offset_table = 1;
      return reg;
    }

  else if (GET_CODE (addr) == CONST || GET_CODE (addr) == PLUS)
    {
      rtx base;

      if (GET_CODE (addr) == CONST)
	{
	  addr = XEXP (addr, 0);
	  if (GET_CODE (addr) != PLUS)
	    abort ();
	}

      if (XEXP (addr, 0) == pic_offset_table_rtx)
	return orig;

      if (reg == 0)
	reg = gen_reg_rtx (Pmode);

      base = legitimize_pic_address (XEXP (addr, 0), reg);
      addr = legitimize_pic_address (XEXP (addr, 1),
				     base == reg ? NULL_RTX : reg);

      if (GET_CODE (addr) == CONST_INT)
	return plus_constant (base, INTVAL (addr));

      if (GET_CODE (addr) == PLUS && CONSTANT_P (XEXP (addr, 1)))
	{
	  base = gen_rtx (PLUS, Pmode, base, XEXP (addr, 0));
	  addr = XEXP (addr, 1);
	}

      return gen_rtx (PLUS, Pmode, base, addr);
    }

  return new;
}

/* Emit insns to move operands[1] into operands[0].  */

void
emit_pic_move (rtx *operands, enum machine_mode mode ATTRIBUTE_UNUSED)
{
  rtx temp = reload_in_progress ? operands[0] : gen_reg_rtx (Pmode);

  if (GET_CODE (operands[0]) == MEM && SYMBOLIC_CONST (operands[1]))
    operands[1] = force_reg (SImode, operands[1]);
  else
    operands[1] = legitimize_pic_address (operands[1], temp);
}

void
expand_move (rtx *operands, enum machine_mode mode)
{
  extern int flag_pic;
  
  if (flag_pic && SYMBOLIC_CONST (operands[1]))
    emit_pic_move (operands, mode);

  /* Don't generate memory->memory moves, go through a register */
  else if (TARGET_MOVE
	   && (reload_in_progress | reload_completed) == 0
	   && GET_CODE (operands[0]) == MEM)
/*	   && GET_CODE (operands[1]) == MEM)  */
/* For we don't have: mem = const             */
    {
      operands[1] = force_reg (mode, operands[1]);
    }
}

int
log2constp (unsigned HOST_WIDE_INT c)
{
  return c != 0 && (c & (c-1)) == 0;
}

int
ccregister_p (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) {
  debug_rtx (op);
  printf ("\n");
  return 1;
}

void 
conditional_register_usage (void)
{
  /* initialize condition code flag register rtx */
  bfin_cc_rtx = gen_rtx_REG (BImode, REG_CC);
  bfin_rets_rtx = gen_rtx_REG (Pmode, REG_RETS);
}

#if 0
int
backward_reference (rtx jump) 
{
  rtx insn;
  int lab_ref_num;

  if (JUMP_INSN != GET_CODE(jump))
      abort();

  lab_ref_num = CODE_LABEL_NUMBER (JUMP_LABEL (jump));
  for (insn = PREV_INSN(jump); ; insn = PREV_INSN(insn)) {
    if (CODE_LABEL == GET_CODE (insn)) {
      if (CODE_LABEL_NUMBER (insn) >= lab_ref_num)
	return 1;
      else
	return 0;
    }
  }
}
#endif

int scale_operand (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) {
  if (GET_CODE(op) == CONST_INT) {
    int iv = INTVAL (op);
    return (iv == 2 || iv == 1 || iv == -2 || iv == -1);
  }
  return 0;
}

int pos_scale_operand (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) {
  if (GET_CODE(op) == CONST_INT) {
    int iv = INTVAL (op);
    return (iv == 2 || iv == 1);
  }
  return 0;
}

int scale_by_operand (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) {
  if (GET_CODE(op) == CONST_INT) {
    int iv = INTVAL (op);
    return (iv == 4 || iv == 2);
  }
  return 0;
}

int reg_or_scale_operand (rtx op, enum machine_mode mode) {
  if (GET_CODE(op) == CONST_INT) {
    int iv = INTVAL (op);
    return (iv == 4 || iv == 2);
  }
  return register_operand (op, mode);
}


int log2_operand (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) {
  if (GET_CODE(op) == CONST_INT) {
    return log2constp (INTVAL (op));
  }
  return 0;
}

int 
regorbitclr_operand (rtx op, enum machine_mode mode) {
  if (GET_CODE(op) == CONST_INT) {
    return log2constp (~(INTVAL (op)));
  }
  return register_operand (op, mode);
}

int highbits_operand (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) {
  if (GET_CODE(op) == CONST_INT) {
    return (log2constp (-INTVAL (op)) && !CONST_7BIT_IMM_P (INTVAL (op)));
  }
  return 0;
}

int
rhs_andsi3_operand (rtx op, enum machine_mode mode)
{
  HOST_WIDE_INT value;

  if (register_operand (op, mode))
    return 1;
  if (GET_CODE (op) != CONST_INT)
    return 0;

  value = INTVAL (op);
  return log2constp (~value) || value == 255 || value == 65535 || value == 1;
}

int regorlog2_operand (rtx op, enum machine_mode mode) {
  if (GET_CODE(op) == CONST_INT) {
    return log2constp (INTVAL (op));
  }
  return register_operand (op, mode);
}

/* Like register_operand, but make sure that hard regs have a valid mode.  */
int 
valid_reg_operand (rtx op, enum machine_mode mode)
{
  if (! register_operand (op, mode))
    return 0;
  if (REG_P (op) && REGNO (op) < FIRST_PSEUDO_REGISTER)
    return HARD_REGNO_MODE_OK (REGNO (op), mode);
  return 1;
}
  
int
cc_operand (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED)
{
  return REG_P (op) && REGNO (op) == REG_CC && GET_MODE (op) == BImode;
}

int reg_or_7bit_operand (rtx op, enum machine_mode mode) {
    return (imm7bit_operand_p (op, mode) || register_operand (op, mode));
}

int reg_or_16bit_operand (rtx op, enum machine_mode mode) {
    return (imm16bit_operand_p (op, mode) || register_operand (op, mode));
}

int
positive_immediate_operand (rtx op, enum machine_mode mode)
{
  return GET_CODE (op) == CONST_INT && INTVAL (op) >= 0;
}

void
asm_output_skip (FILE *file, int size) {
    if (!TARGET_ASM_DIR) {					
	fprintf (file, "\t%s\t%u\n", ASM_SPACE, size);
    } else {							
	char __buf[256];
	fprintf (file, "%s ", ASM_BYTE);
	sprintf (__buf, "LV$%d", bfin_lvno++);
	fprintf(file, " %s[%d];\n", __buf, size);
    }							
}

void
asm_output_ascii (FILE *file, const char *str, int sz) {
    int jk = 0;

    while (jk < sz) {
         if (jk+2 < sz){
           fprintf (file, "%s%s0x%02x%02x;\n", ASM_SHORT, ASM_INIT,
                    (unsigned char)str[jk+1], (unsigned char)str[jk]);
	   jk+=2;
         }
         else {
           fprintf (file, "%s%s0x%02x;\n", ASM_BYTE, ASM_INIT, (unsigned char)str[jk]);
           jk+=1;
         }
    }
}

/* Split one or more DImode RTL references into pairs of SImode
   references.  The RTL can be REG, offsettable MEM, integer constant, or
   CONST_DOUBLE.  "operands" is a pointer to an array of DImode RTL to
   split and "num" is its length.  lo_half and hi_half are output arrays
   that parallel "operands".  */

void
split_di (rtx operands[], int num, rtx lo_half[], rtx hi_half[])
{
  while (num--)
    {
      rtx op = operands[num];

      /* simplify_subreg refuse to split volatile memory addresses,
         but we still have to handle it.  */
      if (GET_CODE (op) == MEM)
	{
	  lo_half[num] = adjust_address (op, SImode, 0);
	  hi_half[num] = adjust_address (op, SImode, 4);
	}
      else
	{
	  lo_half[num] = simplify_gen_subreg (SImode, op,
					      GET_MODE (op) == VOIDmode
					      ? DImode : GET_MODE (op), 0);
	  hi_half[num] = simplify_gen_subreg (SImode, op,
					      GET_MODE (op) == VOIDmode
					      ? DImode : GET_MODE (op), 4);
	}
    }
}

int
hard_regno_mode_ok (int regno, enum machine_mode mode)
{
  /* Allow only dregs to store value of mode HI or QI */
  enum reg_class class = REGNO_REG_CLASS (regno);

  if (mode == CCmode)
    return 0;

  if (class == CCREGS)
    return mode == BImode;
  if (mode == PDImode)
    return regno == REG_A0 || regno == REG_A1;
  return TEST_HARD_REG_BIT (reg_class_contents[MOST_REGS], regno);
}

/* Returns 1 if OP is either the constant zero or a register.  If a
   register, it must be in the proper mode unless MODE is VOIDmode.  */
 
int
reg_or_0_operand (rtx op, enum machine_mode mode) {
  return op == const0_rtx || register_operand (op, mode);
}

/* Used for secondary reloads, this function returns 1 if OP is of the
   form (plus (fp) (const_int)), where CONST_INT can't be added in one
   instruction.  */

int
fp_plus_const_operand (rtx op, enum machine_mode mode)
{
  rtx op1, op2;
  if (GET_CODE (op) != PLUS)
    return 0;
  op1 = XEXP (op, 0);
  op2 = XEXP (op, 1);
  return (REG_P (op1)
	  && (REGNO (op1) == FRAME_POINTER_REGNUM
	      || REGNO (op1) == STACK_POINTER_REGNUM)
	  && GET_CODE (op2) == CONST_INT && ! imm7bit_operand_p (op2, mode));
}

#undef MAX_COST
#define MAX_COST 100

int
register_move_cost(enum reg_class class1, enum reg_class class2)
{
  return 
    ((!reg_class_subset_p (class1, DPREGS) && 
      reg_class_subset_p (class2, DPREGS)) || 
     (reg_class_subset_p (class1, DPREGS) && 
      !reg_class_subset_p (class2, DPREGS)))
    ? 2*MAX_COST
    : ((class1==DREGS && class2==PREGS) || 
       (class1==PREGS && class2==DREGS))
      ? 2*2
      : 2;
}

enum reg_class
secondary_input_reload_class(enum reg_class class,enum machine_mode mode, rtx x)
{
  /* If we have HImode or QImode, we can only use DREGS as secondary registers;
     in most other cases we can also use PREGS.  */
  enum reg_class default_class = GET_MODE_SIZE (mode) >= 4 ? DPREGS : DREGS;
  enum reg_class x_class = NO_REGS;
  enum rtx_code code = GET_CODE (x);

  if (code == SUBREG)
    x = SUBREG_REG (x), code = GET_CODE (x);
  if (REG_P (x))
    {
      int regno = REGNO (x);
      if (regno >= FIRST_PSEUDO_REGISTER)
	regno = reg_renumber[regno];

      if (regno == -1)
	code = MEM;
      else
	x_class = REGNO_REG_CLASS (regno);
    }

  /* We can be asked to reload (plus (FP) (large_constant)) into a DREG.
     This happens as a side effect of register elimination, and we need
     a scratch register to do it.  */
  if (fp_plus_const_operand (x, mode))
    return class == PREGS ? NO_REGS : PREGS;

  /* Data can usually be moved freely between registers of most classes.
     AREGS are an exception; they can only move to or from another register
     in AREGS or one in DREGS.  They can also be assigned the constant 0.  */
  if (x_class == AREGS)
    return class == DREGS || class == AREGS ? NO_REGS : DREGS;

  if (class == AREGS)
    {
      if (x != const0_rtx && x_class != DREGS)
	return DREGS;
      else
	return NO_REGS;
    }

  /* CCREGS can only be moved from/to DREGS.  */
  if (class == CCREGS && x_class != DREGS)
    return DREGS;
  if (x_class == CCREGS && class != DREGS)
    return DREGS;
  /* All registers other than AREGS can load arbitrary constants.  The only
     case that remains is MEM.  */
  if (code == MEM)
    if (! reg_class_subset_p (class, default_class))
      return default_class;
  return NO_REGS;
}

enum reg_class
secondary_output_reload_class(enum reg_class class,enum machine_mode mode, rtx x)
{
  return secondary_input_reload_class(class,mode,x);
}

void
output_symbolic_address (rtx *operands)
{
  if (TARGET_LOW_64K)
    {
    /* output_asm_insn ("lz(%0) = %1;", operands);*/
    output_asm_insn ("%0 = %1 (Z);", operands);
    }
  else
    {
    /* output_asm_insn ("l(%0) = %1; h(%0) = %1;", operands);*/
    output_asm_insn ("%h0 = %1; %d0 = %1;", operands);
    }
}

/* For macro `OVERRIDE_OPTIONS' */

void
override_options (void)
{
  if (TARGET_OMIT_LEAF_FRAME_POINTER)
    flag_omit_frame_pointer = 1;

  /* Initialize assembler directive data structures */
  if (!TARGET_ASM_DIR) {
    section_names[CODE_DIR].dir_name = (char *) ".text";
    section_names[CODE_DIR].sect_name = (char *) "$code";
    section_names[DATA_DIR].dir_name = (char *) ".data";
    section_names[DATA_DIR].sect_name = (char *) "$data";
    
    directive_names[LONG_CONST_DIR] = (char *) ".dd";
    directive_names[SHORT_CONST_DIR] = (char *) ".dw";
    directive_names[BYTE_CONST_DIR] = (char *) ".db";
    directive_names[SPACE_DIR] = (char *) ".space";
    directive_names[INIT_DIR] = (char *) "\t";

  } else {
    section_names[CODE_DIR].dir_name = (char *) ".section";
    section_names[CODE_DIR].sect_name = (char *) "program";
    section_names[DATA_DIR].dir_name = (char *) ".section";
    section_names[DATA_DIR].sect_name = (char *) "data1";
    
    directive_names[LONG_CONST_DIR] = (char *) ".byte4";
    directive_names[SHORT_CONST_DIR] = (char *) ".byte2";
    directive_names[BYTE_CONST_DIR] = (char *) ".byte";
    directive_names[SPACE_DIR] = (char *) ".byte";
    directive_names[INIT_DIR] = (char *) "\t";
  }
  bfin_lvno = 0;
}

/* Return the destination address of BRANCH.  */

static int
branch_dest (rtx branch)
{
  rtx dest;
  int dest_uid;
  rtx pat = PATTERN (branch);
  if (GET_CODE (pat) == PARALLEL)
    pat = XVECEXP (pat, 0, 0);
  dest = SET_SRC (pat);
  if (GET_CODE (dest) == IF_THEN_ELSE)
    dest = XEXP (dest, 1);
  dest = XEXP (dest, 0);
  dest_uid = INSN_UID (dest);
  return INSN_ADDRESSES (dest_uid);
}

/* Return nonzero if INSN is annotated with a REG_BR_PROB note that indicates
   it's a branch that's predicted taken.  */

static int
cbranch_predicted_taken_p (rtx insn)
{
  rtx x = find_reg_note (insn, REG_BR_PROB, 0);

  if (x)
    {
      int pred_val = INTVAL (XEXP (x, 0));

      return pred_val >= REG_BR_PROB_BASE / 2;
    }

  return 0;
}

/* Templates for use by asm_conditional_branch.  */

static const char *ccbranch_templates[][3] = {
  { "if !cc jump %3;",  "if cc jump 4 (bp); jump.s %3;",  "if cc jump 6 (bp); jump.l %3;" },
  { "if cc jump %3;",   "if !cc jump 4 (bp); jump.s %3;", "if !cc jump 6 (bp); jump.l %3;" },
  { "if !cc jump %3 (bp);",  "if cc jump 4; jump.s %3;",  "if cc jump 6; jump.l %3;" },
  { "if cc jump %3 (bp);",  "if !cc jump 4; jump.s %3;",  "if !cc jump 6; jump.l %3;" },
};

/* Output INSN, which is a conditional branch instruction with operands
   OPERANDS.

   We deal with the various forms of conditional branches that can be generated
   by bfin_reorg to prevent the hardware from doing speculative loads, by
   - emitting a sufficient number of nops, if N_NOPS is nonzero, or
   - always emitting the branch as predicted taken, if PREDICT_TAKEN is true.
   Either of these is only necessary if the branch is short, otherwise the
   template we use ends in an unconditional jump which flushes the pipeline
   anyway.  */

void
asm_conditional_branch (rtx insn, rtx *operands, int n_nops, int predict_taken)
{
  int offset = branch_dest (insn) - INSN_ADDRESSES (INSN_UID (insn));
  int len = (offset >= -1024 && offset <= 1022 ? 0
	     : offset >= -4096 && offset <= 4094 ? 1
	     : 2);
  int bp = predict_taken && len == 0 ? 1 : cbranch_predicted_taken_p (insn);
  int idx = (bp << 1) | (GET_CODE (operands[0]) == EQ ? BRF : BRT);
  output_asm_insn (ccbranch_templates[idx][len], operands);
  if (n_nops > 0 && bp)
    abort ();
  if (len == 0)
    while (n_nops-- > 0)
      output_asm_insn ("nop;", NULL);
}

int
bfin_cbranch_operator (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED)
{
  return GET_CODE (op) == EQ || GET_CODE (op) == NE;
}

rtx
bfin_gen_compare (rtx cmp, enum machine_mode mode ATTRIBUTE_UNUSED)
{
  enum rtx_code code1, code2;
  rtx op0 = bfin_compare_op0, op1 = bfin_compare_op1;
  rtx tem = bfin_cc_rtx;
  enum rtx_code code = GET_CODE (cmp);

  /* If we have a BImode input, then we already have a compare result, and
     do not need to emit another comparison.  */
  if (GET_MODE (op0) == BImode)
    {
      if ((code == NE || code == EQ) && op1 == const0_rtx)
	tem = op0, code2 = code;
      else
	abort ();
    }
  else
    {
      switch (code) {
	/* bfin has these conditions */
      case EQ:
      case LT:
      case LE:
      case LEU:
      case LTU:
	code1 = code;
	code2 = NE;
	break;
      default:
	code1 = reverse_condition (code);
	code2 = EQ;
	break;
      }
      emit_insn (gen_rtx_SET (BImode, tem,
			      gen_rtx_fmt_ee (code1, BImode, op0, op1)));
    }

  return gen_rtx_fmt_ee (code2, BImode, tem, CONST0_RTX (BImode));
}

static int
shiftr_zero (int *v) {
    /* returns the number of consecutive least significant zeros
     * in the binary representation of *v,
     * *v is shifted right by the number of zeros*/
    int n = 0;
    if ((*v) == 0)
	return n;

    while (((*v) & 0x1) == 0 && n <= 32) { 
	(*v) >>= 1; 
	n += 1;
    }
    return n;
}

#define HIGH_16BIT_ZERO(val) ((int) ((val) & 0xffff0000) == 0)

const char *
output_load_immediate (rtx *operands) {
/* place code from bfin.md in movsi_insn and move HI here */
/*
 * dregs_lo = imm16 	=> RL3=0x800; sign extended
 * dregs_hi = imm16	=> RH3=0x800; 
 * dregs    = imm16
 * regs     = imm16     => R0-7 P0-7 I0-3 M0-3 B0-3 L0-3
 * LZ (regs)= luimm16	=> 32-bit instr & zero_extended
 * L (regs) = luimm16   => 32-bit instr
 * H (regs) = huimm16   => 32-bit instr
 */
    enum machine_mode mode = GET_MODE (operands[0]);

    if (GET_CODE (operands[1]) == CONST_INT) {
	int val = INTVAL (operands[1]);
	int shifted_val = val;
	unsigned int compl_val = (~val);
	unsigned int shifted_compl_val = compl_val;
	int num_zero = shiftr_zero (&shifted_val); /* consecutive number zero from least signi... */
	int num_compl_zero = shiftr_zero ((int *)&shifted_compl_val);
	enum reg_class class1 = REGNO_REG_CLASS (REGNO (operands[0]));

	if (CONST_16BIT_IMM_P (val)) {
	  if (reg_class_subset_p (class1, DPREGS)
	    || reg_class_subset_p (class1, DAGREGS))
	    output_asm_insn ("%0 = %1 (X);", operands); /* ("%0 = %1;", operands); */
          else
	    output_asm_insn ("%0 = %1 (Z);", operands);/*("lz(%0) = %1;", operands);*/
	} else if (HIGH_16BIT_ZERO (val)) {
            short lo = val & 0xffff;
            operands[2] = GEN_INT (lo);
	    output_asm_insn ("%0 = %2 (Z);", operands);/*("lz(%0) = %2;", operands);*/
	} else if ((class1 == DREGS || (class1 == PREGS && num_zero == 2))
	    && num_zero && CONST_16BIT_IMM_P (shifted_val)) {
	    operands[2] = GEN_INT (shifted_val);
	    operands[3] = GEN_INT (num_zero);
	    if (class1 == DREGS)
		output_asm_insn ("%0 = %2 (X); %0 <<= %3; // zeros", operands);
	    else
		output_asm_insn ("%0 = %2 (X); %0 = %0 << %3; // zeros", operands);
	} else if (class1 == DREGS
	    && num_zero && HIGH_16BIT_ZERO (shifted_val)) {
	    operands[2] = GEN_INT (shifted_val);
	    operands[3] = GEN_INT (num_zero);
	    /*output_asm_insn ("lz(%0) = %2; %0 <<= %3; //zeros", operands);*/
            output_asm_insn ("%0 = %2 (Z); %0 <<= %3; //zeros", operands);
	} else if (class1 == DREGS && optimize_size
	    && num_compl_zero && CONST_7BIT_IMM_P (shifted_compl_val)) {
	    /* Do it if optimize by size, "-Os" */
	    operands[2] = GEN_INT (shifted_compl_val);
	    operands[3] = GEN_INT (num_compl_zero);
	    output_asm_insn ("%0 = %2 (X); %0 <<= %3; %0 = ~%0;// compl", operands);
       	} else {
	  short hi = (val >> 16) & 0xffff;
	  short lo = val & 0xffff;
	  operands[2] = GEN_INT (lo);
	  operands[3] = GEN_INT (hi);
	  if (hi)
	    output_asm_insn ("%h0 = %2; %d0 = %3;", operands);
	    /*("l(%0) = %2; h(%0) = %3;", operands);*/
          else
	    output_asm_insn ("%0 = %2 (Z);", operands);
        }
	return "";
     } else if (GET_CODE (operands[1]) == CONST
        && (GET_CODE (XEXP (operands[1], 0)) == SYMBOL_REF
	|| GET_CODE (XEXP (operands[1], 0)) == LABEL_REF
        || GET_CODE (XEXP (operands[1], 0)) == PLUS)) {
	   output_symbolic_address (operands);
	   return "";
    } else if (GET_CODE (operands[1]) == SYMBOL_REF
	|| GET_CODE (operands[1]) == LABEL_REF) {
	   output_symbolic_address (operands);
	   return "";
    } else if (REG_P (operands[0])
	       && REGNO_REG_CLASS (REGNO (operands[0])) == AREGS
	       && !(GET_CODE (operands[1]) == CONST_INT
		    && INTVAL (operands[1])==0)) {
	 output_asm_insn ("%w0 =%1;", operands);
	 return "";
    } else if (REG_P (operands[1])
	       && REGNO_REG_CLASS (REGNO (operands[1])) == AREGS) {
	 output_asm_insn ("%0 =%w1;", operands);
	 return "";
     }
     else if (GET_CODE (operands[1]) == MEM
	      && GET_MODE_SIZE (mode) < UNITS_PER_WORD)
       {
	 rtx x = XEXP (operands[1], 0);
	 if (GET_CODE (x) == POST_INC && REGNO(XEXP(x,0)) == STACK_POINTER_REGNUM)
	   output_asm_insn ("%0=%1;", operands);
	 else if (mode == HImode)
	   output_asm_insn ("%0 = W %1 (X);", operands);
	 else
	   output_asm_insn ("%0 = B %1 (X);", operands);
	 return "";
       }
     else if (GET_CODE (operands[0]) == MEM
	      && GET_MODE_SIZE (mode) < UNITS_PER_WORD)
       {
	 rtx x = XEXP (operands[0], 0);
	 if (GET_CODE (x) == PRE_DEC && REGNO(XEXP(x,0)) == STACK_POINTER_REGNUM)
	   output_asm_insn ("%0=%1;", operands);
	 else if (mode == HImode)
	   output_asm_insn ("W %0=%1;", operands);
	 else
	   output_asm_insn ("B %0=%1;", operands);
	 return "";
       }

     output_asm_insn ("%0 =%1;", operands);
     return "";
}

int
bfin_return_in_memory (tree type)
{
  int size;
  enum machine_mode mode = TYPE_MODE (type);

  if (mode == BLKmode)
    return 1;
  size = int_size_in_bytes (type);	
  if (VECTOR_MODE_P (mode) || mode == TImode)
    {
      /* User-created vectors small enough to fit in REG.  */
      if (size < 8)
        return 0;
      if (size == 8 || size == 16)
	return 1;
    }

  if (size > 12)
    return 1;
  return 0;
}

rtx
bfin_force_reg (enum machine_mode mode, rtx x)
{
  rtx temp, insn/*, set*/;

  if (GET_CODE (x) == REG)
    return x;

  if (general_operand (x, mode))
    {
      temp = gen_reg_rtx (mode);
      insn = emit_move_insn (temp, x);
    }
  else
    {
      temp = force_operand (x, NULL_RTX);
      if (GET_CODE (temp) == REG)
        insn = get_last_insn ();
      else
        {
          rtx temp2 = gen_reg_rtx (mode);
          insn = emit_move_insn (temp2, temp);
          temp = temp2;
        }
    }

  /* Let optimizers know that TEMP's value never changes
     and that X can be substituted for it.  Don't get confused
     if INSN set something else (such as a SUBREG of TEMP).  */
/*  if (CONSTANT_P (x)
      && (set = single_set (insn)) != 0
      && SET_DEST (set) == temp)
    set_unique_reg_note (insn, REG_EQUAL, x);
*/
  return temp;
}

const char *
output_casesi_internal (rtx *operands)
{
  output_asm_insn ("cc = %0<=%1 (iu);\n\tif cc jump 6; jump.l %3;", operands);
  output_asm_insn ("%1 = %0<<2;\n\t%4.L = %2; %4.H = %2;", operands);
  output_asm_insn ("%4 = %4 + %1;\n\t%1 = [%4];", operands);
  output_asm_insn ("jump (%1);", operands);

  return "";
}

/*
return true if the legitimate memory address for a memory operand of mode
return false if not.

[ Preg + uimm17m4 ]
W [ Preg + uimm16m2 ]
B [ Preg + uimm15 ]

uimm17m4: 17-bit unsigned field that must be a multiple of 4
uimm16m2: 16-bit unsigned field that must be a multiple of 2 
*/

int
bfin_valid_add (enum machine_mode mode, HOST_WIDE_INT value)
{
  int v = value > 0 ? value : -value;
  int sz = GET_MODE_SIZE (mode);
  int shift = sz == 1 ? 0 : sz == 2 ? 1 : 2;
  return (v & ~(0x7FFF << shift)) == 0;
}

bool
bfin_rtx_costs (rtx x,
               int code,
               int outer_code,
               int *total)
{
  switch (code)
    {
  case CONST_INT:
    if ((outer_code)==SET || (outer_code)==PLUS)
        *total = CONST_7BIT_IMM_P(INTVAL(x)) ?
        0 : 2;
    else if ((outer_code)==AND)
        *total = (CONST_7BIT_IMM_P(INTVAL(x)) ||
            log2constp (1+INTVAL(x)) || log2constp (-INTVAL(x)))?
        0 : 2;
    else if ((outer_code)==LE || (outer_code)==LT
                || (outer_code)==EQ)
        *total = (INTVAL (x) >= -4 && INTVAL (x) <= 3) ?
        0 : 2;
    else if ((outer_code)==LEU || (outer_code)==LTU)
        *total = (INTVAL (x) >= 0 && INTVAL (x) <= 7) ?
        0 : 2;
    else if ((outer_code)==MULT)
        *total = ((INTVAL (x)==2 || INTVAL (x)==4)) ?
        0 : 2;
    else if ((outer_code)==ASHIFT &&
        (INTVAL (x) == 1 && INTVAL (x) == 2))
        *total = 0;
    else if ((outer_code)==ASHIFT || (outer_code)==ASHIFTRT
        || (outer_code)==LSHIFTRT)
        *total = (INTVAL (x) >= 0 && INTVAL (x) <= 31) ?
        0 : 2;
    else if ((outer_code)==IOR || (outer_code)==XOR)
        *total = ((INTVAL (x) >= 0 && INTVAL (x) <= 31) &&
        (INTVAL (x) & (INTVAL (x) - 1)) == 0) ?
        0 : 2;
    else
      *total = 2;
      return true;
  case CONST:
  case LABEL_REF:
  case SYMBOL_REF:
  case CONST_DOUBLE:
       *total = COSTS_N_INSNS (2);
       return true;

  default:
       return false;
    }
}

void
bfin_internal_label(FILE *stream, const char *prefix, unsigned long num)
{
        fprintf(stream, "%s%s$%ld:\n", LOCAL_LABEL_PREFIX, prefix, num);
}

/* Used for communication between {push,pop}_multiple_operation (which
   we use not only as a predicate) and the corresponding output functions.  */
static int first_preg_to_save, first_dreg_to_save;

int
push_multiple_operation (rtx op, enum machine_mode mode)
{
  int lastdreg = 8, lastpreg = 6;
  int i, group;

  first_preg_to_save = lastpreg;
  first_dreg_to_save = lastdreg;
  for (i = 1, group = 0; i < XVECLEN (op, 0); i++)
    {
      rtx t = XVECEXP (op, 0, i);
      rtx src, dest;
      int regno;

      if (GET_CODE (t) != SET)
	return 0;

      src = SET_SRC (t);
      dest = SET_DEST (t);
      if (GET_CODE (dest) != MEM || ! REG_P (src))
	return 0;
      dest = XEXP (dest, 0);
      if (GET_CODE (dest) != PLUS
	  || ! REG_P (XEXP (dest, 0))
	  || REGNO (XEXP (dest, 0)) != REG_SP
	  || GET_CODE (XEXP (dest, 1)) != CONST_INT
	  || INTVAL (XEXP (dest, 1)) != -i * 4)
	return 0;

      regno = REGNO (src);
      if (group == 0)
	{
	  if (regno >= REG_R0 && regno <= REG_R7)
	    {
	      group = 1;
	      first_dreg_to_save = lastdreg = regno - REG_R0;
	    }
	  else if (regno >= REG_P0 && regno <= REG_P7)
	    {
	      group = 2;
	      first_preg_to_save = lastpreg = regno - REG_P0;
	    }
	  else
	    return 0;

	  continue;
	}

      if (group == 1)
	{
	  if (regno >= REG_P0 && regno <= REG_P7)
	    {
	      group = 2;
	      first_preg_to_save = lastpreg = regno - REG_P0;
	    }
	  else if (regno != REG_R0 + lastdreg + 1)
	    return 0;
	  else
	    lastdreg++;
	}
      else if (group == 2)
	{
	  if (regno != REG_P0 + lastpreg + 1)
	    return 0;
	  lastpreg++;
	}
    }
  return 1;
}

int
pop_multiple_operation (rtx op, enum machine_mode mode)
{
  int lastdreg = 8, lastpreg = 6;
  int i, group;

  for (i = 1, group = 0; i < XVECLEN (op, 0); i++)
    {
      rtx t = XVECEXP (op, 0, i);
      rtx src, dest;
      int regno;

      if (GET_CODE (t) != SET)
	return 0;

      src = SET_SRC (t);
      dest = SET_DEST (t);
      if (GET_CODE (src) != MEM || ! REG_P (dest))
	return 0;
      src = XEXP (src, 0);

      if (i == 1)
	{
	  if (! REG_P (src) || REGNO (src) != REG_SP)
	    return 0;
	}
      else if (GET_CODE (src) != PLUS
	       || ! REG_P (XEXP (src, 0))
	       || REGNO (XEXP (src, 0)) != REG_SP
	       || GET_CODE (XEXP (src, 1)) != CONST_INT
	       || INTVAL (XEXP (src, 1)) != (i - 1) * 4)
	return 0;

      regno = REGNO (dest);
      if (group == 0)
	{
	  if (regno == REG_R7)
	    {
	      group = 1;
	      lastdreg = 7;
	    }
	  else if (regno != REG_P0 + lastpreg - 1)
	    return 0;
	  else
	    lastpreg--;
	}
      else if (group == 1)
	{
	  if (regno != REG_R0 + lastdreg - 1)
	    return 0;
	  else
	    lastdreg--;
	}
    }
  first_dreg_to_save = lastdreg;
  first_preg_to_save = lastpreg;
  return 1;
}

void
output_push_multiple (rtx insn, rtx *operands)
{
  char buf[80];
  if (! push_multiple_operation (PATTERN (insn), VOIDmode))
    abort ();
  if (first_dreg_to_save == 8)
    sprintf (buf, "[--sp] = ( p5:%d );\n", first_preg_to_save);
  else if (first_preg_to_save == 6)
    sprintf (buf, "[--sp] = ( r7:%d );\n", first_dreg_to_save);
  else
    sprintf (buf, "[--sp] = ( r7:%d, p5:%d );\n", first_dreg_to_save, first_preg_to_save);

  output_asm_insn (buf, operands);
}

void
output_pop_multiple (rtx insn, rtx *operands)
{
  char buf[80];
  if (! pop_multiple_operation (PATTERN (insn), VOIDmode))
    abort ();

  if (first_dreg_to_save == 8)
    sprintf (buf, "( p5:%d ) = [sp++];\n", first_preg_to_save);
  else if (first_preg_to_save == 6)
    sprintf (buf, "( r7:%d ) = [sp++];\n", first_dreg_to_save);
  else
    sprintf (buf, "( r7:%d, p5:%d ) = [sp++];\n", first_dreg_to_save, first_preg_to_save);

  output_asm_insn (buf, operands);
}

/* We use the machine specific reorg pass for emitting CSYNC instructions
   after conditional branches as needed.

   The Blackfin is unusual in that a code sequence like
     if cc jump label
     r0 = (p0)
   may speculatively perform the load even if the condition isn't true.  This
   happens for a branch that is predicted not taken, because the pipeline
   isn't flushed or stalled, so the early stages of the following instructions,
   which perform the memory reference, are allowed to execute before the
   jump condition is evaluated.
   Therefore, we must insert additional instructions in all places where this
   could lead to incorrect behaviour.  The manual recommends CSYNC, while
   VDSP seems to use NOPs (even though its corresponding compiler option is
   named CSYNC).

   When optimizing for speed, we emit NOPs, which seems faster than a CSYNC.
   When optimizing for size, we turn the branch into a predicted taken one.
   This may be slower due to mispredicts, but saves code size.  */

static void
bfin_reorg (void)
{
  rtx insn, last_condjump = NULL_RTX;
  int cycles_since_jump = INT_MAX;

  if (! TARGET_CSYNC)
    return;

  for (insn = get_insns (); insn; insn = NEXT_INSN (insn))
    {
      rtx pat;

      if (NOTE_P (insn) || BARRIER_P (insn) || LABEL_P (insn))
	continue;

      pat = PATTERN (insn);
      if (GET_CODE (pat) == USE || GET_CODE (pat) == CLOBBER
	  || GET_CODE (pat) == ASM_INPUT || GET_CODE (pat) == ADDR_VEC
	  || GET_CODE (pat) == ADDR_DIFF_VEC || asm_noperands (pat) >= 0)
	continue;

      if (JUMP_P (insn))
	{
	  if (any_condjump_p (insn)
	      && ! cbranch_predicted_taken_p (insn))
	    {
	      last_condjump = insn;
	      cycles_since_jump = 0;
	    }
	  else
	    cycles_since_jump = INT_MAX;
	}
      else if (INSN_P (insn))
	{
	  enum attr_type type = get_attr_type (insn);
	  if (cycles_since_jump < INT_MAX)
	    cycles_since_jump++;

	  if (type == TYPE_MCLD && cycles_since_jump < 3)
	    {
	      rtx pat;

	      pat = single_set (insn);
	      if (may_trap_p (SET_SRC (pat)))
		{
		  int num_clobbers;
		  rtx *op = recog_data.operand;

		  extract_insn (last_condjump);
		  if (optimize_size)
		    pat = gen_cbranch_predicted_taken (op[0], op[1], op[2],
						       op[3]);
		  else
		    pat = gen_cbranch_with_nops (op[0], op[1], op[2], op[3],
						 GEN_INT (3 - cycles_since_jump));
		  PATTERN (last_condjump) = pat;
		  INSN_CODE (last_condjump) = recog (pat, insn, &num_clobbers);
		  cycles_since_jump = INT_MAX;
		}
	    }
	}
    }
}

/* Table of valid machine attributes.  */
const struct attribute_spec bfin_attribute_table[] =
{
  /* { name, min_len, max_len, decl_req, type_req, fn_type_req, handler } */
  { "interrupt_handler", 0, 0, false, true,  true, NULL },
  { "exception_handler", 0, 0, false, true,  true, NULL },
  { "nesting", 0, 0, false, true,  true, NULL },
  { "kspisusp", 0, 0, false, true,  true, NULL },
  { "nmi_handler", 0, 0, false, true,  true, NULL },
  { "saveall", 0, 0, false, true,  true, NULL },
  { NULL, 0, 0, false, false, false, NULL }
};

#undef TARGET_ATTRIBUTE_TABLE
#define TARGET_ATTRIBUTE_TABLE bfin_attribute_table

#undef TARGET_RTX_COSTS
#define TARGET_RTX_COSTS bfin_rtx_costs

#undef  TARGET_ADDRESS_COST
#define TARGET_ADDRESS_COST bfin_address_cost

#undef TARGET_ASM_INTERNAL_LABEL
#define TARGET_ASM_INTERNAL_LABEL bfin_internal_label

#undef TARGET_MACHINE_DEPENDENT_REORG
#define TARGET_MACHINE_DEPENDENT_REORG bfin_reorg

struct gcc_target targetm = TARGET_INITIALIZER;
