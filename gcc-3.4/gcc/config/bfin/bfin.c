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

/* RTX for condition code flag register */
extern GTY(()) rtx bfin_cc_rtx;
rtx bfin_cc_rtx;

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

static int saved_dregs_no PARAMS ((void));
static int saved_pregs_no PARAMS ((void));

static void bfin_function_prologue PARAMS ((FILE *, HOST_WIDE_INT));
static void bfin_function_epilogue PARAMS ((FILE *, HOST_WIDE_INT));
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

#undef TARGET_RTX_COSTS
#define TARGET_RTX_COSTS bfin_rtx_costs

#undef  TARGET_ADDRESS_COST
#define TARGET_ADDRESS_COST bfin_address_cost

#undef TARGET_ASM_INTERNAL_LABEL
#define TARGET_ASM_INTERNAL_LABEL bfin_internal_label

struct gcc_target targetm = TARGET_INITIALIZER;

void 
output_file_start (void) 
{
  FILE *file = asm_out_file;
  if (optimize_size)
    fprintf (file, "// gcc version %s bfin version %s opt -Os\n", 
           version_string, bfin_ver_str);
  else
    fprintf (file, "// gcc version %s bfin version %s opt -O%d\n", 
           version_string, bfin_ver_str, optimize);
  fprintf (file, ".file \"%s\";\n", input_filename);
  if (TARGET_SIMPLE_RTM) {
    fprintf (file,"\nsimple_rtm:\nl(SP) =0xFFFC; h(SP) =0x4000;\nFP =SP;\ncall _main;\nhlt;\n___main:\n\nrts;\n\n");

  }
#ifdef FUNCTION_ARG_REGISTERS
  {
    int  i;
    static int argregs[] = FUNCTION_ARG_REGISTERS;
    for (i=0;argregs[i]>=0;i++)
      ;
    max_arg_registers = i;	/* how many arg reg used  */
  }
#endif

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

/*
              Interrupt Extentions to the C-language

  The embeded world is a very special place, first interrupt are
  a dominating factor and we need to handle them from C with minimal
  assembler code.  To minimize the need for assembler code we extend
  the C-language by defining 3 function attributes
  
     interrupt			function is an interrupt
     exception_handler		function is an exception_handler
     nmi_handler		function is an nmi_handler

  These attributes decorate a function prototype as follows:
  
  int foo (void) __attribute__ ((interrupt));

  For simplicity, we save and restore the machine state that the compiler
  uses directly on the supervisor stack.  There is a lot more work to
  be done here 

     1. only the compiler state is saved i.e. dregs and pregs ASTAT return ""S
        this is short sighted because there is much more to be saved.

  In reality we don't need to save that much state here only the compiler scratch
  registers need to be added to the prologue and epilogue of an ISR.
*/
typedef enum { 
  SUBROUTINE, INTERRUPT_HANDLER, EXCPT_HANDLER, NMI_HANDLER
} e_funkind ;

void output_interrupt_handler_prologue PARAMS ((FILE *, int, e_funkind));
void output_interrupt_handler_epilogue PARAMS ((FILE *, int, e_funkind));


static e_funkind funkind (tree fundecl);

static e_funkind funkind (tree fundecl)
{
  if (lookup_attribute ("interrupt_handler", TYPE_ATTRIBUTES(TREE_TYPE(fundecl))))
    return INTERRUPT_HANDLER;
  else if (lookup_attribute ("exception_handler", TYPE_ATTRIBUTES(TREE_TYPE(fundecl))))
    return EXCPT_HANDLER;
  else if (lookup_attribute ("nmi_handler", TYPE_ATTRIBUTES(TREE_TYPE(fundecl))))
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

/* save masks */
static int ndregs;
static int npregs;
static int is_leaf_function;


/* First save data reg and first save pointer reg */
#define NDREGS 8
#define NPREGS 8

static int saved_dregs_no (void)
{
  int i, nregs;

  nregs = NDREGS;
  for (i=1;i<LAST_USER_DREG+1;i++) 
    if (regs_ever_live[i] && ! call_used_regs[i]) {
      nregs = i;
      break;
    }
  return nregs;
}

static int saved_pregs_no (void)
{
  int i, nregs;

  nregs = NPREGS;
  for (i=LAST_USER_DREG+1;i<LAST_USER_PREG+1;i++) {
    if (regs_ever_live[i] && ! call_used_regs[i]) {
      nregs = (i-LAST_USER_DREG+1);
      break;
    }
  }
  return nregs;
}

int save_area_size (void)
/* return the size (in bytes) of register save area on the stack */
{
  int size;

  ndregs = saved_dregs_no (); 
  npregs = saved_pregs_no ();
  size = ((NDREGS - ndregs) + (NPREGS - npregs)) * UNITS_PER_WORD;
  return size;
}

/* Used by macro `frame_pointer_required' */
int frame_pointer_required (void) 
{
    int omit, leaf, frame, required;

    omit = TARGET_OMIT_LEAF_FRAME_POINTER;
    leaf = leaf_function_p ();
    frame = get_frame_size ();
    required = !((omit && leaf) || (leaf && frame == 0 && current_function_args_size == 0));
    return required;
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
   - now, the vastart pointer can access all arguments from the stack.
*/
                                                                                                                             
void
setup_incoming_varargs (CUMULATIVE_ARGS *cum,
			     enum machine_mode mode ATTRIBUTE_UNUSED,
			     tree type ATTRIBUTE_UNUSED,
			     int *pretend_size,
			     int no_rtl)
{
  rtx save_area = NULL_RTX, mem;
  int i;

  if(no_rtl)
    return;

  save_area = frame_pointer_rtx;
  /* gcc will generate the move rtx for us automatically for named arguments
   we need to generate the move rtx for the unnamed arguments if they
   are in the first 3 words. We assume atleast 1 named argument exists
   so we never generate [FP+8] = R0 here
   cum->words will */

  for (i = cum->words + 1; i < max_arg_registers; i++) {
 	
    mem = gen_rtx_MEM (Pmode,
  			 plus_constant (save_area, 8 + (i * UNITS_PER_WORD)));
    emit_move_insn (mem, gen_rtx_REG (Pmode, i));
  }
                                                                                                                             
  *pretend_size = 0;
}

/* The saveall must be syncronized with include/sys/regs.h
 */

void
output_interrupt_handler_prologue (FILE *file, int framesize, e_funkind fkind) 
{
  int i;
  tree all = lookup_attribute 
    ("saveall", 
     TYPE_ATTRIBUTES(TREE_TYPE(current_function_decl)));
  tree kspisusp = lookup_attribute 
    ("kspisusp",
     TYPE_ATTRIBUTES(TREE_TYPE(current_function_decl)));

  if (kspisusp)
    fprintf (file, "sp =usp;\n");
    
  fprintf (file, "\n\
	    \tLINK %d;\n\
	    \t[--SP] =ASTAT;\n", framesize);
  if (lookup_attribute ("nesting", 
			TYPE_ATTRIBUTES(TREE_TYPE(current_function_decl))))
    switch (fkind) {
    case EXCPT_HANDLER:       fprintf (file, "\t[--SP] =RETX;\n"); break;
    case NMI_HANDLER:         fprintf (file, "\t[--SP] =RETN;\n"); break;
    case INTERRUPT_HANDLER:   fprintf (file, "\t[--SP] =RETI;\n"); break;
    case SUBROUTINE:          break; /*RAJA warning*/
    }

  for (i = 0;i<REG_CC /*FIRST_PSEUDO_REGISTER*/; i++) {
    if (i != STACK_POINTER_REGNUM 
	&& (all 
	    || (regs_ever_live[i] 
		|| (!leaf_function_p () && call_used_regs[i])))) {
      if (i == REG_A0 || i == REG_A1)
	fprintf (file,"\t[--SP] =%s.w; [--SP] =%s.x;\n", reg_names[i], reg_names[i]);
      else
	fprintf (file,"\t[--SP] =%s;\n", reg_names[i]);
    }
  }

  if (fkind == EXCPT_HANDLER) {
    fprintf (file, 
	     "\tr0 =SEQSTAT;\n\
	      \tr0 <<=26; // r0<<=(32-6);\n\
	      \tr0 >>=26; // r0>>=(32-6);\n\
	      \tr1 =sp;\n\
	      \tr2 =fp;r2 +=8; //r2=usp;\n");
  }
}

void
output_interrupt_handler_epilogue (FILE *file, int framesize ATTRIBUTE_UNUSED, e_funkind fkind) 
{
  int i;
  tree all = lookup_attribute 
    ("saveall", 
     TYPE_ATTRIBUTES(TREE_TYPE(current_function_decl)));

  for (i = /*FIRST_PSEUDO_REGISTER*/REG_CC-1;i>=0; i--) {
    if (i != STACK_POINTER_REGNUM 
	&& (all
	    || (regs_ever_live[i] 
		|| (!leaf_function_p () && call_used_regs[i])))) {
      if (i == REG_A0
	  || i == REG_A1)
	fprintf (file,"\t%s.x =[SP++]; %s.w =[SP++];\n", reg_names[i], reg_names[i]);
      else
	fprintf (file,"\t%s =[SP++];\n", reg_names[i]);
    }
  }

  if (lookup_attribute ("nesting", 
			TYPE_ATTRIBUTES(TREE_TYPE(current_function_decl))))
    switch (fkind) {
    case EXCPT_HANDLER:       fprintf (file, "\tRETX =[SP++];\n"); break;
    case NMI_HANDLER:         fprintf (file, "\tRETN =[SP++];\n"); break;
    case INTERRUPT_HANDLER:   fprintf (file, "\tRETI =[SP++];\n"); break;
    case SUBROUTINE:          break; /*RAJA warning*/
    }

  fprintf (file, "\n\
	    \tASTAT =[SP++];\n\
	    \tUNLINK;\n");

  switch (fkind) {
  case EXCPT_HANDLER:       fprintf (file, "\trtx;\n"); break;
  case NMI_HANDLER:         fprintf (file, "\trtn;\n"); break;
  case INTERRUPT_HANDLER:   fprintf (file, "\trti;\n"); break;
  case SUBROUTINE:	    break; /*RAJA warning*/
  }
}

static void
bfin_function_prologue (FILE *file, HOST_WIDE_INT framesize)
{
  int i;
  signed int arg_size;

  e_funkind fkind = funkind (current_function_decl);

  if (fkind != SUBROUTINE) {
    output_interrupt_handler_prologue (file, framesize, fkind);
    return;
  }

  is_leaf_function = leaf_function_p ();
  frame_pointer_needed = FRAME_POINTER_REQUIRED;

  if (! frame_pointer_needed && ! TARGET_NON_GNU_PROFILE)
    fprintf (file, "\t[--SP] = RETS;\n");
  else
    {
      /* use 32-bit instruction */
      if (CONST_18UBIT_IMM_P(framesize))
	fprintf (file, "\tLINK %ld;\n", framesize);
      else 
	{
	  rtx operands1[2];
	  fprintf (file, "\tLINK 0;\n");
	  operands1[0] =  gen_rtx_REG (Pmode, REG_P2);
	  operands1[1] =  gen_rtx_CONST_INT (Pmode, -framesize);
	  output_load_immediate (operands1);
	  fprintf (file,"\tSP = SP + P2;\n");
	}
    }
  if (TARGET_NON_GNU_PROFILE)
    fprintf (file, "\tcall mcount_entry;\n");
  
  ndregs = 7; npregs = 5;
  for (i = 1; i < 8; i++)
    {
      if (regs_ever_live[i] && ! call_used_regs[i]) 
	{
	  ndregs = i;
	  break;
	}
    }

  for (i = 8; i < 14; i++) {
    if (regs_ever_live[i] && ! call_used_regs[i])
      {
	npregs = i - 8;
	break;
      }
  }
  
  ndregs = saved_dregs_no (); 
  npregs = saved_pregs_no ();
  if (save_area_size() != 0) 
    {
      if (ndregs == NDREGS)
	fprintf (file, "\t[--sp] = ( p5:%d );\n", npregs-2);
      else if (npregs == NPREGS)
	fprintf (file, "\t[--sp] = ( r7:%d );\n", ndregs);
      else
	fprintf (file, "\t[--sp] = ( r7:%d, p5:%d );\n", ndregs, npregs-2);    
    }

  if (current_function_outgoing_args_size) 
    {
      if (current_function_outgoing_args_size >= FIXED_STACK_AREA)
	arg_size = current_function_outgoing_args_size;
      else
	arg_size = FIXED_STACK_AREA;

      if (arg_size < SP_SIZE)
	fprintf (file, "\tSP += %d;\n", -arg_size);
      else
	do 
	  {
	    int size;
	    (arg_size > SP_SIZE) ? (size = SP_SIZE) : (size = arg_size);
	    fprintf (file, "\tSP += %d;\n", -size);
	    arg_size -= SP_SIZE;
	  } 
	while (arg_size > 0);
    }
}
 
static void
bfin_function_epilogue (FILE *file, HOST_WIDE_INT framesize)
{
  signed int arg_size;

  e_funkind fkind = funkind (current_function_decl);

  if (fkind != SUBROUTINE)
    {
      output_interrupt_handler_epilogue (file, framesize, fkind);
      return;
    }

  if (current_function_outgoing_args_size)
    {
      if (current_function_outgoing_args_size >= FIXED_STACK_AREA)
	arg_size = current_function_outgoing_args_size;
      else
	arg_size = FIXED_STACK_AREA;

      if (arg_size <= SP_SIZE)
	fprintf (file, "\tSP += %d;\n", arg_size);
      else
	do 
	  {
	    int size;
	    (arg_size > SP_SIZE) ? (size = SP_SIZE) : (size = arg_size);
	    fprintf (file, "\tSP += %d;\n", size);
	    arg_size -= SP_SIZE;
	  }
	while (arg_size > 0);        
    }


  ndregs = saved_dregs_no (); 
  npregs = saved_pregs_no ();

  if (save_area_size() != 0) 
    {
      if (ndregs == NDREGS)
	fprintf (file, "\t( p5:%d ) = [sp++];\n", npregs-2);
      else if (npregs == NPREGS)
	fprintf (file, "\t( r7:%d ) = [sp++];\n", ndregs);
      else
	fprintf (file, "\t( r7:%d, p5:%d ) = [sp++];\n", ndregs, npregs-2);    
    }
  if (TARGET_NON_GNU_PROFILE)
    fprintf (file, "\tcall mcount_exit;\n");

  if (! frame_pointer_needed || TARGET_NON_GNU_PROFILE) 
    fprintf (file, "\tRETS = [SP++];\n");
  else
    fprintf (file, "\tUNLINK;\n");

  fprintf (file, "\trts;\n\n\n");
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

int bfin_address_cost (rtx addr) {
  if (GET_CODE (addr) == PLUS
      && CONSTANT_P (XEXP (addr,1)))
    return 2;
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
#ifdef FUNCTION_ARG_REGISTERS

static int arg_regs[] = FUNCTION_ARG_REGISTERS;

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
  rtx ret   = NULL_RTX;
  int bytes
    = (mode == BLKmode) ? int_size_in_bytes (type) : GET_MODE_SIZE (mode);
  int words = (bytes + UNITS_PER_WORD - 1) / UNITS_PER_WORD;

  switch (mode)
    {
      /* For now, pass fp/complex values on the stack. */
    default:
      break;

    case BLKmode:
      if (bytes < 0)
	break;
    case DFmode:
    case DImode:
    case SImode:
    case HImode:
    case QImode:
    case SFmode:
      if (cum->nregs)
	ret = gen_rtx (REG, mode, *(cum->arg_regs));
      break;
    }

  return ret;
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

#endif


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
  bfin_cc_rtx = gen_rtx (REG, BImode, REG_CC);
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

int
loop_end (rtx jump)
{
/* return true if the jump is followed by loop end. */
  rtx insn;

  if (JUMP_INSN != GET_CODE(jump))
      abort();
    
  insn = NEXT_INSN (jump);
  if (GET_CODE (insn) == NOTE
       && (NOTE_LINE_NUMBER (insn) == NOTE_INSN_LOOP_END))
    return 1;
  else
    return 0;
}

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
rhs_andsi3_operand (rtx op, enum machine_mode mode) {
    return (regorbitclr_operand (op, mode) || highbits_operand (op, mode));
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
  
int cc_operand (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED) {
  return bfin_cc_rtx == op;
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
  int ret;

  if (class == CCREGS)
    return mode == CCmode || mode == BImode;

  if (mode == DImode)
    return TEST_HARD_REG_BIT (reg_class_contents[MOST_REGS], regno);

  return mode != CCmode;
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
  return (REG_P (op1) && REGNO (op1) == FRAME_POINTER_REGNUM
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


const char *ccbranch_templates[][3] = {
  { "if !cc jump %3;",  "if cc jump 4; jump.s %3;",  "if cc jump 6; jump.l %3;" },
  { "if cc jump %3;",   "if !cc jump 4; jump.s %3;", "if !cc jump 6; jump.l %3;" },
  { "if !cc jump %3 (bp);",  "if cc jump 4; jump.s %3;",  "if cc jump 6; jump.l %3;" },
  { "if cc jump %3 (bp);",  "if !cc jump 4; jump.s %3;",  "if !cc jump 6; jump.l %3;" },
};

char *asm_conditional_branch (rtx insn, int cond)
{
  int bp = loop_end (insn);
  int idx = (bp<<1)|cond;
  int len = (get_attr_length (insn)/2)-1;
  return (char *) ccbranch_templates[idx][len];
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
     else if (GET_CODE (operands[0]) == MEM
	&& (REGNO_REG_CLASS (REGNO (operands[1])) == IREGS || REGNO_REG_CLASS (REGNO (operands[1])) == BREGS)) {
       abort ();
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

