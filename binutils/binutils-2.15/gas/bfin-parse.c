/* A Bison parser, made by GNU Bison 1.875.  */

/* Skeleton parser for Yacc-like parsing with Bison,
   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* Written by Richard Stallman by simplifying the original so called
   ``semantic'' parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     BYTEOP16P = 258,
     BYTEOP16M = 259,
     BYTEOP1P = 260,
     BYTEOP2P = 261,
     BYTEOP2M = 262,
     BYTEOP3P = 263,
     BYTEUNPACK = 264,
     BYTEPACK = 265,
     PACK = 266,
     SAA = 267,
     ALIGN8 = 268,
     ALIGN16 = 269,
     ALIGN24 = 270,
     VIT_MAX = 271,
     EXTRACT = 272,
     DEPOSIT = 273,
     EXPADJ = 274,
     SEARCH = 275,
     ONES = 276,
     SIGN = 277,
     SIGNBITS = 278,
     LINK = 279,
     UNLINK = 280,
     REG = 281,
     PC = 282,
     CCREG = 283,
     BYTE_REG = 284,
     REG_A00 = 285,
     REG_A11 = 286,
     A_ZERO_DOT_L = 287,
     A_ZERO_DOT_H = 288,
     A_ONE_DOT_L = 289,
     A_ONE_DOT_H = 290,
     HALF_REG = 291,
     NOP = 292,
     RTI = 293,
     RTS = 294,
     RTX = 295,
     RTN = 296,
     RTE = 297,
     HLT = 298,
     IDLE = 299,
     STI = 300,
     CLI = 301,
     CSYNC = 302,
     SSYNC = 303,
     EMUEXCPT = 304,
     RAISE = 305,
     EXCPT = 306,
     LSETUP = 307,
     DISALGNEXCPT = 308,
     JUMP = 309,
     JUMP_DOT_S = 310,
     JUMP_DOT_L = 311,
     CALL = 312,
     ABORT = 313,
     NOT = 314,
     TILDA = 315,
     BANG = 316,
     AMPERSAND = 317,
     BAR = 318,
     PERCENT = 319,
     CARET = 320,
     BXOR = 321,
     MINUS = 322,
     PLUS = 323,
     STAR = 324,
     SLASH = 325,
     NEG = 326,
     MIN = 327,
     MAX = 328,
     ABS = 329,
     DOUBLE_BAR = 330,
     _PLUS_BAR_PLUS = 331,
     _PLUS_BAR_MINUS = 332,
     _MINUS_BAR_PLUS = 333,
     _MINUS_BAR_MINUS = 334,
     _MINUS_MINUS = 335,
     _PLUS_PLUS = 336,
     SHIFT = 337,
     LSHIFT = 338,
     ASHIFT = 339,
     BXORSHIFT = 340,
     _GREATER_GREATER_GREATER_THAN_ASSIGN = 341,
     ROT = 342,
     LESS_LESS = 343,
     GREATER_GREATER = 344,
     _GREATER_GREATER_GREATER = 345,
     _LESS_LESS_ASSIGN = 346,
     _GREATER_GREATER_ASSIGN = 347,
     DIVS = 348,
     DIVQ = 349,
     ASSIGN = 350,
     _STAR_ASSIGN = 351,
     _BAR_ASSIGN = 352,
     _CARET_ASSIGN = 353,
     _AMPERSAND_ASSIGN = 354,
     _MINUS_ASSIGN = 355,
     _PLUS_ASSIGN = 356,
     _ASSIGN_BANG = 357,
     _LESS_THAN_ASSIGN = 358,
     _ASSIGN_ASSIGN = 359,
     GE = 360,
     LT = 361,
     LE = 362,
     GT = 363,
     LESS_THAN = 364,
     FLUSHINV = 365,
     FLUSH = 366,
     IFLUSH = 367,
     PREFETCH = 368,
     PRNT = 369,
     OUTC = 370,
     WHATREG = 371,
     TESTSET = 372,
     ASL = 373,
     ASR = 374,
     B = 375,
     W = 376,
     NS = 377,
     S = 378,
     CO = 379,
     SCO = 380,
     TH = 381,
     TL = 382,
     BP = 383,
     BREV = 384,
     X = 385,
     Z = 386,
     M = 387,
     MMOD = 388,
     R = 389,
     RND = 390,
     RNDL = 391,
     RNDH = 392,
     RND12 = 393,
     RND20 = 394,
     V = 395,
     LO = 396,
     HI = 397,
     BITTGL = 398,
     BITCLR = 399,
     BITSET = 400,
     BITTST = 401,
     BITMUX = 402,
     DBGAL = 403,
     DBGAH = 404,
     DBGHALT = 405,
     DBG = 406,
     DBGA = 407,
     DBGCMPLX = 408,
     IF = 409,
     COMMA = 410,
     BY = 411,
     COLON = 412,
     SEMICOLON = 413,
     RPAREN = 414,
     LPAREN = 415,
     LBRACK = 416,
     RBRACK = 417,
     MODIFIED_STATUS_REG = 418,
     MNOP = 419,
     SYMBOL = 420,
     NUMBER = 421
   };
#endif
#define BYTEOP16P 258
#define BYTEOP16M 259
#define BYTEOP1P 260
#define BYTEOP2P 261
#define BYTEOP2M 262
#define BYTEOP3P 263
#define BYTEUNPACK 264
#define BYTEPACK 265
#define PACK 266
#define SAA 267
#define ALIGN8 268
#define ALIGN16 269
#define ALIGN24 270
#define VIT_MAX 271
#define EXTRACT 272
#define DEPOSIT 273
#define EXPADJ 274
#define SEARCH 275
#define ONES 276
#define SIGN 277
#define SIGNBITS 278
#define LINK 279
#define UNLINK 280
#define REG 281
#define PC 282
#define CCREG 283
#define BYTE_REG 284
#define REG_A00 285
#define REG_A11 286
#define A_ZERO_DOT_L 287
#define A_ZERO_DOT_H 288
#define A_ONE_DOT_L 289
#define A_ONE_DOT_H 290
#define HALF_REG 291
#define NOP 292
#define RTI 293
#define RTS 294
#define RTX 295
#define RTN 296
#define RTE 297
#define HLT 298
#define IDLE 299
#define STI 300
#define CLI 301
#define CSYNC 302
#define SSYNC 303
#define EMUEXCPT 304
#define RAISE 305
#define EXCPT 306
#define LSETUP 307
#define DISALGNEXCPT 308
#define JUMP 309
#define JUMP_DOT_S 310
#define JUMP_DOT_L 311
#define CALL 312
#define ABORT 313
#define NOT 314
#define TILDA 315
#define BANG 316
#define AMPERSAND 317
#define BAR 318
#define PERCENT 319
#define CARET 320
#define BXOR 321
#define MINUS 322
#define PLUS 323
#define STAR 324
#define SLASH 325
#define NEG 326
#define MIN 327
#define MAX 328
#define ABS 329
#define DOUBLE_BAR 330
#define _PLUS_BAR_PLUS 331
#define _PLUS_BAR_MINUS 332
#define _MINUS_BAR_PLUS 333
#define _MINUS_BAR_MINUS 334
#define _MINUS_MINUS 335
#define _PLUS_PLUS 336
#define SHIFT 337
#define LSHIFT 338
#define ASHIFT 339
#define BXORSHIFT 340
#define _GREATER_GREATER_GREATER_THAN_ASSIGN 341
#define ROT 342
#define LESS_LESS 343
#define GREATER_GREATER 344
#define _GREATER_GREATER_GREATER 345
#define _LESS_LESS_ASSIGN 346
#define _GREATER_GREATER_ASSIGN 347
#define DIVS 348
#define DIVQ 349
#define ASSIGN 350
#define _STAR_ASSIGN 351
#define _BAR_ASSIGN 352
#define _CARET_ASSIGN 353
#define _AMPERSAND_ASSIGN 354
#define _MINUS_ASSIGN 355
#define _PLUS_ASSIGN 356
#define _ASSIGN_BANG 357
#define _LESS_THAN_ASSIGN 358
#define _ASSIGN_ASSIGN 359
#define GE 360
#define LT 361
#define LE 362
#define GT 363
#define LESS_THAN 364
#define FLUSHINV 365
#define FLUSH 366
#define IFLUSH 367
#define PREFETCH 368
#define PRNT 369
#define OUTC 370
#define WHATREG 371
#define TESTSET 372
#define ASL 373
#define ASR 374
#define B 375
#define W 376
#define NS 377
#define S 378
#define CO 379
#define SCO 380
#define TH 381
#define TL 382
#define BP 383
#define BREV 384
#define X 385
#define Z 386
#define M 387
#define MMOD 388
#define R 389
#define RND 390
#define RNDL 391
#define RNDH 392
#define RND12 393
#define RND20 394
#define V 395
#define LO 396
#define HI 397
#define BITTGL 398
#define BITCLR 399
#define BITSET 400
#define BITTST 401
#define BITMUX 402
#define DBGAL 403
#define DBGAH 404
#define DBGHALT 405
#define DBG 406
#define DBGA 407
#define DBGCMPLX 408
#define IF 409
#define COMMA 410
#define BY 411
#define COLON 412
#define SEMICOLON 413
#define RPAREN 414
#define LPAREN 415
#define LBRACK 416
#define RBRACK 417
#define MODIFIED_STATUS_REG 418
#define MNOP 419
#define SYMBOL 420
#define NUMBER 421




/* Copy the first part of user declarations.  */
#line 29 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"


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

void error(char *format, ...)
{
    va_list ap;
    char buffer[2000];
    
    va_start (ap, format);
    vsprintf (buffer, format, ap);
    va_end (ap);

    as_bad(buffer);
}


#define semantic_error(s) _semantic_error(s, __LINE__)
#define register_mismatch() _register_mismatch(__LINE__)

static
int _semantic_error(char *syntax, int line)
{
    error("\nSyntax error:<%d>:  `%s'\n", line, syntax);
	return -1;
}

static
int _register_mismatch(int line)
{
	return _semantic_error("Register mismatch", line);
}

int yyerror(char *msg) {
    error("\n %s Input text was `%s'\n", msg, yytext);
    return 0;	/* means successful	*/
}

extern int yylex (void);

#define uimm2(x) EXPR_VALUE(x)
#define uimm3(x) EXPR_VALUE(x)
#define imm3(x) EXPR_VALUE(x)
#define pcrel4(x) ((EXPR_VALUE(x))>>1)
#define imm4(x) EXPR_VALUE(x)
#define uimm4s4(x) ((EXPR_VALUE(x))>>2)
#define uimm4(x) EXPR_VALUE(x)
#define uimm4s2(x) ((EXPR_VALUE(x))>>1)
#define negimm5s4(x) ((EXPR_VALUE(x))>>2)
#define imm5(x) EXPR_VALUE(x)
#define uimm5(x) EXPR_VALUE(x)
#define imm6(x) EXPR_VALUE(x)
#define imm7(x) EXPR_VALUE(x)
#define imm8(x) EXPR_VALUE(x)
#define uimm8(x) EXPR_VALUE(x)
#define pcrel8(x) ((EXPR_VALUE(x))>>1)
#define uimm8s4(x) ((EXPR_VALUE(x))>>2)
#define pcrel8s4(x) ((EXPR_VALUE(x))>>2)
#define lppcrel10(x) ((EXPR_VALUE(x))>>1)
#define pcrel10(x) ((EXPR_VALUE(x))>>1)
#define pcrel12(x) ((EXPR_VALUE(x))>>1)
#define imm16s4(x) ((EXPR_VALUE(x))>>2)
#define luimm16(x) EXPR_VALUE(x)
#define imm16(x) EXPR_VALUE(x)
#define huimm16(x) EXPR_VALUE(x)
#define rimm16(x) EXPR_VALUE(x)
#define imm16s2(x) ((EXPR_VALUE(x))>>1)
#define uimm16s4(x) ((EXPR_VALUE(x))>>2)
#define uimm16(x) EXPR_VALUE(x)
#define pcrel24(x) ((EXPR_VALUE(x))>>1)


////////////////////////////////////////////////////////////////////////////
// Auxiliary functions
//


static
void neg_value(ExprNode *expr)
{
	expr->value.i_value = -expr->value.i_value;
}

static
int are_byteop_regs(Register *dst, Register *src0, ExprNode *s0,
	Register *src1, ExprNode *s1)
{
	if (!IS_DREG(*dst) || !IS_DREG(*src0) || !IS_DREG(*src1)) {
		semantic_error("Dregs expected"); return 0;
	}

	if (((src0->regno & CODE_MASK) != 1 || imm7(s0) != 0)
	 || ((src1->regno & CODE_MASK) != 3 || imm7(s1) != 2)) {
		semantic_error("Bad register pairs"); return 0;
	}
	return 1;
}

static int
check_multfuncs(Macfunc *aa, Macfunc *ab)
{
	if ( (!REG_EQUAL(aa->s0, ab->s0) && !REG_EQUAL(aa->s0, ab->s1))
	   ||(!REG_EQUAL(aa->s1, ab->s1) && !REG_EQUAL(aa->s1, ab->s0)) )
		return semantic_error("Source multiplication register mismatch");

	return 0;
}


// check (vector) mac funcs and ops:

static int
check_macfuncs(Macfunc *aa, Opt_mode *opa,
               Macfunc *ab, Opt_mode *opb)
{
	// Variables for swapping:
	Macfunc mtmp;
	Opt_mode otmp;


	// if a0macfunc comes before a1macfunc, swap them.
	
	if (aa->n == 0) {
		// (M) is not allowed here:
		if (opa->MM != 0) return semantic_error("(M) not allowed with A0MAC");
		if (ab->n != 1)   return semantic_error("Vector AxMACs can't be same");

		mtmp = *aa; *aa = *ab; *ab = mtmp;
		otmp = *opa; *opa = *opb; *opb = otmp;
	} else {
		if (opb->MM != 0) return semantic_error("(M) not allowed with A0MAC");
		if (opa->mod != 0) return semantic_error("Bad opt mode");
		if (ab->n != 0)   return semantic_error("Vector AxMACs can't be same");
	}

	// if both ops are != 3, we have multfuncs in both
	// assignment_or_macfuncs
	if (aa->op == ab->op && aa->op != 3) {
		if (check_multfuncs(aa, ab) < 0) return -1;
	} else {
	// only one of the assign_macfuncs has a multfunc.
	// Evil trick: Just 'OR' their source register codes:
	// We can do that, because we know they were initialized to 0
	// in the rules that don't use multfuncs.
		aa->s0.regno |= (ab->s0.regno & CODE_MASK);
		aa->s1.regno |= (ab->s1.regno & CODE_MASK);
	}

	if (aa->w == ab->w  && aa->P != ab->P) {
		return semantic_error("macfuncs must differ");
		if (aa->w && (aa->dst.regno - ab->dst.regno != 1))
			return semantic_error("Destination Dregs must differ by one");
	} else
	// We assign to full regs, thus obey even/odd rules:	
	if ( (aa->w && aa->P && IS_EVEN(aa->dst)) 
	  || (ab->w && ab->P && !IS_EVEN(ab->dst)) ) {
			return semantic_error("Even/Odd register assignment mismatch");
	} else 
	// We assign to half regs, thus obey hi/low rules:	
	if ( (aa->w && !aa->P && !IS_H(aa->dst)) 
	  || (ab->w && !aa->P && IS_H(ab->dst)) ) {
			return semantic_error("High/Low register assignment mismatch");
	}
	// Make sure first macfunc has got both P flags ORed
	aa->P |= ab->P;

	// Make sure mod flags get ORed, too
	opb->mod |= opa->mod;
	return 0;	
}


static int is_group1 (INSTR_T x)
{
    if ((x->value & 0xc000) == 0x8000  //dspLDST,LDSTpmod,LDST,LDSTiiFP,LDSTii
	|| (x->value == 0x0000))
		return 1;
	return 0;
}

static int is_group2 (INSTR_T x)
{
    if ( (((x->value & 0xfc00) == 0x9c00)  // pick dspLDST
	 && !((x->value & 0xfde0) == 0x9c60)  // pick dagMODim
	 && !((x->value & 0xfde0) == 0x9ce0)  // pick dagMODim with bit rev
	 && !((x->value & 0xfde0) == 0x9d60)) // pick dagMODik
	 || (x->value == 0x0000))
		return 1;
	return 0;
}



/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 387 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
typedef union YYSTYPE {
    INSTR_T instr;
    ExprNode *expr;
    SYMBOL_T symbol;
    long value;
	// new encoding of registers
	Register reg;

    Macfunc macfunc;
    struct { int r0; int s0; int x0; } modcodes;
    struct { int r0; } r0;
    Opt_mode mod;
} YYSTYPE;
/* Line 191 of yacc.c.  */
#line 779 "y.tab.c"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 214 of yacc.c.  */
#line 791 "y.tab.c"

#if ! defined (yyoverflow) || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# if YYSTACK_USE_ALLOCA
#  define YYSTACK_ALLOC alloca
# else
#  ifndef YYSTACK_USE_ALLOCA
#   if defined (alloca) || defined (_ALLOCA_H)
#    define YYSTACK_ALLOC alloca
#   else
#    ifdef __GNUC__
#     define YYSTACK_ALLOC __builtin_alloca
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning. */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
# else
#  if defined (__STDC__) || defined (__cplusplus)
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   define YYSIZE_T size_t
#  endif
#  define YYSTACK_ALLOC malloc
#  define YYSTACK_FREE free
# endif
#endif /* ! defined (yyoverflow) || YYERROR_VERBOSE */


#if (! defined (yyoverflow) \
     && (! defined (__cplusplus) \
	 || (YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  short yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short) + sizeof (YYSTYPE))				\
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  register YYSIZE_T yyi;		\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (0)
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (0)

#endif

#if defined (__STDC__) || defined (__cplusplus)
   typedef signed char yysigned_char;
#else
   typedef short yysigned_char;
#endif

/* YYFINAL -- State number of the termination state. */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1395

/* YYNTOKENS -- Number of terminals. */
#define YYNTOKENS  167
/* YYNNTS -- Number of nonterminals. */
#define YYNNTS  42
/* YYNRULES -- Number of rules. */
#define YYNRULES  334
/* YYNRULES -- Number of states. */
#define YYNSTATES  1020

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   421

#define YYTRANSLATE(YYX) 						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const unsigned char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,   128,   129,   130,   131,   132,   133,   134,
     135,   136,   137,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   147,   148,   149,   150,   151,   152,   153,   154,
     155,   156,   157,   158,   159,   160,   161,   162,   163,   164,
     165,   166
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const unsigned short yyprhs[] =
{
       0,     0,     3,     4,     7,    10,    17,    24,    29,    32,
      37,    39,    42,    48,    50,    57,    64,    68,    72,    90,
     108,   120,   132,   144,   157,   170,   183,   189,   193,   197,
     201,   210,   224,   238,   252,   266,   275,   293,   300,   310,
     314,   321,   325,   331,   338,   347,   356,   359,   362,   367,
     371,   374,   379,   383,   390,   395,   403,   411,   415,   419,
     426,   430,   435,   439,   443,   447,   459,   471,   481,   487,
     493,   503,   509,   515,   522,   529,   535,   541,   547,   554,
     561,   567,   569,   573,   577,   581,   585,   590,   595,   605,
     615,   621,   629,   634,   641,   648,   656,   666,   675,   684,
     696,   706,   711,   717,   724,   732,   739,   744,   751,   757,
     764,   771,   776,   785,   796,   807,   820,   826,   833,   839,
     846,   851,   856,   861,   869,   879,   889,   899,   906,   913,
     920,   929,   938,   945,   951,   957,   966,   971,   979,   981,
     983,   985,   987,   989,   991,   993,   995,   997,   999,  1002,
    1005,  1010,  1015,  1022,  1029,  1032,  1035,  1040,  1043,  1046,
    1049,  1052,  1059,  1066,  1072,  1077,  1081,  1085,  1089,  1093,
    1097,  1101,  1106,  1112,  1117,  1123,  1128,  1134,  1139,  1145,
    1153,  1162,  1171,  1179,  1187,  1195,  1205,  1213,  1222,  1232,
    1241,  1248,  1256,  1265,  1275,  1284,  1292,  1300,  1307,  1322,
    1333,  1348,  1359,  1366,  1369,  1371,  1379,  1389,  1401,  1403,
    1406,  1409,  1414,  1416,  1423,  1430,  1437,  1439,  1441,  1442,
    1448,  1454,  1458,  1462,  1466,  1470,  1471,  1473,  1475,  1477,
    1479,  1481,  1482,  1486,  1487,  1491,  1495,  1496,  1500,  1504,
    1510,  1516,  1517,  1521,  1525,  1526,  1530,  1534,  1535,  1539,
    1543,  1547,  1553,  1559,  1560,  1564,  1565,  1569,  1571,  1573,
    1575,  1577,  1578,  1582,  1586,  1590,  1596,  1602,  1604,  1606,
    1608,  1609,  1613,  1614,  1618,  1620,  1622,  1624,  1626,  1628,
    1630,  1632,  1634,  1638,  1642,  1646,  1650,  1656,  1662,  1668,
    1674,  1678,  1682,  1688,  1694,  1695,  1697,  1699,  1702,  1705,
    1708,  1712,  1714,  1720,  1726,  1730,  1735,  1740,  1745,  1749,
    1751,  1753,  1755,  1757,  1761,  1765,  1769,  1773,  1775,  1777,
    1779,  1783,  1786,  1789,  1791,  1795,  1799,  1803,  1807,  1811,
    1815,  1819,  1823,  1827,  1831
};

