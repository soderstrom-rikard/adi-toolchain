# Blackfin testcase for compare instructions
# mach: bfin

	.include "testutils.inc"

	start

	.global _testeq
_testeq:
	R0 = 0 (X);
	R1 = 0 (X);
	CC = R0 == R1;
	IF !CC JUMP 1f;
	pass
1:
	fail
