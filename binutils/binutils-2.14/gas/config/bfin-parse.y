/* This file is bfin-parse.y
 * Copyright (c) 2000-2001 Analog Devices Inc.,
 * Copyright (c) 2000-2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001-2002 by Arcturus Networks Inc. (www.arcturusnetworks.com),
 * Ported for Blackfin/Frio Architecture by Akbar Hussain  <akbar.hussain@arcturusnetworks.com>,
 *                                          Tony Kou <tony.ko@arcturusnetworks.com>
 *                                          Faisal Akber <fakber@arcturusnetworks.com>
 */
 
/*
 * This file is the parser for the ADI FRIO (Blackfin) processor.
 * The syntax doesn't follow the conventions of M68K or IBM, and is very
 * complex.
 */          



%{
#include <stdio.h>
#include <stdarg.h>
#include "bfin-defs.h"
#include <obstack.h>


int nerrors;
int nwarnings;
extern FILE *errorf;
extern INSTR_T insn;

static ExprNode * binary(ExprOpType,ExprNode *,ExprNode *);
static ExprNode * unary(ExprOpType,ExprNode *);

static int const_fits(ExprNode * expr, const_forms_t form);
static void notethat(char *format, ...);

char *current_inputline;
extern char *yytext;

void error (char *format, ...)
{
    va_list ap;
    char buffer[2000];
    
    va_start (ap, format);
    vsprintf (buffer, format, ap);
    va_end (ap);

    as_bad(buffer);
}

void warn (char *format, ...)
{
    va_list ap;
    char buffer[2000];
    
    va_start (ap, format);
    vsprintf (buffer,format,ap);
    
    va_end (ap);    
    as_warn (buffer);
}

void semantic_error(char *syntax)
{
    error ("\nSemantic error operands don't fit instruction template:  `%s'\n", syntax);
}

void semantic_error_2(char *syntax)
{
    error ("\n Semantic error:  %s \n", syntax);
}

static int yyerror(char *msg) {
    error ("\n %sInput text was `%s'\n", msg, yytext);
    return 0;	/* means successful	*/
}

extern int yylex (void);

static long reg_class_contents[][3] = {
{0x000000ff, 0x00000000, 0x00000000}, /* dregs_lo */
{0x0000ff00, 0x00000000, 0x00000000}, /* dregs_hi */
{0x00ff0000, 0x00000000, 0x00000000}, /* dregs */
{0x0f000000, 0x00000000, 0x00000000}, /* dregs_pair */
{0xf0000000, 0x0000000f, 0x00000000}, /* pregs */
{0x00000000, 0x0000000c, 0x00000000}, /* spfp */
{0x0000ffff, 0x00000000, 0x00000000}, /* dregs_hilo */
{0x00000000, 0x00000030, 0x00000000}, /* accum_ext */
{0x00000000, 0x000000c0, 0x00000000}, /* accum_word */
{0x00000000, 0x00000300, 0x00000000}, /* accum */
{0x00000000, 0x00003c00, 0x00000000}, /* iregs */
{0x00000000, 0x0003c000, 0x00000000}, /* mregs */
{0x00000000, 0x003c0000, 0x00000000}, /* bregs */
{0x00000000, 0x03c00000, 0x00000000}, /* lregs */
{0xf0ff0000, 0x0000000f, 0x00000000}, /* dpregs */
{0xf0ff0000, 0x0000000f, 0x00000000}, /* gregs */
{0xf0ff0000, 0x03fffc0f, 0x00000000}, /* regs */
{0x00000000, 0xfc000000, 0x00000000}, /* statbits */
{0x00000000, 0x00000000, 0x0000003f}, /* ignore_bits */
{0x00000000, 0x00000000, 0x00000040}, /* ccstat */
{0x00000000, 0x00000000, 0x00000180}, /* counters */
{0x00000000, 0x000000f0, 0x00000e00}, /* dregs2_sysregs1 */
{0x00000000, 0x00000000, 0x00000000}, /* open */
{0x00000000, 0x00000000, 0x0003f180}, /* sysregs2 */
{0x00000000, 0x00000000, 0x01fc0000}, /* sysregs3 */
{0xf0ff0000, 0x03fffcff, 0x01ffff80}, /* allregs */
};

#define reginclass(r,c) (reg_class_contents[c][r>>5]&(1<<((r)&63)))


/* RL(0..7)  */
static int encode_dregs_lo[] = {
  0,   1,   2,   3,   4,   5,   6,   7,   -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define dregs_lo(x) (encode_dregs_lo[x])

/* RH(0..7)  */
/*static int encode_dregs_hi[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  0,   1,   2,   3,   4,   5,   6,   7,   
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define dregs_hi(x) (encode_dregs_hi[x])
*/
/* R(0..7)  */
static int encode_dregs[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  0,   1,   2,   3,   4,   5,   6,   7,   -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define dregs(x) (encode_dregs[x])

/* R1:0 - R3:2 - R5:4 - R7:6 -  */
/*static int encode_dregs_pair[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  0,   2,   4,   6,   -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define dregs_pair(x) (encode_dregs_pair[x])
*/
/* P(0..5) SP FP  */
static int encode_pregs[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  0,   1,   2,   3,   
  4,   5,   6,   7,   -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define pregs(x) (encode_pregs[x])



/* I(0..3)   */
static int encode_iregs[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  0,   1,   2,   3,   -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define iregs(x) (encode_iregs[x])

/* M(0..3)   */
static int encode_mregs[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  0,   1,   
  2,   3,   -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  };

#define mregs(x) (encode_mregs[x])


/* dregs pregs  */
static int encode_dpregs[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  0,   1,   2,   3,   4,   5,   6,   7,   -1,  -1,  -1,  -1,  8,   9,   10,  11,  
  12,  13,  14,  15,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define dpregs(x) (encode_dpregs[x])

/* [dregs pregs] */
static int encode_gregs[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  0,   1,   2,   3,   4,   5,   6,   7,   -1,  -1,  -1,  -1,  8,   9,   10,  11,  
  12,  13,  14,  15,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define gregs(x) (encode_gregs[x])
#define Xgregs(x) (encode_gregs[x]>>3)

/* [dregs pregs (iregs mregs) (bregs lregs)]  */
static int encode_regs[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  0,   1,   2,   3,   4,   5,   6,   7,   -1,  -1,  -1,  -1,  8,   9,   10,  11,  
  12,  13,  14,  15,  -1,  -1,  -1,  -1,  -1,  -1,  16,  17,  18,  19,  20,  21,  
  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define regs(x) (encode_regs[x])
#define Xregs(x) (encode_regs[x]>>3)

/* AZ AN AC AV0 AV1 - AQ -                  -  -  -  -   -   -  - -                  -  -  -  -   -   -  - -                  -  -  -  -   -   -  - -  */
static int encode_statbits[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  0,   1,   2,   3,   4,   6,   
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  };

#define statbits(x) (encode_statbits[x])


/* LC0 LC1  */
static int encode_counters[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  0,   1,   -1,  -1,  -1,  -1,  -1,  -1,  -1,
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  };

#define counters(x) (encode_counters[x])


/* [dregs pregs (iregs mregs) (bregs lregs) 	         dregs2_sysregs1 open sysregs2 sysregs3] */
static int encode_allregs[] = {
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  
  0,   1,   2,   3,   4,   5,   6,   7,   -1,  -1,  -1,  -1,  8,   9,   10,  11,  
  12,  13,  14,  15,  32,  34,  33,  35,  -1,  -1,  16,  17,  18,  19,  20,  21,  
  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,  -1,  -1,  -1,  -1,  -1,  -1,  
  -1,  -1,  -1,  -1,  -1,  -1,  -1,  48,  51,  36,  38,  39,  49,  50,  52,  53,  
  54,  55,  56,  57,  58,  59,  60,  61,  62,  
  };

#define allregs(x) (encode_allregs[x])
#define Xallregs(x) (encode_allregs[x]>>3)
struct {
    char *name; 
    int nbits; 
    char reloc;
    char issigned;
    char pcrel; 
    char scale;
    char offset; 
    char negative; 
    char positive;
} constant_formats[] = {
   { "0", 0, 0, 1, 0, 0, 0, 0, 0 },
  { "1", 0, 0, 1, 0, 0, 0, 0, 0 },
  { "4", 0, 0, 1, 0, 0, 0, 0, 0 },
  { "2", 0, 0, 1, 0, 0, 0, 0, 0 },
  { "uimm2", 2, 0, 0, 0, 0, 0, 0, 0 },
  { "uimm3", 3, 0, 0, 0, 0, 0, 0, 0 },
  { "imm3", 3, 0, 1, 0, 0, 0, 0, 0 },
  { "pcrel4", 4, 1, 0, 1, 1, 0, 0, 0 },
  { "pcrel5", 4, 1, 0, 1, 1, 0, 0, 0 },
  { "imm4", 4, 0, 1, 0, 0, 0, 0, 0 },
  { "uimm4s4", 4, 0, 0, 0, 2, 0, 0, 1 },  
  { "uimm4", 4, 0, 0, 0, 0, 0, 0, 0 },
  { "uimm4s2", 4, 0, 0, 0, 1, 0, 0, 1 },  
  { "negimm5s4", 5, 0, 1, 0, 2, 0, 1, 0 },
  { "imm5", 5, 0, 1, 0, 0, 0, 0, 0 },
  { "uimm5", 5, 0, 0, 0, 0, 0, 0, 0 },
  { "imm6", 6, 0, 1, 0, 0, 0, 0, 0 },
  { "imm7", 7, 0, 1, 0, 0, 0, 0, 0 },
  { "imm8", 8, 0, 1, 0, 0, 0, 0, 0 },
  { "uimm8", 8, 0, 0, 0, 0, 0, 0, 0 },
  { "pcrel8", 8, 1, 0, 1, 1, 0, 0, 0 },
  { "uimm8s4", 8, 0, 0, 0, 2, 0, 0, 0 },  
  { "pcrel8s4", 8, 1, 1, 1, 2, 0, 0, 0 }, 
  { "lppcrel10", 10, 1, 0, 1, 1, 0, 0, 0 },
  { "pcrel10", 10, 1, 1, 1, 1, 0, 0, 0 }, 
  { "pcrel11", 10, 1, 0, 1, 1, 0, 0, 0 }, 
  { "pcrel12", 12, 1, 1, 1, 1, 0, 0, 0 }, 
  { "pcrel12_jump", 12, 1, 1, 1, 1, 0, 0, 0},
  { "pcrel12_jump_s", 12, 1, 1, 1, 1, 0, 0, 0},
  { "imm16s4", 16, 0, 1, 0, 2, 0, 0, 0 },
  { "luimm16", 16, 1, 0, 0, 0, 0, 0, 0 },
  { "imm16", 16, 0, 1, 0, 0, 0, 0, 0 },
  { "huimm16", 16, 1, 0, 0, 0, 0, 0, 0 },
  { "rimm16", 16, 1, 1, 0, 0, 0, 0, 0 },
  { "imm16s2", 16, 0, 1, 0, 1, 0, 0, 0 },
  { "uimm16s4", 16, 0, 0, 0, 2, 0, 0, 0 },
  { "uimm16", 16, 0, 0, 0, 0, 0, 0, 0 },
  { "pcrel24", 24, 1, 1, 1, 1, 0, 0, 0 },
  { "pcrel24_call_x", 24, 1, 1, 1, 1, 0, 0, 0},
  { "pcrel24_jump", 24, 1, 1, 1, 1, 0, 0, 0},
  { "pcrel24_jump_x", 24, 1, 1, 1, 1, 0, 0, 0},
  { "pcrel24_jump_l", 24, 1, 1, 1, 1, 0, 0, 0},

};

#define uimm2(x) EXPR_VALUE(x)
#define uimm3(x) EXPR_VALUE(x)
#define imm3(x) EXPR_VALUE(x)
#define pcrel4(x) ((EXPR_VALUE(x))>>1)
#define pcrel5(x) ((EXPR_VALUE(x))>>1)
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
#define pcrel11(x) ((EXPR_VALUE(x))>>1)
#define pcrel12(x) ((EXPR_VALUE(x))>>1)
#define pcrel12_jump(x) ((EXPR_VALUE(x))>>1)
#define pcrel12_jump_s(x) ((EXPR_VALUE(x))>>1)
#define imm16s4(x) ((EXPR_VALUE(x))>>2)
#define luimm16(x) EXPR_VALUE(x)
#define imm16(x) EXPR_VALUE(x)
#define huimm16(x) EXPR_VALUE(x)
#define rimm16(x) EXPR_VALUE(x)
#define imm16s2(x) ((EXPR_VALUE(x))>>1)
#define uimm16s4(x) ((EXPR_VALUE(x))>>2)
#define uimm16(x) EXPR_VALUE(x)
#define pcrel24(x) ((EXPR_VALUE(x))>>1)
#define pcrel24_call_x(x) ((EXPR_VALUE(x))>>1)
#define pcrel24_jump(x) ((EXPR_VALUE(x))>>1)
#define pcrel24_jump_x(x) ((EXPR_VALUE(x))>>1)
#define pcrel24_jump_l(x) ((EXPR_VALUE(x))>>1)

#define	align_power(addr, align)	\
	( ((addr) + ((1<<(align))-1)) & (-1 << (align)))

// this predicate allows only certain instruction to be
// be issued in parallel with dsp32.  The instructions are
// as below or nop which is just a zero.
static void ensure_legal_multi_issue_slavep_first (INSTR_T x) {
    if ((x->value & 0xc000) == 0x8000  //dspLDST,LDSTpmod,LDST,LDSTiiFP,LDSTii
	|| (x->value == 0x0000))
	return ;
    error ("illegal instruction in multi issue slot\\n");
    }

static void  ensure_legal_multi_issue_slavep (INSTR_T x) {
    if ((   ((x->value & 0xfc00) == 0x9c00)  // pick dspLDST
	&& !((x->value & 0xfde0) == 0x9c60)  // pick dagMODim
	&& !((x->value & 0xfde0) == 0x9ce0)  // pick dagMODim with bit rev
	&& !((x->value & 0xfde0) == 0x9d60)) // pick dagMODik
	|| (x->value == 0x0000))
	return ;
    error ("illegal instruction in multi issue slot\\n");
    }


#ifndef ENABLE_M_BIT
#define ENABLE_M_BIT(x)
#endif



%}

%union {
    INSTR_T instr;
    reg_t regno;
    ExprNode *expr;
    SYMBOL_T symbol;
    long value;

    struct { int s0; int x0; } s0x0;
    struct { int r0; } r0;
    struct { int mod; } mod;
    struct { int op; int h0; int h1; } oph0h1;
}


%token BYTEOP1P         BYTEOP16P        BYTEOP16M        BYTEOP2P
%token BYTEOP2M         BYTEOP3P         TILDA            BANG
%token UNLINK           NUMBER           W                LBRACK
%token RPAREN           DBG              BREV             RBRACK
%token LE		M                LO
%token CLI              _LESS_LESS_ASSIGN _LESS_THAN_ASSIGN
%token CSYNC            ALIGN8           RND              S2RND
%token JUMP             JUMP_DOT_S       TFU
%token STAR             ISS2             RNDL             RNDH
%token STI              SSYNC            PREFETCH         NS
%token BYTEUNPACK       _MINUS_MINUS     HI               V
%token COLON            BITCLR		 LOW_REG          HIGH_REG 
%token MIN              MAX		 SHIFT		  REG_A00
%token IS               _ASSIGN_BANG     BYTE_REG	  REG_A11
%token NOP              ASL              ASR              CO
%token _MINUS_ASSIGN    PLUS             SCO
%token FLUSHINV         NOT              R		  V
%token T                FU		 B
%token ROT              SEARCH           ABS              X
%token _GREATER_GREATER_ASSIGN           _BAR_ASSIGN		  
%token LSETUP           _ASSIGN_ASSIGN   DISALGNEXCPT
%token HLT              BITSET		 _PLUS_BAR_PLUS	  _PLUS_BAR_MINUS
%token GE               COMMA            BYTEPACK         RAISE
%token SYMBOL           DBGHALT		 _MINUS_BAR_PLUS  _MINUS_BAR_MINUS
%token _PLUS_PLUS       BITTST		 S		  LT 
%token GT               IH		 A_ZERO_DOT_L	  A_ZERO_DOT_H
%token LESS_THAN        SIGN	         NEG
%token PRNT             _AMPERSAND_ASSIGN
%token SIGN             PERCENT          _STAR_ASSIGN     IFLUSH
%token _GREATER_GREATER_GREATER		  MINUS
%token DBGCMPLX         PC               A_ONE_DOT_L	  A_ONE_DOT_H
%token CARET            TL               LSHIFT
%token OUTC             TH               EXPADJ
%token ASSIGN           FLUSH		 		  
%token SIGNBITS         RND12            AMPERSAND        TESTSET
%token LINK             IF               DIVQ             SAA
%token DIVS             EXTRACT          ABORT
%token IS               IU               _KARAT_ASSIGN    PACK
%token BAR              GREATER_GREATER  
%token EXCPT            RND20		 BXORSHIFT	  BXOR
%token _PLUS_ASSIGN     ALIGN16          BP               SLASH
%token _GREATER_GREATER_GREATER_THAN_ASSIGN               BY
%token VIT_MAX          JUMP_DOT_L       W32              ASHIFT
%token KARAT            BITTGL           JUMP_DOT_X
%token EMUEXCPT         RTE              LPAREN           DBGA
%token RTI              ALIGN24          RTN
%token ONES             DBGAH            BITMUX           RTS
%token DBGAL            LESS_LESS
%token CALL_DOT_X       CALL             REG              RTX              IDLE
%token DEPOSIT          Z		 WHATREG	  DOUBLE_BAR
%token MODIFIED_STATUS_REG



%type<instr> asm
%type<mod> macmod_accm
%type<expr> offset_expr
%type<mod> mxd_mod
%type<value> NUMBER
%type<r0> aligndir
%type<oph0h1> multfunc
/* %type<oph0h1> A0macfunc */
%type<r0> A0macfunc 
%type<mod> macmod_hmove
/* %type<oph0h1> A1macfunc */
%type<r0> A1macfunc 
%type<expr> expr_1
%type<instr> asm_1
%type<s0x0> amod0
%type<s0x0> amod1
%type<r0> amod2
%type<r0> searchmod
%type<expr> symbol
%type<symbol> SYMBOL
%type<mod> macmod_pmove 
%type<expr> eterm
%type<regno> REG
%type<regno> LOW_REG
%type<regno> HIGH_REG
%type<regno> BYTE_REG
%type<regno> REG_A00
%type<regno> REG_A11
%type<regno> MODIFIED_STATUS_REG 
%type<expr> expr
%type<r0> xorzornothing 
%type<r0> sornothing 


/* Precedencde Rules */
%left BAR
%left CARET
%left AMPERSAND
%left LESS_LESS GREATER_GREATER
%left PLUS MINUS
%left STAR SLASH PERCENT
%right TILDA BANG
%start asm_or_directive
%%
asm_or_directive: { INIT_ASM(); } asm {
				       insn=$2;
				       return (1);
				       }
		;

asm: asm_1
       | asm_1 DOUBLE_BAR asm_1 DOUBLE_BAR asm_1 {
       if (($1->value & 0xf800) == 0xc000) {
	   INSTR_T tail;
	   ENABLE_M_BIT($1);
	   $1->value |= 0x0800;   
           for (tail = $1; tail->next; tail = tail->next);
	   ensure_legal_multi_issue_slavep_first ($3);
	   ensure_legal_multi_issue_slavep ($5);
           CONSCODE (tail, $3);
	   CONSCODE ($3, $5);
	   $$ = $1;
       }
       else
	   error ("\nIllegal Multi Issue Construct, First instruction must be DSP32\n");
     }

   | asm_1 DOUBLE_BAR asm_1 {
       if (($1->value & 0xf800) == 0xc000) {
	   INSTR_T tail;
	   ENABLE_M_BIT($1);
	   $1->value |= 0x0800;
           for (tail = $1; tail->next; tail = tail->next);
	   ensure_legal_multi_issue_slavep_first ($3);
           CONSCODE (tail, $3);
/*	    need to conscode a 0 to create a 64-bit execution packet, means NOP  */
	   CONSCODE ($3, CONSCODE (GENCODE (0x0000), NULL_CODE));
	   $$ = $1;
       } 
       else
	   error ("\nIllegal Multi Issue Construct, First instruction must be DSP32\n");
      }  


   | error { $$=0; as_bad("\nParse error.\n");yyerrok; }  // recovery error
   ;
/* First Pattern Page 7.75 */
asm_1:   A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA A0macfunc LOW_REG * LOW_REG macmod_accm"); }
		}
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA A0macfunc LOW_REG * HIGH_REG macmod_accm"); }
		}
	| A1macfunc  LOW_REG STAR LOW_REG mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA A0macfunc HIGH_REG * LOW_REG macmod_accm"); }
		}
	| A1macfunc  LOW_REG STAR LOW_REG mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA A0macfunc HIGH_REG * HIGH_REG macmod_accm"); }
		}
        | A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA A0macfunc LOW_REG * LOW_REG macmod_accm"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA A0macfunc LOW_REG * HIGH_REG macmod_accm"); }
		}
	| A1macfunc  LOW_REG STAR HIGH_REG mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA A0macfunc HIGH_REG * LOW_REG macmod_accm"); }
		}
	| A1macfunc  LOW_REG STAR HIGH_REG mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA A0macfunc HIGH_REG * HIGH_REG macmod_accm"); }
		}
        | A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA A0macfunc LOW_REG * LOW_REG macmod_accm"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA A0macfunc LOW_REG * HIGH_REG macmod_accm"); }
		}
	| A1macfunc  HIGH_REG STAR LOW_REG mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA A0macfunc HIGH_REG * LOW_REG macmod_accm"); }
		}
	| A1macfunc  HIGH_REG STAR LOW_REG mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA A0macfunc HIGH_REG * HIGH_REG macmod_accm"); }
		}
        | A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA A0macfunc LOW_REG * LOW_REG macmod_accm"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA A0macfunc LOW_REG * HIGH_REG macmod_accm"); }
		}
	| A1macfunc  HIGH_REG STAR HIGH_REG mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA A0macfunc HIGH_REG * LOW_REG macmod_accm"); }
		}
	| A1macfunc  HIGH_REG STAR HIGH_REG mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)==reginclass($8,rc_dregs)
                                && reginclass($4,rc_dregs)==reginclass($10,rc_dregs) ){
/*  dsp32mac:	A1macfunc (mxd_mod) , A0macfunc (macmod_accm)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod) , A0macfunc (macmod_accm)\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($11.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($7.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
				  |((dregs($2)&0x7)<<3)
				  |((dregs($4)&0x7)<<0)
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA A0macfunc HIGH_REG * HIGH_REG macmod_accm"); }
		}
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)
				&& reginclass($4,rc_dregs)) {
/*  dsp32mac:	A1macfunc mxd_mod
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc mxd_mod\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((0&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((3&0x3)<<11)                  /*    op0=A0macfunc.op */
		                  |((dregs($2)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src0<(dregs_lo) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)
				&& reginclass($4,rc_dregs)) {
/*  dsp32mac:	A1macfunc mxd_mod
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc mxd_mod\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((0&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((0)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((3&0x3)<<11)                  /*    op0=A0macfunc.op */
		                  |((dregs($2)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src0<(dregs_lo) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)
				&& reginclass($4,rc_dregs)) {
/*  dsp32mac:	A1macfunc mxd_mod
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc mxd_mod\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((0&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((0)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((3&0x3)<<11)                  /*    op0=A0macfunc.op */
		                  |((dregs($2)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src0<(dregs_lo) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)
				&& reginclass($4,rc_dregs)) {
/*  dsp32mac:	A1macfunc mxd_mod
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc mxd_mod\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((0&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((1)&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |(((1)&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((3&0x3)<<11)                  /*    op0=A0macfunc.op */
		                  |((dregs($2)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src0<(dregs_lo) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod"); }
		}
	| A0macfunc LOW_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)
				&& reginclass($4,rc_dregs)) {
/*  dsp32mac:	A0macfunc macmod_accm
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A0macfunc macmod_accm\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((3&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((0&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($5.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |((0&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($1.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src0<(dregs_lo) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A0macfunc LOW_REG * LOW_REG mxd_mod"); }
		}
	| A0macfunc LOW_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)
				&& reginclass($4,rc_dregs)) {
/*  dsp32mac:	A0macfunc macmod_accm
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A0macfunc macmod_accm\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((3&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((0&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($5.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |((0&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($1.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		                  |(((0)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src0<(dregs_lo) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A0macfunc LOW_REG * HIGH_REG mxd_mod"); }
		}
	| A0macfunc HIGH_REG STAR LOW_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)
				&& reginclass($4,rc_dregs)) {
/*  dsp32mac:	A0macfunc macmod_accm
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A0macfunc macmod_accm\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((3&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((0&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($5.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |((0&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($1.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((0)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src0<(dregs_lo) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A0macfunc HIGH_REG * LOW_REG mxd_mod"); }
		}
	| A0macfunc HIGH_REG STAR HIGH_REG macmod_accm
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                                && reginclass($2,rc_dregs)
				&& reginclass($4,rc_dregs)) {
/*  dsp32mac:	A0macfunc macmod_accm
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A0macfunc macmod_accm\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c000
		                |((3&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((0&0x1)<<4)                       /* MM=mxd_mod.mod */
		                |((($5.mod)&0xf)<<5)                     /* mmod=macmod_accm.mod */
		                |((0&0x1)<<2)                            /*  w1<(0) */
		                |((0&0x1)<<3)                            /*  P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x1)<<15)                     /*  h01=A1macfunc.h0*/
		                  |((0&0x1)<<14)                    /*   h11=A1macfunc.h1 */
		                  |((($1.r0)&0x3)<<11)                   /*    op0=A0macfunc.op */
		                  |((0&0x1)<<13)                          /*   w0<(0)         */
		                  |(((1)&0x1)<<10)                    /*  h00=A0macfunc.h0  */
		                  |(((1)&0x1)<<9)                    /*    h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src0<(dregs_lo) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A0macfunc HIGH_REG * HIGH_REG mxd_mod"); }
		}
	| ABORT
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* psedoDEBUG:	ABORT
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: ABORT\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f800
		                |((3&0x7)<<0)                            /* reg<(3) */
		                |((3&0x3)<<6)                            /* fn<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("ABORT"); }
		}
	| A_ZERO_DOT_H ASSIGN HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	A0.H = dregs_hi
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A_ZERO_DOT_H = dregs_hi\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c400
		                |((9&0x1f)<<0)                           /* aopcde<(9) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                 /* src0<(dregs_hi) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A_ZERO_DOT_H ASSIGN HIGH_REG"); }
		}
	| A_ONE_DOT_H ASSIGN HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	A1.H = dregs_hi
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A_ONE_DOT_H = dregs_hi\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c400
		                |((9&0x1f)<<0)                           /* aopcde<(9) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                 /* src0<(dregs_hi) */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));
		  } else { $$ = 0; semantic_error ("A_ONE_DOT_H ASSIGN HIGH_REG"); }
		}
	| A_ZERO_DOT_L ASSIGN LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	A0.L = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A_ZERO_DOT_L = dregs_lo\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c400
		                |((9&0x1f)<<0)                           /* aopcde<(9) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A_ZERO_DOT_L ASSIGN LOW_REG"); }
		}
	| A_ONE_DOT_L ASSIGN LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	A1.L = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A_ONE_DOT_L = dregs_lo\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c400
		                |((9&0x1f)<<0)                           /* aopcde<(9) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));
		  } else { $$ = 0; semantic_error ("A_ONE_DOT_L ASSIGN LOW_REG"); }
		}
	| B LBRACK REG PLUS expr RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)
		             && const_fits($5,c_imm16)
		             && reginclass($8,rc_dregs)) {
/* LDSTidxI:	B [ pregs + imm16 ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: B [ pregs + imm16 ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00e400
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($8)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((2&0x3)<<6)                            /* sz<(2) */
		                |((0&0x1)<<8)                            /* Z<(0) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((imm16($5)&0xffff)<<0)                 /* offset<(imm16) */
		          ),
		          NULL_CODE));
		  } else { $$ = 0; semantic_error ("B LBRACK REG PLUS expr RBRACK ASSIGN REG"); }
		}
	| B LBRACK REG RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)
		             && reginclass($6,rc_dregs)) {
/* LDST:	B [ pregs ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: B [ pregs ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009000
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($6)&0x7)<<0)                    /* reg<(dregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("B LBRACK REG RBRACK ASSIGN REG"); }
		}
	| B LBRACK REG _MINUS_MINUS RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && reginclass($7,rc_dregs)) {
/* LDST:	B [ pregs -- ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: B [ pregs -- ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009000
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($7)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("B LBRACK REG _MINUS_MINUS RBRACK ASSIGN REG"); }
		}
	| B LBRACK REG _PLUS_PLUS RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && reginclass($7,rc_dregs)) {
/* LDST:	B [ pregs ++ ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: B [ pregs ++ ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009000
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($7)&0x7)<<0)                    /* reg<(dregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("B LBRACK REG _PLUS_PLUS RBRACK ASSIGN REG"); }
		}
	| BITCLR LPAREN REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5)) {
/* LOGI2op:	BITCLR ( dregs , uimm5 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LOGI2op: BITCLR ( dregs , uimm5 )\n");
		    $$ = CONSCODE(
		        GENCODE(0x004800
		                |((dregs($3)&0x7)<<0)                    /* dst<(dregs) */
		                |((uimm5($5)&0x1f)<<3)                   /* src<(uimm5) */
		                |((4&0x7)<<8)                            /* opc<(4) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("BITCLR LPAREN REG COMMA expr RPAREN"); }
		}
	| BITSET LPAREN REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5)) {
/* LOGI2op:	BITSET ( dregs , uimm5 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LOGI2op: BITSET ( dregs , uimm5 )\n");
		    $$ = CONSCODE(
		        GENCODE(0x004800
		                |((dregs($3)&0x7)<<0)                    /* dst<(dregs) */
		                |((uimm5($5)&0x1f)<<3)                   /* src<(uimm5) */
		                |((2&0x7)<<8)                            /* opc<(2) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("BITSET LPAREN REG COMMA expr RPAREN"); }
		}
	| BITTGL LPAREN REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5)) {
/* LOGI2op:	BITTGL ( dregs , uimm5 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LOGI2op: BITTGL ( dregs , uimm5 )\n");
		    $$ = CONSCODE(
		        GENCODE(0x004800
		                |((dregs($3)&0x7)<<0)                    /* dst<(dregs) */
		                |((uimm5($5)&0x1f)<<3)                   /* src<(uimm5) */
		                |((3&0x7)<<8)                            /* opc<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("BITTGL LPAREN REG COMMA expr RPAREN"); }
		}
	| IF BANG REG JUMP expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && const_fits($5,c_pcrel10)) {
/* BRCC:	IF !CC JUMP pcrel11m2 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("BRCC: IF !CC JUMP  pcrel11m2\n");
                    $$ = CONSCODE(GENCODE(0x001000
                                  |((pcrel10($5)&0x3ff)<<0)   /* offset<(pcrel10) */
                                  |((0&0x1)<<11)              /* T<(0)            */
                                         ),
                                   ExprNodeGenReloc($5, BFD_RELOC_10_PCREL));