/* YYRHS -- A `-1'-separated list of the rules' RHS. */
static const short yyrhs[] =
{
     168,     0,    -1,    -1,   169,   170,    -1,   171,   158,    -1,
     171,    75,   171,    75,   171,   158,    -1,   164,    75,   171,
      75,   171,   158,    -1,   164,    75,   171,   158,    -1,   164,
     158,    -1,   171,    75,   171,   158,    -1,     1,    -1,   200,
     173,    -1,   200,   173,   155,   200,   173,    -1,    53,    -1,
      26,    95,   160,   199,   172,   159,    -1,    36,    95,   160,
     199,   172,   159,    -1,    33,    95,    36,    -1,    35,    95,
      36,    -1,   160,    26,   155,    26,   159,    95,     3,   160,
      26,   157,   207,   155,    26,   157,   207,   159,   186,    -1,
     160,    26,   155,    26,   159,    95,     4,   160,    26,   157,
     207,   155,    26,   157,   207,   159,   186,    -1,   160,    26,
     155,    26,   159,    95,     9,    26,   157,   207,   186,    -1,
     160,    26,   155,    26,   159,    95,    20,    26,   160,   185,
     159,    -1,    26,    95,    34,    68,    35,   155,    26,    95,
      32,    68,    33,    -1,    26,    95,   172,    68,   172,   155,
      26,    95,   172,    67,   172,   178,    -1,    26,    95,    26,
     193,    26,   155,    26,    95,    26,   193,    26,   178,    -1,
      26,    95,    26,   192,    26,   155,    26,    95,    26,   192,
      26,   179,    -1,    26,    95,    74,    26,   183,    -1,   197,
      74,   172,    -1,    32,    95,    36,    -1,    34,    95,    36,
      -1,    26,    95,   188,   160,    26,   155,    26,   159,    -1,
      26,    95,     5,   160,    26,   157,   207,   155,    26,   157,
     207,   159,   187,    -1,    26,    95,     6,   160,    26,   157,
     207,   155,    26,   157,   207,   159,   194,    -1,    26,    95,
       7,   160,    26,   157,   207,   155,    26,   157,   207,   159,
     194,    -1,    26,    95,     8,   160,    26,   157,   207,   155,
      26,   157,   207,   159,   195,    -1,    26,    95,    10,   160,
      26,   155,    26,   159,    -1,    36,    95,    36,    95,    22,
     160,    36,   159,    69,    36,    68,    22,   160,    36,   159,
      69,    36,    -1,    26,    95,    26,   193,    26,   178,    -1,
      26,    95,   191,   160,    26,   155,    26,   159,   183,    -1,
     197,    67,   172,    -1,    36,    95,    36,   193,    36,   178,
      -1,   197,   197,   207,    -1,   197,   172,   160,   123,   159,
      -1,    36,    95,    26,   160,   135,   159,    -1,    36,    95,
      26,   193,    26,   160,   138,   159,    -1,    36,    95,    26,
     193,    26,   160,   139,   159,    -1,   197,   172,    -1,   197,
      26,    -1,    26,    95,    36,   180,    -1,    36,    95,   207,
      -1,   197,   207,    -1,    26,    95,   207,   181,    -1,    36,
      95,    26,    -1,    26,    95,    26,   192,    26,   177,    -1,
      26,    95,    29,   180,    -1,   197,    74,   172,   155,   197,
      74,   172,    -1,   197,    67,   172,   155,   197,    67,   172,
      -1,   198,   172,   189,    -1,    26,   100,   207,    -1,    26,
     101,    26,   160,   129,   159,    -1,    26,   100,    26,    -1,
     172,   101,   172,   189,    -1,    26,   101,    26,    -1,    26,
     101,   207,    -1,    26,    96,    26,    -1,    12,   160,    26,
     157,   207,   155,    26,   157,   207,   159,   186,    -1,   197,
     172,   160,   123,   159,   155,   197,   172,   160,   123,   159,
      -1,    26,    95,   160,    26,    68,    26,   159,    88,   207,
      -1,    26,    95,    26,    63,    26,    -1,    26,    95,    26,
      65,    26,    -1,    26,    95,    26,    68,   160,    26,    88,
     207,   159,    -1,    28,    95,   172,   104,   172,    -1,    28,
      95,   172,   109,   172,    -1,    28,    95,    26,   109,    26,
     190,    -1,    28,    95,    26,   109,   207,   190,    -1,    28,
      95,    26,   104,    26,    -1,    28,    95,    26,   104,   207,
      -1,    28,    95,   172,   103,   172,    -1,    28,    95,    26,
     103,    26,   190,    -1,    28,    95,    26,   103,   207,   190,
      -1,    26,    95,    26,    62,    26,    -1,   204,    -1,    26,
      95,    26,    -1,    28,    95,    26,    -1,    26,    95,    28,
      -1,    28,   102,    28,    -1,    36,    95,   202,   173,    -1,
      26,    95,   202,   173,    -1,    36,    95,   202,   173,   155,
      36,    95,   202,   173,    -1,    26,    95,   202,   173,   155,
      26,    95,   202,   173,    -1,   197,    84,   172,   156,    36,
      -1,    36,    95,    84,    36,   156,    36,   184,    -1,   197,
     172,    88,   207,    -1,    26,    95,    26,    88,   207,   182,
      -1,    36,    95,    36,    88,   207,   184,    -1,    26,    95,
      84,    26,   156,    36,   182,    -1,    36,    95,    19,   160,
      26,   155,    36,   159,   183,    -1,    36,    95,    19,   160,
      36,   155,    36,   159,    -1,    26,    95,    18,   160,    26,
     155,    26,   159,    -1,    26,    95,    18,   160,    26,   155,
      26,   159,   160,   130,   159,    -1,    26,    95,    17,   160,
      26,   155,    36,   159,   180,    -1,   197,   172,    90,   207,
      -1,   197,    83,   172,   156,    36,    -1,    36,    95,    83,
      36,   156,    36,    -1,    26,    95,    83,    26,   156,    36,
     183,    -1,    26,    95,    82,    26,   156,    36,    -1,   197,
     172,    89,   207,    -1,    26,    95,    26,    89,   207,   183,
      -1,    36,    95,    36,    89,   207,    -1,    36,    95,    36,
      90,   207,   184,    -1,    26,    95,    26,    90,   207,   182,
      -1,    36,    95,    21,    26,    -1,    26,    95,    11,   160,
      36,   155,    36,   159,    -1,    36,    95,    28,    95,    85,
     160,   172,   155,    26,   159,    -1,    36,    95,    28,    95,
      66,   160,   172,   155,    26,   159,    -1,    36,    95,    28,
      95,    66,   160,   172,   155,   172,   155,    28,   159,    -1,
     197,    87,   172,   156,    36,    -1,    26,    95,    87,    26,
     156,    36,    -1,   197,    87,   172,   156,   207,    -1,    26,
      95,    87,    26,   156,   207,    -1,    36,    95,    23,   172,
      -1,    36,    95,    23,    26,    -1,    36,    95,    23,    36,
      -1,    36,    95,    16,   160,    26,   159,   174,    -1,    26,
      95,    16,   160,    26,   155,    26,   159,   174,    -1,   147,
     160,    26,   155,    26,   155,   172,   159,   174,    -1,   197,
      85,   160,   172,   155,   172,   155,    28,   159,    -1,   144,
     160,    26,   155,   207,   159,    -1,   145,   160,    26,   155,
     207,   159,    -1,   143,   160,    26,   155,   207,   159,    -1,
      28,   102,   146,   160,    26,   155,   207,   159,    -1,    28,
      95,   146,   160,    26,   155,   207,   159,    -1,   154,    61,
      28,    26,    95,    26,    -1,   154,    28,    26,    95,    26,
      -1,   154,    61,    28,    54,   207,    -1,   154,    61,    28,
      54,   207,   160,   128,   159,    -1,   154,    28,    54,   207,
      -1,   154,    28,    54,   207,   160,   128,   159,    -1,    37,
      -1,    39,    -1,    38,    -1,    40,    -1,    41,    -1,    42,
      -1,    44,    -1,    47,    -1,    48,    -1,    49,    -1,    46,
      26,    -1,    45,    26,    -1,    54,   160,    26,   159,    -1,
      57,   160,    26,   159,    -1,    57,   160,    27,    68,    26,
     159,    -1,    54,   160,    27,    68,    26,   159,    -1,    50,
     207,    -1,    51,   207,    -1,   117,   160,    26,   159,    -1,
      54,   207,    -1,    55,   207,    -1,    56,   207,    -1,    57,
     207,    -1,    94,   160,    26,   155,    26,   159,    -1,    93,
     160,    26,   155,    26,   159,    -1,    26,    95,    67,    26,
     182,    -1,    26,    95,    60,    26,    -1,    26,    92,    26,
      -1,    26,    92,   207,    -1,    26,    86,    26,    -1,    26,
      91,    26,    -1,    26,    91,   207,    -1,    26,    86,   207,
      -1,   111,   161,    26,   162,    -1,   111,   161,    26,    81,
     162,    -1,   110,   161,    26,   162,    -1,   110,   161,    26,
      81,   162,    -1,   112,   161,    26,   162,    -1,   112,   161,
      26,    81,   162,    -1,   113,   161,    26,   162,    -1,   113,
     161,    26,    81,   162,    -1,   120,   161,    26,   196,   162,
      95,    26,    -1,   120,   161,    26,   193,   207,   162,    95,
      26,    -1,   121,   161,    26,   193,   207,   162,    95,    26,
      -1,   121,   161,    26,   196,   162,    95,    26,    -1,   121,
     161,    26,   196,   162,    95,    36,    -1,   161,    26,   193,
     207,   162,    95,    26,    -1,    26,    95,   121,   161,    26,
     193,   207,   162,   180,    -1,    36,    95,   121,   161,    26,
     196,   162,    -1,    26,    95,   121,   161,    26,   196,   162,
     180,    -1,    26,    95,   121,   161,    26,    81,    26,   162,
     180,    -1,    36,    95,   121,   161,    26,    81,    26,   162,
      -1,   161,    26,   196,   162,    95,    26,    -1,   161,    26,
      81,    26,   162,    95,    26,    -1,   121,   161,    26,    81,
      26,   162,    95,    36,    -1,    26,    95,   120,   161,    26,
     193,   207,   162,   180,    -1,    26,    95,   120,   161,    26,
     196,   162,   180,    -1,    26,    95,   161,    26,    81,    26,
     162,    -1,    26,    95,   161,    26,   193,   207,   162,    -1,
      26,    95,   161,    26,   196,   162,    -1,   161,    80,    26,
     162,    95,   160,    26,   157,   207,   155,    26,   157,   207,
     159,    -1,   161,    80,    26,   162,    95,   160,    26,   157,
     207,   159,    -1,   160,    26,   157,   207,   155,    26,   157,
     207,   159,    95,   161,    26,    81,   162,    -1,   160,    26,
     157,   207,   159,    95,   161,    26,    81,   162,    -1,   161,
      80,    26,   162,    95,    26,    -1,    24,   207,    -1,    25,
      -1,    52,   160,   207,   155,   207,   159,    26,    -1,    52,
     160,   207,   155,   207,   159,    26,    95,    26,    -1,    52,
     160,   207,   155,   207,   159,    26,    95,    26,    89,   207,
      -1,   151,    -1,   151,   172,    -1,   151,    26,    -1,   153,
     160,    26,   159,    -1,   150,    -1,   152,   160,    36,   155,
     207,   159,    -1,   149,   160,    26,   155,   207,   159,    -1,
     148,   160,    26,   155,   207,   159,    -1,    30,    -1,    31,
      -1,    -1,   160,   132,   155,   133,   159,    -1,   160,   133,
     155,   132,   159,    -1,   160,   133,   159,    -1,   160,   132,
     159,    -1,   160,   118,   159,    -1,   160,   119,   159,    -1,
      -1,   123,    -1,   124,    -1,   125,    -1,   118,    -1,   119,
      -1,    -1,   160,   175,   159,    -1,    -1,   160,   122,   159,
      -1,   160,   123,   159,    -1,    -1,   160,   176,   159,    -1,
     160,   175,   159,    -1,   160,   176,   155,   175,   159,    -1,
     160,   175,   155,   176,   159,    -1,    -1,   160,   131,   159,
      -1,   160,   130,   159,    -1,    -1,   160,   130,   159,    -1,
     160,   131,   159,    -1,    -1,   160,   122,   159,    -1,   160,
     123,   159,    -1,   160,   140,   159,    -1,   160,   140,   155,
     123,   159,    -1,   160,   123,   155,   140,   159,    -1,    -1,
     160,   140,   159,    -1,    -1,   160,   123,   159,    -1,   105,
      -1,   108,    -1,   107,    -1,   106,    -1,    -1,   160,   134,
     159,    -1,   160,   134,   159,    -1,   160,   133,   159,    -1,
     160,   133,   155,   134,   159,    -1,   160,   134,   155,   133,
     159,    -1,    13,    -1,    14,    -1,    15,    -1,    -1,   160,
     133,   159,    -1,    -1,   160,   133,   159,    -1,    72,    -1,
      73,    -1,    76,    -1,    77,    -1,    78,    -1,    79,    -1,
      68,    -1,    67,    -1,   160,   137,   159,    -1,   160,   126,
     159,    -1,   160,   136,   159,    -1,   160,   127,   159,    -1,
     160,   137,   155,   134,   159,    -1,   160,   126,   155,   134,
     159,    -1,   160,   136,   155,   134,   159,    -1,   160,   127,
     155,   134,   159,    -1,   160,   141,   159,    -1,   160,   142,
     159,    -1,   160,   141,   155,   134,   159,    -1,   160,   142,
     155,   134,   159,    -1,    -1,    81,    -1,    80,    -1,   172,
      95,    -1,   172,   100,    -1,   172,   101,    -1,    26,    95,
     172,    -1,   201,    -1,    26,    95,   160,   201,   159,    -1,
      36,    95,   160,   201,   159,    -1,    36,    95,   172,    -1,
     197,    36,    69,    36,    -1,   199,    36,    69,    36,    -1,
     198,    36,    69,    36,    -1,    36,    69,    36,    -1,    95,
      -1,    97,    -1,    99,    -1,    98,    -1,    28,   203,   163,
      -1,    28,   203,   140,    -1,   163,   203,    28,    -1,   140,
     203,    28,    -1,   165,    -1,   166,    -1,   205,    -1,   160,
     208,   159,    -1,    60,   208,    -1,    67,   208,    -1,   208,
      -1,   208,    69,   208,    -1,   208,    70,   208,    -1,   208,
      64,   208,    -1,   208,    68,   208,    -1,   208,    67,   208,
      -1,   208,    88,   208,    -1,   208,    89,   208,    -1,   208,
      62,   208,    -1,   208,    65,   208,    -1,   208,    63,   208,
      -1,   206,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const unsigned short yyrline[] =
{
       0,   586,   586,   586,   591,   593,   608,   620,   633,   638,
     660,   669,   703,   732,   745,   760,   776,   789,   801,   818,
     835,   850,   865,   882,   910,   933,   964,   989,  1000,  1015,
    1030,  1043,  1060,  1078,  1095,  1111,  1126,  1150,  1176,  1200,
    1212,  1223,  1239,  1254,  1269,  1284,  1299,  1314,  1329,  1361,
    1369,  1385,  1419,  1448,  1464,  1474,  1489,  1505,  1520,  1534,
    1549,  1564,  1580,  1591,  1617,  1627,  1642,  1657,  1695,  1705,
    1715,  1733,  1744,  1756,  1768,  1779,  1788,  1799,  1811,  1824,
    1844,  1854,  1860,  1870,  1880,  1889,  1899,  1926,  1956,  1987,
    2031,  2048,  2062,  2080,  2116,  2130,  2154,  2168,  2190,  2203,
    2216,  2229,  2245,  2258,  2272,  2288,  2301,  2314,  2351,  2366,
    2380,  2402,  2416,  2429,  2444,  2459,  2472,  2485,  2498,  2511,
    2523,  2536,  2549,  2563,  2576,  2589,  2602,  2622,  2634,  2645,
    2655,  2665,  2675,  2686,  2697,  2707,  2719,  2730,  2742,  2748,
    2754,  2760,  2766,  2772,  2778,  2784,  2790,  2796,  2802,  2812,
    2822,  2832,  2844,  2856,  2866,  2876,  2882,  2892,  2903,  2913,
    2926,  2938,  2947,  2957,  2979,  2989,  2999,  3009,  3020,  3030,
    3041,  3055,  3064,  3074,  3084,  3095,  3105,  3115,  3126,  3142,
    3153,  3168,  3186,  3196,  3212,  3263,  3280,  3295,  3305,  3315,
    3325,  3343,  3361,  3374,  3388,  3399,  3415,  3463,  3494,  3510,
    3529,  3543,  3562,  3583,  3592,  3602,  3612,  3623,  3638,  3645,
    3651,  3657,  3666,  3672,  3678,  3684,  3700,  3702,  3711,  3712,
    3714,  3716,  3718,  3723,  3725,  3730,  3731,  3733,  3735,  3740,
    3742,  3747,  3748,  3754,  3755,  3757,  3763,  3764,  3767,  3770,
    3773,  3778,  3779,  3781,  3786,  3787,  3789,  3794,  3795,  3797,
    3799,  3801,  3803,  3808,  3809,  3814,  3815,  3820,  3822,  3824,
    3826,  3832,  3833,  3838,  3840,  3843,  3846,  3854,  3856,  3858,
    3863,  3864,  3872,  3873,  3886,  3888,  3893,  3895,  3897,  3899,
    3904,  3906,  3911,  3918,  3925,  3932,  3939,  3946,  3953,  3960,
    3969,  3975,  3980,  3986,  3994,  3995,  3997,  4006,  4011,  4016,
    4021,  4028,  4035,  4041,  4047,  4056,  4060,  4064,  4071,  4082,
    4084,  4086,  4088,  4093,  4096,  4099,  4102,  4175,  4180,  4183,
    4185,  4187,  4189,  4203,  4207,  4209,  4211,  4213,  4215,  4217,
    4219,  4221,  4223,  4225,  4227
};
#endif

#if YYDEBUG || YYERROR_VERBOSE
/* YYTNME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals. */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "BYTEOP16P", "BYTEOP16M", "BYTEOP1P", 
  "BYTEOP2P", "BYTEOP2M", "BYTEOP3P", "BYTEUNPACK", "BYTEPACK", "PACK", 
  "SAA", "ALIGN8", "ALIGN16", "ALIGN24", "VIT_MAX", "EXTRACT", "DEPOSIT", 
  "EXPADJ", "SEARCH", "ONES", "SIGN", "SIGNBITS", "LINK", "UNLINK", "REG", 
  "PC", "CCREG", "BYTE_REG", "REG_A00", "REG_A11", "A_ZERO_DOT_L", 
  "A_ZERO_DOT_H", "A_ONE_DOT_L", "A_ONE_DOT_H", "HALF_REG", "NOP", "RTI", 
  "RTS", "RTX", "RTN", "RTE", "HLT", "IDLE", "STI", "CLI", "CSYNC", 
  "SSYNC", "EMUEXCPT", "RAISE", "EXCPT", "LSETUP", "DISALGNEXCPT", "JUMP", 
  "JUMP_DOT_S", "JUMP_DOT_L", "CALL", "ABORT", "NOT", "TILDA", "BANG", 
  "AMPERSAND", "BAR", "PERCENT", "CARET", "BXOR", "MINUS", "PLUS", "STAR", 
  "SLASH", "NEG", "MIN", "MAX", "ABS", "DOUBLE_BAR", "_PLUS_BAR_PLUS", 
  "_PLUS_BAR_MINUS", "_MINUS_BAR_PLUS", "_MINUS_BAR_MINUS", 
  "_MINUS_MINUS", "_PLUS_PLUS", "SHIFT", "LSHIFT", "ASHIFT", "BXORSHIFT", 
  "_GREATER_GREATER_GREATER_THAN_ASSIGN", "ROT", "LESS_LESS", 
  "GREATER_GREATER", "_GREATER_GREATER_GREATER", "_LESS_LESS_ASSIGN", 
  "_GREATER_GREATER_ASSIGN", "DIVS", "DIVQ", "ASSIGN", "_STAR_ASSIGN", 
  "_BAR_ASSIGN", "_CARET_ASSIGN", "_AMPERSAND_ASSIGN", "_MINUS_ASSIGN", 
  "_PLUS_ASSIGN", "_ASSIGN_BANG", "_LESS_THAN_ASSIGN", "_ASSIGN_ASSIGN", 
  "GE", "LT", "LE", "GT", "LESS_THAN", "FLUSHINV", "FLUSH", "IFLUSH", 
  "PREFETCH", "PRNT", "OUTC", "WHATREG", "TESTSET", "ASL", "ASR", "B", 
  "W", "NS", "S", "CO", "SCO", "TH", "TL", "BP", "BREV", "X", "Z", "M", 
  "MMOD", "R", "RND", "RNDL", "RNDH", "RND12", "RND20", "V", "LO", "HI", 
  "BITTGL", "BITCLR", "BITSET", "BITTST", "BITMUX", "DBGAL", "DBGAH", 
  "DBGHALT", "DBG", "DBGA", "DBGCMPLX", "IF", "COMMA", "BY", "COLON", 
  "SEMICOLON", "RPAREN", "LPAREN", "LBRACK", "RBRACK", 
  "MODIFIED_STATUS_REG", "MNOP", "SYMBOL", "NUMBER", "$accept", 
  "asm_or_directive", "@1", "asm", "asm_1", "REG_A", "opt_mode", 
  "asr_asl", "sco", "asr_asl_0", "amod0", "amod1", "amod2", "xpmod", 
  "xpmod1", "vsmod", "vmod", "smod", "searchmod", "aligndir", 
  "byteop_mod", "c_align", "w32_or_nothing", "iu_or_nothing", "min_max", 
  "op_bar_op", "plus_minus", "rnd_op", "b3_op", "post_op", "a_assign", 
  "a_minusassign", "a_plusassign", "assign_macfunc", "a_macfunc", 
  "multfunc", "cc_op", "ccstat", "symbol", "eterm", "expr", "expr_1", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const unsigned short yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,   346,   347,   348,   349,   350,   351,   352,   353,   354,
     355,   356,   357,   358,   359,   360,   361,   362,   363,   364,
     365,   366,   367,   368,   369,   370,   371,   372,   373,   374,
     375,   376,   377,   378,   379,   380,   381,   382,   383,   384,
     385,   386,   387,   388,   389,   390,   391,   392,   393,   394,
     395,   396,   397,   398,   399,   400,   401,   402,   403,   404,
     405,   406,   407,   408,   409,   410,   411,   412,   413,   414,
     415,   416,   417,   418,   419,   420,   421
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const unsigned char yyr1[] =
{
       0,   167,   169,   168,   170,   170,   170,   170,   170,   170,
     170,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   171,   171,   171,   171,
     171,   171,   171,   171,   171,   171,   172,   172,   173,   173,
     173,   173,   173,   174,   174,   175,   175,   175,   175,   176,
     176,   177,   177,   178,   178,   178,   179,   179,   179,   179,
     179,   180,   180,   180,   181,   181,   181,   182,   182,   182,
     182,   182,   182,   183,   183,   184,   184,   185,   185,   185,
     185,   186,   186,   187,   187,   187,   187,   188,   188,   188,
     189,   189,   190,   190,   191,   191,   192,   192,   192,   192,
     193,   193,   194,   194,   194,   194,   194,   194,   194,   194,
     195,   195,   195,   195,   196,   196,   196,   197,   198,   199,
     200,   200,   200,   200,   200,   201,   201,   201,   202,   203,
     203,   203,   203,   204,   204,   204,   204,   205,   206,   206,
     206,   206,   206,   207,   208,   208,   208,   208,   208,   208,
     208,   208,   208,   208,   208
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const unsigned char yyr2[] =
{
       0,     2,     0,     2,     2,     6,     6,     4,     2,     4,
       1,     2,     5,     1,     6,     6,     3,     3,    17,    17,
      11,    11,    11,    12,    12,    12,     5,     3,     3,     3,
       8,    13,    13,    13,    13,     8,    17,     6,     9,     3,
       6,     3,     5,     6,     8,     8,     2,     2,     4,     3,
       2,     4,     3,     6,     4,     7,     7,     3,     3,     6,
       3,     4,     3,     3,     3,    11,    11,     9,     5,     5,
       9,     5,     5,     6,     6,     5,     5,     5,     6,     6,
       5,     1,     3,     3,     3,     3,     4,     4,     9,     9,
       5,     7,     4,     6,     6,     7,     9,     8,     8,    11,
       9,     4,     5,     6,     7,     6,     4,     6,     5,     6,
       6,     4,     8,    10,    10,    12,     5,     6,     5,     6,
       4,     4,     4,     7,     9,     9,     9,     6,     6,     6,
       8,     8,     6,     5,     5,     8,     4,     7,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     2,     2,
       4,     4,     6,     6,     2,     2,     4,     2,     2,     2,
       2,     6,     6,     5,     4,     3,     3,     3,     3,     3,
       3,     4,     5,     4,     5,     4,     5,     4,     5,     7,
       8,     8,     7,     7,     7,     9,     7,     8,     9,     8,
       6,     7,     8,     9,     8,     7,     7,     6,    14,    10,
      14,    10,     6,     2,     1,     7,     9,    11,     1,     2,
       2,     4,     1,     6,     6,     6,     1,     1,     0,     5,
       5,     3,     3,     3,     3,     0,     1,     1,     1,     1,
       1,     0,     3,     0,     3,     3,     0,     3,     3,     5,
       5,     0,     3,     3,     0,     3,     3,     0,     3,     3,
       3,     5,     5,     0,     3,     0,     3,     1,     1,     1,
       1,     0,     3,     3,     3,     5,     5,     1,     1,     1,
       0,     3,     0,     3,     1,     1,     1,     1,     1,     1,
       1,     1,     3,     3,     3,     3,     5,     5,     5,     5,
       3,     3,     5,     5,     0,     1,     1,     2,     2,     2,
       3,     1,     5,     5,     3,     4,     4,     4,     3,     1,
       1,     1,     1,     3,     3,     3,     3,     1,     1,     1,
       3,     2,     2,     1,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const unsigned short yydefact[] =
{
       2,     0,     0,     1,    10,     0,     0,   204,     0,     0,
     216,   217,     0,     0,     0,     0,     0,   138,   140,   139,
     141,   142,   143,   144,     0,     0,   145,   146,   147,     0,
       0,     0,    13,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   212,   208,     0,     0,     0,     0,     0,
       0,     0,     3,     0,     0,     0,     0,     0,   218,   301,
      81,     0,     0,     0,     0,   317,   318,   319,   334,   203,
     323,     0,     0,     0,     0,     0,     0,     0,   309,   310,
     312,   311,     0,     0,     0,     0,     0,     0,     0,   149,
     148,   154,   155,     0,     0,   157,   158,   159,     0,   160,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   309,
       0,     0,     0,     0,     0,     0,     0,   210,   209,     0,
       0,     0,     0,     0,   294,     0,     0,     0,     8,     0,
       4,   297,   298,   299,    47,     0,     0,     0,     0,     0,
       0,     0,    46,     0,    50,     0,   270,     0,     0,    11,
       0,   321,   322,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   167,   170,   168,   169,   165,   166,
       0,     0,     0,     0,     0,     0,   267,   268,   269,     0,
       0,     0,    82,    84,   241,     0,   241,     0,     0,   274,
     275,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     300,     0,     0,   218,   244,    64,    60,    58,    62,    63,
      83,     0,     0,    85,     0,   314,   313,    28,    16,    29,
      17,     0,     0,     0,     0,    52,     0,     0,     0,     0,
       0,     0,   304,   218,    49,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   294,   294,   316,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   281,   280,   296,   295,     0,     0,     0,
     315,     0,     0,   270,     0,    39,    27,     0,     0,     0,
       0,     0,     0,     0,     0,    41,     0,     0,    57,     0,
       0,     0,     0,     0,   320,   331,   333,   326,   332,   328,
     327,   324,   325,   329,   330,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   280,   276,   277,
     278,   279,     0,     0,     0,     0,     0,     0,    54,     0,
       0,    48,   164,   247,   253,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   294,     0,     0,
       0,    87,     0,    51,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   111,   121,   122,   120,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    86,     0,   150,     0,   151,     0,     0,     0,
       0,   173,     0,   171,     0,   175,     0,   177,   156,   295,
       0,     0,   295,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   211,     0,   136,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     7,     0,     9,    61,   305,     0,
       0,     0,     0,     0,     0,    92,   106,   101,     0,   307,
       0,   306,     0,   222,     0,   221,     0,     0,   218,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    80,
      68,    69,     0,   247,   253,   247,   231,   233,     0,     0,
       0,   308,     0,   163,     0,    26,     0,     0,     0,     0,
     294,   294,     0,   299,     0,   302,   295,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   272,   272,    75,    76,
     272,   272,     0,    77,    71,    72,     0,     0,     0,     0,
       0,     0,     0,     0,   255,   108,   255,     0,   233,     0,
       0,   294,     0,   303,     0,     0,     0,     0,     0,     0,
     174,   172,   176,   178,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   133,     0,     0,   134,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   102,    90,     0,   116,   118,    42,   271,     0,
       0,     0,     0,    12,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    93,   107,   110,     0,   225,
      53,     0,     0,    37,   243,   242,     0,     0,     0,     0,
       0,   105,   253,   247,   117,   119,     0,     0,   295,     0,
       0,     0,    14,     0,     0,   197,     0,     0,     0,     0,
     245,   246,    59,     0,    78,    79,    73,    74,     0,     0,
       0,     0,     0,    43,     0,     0,     0,     0,    94,   109,
       0,    40,   103,   255,   295,     0,    15,     0,     0,   153,
     152,   162,   161,     0,     0,     0,     0,     0,   129,   127,
     128,     0,   215,   214,   213,     0,   132,     0,     0,     0,
       0,     0,     0,   190,   202,     0,     6,     5,     0,     0,
       0,     0,   219,   220,     0,   300,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   226,
     227,   228,     0,     0,     0,     0,     0,   248,     0,   249,
       0,   250,   254,   104,    95,     0,   241,     0,     0,   241,
       0,   195,   196,     0,     0,     0,     0,     0,     0,     0,
       0,   123,     0,     0,     0,     0,     0,     0,     0,     0,
      91,     0,   186,     0,   205,     0,   179,     0,     0,   182,
     183,     0,   137,     0,     0,     0,     0,     0,     0,     0,
     191,   184,     0,    56,    55,     0,     0,     0,     0,     0,
       0,     0,    35,   112,     0,   241,    98,     0,     0,   232,
       0,   234,   235,     0,     0,     0,   241,   194,   241,   241,
     187,     0,     0,    30,   253,     0,   218,   273,   131,   130,
       0,     0,   253,    97,    44,    45,     0,     0,   256,     0,
     189,   218,     0,   180,   192,   181,     0,   135,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   124,   100,     0,    70,     0,     0,     0,   252,
     251,   193,   188,   185,    67,     0,    38,    89,   223,   224,
      96,     0,     0,     0,     0,    88,   206,   125,     0,     0,
       0,     0,     0,     0,     0,   126,     0,   261,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   114,     0,   113,
       0,     0,     0,     0,   261,   257,   260,   259,   258,     0,
       0,   201,     0,   199,     0,     0,    65,     0,     0,     0,
       0,    99,   236,   233,    22,   233,     0,     0,   207,     0,
       0,    20,    21,     0,     0,    66,     0,     0,     0,     0,
       0,   225,    25,    24,    23,   115,     0,     0,     0,     0,
       0,   262,     0,    31,     0,    32,    33,     0,    34,   229,
     230,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   238,   225,   237,
       0,     0,     0,   200,   198,     0,   264,     0,   263,     0,
     283,     0,   285,     0,   284,     0,   282,     0,   290,     0,
     291,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   240,   239,     0,   261,   261,   265,
     266,   287,   289,   288,   286,   292,   293,    36,    18,    19
};

/* YYDEFGOTO[NTERM-NUM]. */
static const short yydefgoto[] =
{
      -1,     1,     2,    62,    63,    64,   159,   741,   712,   952,
     600,   603,   932,   338,   363,   483,   485,   648,   899,   906,
     943,   211,   298,   634,   212,   335,   277,   945,   948,   278,
      65,    66,    67,    68,    69,   213,    93,    70,    77,    78,
      79,    80
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -865
static const short yypact[] =
{
    -865,    47,   482,  -865,  -865,  -110,   -35,  -865,   327,   484,
    -865,  -865,     6,    57,    79,   108,   115,  -865,  -865,  -865,
    -865,  -865,  -865,  -865,    88,   111,  -865,  -865,  -865,   -35,
     -35,     8,  -865,   239,   -35,   -35,   385,    52,    62,    31,
      74,    84,    96,    99,   105,   118,   584,   116,   125,   133,
     147,   149,   165,  -865,   194,   184,   187,    32,   341,    15,
     584,   -31,  -865,   -26,   245,    61,   454,   336,   215,  -865,
    -865,   352,   -35,   -35,   -35,  -865,  -865,  -865,  -865,  -865,
     668,    42,    51,    73,   693,   354,   208,   211,    -3,  -865,
    -865,  -865,    -8,   -44,   347,   367,   376,   395,   163,  -865,
    -865,  -865,  -865,   -35,    53,  -865,  -865,  -865,   123,  -865,
     410,   413,   416,   418,   427,   429,   451,   456,   463,  -865,
     393,   476,   499,   520,   552,   554,   565,  -865,  -865,   475,
     581,    11,   589,    97,   161,   597,   613,   843,  -865,   843,
    -865,  -865,  -865,   431,  -865,   471,   291,   431,   431,   431,
     452,   431,   192,   -35,  -865,   582,   498,   604,   337,   536,
     510,  -865,  -865,   411,   -35,   -35,   -35,   -35,   -35,   -35,
     -35,   -35,   -35,   -35,  -865,  -865,  -865,  -865,  -865,  -865,
     542,   545,   568,   574,   580,   595,  -865,  -865,  -865,   614,
     618,   619,   598,  -865,   625,   646,   -34,   251,   260,  -865,
    -865,   733,   747,   760,   761,   762,   628,   629,    40,   765,
     724,   633,   634,   215,   635,  -865,  -865,  -865,   636,  -865,
     191,   637,   400,  -865,   638,  -865,  -865,  -865,  -865,  -865,
    -865,   639,   641,   776,   266,   -37,   708,   398,   768,   770,
     647,   291,  -865,   215,  -865,   652,   651,   741,   653,   743,
     660,   661,   -52,   -47,   -33,     3,   658,   281,   289,  -865,
     663,   664,   665,   666,   667,   669,   670,   671,   728,   -35,
      19,   801,   -35,  -865,  -865,  -865,   802,   -35,   672,   673,
    -865,   -24,   -19,   498,   793,   677,   678,   675,   680,   431,
     681,   -35,   -35,   -35,   715,  -865,   803,   709,  -865,   807,
     114,   175,   541,   -35,  -865,   496,   682,  -865,   485,   332,
     332,  -865,  -865,   551,   551,   818,   819,   820,   821,   822,
     824,   830,   831,   835,   839,   840,   844,   712,  -865,  -865,
    -865,  -865,   -35,   -35,   -35,   860,   875,   361,  -865,   867,
     868,  -865,  -865,   745,   746,   751,   752,   753,   756,   877,
     887,   846,   549,   879,   880,   512,   758,   366,   431,   892,
     893,   766,   438,  -865,   791,   264,   272,   275,   896,   431,
     431,   431,   897,   898,    80,  -865,  -865,  -865,  -865,   790,
     900,    81,   -35,   -35,   -35,   905,   894,   772,   773,   906,
     512,   774,   779,   -35,  -865,   909,  -865,   912,   913,   914,
     769,  -865,   782,  -865,   783,  -865,   784,  -865,  -865,  -865,
     -35,   785,   915,   -35,   786,   -35,   -35,   -35,   923,   -35,
     -35,   -35,  -865,   924,   792,   856,   -35,   798,   204,   796,
     797,   866,   870,   843,  -865,   843,  -865,  -865,  -865,   431,
     431,   926,   930,   812,   200,  -865,  -865,  -865,   809,  -865,
     810,  -865,   837,  -865,   841,  -865,   876,   881,   215,   817,
     823,   825,   827,   828,   826,   834,   845,   847,   850,  -865,
    -865,  -865,   948,   745,   746,   745,    25,    89,   816,   842,
     852,  -865,    55,  -865,   838,  -865,   941,   943,   962,   283,
     281,   391,   973,  -865,   849,  -865,   983,   -35,   848,   857,
     858,   859,   985,   861,   862,   863,   855,   855,  -865,  -865,
     855,   855,   864,  -865,  -865,  -865,   869,   871,   872,   873,
     874,   865,   878,   882,   883,  -865,   883,   884,   885,   980,
     981,   481,   888,  -865,   982,   889,   890,   891,   895,   899,
    -865,  -865,  -865,  -865,   901,   928,   902,   903,   931,   907,
     908,   910,   886,   911,   916,   917,  -865,   904,  1003,   918,
     936,  1008,   940,   942,   944,  1010,    -7,   919,   921,   945,
     979,   977,  -865,  -865,   431,  -865,  -865,   925,  -865,   922,
     927,    -9,     9,  -865,  1026,   -35,   -35,   -35,   -35,  1027,
    1019,  1030,  1021,  1033,   972,  -865,  -865,  -865,  1035,   514,
    -865,  1036,   466,  -865,  -865,  -865,  1042,   929,   230,   295,
     932,  -865,   746,   745,  -865,  -865,   -35,   920,  1045,   -35,
     933,   934,  -865,   935,   937,  -865,  1046,  1047,  1048,   988,
    -865,  -865,  -865,   951,  -865,  -865,  -865,  -865,   -35,   -35,
     938,  1049,  1051,  -865,   458,   431,   431,   966,  -865,  -865,
    1054,  -865,  -865,   883,  1066,   939,  -865,   999,  1070,  -865,
    -865,  -865,  -865,  1005,  1076,  1009,  1011,   178,  -865,  -865,
    -865,   431,  -865,  -865,  -865,   946,  -865,   975,   252,   950,
     947,  1083,  1084,  -865,  -865,  1085,  -865,  -865,   431,   431,
     957,   431,  -865,  -865,   431,  -865,   431,   956,   959,   960,
     961,   963,   958,   964,   965,   967,   968,   -35,  1024,  -865,
    -865,  -865,   969,  1025,   970,   971,  1037,  -865,   991,  -865,
     998,  -865,  -865,  -865,  -865,   974,   625,   976,   978,   625,
    1034,  -865,  -865,  1038,   984,   986,  1089,   987,   989,   990,
     607,  -865,   992,   993,   994,   995,  1000,  1001,  1002,  1004,
    -865,   996,  -865,  1089,  1039,  1109,  -865,  1101,  1113,  -865,
    -865,  1006,  -865,  1007,   997,  1012,  1115,  1116,   -35,  1118,
    -865,  -865,  1013,  -865,  -865,  1119,   431,   -35,  1124,  1133,
    1134,  1136,  -865,  -865,   938,   625,  1014,  1016,  1138,  -865,
    1141,  -865,  -865,  1137,  1017,  1018,   625,  -865,   625,   625,
    -865,   -35,   431,  -865,   746,  1099,   215,  -865,  -865,  -865,
    1020,  1022,   746,  -865,  -865,  -865,   286,  1145,  -865,  1104,
    -865,   215,  1152,  -865,  -865,  -865,   938,  -865,  1154,  1156,
    1028,  1023,  1029,  1103,   -35,  1031,  1032,  1040,  1041,  1043,
    1044,  1050,  -865,  -865,  1056,  -865,   685,   588,  1121,  -865,
    -865,  -865,  -865,  -865,  -865,  1120,  -865,  -865,  -865,  -865,
    -865,  1052,  1053,  1055,  1155,  -865,  1105,  -865,  1058,  1059,
     -35,   676,  1098,  1057,   346,  -865,  1072,  1060,   -35,   -35,
     -35,   -35,  1062,  1170,  1171,  1169,   431,  -865,  1175,  -865,
    1142,   -35,   -35,   -35,  1060,  -865,  -865,  -865,  -865,  1063,
    1064,  -865,  1178,  -865,  1065,  1071,  -865,  1067,  1068,  1069,
    1073,  -865,  1074,   885,  -865,   885,  1077,  1184,  -865,  1075,
    1078,  -865,  -865,  1183,  1061,  -865,  1079,  1080,  1081,  1081,
    1082,   529,  -865,  -865,  -865,  -865,  1086,  1186,  1187,  1148,
     -35,  -865,   583,  -865,   -51,  -865,  -865,   601,  -865,  -865,
    -865,   449,   469,  1181,  1087,  1088,  1090,  1091,   513,   525,
     530,   535,   537,   538,   586,   599,   650,  -865,   514,  -865,
    1092,   -35,   -35,  -865,  -865,  1097,  -865,  1102,  -865,  1114,
    -865,  1122,  -865,  1123,  -865,  1125,  -865,  1126,  -865,  1127,
    -865,  1094,  1095,  1168,  1096,  1106,  1107,  1108,  1110,  1111,
    1112,  1117,  1128,  1129,  -865,  -865,  1203,  1060,  1060,  -865,
    -865,  -865,  -865,  -865,  -865,  -865,  -865,  -865,  -865,  -865
};

/* YYPGOTO[NTERM-NUM].  */
static const short yypgoto[] =
{
    -865,  -865,  -865,  -865,  -125,    24,  -205,  -738,  -864,   257,
    -865,  -515,  -865,  -185,  -865,  -449,  -471,  -511,  -865,  -811,
    -865,  -865,  1015,  -101,  -865,   397,  -176,   318,  -865,  -240,
     -32,  -199,  -136,  1093,  -198,   -96,   155,  -865,  -865,  -865,
     -29,   -10
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const unsigned short yytable[] =
{
     101,   102,   243,   596,   105,   106,   107,   109,   361,   354,
     356,   341,   281,   651,   282,   649,   336,   411,   414,   684,
     223,    10,    11,   220,   595,    72,   597,    10,    11,   400,
     273,   274,    73,   153,   402,   340,   154,   268,   392,    10,
      11,   134,   354,   391,   137,   425,   842,     3,   404,   139,
      71,   433,   175,   177,   179,   214,   435,   217,   219,   380,
     131,   386,   161,   162,   163,   269,   351,   951,   174,   244,
      10,    11,   355,   426,   245,   960,   961,   176,   128,   246,
     247,   410,   413,   921,   406,   962,   963,   144,   867,   152,
     156,    10,    11,   132,   163,   135,   225,   145,   163,   178,
      72,    94,    72,   354,   992,   390,   518,    73,   210,    73,
     401,    72,   222,    72,    99,   403,   519,   498,    73,   226,
      73,    72,   242,   379,   295,    74,   337,   138,   146,   405,
      75,    76,   140,    72,   434,   147,   162,   100,   224,   436,
      73,   723,   750,   221,   148,   149,   150,   522,   151,   248,
     249,   694,    95,   685,   305,   306,   307,   308,   309,   310,
     311,   312,   313,   314,   724,   407,   523,   283,   103,   696,
     285,   286,   287,   288,    96,   290,   353,   607,   608,   231,
     598,   497,   232,    72,   233,   599,   234,   161,   162,   235,
      73,   236,   112,    10,    11,   609,  1018,  1019,   163,   237,
      74,   120,    74,    97,   759,    75,    76,    75,    76,   353,
      98,    74,   110,    74,   760,   136,    75,    76,    75,    76,
     127,    74,   111,    72,    10,    11,    75,    76,   273,   274,
      73,   163,   352,    74,   216,   113,   575,   218,    75,    76,
     424,   275,   276,   428,   601,   114,   238,   239,   430,   602,
     617,   620,   271,   583,   272,   764,   765,   115,   378,   116,
      72,   766,   445,   446,   447,   352,   117,    73,    72,   452,
     353,    72,   767,   453,   459,    73,   121,   342,    73,   118,
     291,   292,   293,    74,   240,   122,   343,   141,    75,    76,
     506,   655,   376,   123,   365,   366,    10,    11,   508,    72,
     367,   510,   377,   473,   474,   475,    73,   124,   567,   125,
     568,    72,   861,   443,   616,   619,    10,    11,    73,   614,
      72,    10,    11,   241,    72,   126,   352,    73,    75,    76,
     454,    73,    72,   856,   455,    72,   507,   509,   511,    73,
     141,   860,    73,    72,   129,   142,   143,   130,   273,   274,
      73,    72,   294,   524,   525,   526,   273,   274,    73,   561,
      74,   275,   409,   562,   535,    75,    76,   133,    74,   275,
     412,    74,   157,    75,    76,   158,    75,    76,   160,   494,
     215,   544,   499,   227,   547,   718,   549,   550,   551,   719,
     553,   554,   555,   513,   514,   515,   166,   559,   933,   104,
     934,   170,   171,   228,    75,    76,   635,   570,   571,   636,
     637,    74,   229,    81,   532,   576,    75,    76,    82,    83,
      74,   259,    84,    85,    74,    75,    76,    86,    87,    75,
      76,   230,    74,   273,   274,    74,   250,    75,    76,   251,
      75,    76,   252,    74,   253,    72,   275,   496,    75,    76,
     720,    74,    73,   254,   721,   255,    75,    76,   273,   274,
     615,    10,    11,   569,   569,   273,   274,   340,   624,   300,
     301,   275,   618,   164,   165,   166,   167,   256,   168,   169,
     170,   171,   257,     4,    10,    11,   382,   383,   384,   258,
     155,   478,   479,   385,     5,   354,   356,   354,   391,   172,
     173,   902,   260,   369,   370,   903,     6,     7,     8,   371,
       9,   266,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,    21,    22,   261,    23,    24,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
     284,   797,    10,    11,   800,   108,   262,   164,   157,   166,
      75,    76,   168,   169,   170,   171,   698,   699,   700,   701,
     166,   275,   654,   168,   169,   170,   171,   456,   503,   504,
     304,    10,    11,   172,   173,    37,    38,   457,   263,    88,
     264,    89,    90,    91,   172,   173,    92,   725,   714,   715,
     728,   265,    39,    40,    41,    42,   744,   745,   690,    43,
     843,   857,    44,    45,   966,   695,   242,   267,   967,   738,
     739,   851,   289,   852,   853,   166,   865,   270,   168,   169,
     170,   171,    46,   279,   968,    47,    48,    49,   969,    50,
      51,    52,    53,    54,    55,    56,    57,   709,   710,   711,
     806,   280,    58,    59,   141,    60,    61,   949,   950,   142,
     493,   296,   709,   710,   711,   273,   274,   821,   297,   776,
     324,   325,   353,   326,   353,   273,   327,   303,   975,   746,
     747,   884,   976,   299,   328,   329,   330,   331,   787,   119,
     977,    89,    90,    91,   978,   979,   332,   333,   334,   980,
     981,   302,   983,   985,   982,   761,   984,   986,   180,   181,
     182,   183,   315,   184,   185,   316,   186,   187,   188,   189,
     190,   191,   773,   774,   339,   569,   958,   959,   352,   192,
     352,   193,   194,    10,    11,   810,   811,   195,   317,   196,
     164,   165,   166,   167,   318,   168,   169,   170,   171,   832,
     319,   987,   964,   965,   164,   988,   166,   167,   837,   168,
     169,   170,   171,   197,   989,   320,   172,   173,   990,   344,
     198,   328,   329,   330,   331,   199,   200,   201,   949,   950,
     172,   173,   854,   345,   321,   202,   203,   204,   322,   323,
     205,   895,   896,   897,   898,   337,   346,   347,   348,   349,
     350,   357,   358,   359,   360,   362,   364,   368,   372,   373,
     836,   374,   375,   381,   387,   874,   388,   393,   389,   395,
     394,   397,   396,   206,   207,   398,   399,   408,   415,   416,
     417,   418,   419,   423,   420,   421,   855,   427,   429,   438,
     422,   441,   439,   440,   431,   432,   442,   444,   448,   449,
     862,   894,   450,   451,   460,   461,   462,   463,   464,   907,
     908,   909,   910,   208,   209,     5,   466,   467,    75,    76,
     465,   468,   918,   919,   920,   469,   470,     6,     7,     8,
     471,     9,   472,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,    21,    22,   476,    23,    24,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,   477,   480,   490,   481,   482,   484,   486,   487,   488,
     915,   957,   489,   491,   492,   145,   155,   495,   500,   501,
     505,   502,   512,   516,   517,   520,   521,   527,   529,   530,
     528,   540,   531,   533,   534,   536,    37,    38,   537,   538,
     539,   546,   994,   995,   541,   542,   543,   545,   548,   552,
     556,   558,   557,    39,    40,    41,    42,   560,   563,   564,
      43,   565,   572,    44,    45,   566,   573,   574,   577,   578,
     579,   581,   584,   580,   594,   604,   582,   611,   610,   612,
     585,   589,   586,    46,   587,   588,    47,    48,    49,   590,
      50,    51,    52,    53,    54,    55,    56,    57,   613,   621,
     591,   605,   592,    58,    59,   593,    60,   606,   622,   623,
     625,   629,   626,   627,   628,   633,   652,   653,   657,   638,
     630,   631,   632,   664,   639,   644,   667,   641,   642,   676,
     640,   678,   675,   643,   679,   680,   683,   681,   645,   682,
     141,   671,   646,   647,   650,   602,   688,   656,   658,   659,
     660,   689,   697,   702,   661,   703,   704,   705,   662,   706,
     707,   708,   713,   663,   665,   666,   668,   669,   716,   670,
     672,   727,   733,   734,   735,   673,   674,   686,   677,   687,
     691,   692,   726,   736,   737,   742,   693,   743,   717,   748,
     749,   722,   751,   730,   753,   729,   754,   731,   740,   732,
     755,   752,   756,   763,   757,   762,   758,   768,   769,   770,
     771,   772,   775,   777,   778,   779,   780,   782,   781,   788,
     790,   795,   801,   783,   784,   805,   785,   786,   789,   791,
     792,   794,   793,   802,   822,   823,   796,   824,   798,   825,
     799,   830,   831,   803,   833,   804,   807,   835,   808,   809,
     838,   812,   813,   814,   815,   816,   817,   828,   820,   839,
     840,   818,   841,   819,   846,   826,   827,   847,   340,   848,
     834,   863,   829,   864,   844,   845,   849,   850,   866,   858,
     868,   859,   869,   871,   873,   870,   882,   886,   872,   885,
     875,   890,   876,   900,   891,   904,   912,   913,   878,   877,
     879,   880,   914,   916,   924,   926,   936,   881,   888,   939,
     917,   887,   954,   955,   889,   892,   893,   970,   940,   901,
     905,   911,   922,   991,   925,   923,   927,   928,   929,   956,
     937,   996,   930,   938,   931,   997,   935,  1006,   941,  1017,
     942,   944,   947,   883,   971,   972,   953,   946,   998,     0,
     974,   993,   973,  1004,  1005,  1007,   999,  1000,     0,  1001,
    1002,  1003,     0,     0,     0,  1008,  1009,  1010,     0,  1011,
    1012,  1013,     0,     0,     0,     0,  1014,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,  1015,  1016,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   437,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   458
};

static const short yycheck[] =
{
      29,    30,    98,   474,    33,    34,    35,    36,   213,   208,
     208,   196,   137,   528,   139,   526,   192,   257,   258,    26,
      28,    30,    31,    26,   473,    60,   475,    30,    31,    81,
      67,    68,    67,    65,    81,    69,    65,    26,   243,    30,
      31,    26,   241,   241,    75,    26,   784,     0,    81,    75,
     160,    75,    81,    82,    83,    84,    75,    86,    87,   235,
      28,   237,    72,    73,    74,    54,    26,   931,    26,    98,
      30,    31,   208,    54,   103,   126,   127,    26,    54,    26,
      27,   257,   258,   894,    81,   136,   137,    26,   826,    65,
      66,    30,    31,    61,   104,    80,   140,    36,   108,    26,
      60,    95,    60,   302,   968,   241,    26,    67,    84,    67,
     162,    60,    88,    60,    26,   162,    36,   357,    67,   163,
      67,    60,    98,   160,   153,   160,   160,   158,    67,   162,
     165,   166,   158,    60,   158,    74,   146,    26,   146,   158,
      67,   612,   653,   146,    83,    84,    85,    66,    87,    26,
      27,   160,    95,   160,   164,   165,   166,   167,   168,   169,
     170,   171,   172,   173,   613,   162,    85,   143,   160,   160,
     146,   147,   148,   149,    95,   151,   208,   122,   123,    16,
     155,   357,    19,    60,    21,   160,    23,   197,   198,    26,
      67,    28,   161,    30,    31,   140,  1007,  1008,   208,    36,
     160,    46,   160,    95,    26,   165,   166,   165,   166,   241,
      95,   160,   160,   160,    36,    60,   165,   166,   165,   166,
      26,   160,   160,    60,    30,    31,   165,   166,    67,    68,
      67,   241,   208,   160,    26,   161,    36,    26,   165,   166,
     269,    80,    81,   272,   155,   161,    83,    84,   277,   160,
     490,   491,   155,   458,   157,     3,     4,   161,   234,   160,
      60,     9,   291,   292,   293,   241,   161,    67,    60,   155,
     302,    60,    20,   159,   303,    67,   160,    26,    67,   161,
      88,    89,    90,   160,   121,   160,    26,    95,   165,   166,
      26,   531,    26,   160,   103,   104,    30,    31,    26,    60,
     109,    26,    36,   332,   333,   334,    67,   160,   433,   160,
     435,    60,    26,   289,   490,   491,    30,    31,    67,    36,
      60,    30,    31,   160,    60,   160,   302,    67,   165,   166,
     155,    67,    60,   804,   159,    60,   365,   366,   367,    67,
      95,   812,    67,    60,   160,   100,   101,   160,    67,    68,
      67,    60,   160,   382,   383,   384,    67,    68,    67,   155,
     160,    80,    81,   159,   393,   165,   166,    26,   160,    80,
      81,   160,    36,   165,   166,   160,   165,   166,    26,   355,
      26,   410,   358,    36,   413,   155,   415,   416,   417,   159,
     419,   420,   421,   369,   370,   371,    64,   426,   913,   160,
     915,    69,    70,    36,   165,   166,   507,   439,   440,   510,
     511,   160,    36,    86,   390,   444,   165,   166,    91,    92,
     160,    28,    95,    96,   160,   165,   166,   100,   101,   165,
     166,    36,   160,    67,    68,   160,    26,   165,   166,    26,
     165,   166,    26,   160,    26,    60,    80,    81,   165,   166,
     155,   160,    67,    26,   159,    26,   165,   166,    67,    68,
     489,    30,    31,   439,   440,    67,    68,    69,   497,   132,
     133,    80,    81,    62,    63,    64,    65,    26,    67,    68,
      69,    70,    26,     1,    30,    31,    88,    89,    90,    26,
      36,   130,   131,    95,    12,   694,   694,   696,   696,    88,
      89,   155,    26,   103,   104,   159,    24,    25,    26,   109,
      28,    36,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    26,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      69,   726,    30,    31,   729,   160,    26,    62,    36,    64,
     165,   166,    67,    68,    69,    70,   585,   586,   587,   588,
      64,    80,    81,    67,    68,    69,    70,    26,   130,   131,
     159,    30,    31,    88,    89,    93,    94,    36,    26,    95,
      26,    97,    98,    99,    88,    89,   102,   616,   122,   123,
     619,    26,   110,   111,   112,   113,   138,   139,   574,   117,
     785,   806,   120,   121,   155,   581,   582,    26,   159,   638,
     639,   796,   160,   798,   799,    64,   821,    28,    67,    68,
      69,    70,   140,    26,   155,   143,   144,   145,   159,   147,
     148,   149,   150,   151,   152,   153,   154,   123,   124,   125,
     736,    28,   160,   161,    95,   163,   164,   118,   119,   100,
     101,    69,   123,   124,   125,    67,    68,   753,   160,   691,
      62,    63,   694,    65,   696,    67,    68,   157,   155,   645,
     646,   847,   159,    69,    76,    77,    78,    79,   707,    95,
     155,    97,    98,    99,   159,   155,    88,    89,    90,   159,
     155,   155,   155,   155,   159,   671,   159,   159,     5,     6,
       7,     8,   160,    10,    11,   160,    13,    14,    15,    16,
      17,    18,   688,   689,    68,   691,   133,   134,   694,    26,
     696,    28,    29,    30,    31,   118,   119,    34,   160,    36,
      62,    63,    64,    65,   160,    67,    68,    69,    70,   768,
     160,   155,   141,   142,    62,   159,    64,    65,   777,    67,
      68,    69,    70,    60,   155,   160,    88,    89,   159,    26,
      67,    76,    77,    78,    79,    72,    73,    74,   118,   119,
      88,    89,   801,    26,   160,    82,    83,    84,   160,   160,
      87,   105,   106,   107,   108,   160,    26,    26,    26,   161,
     161,    26,    68,   160,   160,   160,   160,   160,   160,   160,
     776,   160,    26,    95,    36,   834,    36,   155,   161,    68,
     159,    68,   159,   120,   121,   155,   155,   159,   155,   155,
     155,   155,   155,    95,   155,   155,   802,    26,    26,    36,
     159,   156,   155,   155,   162,   162,   156,   156,   123,    36,
     816,   870,   133,    36,    26,    26,    26,    26,    26,   878,
     879,   880,   881,   160,   161,    12,    26,    26,   165,   166,
      36,    26,   891,   892,   893,    26,    26,    24,    25,    26,
      26,    28,   160,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    26,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,    55,    56,
      57,    26,    35,    26,    36,   160,   160,   156,   156,   156,
     886,   940,   156,    26,    68,    36,    36,   159,    26,    26,
     129,   155,    26,    26,    26,   135,    26,    22,   156,   156,
      36,   162,    26,   159,   155,    26,    93,    94,    26,    26,
      26,    26,   971,   972,   162,   162,   162,   162,   162,    26,
      26,    95,   160,   110,   111,   112,   113,   159,   162,   162,
     117,    95,    36,   120,   121,    95,    36,   155,   159,   159,
     133,    95,   155,   132,    26,   159,    95,    36,   140,    36,
     157,   155,   157,   140,   157,   157,   143,   144,   145,   155,
     147,   148,   149,   150,   151,   152,   153,   154,    36,    26,
     155,   159,   155,   160,   161,   155,   163,   155,   159,    26,
     162,    26,   155,   155,   155,   160,    36,    36,    36,   155,
     159,   159,   159,    95,   155,   160,    95,   155,   155,    26,
     159,    95,   128,   159,    26,    95,    26,    95,   160,    95,
      95,   155,   160,   160,   160,   160,    67,   159,   159,   159,
     159,    74,    26,    26,   159,    36,    26,    36,   159,    26,
      88,    26,    26,   162,   162,   162,   159,   159,    26,   159,
     159,    26,    26,    26,    26,   159,   159,   158,   160,   158,
     155,   159,   162,    95,   133,    36,   159,    36,   159,   123,
      36,   159,    26,   159,    95,   162,    26,   162,   160,   162,
      95,   162,    26,   128,    95,   159,    95,   157,   161,    26,
      26,    26,   155,   157,   155,   155,   155,   159,   155,    95,
      95,   123,    88,   159,   159,    36,   159,   159,   159,   159,
     159,   140,    95,    95,    95,    26,   162,    36,   162,    26,
     162,    26,    26,   159,    26,   159,   159,    28,   159,   159,
      26,   159,   159,   159,   159,   155,   155,   160,   162,    26,
      26,   159,    26,   159,    26,   159,   159,    26,    69,    32,
     157,    26,   160,    69,   160,   159,   159,   159,    26,   159,
      26,   159,    26,   160,    81,   157,   130,    67,   159,    68,
     159,    36,   160,    95,    89,   123,    26,    26,   157,   159,
     157,   157,    33,    28,    26,   134,    22,   157,   155,    26,
      68,   159,    26,    26,   159,   157,   157,    36,   157,   162,
     160,   159,   159,   966,   159,   161,   159,   159,   159,    81,
     155,   134,   159,   155,   160,   133,   159,    69,   159,    36,
     160,   160,   160,   846,   157,   157,   160,   929,   134,    -1,
     159,   159,   162,   159,   159,   159,   134,   134,    -1,   134,
     134,   134,    -1,    -1,    -1,   159,   159,   159,    -1,   159,
     159,   159,    -1,    -1,    -1,    -1,   159,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   159,   159,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   283,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   302
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const unsigned char yystos[] =
{
       0,   168,   169,     0,     1,    12,    24,    25,    26,    28,
      30,    31,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    93,    94,   110,
     111,   112,   113,   117,   120,   121,   140,   143,   144,   145,
     147,   148,   149,   150,   151,   152,   153,   154,   160,   161,
     163,   164,   170,   171,   172,   197,   198,   199,   200,   201,
     204,   160,    60,    67,   160,   165,   166,   205,   206,   207,
     208,    86,    91,    92,    95,    96,   100,   101,    95,    97,
      98,    99,   102,   203,    95,    95,    95,    95,    95,    26,
      26,   207,   207,   160,   160,   207,   207,   207,   160,   207,
     160,   160,   161,   161,   161,   161,   160,   161,   161,    95,
     203,   160,   160,   160,   160,   160,   160,    26,   172,   160,
     160,    28,    61,    26,    26,    80,   203,    75,   158,    75,
     158,    95,   100,   101,    26,    36,    67,    74,    83,    84,
      85,    87,   172,   197,   207,    36,   172,    36,   160,   173,
      26,   208,   208,   208,    62,    63,    64,    65,    67,    68,
      69,    70,    88,    89,    26,   207,    26,   207,    26,   207,
       5,     6,     7,     8,    10,    11,    13,    14,    15,    16,
      17,    18,    26,    28,    29,    34,    36,    60,    67,    72,
      73,    74,    82,    83,    84,    87,   120,   121,   160,   161,
     172,   188,   191,   202,   207,    26,    26,   207,    26,   207,
      26,   146,   172,    28,   146,   140,   163,    36,    36,    36,
      36,    16,    19,    21,    23,    26,    28,    36,    83,    84,
     121,   160,   172,   202,   207,   207,    26,    27,    26,    27,
      26,    26,    26,    26,    26,    26,    26,    26,    26,    28,
      26,    26,    26,    26,    26,    26,    36,    26,    26,    54,
      28,   155,   157,    67,    68,    80,    81,   193,   196,    26,
      28,   171,   171,   172,    69,   172,   172,   172,   172,   160,
     172,    88,    89,    90,   160,   207,    69,   160,   189,    69,
     132,   133,   155,   157,   159,   208,   208,   208,   208,   208,
     208,   208,   208,   208,   208,   160,   160,   160,   160,   160,
     160,   160,   160,   160,    62,    63,    65,    68,    76,    77,
      78,    79,    88,    89,    90,   192,   193,   160,   180,    68,
      69,   180,    26,    26,    26,    26,    26,    26,    26,   161,
     161,    26,   172,   197,   198,   199,   201,    26,    68,   160,
     160,   173,   160,   181,   160,   103,   104,   109,   160,   103,
     104,   109,   160,   160,   160,    26,    26,    36,   172,   160,
     193,    95,    88,    89,    90,    95,   193,    36,    36,   161,
     199,   201,   173,   155,   159,    68,   159,    68,   155,   155,
      81,   162,    81,   162,    81,   162,    81,   162,   159,    81,
     193,   196,    81,   193,   196,   155,   155,   155,   155,   155,
     155,   155,   159,    95,   207,    26,    54,    26,   207,    26,
     207,   162,   162,    75,   158,    75,   158,   189,    36,   155,
     155,   156,   156,   172,   156,   207,   207,   207,   123,    36,
     133,    36,   155,   159,   155,   159,    26,    36,   200,   207,
      26,    26,    26,    26,    26,    36,    26,    26,    26,    26,
      26,    26,   160,   207,   207,   207,    26,    26,   130,   131,
      35,    36,   160,   182,   160,   183,   156,   156,   156,   156,
      26,    26,    68,   101,   172,   159,    81,   193,   196,   172,
      26,    26,   155,   130,   131,   129,    26,   207,    26,   207,
      26,   207,    26,   172,   172,   172,    26,    26,    26,    36,
     135,    26,    66,    85,   207,   207,   207,    22,    36,   156,
     156,    26,   172,   159,   155,   207,    26,    26,    26,    26,
     162,   162,   162,   162,   207,   162,    26,   207,   162,   207,
     207,   207,    26,   207,   207,   207,    26,   160,    95,   207,
     159,   155,   159,   162,   162,    95,    95,   171,   171,   172,
     197,   197,    36,    36,   155,    36,   207,   159,   159,   133,
     132,    95,    95,   173,   155,   157,   157,   157,   157,   155,
     155,   155,   155,   155,    26,   182,   183,   182,   155,   160,
     177,   155,   160,   178,   159,   159,   155,   122,   123,   140,
     140,    36,    36,    36,    36,   207,   193,   196,    81,   193,
     196,    26,   159,    26,   207,   162,   155,   155,   155,    26,
     159,   159,   159,   160,   190,   190,   190,   190,   155,   155,
     159,   155,   155,   159,   160,   160,   160,   160,   184,   184,
     160,   178,    36,    36,    81,   196,   159,    36,   159,   159,
     159,   159,   159,   162,    95,   162,   162,    95,   159,   159,
     159,   155,   159,   159,   159,   128,    26,   160,    95,    26,
      95,    95,    95,    26,    26,   160,   158,   158,    67,    74,
     172,   155,   159,   159,   160,   172,   160,    26,   207,   207,
     207,   207,    26,    36,    26,    36,    26,    88,    26,   123,
     124,   125,   175,    26,   122,   123,    26,   159,   155,   159,
     155,   159,   159,   183,   182,   207,   162,    26,   207,   162,
     159,   162,   162,    26,    26,    26,    95,   133,   207,   207,
     160,   174,    36,    36,   138,   139,   172,   172,   123,    36,
     184,    26,   162,    95,    26,    95,    26,    95,    95,    26,
      36,   172,   159,   128,     3,     4,     9,    20,   157,   161,
      26,    26,    26,   172,   172,   155,   197,   157,   155,   155,
     155,   155,   159,   159,   159,   159,   159,   207,    95,   159,
      95,   159,   159,    95,   140,   123,   162,   180,   162,   162,
     180,    88,    95,   159,   159,    36,   202,   159,   159,   159,
     118,   119,   159,   159,   159,   159,   155,   155,   159,   159,
     162,   202,    95,    26,    36,    26,   159,   159,   160,   160,
      26,    26,   207,    26,   157,    28,   172,   207,    26,    26,
      26,    26,   174,   180,   160,   159,    26,    26,    32,   159,
     159,   180,   180,   180,   207,   172,   183,   173,   159,   159,
     183,    26,   172,    26,    69,   173,    26,   174,    26,    26,
     157,   160,   159,    81,   207,   159,   160,   159,   157,   157,
     157,   157,   130,   192,   193,    68,    67,   159,   155,   159,
      36,    89,   157,   157,   207,   105,   106,   107,   108,   185,
      95,   162,   155,   159,   123,   160,   186,   207,   207,   207,
     207,   159,    26,    26,    33,   172,    28,    68,   207,   207,
     207,   186,   159,   161,    26,   159,   134,   159,   159,   159,
     159,   160,   179,   178,   178,   159,    22,   155,   155,    26,
     157,   159,   160,   187,   160,   194,   194,   160,   195,   118,
     119,   175,   176,   160,    26,    26,    81,   207,   133,   134,
     126,   127,   136,   137,   141,   142,   155,   159,   155,   159,
      36,   157,   157,   162,   159,   155,   159,   155,   159,   155,
     159,   155,   159,   155,   159,   155,   159,   155,   159,   155,
     159,   176,   175,   159,   207,   207,   134,   133,   134,   134,
     134,   134,   134,   134,   159,   159,    69,   159,   159,   159,
     159,   159,   159,   159,   159,   159,   159,    36,   186,   186
};

#if ! defined (YYSIZE_T) && defined (__SIZE_TYPE__)
# define YYSIZE_T __SIZE_TYPE__
#endif
#if ! defined (YYSIZE_T) && defined (size_t)
# define YYSIZE_T size_t
#endif
#if ! defined (YYSIZE_T)
# if defined (__STDC__) || defined (__cplusplus)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# endif
#endif
#if ! defined (YYSIZE_T)
# define YYSIZE_T unsigned int
#endif

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrlab1

/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { 								\
      yyerror ("syntax error: cannot back up");\
      YYERROR;							\
    }								\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

/* YYLLOC_DEFAULT -- Compute the default location (before the actions
   are run).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)         \
  Current.first_line   = Rhs[1].first_line;      \
  Current.first_column = Rhs[1].first_column;    \
  Current.last_line    = Rhs[N].last_line;       \
  Current.last_column  = Rhs[N].last_column;
#endif

/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (0)

# define YYDSYMPRINT(Args)			\
do {						\
  if (yydebug)					\
    yysymprint Args;				\
} while (0)

# define YYDSYMPRINTF(Title, Token, Value, Location)		\
do {								\
  if (yydebug)							\
    {								\
      YYFPRINTF (stderr, "%s ", Title);				\
      yysymprint (stderr, 					\
                  Token, Value);	\
      YYFPRINTF (stderr, "\n");					\
    }								\
} while (0)

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (cinluded).                                                   |
`------------------------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_stack_print (short *bottom, short *top)
#else
static void
yy_stack_print (bottom, top)
    short *bottom;
    short *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (/* Nothing. */; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_reduce_print (int yyrule)
#else
static void
yy_reduce_print (yyrule)
    int yyrule;
#endif
{
  int yyi;
  unsigned int yylineno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %u), ",
             yyrule - 1, yylineno);
  /* Print the symbols being reduced, and their result.  */
  for (yyi = yyprhs[yyrule]; 0 <= yyrhs[yyi]; yyi++)
    YYFPRINTF (stderr, "%s ", yytname [yyrhs[yyi]]);
  YYFPRINTF (stderr, "-> %s\n", yytname [yyr1[yyrule]]);
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (Rule);		\
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YYDSYMPRINT(Args)
# define YYDSYMPRINTF(Title, Token, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   SIZE_MAX < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#if YYMAXDEPTH == 0
# undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined (__GLIBC__) && defined (_STRING_H)
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
#   if defined (__STDC__) || defined (__cplusplus)
yystrlen (const char *yystr)
#   else
yystrlen (yystr)
     const char *yystr;
#   endif
{
  register const char *yys = yystr;

  while (*yys++ != '\0')
    continue;

  return yys - yystr - 1;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined (__GLIBC__) && defined (_STRING_H) && defined (_GNU_SOURCE)
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
#   if defined (__STDC__) || defined (__cplusplus)
yystpcpy (char *yydest, const char *yysrc)
#   else
yystpcpy (yydest, yysrc)
     char *yydest;
     const char *yysrc;
#   endif
{
  register char *yyd = yydest;
  register const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

#endif /* !YYERROR_VERBOSE */



#if YYDEBUG
/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yysymprint (FILE *yyoutput, int yytype, YYSTYPE *yyvaluep)
#else
static void
yysymprint (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  if (yytype < YYNTOKENS)
    {
      YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
# ifdef YYPRINT
      YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
    }
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  switch (yytype)
    {
      default:
        break;
    }
  YYFPRINTF (yyoutput, ")");
}

#endif /* ! YYDEBUG */
/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yydestruct (int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yytype, yyvaluep)
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  switch (yytype)
    {

      default:
        break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM);
# else
int yyparse ();
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM)
# else
int yyparse (YYPARSE_PARAM)
  void *YYPARSE_PARAM;
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  register int yystate;
  register int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  short	yyssa[YYINITDEPTH];
  short *yyss = yyssa;
  register short *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  register YYSTYPE *yyvsp;



#define YYPOPSTACK   (yyvsp--, yyssp--)

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* When reducing, the number of symbols on the RHS of the reduced
     rule.  */
  int yylen;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed. so pushing a state here evens the stacks.
     */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack. Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	short *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyoverflowlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyoverflowlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	short *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyoverflowlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YYDSYMPRINTF ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */
  YYDPRINTF ((stderr, "Shifting token %s, ", yytname[yytoken]));

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;


  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  yystate = yyn;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 586 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { INIT_ASM(); }
    break;

  case 3:
#line 588 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { insn=yyvsp[0].instr; return (1); }
    break;

  case 5:
#line 593 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
	if ((yyvsp[-5].instr->value & 0xf800) == 0xc000) {
		if (is_group1(yyvsp[-3].instr) && is_group2(yyvsp[-1].instr)) {
			yyval.instr = gen_multi_instr(yyvsp[-5].instr, yyvsp[-3].instr, yyvsp[-1].instr);
		} else 
		if (is_group2(yyvsp[-3].instr) && is_group1(yyvsp[-1].instr)) {
			yyval.instr = gen_multi_instr(yyvsp[-5].instr, yyvsp[-1].instr, yyvsp[-3].instr);
		} else {
			return semantic_error("Wrong 16 bit instructions groups");
		}
	}
		else
		error("\nIllegal Multi Issue Construct, first instruction must be DSP32\n");
	}
    break;

  case 6:
#line 609 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (is_group1(yyvsp[-3].instr) && is_group2(yyvsp[-1].instr)) {
			yyval.instr = gen_multi_instr(0, yyvsp[-3].instr, yyvsp[-1].instr);
		} else
		if (is_group2(yyvsp[-3].instr) && is_group1(yyvsp[-1].instr)) {
			yyval.instr = gen_multi_instr(0, yyvsp[-1].instr, yyvsp[-3].instr);
		} else {
			return semantic_error("Wrong 16 bit instructions groups");
		}
	}
    break;

  case 7:
#line 621 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (is_group1(yyvsp[-1].instr)) {
			yyval.instr = gen_multi_instr(0, yyvsp[-1].instr, 0);
		} else
		if (is_group2(yyvsp[-1].instr)) {
			yyval.instr = gen_multi_instr(0, 0, yyvsp[-1].instr);
		} else {
			return semantic_error("Wrong 16 bit instructions groups");
		}

	}
    break;

  case 8:
#line 634 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.instr = gen_multi_instr(0, 0, 0);
	}
    break;

  case 9:
