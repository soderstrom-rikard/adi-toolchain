#if !defined(BFIN_OPCODES_H_HD9837U0U9I27E902702DYHCXH2D79218D701D)
#define BFIN_OPCODES_H_HD9837U0U9I27E902702DYHCXH2D79218D701D

/*
 * Opcode union defines
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

#include <asm/byteorder.h>


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

typedef union _dsp32mac {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned long src1:3;
		unsigned long src0:3;
		unsigned long dst:3;
		unsigned long h10:1;
		unsigned long h00:1;
		unsigned long op0:2;
		unsigned long w0:1;
		unsigned long h11:1;
		unsigned long h01:1;

		unsigned long op1:2;
		unsigned long w1:1;
		unsigned long P:1;
		unsigned long MM:1;
		unsigned long mmod:4;
		unsigned long code2:2;
		unsigned long M:1;
		unsigned long code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned long code:4;
                unsigned long M:1;
                unsigned long code2:2;
                unsigned long mmod:4;
                unsigned long MM:1;
                unsigned long P:1;
                unsigned long w1:1;
                unsigned long op1:2;

                unsigned long h01:1;
                unsigned long h11:1;
                unsigned long w0:1;
                unsigned long op0:2;
                unsigned long h00:1;
                unsigned long h10:1;
                unsigned long dst:3;
                unsigned long src0:3;
                unsigned long src1:3;
#else 
#error "Unknown bitfield order forfiles."
# endif
	} bits;
} DSP32Mac;

#define init_DSP32Mac 0xc0000000

/* dsp32mult
+----+----+---+---|---+----+----+---|---+---+---+---|---+---+---+---+
| 1  | 1  | 0 | 0 |.M.| 0  | 1  |.mmod..........|.MM|.P.|.w1|.op1...|
|.h01|.h11|.w0|.op0...|.h00|.h10|.dst.......|.src0......|.src1......|
+----+----+---+---|---+----+----+---|---+---+---+---|---+---+---+---+
*/

typedef DSP32Mac DSP32Mult;

#define init_DSP32Mult 0xc2000000