#if 0
		    $$ = CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_10_PCREL,$5,
		          GENCODE(0x001000
		                  |((pcrel10($5)&0x3ff)<<0)                /* offset<(pcrel10) */
		                  |((0&0x1)<<11)                           /* T<(0) */
		          )),
		        NULL_CODE);
#endif
		  } else { $$ = 0; semantic_error ("IF BANG REG JUMP expr"); }
		}
	| IF BANG REG JUMP expr LPAREN BP RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && const_fits($5,c_pcrel10)) {
/* BRCC:	IF !CC JUMP pcrel11m2 (bp)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("BRCC: IF !CC JUMP  pcrel11m2 (bp)\n");
                    $$ = CONSCODE(GENCODE(0x001000
                                  |((pcrel10($5)&0x3ff)<<0)    /* offset<(pcrel10) */
                                  |((0&0x1)<<11)               /* T<(0) */
                                  |((1&0x1)<<10)               /* B<(1) */
                                  ),
                                  ExprNodeGenReloc($5, BFD_RELOC_10_PCREL));
#if 0
		    $$ = CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_10_PCREL,$5,
		          GENCODE(0x001000
		                  |((pcrel10($5)&0x3ff)<<0)                /* offset<(pcrel10) */
		                  |((0&0x1)<<11)                           /* T<(0) */
		                  |((1&0x1)<<10)                           /* B<(1) */
		          )),
		        NULL_CODE);
#endif
		  } else { $$ = 0; semantic_error ("IF BANG REG JUMP expr LPAREN BP RPAREN"); }
		}
	| IF REG JUMP expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && const_fits($4,c_pcrel10)) {
/* BRCC:	IF CC JUMP pcrel11m2
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("BRCC: IF CC JUMP pcrel11m2\n");
                    $$ = CONSCODE(GENCODE(0x001000
                                  |((pcrel10($4)&0x3ff)<<0)    /* offset<(pcrel10) */
                                  |((1&0x1)<<11)               /* T<(1) */
                                         ),
                                   ExprNodeGenReloc($4, BFD_RELOC_10_PCREL));
#if 0
		    $$ = CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_10_PCREL,$4,
		          GENCODE(0x001000
		                  |((pcrel10($4)&0x3ff)<<0)                /* offset<(pcrel10) */
		                  |((1&0x1)<<11)                           /* T<(1) */
		          )),
		        NULL_CODE);
#endif
		  } else { $$ = 0; semantic_error ("IF REG JUMP expr"); }
		}
 
	| IF REG JUMP expr LPAREN BP RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && const_fits($4,c_pcrel10)) {
/* BRCC:	IF CC JUMP pcrel11m2 (bp)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("BRCC: IF CC JUMP pcrel11m2 (bp)\n");
                    $$ = CONSCODE(GENCODE(0x001000
                                  |((pcrel10($4)&0x3ff)<<0)    /* offset<(pcrel10) */
                                  |((1&0x1)<<11)               /* T<(1) */
                                  |((1&0x1)<<10)               /* B<(1) */
                                         ),
                                   ExprNodeGenReloc($4, BFD_RELOC_10_PCREL));
#if 0
		    $$ = CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_10_PCREL,$4,
		          GENCODE(0x001000
		                  |((pcrel10($4)&0x3ff)<<0)                /* offset<(pcrel10) */
		                  |((1&0x1)<<11)                           /* T<(1) */
		                  |((1&0x1)<<10)                           /* B<(1) */
		          )),
		        NULL_CODE);
#endif
		  } else { $$ = 0; semantic_error ("IF REG JUMP expr LPAREN BP RPAREN"); }
		}

	| CALL LPAREN PC PLUS REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($5,rc_pregs)) {
/* ProgCtrl:	CALL ( PC + pregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: CALL ( PC + pregs )\n");
		    $$ = CONSCODE(
		        GENCODE(0x000000
		                |((pregs($5)&0xf)<<0)                    /* poprnd<(pregs) */
		                |((7&0xf)<<4)                            /* prgfunc<(7) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("CALL LPAREN PC PLUS REG RPAREN"); }
		}
	| CALL LPAREN REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)) {
/* ProgCtrl:	CALL ( pregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: CALL ( pregs )\n");
		    $$ = CONSCODE(
		        GENCODE(0x000000
		                |((pregs($3)&0xf)<<0)                    /* poprnd<(pregs) */
		                |((6&0xf)<<4)                            /* prgfunc<(6) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("CALL LPAREN REG RPAREN"); }
		}
	| CALL expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && const_fits($2,c_pcrel24)) {
/* CALLa:	CALL pcrel25m2
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 1 |.S.|.msw...........................|
|.lsw...........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CALLa: CALL pcrel25m2\n");
                    $$ = CONSCODE(GENCODE(0x00e200
                            |(((pcrel24($2)>>16)&0xff)<<0)/* msw<(pcrel24)>>16 */
                            |((1&0x1)<<8)                 /* S<(1) */
                            ),
                           ExprNodeGenReloc($2, BFD_RELOC_24_PCREL));
#if 0
		    $$ = CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_24_PCREL,$2,
		          GENCODE(0x00e200
		                  |(((pcrel24($2)>>16)&0xff)<<0)           /* msw<(pcrel24)>>16 */
		                  |((1&0x1)<<8)                            /* S<(1) */
		          )),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((pcrel24($2)&0xffff)<<0)               /* lsw<(pcrel24) */
		          ),
		          NULL_CODE));
#endif
		  } else { $$ = 0; semantic_error ("CALL expr"); }
		}

         | CALL_DOT_X expr
                {
                  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && const_fits($2,c_pcrel24_call_x)) {
/* CALLa:       CALL.X pcrel25m2
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 1 |.S.|.msw...........................|
|.lsw...........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
                    notethat("CALLa: CALL pcrel25m2\n");
                    $$ = CONSCODE(GENCODE(0x00e200
                         |(((pcrel24_call_x($2)>>16)&0xff)<<0)/* msw<(pcrel24)>>16 */
                         |((1&0x1)<<8)                        /* S<(1) */
                         ),
                         ExprNodeGenReloc($2, BFD_RELOC_24_PCREL_CALL_X));
#if 0
                    $$ = CONSCODE(
                        NOTERELOC(PCREL,BFD_RELOC_24_PCREL_CALL_X,$2,
                          GENCODE(0x00e200
                                  |(((pcrel24_call_x($2)>>16)&0xff)<<0)           /* msw<(pcrel24)>>16 */
                                  |((1&0x1)<<8)                            /* S<(1) */
                          )),
                        CONSCODE(
                          GENCODE(0x000000
                                  |((pcrel24_call_x($2)&0xffff)<<0)               /* lsw<(pcrel24) */
                          ),
                          NULL_CODE));
#endif
                  } else { $$ = 0; semantic_error ("CALL expr"); }
                }

	| CSYNC
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	CSYNC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: CSYNC\n");
		    $$ = CONSCODE(
		        GENCODE(0x000000
		                |((2&0xf)<<4)                            /* prgfunc<(2) */
		                |((3&0xf)<<0)                            /* poprnd<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("CSYNC"); }
		}
	| DBG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* psedoDEBUG:	DBG
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: DBG\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f800
		                |((7&0x7)<<0)                            /* reg<(7) */
		                |((3&0x3)<<6)                            /* fn<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("DBG"); }
		}
	| DBG REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && $2 == REG_A0) {
/* psedoDEBUG:	DBG A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: DBG A0\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f800
		                |((0&0x7)<<0)                            /* reg<(0) */
		                |((3&0x3)<<6)                            /* fn<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("DBG REG_A00"); }
		}
	| DBG REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && $2 == REG_A1) {
/* psedoDEBUG:	DBG A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: DBG A1\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f800
		                |((1&0x7)<<0)                            /* reg<(1) */
		                |((3&0x3)<<6)                            /* fn<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("DBG REG_A11"); }
		}
	| DBG REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_allregs)) {
/* psedoDEBUG:	DBG allregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: DBG allregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f800
		                |((allregs($2)&0x7)<<0)                  /* reg<(allregs) */
		                |((Xallregs($2)&0x7)<<3)                 /* grp<(Xallregs($2)) */
		                |((0&0x3)<<6)                            /* fn<(0) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("DBG REG"); }
		}
	| DBGA LPAREN LOW_REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm16)) {
/* psedodbg_assert:	DBGA ( dregs_lo , uimm16 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 0 | - | - | - | - | - |.dbgop.....|.regtest...|
|.expected......................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedodbg_assert: DBGA ( dregs_lo , uimm16 )\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f000
		                |((dregs($3)&0x7)<<0)                 /* regtest<(dregs_lo) */
		                |((0&0x7)<<3)                            /* dbgop<(0) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((uimm16($5)&0xffff)<<0)                /* expected<(uimm16) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("DBGA LPAREN LOW_REG COMMA expr RPAREN"); }
		}
	| DBGA LPAREN HIGH_REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm16)) {
/* psedodbg_assert:	DBGA ( dregs_hi , uimm16 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 0 | - | - | - | - | - |.dbgop.....|.regtest...|
|.expected......................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedodbg_assert: DBGA ( dregs_hi , uimm16 )\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f000
		                |((dregs($3)&0x7)<<0)                 /* regtest<(dregs_hi) */
		                |((1&0x7)<<3)                            /* dbgop<(1) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((uimm16($5)&0xffff)<<0)                /* expected<(uimm16) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("DBGA LPAREN HIGH_REG COMMA expr RPAREN"); }
		}
	| DBGAH LPAREN REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm16)) {
/* psedodbg_assert:	DBGAH ( dregs , uimm16 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 0 | - | - | - | - | - |.dbgop.....|.regtest...|
|.expected......................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedodbg_assert: DBGAH ( dregs , uimm16 )\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f000
		                |((dregs($3)&0x7)<<0)                    /* regtest<(dregs) */
		                |((3&0x7)<<3)                            /* dbgop<(3) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((uimm16($5)&0xffff)<<0)                /* expected<(uimm16) */
		          ),
		          NULL_CODE));
		  } else { $$ = 0; semantic_error ("DBGAH LPAREN REG COMMA expr RPAREN"); }
		}
	| DBGAL LPAREN REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm16)) {
/* psedodbg_assert:	DBGAL ( dregs , uimm16 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 0 | - | - | - | - | - |.dbgop.....|.regtest...|
|.expected......................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedodbg_assert: DBGAL ( dregs , uimm16 )\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f000
		                |((dregs($3)&0x7)<<0)                    /* regtest<(dregs) */
		                |((2&0x7)<<3)                            /* dbgop<(2) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((uimm16($5)&0xffff)<<0)                /* expected<(uimm16) */
		          ),
		          NULL_CODE));
		  } else { $$ = 0; semantic_error ("DBGAL LPAREN REG COMMA expr RPAREN"); }
		}
	| DBGCMPLX LPAREN REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)) {
/* psedoDEBUG:	DBGCMPLX ( dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: DBGCMPLX ( dregs )\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f800
		                |((dregs($3)&0x7)<<3)                    /* grp<(dregs) */
		                |((6&0x7)<<0)                            /* reg<(6) */
		                |((3&0x3)<<6)                            /* fn<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("DBGCMPLX LPAREN REG RPAREN"); }
		}
	| DBGHALT
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* psedoDEBUG:	DBGHALT
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: DBGHALT\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f800
		                |((5&0x7)<<0)                            /* reg<(5) */
		                |((3&0x3)<<6)                            /* fn<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("DBGHALT"); }
		}
	| DISALGNEXCPT
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* dsp32alu:	DISALGNEXCPT
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: DISALGNEXCPT\n");
		    $$ = CONSCODE(
		        GENCODE(0x00c400
		                |((18&0x1f)<<0)                          /* aopcde<(18) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));
		  } else { $$ = 0; semantic_error ("DISALGNEXCPT"); }
		}
	| DIVQ LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* ALU2op:	DIVQ (dregs, dregs)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: DIVQ (dregs, dregs)\n");
		    $$ = CONSCODE(
		        GENCODE(0x004000
		                |((dregs($3)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* src<(dregs) */
		                |((8&0xf)<<6)                            /* opc<(8) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("DIVQ LPAREN REG COMMA REG RPAREN"); }
		}
	| DIVS LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* ALU2op:	DIVS (dregs, dregs)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: DIVS (dregs, dregs)\n");
		    $$ = CONSCODE(
		        GENCODE(0x004000
		                |((dregs($3)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* src<(dregs) */
		                |((9&0xf)<<6)                            /* opc<(9) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("DIVS LAPREN REG COMMA REG RPAREN"); }
		}
	| EMUEXCPT
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	EMUEXCPT
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: EMUEXCPT\n");
		    $$ = CONSCODE(
		        GENCODE(0x000000
		                |((2&0xf)<<4)                            /* prgfunc<(2) */
		                |((5&0xf)<<0)                            /* poprnd<(5) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("EMUEXCPT"); }
		}
	| EXCPT expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && const_fits($2,c_uimm4)) {
/* ProgCtrl:	EXCPT uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: EXCPT uimm4\n");
		    $$ = CONSCODE(
		        GENCODE(0x000000
		                |((uimm4($2)&0xf)<<0)                    /* poprnd<(uimm4) */
		                |((10&0xf)<<4)                           /* prgfunc<(10) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("EXCPT expr"); }
		}
	| FLUSH LBRACK REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)) {
/* CaCTRL:	FLUSH [ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CaCTRL: FLUSH [ pregs ]\n");
		    $$ = CONSCODE(
		        GENCODE(0x000240
		                |((pregs($3)&0x7)<<0)                    /* reg<(pregs) */
		                |((0&0x1)<<5)                            /* a<(0) */
		                |((2&0x3)<<3)                            /* op<(2) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("FLUSH LBRACK REG RBRACK"); }
		}
	| FLUSH LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)) {
/* CaCTRL:	FLUSH [ pregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CaCTRL: FLUSH [ pregs ++ ]\n");
		    $$ = CONSCODE(
		        GENCODE(0x000240
		                |((pregs($3)&0x7)<<0)                    /* reg<(pregs) */
		                |((1&0x1)<<5)                            /* a<(1) */
		                |((2&0x3)<<3)                            /* op<(2) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("FLUSH LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| FLUSHINV LBRACK REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)) {
/* CaCTRL:	FLUSHINV [ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CaCTRL: FLUSHINV [ pregs ]\n");
		    $$ = CONSCODE(
		        GENCODE(0x000240
		                |((pregs($3)&0x7)<<0)                    /* reg<(pregs) */
		                |((0&0x1)<<5)                            /* a<(0) */
		                |((1&0x3)<<3)                            /* op<(1) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("FLUSHINV LBRACK REG RBRACK"); }
		}
	| FLUSHINV LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)) {
/* CaCTRL:	FLUSHINV [ pregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CaCTRL: FLUSHINV [ pregs ++ ]\n");
		    $$ = CONSCODE(
		        GENCODE(0x000240
		                |((pregs($3)&0x7)<<0)                    /* reg<(pregs) */
		                |((1&0x1)<<5)                            /* a<(1) */
		                |((1&0x3)<<3)                            /* op<(1) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("FLUSHINV LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| W LBRACK REG PLUS expr RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && const_fits($5,c_uimm4s2)
		             && reginclass($8,rc_dregs)) {
/* LDSTii:	W [ pregs + uimm4s2 ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTii: W [ pregs + uimm4s2 ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00a000
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((uimm4s2($5)&0xf)<<6)                  /* offset<(uimm4s2) */
		                |((dregs($8)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x1)<<12)                           /* W<(1) */
		                |((1&0x3)<<10)                           /* op<(1) */
		        ),
		        NULL_CODE);
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && const_fits($5,c_imm16s2)
		             && reginclass($8,rc_dregs)) {
/* LDSTidxI:	W [ pregs + imm16s2 ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: W [ pregs + imm16s2 ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00e400
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($8)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((1&0x3)<<6)                            /* sz<(1) */
		                |((0&0x1)<<8)                            /* Z<(0) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((imm16s2($5)&0xffff)<<0)               /* offset<(imm16s2) */
		          ),
		          NULL_CODE));
		  } else { $$ = 0; semantic_error ("W LBRACK REG PLUS expr RBRACK ASSIGN REG"); }
		}
	| W LBRACK REG RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && reginclass($6,rc_dregs)) {
/* LDST:	W [ pregs ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: W [ pregs ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009000
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($6)&0x7)<<0)                    /* reg<(dregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("W LBRACK REG RBRACK ASSIGN REG"); }
		}
	| W LBRACK REG RBRACK ASSIGN LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_iregs)
		             && reginclass($6,rc_dregs)) {
/* dspLDST:	W [ iregs ] = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: W [ iregs ] = dregs_lo\n");
		    $$ = CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($3)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($6)&0x7)<<0)                 /* reg<(dregs_lo) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((1&0x3)<<5)                            /* m<(1) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && reginclass($6,rc_dregs)) {
/* LDSTpmod:	W [ pregs ] = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: W [ pregs ] = dregs_lo\n");
		    $$ = CONSCODE(
		        GENCODE(0x008000
		                |((pregs($3)&0x7)<<0)                    /* ptr<(pregs) */
		                |((dregs($6)&0x7)<<6)                 /* reg<(dregs_lo) */
		                |((1&0x3)<<9)                            /* aop<(1) */
		                |((1&0x1)<<11)                           /* W<(1) */
		                |((pregs($3)&0x7)<<3)                    /* idx<(pregs($2)) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("W LBRACK REG RBRACK ASSIGN LOW_REG"); }
		}
	| W LBRACK REG RBRACK ASSIGN HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_iregs)
		             && reginclass($6,rc_dregs)) {
/* dspLDST:	W [ iregs ] = dregs_hi
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: W [ iregs ] = dregs_hi\n");
		    $$ = CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($3)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($6)&0x7)<<0)                 /* reg<(dregs_hi) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((2&0x3)<<5)                            /* m<(2) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && reginclass($6,rc_dregs)) {
/* LDSTpmod:	W [ pregs ] = dregs_hi
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: W [ pregs ] = dregs_hi\n");
		    $$ = CONSCODE(
		        GENCODE(0x008000
		                |((pregs($3)&0x7)<<0)                    /* ptr<(pregs) */
		                |((dregs($6)&0x7)<<6)                 /* reg<(dregs_hi) */
		                |((2&0x3)<<9)                            /* aop<(2) */
		                |((1&0x1)<<11)                           /* W<(1) */
		                |((pregs($3)&0x7)<<3)                    /* idx<(pregs($2)) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("W LBRACK REG RBRACK ASSIGN HIGH_REG"); }
		}
	| W LBRACK REG _MINUS_MINUS RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && reginclass($7,rc_dregs)) {
/* LDST:	W [ pregs -- ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: W [ pregs -- ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009000
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($7)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("W LBRACK REG _MINUS_MINUS RBRACK ASSIGN REG"); }
		}
	| W LBRACK REG _MINUS_MINUS RBRACK ASSIGN LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_iregs)
		             && reginclass($7,rc_dregs)) {
/* dspLDST:	W [ iregs -- ] = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: W [ iregs -- ] = dregs_lo\n");
		    $$ = CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($3)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($7)&0x7)<<0)                 /* reg<(dregs_lo) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((1&0x3)<<5)                            /* m<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("W LBRACK REG _MINUS_MINUS RBRACK ASSIGN LOW_REG"); }
		}
	| W LBRACK REG _MINUS_MINUS RBRACK ASSIGN HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_iregs)
		             && reginclass($7,rc_dregs)) {
/* dspLDST:	W [ iregs -- ] = dregs_hi
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: W [ iregs -- ] = dregs_hi\n");
		    $$ = CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($3)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($7)&0x7)<<0)                 /* reg<(dregs_hi) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((2&0x3)<<5)                            /* m<(2) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("W LBRACK REG _MINUS_MINUS RBRACK ASSIGN HIGH_REG"); }
		}
	| W LBRACK REG _PLUS_PLUS RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)
		             && reginclass($7,rc_dregs)) {
/* LDST:	W [ pregs ++ ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: W [ pregs ++ ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009000
		                |((pregs($3)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($7)&0x7)<<0)                    /* reg<(dregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("W LBRACK REG _PLUS_PLUS RBRACK ASSIGN REG"); }
		}
	| W LBRACK REG _PLUS_PLUS RBRACK ASSIGN LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_iregs)
		             && reginclass($7,rc_dregs)) {
/* dspLDST:	W [ iregs ++ ] = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: W [ iregs ++ ] = dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($3)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($7)&0x7)<<0)                 /* reg<(dregs_lo) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((1&0x3)<<5)                            /* m<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("W LBRACK REG _PLUS_PLUS RBRACK ASSIGN LOW_REG"); }
		}
	| W LBRACK REG _PLUS_PLUS RBRACK ASSIGN HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_iregs)
		             && reginclass($7,rc_dregs)) {
/* dspLDST:	W [ iregs ++ ] = dregs_hi
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: W [ iregs ++ ] = dregs_hi\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($3)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($7)&0x7)<<0)                 /* reg<(dregs_hi) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((2&0x3)<<5)                            /* m<(2) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("W LBRACK REG _PLUS_PLUS RBRACK ASSIGN HIGH_REG"); }
		}
	| HLT
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* psedoDEBUG:	HLT
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: HLT\n");
		    $$ = CONSCODE(
		        GENCODE(0x00f800
		                |((4&0x7)<<0)                            /* reg<(4) */
		                |((3&0x3)<<6)                            /* fn<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("HLT"); }
		}
	| IDLE
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	IDLE
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: IDLE\n");
		    $$ = CONSCODE(
		        GENCODE(0x000000
		                |((2&0xf)<<4)                            /* prgfunc<(2) */
		                |((0&0xf)<<0)                            /* poprnd<(0) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("IDLE"); }
		}
	| IF BANG REG REG ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && $3 == REG_CC
		             && reginclass($4,rc_gregs)
		             && reginclass($6,rc_gregs)) {
/* ccMV:	IF ! CC gregs = gregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 1 |.T.|.d.|.s.|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ccMV: IF ! CC gregs = gregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x000600
		                |((gregs($4)&0x7)<<3)                    /* dst<(gregs) */
		                |((gregs($6)&0x7)<<0)                    /* src<(gregs) */
		                |((0&0x1)<<8)                            /* T<(0) */
		                |((Xgregs($4)&0x1)<<7)                   /* d<(Xgregs($4)) */
		                |((Xgregs($6)&0x1)<<6)                   /* s<(Xgregs($6)) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("IF BANG REG REG ASSIGN REG"); }
		}
	| IF REG REG ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && $2 == REG_CC
		             && reginclass($3,rc_gregs)
		             && reginclass($5,rc_gregs)) {
/* ccMV:	IF CC gregs = gregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 1 |.T.|.d.|.s.|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ccMV: IF CC gregs = gregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x000600
		                |((gregs($3)&0x7)<<3)                    /* dst<(gregs) */
		                |((gregs($5)&0x7)<<0)                    /* src<(gregs) */
		                |((1&0x1)<<8)                            /* T<(1) */
		                |((Xgregs($3)&0x1)<<7)                   /* d<(Xgregs($3)) */
		                |((Xgregs($5)&0x1)<<6)                   /* s<(Xgregs($5)) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("IF REG REG ASSIGN REG"); }
		}
	| IFLUSH LBRACK REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)) {
/* CaCTRL:	IFLUSH [ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CaCTRL: IFLUSH [ pregs ]\n");
		    $$ = CONSCODE(
		        GENCODE(0x000240
		                |((pregs($3)&0x7)<<0)                    /* reg<(pregs) */
		                |((0&0x1)<<5)                            /* a<(0) */
		                |((3&0x3)<<3)                            /* op<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("IFLUSH LBRACK REG RBRACK"); }
		}
	| IFLUSH LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)) {
/* CaCTRL:	IFLUSH [ pregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CaCTRL: IFLUSH [ pregs ++ ]\n");
		    $$ = CONSCODE(
		        GENCODE(0x000240
		                |((pregs($3)&0x7)<<0)                    /* reg<(pregs) */
		                |((1&0x1)<<5)                            /* a<(1) */
		                |((3&0x3)<<3)                            /* op<(3) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("IFLUSH LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| JUMP LPAREN PC PLUS REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($5,rc_pregs)) {
/* ProgCtrl:	JUMP ( PC + pregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: JUMP ( PC + pregs )\n");
		    $$ = CONSCODE(
		        GENCODE(0x000000
		                |((pregs($5)&0xf)<<0)                    /* poprnd<(pregs) */
		                |((8&0xf)<<4)                            /* prgfunc<(8) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("JUMP LPAREN PC PLUS REG RPAREN"); }
		}
	| JUMP LPAREN REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($3,rc_pregs)) {
/* ProgCtrl:	JUMP ( pregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: JUMP ( pregs )\n");
		    $$ = CONSCODE(
		        GENCODE(0x000000
		                |((pregs($3)&0xf)<<0)                    /* poprnd<(pregs) */
		                |((5&0xf)<<4)                            /* prgfunc<(5) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("JUMP LPAREN REG RPAREN"); }
		}
	| JUMP expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && const_fits($2,c_pcrel12_jump)) {
/* UJUMP:	JUMP pcrel12
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 0 |.offset........................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("UJUMP: JUMP pcrel12\n");
		    $$ = CONSCODE(GENCODE(0x002000
                             |((pcrel12_jump($2)&0xfff)<<0) /* offset<(pcrel12) */
                                 ),
                         ExprNodeGenReloc($2, BFD_RELOC_12_PCREL_JUMP));
#if 0
		    $$ = CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_12_PCREL_JUMP,$2,
		          GENCODE(0x002000
		                  |((pcrel12_jump($2)&0xfff)<<0)                /* offset<(pcrel12) */
		          )),
		        NULL_CODE);
#endif
		  } else { $$ = 0; semantic_error ("JUMP expr"); }
		}
	| JUMP_DOT_S expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && const_fits($2,c_pcrel12_jump_s)) {
/* UJUMP:	JUMP.S pcrel12
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 0 |.offset........................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("UJUMP: JUMP_DOT_S pcrel12\n");
                    $$ = CONSCODE(GENCODE(0x002000
                             |((pcrel12_jump_s($2)&0xfff)<<0)/* offset<(pcrel12) */
                             ),
                         ExprNodeGenReloc($2, BFD_RELOC_12_PCREL_JUMP_S));

#if 0
		    $$ = CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_12_PCREL_JUMP_S,$2,
		          GENCODE(0x002000
		                  |((pcrel12_jump_s($2)&0xfff)<<0)                /* offset<(pcrel12) */
		          )),
		        NULL_CODE);
