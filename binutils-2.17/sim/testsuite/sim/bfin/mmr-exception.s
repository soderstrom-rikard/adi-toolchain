# Blackfin testcase for MMR exceptions in a lower EVT
# mach: bfin
# sim: --environment operating

	.include "testutils.inc"

	start

	imm32 P0, 0xFFE02000
	loadsym R1, _evx
	[P0 + (4 * 3)] = R1;
	loadsym R1, _ivg9
	[P0 + (4 * 9)] = R1;
	CSYNC;

	RETI = R1;
	RAISE 9;
	R0 = -1;
	STI R0;
	RTI;
	dbg_fail

_evx:
	R0 = SEQSTAT;
	R0 = R0.B;
	R1 = 0x2e (x);
	CC = R0 == R1;
	IF !CC JUMP 1f;
	dbg_pass

_ivg9:
	# Invalid MMR
	imm32 P0, 0xFFEE0000
	[P0] = R0;
1:	dbg_fail
