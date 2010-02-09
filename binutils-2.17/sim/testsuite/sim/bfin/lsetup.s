# Blackfin testcase for playing with LSETUP
# mach: bfin

	.include "testutils.inc"

	start

	.global _test
_test:
	R0 = 0x123;
	P0 = R0;
	LSETUP (.L1, .L1) LC0 = P0;
.L1:
	R0 += -1;

	R1 = 0;
	CC = R1 == R0;
	IF !CC JUMP 1f;

	pass
1:
	fail