#endif

		  } else { $$ = 0; semantic_error ("JUMP_DOT_S expr"); }
		}
	| LBRACK REG PLUS expr RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $2 == REG_FP
		             && const_fits($4,c_negimm5s4)
		             && reginclass($7,rc_dpregs)) {
/* LDSTiiFP:	[ FP + negimm5s4 ] = dpregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 | 1 | 1 | 0 |.W.|.offset............|.reg...........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTiiFP: [ FP + negimm5s4 ] = dpregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00b800
		                |((negimm5s4($4)&0x1f)<<4)               /* offset<(negimm5s4) */
		                |((dpregs($7)&0xf)<<0)                   /* reg<(dpregs) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_pregs)
		             && const_fits($4,c_uimm4s4)
		             && reginclass($7,rc_dregs)) {
/* LDSTii:	[ pregs + uimm4s4 ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTii: [ pregs + uimm4s4 ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00a000
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((uimm4s4($4)&0xf)<<6)                  /* offset<(uimm4s4) */
		                |((dregs($7)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x1)<<12)                           /* W<(1) */
		                |((0&0x3)<<10)                           /* op<(0) */
		        ),
		        NULL_CODE);
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_pregs)
		             && const_fits($4,c_uimm4s4)
		             && reginclass($7,rc_pregs)) {
/* LDSTii:	[ pregs + uimm4s4 ] = pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTii: [ pregs + uimm4s4 ] = pregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00a000
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((uimm4s4($4)&0xf)<<6)                  /* offset<(uimm4s4) */
		                |((pregs($7)&0x7)<<0)                    /* reg<(pregs) */
		                |((1&0x1)<<12)                           /* W<(1) */
		                |((3&0x3)<<10)                           /* op<(3) */
		        ),
		        NULL_CODE);
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_pregs)
		             && const_fits($4,c_imm16s4)
		             && reginclass($7,rc_dregs)) {
/* LDSTidxI:	[ pregs + imm16s4 ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: [ pregs + imm16s4 ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00e400
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($7)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((0&0x3)<<6)                            /* sz<(0) */
		                |((0&0x1)<<8)                            /* Z<(0) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((imm16s4($4)&0xffff)<<0)               /* offset<(imm16s4) */
		          ),
		          NULL_CODE));
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_pregs)
		             && const_fits($4,c_imm16s4)
		             && reginclass($7,rc_pregs)) {
/* LDSTidxI:	[ pregs + imm16s4 ] = pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: [ pregs + imm16s4 ] = pregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x00e400
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((pregs($7)&0x7)<<0)                    /* reg<(pregs) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((0&0x3)<<6)                            /* sz<(0) */
		                |((1&0x1)<<8)                            /* Z<(1) */
		        ),
		        CONSCODE(  
		          GENCODE(0x000000
		                  |((imm16s4($4)&0xffff)<<0)               /* offset<(imm16s4) */
		          ),
		          NULL_CODE));
		  } else { $$ = 0; semantic_error ("LBRACK REG PLUS expr RBRACK ASSIGN REG"); }
		}
	| LBRACK REG RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_iregs)
		             && reginclass($5,rc_dregs)) {
/* dspLDST:	[ iregs ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: [ iregs ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($2)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($5)&0x7)<<0)                    /* reg<(dregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((0&0x3)<<5)                            /* m<(0) */
		        ),
		        NULL_CODE);
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_pregs)
		             && reginclass($5,rc_dregs)) {
/* LDST:	[ pregs ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: [ pregs ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009000
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($5)&0x7)<<0)                    /* reg<(dregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_pregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	[ pregs ] = pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: [ pregs ] = pregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009000
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((pregs($5)&0x7)<<0)                    /* reg<(pregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("LBRACK REG RBRACK ASSIGN REG"); }
		}
	| LBRACK REG _MINUS_MINUS RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_iregs)
		             && reginclass($6,rc_dregs)) {
/* dspLDST:	[ iregs -- ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: [ iregs -- ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($2)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($6)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((0&0x3)<<5)                            /* m<(0) */
		        ),
		        NULL_CODE);
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($2,rc_pregs)
		             && reginclass($6,rc_dregs)) {
/* LDST:	[ pregs -- ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: [ pregs -- ] = dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($6)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_pregs)
		             && reginclass($6,rc_pregs)) {
/* LDST:	[ pregs -- ] = pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: [ pregs -- ] = pregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((pregs($6)&0x7)<<0)                    /* reg<(pregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("LBRACK REG _MINUS_MINUS RBRACK ASSIGN REG"); }
		}
	| LBRACK REG _PLUS_PLUS RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_iregs)
		             && reginclass($6,rc_dregs)) {
/* dspLDST:	[ iregs ++ ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: [ iregs ++ ] = dregs\n");
		    $$ = CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($2)&0x3)<<3)                    /* i<(iregs) */
		                |((dregs($6)&0x7)<<0)                    /* reg<(dregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		                |((0&0x3)<<5)                            /* m<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_pregs)
		             && reginclass($6,rc_dregs)) {
/* LDST:	[ pregs ++ ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: [ pregs ++ ] = dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((dregs($6)&0x7)<<0)                    /* reg<(dregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_pregs)
		             && reginclass($6,rc_pregs)) {
/* LDST:	[ pregs ++ ] = pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: [ pregs ++ ] = pregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((pregs($2)&0x7)<<3)                    /* ptr<(pregs) */
		                |((pregs($6)&0x7)<<0)                    /* reg<(pregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("LBRACK REG _PLUS_PLUS RBRACK ASSIGN REG"); }
		}
	| LBRACK REG _PLUS_PLUS REG RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_iregs)
		             && reginclass($4,rc_mregs)
		             && reginclass($7,rc_dregs)) {
/* dspLDST:	[ iregs ++ mregs ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: [ iregs ++ mregs ] = dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((iregs($2)&0x3)<<3)                    /* i<(iregs) */
		                |((mregs($4)&0x3)<<5)                    /* m<(mregs) */
		                |((dregs($7)&0x7)<<0)                    /* reg<(dregs) */
		                |((3&0x3)<<7)                            /* aop<(3) */
		                |((1&0x1)<<9)                            /* W<(1) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_pregs)
		             && reginclass($4,rc_pregs)
		             && reginclass($7,rc_dregs)) {
/* LDSTpmod:	[ pregs ++ pregs ] = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: [ pregs ++ pregs ] = dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((pregs($2)&0x7)<<0)                    /* ptr<(pregs) */
		                |((pregs($4)&0x7)<<3)                    /* idx<(pregs) */
		                |((dregs($7)&0x7)<<6)                    /* reg<(dregs) */
		                |((0&0x3)<<9)                            /* aop<(0) */
		                |((1&0x1)<<11)                           /* W<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("LBRACK REG _PLUS_PLUS REG RBRACK ASSIGN REG"); }
		}
	| W LBRACK REG _PLUS_PLUS REG RBRACK ASSIGN LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)
		             && reginclass($5,rc_pregs)
		             && reginclass($8,rc_dregs)) {
/* LDSTpmod:	W [ pregs ++ pregs ] = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: W [ pregs ++ pregs ] = dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((pregs($3)&0x7)<<0)                    /* ptr<(pregs) */
		                |((pregs($5)&0x7)<<3)                    /* idx<(pregs) */
		                |((dregs($8)&0x7)<<6)                 /* reg<(dregs_lo) */
		                |((1&0x3)<<9)                            /* aop<(1) */
		                |((1&0x1)<<11)                           /* W<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("W LBRACK REG _PLUS_PLUS REG RBRACK ASSIGN LOW_REG"); }
		}
	| W LBRACK REG _PLUS_PLUS REG RBRACK ASSIGN HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)
		             && reginclass($5,rc_pregs)
		             && reginclass($8,rc_dregs)) {
/* LDSTpmod:	W [ pregs ++ pregs ] = dregs_hi
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: W [ pregs ++ pregs ] = dregs_hi\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((pregs($3)&0x7)<<0)                    /* ptr<(pregs) */
		                |((pregs($5)&0x7)<<3)                    /* idx<(pregs) */
		                |((dregs($8)&0x7)<<6)                 /* reg<(dregs_hi) */
		                |((2&0x3)<<9)                            /* aop<(2) */
		                |((1&0x1)<<11)                           /* W<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("W LBRACK REG _PLUS_PLUS REG RBRACK ASSIGN HIGH_REG"); }
		}
	| LBRACK _MINUS_MINUS REG RBRACK ASSIGN LPAREN REG COLON expr COMMA REG COLON expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $3 == REG_SP
		             && $7 == REG_R7
		             && (EXPR_VALUE($9) >= 0 && EXPR_VALUE($9) < 8)  
		             && $11 == REG_P5
		             && (EXPR_VALUE($13) >= 0 && EXPR_VALUE($13) < 6)  ) {   
/* PushPopMultiple:	[ -- SP ] = ( R7 : reglim , P5 : reglim )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PushPopMultiple: [ -- SP ] = ( R7 : reglim , P5 : reglim )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000400
		                |((imm5($9)&0x7)<<3)                    /* dr<(reglim) */
		                |((imm5($13)&0x7)<<0)                   /* pr<(reglim) */
		                |((1&0x1)<<6)                            /* W<(1) */
		                |((1&0x1)<<8)                            /* d<(1) */
		                |((1&0x1)<<7)                            /* p<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("LBRACK _MINUS_MINUS REG RBRACK ASSIGN LPAREN REG COLON expr COMMA REG COLON expr RPAREN"); }
		}
	| LBRACK _MINUS_MINUS REG RBRACK ASSIGN LPAREN REG COLON expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $3 == REG_SP
		             && $7 == REG_R7
		             && (EXPR_VALUE($9) >= 0 && EXPR_VALUE($9) < 8) ) { 
/* PushPopMultiple:	[ -- SP ] = ( R7 : reglim )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PushPopMultiple: [ -- SP ] = ( R7 : reglim )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000400
		                |((imm5($9)&0x7)<<3)                    /* dr<(dregs) */
		                |((1&0x1)<<6)                            /* W<(1) */
		                |((1&0x1)<<8)                            /* d<(1) */
		                |((0&0x1)<<7)                            /* p<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $3 == REG_SP
		             && $7 == REG_P5
		             && (EXPR_VALUE($9) >= 0 && EXPR_VALUE($9) < 6) ) { 
/* PushPopMultiple:	[ -- SP ] = ( P5 : reglim )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PushPopMultiple: [ -- SP ] = ( P5 : reglim )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000400
		                |((imm5($9)&0x7)<<0)                    /* pr<(pregs) */
		                |((1&0x1)<<6)                            /* W<(1) */
		                |((0&0x1)<<8)                            /* d<(0) */
		                |((1&0x1)<<7)                            /* p<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("LBRACK _MINUS_MINUS REG RBRACK ASSIGN LPAREN REG COLON expr RPAREN"); }
		}
	| LBRACK _MINUS_MINUS REG RBRACK ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $3 == REG_SP
		             && reginclass($6,rc_allregs)) {
/* PushPopReg:	[ -- SP ] = allregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.W.|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PushPopReg: [ -- SP ] = allregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000100
		                |((allregs($6)&0x7)<<0)                  /* reg<(allregs) */
		                |((1&0x1)<<6)                            /* W<(1) */
		                |((Xallregs($6)&0x7)<<3)                 /* grp<(Xallregs($6)) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("LBRACK _MINUS_MINUS REG RBRACK ASSIGN REG"); }
		}
	| LINK expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && const_fits($2,c_uimm16s4)) {
/* linkage:	LINK uimm16s4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.R.|
|.framesize.....................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("linkage: LINK uimm16s4\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e800
		                |((0&0x1)<<0)                            /* R<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((uimm16s4($2)&0xffff)<<0)              /* framesize<(uimm16s4) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LINK expr"); }
		}
	| JUMP_DOT_L expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && const_fits($2,c_pcrel24_jump_l)) {
/* CALLa:	JUMP.L pcrel24
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 1 |.S.|.msw...........................|
|.lsw...........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CALLa: JUMP_DOT_L pcrel24\n");
                    $$ = CONSCODE(GENCODE(0x00e200
                         |(((pcrel24_jump_l($2)>>16)&0xff)<<0)/* msw<(pcrel24)>>16 */
                         |((0&0x1)<<8)                        /* S<(0) */
                         ),
                         ExprNodeGenReloc($2, BFD_RELOC_24_PCREL_JUMP_L));
#if 0
		    $$ =
		      CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_24_PCREL_JUMP_L,$2,
		          GENCODE(0x00e200
		                  |(((pcrel24_jump_l($2)>>16)&0xff)<<0)           /* msw<(pcrel24)>>16 */
		                  |((0&0x1)<<8)                            /* S<(0) */
		          )),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((pcrel24_jump_l($2)&0xffff)<<0)               /* lsw<(pcrel24) */
		          ),
		          NULL_CODE));
#endif

		  } else { $$ = 0; semantic_error ("JUMP_DOT_L expr"); }
		}
        // Copied from JUMP_DOT_L
        | JUMP_DOT_X expr
                {
                  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && const_fits($2,c_pcrel24_call_x)) {
/* CALLa:       JUMP.X pcrel24_call_x
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 1 |.S.|.msw...........................|
|.lsw...........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
                    notethat("CALLa: JUMP_DOT_X pcrel24_call_x\n");
                    $$ = CONSCODE(GENCODE(0x00e200
                         |(((pcrel24_call_x($2)>>16)&0xff)<<0)/* msw<(pcrel24)>>16 */
                         |((0&0x1)<<8)                        /* S<(0) */
                         ),
                         ExprNodeGenReloc($2, BFD_RELOC_24_PCREL_JUMP_X));
#if 0
                    $$ =
                      CONSCODE(
                        NOTERELOC(PCREL,BFD_RELOC_24_PCREL_JUMP_X,$2,
                          GENCODE(0x00e200
                                  |(((pcrel24_call_x($2)>>16)&0xff)<<0)           /* msw<(pcrel24)>>16 */
                                  |((0&0x1)<<8)                            /* S<(0) */
                          )),
                        CONSCODE(
                          GENCODE(0x000000
                                  |((pcrel24_call_x($2)&0xffff)<<0)               /* lsw<(pcrel24) */
                          ),
                          NULL_CODE));
#endif

                  } else { $$ = 0; semantic_error ("JUMP_DOT_L expr"); }
                }

 


	| LPAREN REG COMMA REG RPAREN ASSIGN BYTEOP16P LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($9,rc_dregs)
		             && reginclass($13,rc_dregs)) {
/* dsp32alu:	( dregs , dregs ) = BYTEOP16P ( dregs_pair , dregs_pair ) (aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: ( dregs , dregs ) = BYTEOP16P ( dregs_pair , dregs_pair ) (aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((21&0x1f)<<0)                          /* aopcde<(21) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($2)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($4)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($9)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($13)&0x7)<<0)              /* src1<(dregs_pair) */
		                  |((($17.r0)&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LPAREN REG COMMA REG RPAREN ASSIGN BYTEOP16P LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir"); }
		}
	| LPAREN REG COMMA REG RPAREN ASSIGN BYTEOP16M LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($9,rc_dregs)
		             && reginclass($13,rc_dregs)) {
/* dsp32alu:	( dregs , dregs ) = BYTEOP16M ( dregs_pair , dregs_pair ) (aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: ( dregs , dregs ) = BYTEOP16M ( dregs_pair , dregs_pair ) (aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((21&0x1f)<<0)                          /* aopcde<(21) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($2)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($4)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($9)&0x7)<<3)              /* src0<(dregs_pair) */
		                  |((dregs($13)&0x7)<<0)              /* src1<(dregs_pair) */
		                  |((($17.r0)&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LPAREN REG COMMA REG RPAREN ASSIGN BYTEOP16M LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir"); }
		}
	| LPAREN REG COMMA REG RPAREN ASSIGN BYTEUNPACK REG COLON expr aligndir
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($8,rc_dregs)) {
/* dsp32alu:	( dregs , dregs ) = BYTEUNPACK dregs_pair (aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: ( dregs , dregs ) = BYTEUNPACK dregs_pair (aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((24&0x1f)<<0)                          /* aopcde<(24) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($2)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($4)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($8)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((($11.r0)&0x1)<<13)                     /* s=aligndir.r0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LPAREN REG COMMA REG RPAREN ASSIGN BYTEUNPACK REG COLON expr aligndir"); }
		}
	/*| LPAREN REG COMMA REG RPAREN ASSIGN L PLUS H COMMA L PLUS H LPAREN REG COMMA REG RPAREN*/
        | REG ASSIGN A_ONE_DOT_L PLUS A_ONE_DOT_H COMMA REG ASSIGN A_ZERO_DOT_L PLUS A_ZERO_DOT_H
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($7,rc_dregs)  ) {
/* dsp32alu:	( dregs , dregs ) = L + H , L + H ( A1 , A0 )
   dsp32alu:	dregs = A1.l + A1.h, dregs = A0.l + A0.h
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
	    notethat("dsp32alu: dregs = A1.l + A1.h, dregs = A0.l + A0.h  \n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((12&0x1f)<<0)                          /* aopcde<(12) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($7)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN A1.L PLUS A1.H COMMA REG ASSIGN A0.L PLUS A0.H"); }
		}
	| LPAREN REG COMMA REG RPAREN ASSIGN SEARCH REG LPAREN searchmod RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($8,rc_dregs)) {
/* dsp32alu:	( dregs , dregs ) = SEARCH dregs (searchmod)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: ( dregs , dregs ) = SEARCH dregs (searchmod)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((13&0x1f)<<0)                          /* aopcde<(13) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($2)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($4)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($8)&0x7)<<3)                    /* src0<(dregs) */
		                  |((($10.r0)&0x3)<<14)                     /* aop=searchmod.r0 */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LPAREN REG COMMA REG RPAREN ASSIGN SEARCH REG LPAREN searchmod RPAREN"); }
		}
	| REG ASSIGN REG _PLUS_BAR_MINUS REG COMMA REG ASSIGN REG _MINUS_BAR_PLUS REG amod2 
        	{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
                             && reginclass($3,rc_dregs)
                             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)
		             && reginclass($9,rc_dregs)
		             && reginclass($11,rc_dregs)) {
/* dsp32alu:	dregs = dregs +|- dregs , dregs = dregs -|+ dregs (amod2)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu:  dregs = dregs +|- dregs , dregs = dregs -|+ dregs (amod2)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((1&0x1f)<<0)                           /* aopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($7)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                   /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                   /* src1<(dregs) */
		                  |((($12.r0)&0x3)<<14)                    /* aop=amod2.r0 */
		                  |((0&0x1)<<13)                    /* s=amod0.s0 */
		                  |((0&0x1)<<12)                    /* x=amod0.x0 */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _PLUS_BAR_MINUS REG COMMA REG ASSIGN REG _MINUS_BAR_PLUS REG amod2"); }
		}
	| REG ASSIGN REG _PLUS_BAR_MINUS REG COMMA REG ASSIGN REG _MINUS_BAR_PLUS REG LPAREN S COMMA ASR RPAREN
        	{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
                             && reginclass($3,rc_dregs)
                             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)
		             && reginclass($9,rc_dregs)
		             && reginclass($11,rc_dregs)) {
/* dsp32alu:	dregs = dregs +|- dregs , dregs = dregs -|+ dregs (S, ASR)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu:  dregs = dregs +|- dregs , dregs = dregs -|+ dregs (S, ASR)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((1&0x1f)<<0)                           /* aopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($7)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                   /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                   /* src1<(dregs) */
		                  |((2&0x3)<<14)                    /* aop=amod2.r0 */
		                  |((1&0x1)<<13)                    /* s=amod0.s0 */
		                  |((0&0x1)<<12)                    /* x=amod0.x0 */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _PLUS_BAR_MINUS REG COMMA REG ASSIGN REG _MINUS_BAR_PLUS REG LPAREN S COMMA ASR RPAREN"); }
		}
	| REG ASSIGN REG _PLUS_BAR_MINUS REG COMMA REG ASSIGN REG _MINUS_BAR_PLUS REG LPAREN S COMMA ASL RPAREN
        	{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
                             && reginclass($3,rc_dregs)
                             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)
		             && reginclass($9,rc_dregs)
		             && reginclass($11,rc_dregs)) {
/* dsp32alu:	dregs = dregs +|- dregs , dregs = dregs -|+ dregs (S, ASL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu:  dregs = dregs +|- dregs , dregs = dregs -|+ dregs (S, ASL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((1&0x1f)<<0)                           /* aopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($7)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                   /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                   /* src1<(dregs) */
		                  |((3&0x3)<<14)                    /* aop=amod2.r0 */
		                  |((1&0x1)<<13)                    /* s=amod0.s0 */
		                  |((0&0x1)<<12)                    /* x=amod0.x0 */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _PLUS_BAR_MINUS REG COMMA REG ASSIGN REG _MINUS_BAR_PLUS REG LPAREN S COMMA ASL RPAREN"); }
		}
	| REG ASSIGN REG_A11 PLUS REG_A00 COMMA REG ASSIGN REG_A11 MINUS REG_A00 amod1 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($7,rc_dregs)
		             && $3 == REG_A1
                             && $5 == REG_A0
                             && $9 == REG_A1
		             && $11 == REG_A0) {
/* dsp32alu: dregs = A1 + A0 , dregs = A1 - A0 (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = A1 + A0 , dregs = A1 - A0 (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((17&0x1f)<<0)                          /* aopcde<(17) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($7)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((($12.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($12.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG_A11 PLUS REG_A00 COMMA REG ASSIGN REG_A11 MINUS REG_A00 LPAREN amod1 RPAREN"); }
		}
	| REG ASSIGN REG_A00 PLUS REG_A11 COMMA REG ASSIGN REG_A00 MINUS REG_A11 amod1 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs)
		             && reginclass($7,rc_dregs)
		             && $3 == REG_A0
                             && $5 == REG_A1
                             && $9 == REG_A0
		             && $11 == REG_A1) {
/* dsp32alu: dregs = A0 + A1 , dregs = A0 - A1 (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = A0 + A1 , dregs = A0 - A1 (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((17&0x1f)<<0)                          /* aopcde<(17) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($7)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((($12.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($12.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG_A00 PLUS REG_A11 COMMA REG ASSIGN REG_A00 MINUS REG_A11 LPAREN amod1 RPAREN"); }
		}
	| REG ASSIGN REG PLUS REG COMMA REG ASSIGN REG MINUS REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs)
                             && reginclass($9,rc_dregs)
		             && reginclass($11,rc_dregs)) {
/* dsp32alu: dregs = dregs + dregs , dregs = dregs - dregs (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs + dregs , dregs = dregs - dregs (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((4&0x1f)<<0)                           /* aopcde<(4) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($7)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                   /* src1<(dregs) */
		                  |((($12.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($12.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG PLUS REG COMMA REG ASSIGN REG MINUS REG LPAREN amod1 RPAREN"); }
		}
	| REG ASSIGN REG _PLUS_BAR_PLUS REG COMMA REG ASSIGN REG _MINUS_BAR_MINUS REG amod2
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
                             && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs)
		             && reginclass($9,rc_dregs)
		             && reginclass($11,rc_dregs)) {
/* dsp32alu:	dregs = dregs +|+ dregs , dregs = dregs -|- dregs (amod2)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs +|+ dregs , dregs = dregs -|- dregs (amod2)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((1&0x1f)<<0)                           /* aopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst1<(dregs) */
		                  |((dregs($7)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                   /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                   /* src1<(dregs) */
		                  |((($12.r0)&0x3)<<14)                    /* aop=amod2.r0 */
		                  |((0&0x1)<<13)                    /* s=amod0.s0 */
		                  |((0&0x1)<<12)                    /* x=amod0.x0 */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN REG _PLUS_BAR_PLUS REG COMMA REG ASSIGN REG _MINUS_BAR_MINUS REG amod2"); }
		}
	| REG ASSIGN REG _PLUS_BAR_PLUS REG COMMA REG ASSIGN REG _MINUS_BAR_MINUS REG LPAREN S COMMA ASR RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
                             && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs)
		             && reginclass($9,rc_dregs)
		             && reginclass($11,rc_dregs)) {
/*  dsp32alu:	dregs = dregs +|+ dregs , dregs = dregs -|- dregs (S, ASR)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs +|+ dregs , dregs = dregs -|- dregs (S, ASR)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)
		                |((1&0x1f)<<0)
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)
		                  |((dregs($7)&0x7)<<9)
		                  |((dregs($3)&0x7)<<3)
		                  |((dregs($5)&0x7)<<0)
		                  |((2&0x3)<<14)
		                  |((1&0x1)<<13)
		                  |((0&0x1)<<12)
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN REG _PLUS_BAR_PLUS REG COMMA REG ASSIGN REG _MINUS_BAR_MINUS REG LPAREN S COMMA ASR RPAREN"); }
		}
	| REG ASSIGN REG _PLUS_BAR_PLUS REG COMMA REG ASSIGN REG _MINUS_BAR_MINUS REG LPAREN S COMMA ASL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
                             && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs)
		             && reginclass($9,rc_dregs)
		             && reginclass($11,rc_dregs)) {
/*  dsp32alu:	dregs = dregs +|+ dregs , dregs = dregs -|- dregs (S, ASL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs +|+ dregs , dregs = dregs -|- dregs (S, ASL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)
		                |((1&0x1f)<<0)
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)
		                  |((dregs($7)&0x7)<<9)
		                  |((dregs($3)&0x7)<<3)
		                  |((dregs($5)&0x7)<<0)
		                  |((3&0x3)<<14)
		                  |((1&0x1)<<13)
		                  |((0&0x1)<<12)
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN REG _PLUS_BAR_PLUS REG COMMA REG ASSIGN REG _MINUS_BAR_MINUS REG LPAREN S COMMA ASL RPAREN"); }
		}
	| LPAREN REG COLON expr COMMA REG COLON expr RPAREN ASSIGN LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $2 == REG_R7
		             && (EXPR_VALUE($4) >= 0 && EXPR_VALUE($4) < 8)  
		             && $6 == REG_P5
		             && (EXPR_VALUE($8) >= 0 && EXPR_VALUE($8) < 6)  
		             && $12 == REG_SP) {
/* PushPopMultiple:	( R7 : reglim , P5 : reglim ) = [ SP ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PushPopMultiple: ( R7 : reglim , P5 : reglim ) = [ SP ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000400
		                |((imm5($4)&0x7)<<3)                    /* dr<(dregs) */
		                |((imm5($8)&0x7)<<0)                    /* pr<(pregs) */
		                |((0&0x1)<<6)                            /* W<(0) */
		                |((1&0x1)<<8)                            /* d<(1) */
		                |((1&0x1)<<7)                            /* p<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("LPAREN REG COLON expr COMMA REG COLON expr RPAREN ASSIGN LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| LPAREN REG COLON expr RPAREN ASSIGN LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $2 == REG_R7
		             && (EXPR_VALUE($4) >= 0 && EXPR_VALUE($4) < 8)  
		             && $8 == REG_SP) {
/* PushPopMultiple:	( R7 : reglim ) = [ SP ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PushPopMultiple: ( R7 : reglim ) = [ SP ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000400
		                |((imm5($4)&0x7)<<3)                    /* dr<(dregs) */
		                |((0&0x1)<<6)                            /* W<(0) */
		                |((1&0x1)<<8)                            /* d<(1) */
		                |((0&0x1)<<7)                            /* p<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $2 == REG_P5
		             && (EXPR_VALUE($4) >= 0 && EXPR_VALUE($4) < 6)  
		             && $8 == REG_SP) {
/* PushPopMultiple:	( P5 : reglim ) = [ SP ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PushPopMultiple: ( P5 : reglim ) = [ SP ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000400
		                |((imm5($4)&0x7)<<0)                    /* pr<(pregs) */
		                |((0&0x1)<<6)                            /* W<(0) */
		                |((0&0x1)<<8)                            /* d<(0) */
		                |((1&0x1)<<7)                            /* p<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("LPAREN REG COLON expr RPAREN ASSIGN LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| LSETUP LPAREN expr COMMA expr RPAREN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && const_fits($3,c_pcrel5)
		             && const_fits($5,c_pcrel11)
		             && reginclass($7,rc_counters)) {
/* LoopSetup:	LSETUP ( pcrel4 , lppcrel10 ) counters
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |.rop...|.c.|.soffset.......|
|.reg...........| - | - |.eoffset...............................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LoopSetup: LSETUP ( pcrel4 , lppcrel10 ) counters\n");
                    $$ = CONSCODE(GENCODE(0x00e080
                                  |((pcrel5($3)&0xf)<<0)/* soffset<(pcrel4) */
                                  |((counters($7)&0x1)<<4)/* c<(counters) */
                                  |((0&0x3)<<5)           /* rop<(0) */
                            ),
                            CONCTCODE(ExprNodeGenReloc($3, BFD_RELOC_5_PCREL),
                                     ExprNodeGenReloc($5, BFD_RELOC_11_PCREL)));
#if 0
		    $$ =
		      CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_5_PCREL,$3,
		          GENCODE(0x00e080
		                  |((pcrel5($3)&0xf)<<0)                   /* soffset<(pcrel4) */
		                  |((counters($7)&0x1)<<4)                 /* c<(counters) */
		                  |((0&0x3)<<5)                            /* rop<(0) */
		          )),
		        CONSCODE(
		          NOTERELOC(PCREL,BFD_RELOC_11_PCREL,$5,
		            GENCODE(0x000000
		                    |((pcrel11($5)&0x3ff)<<0)              /* eoffset<(lppcrel10) */
		            )),
		          NULL_CODE));
