# mach: bfin
.include "testutils.inc"

	start

	imm32 R0, 0x45c1969f;   A0.w = R0;
	imm32 R0, 0x00000000;   A0.x = R0;
	R4 = A0 (IU);
	checkreg R4, 0x45c1969f;

	pass
