/* bfin-parse.y
 *
 * This is the mainly rewritten bfin/nisa assembly parser
 * for the Blackfin processor family.
 * 
 * Opcodes and some parts were derived from the original nisa-parse.y
 * ( (c) by Analog Devices Inc. )
 * which was considered to be too big for maintenance.
 *
 * 03/2004 (c) Martin Strubel <hackfin@section5.ch>
 * 05/2004 merged in new expression parsing from ADI CVS snapshot
 * 09/2004 tested for all relocations and fixed bugs
 * 
 * This code is subject to the GNU license. Please see www.gnu.org for
 * license details. This source code is provided AS IS, without warranty.
 *
 * TODO:
 *       - better syntax error reporting,
 *       - Valid opt_mode checking in DSP32MAC commands
 *       - More compacting of redundant code.
 *
 *       Parser:
 *       - allow splitting up of commands in multiple lines
 *       - enable better delimiter checks to prevent wrong parsing
 * 
 *
 */

%{

#include <stdio.h>
#include "bfin-aux.h"  // opcode generating auxiliaries
#include <stdarg.h>
#include <obstack.h>


////////////////////////////////////////////////////////////////////////////
// Auxiliary macros to derive some systematics from the old nisa-parse.y
// See bfin-aux.c for the function calls

#define DSP32ALU(aopcde, HL, dst1, dst0, src0, src1, s, x, aop) \
	gen_dsp32alu(HL, aopcde, aop, s, x, dst0, dst1, src0, src1)

#define DSP32MAC(op1, MM, mmod, w1, P, h01, h11, h00, h10, dst, op0, src0, src1, w0) \
	gen_dsp32mac(op1, MM, mmod, w1, P, h01, h11, h00, h10, op0, \
	             dst, src0, src1, w0)

#define DSP32MULT(op1, MM, mmod, w1, P, h01, h11, h00, h10, dst, op0, src0, src1, w0) \
	gen_dsp32mult(op1, MM, mmod, w1, P, h01, h11, h00, h10, op0, \
	              dst, src0, src1, w0)

#define DSP32SHIFT(sopcde, dst0, src0, src1, sop, hls)  \
	gen_dsp32shift(sopcde, dst0, src0, src1, sop, hls)

#define DSP32SHIFTIMM(sopcde, dst0, immag, src1, sop, hls)  \
	gen_dsp32shiftimm(sopcde, dst0, immag, src1, sop, hls)

////////////////////////////////////////////////////////////////////////////

//#define LDIMMHALF(reg, h, s, z, hword) 
//	gen_ldimmhalf(reg, h, s, z, hword, 0)

#define LDIMMHALF_R(reg, h, s, z, hword) \
	gen_ldimmhalf(reg, h, s, z, hword, 1)

#define LDIMMHALF_R5(reg, h, s, z, hword) \
        gen_ldimmhalf(reg, h, s, z, hword, 2)

#define LDSTIDXI(ptr, reg, w, sz, z, offset)  \
	gen_ldstidxi(ptr, reg, w, sz, z, offset)

#define LDST(ptr, reg, aop, sz, z, w)  \
	gen_ldst(ptr, reg, aop, sz, z, w)

#define LDSTII(ptr, reg, offset, w, op)  \
	gen_ldstii(ptr, reg, offset, w, op)

#define DSPLDST(i, m, reg, aop, w) \
	gen_dspldst(i, reg, aop, w, m)

#define LDSTPMOD(ptr, reg, idx, aop, w) \
	gen_ldstpmod(ptr, reg, aop, w, idx)

#define LDSTIIFP(offset, reg, w)  \
	gen_ldstiifp(reg, offset, w)

#define LOGI2OP(dst, src, opc) \
	gen_logi2op(opc, src, dst.regno & CODE_MASK)

#define ALU2OP(dst, src, opc)  \
	gen_alu2op(dst, src, opc)

#define BRCC(t, b, offset) \
	gen_brcc(t, b, offset)

#define UJUMP(offset) \
	gen_ujump(offset)

#define PROGCTRL(prgfunc, poprnd) \
	gen_progctrl(prgfunc, poprnd)

#define PUSHPOPMULTIPLE(dr, pr, d, p, w) \
	gen_pushpopmultiple(dr, pr, d, p, w)

#define PUSHPOPREG(reg, w) \
	gen_pushpopreg(reg, w)

#define CALLA(addr, s)  \
	gen_calla(addr, s)

#define LINKAGE(r, framesize) \
	gen_linkage(r, framesize)

#define COMPI2OPD(dst, src, op)  \
	gen_compi2opd(dst, src, op)

#define COMPI2OPP(dst, src, op)  \
	gen_compi2opp(dst, src, op)

#define DAGMODIK(i, op)  \
	gen_dagmodik(i, op)

#define DAGMODIM(i, m, op, br)  \
	gen_dagmodim(i, m, op, br)

#define COMP3OP(dst, src0, src1, opc)   \
	gen_comp3op(src0, src1, dst, opc)

#define PTR2OP(dst, src, opc)   \
	gen_ptr2op(dst, src, opc)

#define CCFLAG(x, y, opc, i, g)  \
	gen_ccflag(x, y, opc, i, g)

#define CCMV(src, dst, t) \
	gen_ccmv(src, dst, t)

#define CACTRL(reg, a, op) \
	gen_cactrl(reg, a, op)

#define LOOPSETUP(soffset, c, rop, eoffset, reg) \
	gen_loopsetup(soffset, c, rop, eoffset, reg)

// Auxiliaries: (TODO: move to bfin-defs.h)

#define HL2(r1, r0)  (IS_H(r1) << 1 | IS_H(r0))


#define IS_PLUS(o)       (o.r0 == 0)
#define IS_MINUS(o)      (o.r0 == 1)
#define IS_RANGE(bits, expr, sign, mul)    \
	value_match(expr, bits, sign, mul, 1)
#define IS_URANGE(bits, expr, sign, mul)    \
	value_match(expr, bits, sign, mul, 0)
#define IS_CONST(expr) (expr->type == ExprNodeConstant)
#define IS_RELOC(expr) (expr->type != ExprNodeConstant)
#define IS_IMM(expr, bits)  value_match(expr, bits, 0, 1, 1)
#define IS_UIMM(expr, bits)  value_match(expr, bits, 0, 1, 0)

#define IS_LIMM(expr, bits) \
	(value_match(expr, bits, 0, 1, 1))

#define IS_PCREL4(expr) \
	(value_match(expr, 4, 0, 2, 0))

#define IS_LPPCREL10(expr) \
	(value_match(expr, 10, 0, 2, 0))

#define IS_PCREL10(expr) \
	(value_match(expr, 10, 0, 2, 1))

#define IS_PCREL12(expr) \
	(value_match(expr, 12, 0, 2, 1))

#define IS_PCREL24(expr) \
	(value_match(expr, 24, 0, 2, 1))


////////////////////////////////////////////////////////////////////////////

static int value_match(ExprNode *expr, int sz, int sign, int mul, int issigned);

int nerrors;
int nwarnings;
extern FILE *errorf;
extern INSTR_T insn;


static ExprNode * binary(ExprOpType,ExprNode *,ExprNode *);
static ExprNode * unary(ExprOpType,ExprNode *);

static void notethat(char *format, ...);

char *current_inputline;
extern char *yytext;
int yyerror(char *msg);

void error (char *format, ...)
{
    va_list ap;
    char buffer[2000];
    
    va_start (ap, format);
    vsprintf (buffer, format, ap);
    va_end (ap);

    as_bad (buffer);
}


#define semantic_error(s) _semantic_error (s, __LINE__)
#define register_mismatch() _register_mismatch (__LINE__)

static
int _semantic_error (char *syntax, int line)
{
  error ("\nSyntax error:<%d>:  `%s'\n", line, syntax);
  return -1;
}

static
int _register_mismatch (int line)
{
  return _semantic_error ("Register mismatch", line);
}

int
yyerror (char *msg)
{
  error ("\n %s Input text was `%s'\n", msg, yytext);
  return 0;	/* means successful	*/
}

static int
in_range_p (ExprNode *expr, int from, int to, unsigned int mask)
{
  int val = EXPR_VALUE (expr);
  if (expr->type != ExprNodeConstant)
    return 0;
  if (val < from || val > to)
    return 0;
  return (val & mask) == 0;
}

extern int yylex (void);

#define uimm2(x) EXPR_VALUE (x)
#define uimm3(x) EXPR_VALUE (x)
#define imm3(x) EXPR_VALUE (x)
#define pcrel4(x) ((EXPR_VALUE (x)) >> 1)
#define imm4(x) EXPR_VALUE (x)
#define uimm4s4(x) ((EXPR_VALUE (x)) >> 2)
#define uimm4(x) EXPR_VALUE (x)
#define uimm4s2(x) ((EXPR_VALUE (x)) >> 1)
#define negimm5s4(x) ((EXPR_VALUE (x)) >> 2)
#define imm5(x) EXPR_VALUE (x)
#define uimm5(x) EXPR_VALUE (x)
#define imm6(x) EXPR_VALUE (x)
#define imm7(x) EXPR_VALUE (x)
#define imm8(x) EXPR_VALUE (x)
#define uimm8(x) EXPR_VALUE (x)
#define pcrel8(x) ((EXPR_VALUE (x)) >> 1)
#define uimm8s4(x) ((EXPR_VALUE (x)) >> 2)
#define pcrel8s4(x) ((EXPR_VALUE (x)) >> 2)
#define lppcrel10(x) ((EXPR_VALUE (x)) >> 1)
#define pcrel10(x) ((EXPR_VALUE (x)) >> 1)
#define pcrel12(x) ((EXPR_VALUE (x)) >> 1)
#define imm16s4(x) ((EXPR_VALUE (x)) >> 2)
#define luimm16(x) EXPR_VALUE (x)
#define imm16(x) EXPR_VALUE (x)
#define huimm16(x) EXPR_VALUE (x)
#define rimm16(x) EXPR_VALUE (x)
#define imm16s2(x) ((EXPR_VALUE (x)) >> 1)
#define uimm16s4(x) ((EXPR_VALUE (x)) >> 2)
#define uimm16(x) EXPR_VALUE (x)
#define pcrel24(x) ((EXPR_VALUE (x)) >> 1)


////////////////////////////////////////////////////////////////////////////
// Auxiliary functions
//


static
void neg_value (ExprNode *expr)
{
  expr->value.i_value = -expr->value.i_value;
}

static int
valid_dreg_pair (Register *reg1, ExprNode *reg2)
{
  if (!IS_DREG (*reg1))
    {
      semantic_error ("Dregs expected");
      return 0;
    }

  if (reg1->regno != 1 && reg1->regno != 3)
    {
      semantic_error ("Bad register pair");
      return 0;
    }

  if (imm7 (reg2) != reg1->regno - 1)
    {
      semantic_error ("Bad register pair");
      return 0;
    }

  reg1->regno--;
  return 1;
}

static int
check_multfuncs (Macfunc *aa, Macfunc *ab)
{
  if ((!REG_EQUAL(aa->s0, ab->s0) && !REG_EQUAL(aa->s0, ab->s1))
      || (!REG_EQUAL(aa->s1, ab->s1) && !REG_EQUAL(aa->s1, ab->s0)))
    return semantic_error ("Source multiplication register mismatch");

  return 0;
}


// check (vector) mac funcs and ops:

static int
check_macfuncs (Macfunc *aa, Opt_mode *opa,
		Macfunc *ab, Opt_mode *opb)
{
  // Variables for swapping:
  Macfunc mtmp;
  Opt_mode otmp;

  // if a0macfunc comes before a1macfunc, swap them.
	
  if (aa->n == 0)
    {
      // (M) is not allowed here:
      if (opa->MM != 0)
	return semantic_error ("(M) not allowed with A0MAC");
      if (ab->n != 1)
	return semantic_error ("Vector AxMACs can't be same");

      mtmp = *aa; *aa = *ab; *ab = mtmp;
      otmp = *opa; *opa = *opb; *opb = otmp;
    }
  else
    {

      if (opb->MM != 0)
	return semantic_error ("(M) not allowed with A0MAC");
      if (opa->mod != 0)
	return semantic_error ("Bad opt mode");
      if (ab->n != 0)
	return semantic_error ("Vector AxMACs can't be same");
    }

  // if both ops are != 3, we have multfuncs in both
  // assignment_or_macfuncs
  if (aa->op == ab->op && aa->op != 3)
    {
      if (check_multfuncs (aa, ab) < 0)
	return -1;
    }
  else
    {

      // only one of the assign_macfuncs has a multfunc.
      // Evil trick: Just 'OR' their source register codes:
      // We can do that, because we know they were initialized to 0
      // in the rules that don't use multfuncs.
      aa->s0.regno |= (ab->s0.regno & CODE_MASK);
      aa->s1.regno |= (ab->s1.regno & CODE_MASK);
    }

  if (aa->w == ab->w  && aa->P != ab->P)
    {
      return semantic_error ("macfuncs must differ");
      if (aa->w && (aa->dst.regno - ab->dst.regno != 1))
	return semantic_error ("Destination Dregs must differ by one");
    }
  // We assign to full regs, thus obey even/odd rules:	
  else if ((aa->w && aa->P && IS_EVEN(aa->dst)) 
	   || (ab->w && ab->P && !IS_EVEN(ab->dst)))
    return semantic_error ("Even/Odd register assignment mismatch");
  // We assign to half regs, thus obey hi/low rules:	
  else if ( (aa->w && !aa->P && !IS_H(aa->dst)) 
	    || (ab->w && !aa->P && IS_H(ab->dst)))
    return semantic_error ("High/Low register assignment mismatch");

  // Make sure first macfunc has got both P flags ORed
  aa->P |= ab->P;

  // Make sure mod flags get ORed, too
  opb->mod |= opa->mod;
  return 0;	
}


static int
is_group1 (INSTR_T x)
{
  if ((x->value & 0xc000) == 0x8000  //dspLDST,LDSTpmod,LDST,LDSTiiFP,LDSTii
      || (x->value == 0x0000))
    return 1;
  return 0;
}

static int
is_group2 (INSTR_T x)
{
  if ((((x->value & 0xfc00) == 0x9c00)  // pick dspLDST
       && !((x->value & 0xfde0) == 0x9c60)  // pick dagMODim
       && !((x->value & 0xfde0) == 0x9ce0)  // pick dagMODim with bit rev
       && !((x->value & 0xfde0) == 0x9d60)) // pick dagMODik
      || (x->value == 0x0000))
    return 1;
  return 0;
}

%}

%union {
  INSTR_T instr;
  ExprNode *expr;
  SYMBOL_T symbol;
  long value;
  // new encoding of registers
  Register reg;

  Macfunc macfunc;
  struct { int r0; int s0; int x0; int aop; } modcodes;
  struct { int r0; } r0;
  Opt_mode mod;
}


/***************************************************************************/
/* Tokens                                                                  */
/***************************************************************************/

// Vector specific
%token BYTEOP16P BYTEOP16M
%token BYTEOP1P BYTEOP2P BYTEOP2M BYTEOP3P
%token BYTEUNPACK BYTEPACK
%token PACK
%token SAA
%token ALIGN8 ALIGN16 ALIGN24
%token VIT_MAX
%token EXTRACT DEPOSIT EXPADJ SEARCH
%token ONES SIGN SIGNBITS

// stack
%token LINK UNLINK

// registers
%token REG
%token PC
%token CCREG BYTE_REG
%token REG_A00 REG_A11
%token A_ZERO_DOT_L A_ZERO_DOT_H A_ONE_DOT_L A_ONE_DOT_H
%token HALF_REG

// progctrl
%token NOP
%token RTI RTS RTX RTN RTE
%token HLT IDLE
%token STI CLI
%token CSYNC SSYNC
%token EMUEXCPT
%token RAISE EXCPT
%token LSETUP
%token DISALGNEXCPT
%token JUMP JUMP_DOT_S JUMP_DOT_L
%token CALL

// emulator only
%token ABORT

// operators
%token NOT TILDA BANG
%token AMPERSAND BAR
%token PERCENT
%token CARET
%token BXOR

%token MINUS PLUS STAR SLASH
%token NEG
%token MIN MAX ABS
%token DOUBLE_BAR
%token _PLUS_BAR_PLUS _PLUS_BAR_MINUS _MINUS_BAR_PLUS _MINUS_BAR_MINUS
%token _MINUS_MINUS _PLUS_PLUS

// shift/rotate ops
%token SHIFT LSHIFT ASHIFT BXORSHIFT
%token _GREATER_GREATER_GREATER_THAN_ASSIGN
%token ROT
%token LESS_LESS GREATER_GREATER  
%token _GREATER_GREATER_GREATER
%token _LESS_LESS_ASSIGN _GREATER_GREATER_ASSIGN
%token DIVS DIVQ

// in place operators
%token ASSIGN _STAR_ASSIGN
%token _BAR_ASSIGN _CARET_ASSIGN _AMPERSAND_ASSIGN
%token _MINUS_ASSIGN _PLUS_ASSIGN

// assignments, comparisons
%token _ASSIGN_BANG _LESS_THAN_ASSIGN _ASSIGN_ASSIGN
%token GE LT LE GT
%token LESS_THAN

// cache
%token FLUSHINV FLUSH
%token IFLUSH PREFETCH

// misc
%token PRNT
%token OUTC
%token WHATREG
%token TESTSET

// modifiers
%token ASL ASR
%token B W
%token NS S CO SCO
%token TH TL
%token BP
%token BREV
%token X Z
%token M MMOD
%token R RND RNDL RNDH RND12 RND20
%token V
%token LO HI

// bit ops
%token BITTGL BITCLR BITSET BITTST BITMUX

// debug
%token DBGAL DBGAH DBGHALT DBG DBGA DBGCMPLX

// semantic auxiliaries