#endif

		  } else { $$ = 0; semantic_error ("LSETUP LPAREN expr COMMA expr RPAREN REG"); }
		}
	| LSETUP LPAREN expr COMMA expr RPAREN REG ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && const_fits($3,c_pcrel5)
		             && const_fits($5,c_pcrel11)
		             && reginclass($7,rc_counters)
		             && reginclass($9,rc_pregs)) {
/* LoopSetup:	LSETUP ( pcrel4 , lppcrel10 ) counters = pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |.rop...|.c.|.soffset.......|
|.reg...........| - | - |.eoffset...............................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
#if 0
		    int value;
			value = 0x00000000 | ((pcrel11($5)&0x3ff)<<0) | 
				((pregs($9)&0xf)<<12);
#endif
		    notethat("LoopSetup: LSETUP ( pcrel4 , lppcrel10 ) counters = pregs\n");
                    $$ = CONSCODE(GENCODE(0x00e080
                                  |((pcrel5($3)&0xf)<<0)  /* soffset<(pcrel4) */
                                  |((counters($7)&0x1)<<4)/* c<(counters) */
                                  |((1&0x3)<<5)           /* rop<(1) */
                          ),
			  CONCTCODE( ExprNodeGenReloc($3, BFD_RELOC_5_PCREL),
                          CONCTCODE(GENCODE(0x000000
                                    |((pcrel11($5)&0x3ff)<<0)              /* eoffset<(lppcrel10) */
                                    |((pregs($9)&0xf)<<12)                   /* reg<(pregs) */
                                    ),
                                    ExprNodeGenReloc($5, BFD_RELOC_11_PCREL))));
#if 0
			CONSCODE(CONSCODE(GENCODE(value), NULL_CODE),
			NOTERELOC1(1, BFD_RELOC_11_PCREL, ($5)->value.s_value, GENCODE(0x0)))));
#endif
#if 0
		    $$ =
		      CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_5_PCREL,$3,
		          GENCODE(0x00e080
		                  |((pcrel5($3)&0xf)<<0)                   /* soffset<(pcrel4) */
		                  |((counters($7)&0x1)<<4)                 /* c<(counters) */
		                  |((1&0x3)<<5)                            /* rop<(1) */
		          )),
		        CONSCODE(
		          NOTERELOC(PCREL,BFD_RELOC_11_PCREL,$5,
		            GENCODE(0x000000
		                    |((pcrel11($5)&0x3ff)<<0)              /* eoffset<(lppcrel10) */
		                    |((pregs($9)&0xf)<<12)                   /* reg<(pregs) */
		            )),
		          NULL_CODE));
#endif

		  } else { $$ = 0; semantic_error ("LSETUP LPAREN expr COMMA expr RPAREN REG ASSIGN REG"); }
		}
	| LSETUP LPAREN expr COMMA expr RPAREN REG ASSIGN REG GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && const_fits($3,c_pcrel5)
		             && const_fits($5,c_pcrel11)
		             && reginclass($7,rc_counters)
		             && reginclass($9,rc_pregs)
		             && EXPR_VALUE($11) == 1) {
/* LoopSetup:	LSETUP ( pcrel4 , lppcrel10 ) counters = pregs >> 1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |.rop...|.c.|.soffset.......|
|.reg...........| - | - |.eoffset...............................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LoopSetup: LSETUP ( pcrel4 , lppcrel10 ) counters = pregs >> 1\n");
                    $$ = CONSCODE(GENCODE(0x00e080
                                  |((pcrel5($3)&0xf)<<0)  /* soffset<(pcrel4) */
                                  |((counters($7)&0x1)<<4)/* c<(counters) */
                                  |((3&0x3)<<5)           /* rop<(3) */
                             ),
                             CONCTCODE(ExprNodeGenReloc($3, BFD_RELOC_5_PCREL),
                                       ExprNodeGenReloc($5, BFD_RELOC_11_PCREL)));
#if 0
		    $$ =
		      CONSCODE(
		        NOTERELOC(PCREL,BFD_RELOC_5_PCREL,$3,
		          GENCODE(0x00e080
		                  |((pcrel5($3)&0xf)<<0)                   /* soffset<(pcrel4) */
		                  |((counters($7)&0x1)<<4)                 /* c<(counters) */
		                  |((3&0x3)<<5)                            /* rop<(3) */
		          )),
		        CONSCODE(
		          NOTERELOC(PCREL,BFD_RELOC_11_PCREL,$5,
		            GENCODE(0x000000
		                    |((pcrel11($5)&0x3ff)<<0)              /* eoffset<(lppcrel10) */
		                    |((pregs($9)&0xf)<<12)                   /* reg<(pregs) */
		            )),
		          NULL_CODE));
#endif

		  } else { $$ = 0; semantic_error ("LSETUP LPAREN expr COMMA expr RPAREN REG ASSIGN REG GREATER_GREATER expr"); }
		}
	| REG ASSIGN expr LPAREN Z RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_regs)
		             && const_fits($3,c_luimm16) ) {
/* LDIMMhalf:	regs = luimm16 (z) 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDIMMhalf: regs = luimm16 (z)\n");
                    $$ = CONSCODE(GENCODE(0x00e100
                                |((regs($1)&0x7)<<0)       /* reg<(regs) */
                                |((Xregs($1)&0x3)<<3)      /* grp<(Xregs($3)) */
                                |((0&0x1)<<6)              /* H<(0) */
                                |((0&0x1)<<5)              /* S<(0) */
                                |((1&0x1)<<7)              /* Z<(1) */
                           ),
                           ExprNodeGenReloc($3, BFD_RELOC_16_LOW));
#if 0
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e100
		                |((regs($1)&0x7)<<0)                     /* reg<(regs) */
		                |((Xregs($1)&0x3)<<3)                    /* grp<(Xregs($3)) */
		                |((0&0x1)<<6)                            /* H<(0) */
		                |((0&0x1)<<5)                            /* S<(0) */
		                |((1&0x1)<<7)                            /* Z<(1) */
		        ),
		        CONSCODE(
		          NOTERELOC(0,BFD_RELOC_16_LOW,$3,
		            GENCODE(0x000000
		                    |((luimm16($3)&0xffff)<<0)               /* hword<(luimm16) */
		            )),
		          NULL_CODE));
#endif

		  } else { $$ = 0; semantic_error ("REG ASSIGN expr LPAREN Z RPAREN"); }
		}
	| NOP
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	NOP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: NOP\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((0&0xf)<<4)                            /* prgfunc<(0) */
		                |((0&0xf)<<0)                            /* poprnd<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("NOP"); }
		}
	| REG _ASSIGN_BANG REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC && $3 == REG_CC) {
/* CC2dreg:	CC =! CC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2dreg: CC =! CC\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000200
		                |((3&0x3)<<3)                            /* op<(3) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _ASSIGN_BANG REG"); }
		}
	| OUTC REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs)) {
/* psedoDEBUG:	OUTC dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: OUTC dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00f800
		                |((dregs($2)&0x7)<<0)                    /* reg<(dregs) */
		                |((0&0x7)<<3)                            /* grp<(0) */
		                |((2&0x3)<<6)                            /* fn<(2) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("OUTC REG"); }
		}
	| OUTC expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && const_fits($2,c_uimm8)) {
/* psedoOChar:	OUTC uimm8
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 |.ch............................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoOChar: OUTC uimm8\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00f900
		                |((uimm8($2)&0xff)<<0)                   /* ch<(uimm8) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("OUTC expr"); }
		}
	| PREFETCH LBRACK REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)) {
/* CaCTRL:	PREFETCH [ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CaCTRL: PREFETCH [ pregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000240
		                |((pregs($3)&0x7)<<0)                    /* reg<(pregs) */
		                |((0&0x1)<<5)                            /* a<(0) */
		                |((0&0x3)<<3)                            /* op<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("PREFETCH LBRACK REG RBRACK"); }
		}
	| PREFETCH LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)) {
/* CaCTRL:	PREFETCH [ pregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CaCTRL: PREFETCH [ pregs ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000240
		                |((pregs($3)&0x7)<<0)                    /* reg<(pregs) */
		                |((1&0x1)<<5)                            /* a<(1) */
		                |((0&0x3)<<3)                            /* op<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("PREFETCH LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| PRNT REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_allregs)) {
/* psedoDEBUG:	PRNT allregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("psedoDEBUG: PRNT allregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00f800
		                |((allregs($2)&0x7)<<0)                  /* reg<(allregs) */
		                |((Xallregs($2)&0x7)<<3)                 /* grp<(Xallregs($2)) */
		                |((1&0x3)<<6)                            /* fn<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("PRNT REG"); }
		}
	| RAISE expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && const_fits($2,c_uimm4)) {
/* ProgCtrl:	RAISE uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: RAISE uimm4\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((uimm4($2)&0xf)<<0)                    /* poprnd<(uimm4) */
		                |((9&0xf)<<4)                            /* prgfunc<(9) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("RAISE expr"); }
		}
  /* Third Pattern Page 7.75 */
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)               /*   src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)               /*     src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                 /*   src0<(dregs)  */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)               /*   src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)               /*     src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                 /*   src0<(dregs)  */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)               /*   src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)               /*     src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                 /*   src0<(dregs)  */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)               /*   src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)               /*     src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:	A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                 /*   src0<(dregs)  */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
/* Sixth Pattern Page 7.75 */
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc LOW_REG STAR HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc LOW_REG * HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * LOW_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| A1macfunc HIGH_REG STAR HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs) == reginclass($11,rc_dregs)
                             && reginclass($4,rc_dregs) == reginclass($13,rc_dregs)
		             && reginclass($7,rc_dregs) && ((dregs($7)&0x7)%2)==0) {
/* dsp32mac:   A1macfunc (mxd_mod) , dregs = ( A0macfunc ) (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: A1macfunc (mxd_mod), dregs = ( A0macfunc ) (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($1.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($5.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($7)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($10.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($2)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                 /*   src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("A1macfunc HIGH_REG * HIGH_REG mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN ABS REG LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* dsp32alu:	dregs = ABS dregs ( V )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = ABS dregs ( V )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((6&0x1f)<<0)                           /* aopcde<(6) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<3)                    /* src0<(dregs) */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ABS REG LPAREN V RPAREN"); }
		}
	| REG_A00 ASSIGN ABS REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $4 == REG_A0) {
/* dsp32alu:	A0 = ABS A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 = ABS A0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((16&0x1f)<<0)                          /* aopcde<(16) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN ABS REG_A00"); }
		}
	| REG_A00 ASSIGN ABS REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $4 == REG_A1) {
/* dsp32alu:	A0 = ABS A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 = ABS A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((16&0x1f)<<0)                          /* aopcde<(16) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN ABS REG_A11"); }
		}
	| REG_A11 ASSIGN ABS REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $4 == REG_A0) {
/* dsp32alu:	A1 = ABS A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = ABS A0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((16&0x1f)<<0)                          /* aopcde<(16) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN ABS REG_A00"); }
		}
	| REG_A11 ASSIGN ABS REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $4 == REG_A1) {
/* dsp32alu:	A1 = ABS A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = ABS A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((16&0x1f)<<0)                          /* aopcde<(16) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN ABS REG_A11"); }
		}
	| REG ASSIGN ABS REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* dsp32alu:	dregs = ABS dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = ABS dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((7&0x1f)<<0)                           /* aopcde<(7) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<3)                    /* src0<(dregs) */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ABS REG"); }
		}
	| REG ASSIGN ALIGN16 LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = ALIGN16 ( dregs , dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = ALIGN16 ( dregs , dregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((13&0x1f)<<0)                          /* sopcde<(13) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ALIGN16 LPAREN REG COMMA REG RPAREN"); }
		}
	| REG ASSIGN ALIGN24 LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = ALIGN24 ( dregs , dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = ALIGN24 ( dregs , dregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((13&0x1f)<<0)                          /* sopcde<(13) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ALIGN24 LPAREN REG COMMA REG RPAREN"); }
		}
	| REG ASSIGN ALIGN8 LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = ALIGN8 ( dregs , dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = ALIGN8 ( dregs , dregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((13&0x1f)<<0)                          /* sopcde<(13) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ALIGN8 LPAREN REG COMMA REG RPAREN"); }
		}
	| REG_A00 ASSIGN ASHIFT REG_A00 BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $4 == REG_A0
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	A0 = ASHIFT  A0 BY dregs_lo 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: A0 = ASHIFT A0 BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN ASHIFT REG_A00 BY LOW_REG"); }
		}
	| REG_A11 ASSIGN ASHIFT REG_A11 BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $4 == REG_A1
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	A1 = ASHIFT A1 BY dregs_lo 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: A1 = ASHIFT A1 BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN ASHIFT REG_A11 BY LOW_REG"); }
		}
	| REG ASSIGN ASHIFT REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs = ASHIFT dregs BY dregs_lo 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = ASHIFT dregs BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ASHIFT REG BY LOW_REG"); }
		}
	| LOW_REG ASSIGN ASHIFT HIGH_REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_lo = ASHIFT dregs_hi BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = ASHIFT dregs_hi BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN ASHIFT HIGH_REG BY LOW_REG"); }
		}
	| HIGH_REG ASSIGN ASHIFT LOW_REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_hi = ASHIFT dregs_lo BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_hi = ASHIFT dregs_lo BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<12)                           /* HLs<(2) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN ASHIFT LOW_REG BY LOW_REG"); }
		}
	| HIGH_REG ASSIGN ASHIFT HIGH_REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_hi = ASHIFT dregs_hi BY dregs_lo 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_hi = ASHIFT dregs_hi BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((3&0x3)<<12)                           /* HLs<(3) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN ASHIFT HIGH_REG BY LOW_REG"); }
		}
	| LOW_REG ASSIGN ASHIFT LOW_REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_lo = ASHIFT dregs_lo BY dregs_lo 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = ASHIFT dregs_lo BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN ASHIFT LOW_REG BY LOW_REG"); }
		}
	| LOW_REG ASSIGN ASHIFT LOW_REG BY LOW_REG LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_lo = ASHIFT dregs_lo BY dregs_lo (S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = ASHIFT dregs_lo BY dregs_lo (S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN ASHIFT LOW_REG BY LOW_REG LPAREN S RPAREN"); }
		}
	| LOW_REG ASSIGN ASHIFT HIGH_REG BY LOW_REG LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_lo = ASHIFT dregs_hi BY dregs_lo (S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = ASHIFT dregs_hi BY dregs_lo (S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN ASHIFT HIGH_REG BY LOW_REG LPAREN S RPAREN"); }
		}
	| HIGH_REG ASSIGN ASHIFT LOW_REG BY LOW_REG LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_hi = ASHIFT dregs_lo BY dregs_lo (S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_hi = ASHIFT dregs_lo BY dregs_lo (S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<12)                           /* HLs<(2) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN ASHIFT LOW_REG BY LOW_REG LPAREN S RPAREN"); }
		}
	| HIGH_REG ASSIGN ASHIFT HIGH_REG BY LOW_REG LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_hi = ASHIFT dregs_hi BY dregs_lo (S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_hi = ASHIFT dregs_hi BY dregs_lo (S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((3&0x3)<<12)                           /* HLs<(3) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN ASHIFT HIGH_REG BY LOW_REG LPAREN S RPAREN"); }
		}
	| REG ASSIGN ASHIFT REG BY LOW_REG LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs = ASHIFT dregs BY dregs_lo (S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = ASHIFT dregs BY dregs_lo (S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ASHIFT REG BY LOW_REG LPAREN S RPAREN"); }
		}
        | REG_A00 ASSIGN REG_A00 LESS_LESS expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $3 == REG_A0
		             && const_fits($5,c_uimm5)) {
/* dsp32shiftimm:	A0 = A0 << uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: A0 = A0 << uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm6($5)&0x3f)<<3)                    /* immag<(imm6) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN REG_A00 LESS_LESS expr"); }
		}
        | REG_A11 ASSIGN REG_A11 LESS_LESS expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $3 == REG_A1
		             && const_fits($5,c_uimm5)) {
/* dsp32shiftimm:	A1 = A1 << uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: A1 = A1 << uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm6($5)&0x3f)<<3)                    /* immag<(imm6) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN REG_A11 LESS_LESS expr"); }
		}
        | REG ASSIGN REG LESS_LESS expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5)) {
/* dsp32shiftimm:	dregs = dregs << uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs =  dregs << uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |((imm6($5)&0x3f)<<3)                    /* immag<(imm6) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)
		             && EXPR_VALUE($5) == 2) {
/* PTR2op:	pregs = pregs << 2
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PTR2op: pregs = pregs << 2\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004400
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<3)                    /* src<(pregs) */
		                |((1&0x7)<<6)                            /* opc<(1) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)
		             && EXPR_VALUE($5) == 1) {
/* COMP3op:	pregs = pregs << 1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: pregs = pregs << 1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((pregs($1)&0x7)<<6)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<0)                    /* src0<(pregs) */
		                |((5&0x7)<<9)                            /* opc<(5) */
		                |((pregs($3)&0x7)<<3)                    /* src1<(pregs($3)) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG LESS_LESS expr"); }
		}
        | LOW_REG ASSIGN HIGH_REG LESS_LESS expr sornothing 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm4)) {
/* dsp32shiftimm:	dregs_lo = dregs_hi << uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_lo = dregs_hi << uimm4\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((imm5($5)&0x3f)<<3)                    /* immag<(imm5) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		                  |(($6.r0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN HIGH_REG LESS_LESS expr sornothing"); }
		}
        | HIGH_REG ASSIGN LOW_REG LESS_LESS expr sornothing
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm4)) {
/* dsp32shiftimm:	dregs_hi = dregs_lo << uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_hi = dregs_lo << uimm4\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((imm5($5)&0x3f)<<3)                    /* immag<(imm5) */
		                  |((2&0x3)<<12)                           /* HLs<(2) */
		                  |(($6.r0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG LESS_LESS expr"); }
		}
        | HIGH_REG ASSIGN HIGH_REG LESS_LESS expr sornothing
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm4)) {
/* dsp32shiftimm:	dregs_hi = dregs_hi << uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_hi = dregs_hi << uimm4\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((imm5($5)&0x3f)<<3)                    /* immag<(imm5) */
		                  |((3&0x3)<<12)                           /* HLs<(3) */
		                  |(($6.r0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN HIGH_REG LESS_LESS expr"); }
		}
        | LOW_REG ASSIGN LOW_REG LESS_LESS expr sornothing
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm4)) {
/* dsp32shiftimm:	dregs_lo = dregs_lo << uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_lo = dregs_lo << uimm4\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((imm5($5)&0x3f)<<3)                    /* immag<(imm5) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		                  |(($6.r0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LOW_REG LESS_LESS expr"); }
		}
	| REG ASSIGN REG LESS_LESS expr LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm6)>=0 ) {
/* dsp32shiftimm:	dregs = dregs << uimm5 ( S )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs = dregs << uimm5 ( S )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |((imm6($5)&0x3f)<<3)                    /* immag<(imm6) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG LESS_LESS expr LPAREN S RPAREN"); }
		}
	| REG ASSIGN ASHIFT REG BY LOW_REG LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs = ASHIFT dregs BY dregs_lo (V)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = ASHIFT dregs BY dregs_lo (V)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((1&0x1f)<<0)                           /* sopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ASHIFT REG BY LOW_REG LPAREN V RPAREN"); }
		}
	| REG ASSIGN ASHIFT REG BY LOW_REG LPAREN V COMMA S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs = ASHIFT dregs BY dregs_lo ( V , S )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = ASHIFT dregs BY dregs_lo ( V , S )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((1&0x1f)<<0)                           /* sopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN ASHIFT REG BY LOW_REG LPAREN V COMMA S RPAREN"); }
		}
	| REG ASSIGN REG LESS_LESS expr LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm5)>=0) {
/* dsp32shiftimm:	dregs = dregs << expr ( V )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs = dregs << expr ( V )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((1&0x1f)<<0)                           /* sopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |((imm5($5)&0x3f)<<3)                    /* immag<(imm5) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG LESS_LESS expr LPAREN V RPAREN"); }
		}
	|  REG ASSIGN REG LESS_LESS expr LPAREN V COMMA S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm5)>=0 ) {
/* dsp32shiftimm:	dregs = dregs << imm5 ( V , S )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs = dregs << imm5 ( V , S )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((1&0x1f)<<0)                           /* sopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |((imm5($5)&0x3f)<<3)                    /* immag<(imm5) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG LESS_LESS expr LPAREN V COMMA S RPAREN"); }
		}
	| REG ASSIGN B LBRACK REG PLUS expr RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && const_fits($7,c_imm16)) {
/* LDSTidxI:	dregs = B [ pregs + imm16 ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: dregs = B [ pregs + imm16 ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e400
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((2&0x3)<<6)                            /* sz<(2) */
		                |((0&0x1)<<8)                            /* Z<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16($7)&0xffff)<<0)                 /* offset<(imm16) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN B LBRACK REG PLUS expr RBRACK LPAREN Z RPAREN"); }
		}
	| REG ASSIGN B LBRACK REG RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = B [ pregs ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = B [ pregs ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN B LBRACK REG RBRACK LPAREN Z RPAREN"); }
		}
	| REG ASSIGN B LBRACK REG _MINUS_MINUS RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = B [ pregs -- ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = B [ pregs -- ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN B LBRACK REG _MINUS_MINUS RBRACK LPAREN Z RPAREN"); }
		}
	| REG ASSIGN B LBRACK REG _PLUS_PLUS RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = B [ pregs ++ ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = B [ pregs ++ ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN B LBRACK REG _PLUS_PLUS RBRACK LPAREN Z RPAREN"); }
		}
	| REG _ASSIGN_BANG BITTST LPAREN REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($5,rc_dregs)
		             && const_fits($7,c_uimm5)) {
/* LOGI2op:	CC = ! BITTST ( dregs , uimm5 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LOGI2op: CC =! BITTST ( dregs , uimm5 )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004800
		                |((dregs($5)&0x7)<<0)                    /* dst<(dregs) */
		                |((uimm5($7)&0x1f)<<3)                   /* src<(uimm5) */
		                |((0&0x7)<<8)                            /* opc<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _ASSIGN_BANG BITTST LPAREN REG COMMA expr RPAREN"); }
		}
	| REG ASSIGN BITTST LPAREN REG COMMA expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($5,rc_dregs)
		             && const_fits($7,c_uimm5)) {
/* LOGI2op:	CC = BITTST ( dregs , uimm5 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LOGI2op: CC = BITTST ( dregs , uimm5 )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004800
		                |((dregs($5)&0x7)<<0)                    /* dst<(dregs) */
		                |((uimm5($7)&0x1f)<<3)                   /* src<(uimm5) */
		                |((1&0x7)<<8)                            /* opc<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN BITTST LPAREN REG COMMA expr RPAREN"); }
		}
 	| REG ASSIGN BYTEOP1P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN T RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP1P ( dregs_pair , dregs_pair ) (T)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP1P ( dregs_pair , dregs_pair ) (T)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((20&0x1f)<<0)                          /* aopcde<(20) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                 /* |((($12.r0)&0x1)<<13)                     s=aligndir.r0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP1P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN T RPAREN)"); }
		}
	| REG ASSIGN BYTEOP1P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN T COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP1P ( dregs_pair , dregs_pair ) (T , aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP1P ( dregs_pair , dregs_pair ) (T , aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((20&0x1f)<<0)                          /* aopcde<(20) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP1P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN T COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP1P LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP1P ( dregs_pair , dregs_pair ) (aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP1P ( dregs_pair , dregs_pair ) (aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((20&0x1f)<<0)                          /* aopcde<(20) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((($13.r0)&0x1)<<13)                     /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP1P LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir"); }
		}
	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDH RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDH)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDH)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  /*|((($12.r0)&0x1)<<13)                     s=aligndir.r0 */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDH RPAREN"); }
		}
	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TH RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TH)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TH)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TH RPAREN"); }
		}
	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDL RPAREN"); }
		}
	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TL RPAREN"); }
		}
	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDH COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2P ( dregs_pair , dregs_pair )  (RNDH , aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDH, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDH COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TH COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2 ( dregs_pair , dregs_pair ) (TH, aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TH, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TH COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDL COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDL, aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (RNDL, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDL COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TL COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TL, aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2P ( dregs_pair , dregs_pair ) (TL, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TL COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDH RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2 ( dregs_pair , dregs_pair ) (RNDH)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2  ( dregs_pair , dregs_pair ) (RNDH)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDH RPAREN"); }
		}
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDH COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (RNDH,  aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2 ( dregs_pair , dregs_pair ) (RNDH, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDH COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TH RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:    dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TH)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TH)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TH RPAREN"); }
		}
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TH COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TH, aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TH, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TH COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (RNDL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (RNDL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDL RPAREN"); }
		}
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDL COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (RNDL, aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (RNDL, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN RNDL COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TL COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TL, aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TL, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TL COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP2M ( dregs_pair , dregs_pair ) (TL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((22&0x1f)<<0)                          /* aopcde<(22) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP2M LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN TL RPAREN"); }
		}
	| REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN HI RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (HI)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (HI)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((23&0x1f)<<0)                          /* aopcde<(23) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN HI RPAREN"); }
		}
	| REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN LO RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (LO)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (LO)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((23&0x1f)<<0)                          /* aopcde<(23) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((0&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN LO RPAREN"); }
		}
	| REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN HI COMMA R RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (HI, aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (HI, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((23&0x1f)<<0)                          /* aopcde<(23) */
		                |((1&0x1)<<5)                            /* HL<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN HI COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN LO COMMA R RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($9,rc_dregs)) {
/* dsp32alu:	dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (LO, aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEOP3P ( dregs_pair , dregs_pair ) (LO, aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((23&0x1f)<<0)                          /* aopcde<(23) */
		                |((0&0x1)<<5)                            /* HL<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($9)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((1&0x1)<<13)                    /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEOP3P LPAREN REG COLON expr COMMA REG COLON expr RPAREN LPAREN LO COMMA R RPAREN"); }
		}
	| REG ASSIGN BYTEPACK LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32alu:	dregs = BYTEPACK ( dregs , dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = BYTEPACK ( dregs , dregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((24&0x1f)<<0)                          /* aopcde<(24) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTEPACK LPAREN REG COMMA REG RPAREN"); }
		}
	| CLI REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs)) {
/* ProgCtrl:	CLI dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: CLI dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((dregs($2)&0xf)<<0)                    /* poprnd<(dregs) */
		                |((3&0xf)<<4)                            /* prgfunc<(3) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("CLI REG"); }
		}
	| LOW_REG ASSIGN EXPADJ LPAREN REG COMMA LOW_REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs_lo)) {
/* dsp32shift:	dregs_lo = EXPADJ ( dregs , dregs_lo)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = EXPADJ ( dregs , dregs_lo )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((7&0x1f)<<0)                           /* sopcde<(7) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs_lo($7)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN EXPADJ LPAREN REG COMMA LOW_REG RPAREN"); }
		}
	| LOW_REG ASSIGN EXPADJ LPAREN LOW_REG COMMA LOW_REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs_lo = EXPADJ ( dregs_lo , dregs_lo )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = EXPADJ ( dregs_lo , dregs_lo )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((7&0x1f)<<0)                           /* sopcde<(7) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($5)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((dregs($7)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN EXPADJ LPAREN LOW_REG COMMA LOW_REG RPAREN"); }
		}
	| LOW_REG ASSIGN EXPADJ LPAREN HIGH_REG COMMA LOW_REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs_lo = EXPADJ ( dregs_hi , dregs_lo )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = EXPADJ ( dregs_hi , dregs_lo )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((7&0x1f)<<0)                           /* sopcde<(7) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($5)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((dregs($7)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((3&0x3)<<14)                           /* sop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN EXPADJ LPAREN HIGH_REG COMMA LOW_REG RPAREN"); }
		}
	| LOW_REG ASSIGN EXPADJ LPAREN REG COMMA LOW_REG RPAREN LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs_lo = EXPADJ ( dregs , dregs_lo) ( V )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = EXPADJ ( dregs , dregs_lo ) (V)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((7&0x1f)<<0)                           /* sopcde<(7) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN EXPADJ LPAREN REG COMMA LOW_REG RPAREN LPAREN V RPAREN"); }
		}
	| REG ASSIGN DEPOSIT LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = DEPOSIT ( dregs , dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = DEPOSIT ( dregs , dregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((10&0x1f)<<0)                          /* sopcde<(10) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN DEPOSIT LPAREN REG COMMA REG RPAREN"); }
		}
	| REG ASSIGN DEPOSIT LPAREN REG COMMA REG RPAREN LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = DEPOSIT ( dregs , dregs ) (X)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = DEPOSIT ( dregs , dregs ) (X)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((10&0x1f)<<0)                          /* sopcde<(10) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((3&0x3)<<14)                           /* sop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN DEPOSIT LPAREN REG COMMA REG RPAREN LPAREN X RPAREN"); }
		}
	| REG ASSIGN EXTRACT LPAREN REG COMMA LOW_REG RPAREN xorzornothing 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = EXTRACT ( dregs , dregs_lo ) xorzornothing 
---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = EXTRACT ( dregs , dregs_lo ) xorzornothing\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((10&0x1f)<<0)                          /* sopcde<(10) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |(($9.r0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN DEPOSIT LPAREN REG COMMA LOW_REG RPAREN xorzornothing"); }
		}
	| REG ASSIGN W LBRACK REG PLUS expr RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && const_fits($7,c_uimm4s2)) {
/* LDSTii:	dregs = W [ pregs + uimm4s2 ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTii: dregs = W [ pregs + uimm4s2 ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00a000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((uimm4s2($7)&0xf)<<6)                  /* offset<(uimm4s2) */
		                |((0&0x1)<<12)                           /* W<(0) */
		                |((1&0x3)<<10)                           /* op<(1) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && const_fits($7,c_imm16s2)) {
/* LDSTidxI:	dregs = W [ pregs + imm16s2 ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: dregs = W [ pregs + imm16s2 ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e400
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((1&0x3)<<6)                            /* sz<(1) */
		                |((0&0x1)<<8)                            /* Z<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16s2($7)&0xffff)<<0)               /* offset<(imm16s2) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG PLUS expr RBRACK LPAREN Z RPAREN"); }
		}
	| REG ASSIGN W LBRACK REG RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = W [ pregs ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = W [ pregs ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG RBRACK LPAREN Z RPAREN"); }
		}
	| LOW_REG ASSIGN W LBRACK REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_iregs)) {
/* dspLDST:	dregs_lo = W [ iregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs_lo = W [ iregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                 /* reg<(dregs_lo) */
		                |((iregs($5)&0x3)<<3)                    /* i<(iregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((1&0x3)<<5)                            /* m<(1) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDSTpmod:	dregs_lo = W [ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: dregs_lo = W [ pregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((dregs($1)&0x7)<<6)                 /* reg<(dregs_lo) */
		                |((pregs($5)&0x7)<<0)                    /* ptr<(pregs) */
		                |((1&0x3)<<9)                            /* aop<(1) */
		                |((0&0x1)<<11)                           /* W<(0) */
		                |((pregs($5)&0x7)<<3)                    /* idx<(pregs($4)) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN W LBRACK REG RBRACK"); }
		}
	| HIGH_REG ASSIGN W LBRACK REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_iregs)) {
/* dspLDST:	dregs_hi = W [ iregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs_hi = W [ iregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                 /* reg<(dregs_hi) */
		                |((iregs($5)&0x3)<<3)                    /* i<(iregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((2&0x3)<<5)                            /* m<(2) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDSTpmod:	dregs_hi = W [ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: dregs_hi = W [ pregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((dregs($1)&0x7)<<6)                 /* reg<(dregs_hi) */
		                |((pregs($5)&0x7)<<0)                    /* ptr<(pregs) */
		                |((2&0x3)<<9)                            /* aop<(2) */
		                |((0&0x1)<<11)                           /* W<(0) */
		                |((pregs($5)&0x7)<<3)                    /* idx<(pregs($4)) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN W LBRACK REG RBRACK"); }
		}
	| REG ASSIGN W LBRACK REG _MINUS_MINUS RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = W [ pregs -- ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = W [ pregs -- ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG _MINUS_MINUS RBRACK LPAREN Z RPAREN"); }
		}
	| LOW_REG ASSIGN W LBRACK REG _MINUS_MINUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_iregs)) {
/* dspLDST:	dregs_lo = W [ iregs -- ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs_lo = W [ iregs -- ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                 /* reg<(dregs_lo) */
		                |((iregs($5)&0x3)<<3)                    /* i<(iregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((1&0x3)<<5)                            /* m<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN W LBRACK REG _MINUS_MINUS RBRACK"); }
		}
	| HIGH_REG ASSIGN W LBRACK REG _MINUS_MINUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_iregs)) {
/* dspLDST:	dregs_hi = W [ iregs -- ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs_hi = W [ iregs -- ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                 /* reg<(dregs_hi) */
		                |((iregs($5)&0x3)<<3)                    /* i<(iregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((2&0x3)<<5)                            /* m<(2) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN W LBRACK REG _MINUS_MINUS RBRACK"); }
		}
	| REG ASSIGN W LBRACK REG _PLUS_PLUS RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = W [ pregs ++ ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = W [ pregs ++ ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG _PLUS_PLUS RBRACK LPAREN Z RPAREN"); }
		}
	| LOW_REG ASSIGN W LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_iregs)) {
/* dspLDST:	dregs_lo = W [ iregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs_lo = W [ iregs ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                 /* reg<(dregs_lo) */
		                |((iregs($5)&0x3)<<3)                    /* i<(iregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((1&0x3)<<5)                            /* m<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN W LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| HIGH_REG ASSIGN W LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_iregs)) {
/* dspLDST:	dregs_hi = W [ iregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs_hi = W [ iregs ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                 /* reg<(dregs_hi) */
		                |((iregs($5)&0x3)<<3)                    /* i<(iregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((2&0x3)<<5)                            /* m<(2) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN W LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && reginclass($7,rc_pregs)) {
/* LDSTpmod:	dregs = W [ pregs ++ pregs ] (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: dregs = W [ pregs ++ pregs ] (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((dregs($1)&0x7)<<6)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<0)                    /* ptr<(pregs) */
		                |((pregs($7)&0x7)<<3)                    /* idx<(pregs) */
		                |((3&0x3)<<9)                            /* aop<(3) */
		                |((0&0x1)<<11)                           /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK LPAREN Z RPAREN"); }
		}
	| LOW_REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && reginclass($7,rc_pregs)) {
/* LDSTpmod:	dregs_lo = W [ pregs ++ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: dregs_lo = W [ pregs ++ pregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((dregs($1)&0x7)<<6)                 /* reg<(dregs_lo) */
		                |((pregs($5)&0x7)<<0)                    /* ptr<(pregs) */
		                |((pregs($7)&0x7)<<3)                    /* idx<(pregs) */
		                |((1&0x3)<<9)                            /* aop<(1) */
		                |((0&0x1)<<11)                           /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK"); }
		}
	| HIGH_REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && reginclass($7,rc_pregs)) {
/* LDSTpmod:	dregs_hi = W [ pregs ++ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: dregs_hi = W [ pregs ++ pregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((dregs($1)&0x7)<<6)                 /* reg<(dregs_hi) */
		                |((pregs($5)&0x7)<<0)                    /* ptr<(pregs) */
		                |((pregs($7)&0x7)<<3)                    /* idx<(pregs) */
		                |((2&0x3)<<9)                            /* aop<(2) */
		                |((0&0x1)<<11)                           /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK"); }
		}
/*	| REG ASSIGN H PLUS L LPAREN SGN LPAREN REG RPAREN STAR REG RPAREN*/
	| HIGH_REG ASSIGN LOW_REG ASSIGN SIGN LPAREN HIGH_REG RPAREN STAR HIGH_REG PLUS SIGN LPAREN LOW_REG RPAREN STAR LOW_REG 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($7,rc_dregs)
		             && reginclass($10,rc_dregs)
		             && reginclass($14,rc_dregs)
		             && reginclass($17,rc_dregs)) {
/* dsp32alu:	dregs = H + L ( SGN ( dregs ) * dregs )
   dsp32alu:	dregs_hi = dregs_lo =  SIGN (dregs_hi) * dregs_hi + SIGN (dregs_lo) * dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
   		    notethat("dsp32alu:	dregs_hi = dregs_lo =  SIGN (dregs_hi) * dregs_hi + SIGN (dregs_lo) * dregs_lo \n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((12&0x1f)<<0)                          /* aopcde<(12) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<6)                    /* dst0<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($10)&0x7)<<0)                   /* src1<(dregs) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else  { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG ASSIGN SIGN LPAREN HIGH_REG RPAREN STAR HIGH_REG PLUS SIGN LPAREN LOW_REG RPAREN STAR LOW_REG");}
		}
        | REG ASSIGN REG MINUS REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs = dregs - dregs (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs - dregs (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((4&0x1f)<<0)                           /* aopcde<(4) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                     /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                     /* x=amod1.x0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG MINUS REG LPAREN amod1 RPAREN"); }
		}
        | LOW_REG ASSIGN LOW_REG MINUS LOW_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo =  dregs_lo - dregs_lo (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs_lo - dregs_lo (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((3&0x1f)<<0)                           /* aopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LOW_REG MINUS LOW_REG LPAREN amod1 RPAREN"); }
		}
        | HIGH_REG ASSIGN LOW_REG MINUS LOW_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi =  dregs_lo - dregs_lo (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs_lo - dregs_lo (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((3&0x1f)<<0)                           /* aopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG MINUS LOW_REG LPAREN amod1 RPAREN"); }
		}
        | LOW_REG ASSIGN LOW_REG MINUS HIGH_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo = dregs_lo - dregs_hi (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs_lo - dregs_hi (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((3&0x1f)<<0)                           /* aopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LOW_REG MINUS HIGH_REG LPAREN amod1 RPAREN"); }
		}
        | HIGH_REG ASSIGN LOW_REG MINUS HIGH_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi =   dregs_lo - dregs_hi (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs_lo - dregs_hi (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((3&0x1f)<<0)                           /* aopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG MINUS HIGH_REG LPAREN amod1 RPAREN"); }
		}
        | LOW_REG ASSIGN HIGH_REG MINUS LOW_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo =  dregs_hi - dregs_lo (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs_hi - dregs_lo (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((3&0x1f)<<0)                           /* aopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN HIGH_REG MINUS LOW_REG LPAREN amod1 RPAREN"); }
		}
        | HIGH_REG ASSIGN HIGH_REG MINUS LOW_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi =  dregs_hi - dregs_lo (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs_hi - dregs_lo (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((3&0x1f)<<0)                           /* aopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN HIGH_REG MINUS LOW_REG LPAREN amod1 RPAREN"); }
		}
        | LOW_REG ASSIGN HIGH_REG MINUS HIGH_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo = dregs_hi - dregs_hi (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs_hi - dregs_hi (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((3&0x1f)<<0)                           /* aopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN HIGH_REG MINUS HIGH_REG LPAREN amod1 RPAREN"); }
		}
        | HIGH_REG ASSIGN HIGH_REG MINUS HIGH_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi = dregs_hi - dregs_hi (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs_hi - dregs_hi (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((3&0x1f)<<0)                           /* aopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN HIGH_REG MINUS HIGH_REG LPAREN amod1 RPAREN"); }
		}
	| REG ASSIGN LBRACK REG PLUS expr RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dpregs)
		             && $4 == REG_FP
		             && const_fits($6,c_negimm5s4)) {
/* LDSTiiFP:	dpregs = [ FP + negimm5s4 ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 | 1 | 1 | 0 |.W.|.offset............|.reg...........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTiiFP: dpregs = [ FP + negimm5s4 ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00b800
		                |((dpregs($1)&0xf)<<0)                   /* reg<(dpregs) */
		                |((negimm5s4($6)&0x1f)<<4)               /* offset<(negimm5s4) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_pregs)
		             && const_fits($6,c_uimm4s4)) {
/* LDSTii:	dregs = [ pregs + uimm4s4 ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTii: dregs = [ pregs + uimm4s4 ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00a000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((uimm4s4($6)&0xf)<<6)                  /* offset<(uimm4s4) */
		                |((0&0x1)<<12)                           /* W<(0) */
		                |((0&0x3)<<10)                           /* op<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($4,rc_pregs)
		             && const_fits($6,c_uimm4s4)) {
/* LDSTii:	pregs = [ pregs + uimm4s4 ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTii: pregs = [ pregs + uimm4s4 ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00a000
		                |((pregs($1)&0x7)<<0)                    /* reg<(pregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((uimm4s4($6)&0xf)<<6)                  /* offset<(uimm4s4) */
		                |((0&0x1)<<12)                           /* W<(0) */
		                |((3&0x3)<<10)                           /* op<(3) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_pregs)
		             && const_fits($6,c_imm16s4)) {
/* LDSTidxI:	dregs = [ pregs + imm16s4 ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: dregs = [ pregs + imm16s4 ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e400
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((0&0x3)<<6)                            /* sz<(0) */
		                |((0&0x1)<<8)                            /* Z<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16s4($6)&0xffff)<<0)               /* offset<(imm16s4) */
		          ),
		          NULL_CODE));
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($4,rc_pregs)
		             && const_fits($6,c_imm16s4)) {
/* LDSTidxI:	pregs = [ pregs + imm16s4 ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: pregs = [ pregs + imm16s4 ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e400
		                |((pregs($1)&0x7)<<0)                    /* reg<(pregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((0&0x3)<<6)                            /* sz<(0) */
		                |((1&0x1)<<8)                            /* Z<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16s4($6)&0xffff)<<0)               /* offset<(imm16s4) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN LBRACK REG PLUS expr RBRACK"); }
		}
	| REG ASSIGN LBRACK REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_iregs)) {
/* dspLDST:	dregs = [ iregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs = [ iregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((iregs($4)&0x3)<<3)                    /* i<(iregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((0&0x3)<<5)                            /* m<(0) */
		        ),
		        NULL_CODE);
		
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_pregs)) {
/* LDST:	dregs = [ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = [ pregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($4,rc_pregs)) {
/* LDST:	pregs = [ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: pregs = [ pregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((pregs($1)&0x7)<<0)                    /* reg<(pregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN LBRACK REG RBRACK"); }
		}
	| REG ASSIGN LBRACK REG _MINUS_MINUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_iregs)) {
/* dspLDST:	dregs = [ iregs -- ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs = [ iregs -- ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((iregs($4)&0x3)<<3)                    /* i<(iregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((0&0x3)<<5)                            /* m<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_pregs)) {
/* LDST:	dregs = [ pregs -- ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = [ pregs -- ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($4,rc_pregs)) {
/* LDST:	pregs = [ pregs -- ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: pregs = [ pregs -- ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((pregs($1)&0x7)<<0)                    /* reg<(pregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN LBRACK REG _MINUS_MINUS RBRACK"); }
		}
	| REG ASSIGN LBRACK REG _PLUS_PLUS RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_iregs)) {
/* dspLDST:	dregs = [ iregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs = [ iregs ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((iregs($4)&0x3)<<3)                    /* i<(iregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((0&0x3)<<5)                            /* m<(0) */
		        ),
		        NULL_CODE);
		
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_pregs)) {
/* LDST:	dregs = [ pregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = [ pregs ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((0&0x1)<<6)                            /* Z<(0) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($4,rc_pregs)) {
/* LDST:	pregs = [ pregs ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: pregs = [ pregs ++ ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((pregs($1)&0x7)<<0)                    /* reg<(pregs) */
		                |((pregs($4)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((0&0x3)<<10)                           /* sz<(0) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_allregs)
		             && $4 == REG_SP) {
/* PushPopReg:	allregs = [ SP ++ ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.W.|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PushPopReg: allregs = [ SP ++ ]\n");
		    $$ =
		      CONSCODE(
		         GENCODE(0x000100
		                |((allregs($1)&0x7)<<0)                  /* reg<(allregs) */
		                |((0&0x1)<<6)                            /* W<(0) */
		                |((Xallregs($1)&0x7)<<3)                 /* grp<(Xallregs($1)) */
		        ),
		        NULL_CODE);
		  } else { $$ = 0; semantic_error ("REG ASSIGN LBRACK REG _PLUS_PLUS RBRACK"); }
		}
	| REG ASSIGN LBRACK REG _PLUS_PLUS REG RBRACK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_iregs)
		             && reginclass($6,rc_mregs)) {
/* dspLDST:	dregs = [ iregs ++ mregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dspLDST: dregs = [ iregs ++ mregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009c00
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((iregs($4)&0x3)<<3)                    /* i<(iregs) */
		                |((mregs($6)&0x3)<<5)                    /* m<(mregs) */
		                |((3&0x3)<<7)                            /* aop<(3) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_pregs)
		             && reginclass($6,rc_pregs)) {
/* LDSTpmod:	dregs = [ pregs ++ pregs ]
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: dregs = [ pregs ++ pregs ]\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((dregs($1)&0x7)<<6)                    /* reg<(dregs) */
		                |((pregs($4)&0x7)<<0)                    /* ptr<(pregs) */
		                |((pregs($6)&0x7)<<3)                    /* idx<(pregs) */
		                |((0&0x3)<<9)                            /* aop<(0) */
		                |((0&0x1)<<11)                           /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN LBRACK REG _PLUS_PLUS REG RBRACK"); }
		}
