// **************************************************************************
//
//	Analog Devices Blackfin ETSI Implementation. 
// 	Copyright (C). 2002 Analog Devices Inc., All Rights Reserved.
//
// **************************************************************************
.file_attr libGroup=libetsi.h;
.file_attr libName=libetsi;
.file_attr libFunc=L_deposit_h;
.file_attr FuncName=_L_deposit_h;
.file_attr libFunc=_L_deposit_h;
.file_attr prefersMem=any;
.file_attr prefersMemNum="50";
	.section program;
.epctext:
	.align 2;
_L_deposit_h:
		R0 <<=  16;
		RTS;

._L_deposit_h.end:
	.global _L_deposit_h;
	.type _L_deposit_h,STT_FUNC;
.epctext.end:
	.section data1;

