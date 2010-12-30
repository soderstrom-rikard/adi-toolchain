/* Common Flash Memory Interface (CFI) model.

   Copyright (C) 2010 Free Software Foundation, Inc.
   Contributed by Analog Devices, Inc.

   This file is part of simulators.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

#ifndef DV_CFI_H
#define DV_CFI_H

/* CFI standard.  */
#define CFI_CMD_QUERY		0x98
#define CFI_ADDR_QUERY_START	0x55
#define CFI_ADDR_QUERY_RESULT	0x10

#define CFI_CMD_RESET		0xFF
#define CFI_CMD_RESET_ALT	0xF0

#define CFI_CMD_READ_ID		0x90
#define CFI_ADDR_READ_ID	0x00

/* Intel specific.  */
#define CFI_CMDSET_INTEL	0x0001
#define INTEL_CMD_ERASE_BLOCK	0x20
#define INTEL_CMD_WRITE		0x40
#define INTEL_CMD_CLEAR_STATUS	0x50
#define INTEL_CMD_PROTECT	0x60
#define INTEL_CMD_ERASE_CONFIRM	0xD0

#endif
