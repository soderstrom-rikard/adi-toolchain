# mach: bfin

.include "testutils.inc"
	start

	R0 = 0;
	ASTAT = R0;
	R1.L = 32767;
	R1.H = -32768;
	DBG R1;
	R0.L = 1;
	R0.H = 1;
	R0 = R1 +|+ R0, R2 = R1 -|- R0 (S , ASL);
	DBG R0;
	DBGA ( R0.H , 0x8000 );	DBGA ( R0.L , 0x7fff );
	DBG R2;
	DBGA ( R2.H , 0x8000 );	DBGA ( R2.L , 0x7fff );

	R0 = ASTAT;
	dbg r0;
	DBGA ( R0.L , 0x000a );
	DBGA ( R0.H , 0x0300 );

	R0 = 0;
	R1 = 0;
	R4 = 0;
	ASTAT = R0;
	R4 = R1 +|+ R0, R0 = R1 -|- R0 (S , ASL);
	DBG R4;
	DBG R0;
	R7 = ASTAT;
	DBG R7;
	DBG ASTAT;
	DBGA ( R7.L , 0x0001 );
	DBGA ( R7.H , 0x0000 );

	pass