#line 639 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if ((yyvsp[-3].instr->value & 0xf800) == 0xc000) {

			if (is_group1(yyvsp[-1].instr) )
				yyval.instr = gen_multi_instr(yyvsp[-3].instr, yyvsp[-1].instr, 0);
			else
			if (is_group2(yyvsp[-1].instr) )
				yyval.instr = gen_multi_instr(yyvsp[-3].instr, 0, yyvsp[-1].instr);
			else
				return semantic_error("Wrong 16 bit instructions groups");
		} else
		if (is_group1(yyvsp[-3].instr) && is_group2(yyvsp[-1].instr)) {
			yyval.instr = gen_multi_instr(0, yyvsp[-3].instr, yyvsp[-1].instr);
		} else
		if (is_group2(yyvsp[-3].instr) && is_group1(yyvsp[-1].instr)) {
			yyval.instr = gen_multi_instr(0, yyvsp[-1].instr, yyvsp[-3].instr);
		} else {
			return semantic_error("Wrong 16 bit instructions groups");
		}
	}
    break;

  case 10:
#line 660 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.instr=0; as_bad("\nParse error.\n");yyerrok; }
    break;

  case 11:
#line 670 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		int op0, op1;
		int w0 = 0, w1 = 0;
		int h00, h10, h01, h11;

		if (yyvsp[-1].macfunc.n == 0) {
			if (yyvsp[0].mod.MM) 
				return semantic_error("(m) not allowed with a0 unit");
			op1 = 3; op0 = yyvsp[-1].macfunc.op;
			w1 = 0; w0 = yyvsp[-1].macfunc.w;
			h00 = IS_H(yyvsp[-1].macfunc.s0); h10 = IS_H(yyvsp[-1].macfunc.s1);
			h01 = h11 = 0;
		} else {
			op1 = yyvsp[-1].macfunc.op; op0 = 3;
			w1 = yyvsp[-1].macfunc.w; w0 = 0;
			h00 = h10 = 0;
			h01 = IS_H(yyvsp[-1].macfunc.s0); h11 = IS_H(yyvsp[-1].macfunc.s1);
		}

					   /*   op1       MM      mmod  */
		yyval.instr = DSP32MAC  (    op1,   yyvsp[0].mod.MM,   yyvsp[0].mod.mod,  /* w1     P */
					   /*   h01   h11    h00    h10 */  w1, yyvsp[-1].macfunc.P,
							h01,  h11,   h00,   h10,
					    &yyvsp[-1].macfunc.dst,  // dst (dregs)
					   /*   op0  src0     src1    w0              */
						    op0, &yyvsp[-1].macfunc.s0, &yyvsp[-1].macfunc.s1,  w0              );

	}
    break;

  case 12:
