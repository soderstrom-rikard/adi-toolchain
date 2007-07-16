// **************************************************************************
//
//	Analog Devices Blackfin ETSI Implementation. 
// 	Copyright (C). 2002 Analog Devices Inc., All Rights Reserved.
//
// **************************************************************************
.file_attr libGroup=libetsi.h;
.file_attr libName=libetsi;
.file_attr libFunc=L_negate;
.file_attr FuncName=_L_negate;
.file_attr libFunc=_L_negate;
.file_attr prefersMem=any;
.file_attr prefersMemNum="50";
	.section program;
.epctext:
	.align 2;
_L_negate:
#if !defined(__ADSPLPBLACKFIN__)
		R1 = 0;
		R0 = R1 - R0 (S);
#else
		R0 = -R0 (S);
#endif
		RTS;
._L_negate.end:
	.global _L_negate;
	.type _L_negate,STT_FUNC;
.epctext.end:
	.section data1;

