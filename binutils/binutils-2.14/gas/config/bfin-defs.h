/* bfin-defs.h -- header file for nisa assembler
 * Copyright (c) 2000-2001 Analog Devices Inc.,
 * Copyright (c) 2000-2001 by Lineo, Inc./Lineo Canada Corp. (www.lineo.com),
 * Copyright (c) 2001-2002 by Arcturus Networks Inc.(www.arcturusnetworks.com)
 * Ported for Blackfin Architecture by 
 *	      Akbar Hussain <akbar.hussain@arcturusnetworks.com>,
 *            Tony Kou <tony.ko@arcturusnetworks.com>
 *            Faisal Akber <fakber@arcturusnetworks.com>
 * Copyright (c) 2003 Metrowerks
 */
 
#ifndef BFIN_PARSE_H
#define BFIN_PARSE_H  

#include <bfd.h>
#include "as.h"

#define PCREL	1
#define CODE_FRAG_SIZE 4096  /* 1 page */  

typedef enum {
   c_0,     c_1,     c_4,     c_2,     c_uimm2, c_uimm3, c_imm3,  c_pcrel4, c_pcrel5,
  c_imm4,  c_uimm4s4, c_uimm4, c_uimm4s2, c_negimm5s4, c_imm5,  c_uimm5, c_imm6,
  c_imm7,  c_imm8,  c_uimm8, c_pcrel8, c_uimm8s4, c_pcrel8s4, c_lppcrel10, c_pcrel10, c_pcrel11,
  c_pcrel12, c_pcrel12_jump, c_pcrel12_jump_s, c_imm16s4, c_luimm16, c_imm16, c_huimm16,
  c_rimm16, c_imm16s2, c_uimm16s4,  c_uimm16, c_pcrel24, c_pcrel24_call_x, c_pcrel24_jump,
  c_pcrel24_jump_x, c_pcrel24_jump_l
  } const_forms_t;

enum machine_registers {
  REG_RL0,   REG_RL1,   REG_RL2,   REG_RL3,   REG_RL4,   REG_RL5,   REG_RL6,   REG_RL7,   
  REG_RH0,   REG_RH1,   REG_RH2,   REG_RH3,   REG_RH4,   REG_RH5,   REG_RH6,   REG_RH7,   
  REG_R0,    REG_R1,    REG_R2,    REG_R3,    REG_R4,    REG_R5,    REG_R6,    REG_R7,    
  REG_R1_0,  REG_R3_2,  REG_R5_4,  REG_R7_6,  REG_P0,    REG_P1,    REG_P2,    REG_P3,    
  REG_P4,    REG_P5,    REG_SP,    REG_FP,    REG_A0x,   REG_A1x,   REG_A0w,   REG_A1w,   
  REG_A0,    REG_A1,    REG_I0,    REG_I1,    REG_I2,    REG_I3,    REG_M0,    REG_M1,    
  REG_M2,    REG_M3,    REG_B0,    REG_B1,    REG_B2,    REG_B3,    REG_L0,    REG_L1,    
  REG_L2,    REG_L3,    nREG_AZ,    nREG_AN,    nREG_AC,    nREG_AV0,   nREG_AV1,   nREG_AQ,    
  REG_sftreset, REG_omode, REG_excause, REG_emucause, REG_idle_req, REG_hwerrcause,
  REG_CC,    REG_LC0,   REG_LC1,   REG_GP,    REG_ASTAT, REG_RETS,  REG_LT0,   REG_LB0,
  REG_LT1,   REG_LB1,   REG_CYCLES, REG_CYCLES2, REG_USP,   REG_SEQSTAT, REG_SYSCFG,
  REG_RETI,  REG_RETX,  REG_RETN,  REG_RETE,  REG_LASTREG, 
  };

enum reg_class {
  rc_dregs_lo, rc_dregs_hi, rc_dregs,  rc_dregs_pair, rc_pregs,  rc_spfp,
  rc_dregs_hilo, rc_accum_ext, rc_accum_word, rc_accum,  rc_iregs,  rc_mregs,
  rc_bregs,  rc_lregs,  rc_dpregs, rc_gregs,  rc_regs,   rc_statbits, rc_ignore_bits,
  rc_ccstat, rc_counters, rc_dregs2_sysregs1, rc_open,   rc_sysregs2, rc_sysregs3,
  rc_allregs, LIM_REG_CLASSES
};
/*************** Definition for all Status bits *******/
#define REG_AZ	0
#define REG_AN	1
#define REG_AC 	2
#define REG_AV0	3
#define REG_AV1	4
#define REG_AQ	6