#line 704 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		Register *dst;

		if (check_macfuncs(&yyvsp[-4].macfunc, &yyvsp[-3].mod, &yyvsp[-1].macfunc, &yyvsp[0].mod) < 0) 
			return -1;
		notethat("assign_macfunc (.), assign_macfunc (.)\n");

		if (yyvsp[-4].macfunc.w) { // a1macfunc destination
			dst = &yyvsp[-4].macfunc.dst;
		} else {
			dst = &yyvsp[-1].macfunc.dst;
		}

					   /*   op1       MM      mmod  */
		yyval.instr = DSP32MAC  (  yyvsp[-4].macfunc.op,   yyvsp[-3].mod.MM,   yyvsp[0].mod.mod,  /* w1     P */
					   /*   h01   h11    h00    h10 */ yyvsp[-4].macfunc.w, yyvsp[-4].macfunc.P,
			 		IS_H(yyvsp[-4].macfunc.s0),  IS_H(yyvsp[-4].macfunc.s1), IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1),
					        dst,  // dst (dregs)
					   /*   op0  src0     src1    w0              */
						  yyvsp[-1].macfunc.op, &yyvsp[-4].macfunc.s0, &yyvsp[-4].macfunc.s1,  yyvsp[-1].macfunc.w            );

	}
    break;

  case 13:
#line 733 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		    notethat("dsp32alu: DISALGNEXCPT\n");

						  /* aopcde       HL   */
			yyval.instr = DSP32ALU (      18,       0,
						  /*   dst1     dst0     src0     src1 */
							      0,       0,       0,       0,
						  /*      s        x      aop */
							      0,       0,       3           );

	}
    break;

  case 14:
#line 746 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && !IS_A1(yyvsp[-2].reg) && IS_A1(yyvsp[-1].reg)) {
		    notethat("dsp32alu: dregs = ( A0 += A1 )\n");
						  /* aopcde       HL   */
			yyval.instr = DSP32ALU (      11,       0,
						  /*   dst1     dst0     src0     src1 */
							      0,     &yyvsp[-5].reg,       0,       0,
						  /*      s        x      aop */
							      0,       0,       0           );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 15:
#line 761 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!IS_A1(yyvsp[-2].reg) && IS_A1(yyvsp[-1].reg)) {
			notethat("dsp32alu: dregs_half = ( A0 += A1 )\n");
						  /* aopcde       HL   */
			yyval.instr = DSP32ALU (      11,   IS_H(yyvsp[-5].reg), 
						  /*   dst1     dst0     src0     src1 */
								  0,     &yyvsp[-5].reg,       0,       0,
						  /*      s        x      aop */
								  0,       0,       1           );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 16:
#line 777 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("dsp32alu: A_ZERO_DOT_H = dregs_hi\n");
					  /* aopcde        HL   */
		yyval.instr = DSP32ALU (       9, IS_H(yyvsp[0].reg), 
			          /*   dst1     dst0     src0     src1 */
							  0,       0,     &yyvsp[0].reg,       0,
					  /*      s        x      aop */
							  0,       0,       0           );
	               
	}
    break;

  case 17:
#line 790 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("dsp32alu: A_ZERO_DOT_H = dregs_hi\n");
			               /* aopcde       HL   */
			yyval.instr = DSP32ALU (       9, IS_H(yyvsp[0].reg),
			              /*   dst1     dst0     src0     src1 */
							      0,       0,     &yyvsp[0].reg,       0,
			              /*      s        x      aop */
			                      0,       0,       2          );

	}
    break;

  case 18:
#line 803 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {

		if (IS_DREG(yyvsp[-15].reg) && IS_DREG(yyvsp[-13].reg) && IS_DREG(yyvsp[-8].reg) && IS_DREG(yyvsp[-4].reg)) {
		    notethat("dsp32alu: ( dregs , dregs ) = BYTEOP16P ( dregs_pair , dregs_pair ) (half)\n");
			               /* aopcde       HL   */
			yyval.instr = DSP32ALU (      21,       0,
			              /*   dst1     dst0     src0     src1 */
							    &yyvsp[-15].reg,     &yyvsp[-13].reg,     &yyvsp[-8].reg,    &yyvsp[-4].reg,
			              /*      s        x      aop */
			                 yyvsp[0].r0.r0,       0,       0          );
		} else {
			return register_mismatch();
		}	
	}
    break;

  case 19:
#line 820 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {

		if (IS_DREG(yyvsp[-15].reg) && IS_DREG(yyvsp[-13].reg) && IS_DREG(yyvsp[-8].reg) && IS_DREG(yyvsp[-4].reg)) {
		    notethat("dsp32alu: ( dregs , dregs ) = BYTEOP16M ( dregs_pair , dregs_pair ) (aligndir)\n");
			               /* aopcde       HL   */
			yyval.instr = DSP32ALU (      21,       0,
			              /*   dst1     dst0     src0     src1 */
							    &yyvsp[-15].reg,     &yyvsp[-13].reg,     &yyvsp[-8].reg,    &yyvsp[-4].reg,
			              /*      s        x      aop */
			                 yyvsp[0].r0.r0,       0,       1          );
		} else {
			return register_mismatch();
		}	
	}
    break;

  case 20:
#line 836 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-9].reg) && IS_DREG(yyvsp[-7].reg) && IS_DREG(yyvsp[-3].reg)) {
		    notethat("dsp32alu: ( dregs , dregs ) = BYTEUNPACK dregs_pair (aligndir)\n");
		                  /* aopcde       HL   */
			yyval.instr = DSP32ALU (      24,       0,
			              /*   dst1     dst0     src0     src1 */
							    &yyvsp[-9].reg,     &yyvsp[-7].reg,     &yyvsp[-3].reg,       0,
			              /*      s        x      aop */
			                 yyvsp[0].r0.r0,       0,       1          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 21:
#line 851 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-9].reg) && IS_DREG(yyvsp[-7].reg) && IS_DREG(yyvsp[-3].reg)) {
		    notethat("dsp32alu: ( dregs , dregs ) = SEARCH dregs (searchmod)\n");
		                  /* aopcde       HL   */
			yyval.instr = DSP32ALU (      13,       0,
			              /*   dst1     dst0     src0     src1 */
							    &yyvsp[-9].reg,     &yyvsp[-7].reg,     &yyvsp[-3].reg,       0,
			              /*      s        x      aop */
			                      0,       0,  yyvsp[-1].r0.r0          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 22:
#line 867 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-10].reg) && IS_DREG(yyvsp[-4].reg)  ) {
			notethat("dsp32alu: dregs = A1.l + A1.h, dregs = A0.l + A0.h  \n");
		                  /* aopcde       HL   */
			yyval.instr = DSP32ALU (      12,       0,
			              /*   dst1     dst0     src0     src1 */
							    &yyvsp[-10].reg,     &yyvsp[-4].reg,       0,       0,
			              /*      s        x      aop */
			                      0,       0,       1          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 23:
#line 883 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-11].reg) && IS_DREG(yyvsp[-5].reg) && !REG_SAME(yyvsp[-9].reg, yyvsp[-7].reg)
		   && IS_A1(yyvsp[-3].reg) && !IS_A1(yyvsp[-1].reg) ) {
		    notethat("dsp32alu: dregs = A1 + A0 , dregs = A1 - A0 (amod1)\n");
			              /* aopcde       HL   */
			yyval.instr = DSP32ALU (      17,       0,
			              /*   dst1     dst0     src0     src1 */
							    &yyvsp[-11].reg,     &yyvsp[-5].reg,       0,       0,
			              /*      s        x      aop */
			                 yyvsp[0].modcodes.s0,  yyvsp[0].modcodes.x0,       0          );

		} else
		if (IS_DREG(yyvsp[-11].reg) && IS_DREG(yyvsp[-5].reg) && !REG_SAME(yyvsp[-9].reg, yyvsp[-7].reg)
		   && !IS_A1(yyvsp[-3].reg) && IS_A1(yyvsp[-1].reg) ) {
		    notethat("dsp32alu: dregs = A0 + A1 , dregs = A0 - A1 (amod1)\n");
			              /* aopcde       HL   */
			yyval.instr = DSP32ALU (      17,       0,
			              /*   dst1     dst0     src0     src1 */
							    &yyvsp[-11].reg,     &yyvsp[-5].reg,       0,       0,
			              /*      s        x      aop */
			                 yyvsp[0].modcodes.s0,  yyvsp[0].modcodes.x0,       1          );
	
		} else {
			return register_mismatch();
		}
	}
    break;

  case 24:
#line 911 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[-8].r0.r0 == yyvsp[-2].r0.r0) 
			return semantic_error("Operators must differ");

		if (IS_DREG(yyvsp[-11].reg) && IS_DREG(yyvsp[-9].reg) && IS_DREG(yyvsp[-7].reg)
		 && REG_SAME(yyvsp[-9].reg, yyvsp[-3].reg) && REG_SAME(yyvsp[-7].reg, yyvsp[-1].reg)) {
			notethat("dsp32alu: dregs = dregs + dregs,"
			         "dregs = dregs - dregs (amod1)\n");
						  /* aopcde       HL   */
			yyval.instr = DSP32ALU (       4,       0,
						  /*   dst1     dst0     src0     src1 */
							    &yyvsp[-11].reg,     &yyvsp[-5].reg,     &yyvsp[-9].reg,     &yyvsp[-7].reg,
						  /*      s        x      aop */
							 yyvsp[0].modcodes.s0,  yyvsp[0].modcodes.x0,       2          );

		} else {
			return register_mismatch();
		}
	}
    break;

  case 25:
#line 934 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!REG_SAME(yyvsp[-9].reg, yyvsp[-3].reg) || !REG_SAME(yyvsp[-7].reg, yyvsp[-1].reg))
			return semantic_error("Differing source registers");

		if (!IS_DREG(yyvsp[-11].reg) || !IS_DREG(yyvsp[-9].reg) || !IS_DREG(yyvsp[-7].reg) || !IS_DREG(yyvsp[-5].reg)) 
			return semantic_error("Dregs expected");

	
		if (yyvsp[-8].r0.r0 == 1 && yyvsp[-2].r0.r0 == 2) {
			notethat("dsp32alu:  dregs = dregs .|. dregs , dregs = dregs .|. dregs (amod2)\n");
						  /* aopcde       HL   */
			yyval.instr = DSP32ALU (       1,       1,
						  /*   dst1     dst0     src0     src1 */
							    &yyvsp[-11].reg,     &yyvsp[-5].reg,     &yyvsp[-9].reg,     &yyvsp[-7].reg,
						  /*      s        x      aop */
							  yyvsp[0].modcodes.s0, yyvsp[0].modcodes.x0,  yyvsp[0].modcodes.r0          );
		} else
		if (yyvsp[-8].r0.r0 == 0 && yyvsp[-2].r0.r0 == 3) {
			notethat("dsp32alu:  dregs = dregs .|. dregs , dregs = dregs .|. dregs (amod2)\n");
						  /* aopcde       HL   */
			yyval.instr = DSP32ALU (       1,       0,
						  /*   dst1     dst0     src0     src1 */
							    &yyvsp[-11].reg,     &yyvsp[-5].reg,     &yyvsp[-9].reg,     &yyvsp[-7].reg,
						  /*      s        x      aop */
							 yyvsp[0].modcodes.s0,  yyvsp[0].modcodes.x0,  yyvsp[0].modcodes.r0          );
		} else {
			return semantic_error("Bar operand mismatch");
		}
	}
    break;

  case 26:
#line 965 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		int op;

		if (IS_DREG(yyvsp[-4].reg) && IS_DREG(yyvsp[-1].reg)) {
			if (yyvsp[0].r0.r0) {
				notethat("dsp32alu: dregs = ABS dregs (v)\n");
				op = 6;
			} else {
				// Vector version of ABS
				notethat("dsp32alu: dregs = ABS dregs\n");
				op = 7;
			}
		              /* aopcde       HL   */
		yyval.instr = DSP32ALU (      op,       0,
					  /*   dst1     dst0     src0     src1 */
		                      0,     &yyvsp[-4].reg,    &yyvsp[-1].reg,       0,
					  /*      s        x      aop */
							  0,       0,       2          );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 27:
#line 990 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("dsp32alu: Ax = ABS Ax\n");
		              /* aopcde       HL   */
		yyval.instr = DSP32ALU (      16, IS_A1(yyvsp[-2].reg),
					  /*   dst1     dst0     src0     src1 */
							  0,       0,       0,       0,
					  /*      s        x      aop */
							  0,       0,  IS_A1(yyvsp[0].reg)       );
	}
    break;

  case 28:
#line 1001 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[0].reg)) {
			notethat("dsp32alu: A0.l = reg_half\n");
						  /* aopcde       HL   */
			yyval.instr = DSP32ALU (       9, IS_H(yyvsp[0].reg),
						  /*   dst1     dst0     src0     src1 */
								  0,       0,     &yyvsp[0].reg,       0,
						  /*      s        x      aop */
								  0,       0,       0          );
		} else {
			return semantic_error("A0.l = Rx.l expected");
		}
	}
    break;

  case 29:
#line 1016 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[0].reg)) {
			notethat("dsp32alu: A1.l = reg_half\n");
						  /* aopcde       HL   */
			yyval.instr = DSP32ALU (       9, IS_H(yyvsp[0].reg),
						  /*   dst1     dst0     src0     src1 */
								  0,       0,     &yyvsp[0].reg,       0,
						  /*      s        x      aop */
								  0,       0,       2          );
		} else {
			return semantic_error("A1.l = Rx.l expected");
		}
	}
    break;

  case 30:
#line 1031 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-7].reg) && IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
		    notethat("dsp32shift: dregs = ALIGN8 ( dregs , dregs )\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      13,   &yyvsp[-7].reg,     &yyvsp[-1].reg,     &yyvsp[-3].reg,
			              /*      sop      HLs */
			                    yyvsp[-5].r0.r0,       0                    );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 31:
#line 1045 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (are_byteop_regs(&yyvsp[-12].reg, &yyvsp[-8].reg, yyvsp[-6].expr, &yyvsp[-4].reg, yyvsp[-2].expr)) {
		    notethat("dsp32alu: dregs = BYTEOP1P ( dregs_pair , dregs_pair ) (T)\n");
		              /* aopcde       HL   */
		yyval.instr = DSP32ALU (      20,       0,
					  /*   dst1     dst0     src0     src1 */
		                      0,    &yyvsp[-12].reg,      &yyvsp[-8].reg,     &yyvsp[-4].reg,
					  /*      s        x      aop */
						 yyvsp[0].modcodes.s0,       0,   yyvsp[0].modcodes.r0          );
		} else {
			return register_mismatch();
		}

	}
    break;

  case 32:
#line 1062 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (are_byteop_regs(&yyvsp[-12].reg, &yyvsp[-8].reg, yyvsp[-6].expr, &yyvsp[-4].reg, yyvsp[-2].expr)) {
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (rnd_op)\n");
		              /* aopcde       HL   */
		yyval.instr = DSP32ALU (      22,  yyvsp[0].modcodes.r0,
		              /*   dst1     dst0     src0     src1 */
		                      0,    &yyvsp[-12].reg,      &yyvsp[-8].reg,     &yyvsp[-4].reg,
		              /*      s        x      aop */
		                 yyvsp[0].modcodes.s0,       0,   yyvsp[0].modcodes.x0         );
		} else {
			return semantic_error("Dregs expected");
		}

	}
    break;

  case 33:
#line 1080 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (are_byteop_regs(&yyvsp[-12].reg, &yyvsp[-8].reg, yyvsp[-6].expr, &yyvsp[-4].reg, yyvsp[-2].expr)) {
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (rnd_op)\n");
		              /* aopcde       HL   */
		yyval.instr = DSP32ALU (      22,  yyvsp[0].modcodes.r0,
		              /*   dst1     dst0     src0     src1 */
		                      0,    &yyvsp[-12].reg,      &yyvsp[-8].reg,     &yyvsp[-4].reg,
		              /*      s        x      aop */
		                 yyvsp[0].modcodes.s0,       0,   yyvsp[0].modcodes.x0         );
		} else {
			return semantic_error("Dregs expected");
		}

	}
    break;

  case 34:
#line 1097 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (are_byteop_regs(&yyvsp[-12].reg, &yyvsp[-8].reg, yyvsp[-6].expr, &yyvsp[-4].reg, yyvsp[-2].expr)) {
		    notethat("dsp32alu: dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (b3_op)\n");
		              /* aopcde       HL   */
		yyval.instr = DSP32ALU (      23,  yyvsp[0].modcodes.x0,
		              /*   dst1     dst0     src0     src1 */
		                      0,    &yyvsp[-12].reg,      &yyvsp[-8].reg,     &yyvsp[-4].reg,
		              /*      s        x      aop */
		                 yyvsp[0].modcodes.s0,       0,       0          );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 35:
#line 1112 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-7].reg) && IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
		    notethat("dsp32alu: dregs = BYTEPACK ( dregs , dregs )\n");
		              /* aopcde       HL   */
		yyval.instr = DSP32ALU (      24,       0,
		              /*   dst1     dst0     src0     src1 */
		                      0,    &yyvsp[-7].reg,      &yyvsp[-3].reg,     &yyvsp[-1].reg,
		              /*      s        x      aop */
		                      0,       0,       0          );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 36:
#line 1128 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_HCOMPL(yyvsp[-16].reg, yyvsp[-14].reg) && IS_HCOMPL(yyvsp[-10].reg, yyvsp[-3].reg) && IS_HCOMPL(yyvsp[-7].reg, yyvsp[0].reg) ) {
   		    notethat("dsp32alu:	dregs_hi = dregs_lo ="
			         "SIGN (dregs_hi) * dregs_hi + "
			         "SIGN (dregs_lo) * dregs_lo \n");

		              /* aopcde       HL   */
		yyval.instr = DSP32ALU (      12,       0,
		              /*   dst1     dst0     src0     src1 */
		                    &yyvsp[-14].reg,     &yyvsp[-16].reg,     &yyvsp[-10].reg,    &yyvsp[-7].reg,
		              /*      s        x      aop */
		                      0,       0,       0          );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 37:
