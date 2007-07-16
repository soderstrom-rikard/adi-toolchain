/*
** Float16 negate
** Copyright (C) 2003 Analog Devices, Inc. All Rights Reserved.
*/

.file_attr libGroup      = floating_point_support;
.file_attr libName = libdsp;
.file_attr prefersMem    = internal;
.file_attr prefersMemNum = "30";
.file_attr libFunc = _negate_fl16;
.file_attr FuncName      = _negate_fl16;

.section program;
.align 2;
_negate_fl16:
	R1 = 0;
	R0.H = R1.H - R0.H (NS);
	RTS;
._negate_fl16.end:
.global _negate_fl16;
.type _negate_fl16, STT_FUNC;
