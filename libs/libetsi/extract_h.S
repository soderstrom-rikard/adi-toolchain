// **************************************************************************
//
//	Analog Devices Blackfin ETSI Implementation. 
// 	Copyright (C). 2002 Analog Devices Inc., All Rights Reserved.
//
// **************************************************************************
.file_attr libGroup=libetsi.h;
.file_attr libName=libetsi;
.file_attr libFunc=extract_h;
.file_attr FuncName=_extract_h;
.file_attr libFunc=_extract_h;
.file_attr prefersMem=any;
.file_attr prefersMemNum="50";
	.section program;

.epctext:

	.align 2;
_extract_h:
		R0 = R0 >>> 16;
		RTS;

._extract_h.end:
	.global _extract_h;
	.type _extract_h,STT_FUNC;

.epctext.end:

	.section data1;

