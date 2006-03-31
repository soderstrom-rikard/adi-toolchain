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
.global ___nedf2;
.type ___nedf2, STT_FUNC;
___nedf2:
	CALL.X	___cmpdf2;
	CC = R0 == 0;
	CC = !CC;
	R0 = CC;
	RTS;
	.size ___nedf2, .-___nedf2;
