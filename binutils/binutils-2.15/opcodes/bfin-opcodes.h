#if !defined(BFIN_OPCODES_H_HD9837U0U9I27E902702DYHCXH2D79218D701D)
#define BFIN_OPCODES_H_HD9837U0U9I27E902702DYHCXH2D79218D701D

/*
 *
 * This file contains the bitfield defines
 * for the Blackfin opcodes
 *
 * (c) 03/2004 Martin Strubel <hackfin@section5.ch>
 *
 */

 
// Common to all DSP32 instructions:
#define BIT_MULTI_INS 0x0800  // multi instruction bit

// This just sets the multi instruction bit of a DSP32 instruction
#define SET_MULTI_INSTRUCTION_BIT(x) x->value |= BIT_MULTI_INS;


////////////////////////////////////////////////////////////////////////////
//
// DSP instructions (32 bit)
// {

/*  dsp32mac
+----+----+---+---|---+----+----+---|---+---+---+---|---+---+---+---+
| 1  | 1  | 0 | 0 |.M.| 0  | 0  |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+----+----+---+---|---+----+----+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_src1;
	int mask_src1;
	int bits_src0;      
	int mask_src0;
	int bits_dst;      
	int mask_dst;
	int bits_h10;      
	int mask_h10;
	int bits_h00;      
	int mask_h00;
	int bits_op0;      
	int mask_op0;
	int bits_w0;      
	int mask_w0;
	int bits_h11;      
	int mask_h11;
	int bits_h01;      
	int mask_h01;

	int bits_op1;      
	int mask_op1;
	int bits_w1;      
	int mask_w1;
	int bits_P;      
	int mask_P;
	int bits_MM;      
	int mask_MM;
	int bits_mmod;      
	int mask_mmod;
	int bits_code2;      
	int mask_code2;
	int bits_M;      
	int mask_M;
	int bits_code;      
	int mask_code;
} DSP32Mac;

DSP32Mac init_DSP32Mac ={
	0xc0000000,
	/*src1*/0,0x7,
	/*src0*/3,0x7,
	/*dst*/6,0x7,
	/*h10*/9,0x01,
	/*h00*/10,0x01,
	/*op0*/11,0x3,
	/*w0*/13,0x01,
	/*h11*/14,0x01,
	/*h01*/15,0x01,
	/*op1*/16,0x3,
	/*w1*/18,0x01,
	/*P*/19,0x01,
	/*MM*/20,0x01,
	/*mmod*/21,0xf,
	/*code2*/25,0x3,
	/*M*/27,0x01,
	/*code*/28,0xf
};

/* dsp32mult
+----+----+---+---|---+----+----+---|---+---+---+---|---+---+---+---+
| 1  | 1  | 0 | 0 |.M.| 0  | 1  |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+----+----+---+---|---+----+----+---|---+---+---+---|---+---+---+---+
*/

typedef DSP32Mac DSP32Mult;

DSP32Mult init_DSP32Mult ={
	0xc2000000,
	/*src1*/0,0x7,
	/*src0*/3,0x7,
	/*dst*/6,0x7,
	/*h10*/9,0x01,
	/*h00*/10,0x01,
	/*op0*/11,0x3,
	/*w0*/13,0x01,
	/*h11*/14,0x01,
	/*h01*/15,0x01,
	/*op1*/16,0x3,
	/*w1*/18,0x01,
	/*P*/19,0x01,
	/*MM*/20,0x01,
	/*mmod*/21,0xf,
	/*code2*/25,0x3,
	/*M*/27,0x01,
	/*code*/28,0xf
};

/* dsp32alu
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_src1;
	int mask_src1;
	int bits_src0;
	int mask_src0;
	int bits_dst1;
	int mask_dst1;
	int bits_dst0;
	int mask_dst0;
	int bits_x;
	int mask_x;
	int bits_s;
	int mask_s;
	int bits_aop;
	int mask_aop;
	int bits_aopcde;
	int mask_aopcde;
	int bits_HL;
	int mask_HL;
	int bits_dontcare;
	int mask_dontcare;
	int bits_code2;
	int mask_code2;
	int bits_M;
	int mask_M;
	int bits_code;
	int mask_code;
} DSP32Alu;

DSP32Alu init_DSP32Alu ={
	0xc4000000,
	/*src1*/0,0x7,
	/*src0*/3,0x7,
	/*dst1*/6,0x7,
	/*dst0*/9,0x7,
	/*x*/12,0x01,
	/*s*/13,0x01,
	/*aop*/14,0x3,
	/*aopcde*/16,0x1f,
	/*HL*/21,0x01,
	/*dontcare*/22,0x7,
	/*code2*/25,0x3,
	/*M*/27,0x01,
	/*code*/28,0xf
};