%token IF COMMA BY
%token COLON SEMICOLON
%token RPAREN LPAREN LBRACK RBRACK
%token MODIFIED_STATUS_REG
%token MNOP
%token SYMBOL NUMBER
%token GOT AT PLTPC

/***************************************************************************/
/* Types                                                                   */
/***************************************************************************/
%type<instr> asm
%type<value> MMOD
%type<mod> opt_mode

// %type<expr> offset_expr
%type<value> NUMBER
%type<r0> aligndir
%type<modcodes> byteop_mod
%type<reg> a_assign
%type<reg> a_plusassign
%type<reg> a_minusassign
%type<macfunc> multfunc
%type<macfunc> assign_macfunc 
%type<macfunc> a_macfunc 
%type<expr> expr_1
%type<instr> asm_1
%type<r0> vmod
%type<modcodes> vsmod
%type<modcodes> ccstat
%type<r0> cc_op
%type<reg> CCREG

%type<r0> searchmod
%type<expr> symbol
%type<symbol> SYMBOL
%type<expr> eterm
%type<reg> REG
%type<reg> BYTE_REG
%type<reg> REG_A00
%type<reg> REG_A11
%type<reg> REG_A
%type<reg> MODIFIED_STATUS_REG 
%type<expr> expr
%type<r0> xpmod
%type<r0> xpmod1
%type<modcodes> smod 
%type<modcodes> b3_op
%type<modcodes> rnd_op
%type<modcodes> post_op
%type<reg> HALF_REG
%type<r0> iu_or_nothing
%type<r0> plus_minus
%type<r0> asr_asl
%type<r0> asr_asl_0
%type<modcodes> sco
%type<modcodes> amod0
%type<modcodes> amod1
%type<modcodes> amod2
%type<r0> op_bar_op
%type<r0> w32_or_nothing
%type<r0> c_align
%type<r0> min_max
%type<expr> got
%type<expr> got_or_expr
%type<expr> pltpc


/* Precedence Rules */
%left BAR
%left CARET
%left AMPERSAND
%left LESS_LESS GREATER_GREATER
%left PLUS MINUS
%left STAR SLASH PERCENT

%right ASSIGN

%right TILDA BANG
%start asm_or_directive
%%
asm_or_directive:
	{ INIT_ASM(); }
	asm
	{ insn=$2; return (1); }
;

asm: asm_1 SEMICOLON
	// Parallel instructions:
	| asm_1 DOUBLE_BAR asm_1 DOUBLE_BAR asm_1 SEMICOLON
	{
	  if (($1->value & 0xf800) == 0xc000)
	    {
	      if (is_group1 ($3) && is_group2 ($5))
		$$ = gen_multi_instr($1, $3, $5);
	      else if (is_group2 ($3) && is_group1 ($5))
		$$ = gen_multi_instr($1, $5, $3);
	      else
		return semantic_error ("Wrong 16 bit instructions groups");
	    }
	  else
	    error ("\nIllegal Multi Issue Construct, first instruction must be DSP32\n");
	}

	| MNOP DOUBLE_BAR asm_1 DOUBLE_BAR asm_1 SEMICOLON
	{
	  if (is_group1 ($3) && is_group2 ($5))
	    $$ = gen_multi_instr(0, $3, $5);
	  else if (is_group2 ($3) && is_group1 ($5))
	    $$ = gen_multi_instr(0, $5, $3);
	  else
	    return semantic_error ("Wrong 16 bit instructions groups");
	}

	| MNOP DOUBLE_BAR asm_1 SEMICOLON
	{
	  if (is_group1 ($3))
	    $$ = gen_multi_instr(0, $3, 0);
	  else if (is_group2 ($3)) 
	    $$ = gen_multi_instr(0, 0, $3);
	  else 
	    return semantic_error ("Wrong 16 bit instructions groups");
	}

	| MNOP SEMICOLON
	{
	  $$ = gen_multi_instr(0, 0, 0);
	}

	| asm_1 DOUBLE_BAR asm_1 SEMICOLON
	{
	  if (($1->value & 0xf800) == 0xc000)
	    {
	      if (is_group1 ($3))
		$$ = gen_multi_instr($1, $3, 0);
	      else if (is_group2 ($3))
		$$ = gen_multi_instr($1, 0, $3);
	      else
		return semantic_error ("Wrong 16 bit instructions groups");
	    }
	  else if (is_group1 ($1) && is_group2 ($3))
	      $$ = gen_multi_instr(0, $1, $3);
	  else if (is_group2 ($1) && is_group1 ($3))
	    $$ = gen_multi_instr(0, $3, $1);
	  else
	    return semantic_error ("Wrong 16 bit instructions groups");
	}

	| error { $$ = 0; as_bad ("\nParse error.\n"); yyerrok; }  // recovery error
;

////////////////////////////////////////////////////////////////////////////
// DSPMAC
// {

asm_1:   

	assign_macfunc opt_mode
	{
	  int op0, op1;
	  int w0 = 0, w1 = 0;
	  int h00, h10, h01, h11;

	  if ($1.n == 0)
	    {
	      if ($2.MM) 
		return semantic_error ("(m) not allowed with a0 unit");
	      op1 = 3; op0 = $1.op;
	      w1 = 0; w0 = $1.w;
	      h00 = IS_H ($1.s0); h10 = IS_H ($1.s1);
	      h01 = h11 = 0;
	    }
	  else
	    {
	      op1 = $1.op; op0 = 3;
	      w1 = $1.w; w0 = 0;
	      h00 = h10 = 0;
	      h01 = IS_H ($1.s0); h11 = IS_H ($1.s1);
	    }
	  
	  $$ = DSP32MAC (op1, $2.MM, $2.mod, w1, $1.P, h01, h11, h00, h10,
			 &$1.dst, op0, &$1.s0, &$1.s1, w0);
	}

////////////////////////////////////////////////////////////////////////////
// VECTOR MACs
// }{

	| assign_macfunc opt_mode COMMA assign_macfunc opt_mode
	{
	  Register *dst;

	  if (check_macfuncs(&$1, &$2, &$4, &$5) < 0) 
	    return -1;
	  notethat("assign_macfunc (.), assign_macfunc (.)\n");

	  if ($1.w)  // a1macfunc destination
	    dst = &$1.dst;
	  else
	    dst = &$4.dst;

	  $$ = DSP32MAC ($1.op, $2.MM, $5.mod, $1.w, $1.P,
			 IS_H ($1.s0),  IS_H ($1.s1), IS_H ($4.s0), IS_H ($4.s1),
			 dst, $4.op, &$1.s0, &$1.s1, $4.w);
	}

// }
////////////////////////////////////////////////////////////////////////////
// DSPALU
// { 

	| DISALGNEXCPT
	{
	  notethat("dsp32alu: DISALGNEXCPT\n");

	  $$ = DSP32ALU (18, 0, 0, 0, 0, 0, 0, 0, 3);
	}

	| REG ASSIGN LPAREN a_plusassign REG_A RPAREN
	{
	  if (IS_DREG ($1) && !IS_A1 ($4) && IS_A1 ($5))
	    {
	      notethat("dsp32alu: dregs = ( A0 += A1 )\n");
	      $$ = DSP32ALU (11, 0, 0, &$1, 0, 0, 0, 0, 0);
	    }
	  else 
	    return register_mismatch();
	}	

	| HALF_REG ASSIGN LPAREN a_plusassign REG_A RPAREN
	{
	  if (!IS_A1 ($4) && IS_A1 ($5))
	    {
	      notethat("dsp32alu: dregs_half = ( A0 += A1 )\n");
	      $$ = DSP32ALU (11, IS_H ($1), 0, &$1, 0, 0, 0, 0, 1);
	    }
	  else
	    return register_mismatch();
	}

/* 2 rules compacted */
	| A_ZERO_DOT_H ASSIGN HALF_REG
	{
	  notethat("dsp32alu: A_ZERO_DOT_H = dregs_hi\n");
	  $$ = DSP32ALU (9, IS_H ($3), 0, 0, &$3, 0, 0, 0, 0);
	}

/* 2 rules compacted */
	| A_ONE_DOT_H ASSIGN HALF_REG
	{
	  notethat("dsp32alu: A_ZERO_DOT_H = dregs_hi\n");
	  $$ = DSP32ALU (9, IS_H ($3), 0, 0, &$3, 0,
			 0, 0, 2);

	}

	| LPAREN REG COMMA REG RPAREN ASSIGN BYTEOP16P LPAREN REG COLON expr COMMA
	  REG COLON expr RPAREN aligndir
	{
	  if (!IS_DREG ($2) || !IS_DREG ($4))
	    return semantic_error ("Dregs expected");
	  else if (!valid_dreg_pair (&$9, $11))
	    return semantic_error ("Bad dreg pair");
	  else if (!valid_dreg_pair (&$13, $15))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: (dregs , dregs ) = BYTEOP16P (dregs_pair , dregs_pair ) (half)\n");
	      $$ = DSP32ALU (21, 0, &$2, &$4, &$9, &$13, $17.r0, 0, 0);
	    }
	}

	| LPAREN REG COMMA REG RPAREN ASSIGN BYTEOP16M LPAREN REG COLON expr COMMA
	  REG COLON expr RPAREN aligndir 
	{
	  if (!IS_DREG ($2) || !IS_DREG($4))
	    return semantic_error ("Dregs expected");
	  else if (!valid_dreg_pair (&$9, $11))
	    return semantic_error ("Bad dreg pair");
	  else if (!valid_dreg_pair (&$13, $15))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: (dregs , dregs ) = BYTEOP16M (dregs_pair , dregs_pair ) (aligndir)\n");
	      $$ = DSP32ALU (21, 0, &$2, &$4, &$9, &$13, $17.r0, 0, 1);
	    }
	}

	| LPAREN REG COMMA REG RPAREN ASSIGN BYTEUNPACK REG COLON expr aligndir
	{
	  if (!IS_DREG ($2) || !IS_DREG ($4))
	    return semantic_error ("Dregs expected");
	  else if (!valid_dreg_pair (&$8, $10))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: (dregs , dregs ) = BYTEUNPACK dregs_pair (aligndir)\n");
	      $$ = DSP32ALU (24, 0, &$2, &$4, &$8, 0, $11.r0, 0, 1);
	    }
	}

	| LPAREN REG COMMA REG RPAREN ASSIGN SEARCH REG LPAREN searchmod RPAREN
	{
	  if (IS_DREG ($2) && IS_DREG ($4) && IS_DREG ($8))
	    {
	      notethat("dsp32alu: (dregs , dregs ) = SEARCH dregs (searchmod)\n");
	      $$ = DSP32ALU (13, 0, &$2, &$4, &$8, 0, 0, 0, $10.r0);
	    }
	  else
	    return register_mismatch();
	}

	| REG ASSIGN A_ONE_DOT_L PLUS A_ONE_DOT_H COMMA
	  REG ASSIGN A_ZERO_DOT_L PLUS A_ZERO_DOT_H
	{
	  if (IS_DREG ($1) && IS_DREG ($7))
	    {
	      notethat("dsp32alu: dregs = A1.l + A1.h, dregs = A0.l + A0.h  \n");
	      $$ = DSP32ALU (12, 0, &$1, &$7, 0, 0, 0, 0, 1);
	    }
	  else
	    return register_mismatch();
	}


	| REG ASSIGN REG_A PLUS REG_A COMMA REG ASSIGN REG_A MINUS REG_A amod1 
	{
	  if (IS_DREG ($1) && IS_DREG ($7) && !REG_SAME ($3, $5)
	      && IS_A1 ($9) && !IS_A1 ($11))
	    {
	      notethat("dsp32alu: dregs = A1 + A0 , dregs = A1 - A0 (amod1)\n");
	      $$ = DSP32ALU (17, 0, &$1, &$7, 0, 0, $12.s0, $12.x0, 0);
	      
	    }
	  else if (IS_DREG ($1) && IS_DREG ($7) && !REG_SAME ($3, $5)
		   && !IS_A1 ($9) && IS_A1 ($11))
	    {
	      notethat("dsp32alu: dregs = A0 + A1 , dregs = A0 - A1 (amod1)\n");
	      $$ = DSP32ALU (17, 0, &$1, &$7, 0, 0, $12.s0, $12.x0, 1);
	    }
	  else
	    return register_mismatch ();
	}

	| REG ASSIGN REG plus_minus REG COMMA REG ASSIGN REG plus_minus REG amod1
	{
	  if ($4.r0 == $10.r0) 
	    return semantic_error ("Operators must differ");

	  if (IS_DREG ($1) && IS_DREG ($3) && IS_DREG ($5)
	      && REG_SAME ($3, $9) && REG_SAME ($5, $11))
	    {
	      notethat("dsp32alu: dregs = dregs + dregs,"
		       "dregs = dregs - dregs (amod1)\n");
	      $$ = DSP32ALU (4, 0, &$1, &$7, &$3, &$5, $12.s0, $12.x0, 2);
	    }
	  else
	    return register_mismatch ();
	}

