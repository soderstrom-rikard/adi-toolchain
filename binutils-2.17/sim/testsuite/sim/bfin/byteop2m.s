# Blackfin testcase for BYTEOP2M
# mach: bfin

	.include "testutils.inc"

	start

	.macro test_byteop2m i0:req, resRL:req, resRH:req, resTL:req, resTH:req, resRLr:req, resRHr:req, resTLr:req, resTHr:req
	dmm32 I0, \i0

	R4 = BYTEOP2M (R1:0, R3:2) (rndl);
	R5 = BYTEOP2M (R1:0, R3:2) (rndh);
	R6 = BYTEOP2M (R1:0, R3:2) (tl);
	R7 = BYTEOP2M (R1:0, R3:2) (th);
	CHECKREG R4, \resRL;
	CHECKREG R5, \resRH;
	CHECKREG R6, \resTL;
	CHECKREG R7, \resTH;
	R4 = BYTEOP2M (R1:0, R3:2) (rndl, r);
	R5 = BYTEOP2M (R1:0, R3:2) (rndh, r);
	R6 = BYTEOP2M (R1:0, R3:2) (tl, r);
	R7 = BYTEOP2M (R1:0, R3:2) (th, r);
	CHECKREG R4, \resRLr
	CHECKREG R5, \resRHr
	CHECKREG R6, \resTLr
	CHECKREG R7, \resTHr

	.endm

	imm32 R0, 0x01020304
	imm32 R1, 0x10203040
	imm32 R2, 0x0a0b0c0d
	imm32 R3, 0xa0b0c0d0

	test_byteop2m 0, 0x00060008, 0x06000800, 0x00060008, 0x06000800, 0x00600080, 0x60008000, 0x00600080, 0x60008000
	test_byteop2m 1, 0x00470007, 0x47000700, 0x00470007, 0x47000700, 0x00300070, 0x30007000, 0x00300070, 0x30007000
	test_byteop2m 2, 0x00800006, 0x80000600, 0x00800006, 0x80000600, 0x00080060, 0x08006000, 0x00080060, 0x08006000
	test_byteop2m 3, 0x00700047, 0x70004700, 0x00700047, 0x70004700, 0x00070030, 0x07003000, 0x00070030, 0x07003000

	imm32 R0, ~0x01020304
	imm32 R1, ~0x10203040
	imm32 R2, ~0x0a0b0c0d
	imm32 R3, ~0xa0b0c0d0

	test_byteop2m 0, 0x00f900f7, 0xf900f700, 0x00f900f7, 0xf900f700, 0x009f007f, 0x9f007f00, 0x009f007f, 0x9f007f00
	test_byteop2m 1, 0x00b800f8, 0xb800f800, 0x00b800f8, 0xb800f800, 0x00cf008f, 0xcf008f00, 0x00cf008f, 0xcf008f00
	test_byteop2m 2, 0x007f00f9, 0x7f00f900, 0x007f00f9, 0x7f00f900, 0x00f7009f, 0xf7009f00, 0x00f7009f, 0xf7009f00
	test_byteop2m 3, 0x008f00b8, 0x8f00b800, 0x008f00b8, 0x8f00b800, 0x00f800cf, 0xf800cf00, 0x00f800cf, 0xf800cf00

	pass
