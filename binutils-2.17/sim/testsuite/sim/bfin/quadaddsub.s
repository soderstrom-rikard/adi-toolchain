# mach: bfin

.include "testutils.inc"
	start


	R6.L = 32767;
	R6.H = 2768;
	R1.L = 2767;
	R1.H = 2768;

	r7=0;
	astat = r7;
	r3 = r6 -|- r1;
	DBG r3;
	DBG ASTAT;
	r7=ASTAT;
	DBG R7;
	DBGA (R7.H, 0x0);
	DBGA (R7.L, 0x3005);

	r7=0;
	astat=r7;
	r2 = r6 +|+ r1;
	DBG r2;
	DBG ASTAT;
	r7=ASTAT;
	DBG R7;
	DBGA (R7.H, 0x0300);
	DBGA (R7.L, 0x000a);

	r7=0;
	astat=r7;
	r2 = r6 +|+ r1, r3 = r6 -|- r1;

	DBG r2;
	DBG r3;
	DBG ASTAT;

	R7 = ASTAT;
	DBG  R7;
	DBGA (R7.H, 0x0300);
	DBGA (R7.L, 0x000b);

	r7=0;
	astat=r7;
	r2 = r6 +|- r1, r3 = r6 -|+ r1;

	DBG r2;
	DBG r3;
	DBG ASTAT;

	R7 = ASTAT;
	DBG  R7;
	DBGA (R7.H, 0x0300);
	DBGA (R7.L, 0x000b);

	pass
