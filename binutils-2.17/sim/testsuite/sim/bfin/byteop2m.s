# Blackfin testcase for BYTEOP2M
# mach: bfin

	.include "testutils.inc"

	start

	.macro check_it res:req
	imm32 R7, \res
	CC = R6 == R7;
	IF !CC JUMP 1f;
	.endm
	.macro test_byteop2m i0:req, resRL:req, resRH:req, resTL:req, resTH:req, resRLr:req, resRHr:req, resTLr:req, resTHr:req
	dmm32 I0, \i0

	R6 = BYTEOP2M (R1:0, R3:2) (rndl);
	check_it \resRL
	R6 = BYTEOP2M (R1:0, R3:2) (rndh);
	check_it \resRH
	R6 = BYTEOP2M (R1:0, R3:2) (tl);
	check_it \resTL
	R6 = BYTEOP2M (R1:0, R3:2) (th);
	check_it \resTH
	R6 = BYTEOP2M (R1:0, R3:2) (rndl, r);
	check_it \resRLr
	R6 = BYTEOP2M (R1:0, R3:2) (rndh, r);
	check_it \resRHr
	R6 = BYTEOP2M (R1:0, R3:2) (tl, r);
	check_it \resTLr
	R6 = BYTEOP2M (R1:0, R3:2) (th, r);
	check_it \resTHr

	jump 2f;
1:	fail
2:
	.endm

	imm32 R0, 0x01020304
	imm32 R1, 0x10203040
	imm32 R2, 0x0a0b0c0d
	imm32 R3, 0xa0b0c0d0

	test_byteop2m 0, 0x00040004, 0x04000400, 0x00040004, 0x04000400, 0x00480048, 0x48004800, 0x00480048, 0x48004800
	test_byteop2m 1, 0x00260004, 0x26000400, 0x00260004, 0x26000400, 0x00260048, 0x26004800, 0x00260048, 0x26004800
	test_byteop2m 2, 0x00480004, 0x48000400, 0x00480004, 0x48000400, 0x00040048, 0x04004800, 0x00040048, 0x04004800
	test_byteop2m 3, 0x00480026, 0x48002600, 0x00480026, 0x48002600, 0x00040026, 0x04002600, 0x00040026, 0x04002600

	imm32 R0, ~0x01020304
	imm32 R1, ~0x10203040
	imm32 R2, ~0x0a0b0c0d
	imm32 R3, ~0xa0b0c0d0

	test_byteop2m 0, 0x00fb00fb, 0xfb00fb00, 0x00fb00fb, 0xfb00fb00, 0x00b800b8, 0xb800b800, 0x00b800b8, 0xb800b800
	test_byteop2m 1, 0x00d900fb, 0xd900fb00, 0x00d900fb, 0xd900fb00, 0x00d900b8, 0xd900b800, 0x00d900b8, 0xd900b800
	test_byteop2m 2, 0x00b800fb, 0xb800fb00, 0x00b800fb, 0xb800fb00, 0x00fb00b8, 0xfb00b800, 0x00fb00b8, 0xfb00b800
	test_byteop2m 3, 0x00b800d9, 0xb800d900, 0x00b800d9, 0xb800d900, 0x00fb00d9, 0xfb00d900, 0x00fb00d9, 0xfb00d900

	pass
