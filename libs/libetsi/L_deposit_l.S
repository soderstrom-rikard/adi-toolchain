// **************************************************************************
//
//	Analog Devices Blackfin ETSI Implementation. 
// 	Copyright (C). 2002 Analog Devices Inc., All Rights Reserved.
//
// **************************************************************************
.file_attr libGroup=libetsi.h;
.file_attr libName=libetsi;
.file_attr libFunc=L_deposit_l;
.file_attr FuncName=_L_deposit_l;
.file_attr libFunc=_L_deposit_l;
.file_attr prefersMem=any;
.file_attr prefersMemNum="50";
	.section program;
.epctext:
	.align 2;
_L_deposit_l:
		R0 = R0.L (X);
		RTS;

._L_deposit_l.end:
	.global _L_deposit_l;
	.type _L_deposit_l,STT_FUNC;
.epctext.end:
	.section data1;

