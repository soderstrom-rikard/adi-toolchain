/* Blackfin opcode generation
 *
 * 03/2004 (c) Martin Strubel <hackfin@section5.ch>
 *
 */

#include "bfin-defs.h"

#define REG_T Register *

INSTR_T
gen_dsp32mac (int op1, int mm, int mmod, int w1, int p,
              int h01, int h11, int h00, int h10,
	      int op0, REG_T dst, REG_T src0, REG_T src1, int w0);

INSTR_T
gen_dsp32mult (int op1, int mm, int mmod, int w1, int p,
               int h01, int h11, int h00, int h10,
	       int op0, REG_T dst, REG_T src0, REG_T src1, int w0);

INSTR_T
gen_dsp32alu (int HL, int aopcde, int aop, int s, int x,
              REG_T dst0, REG_T dst1, REG_T src0, REG_T src1);

INSTR_T
gen_dsp32shift (int sopcde, REG_T dst0, REG_T src0, REG_T src1,
                int sop, int hls);

INSTR_T
gen_dsp32shiftimm (int sopcde, REG_T dst0, int immag, REG_T src1,
                   int sop, int hls);

INSTR_T
gen_ldimmhalf (REG_T reg, int h, int s, int z, ExprNode *hword,
               int reloc);

INSTR_T
gen_ldstidxi (REG_T ptr, REG_T reg, int w, int sz, int z,
              ExprNode *offset);

INSTR_T
gen_ldst (REG_T ptr, REG_T reg, int aop, int sz, int z, int w);

INSTR_T
gen_ldstii (REG_T ptr, REG_T reg, ExprNode *offset, int w, int op);

INSTR_T
gen_ldstiifp (REG_T reg, ExprNode *offset, int w);

INSTR_T
gen_ldstpmod (REG_T ptr, REG_T reg, int aop, int w, REG_T idx);

INSTR_T
gen_dspldst (REG_T i, REG_T reg, int aop, int w, int m);

INSTR_T
gen_alu2op (REG_T dst, REG_T src, int opc);

INSTR_T
gen_compi2opd (REG_T dst, int src, int op);

INSTR_T
gen_compi2opp (REG_T dst, int src, int op);

INSTR_T
gen_dagmodik (REG_T i, int op);

INSTR_T
gen_dagmodim (REG_T i, REG_T m, int op, int br);

INSTR_T
gen_ptr2op (REG_T dst, REG_T src, int opc);

INSTR_T
gen_logi2op (int dst, int src, int opc);

INSTR_T
gen_comp3op (REG_T src0, REG_T src1, REG_T dst, int opc);

INSTR_T
gen_ccmv (REG_T src, REG_T dst, int t);

INSTR_T
gen_ccflag (REG_T x, int y, int opc, int i, int g);

INSTR_T
gen_cc2stat (int cbit, int op, int d);

INSTR_T
gen_regmv (REG_T src, REG_T dst);

INSTR_T
gen_cc2dreg (int op, REG_T reg);

INSTR_T
gen_brcc (int t, int b, ExprNode *offset);

INSTR_T
gen_ujump (ExprNode *offset);

INSTR_T
gen_cactrl (REG_T reg, int a, int op);

INSTR_T
gen_progctrl (int prgfunc, int poprnd);

INSTR_T
gen_loopsetup (ExprNode *soffset, REG_T c, int rop,
               ExprNode *eoffset, REG_T reg);

INSTR_T
gen_loop (ExprNode *expr, REG_T reg, int rop, REG_T preg);

INSTR_T
gen_pushpopmultiple (int dr, int pr, int d, int p, int w);

// Register group check required!
INSTR_T
gen_pushpopreg (REG_T reg, int w);

INSTR_T
gen_calla (ExprNode *addr, int s);

INSTR_T
gen_linkage (int r, int framesize);

INSTR_T
gen_pseudodbg (int fn, int reg, int grp);

INSTR_T
gen_pseudodbg_assert (int dbgop, REG_T regtest, int expected);

INSTR_T
gen_multi_instr (INSTR_T dsp32, INSTR_T dsp16_grp1, INSTR_T dsp16_grp2);