#line 1151 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
			// XXX For the moment, we always use the 16 bit variant
			if (0) {
				notethat("dsp32alu: dregs = dregs +- dregs (amod1)\n");
						  /* aopcde       HL                   */
				yyval.instr = DSP32ALU (   4,       0,
						  /*   dst1     dst0     src0     src1 */
								  0,     &yyvsp[-5].reg,     &yyvsp[-3].reg,     &yyvsp[-1].reg,
						  /*      s        x      aop          */
							  yyvsp[0].modcodes.s0,   yyvsp[0].modcodes.x0,   yyvsp[-2].r0.r0          );
			} else {
				notethat("COMP3op: dregs = dregs +- dregs\n");
				yyval.instr = COMP3OP (&yyvsp[-5].reg, &yyvsp[-3].reg, &yyvsp[-1].reg, yyvsp[-2].r0.r0);
			}
		} else
		if (IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-3].reg) && IS_PREG(yyvsp[-1].reg) && yyvsp[-2].r0.r0 == 0) {
		    notethat("COMP3op: pregs = pregs + pregs\n");
			yyval.instr = COMP3OP (&yyvsp[-5].reg, &yyvsp[-3].reg, &yyvsp[-1].reg, 5);
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 38:
#line 1177 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		int op;

		if (IS_DREG(yyvsp[-8].reg) && IS_DREG(yyvsp[-4].reg) && IS_DREG(yyvsp[-2].reg)) {
			if (yyvsp[0].r0.r0) {
				op = 6;
			} else {
				op = 7;
			}

		    notethat("dsp32alu: dregs = {MIN|MAX} (dregs, dregs)\n");
			          /* aopcde       HL   */
		yyval.instr = DSP32ALU (      op,       0,
		              /*   dst1     dst0     src0     src1 */
		                      0,     &yyvsp[-8].reg,     &yyvsp[-4].reg,     &yyvsp[-2].reg,
		              /*      s        x      aop */
		                      0,       0,   yyvsp[-6].r0.r0          );

		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 39:
#line 1201 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("dsp32alu: Ax = - Ax\n");
				  /*     aopcde       HL               */
		yyval.instr = DSP32ALU (  14,       IS_A1(yyvsp[-2].reg),
				  /*   dst1     dst0     src0     src1 */
						  0,       0,       0,       0,
				  /*      s        x      aop          */
						  0,       0,  IS_A1(yyvsp[0].reg)       );
	}
    break;

  case 40:
#line 1213 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("dsp32alu: dregs_lo = dregs_lo +- dregs_lo (amod1)\n");
				  /* aopcde       HL                   */
		yyval.instr = DSP32ALU ( 2 | yyvsp[-2].r0.r0,  IS_H(yyvsp[-5].reg),
				  /*   dst1     dst0     src0     src1 */
						  0,     &yyvsp[-5].reg,     &yyvsp[-3].reg,     &yyvsp[-1].reg,
				  /*      s        x      aop          */
					  yyvsp[0].modcodes.s0,   yyvsp[0].modcodes.x0,  HL2(yyvsp[-3].reg, yyvsp[-1].reg)     );
	}
    break;

  case 41:
#line 1224 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (EXPR_VALUE(yyvsp[0].expr) == 0 && !REG_SAME(yyvsp[-2].reg, yyvsp[-1].reg) ) {
			notethat("dsp32alu: A1 = A0 = 0\n");
					  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (   8,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,       0,       0,       0,
					  /*      s        x      aop          */
							  0,       0,       2          );
		} else {
			return semantic_error("Bad value, 0 expected");
		}
	}
    break;

  case 42:
#line 1240 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_SAME(yyvsp[-4].reg, yyvsp[-3].reg)) {
		    notethat("dsp32alu: Ax = Ax (S)\n");
				  /* aopcde       HL                   */
		yyval.instr = DSP32ALU (   8,       0,
				  /*   dst1     dst0     src0     src1 */
						  0,       0,       0,       0,
				  /*      s        x      aop          */
						  1,       0,  IS_A1(yyvsp[-4].reg)       );
		} else {
			return semantic_error("Registers must be equal");
		}
	}
    break;

  case 43:
#line 1255 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg)) {
		    notethat("dsp32alu: dregs_half = dregs (RND)\n");
				  /* aopcde       HL                   */
		yyval.instr = DSP32ALU (  12,  IS_H(yyvsp[-5].reg),
		          /*   dst1     dst0     src0     src1 */
		                  0,     &yyvsp[-5].reg,     &yyvsp[-3].reg,       0,
		          /*      s        x      aop          */
		                  0,       0,       3          );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 44:
#line 1270 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg)) {
		    notethat("dsp32alu: dregs_half = dregs (+-) dregs (RND12)\n");
				  /* aopcde       HL                   */
		yyval.instr = DSP32ALU (   5,  IS_H(yyvsp[-7].reg),
		          /*   dst1     dst0     src0     src1 */
		                  0,     &yyvsp[-7].reg,     &yyvsp[-5].reg,     &yyvsp[-3].reg,
		          /*      s        x      aop          */
		                  0,       0,   yyvsp[-4].r0.r0          );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 45:
#line 1285 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg)) {
		    notethat("dsp32alu: dregs_half = dregs -+ dregs (RND20)\n");
				  /* aopcde       HL                   */
		yyval.instr = DSP32ALU (   5,  IS_H(yyvsp[-7].reg),
		          /*   dst1     dst0     src0     src1 */
		                  0,     &yyvsp[-7].reg,     &yyvsp[-5].reg,     &yyvsp[-3].reg,
		          /*      s        x      aop          */
		                  0,       1,   yyvsp[-4].r0.r0 | 2      );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 46:
#line 1300 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!REG_SAME(yyvsp[-1].reg, yyvsp[0].reg)) {
			notethat("dsp32alu: An = Am\n");
					  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (   8,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,       0,       0,       0,
					  /*      s        x      aop          */
						  IS_A1(yyvsp[-1].reg),   0,       3          );
		} else {
			return semantic_error("Accu reg arguments must differ");
		}
	}
    break;

  case 47:
#line 1315 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[0].reg)) {
		    notethat("dsp32alu: An = dregs\n");
					  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (   9,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,       0,     &yyvsp[0].reg,       0,
					  /*      s        x      aop          */
						      1,       0,   IS_A1(yyvsp[-1].reg) << 1 );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 48:
#line 1330 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!IS_H(yyvsp[-1].reg)) {
			if (yyvsp[-3].reg.regno == REG_A0x && IS_DREG(yyvsp[-1].reg)) {
				notethat("dsp32alu: A0.x = dregs_lo\n");
							  /* aopcde       HL                   */
				yyval.instr = DSP32ALU (   9,       0,
						  /*   dst1     dst0     src0     src1 */
								  0,       0,     &yyvsp[-1].reg,       0,
						  /*      s        x      aop          */
								  0,       0,       1          );
			} else
			if (yyvsp[-3].reg.regno == REG_A1x && IS_DREG(yyvsp[-1].reg)) {
				notethat("dsp32alu: A1.x = dregs_lo\n");
							  /* aopcde       HL                   */
				yyval.instr = DSP32ALU (   9,       0,
						  /*   dst1     dst0     src0     src1 */
								  0,       0,     &yyvsp[-1].reg,       0,
						  /*      s        x      aop          */
								  0,       0,       3          );
			} else
			if (IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
				notethat("ALU2op: dregs = dregs_lo\n");
				yyval.instr = ALU2OP (&yyvsp[-3].reg, &yyvsp[-1].reg, 10 | (yyvsp[0].r0.r0 ? 0: 1));   // dst, src, opc
			} else {
				return register_mismatch();
			}
		} else {
			return semantic_error("Low reg expected");
		}
	}
    break;

  case 49:
#line 1362 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("LDIMMhalf: pregs_half = sym32\n");
                /*      reg, H,  S,  Z  */
                yyval.instr = LDIMMHALF_R (&yyvsp[-2].reg, IS_H(yyvsp[-2].reg),  0,  0, yyvsp[0].expr);

	}
    break;

  case 50:
#line 1370 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("dsp32alu: An = 0\n");

		if (imm7(yyvsp[0].expr) != 0) return semantic_error("0 expected");

				  /* aopcde       HL                   */
		yyval.instr = DSP32ALU (   8,       0,
				  /*   dst1     dst0     src0     src1 */
						  0,       0,       0,       0,
				  /*      s        x      aop          */
						  0,       0,   IS_A1(yyvsp[-1].reg)       );
	}
    break;

  case 51:
#line 1386 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[0].r0.r0 == 0) { // Default: (x)
			/* 7 bit immediate value if possible.
                           We will check for that constant value for efficiency
                           If it goes to reloc, it will be 16 bit
                        */
			if(IS_CONST(yyvsp[-1].expr) && IS_IMM(yyvsp[-1].expr, 7) && (IS_DREG(yyvsp[-3].reg) || IS_PREG(yyvsp[-3].reg))){
				/* if the expr is a relocation, generate it */
				if (IS_DREG(yyvsp[-3].reg) && IS_IMM(yyvsp[-1].expr, 7)) {
					notethat("COMPI2opD: dregs = imm7 (x) \n");
					yyval.instr = COMPI2OPD (&yyvsp[-3].reg, imm7(yyvsp[-1].expr),  0);
				} else
				if (IS_PREG(yyvsp[-3].reg) && IS_IMM(yyvsp[-1].expr, 7)) {
					notethat("COMPI2opP: pregs = imm7 (x)\n");
					yyval.instr = COMPI2OPP (&yyvsp[-3].reg, imm7(yyvsp[-1].expr),  0);
				}
				else{
				  return semantic_error("Bad register or value for assigment");
				}
			}
			else{
				notethat("LDIMMhalf: regs = luimm16 (x)\n");
				/*      reg,   H,  S,  Z  */
				yyval.instr = LDIMMHALF_R5 (&yyvsp[-3].reg,   0,  1,  0, yyvsp[-1].expr);
			} 
		} else { // (z)
			/* there is no 7 bit zero extended instruction */
			/* if the expr is a relocation, generate it */
				notethat("LDIMMhalf: regs = luimm16 (x)\n");
				/*      reg,  H,  S,  Z  */
				yyval.instr = LDIMMHALF_R5 (&yyvsp[-3].reg,  0,  0,  1, yyvsp[-1].expr);
		}
	}
    break;

  case 52:
#line 1420 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_H(yyvsp[-2].reg)) return semantic_error("Low reg expected");

		if (IS_DREG(yyvsp[-2].reg) && yyvsp[0].reg.regno == REG_A0x) {
		    notethat("dsp32alu: dregs_lo = A0.x\n");
						  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (  10,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,     &yyvsp[-2].reg,       0,       0,
					  /*      s        x      aop          */
						      0,       0,       0          );
		} else
		if (IS_DREG(yyvsp[-2].reg) && yyvsp[0].reg.regno == REG_A1x) {
		    notethat("dsp32alu: dregs_lo = A1.x\n");
						  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (  10,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,     &yyvsp[-2].reg,       0,       0,
					  /*      s        x      aop          */
						      0,       0,       1          );

		} else {
			return register_mismatch();
		}
	}
    break;

  case 53:
#line 1449 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
		    notethat("dsp32alu: dregs = dregs .|. dregs (amod0)\n");
						  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (   0,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,     &yyvsp[-5].reg,     &yyvsp[-3].reg,     &yyvsp[-1].reg,
					  /*      s        x      aop          */
						  yyvsp[0].modcodes.s0,   yyvsp[0].modcodes.x0,   yyvsp[-2].r0.r0          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 54:
#line 1465 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
		    notethat("ALU2op: dregs = dregs_byte\n");
			yyval.instr = ALU2OP (&yyvsp[-3].reg, &yyvsp[-1].reg, 12 | (yyvsp[0].r0.r0 ? 0: 1));   // dst, src, opc
		} else {
			return register_mismatch();
		}
	}
    break;

  case 55:
#line 1475 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_SAME(yyvsp[-6].reg, yyvsp[-4].reg) && REG_SAME(yyvsp[-2].reg, yyvsp[0].reg) && !REG_SAME(yyvsp[-6].reg, yyvsp[-2].reg)) {
			notethat("dsp32alu: A1 = ABS A1 , A0 = ABS A0\n");
						  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (  16,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,       0,       0,       0,
					  /*      s        x      aop          */
							  0,       0,       3          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 56:
#line 1490 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_SAME(yyvsp[-6].reg, yyvsp[-4].reg) && REG_SAME(yyvsp[-2].reg, yyvsp[0].reg) && !REG_SAME(yyvsp[-6].reg, yyvsp[-2].reg)) {
			notethat("dsp32alu: A1 = - A1 , A0 = - A0\n");

					  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (  14,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,       0,       0,       0,
					  /*      s        x      aop          */
							  0,       0,       3          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 57:
#line 1506 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!IS_A1(yyvsp[-2].reg) && IS_A1(yyvsp[-1].reg)) {
			notethat("dsp32alu: A0 -= A1\n");
					  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (  11,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,       0,       0,       0,
					  /*      s        x      aop          */
						  yyvsp[0].r0.r0,       0,       3          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 58:
#line 1521 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IREG(yyvsp[-2].reg) && EXPR_VALUE(yyvsp[0].expr) == 4) {
		    notethat("dagMODik: iregs -= 4\n");
			yyval.instr = DAGMODIK (&yyvsp[-2].reg, 3);
		} else
		if (IS_IREG(yyvsp[-2].reg) && EXPR_VALUE(yyvsp[0].expr) == 2) {
		    notethat("dagMODik: iregs -= 2\n");
			yyval.instr = DAGMODIK (&yyvsp[-2].reg, 1);
		} else {
			return semantic_error("Register or value mismatch");
		}
	}
    break;

  case 59:
#line 1535 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IREG(yyvsp[-5].reg) && IS_MREG(yyvsp[-3].reg)) {
		    notethat("dagMODim: iregs += mregs (opt_brev)\n");
				/*         i          m  op  br */
			yyval.instr = DAGMODIM (&yyvsp[-5].reg, &yyvsp[-3].reg,  0,  1);
		} else
		if (IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-3].reg)) {
		    notethat("PTR2op: pregs += pregs ( BREV )\n");
			yyval.instr = PTR2OP (&yyvsp[-5].reg, &yyvsp[-3].reg, 5);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 60:
#line 1550 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IREG(yyvsp[-2].reg) && IS_MREG(yyvsp[0].reg)) {
		    notethat("dagMODim: iregs -= mregs\n");
				/*         i          m  op  br */
			yyval.instr = DAGMODIM (&yyvsp[-2].reg, &yyvsp[0].reg,  1,  0);
		} else
		if (IS_PREG(yyvsp[-2].reg) && IS_PREG(yyvsp[0].reg)) {
		    notethat("PTR2op: pregs -= pregs\n");
			yyval.instr = PTR2OP (&yyvsp[-2].reg, &yyvsp[0].reg, 0);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 61:
#line 1565 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!IS_A1(yyvsp[-3].reg) && IS_A1(yyvsp[-1].reg)) {
			notethat("dsp32alu: A0 += A1 (W32)\n");

					  /* aopcde       HL                   */
			yyval.instr = DSP32ALU (  11,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,       0,       0,       0,
					  /*      s        x      aop          */
						  yyvsp[0].r0.r0,       0,       2          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 62:
#line 1581 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IREG(yyvsp[-2].reg) && IS_MREG(yyvsp[0].reg)) {
		    notethat("dagMODim: iregs += mregs\n");
			            /*         i          m  op  br */
			yyval.instr = DAGMODIM (&yyvsp[-2].reg, &yyvsp[0].reg,  0,  0);
		} else {
			return semantic_error("iregs += mregs expected");
		}
	}
    break;

  case 63:
#line 1592 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IREG(yyvsp[-2].reg)) {
			if (EXPR_VALUE(yyvsp[0].expr) == 4) {
				notethat("dagMODik: iregs += 4\n");
				yyval.instr = DAGMODIK (&yyvsp[-2].reg, 2);
			} else
			if (EXPR_VALUE(yyvsp[0].expr) == 2) {
				notethat("dagMODik: iregs += 2\n");
				yyval.instr = DAGMODIK (&yyvsp[-2].reg, 0);
			} else {
				return semantic_error("iregs += [ 2 | 4 ");
			}
		} else
		if (IS_PREG(yyvsp[-2].reg) && IS_IMM(yyvsp[0].expr, 7)) {
		    notethat("COMPI2opP: pregs += imm7\n");
			yyval.instr = COMPI2OPP (&yyvsp[-2].reg, imm7(yyvsp[0].expr),  1);
		} else
		if (IS_DREG(yyvsp[-2].reg) && IS_IMM(yyvsp[0].expr, 7)) {
		    notethat("COMPI2opD: dregs += imm7\n");
			yyval.instr = COMPI2OPD (&yyvsp[-2].reg, imm7(yyvsp[0].expr),  1);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 64:
#line 1618 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("ALU2op: dregs *= dregs\n");
			yyval.instr = ALU2OP (&yyvsp[-2].reg, &yyvsp[0].reg, 3);   // dst, src, opc
		} else {
			return register_mismatch();
		}
	}
    break;

  case 65:
#line 1628 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-8].reg) && IS_DREG(yyvsp[-4].reg)) {
		    notethat("dsp32alu: SAA ( dregs_pair , dregs_pair ) (aligndir)\n");
			          /* aopcde       HL                   */
		yyval.instr = DSP32ALU (  18,       0,
		          /*   dst1     dst0     src0     src1 */
		                  0,       0,     &yyvsp[-8].reg,     &yyvsp[-4].reg,
		          /*      s        x      aop          */
		             yyvsp[0].r0.r0,       0,       0          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 66:
#line 1643 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_SAME(yyvsp[-10].reg, yyvsp[-9].reg) && REG_SAME(yyvsp[-4].reg, yyvsp[-3].reg) && !REG_SAME(yyvsp[-10].reg, yyvsp[-4].reg)) {

			notethat("dsp32alu: A1 = A1 (S) , A0 = A0 (S)\n");
			yyval.instr = DSP32ALU (   8,       0,
					  /*   dst1     dst0     src0     src1 */
							  0,       0,       0,       0,
					  /*      s        x      aop          */
							  1,       0,       2          );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 67:
#line 1658 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-8].reg) && IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg)
		 && REG_SAME(yyvsp[-8].reg, yyvsp[-5].reg)) {
		 	if (EXPR_VALUE(yyvsp[0].expr) == 1) {
				notethat("ALU2op: dregs = (dregs + dregs) << 1\n");
				yyval.instr = ALU2OP (&yyvsp[-8].reg, &yyvsp[-3].reg, 4);   // dst, src, opc
			} else
		 	if (EXPR_VALUE(yyvsp[0].expr) == 2) {
				notethat("ALU2op: dregs = (dregs + dregs) << 2\n");
				yyval.instr = ALU2OP (&yyvsp[-8].reg, &yyvsp[-3].reg, 5);   // dst, src, opc
			} else {
				return semantic_error("Bad shift value");
			}
		} else
		if (IS_PREG(yyvsp[-8].reg) && IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-3].reg)
		 && REG_SAME(yyvsp[-8].reg, yyvsp[-5].reg)) {
		 	if (EXPR_VALUE(yyvsp[0].expr) == 1) {
				notethat("PTR2op: pregs = (pregs + pregs) << 1\n");
				yyval.instr = PTR2OP (&yyvsp[-8].reg, &yyvsp[-3].reg, 6);
			} else
		 	if (EXPR_VALUE(yyvsp[0].expr) == 2) {
				notethat("PTR2op: pregs = (pregs + pregs) << 2\n");
				yyval.instr = PTR2OP (&yyvsp[-8].reg, &yyvsp[-3].reg, 7);
			} else {
				return semantic_error("Bad shift value");
			}
		} else {
			return register_mismatch();
		}
	}
    break;

  case 68:
#line 1696 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-4].reg) && IS_DREG(yyvsp[-2].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("COMP3op: dregs = dregs | dregs\n");
			yyval.instr = COMP3OP (&yyvsp[-4].reg, &yyvsp[-2].reg, &yyvsp[0].reg, 3);
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 69:
#line 1706 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-4].reg) && IS_DREG(yyvsp[-2].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("COMP3op: dregs = dregs ^ dregs\n");
			yyval.instr = COMP3OP (&yyvsp[-4].reg, &yyvsp[-2].reg, &yyvsp[0].reg, 4);
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 70:
#line 1716 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-8].reg) && IS_PREG(yyvsp[-6].reg) && IS_PREG(yyvsp[-3].reg)) {
			if (EXPR_VALUE(yyvsp[-1].expr) == 1) {
				notethat("COMP3op: pregs = pregs + (pregs << 1)\n");
				yyval.instr = COMP3OP (&yyvsp[-8].reg, &yyvsp[-6].reg, &yyvsp[-3].reg, 6);
			} else 
			if (EXPR_VALUE(yyvsp[-1].expr) == 2) {
				notethat("COMP3op: pregs = pregs + (pregs << 2)\n");
				yyval.instr = COMP3OP (&yyvsp[-8].reg, &yyvsp[-6].reg, &yyvsp[-3].reg, 7);
			} else {
				return semantic_error("Bad shift value");
			}
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 71:
#line 1734 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!REG_SAME(yyvsp[-2].reg, yyvsp[0].reg)) {
		    notethat("CCflag: CC = A0 == A1\n");
					/*    x       y      opc     I     G   */
			yyval.instr = CCFLAG ( 0,      0,       5,    0,    0   );
		} else {
			return semantic_error("CC register expected");
		}
	}
    break;

  case 72:
#line 1745 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!REG_SAME(yyvsp[-2].reg, yyvsp[0].reg)) {
		    notethat("CCflag: CC = A0 < A1\n");
			        /*   x     y     opc     I     G   */
			yyval.instr = CCFLAG (0,    0,      6,    0,    0   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 73:
#line 1757 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_CLASS(yyvsp[-3].reg) == REG_CLASS(yyvsp[-1].reg)) {
		    notethat("CCflag: CC = dpregs < dpregs\n");
			        /*    x       y        opc     I     G   */
			yyval.instr = CCFLAG (&yyvsp[-3].reg, yyvsp[-1].reg.regno & CODE_MASK, yyvsp[0].r0.r0,    0,  IS_PREG(yyvsp[-3].reg) ? 1 : 0 );
		} else {
			return semantic_error("Compare only of same register class");
		}
	}
    break;

  case 74:
#line 1769 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if ( (IS_IMM(yyvsp[-1].expr, 3) && yyvsp[0].r0.r0 == 1) || IS_UIMM(yyvsp[-1].expr, 3) ) {
			notethat("CCflag: CC = dpregs < (u)imm3\n");
					/*    x       y         opc     I     G   */
			yyval.instr = CCFLAG (&yyvsp[-3].reg, imm3(yyvsp[-1].expr), yyvsp[0].r0.r0,    1,  IS_PREG(yyvsp[-3].reg) ? 1 : 0 );
		} else {
			return semantic_error("Bad constant range");
		}
	}
    break;

  case 75:
#line 1780 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_CLASS(yyvsp[-2].reg) == REG_CLASS(yyvsp[0].reg)) {
			notethat("CCflag: CC = dpregs == dpregs\n");
					/*    x       y        opc     I     G   */
			yyval.instr = CCFLAG (&yyvsp[-2].reg, yyvsp[0].reg.regno & CODE_MASK,    0,    0,  IS_PREG(yyvsp[-2].reg) ? 1 : 0 );
		} 
	}
    break;

  case 76:
#line 1789 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IMM(yyvsp[0].expr, 3)) {
			notethat("CCflag: CC = dpregs == imm3\n");
					/*    x       y         opc     I     G   */
			yyval.instr = CCFLAG (&yyvsp[-2].reg, imm3(yyvsp[0].expr),    0,    1, IS_PREG(yyvsp[-2].reg) ? 1 : 0 );
		} else {
			return semantic_error("Bad constant range");
		}
	}
    break;

  case 77:
#line 1800 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!REG_SAME(yyvsp[-2].reg, yyvsp[0].reg)) {
		    notethat("CCflag: CC = A0 <= A1\n");
					/*    x       y         opc     I     G   */
			yyval.instr = CCFLAG ( 0,      0,          7,    0,    0   );
		} else {
			return semantic_error("CC register expected");
		}
	}
    break;

  case 78:
#line 1812 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_CLASS(yyvsp[-3].reg) == REG_CLASS(yyvsp[-1].reg)) {
			notethat("CCflag: CC = pregs <= pregs (..)\n");
					/*    x       y     opc     I     G   */
			yyval.instr = CCFLAG (&yyvsp[-3].reg, yyvsp[-1].reg.regno & CODE_MASK,
			                           1+yyvsp[0].r0.r0, 0, IS_PREG(yyvsp[-3].reg) ? 1 : 0 );

		} else {
			return semantic_error("Compare only of same register class");
		}
	}
    break;

  case 79:
#line 1825 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if ( (IS_IMM(yyvsp[-1].expr, 3) && yyvsp[0].r0.r0 == 1) || IS_UIMM(yyvsp[-1].expr, 3) ) {
			if (IS_DREG(yyvsp[-3].reg)) {
				notethat("CCflag: CC = dregs <= imm3\n");
						/*    x       y     opc     I     G   */
				yyval.instr = CCFLAG (&yyvsp[-3].reg, imm3(yyvsp[-1].expr), 1+yyvsp[0].r0.r0,    1,    0   );
			} else
			if (IS_PREG(yyvsp[-3].reg)) {
				notethat("CCflag: CC = pregs <= imm3\n");
						/*    x       y     opc     I     G   */
				yyval.instr = CCFLAG (&yyvsp[-3].reg, imm3(yyvsp[-1].expr), 1+yyvsp[0].r0.r0,    1,    1   );
			} else {
				return semantic_error("Dreg or Preg expected");
			}
		} else {
			return semantic_error("Bad constant value");
		}
	}
    break;

  case 80:
#line 1845 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-4].reg) && IS_DREG(yyvsp[-2].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("COMP3op: dregs = dregs & dregs\n");
			yyval.instr = COMP3OP (&yyvsp[-4].reg, &yyvsp[-2].reg, &yyvsp[0].reg, 2);
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 81:
#line 1855 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("CC2stat operation\n");
		yyval.instr = gen_cc2stat(yyvsp[0].modcodes.r0, yyvsp[0].modcodes.x0, yyvsp[0].modcodes.s0); // cbit, op, D
	}
    break;

  case 82:
#line 1861 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_ALLREG(yyvsp[-2].reg) && IS_ALLREG(yyvsp[0].reg)) {
		    notethat("REGMV: allregs = allregs\n");
			yyval.instr = gen_regmv(&yyvsp[0].reg, &yyvsp[-2].reg);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 83:
#line 1871 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {

		if (IS_DREG(yyvsp[0].reg)) {
		    notethat("CC2dreg: CC = dregs\n");
			yyval.instr = gen_cc2dreg(1, &yyvsp[0].reg);
		} else
			return register_mismatch();
	}
    break;

  case 84:
#line 1881 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg)) {
		    notethat("CC2dreg: dregs = CC\n");
			yyval.instr = gen_cc2dreg(0, &yyvsp[-2].reg);
		} else
			return register_mismatch();
	}
    break;

  case 85:
#line 1890 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("CC2dreg: CC =! CC\n");
		yyval.instr = gen_cc2dreg(3, 0);
	}
    break;

  case 86:
#line 1900 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("dsp32mult: dregs_half = multfunc (opt_mode)\n");

		if (!IS_H(yyvsp[-3].reg) && yyvsp[0].mod.MM) { // not allowed
			return semantic_error("(M) not allowed with MAC0");
		}

		if (IS_H(yyvsp[-3].reg)) {
						   /*   op1     MM      mmod  */
			yyval.instr = DSP32MULT (     0,  yyvsp[0].mod.MM,   yyvsp[0].mod.mod,              /* w1  P */
						   /*   h01    h11       h00    h10 */         1, 0,
							   IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1),   0,   0,
									 &yyvsp[-3].reg,  // dst (dregs)
						   /*  op0    src0    src1  w0  */
								 0, &yyvsp[-1].macfunc.s0, &yyvsp[-1].macfunc.s1,  0                   );
		} else {
						   /*   op1     MM      mmod  */
			yyval.instr = DSP32MULT (     0,      0,   yyvsp[0].mod.mod,              /* w1  P */
						   /*   h01    h11       h00    h10 */         0, 0,
							    0,   0, IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1),  
									 &yyvsp[-3].reg,  // dst (dregs)
						   /*  op0    src0    src1  w0  */
								 0, &yyvsp[-1].macfunc.s0, &yyvsp[-1].macfunc.s1,  1                   );
		}	
	}
    break;

  case 87:
