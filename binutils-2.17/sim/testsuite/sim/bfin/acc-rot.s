# Blackfin testcase for Accumulator Rotates (ROT)
# mach: bfin

	.include "testutils.inc"

	.macro atest_setup acc:req, val:req, cc:req, shift:req
	imm32 R0, \val
	R1 = \val >> 32;
	R2 = \cc;
	R3 = \shift
	\acc\().W = R0;
	\acc\().X = R1;
	CC = R2;
	.endm

	.macro atest_check acc:req, exp:req, expcc:req
	R7 = CC;
	R6 = \expcc;
	CC = R7 == R6;
	IF !CC JUMP 1f;

	imm32 R4, \exp
	R2 = \acc\().W;
	CC = R4 == R2;
	IF !CC JUMP 1f;
	R5 = \exp >> 32;
	R6 = \acc\().X;
	R6 = R6.B (z);
	CC = R5 == R6;
	IF !CC JUMP 1f;

	JUMP 2f;
1:	fail
2:
	.endm

	.macro _atest acc:req, val:req, cc:req, shift:req, exp:req, expcc:req
	atest_setup \acc, \val, \cc, \shift
	\acc = ROT \acc BY \shift;
	atest_check \acc, \exp, \expcc

	atest_setup \acc, \val, \cc, \shift
	\acc = ROT \acc BY R3.L;
	atest_check \acc, \exp, \expcc
	.endm

	.macro atest val:req, cc:req, shift:req, exp:req, expcc:req
	_atest A0, \val, \cc, \shift, \exp, \expcc
	_atest A1, \val, \cc, \shift, \exp, \expcc
	.endm

	start

	atest 0x0000000000, 0,   0, 0x0000000000, 0
	atest 0xa5a5a5a5a5, 0,   0, 0xa5a5a5a5a5, 0
	atest 0x0000000000, 1,   0, 0x0000000000, 1
	atest 0xa5a5a5a5a5, 1,   0, 0xa5a5a5a5a5, 1
	atest 0x0000000000, 0,  10, 0x0000000000, 0

	atest 0x000000000f, 0,   4, 0x00000000f0, 0
	atest 0x000000000f, 1,   4, 0x00000000f8, 0
	atest 0x000000000f, 0,  20, 0x0000f00000, 0
	atest 0x000000000f, 1,  20, 0x0000f80000, 0
	atest 0x000000000f, 0,  -5, 0xf000000000, 0
	atest 0x000000000f, 1,  -5, 0xf800000000, 0
	atest 0x000000000f, 0,  -1, 0x0000000007, 1
	atest 0x000000000f, 1,  -1, 0x8000000007, 1

	atest 0xffffffffff, 1,  10, 0xffffffffff, 1
	atest 0x1111111110, 0,  -5, 0x0088888888, 1

	atest 0x1f2e3d4c5b, 1,   0, 0x1f2e3d4c5b, 1
	atest 0x1f2e3d4c5b, 1,   1, 0x3e5c7a98b7, 0
	atest 0x1f2e3d4c5b, 1,   2, 0x7cb8f5316e, 0
	atest 0x1f2e3d4c5b, 1,   3, 0xf971ea62dc, 0
	atest 0x1f2e3d4c5b, 1,   4, 0xf2e3d4c5b8, 1
	atest 0x1f2e3d4c5b, 1,   5, 0xe5c7a98b71, 1
	atest 0x1f2e3d4c5b, 1,   6, 0xcb8f5316e3, 1
	atest 0x1f2e3d4c5b, 1,   7, 0x971ea62dc7, 1
	atest 0x1f2e3d4c5b, 1,   8, 0x2e3d4c5b8f, 1
	atest 0x1f2e3d4c5b, 1,   9, 0x5c7a98b71f, 0
	atest 0x1f2e3d4c5b, 1,  10, 0xb8f5316e3e, 0
	atest 0x1f2e3d4c5b, 1,  11, 0x71ea62dc7c, 1
	atest 0x1f2e3d4c5b, 1,  12, 0xe3d4c5b8f9, 0
	atest 0x1f2e3d4c5b, 1,  13, 0xc7a98b71f2, 1
	atest 0x1f2e3d4c5b, 1,  14, 0x8f5316e3e5, 1
	atest 0x1f2e3d4c5b, 1,  15, 0x1ea62dc7cb, 1
	atest 0x1f2e3d4c5b, 1,  16, 0x3d4c5b8f97, 0
	atest 0x1f2e3d4c5b, 1,  17, 0x7a98b71f2e, 0
	atest 0x1f2e3d4c5b, 1,  18, 0xf5316e3e5c, 0
	atest 0x1f2e3d4c5b, 1,  19, 0xea62dc7cb8, 1
	atest 0x1f2e3d4c5b, 1,  20, 0xd4c5b8f971, 1
	atest 0x1f2e3d4c5b, 1,  21, 0xa98b71f2e3, 1
	atest 0x1f2e3d4c5b, 1,  22, 0x5316e3e5c7, 1
	atest 0x1f2e3d4c5b, 1,  23, 0xa62dc7cb8f, 0
	atest 0x1f2e3d4c5b, 1,  24, 0x4c5b8f971e, 1
	atest 0x1f2e3d4c5b, 1,  25, 0x98b71f2e3d, 0
	atest 0x1f2e3d4c5b, 1,  26, 0x316e3e5c7a, 1
	atest 0x1f2e3d4c5b, 1,  27, 0x62dc7cb8f5, 0
	atest 0x1f2e3d4c5b, 1,  28, 0xc5b8f971ea, 0
	atest 0x1f2e3d4c5b, 1,  29, 0x8b71f2e3d4, 1
	atest 0x1f2e3d4c5b, 1,  30, 0x16e3e5c7a9, 1
	atest 0x1f2e3d4c5b, 1,  31, 0x2dc7cb8f53, 0
	atest 0x1f2e3d4c5b, 1,  -1, 0x8f971ea62d, 1
	atest 0x1f2e3d4c5b, 1,  -2, 0xc7cb8f5316, 1
	atest 0x1f2e3d4c5b, 1,  -3, 0xe3e5c7a98b, 0
	atest 0x1f2e3d4c5b, 1,  -4, 0x71f2e3d4c5, 1
	atest 0x1f2e3d4c5b, 1,  -5, 0xb8f971ea62, 1
	atest 0x1f2e3d4c5b, 1,  -6, 0xdc7cb8f531, 0
	atest 0x1f2e3d4c5b, 1,  -7, 0x6e3e5c7a98, 1
	atest 0x1f2e3d4c5b, 1,  -8, 0xb71f2e3d4c, 0
	atest 0x1f2e3d4c5b, 1,  -9, 0x5b8f971ea6, 0
	atest 0x1f2e3d4c5b, 1, -10, 0x2dc7cb8f53, 0
	atest 0x1f2e3d4c5b, 1, -11, 0x16e3e5c7a9, 1
	atest 0x1f2e3d4c5b, 1, -12, 0x8b71f2e3d4, 1
	atest 0x1f2e3d4c5b, 1, -13, 0xc5b8f971ea, 0
	atest 0x1f2e3d4c5b, 1, -14, 0x62dc7cb8f5, 0
	atest 0x1f2e3d4c5b, 1, -15, 0x316e3e5c7a, 1
	atest 0x1f2e3d4c5b, 1, -16, 0x98b71f2e3d, 0
	atest 0x1f2e3d4c5b, 1, -17, 0x4c5b8f971e, 1
	atest 0x1f2e3d4c5b, 1, -18, 0xa62dc7cb8f, 0
	atest 0x1f2e3d4c5b, 1, -19, 0x5316e3e5c7, 1
	atest 0x1f2e3d4c5b, 1, -20, 0xa98b71f2e3, 1
	atest 0x1f2e3d4c5b, 1, -21, 0xd4c5b8f971, 1
	atest 0x1f2e3d4c5b, 1, -22, 0xea62dc7cb8, 1
	atest 0x1f2e3d4c5b, 1, -23, 0xf5316e3e5c, 0
	atest 0x1f2e3d4c5b, 1, -24, 0x7a98b71f2e, 0
	atest 0x1f2e3d4c5b, 1, -25, 0x3d4c5b8f97, 0
	atest 0x1f2e3d4c5b, 1, -26, 0x1ea62dc7cb, 1
	atest 0x1f2e3d4c5b, 1, -27, 0x8f5316e3e5, 1
	atest 0x1f2e3d4c5b, 1, -28, 0xc7a98b71f2, 1
	atest 0x1f2e3d4c5b, 1, -29, 0xe3d4c5b8f9, 0
	atest 0x1f2e3d4c5b, 1, -30, 0x71ea62dc7c, 1
	atest 0x1f2e3d4c5b, 1, -31, 0xb8f5316e3e, 0
	atest 0x1f2e3d4c5b, 1, -32, 0x5c7a98b71f, 0

	pass