/* Second Pattern Page 7.75 */
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * LOW_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * HIGH_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * LOW_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * HIGH_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * LOW_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * HIGH_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * LOW_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * HIGH_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * LOW_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * HIGH_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * LOW_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * HIGH_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * LOW_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * HIGH_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * LOW_REG LPAREN macmod_hmove RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_hmove
		{
		  if(0) {
                  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
                             && reginclass($1,rc_dregs) ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
                                  |((($11.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                            /*      |((($8.op)&0x183f)<<0)                    op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)              /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*   src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * HIGH_REG LPAREN macmod_hmove RPAREN"); }
		}
/* Fifth Pattern Page 7.75  */
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * LOW_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * HIGH_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * LOW_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * HIGH_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * LOW_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * HIGH_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * LOW_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * HIGH_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * LOW_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * HIGH_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * LOW_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * HIGH_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR LOW_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * LOW_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc LOW_REG STAR HIGH_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc LOW_REG * HIGH_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR LOW_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * LOW_REG macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA A0macfunc HIGH_REG STAR HIGH_REG macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($12,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($14,rc_dregs)
		             && reginclass($1,rc_dregs) && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mac:   dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), A0macfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($15.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($11.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1*/
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /* src1<(dregs) */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

                        } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA A0macfunc HIGH_REG * HIGH_REG macmod_hmove"); }
		}
/* Fourth Pattern Page 7.75 */
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && reginclass($1,rc_dregs) == reginclass($11,rc_dregs)  ) {
/* dsp32mac:	dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_hi = ( A1macfunc ) (mxd_mod), dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                /* op0=A0macfunc.op */
                                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)               /*  src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)               /*  src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN LPAREN mxd_mod RPAREN COMMA LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs) && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs) ) {
/* dsp32mac:   dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_lo = A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |(((3)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |(((0)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($4.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| LOW_REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs) && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs)  ) {
/* dsp32mac:   dregs_lo = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |(((3)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |(((0)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($4.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs) && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs)  ) {
/* dsp32mac:   dregs_lo  = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |(((3)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |(((0)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($4.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs) && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs)  ) {
/* dsp32mac:   dregs_lo  = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs_lo = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |(((3)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |(((0)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($4.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs) && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs) && ((dregs($1)&0x7)%2)==0 ) {
/* dsp32mac:   dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |(((3)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |(((0)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($4.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs) && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs) && ((dregs($1)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |(((3)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |(((0)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($4.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs) && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs) && ((dregs($1)&0x7)%2)==0 ) {
/* dsp32mac:   dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |(((3)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |(((0)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($4.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs) && reginclass($5,rc_dregs)
                             && reginclass($7,rc_dregs) && ((dregs($1)&0x7)%2)==0 ) {
/* dsp32mac:   dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |(((3)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |(((0)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($4.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
/* Seventh Pattern Page 7.75  */
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc LOW_REG STAR HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((0)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc LOW_REG * HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((0)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * LOW_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((0)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc LOW_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR LOW_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((0)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * LOW_REG RPAREN macmod_hmove"); }
		}
	| REG ASSIGN LPAREN A1macfunc HIGH_REG STAR HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG STAR HIGH_REG RPAREN macmod_pmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($5,rc_dregs) == reginclass($15,rc_dregs)
                             && reginclass($7,rc_dregs) == reginclass($17,rc_dregs)
                             && (((dregs($1)&0x7)-(dregs($11)&0x7))==1)
                             && ((dregs($1)&0x7)%2)!=0 && ((dregs($11)&0x7)%2)==0 ) {
/* dsp32mac:   dregs(odd) = ( A1macfunc ) (mxd_mod), dregs (even) = ( A0macfunc ) (macmod_hmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 0 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mac: dregs = ( A1macfunc ) (mxd_mod), dregs = ( A0macfunc ) (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c000
		                |((($4.r0)&0x3)<<0)                      /* op1=A1macfunc.op */
		                |((($9.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($19.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($11)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |(((1)&0x1)<<15)                     /* h01=A1macfunc.h0 */
		                  |(((1)&0x1)<<14)                     /* h11=A1macfunc.h1 */
		                  |((($14.r0)&0x3)<<11)                     /* op0=A0macfunc.op */
		                  |(((1)&0x1)<<10)                     /* h00=A0macfunc.h0 */
		                  |(((1)&0x1)<<9)                      /* h10=A0macfunc.h1 */
		                  |((dregs($5)&0x7)<<3)                /*    src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                /*    src1<(dregs) */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

                  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN A1macfunc HIGH_REG * HIGH_REG RPAREN mxd_mod COMMA REG ASSIGN LPAREN A0macfunc HIGH_REG * HIGH_REG RPAREN macmod_hmove"); }
		}
        | REG ASSIGN LPAREN REG_A00 _PLUS_ASSIGN REG_A11 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $4 == REG_A0
		             && $6 == REG_A1) {
/* dsp32alu:	dregs = ( A0 += A1 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = ( A0 += A1 )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((11&0x1f)<<0)                          /* aopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN REG_A00 _PLUS_ASSIGN REG_A11 RPAREN"); }
		}
	| LOW_REG ASSIGN LPAREN REG_A00 _PLUS_ASSIGN REG_A11 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $4 == REG_A0
		             && $6 == REG_A1) {
/* dsp32alu:	dregs_lo = ( A0 += A1 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = ( A0 += A1 )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((11&0x1f)<<0)                          /* aopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LPAREN REG_A00 _PLUS_ASSIGN REG_A11 RPAREN"); }
		}
	| HIGH_REG ASSIGN LPAREN REG_A00 _PLUS_ASSIGN REG_A11 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $4 == REG_A0
		             && $6 == REG_A1) {
/* dsp32alu:	dregs_hi = ( A0 += A1 )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = ( A0 += A1 )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((11&0x1f)<<0)                          /* aopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LPAREN REG_A00 _PLUS_ASSIGN REG_A11 RPAREN"); }
		}
/*First Pattern 7-81	| REG ASSIGN LPAREN multfunc RPAREN COMMA MUNOP LPAREN REG COMMA REG RPAREN macmod_hmove*/
	| HIGH_REG ASSIGN multfunc macmod_hmove mxd_mod
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)) {
/* dsp32mult:	dregs = ( multfunc ) , MUNOP ( dregs , dregs ) macmod_hmove
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mult: dregs_hi = multfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c200
		                |((0&0x3)<<0)                      /* op1=multfunc.op */
		                |((($4.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		                |((0&0x1)<<4)                            /* MM<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |((($3.h0)&0x1)<<15)                     /* h01=multfunc.h0 */
		                  |((($3.h1)&0x1)<<14)                     /* h11=multfunc.h1 */
		                  |((($3.op)&0x183f)<<0)                   /* op0=A0macfunc.op */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN multfunc LPAREN macmod_hmove RPAREN"); }
		}
/* Second Pattern 7-81	| REG MUNOP COMMA ASSIGN LPAREN multfunc RPAREN LPAREN REG COMMA REG RPAREN macmod_hmove */
	| LOW_REG ASSIGN multfunc macmod_hmove mxd_mod 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)) {
/* dsp32mult: dregs MUNOP , = ( multfunc ) ( dregs , dregs ) macmod_hmove
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mult: dregs_lo = multfunc (macmod_hmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c200
		                |((($4.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((0&0x1)<<3)                            /* P<(0) */
		                |((0&0x1)<<4)                            /* MM<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |((($3.op)&0x183f)<<0)                     /* op0=multfunc.op */
		                  |((($3.h0)&0x1)<<10)                     /* h00=multfunc.h0 */
		                  |((($3.h1)&0x1)<<9)                      /* h10=multfunc.h1 */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN multfunc LPAREN macmod_hmove RPAREN"); }
		}
/* Fourth Pattern 7-81	| REG _DOTP ASSIGN LPAREN multfunc RPAREN COMMA MUNOP LPAREN REG COMMA REG RPAREN macmod_pmove
   concerned about MAC1 so odd number */
	| REG ASSIGN multfunc  macmod_pmove 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && ((dregs($1)&0x7)%2)!=0) {
/* dsp32mult:	dregs_pair .P = ( multfunc ) , MUNOP ( dregs , dregs ) macmod_pmove
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mult: dregs = multfunc (macmod_pmove)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c200
		                |((0&0x3)<<0)                      /* op1=multfunc.op */
		                |((($4.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		                |((0&0x1)<<4)                            /* MM<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |((($3.h0)&0x1)<<15)                     /* h01=multfunc.h0 */
		                  |((($3.h1)&0x1)<<14)                     /* h11=multfunc.h1 */
		                  |((($3.op)&0x183f)<<0)                   /* op0 */
		                  |((0&0x1)<<13)                           /* w0<(0) */
		          ),
		          NULL_CODE));

/* Fifth Pattern 7-81	| REG _DOTP MUNOP COMMA ASSIGN LPAREN multfunc RPAREN LPAREN REG COMMA REG RPAREN macmod_pmove
   concerned about MAC0 so even number */ 
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && ((dregs($1)&0x7)%2)==0) {
/* dsp32mult:	dregs_pair .P MUNOP , = ( multfunc ) ( dregs , dregs ) macmod_pmove
   dsp32mult:	dregs = multfunc (macmod_pmove)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mult: dregs = multfunc macmod_pmove\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c200
		                |((($4.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((0&0x1)<<2)                            /* w1<(0) */
		                |((1&0x1)<<3)                            /* P<(1) */
		                |((0&0x1)<<4)                            /* MM<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)               /* dst<(dregs_pair) */
		                  |((($3.op)&0x183f)<<0)                     /* op0=multfunc.op */
		                  |((($3.h0)&0x1)<<10)                     /* h00=multfunc.h0 */
		                  |((($3.h1)&0x1)<<9)                      /* h10=multfunc.h1 */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN multfunc LPAREN macmod_hmove RPAREN"); }
		}
/* Third Pattern 7-81	| REG ASSIGN LPAREN multfunc mxd_mod COMMA multfunc RPAREN LPAREN REG COMMA REG RPAREN macmod_hmove */
	| HIGH_REG ASSIGN multfunc mxd_mod COMMA LOW_REG ASSIGN multfunc macmod_hmove
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($6,rc_dregs)
                             && (dregs($1)&0x7)==(dregs($6)&0x7) ) {
/*   dsp32mult:	dregs_hi = multfunc mxd_mod , dregs_lo = multfunc macmod_hmove
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mult: dregs_hi = multfunc mxd_mod , dregs_lo = multfunc macmod_hmove\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c200
		                |((0&0x3)<<0)                      /* op1=multfunc.op */
		                |((($4.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_hmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((0&0x1)<<3)                            /* P<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                  |((($3.h0)&0x1)<<15)                     /* h01=multfunc.h0 */
		                  |((($3.h1)&0x1)<<14)                     /* h11=multfunc.h1 */
		                  |((($8.op)&0x183f)<<0)                     /* op0=multfunc.op */
		                  |((($8.h0)&0x1)<<10)                     /* h00=multfunc.h0 */
		                  |((($8.h1)&0x1)<<9)                      /* h10=multfunc.h1 */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN multfunc mxd_mod COMMA LOW_REG ASSIGN multfunc macmod_hmove"); }
		}
/* Sixth Pattern 7-81	| REG _DOTP ASSIGN LPAREN multfunc mxd_mod COMMA multfunc RPAREN LPAREN REG COMMA REG RPAREN macmod_pmove */ 
	| REG ASSIGN multfunc mxd_mod COMMA REG ASSIGN multfunc macmod_pmove 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($6,rc_dregs)
			     && ((((dregs($1)&0x7)-(dregs($6)&0x7))==1) || 
					((dregs($6)&0x7)-(dregs($1)&0x7))==1)) {
/* dsp32mult:	dregs_pair .P = ( multfunc mxd_mod , multfunc ) ( dregs , dregs ) macmod_hmove
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 0 | 1 |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32mult: dregs = multfunc mxd_mod , dregs = multfunc macmod_hmove\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c200
		                |((0&0x3)<<0)                      /* op1=multfunc.op */
		                |((($4.mod)&0x1)<<4)                     /* MM=mxd_mod.mod */
		                |((($9.mod)&0xf)<<5)                    /* mmod=macmod_pmove.mod */
		                |((1&0x1)<<2)                            /* w1<(1) */
		                |((1&0x1)<<3)                            /* P<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((dregs($1)&0x7)/2)*2<<6)               /* dst<(dregs_pair) */
		                  |((($3.h0)&0x1)<<15)                     /* h01=multfunc.h0 */
		                  |((($3.h1)&0x1)<<14)                     /* h11=multfunc.h1 */
		                  |((($8.op)&0x183f)<<0)                     /* op0=multfunc.op */
		                  |((($8.h0)&0x1)<<10)                     /* h00=multfunc.h0 */
		                  |((($8.h1)&0x1)<<9)                      /* h10=multfunc.h1 */
		                  |((1&0x1)<<13)                           /* w0<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN multfunc mxd_mod COMMA REG ASSIGN multfunc macmod_hmove"); }
		}
	| REG_A00 ASSIGN LSHIFT REG_A00 BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $4 == REG_A0
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	A0 = LSHIFT A0 BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: A0 = LSHIFT A0 BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN LSHIFT REG_A00 BY LOW_REG"); }
		}
	| REG_A11 ASSIGN LSHIFT REG_A11 BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $4 == REG_A1
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	A1 = LSHIFT A1 BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: A1 = LSHIFT A1 BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN LSHIFT REG_A11 BY LOW_REG"); }
		}
	| LOW_REG ASSIGN LSHIFT HIGH_REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_lo = LSHIFT dregs_hi BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = LSHIFT dregs_hi BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LSHIFT HIGH_REG BY LOW_REG"); }
		}
	| HIGH_REG ASSIGN LSHIFT LOW_REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_hi = LSHIFT dregs_lo BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_hi = LSHIFT dregs_lo BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<12)                           /* HLs<(2) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LSHIFT LOW_REG BY LOW_REG"); }
		}
	| HIGH_REG ASSIGN LSHIFT HIGH_REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_hi = LSHIFT dregs_hi BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_hi = LSHIFT dregs_hi BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((3&0x3)<<12)                           /* HLs<(3) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LSHIFT HIGH_REG BY LOW_REG"); }
		}
	| LOW_REG ASSIGN LSHIFT LOW_REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs_lo = LSHIFT dregs_lo BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = LSHIFT dregs_lo BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LSHIFT LOW_REG BY LOW_REG"); }
		}
	| REG ASSIGN SHIFT REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs = SHIFT dregs BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = SHIFT dregs BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN SHIFT REG BY LOW_REG"); }
		}
	| REG_A00 ASSIGN REG_A00 GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $3 == REG_A0
		             && const_fits($5,c_imm6)>=0 ) {
/* dsp32shiftimm:	A0 = A0 >> uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: A0 = A0 >> imm6\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((-imm6($5))&0x3f)<<3)                    /* immag<(imm6) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN REG_A00 GREATER_GREATER expr"); }
		}
	| REG_A11 ASSIGN REG_A11 GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $3 == REG_A1
		             && const_fits($5,c_imm6)>=0 ) {
/* dsp32shiftimm:	A1 = A1 >> uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: A1 = A1 >> imm6\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |(((-imm6($5))&0x3f)<<3)                    /* immag<(imm6) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN REG_A11 GREATER_GREATER expr"); }
		}
	| REG ASSIGN REG GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm6)>=0 ) {
/*dsp32shiftimm: dregs  =  dregs >> imm6
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs  =  dregs >> imm6\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |(((-imm6($5))&0x3f)<<3)                    /* immag<(imm6) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)
		             && EXPR_VALUE($5) == 2) {
/* PTR2op:	pregs = pregs >> 2
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PTR2op: pregs = pregs >> 2\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004400
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<3)                    /* src<(pregs) */
		                |((3&0x7)<<6)                            /* opc<(3) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)
		             && EXPR_VALUE($5) == 1) {
/* PTR2op:	pregs = pregs >> 1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PTR2op: pregs = pregs >> 1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004400
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<3)                    /* src<(pregs) */
		                |((4&0x7)<<6)                            /* opc<(4) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG GREATER_GREATER expr"); }
		}
	| LOW_REG ASSIGN LOW_REG GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	 dregs_lo = dregs_lo  >> uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm:  dregs_lo =  dregs_lo >> uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((0&0x3)<<12)                           /* HLs<(1) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LOW_REG GREATER_GREATER expr"); }
		}
	| LOW_REG ASSIGN HIGH_REG GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	 dregs_lo = dregs_hi  >> uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm:  dregs_lo =  dregs_hi >> uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN HIGH_REG GREATER_GREATER expr"); }
		}
	| HIGH_REG ASSIGN LOW_REG GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	 dregs_hi = dregs_lo  >> uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_hi = dregs_lo >> uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((2&0x3)<<12)                           /* HLs<(2) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG GREATER_GREATER expr"); }
		}
	| HIGH_REG ASSIGN HIGH_REG GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	dregs_hi  = dregs_hi  >> uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm:  dregs_hi = dregs_hi  >> uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((3&0x3)<<12)                           /* HLs<(3) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN HIGH_REG GREATER_GREATER expr"); }
		}
	| REG ASSIGN REG _GREATER_GREATER_GREATER expr LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/*dsp32shiftimm: dregs  =  dregs >>> uimm5 ( S )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/		    	
		    notethat("dsp32shiftimm: dregs  =  dregs >>> uimm5 ( S )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm6) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG GREATER_GREATER_GREATER expr LPAREN S RPAREN"); }
		}
	| LOW_REG ASSIGN LOW_REG _GREATER_GREATER_GREATER expr LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	dregs_lo = dregs_lo >>> uimm5 ( S )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_lo = dregs_lo >>> uimm5 ( S )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LOW_REG GREATER_GREATER_GREATER expr LPAREN S RPAREN"); }
		}
	| HIGH_REG ASSIGN HIGH_REG _GREATER_GREATER_GREATER expr LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	dregs_hi  = dregs_hi  >>> uimm5 ( S )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm:  dregs_hi = dregs_hi  >>> uimm5 ( S )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((3&0x3)<<12)                           /* HLs<(3) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN HIGH_REG GREATER_GREATER_GREATER expr LPAREN S RPAREN"); }
		}
	| LOW_REG ASSIGN HIGH_REG _GREATER_GREATER_GREATER expr LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm5)) {
/* dsp32shiftimm:	 dregs_lo = dregs_hi  >>> uimm5 ( S )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm:  dregs_lo =  dregs_hi >>> uimm5 ( S )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN HIGH_REG GREATER_GREATER_GREATER expr LPAREN S RPAREN"); }
		}
	| HIGH_REG ASSIGN LOW_REG _GREATER_GREATER_GREATER expr LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	 dregs_hi = dregs_lo  >>> uimm5 ( S )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_hi = dregs_lo >>> uimm5 ( S ) \n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((2&0x3)<<12)                           /* HLs<(2) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG GREATER_GREATER_GREATER expr LPAREN S RPAREN"); }
		}
	| REG ASSIGN REG _GREATER_GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm6)>=0 ) {
/*dsp32shiftimm: dregs  =  dregs >>> imm6
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs  =  dregs >>> imm6\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |(((-imm6($5))&0x3f)<<3)                    /* immag<(imm6) */
		                  |((0&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG GREATER_GREATER_GREATER expr"); }
		}
	| LOW_REG ASSIGN LOW_REG _GREATER_GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	dregs_lo = dregs_lo >>> uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_lo = dregs_lo >>> uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LOW_REG GREATER_GREATER_GREATER expr"); }
		}
	| HIGH_REG ASSIGN HIGH_REG _GREATER_GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	dregs_hi  = dregs_hi  >>> uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm:  dregs_hi = dregs_hi  >>> uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((3&0x3)<<12)                           /* HLs<(3) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN HIGH_REG GREATER_GREATER_GREATER expr"); }
		}
	| LOW_REG ASSIGN HIGH_REG _GREATER_GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	 dregs_lo = dregs_hi  >>> uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm:  dregs_lo =  dregs_hi >>> uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN HIGH_REG GREATER_GREATER_GREATER expr"); }
		}
	| HIGH_REG ASSIGN LOW_REG _GREATER_GREATER_GREATER expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5) ) {
/* dsp32shiftimm:	 dregs_hi = dregs_lo  >>> uimm4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs_hi = dregs_lo >>> uimm5 \n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((0&0x1f)<<0)                           /* sopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((2&0x3)<<12)                           /* HLs<(2) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG GREATER_GREATER_GREATER expr"); }
		}
	| REG ASSIGN LSHIFT REG BY LOW_REG LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs = LSHIFT dregs BY dregs_lo ( V )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = LSHIFT dregs BY dregs_lo ( V )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((1&0x1f)<<0)                           /* sopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN LSHIFT REG BY LOW_REG LPAREN V RPAREN"); }
		}
	| REG ASSIGN REG GREATER_GREATER expr LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5)>=0 ) {
/* dsp32shiftimm:	dregs = dregs >> uimm5 (V)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs = dregs >> imm5 (V)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((1&0x1f)<<0)                           /* sopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((2&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG GREATER_GREATER expr LPAREN V RPAREN"); }
		}
	| REG ASSIGN REG _GREATER_GREATER_GREATER expr LPAREN V COMMA S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm5)>=0 ) {
/* dsp32shiftimm:	dregs = dregs >>> uimm5 (V, S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs = dregs >>> uimm5 (V, S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((1&0x1f)<<0)                           /* sopcde<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<0)                    /* src1<(dregs) */
		                  |(((-uimm5($5))&0x3f)<<3)                    /* immag<(imm5) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG GREATER_GREATER_GREATER expr LPAREN V COMMA S RPAREN"); }
		}
	| REG ASSIGN MAX LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32alu:	dregs = MAX ( dregs , dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = MAX ( dregs , dregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((7&0x1f)<<0)                           /* aopcde<(7) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN MAX LPAREN REG COMMA REG RPAREN"); }
		}
	| REG ASSIGN MAX LPAREN REG COMMA REG RPAREN LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32alu:	dregs = MAX / MAX ( dregs , dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = MAX ( dregs , dregs ) (V)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((6&0x1f)<<0)                           /* aopcde<(6) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN MAX LPAREN REG COMMA REG RPAREN LPAREN V RPAREN"); }
		}
	| REG ASSIGN MIN LPAREN REG COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32alu:	dregs = MIN ( dregs , dregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = MIN ( dregs , dregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((7&0x1f)<<0)                           /* aopcde<(7) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                    /* src1<(dregs) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN MIN LPAREN REG COMMA REG RPAREN"); }
		}
	| REG ASSIGN MIN LPAREN REG COMMA REG RPAREN LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32alu:	dregs = MIN ( dregs , dregs ) (V)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = MIN ( dregs , dregs ) (V)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((6&0x1f)<<0)                           /* aopcde<(6) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($7)&0x7)<<0)                    /* src1<(dregs) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN MIN LPAREN REG COMMA REG RPAREN LPAREN V RPAREN"); }
		}
	| REG ASSIGN MINUS REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* ALU2op:	dregs = - dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = - dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($4)&0x7)<<3)                    /* src<(dregs) */
		                |((14&0xf)<<6)                           /* opc<(14) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN MINUS REG"); }
		}
	| REG_A00 ASSIGN MINUS REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $4 == REG_A0) {
/* dsp32alu:	A0 = - A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 = - A0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((14&0x1f)<<0)                          /* aopcde<(14) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN MINUS REG_A00"); }
		}
	| REG_A00 ASSIGN MINUS REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $4 == REG_A1) {
/* dsp32alu:	A0 = - A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 = - A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((14&0x1f)<<0)                          /* aopcde<(14) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN MINUS REG_A11"); }
		}
	| REG_A11 ASSIGN MINUS REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $4 == REG_A0) {
/* dsp32alu:	A1 = - A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = - A0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((14&0x1f)<<0)                          /* aopcde<(14) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN MINUS REG_A00"); }
		}
	| REG_A11 ASSIGN MINUS REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $4 == REG_A1) {
/* dsp32alu:	A1 = - A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = - A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((14&0x1f)<<0)                          /* aopcde<(14) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN MINUS REG_A11"); }
		}
	| REG ASSIGN MINUS REG LPAREN V RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* dsp32alu:	dregs = NEG / NEG dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = - dregs (V)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((15&0x1f)<<0)                          /* aopcde<(15) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<3)                    /* src0<(dregs) */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN MINUS REG LPAREN V RPAREN"); }
		}
	| LOW_REG ASSIGN ONES REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* dsp32shift:	dregs_lo = ONES dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = ONES dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((6&0x1f)<<0)                           /* sopcde<(6) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((3&0x3)<<14)                           /* sop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN ONES REG"); }
		}
	| REG ASSIGN PACK LPAREN HIGH_REG COMMA HIGH_REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = PACK ( dregs_hi , dregs_hi )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = PACK ( dregs_hi , dregs_hi )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((4&0x1f)<<0)                           /* sopcde<(4) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((3&0x3)<<14)                           /* sop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN PACK LPAREN HIGH_REG COMMA HIGH_REG RPAREN"); }
		}
	| REG ASSIGN PACK LPAREN HIGH_REG COMMA LOW_REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = PACK ( dregs_hi , dregs_lo )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = PACK ( dregs_hi , dregs_lo )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((4&0x1f)<<0)                           /* sopcde<(4) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN PACK LPAREN HIGH_REG COMMA LOW_REG RPAREN"); }
		}
	| REG ASSIGN PACK LPAREN LOW_REG COMMA HIGH_REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = PACK ( dregs_lo , dregs_hi )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = PACK ( dregs_lo , dregs_hi )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((4&0x1f)<<0)                           /* sopcde<(4) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN PACK LPAREN LOW_REG COMMA HIGH_REG RPAREN"); }
		}
	| REG ASSIGN PACK LPAREN LOW_REG COMMA LOW_REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = PACK ( dregs_lo , dregs_lo )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = PACK ( dregs_lo , dregs_lo )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((4&0x1f)<<0)                           /* sopcde<(4) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN PACK LPAREN LOW_REG COMMA LOW_REG RPAREN"); }
		}
	| REG ASSIGN REG PLUS REG amod1 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs = dregs + dregs (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs + dregs (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((4&0x1f)<<0)                           /* aopcde<(4) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                     /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                     /* x=amod1.x0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG PLUS REG LPAREN amod1 RPAREN"); }
		}
	| LOW_REG ASSIGN LOW_REG PLUS LOW_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo = dregs_lo + dregs_lo  (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs_lo + dregs_lo (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((2&0x1f)<<0)                           /* aopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                 /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                 /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LOW_REG PLUS LOW_REG LPAREN amod1 RPAREN"); }
		}
	| HIGH_REG ASSIGN LOW_REG PLUS LOW_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi =  dregs_lo + dregs_lo (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs_lo + dregs_lo (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((2&0x1f)<<0)                           /* aopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG PLUS LOW_REG LPAREN amod1 RPAREN"); }
		}
	| LOW_REG ASSIGN LOW_REG PLUS HIGH_REG amod1 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo =  dregs_lo + dregs_hi (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs_lo + dregs_hi (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((2&0x1f)<<0)                           /* aopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN LOW_REG PLUS HIGH_REG LPAREN amod1 RPAREN"); }
		}
	| HIGH_REG ASSIGN LOW_REG PLUS HIGH_REG amod1 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi = dregs_lo + dregs_hi (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs_lo + dregs_hi (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((2&0x1f)<<0)                           /* aopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN LOW_REG PLUS HIGH_REG LPAREN amod1 RPAREN"); }
		}
	| LOW_REG ASSIGN HIGH_REG PLUS HIGH_REG amod1 
		{
		  if(0) {
		   } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo = dregs_hi + dregs_hi (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs_hi + dregs_hi (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((2&0x1f)<<0)                           /* aopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN HIGH_REG PLUS HIGH_REG LPAREN amod1 RPAREN"); }
		}
	| HIGH_REG ASSIGN HIGH_REG PLUS HIGH_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi = dregs_hi + dregs_hi (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs_hi + dregs_hi (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((2&0x1f)<<0)                           /* aopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN HIGH_REG PLUS HIGH_REG LPAREN amod1 RPAREN"); }
		}
	| LOW_REG ASSIGN HIGH_REG PLUS LOW_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo = dregs_hi +  dregs_lo (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs_hi +  dregs_lo (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((2&0x1f)<<0)                           /* aopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN HIGH_REG PLUS LOW_REG LPAREN amod1 RPAREN"); }
		}
	| HIGH_REG ASSIGN HIGH_REG PLUS LOW_REG amod1
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi = dregs_hi + dregs_lo (amod1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs_hi + dregs_lo (amod1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((2&0x1f)<<0)                           /* aopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                    /* s=amod1.s0 */
		                  |((($6.x0)&0x1)<<12)                    /* x=amod1.x0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN HIGH_REG PLUS LOW_REG LPAREN amod1 RPAREN"); }
		}
	| REG ASSIGN REG AMPERSAND REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* COMP3op:	dregs = dregs & dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: dregs = dregs & dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<0)                    /* src0<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* src1<(dregs) */
		                |((2&0x7)<<9)                            /* opc<(2) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG AMPERSAND REG"); }
		}
	| LOW_REG ASSIGN REG ASSIGN BXORSHIFT LPAREN REG_A00 COMMA REG RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $3 == REG_CC
		             && $7 == REG_A0
		             && reginclass($9,rc_dregs)) {
/* dsp32shift:	dregs_lo = CC = BXORSHIFT ( A0 , dregs ) 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = CC = BXORSHIFT ( A0 , dregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((11&0x1f)<<0)                          /* sopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($9)&0x7)<<3)                    /* src0<(dregs) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG ASSIGN BXORSHIFT LPAREN REG_A00 COMMA REG RPAREN"); }
		}
	| LOW_REG ASSIGN REG ASSIGN BXOR LPAREN REG_A00 COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $3 == REG_CC
		             && $7 == REG_A0
		             && reginclass($9,rc_dregs)) {
/* dsp32shift:	dregs_lo = CC = BXOR (A0 , dregs)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = CC = BXOR (A0 , dregs)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((11&0x1f)<<0)                          /* sopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($9)&0x7)<<3)                    /* src0<(dregs) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG ASSIGN BXOR LPAREN REG_A00 COMMA REG RPAREN"); }
		}
	| LOW_REG ASSIGN REG ASSIGN BXOR LPAREN REG_A00 COMMA REG_A11 COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $3 == REG_CC
		             && $7 == REG_A0
		             && $9 == REG_A1
		             && $11 == REG_CC) {
/* dsp32shift:	dregs_lo = CC = BXOR (A0 , A1 , CC)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = CC = BXOR (A0 , A1 , CC)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((12&0x1f)<<0)                          /* sopcde<(12) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG ASSIGN BXOR LPAREN REG_A00 COMMA REG_A11 COMMA REG RPAREN"); }
		}
	| REG_A11 ASSIGN REG_A00 ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $3 == REG_A0) {
/* dsp32alu:	A1 = A0 = 0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = A0 = 0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((8&0x1f)<<0)                           /* aopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((2&0x3)<<14)                           /* aop<(2) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN REG_A00 ASSIGN expr"); }
		}
	| REG ASSIGN REG BAR REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* COMP3op:	dregs = dregs | dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: dregs = dregs | dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<0)                    /* src0<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* src1<(dregs) */
		                |((3&0x7)<<9)                            /* opc<(3) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG BAR REG"); }
		}
	| REG ASSIGN REG CARET REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* COMP3op:	dregs = dregs ^ dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: dregs = dregs ^ dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<0)                    /* src0<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* src1<(dregs) */
		                |((4&0x7)<<9)                            /* opc<(4) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG CARET REG"); }
		}
	| REG ASSIGN REG_A00 LESS_THAN REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && $3 == REG_A0
		             && $5 == REG_A1) {
/* CCflag:	CC = A0 < A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = A0 < A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((6&0x7)<<7)                            /* opc<(6) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG_A00 LESS_THAN REG_A11"); }
		}
	| REG ASSIGN REG LESS_THAN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && reginclass($5,rc_pregs)) {
/* CCflag:	CC = pregs < pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs < pregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((pregs($5)&0x7)<<3)                    /* y<(pregs) */
		                |((1&0x7)<<7)                            /* opc<(1) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* CCflag:	CC = dregs < dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs < dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* y<(dregs) */
		                |((1&0x7)<<7)                            /* opc<(1) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG LESS_THAN REG"); }
		}
	| REG ASSIGN REG LESS_THAN REG LPAREN IU RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* CCflag:	CC = dregs < dregs ( IU )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs < dregs ( IU )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* y<(dregs) */
		                |((3&0x7)<<7)                            /* opc<(3) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && reginclass($5,rc_pregs)) {
/* CCflag:	CC = pregs < pregs ( IU )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs < pregs ( IU )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((pregs($5)&0x7)<<3)                    /* y<(pregs) */
		                |((3&0x7)<<7)                            /* opc<(3) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG LESS_THAN REG LPAREN IU RPAREN"); }
		}
	| REG ASSIGN REG LESS_THAN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm3)) {
/* CCflag:	CC = dregs < imm3
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs < imm3\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((imm3($5)&0x7)<<3)                     /* y<(imm3) */
		                |((1&0x7)<<7)                            /* opc<(1) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && const_fits($5,c_imm3)) {
/* CCflag:	CC = pregs < imm3
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs < imm3\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((imm3($5)&0x7)<<3)                     /* y<(imm3) */
		                |((1&0x7)<<7)                            /* opc<(1) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG LESS_THAN expr"); }
		}
	| REG ASSIGN REG LESS_THAN expr LPAREN IU RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm3)) {
/* CCflag:	CC = dregs < uimm3 ( IU )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs < uimm3 ( IU )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((uimm3($5)&0x7)<<3)                    /* y<(uimm3) */
		                |((3&0x7)<<7)                            /* opc<(3) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && const_fits($5,c_uimm3)) {
/* CCflag:	CC = pregs < uimm3 ( IU )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs < uimm3 ( IU )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((uimm3($5)&0x7)<<3)                    /* y<(uimm3) */
		                |((3&0x7)<<7)                            /* opc<(3) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG LESS_THAN expr LPAREN IU RPAREN"); }
		}
	| REG ASSIGN REG MINUS REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* COMP3op:	dregs = dregs - dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: dregs = dregs - dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<0)                    /* src0<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* src1<(dregs) */
		                |((1&0x7)<<9)                            /* opc<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG MINUS REG"); }
		}
	| REG ASSIGN REG PLUS REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* COMP3op:	dregs = dregs + dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: dregs = dregs + dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((dregs($1)&0x7)<<6)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<0)                    /* src0<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* src1<(dregs) */
		                |((0&0x7)<<9)                            /* opc<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)
		             && reginclass($5,rc_pregs)) {
/* COMP3op:	pregs = pregs + pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: pregs = pregs + pregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((pregs($1)&0x7)<<6)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<0)                    /* src0<(pregs) */
		                |((pregs($5)&0x7)<<3)                    /* src1<(pregs) */
		                |((5&0x7)<<9)                            /* opc<(5) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG PLUS REG"); }
		}
	| REG ASSIGN REG PLUS LPAREN REG LESS_LESS expr RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)
		             && reginclass($6,rc_pregs)
		             && EXPR_VALUE($8) == 1) {
/* COMP3op:	pregs = pregs + (pregs << 1)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: pregs = pregs + (pregs << 1)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((pregs($1)&0x7)<<6)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<0)                    /* src0<(pregs) */
		                |((pregs($6)&0x7)<<3)                    /* src1<(pregs) */
		                |((6&0x7)<<9)                            /* opc<(6) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)
		             && reginclass($6,rc_pregs)
		             && EXPR_VALUE($8) == 2) {
/* COMP3op:	pregs = pregs + (pregs << 2)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMP3op: pregs = pregs + (pregs << 2)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x005000
		                |((pregs($1)&0x7)<<6)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<0)                    /* src0<(pregs) */
		                |((pregs($6)&0x7)<<3)                    /* src1<(pregs) */
		                |((7&0x7)<<9)                            /* opc<(7) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG PLUS LPAREN REG LESS_LESS expr RPAREN"); }
		}
	| REG_A00 ASSIGN REG_A00 LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $3 == REG_A0) {
/* dsp32alu:	A0 = A0 (S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 = A0 (S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((8&0x1f)<<0)                           /* aopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x3)<<14)                           /* aop<(0) */
		                  |((1&0x1)<<13)                           /* s<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN REG_A00 LPAREN S RPAREN"); }
		}
	| REG_A11 ASSIGN REG_A11 LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $3 == REG_A1) {
/* dsp32alu:	A1 = A1 (S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = A1 (S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((8&0x1f)<<0)                           /* aopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((1&0x3)<<14)                           /* aop<(1) */
		                  |((1&0x1)<<13)                           /* s<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN REG_A11 LPAREN S RPAREN"); }
		}
	| REG ASSIGN REG_A00 _ASSIGN_ASSIGN REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && $3 == REG_A0
		             && $5 == REG_A1) {
/* CCflag:	CC = A0 == A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = A0 == A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((5&0x7)<<7)                            /* opc<(5) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG_A00 _ASSIGN_ASSIGN REG_A11"); }
		}
	| REG ASSIGN REG _ASSIGN_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && reginclass($5,rc_pregs)) {
/* CCflag:	CC = pregs == pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs == pregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((pregs($5)&0x7)<<3)                    /* y<(pregs) */
		                |((0&0x7)<<7)                            /* opc<(0) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* CCflag:	CC = dregs == dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs == dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* y<(dregs) */
		                |((0&0x7)<<7)                            /* opc<(0) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _ASSIGN_ASSIGN REG"); }
		}
	| REG ASSIGN REG _ASSIGN_ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm3)) {
/* CCflag:	CC = dregs == imm3
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs == imm3\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((imm3($5)&0x7)<<3)                     /* y<(imm3) */
		                |((0&0x7)<<7)                            /* opc<(0) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && const_fits($5,c_imm3)) {
/* CCflag:	CC = pregs == imm3
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs == imm3\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((imm3($5)&0x7)<<3)                     /* y<(imm3) */
		                |((0&0x7)<<7)                            /* opc<(0) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _ASSIGN_ASSIGN expr"); }
		}
	| REG ASSIGN REG_A00 _LESS_THAN_ASSIGN REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && $3 == REG_A0
		             && $5 == REG_A1) {
/* CCflag:	CC = A0 <= A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = A0 <= A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((7&0x7)<<7)                            /* opc<(7) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG_A00 _LESS_THAN_ASSIGN REG_A11"); }
		}
	| REG ASSIGN REG _LESS_THAN_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && reginclass($5,rc_pregs)) {
/* CCflag:	CC = pregs <= pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs <= pregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((pregs($5)&0x7)<<3)                    /* y<(pregs) */
		                |((2&0x7)<<7)                            /* opc<(2) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* CCflag:	CC = dregs <= dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs <= dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* y<(dregs) */
		                |((2&0x7)<<7)                            /* opc<(2) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _LESS_THAN_ASSIGN REG"); }
		}
	| REG ASSIGN REG _LESS_THAN_ASSIGN REG LPAREN IU RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* CCflag:	CC = dregs <= dregs ( IU )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs <= dregs ( IU )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((dregs($5)&0x7)<<3)                    /* y<(dregs) */
		                |((4&0x7)<<7)                            /* opc<(4) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && reginclass($5,rc_pregs)) {
/* CCflag:	CC = pregs <= pregs ( IU )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs <= pregs ( IU )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((pregs($5)&0x7)<<3)                    /* y<(pregs) */
		                |((4&0x7)<<7)                            /* opc<(4) */
		                |((0&0x1)<<10)                           /* I<(0) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _LESS_THAN_ASSIGN REG LPAREN IU RPAREN"); }
		}
	| REG ASSIGN REG _LESS_THAN_ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_imm3)) {
/* CCflag:	CC = dregs <= imm3
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs <= imm3\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((imm3($5)&0x7)<<3)                     /* y<(imm3) */
		                |((2&0x7)<<7)                            /* opc<(2) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && const_fits($5,c_imm3)) {
/* CCflag:	CC = pregs <= imm3
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs <= imm3\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((imm3($5)&0x7)<<3)                     /* y<(imm3) */
		                |((2&0x7)<<7)                            /* opc<(2) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _LESS_THAN_ASSIGN expr"); }
		}
	| REG ASSIGN REG _LESS_THAN_ASSIGN expr LPAREN IU RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_dregs)
		             && const_fits($5,c_uimm3)) {
/* CCflag:	CC = dregs <= uimm3 ( IU )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = dregs <= uimm3 ( IU )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((dregs($3)&0x7)<<0)                    /* x<(dregs) */
		                |((uimm3($5)&0x7)<<3)                    /* y<(uimm3) */
		                |((4&0x7)<<7)                            /* opc<(4) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((0&0x1)<<6)                            /* G<(0) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_pregs)
		             && const_fits($5,c_uimm3)) {
/* CCflag:	CC = pregs <= uimm3 ( IU )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CCflag: CC = pregs <= uimm3 ( IU )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000800
		                |((pregs($3)&0x7)<<0)                    /* x<(pregs) */
		                |((uimm3($5)&0x7)<<3)                    /* y<(uimm3) */
		                |((4&0x7)<<7)                            /* opc<(4) */
		                |((1&0x1)<<10)                           /* I<(1) */
		                |((1&0x1)<<6)                            /* G<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _LESS_THAN_ASSIGN expr LPAREN IU RPAREN"); }
		}
	| LOW_REG ASSIGN REG LPAREN RND RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	dregs_lo = dregs (RND)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs (RND)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((12&0x1f)<<0)                          /* aopcde<(12) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG LPAREN RND RPAREN"); }
		}
	| HIGH_REG ASSIGN REG LPAREN RND RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	dregs_hi = dregs (RND)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs (RND)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((12&0x1f)<<0)                          /* aopcde<(12) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN REG LPAREN RND RPAREN"); }
		}
	| LOW_REG ASSIGN REG MINUS REG LPAREN RND12 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo = dregs - dregs (RND12)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs - dregs (RND12)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((5&0x1f)<<0)                           /* aopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x1)<<12)                           /* x<(0) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG MINUS REG LPAREN RND12 RPAREN"); }
		}
	| HIGH_REG ASSIGN REG MINUS REG LPAREN RND12 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi = dregs - dregs (RND12)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs - dregs (RND12)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((5&0x1f)<<0)                           /* aopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x1)<<12)                           /* x<(0) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN REG MINUS REG LPAREN RND12 RPAREN"); }
		}
	| LOW_REG ASSIGN REG PLUS REG LPAREN RND12 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo =  dregs + dregs (RND12)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs + dregs (RND12)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((5&0x1f)<<0)                           /* aopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x1)<<12)                           /* x<(0) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG PLUS REG LPAREN RND12 RPAREN"); }
		}
	| HIGH_REG ASSIGN REG PLUS REG LPAREN RND12 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi = dregs + dregs (RND12)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs + dregs (RND12)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((5&0x1f)<<0)                           /* aopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x1)<<12)                           /* x<(0) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN REG PLUS REG LPAREN RND12 RPAREN"); }
		}
	| LOW_REG ASSIGN REG MINUS REG LPAREN RND20 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo = dregs - dregs (RND20)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs - dregs (RND20)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((5&0x1f)<<0)                           /* aopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((1&0x1)<<12)                           /* x<(1) */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG MINUS REG LPAREN RND20 RPAREN"); }
		}
	| HIGH_REG ASSIGN REG MINUS REG LPAREN RND20 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi =  dregs - dregs (RND20)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs - dregs (RND20)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((5&0x1f)<<0)                           /* aopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((1&0x1)<<12)                           /* x<(1) */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN REG MINUS REG LPAREN RND20 RPAREN"); }
		}
	|  LOW_REG ASSIGN REG PLUS REG LPAREN RND20 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_lo =  dregs + dregs (RND20)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = dregs + dregs (RND20)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((5&0x1f)<<0)                           /* aopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((1&0x1)<<12)                           /* x<(1) */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG PLUS REG LPAREN RND20 RPAREN"); }
		}
	|  HIGH_REG ASSIGN REG PLUS REG LPAREN RND20 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs_hi =  dregs + dregs (RND20)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_hi = dregs + dregs (RND20)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((1&0x1)<<5)                            /* HL<(1) */
		                |((5&0x1f)<<0)                           /* aopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_hi) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((1&0x1)<<12)                           /* x<(1) */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN REG PLUS REG LPAREN RND20 RPAREN"); }
		}
	| REG_A00 ASSIGN REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $3 == REG_A1) {
/* dsp32alu:	A0 = A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 = A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((8&0x1f)<<0)                           /* aopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((3&0x3)<<14)                           /* aop<(3) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN REG_A11"); }
		}
	| REG_A11 ASSIGN REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $3 == REG_A0) {
/* dsp32alu:	A1 = A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = A0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((8&0x1f)<<0)                           /* aopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((3&0x3)<<14)                           /* aop<(3) */
		                  |((1&0x1)<<13)                           /* s<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN REG_A00"); }
		}
	| REG_A00 ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	A0 = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 = dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((9&0x1f)<<0)                           /* aopcde<(9) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		                  |((1&0x1)<<13)                           /* s<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN REG"); }
		}
	| REG_A11 ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	A1 = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((9&0x1f)<<0)                           /* aopcde<(9) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		                  |((1&0x1)<<13)                           /* s<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN REG"); }
		}
	| REG ASSIGN MODIFIED_STATUS_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC 
		             && (($3==0) || ($3==1) || ($3==6) || ($3==2) || ($3==3) || ($3==4)) ) {
/* CC2stat:	CC = statbits
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2stat: CC = statbits\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000300
		                |(($3&0x1f)<<0)                /* cbit<(statbits) */
		                |((0&0x3)<<5)                            /* op<(0) */
		                |((0&0x1)<<7)                            /* D<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN MODIFIED_STATUS_REG"); }
		}
	| MODIFIED_STATUS_REG ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && (($1==0) || ($1==1) || ($1==6) || ($1==2) || ($1==3) || ($1==4))
		             && $3 == REG_CC) {
/* CC2stat:	statbits = CC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2stat: statbits = CC\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000300
		                |(($1&0x1f)<<0)                /* cbit<(statbits) */
		                |((0&0x3)<<5)                            /* op<(0) */
		                |((1&0x1)<<7)                            /* D<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("MODIFIED_STATUS_REG ASSIGN REG"); }
		}
	| REG ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_allregs)
		             && reginclass($3,rc_allregs)) {
/* REGMV:	allregs = allregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 1 |.gd........|.gs........|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("REGMV: allregs = allregs\n");
		    $$ = 
		      CONSCODE(
		        GENCODE(0x003000
		                |((allregs($1)&0x7)<<3)                  /* dst<(allregs) */
		                |((allregs($3)&0x7)<<0)                  /* src<(allregs) */
		                |((Xallregs($3)&0x7)<<6)                 /* gs<(Xallregs($3)) */
		                |((Xallregs($1)&0x7)<<9)                 /* gd<(Xallregs($1)) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC 
		             && reginclass($3,rc_dregs)) {
/* CC2dreg:	CC = dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2dreg: CC = dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000200
		                |((dregs($3)&0x7)<<0)                    /* reg<(dregs) */
		                |((1&0x3)<<3)                            /* op<(1) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $3 == REG_CC) {
/* CC2dreg:	dregs = CC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2dreg: dregs = CC\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000200
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((0&0x3)<<3)                            /* op<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG"); }
		}
	| REG ASSIGN LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0x
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	A0.x = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0.x = dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((9&0x1f)<<0)                           /* aopcde<(9) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1x
		             && reginclass($3,rc_dregs)) {
/* dsp32alu:	A1.x = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1.x = dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((9&0x1f)<<0)                           /* aopcde<(9) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs = dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((11&0xf)<<6)                           /* opc<(11) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN LOW_REG"); }
		}
	| LOW_REG ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $3 == REG_A0x) {
/* dsp32alu:	dregs_lo = A0.x
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = A0.x\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((10&0x1f)<<0)                          /* aopcde<(10) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $3 == REG_A1x) {
/* dsp32alu:	dregs_lo = A1.x
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs_lo = A1.x\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((10&0x1f)<<0)                          /* aopcde<(10) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN REG"); }
		}
	| REG ASSIGN BYTE_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs = dregs_byte
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = dregs_byte\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((13&0xf)<<6)                           /* opc<(13) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTE_REG"); }
		}
	| REG_A00 ASSIGN ROT REG_A00 BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $4 == REG_A0
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	A0 = ROT  A0 BY dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: A0 = ROT A0 BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN ROT REG_A00 BY LOW_REG"); }
		}
	| REG_A11 ASSIGN ROT REG_A11 BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $4 == REG_A1
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	A1 = ROT A1 BY dregs_lo 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: A1 = ROT A1 BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN ROT REG_A11 BY LOW_REG"); }
		}
	| REG ASSIGN ROT REG BY LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)) {
/* dsp32shift:	dregs = ROT dregs BY dregs_lo 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = ROT dregs BY dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($6)&0x7)<<3)                 /* src0<(dregs_lo) */
		                  |((3&0x3)<<14)                           /* sop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN ROT REG BY LOW_REG"); }
		}
	| REG_A00 ASSIGN ROT REG_A00 BY expr 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $4 == REG_A0
		             && const_fits($6,c_imm6)) {
/* dsp32shiftimm:	A0 = ROT A0 BY imm6
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: A0 = ROT A0 BY imm6\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm6($6)&0x3f)<<3)                    /* immag<(imm6) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		                  |((0&0x3)<<12)                           /* HLs<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN ROT REG_A00 BY expr"); }
		}
	| REG_A11 ASSIGN ROT REG_A11 BY expr 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $4 == REG_A1
		             && const_fits($6,c_imm6)) {
/* dsp32shiftimm:	A1 = ROT A1 BY imm6
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: A1 = ROT A1 BY imm6\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((3&0x1f)<<0)                           /* sopcde<(3) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm6($6)&0x3f)<<3)                    /* immag<(imm6) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		                  |((1&0x3)<<12)                           /* HLs<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN ROT REG_A11 BY expr"); }
		}
	| REG ASSIGN ROT REG BY expr 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && const_fits($6,c_imm6)) {
/* dsp32shiftimm:	dregs = ROT dregs BY imm6
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shiftimm: dregs = ROT dregs BY imm6\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c680
		                |((2&0x1f)<<0)                           /* sopcde<(2) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((imm6($6)&0x3f)<<3)                    /* immag<(imm6) */
		                  |((3&0x3)<<14)                           /* sop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN ROT REG BY expr"); }
		}
	| LOW_REG ASSIGN SIGNBITS REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $4 == REG_A0) {
/* dsp32shift:	dregs_lo = SIGNBITS A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = SIGNBITS A0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((6&0x1f)<<0)                           /* sopcde<(6) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN SIGNBITS REG_A00"); }
		}
	| LOW_REG ASSIGN SIGNBITS REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && $4 == REG_A1) {
/* dsp32shift:	dregs_lo = SIGNBITS A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = SIGNBITS A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((6&0x1f)<<0)                           /* sopcde<(6) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN SIGNBITS REG_A11"); }
		}
	| LOW_REG ASSIGN SIGNBITS REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* dsp32shift:	dregs_lo = SIGNBITS dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = SIGNBITS dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((5&0x1f)<<0)                           /* sopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN SIGNBITS REG"); }
		}
	| LOW_REG ASSIGN SIGNBITS LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* dsp32shift:	dregs_lo = SIGNBITS dregs_lo
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = SIGNBITS dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((5&0x1f)<<0)                           /* sopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_lo) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN SIGNBITS LOW_REG"); }
		}
	| LOW_REG ASSIGN SIGNBITS HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* dsp32shift:	dregs_lo = SIGNBITS dregs_hi
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = SIGNBITS dregs_hi\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((5&0x1f)<<0)                           /* sopcde<(5) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($4)&0x7)<<0)                 /* src1<(dregs_hi) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN SIGNBITS HIGH_REG"); }
		}
	| REG ASSIGN TILDA REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)) {
/* ALU2op:	dregs = ~ dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = ~ dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($4)&0x7)<<3)                    /* src<(dregs) */
		                |((15&0xf)<<6)                           /* opc<(15) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN TILDA REG"); }
		}
	| LOW_REG ASSIGN VIT_MAX LPAREN REG RPAREN LPAREN ASR RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32shift:	dregs_lo = VIT_MAX (dregs) (ASR)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = VIT_MAX (dregs) (ASR)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((9&0x1f)<<0)                           /* sopcde<(9) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN VIT_MAX LPAREN REG RPAREN LPAREN ASR RPAREN"); }
		}
	| LOW_REG ASSIGN VIT_MAX LPAREN REG RPAREN LPAREN ASL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32shift:	dregs_lo = VIT_MAX (dregs) (ASL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs_lo = VIT_MAX (dregs) (ASL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((9&0x1f)<<0)                           /* sopcde<(9) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                 /* dst0<(dregs_lo) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN VIT_MAX LPAREN REG RPAREN LPAREN ASL RPAREN"); }
		}
	| REG ASSIGN VIT_MAX LPAREN REG COMMA REG RPAREN LPAREN ASR RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = VIT_MAX (dregs, dregs) (ASR)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = VIT_MAX (dregs, dregs) (ASR)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((9&0x1f)<<0)                           /* sopcde<(9) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((3&0x3)<<14)                           /* sop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN VIT_MAX LPAREN REG COMMA REG RPAREN LPAREN ASR RPAREN"); }
		}
	| REG ASSIGN VIT_MAX LPAREN REG COMMA REG RPAREN LPAREN ASL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32shift:	dregs = VIT_MAX (dregs, dregs) (ASL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: dregs = VIT_MAX (dregs, dregs) (ASL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((9&0x1f)<<0)                           /* sopcde<(9) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((dregs($7)&0x7)<<3)                    /* src0<(dregs) */
		                  |((2&0x3)<<14)                           /* sop<(2) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN VIT_MAX LPAREN REG COMMA REG RPAREN LPAREN ASL RPAREN"); }
		}
	| REG ASSIGN B LBRACK REG PLUS expr RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && const_fits($7,c_imm16)) {
/* LDSTidxI:	dregs = B [ pregs + imm16 ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: dregs = B [ pregs + imm16 ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e400
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((2&0x3)<<6)                            /* sz<(2) */
		                |((1&0x1)<<8)                            /* Z<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16($7)&0xffff)<<0)                 /* offset<(imm16) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN B LBRACK REG PLUS expr RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN B LBRACK REG RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = B [ pregs ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = B [ pregs ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN B LBRACK REG RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN B LBRACK REG _MINUS_MINUS RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = B [ pregs -- ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = B [ pregs -- ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN B LBRACK REG _MINUS_MINUS RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN B LBRACK REG _PLUS_PLUS RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = B [ pregs ++ ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = B [ pregs ++ ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((2&0x3)<<10)                           /* sz<(2) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN B LBRACK REG _PLUS_PLUS RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN W LBRACK REG PLUS expr RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && const_fits($7,c_uimm4s2)) {
/* LDSTii:	dregs = W [ pregs + uimm4s2 ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTii: dregs = W [ pregs + uimm4s2 ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00a000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((uimm4s2($7)&0xf)<<6)                  /* offset<(uimm4s2) */
		                |((0&0x1)<<12)                           /* W<(0) */
		                |((2&0x3)<<10)                           /* op<(2) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && const_fits($7,c_imm16s2)) {
/* LDSTidxI:	dregs = W [ pregs + imm16s2 ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTidxI: dregs = W [ pregs + imm16s2 ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e400
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x1)<<9)                            /* W<(0) */
		                |((1&0x3)<<6)                            /* sz<(1) */
		                |((1&0x1)<<8)                            /* Z<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16s2($7)&0xffff)<<0)               /* offset<(imm16s2) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG PLUS expr RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN W LBRACK REG RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = W [ pregs ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = W [ pregs ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((2&0x3)<<7)                            /* aop<(2) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN W LBRACK REG _MINUS_MINUS RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = W [ pregs -- ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = W [ pregs -- ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((1&0x3)<<7)                            /* aop<(1) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG _MINUS_MINUS RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN W LBRACK REG _PLUS_PLUS RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)) {
/* LDST:	dregs = W [ pregs ++ ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDST: dregs = W [ pregs ++ ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009000
		                |((dregs($1)&0x7)<<0)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<3)                    /* ptr<(pregs) */
		                |((0&0x3)<<7)                            /* aop<(0) */
		                |((1&0x3)<<10)                           /* sz<(1) */
		                |((1&0x1)<<6)                            /* Z<(1) */
		                |((0&0x1)<<9)                            /* W<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG _PLUS_PLUS RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($5,rc_pregs)
		             && reginclass($7,rc_pregs)) {
/* LDSTpmod:	dregs = W [ pregs ++ pregs ] (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDSTpmod: dregs = W [ pregs ++ pregs ] (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x008000
		                |((dregs($1)&0x7)<<6)                    /* reg<(dregs) */
		                |((pregs($5)&0x7)<<0)                    /* ptr<(pregs) */
		                |((pregs($7)&0x7)<<3)                    /* idx<(pregs) */
		                |((3&0x3)<<9)                            /* aop<(3) */
		                |((1&0x1)<<11)                           /* W<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN W LBRACK REG _PLUS_PLUS REG RBRACK LPAREN X RPAREN"); }
		}
	| REG ASSIGN LOW_REG LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs = dregs_lo (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = dregs_lo (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((10&0xf)<<6)                           /* opc<(10) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN LOW_REG LPAREN X RPAREN"); }
		}
	| REG ASSIGN BYTE_REG LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs = dregs_byte (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = dregs_byte (z)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((13&0xf)<<6)                           /* opc<(13) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTE_REG LPAREN Z RPAREN"); }
		}
	| REG ASSIGN BYTE_REG LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs = dregs_byte (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = dregs_byte (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                <((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((12&0xf)<<6)                           /* opc<(12) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN BYTE_REG LPAREN X RPAREN"); }
		}
	| REG ASSIGN LOW_REG LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs = dregs_lo (z)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = dregs_lo\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((11&0xf)<<6)                           /* opc<(11) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN LOW_REG LPAREN Z RPAREN"); }
		}
	| REG ASSIGN REG _MINUS_BAR_MINUS REG amod0 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs = dregs -|- dregs (amod0)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs -|- dregs (amod0)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1f)<<0)                           /* aopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                     /* s=amod0.s0 */
		                  |((($6.x0)&0x1)<<12)                     /* x=amod0.x0 */
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _MINUS_BAR_MINUS REG LPAREN amod0 RPAREN"); }
		}
	| REG ASSIGN REG _MINUS_BAR_PLUS REG amod0 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs = dregs -|+ dregs (amod0)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs -|+ dregs (amod0)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1f)<<0)                           /* aopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                     /* s=amod0.s0 */
		                  |((($6.x0)&0x1)<<12)                     /* x=amod0.x0 */
		                  |((2&0x3)<<14)                           /* aop<(2) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _MINUS_BAR_PLUS REG LPAREN amod0 RPAREN"); }
		}
	| REG ASSIGN REG _PLUS_BAR_MINUS REG amod0 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs = dregs +|- dregs (amod0)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: dregs = dregs +|- dregs (amod0)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1f)<<0)                           /* aopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                     /* s=amod0.s0 */
		                  |((($6.x0)&0x1)<<12)                     /* x=amod0.x0 */
		                  |((1&0x3)<<14)                           /* aop<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _PLUS_BAR_MINUS REG LPAREN amod0 RPAREN"); }
		}
	| REG ASSIGN REG _PLUS_BAR_PLUS REG amod0
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)) {
/* dsp32alu:	dregs = dregs +|+ dregs (amod0)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu:  dregs +|+ dregs (amod0)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1f)<<0)                           /* aopcde<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($1)&0x7)<<9)                    /* dst0<(dregs) */
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((($6.s0)&0x1)<<13)                     /* s=amod0.s0 */
		                  |((($6.x0)&0x1)<<12)                     /* x=amod0.x0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG ASSIGN REG _PLUS_BAR_PLUS REG LPAREN amod0 RPAREN"); }
		}
	| LOW_REG ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && const_fits($3,c_imm16)) {
/* LDIMMhalf:	dregs_lo = imm16
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDIMMhalf: dregs_lo = imm16\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e100
		                |((dregs($1)&0x7)<<0)                 /* reg<(dregs_lo) */
		                |((0&0x3)<<3)                            /* grp<(0) */
		                |((0&0x1)<<6)                            /* H<(0) */
		                |((0&0x1)<<5)                            /* S<(0) */
		                |((0&0x1)<<7)                            /* Z<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16($3)&0xffff)<<0)                 /* hword<(imm16) */
		          ),
		          NULL_CODE));
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($1,rc_regs)
		             && const_fits($3,c_luimm16)) {
/* LDIMMhalf:	L ( regs ) = luimm16
   LDIMMhalf:	regs = luimm16  This includes M, B, I, L & P Registers
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDIMMhalf: regs = luimm16\n");
                    $$ = CONSCODE(GENCODE(0x00e100
                                |((regs($1)&0x7)<<0)    /* reg<(regs) */
                                |((Xregs($1)&0x3)<<3)   /* grp<(Xregs($3)) */
                                |((0&0x1)<<6)           /* H<(0) */
                                |((0&0x1)<<5)           /* S<(0) */
                                |((0&0x1)<<7)           /* Z<(0) */
                           ),
                           ExprNodeGenReloc($3, BFD_RELOC_16_LOW));