#line 1927 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		// Odd registers can use (M)
		if (!IS_DREG(yyvsp[-3].reg)) return semantic_error("Dreg expected");

		if (!IS_EVEN(yyvsp[-3].reg)) {
		    notethat("dsp32mult: dregs = multfunc (opt_mode)\n");

			               /*   op1       MM      mmod  */
			yyval.instr = DSP32MULT (      0,   yyvsp[0].mod.MM,   yyvsp[0].mod.mod,         /* w1  P */
			               /*   h01    h11       h00      h10 */    1, 1,
						   IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1),      0,     0,
			                     &yyvsp[-3].reg,  // dst (dregs)
					   /*  op0    src0    src1  w0  */
						     0, &yyvsp[-1].macfunc.s0, &yyvsp[-1].macfunc.s1,  0                   );
		} else
		if (yyvsp[0].mod.MM == 0) {
		    notethat("dsp32mult: dregs = multfunc opt_mode\n");
			               /*   op1       MM      mmod  */
			yyval.instr = DSP32MULT (      0,       0,   yyvsp[0].mod.mod,         /* w1  P */
			               /*   h01    h11       h00      h10 */    0, 1,
						       0,     0,  IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1),  
			                     &yyvsp[-3].reg,  // dst (dregs)
					   /*  op0    src0    src1  w0  */
						     0, &yyvsp[-1].macfunc.s0, &yyvsp[-1].macfunc.s1,  1                   );
		} else {
			return semantic_error("Register or mode mismatch");
		}
	}
    break;

  case 88:
#line 1957 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!IS_DREG(yyvsp[-8].reg) || !IS_DREG(yyvsp[-3].reg)) 
			return semantic_error("Dregs expected");

		if (check_multfuncs(&yyvsp[-6].macfunc, &yyvsp[-1].macfunc) < 0) return -1;

		if (IS_H(yyvsp[-8].reg) && !IS_H(yyvsp[-3].reg)) {
		    notethat("dsp32mult: dregs_hi = multfunc mxd_mod, "
			         "dregs_lo = multfunc opt_mode\n");
			               /*   op1       MM      mmod  */
			yyval.instr = DSP32MULT (      0,   yyvsp[-5].mod.MM,   yyvsp[0].mod.mod,         /* w1  P */
			               /*   h01    h11       h00      h10 */    1, 0,
						   IS_H(yyvsp[-6].macfunc.s0), IS_H(yyvsp[-6].macfunc.s1), IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1),
			                     &yyvsp[-8].reg,  // dst (dregs)
					   /*  op0    src0    src1  w0  */
						     0, &yyvsp[-6].macfunc.s0, &yyvsp[-6].macfunc.s1,  1                   );
		} else 
		if (!IS_H(yyvsp[-8].reg) && IS_H(yyvsp[-3].reg) && yyvsp[-5].mod.MM == 0) {
			               /*   op1       MM      mmod  */
			yyval.instr = DSP32MULT (      0,   yyvsp[0].mod.MM,   yyvsp[0].mod.mod,         /* w1  P */
			               /*   h01    h11       h00      h10 */    1, 0,
						   IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1), IS_H(yyvsp[-6].macfunc.s0), IS_H(yyvsp[-6].macfunc.s1),
			                     &yyvsp[-8].reg,  // dst (dregs)
					   /*  op0    src0    src1  w0  */
						     0, &yyvsp[-6].macfunc.s0, &yyvsp[-6].macfunc.s1,  1                   );
		} else {
			return semantic_error("Multfunc Register or mode mismatch");
		}
	}
    break;

  case 89:
#line 1988 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (check_multfuncs(&yyvsp[-6].macfunc, &yyvsp[-1].macfunc) < 0) return -1;

		if (!IS_DREG(yyvsp[-8].reg) || !IS_DREG(yyvsp[-3].reg)) 
			return semantic_error("Dregs expected");

		notethat("dsp32mult: dregs = multfunc mxd_mod, "
		         "dregs = multfunc opt_mode\n");
		if (IS_EVEN(yyvsp[-8].reg)) {
			if ( yyvsp[-3].reg.regno - yyvsp[-8].reg.regno != 1 || yyvsp[-5].mod.MM != 0)
				return semantic_error("Dest registers or mode mismatch");

						   /*   op1       MM      mmod  */
			yyval.instr = DSP32MULT (      0,       0,   yyvsp[0].mod.mod,         /* w1  P */
							/*   h01    h11       h00      h10 */   1, 1,
						IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1), IS_H(yyvsp[-6].macfunc.s0), IS_H(yyvsp[-6].macfunc.s1),
							 &yyvsp[-8].reg,
					   /* op0    src0    src1  w0  */
							0, &yyvsp[-6].macfunc.s0, &yyvsp[-6].macfunc.s1,  1                   );

		} else {
			if ( yyvsp[-8].reg.regno - yyvsp[-3].reg.regno != 1 ) 
				return semantic_error("Dest registers mismatch");

						   /*   op1       MM      mmod  */
			yyval.instr = DSP32MULT (      0,   yyvsp[0].mod.MM,   yyvsp[0].mod.mod,         /* w1  P */
							/*   h01    h11       h00      h10 */   1, 1,
						  IS_H(yyvsp[-6].macfunc.s0), IS_H(yyvsp[-6].macfunc.s1), IS_H(yyvsp[-1].macfunc.s0), IS_H(yyvsp[-1].macfunc.s1),
							 &yyvsp[-8].reg,
					   /* op0    src0    src1  w0  */
							0, &yyvsp[-6].macfunc.s0, &yyvsp[-6].macfunc.s1,  1                   );
		}
	}
    break;

  case 90:
#line 2032 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!REG_SAME(yyvsp[-4].reg, yyvsp[-2].reg)) {
			return semantic_error("Aregs must be same");
		}
		if (IS_DREG(yyvsp[0].reg) && !IS_H(yyvsp[0].reg)) {
		    notethat("dsp32shift: A0 = ASHIFT A0 BY dregs_lo\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       3,     0,     &yyvsp[0].reg,       0,
						  /*      sop      HLs */
									0,  IS_A1(yyvsp[-4].reg)                 );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 91:
#line 2049 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-1].reg) && !IS_H(yyvsp[-1].reg)) {
		    notethat("dsp32shift: dregs_half = ASHIFT dregs_half BY dregs_lo\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       0,   &yyvsp[-6].reg,     &yyvsp[-1].reg,     &yyvsp[-3].reg,
						  /*      sop      HLs */
								yyvsp[0].modcodes.s0,  HL2(yyvsp[-6].reg, yyvsp[-3].reg)     );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 92:
#line 2063 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!REG_SAME(yyvsp[-3].reg, yyvsp[-2].reg)) {
			return semantic_error("Aregs must be same");
		}
		if (IS_UIMM(yyvsp[0].expr, 5)) {
		    notethat("dsp32shiftimm: A0 = A0 << uimm5\n");
							/*   sopcde   dst0      immag     src1 */
			yyval.instr = DSP32SHIFTIMM (      3,   &yyvsp[-3].reg,  imm6(yyvsp[0].expr),    0,
							/*      sop      HLs */
									  0,   IS_A1(yyvsp[-3].reg)                 );
		} else {
			return semantic_error("Bad shift value");
		}

	}
    break;

  case 93:
#line 2081 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5)) {
			if (yyvsp[0].modcodes.r0) { // vector ?
				notethat("dsp32shiftimm: dregs = dregs << expr (V, .)\n");
				                /*   sopcde   dst0      immag     src1 */
				yyval.instr = DSP32SHIFTIMM (      1,   &yyvsp[-5].reg,  imm5(yyvsp[-1].expr),     &yyvsp[-3].reg,
				                /*      sop      HLs */
				                      yyvsp[0].modcodes.s0,       0                      );

			} else {
				notethat("dsp32shiftimm: dregs =  dregs << uimm5 (.)\n");
								/*   sopcde   dst0      immag     src1 */
				yyval.instr = DSP32SHIFTIMM (      2,   &yyvsp[-5].reg,  imm6(yyvsp[-1].expr),     &yyvsp[-3].reg,
								/*      sop      HLs */
				               yyvsp[0].modcodes.s0 ? 1: 2,       0                     );
			}
		} else

		if (yyvsp[0].modcodes.s0 == 0 && IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-3].reg)) {
			if (EXPR_VALUE(yyvsp[-1].expr) == 2) {
				notethat("PTR2op: pregs = pregs << 2\n");
				yyval.instr = PTR2OP (&yyvsp[-5].reg, &yyvsp[-3].reg, 1);
			} else
			if (EXPR_VALUE(yyvsp[-1].expr) == 1) {
				notethat("COMP3op: pregs = pregs << 1\n");
				yyval.instr = COMP3OP (&yyvsp[-5].reg, &yyvsp[-3].reg, &yyvsp[-3].reg, 5);
			} else {
				return semantic_error("Bad shift value");
			}
		} else {
			return semantic_error("Bad shift value or register");
		}
	}
    break;

  case 94:
#line 2117 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_UIMM(yyvsp[-1].expr, 4)) {
		    notethat("dsp32shiftimm: dregs_half = dregs_half << uimm4\n");
			                /*   sopcde   dst0      immag     src1  */
			yyval.instr = DSP32SHIFTIMM (      0,   &yyvsp[-5].reg,  imm5(yyvsp[-1].expr),     &yyvsp[-3].reg,
		                    /*      sop      HLs */
			                      yyvsp[0].modcodes.s0, HL2(yyvsp[-5].reg, yyvsp[-3].reg)  );
		} else {
			return semantic_error("Bad shift value");
		}
	}
    break;

  case 95:
#line 2131 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		int op;

		if (IS_DREG(yyvsp[-6].reg) && IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg) && !IS_H(yyvsp[-1].reg)) {
			if (yyvsp[0].modcodes.r0) {
				op = 1;
				notethat("dsp32shift: dregs = ASHIFT dregs BY "
				         "dregs_lo (V, .)\n");
			} else {
				op = 2;
				notethat("dsp32shift: dregs = ASHIFT dregs BY dregs_lo (.)\n");
			}
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      op,   &yyvsp[-6].reg,     &yyvsp[-1].reg,     &yyvsp[-3].reg,
						  /*      sop      HLs */
								yyvsp[0].modcodes.s0,       0                    );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 96:
#line 2155 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[-8].reg) && IS_DREG_L(yyvsp[-4].reg) && IS_DREG_L(yyvsp[-2].reg)) {
		    notethat("dsp32shift: dregs_lo = EXPADJ ( dregs , dregs_lo )\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       7,   &yyvsp[-8].reg,     &yyvsp[-2].reg,     &yyvsp[-4].reg,
						  /*      sop      HLs */
								yyvsp[0].r0.r0,       0                    );
		} else {
			return semantic_error("Bad shift value or register");
		}
	}
    break;

  case 97:
#line 2169 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[-7].reg) && IS_DREG_L(yyvsp[-3].reg) && IS_DREG_L(yyvsp[-1].reg)) {
		    notethat("dsp32shift: dregs_lo = EXPADJ (dregs_lo, dregs_lo)\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       7,   &yyvsp[-7].reg,     &yyvsp[-1].reg,     &yyvsp[-3].reg,
						  /*      sop      HLs */
									2,       0                    );
		} else 
		if (IS_DREG_L(yyvsp[-7].reg) && IS_DREG_H(yyvsp[-3].reg) && IS_DREG_L(yyvsp[-1].reg)) {
		    notethat("dsp32shift: dregs_lo = EXPADJ (dregs_hi, dregs_lo)\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       7,   &yyvsp[-7].reg,     &yyvsp[-1].reg,     &yyvsp[-3].reg,
						  /*      sop      HLs */
									3,       0                    );
		} else {
			return semantic_error("Bad shift value or register");
		}
	}
    break;

  case 98:
#line 2191 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-7].reg) && IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
		    notethat("dsp32shift: dregs = DEPOSIT ( dregs , dregs )\n");
		              /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      10,   &yyvsp[-7].reg,     &yyvsp[-1].reg,     &yyvsp[-3].reg,
					  /*      sop      HLs */
							    2,       0                    );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 99:
#line 2204 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-10].reg) && IS_DREG(yyvsp[-6].reg) && IS_DREG(yyvsp[-4].reg)) {
		    notethat("dsp32shift: dregs = DEPOSIT ( dregs , dregs ) (X)\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      10,   &yyvsp[-10].reg,     &yyvsp[-4].reg,     &yyvsp[-6].reg,
						  /*      sop      HLs */
									3,       0                    );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 100:
#line 2217 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-8].reg) && IS_DREG(yyvsp[-4].reg) && IS_DREG_L(yyvsp[-2].reg)) {
		    notethat("dsp32shift: dregs = EXTRACT ( dregs ,dregs_lo ) (.)\n");
		              /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      10,   &yyvsp[-8].reg,     &yyvsp[-2].reg,     &yyvsp[-4].reg,
			          /*      sop      HLs */
			                yyvsp[0].r0.r0,       0                    );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 101:
#line 2230 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!REG_SAME(yyvsp[-3].reg, yyvsp[-2].reg))
			return semantic_error("Aregs must be same");
		if (IS_UIMM(yyvsp[0].expr, 5)) {
			notethat("dsp32shiftimm: Ax = Ax >>> uimm5\n");
							/*   sopcde   dst0      immag     src1 */
			yyval.instr = DSP32SHIFTIMM (      3,     0,  -uimm5(yyvsp[0].expr),    0,
							/*      sop    HLs                     */
									  0,  IS_A1(yyvsp[-3].reg)                );
		} else {
			return semantic_error("Shift value range error");
		}
	}
    break;

  case 102:
#line 2246 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_SAME(yyvsp[-4].reg, yyvsp[-2].reg) && IS_DREG_L(yyvsp[0].reg)) {
		    notethat("dsp32shift: Ax = LSHIFT Ax BY dregs_lo\n");
					      /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       3,     0,     &yyvsp[0].reg,       0,
			              /*      sop    HLs                   */
			                        1,  IS_A1(yyvsp[-4].reg)              );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 103:
#line 2259 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-2].reg) && IS_DREG_L(yyvsp[0].reg)) {

		    notethat("dsp32shift: dregs_lo = LSHIFT dregs_hi BY dregs_lo\n");
					      /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       0,   &yyvsp[-5].reg,     &yyvsp[0].reg,     &yyvsp[-2].reg,
			              /*      sop    HLs                   */
			                        2,  HL2(yyvsp[-5].reg, yyvsp[-2].reg)     );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 104:
#line 2273 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {

		if (IS_DREG(yyvsp[-6].reg) && IS_DREG(yyvsp[-3].reg) && IS_DREG_L(yyvsp[-1].reg)) {

		    notethat("dsp32shift: dregs = LSHIFT dregs BY dregs_lo ( V )\n");

					      /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT ( yyvsp[0].r0.r0 ? 1: 2, &yyvsp[-6].reg, &yyvsp[-1].reg,   &yyvsp[-3].reg,
			              /*      sop      HLs */
			                        2,       0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 105:
#line 2289 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-2].reg) && IS_DREG_L(yyvsp[0].reg)) {
		    notethat("dsp32shift: dregs = SHIFT dregs BY dregs_lo\n");
					      /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       2,   &yyvsp[-5].reg,     &yyvsp[0].reg,     &yyvsp[-2].reg,
			              /*      sop      HLs */
			                        2,       0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 106:
#line 2302 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_SAME(yyvsp[-3].reg, yyvsp[-2].reg) && IS_IMM(yyvsp[0].expr, 6)>=0 ) {
		    notethat("dsp32shiftimm: Ax = Ax >> imm6\n");
			                /*   sopcde   dst0      immag     src1 */
			yyval.instr = DSP32SHIFTIMM (      3,     0,  -imm6(yyvsp[0].expr),      0,
			                /*      sop      HLs */
			                          1,   IS_A1(yyvsp[-3].reg)                 );
		} else {
			return semantic_error("Accu register expected");
		}
	}
    break;

  case 107:
#line 2315 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[0].r0.r0 == 1) {
			if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5) ) {
				notethat("dsp32shiftimm: dregs = dregs >> uimm5 (V)\n");
								/*   sopcde     dst0      immag     src1 */
				yyval.instr = DSP32SHIFTIMM (      1,     &yyvsp[-5].reg, -uimm5(yyvsp[-1].expr),    &yyvsp[-3].reg,
								/*      sop      HLs */
										  2,       0                     );
			} else {
				return register_mismatch();
			}
		} else {
			if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5)) {
				notethat("dsp32shiftimm: dregs = dregs >> uimm5\n");
								/*   sopcde     dst0      immag     src1 */
				yyval.instr = DSP32SHIFTIMM (      2,     &yyvsp[-5].reg,  -imm6(yyvsp[-1].expr),    &yyvsp[-3].reg,
								/*      sop      HLs */
										  2,       0                     );
			} else
			if (IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-3].reg)
			 && EXPR_VALUE(yyvsp[-1].expr) == 2) {
				notethat("PTR2op: pregs = pregs >> 2\n");
					yyval.instr = PTR2OP (&yyvsp[-5].reg, &yyvsp[-3].reg, 3);
			} else
			if (IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-3].reg)
			 && EXPR_VALUE(yyvsp[-1].expr) == 1) {
				notethat("PTR2op: pregs = pregs >> 1\n");
					yyval.instr = PTR2OP (&yyvsp[-5].reg, &yyvsp[-3].reg, 4);

			} else {
				return register_mismatch();
			}
		}
	}
    break;

  case 108:
#line 2352 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_UIMM(yyvsp[0].expr, 5) ) {
		    notethat("dsp32shiftimm:  dregs_half =  dregs_half >> uimm5\n");

			                /*   sopcde     dst0      immag     src1 */
			yyval.instr = DSP32SHIFTIMM (      0,     &yyvsp[-4].reg, -uimm5(yyvsp[0].expr),    &yyvsp[-2].reg,
			                /*      sop      HLs */
			                          2,  HL2(yyvsp[-4].reg, yyvsp[-2].reg)   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 109:
#line 2367 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_UIMM(yyvsp[-1].expr, 5)) {
		    notethat("dsp32shiftimm: dregs_half = dregs_half >>> uimm5\n");
			                /*   sopcde     dst0      immag     src1 */
			yyval.instr = DSP32SHIFTIMM (      0,     &yyvsp[-5].reg, -uimm5(yyvsp[-1].expr),    &yyvsp[-3].reg,
			                /*      sop      HLs */
			                      yyvsp[0].modcodes.s0,   HL2(yyvsp[-5].reg, yyvsp[-3].reg) );
		} else {
			return semantic_error("Register or modifier mismatch");
		}
	}
    break;

  case 110:
#line 2381 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5) ) {
			if (yyvsp[0].modcodes.r0) { // Vector ?
				notethat("dsp32shiftimm: dregs  =  dregs >>> uimm5 (V, .)\n");
								/*  sopcde     dst0      immag     src1 */
				yyval.instr = DSP32SHIFTIMM (     1,      &yyvsp[-5].reg, -uimm5(yyvsp[-1].expr),   &yyvsp[-3].reg,
								/*      sop      HLs */
									 yyvsp[0].modcodes.s0,       0                      );

			} else {
				notethat("dsp32shiftimm: dregs  =  dregs >>> uimm5 (.)\n");
								/*  sopcde     dst0      immag     src1 */
				yyval.instr = DSP32SHIFTIMM (     2,     &yyvsp[-5].reg, -uimm5(yyvsp[-1].expr),    &yyvsp[-3].reg,
								/*      sop      HLs */
									 yyvsp[0].modcodes.s0,       0                      );
			}
		} else {
			return register_mismatch();
		}
	}
    break;

  case 111:
#line 2403 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[-3].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("dsp32shift: dregs_lo = ONES dregs\n");
					      /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       6,   &yyvsp[-3].reg,       0,     &yyvsp[0].reg,
			              /*      sop      HLs */
			                        3,       0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 112:
#line 2417 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-7].reg) && IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
		    notethat("dsp32shift: dregs = PACK ( dregs_hi , dregs_hi )\n");
					      /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       4,   &yyvsp[-7].reg,     &yyvsp[-1].reg,     &yyvsp[-3].reg,
			              /*      sop      HLs */
			                HL2(yyvsp[-3].reg, yyvsp[-1].reg),     0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 113:
#line 2430 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-9].reg)
		 && yyvsp[-3].reg.regno == REG_A0
		 && IS_DREG(yyvsp[-1].reg) && !IS_H(yyvsp[-9].reg) && !IS_A1(yyvsp[-3].reg)) {
		    notethat("dsp32shift: dregs_lo = CC = BXORSHIFT ( A0 , dregs )\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      11,   &yyvsp[-9].reg,     &yyvsp[-1].reg,       0,
			              /*      sop      HLs */
			                        0,       0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 114:
#line 2445 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-9].reg)
		 && yyvsp[-3].reg.regno == REG_A0
		 && IS_DREG(yyvsp[-1].reg) && !IS_H(yyvsp[-9].reg) && !IS_A1(yyvsp[-3].reg)) {
		    notethat("dsp32shift: dregs_lo = CC = BXOR (A0 , dregs)\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      11,   &yyvsp[-9].reg,     &yyvsp[-1].reg,       0,
			              /*      sop      HLs */
			                        1,       0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 115:
#line 2460 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-11].reg) && !IS_H(yyvsp[-11].reg) && !REG_SAME(yyvsp[-5].reg, yyvsp[-3].reg)) {
		    notethat("dsp32shift: dregs_lo = CC = BXOR (A0 , A1 , CC)\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      12,  &yyvsp[-11].reg,       0,       0,
			              /*      sop      HLs */
			                        1,       0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 116:
#line 2473 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (REG_SAME(yyvsp[-4].reg, yyvsp[-2].reg) && IS_DREG_L(yyvsp[0].reg)) {
		    notethat("dsp32shift: Ax = ROT Ax BY dregs_lo\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       3,     0,     &yyvsp[0].reg,       0,
			              /*      sop      HLs */
			                        2,   IS_A1(yyvsp[-4].reg)               );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 117:
#line 2486 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if ( IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-2].reg) && IS_DREG_L(yyvsp[0].reg)) {
		    notethat("dsp32shift: dregs = ROT dregs BY dregs_lo\n");
						  /*   sopcde   dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       3,   &yyvsp[-5].reg,     &yyvsp[0].reg,     &yyvsp[-2].reg,
			              /*      sop      HLs */
			                        3,       0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 118:
#line 2499 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IMM(yyvsp[0].expr, 6)) {
		    notethat("dsp32shiftimm: An = ROT An BY imm6\n");
							/*   sopcde   dst0      immag     src1 */
			yyval.instr = DSP32SHIFTIMM (      3,   &yyvsp[-4].reg,  imm6(yyvsp[0].expr),    0,
							/*      sop      HLs */
									  2,   IS_A1(yyvsp[-4].reg)                 );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 119:
#line 2512 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_DREG(yyvsp[-2].reg) && IS_IMM(yyvsp[0].expr, 6)) {
							/*   sopcde   dst0      immag     src1 */
			yyval.instr = DSP32SHIFTIMM (      2,   &yyvsp[-5].reg,  imm6(yyvsp[0].expr),     &yyvsp[-2].reg,
							/*      sop      HLs */
									  3,   IS_A1(yyvsp[-5].reg)                 );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 120:
#line 2524 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[-3].reg)) {
		    notethat("dsp32shift: dregs_lo = SIGNBITS An\n");
						  /*   sopcde     dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       6,     &yyvsp[-3].reg,       0,       0,
			              /*      sop      HLs */
			                 IS_A1(yyvsp[0].reg),    0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 121:
#line 2537 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[-3].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("dsp32shift: dregs_lo = SIGNBITS dregs\n");
						  /*   sopcde     dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       5,     &yyvsp[-3].reg,       0,     &yyvsp[0].reg,
			              /*      sop      HLs */
			                        0,     0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 122:
#line 2550 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[-3].reg)) {
		    notethat("dsp32shift: dregs_lo = SIGNBITS dregs_lo\n");
						  /*   sopcde     dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       5,     &yyvsp[-3].reg,       0,     &yyvsp[0].reg,
			              /*      sop      HLs */
			                1+IS_H(yyvsp[0].reg),    0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 123:
#line 2564 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG_L(yyvsp[-6].reg) && IS_DREG(yyvsp[-2].reg)) {
		    notethat("dsp32shift: dregs_lo = VIT_MAX (dregs) (..)\n");
						  /*   sopcde     dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       9,     &yyvsp[-6].reg,       0,     &yyvsp[-2].reg,
			              /*      sop      HLs */
			               (yyvsp[0].r0.r0 ? 0 : 1),     0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 124:
#line 2577 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-8].reg) && IS_DREG(yyvsp[-4].reg) && IS_DREG(yyvsp[-2].reg)) {
		    notethat("dsp32shift: dregs = VIT_MAX (dregs, dregs) (ASR)\n");
						  /*   sopcde     dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       9,     &yyvsp[-8].reg,     &yyvsp[-2].reg,     &yyvsp[-4].reg,
			              /*      sop      HLs */
			                2 | (yyvsp[0].r0.r0 ? 0 : 1),     0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 125:
#line 2590 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-6].reg) && IS_DREG(yyvsp[-4].reg) && !IS_A1(yyvsp[-2].reg)) {
		    notethat("dsp32shift: BITMUX (dregs , dregs , A0) (ASR)\n");
						  /*   sopcde     dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (       8,       0,     &yyvsp[-6].reg,     &yyvsp[-4].reg,
			              /*      sop      HLs */
			                    yyvsp[0].r0.r0,     0                   );
		} else {
			return register_mismatch();
		}
	}
    break;

  case 126:
#line 2603 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!IS_A1(yyvsp[-8].reg) && !IS_A1(yyvsp[-5].reg) && IS_A1(yyvsp[-3].reg)) {
		    notethat("dsp32shift: A0 = BXORSHIFT ( A0 , A1 , CC )\n");
						  /*   sopcde     dst0     src0     src1 */
			yyval.instr = DSP32SHIFT (      12,       0,       0,       0,
			              /*      sop      HLs */
			                        0,     0                   );
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 127:
#line 2624 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5)) {
		    notethat("LOGI2op: BITCLR ( dregs , uimm5 )\n");
			yyval.instr = LOGI2OP (yyvsp[-3].reg, uimm5(yyvsp[-1].expr), 4);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 128:
#line 2635 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5)) {
		    notethat("LOGI2op: BITCLR ( dregs , uimm5 )\n");
			yyval.instr = LOGI2OP (yyvsp[-3].reg, uimm5(yyvsp[-1].expr), 2);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 129:
#line 2646 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5)) {
		    notethat("LOGI2op: BITCLR ( dregs , uimm5 )\n");
			yyval.instr = LOGI2OP (yyvsp[-3].reg, uimm5(yyvsp[-1].expr), 3);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 130:
#line 2656 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5)) {
		    notethat("LOGI2op: CC =! BITTST ( dregs , uimm5 )\n");
			yyval.instr = LOGI2OP (yyvsp[-3].reg, uimm5(yyvsp[-1].expr), 0);
		} else {
			return semantic_error("Register mismatch or value error");
		}
	}
    break;

  case 131:
#line 2666 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_UIMM(yyvsp[-1].expr, 5)) {
		    notethat("LOGI2op: CC = BITTST ( dregs , uimm5 )\n");
			yyval.instr = LOGI2OP (yyvsp[-3].reg, uimm5(yyvsp[-1].expr), 1);
		} else {
			return semantic_error("Register mismatch or value error");
		}
	}
    break;

  case 132:
#line 2676 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if ((IS_DREG(yyvsp[-2].reg) || IS_PREG(yyvsp[-2].reg))
		 && (IS_DREG(yyvsp[0].reg) || IS_PREG(yyvsp[0].reg))) {
		    notethat("ccMV: IF ! CC gregs = gregs\n");
			yyval.instr = CCMV (&yyvsp[0].reg, &yyvsp[-2].reg, 0);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 133:
#line 2687 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if ((IS_DREG(yyvsp[0].reg) || IS_PREG(yyvsp[0].reg))
		 && (IS_DREG(yyvsp[-2].reg) || IS_PREG(yyvsp[-2].reg))) {
		    notethat("ccMV: IF CC gregs = gregs\n");
			yyval.instr = CCMV (&yyvsp[0].reg, &yyvsp[-2].reg, 1);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 134:
#line 2698 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL10(yyvsp[0].expr)) {
		    notethat("BRCC: IF !CC JUMP  pcrel11m2\n");
			yyval.instr = BRCC (0, 0, yyvsp[0].expr);

		} else {
			return semantic_error("Bad jump offset");
		}
	}
    break;

  case 135:
#line 2708 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL10(yyvsp[-3].expr)) {
		    notethat("BRCC: IF !CC JUMP  pcrel11m2\n");
			yyval.instr = BRCC (0, 1, yyvsp[-3].expr); // use branch prediction

		} else {
			return semantic_error("Bad jump offset");
		}

	}
    break;

  case 136:
#line 2720 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL10(yyvsp[0].expr)) {
		    notethat("BRCC: IF CC JUMP  pcrel11m2\n");
			yyval.instr = BRCC (1, 0, yyvsp[0].expr); // use branch prediction

		} else {
			return semantic_error("Bad jump offset");
		}
	}
    break;

  case 137:
