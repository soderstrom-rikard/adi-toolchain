/*
** Copyright (C) 2006 Analog Devices, Inc.
**
** This file is subject to the terms and conditions of the GNU General  
** Public License. See the file COPYING in the main directory of this  
** archive for more details.
**
** In addition to the permissions in the GNU General Public License,
** Analog Devices gives you unlimited permission to link the
** compiled version of this file into combinations with other programs,
** and to distribute those combinations without any restriction coming
** from the use of this file.  (The General Public License restrictions
** do apply in other respects; for example, they cover modification of
** the file, and distribution when not linked into a combine
** executable.)  
**
** Non-GPL License also available as part of VisualDSP++  
** http://www.analog.com/processors/resources/crosscore/visualDspDevSoftware.html
*/

.extern ___cmpdf2;
.text;
.global ___ltdf2;
.type ___ltdf2, STT_FUNC;
___ltdf2:
	[--SP] = RETS;
	CALL.X	___cmpdf2;
	RETS = [SP++];
	CC = R0 < 0;
	R0 = CC;
	RTS;
	.size ___ltdf2, .-___ltdf2;
