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
.global ___ledf2;
.type ___ledf2, STT_FUNC;
___ledf2:
	CALL.X	___cmpdf2;
	CC = R0 <= 0;
	R0 = CC;
	RTS;
	.size ___ledf2, .-___ledf2;
