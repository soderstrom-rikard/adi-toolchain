/*
** Float16 abs
** Copyright (C) 2003 Analog Devices, Inc. All Rights Reserved.
*/

.file_attr libGroup      = float16.h;
.file_attr libFunc       = _abs_fl16;
.file_attr libFunc       = abs_fl16;
.file_attr libName = libdsp;
.file_attr prefersMem    = internal;
.file_attr prefersMemNum = "30";
.file_attr FuncName      = _abs_fl16;

.section program;
.align 2;
_abs_fl16:
	R1 = ABS R0 (V);
	R0.H = R1.H >> 0;
	RTS;
._abs_fl16.end:
.global _abs_fl16;
.type _abs_fl16, STT_FUNC;
