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
.global ___nesf2;
.type ___nesf2, STT_FUNC;
___nesf2:
	CALL.X	___cmpsf2;
	CC = R0 == 0;
	CC = !CC;
	R0 = CC;
	RTS;
	.size ___nesf2, .-___nesf2;
