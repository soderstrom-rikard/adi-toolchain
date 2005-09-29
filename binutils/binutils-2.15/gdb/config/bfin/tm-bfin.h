/*

    Copyright (c) 1990-1994,1997,1998,1999 Analog Devices Inc.,
	          All Rights Reserved

This material is considered highly CONFIDENTIAL and SENSITIVE
background Interlectual Property of Analog Devices Inc. Its recipient
is required to adhear to the LICENSE agreement.

This software is being provided to you, the LICENSEE, by Analog
Devices Inc (ADI) under the following license.  The following software
is proprietary background Intelectual Property of Analog Devices and
can not be used by its LICENSEE without written consent from ADI.

By obtaining, using and/or copying this software, you agree that you
have read, understood, and will comply with these terms and
conditions:

1. You may not, copy, modify or distribute, this software with out a
   written agreement from Analog Devices.


THIS SOFTWARE IS PROVIDED "AS IS", AND ADI MAKES NO REPRESENTATIONS
OR WARRANTIES, EXPRESS OR IMPLIED.  By way of example, but not
limitation, ADI MAKES NO REPRESENTATIONS OR WARRANTIES OF
MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE
OF THE LICENSED SOFTWARE OR DOCUMENTATION WILL NOT INFRINGE ANY THIRD
PARTY PATENTS, COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS.

*/
/* Defines needed when configuring for "bfin".
   Copyright (C) 1993 Free Software Foundation, Inc.

This file is part of GDB.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */


#include "value.h"
#include "defs.h"
#include "symtab.h"
#include "frame.h"

#include "solib.h"

/* Index within `registers' of the first byte of the space for
   register N.  */

#define REGISTER_BYTE(N)  ((N)*4)

/* Need to research if this is possible, until then no
*/
#if !defined (FRAME_NUM_ARGS)
/* #define FRAME_NUM_ARGS(val,fi) (val = -1)	 */
#define FRAME_NUM_ARGS(fi)	-1
#define FRAME_NUM_ARGS_P() (0)
#endif

/* Offset from SP to first arg on stack at first instruction of a function */
#define SP_ARG0 (0)

#if !defined (REMOTE_BREAKPOINT)
#define REMOTE_BREAKPOINT {0xa1, 0x00}
#endif

#define GDB_MULTI_ARCH GDB_MULTI_ARCH_PARTIAL

