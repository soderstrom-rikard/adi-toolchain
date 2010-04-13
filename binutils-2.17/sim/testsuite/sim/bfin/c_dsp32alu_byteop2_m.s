//Original:/proj/frio/dv/testcases/core/c_dsp32alu_byteop2_m/c_dsp32alu_byteop2_m.dsp
// Spec Reference: dsp32alu byteop2 - minus

#include "test.h"
.include "testutils.inc"
	start




	A1 = 0;
	A0 = 0;
	R0 = 0;
	ASTAT = R0;

	imm32 r0, 0x15678911;
	imm32 r1, 0x2789ab1d;
	imm32 r2, 0x34445515;
	imm32 r3, 0x46667717;
	imm32 r4, 0x5567891b;
	imm32 r5, 0x6789ab1d;
	imm32 r6, 0x74445515;
	imm32 r7, 0x86667777;
	R4 = BYTEOP2M ( R1:0 , R3:2 ) (RNDL);
	R5 = BYTEOP2M ( R1:0 , R3:2 ) (RNDL , R);
	R6 = BYTEOP2M ( R1:0 , R3:2 ) (RNDH);
	R7 = BYTEOP2M ( R1:0 , R3:2 ) (RNDH , R);
	CHECKREG r4, 0x003d0041;
	CHECKREG r5, 0x00570056;
	CHECKREG r6, 0x3d004100;
	CHECKREG r7, 0x57005600;

	imm32 r0, 0x1567892b;
	imm32 r1, 0x2789ab2d;
	imm32 r2, 0x34445525;
	imm32 r3, 0x46667727;
	imm32 r4, 0x58889929;
	imm32 r5, 0x6aaabb2b;
	imm32 r6, 0x7cccdd2d;
	imm32 r7, 0x8eeeffff;
	R0 = BYTEOP2M ( R3:2 , R1:0 ) (RNDL);
	R1 = BYTEOP2M ( R3:2 , R1:0 ) (RNDL , R);
	R2 = BYTEOP2M ( R3:2 , R1:0 ) (RNDH);
	R3 = BYTEOP2M ( R3:2 , R1:0 ) (RNDH , R);
	CHECKREG r0, 0x003d004c;
	CHECKREG r1, 0x0057005e;
	CHECKREG r2, 0x2d003200;
	CHECKREG r3, 0x41003f00;

	imm32 r0, 0x716789ab;
	imm32 r1, 0x8289abcd;
	imm32 r2, 0x93445555;
	imm32 r3, 0xa4667777;
	imm32 r4, 0xb56789ab;
	imm32 r5, 0xd689abcd;
	imm32 r6, 0xe7445555;
	imm32 r7, 0x6f661235;
	R4 = BYTEOP2M ( R1:0 , R3:2 ) (TL);
	R5 = BYTEOP2M ( R1:0 , R3:2 ) (TL , R);
	R6 = BYTEOP2M ( R1:0 , R3:2 ) (TH);
	R7 = BYTEOP2M ( R1:0 , R3:2 ) (TH , R);
	CHECKREG r4, 0x006c0078;
	CHECKREG r5, 0x0085009a;
	CHECKREG r6, 0x6c007800;
	CHECKREG r7, 0x85009a00;

	imm32 r0, 0x416789ab;
	imm32 r1, 0x6289abcd;
	imm32 r2, 0x43445555;
	imm32 r3, 0x64667777;
	imm32 r4, 0x456789ab;
	imm32 r5, 0x6689abcd;
	imm32 r6, 0x47445555;
	imm32 r7, 0x68667777;
	R0 = BYTEOP2M ( R3:2 , R1:0 ) (TL);
	R1 = BYTEOP2M ( R3:2 , R1:0 ) (TL , R);
	R2 = BYTEOP2M ( R3:2 , R1:0 ) (TH);
	R3 = BYTEOP2M ( R3:2 , R1:0 ) (TH , R);
	CHECKREG r0, 0x004c0078;
	CHECKREG r1, 0x006d009a;
	CHECKREG r2, 0x35004900;
	CHECKREG r3, 0x4e006200;

	pass

