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
.global ___lesf2;
.type ___lesf2, STT_FUNC;
___lesf2:
	CALL.X	___cmpsf2;
	CC = R0 <= 0;
	R0 = CC;
	RTS;
	.size ___lesf2, .-___lesf2;
