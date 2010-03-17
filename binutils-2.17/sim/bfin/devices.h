/* Common Blackfin device stuff.

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

#ifndef DEVICES_H
#define DEVICES_H

#include "hw-main.h"
#include "hw-device.h"
#include "hw-tree.h"

static inline bu32 dv_load_4(const void *ptr)
{
	const unsigned char *c = ptr;
	return (c[3] << 24) | (c[2] << 16) | (c[1] << 8) | (c[0]);
}

static inline void dv_store_4(void *ptr, bu32 val)
{
	unsigned char *c = ptr;
	c[3] = val >> 24;
	c[2] = val >> 16;
	c[1] = val >> 8;
	c[0] = val;
}

static inline void *
dv_get_state (SIM_CPU *cpu, const char *device_name)
{
  SIM_DESC sd = CPU_STATE (cpu);
  void *root = STATE_HW (sd);
  struct hw *hw = hw_tree_find_device (root, device_name);
  return hw_data (hw);
}

#endif
