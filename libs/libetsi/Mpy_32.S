// **************************************************************************
//
//	Analog Devices Blackfin ETSI Implementation. 
// 	Copyright (C). 2002 Analog Devices Inc., All Rights Reserved.
//
// **************************************************************************
.file_attr libGroup=libetsi.h;
.file_attr libName=libetsi;
.file_attr libFunc=Mpy_32;
.file_attr FuncName=_Mpy_32;
.file_attr libFunc=_Mpy_32;
.file_attr prefersMem=any;
.file_attr prefersMemNum="50";
	.section program;
.epctext:
	.align 2;
_Mpy_32:
	[--SP]=R7;
	R1.L = R1.L*R2.L (T) || R3=[SP+ 16] || NOP;
	R7.L =  1;
#if __SET_ETSI_FLAGS
#if !defined(__ADSPLPBLACKFIN__)
	CC = AV0;
#else
	CC=V;
#endif
	I0.L = _Overflow;
	I0.H = _Overflow;
	IF !CC JUMP no_overflow1 (BP);
	[I0] = R7;
no_overflow1:
#endif
	R3.L = R0.L*R3.L (T);
#if __SET_ETSI_FLAGS
#if !defined(__ADSPLPBLACKFIN__)
	CC = AV0;
#else
	CC=V;
#endif
	IF !CC JUMP no_overflow2 (BP);
	I0.L = _Overflow;
	I0.H = _Overflow;
	[I0] = R7;
no_overflow2:
#endif
	A0=R3.L*R7.L (W32) || R7 = [SP++] || NOP;
#if __SET_ETSI_FLAGS
#if !defined(__ADSPLPBLACKFIN__)
	CC = AV0;
#else
	CC=V;
#endif
	R3 = 1;
	IF !CC JUMP no_overflow3 (BP);
	I0.L = _Overflow;
	I0.H = _Overflow;
	[I0] = R3;
no_overflow3:
#endif
	A0 += R2.L*R0.L (W32);
#if __SET_ETSI_FLAGS
#if !defined(__ADSPLPBLACKFIN__)
	CC = AV0;
#else
	CC=V;
#endif
	R3 = 1;
	IF !CC JUMP no_overflow4 (BP);
	I0.L = _Overflow;
	I0.H = _Overflow;
	[I0] = R3;
no_overflow4:
#endif
	R0.L =  1;
	R0=(A0+=R0.L*R1.L);
#if __SET_ETSI_FLAGS
#if !defined(__ADSPLPBLACKFIN__)
	CC = AV0;
#else
	CC=V;
#endif
	R3 = 1;
	IF !CC JUMP no_overflow5 (BP);
	I0.L = _Overflow;
	I0.H = _Overflow;
	[I0] = R3;
no_overflow5:
#endif
	RTS;
._Mpy_32.end:
	.global _Mpy_32;
	.type _Mpy_32,STT_FUNC;
#if __SET_ETSI_FLAGS
	.extern _Overflow;
	.type _Overflow,STT_OBJECT;
#endif
.epctext.end:
	.section data1;
