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
.global ___ltsf2;
.type ___ltsf2, STT_FUNC;
___ltsf2:
	CALL.X	___cmpsf2;
	CC = R0 < 0;
	R0 = CC;
	RTS;
	.size ___ltsf2, .-___ltsf2;
