/* Blackfin UART model.

   Copyright (C) 2010 Free Software Foundation, Inc.
   Contributed by Analog Devices, Inc.

   This file is part of simulators.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

#ifndef DV_BFIN_UART_H
#define DV_BFIN_UART_H

/* XXX: This should be pushed into the model data.  */
#define BFIN_COREMMR_UART_BASE	0xFFC00400
#define BFIN_COREMMR_UART_SIZE	0x30

/* UART_LCR */
#define DLAB (1 << 7)

/* UART_LSR */
#define TEMT (1 << 6)
#define THRE (1 << 5)
#define DR (1 << 0)

#endif