#if 0
		    $$ = CONSCODE(
		        GENCODE(0x00e100
		                |((regs($1)&0x7)<<0)                     /* reg<(regs) */
		                |((Xregs($1)&0x3)<<3)                    /* grp<(Xregs($3)) */
		                |((0&0x1)<<6)                            /* H<(0) */
		                |((0&0x1)<<5)                            /* S<(0) */
		                |((0&0x1)<<7)                            /* Z<(0) */
		        ),
		        CONSCODE(
		          NOTERELOC(0,BFD_RELOC_16_LOW,$3,
		            GENCODE(0x000000
		                    |((luimm16($3)&0xffff)<<0)               /* hword<(luimm16) */
		            )),
		          NULL_CODE));
#endif
		
		  } else { $$ = 0; semantic_error ("LOW_REG ASSIGN expr"); }
		}
	| HIGH_REG ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && const_fits($3,c_imm16)) {
/* LDIMMhalf:	dregs_hi = imm16
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDIMMhalf: dregs_hi = imm16\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e100
		                |((dregs($1)&0x7)<<0)                 /* reg<(dregs_hi) */
		                |((0&0x3)<<3)                            /* grp<(0) */
		                |((1&0x1)<<6)                            /* H<(1) */
		                |((0&0x1)<<5)                            /* S<(0) */
		                |((0&0x1)<<7)                            /* Z<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16($3)&0xffff)<<0)                 /* hword<(imm16) */
		          ),
		          NULL_CODE));
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) 
		             && reginclass($1,rc_regs)
		             && const_fits($3,c_huimm16)) {
/* LDIMMhalf:	H ( regs ) = huimm16
   LDIMMhalf:	regs = huimm16  This includes M, I, B, L & P Registers
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDIMMhalf: regs = huimm16\n");
                    $$ = CONSCODE(GENCODE(0x00e100
                                |((regs($1)&0x7)<<0)     /* reg<(regs) */
                                |((Xregs($1)&0x3)<<3)    /* grp<(Xregs($3)) */
                                |((1&0x1)<<6)            /* H<(1) */
                                |((0&0x1)<<5)            /* S<(0) */
                                |((0&0x1)<<7)            /* Z<(0) */
                           ),
                           ExprNodeGenReloc($3, BFD_RELOC_16_HIGH));