/* dsp32shift
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_src1;
	int mask_src1;
	int bits_src0;
	int mask_src0;
	int bits_dst1;
	int mask_dst1;
	int bits_dst0;
	int mask_dst0;
	int bits_HLs;
	int mask_HLs;
	int bits_sop;
	int mask_sop;
	int bits_sopcde;
	int mask_sopcde;
	int bits_dontcare;
	int mask_dontcare;
	int bits_code2;
	int mask_code2;
	int bits_M;
	int mask_M;
	int bits_code;
	int mask_code;
} DSP32Shift;

DSP32Shift init_DSP32Shift ={
	0xc6000000,
	/*src1*/0,0x7,
	/*src0*/3,0x7,
	/*dst1*/6,0x7,
	/*dst0*/9,0x7,
	/*HLs*/12,0x3,
	/*sop*/14,0x3,
	/*sopcde*/16,0x1f,
	/*dontcare*/21,0x3,
	/*code2*/23,0xf,
	/*M*/27,0x01,
	/*code*/28,0xf
};

/* dsp32shiftimm
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_src1;
	int mask_src1;
	int bits_immag;
	int mask_immag;
	int bits_dst0;
	int mask_dst0;
	int bits_HLs;
	int mask_HLs;
	int bits_sop;
	int mask_sop;
	int bits_sopcde;
	int mask_sopcde;
	int bits_dontcare;
	int mask_dontcare;
	int bits_code2;
	int mask_code2;
	int bits_M;
	int mask_M;
	int bits_code;
	int mask_code;
} DSP32ShiftImm;

DSP32ShiftImm init_DSP32ShiftImm ={
	0xc6800000,
	/*src1*/0,0x7,
	/*immag*/3,0x3f,
	/*dst0*/9,0x7,
	/*HLs*/12,0x3,
	/*sop*/14,0x3,
	/*sopcde*/16,0x1f,
	/*dontcare*/21,0x3,
	/*code2*/23,0xf,
	/*M*/27,0x01,
	/*code*/28,0xf
};

// }
////////////////////////////////////////////////////////////////////////////
// LOAD / STORE

/* LDSTidxI
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_offset;
	int mask_offset;
	int bits_reg;
	int mask_reg;
	int bits_ptr;
	int mask_ptr;
	int bits_sz;
	int mask_sz;
	int bits_Z;
	int mask_Z;
	int bits_W;
	int mask_W;
	int bits_code;
	int mask_code;
} LDSTidxI;

LDSTidxI init_LDSTidxI ={
	0xe4000000,
	/*offset*/0,0xffff,
	/*reg*/16,0x7,
	/*ptr*/19,0x7,
	/*sz*/22,0x3,
	/*Z*/24,0x01,
	/*W*/25,0x01,
	/*code*/26,0x3f
};


/* LDST
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_reg;
	int mask_reg;
	int bits_ptr;
	int mask_ptr;
	int bits_Z;
	int mask_Z;
	int bits_aop;
	int mask_aop;
	int bits_W;
	int mask_W;
	int bits_sz;
	int mask_sz;
	int bits_code;
	int mask_code;
} LDST;

LDST init_LDST ={
	0x9000,
	/*reg*/0,0x7,
	/*ptr*/3,0x7,
	/*Z*/6,0x01,
	/*aop*/7,0x3,
	/*W*/9,0x01,
	/*sz*/10,0x3,
	/*code*/12,0xf
};


/* LDSTii
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_reg;
	int mask_reg;
	int bits_ptr;
	int mask_ptr;
	int bits_offset;
	int mask_offset;
	int bits_op;
	int mask_op;
	int bits_W;
	int mask_W;
	int bits_code;
	int mask_code;
} LDSTii;

LDSTii init_LDSTii ={
	0xa000,
	/*reg*/0,0x7,
	/*ptr*/3,0x7,
	/*offset*/6,0xf,
	/*op*/10,0x3,
	/*W*/12,0x01,
	/*code*/13,0x7
};