typedef enum { 
  ones_compl, twos_compl, mult, divide, mod, add, sub, lsh, rsh, logand, logior, logxor
             } expr_opcodes_t ;

struct expressionS;

#define SYMBOL_T       symbolS*
 
struct expression_cell {
    long value;
    SYMBOL_T symbol;
};

/* User Type Definitions */
struct bfin_insn
{
  unsigned long value;
  struct bfin_insn *next;
  struct expression_cell *exp;
  int pcrel;
  int reloc;
};
    
#define INSTR_T        struct bfin_insn*
#define EXPR_T         struct expression_cell* 
 
typedef struct expr_node_struct ExprNode;

extern INSTR_T gencode (unsigned long x);
extern INSTR_T conscode(INSTR_T head, INSTR_T tail);   
extern INSTR_T conctcode(INSTR_T head, INSTR_T tail);
extern INSTR_T notereloc(INSTR_T code, ExprNode *, int reloc, int pcrel);
extern INSTR_T notereloc1(INSTR_T code, const char * sym, int reloc, int pcrel);
 
#define CONSCODE(head,tail)       conscode(head,tail)
#define CONCTCODE(head, tail)	  conctcode(head, tail)
#define GENCODE(x)                gencode(x)
#define NOTERELOC(pcrel, rel, expr, code)  notereloc(code,expr,rel,pcrel)
#define NOTERELOC1(pcrel, rel, expr, code)  notereloc1(code,expr,rel,pcrel)
 
 
/****************typedef and methods related to new expresion parser ***/
/* types of expressions */
typedef enum 
{
	ExprNodeBinop, // binary operator
	ExprNodeUnop,  // unary  opertor
	ExprNodeReloc, // a symbol, to be relocated
	ExprNodeConstant // a constant value
} ExprNodeType;

/* types of operators */
typedef enum 
{
	ExprOpTypeAdd, 		/*Addition*/
	ExprOpTypeSub,		/*subtraction*/
	ExprOpTypeMult,		/*Multiplication*/
	ExprOpTypeDiv,		/*Division*/
	ExprOpTypeMod,		/*Modulus*/
	ExprOpTypeLsft,		/*Left shift*/
	ExprOpTypeRsft,		/*Right shift*/
	ExprOpTypeBAND,		/*Bitwise AND*/
	ExprOpTypeBOR,		/*Bitwise OR*/
	ExprOpTypeBXOR,		/*Bitwise exclusive OR*/
	ExprOpTypeLAND,		/*Logical AND*/
	ExprOpTypeLOR,		/*Logical OR*/
	ExprOpTypeNEG,	/*Negate expression*/
	ExprOpTypeCOMP	/*Complement expression*/
} ExprOpType;

/* The value that can be stored ... depends on type */
typedef union
{
	char *s_value;       /* if relocation symbol, the text */
	int  i_value;        /* if constant, the value */
	ExprOpType op_value; /* if operator, the value */
} ExprNodeValue;

/* the actual expression node */
struct expr_node_struct
{
	ExprNodeType type;
	ExprNodeValue value;
	ExprNode *LeftChild;
	ExprNode *RightChild;
};


/* operations on the expression node */
ExprNode *ExprNodeCreate(ExprNodeType type, 
		         ExprNodeValue value, 
			 ExprNode *LeftChild, 
			 ExprNode *RightChild);

/* generate the reloc structure as a series of instructions */
INSTR_T ExprNodeGenReloc(ExprNode *head, 
		          int parent_reloc /* the real reloction type - depends on
					      the assembly instruction
					   */
			 );


/****************************************************************************/

 
#define MKREF(x)	mkexpr(0,x)
#define ALLOCATE(x)	malloc(x)
 
#ifndef INIT_ASM
#define INIT_ASM() { }
#endif

#define NULL_CODE ((INSTR_T)0)


#ifndef EXPR_VALUE
#define EXPR_VALUE(x)  (((x)->type == ExprNodeConstant)?((x)->value.i_value):0)
#endif
#ifndef EXPR_SYMBOL
#define EXPR_SYMBOL(x) ((x)->symbol)
#endif


typedef long reg_t;


#ifdef __cplusplus
extern "C" {
#endif

extern int debug_codeselection;

void error (char *format, ...);
void warn (char *format, ...);
void semantic_error(char *syntax);
void semantic_error_2(char *syntax);

EXPR_T mkexpr(int, SYMBOL_T);

#ifdef __cplusplus
}
#endif

#endif  /* BFIN_PARSE_H */