// Bar operations:

	| REG ASSIGN REG op_bar_op REG COMMA REG ASSIGN REG op_bar_op REG amod2 
	{
	  if (!REG_SAME ($3, $9) || !REG_SAME ($5, $11))
	    return semantic_error ("Differing source registers");

	  if (!IS_DREG ($1) || !IS_DREG ($3) || !IS_DREG ($5) || !IS_DREG ($7)) 
	    return semantic_error ("Dregs expected");

	
	  if ($4.r0 == 1 && $10.r0 == 2)
	    {
	      notethat("dsp32alu:  dregs = dregs .|. dregs , dregs = dregs .|. dregs (amod2)\n");
	      $$ = DSP32ALU (1, 1, &$1, &$7, &$3, &$5, $12.s0, $12.x0, $12.r0);
	    }
	  else if ($4.r0 == 0 && $10.r0 == 3)
	    {
	      notethat("dsp32alu:  dregs = dregs .|. dregs , dregs = dregs .|. dregs (amod2)\n");
	      $$ = DSP32ALU (1, 0, &$1, &$7, &$3, &$5, $12.s0, $12.x0, $12.r0);
	    }
	  else
	    return semantic_error ("Bar operand mismatch");
	}

	| REG ASSIGN ABS REG vmod
	{
	  int op;

	  if (IS_DREG ($1) && IS_DREG ($4))
	    {
	      if ($5.r0)
		{
		  notethat("dsp32alu: dregs = ABS dregs (v)\n");
		  op = 6;
		}
	      else
		{
		  // Vector version of ABS
		  notethat("dsp32alu: dregs = ABS dregs\n");
		  op = 7;
		}
	      $$ = DSP32ALU (op, 0, 0, &$1, &$4, 0, 0, 0, 2);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

/* 4 rules compacted */
	| a_assign ABS REG_A
	{
	  notethat("dsp32alu: Ax = ABS Ax\n");
	  $$ = DSP32ALU (16, IS_A1 ($1), 0, 0, 0, 0, 0, 0, IS_A1 ($3));
	}

	| A_ZERO_DOT_L ASSIGN HALF_REG
	{
	  if (IS_DREG_L($3))
	    {
	      notethat("dsp32alu: A0.l = reg_half\n");
	      $$ = DSP32ALU (9, IS_H ($3), 0, 0, &$3, 0, 0, 0, 0);
	    }
	  else
	    return semantic_error ("A0.l = Rx.l expected");
	}

	| A_ONE_DOT_L ASSIGN HALF_REG
	{
	  if (IS_DREG_L($3))
	    {
	      notethat("dsp32alu: A1.l = reg_half\n");
	      $$ = DSP32ALU (9, IS_H ($3), 0, 0, &$3, 0, 0, 0, 2);
	    }
	  else
	    return semantic_error ("A1.l = Rx.l expected");
	}

	| REG ASSIGN c_align LPAREN REG COMMA REG RPAREN
	{
	  if (IS_DREG ($1) && IS_DREG ($5) && IS_DREG ($7))
	    {
	      notethat("dsp32shift: dregs = ALIGN8 (dregs , dregs )\n");
	      $$ = DSP32SHIFT (13, &$1, &$7, &$5, $3.r0, 0);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

 	| REG ASSIGN BYTEOP1P LPAREN REG COLON expr COMMA REG COLON expr RPAREN byteop_mod
	{
	  if (!IS_DREG ($1))
	    return semantic_error ("Dregs expected");
	  else if (!valid_dreg_pair (&$5, $7))
	    return semantic_error ("Bad dreg pair");
	  else if (!valid_dreg_pair (&$9, $11))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: dregs = BYTEOP1P (dregs_pair , dregs_pair ) (T)\n");
	      $$ = DSP32ALU (20, 0, 0, &$1, &$5, &$9, $13.s0, 0, $13.r0);
	    }
	}
 	| REG ASSIGN BYTEOP1P LPAREN REG COLON expr COMMA REG COLON expr RPAREN
	{
	  if (!IS_DREG ($1))
	    return semantic_error ("Dregs expected");
	  else if (!valid_dreg_pair (&$5, $7))
	    return semantic_error ("Bad dreg pair");
	  else if (!valid_dreg_pair (&$9, $11))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: dregs = BYTEOP1P (dregs_pair , dregs_pair ) (T)\n");
	      $$ = DSP32ALU (20, 0, 0, &$1, &$5, &$9, 0, 0, 0);
	    }
	}

	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN
	  rnd_op
	{
	  if (!IS_DREG ($1))
	    return semantic_error ("Dregs expected");
	  else if (!valid_dreg_pair (&$5, $7))
	    return semantic_error ("Bad dreg pair");
	  else if (!valid_dreg_pair (&$9, $11))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: dregs = BYTEOP2P (dregs_pair , dregs_pair ) (rnd_op)\n");
	      $$ = DSP32ALU (22, $13.r0, 0, &$1, &$5, &$9, $13.s0, $13.x0, $13.aop);
	    }
	}

/* 8 rules compacted */
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN
	  rnd_op
	{
	  if (!IS_DREG ($1))
	    return semantic_error ("Dregs expected");
	  else if (!valid_dreg_pair (&$5, $7))
	    return semantic_error ("Bad dreg pair");
	  else if (!valid_dreg_pair (&$9, $11))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: dregs = BYTEOP2P (dregs_pair , dregs_pair ) (rnd_op)\n");
	      $$ = DSP32ALU (22, $13.r0, 0, &$1, &$5, &$9, $13.s0, 0, $13.x0);
	    }
	}

	| REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN
	  b3_op
	{
	  if (!IS_DREG ($1))
	    return semantic_error ("Dregs expected");
	  else if (!valid_dreg_pair (&$5, $7))
	    return semantic_error ("Bad dreg pair");
	  else if (!valid_dreg_pair (&$9, $11))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: dregs = BYTEOP3P (dregs_pair , dregs_pair ) (b3_op)\n");
	      $$ = DSP32ALU (23, $13.x0, 0, &$1, &$5, &$9, $13.s0, 0, 0);
	    }
	}

	| REG ASSIGN BYTEPACK LPAREN REG COMMA REG RPAREN
	{
	  if (IS_DREG ($1) && IS_DREG ($5) && IS_DREG ($7))
	    {
	      notethat("dsp32alu: dregs = BYTEPACK (dregs , dregs )\n");
		$$ = DSP32ALU (24, 0, 0, &$1, &$5, &$7, 0, 0, 0);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| HALF_REG ASSIGN HALF_REG ASSIGN SIGN LPAREN HALF_REG RPAREN STAR
	  HALF_REG PLUS SIGN LPAREN HALF_REG RPAREN STAR HALF_REG 
	{
	  if (IS_HCOMPL($1, $3) && IS_HCOMPL($7, $14) && IS_HCOMPL($10, $17))
	    {
	      notethat("dsp32alu:	dregs_hi = dregs_lo ="
		       "SIGN (dregs_hi) * dregs_hi + "
		       "SIGN (dregs_lo) * dregs_lo \n");

		$$ = DSP32ALU (12, 0, 0, &$1, &$7, &$10, 0, 0, 0);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

// XXX This is an 'intrinsically redundant' one. (Nice word, huh ?)
//     We have a problem if we want to use this in a parallel instruction
//     where we have to use the 32 bit variant instead of the 16 bit one
//     of this assigment. Do we solve this with an assembler flag or
//     'switch' the opcodes if we detect a parallel command being issued ?
	| REG ASSIGN REG plus_minus REG amod1 
	{
	  if (IS_DREG ($1) && IS_DREG ($3) && IS_DREG ($5))
	    {
	      // XXX For the moment, we always use the 16 bit variant
	      if (0)
		{
		  notethat("dsp32alu: dregs = dregs +- dregs (amod1)\n");
		  $$ = DSP32ALU (4, 0, 0, &$1, &$3, &$5, $6.s0, $6.x0, $4.r0);
		}
	      else
		{
		  notethat("COMP3op: dregs = dregs +- dregs\n");
		  $$ = COMP3OP (&$1, &$3, &$5, $4.r0);
		}
	    }
	  else
	    if (IS_PREG ($1) && IS_PREG ($3) && IS_PREG ($5) && $4.r0 == 0)
	      {
		notethat("COMP3op: pregs = pregs + pregs\n");
		$$ = COMP3OP (&$1, &$3, &$5, 5);
	      }
	    else
	      return semantic_error ("Dregs expected");
	}

/* 4 rules compacted */
	| REG ASSIGN min_max LPAREN REG COMMA REG RPAREN vmod
	{
	  int op;

	  if (IS_DREG ($1) && IS_DREG ($5) && IS_DREG ($7))
	    {
	      if ($9.r0)
		op = 6;
	      else
		op = 7;

	      notethat("dsp32alu: dregs = {MIN|MAX} (dregs, dregs)\n");
	      $$ = DSP32ALU (op, 0, 0, &$1, &$5, &$7, 0, 0, $3.r0);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| a_assign MINUS REG_A
	{
	  notethat("dsp32alu: Ax = - Ax\n");
	  $$ = DSP32ALU (14, IS_A1 ($1), 0, 0, 0, 0, 0, 0, IS_A1 ($3));
	}

/* 16 rules compacted */
	| HALF_REG ASSIGN HALF_REG plus_minus HALF_REG amod1
	{
	  notethat("dsp32alu: dregs_lo = dregs_lo +- dregs_lo (amod1)\n");
	  $$ = DSP32ALU (2 | $4.r0, IS_H ($1), 0, &$1, &$3, &$5,
			 $6.s0, $6.x0, HL2 ($3, $5));
	}

	| a_assign a_assign expr
	{
	  if (EXPR_VALUE ($3) == 0 && !REG_SAME ($1, $2))
	    {
	      notethat("dsp32alu: A1 = A0 = 0\n");
	      $$ = DSP32ALU (8, 0, 0, 0, 0, 0, 0, 0, 2);
	    }
	  else
	    return semantic_error ("Bad value, 0 expected");
	}

// saturating:
	| a_assign REG_A LPAREN S RPAREN
	{
	  if (REG_SAME ($1, $2))
	    {
	      notethat("dsp32alu: Ax = Ax (S)\n");
	      $$ = DSP32ALU (8, 0, 0, 0, 0, 0, 1, 0, IS_A1 ($1));
	    }
	  else
	    return semantic_error ("Registers must be equal");
	}

	| HALF_REG ASSIGN REG LPAREN RND RPAREN
	{
	  if (IS_DREG ($3))
	    {
	      notethat("dsp32alu: dregs_half = dregs (RND)\n");
	      $$ = DSP32ALU (12, IS_H ($1), 0, &$1, &$3, 0, 0, 0, 3);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| HALF_REG ASSIGN REG plus_minus REG LPAREN RND12 RPAREN
	{
	  if (IS_DREG ($3) && IS_DREG ($5))
	    {
	      notethat("dsp32alu: dregs_half = dregs (+-) dregs (RND12)\n");
	      $$ = DSP32ALU (5, IS_H ($1), 0, &$1, &$3, &$5, 0, 0, $4.r0);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| HALF_REG ASSIGN REG plus_minus REG LPAREN RND20 RPAREN
	{
	  if (IS_DREG ($3) && IS_DREG ($5))
	    {
	      notethat("dsp32alu: dregs_half = dregs -+ dregs (RND20)\n");
	      $$ = DSP32ALU (5, IS_H ($1), 0, &$1, &$3, &$5, 0, 1, $4.r0 | 2);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| a_assign REG_A 
	{
	  if (!REG_SAME ($1, $2))
	    {
	      notethat("dsp32alu: An = Am\n");
	      $$ = DSP32ALU (8, 0, 0, 0, 0, 0, IS_A1 ($1), 0, 3);
	    }
	  else
	    return semantic_error ("Accu reg arguments must differ");
	}

	| a_assign REG
	{
	  if (IS_DREG ($2))
	    {
	      notethat("dsp32alu: An = dregs\n");
	      $$ = DSP32ALU (9, 0, 0, 0, &$2, 0, 1, 0, IS_A1 ($1) << 1);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| REG ASSIGN HALF_REG xpmod
	{
	  if (!IS_H ($3))
	    {
	      if ($1.regno == REG_A0x && IS_DREG ($3))
		{
		  notethat("dsp32alu: A0.x = dregs_lo\n");
		  $$ = DSP32ALU (9, 0, 0, 0, &$3, 0, 0, 0, 1);
		}
	      else if ($1.regno == REG_A1x && IS_DREG ($3))
		{
		  notethat("dsp32alu: A1.x = dregs_lo\n");
		  $$ = DSP32ALU (9, 0, 0, 0, &$3, 0, 0, 0, 3);
		}
	      else if (IS_DREG ($1) && IS_DREG ($3))
		{
		  notethat("ALU2op: dregs = dregs_lo\n");
		  $$ = ALU2OP (&$1, &$3, 10 | ($4.r0 ? 0: 1));   // dst, src, opc
		}
	      else
		return register_mismatch();
	    }
	  else
	    return semantic_error ("Low reg expected");
	}

	| HALF_REG ASSIGN expr
	{
	  notethat("LDIMMhalf: pregs_half = sym32\n");
	  $$ = LDIMMHALF_R (&$1, IS_H ($1), 0, 0, $3);

	}

	| a_assign expr
	{
	  notethat("dsp32alu: An = 0\n");

	  if (imm7 ($2) != 0)
	    return semantic_error ("0 expected");

	  $$ = DSP32ALU (8, 0, 0, 0, 0, 0, 0, 0, IS_A1 ($1));
	}

/* 2 rules compacted */
	| REG ASSIGN expr xpmod1
	{
	  if ($4.r0 == 0)
	    {
	      // Default: (x)
	      /* 7 bit immediate value if possible.
		 We will check for that constant value for efficiency
		 If it goes to reloc, it will be 16 bit
	      */
	      if (IS_CONST($3) && IS_IMM ($3, 7) && (IS_DREG ($1) || IS_PREG ($1)))
		{
		  /* if the expr is a relocation, generate it */
		  if (IS_DREG ($1) && IS_IMM ($3, 7))
		    {
		      notethat("COMPI2opD: dregs = imm7 (x) \n");
		      $$ = COMPI2OPD (&$1, imm7 ($3), 0);
		    }
		  else if (IS_PREG ($1) && IS_IMM ($3, 7))
		    {
		      notethat("COMPI2opP: pregs = imm7 (x)\n");
		      $$ = COMPI2OPP (&$1, imm7 ($3), 0);
		    }
		  else
		    return semantic_error ("Bad register or value for assigment");
		}
	      else
		{
		  notethat("LDIMMhalf: regs = luimm16 (x)\n");
		  /*      reg, H, S, Z  */
		  $$ = LDIMMHALF_R5 (&$1, 0, 1, 0, $3);
		} 
	    }
	  else
	    {
	      // (z)
	      /* there is no 7 bit zero extended instruction */
	      /* if the expr is a relocation, generate it */
	      notethat("LDIMMhalf: regs = luimm16 (x)\n");
	      /*      reg, H, S, Z  */
	      $$ = LDIMMHALF_R5 (&$1, 0, 0, 1, $3);
	    }
	}

	| HALF_REG ASSIGN REG
	{
	  if (IS_H ($1))
	    return semantic_error ("Low reg expected");

	  if (IS_DREG ($1) && $3.regno == REG_A0x)
	    {
	      notethat("dsp32alu: dregs_lo = A0.x\n");
	      $$ = DSP32ALU (10, 0, 0, &$1, 0, 0, 0, 0, 0);
	    }
	  else if (IS_DREG ($1) && $3.regno == REG_A1x)
	    {
	      notethat("dsp32alu: dregs_lo = A1.x\n");
	      $$ = DSP32ALU (10, 0, 0, &$1, 0, 0, 0, 0, 1);
	    }
	  else
	    return register_mismatch ();
	}

/* 4 rules compacted */
	| REG ASSIGN REG op_bar_op REG amod0 
	{
	  if (IS_DREG ($1) && IS_DREG ($3) && IS_DREG ($5))
	    {
	      notethat("dsp32alu: dregs = dregs .|. dregs (amod0)\n");
	      $$ = DSP32ALU (0, 0, 0, &$1, &$3, &$5, $6.s0, $6.x0, $4.r0);
	    }
	  else
	    return register_mismatch ();
	}

	| REG ASSIGN BYTE_REG xpmod
	{
	  if (IS_DREG ($1) && IS_DREG ($3))
	    {
	      notethat("ALU2op: dregs = dregs_byte\n");
	      $$ = ALU2OP (&$1, &$3, 12 | ($4.r0 ? 0: 1));   // dst, src, opc
	    }
	  else
	    return register_mismatch ();
	}

	| a_assign ABS REG_A COMMA a_assign ABS REG_A
	{
	  if (REG_SAME ($1, $3) && REG_SAME ($5, $7) && !REG_SAME ($1, $5))
	    {
	      notethat("dsp32alu: A1 = ABS A1 , A0 = ABS A0\n");
	      $$ = DSP32ALU (16, 0, 0, 0, 0, 0, 0, 0, 3);
	    }
	  else
	    return register_mismatch ();
	}

	| a_assign MINUS REG_A COMMA a_assign MINUS REG_A
	{
	  if (REG_SAME ($1, $3) && REG_SAME ($5, $7) && !REG_SAME ($1, $5))
	    {
	      notethat("dsp32alu: A1 = - A1 , A0 = - A0\n");
	      $$ = DSP32ALU (14, 0, 0, 0, 0, 0, 0, 0, 3);
	    }
	  else
	    return register_mismatch ();
	}

	| a_minusassign REG_A w32_or_nothing
	{
	  if (!IS_A1 ($1) && IS_A1 ($2))
	    {
	      notethat("dsp32alu: A0 -= A1\n");
	      $$ = DSP32ALU (11, 0, 0, 0, 0, 0, $3.r0, 0, 3);
	    }
	  else
	    return register_mismatch ();
	}

	| REG _MINUS_ASSIGN expr
	{
	  if (IS_IREG ($1) && EXPR_VALUE ($3) == 4)
	    {
	      notethat("dagMODik: iregs -= 4\n");
	      $$ = DAGMODIK (&$1, 3);
	    }
	  else if (IS_IREG ($1) && EXPR_VALUE ($3) == 2)
	    {
	      notethat("dagMODik: iregs -= 2\n");
	      $$ = DAGMODIK (&$1, 1);
	    }
	  else
	    return semantic_error ("Register or value mismatch");
	}

	| REG _PLUS_ASSIGN REG LPAREN BREV RPAREN
	{
	  if (IS_IREG ($1) && IS_MREG ($3))
	    {
	      notethat("dagMODim: iregs += mregs (opt_brev)\n");
	      /*         i          m  op  br */
	      $$ = DAGMODIM (&$1, &$3, 0, 1);
	    }
	  else if (IS_PREG ($1) && IS_PREG ($3))
	    {
	      notethat("PTR2op: pregs += pregs (BREV )\n");
	      $$ = PTR2OP (&$1, &$3, 5);
	    }
	  else
	    return register_mismatch ();
	}

	| REG _MINUS_ASSIGN REG
	{
	  if (IS_IREG ($1) && IS_MREG ($3))
	    {
	      notethat("dagMODim: iregs -= mregs\n");
	      $$ = DAGMODIM (&$1, &$3, 1, 0);
	    }
	  else if (IS_PREG ($1) && IS_PREG ($3))
	    {
	      notethat("PTR2op: pregs -= pregs\n");
	      $$ = PTR2OP (&$1, &$3, 0);
	    }
	  else
	    return register_mismatch ();
	}

	| REG_A _PLUS_ASSIGN REG_A w32_or_nothing
	{
	  if (!IS_A1 ($1) && IS_A1 ($3))
	    {
	      notethat("dsp32alu: A0 += A1 (W32)\n");
	      $$ = DSP32ALU (11, 0, 0, 0, 0, 0, $4.r0, 0, 2);
	    }
	  else
	    return register_mismatch ();
	}

	| REG _PLUS_ASSIGN REG
	{
	  if (IS_IREG ($1) && IS_MREG ($3))
	    {
	      notethat("dagMODim: iregs += mregs\n");
	      $$ = DAGMODIM (&$1, &$3, 0, 0);
	    }
	  else
	    return semantic_error ("iregs += mregs expected");
	}

	| REG _PLUS_ASSIGN expr
	{
	  if (IS_IREG ($1))
	    {
	      if (EXPR_VALUE ($3) == 4)
		{
		  notethat("dagMODik: iregs += 4\n");
		  $$ = DAGMODIK (&$1, 2);
		}
	      else if (EXPR_VALUE ($3) == 2)
		{
		  notethat("dagMODik: iregs += 2\n");
		  $$ = DAGMODIK (&$1, 0);
		}
	      else
		return semantic_error ("iregs += [ 2 | 4 ");
	    }
	  else if (IS_PREG ($1) && IS_IMM ($3, 7))
	    {
	      notethat("COMPI2opP: pregs += imm7\n");
	      $$ = COMPI2OPP (&$1, imm7 ($3), 1);
	    }
	  else if (IS_DREG ($1) && IS_IMM ($3, 7))
	    {
	      notethat("COMPI2opD: dregs += imm7\n");
	      $$ = COMPI2OPD (&$1, imm7 ($3), 1);
	    }
	  else
	    return register_mismatch ();
	}

 	| REG _STAR_ASSIGN REG
	{
	  if (IS_DREG ($1) && IS_DREG ($3))
	    {
	      notethat("ALU2op: dregs *= dregs\n");
	      $$ = ALU2OP (&$1, &$3, 3);   // dst, src, opc
	    }
	  else
	    return register_mismatch ();
	}

	| SAA LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir
	{
	  if (!valid_dreg_pair (&$3, $5))
	    return semantic_error ("Bad dreg pair");
	  else if (!valid_dreg_pair (&$7, $9))
	    return semantic_error ("Bad dreg pair");
	  else
	    {
	      notethat("dsp32alu: SAA (dregs_pair , dregs_pair ) (aligndir)\n");
	      $$ = DSP32ALU (18, 0, 0, 0, &$3, &$7, $11.r0, 0, 0);
	    }
	}

	| a_assign REG_A LPAREN S RPAREN COMMA a_assign REG_A LPAREN S RPAREN
	{
	  if (REG_SAME ($1, $2) && REG_SAME ($7, $8) && !REG_SAME ($1, $7))
	    {
	      notethat("dsp32alu: A1 = A1 (S) , A0 = A0 (S)\n");
	      $$ = DSP32ALU (8, 0, 0, 0, 0, 0, 1, 0, 2);
	    }
	  else
	    return register_mismatch ();
	}

	| REG ASSIGN LPAREN REG PLUS REG RPAREN LESS_LESS expr
	{
	  if (IS_DREG ($1) && IS_DREG ($4) && IS_DREG ($6)
	      && REG_SAME ($1, $4))
	    {
	      if (EXPR_VALUE ($9) == 1)
		{
		  notethat("ALU2op: dregs = (dregs + dregs) << 1\n");
		  $$ = ALU2OP (&$1, &$6, 4);   // dst, src, opc
		}
	      else if (EXPR_VALUE ($9) == 2)
		{
		  notethat("ALU2op: dregs = (dregs + dregs) << 2\n");
		  $$ = ALU2OP (&$1, &$6, 5);   // dst, src, opc
		}
	      else
		return semantic_error ("Bad shift value");
	    }
	  else if (IS_PREG ($1) && IS_PREG ($4) && IS_PREG ($6)
		   && REG_SAME ($1, $4))
	    {
	      if (EXPR_VALUE ($9) == 1)
		{
		  notethat("PTR2op: pregs = (pregs + pregs) << 1\n");
		  $$ = PTR2OP (&$1, &$6, 6);
		}
	      else if (EXPR_VALUE ($9) == 2)
		{
		  notethat("PTR2op: pregs = (pregs + pregs) << 2\n");
		  $$ = PTR2OP (&$1, &$6, 7);
		}
	      else
		return semantic_error ("Bad shift value");
	    }
	  else
	    return register_mismatch ();
	}
			
				
// }
////////////////////////////////////////////////////////////////////////////
// COMP3 CCFLAG
// {

	| REG ASSIGN REG BAR REG
	{
	  if (IS_DREG ($1) && IS_DREG ($3) && IS_DREG ($5))
	    {
	      notethat("COMP3op: dregs = dregs | dregs\n");
	      $$ = COMP3OP (&$1, &$3, &$5, 3);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| REG ASSIGN REG CARET REG
	{
	  if (IS_DREG ($1) && IS_DREG ($3) && IS_DREG ($5))
	    {
	      notethat("COMP3op: dregs = dregs ^ dregs\n");
	      $$ = COMP3OP (&$1, &$3, &$5, 4);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| REG ASSIGN REG PLUS LPAREN REG LESS_LESS expr RPAREN
	{
	  if (IS_PREG ($1) && IS_PREG ($3) && IS_PREG ($6))
	    {
	      if (EXPR_VALUE ($8) == 1)
		{
		  notethat("COMP3op: pregs = pregs + (pregs << 1)\n");
		  $$ = COMP3OP (&$1, &$3, &$6, 6);
		}
	      else if (EXPR_VALUE ($8) == 2)
		{
		  notethat("COMP3op: pregs = pregs + (pregs << 2)\n");
		  $$ = COMP3OP (&$1, &$3, &$6, 7);
		}
	      else
		  return semantic_error ("Bad shift value");
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| CCREG ASSIGN REG_A _ASSIGN_ASSIGN REG_A
	{
	  if (!REG_SAME ($3, $5))
	    {
	      notethat("CCflag: CC = A0 == A1\n");
	      $$ = CCFLAG (0, 0, 5, 0, 0);
	    }
	  else
	    return semantic_error ("CC register expected");
	}

	| CCREG ASSIGN REG_A LESS_THAN REG_A
	{
	  if (!REG_SAME ($3, $5))
	    {
	      notethat("CCflag: CC = A0 < A1\n");
	      $$ = CCFLAG (0, 0, 6, 0, 0);
	    }
	  else
	    return register_mismatch ();
	}

/* 2 rules compacted */
	| CCREG ASSIGN REG LESS_THAN REG iu_or_nothing
	{
	  if (REG_CLASS($3) == REG_CLASS($5))
	    {
	      notethat("CCflag: CC = dpregs < dpregs\n");
	      $$ = CCFLAG (&$3, $5.regno & CODE_MASK, $6.r0, 0, IS_PREG ($3) ? 1 : 0);
	    }
	  else
	    return semantic_error ("Compare only of same register class");
	}

/* 2 rules compacted */
	| CCREG ASSIGN REG LESS_THAN expr iu_or_nothing
	{
	  if ((IS_IMM ($5, 3) && $6.r0 == 1) || IS_UIMM ($5, 3))
	    {
	      notethat("CCflag: CC = dpregs < (u)imm3\n");
	      $$ = CCFLAG (&$3, imm3($5), $6.r0, 1, IS_PREG ($3) ? 1 : 0);
	    }
	  else
	    return semantic_error ("Bad constant range");
	}

	| CCREG ASSIGN REG _ASSIGN_ASSIGN REG
	{
	  if (REG_CLASS($3) == REG_CLASS($5))
	    {
	      notethat("CCflag: CC = dpregs == dpregs\n");
	      $$ = CCFLAG (&$3, $5.regno & CODE_MASK, 0, 0, IS_PREG ($3) ? 1 : 0);
	    } 
	}

	| CCREG ASSIGN REG _ASSIGN_ASSIGN expr
	{
	  if (IS_IMM ($5, 3))
	    {
	      notethat("CCflag: CC = dpregs == imm3\n");
	      $$ = CCFLAG (&$3, imm3($5), 0, 1, IS_PREG ($3) ? 1 : 0);
	    }
	  else
	    return semantic_error ("Bad constant range");
	}

	| CCREG ASSIGN REG_A _LESS_THAN_ASSIGN REG_A
	{
	  if (!REG_SAME ($3, $5))
	    {
	      notethat("CCflag: CC = A0 <= A1\n");
	      $$ = CCFLAG (0, 0, 7, 0, 0);
	    }
	  else
	    return semantic_error ("CC register expected");
	}

/* 2 rules compacted */
	| CCREG ASSIGN REG _LESS_THAN_ASSIGN REG iu_or_nothing
	{
	  if (REG_CLASS($3) == REG_CLASS($5))
	    {
	      notethat("CCflag: CC = pregs <= pregs (..)\n");
	      $$ = CCFLAG (&$3, $5.regno & CODE_MASK,
			   1 + $6.r0, 0, IS_PREG ($3) ? 1 : 0);
	    }
	  else
	    return semantic_error ("Compare only of same register class");
	}

	| CCREG ASSIGN REG _LESS_THAN_ASSIGN expr iu_or_nothing
	{
	  if ((IS_IMM ($5, 3) && $6.r0 == 1) || IS_UIMM ($5, 3))
	    {
	      if (IS_DREG ($3))
		{
		  notethat("CCflag: CC = dregs <= imm3\n");
		  /*    x       y     opc     I     G   */
		  $$ = CCFLAG (&$3, imm3($5), 1+$6.r0, 1, 0);
		}
	      else if (IS_PREG ($3))
		{
		  notethat("CCflag: CC = pregs <= imm3\n");
		  /*    x       y     opc     I     G   */
		  $$ = CCFLAG (&$3, imm3($5), 1+$6.r0, 1, 1);
		}
	      else
		return semantic_error ("Dreg or Preg expected");
	    }
	  else
	    return semantic_error ("Bad constant value");
	}

	| REG ASSIGN REG AMPERSAND REG
	{
	  if (IS_DREG ($1) && IS_DREG ($3) && IS_DREG ($5))
	    {
	      notethat("COMP3op: dregs = dregs & dregs\n");
	      $$ = COMP3OP (&$1, &$3, &$5, 2);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| ccstat
	{
	  notethat("CC2stat operation\n");
	  $$ = gen_cc2stat($1.r0, $1.x0, $1.s0); // cbit, op, D
	}

	| REG ASSIGN REG
	{
	  if (IS_ALLREG ($1) && IS_ALLREG ($3))
	    {
	      notethat("REGMV: allregs = allregs\n");
	      $$ = gen_regmv(&$3, &$1);
	    }
	  else
	    return register_mismatch ();
	}

	| CCREG ASSIGN REG
	{
	  if (IS_DREG ($3))
	    {
	      notethat("CC2dreg: CC = dregs\n");
	      $$ = gen_cc2dreg (1, &$3);
	    }
	  else
	    return register_mismatch();
	}

	| REG ASSIGN CCREG
	{
	  if (IS_DREG ($1))
	    {
	      notethat("CC2dreg: dregs = CC\n");
	      $$ = gen_cc2dreg (0, &$1);
	    }
	  else
	    return register_mismatch();
	}

	| CCREG _ASSIGN_BANG CCREG
	{
	  notethat("CC2dreg: CC =! CC\n");
	  $$ = gen_cc2dreg (3, 0);
	}
			
////////////////////////////////////////////////////////////////////////////
// DSPMULT
// {

	| HALF_REG ASSIGN multfunc opt_mode
	{
	  notethat("dsp32mult: dregs_half = multfunc (opt_mode)\n");

	  if (!IS_H ($1) && $4.MM)
	    return semantic_error ("(M) not allowed with MAC0");

	  if (IS_H ($1))
	    {
	      $$ = DSP32MULT (0, $4.MM, $4.mod, 1, 0,
			      IS_H ($3.s0), IS_H ($3.s1), 0, 0,
			      &$1, 0, &$3.s0, &$3.s1, 0);
	    }
	  else
	    {
	      $$ = DSP32MULT (0, 0, $4.mod, 0, 0,
			      0, 0, IS_H ($3.s0), IS_H ($3.s1), 
			      &$1, 0, &$3.s0, &$3.s1, 1);
		}	
	}

	| REG ASSIGN multfunc opt_mode 
	{
	  // Odd registers can use (M)
	  if (!IS_DREG ($1))
	    return semantic_error ("Dreg expected");

	  if (!IS_EVEN($1))
	    {
	      notethat("dsp32mult: dregs = multfunc (opt_mode)\n");

	      $$ = DSP32MULT (0, $4.MM, $4.mod, 1, 1,
			      IS_H ($3.s0), IS_H ($3.s1), 0, 0,
			      &$1, 0, &$3.s0, &$3.s1, 0);
	    }
	  else if ($4.MM == 0)
	    {
	      notethat("dsp32mult: dregs = multfunc opt_mode\n");
	      $$ = DSP32MULT (0, 0, $4.mod, 0, 1,
			      0, 0, IS_H ($3.s0), IS_H ($3.s1), 
			      &$1,  0, &$3.s0, &$3.s1, 1);
	    }
	  else
	    return semantic_error ("Register or mode mismatch");
	}

	| HALF_REG ASSIGN multfunc opt_mode COMMA HALF_REG ASSIGN multfunc opt_mode
	{
	  if (!IS_DREG ($1) || !IS_DREG ($6)) 
	    return semantic_error ("Dregs expected");

	  if (check_multfuncs(&$3, &$8) < 0)
	    return -1;

	  if (IS_H ($1) && !IS_H ($6))
	    {
	      notethat("dsp32mult: dregs_hi = multfunc mxd_mod, "
		       "dregs_lo = multfunc opt_mode\n");
	      $$ = DSP32MULT (0, $4.MM, $9.mod, 1, 0,
			      IS_H ($3.s0), IS_H ($3.s1), IS_H ($8.s0), IS_H ($8.s1),
			      &$1, 0, &$3.s0, &$3.s1, 1);
	    }
	  else if (!IS_H ($1) && IS_H ($6) && $4.MM == 0)
	    {
	      $$ = DSP32MULT (0, $9.MM, $9.mod, 1, 0,
			      IS_H ($8.s0), IS_H ($8.s1), IS_H ($3.s0), IS_H ($3.s1),
			      &$1, 0, &$3.s0, &$3.s1, 1);
	    }
	  else
	    return semantic_error ("Multfunc Register or mode mismatch");
	}

	| REG ASSIGN multfunc opt_mode COMMA REG ASSIGN multfunc opt_mode 
	{
	  if (!IS_DREG ($1) || !IS_DREG ($6)) 
	    return semantic_error ("Dregs expected");

	  if (check_multfuncs(&$3, &$8) < 0)
	    return -1;

	  notethat("dsp32mult: dregs = multfunc mxd_mod, "
		   "dregs = multfunc opt_mode\n");
	  if (IS_EVEN($1))
	    {
	      if ($6.regno - $1.regno != 1 || $4.MM != 0)
		return semantic_error ("Dest registers or mode mismatch");

	      /*   op1       MM      mmod  */
	      $$ = DSP32MULT (0, 0, $9.mod, 1, 1,
			      IS_H ($8.s0), IS_H ($8.s1), IS_H ($3.s0), IS_H ($3.s1),
			      &$1, 0, &$3.s0, &$3.s1, 1);
	      
	    }
	  else
	    {
	      if ($1.regno - $6.regno != 1)
		return semantic_error ("Dest registers mismatch");
	      
	      $$ = DSP32MULT (0, $9.MM, $9.mod, 1, 1,
			      IS_H ($3.s0), IS_H ($3.s1), IS_H ($8.s0), IS_H ($8.s1),
			      &$1, 0, &$3.s0, &$3.s1, 1);
	    }
	}

// }
////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
// SHIFTs
// {

/* 2 rules compacted */
	
	| a_assign ASHIFT REG_A BY HALF_REG
	{
	  if (!REG_SAME ($1, $3))
	    return semantic_error ("Aregs must be same");

	  if (IS_DREG ($5) && !IS_H ($5))
	    {
	      notethat("dsp32shift: A0 = ASHIFT A0 BY dregs_lo\n");
	      $$ = DSP32SHIFT (3, 0, &$5, 0, 0, IS_A1 ($1));
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

/* 8 rules compacted */
	| HALF_REG ASSIGN ASHIFT HALF_REG BY HALF_REG smod
	{
	  if (IS_DREG ($6) && !IS_H ($6))
	    {
	      notethat("dsp32shift: dregs_half = ASHIFT dregs_half BY dregs_lo\n");
	      $$ = DSP32SHIFT (0, &$1, &$6, &$4, $7.s0, HL2 ($1, $4));
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

/* 2 rules compacted */
	| a_assign REG_A LESS_LESS expr
	{
	  if (!REG_SAME ($1, $2))
	    return semantic_error ("Aregs must be same");

	  if (IS_UIMM ($4, 5))
	    {
	      notethat("dsp32shiftimm: A0 = A0 << uimm5\n");
	      $$ = DSP32SHIFTIMM (3, 0, imm5($4), 0, 0, IS_A1 ($1));
	    }
	  else
	    return semantic_error ("Bad shift value");
	}

/* 5 rules compacted */
	| REG ASSIGN REG LESS_LESS expr vsmod
	{
	  if (IS_DREG ($1) && IS_DREG ($3) && IS_UIMM ($5, 5))
	    {
	      if ($6.r0)
		{
		  // vector ?
		  notethat("dsp32shiftimm: dregs = dregs << expr (V, .)\n");
		  $$ = DSP32SHIFTIMM (1, &$1, imm4 ($5), &$3, $6.s0 ? 1 : 2, 0);
		}
	      else
		{
		  notethat("dsp32shiftimm: dregs =  dregs << uimm5 (.)\n");
		  $$ = DSP32SHIFTIMM (2, &$1, imm6 ($5), &$3, $6.s0 ? 1 : 2, 0);
		}
	    }
	  else if ($6.s0 == 0 && IS_PREG ($1) && IS_PREG ($3))
	    {
	      if (EXPR_VALUE ($5) == 2)
		{
		  notethat("PTR2op: pregs = pregs << 2\n");
		  $$ = PTR2OP (&$1, &$3, 1);
		}
	      else if (EXPR_VALUE ($5) == 1)
		{
		  notethat("COMP3op: pregs = pregs << 1\n");
		  $$ = COMP3OP (&$1, &$3, &$3, 5);
		}
	      else
		return semantic_error ("Bad shift value");
	    }
	  else
	    return semantic_error ("Bad shift value or register");
	}

/* 4 rules compacted */
	| HALF_REG ASSIGN HALF_REG LESS_LESS expr
	{
	  if (IS_UIMM ($5, 4))
	    {
	      notethat("dsp32shiftimm: dregs_half = dregs_half << uimm4\n");
	      $$ = DSP32SHIFTIMM (0x0, &$1, imm5 ($5), &$3, 2, HL2 ($1, $3));
	    }
	  else
	    return semantic_error ("Bad shift value");
	}
	| HALF_REG ASSIGN HALF_REG LESS_LESS expr smod 
	{
	  if (IS_UIMM ($5, 4))
	    {
	      notethat("dsp32shiftimm: dregs_half = dregs_half << uimm4\n");
	      $$ = DSP32SHIFTIMM (0x0, &$1, imm5 ($5), &$3, $6.s0, HL2 ($1, $3));
	    }
	  else
	    return semantic_error ("Bad shift value");
	}

/* 6 rules compacted */
	| REG ASSIGN ASHIFT REG BY HALF_REG vsmod
	{
	  int op;

	  if (IS_DREG ($1) && IS_DREG ($4) && IS_DREG ($6) && !IS_H ($6))
	    {
	      if ($7.r0)
		{
		  op = 1;
		  notethat("dsp32shift: dregs = ASHIFT dregs BY "
			   "dregs_lo (V, .)\n");
		}
	      else
		{
		  
		  op = 2;
		  notethat("dsp32shift: dregs = ASHIFT dregs BY dregs_lo (.)\n");
		}
	      $$ = DSP32SHIFT (op, &$1, &$6, &$4, $7.s0, 0);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

// EXPADJ
/* 2 rules compacted */
	| HALF_REG ASSIGN EXPADJ LPAREN REG COMMA HALF_REG RPAREN vmod
	{
	  if (IS_DREG_L($1) && IS_DREG_L($5) && IS_DREG_L($7))
	    {
	      notethat("dsp32shift: dregs_lo = EXPADJ (dregs , dregs_lo )\n");
	      $$ = DSP32SHIFT (7, &$1, &$7, &$5, $9.r0, 0);
	    }
	  else
	    return semantic_error ("Bad shift value or register");
	}


	| HALF_REG ASSIGN EXPADJ LPAREN HALF_REG COMMA HALF_REG RPAREN
	{
	  if (IS_DREG_L($1) && IS_DREG_L($5) && IS_DREG_L($7))
	    {
	      notethat("dsp32shift: dregs_lo = EXPADJ (dregs_lo, dregs_lo)\n");
	      $$ = DSP32SHIFT (7, &$1, &$7, &$5, 2, 0);
	    }
	  else if (IS_DREG_L($1) && IS_DREG_H($5) && IS_DREG_L($7))
	    {
	      notethat("dsp32shift: dregs_lo = EXPADJ (dregs_hi, dregs_lo)\n");
	      $$ = DSP32SHIFT (7, &$1, &$7, &$5, 3, 0);
	    }
	  else
	    return semantic_error ("Bad shift value or register");
	}

// DEPOSIT

	| REG ASSIGN DEPOSIT LPAREN REG COMMA REG RPAREN
	{
	  if (IS_DREG ($1) && IS_DREG ($5) && IS_DREG ($7))
	    {
	      notethat("dsp32shift: dregs = DEPOSIT (dregs , dregs )\n");
	      $$ = DSP32SHIFT (10, &$1, &$7, &$5, 2, 0);
	    }
	  else
	    return register_mismatch ();
	}

	| REG ASSIGN DEPOSIT LPAREN REG COMMA REG RPAREN LPAREN X RPAREN
	{
	  if (IS_DREG ($1) && IS_DREG ($5) && IS_DREG ($7))
	    {
	      notethat("dsp32shift: dregs = DEPOSIT (dregs , dregs ) (X)\n");
	      $$ = DSP32SHIFT (10, &$1, &$7, &$5, 3, 0);
	    }
	  else
	    return register_mismatch ();
	}

	| REG ASSIGN EXTRACT LPAREN REG COMMA HALF_REG RPAREN xpmod 
	{
	  if (IS_DREG ($1) && IS_DREG ($5) && IS_DREG_L($7))
	    {
	      notethat("dsp32shift: dregs = EXTRACT (dregs, dregs_lo ) (.)\n");
	      $$ = DSP32SHIFT (10, &$1, &$7, &$5, $9.r0, 0);
	    }
	  else
	    return register_mismatch ();
	}

	| a_assign REG_A _GREATER_GREATER_GREATER expr
	{
	  if (!REG_SAME ($1, $2))
	    return semantic_error ("Aregs must be same");

	  if (IS_UIMM ($4, 5))
	    {
	      notethat("dsp32shiftimm: Ax = Ax >>> uimm5\n");
	      $$ = DSP32SHIFTIMM (3, 0, -imm6($4), 0, 0, IS_A1 ($1));
	    }
	  else
	    return semantic_error ("Shift value range error");
	}

/* 2 rules compacted */
	| a_assign LSHIFT REG_A BY HALF_REG
	{
	  if (REG_SAME ($1, $3) && IS_DREG_L($5))
	    {
	      notethat("dsp32shift: Ax = LSHIFT Ax BY dregs_lo\n");
	      $$ = DSP32SHIFT (3, 0, &$5, 0, 1, IS_A1 ($1));
	    }
	  else
	    return register_mismatch ();
	}

	| HALF_REG ASSIGN LSHIFT HALF_REG BY HALF_REG
	{
	  if (IS_DREG ($1) && IS_DREG ($4) && IS_DREG_L($6))
	    {
	      notethat("dsp32shift: dregs_lo = LSHIFT dregs_hi BY dregs_lo\n");
	      $$ = DSP32SHIFT (0, &$1, &$6, &$4, 2, HL2 ($1, $4));
	    }
	  else
	    return register_mismatch ();
	}

	| REG ASSIGN LSHIFT REG BY HALF_REG vmod
	{
	  if (IS_DREG ($1) && IS_DREG ($4) && IS_DREG_L($6))
	    {
	      notethat("dsp32shift: dregs = LSHIFT dregs BY dregs_lo (V )\n");
	      $$ = DSP32SHIFT ($7.r0 ? 1: 2, &$1, &$6, &$4, 2, 0);
	    }
	  else
	    return register_mismatch ();
	}

	| REG ASSIGN SHIFT REG BY HALF_REG
	{
	  if (IS_DREG ($1) && IS_DREG ($4) && IS_DREG_L($6))
	    {
	      notethat("dsp32shift: dregs = SHIFT dregs BY dregs_lo\n");
	      $$ = DSP32SHIFT (2, &$1, &$6, &$4, 2, 0);
	    }
	  else
	    return register_mismatch ();
	}

	| a_assign REG_A GREATER_GREATER expr
	{
	  if (REG_SAME ($1, $2) && IS_IMM ($4, 6)>=0 )
	    {
	      notethat("dsp32shiftimm: Ax = Ax >> imm6\n");
	      $$ = DSP32SHIFTIMM (3, 0, -imm6 ($4), 0, 1, IS_A1 ($1));
	    }
	  else
	    return semantic_error ("Accu register expected");
	}

	| REG ASSIGN REG GREATER_GREATER expr vmod
	{
	  if ($6.r0 == 1)
	    {
	      if (IS_DREG ($1) && IS_DREG ($3) && IS_UIMM ($5, 5))
		{
		  notethat("dsp32shiftimm: dregs = dregs >> uimm5 (V)\n");
		  $$ = DSP32SHIFTIMM (1, &$1, -uimm5 ($5), &$3, 2, 0);
		}
	      else
		return register_mismatch();
	    }
	  else
	    {
	      if (IS_DREG ($1) && IS_DREG ($3) && IS_UIMM ($5, 5))
		{
		  notethat("dsp32shiftimm: dregs = dregs >> uimm5\n");
		  $$ = DSP32SHIFTIMM (2, &$1, -imm6($5), &$3, 2, 0);
		}
	      else if (IS_PREG ($1) && IS_PREG ($3) && EXPR_VALUE ($5) == 2)
		{
		  notethat("PTR2op: pregs = pregs >> 2\n");
		  $$ = PTR2OP (&$1, &$3, 3);
		}
	      else if (IS_PREG ($1) && IS_PREG ($3) && EXPR_VALUE ($5) == 1)
		{
		  notethat("PTR2op: pregs = pregs >> 1\n");
		  $$ = PTR2OP (&$1, &$3, 4);
		}
	      else
		return register_mismatch();
	    }
	}

/* 4 rules compacted */
	| HALF_REG ASSIGN HALF_REG GREATER_GREATER expr
	{
	  if (IS_UIMM ($5, 5))
	    {
	      notethat("dsp32shiftimm:  dregs_half =  dregs_half >> uimm5\n");
	      $$ = DSP32SHIFTIMM (0, &$1, -uimm5 ($5), &$3, 2, HL2 ($1, $3));
	    }
	  else
	    return register_mismatch ();
	}

	| HALF_REG ASSIGN HALF_REG _GREATER_GREATER_GREATER expr smod
	{
	  if (IS_UIMM ($5, 5))
	    {
	      notethat("dsp32shiftimm: dregs_half = dregs_half >>> uimm5\n");
	      $$ = DSP32SHIFTIMM (0, &$1, -uimm5 ($5), &$3,
				  $6.s0, HL2 ($1, $3));
	    }
	  else
	    return semantic_error ("Register or modifier mismatch");
	}


	| REG ASSIGN REG _GREATER_GREATER_GREATER expr vsmod
	{
	  if (IS_DREG ($1) && IS_DREG ($3) && IS_UIMM ($5, 5))
	    {
	      if ($6.r0)
		{
		  // Vector ?
		  notethat("dsp32shiftimm: dregs  =  dregs >>> uimm5 (V, .)\n");
		  $$ = DSP32SHIFTIMM (1, &$1, -uimm5 ($5), &$3, $6.s0, 0);
		}
	      else
		{
		  notethat("dsp32shiftimm: dregs  =  dregs >>> uimm5 (.)\n");
		  $$ = DSP32SHIFTIMM (2, &$1, -uimm5 ($5), &$3, $6.s0, 0);
		}
	    }
	  else
	    return register_mismatch ();
	}

	| HALF_REG ASSIGN ONES REG
	{
	  if (IS_DREG_L($1) && IS_DREG ($4))
	    {
	      notethat("dsp32shift: dregs_lo = ONES dregs\n");
	      $$ = DSP32SHIFT (6, &$1, 0, &$4, 3, 0);
	    }
	  else
	    return register_mismatch ();
	}

/* 4 rules compacted */
	| REG ASSIGN PACK LPAREN HALF_REG COMMA HALF_REG RPAREN
	{
	  if (IS_DREG ($1) && IS_DREG ($5) && IS_DREG ($7))
	    {
	      notethat("dsp32shift: dregs = PACK (dregs_hi , dregs_hi )\n");
	      $$ = DSP32SHIFT (4, &$1, &$7, &$5, HL2 ($5, $7), 0);
	    }
	  else
	    return register_mismatch ();
	}

	| HALF_REG ASSIGN CCREG ASSIGN BXORSHIFT LPAREN REG_A COMMA REG RPAREN 
	{
	  if (IS_DREG ($1)
	      && $7.regno == REG_A0
	      && IS_DREG ($9) && !IS_H ($1) && !IS_A1 ($7))
	    {
	      notethat("dsp32shift: dregs_lo = CC = BXORSHIFT (A0 , dregs )\n");
	      $$ = DSP32SHIFT (11, &$1, &$9, 0, 0, 0);
	    }
	  else
	    return register_mismatch ();
	}

	| HALF_REG ASSIGN CCREG ASSIGN BXOR LPAREN REG_A COMMA REG RPAREN
	{
	  if (IS_DREG ($1)
	      && $7.regno == REG_A0
	      && IS_DREG ($9) && !IS_H ($1) && !IS_A1 ($7))
	    {
	      notethat("dsp32shift: dregs_lo = CC = BXOR (A0 , dregs)\n");
	      $$ = DSP32SHIFT (11, &$1, &$9, 0, 1, 0);
	    }
	  else
	    return register_mismatch();
	}

	| HALF_REG ASSIGN CCREG ASSIGN BXOR LPAREN REG_A COMMA REG_A COMMA CCREG RPAREN
	{
	  if (IS_DREG ($1) && !IS_H ($1) && !REG_SAME ($7, $9))
	    {
	      notethat("dsp32shift: dregs_lo = CC = BXOR (A0 , A1 , CC)\n");
	      $$ = DSP32SHIFT (12, &$1, 0, 0, 1, 0);
	    }
	  else
	    return register_mismatch();
	}

	| a_assign ROT REG_A BY HALF_REG
	{
	  if (REG_SAME ($1, $3) && IS_DREG_L($5))
	    {
	      notethat("dsp32shift: Ax = ROT Ax BY dregs_lo\n");
	      $$ = DSP32SHIFT (3, 0, &$5, 0, 2, IS_A1 ($1));
	    }
	  else
	    return register_mismatch();
	}

	| REG ASSIGN ROT REG BY HALF_REG
	{
	  if (IS_DREG ($1) && IS_DREG ($4) && IS_DREG_L($6))
	    {
	      notethat("dsp32shift: dregs = ROT dregs BY dregs_lo\n");
	      $$ = DSP32SHIFT (2, &$1, &$6, &$4, 3, 0);
	    }
	  else
	    return register_mismatch();
	}

	| a_assign ROT REG_A BY expr 
	{
	  if (IS_IMM ($5, 6))
	    {
	      notethat("dsp32shiftimm: An = ROT An BY imm6\n");
	      $$ = DSP32SHIFTIMM (3, 0, imm6($5), 0, 2, IS_A1 ($1));
	    }
	  else
	    return register_mismatch();
	}

	| REG ASSIGN ROT REG BY expr 
	{
	  if (IS_DREG ($1) && IS_DREG ($4) && IS_IMM ($6, 6))
	    {
	      $$ = DSP32SHIFTIMM (2, &$1, imm6 ($6), &$4, 3, IS_A1 ($1));
	    }
	  else
	    return register_mismatch();
	}

	| HALF_REG ASSIGN SIGNBITS REG_A
	{
	  if (IS_DREG_L($1))
	    {
	      notethat("dsp32shift: dregs_lo = SIGNBITS An\n");
	      $$ = DSP32SHIFT (6, &$1, 0, 0, IS_A1 ($4), 0);
	    }
	  else
	    return register_mismatch();
	}

	| HALF_REG ASSIGN SIGNBITS REG
	{
	  if (IS_DREG_L($1) && IS_DREG ($4))
	    {
	      notethat("dsp32shift: dregs_lo = SIGNBITS dregs\n");
	      $$ = DSP32SHIFT (5, &$1, 0, &$4, 0, 0);
	    }
	  else
	    return register_mismatch();
	}

	| HALF_REG ASSIGN SIGNBITS HALF_REG
	{
	  if (IS_DREG_L($1))
	    {
	      notethat("dsp32shift: dregs_lo = SIGNBITS dregs_lo\n");
	      $$ = DSP32SHIFT (5, &$1, 0, &$4, 1 + IS_H ($4), 0);
	    }
	  else
	    return register_mismatch();
	}
	
	// Silly. The ASR bit is just inverted here.
	| HALF_REG ASSIGN VIT_MAX LPAREN REG RPAREN asr_asl 
	{
	  if (IS_DREG_L($1) && IS_DREG ($5))
	    {
	      notethat("dsp32shift: dregs_lo = VIT_MAX (dregs) (..)\n");
	      $$ = DSP32SHIFT (9, &$1, 0, &$5, ($7.r0 ? 0 : 1), 0);
	    }
	  else
	    return register_mismatch();
	}

	| REG ASSIGN VIT_MAX LPAREN REG COMMA REG RPAREN asr_asl 
	{
	  if (IS_DREG ($1) && IS_DREG ($5) && IS_DREG ($7))
	    {
	      notethat("dsp32shift: dregs = VIT_MAX (dregs, dregs) (ASR)\n");
	      $$ = DSP32SHIFT (9, &$1, &$7, &$5, 2 | ($9.r0 ? 0 : 1), 0);
	    }
	  else
	    return register_mismatch();
	}

	| BITMUX LPAREN REG COMMA REG COMMA REG_A RPAREN asr_asl
	{
	  if (IS_DREG ($3) && IS_DREG ($5) && !IS_A1 ($7))
	    {
	      notethat("dsp32shift: BITMUX (dregs , dregs , A0) (ASR)\n");
	      $$ = DSP32SHIFT (8, 0, &$3, &$5, $9.r0, 0);
	    }
	  else
	    return register_mismatch();
	}

	| a_assign BXORSHIFT LPAREN REG_A COMMA REG_A COMMA CCREG RPAREN
	{
	  if (!IS_A1 ($1) && !IS_A1 ($4) && IS_A1 ($6))
	    {
	      notethat("dsp32shift: A0 = BXORSHIFT (A0 , A1 , CC )\n");
	      $$ = DSP32SHIFT (12, 0, 0, 0, 0, 0);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}


// }

////////////////////////////////////////////////////////////////////////////


// LOGI2op:	BITCLR (dregs , uimm5 )
	| BITCLR LPAREN REG COMMA expr RPAREN
	{
	  if (IS_DREG ($3) && IS_UIMM ($5, 5))
	    {
	      notethat("LOGI2op: BITCLR (dregs , uimm5 )\n");
	      $$ = LOGI2OP ($3, uimm5 ($5), 4);
	    }
	  else
	    return register_mismatch();
	}

// LOGI2op:	BITSET (dregs , uimm5 )
	| BITSET LPAREN REG COMMA expr RPAREN
	{
	  if (IS_DREG ($3) && IS_UIMM ($5, 5))
	    {
	      notethat("LOGI2op: BITCLR (dregs , uimm5 )\n");
	      $$ = LOGI2OP ($3, uimm5 ($5), 2);
	    }
	  else
	    return register_mismatch();
	}

// LOGI2op:	BITTGL (dregs , uimm5 )
	| BITTGL LPAREN REG COMMA expr RPAREN
	{
	  if (IS_DREG ($3) && IS_UIMM ($5, 5))
	    {
	      notethat("LOGI2op: BITCLR (dregs , uimm5 )\n");
	      $$ = LOGI2OP ($3, uimm5 ($5), 3);
	    }
	  else
	    return register_mismatch();
	}

	| CCREG _ASSIGN_BANG BITTST LPAREN REG COMMA expr RPAREN
	{
	  if (IS_DREG ($5) && IS_UIMM ($7, 5))
	    {
	      notethat("LOGI2op: CC =! BITTST (dregs , uimm5 )\n");
	      $$ = LOGI2OP ($5, uimm5 ($7), 0);
	    }
	  else
	    return semantic_error ("Register mismatch or value error");
	}

	| CCREG ASSIGN BITTST LPAREN REG COMMA expr RPAREN
	{
	  if (IS_DREG ($5) && IS_UIMM ($7, 5))
	    {
	      notethat("LOGI2op: CC = BITTST (dregs , uimm5 )\n");
	      $$ = LOGI2OP ($5, uimm5 ($7), 1);
	    }
	  else
	    return semantic_error ("Register mismatch or value error");
	}

	| IF BANG CCREG REG ASSIGN REG
	{
	  if ((IS_DREG ($4) || IS_PREG ($4))
	      && (IS_DREG ($6) || IS_PREG ($6)))
	    {
	      notethat("ccMV: IF ! CC gregs = gregs\n");
	      $$ = CCMV (&$6, &$4, 0);
	    }
	  else
	    return register_mismatch();
	}

	| IF CCREG REG ASSIGN REG
	{
	  if ((IS_DREG ($5) || IS_PREG ($5))
	      && (IS_DREG ($3) || IS_PREG ($3)))
	    {
	      notethat("ccMV: IF CC gregs = gregs\n");
	      $$ = CCMV (&$5, &$3, 1);
	    }
	  else
	    return register_mismatch();
	}

	| IF BANG CCREG JUMP expr
	{
	  if (IS_PCREL10 ($5))
	    {
	      notethat("BRCC: IF !CC JUMP  pcrel11m2\n");
	      $$ = BRCC (0, 0, $5);
	    }
	  else
	    return semantic_error ("Bad jump offset");
	}

	| IF BANG CCREG JUMP expr LPAREN BP RPAREN
	{
	  if (IS_PCREL10 ($5))
	    {
	      notethat("BRCC: IF !CC JUMP  pcrel11m2\n");
	      $$ = BRCC (0, 1, $5); // use branch prediction
	    }
	  else
	    return semantic_error ("Bad jump offset");
	}

	| IF CCREG JUMP expr
	{
	  if (IS_PCREL10 ($4))
	    {
	      notethat("BRCC: IF CC JUMP  pcrel11m2\n");
	      $$ = BRCC (1, 0, $4); // use branch prediction
	    }
	  else
	    return semantic_error ("Bad jump offset");
	}

	| IF CCREG JUMP expr LPAREN BP RPAREN
	{
	  if (IS_PCREL10 ($4))
	    {
	      notethat("BRCC: IF !CC JUMP  pcrel11m2\n");
	      $$ = BRCC (1, 1, $4); // use branch prediction
	    }
	  else
	    return semantic_error ("Bad jump offset");
	}

	| NOP
	{
	  notethat("ProgCtrl: NOP\n");
	  $$ = PROGCTRL (0, 0);
	}

	| RTS
	{
	  notethat("ProgCtrl: RTS\n");
	  $$ = PROGCTRL (1, 0);
	}

	| RTI
	{
	  notethat("ProgCtrl: RTI\n");
	  $$ = PROGCTRL (1, 1);
	}

	| RTX
	{
	  notethat("ProgCtrl: RTX\n");
	  $$ = PROGCTRL (1, 2);
	}

	| RTN
	{
	  notethat("ProgCtrl: RTN\n");
	  $$ = PROGCTRL (1, 3);
	}

	| RTE
	{
	  notethat("ProgCtrl: RTE\n");
	  $$ = PROGCTRL (1, 4);
	}

	| IDLE
	{
	  notethat("ProgCtrl: IDLE\n");
	  $$ = PROGCTRL (2, 0);
	}

	| CSYNC
	{
	  notethat("ProgCtrl: CSYNC\n");
	  $$ = PROGCTRL (2, 3);
	}

	| SSYNC
	{
	  notethat("ProgCtrl: SSYNC\n");
	  $$ = PROGCTRL (2, 4);
	}

	| EMUEXCPT
	{
	  notethat("ProgCtrl: EMUEXCPT\n");
	  $$ = PROGCTRL (2, 5);
	}

	| CLI REG
	{
	  if (IS_DREG ($2))
	    {
	      notethat("ProgCtrl: CLI dregs\n");
	      $$ = PROGCTRL (3, $2.regno & CODE_MASK);
	    }
	  else
	    return semantic_error ("Dreg expected for CLI");
	}

	| STI REG
	{
	  if (IS_DREG ($2))
	    {
	      notethat("ProgCtrl: STI dregs\n");
	      $$ = PROGCTRL (4, $2.regno & CODE_MASK);
	    }
	  else
	    return semantic_error ("Dreg expected for STI");
	}

	| JUMP LPAREN REG RPAREN
	{
	  if (IS_PREG ($3))
	    {
	      notethat("ProgCtrl: JUMP (pregs )\n");
	      $$ = PROGCTRL (5, $3.regno & CODE_MASK);
	    }
	  else
	    return semantic_error ("Bad register for indirect jump");
	}

	| CALL LPAREN REG RPAREN
	{
	  if (IS_PREG ($3))
	    {
	      notethat("ProgCtrl: CALL (pregs )\n");
	      $$ = PROGCTRL (6, $3.regno & CODE_MASK);
	    }
	  else
	    return semantic_error ("Bad register for indirect call");
	}

	| CALL LPAREN PC PLUS REG RPAREN
	{
	  if (IS_PREG ($5))
	    {
	      notethat("ProgCtrl: CALL (PC + pregs )\n");
	      $$ = PROGCTRL (7, $5.regno & CODE_MASK);
	    }
	  else
	    return semantic_error ("Bad register for indirect call");
	}

	| JUMP LPAREN PC PLUS REG RPAREN
	{
	  if (IS_PREG ($5))
	    {
	      notethat("ProgCtrl: JUMP (PC + pregs )\n");
	      $$ = PROGCTRL (8, $5.regno & CODE_MASK);
	    }
	  else
	    return semantic_error ("Bad register for indirect jump");
	}

	| RAISE expr
	{
	  if (IS_UIMM ($2, 4))
	    {
	      notethat("ProgCtrl: RAISE uimm4\n");
	      $$ = PROGCTRL (9, uimm4 ($2));
	    }
	  else
	    return semantic_error ("Bad value for RAISE");
	}

	| EXCPT expr
	{
		notethat("ProgCtrl: EMUEXCPT\n");
		$$ = PROGCTRL (10, uimm4 ($2));
	}

	| TESTSET LPAREN REG RPAREN
	{
	  if (IS_PREG ($3))
	    {
	      notethat("ProgCtrl: TESTSET (pregs )\n");
	      $$ = PROGCTRL (11, $3.regno & CODE_MASK);
	    }
	  else
	    return semantic_error ("Preg expected");
	}

	| JUMP expr
	{
	  if (IS_PCREL12($2))
	    {
	      notethat("UJUMP: JUMP pcrel12\n");
	      $$ = UJUMP($2);
	    }
	  else
	    return semantic_error ("Bad value for relative jump");
	}

	| JUMP_DOT_S expr
	{
	  if (IS_PCREL12($2))
	    {
	      notethat("UJUMP: JUMP_DOT_S pcrel12\n");
	      $$ = UJUMP($2);
	    }
	  else
	    return semantic_error ("Bad value for relative jump");
	}

	| JUMP_DOT_L expr
	{
	  if (IS_PCREL24 ($2))
	    {
	      notethat("CALLa: jump.l pcrel24\n");
	      $$ = CALLA ($2, 0);
	    }
	  else
	    return semantic_error ("Bad value for long jump");
	}

	| JUMP_DOT_L pltpc
	{
	  if (IS_PCREL24 ($2))
	    {
	      notethat("CALLa: jump.l pcrel24\n");
	      $$ = CALLA ($2, 2);
	    }
	  else
	    return semantic_error ("Bad value for long jump");
	}


////////////////////////////////////////////////////////////////////////////

	| CALL expr
	{
	  if (IS_PCREL24 ($2))
	    {
	      notethat("CALLa: CALL pcrel25m2\n");
	      $$ = CALLA ($2, 1);
	    }
	  else
	    return semantic_error ("Bad call address");
	}
	| CALL pltpc
	{
	  if (IS_PCREL24 ($2))
	    {
	      notethat("CALLa: CALL pcrel25m2\n");
	      $$ = CALLA ($2, 2);
	    }
	  else
	    return semantic_error ("Bad call address");
	}

// ALU2ops
// ALU2op:	DIVQ (dregs, dregs)
	| DIVQ LPAREN REG COMMA REG RPAREN
	{
	  if (IS_DREG ($3) && IS_DREG ($5))
	    $$ = ALU2OP (&$3, &$5, 8);   // dst, src, opc
	  else
	    return semantic_error ("Bad registers for DIVQ");
	}

	| DIVS LPAREN REG COMMA REG RPAREN
	{
	  if (IS_DREG ($3) && IS_DREG ($5))
	    $$ = ALU2OP (&$3, &$5, 9);   // dst, src, opc
	  else
	    return semantic_error ("Bad registers for DIVS");
	}

/* 3 rules compacted */
	| REG ASSIGN MINUS REG vsmod
	{
	  if (IS_DREG ($1) && IS_DREG ($4))
	    {
	      if ($5.r0 == 0 && $5.s0 == 0)
		{
		  notethat("ALU2op: dregs = - dregs\n");
		  $$ = ALU2OP (&$1, &$4, 14);   // dst, src, opc
		}
	      else
		{
		  notethat("dsp32alu: dregs = - dregs (.)\n");
		  $$ = DSP32ALU (15, 0, 0, &$1, &$4, 0, $5.s0, 0, 3);
		}
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| REG ASSIGN TILDA REG
	{
	  if (IS_DREG ($1) && IS_DREG ($4))
	    {
	      notethat("ALU2op: dregs = ~dregs\n");
	      $$ = ALU2OP (&$1, &$4, 15);   // dst, src, opc
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| REG _GREATER_GREATER_ASSIGN REG
	{
	  if (IS_DREG ($1) && IS_DREG ($3))
	    {
	      notethat("ALU2op: dregs >>= dregs\n");
	      $$ = ALU2OP (&$1, &$3, 1);   // dst, src, opc
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| REG _GREATER_GREATER_ASSIGN expr
	{
	  if (IS_DREG ($1) && IS_UIMM ($3, 5))
	    {
	      notethat("LOGI2op: dregs >>= uimm5\n");
	      $$ = LOGI2OP ($1, uimm5 ($3), 6);
	    }
	  else
	    return semantic_error ("Dregs expected or value error");
	}

	| REG _GREATER_GREATER_GREATER_THAN_ASSIGN REG
	{
	  if (IS_DREG ($1) && IS_DREG ($3))
	    {
	      notethat("ALU2op: dregs >>>= dregs\n");
	      $$ = ALU2OP (&$1, &$3, 0);   // dst, src, opc
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| REG _LESS_LESS_ASSIGN REG
	{
	  if (IS_DREG ($1) && IS_DREG ($3))
	    {
	      notethat("ALU2op: dregs <<= dregs\n");
	      $$ = ALU2OP (&$1, &$3, 2);   // dst, src, opc
	    }
	  else
	    return semantic_error ("Dregs expected");
	}

	| REG _LESS_LESS_ASSIGN expr
	{
	  if (IS_DREG ($1) && IS_UIMM ($3, 5))
	    {
	      notethat("LOGI2op: dregs <<= uimm5\n");
	      $$ = LOGI2OP ($1, uimm5 ($3), 7);
	    }
	  else
	    return semantic_error ("Dregs expected or const value error");
	}


	| REG _GREATER_GREATER_GREATER_THAN_ASSIGN expr
	{
	  if (IS_DREG ($1) && IS_UIMM ($3, 5))
	    {
	      notethat("LOGI2op: dregs >>>= uimm5\n");
	      $$ = LOGI2OP ($1, uimm5 ($3), 5);
	    }
	  else
	    return semantic_error ("Dregs expected");
	}


////////////////////////////////////////////////////////////////////////////
// Cache Control

	| FLUSH LBRACK REG RBRACK
	{
	  notethat("CaCTRL: FLUSH [ pregs ]\n");
	  if (IS_PREG ($3))
	    $$ = CACTRL (&$3, 0, 2);   // reg, a, op
	  else
	    return semantic_error ("Bad register(s) for FLUSH");
	}

	| FLUSH LBRACK REG _PLUS_PLUS RBRACK
	{
	  if (IS_PREG ($3))
	    {
	      notethat("CaCTRL: FLUSH [ pregs ++ ]\n");
	      $$ = CACTRL (&$3, 1, 2);   // reg, a, op
	    }
	  else
	    return semantic_error ("Bad register(s) for FLUSH");
	}

	| FLUSHINV LBRACK REG RBRACK
	{
	  if (IS_PREG ($3))
	    {
	      notethat("CaCTRL: FLUSHINV [ pregs ]\n");
	      $$ = CACTRL (&$3, 0, 1);   // reg, a, op
	    }
	  else
	    return semantic_error ("Bad register(s) for FLUSH");
	}

	| FLUSHINV LBRACK REG _PLUS_PLUS RBRACK
	{
	  if (IS_PREG ($3))
	    {
	      notethat("CaCTRL: FLUSHINV [ pregs ++ ]\n");
	      $$ = CACTRL (&$3, 1, 1);   // reg, a, op
	    }
	  else
	    return semantic_error ("Bad register(s) for FLUSH");
	}

// CaCTRL:	IFLUSH [ pregs ]
	| IFLUSH LBRACK REG RBRACK
	{
	  if (IS_PREG ($3))
	    {
	      notethat("CaCTRL: IFLUSH [ pregs ]\n");
	      $$ = CACTRL (&$3, 0, 3);   // reg, a, op
	    }
	  else
	    return semantic_error ("Bad register(s) for FLUSH");
	}

	| IFLUSH LBRACK REG _PLUS_PLUS RBRACK
	{
	  if (IS_PREG ($3))
	    {
	      notethat("CaCTRL: IFLUSH [ pregs ++ ]\n");
	      $$ = CACTRL (&$3, 1, 3);   // reg, a, op
	    }
	  else
	    return semantic_error ("Bad register(s) for FLUSH");
	}

	| PREFETCH LBRACK REG RBRACK
	{
	  if (IS_PREG ($3))
	    {
	      notethat("CaCTRL: PREFETCH [ pregs ]\n");
	      $$ = CACTRL(&$3, 0, 0);
	    }
	  else
	    return semantic_error ("Bad register(s) for PREFETCH");
	}

	| PREFETCH LBRACK REG _PLUS_PLUS RBRACK
	{
	  if (IS_PREG ($3))
	    {
	      notethat("CaCTRL: PREFETCH [ pregs ++ ]\n");
	      $$ = CACTRL(&$3, 1, 0);
	    }
	  else
	    return semantic_error ("Bad register(s) for PREFETCH");
	}

////////////////////////////////////////////////////////////////////////////
// LOAD/STORE
// {

// LDST:	B [ pregs <post_op> ] = dregs
	| B LBRACK REG post_op RBRACK ASSIGN REG
	{
	  if (IS_PREG ($3) && IS_DREG ($7))
	    {
	      notethat("LDST: B [ pregs <post_op> ] = dregs\n");
	      $$ = LDST (&$3, &$7, $4.x0, 2, 0, 1);
	    }
	  else
	    return register_mismatch();
	}

// LDSTidxI:	B [ pregs + imm16 ] = dregs */
	| B LBRACK REG plus_minus expr RBRACK ASSIGN REG
	{
	  if (IS_PREG ($3) && IS_RANGE(16, $5, $4.r0, 1) && IS_DREG ($8))
	    {
	      notethat("LDST: B [ pregs + imm16 ] = dregs\n");
	      if ($4.r0)
		neg_value($5);
	      $$ = LDSTIDXI (&$3, &$8, 1, 2, 0, $5);
	    }
	  else
	    return semantic_error ("Register mismatch or const size wrong");
	}


// LDSTii:	W [ pregs + uimm4s2 ] = dregs
	| W LBRACK REG plus_minus expr RBRACK ASSIGN REG
	{
	  if (IS_PREG ($3) && IS_URANGE (4, $5, $4.r0, 2) && IS_DREG ($8))
	    {
	      notethat("LDSTii: W [ pregs +- uimm5m2 ] = dregs\n");
	      $$ = LDSTII (&$3, &$8, $5, 1, 1); // ptr, reg, offset, W, op
	    }
	  else if (IS_PREG ($3) && IS_RANGE(16, $5, $4.r0, 2) && IS_DREG ($8))
	    {
	      notethat("LDSTidxI: W [ pregs + imm17m2 ] = dregs\n");
	      if ($4.r0)
		neg_value ($5);
	      $$ = LDSTIDXI (&$3, &$8, 1, 1, 0, $5);
	    }
	  else
	    return semantic_error ("Bad register(s) or wrong constant size");
	}

// LDST:	W [ pregs <post_op> ] = dregs
	| W LBRACK REG post_op RBRACK ASSIGN REG
	{
	  if (IS_PREG ($3) && IS_DREG ($7))
	    {
	      notethat("LDST: W [ pregs <post_op> ] = dregs\n");
	      $$ = LDST (&$3, &$7, $4.x0, 1, 0, 1);
	    }
	  else
	    return semantic_error ("Bad register(s) for STORE");
	}

	| W LBRACK REG post_op RBRACK ASSIGN HALF_REG
	{
	  if (IS_IREG ($3))
	    {
	      notethat("dspLDST: W [ iregs <post_op> ] = dregs_half\n");
	      $$ = DSPLDST (&$3, 1 + IS_H ($7), &$7, $4.x0, 1);
	    }
	  else if ($4.x0 == 2 && IS_PREG ($3) && IS_DREG ($7))
	    {
	      notethat("LDSTpmod: W [ pregs <post_op>] = dregs_half\n");
	      $$ = LDSTPMOD (&$3, &$7, &$3, 1 + IS_H ($7), 1);
	      
	    }
	  else
	    return semantic_error ("Bad register(s) for STORE");
	}

// LDSTiiFP:	[ FP - const ] = dpregs
	| LBRACK REG plus_minus expr RBRACK ASSIGN REG
	{
	  ExprNode *tmp = $4;
	  int ispreg = IS_PREG ($7);

	  if (!IS_PREG ($2))
	    return semantic_error ("Preg expected for indirect");

	  if (!IS_DREG ($7) && !ispreg)
	    return semantic_error ("Bad source register for STORE");

	  if ($3.r0)
	    tmp = unary (ExprOpTypeNEG, tmp);

	  if (in_range_p (tmp, 0, 63, 3))
	    {
	      notethat("LDSTii: dpregs = [ pregs + uimm6m4 ]\n");
	      $$ = LDSTII (&$2, &$7, tmp, 1, ispreg ? 3 : 0);
	    }
	  else if ($2.regno == REG_FP && in_range_p (tmp, -128, 0, 3))
	    {
	      notethat("LDSTiiFP: dpregs = [ FP - uimm7m4 ]\n");
	      tmp = unary (ExprOpTypeNEG, tmp);
	      $$ = LDSTIIFP (tmp, &$7, 1);
	    }
	  else if (in_range_p (tmp, -131072, 131071, 3))
	    {
	      notethat("LDSTidxI: [ pregs + imm18m4 ] = dpregs\n");
	      $$ = LDSTIDXI (&$2, &$7, 1, 0, ispreg ? 1: 0, tmp);
	    }
	  else
	    return semantic_error ("Displacement out of range for store");
	}

	| REG ASSIGN W LBRACK REG plus_minus expr RBRACK xpmod
	{
	  if (IS_DREG ($1) && IS_PREG ($5) && IS_URANGE (4, $7, $6.r0, 2))
	    {
	      notethat("LDSTii: dregs = W [ pregs + uimm4s2 ] (.)\n");
	      $$ = LDSTII (&$5, &$1, $7, 0, 1 << $9.r0);
	    }
	  else if (IS_DREG ($1) && IS_PREG ($5) && IS_RANGE(16, $7, $6.r0, 2))
	    {
	      notethat("LDSTidxI: dregs = W [ pregs + imm17m2 ] (.)\n");
	      if ($6.r0)
		neg_value($7);
	      $$ = LDSTIDXI (&$5, &$1, 0, 1, $9.r0, $7);
	    }
	  else
	    return semantic_error ("Bad register or constant for LOAD");
	}	

	| HALF_REG ASSIGN W LBRACK REG post_op RBRACK
	{
	  if (IS_IREG ($5))
	    {
	      notethat("dspLDST: dregs_half = W [ iregs ]\n");
	      $$ = DSPLDST(&$5, 1 + IS_H ($1), &$1, $6.x0, 0);
	    }
	  else if ($6.x0 == 2 && IS_DREG ($1) && IS_PREG ($5))
	    {
	      notethat("LDSTpmod: dregs_half = W [ pregs ]\n");
	      $$ = LDSTPMOD (&$5, &$1, &$5, 1 + IS_H ($1), 0);
	    }
	  else
	    return semantic_error ("Bad register or post_op for LOAD");
	}


	| REG ASSIGN W LBRACK REG post_op RBRACK xpmod
	{
	  if (IS_DREG ($1) && IS_PREG ($5))
	    {
	      notethat("LDST: dregs = W [ pregs <post_op> ] (.)\n");
	      $$ = LDST (&$5, &$1, $6.x0, 1, $8.r0, 0);
	    }
	  else
	    return semantic_error ("Bad register for LOAD");
	}

	| REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK xpmod
	{
	  if (IS_DREG ($1) && IS_PREG ($5) && IS_PREG ($7))
	    {
	      notethat("LDSTpmod: dregs = W [ pregs ++ pregs ] (.)\n");
	      $$ = LDSTPMOD (&$5, &$1, &$7, 3, $9.r0);
	    }
	  else
	    return semantic_error ("Bad register for LOAD");
	}

	| HALF_REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK
	{
	  if (IS_DREG ($1) && IS_PREG ($5) && IS_PREG ($7))
	    {
	      notethat("LDSTpmod: dregs_half = W [ pregs ++ pregs ]\n");
	      $$ = LDSTPMOD (&$5, &$1, &$7, 1 + IS_H ($1), 0);
	    }
	  else
	    return semantic_error ("Bad register for LOAD");
	}

	| LBRACK REG post_op RBRACK ASSIGN REG
	{
	  if (IS_IREG ($2) && IS_DREG ($6))
	    {
	      notethat("dspLDST: [ iregs <post_op> ] = dregs\n");
	      $$ = DSPLDST(&$2, 0, &$6, $3.x0, 1);
	    }
	  else if (IS_PREG ($2) && IS_DREG ($6))
	    {
	      notethat("LDST: [ pregs <post_op> ] = dregs\n");
	      $$ = LDST (&$2, &$6, $3.x0, 0, 0, 1);
	    }
	  else if (IS_PREG ($2) && IS_PREG ($6))
	    {
	      notethat("LDST: [ pregs <post_op> ] = pregs\n");
	      $$ = LDST (&$2, &$6, $3.x0, 0, 1, 1);
	    }
	  else
	    return semantic_error ("Bad register for STORE");
	}

	| LBRACK REG _PLUS_PLUS REG RBRACK ASSIGN REG
	{
	  if (! IS_DREG ($7))
	    return semantic_error ("Expected Dreg for last argument");

	  if (IS_IREG ($2) && IS_MREG ($4))
	    {
	      notethat("dspLDST: [ iregs ++ mregs ] = dregs\n");
	      $$ = DSPLDST(&$2, $4.regno & CODE_MASK, &$7, 3, 1);
	    }
	  else if (IS_PREG ($2) && IS_PREG ($4))
	    {
	      notethat("LDSTpmod: [ pregs ++ pregs ] = dregs\n");
	      $$ = LDSTPMOD (&$2, &$7, &$4, 0, 1);
	    }
	  else
	    return semantic_error ("Bad register for STORE");
	}
			
	| W LBRACK REG _PLUS_PLUS REG RBRACK ASSIGN HALF_REG
	{
	  if (!IS_DREG ($8))
	    return semantic_error ("Expect Dreg as last argument");
	  if (IS_PREG ($3) && IS_PREG ($5))
	    {
	      notethat("LDSTpmod: W [ pregs ++ pregs ] = dregs_half\n");
	      $$ = LDSTPMOD (&$3, &$8, &$5, 1 + IS_H ($8), 1);
	    }
	  else
	    return semantic_error ("Bad register for STORE");
	}

	| REG ASSIGN B LBRACK REG plus_minus expr RBRACK xpmod
	{
	  if (IS_DREG ($1) && IS_PREG ($5) && IS_RANGE(16, $7, $6.r0, 1))
	    {
	      notethat("LDSTidxI: dregs = B [ pregs + imm16 ] (%c)\n",
		       $9.r0 ? 'X' : 'Z');
	      if ($6.r0)
		neg_value($7);
	      $$ = LDSTIDXI (&$5, &$1, 0, 2, $9.r0, $7);
	    }
	  else
	    return semantic_error ("Bad register or value for LOAD");
	}

	| REG ASSIGN B LBRACK REG post_op RBRACK xpmod
	{
	  if (IS_DREG ($1) && IS_PREG ($5))
	    {
	      notethat("LDST: dregs = B [ pregs <post_op> ] (%c)\n",
		       $8.r0 ? 'X' : 'Z');
	      $$ = LDST (&$5, &$1, $6.x0, 2, $8.r0, 0);
	    }
	  else
	    return semantic_error ("Bad register for LOAD");
	}
			
	| REG ASSIGN LBRACK REG _PLUS_PLUS REG RBRACK
	{
	  if (IS_DREG ($1) && IS_IREG ($4) && IS_MREG ($6))
	    {
	      notethat("dspLDST: dregs = [ iregs ++ mregs ]\n");
	      $$ = DSPLDST(&$4, $6.regno & CODE_MASK, &$1, 3, 0);
	    }
	  else if (IS_DREG ($1) && IS_PREG ($4) && IS_PREG ($6))
	    {
	      notethat("LDSTpmod: dregs = [ pregs ++ pregs ]\n");
	      $$ = LDSTPMOD (&$4, &$1, &$6, 0, 0);
	    }
	  else
	    return semantic_error ("Bad register for LOAD");
	}

	| REG ASSIGN LBRACK REG plus_minus got_or_expr RBRACK
	{
	  ExprNode *tmp = $6;
	  int ispreg = IS_PREG ($1);
	  int isgot = IS_RELOC($6);

	  if (!IS_PREG ($4))
	    return semantic_error ("Preg expected for indirect");

	  if (!IS_DREG ($1) && !ispreg)
	    return semantic_error ("Bad destination register for LOAD");

	  if ($5.r0)
	    tmp = unary (ExprOpTypeNEG, tmp);

	  if(isgot){
	      notethat("LDSTidxI: dpregs = [ pregs + sym@got ]\n");
	      $$ = LDSTIDXI (&$4, &$1, 0, 0, ispreg ? 1: 0, tmp);
	  }
	  else if (in_range_p (tmp, 0, 63, 3))
	    {
	      notethat("LDSTii: dpregs = [ pregs + uimm7m4 ]\n");
	      $$ = LDSTII (&$4, &$1, tmp, 0, ispreg ? 3 : 0);
	    }
	  else if ($4.regno == REG_FP && in_range_p (tmp, -128, 0, 3))
	    {
	      notethat("LDSTiiFP: dpregs = [ FP - uimm7m4 ]\n");
	      tmp = unary (ExprOpTypeNEG, tmp);
	      $$ = LDSTIIFP (tmp, &$1, 0);
	    }
	  else if (in_range_p (tmp, -131072, 131071, 3))
	    {
	      notethat("LDSTidxI: dpregs = [ pregs + imm18m4 ]\n");
	      $$ = LDSTIDXI (&$4, &$1, 0, 0, ispreg ? 1: 0, tmp);
	      
	    }
	  else
	    return semantic_error ("Displacement out of range for load");
	}

/* 3 rules compacted */
	| REG ASSIGN LBRACK REG post_op RBRACK
	{
	  if (IS_DREG ($1) && IS_IREG ($4))
	    {
	      notethat("dspLDST: dregs = [ iregs <post_op> ]\n");
	      $$ = DSPLDST (&$4, 0, &$1, $5.x0, 0);
	    }
	  else if (IS_DREG ($1) && IS_PREG ($4))
	    {
	      notethat("LDST: dregs = [ pregs <post_op> ]\n");
	      $$ = LDST (&$4, &$1, $5.x0, 0, 0, 0);
	    }
	  else if (IS_PREG ($1) && IS_PREG ($4))
	    {
	      if (REG_SAME ($1, $4) && $5.x0 != 2)
		return semantic_error ("Pregs can't be same");

	      notethat("LDST: pregs = [ pregs <post_op> ]\n");
	      $$ = LDST (&$4, &$1, $5.x0, 0, 1, 0);
	    }
	  else if ($4.regno == REG_SP && IS_ALLREG ($1) && $5.x0 == 0)
	    {
	      notethat("PushPopReg: allregs = [ SP ++ ]\n");
	      $$ = PUSHPOPREG (&$1, 0);
	    }
	  else
	    return semantic_error ("Bad register or value");
	}


// }
////////////////////////////////////////////////////////////////////////////
// PushPopMultiple
// {
	| LBRACK _MINUS_MINUS REG RBRACK ASSIGN LPAREN REG COLON expr COMMA REG COLON expr RPAREN
	{
	  if ($3.regno != REG_SP)
	    return semantic_error ("SP expected");

	  if ($7.regno == REG_R7
	      && (EXPR_VALUE ($9) >= 0 && EXPR_VALUE ($9) < 8)  
	      && $11.regno == REG_P5
	      && (EXPR_VALUE ($13) >= 0 && EXPR_VALUE ($13) < 6))
	    {
	      notethat("PushPopMultiple: [ -- SP ] = (R7 : reglim , P5 : reglim )\n");
	      $$ = PUSHPOPMULTIPLE (imm5($9), imm5($13), 1, 1, 1);
	    }
	  else
	    return semantic_error ("Bad register for PushPopMultiple");
	}

	| LBRACK _MINUS_MINUS REG RBRACK ASSIGN LPAREN REG COLON expr RPAREN
	{
	  if ($3.regno != REG_SP)
	    return semantic_error ("SP expected");

	  if ($7.regno == REG_R7
	      && (EXPR_VALUE ($9) >= 0 && EXPR_VALUE ($9) < 8))
	    {
	      notethat("PushPopMultiple: [ -- SP ] = (R7 : reglim )\n");
	      $$ = PUSHPOPMULTIPLE (imm5($9), 0, 1, 0, 1);
	    }
	  else if ($7.regno == REG_P5
		   && (EXPR_VALUE ($9) >= 0 && EXPR_VALUE ($9) < 6))
	    {
	      notethat("PushPopMultiple: [ -- SP ] = (P5 : reglim )\n");
	      $$ = PUSHPOPMULTIPLE (0, imm5($9), 0, 1, 1);
	    }
	  else
	    return semantic_error ("Bad register for PushPopMultiple");
	}

	| LPAREN REG COLON expr COMMA REG COLON expr RPAREN ASSIGN LBRACK REG _PLUS_PLUS RBRACK
	{
	  if ($12.regno != REG_SP)
	    return semantic_error ("SP expected");

	  if ($2.regno == REG_R7 && (EXPR_VALUE ($4) >= 0 && EXPR_VALUE ($4) < 8)  
	      && $6.regno == REG_P5 && (EXPR_VALUE ($8) >= 0 && EXPR_VALUE ($8) < 6))
	    {
	      notethat("PushPopMultiple: (R7 : reglim , P5 : reglim ) = [ SP ++ ]\n");
	      $$ = PUSHPOPMULTIPLE (imm5($4), imm5($8), 1, 1, 0);
	    }
	  else
	    return semantic_error ("Bad register range for PushPopMultiple");
	}

	| LPAREN REG COLON expr RPAREN ASSIGN LBRACK REG _PLUS_PLUS RBRACK
	{
	  if ($8.regno != REG_SP)
	    return semantic_error ("SP expected");

	  if ($2.regno == REG_R7
	      && EXPR_VALUE ($4) >= 0 && EXPR_VALUE ($4) < 8)
	    {
	      notethat("PushPopMultiple: (R7 : reglim ) = [ SP ++ ]\n");
	      $$ = PUSHPOPMULTIPLE (imm5($4), 0, 1, 0, 0);
	    }
	  else if ($2.regno == REG_P5
		   && (EXPR_VALUE ($4) >= 0 && EXPR_VALUE ($4) < 6))
	    {
	      notethat("PushPopMultiple: (P5 : reglim ) = [ SP ++ ]\n");
	      $$ = PUSHPOPMULTIPLE (0, imm5($4), 0, 1, 0);
	    }
	  else
	    return semantic_error ("Bad register range for PushPopMultiple");
	}

	| LBRACK _MINUS_MINUS REG RBRACK ASSIGN REG
	{
	  if ($3.regno != REG_SP)
	    return semantic_error ("SP expected");

	  if (IS_ALLREG ($6))
	    {
	      notethat("PushPopReg: [ -- SP ] = allregs\n");
	      $$ = PUSHPOPREG (&$6, 1);
	    }
	  else
	    return semantic_error ("Bad register for PushPopReg");
	}

// PushPopReg: allregs = [ SP ++ ] is covered in the LDST section.
// We no longer pre-'lex' the SP against other Pregs.

// }

////////////////////////////////////////////////////////////////////////////
// linkage

	| LINK expr
	{
	  if (IS_URANGE (16, $2, 0, 4))
	    $$ = LINKAGE (0, uimm16s4 ($2));
	  else
	    return semantic_error ("Bad constant for LINK");
	}
		
	| UNLINK
	{
		notethat("linkage: UNLINK\n");
		$$ = LINKAGE (1, 0);
	}


////////////////////////////////////////////////////////////////////////////
// LSETUP

	| LSETUP LPAREN expr COMMA expr RPAREN REG
	{
	  if (IS_PCREL4 ($3) && IS_LPPCREL10 ($5) && IS_CREG ($7))
	    {
	      notethat("LoopSetup: LSETUP (pcrel4 , lppcrel10 ) counters\n");
	      $$ = LOOPSETUP ($3, &$7, 0, $5, 0);
	    }
	  else
	    return semantic_error ("Bad register or values for LSETUP");
	  
	}

	| LSETUP LPAREN expr COMMA expr RPAREN REG ASSIGN REG
	{
	  if (IS_PCREL4 ($3) && IS_LPPCREL10 ($5)
	      && IS_PREG ($9) && IS_CREG ($7))
	    {
	      notethat("LoopSetup: LSETUP (pcrel4 , lppcrel10 ) counters = pregs\n");
	      $$ = LOOPSETUP ($3, &$7, 1, $5, &$9);
	    }
	  else
	    return semantic_error ("Bad register or values for LSETUP");
	}

	| LSETUP LPAREN expr COMMA expr RPAREN REG ASSIGN REG GREATER_GREATER expr
	{
	  if (IS_PCREL4 ($3) && IS_LPPCREL10 ($5)
	      && IS_PREG ($9) && IS_CREG ($7) 
	      && EXPR_VALUE ($11) == 1)
	    {
	      notethat("LoopSetup: LSETUP (pcrel4 , lppcrel10 ) counters = pregs >> 1\n");
	      $$ = LOOPSETUP ($3, &$7, 3, $5, &$9);
	    }
	  else
	    return semantic_error ("Bad register or values for LSETUP");
	}

////////////////////////////////////////////////////////////////////////////
// pseudoDEBUG

	| DBG
	{
	  notethat("pseudoDEBUG: DBG\n");

	  $$ = gen_pseudodbg(3, 7, 0);
	}

	| DBG REG_A
	{
	  notethat("pseudoDEBUG: DBG REG_A\n");
	  $$ = gen_pseudodbg(3, IS_A1 ($2), 0);
	}

	| DBG REG
	{
	  notethat("pseudoDEBUG: DBG allregs\n");
	  $$ = gen_pseudodbg(0, $2.regno & CODE_MASK, $2.regno & CLASS_MASK);
	}

	| DBGCMPLX LPAREN REG RPAREN
	{
	  if (!IS_DREG ($3))
	    return semantic_error ("Dregs expected");

	  notethat("pseudoDEBUG: DBGCMPLX (dregs )\n");
	  $$ = gen_pseudodbg(3, 6, $3.regno & CODE_MASK);
	}
	
	| DBGHALT
	{
	  notethat("psedoDEBUG: DBGHALT\n");
	  $$ = gen_pseudodbg(3, 5, 0);
	}

	| DBGA LPAREN HALF_REG COMMA expr RPAREN
	{
	  notethat("pseudodbg_assert: DBGA (dregs_lo , uimm16 )\n");
	  $$ = gen_pseudodbg_assert (IS_H ($3), &$3, uimm16 ($5));
	}
		
	| DBGAH LPAREN REG COMMA expr RPAREN
	{
	  notethat("pseudodbg_assert: DBGAH (dregs , uimm16 )\n");
	  $$ = gen_pseudodbg_assert (3, &$3, uimm16 ($5));
	}

	| DBGAL LPAREN REG COMMA expr RPAREN
	{
	  notethat("psedodbg_assert: DBGAL (dregs , uimm16 )\n");
	  $$ = gen_pseudodbg_assert (2, &$3, uimm16 ($5));
	}


;

////////////////////////////////////////////////////////////////////////////
// AUX RULES

// Register rules

REG_A:
	REG_A00
	{ $$ = $1; }
	| REG_A11
	{ $$ = $1; }
;


// Modifiers
/* { */

opt_mode:
	{ $$.MM = 0; $$.mod = 0; }
	| LPAREN M COMMA MMOD RPAREN
	{ $$.MM = 1; $$.mod = $4; }
	| LPAREN MMOD COMMA M RPAREN
	{ $$.MM = 1; $$.mod = $2; }
	| LPAREN MMOD RPAREN
	{ $$.MM = 0; $$.mod = $2; }
	| LPAREN M RPAREN
	{ $$.MM = 1; $$.mod = 0; }
;

asr_asl:
	LPAREN ASL RPAREN
	{ $$.r0 = 1; }
	| LPAREN ASR RPAREN
	{ $$.r0 = 0; }
;

sco:
	{ $$.s0 = 0; $$.x0 = 0; }
	| S
	{ $$.s0 = 1; $$.x0 = 0; }
	| CO
	{ $$.s0 = 0; $$.x0 = 1; }
	| SCO
	{ $$.s0 = 1; $$.x0 = 1; }
;

asr_asl_0:
	ASL
	{ $$.r0 = 1; }
	| ASR
	{ $$.r0 = 0; }
;

amod0:
	{ $$.s0 = 0; $$.x0 = 0; }
	| LPAREN sco RPAREN
	{ $$.s0 = $2.s0; $$.x0 = $2.x0; }
;


amod1:
	{ $$.s0 = 0; $$.x0 = 0; }
	| LPAREN NS RPAREN
	{ $$.s0 = 0; $$.x0 = 0; }
	| LPAREN S RPAREN
	{ $$.s0 = 1; $$.x0 = 0; }
;


amod2:
	{ $$.r0 = 0; $$.s0 = 0; }
	| LPAREN asr_asl_0 RPAREN
	{ $$.r0 = 2 + $2.r0; $$.s0 = 0; $$.x0 = 0; }

	| LPAREN sco RPAREN
	{ $$.r0 = 0; $$.s0 = $2.s0; $$.x0 = $2.x0; }

	| LPAREN asr_asl_0 COMMA sco RPAREN
	{ $$.r0 = 2 + $2.r0; $$.s0 = $4.s0; $$.x0 = $4.x0; }

	| LPAREN sco COMMA asr_asl_0 RPAREN
	{ $$.r0 = 2 + $4.r0; $$.s0 = $2.s0; $$.x0 = $2.x0; }
;

xpmod:
	{ $$.r0 = 0; }
	| LPAREN Z RPAREN
	{ $$.r0 = 0; }
	| LPAREN X RPAREN
	{ $$.r0 = 1; }
;

xpmod1:
	{ $$.r0 = 0; }
	| LPAREN X RPAREN
	{ $$.r0 = 0; }
	| LPAREN Z RPAREN
	{ $$.r0 = 1; }
;

vsmod:
	{ $$.r0 = 0; $$.s0 = 0; }
	| LPAREN NS RPAREN
	{ $$.r0 = 0; $$.s0 = 0; }
	| LPAREN S RPAREN
	{ $$.r0 = 0; $$.s0 = 1; }
	| LPAREN V RPAREN
	{ $$.r0 = 1; $$.s0 = 0; }
	| LPAREN V COMMA S RPAREN
	{ $$.r0 = 1; $$.s0 = 1; }
	| LPAREN S COMMA V RPAREN
	{ $$.r0 = 1; $$.s0 = 1; }
;

vmod:
	{ $$.r0 = 0; }
	| LPAREN V RPAREN
	{ $$.r0 = 1; }
;

smod:
	{ $$.s0 = 0; }
	| LPAREN S RPAREN
	{ $$.s0 = 1; }
;

searchmod:
	  GE
	{ $$.r0 = 1; }
	| GT
	{ $$.r0 = 0; }
	| LE
	{ $$.r0 = 3; }
	| LT
	{ $$.r0 = 2; }
;


aligndir:
	{ $$.r0 = 0; }
	| LPAREN R RPAREN
	{ $$.r0 = 1; }
;

byteop_mod:
	LPAREN R RPAREN
	{ $$.r0 = 0; $$.s0 = 1; }
	| LPAREN MMOD RPAREN
	{ if ($2 != M_T)
	    return semantic_error ("Bad modifier");
	  $$.r0 = 1; $$.s0 = 0; }
	| LPAREN MMOD COMMA R RPAREN
	{ if ($2 != M_T)
	    return semantic_error ("Bad modifier");
	  $$.r0 = 1; $$.s0 = 1; }
	| LPAREN R COMMA MMOD RPAREN
	{ if ($4 != M_T)
	    return semantic_error ("Bad modifier");
	  $$.r0 = 1; $$.s0 = 1; }
;



c_align:
	ALIGN8
	{ $$.r0 = 0; }
	| ALIGN16
	{ $$.r0 = 1; }
	| ALIGN24
	{ $$.r0 = 2; }
;

w32_or_nothing:
	{ $$.r0 = 0; }
	| LPAREN MMOD RPAREN
	{
	  if ($2 == M_W32)
	    $$.r0 = 1;
	  else
	    return semantic_error ("Only (W32) allowed");
	}
;

iu_or_nothing:
	{ $$.r0 = 1; }
	| LPAREN MMOD RPAREN
	{
	  if ($2 == M_IU)
	    $$.r0 = 3;
	  else
	    return semantic_error ("(IU) expected");
	}
;


/* } */
// Operators
/* { */

min_max:
	MIN
	{ $$.r0 = 1; }
	| MAX
	{ $$.r0 = 0; }
;
 
op_bar_op:
	_PLUS_BAR_PLUS
	{ $$.r0 = 0; }
	| _PLUS_BAR_MINUS
	{ $$.r0 = 1; }
	| _MINUS_BAR_PLUS
	{ $$.r0 = 2; }
	| _MINUS_BAR_MINUS
	{ $$.r0 = 3; }
;

plus_minus:
	PLUS
	{ $$.r0 = 0; }
	| MINUS
	{ $$.r0 = 1; }
;

rnd_op:
	LPAREN RNDH RPAREN
	{
	  $$.r0 = 1; // HL
	  $$.s0 = 0; // s
	  $$.x0 = 0; // x
	  $$.aop = 0; // aop
	}

	| LPAREN TH RPAREN
	{
	  $$.r0 = 1; // HL
	  $$.s0 = 0; // s
	  $$.x0 = 0; // x
	  $$.aop = 1; // aop
	}

	| LPAREN RNDL RPAREN
	{
	  $$.r0 = 0; // HL
	  $$.s0 = 0; // s
	  $$.x0 = 0; // x
	  $$.aop = 0; // aop
	}

	| LPAREN TL RPAREN
	{
	  $$.r0 = 0; // HL
	  $$.s0 = 0; // s
	  $$.x0 = 0; // x
	  $$.aop = 1;
	}

	| LPAREN RNDH COMMA R RPAREN
	{
	  $$.r0 = 1; // HL
	  $$.s0 = 1; // s
	  $$.x0 = 0; // x
	  $$.aop = 0; // aop
	}

	| LPAREN TH COMMA R RPAREN
	{
	  $$.r0 = 1; // HL
	  $$.s0 = 1; // s
	  $$.x0 = 0; // x
	  $$.aop = 1; // aop
	}

	| LPAREN RNDL COMMA R RPAREN
	{
	  $$.r0 = 0; // HL
	  $$.s0 = 1; // s
	  $$.x0 = 0; // x
	  $$.aop = 0; // aop
	}

	| LPAREN TL COMMA R RPAREN
	{
	  $$.r0 = 0; // HL
	  $$.s0 = 1; // s
	  $$.x0 = 0; // x
	  $$.aop = 1;  // aop
	}
;

b3_op:
	LPAREN LO RPAREN
	{
	  $$.s0 = 0; // s
	  $$.x0 = 0; // HL
	}

	| LPAREN HI RPAREN
	{
	  $$.s0 = 0; // s
	  $$.x0 = 1; // HL
	}
	| LPAREN LO COMMA R RPAREN
	{
	  $$.s0 = 1; // s
	  $$.x0 = 0; // HL
	}

	| LPAREN HI COMMA R RPAREN
	{
	  $$.s0 = 1; // s
	  $$.x0 = 1; // HL
	}
;

post_op:
	{ $$.x0 = 2; }
	| _PLUS_PLUS 
	{ $$.x0 = 0; }
	| _MINUS_MINUS
	{ $$.x0 = 1; }
;

/* } */
// Assignments, Macfuncs
/* { */

a_assign:
	REG_A ASSIGN
	{ $$ = $1; }
;

a_minusassign:
	REG_A _MINUS_ASSIGN
	{ $$ = $1; }
;

a_plusassign:
	REG_A _PLUS_ASSIGN
	{ $$ = $1; }
;

assign_macfunc:
	REG ASSIGN REG_A
	{
	  $$.w = 1; $$.P = 1; $$.n = IS_A1 ($3);
	  $$.op = 3; $$.dst = $1;
	  $$.s0.regno = 0; $$.s1.regno = 0; // XXX
	}

	| a_macfunc
	{
	  $$ = $1;
	  $$.w = 0; $$.P = 0;
	  $$.dst.regno = 0;
	}

	| REG ASSIGN LPAREN a_macfunc RPAREN
	{
	  $$ = $4;
	  $$.w = 1; $$.P = 1; $$.dst = $1;
	}

	| HALF_REG ASSIGN LPAREN a_macfunc RPAREN
	{
	  $$ = $4;
	  $$.w = 1; $$.P = 0; $$.dst = $1;
	}

	| HALF_REG ASSIGN REG_A
	{
	  $$.w = 1; $$.P = 0; $$.n = IS_A1 ($3);
	  $$.op = 3; $$.dst = $1;
	  $$.s0.regno = 0; $$.s1.regno = 0;
	}
;

a_macfunc:
	a_assign HALF_REG STAR HALF_REG
	{
	  $$.n = IS_A1 ($1); $$.op = 0;  $$.s0 = $2; $$.s1 = $4;
	}
	| a_plusassign HALF_REG STAR HALF_REG
	{
	  $$.n = IS_A1 ($1); $$.op = 1;  $$.s0 = $2; $$.s1 = $4;
	}
	| a_minusassign HALF_REG STAR HALF_REG
	{
	  $$.n = IS_A1 ($1); $$.op = 2;  $$.s0 = $2; $$.s1 = $4;
	}
;

multfunc:
	HALF_REG STAR HALF_REG
	{
	  if (IS_DREG ($1) && IS_DREG ($3))
	    {
	      $$.s0 = $1; $$.s1 = $3;
	    }
	  else
	    return semantic_error ("Multfunc expects Dregs");
	}
;

cc_op:
	ASSIGN
	{ $$.r0 = 0; }
	| _BAR_ASSIGN
	{ $$.r0 = 1; }
	| _AMPERSAND_ASSIGN
	{ $$.r0 = 2; }
	| _CARET_ASSIGN
	{ $$.r0 = 3; }
;

ccstat:
	CCREG cc_op MODIFIED_STATUS_REG
	{ $$.r0 = $3.regno; $$.x0 = $2.r0; $$.s0 = 0; }

	| CCREG cc_op V
	{ $$.r0 = 0x18; $$.x0 = $2.r0; $$.s0 = 0; }

	| MODIFIED_STATUS_REG cc_op CCREG
	{ $$.r0 = $1.regno; $$.x0 = $2.r0; $$.s0 = 1; }

	| V cc_op CCREG
	{ $$.r0 = 0x18; $$.x0 = $2.r0; $$.s0 = 1; }

;

/* } */

// Expressions / Symbols

// Changed this such that expressions as:
// 
//    r0 = 2 + (1 << 4) * 3;
//
// are valid without brackets


symbol: SYMBOL
	{ ExprNodeValue val; val.s_value = S_GET_NAME($1);
	  $$ = ExprNodeCreate(ExprNodeReloc, val, NULL, NULL); }
;

got :
	symbol AT GOT
	{ $$ = $1; }
;

got_or_expr: got {$$ = $1;}
	| expr { $$ = $1; }
;

pltpc :
	symbol AT PLTPC
	{ $$ = $1; }
;

eterm: NUMBER
	{ ExprNodeValue val; val.i_value = $1;
	  $$ = ExprNodeCreate(ExprNodeConstant, val, NULL, NULL); }
	| symbol
	{ $$ = $1; }
	| LPAREN expr_1 RPAREN
	{ $$ = $2; }
	| TILDA expr_1
	{ $$ = unary(ExprOpTypeCOMP,$2); }
	| MINUS expr_1 %prec TILDA
	{ $$ = unary(ExprOpTypeNEG,$2); }
;

expr: expr_1
	{ $$ = $1; }
;

expr_1: expr_1 STAR expr_1
	{ $$ = binary(ExprOpTypeMult,$1,$3); }
	| expr_1 SLASH expr_1
	{ $$ = binary(ExprOpTypeDiv,$1,$3); }
	| expr_1 PERCENT expr_1
	{ $$ = binary(ExprOpTypeMod,$1,$3); }
	| expr_1 PLUS expr_1
	{ $$ = binary(ExprOpTypeAdd,$1,$3); }
	| expr_1 MINUS expr_1
	{ $$ = binary(ExprOpTypeSub,$1,$3); }
	| expr_1 LESS_LESS expr_1
	{ $$ = binary(ExprOpTypeLsft,$1,$3); }
	| expr_1 GREATER_GREATER expr_1
	{ $$ = binary(ExprOpTypeRsft,$1,$3); }
	| expr_1 AMPERSAND expr_1
	{ $$ = binary(ExprOpTypeBAND,$1,$3); }
	| expr_1 CARET expr_1
	{ $$ = binary(ExprOpTypeLOR,$1,$3); }
	| expr_1 BAR expr_1
	{ $$ = binary(ExprOpTypeBOR,$1,$3); }
	| eterm	
	{ $$ = $1; }
;


%%

EXPR_T mkexpr(int x, SYMBOL_T s)
{
  EXPR_T e = (EXPR_T) ALLOCATE(sizeof (struct expression_cell));
  e->value = x;
  EXPR_SYMBOL(e) = s;
  return e;
}

static int
value_match(ExprNode *expr, int sz, int sign, int mul, int issigned)
{
  long umax = (1L << sz) - 1;
  long min = -1L << (sz - 1);
  long max = (1L << (sz - 1)) - 1;
	
  long v = EXPR_VALUE (expr);

  if ((v % mul) != 0)
    {
      fprintf(stderr, "ValueError: Must align to %d\n", mul);
      return 0;
    }

  v /= mul;

  if (sign) v = -v;

  if (issigned)
    {
      if (v >= min && v <= max) return 1;
#ifdef DEBUG
      fprintf(stderr, "signed value %lx out of range\n", v * mul);
#endif
      return 0;
    }
  if (v <= umax && v >= 0) 
    return 1;
#ifdef DEBUG
  fprintf(stderr, "unsigned value %lx out of range\n", v * mul);
#endif
  return 0;
}

/* Return the new expression structure that allows symbol operations
   if the left and right children are constants, do the operation  */
static ExprNode *binary (ExprOpType op, ExprNode *x, ExprNode *y)
{
  if(x->type == ExprNodeConstant && y->type == ExprNodeConstant)
    {
      switch (op)
	{
        case ExprOpTypeAdd: 
	  x->value.i_value += y->value.i_value;
	  break;
        case ExprOpTypeSub: 
	  x->value.i_value -= y->value.i_value;
	  break;
        case ExprOpTypeMult: 
	  x->value.i_value *= y->value.i_value;
	  break;
        case ExprOpTypeDiv: 
	  x->value.i_value /= y->value.i_value;
	  break;
        case ExprOpTypeMod: 
	  x->value.i_value %= y->value.i_value;
	  break;
        case ExprOpTypeLsft: 
	  x->value.i_value <<= y->value.i_value;
	  break;
        case ExprOpTypeRsft: 
	  x->value.i_value >>= y->value.i_value;
	  break;
        case ExprOpTypeBAND: 
	  x->value.i_value &= y->value.i_value;
	  break;
        case ExprOpTypeBOR: 
	  x->value.i_value |= y->value.i_value;
	  break;
        case ExprOpTypeBXOR: 
	  x->value.i_value ^= y->value.i_value;
	  break;
        case ExprOpTypeLAND: 
	  x->value.i_value = x->value.i_value && y->value.i_value;
	  break;
        case ExprOpTypeLOR: 
	  x->value.i_value = x->value.i_value || y->value.i_value;
	  break;

	default:
	  fprintf(stderr, "Internal compiler error at line %d in file %s\n", __LINE__, __FILE__);
	}
      return x; // should delete y
    }
  else
    {
    /* create a new expression structure */
    ExprNodeValue val;
    val.op_value = op;
    return ExprNodeCreate(ExprNodeBinop, val, x, y);
  }
}

static ExprNode * unary(ExprOpType op,ExprNode * x) 
{
  if (x->type == ExprNodeConstant)
    {
      switch (op)
	{
	case ExprOpTypeNEG: 
	  x->value.i_value = -x->value.i_value;
	  break;
	case ExprOpTypeCOMP:
	  x->value.i_value = ~x->value.i_value;
	  break;
	default:
	  fprintf(stderr, "Internal compiler error at line %d in file %s\n", __LINE__, __FILE__);
	}
      return x;
    }
  else
    {
      /* create a new expression structure */
      ExprNodeValue val;
      val.op_value = op;
      return ExprNodeCreate(ExprNodeUnop, val, x, NULL);
    }
}

int debug_codeselection = 0;
static void
notethat(char *format, ...)
{
  va_list ap;
  va_start (ap, format);
  if (debug_codeselection)
    {
      vfprintf (errorf, format, ap);
    }
  va_end (ap);
}

#ifdef TEST
main (int argc, char **argv)
{
  yyparse();
}
#endif