#if 0
		    $$ = CONSCODE(
		        GENCODE(0x00e100
		                |((regs($1)&0x7)<<0)                     /* reg<(regs) */
		                |((Xregs($1)&0x3)<<3)                    /* grp<(Xregs($3)) */
		                |((1&0x1)<<6)                            /* H<(1) */
		                |((0&0x1)<<5)                            /* S<(0) */
		                |((0&0x1)<<7)                            /* Z<(0) */
		        ),
		        CONSCODE(  
		          NOTERELOC(0,BFD_RELOC_16_HIGH,$3,
		            GENCODE(0x000000
		                    |((huimm16($3)&0xffff)<<0)               /* hword<(huimm16) */
		            )),
		          NULL_CODE));
#endif
		
		  } else { $$ = 0; semantic_error ("HIGH_REG ASSIGN expr"); }
		}
	| REG_A00 ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0) {
/* dsp32alu:	A0 = 0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 = 0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((8&0x1f)<<0)                           /* aopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x3)<<14)                           /* aop<(0) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN expr"); }
		}
	| REG_A11 ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1) {
/* dsp32alu:	A1 = 0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = 0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((8&0x1f)<<0)                           /* aopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((1&0x3)<<14)                           /* aop<(1) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN expr"); }
		}
	| REG ASSIGN expr 
		{
                   /* ExprNode *pNode = ExprNodeCreate(ExprNodeBinOp, "+",
                                             ExprNodeCreate(ExprNodeReloc, "$L$1", 0, 0),
                                             ExprNodeCreate(ExprNodeConstant, 1, 0, 0));
			printf("reg = target got called zero param = %s"
	"first param = %d third param = %s\n", $$->exp->symbol->bsym->, $1,  $3->symbol->bsym);*/
//		int arith_reloc_code = 0xAABBCCDD;
//		fprintf(stderr, "entry for rN=<preg>\n");	
		if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && const_fits($3,c_imm7)) {
/* COMPI2opD:	dregs = imm7 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 0 |.op|.isrc......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMPI2opD: dregs = imm7 \n");

		    $$ =
		      CONSCODE(
		        GENCODE(0x006000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((imm7($3)&0x7f)<<3)                    /* isrc<(imm7) */
		                |((0&0x1)<<10)                           /* op<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && const_fits($3,c_imm7)) {
/* COMPI2opP:	pregs = imm7 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 1 |.op|.src.......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/		   
		    notethat("COMPI2opP: pregs = imm7\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x006800
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((imm7($3)&0x7f)<<3)                    /* src<(imm7) */
		                |((0&0x1)<<10)                           /* op<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_regs)
		             && const_fits($3,c_luimm16)) {
/* LDIMMhalf:	regs = luimm16 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
//			fprintf(stderr, "adding %d reloc\n",BFD_ARELOC_EC);	
		    notethat("LDIMMhalf: regs = luimm16 \n");
#if 0
		    $$ =
		  //    CONSCODE(GENCODE(arith_reloc_code),
			CONSCODE(
		        GENCODE(0x00e100
		                |((regs($1)&0x7)<<0)                     /* reg<(regs) */
		                |((Xregs($1)&0x3)<<3)                    /* grp<(Xregs($3)) */
		                |((0&0x1)<<6)                            /* H<(0) */
		                |((0&0x1)<<5)                            /* S<(0) */
		                |((1&0x1)<<7)                            /* Z<(1) */
		        ),
		        CONSCODE(
		          NOTERELOC(0,BFD_RELOC_16_IMM,$3,
		            GENCODE(0x000000
		                    |((luimm16($3)&0xffff)<<0)               /* hword<(luimm16) */
		            )),
		          NULL_CODE));
