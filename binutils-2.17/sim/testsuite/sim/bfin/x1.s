# mach: bfin

.include "testutils.inc"
	start


// 0.5
	R0.L = 0x4000;
	R0.H = 0x4000;
	R1.L = 0x4000;
	R1.H = 0x4000;

	R2 = R0 +|+ R1, R3 = R0 -|- R1 (S , ASR);
//	DBGCMPLX ( R2 );
//	DBGCMPLX ( R3 );

	DBGA ( R2.L , 0x4000 );
	DBGA ( R2.H , 0x4000 );
	DBGA ( R3.L , 0 );
	DBGA ( R3.H , 0 );

// 0.125
	R1.L = 0x1000;
	R1.H = 0x1000;

	R2 = R0 +|+ R1, R3 = R0 -|- R1 (S , ASR);
//	DBGCMPLX ( R2 );
//	DBGCMPLX ( R3 );
//DBGA ( R2.L , 0.3125 );
//DBGA ( R2.H , 0.3125 );
//DBGA ( R3.L , 0.1875 );
//DBGA ( R3.H , 0.1875 );
	DBGA ( R2.L , 0x2800 );
	DBGA ( R2.H , 0x2800);
	DBGA ( R3.L , 0x1800 );
	DBGA ( R3.H , 0x1800);

	R0 = R2 +|+ R3, R1 = R2 -|- R3 (S , ASR);
//	DBGCMPLX ( R0 );
//	DBGCMPLX ( R1 );
	DBGA ( R0.L , 0x2000);
	DBGA ( R0.H , 0x2000 );
	DBGA ( R1.L , 0x0800 );
	DBGA ( R1.H , 0x0800 );

	R0 = 1;
	R0 <<= 15;
	R1 = R0 << 16;
	R0 = R0 | R1;
	R1 = R0;

	R2 = R0 +|+ R1, R3 = R0 -|- R1 (S , ASR);

//	DBGCMPLX ( R2 );
//	DBGCMPLX ( R3 );
	DBGA ( R0.L , 0x8000 );
	DBGA ( R0.H , 0x8000 );
	DBGA ( R1.L , 0x8000 );
	DBGA ( R1.H , 0x8000 );

	R4 = 0;
	R2 = R2 +|+ R4, R3 = R2 -|- R4 (S , ASR);
//	DBGCMPLX ( R2 );
//	DBGCMPLX ( R3 );

	R2 = R2 +|+ R3, R3 = R2 -|- R3 (S , ASR);
//	DBGCMPLX ( R2 );
//	DBGCMPLX ( R3 );
	DBGA ( R2.L , 0xc000 );
	DBGA ( R2.H , 0xc000 );

	R2 = R2 +|+ R2, R3 = R2 -|- R2 (S , ASL);
//	DBGCMPLX ( R2 );
//	DBGCMPLX ( R3 );
//DBGA ( R2.L , 0x7fff );
//DBGA ( R2.H , 0x7fff );
	DBGA ( R2.L , 0x8000 );
	DBGA ( R2.H , 0x8000 );
	pass