/* LDSTiiFP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 | 1 | 1 | 0 |.W.|.offset............|.reg...........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_reg;
	int mask_reg;
	int bits_offset;
	int mask_offset;
	int bits_W;
	int mask_W;
	int bits_code;
	int mask_code;
} LDSTiiFP;

LDSTiiFP init_LDSTiiFP ={
	0xb800,
	/*reg*/0,0xf,
	/*offset*/4,0x1f,
	/*W*/9,0x01,
	/*code*/10,0x3f
};

/* dspLDST
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_reg;
	int mask_reg;
	int bits_i;
	int mask_i;
	int bits_m;
	int mask_m;
	int bits_aop;
	int mask_aop;
	int bits_W;
	int mask_W;
	int bits_code;
	int mask_code;
} DspLDST;

DspLDST init_DspLDST ={
	0x9c00,
	/*reg*/0,0x7,
	/*i*/3,0x3,
	/*m*/5,0x3,
	/*aop*/7,0x3,
	/*W*/9,0x01,
	/*code*/10,0x3f
};


/* LDSTpmod
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_ptr;
	int mask_ptr;
	int bits_idx;
	int mask_idx;
	int bits_reg;
	int mask_reg;
	int bits_aop;
	int mask_aop;
	int bits_W;
	int mask_W;
	int bits_code;
	int mask_code;
} LDSTpmod;

LDSTpmod init_LDSTpmod ={
	0x8000,
	/*ptr*/0,0x7,
	/*idx*/3,0x7,
	/*reg*/6,0x7,
	/*aop*/9,0x3,
	/*W*/11,0x01,
	/*code*/12,0xf
};

////////////////////////////////////////////////////////////////////////////

/* LOGI2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_dst;
	int mask_dst;
	int bits_src;
	int mask_src;
	int bits_opc;
	int mask_opc;
	int bits_code;
	int mask_code;
} LOGI2op;

LOGI2op init_LOGI2op ={
	0x4800,
	/*dst*/0,0x7,
	/*src*/3,0x1f,
	/*opc*/8,0x7,
	/*code*/11,0x1f
};


/* ALU2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_dst;
	int mask_dst;
	int bits_src;
	int mask_src;
	int bits_opc;
	int mask_opc;
	int bits_code;
	int mask_code;
} ALU2op;

ALU2op init_ALU2op ={
	0x4000,
	/*dst*/0,0x7,
	/*src*/3,0x7,
	/*opc*/6,0xf,
	/*code*/10,0x3f
};


/* BRCC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_offset;
	int mask_offset;
	int bits_B;
	int mask_B;
	int bits_T;
	int mask_T;
	int bits_code;
	int mask_code;
} BRCC;

BRCC init_BRCC ={
	0x1000,
	/*offset*/0,0x3ff,
	/*B*/10,0x01,
	/*T*/11,0x01,
	/*code*/12,0xf
};


/* UJUMP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 0 |.offset........................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_offset;
	int mask_offset;
	int bits_code;
	int mask_code;
} UJump;

UJump init_UJump ={
	0x2000,
	/*offset*/0,0xfff,
	/*code*/12,0xf
};


/* ProgCtrl
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_poprnd;
	int mask_poprnd;
	int bits_prgfunc;
	int mask_prgfunc;
	int bits_code;
	int mask_code;
} ProgCtrl;

ProgCtrl init_ProgCtrl ={
	0x0000,
	/*poprnd*/0,0xf,
	/*prgfunc*/4,0xf,
	/*code*/8,0xff
};

/* CALLa
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 1 |.S.|.msw...........................|
|.lsw...........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/


typedef struct{
	unsigned long opcode;
	int bits_addr;
	int mask_addr;
	int bits_S;
	int mask_S;
	int bits_code;
	int mask_code;
} CALLa;

CALLa init_CALLa ={
	0xe2000000,
	/*addr*/0,0xffffff,
	/*S*/24,0x01,
	/*code*/25,0x7f
};


/* pseudoDEBUG
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_reg;
	int mask_reg;
	int bits_grp;
	int mask_grp;
	int bits_fn;
	int mask_fn;
	int bits_code;
	int mask_code;
} PseudoDbg;

PseudoDbg init_PseudoDbg ={
	0xf800,
	/*reg*/0,0x7,
	/*grp*/3,0x7,
	/*fn*/ 6, 0x3,
	/*code*/8,0xff
};