#endif
			{
#if 0
			ExprNode* constVal;
			ExprNode* negOp;
			ExprNode* head;
			ExprNodeValue val, val1, val2;
			val.i_value = 1;
			constVal = ExprNodeCreate(ExprNodeConstant,val, NULL, NULL);
			val.op_value = ExprOpTypeSub;
			val1.s_value = "_L$L4";
			val2.s_value = "_L$L5";
			negOp  = ExprNodeCreate(ExprNodeBinop, val,
					ExprNodeCreate(ExprNodeReloc, val1, NULL, NULL),
					ExprNodeCreate(ExprNodeReloc, val2, NULL, NULL));
			val.op_value = ExprOpTypeAdd;
			head   = ExprNodeCreate(ExprNodeBinop, val, negOp, constVal); 
#endif
		
			$$ = CONSCODE(
		        	GENCODE(0x00e100
		                |((regs($1)&0x7)<<0)                     /* reg<(regs) */
		                |((Xregs($1)&0x3)<<3)                    /* grp<(Xregs($3)) */
		                |((0&0x1)<<6)                            /* H<(0) */
		                |((0&0x1)<<5)                            /* S<(0) */
		                |((1&0x1)<<7)                            /* Z<(1) */
		        ),
			ExprNodeGenReloc($3, BFD_RELOC_16_IMM)
		          );
			}

		  } else { $$ = 0; semantic_error ("REG ASSIGN expr"); }
		}
	| REG ASSIGN expr LPAREN X RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && const_fits($3,c_imm7)) {
/* COMPI2opD:	dregs = imm7 (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 0 |.op|.isrc......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMPI2opD: dregs = imm7 (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x006000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((imm7($3)&0x7f)<<3)                    /* isrc<(imm7) */
		                |((0&0x1)<<10)                           /* op<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && const_fits($3,c_imm7)) {
/* COMPI2opP:	pregs = imm7 (x)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 1 |.op|.src.......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMPI2opP: pregs = imm7 (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x006800
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((imm7($3)&0x7f)<<3)                    /* src<(imm7) */
		                |((0&0x1)<<10)                           /* op<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_regs)
		             && const_fits($3,c_imm16) ) {
/* LDIMMhalf:	regs = imm16 (x)  This include R, P, M, I, B & L Registers
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LDIMMhalf: regs = imm16 (x)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e100
		                |((regs($1)&0x7)<<0)                     /* reg<(regs) */
		                |((Xregs($1)&0x3)<<3)                    /* grp<(Xregs($1)) */
		                |((0&0x1)<<6)                            /* H<(0) */
		                |((1&0x1)<<5)                            /* S<(1) */
		                |((0&0x1)<<7)                            /* Z<(0) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((imm16($3)&0xffff)<<0)                 /* hword<(imm16) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG ASSIGN expr LPAREN X RPAREN"); }
		}
	| REG_A11 ASSIGN ABS REG_A11 COMMA REG_A00 ASSIGN ABS REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $6 == REG_A0
		             && $4 == REG_A1
		             && $9 == REG_A0) {
/* dsp32alu:	A1 = ABS A1 , A0 =  ABS A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = ABS A1 , A0 = ABS A0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((16&0x1f)<<0)                          /* aopcde<(16) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN ABS REG_A11 COMMA REG_A00 ASSIGN ABS REG_A00"); }
		}
	| REG_A11 ASSIGN MINUS REG_A11 COMMA REG_A00 ASSIGN MINUS REG_A00
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $6 == REG_A0
		             && $4 == REG_A1
		             && $9 == REG_A0) {
/* dsp32alu:	A1 = - A1 , A0 = - A0
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = - A1 , A0 = - A0\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((0&0x1)<<5)                            /* HL<(0) */
		                |((14&0x1f)<<0)                          /* aopcde<(14) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((3&0x3)<<14)                           /* aop<(3) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN MINUS REG_A11 COMMA REG_A00 ASSIGN MINUS REG_A00"); }
		}
	| BITMUX LPAREN REG COMMA REG COMMA REG_A00 RPAREN LPAREN ASR RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && $7 == REG_A0) {
/* dsp32shift:	BITMUX (dregs , dregs , A0) (ASR)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: BITMUX (dregs , dregs , A0) (ASR)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((8&0x1f)<<0)                           /* sopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("BITMUX LPAREN REG COMMA REG COMMA REG_A00 RPAREN LPAREN ASR RPAREN"); }
		}
	| BITMUX LPAREN REG COMMA REG COMMA REG_A00 RPAREN LPAREN ASL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_dregs)
		             && reginclass($5,rc_dregs)
		             && $7 == REG_A0) {
/* dsp32shift:	BITMUX (dregs , dregs , A0) (ASL)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: BITMUX (dregs , dregs , A0) (ASL)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((8&0x1f)<<0)                           /* sopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)                    /* src0<(dregs) */
		                  |((dregs($5)&0x7)<<0)                    /* src1<(dregs) */
		                  |((1&0x3)<<14)                           /* sop<(1) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("BITMUX LPAREN REG COMMA REG COMMA REG_A00 RPAREN LPAREN ASL RPAREN"); }
		}
	| REG _AMPERSAND_ASSIGN MODIFIED_STATUS_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && (($3==0) || ($3==1) || ($3==6) || ($3==2) || ($3==3) || ($3==4)) ) {
/* CC2stat:	CC &= statbits
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2stat: CC &= statbits\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000300
		                |(($3&0x1f)<<0)                /* cbit<(statbits) */
		                |((2&0x3)<<5)                            /* op<(2) */
		                |((0&0x1)<<7)                            /* D<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG _AMPERSAND_ASSIGN MODIFIED_STATUS_REG"); }
		}
	| MODIFIED_STATUS_REG _AMPERSAND_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && (($1==0) || ($1==1) || ($1==6) || ($1==2) || ($1==3) || ($1==4)) 
		             && $3 == REG_CC) {
/* CC2stat:	statbits &= CC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2stat: statbits &= CC\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000300
		                |(($1&0x1f)<<0)                /* cbit<(statbits) */
		                |((2&0x3)<<5)                            /* op<(2) */
		                |((1&0x1)<<7)                            /* D<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("MODIFIED_STATUS_REG _AMPERSAND_ASSIGN REG"); }
		}
	| REG _BAR_ASSIGN MODIFIED_STATUS_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && (($3==0) || ($3==1) || ($3==6) || ($3==2) || ($3==3) || ($3==4)) ) {
/* CC2stat:	CC |= statbits
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2stat: CC |= statbits\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000300
		                |(($3&0x1f)<<0)                /* cbit<(statbits) */
		                |((1&0x3)<<5)                            /* op<(1) */
		                |((0&0x1)<<7)                            /* D<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _BAR_ASSIGN MODIFIED_STATUS_REG"); }
		}
	| MODIFIED_STATUS_REG _BAR_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && (($1==0) || ($1==1) || ($1==6) || ($1==2) || ($1==3) || ($1==4)) 
		             && $3 == REG_CC) {
/* CC2stat:	statbits |= CC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2stat: statbits |= CC\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000300
		                |(($1&0x1f)<<0)                /* cbit<(statbits) */
		                |((1&0x3)<<5)                            /* op<(1) */
		                |((1&0x1)<<7)                            /* D<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("MODIFIED_STATUS_REG _BAR_ASSIGN REG"); }
		}
	| REG _GREATER_GREATER_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs >>= dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs >>= dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((1&0xf)<<6)                            /* opc<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _GREATER_GREATER_ASSIGN REG"); }
		}
	| REG _GREATER_GREATER_ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && const_fits($3,c_uimm5)) {
/* LOGI2op:	dregs >>= uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LOGI2op: dregs >>= uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004800
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((uimm5($3)&0x1f)<<3)                   /* src<(uimm5) */
		                |((6&0x7)<<8)                            /* opc<(6) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _GREATER_GREATER_ASSIGN expr"); }
		}
	| REG _GREATER_GREATER_GREATER_THAN_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs >>>= dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs >>>= dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((0&0xf)<<6)                            /* opc<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _GREATER_GREATER_GREATER_THAN_ASSIGN REG"); }
		}
	| REG _GREATER_GREATER_GREATER_THAN_ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && const_fits($3,c_uimm5)) {
/* LOGI2op:	dregs >>>= uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LOGI2op: dregs >>>= uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004800
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((uimm5($3)&0x1f)<<3)                   /* src<(uimm5) */
		                |((5&0x7)<<8)                            /* opc<(5) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _GREATER_GREATER_GREATER_THAN_ASSIGN expr"); }
		}
	| REG _KARAT_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_CC
		             && reginclass($3,rc_statbits)) {
/* CC2stat:	CC ^= statbits
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2stat: CC ^= statbits\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000300
		                |((statbits($3)&0x1f)<<0)                /* cbit<(statbits) */
		                |((3&0x3)<<5)                            /* op<(3) */
		                |((0&0x1)<<7)                            /* D<(0) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_statbits)
		             && $3 == REG_CC) {
/* CC2stat:	statbits ^= CC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("CC2stat: statbits ^= CC\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000300
		                |((statbits($1)&0x1f)<<0)                /* cbit<(statbits) */
		                |((3&0x3)<<5)                            /* op<(3) */
		                |((1&0x1)<<7)                            /* D<(1) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG _KARAT_ASSIGN REG"); }
		}
	| REG _LESS_LESS_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs <<= dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs <<= dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((2&0xf)<<6)                            /* opc<(2) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG _LESS_LESS_ASSIGN REG"); }
		}
	| REG _LESS_LESS_ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && const_fits($3,c_uimm5)) {
/* LOGI2op:	dregs <<= uimm5
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("LOGI2op: dregs <<= uimm5\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004800
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((uimm5($3)&0x1f)<<3)                   /* src<(uimm5) */
		                |((7&0x7)<<8)                            /* opc<(7) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG _LESS_LESS_ASSIGN expr"); }
		}
	| REG_A00 ASSIGN BXORSHIFT LPAREN REG_A00 COMMA REG_A11 COMMA REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $5 == REG_A0
		             && $7 == REG_A1
		             && $9 == REG_CC) {
/* dsp32shift:	A0 = BXORSHIFT (A0 , A1 , CC )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32shift: A0 = BXORSHIFT ( A0 , A1 , CC )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c600
		                |((12&0x1f)<<0)                          /* sopcde<(12) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((0&0x3)<<14)                           /* sop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 ASSIGN BXORSHIFT LPAREN REG_A00 COMMA REG_A11 COMMA REG RPAREN"); }
		}
	| REG_A00 _MINUS_ASSIGN REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $3 == REG_A1) {
/* dsp32alu:	A0 -= A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 -= A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((11&0x1f)<<0)                          /* aopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((3&0x3)<<14)                           /* aop<(3) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));
		
		  } else { $$ = 0; semantic_error ("REG_A00 _MINUS_ASSIGN REG_A11"); }
		}
	| REG _MINUS_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_iregs)
		             && reginclass($3,rc_mregs)) {
/* dagMODim:	iregs -= mregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |.br| 1 | 1 |.op|.m.....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dagMODim: iregs -= mregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009e60
		                |((iregs($1)&0x3)<<0)                    /* i<(iregs) */
		                |((mregs($3)&0x3)<<2)                    /* m<(mregs) */
		                |((1&0x1)<<4)                            /* op<(1) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)) {
/* PTR2op:	pregs -= pregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PTR2op: pregs -= pregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004400
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<3)                    /* src<(pregs) */
		                |((0&0x7)<<6)                            /* opc<(0) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("REG _MINUS_ASSIGN REG"); }
		}
	| REG_A00 _MINUS_ASSIGN REG_A11 LPAREN W32 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $3 == REG_A1) {
/* dsp32alu:	A0 -= A1 (W32)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 -= A1 (W32)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((11&0x1f)<<0)                          /* aopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((3&0x3)<<14)                           /* aop<(3) */
		                  |((1&0x1)<<13)                           /* s<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 _MINUS_ASSIGN REG_A11 LPAREN W32 RPAREN"); }
		}
	| REG _MINUS_ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_iregs)
		             && EXPR_VALUE($3) == 4) {
/* dagMODik:	iregs -= 4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dagMODik: iregs -= 4\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009f60
		                |((iregs($1)&0x3)<<0)                    /* i<(iregs) */
		                |((3&0x3)<<2)                            /* op<(3) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_iregs)
		             && EXPR_VALUE($3) == 2) {
/* dagMODik:	iregs -= 2
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dagMODik: iregs -= 2\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009f60
		                |((iregs($1)&0x3)<<0)                    /* i<(iregs) */
		                |((1&0x3)<<2)                            /* op<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _MINUS_ASSIGN expr"); }
		}

	| REG _PLUS_ASSIGN REG LPAREN BREV RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_iregs)
		             && reginclass($3,rc_mregs)) {
/* dagMODim:	iregs += mregs (opt_brev)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |.br| 1 | 1 |.op|.m.....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dagMODim: iregs += mregs (opt_brev)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009e60
		                |((iregs($1)&0x3)<<0)                    /* i<(iregs) */
		                |((mregs($3)&0x3)<<2)                    /* m<(mregs) */
		                |((0&0x1)<<4)                            /* op<(0) */
		                |((1&0x1)<<7)                            /* br<(1) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($3,rc_pregs)) {
/* PTR2op:	pregs += pregs ( BREV )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PTR2op: pregs += pregs ( BREV )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004400
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((pregs($3)&0x7)<<3)                    /* src<(pregs) */
		                |((5&0x7)<<6)                            /* opc<(5) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _PLUS_ASSIGN REG LPAREN BREV RPAREN"); }
		}
	| REG_A00 _PLUS_ASSIGN REG_A11 LPAREN W32 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $3 == REG_A1) {
/* dsp32alu:	A0 += A1 (W32)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 += A1 (W32)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((11&0x1f)<<0)                          /* aopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((2&0x3)<<14)                           /* aop<(2) */
		                  |((1&0x1)<<13)                           /* s<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 _PLUS_ASSIGN REG_A11 LPAREN W32 RPAREN)"); }
		}
	| REG_A00 _PLUS_ASSIGN REG_A11
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A0
		             && $3 == REG_A1) {
/* dsp32alu:	A0 += A1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A0 += A1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((11&0x1f)<<0)                          /* aopcde<(11) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((2&0x3)<<14)                           /* aop<(2) */
		                  |((0&0x1)<<13)                           /* s<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A00 _PLUS_ASSIGN REG_A11"); }
		}
	| REG _PLUS_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_iregs)
		             && reginclass($3,rc_mregs)) {
/* dagMODim:	iregs += mregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |.br| 1 | 1 |.op|.m.....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dagMODim: iregs += mregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009e60
		                |((iregs($1)&0x3)<<0)                    /* i<(iregs) */
		                |((mregs($3)&0x3)<<2)                    /* m<(mregs) */
		                |((0&0x1)<<4)                            /* op<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _PLUS_ASSIGN REG"); }
		}
	| REG _PLUS_ASSIGN expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_iregs)
		             && EXPR_VALUE($3) == 4) {
/* dagMODik:	iregs += 4
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dagMODik: iregs += 4\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009f60
		                |((iregs($1)&0x3)<<0)                    /* i<(iregs) */
		                |((2&0x3)<<2)                            /* op<(2) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && const_fits($3,c_imm7)) {
/* COMPI2opP:	pregs += imm7
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 1 |.op|.src.......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMPI2opP: pregs += imm7\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x006800
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((imm7($3)&0x7f)<<3)                    /* src<(imm7) */
		                |((1&0x1)<<10)                           /* op<(1) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && const_fits($3,c_imm7)) {
/* COMPI2opD:	dregs += imm7
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 0 |.op|.isrc......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("COMPI2opD: dregs += imm7\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x006000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((imm7($3)&0x7f)<<3)                    /* isrc<(imm7) */
		                |((1&0x1)<<10)                           /* op<(1) */
		        ),
		        NULL_CODE);

		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_iregs)
		             && EXPR_VALUE($3) == 2) {
/* dagMODik:	iregs += 2
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dagMODik: iregs += 2\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x009f60
		                |((iregs($1)&0x3)<<0)                    /* i<(iregs) */
		                |((0&0x3)<<2)                            /* op<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _PLUS_ASSIGN expr"); }
		}
 	| REG _STAR_ASSIGN REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)) {
/* ALU2op:	dregs *= dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs *= dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($3)&0x7)<<3)                    /* src<(dregs) */
		                |((3&0xf)<<6)                            /* opc<(3) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG _STAR_ASSIGN REG"); }
		}
	| RTE
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	RTE
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: RTE\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((1&0xf)<<4)                            /* prgfunc<(1) */
		                |((4&0xf)<<0)                            /* poprnd<(4) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("RTE"); }
		}
	| RTI
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	RTI
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: RTI\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((1&0xf)<<4)                            /* prgfunc<(1) */
		                |((1&0xf)<<0)                            /* poprnd<(1) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("RTI"); }
		}
	| RTN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	RTN
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: RTN\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((1&0xf)<<4)                            /* prgfunc<(1) */
		                |((3&0xf)<<0)                            /* poprnd<(3) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("RTN"); }
		}
	| RTS
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	RTS
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: RTS\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((1&0xf)<<4)                            /* prgfunc<(1) */
		                |((0&0xf)<<0)                            /* poprnd<(0) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("RTS"); }
		}
	| RTX
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	RTX
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: RTX\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((1&0xf)<<4)                            /* prgfunc<(1) */
		                |((2&0xf)<<0)                            /* poprnd<(2) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("RTX"); }
		}
	| SAA LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_dregs)
		             && reginclass($7,rc_dregs)) {
/* dsp32alu:	SAA ( dregs_pair , dregs_pair ) (aligndir)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: SAA ( dregs_pair , dregs_pair ) (aligndir)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((18&0x1f)<<0)                          /* aopcde<(18) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((dregs($3)&0x7)<<3)               /* src0<(dregs_pair) */
		                  |((dregs($7)&0x7)<<0)               /* src1<(dregs_pair) */
		                  |((($11.r0)&0x1)<<13)                     /* s=aligndir.r0 */
		                  |((0&0x3)<<14)                           /* aop<(0) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("SAA LPAREN REG COLON expr COMMA REG COLON expr RPAREN aligndir"); }
		}
	| REG_A11 ASSIGN REG_A11 LPAREN S RPAREN COMMA REG_A00 ASSIGN REG_A00 LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && $1 == REG_A1
		             && $3 == REG_A1
		             && $8 == REG_A0
		             && $10 == REG_A0) {
/* dsp32alu:	A1 = A1 (S) , A0 = A0 (S)
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("dsp32alu: A1 = A1 (S) , A0 = A0 (S)\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00c400
		                |((8&0x1f)<<0)                           /* aopcde<(8) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		                  |((2&0x3)<<14)                           /* aop<(2) */
		                  |((1&0x1)<<13)                           /* s<(1) */
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("REG_A11 ASSIGN REG_A11 LPAREN S RPAREN COMMA REG_A00 ASSIGN REG_A00 LPAREN S RPAREN"); }
		}
	| REG ASSIGN LPAREN REG PLUS REG RPAREN LESS_LESS expr
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)
		             && EXPR_VALUE($9) == 1
			     && $1==$4) {
/* ALU2op:	dregs = (dregs + dregs) << 1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = (dregs + dregs) << 1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($6)&0x7)<<3)                    /* src<(dregs) */
		                |((4&0xf)<<6)                            /* opc<(4) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_dregs)
		             && reginclass($4,rc_dregs)
		             && reginclass($6,rc_dregs)
		             && EXPR_VALUE($9) == 2
			     && $1==$4) {
/* ALU2op:	dregs = (dregs + dregs) << 2
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ALU2op: dregs = (dregs + dregs) << 2\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004000
		                |((dregs($1)&0x7)<<0)                    /* dst<(dregs) */
		                |((dregs($6)&0x7)<<3)                    /* src<(dregs) */
		                |((5&0xf)<<6)                            /* opc<(5) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($4,rc_pregs)
		             && reginclass($6,rc_pregs)
		             && EXPR_VALUE($9) == 1
			     && $1==$4) {
/* PTR2op:	pregs = (pregs + pregs) << 1
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PTR2op: pregs = (pregs + pregs) << 1\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004400
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((pregs($6)&0x7)<<3)                    /* src<(pregs) */
		                |((6&0x7)<<6)                            /* opc<(6) */
		        ),
		        NULL_CODE);
		
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($1,rc_pregs)
		             && reginclass($4,rc_pregs)
		             && reginclass($6,rc_pregs)
		             && EXPR_VALUE($9) == 2
			     && $1==$4) {
/* PTR2op:	pregs = (pregs + pregs) << 2 
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("PTR2op: pregs = (pregs + pregs) << 2\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x004400
		                |((pregs($1)&0x7)<<0)                    /* dst<(pregs) */
		                |((pregs($6)&0x7)<<3)                    /* src<(pregs) */
		                |((7&0x7)<<6)                            /* opc<(7) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("REG ASSIGN LPAREN REG PLUS REG RPAREN LESS_LESS expr"); }
		}
	| SSYNC
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* ProgCtrl:	SSYNC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: SSYNC\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((2&0xf)<<4)                            /* prgfunc<(2) */
		                |((4&0xf)<<0)                            /* poprnd<(4) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("SSYNC"); }
		}
	| STI REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($2,rc_dregs)) {
/* ProgCtrl:	STI dregs
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: STI dregs\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((dregs($2)&0xf)<<0)                    /* poprnd<(dregs) */
		                |((4&0xf)<<4)                            /* prgfunc<(4) */
		        ),
		        NULL_CODE);

		  } else { $$ = 0; semantic_error ("STI REG"); }
		}
	| TESTSET LPAREN REG RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
		             && reginclass($3,rc_pregs)) {
/* ProgCtrl:	TESTSET ( pregs )
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("ProgCtrl: TESTSET ( pregs )\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x000000
		                |((pregs($3)&0xf)<<0)                    /* poprnd<(pregs) */
		                |((11&0xf)<<4)                           /* prgfunc<(11) */
		        ),
		        NULL_CODE);
		
		  } else { $$ = 0; semantic_error ("TESTSET LPAREN REG RPAREN"); }
		}
	| UNLINK
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
/* linkage:	UNLINK
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.R.|
|.framesize.....................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/
		    notethat("linkage: UNLINK\n");
		    $$ =
		      CONSCODE(
		        GENCODE(0x00e800
		                |((1&0x1)<<0)                            /* R<(1) */
		        ),
		        CONSCODE(
		          GENCODE(0x000000
		          ),
		          NULL_CODE));

		  } else { $$ = 0; semantic_error ("UNLINK"); }
		}

	;


/******************************************************************/
amod0:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.s0 = 0;
		      $$.x0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.s0 = 1;
		      $$.x0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("S"); }
		}
	| LPAREN SCO RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.s0 = 1;
		      $$.x0 = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("SCO"); }
		}
	| LPAREN CO RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.s0 = 0;
		      $$.x0 = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("CO"); }
		}
	| CO
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("Not Allowed"); 
		  } 
		}
	| S
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("Not Allowed"); 
		  } 
		}
	| SCO 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("Not Allowed"); 
		  } 
		}
	;
amod1:

		 {
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.s0 = 0;
		      $$.x0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		} 
	| LPAREN NS RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.s0 = 0;
		      $$.x0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("NS"); }
		}
	| LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.s0 = 1;
		      $$.x0 = 0;   
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("S"); }
		}
	| S 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("Not Allowed"); 
		  } 
		}
	| NS 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("Not Allowed"); 
		  } 
		}
	;
amod2:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| LPAREN ASR RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 2;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("ASR");}
		}
	| LPAREN ASL RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 3;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("ASL");}
		}

	;
xorzornothing:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| LPAREN Z RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(Z)");}
		}
	| LPAREN X RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(X)");}
		}

	;

sornothing:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| LPAREN S RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(S)");}
		}
	;

macmod_accm:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| IS
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("(IS)"); 
		  } 
		}
	| FU 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("(FU)"); 
		  } 
		}
	| W32
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("(W32)"); 
		  } 
		}
	| LPAREN IS RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 8;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(IS)"); }
		}
	| LPAREN FU RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 4;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(FU)"); }
		}
	| LPAREN W32 RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 3;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(W32)"); }
		}

	;



searchmod:	  GE
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("GE"); }
		}
	| GT
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("GT"); }
		}
	| LE
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 3;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("LE"); }
		}
	| LT
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 2;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("LT"); }
		}

	;



macmod_pmove:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| IS
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("IS"); }
		}
	| ISS2
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("ISS2"); }
		}
	| S2RND
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("S2RND"); }
		}
	| FU
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("FU"); }
		}
	| LPAREN IS RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 8;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(IS)"); }
		}
	| LPAREN ISS2 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 9;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(ISS2)"); }
		}
	| LPAREN S2RND RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(S2RND)"); }
		}
	| LPAREN FU RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 4;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(FU)"); }
		}

	;

mxd_mod:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| M
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("M"); }
		}
	| LPAREN M RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(M)"); }
		}

	;



aligndir:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| LPAREN R RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.r0 = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("R"); }
		}
	| R
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      memset (&$$, 0, sizeof ($$)); semantic_error ("Not Allowed"); 
		  } 
		}
	;


A1macfunc:	  REG_A11 ASSIGN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && $1==REG_A1){
		      $$.r0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("REG_A11 ASSIGN"); }
		}
	| REG_A11 _PLUS_ASSIGN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && $1==REG_A1){
		      $$.r0 = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("REG_A11 _PLUS_ASSIGN"); }
		}
	| REG_A11 _MINUS_ASSIGN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && $1==REG_A1){
		      $$.r0 = 2;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("REG_A11 _MINUS_ASSIGN"); }
		}
	;

A0macfunc:	  REG_A00 ASSIGN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && $1==REG_A0){
		      $$.r0 = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("REG_A00 ASSIGN"); }
		}
	| REG_A00 _PLUS_ASSIGN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && $1==REG_A0){
		      $$.r0 = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("REG_A00 _PLUS_ASSIGN"); }
		}
	| REG_A00 _MINUS_ASSIGN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && $1==REG_A0){
		      $$.r0 = 2;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("REG_A00 _MINUS_ASSIGN"); }
		}
	;

multfunc:	  HIGH_REG STAR HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)){
		      $$.h0 = 1;
		      $$.h1 = 1;
		      $$.op = 0<<11
                      |((dregs($1)&0x7)<<3)                    /*src0<(dregs)*/
		      |((dregs($3)&0x7)<<0);                    /*src1<(dregs)*/

		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("HIGH_REG STAR HIGH_REG"); }
		}
	| HIGH_REG STAR LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)){
		      $$.h0 = 1;
		      $$.h1 = 0;
		      $$.op = 0<<11
                      |((dregs($1)&0x7)<<3)                    /*src0<(dregs)*/
		      |((dregs($3)&0x7)<<0);                    /*src1<(dregs)*/

		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("HIGH_REG STAR LOW_REG"); }
		}
	| LOW_REG STAR HIGH_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)){
		      $$.h0 = 0;
		      $$.h1 = 1;
		      $$.op = 0<<11
                      |((dregs($1)&0x7)<<3)                    /*src0<(dregs)*/
		      |((dregs($3)&0x7)<<0);                    /*src1<(dregs)*/

		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("LOW_REG STAR HIGH_REG"); }
		}
	 | LOW_REG STAR LOW_REG
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE))
                             && reginclass($1,rc_dregs)
		             && reginclass($3,rc_dregs)){
		      $$.h0 = 0;
		      $$.h1 = 0;
		      $$.op = 0<<11
                      |((dregs($1)&0x7)<<3)                    /*src0<(dregs)*/
		      |((dregs($3)&0x7)<<0);                    /*src1<(dregs)*/

		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("LOW_REG STAR LOW_REG"); }
		}

	;

macmod_hmove:
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 0;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error (""); }
		}
	| IS
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("IS"); }
		}
	| IH
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("IH"); }
		}
	| ISS2
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("ISS2"); }
		}
	| IU
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("IU"); }
		}
	| S2RND
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("S2RND"); }
		}
	| T
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("T"); }
		}
	| TFU 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("TFU"); }
		}
	| FU
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		   memset (&$$, 0, sizeof ($$)); semantic_error ("FU"); }
		}
	| LPAREN IS RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 8;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(IS)"); }
		}
	| LPAREN IH RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 11;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(IH)"); }
		}
	| LPAREN ISS2 RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 9;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(ISS2)"); }
		}
	| LPAREN IU RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 12;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(IU)"); }
		}
	| LPAREN S2RND RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 1;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(S2RND)"); }
		}
	| LPAREN T RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 2;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(T)"); }
		}
	| LPAREN TFU RPAREN 
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 6;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(TFU)"); }
		}
	| LPAREN FU RPAREN
		{
		  if(0) {
		  } else if ( 1 && memset(&$$, 0, sizeof(YYSTYPE)) ) {
		      $$.mod = 4;
		  } else { memset (&$$, 0, sizeof ($$)); semantic_error ("(FU)"); }
		}
	;


symbol		: SYMBOL 			{ ExprNodeValue val; val.s_value = S_GET_NAME($1); $$ = ExprNodeCreate(ExprNodeReloc, val, NULL, NULL); }
		;

eterm           : NUMBER 			{ ExprNodeValue val; val.i_value = $1; $$ = ExprNodeCreate(ExprNodeConstant, val, NULL, NULL); }
		| symbol			{ $$ = $1; }
    		| LPAREN expr_1 RPAREN  	{ $$ = $2; }
                | TILDA expr_1			{ $$ = unary(ExprOpTypeCOMP,$2); }
		| MINUS expr_1 %prec TILDA	{ $$ = unary(ExprOpTypeNEG,$2); }
		;

offset_expr	: PLUS eterm    { $$ = $2; }
		| MINUS eterm   { $$ = unary(ExprOpTypeNEG,$2); }
		|		{ $$ = NULL; }
		;

expr		: expr_1				{ $$ = $1; }
		;

expr_1		: expr_1 STAR expr_1		{ $$ = binary(ExprOpTypeMult,$1,$3);   }
		| expr_1 SLASH expr_1		{ $$ = binary(ExprOpTypeDiv,$1,$3); }
		| expr_1 PERCENT expr_1		{ $$ = binary(ExprOpTypeMod,$1,$3);    }
		| expr_1 PLUS expr_1		{ $$ = binary(ExprOpTypeAdd,$1,$3);    }
		| expr_1 MINUS expr_1		{ $$ = binary(ExprOpTypeSub,$1,$3);    }
		| expr_1 LESS_LESS expr_1	{ $$ = binary(ExprOpTypeLsft,$1,$3);    }
		| expr_1 GREATER_GREATER expr_1	{ $$ = binary(ExprOpTypeRsft,$1,$3);    }
		| expr_1 AMPERSAND expr_1	{ $$ = binary(ExprOpTypeBAND,$1,$3); }
		| expr_1 CARET expr_1		{ $$ = binary(ExprOpTypeLOR,$1,$3); }
		| expr_1 BAR expr_1		{ $$ = binary(ExprOpTypeBOR,$1,$3); }
		| eterm				{ $$ = $1;		     }
		;


%%

EXPR_T mkexpr(int x, SYMBOL_T s) {
    EXPR_T e = (EXPR_T) ALLOCATE(sizeof (struct expression_cell));
    e->value = x;
    EXPR_SYMBOL(e) = s;
    return e;
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

static int const_fits(ExprNode * expr, const_forms_t form) {
#if 1
    int sz       = constant_formats[form].nbits;
    int scale    = constant_formats[form].scale;
    int offset   = constant_formats[form].offset;
    int issigned = constant_formats[form].issigned;

    /* check if reloc is allowed */
    if((expr->type != ExprNodeConstant) && 
        !constant_formats[form].reloc)
	return 0;

    if(expr->type != ExprNodeConstant)
      return 1; // it will be relocated, not a constant

    if (sz < 32) {
      long mask   = (1l<<sz)-1;
      long minint = (-1l<<(sz-1));
      long maxint = (1l<<(sz-1));
      long v = expr->value.i_value;

      if (scale) {
	long temp = v >> scale;
	// This is to ensure that constants that are not
	// rounded up to the correct bit position
	// are not excepted by const_fits.
	if (v != (temp << scale))
	  return 0;
	v = temp;
      }


      

      if (0 && constant_formats[form].negative) {
	  if (v >= 0)
	      return 0;
	  v = -v;
	  issigned = 0;
      }

      if (constant_formats[form].negative) {
        // return true if all the out-of-range sign bits are 1's
        return ((v & ~mask) == ~mask);
      }

      if (constant_formats[form].positive) {
	  if (v < 0)
	      return 0;
      }

      v -= offset;
      return (!issigned && (v & ~mask) == 0)
	  || ((minint <= v) && (v < maxint));
    }
    return 1;

#else	/* #if 0  */
    int sz       = constant_formats[form].nbits;
    int scale    = constant_formats[form].scale;
    int offset   = constant_formats[form].offset;
    int issigned = constant_formats[form].issigned;

    if (EXPR_SYMBOL(expr) 
	&& !constant_formats[form].reloc)
	return 0;

    if (sz < 32) {
      long mask   = (1l<<sz)-1;
      long minint = (-1l<<(sz-1));
      long maxint = (1l<<(sz-1));

      long v = EXPR_VALUE (expr);

      if (scale) {
	long temp = v >> scale;
	// This is to ensure that constants that are not
	// rounded up to the correct bit position
	// are not excepted by const_fits.
	if (v != (temp << scale))
	  return 0;
	v = temp;
      }


      

      if (constant_formats[form].negative) {
        // return true if all the out-of-range sign bits are 1's
        return ((v & ~mask) == ~mask);
      }

      // some numbers are treated a negative but have positive format
      if (constant_formats[form].negative && !constant_formats[form].positive){
	  if (v >= 0)
	      return 0;
	  v = -v;
	  issigned = 0;
      }

      if (constant_formats[form].positive && !constant_formats[form].negative) {
	  if (v < 0)
	      return 0;
      }

      v -= offset;

      return (!issigned && (v & ~mask) == 0)
	  || ((minint <= v) && (v < maxint));
    }
    return 1;
#endif
}

int debug_codeselection;
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

/* Note:
 * . keep in mind, "DOT" arg in patterm "eterm" has been temporarily eliminated.
*/
