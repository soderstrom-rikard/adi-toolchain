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
#define P(n) MODEL_BF##n,
#include "_proc_list.h"
#undef P
  MODEL_MAX
} MODEL_TYPE;

typedef enum mach_attr {
  MACH_BASE,
  MACH_BFIN,
  MACH_MAX
} MACH_ATTR;

void bfin_model_cpu_init (SIM_DESC, SIM_CPU *);
bu32 bfin_model_get_chipid (SIM_DESC);
bu32 bfin_model_get_dspid (SIM_DESC);

#endif
