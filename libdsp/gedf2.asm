/*
** Copyright (C) 2006 Analog Devices, Inc.
**
** This file is subject to the terms and conditions of the GNU Library General  
** Public License. See the file "COPYING.LIB" in the main directory of this  
** archive for more details.  
**
** Non-LGPL License also available as part of VisualDSP++  
** http://www.analog.com/processors/resources/crosscore/visualDspDevSoftware.html
*/

.extern ___cmpdf2;
.text;
.global ___gedf2;
.type ___gedf2, STT_FUNC;
___gedf2:
	LINK 16;
	[FP + 16] = R2;
	[SP + 12] = R1;
	R2 = R0;
	R1 = [FP + 20];
	R0 = [FP + 16];
	CALL.X	___cmpdf2;
	CC = R0 <= 0;
	R0 = CC;
	UNLINK;
	RTS;
	.size ___gedf2, .-___gedf2;