/* dsp32alu
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 0 | - | - | - |.HL|.aopcde............|
|.aop...|.s.|.x.|.dst0......|.dst1......|.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _dsp32alu {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned long src1:3;
		unsigned long src0:3;
		unsigned long dst1:3;
		unsigned long dst0:3;
		unsigned long x:1;
		unsigned long s:1;
		unsigned long aop:2;

		unsigned long aopcde:5;
		unsigned long HL:1;
		unsigned long dontcare:3;
		unsigned long code2:2;
		unsigned long M:1;
		unsigned long code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned long code:4;
                unsigned long M:1;
                unsigned long code2:2;
                unsigned long dontcare:3;
                unsigned long HL:1;
                unsigned long aopcde:5;

                unsigned long aop:2;
                unsigned long s:1;
                unsigned long x:1;
                unsigned long dst0:3;
                unsigned long dst1:3;
                unsigned long src0:3;
                unsigned long src1:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} DSP32Alu;

#define init_DSP32Alu 0xc4000000

/* dsp32shift
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 0 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......| - | - | - |.src0......|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/



typedef union _dsp32shift {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned long src1:3;
		unsigned long src0:3;
		unsigned long dst1:3; // Don't care
		unsigned long dst0:3;
		unsigned long HLs:2;
		unsigned long sop:2;

		unsigned long sopcde:5;
		unsigned long dontcare:2;
		unsigned long code2:4;
		unsigned long M:1;
		unsigned long code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned long code:4;
                unsigned long M:1;
                unsigned long code2:4;
                unsigned long dontcare:2;
                unsigned long sopcde:5;

                unsigned long sop:2;
                unsigned long HLs:2;
                unsigned long dst0:3;
                unsigned long dst1:3; // Don't care
                unsigned long src0:3;
                unsigned long src1:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} DSP32Shift;

#define init_DSP32Shift 0xc6000000

/* dsp32shiftimm
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 0 | 0 |.M.| 1 | 1 | 0 | 1 | - | - |.sopcde............|
|.sop...|.HLs...|.dst0......|.immag.................|.src1......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _dsp32shiftimm {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned long src1:3;
		unsigned long immag:6;
		unsigned long dst0:3;
		unsigned long HLs:2;
		unsigned long sop:2;

		unsigned long sopcde:5;
		unsigned long dontcare:2;
		unsigned long code2:4;
		unsigned long M:1;
		unsigned long code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned long code:4;
                unsigned long M:1;
                unsigned long code2:4;
                unsigned long dontcare:2;
                unsigned long sopcde:5;

                unsigned long sop:2;
                unsigned long HLs:2;
                unsigned long dst0:3;
                unsigned long immag:6;
                unsigned long src1:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} DSP32ShiftImm;

#define init_DSP32ShiftImm 0xc6800000

// }
////////////////////////////////////////////////////////////////////////////
// LOAD / STORE

/* LDSTidxI
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 1 |.W.|.Z.|.sz....|.ptr.......|.reg.......|
|.offset........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ldsidxi {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		short offset;
		unsigned short reg:3;
		unsigned short ptr:3;
		unsigned short sz:2;
		unsigned short Z:1;
		unsigned short W:1;
		unsigned short code:6;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:6;
                unsigned short W:1;
                unsigned short Z:1;
                unsigned short sz:2;
                unsigned short ptr:3;
                unsigned short reg:3;
                short offset;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} LDSTidxI;

#define init_LDSTidxI 0xe4000000


/* LDST
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 |.sz....|.W.|.aop...|.Z.|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ldst {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short reg:3;
		unsigned short ptr:3;
		unsigned short Z:1;
		unsigned short aop:2;
		unsigned short W:1;
		unsigned short sz:2;
		unsigned short code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:4;
                unsigned short sz:2;
                unsigned short W:1;
                unsigned short aop:2;
                unsigned short Z:1;
                unsigned short ptr:3;
                unsigned short reg:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} LDST;

#define init_LDST 0x9000


/* LDSTii
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 |.W.|.op....|.offset........|.ptr.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ldstii {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short reg:3;
		unsigned short ptr:3;
		unsigned short offset:4;
		unsigned short op:2;
		unsigned short W:1;
		unsigned short code:3;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:3;
                unsigned short W:1;
                unsigned short op:2;
                unsigned short offset:4;
                unsigned short ptr:3;
                unsigned short reg:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} LDSTii;

#define init_LDSTii 0xa000


/* LDSTiiFP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 1 | 1 | 1 | 0 |.W.|.offset............|.reg...........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ldstiifp {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short reg:4;
		unsigned short offset:5;
		unsigned short W:1;
		unsigned short code:6;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:6;
                unsigned short W:1;
                unsigned short offset:5;
                unsigned short reg:4;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} LDSTiiFP;

#define init_LDSTiiFP 0xb800

/* dspLDST
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 |.W.|.aop...|.m.....|.i.....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/


typedef union _dspldst {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short reg:3;
		unsigned short i:2;
		unsigned short m:2;
		unsigned short aop:2;
		unsigned short W:1;
		unsigned short code:6;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:6;
                unsigned short W:1;
                unsigned short aop:2;
                unsigned short m:2;
                unsigned short i:2;
                unsigned short reg:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} DspLDST;

#define init_DspLDST 0x9c00


/* LDSTpmod
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 0 |.W.|.aop...|.reg.......|.idx.......|.ptr.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ldstpmod {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short ptr:3;
		unsigned short idx:3;
		unsigned short reg:3;
		unsigned short aop:2;
		unsigned short W:1;
		unsigned short code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:4;
                unsigned short W:1;
                unsigned short aop:2;
                unsigned short reg:3;
                unsigned short idx:3;
                unsigned short ptr:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} LDSTpmod;

#define init_LDSTpmod 0x8000

////////////////////////////////////////////////////////////////////////////

/* LOGI2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 1 |.opc.......|.src...............|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _logi2op {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short dst:3;
		unsigned short src:5;
		unsigned short opc:3;
		unsigned short code:5;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:5;
                unsigned short opc:3;
                unsigned short src:5;
                unsigned short dst:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} LOGI2op;

#define init_LOGI2op 0x4800


/* ALU2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 0 |.opc...........|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _alu2op {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short dst:3;
		unsigned short src:3;
		unsigned short opc:4;
		unsigned short code:6;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:6;
                unsigned short opc:4;
                unsigned short src:3;
                unsigned short dst:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} ALU2op;

#define init_ALU2op 0x4000


/* BRCC
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 1 |.T.|.B.|.offset................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _brcc {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short offset:10;
		unsigned short B:1;
		unsigned short T:1;
		unsigned short code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:4;
                unsigned short T:1;
                unsigned short B:1;
                unsigned short offset:10;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} BRCC;

#define init_BRCC 0x1000


/* UJUMP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 0 |.offset........................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ujump {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short offset:12;
		unsigned short code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:4;
                unsigned short offset:12;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} UJump;

#define init_UJump 0x2000


/* ProgCtrl
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.prgfunc.......|.poprnd........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _progctrl {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short poprnd:4;
		unsigned short prgfunc:4;
		unsigned short code:8;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:8;
                unsigned short prgfunc:4;
                unsigned short poprnd:4;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} ProgCtrl;

#define init_ProgCtrl 0x0000

/* CALLa
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 1 |.S.|.msw...........................|
|.lsw...........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/


typedef union _calla {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned long addr:24;
		unsigned long S:1;
		unsigned long code:7;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned long code:7;
                unsigned long S:1;
                unsigned long addr:24;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} CALLa;

#define init_CALLa 0xe2000000


/* pseudoDEBUG
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |.fn....|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _pseudodbg {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short reg:3;
		unsigned short grp:3;
		unsigned short fn:2;
		unsigned short code:8;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:8;
                unsigned short fn:2;
                unsigned short grp:3;
                unsigned short reg:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} PseudoDbg;

#define init_PseudoDbg 0xf800


/* psedodbg_assert
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 1 | 0 | - | - | - | - | - |.dbgop.....|.regtest...|
|.expected......................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _pseudodbg_assert {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned long expected:16;
		unsigned long regtest:3;
		unsigned long dbgop:3;
		unsigned long dontcare:5;
		unsigned long code:5;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned long code:5;
                unsigned long dontcare:5;
                unsigned long dbgop:3;
                unsigned long regtest:3;
                unsigned long expected:16;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} PseudoDbg_Assert;

#define init_PseudoDbg_Assert 0xf0000000


/* CaCTRL
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |.a.|.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _cactrl {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short reg:3;
		unsigned short op:2;
		unsigned short a:1;
		unsigned short code:10;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:10;
                unsigned short a:1;
                unsigned short op:2;
                unsigned short reg:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} CaCTRL;

#define init_CaCTRL 0x0240


/* PushPopMultiple
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 0 |.d.|.p.|.W.|.dr........|.pr........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _pushpopmultiple {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short pr:3;
		unsigned short dr:3;
		unsigned short W:1;
		unsigned short p:1;
		unsigned short d:1;
		unsigned short code:7;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:7;
                unsigned short d:1;
                unsigned short p:1;
                unsigned short W:1;
                unsigned short dr:3;
                unsigned short pr:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} PushPopMultiple;

#define init_PushPopMultiple 0x0400


/* PushPopReg
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |.W.|.grp.......|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _pushpopreg {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short reg:3;
		unsigned short grp:3;
		unsigned short W:1;
		unsigned short code:9;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:9;
                unsigned short W:1;
                unsigned short grp:3;
                unsigned short reg:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} PushPopReg;

#define init_PushPopReg 0x0100

/* linkage
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |.R.|
|.framesize.....................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _linkage {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned long framesize:16;
		unsigned long R:1;
		unsigned long code:15;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned long code:15;
                unsigned long R:1;
                unsigned long framesize:16;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} Linkage;

#define init_Linkage 0xe8000000

/* LoopSetup
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |.rop...|.c.|.soffset.......|
|.reg...........| - | - |.eoffset...............................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/


typedef union _loopsetup {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned long eoffset:10;
		unsigned long dontcare:2;
		unsigned long reg:4;
		unsigned long soffset:4;
		unsigned long c:1;
		unsigned long rop:2;
		unsigned long code:9;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned long code:9;
                unsigned long rop:2;
                unsigned long c:1;
                unsigned long soffset:4;
                unsigned long reg:4;
                unsigned long dontcare:2;
                unsigned long eoffset:10;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} LoopSetup;

#define init_LoopSetup 0xe0800000


/* LDIMMhalf
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |.Z.|.H.|.S.|.grp...|.reg.......|
|.hword.........................................................|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ldimmhalf {
	unsigned long opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short hword;
		unsigned short reg:3;
		unsigned short grp:2;
		unsigned short S:1;
		unsigned short H:1;
		unsigned short Z:1;
		unsigned short code:8;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:8;
                unsigned short Z:1;
                unsigned short H:1;
                unsigned short S:1;
                unsigned short grp:2;
                unsigned short reg:3;
                unsigned short hword;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} LDIMMhalf;

#define init_LDIMMhalf 0xe1000000


/* CC2dreg
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |.op....|.reg.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _cc2dreg {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short reg:3;
		unsigned short op:2;
		unsigned short code:11;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:11;
                unsigned short op:2;
                unsigned short reg:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} CC2dreg;

#define init_CC2dreg 0x0200


/* PTR2op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 0 | 0 | 1 | 0 |.opc.......|.src.......|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ptr2op {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short dst:3;
		unsigned short src:3;
		unsigned short opc:3;
		unsigned short code:7;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:7;
                unsigned short opc:3;
                unsigned short src:3;
                unsigned short dst:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} PTR2op;

#define init_PTR2op 0x4400


/* COMP3op
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 0 | 1 |.opc.......|.dst.......|.src1......|.src0......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _comp3op {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short src0:3;
		unsigned short src1:3;
		unsigned short dst:3;
		unsigned short opc:3;
		unsigned short code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:4;
                unsigned short opc:3;
                unsigned short dst:3;
                unsigned short src1:3;
                unsigned short src0:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} COMP3op;

#define init_COMP3op 0x5000

/* ccMV
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 1 | 1 |.T.|.d.|.s.|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ccmv {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short src:3;
		unsigned short dst:3;
		unsigned short s:1;
		unsigned short d:1;
		unsigned short T:1;
		unsigned short code:7;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:7;
                unsigned short T:1;
                unsigned short d:1;
                unsigned short s:1;
                unsigned short dst:3;
                unsigned short src:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} CCmv;

#define init_CCmv 0x0600


/* CCflag
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 1 |.I.|.opc.......|.G.|.y.........|.x.........|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _ccflag {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short x:3;
		unsigned short y:3;
		unsigned short G:1;
		unsigned short opc:3;
		unsigned short I:1;
		unsigned short code:5;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:5;
                unsigned short I:1;
                unsigned short opc:3;
                unsigned short G:1;
                unsigned short y:3;
                unsigned short x:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} CCflag;

#define init_CCflag 0x0800


/* CC2stat
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |.D.|.op....|.cbit..............|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _cc2stat {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short cbit:5;
		unsigned short op:2;
		unsigned short D:1;
		unsigned short code:8;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:8;
                unsigned short D:1;
                unsigned short op:2;
                unsigned short cbit:5;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} CC2stat;

#define init_CC2stat 0x0300


/* REGMV
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 0 | 1 | 1 |.gd........|.gs........|.dst.......|.src.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _regmv {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short src:3;
		unsigned short dst:3;
		unsigned short gs:3;
		unsigned short gd:3;
		unsigned short code:4;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:4;
                unsigned short gd:3;
                unsigned short gs:3;
                unsigned short dst:3;
                unsigned short src:3;
#else 
#error "Unknown bitfield order for files."
# endif
	} bits;
} RegMv;

#define init_RegMv 0x3000


/* COMPI2opD
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 0 |.op|.isrc......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _compi2opd {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short dst:3;
		unsigned short src:7;
		unsigned short op:1;
		unsigned short code:5;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:5;
                unsigned short op:1;
                unsigned short src:7;
                unsigned short dst:3;
#else
#error "Unknown bitfield order for files."
# endif
	} bits;
} COMPI2opD;

#define init_COMPI2opD 0x6000

/* COMPI2opP
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 0 | 1 | 1 | 0 | 1 |.op|.src.......................|.dst.......|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef COMPI2opD COMPI2opP;

#define init_COMPI2opP 0x6800


/* dagMODim
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |.br| 1 | 1 |.op|.m.....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _dagmodim {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short i:2;
		unsigned short m:2;
		unsigned short op:1;
		unsigned short code2:2;
		unsigned short br:1;
		unsigned short code:8;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:8;
                unsigned short br:1;
                unsigned short code2:2;
                unsigned short op:1;
                unsigned short m:2;
                unsigned short i:2;
#else
#error "Unknown bitfield order for files."
# endif
	} bits;
} DagMODim;

#define init_DagMODim 0x9e60

/* dagMODik
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
| 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |.op....|.i.....|
+---+---+---+---|---+---+---+---|---+---+---+---|---+---+---+---+
*/

typedef union _dagmodik {
	unsigned short opcode;
	struct {
#if defined(__LITTLE_ENDIAN_BITFIELD)
		unsigned short i:2;
		unsigned short op:2;
		unsigned short code:12;
#elif defined(__BIG_ENDIAN_BITFIELD)
                unsigned short code:12;
                unsigned short op:2;
                unsigned short i:2;
#else
#error "Unknown bitfield order for files."
# endif
	} bits;
} DagMODik;

#define init_DagMODik 0x9f60

#endif //BFIN_OPCODES_H_HD9837U0U9I27E902702DYHCXH2D79218D701D
