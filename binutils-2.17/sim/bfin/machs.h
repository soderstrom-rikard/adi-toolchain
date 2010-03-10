/* Simulator for Analog Devices Blackfin processers.

   Copyright (C) 2005-2010 Free Software Foundation, Inc.
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
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

#ifndef _BFIN_MACHS_H_
#define _BFIN_MACHS_H_

typedef enum model_type {
  MODEL_BF537,
  MODEL_MAX
} MODEL_TYPE;

typedef enum mach_attr {
  MACH_BASE,
  MACH_BFIN,
  MACH_MAX
} MACH_ATTR;

struct bfin_memory_layout {
  address_word addr, len;
  unsigned mask;	/* see mapmask in sim_core_attach() */
};
struct bfin_model_data {
  address_word async_bank_size;
  const struct bfin_memory_layout *mem, *core_mmrs;
  size_t mem_count, core_mmrs_count;
};

#define DEFAULT_MODEL "bf537"

#endif
