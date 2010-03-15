# Blackfin testcase for signbits
# mach: bfin

	.include "testutils.inc"

	start

	.global _test

	A0 = 0;
	r0 = 0x10 (Z);
	A0.x = R0;

	imm32 r0, 0x60038;

	R0.L = SIGNBITS A0;

	imm32 r1, 0x6fffa;
	CC = R1 == R0
	if CC jump 1f;
	fail
1:
	pass
