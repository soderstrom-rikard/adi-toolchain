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

.extern ___cmpsf2;
.text;
.global ___gtsf2;
.type ___gtsf2, STT_FUNC;
___gtsf2:
	R2 = R1;
	R1 = R0;
	R0 = R2
	CALL.X	___cmpsf2;
	CC = R0 < 0;
	R0 = CC;
	RTS;
	.size ___gtsf2, .-___gtsf2;