/* psedodbg_assert
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 0 | - | - | - | - | - |.dbgop.....|.regtest...|
|.expected......................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_expected;
	int mask_expected;
	int bits_regtest;
	int mask_regtest;
	int bits_dbgop;
	int mask_dbgop;
	int bits_dontcare;
	int mask_dontcare;
	int bits_code;
	int mask_code;
} PseudoDbg_Assert;

PseudoDbg_Assert init_PseudoDbg_Assert ={
	0xf0000000,
	/*expected*/0,0xffff,
	/*regtest*/16,0x7,
	/*dbgop*/19,0x7,
	/*dontcare*/22,0x1f,
	/*code*/27,0x1f
};


/* CaCTRL
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_reg;
	int mask_reg;
	int bits_op;
	int mask_op;
	int bits_a;
	int mask_a;
	int bits_code;
	int mask_code;
} CaCTRL;

CaCTRL init_CaCTRL ={
	0x0240,
	/*reg*/0,0x7,
	/*op*/3,0x3,
	/*a*/5,0x01,
	/*code*/6,0x3ff,
};

/* PushPopMultiple
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_pr;
	int mask_pr;
	int bits_dr;
	int mask_dr;
	int bits_W;
	int mask_W;
	int bits_p;
	int mask_p;
	int bits_d;
	int mask_d;
	int bits_code;
	int mask_code;
} PushPopMultiple;

PushPopMultiple init_PushPopMultiple ={
	0x0400,
	/*pr*/0,0x7,
	/*dr*/3,0x7,
	/*W*/6,0x01,
	/*p*/7,0x01,
	/*d*/8,0x01,
	/*code*/9,0x7f
};

/* PushPopReg
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.W.|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_reg;
	int mask_reg;
	int bits_grp;
	int mask_grp;
	int bits_W;
	int mask_W;
	int bits_code;
	int mask_code;
} PushPopReg;

PushPopReg init_PushPopReg ={
	0x0100,
	/*reg*/0,0x7,
	/*grp*/3,0x7,
	/*W*/6,0x01,
	/*code*/7,0x1ff
};

/* linkage
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.R.|
|.framesize.....................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_framesize;      
	int mask_framesize;
	int bits_R;      
	int mask_R;
	int bits_code;
	int mask_code;
} Linkage;

Linkage init_Linkage ={
	0xe8000000,
	/*framesize*/0,0xffff,
	/*R*/16,0x01,
	/*code*/17,0x7fff
};

/* LoopSetup
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |.rop...|.c.|.soffset.......|
|.reg...........| - | - |.eoffset...............................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_eoffset;
	int mask_eoffset; 
	int bits_dontcare;      
	int mask_dontcare;
	int bits_reg;      
	int mask_reg;
	int bits_soffset;      
	int mask_soffset;
	int bits_c;      
	int mask_c;
	int bits_rop;      
	int mask_rop;
	int bits_code;      
	int mask_code;
} LoopSetup;

LoopSetup init_LoopSetup ={
	0xe0800000,
	/*eoffset*/0,0x3ff,
	/*dontcare*/10,0x3,
	/*reg*/12,0xf,
	/*soffset*/16,0xf,
	/*c*/20,0x01,
	/*rop*/21,0x3,
	/*code*/23,0x1ff
};

/* LDIMMhalf
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned long opcode;
	int bits_hword;
	int mask_hword;
	int bits_reg;      
	int mask_reg;
	int bits_grp;      
	int mask_grp;
	int bits_S;      
	int mask_S;
	int bits_H;      
	int mask_H;
	int bits_Z;      
	int mask_Z;
	int bits_code;      
	int mask_code;
} LDIMMhalf;

LDIMMhalf init_LDIMMhalf ={
	0xe1000000,
	/*hword*/0,0xffff,
	/*reg*/16,0x7,
	/*grp*/19,0x3,
	/*S*/21,0x01,
	/*H*/22,0x01,
	/*Z*/23,0x01,
	/*code*/24,0xff
};


/* CC2dreg
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_reg;
	int mask_reg;
	int bits_op;      
	int mask_op;
	int bits_code;      
	int mask_code;
} CC2dreg;

CC2dreg init_CC2dreg ={
	0x0200,
	/*reg*/0,0x7,
	/*op*/3,0x3,
	/*code*/5,0x7ff
};


/* PTR2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_dst;
	int mask_dst;
	int bits_src;      
	int mask_src;
	int bits_opc;      
	int mask_opc;
	int bits_code;      
	int mask_code;
} PTR2op;

PTR2op init_PTR2op ={
	0x4400,
	/*dst*/0,0x7,
	/*src*/3,0x7,
	/*opc*/6,0x7,
	/*code*/9,0x7f
};