#line 2731 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL10(yyvsp[-3].expr)) {
		    notethat("BRCC: IF !CC JUMP  pcrel11m2\n");
			yyval.instr = BRCC (1, 1, yyvsp[-3].expr); // use branch prediction

		} else {
			return semantic_error("Bad jump offset");
		}

	}
    break;

  case 138:
#line 2743 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: NOP\n");
		yyval.instr = PROGCTRL (0, 0);
	}
    break;

  case 139:
#line 2749 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: RTS\n");
		yyval.instr = PROGCTRL (1, 0);
	}
    break;

  case 140:
#line 2755 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: RTI\n");
		yyval.instr = PROGCTRL (1, 1);
	}
    break;

  case 141:
#line 2761 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: RTX\n");
		yyval.instr = PROGCTRL (1, 2);
	}
    break;

  case 142:
#line 2767 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: RTN\n");
		yyval.instr = PROGCTRL (1, 3);
	}
    break;

  case 143:
#line 2773 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: RTE\n");
		yyval.instr = PROGCTRL (1, 4);
	}
    break;

  case 144:
#line 2779 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: IDLE\n");
		yyval.instr = PROGCTRL (2, 0);
	}
    break;

  case 145:
#line 2785 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: CSYNC\n");
		yyval.instr = PROGCTRL (2, 3);
	}
    break;

  case 146:
#line 2791 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: SSYNC\n");
		yyval.instr = PROGCTRL (2, 4);
	}
    break;

  case 147:
#line 2797 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: EMUEXCPT\n");
		yyval.instr = PROGCTRL (2, 5);
	}
    break;

  case 148:
#line 2803 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[0].reg)) {
		    notethat("ProgCtrl: CLI dregs\n");
			yyval.instr = PROGCTRL (3, yyvsp[0].reg.regno & CODE_MASK);
		} else {
			return semantic_error("Dreg expected for CLI");
		}
	}
    break;

  case 149:
#line 2813 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[0].reg)) {
		    notethat("ProgCtrl: STI dregs\n");
			yyval.instr = PROGCTRL (4, yyvsp[0].reg.regno & CODE_MASK);
		} else {
			return semantic_error("Dreg expected for STI");
		}
	}
    break;

  case 150:
#line 2823 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-1].reg)) {
		    notethat("ProgCtrl: JUMP ( pregs )\n");
			yyval.instr = PROGCTRL (5, yyvsp[-1].reg.regno & CODE_MASK);
		} else {
			return semantic_error("Bad register for indirect jump");
		}
	}
    break;

  case 151:
#line 2833 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-1].reg)) {
		    notethat("ProgCtrl: CALL ( pregs )\n");
			yyval.instr = PROGCTRL (6, yyvsp[-1].reg.regno & CODE_MASK);

		} else {
			return semantic_error("Bad register for indirect call");
		}

	}
    break;

  case 152:
#line 2845 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-1].reg)) {
		    notethat("ProgCtrl: CALL ( PC + pregs )\n");
			yyval.instr = PROGCTRL (7, yyvsp[-1].reg.regno & CODE_MASK);

		} else {
			return semantic_error("Bad register for indirect call");
		}

	}
    break;

  case 153:
#line 2857 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-1].reg)) {
		    notethat("ProgCtrl: JUMP ( PC + pregs )\n");
			yyval.instr = PROGCTRL (8, yyvsp[-1].reg.regno & CODE_MASK);
		} else {
			return semantic_error("Bad register for indirect jump");
		}
	}
    break;

  case 154:
#line 2867 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_UIMM(yyvsp[0].expr, 4)) {
		    notethat("ProgCtrl: RAISE uimm4\n");
		yyval.instr = PROGCTRL (9, uimm4(yyvsp[0].expr));
		} else {
			return semantic_error("Bad value for RAISE");
		}
	}
    break;

  case 155:
#line 2877 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("ProgCtrl: EMUEXCPT\n");
		yyval.instr = PROGCTRL (10, uimm4(yyvsp[0].expr));
	}
    break;

  case 156:
#line 2883 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-1].reg)) {
		    notethat("ProgCtrl: TESTSET ( pregs )\n");
			yyval.instr = PROGCTRL (11, yyvsp[-1].reg.regno & CODE_MASK);
		} else {
			return semantic_error("Preg expected");
		}
	}
    break;

  case 157:
#line 2893 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL12(yyvsp[0].expr)) {
		    notethat("UJUMP: JUMP pcrel12\n");
		    yyval.instr = UJUMP(yyvsp[0].expr);

		} else {
			return semantic_error("Bad value for relative jump");
		}
	}
    break;

  case 158:
#line 2904 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL12(yyvsp[0].expr)) {
		    notethat("UJUMP: JUMP_DOT_S pcrel12\n");
		    yyval.instr = UJUMP(yyvsp[0].expr);
		} else {
			return semantic_error("Bad value for relative jump");
		}
	}
    break;

  case 159:
#line 2914 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL24(yyvsp[0].expr)) {
		    notethat("CALLa: jump.l pcrel24\n");
			yyval.instr = CALLA (yyvsp[0].expr, 0);
		} else {
			return semantic_error("Bad value for long jump");
		}
	}
    break;

  case 160:
#line 2927 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL24(yyvsp[0].expr)) {
		    notethat("CALLa: CALL pcrel25m2\n");
			yyval.instr = CALLA (yyvsp[0].expr, 1);
		} else {
			return semantic_error("Bad call address");
		}
	}
    break;

  case 161:
#line 2939 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
			yyval.instr = ALU2OP (&yyvsp[-3].reg, &yyvsp[-1].reg, 8);   // dst, src, opc
		} else {
			return semantic_error("Bad registers for DIVQ");
		}
	}
    break;

  case 162:
#line 2948 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[-1].reg)) {
			yyval.instr = ALU2OP (&yyvsp[-3].reg, &yyvsp[-1].reg, 9);   // dst, src, opc
		} else {
			return semantic_error("Bad registers for DIVS");
		}
	}
    break;

  case 163:
#line 2958 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-4].reg) && IS_DREG(yyvsp[-1].reg)) {
			if (yyvsp[0].modcodes.r0 == 0 && yyvsp[0].modcodes.s0 == 0) {
				notethat("ALU2op: dregs = - dregs\n");
				yyval.instr = ALU2OP (&yyvsp[-4].reg, &yyvsp[-1].reg, 14);   // dst, src, opc
			} else {

				notethat("dsp32alu: dregs = - dregs (.)\n");
						  /*     aopcde       HL               */
				yyval.instr = DSP32ALU (      15,       0,
						  /*   dst1     dst0     src0     src1 */
								  0,     &yyvsp[-4].reg,     &yyvsp[-1].reg,       0,
						  /*      s        x      aop          */
							  yyvsp[0].modcodes.s0,       0,       3          );
			}

		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 164:
#line 2980 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-3].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("ALU2op: dregs = ~dregs\n");
			yyval.instr = ALU2OP (&yyvsp[-3].reg, &yyvsp[0].reg, 15);   // dst, src, opc
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 165:
#line 2990 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("ALU2op: dregs >>= dregs\n");
			yyval.instr = ALU2OP (&yyvsp[-2].reg, &yyvsp[0].reg, 1);   // dst, src, opc
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 166:
#line 3000 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg) && IS_UIMM(yyvsp[0].expr, 5)) {
		    notethat("LOGI2op: dregs >>= uimm5\n");
			yyval.instr = LOGI2OP (yyvsp[-2].reg, uimm5(yyvsp[0].expr), 6);
		} else {
			return semantic_error("Dregs expected or value error");
		}
	}
    break;

  case 167:
#line 3010 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("ALU2op: dregs >>>= dregs\n");

			yyval.instr = ALU2OP (&yyvsp[-2].reg, &yyvsp[0].reg, 0);   // dst, src, opc
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 168:
#line 3021 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("ALU2op: dregs <<= dregs\n");
			yyval.instr = ALU2OP (&yyvsp[-2].reg, &yyvsp[0].reg, 2);   // dst, src, opc
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 169:
#line 3031 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg) && IS_UIMM(yyvsp[0].expr, 5)) {
		    notethat("LOGI2op: dregs <<= uimm5\n");
			yyval.instr = LOGI2OP (yyvsp[-2].reg, uimm5(yyvsp[0].expr), 7);
		} else {
			return semantic_error("Dregs expected or const value error");
		}
	}
    break;

  case 170:
#line 3042 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg) && IS_UIMM(yyvsp[0].expr, 5)) {
		    notethat("LOGI2op: dregs >>>= uimm5\n");
			yyval.instr = LOGI2OP (yyvsp[-2].reg, uimm5(yyvsp[0].expr), 5);
		} else {
			return semantic_error("Dregs expected");
		}
	}
    break;

  case 171:
#line 3056 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		    notethat("CaCTRL: FLUSH [ pregs ]\n");
		if (IS_PREG(yyvsp[-1].reg)) {
			yyval.instr = CACTRL (&yyvsp[-1].reg, 0, 2);   // reg, a, op
		} else {
			return semantic_error("Bad register(s) for FLUSH");
		}
	}
    break;

  case 172:
#line 3065 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-2].reg)) {
		    notethat("CaCTRL: FLUSH [ pregs ++ ]\n");
			yyval.instr = CACTRL (&yyvsp[-2].reg, 1, 2);   // reg, a, op
		} else {
			return semantic_error("Bad register(s) for FLUSH");
		}
	}
    break;

  case 173:
#line 3075 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-1].reg)) {
		    notethat("CaCTRL: FLUSHINV [ pregs ]\n");
			yyval.instr = CACTRL (&yyvsp[-1].reg, 0, 1);   // reg, a, op
		} else {
			return semantic_error("Bad register(s) for FLUSH");
		}
	}
    break;

  case 174:
#line 3085 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-2].reg)) {
		    notethat("CaCTRL: FLUSHINV [ pregs ++ ]\n");
			yyval.instr = CACTRL (&yyvsp[-2].reg, 1, 1);   // reg, a, op
		} else {
			return semantic_error("Bad register(s) for FLUSH");
		}
	}
    break;

  case 175:
#line 3096 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-1].reg)) {
		    notethat("CaCTRL: IFLUSH [ pregs ]\n");
			yyval.instr = CACTRL (&yyvsp[-1].reg, 0, 3);   // reg, a, op
		} else {
			return semantic_error("Bad register(s) for FLUSH");
		}
	}
    break;

  case 176:
#line 3106 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-2].reg)) {
		    notethat("CaCTRL: IFLUSH [ pregs ++ ]\n");
			yyval.instr = CACTRL (&yyvsp[-2].reg, 1, 3);   // reg, a, op
		} else {
			return semantic_error("Bad register(s) for FLUSH");
		}
	}
    break;

  case 177:
#line 3116 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-1].reg)) {
		    notethat("CaCTRL: PREFETCH [ pregs ]\n");
			yyval.instr = CACTRL(&yyvsp[-1].reg, 0, 0);
		} else {
			return semantic_error("Bad register(s) for PREFETCH");
		}

	}
    break;

  case 178:
#line 3127 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-2].reg)) {
		    notethat("CaCTRL: PREFETCH [ pregs ++ ]\n");
			yyval.instr = CACTRL(&yyvsp[-2].reg, 1, 0);
		} else {
			return semantic_error("Bad register(s) for PREFETCH");
		}

	}
    break;

  case 179:
#line 3143 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-4].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("LDST: B [ pregs <post_op> ] = dregs\n");
			yyval.instr = LDST (&yyvsp[-4].reg, &yyvsp[0].reg, yyvsp[-3].modcodes.x0, 2, 0, 1);
		} else {
			return register_mismatch();
		}
	}
    break;

  case 180:
#line 3154 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-5].reg) && IS_RANGE(16, yyvsp[-3].expr, yyvsp[-4].r0.r0, 1) && IS_DREG(yyvsp[0].reg)) {
		    notethat("LDST: B [ pregs + imm16 ] = dregs\n");
			if (yyvsp[-4].r0.r0) { neg_value(yyvsp[-3].expr); }
			yyval.instr = LDSTIDXI (&yyvsp[-5].reg, &yyvsp[0].reg,   /* W  sz  Z */
			                            1,  2,  0,
									    yyvsp[-3].expr);
		} else {
			return semantic_error("Register mismatch or const size wrong");
		}
	}
    break;

  case 181:
#line 3169 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-5].reg) && IS_URANGE(4, yyvsp[-3].expr, yyvsp[-4].r0.r0, 2) && IS_DREG(yyvsp[0].reg)) {
		    notethat("LDSTii: W [ pregs +- uimm5m2 ] = dregs\n");
			yyval.instr = LDSTII (&yyvsp[-5].reg, &yyvsp[0].reg, yyvsp[-3].expr, 1, 1); // ptr, reg, offset, W, op

		} else if (IS_PREG(yyvsp[-5].reg) && IS_RANGE(16, yyvsp[-3].expr, yyvsp[-4].r0.r0, 2) && IS_DREG(yyvsp[0].reg)) {
		    notethat("LDSTidxI: W [ pregs + imm17m2 ] = dregs\n");
			if (yyvsp[-4].r0.r0) { neg_value(yyvsp[-3].expr); }
			yyval.instr = LDSTIDXI (&yyvsp[-5].reg, &yyvsp[0].reg,   /* W  sz  Z */
			                            1,  1, 0,
									      yyvsp[-3].expr);
		} else {
			return semantic_error("Bad register(s) or wrong constant size");
		}
	}
    break;

  case 182:
#line 3187 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PREG(yyvsp[-4].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("LDST: W [ pregs <post_op> ] = dregs\n");
			yyval.instr = LDST (&yyvsp[-4].reg, &yyvsp[0].reg, yyvsp[-3].modcodes.x0, 1, 0, 1);
		} else {
			return semantic_error("Bad register(s) for STORE");
		}
	}
    break;

  case 183:
#line 3197 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IREG(yyvsp[-4].reg) ) {
		    notethat("dspLDST: W [ iregs <post_op> ] = dregs_half\n");
			yyval.instr = DSPLDST (&yyvsp[-4].reg, 1 + IS_H(yyvsp[0].reg), &yyvsp[0].reg, yyvsp[-3].modcodes.x0, 1);
		} else
		if (yyvsp[-3].modcodes.x0 == 2 && IS_PREG(yyvsp[-4].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("LDSTpmod: W [ pregs <post_op>] = dregs_half\n");
			yyval.instr = LDSTPMOD (&yyvsp[-4].reg, &yyvsp[0].reg, &yyvsp[-4].reg, 1 + IS_H(yyvsp[0].reg), 1);

		} else {
			return semantic_error("Bad register(s) for STORE");
		}
	}
    break;

  case 184:
#line 3213 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		int ispreg = IS_PREG(yyvsp[0].reg);

		if (!IS_PREG(yyvsp[-5].reg))
			return semantic_error("Preg expected for indirect");

		if (yyvsp[-5].reg.regno == REG_FP) {
			if (IS_URANGE(4, yyvsp[-3].expr, yyvsp[-4].r0.r0, 4)) {
				notethat("LDSTii: dpregs = [ FP + uimm6m4 ]\n");
				yyval.instr = LDSTII (&yyvsp[-5].reg, &yyvsp[0].reg, yyvsp[-3].expr, 1, ispreg ? 3: 0);

			} else
			if (IS_URANGE(5, yyvsp[-3].expr, yyvsp[-4].r0.r0 ? 0: 1, 4)) {
				notethat("LDSTiiFP: dpregs = [ FP - uimm7m4 ]\n");
				if (!yyvsp[-4].r0.r0) { neg_value(yyvsp[-3].expr); }
				yyval.instr = LDSTIIFP (yyvsp[-3].expr, &yyvsp[0].reg, 1);
			} else 
			if (IS_RANGE(16, yyvsp[-3].expr, yyvsp[-4].r0.r0, 4)) { // 16 offset, DREGS
				notethat("LDSTidxI: [ FP + imm18m4 ] = dpregs\n");
				if (yyvsp[-4].r0.r0) { neg_value(yyvsp[-3].expr); }
				yyval.instr = LDSTIDXI (&yyvsp[-5].reg, &yyvsp[0].reg,   /* W  sz  Z */
											  1,  0, ispreg ? 1: 0, yyvsp[-3].expr);
			} else 
			return semantic_error("Bad constant for load @FP");

		} else
		if (IS_URANGE(4, yyvsp[-3].expr, yyvsp[-4].r0.r0, 4)) {
			if (IS_DREG(yyvsp[0].reg)) {
				notethat("LDSTii: [ pregs + uimm6m4 ] = dregs\n");
				yyval.instr = LDSTII (&yyvsp[-5].reg, &yyvsp[0].reg, yyvsp[-3].expr, 1, 0);
			} else 
			if (ispreg) {
				notethat("LDSTii: [ pregs + uimm6m4 ] = pregs\n");
				yyval.instr = LDSTII (&yyvsp[-5].reg, &yyvsp[0].reg, yyvsp[-3].expr, 1, 3);
			} else {
				return semantic_error("Bad registers for STORE");
			}
			break;
		} else 
		if (IS_RANGE(16, yyvsp[-3].expr, yyvsp[-4].r0.r0, 4)) { // 16 offset, DREGS
			notethat("LDSTidxI: [ pregs + imm18m4 ] = dpregs\n");
			if (yyvsp[-4].r0.r0) { neg_value(yyvsp[-3].expr); }
			yyval.instr = LDSTIDXI (&yyvsp[-5].reg, &yyvsp[0].reg,   /* W  sz  Z */
			                              1,  0, ispreg ? 1: 0, yyvsp[-3].expr);
		} else {
			return semantic_error("Bad constant for STORE");
		}

	}
    break;

  case 185:
#line 3264 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-8].reg) && IS_PREG(yyvsp[-4].reg) && IS_URANGE(4, yyvsp[-2].expr, yyvsp[-3].r0.r0, 2)) {
			notethat("LDSTii: dregs = W [ pregs + uimm4s2 ] (.)\n");
			yyval.instr = LDSTII (&yyvsp[-4].reg, &yyvsp[-8].reg, yyvsp[-2].expr, 0, 1 << yyvsp[0].r0.r0 );
		} else
		if (IS_DREG(yyvsp[-8].reg) && IS_PREG(yyvsp[-4].reg) && IS_RANGE(16, yyvsp[-2].expr, yyvsp[-3].r0.r0, 2)) {
		    notethat("LDSTidxI: dregs = W [ pregs + imm17m2 ] (.)\n");
			if (yyvsp[-3].r0.r0) { neg_value(yyvsp[-2].expr); }
			yyval.instr = LDSTIDXI (&yyvsp[-4].reg, &yyvsp[-8].reg,   /* W  sz  Z */
			                              0,  1, yyvsp[0].r0.r0,
									       yyvsp[-2].expr);
		} else {
			return semantic_error("Bad register or constant for LOAD");
        }
	}
    break;

  case 186:
#line 3281 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IREG(yyvsp[-2].reg)) {
		    notethat("dspLDST: dregs_half = W [ iregs ]\n");
			yyval.instr = DSPLDST(&yyvsp[-2].reg, 1 + IS_H(yyvsp[-6].reg), &yyvsp[-6].reg, yyvsp[-1].modcodes.x0, 0);
		} else
		if (yyvsp[-1].modcodes.x0 == 2 && IS_DREG(yyvsp[-6].reg) && IS_PREG(yyvsp[-2].reg)) {
		    notethat("LDSTpmod: dregs_half = W [ pregs ]\n");
			yyval.instr = LDSTPMOD (&yyvsp[-6].reg, &yyvsp[-2].reg, &yyvsp[-2].reg, 1 + IS_H(yyvsp[-6].reg), 0);
		} else {
			return semantic_error("Bad register or post_op for LOAD");
        }
	}
    break;

  case 187:
#line 3296 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-7].reg) && IS_PREG(yyvsp[-3].reg)) {
		    notethat("LDST: dregs = W [ pregs <post_op> ] (.)\n");
			yyval.instr = LDST (&yyvsp[-3].reg, &yyvsp[-7].reg, yyvsp[-2].modcodes.x0, 1, yyvsp[0].r0.r0, 0);
		} else {
			return semantic_error("Bad register for LOAD");
        }
	}
    break;

  case 188:
#line 3306 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-8].reg) && IS_PREG(yyvsp[-4].reg) && IS_PREG(yyvsp[-2].reg)) {
		    notethat("LDSTpmod: dregs = W [ pregs ++ pregs ] (.)\n");
			yyval.instr = LDSTPMOD (&yyvsp[-8].reg, &yyvsp[-4].reg, &yyvsp[-2].reg, 3, yyvsp[0].r0.r0);
		} else {
			return semantic_error("Bad register for LOAD");
        }
	}
    break;

  case 189:
#line 3316 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-7].reg) && IS_PREG(yyvsp[-3].reg) && IS_PREG(yyvsp[-1].reg)) {
		    notethat("LDSTpmod: dregs_half = W [ pregs ++ pregs ]\n");
			yyval.instr = LDSTPMOD (&yyvsp[-7].reg, &yyvsp[-3].reg, &yyvsp[-1].reg, 1 + IS_H(yyvsp[-7].reg), 0);
		} else {
			return semantic_error("Bad register for LOAD");
        }
	}
    break;

  case 190:
#line 3326 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_IREG(yyvsp[-4].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("dspLDST: [ iregs <post_op> ] = dregs\n");
			yyval.instr = DSPLDST(&yyvsp[-4].reg, 0, &yyvsp[0].reg, yyvsp[-3].modcodes.x0, 1);
		} else
		if (IS_PREG(yyvsp[-4].reg) && IS_DREG(yyvsp[0].reg)) {
		    notethat("LDST: [ pregs <post_op> ] = dregs\n");
			yyval.instr = LDST (&yyvsp[-4].reg, &yyvsp[0].reg, yyvsp[-3].modcodes.x0, 0, 0, 1);
		} else
		if (IS_PREG(yyvsp[-4].reg) && IS_PREG(yyvsp[0].reg)) {
		    notethat("LDST: [ pregs <post_op> ] = pregs\n");
			yyval.instr = LDST (&yyvsp[-4].reg, &yyvsp[0].reg, yyvsp[-3].modcodes.x0, 0, 1, 1);
		} else {
			return semantic_error("Bad register for STORE");
		}
	}
    break;

  case 191:
#line 3344 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[0].reg)) {
			if (IS_IREG(yyvsp[-5].reg) && IS_MREG(yyvsp[-3].reg)) {
				notethat("dspLDST: [ iregs ++ mregs ] = dregs\n");
				yyval.instr = DSPLDST(&yyvsp[-5].reg, yyvsp[-3].reg.regno & CODE_MASK, &yyvsp[0].reg, 3, 1);
			} else
			if (IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-3].reg)) {
				notethat("LDSTpmod: [ pregs ++ pregs ] = dregs\n");
				yyval.instr = LDSTPMOD (&yyvsp[-5].reg, &yyvsp[0].reg, &yyvsp[-3].reg, 0, 1);
			} else {
				return semantic_error("Bad register for STORE");
			}
		} else {
			return semantic_error("Expected Dreg for last argument");
		}
	}
    break;

  case 192:
#line 3362 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!IS_DREG(yyvsp[0].reg))
			return semantic_error("Expect Dreg as last argument");
		if (IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-3].reg)) {
		    notethat("LDSTpmod: W [ pregs ++ pregs ] = dregs_half\n");
			yyval.instr = LDSTPMOD (&yyvsp[-5].reg, &yyvsp[0].reg, &yyvsp[-3].reg, 1 + IS_H(yyvsp[0].reg), 1);
			
		} else {
			return semantic_error("Bad register for STORE");
		}
	}
    break;

  case 193:
#line 3375 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-8].reg) && IS_PREG(yyvsp[-4].reg) && IS_RANGE(16, yyvsp[-2].expr, yyvsp[-3].r0.r0, 1)) {
		    notethat("LDSTidxI: dregs = B [ pregs + imm16 ] (%c)\n",
				yyvsp[0].r0.r0 ? 'X' : 'Z' );
			if (yyvsp[-3].r0.r0) { neg_value(yyvsp[-2].expr); }
			yyval.instr = LDSTIDXI (&yyvsp[-4].reg, &yyvsp[-8].reg,   /* W  sz  Z */
			                              0,  2, yyvsp[0].r0.r0,
									       yyvsp[-2].expr);
		} else {
			return semantic_error("Bad register or value for LOAD");
		}
	}
    break;

  case 194:
#line 3389 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-7].reg) && IS_PREG(yyvsp[-3].reg)) {
		    notethat("LDST: dregs = B [ pregs <post_op> ] (%c)\n",
				yyvsp[0].r0.r0 ? 'X' : 'Z' );
			yyval.instr = LDST (&yyvsp[-3].reg, &yyvsp[-7].reg, yyvsp[-2].modcodes.x0, 2, yyvsp[0].r0.r0, 0);
		} else {
			return semantic_error("Bad register for LOAD");
		}
	}
    break;

  case 195:
#line 3400 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-6].reg) && IS_IREG(yyvsp[-3].reg) && IS_MREG(yyvsp[-1].reg)) {

		    notethat("dspLDST: dregs = [ iregs ++ mregs ]\n");
			yyval.instr = DSPLDST(&yyvsp[-3].reg, yyvsp[-1].reg.regno & CODE_MASK, &yyvsp[-6].reg, 3, 0);
		} else
		if (IS_DREG(yyvsp[-6].reg) && IS_PREG(yyvsp[-3].reg) && IS_PREG(yyvsp[-1].reg)) {

		    notethat("LDSTpmod: dregs = [ pregs ++ pregs ]\n");
			yyval.instr = LDSTPMOD (&yyvsp[-3].reg, &yyvsp[-6].reg, &yyvsp[-1].reg, 0, 0);
		} else {
			return semantic_error("Bad register for LOAD");
		}
	}
    break;

  case 196:
#line 3416 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		int ispreg = IS_PREG(yyvsp[-6].reg);

		if (!IS_PREG(yyvsp[-3].reg))
			return semantic_error("Expects Preg for indirect");

		// special case REG_FP:
		if (yyvsp[-3].reg.regno == REG_FP) {

			if (IS_URANGE(4, yyvsp[-1].expr, yyvsp[-2].r0.r0, 4)) {
				notethat("LDSTii: dpregs = [ FP + uimm6m4 ]\n");
				yyval.instr = LDSTII (&yyvsp[-3].reg, &yyvsp[-6].reg, yyvsp[-1].expr, 0, ispreg ? 3: 0);

			} else
			if (IS_URANGE(5, yyvsp[-1].expr, yyvsp[-2].r0.r0 ? 0: 1, 4)) {
				notethat("LDSTiiFP: dpregs = [ FP - uimm7m4 ]\n");
				if (!yyvsp[-2].r0.r0) { neg_value(yyvsp[-1].expr); }
				yyval.instr = LDSTIIFP (yyvsp[-1].expr, &yyvsp[-6].reg, 0);
			} else 
			if (IS_RANGE(16, yyvsp[-1].expr, yyvsp[-2].r0.r0, 4)) {
				notethat("LDSTidxI: dpregs = [ FP + imm18m4 ]\n");
				yyval.instr = LDSTIDXI (&yyvsp[-3].reg, &yyvsp[-6].reg,   /* W  sz  Z */
											  0,  0, ispreg ? 1: 0,
											  yyvsp[-1].expr);

			} else 
				return semantic_error("Bad constant for load @FP");
		} else

		if (IS_URANGE(4, yyvsp[-1].expr, yyvsp[-2].r0.r0, 4)) {
			notethat("LDSTii: dpregs = [ pregs + uimm7m4 ]\n");
			yyval.instr = LDSTII (&yyvsp[-3].reg, &yyvsp[-6].reg, yyvsp[-1].expr, 0, ispreg ? 3 : 0);
		} else
		if (IS_RANGE(16, yyvsp[-1].expr, yyvsp[-2].r0.r0, 4)) {
			notethat("LDSTidxI: dpregs = [ pregs + imm18m4 ]\n");
			if (yyvsp[-2].r0.r0) { neg_value(yyvsp[-1].expr); }
			yyval.instr = LDSTIDXI (&yyvsp[-3].reg, &yyvsp[-6].reg,   /* W  sz  Z */
										  0,  0, ispreg ? 1: 0,
										  yyvsp[-1].expr);

		} else {
			return semantic_error("Bad constant range or register");
		}

	}
    break;

  case 197:
#line 3464 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-5].reg) && IS_IREG(yyvsp[-2].reg)) {
		    notethat("dspLDST: dregs = [ iregs <post_op> ]\n");
			yyval.instr = DSPLDST (&yyvsp[-2].reg, 0, &yyvsp[-5].reg, yyvsp[-1].modcodes.x0, 0 );
		} else
		if (IS_DREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-2].reg)) {
		    notethat("LDST: dregs = [ pregs <post_op> ]\n");
			yyval.instr = LDST (&yyvsp[-2].reg, &yyvsp[-5].reg, yyvsp[-1].modcodes.x0, 0, 0, 0);
		} else
		if (IS_PREG(yyvsp[-5].reg) && IS_PREG(yyvsp[-2].reg)) {
			if (REG_SAME(yyvsp[-5].reg, yyvsp[-2].reg) && yyvsp[-1].modcodes.x0 != 2)
				return semantic_error("Pregs can't be same");

		    notethat("LDST: pregs = [ pregs <post_op> ]\n");
			yyval.instr = LDST (&yyvsp[-2].reg, &yyvsp[-5].reg, yyvsp[-1].modcodes.x0, 0, 1, 0);
		} else 
		if (yyvsp[-2].reg.regno == REG_SP && IS_ALLREG(yyvsp[-5].reg) && yyvsp[-1].modcodes.x0 == 0) {
		    notethat("PushPopReg: allregs = [ SP ++ ]\n");
			yyval.instr = PUSHPOPREG(&yyvsp[-5].reg, 0);

		} else {
			return semantic_error("Bad register or value");
		}
	}
    break;

  case 198:
