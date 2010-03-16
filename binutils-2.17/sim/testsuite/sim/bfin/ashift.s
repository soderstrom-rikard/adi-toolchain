# Blackfin testcase for ashift
# mach: bfin
# xfail: "need to implement ASHIFT in sim" bfin-*

	.include "testutils.inc"

	start

	/*
	 * 16-bit ashift and lshift uses a 6-bit signed  magnitude, which
	 * gives a range from -32 to 31.  In the case where the  magnitude
	 * is -32, make sure the answer is correct.
	 */

	R1 = 0x8000 (Z);
	R0.L = -32;
	R2.H = 0;
	R2.L = ASHIFT R1.L BY R0.L;
	R3 = 0xffff (Z);
	CC = R3 == R2;
	if CC jump 1f;
	fail
1:
	pass