/* COMP3op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_src0;
	int mask_src0;
	int bits_src1;      
	int mask_src1;
	int bits_dst;      
	int mask_dst;
	int bits_opc;      
	int mask_opc;
	int bits_code;      
	int mask_code;
} COMP3op;

COMP3op init_COMP3op ={
	0x5000,
	/*src0*/0,0x7,
	/*src1*/3,0x7,
	/*dst*/6,0x7,
	/*opc*/9,0x7,
	/*code*/12,0xf
};

/* ccMV
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 1 |.T.|.d.|.s.|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_src;
	int mask_src;
	int bits_dst;      
	int mask_dst;
	int bits_s;      
	int mask_s;
	int bits_d;      
	int mask_d;
	int bits_T;      
	int mask_T;
	int bits_code;      
	int mask_code;
} CCmv;

CCmv init_CCmv ={
	0x0600,
	/*src*/0,0x7,
	/*dst*/3,0x7,
	/*s*/6,0x01,
	/*d*/7,0x01,
	/*T*/8,0x01,
	/*code*/9,0x7f
};


/* CCflag
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_x;
	int mask_x;
	int bits_y;      
	int mask_y;
	int bits_G;      
	int mask_G;
	int bits_opc;      
	int mask_opc;
	int bits_I;      
	int mask_I;
	int bits_code;      
	int mask_code;
} CCflag;

CCflag init_CCflag ={
	0x0800,
	/*x*/0,0x7,
	/*y*/3,0x7,
	/*G*/6,0x01,
	/*opc*/7,0x7,
	/*I*/10,0x01,
	/*code*/11,0x1f
};


/* CC2stat
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_cbit;
	int mask_cbit;
	int bits_op;      
	int mask_op;
	int bits_D;      
	int mask_D;
	int bits_code;      
	int mask_code;
} CC2stat;

CC2stat init_CC2stat ={
	0x0300,
	/*cbit*/0,0x1f,
	/*op*/5,0x3,
	/*D*/7,0x01,
	/*code*/8,0xff
};


/* REGMV
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 1 |.gd........|.gs........|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_src;
	int mask_src;
	int bits_dst;      
	int mask_dst;
	int bits_gs;      
	int mask_gs;
	int bits_gd;      
	int mask_gd;
	int bits_code;      
	int mask_code;
} RegMv;

RegMv init_RegMv ={
	0x3000,
	/*src*/0,0x7,
	/*dst*/3,0x7,
	/*gs*/6,0x7,
	/*gd*/9,0x7,
	/*code*/12,0xf
};


/* COMPI2opD
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 0 |.op|.isrc......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_dst;
	int mask_dst;
	int bits_src;      
	int mask_src;
	int bits_op;      
	int mask_op;
	int bits_code;      
	int mask_code;
} COMPI2opD;

COMPI2opD init_COMPI2opD ={
	0x6000,
	/*dst*/0,0x7,
	/*src*/3,0x7f,
	/*op*/10,0x01,
	/*code*/11,0x1f
};

/* COMPI2opP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 1 |.op|.src.......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef COMPI2opD COMPI2opP;

COMPI2opP init_COMPI2opP ={
	0x6800,
	/*dst*/0,0x7,
	/*src*/3,0x7f,
	/*op*/10,0x01,
	/*code*/11,0x1f
};


/* dagMODim
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |.br| 1 | 1 |.op|.m.....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_i;
	int mask_i;
	int bits_m;      
	int mask_m;
	int bits_op;      
	int mask_op;
	int bits_code2;      
	int mask_code2;
	int bits_br;      
	int mask_br;
	int bits_code;      
	int mask_code;
} DagMODim;

DagMODim init_DagMODim ={
	0x9e60,
	/*i*/0,0x3,
	/*m*/2,0x3,
	/*op*/4,0x01,
	/*code2*/5,0x3,
	/*br*/7,0x01,
	/*code*/8,0xff
};

/* dagMODik
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef struct{
	unsigned short opcode;
	int bits_i;
	int mask_i;
	int bits_op;
	int mask_op;
	int bits_code;
	int mask_code;
} DagMODik;

DagMODik init_DagMODik ={
	0x9f60,
	/*i*/0,0x3,
	/*op*/2,0x3,
	/*code*/4,0xfff
};

#endif //BFIN_OPCODES_H_HD9837U0U9I27E902702DYHCXH2D79218D701D