#line 3495 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[-11].reg.regno != REG_SP)
			return semantic_error("SP expected");

		if (yyvsp[-7].reg.regno == REG_R7
		 && (EXPR_VALUE(yyvsp[-5].expr) >= 0 && EXPR_VALUE(yyvsp[-5].expr) < 8)  
		 && yyvsp[-3].reg.regno == REG_P5
		 && (EXPR_VALUE(yyvsp[-1].expr) >= 0 && EXPR_VALUE(yyvsp[-1].expr) < 6)  ) {
		    notethat("PushPopMultiple: [ -- SP ] = ( R7 : reglim , P5 : reglim )\n");
			yyval.instr = PUSHPOPMULTIPLE (imm5(yyvsp[-5].expr), imm5(yyvsp[-1].expr), 1, 1, 1);
		} else {
			return semantic_error("Bad register for PushPopMultiple");
		}
	}
    break;

  case 199:
#line 3511 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[-7].reg.regno != REG_SP)
			return semantic_error("SP expected");

		if (yyvsp[-3].reg.regno == REG_R7
		 && (EXPR_VALUE(yyvsp[-1].expr) >= 0 && EXPR_VALUE(yyvsp[-1].expr) < 8) ) {
		    notethat("PushPopMultiple: [ -- SP ] = ( R7 : reglim )\n");
			yyval.instr = PUSHPOPMULTIPLE (imm5(yyvsp[-1].expr), 0, 1, 0, 1);
		} else
		if (yyvsp[-3].reg.regno == REG_P5
		 && (EXPR_VALUE(yyvsp[-1].expr) >= 0 && EXPR_VALUE(yyvsp[-1].expr) < 6) ) {
		    notethat("PushPopMultiple: [ -- SP ] = ( P5 : reglim )\n");
			yyval.instr = PUSHPOPMULTIPLE (0, imm5(yyvsp[-1].expr), 0, 1, 1);
		} else {
			return semantic_error("Bad register for PushPopMultiple");
		}
	}
    break;

  case 200:
#line 3530 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[-2].reg.regno != REG_SP)
			return semantic_error("SP expected");

		if (yyvsp[-12].reg.regno == REG_R7 && (EXPR_VALUE(yyvsp[-10].expr) >= 0 && EXPR_VALUE(yyvsp[-10].expr) < 8)  
		 && yyvsp[-8].reg.regno == REG_P5 && (EXPR_VALUE(yyvsp[-6].expr) >= 0 && EXPR_VALUE(yyvsp[-6].expr) < 6)) {
		    notethat("PushPopMultiple: ( R7 : reglim , P5 : reglim ) = [ SP ++ ]\n");
			yyval.instr = PUSHPOPMULTIPLE (imm5(yyvsp[-10].expr), imm5(yyvsp[-6].expr), 1, 1, 0);
		} else {
			return semantic_error("Bad register range for PushPopMultiple");
		}
	}
    break;

  case 201:
#line 3544 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[-2].reg.regno != REG_SP)
			return semantic_error("SP expected");

		if (yyvsp[-8].reg.regno == REG_R7 && (EXPR_VALUE(yyvsp[-6].expr) >= 0
		 && EXPR_VALUE(yyvsp[-6].expr) < 8)) {
		    notethat("PushPopMultiple: ( R7 : reglim ) = [ SP ++ ]\n");
			yyval.instr = PUSHPOPMULTIPLE (imm5(yyvsp[-6].expr), 0, 1, 0, 0);
		} else
		if (yyvsp[-8].reg.regno == REG_P5 && (EXPR_VALUE(yyvsp[-6].expr) >= 0
		 && EXPR_VALUE(yyvsp[-6].expr) < 6)) {
		    notethat("PushPopMultiple: ( P5 : reglim ) = [ SP ++ ]\n");
			yyval.instr = PUSHPOPMULTIPLE (0, imm5(yyvsp[-6].expr), 0, 1, 0);
		} else {
			return semantic_error("Bad register range for PushPopMultiple");
		}
	}
    break;

  case 202:
#line 3563 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[-3].reg.regno != REG_SP)
			return semantic_error("SP expected");

		if (IS_ALLREG(yyvsp[0].reg)) {
		    notethat("PushPopReg: [ -- SP ] = allregs\n");
			yyval.instr = PUSHPOPREG(&yyvsp[0].reg, 1);
		} else {
			return semantic_error("Bad register for PushPopReg");
		}
	}
    break;

  case 203:
#line 3584 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_URANGE(16, yyvsp[0].expr, 0, 4)) {
			yyval.instr = LINKAGE (0, uimm16s4(yyvsp[0].expr));
		} else {
			return semantic_error("Bad constant for LINK");
		}
	}
    break;

  case 204:
#line 3593 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("linkage: UNLINK\n");
		yyval.instr = LINKAGE (1, 0);
	}
    break;

  case 205:
#line 3603 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL4(yyvsp[-4].expr) && IS_LPPCREL10(yyvsp[-2].expr) && IS_CREG(yyvsp[0].reg)) {
		    notethat("LoopSetup: LSETUP ( pcrel4 , lppcrel10 ) counters\n");
			yyval.instr = LOOPSETUP (yyvsp[-4].expr, &yyvsp[0].reg, 0, yyvsp[-2].expr, 0);
		} else {
			return semantic_error("Bad register or values for LSETUP");
		}
	}
    break;

  case 206:
#line 3613 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL4(yyvsp[-6].expr) && IS_LPPCREL10(yyvsp[-4].expr)
		 && IS_PREG(yyvsp[0].reg) && IS_CREG(yyvsp[-2].reg)) {
		    notethat("LoopSetup: LSETUP ( pcrel4 , lppcrel10 ) counters = pregs\n");
			yyval.instr = LOOPSETUP (yyvsp[-6].expr, &yyvsp[-2].reg, 1, yyvsp[-4].expr, &yyvsp[0].reg);
		} else {
			return semantic_error("Bad register or values for LSETUP");
		}
	}
    break;

  case 207:
#line 3624 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_PCREL4(yyvsp[-8].expr) && IS_LPPCREL10(yyvsp[-6].expr)
		 && IS_PREG(yyvsp[-2].reg) && IS_CREG(yyvsp[-4].reg) 
		 && EXPR_VALUE(yyvsp[0].expr) == 1) {
		    notethat("LoopSetup: LSETUP ( pcrel4 , lppcrel10 ) counters = pregs >> 1\n");
			yyval.instr = LOOPSETUP (yyvsp[-8].expr, &yyvsp[-4].reg, 3, yyvsp[-6].expr, &yyvsp[-2].reg);
		} else {
			return semantic_error("Bad register or values for LSETUP");
		}
	}
    break;

  case 208:
#line 3639 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("pseudoDEBUG: DBG\n");

	 	yyval.instr = gen_pseudodbg(3, 7, 0);
	}
    break;

  case 209:
#line 3646 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("pseudoDEBUG: DBG REG_A\n");
		yyval.instr = gen_pseudodbg(3, IS_A1(yyvsp[0].reg), 0);
	}
    break;

  case 210:
#line 3652 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("pseudoDEBUG: DBG allregs\n");
		yyval.instr = gen_pseudodbg(0, yyvsp[0].reg.regno & CODE_MASK, yyvsp[0].reg.regno & CLASS_MASK);
	}
    break;

  case 211:
#line 3658 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (!IS_DREG(yyvsp[-1].reg))
			return semantic_error("Dregs expected");

		notethat("pseudoDEBUG: DBGCMPLX ( dregs )\n");
		yyval.instr = gen_pseudodbg(3, 6, yyvsp[-1].reg.regno & CODE_MASK);
	}
    break;

  case 212:
#line 3667 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("psedoDEBUG: DBGHALT\n");
		yyval.instr = gen_pseudodbg(3, 5, 0);
	}
    break;

  case 213:
#line 3673 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("pseudodbg_assert: DBGA ( dregs_lo , uimm16 )\n");
		yyval.instr = gen_pseudodbg_assert(IS_H(yyvsp[-3].reg), &yyvsp[-3].reg, uimm16(yyvsp[-1].expr) );
	}
    break;

  case 214:
#line 3679 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("pseudodbg_assert: DBGAH ( dregs , uimm16 )\n");
		yyval.instr = gen_pseudodbg_assert(3, &yyvsp[-3].reg, uimm16(yyvsp[-1].expr) );
	}
    break;

  case 215:
#line 3685 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		notethat("psedodbg_assert: DBGAL ( dregs , uimm16 )\n");
		yyval.instr = gen_pseudodbg_assert(2, &yyvsp[-3].reg, uimm16(yyvsp[-1].expr) );

	}
    break;

  case 216:
#line 3701 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.reg = yyvsp[0].reg; }
    break;

  case 217:
#line 3703 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.reg = yyvsp[0].reg; }
    break;

  case 218:
#line 3711 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.mod.MM = 0; yyval.mod.mod = 0; }
    break;

  case 219:
#line 3713 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.mod.MM = 1; yyval.mod.mod = yyvsp[-1].value; }
    break;

  case 220:
#line 3715 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.mod.MM = 1; yyval.mod.mod = yyvsp[-3].value; }
    break;

  case 221:
#line 3717 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.mod.MM = 0; yyval.mod.mod = yyvsp[-1].value; }
    break;

  case 222:
#line 3719 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.mod.MM = 1; yyval.mod.mod = 0; }
    break;

  case 223:
#line 3724 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 224:
#line 3726 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 225:
#line 3730 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 0; yyval.modcodes.x0 = 0; }
    break;

  case 226:
#line 3732 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 1; yyval.modcodes.x0 = 0; }
    break;

  case 227:
#line 3734 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 0; yyval.modcodes.x0 = 1; }
    break;

  case 228:
#line 3736 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 1; yyval.modcodes.x0 = 1; }
    break;

  case 229:
#line 3741 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 230:
#line 3743 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 231:
#line 3747 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 0; yyval.modcodes.x0 = 0; }
    break;

  case 232:
#line 3749 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = yyvsp[-1].modcodes.s0; yyval.modcodes.x0 = yyvsp[-1].modcodes.x0; }
    break;

  case 233:
#line 3754 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 0; yyval.modcodes.x0 = 0; }
    break;

  case 234:
#line 3756 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 0; yyval.modcodes.x0 = 0; }
    break;

  case 235:
#line 3758 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 1; yyval.modcodes.x0 = 0; }
    break;

  case 236:
#line 3763 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 0; yyval.modcodes.s0 = 0; }
    break;

  case 237:
#line 3765 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 2 + yyvsp[-1].r0.r0; yyval.modcodes.s0 = 0; yyval.modcodes.x0 = 0; }
    break;

  case 238:
#line 3768 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 0; yyval.modcodes.s0 = yyvsp[-1].modcodes.s0; yyval.modcodes.x0 = yyvsp[-1].modcodes.x0; }
    break;

  case 239:
#line 3771 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 2 + yyvsp[-3].r0.r0; yyval.modcodes.s0 = yyvsp[-1].modcodes.s0; yyval.modcodes.x0 = yyvsp[-1].modcodes.x0; }
    break;

  case 240:
#line 3774 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 2 + yyvsp[-1].r0.r0; yyval.modcodes.s0 = yyvsp[-3].modcodes.s0; yyval.modcodes.x0 = yyvsp[-3].modcodes.x0; }
    break;

  case 241:
#line 3778 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 242:
#line 3780 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 243:
#line 3782 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 244:
#line 3786 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 245:
#line 3788 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 246:
#line 3790 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 247:
#line 3794 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 0; yyval.modcodes.s0 = 0; }
    break;

  case 248:
#line 3796 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 0; yyval.modcodes.s0 = 0; }
    break;

  case 249:
#line 3798 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 0; yyval.modcodes.s0 = 1; }
    break;

  case 250:
#line 3800 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 1; yyval.modcodes.s0 = 0; }
    break;

  case 251:
#line 3802 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 1; yyval.modcodes.s0 = 1; }
    break;

  case 252:
#line 3804 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 1; yyval.modcodes.s0 = 1; }
    break;

  case 253:
#line 3808 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 254:
#line 3810 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 255:
#line 3814 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 0; }
    break;

  case 256:
#line 3816 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.s0 = 1; }
    break;

  case 257:
#line 3821 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 258:
#line 3823 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 259:
#line 3825 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 3; }
    break;

  case 260:
#line 3827 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 2; }
    break;

  case 261:
#line 3832 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 262:
#line 3834 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 263:
#line 3839 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 0; yyval.modcodes.s0 = 1; }
    break;

  case 264:
#line 3841 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { if (yyvsp[-1].value != M_T) return semantic_error("Bad modifier");
		yyval.modcodes.r0 = 1; yyval.modcodes.s0 = 0; }
    break;

  case 265:
#line 3844 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { if (yyvsp[-3].value != M_T) return semantic_error("Bad modifier");
		yyval.modcodes.r0 = 1; yyval.modcodes.s0 = 1; }
    break;

  case 266:
#line 3847 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { if (yyvsp[-1].value != M_T) return semantic_error("Bad modifier");
		yyval.modcodes.r0 = 1; yyval.modcodes.s0 = 1; }
    break;

  case 267:
#line 3855 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 268:
#line 3857 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 269:
#line 3859 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 2; }
    break;

  case 270:
#line 3863 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 271:
#line 3865 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[-1].value == M_W32) yyval.r0.r0 = 1;
		else return semantic_error("Only (W32) allowed");
	}
    break;

  case 272:
#line 3872 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 273:
#line 3874 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (yyvsp[-1].value == M_IU) yyval.r0.r0 = 3;
		else return semantic_error("(IU) expected");
	}
    break;

  case 274:
#line 3887 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 275:
#line 3889 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 276:
#line 3894 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 277:
#line 3896 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 278:
#line 3898 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 2; }
    break;

  case 279:
#line 3900 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 3; }
    break;

  case 280:
#line 3905 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 281:
#line 3907 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 282:
#line 3912 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.r0 = 1; // HL
		yyval.modcodes.s0 = 0; // s
		yyval.modcodes.x0 = 0; // aop
	}
    break;

  case 283:
#line 3919 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.r0 = 1; // HL
		yyval.modcodes.s0 = 0; // s
		yyval.modcodes.x0 = 1; // aop
	}
    break;

  case 284:
#line 3926 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.r0 = 0; // HL
		yyval.modcodes.s0 = 0; // s
		yyval.modcodes.x0 = 0; // aop
	}
    break;

  case 285:
#line 3933 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.r0 = 0; // HL
		yyval.modcodes.s0 = 0; // s
		yyval.modcodes.x0 = 1; // aop
	}
    break;

  case 286:
#line 3940 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.r0 = 0; // HL
		yyval.modcodes.s0 = 1; // s
		yyval.modcodes.x0 = 1; // aop
	}
    break;

  case 287:
#line 3947 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.r0 = 1; // HL
		yyval.modcodes.s0 = 1; // s
		yyval.modcodes.x0 = 1; // aop
	}
    break;

  case 288:
#line 3954 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.r0 = 0; // HL
		yyval.modcodes.s0 = 1; // s
		yyval.modcodes.x0 = 0; // aop
	}
    break;

  case 289:
#line 3961 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.r0 = 0; // HL
		yyval.modcodes.s0 = 1; // s
		yyval.modcodes.x0 = 1; // aop
	}
    break;

  case 290:
#line 3970 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.s0 = 0; // s
		yyval.modcodes.x0 = 0; // HL
	}
    break;

  case 291:
#line 3976 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.s0 = 0; // s
		yyval.modcodes.x0 = 1; // HL
	}
    break;

  case 292:
#line 3981 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.s0 = 1; // s
		yyval.modcodes.x0 = 0; // HL
	}
    break;

  case 293:
#line 3987 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.modcodes.s0 = 1; // s
		yyval.modcodes.x0 = 1; // HL
	}
    break;

  case 294:
#line 3994 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.x0 = 2; }
    break;

  case 295:
#line 3996 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.x0 = 0; }
    break;

  case 296:
#line 3998 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.x0 = 1; }
    break;

  case 297:
#line 4007 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.reg = yyvsp[-1].reg; }
    break;

  case 298:
#line 4012 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.reg = yyvsp[-1].reg; }
    break;

  case 299:
#line 4017 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.reg = yyvsp[-1].reg; }
    break;

  case 300:
#line 4022 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.macfunc.w = 1; yyval.macfunc.P = 1; yyval.macfunc.n = IS_A1(yyvsp[0].reg);
		yyval.macfunc.op = 3; yyval.macfunc.dst = yyvsp[-2].reg;
		yyval.macfunc.s0.regno = 0; yyval.macfunc.s1.regno = 0; // XXX
	}
    break;

  case 301:
#line 4029 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.macfunc = yyvsp[0].macfunc;
		yyval.macfunc.w = 0; yyval.macfunc.P = 0;
		yyval.macfunc.dst.regno = 0;
	}
    break;

  case 302:
#line 4036 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.macfunc = yyvsp[-1].macfunc;
		yyval.macfunc.w = 1; yyval.macfunc.P = 1; yyval.macfunc.dst = yyvsp[-4].reg;
	}
    break;

  case 303:
#line 4042 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.macfunc = yyvsp[-1].macfunc;
		yyval.macfunc.w = 1; yyval.macfunc.P = 0; yyval.macfunc.dst = yyvsp[-4].reg;
	}
    break;

  case 304:
#line 4048 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.macfunc.w = 1; yyval.macfunc.P = 0; yyval.macfunc.n = IS_A1(yyvsp[0].reg);
		yyval.macfunc.op = 3; yyval.macfunc.dst = yyvsp[-2].reg;
		yyval.macfunc.s0.regno = 0; yyval.macfunc.s1.regno = 0;
	}
    break;

  case 305:
#line 4057 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.macfunc.n = IS_A1(yyvsp[-3].reg); yyval.macfunc.op = 0;  yyval.macfunc.s0 = yyvsp[-2].reg; yyval.macfunc.s1 = yyvsp[0].reg;
	}
    break;

  case 306:
#line 4061 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.macfunc.n = IS_A1(yyvsp[-3].reg); yyval.macfunc.op = 1;  yyval.macfunc.s0 = yyvsp[-2].reg; yyval.macfunc.s1 = yyvsp[0].reg;
	}
    break;

  case 307:
#line 4065 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		yyval.macfunc.n = IS_A1(yyvsp[-3].reg); yyval.macfunc.op = 2;  yyval.macfunc.s0 = yyvsp[-2].reg; yyval.macfunc.s1 = yyvsp[0].reg;
	}
    break;

  case 308:
#line 4072 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    {
		if (IS_DREG(yyvsp[-2].reg) && IS_DREG(yyvsp[0].reg)) {
			yyval.macfunc.s0 = yyvsp[-2].reg; yyval.macfunc.s1 = yyvsp[0].reg;
		} else {
			return semantic_error("Multfunc expects Dregs");
		}
	}
    break;

  case 309:
#line 4083 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 0; }
    break;

  case 310:
#line 4085 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 1; }
    break;

  case 311:
#line 4087 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 2; }
    break;

  case 312:
#line 4089 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.r0.r0 = 3; }
    break;

  case 313:
#line 4094 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = yyvsp[0].reg.regno; yyval.modcodes.x0 = yyvsp[-1].r0.r0; yyval.modcodes.s0 = 0; }
    break;

  case 314:
#line 4097 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 0x18; yyval.modcodes.x0 = yyvsp[-1].r0.r0; yyval.modcodes.s0 = 0; }
    break;

  case 315:
#line 4100 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = yyvsp[-2].reg.regno; yyval.modcodes.x0 = yyvsp[-1].r0.r0; yyval.modcodes.s0 = 1; }
    break;

  case 316:
#line 4103 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.modcodes.r0 = 0x18; yyval.modcodes.x0 = yyvsp[-1].r0.r0; yyval.modcodes.s0 = 1; }
    break;

  case 317:
#line 4176 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { ExprNodeValue val; val.s_value = S_GET_NAME(yyvsp[0].symbol);
	  yyval.expr = ExprNodeCreate(ExprNodeReloc, val, NULL, NULL); }
    break;

  case 318:
#line 4181 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { ExprNodeValue val; val.i_value = yyvsp[0].value;
	  yyval.expr = ExprNodeCreate(ExprNodeConstant, val, NULL, NULL); }
    break;

  case 319:
#line 4184 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = yyvsp[0].expr; }
    break;

  case 320:
#line 4186 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = yyvsp[-1].expr; }
    break;

  case 321:
#line 4188 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = unary(ExprOpTypeCOMP,yyvsp[0].expr); }
    break;

  case 322:
#line 4190 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = unary(ExprOpTypeNEG,yyvsp[0].expr); }
    break;

  case 323:
#line 4204 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = yyvsp[0].expr; }
    break;

  case 324:
#line 4208 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeMult,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 325:
#line 4210 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeDiv,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 326:
#line 4212 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeMod,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 327:
#line 4214 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeAdd,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 328:
#line 4216 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeSub,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 329:
#line 4218 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeLsft,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 330:
#line 4220 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeRsft,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 331:
#line 4222 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeBAND,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 332:
#line 4224 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeLOR,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 333:
#line 4226 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = binary(ExprOpTypeBOR,yyvsp[-2].expr,yyvsp[0].expr); }
    break;

  case 334:
#line 4228 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"
    { yyval.expr = yyvsp[0].expr; }
    break;


    }

/* Line 991 of yacc.c.  */
#line 6698 "y.tab.c"

  yyvsp -= yylen;
  yyssp -= yylen;


  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (YYPACT_NINF < yyn && yyn < YYLAST)
	{
	  YYSIZE_T yysize = 0;
	  int yytype = YYTRANSLATE (yychar);
	  char *yymsg;
	  int yyx, yycount;

	  yycount = 0;
	  /* Start YYX at -YYN if negative to avoid negative indexes in
	     YYCHECK.  */
	  for (yyx = yyn < 0 ? -yyn : 0;
	       yyx < (int) (sizeof (yytname) / sizeof (char *)); yyx++)
	    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	      yysize += yystrlen (yytname[yyx]) + 15, yycount++;
	  yysize += yystrlen ("syntax error, unexpected ") + 1;
	  yysize += yystrlen (yytname[yytype]);
	  yymsg = (char *) YYSTACK_ALLOC (yysize);
	  if (yymsg != 0)
	    {
	      char *yyp = yystpcpy (yymsg, "syntax error, unexpected ");
	      yyp = yystpcpy (yyp, yytname[yytype]);

	      if (yycount < 5)
		{
		  yycount = 0;
		  for (yyx = yyn < 0 ? -yyn : 0;
		       yyx < (int) (sizeof (yytname) / sizeof (char *));
		       yyx++)
		    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
		      {
			const char *yyq = ! yycount ? ", expecting " : " or ";
			yyp = yystpcpy (yyp, yyq);
			yyp = yystpcpy (yyp, yytname[yyx]);
			yycount++;
		      }
		}
	      yyerror (yymsg);
	      YYSTACK_FREE (yymsg);
	    }
	  else
	    yyerror ("syntax error; also virtual memory exhausted");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror ("syntax error");
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      /* Return failure if at end of input.  */
      if (yychar == YYEOF)
        {
	  /* Pop the error token.  */
          YYPOPSTACK;
	  /* Pop the rest of the stack.  */
	  while (yyss < yyssp)
	    {
	      YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
	      yydestruct (yystos[*yyssp], yyvsp);
	      YYPOPSTACK;
	    }
	  YYABORT;
        }

      YYDSYMPRINTF ("Error: discarding", yytoken, &yylval, &yylloc);
      yydestruct (yytoken, &yylval);
      yychar = YYEMPTY;

    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab2;


/*----------------------------------------------------.
| yyerrlab1 -- error raised explicitly by an action.  |
`----------------------------------------------------*/
yyerrlab1:

  /* Suppress GCC warning that yyerrlab1 is unused when no action
     invokes YYERROR.  */
#if defined (__GNUC_MINOR__) && 2093 <= (__GNUC__ * 1000 + __GNUC_MINOR__) \
    && !defined __cplusplus
  __attribute__ ((__unused__))
#endif


  goto yyerrlab2;


/*---------------------------------------------------------------.
| yyerrlab2 -- pop states until the error token can be shifted.  |
`---------------------------------------------------------------*/
yyerrlab2:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
      yydestruct (yystos[yystate], yyvsp);
      yyvsp--;
      yystate = *--yyssp;

      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  YYDPRINTF ((stderr, "Shifting error token, "));

  *++yyvsp = yylval;


  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*----------------------------------------------.
| yyoverflowlab -- parser overflow comes here.  |
`----------------------------------------------*/
yyoverflowlab:
  yyerror ("parser stack overflow");
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  return yyresult;
}


#line 4232 "/home2/raja/testDEL/binutils/gas/./config/bfin-parse.y"


EXPR_T mkexpr(int x, SYMBOL_T s)
{
    EXPR_T e = (EXPR_T) ALLOCATE(sizeof (struct expression_cell));
    e->value = x;
    EXPR_SYMBOL(e) = s;
    return e;
}

/*
static EXPR_T binary(expr_opcodes_t op,EXPR_T x,EXPR_T y)
{
    int val = 0;
    switch (op) {
		case mult:   val = EXPR_VALUE(x) * EXPR_VALUE(y);	break;
		case divide: val = EXPR_VALUE(x) / EXPR_VALUE(y);	break;
		case mod:    val = EXPR_VALUE(x) % EXPR_VALUE(y);	break;
		case add:    val = EXPR_VALUE(x) + EXPR_VALUE(y);	break;
		case sub:    val = EXPR_VALUE(x) - EXPR_VALUE(y);	break;
		case lsh:    val = EXPR_VALUE(x) << EXPR_VALUE(y);  break;
		case rsh:    val = EXPR_VALUE(x) >> EXPR_VALUE(y);  break;
		case logand: val = EXPR_VALUE(x) & EXPR_VALUE(y);	break;
		case logior: val = EXPR_VALUE(x) | EXPR_VALUE(y);	break;
		case logxor: val = EXPR_VALUE(x) ^ EXPR_VALUE(y);	break;
		default: break;  // to avoid warnings
    }
    return mkexpr (val, EXPR_SYMBOL(x));
}

static EXPR_T unary(expr_opcodes_t op,EXPR_T x)
{
    int val = 0;
    switch (op) {
		case ones_compl: val = ~EXPR_VALUE(x);	break;
		case twos_compl: val = -EXPR_VALUE(x);	break;
		default: break; // to avoid warnings
    }
    return mkexpr (val, EXPR_SYMBOL(x));
}
*/

static int value_match(ExprNode *expr, int sz, int sign, int mul, int issigned)
{
	long umax = (1L << sz) - 1;
	long min = -1L << (sz - 1);
	long max = (1L << (sz - 1)) - 1;
	
	long v = EXPR_VALUE(expr);

	if ((v % mul) != 0) {
		fprintf(stderr, "ValueError: Must align to %d\n", mul);
		return 0;
	}

	v /= mul;

	if (sign) v = -v;

	if (issigned) {
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

 /* return the new expression structure that allows
   symbol operations
   if the left and right children are constants, do the operation
*/
static ExprNode * binary(ExprOpType op,ExprNode *x,ExprNode *y) {
    if(x->type == ExprNodeConstant && y->type == ExprNodeConstant){
      switch (op) {
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

	default : fprintf(stderr, "Internal compiler error at line %d in file %s\n", __LINE__, __FILE__);
      }
      return x; // should delete y
    }
    else{
      /* create a new expression structure */
      ExprNodeValue val;
      val.op_value = op;
      return ExprNodeCreate(ExprNodeBinop, val, x, y);
    }
}

static ExprNode * unary(ExprOpType op,ExprNode * x) 
{
  if(x->type == ExprNodeConstant){
    switch (op) {
        case ExprOpTypeNEG: 
                x->value.i_value = -x->value.i_value;
		break;
        case ExprOpTypeCOMP: 
                x->value.i_value = ~x->value.i_value;
		break;
	default :  fprintf(stderr, "Internal compiler error at line %d in file %s\n", __LINE__, __FILE__);
    }
    return x;
  }
  else{
      /* create a new expression structure */
      ExprNodeValue val;
      val.op_value = op;
      return ExprNodeCreate(ExprNodeUnop, val, x, NULL);
  }
}

int debug_codeselection = 0;
static void notethat(char *format, ...)
{
    va_list ap;
    va_start (ap, format);
    if (debug_codeselection) {
      vfprintf (errorf, format, ap);
    }
    va_end (ap);
}

#ifdef TEST
main(int argc, char **argv)
{
    yyparse();
}
#endif


