/* Blackfin device support.

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

#include "sim-main.h"
#include "hw-device.h"
#include "dv-bfin_cec.h"

static bool
bfin_mmr_check (SIM_CPU *cpu, struct hw *me, address_word addr, unsigned nr_bytes)
{
  if (addr >= BFIN_CORE_MMR_BASE)
    {
      /* All Core MMRs are aligned 32bits */
      if ((addr & 3) == 0 && nr_bytes == 4)
	return true;

      /* XXX: is this what hardware does ? */
      if (cpu)
	cec_exception (cpu, VEC_ILL_RES);
      else
	hw_abort (me, "invalid MMR access and cpu is NULL");
    }
  else if (addr >= BFIN_SYSTEM_MMR_BASE)
    {
      /* All System MMRs are aligned 16bits or 32bits */
      if ((addr & 0x1) == 0 && nr_bytes == 2)
	return true;
      if ((addr & 0x3) == 0 && nr_bytes == 4)
	return true;

      /* XXX: is this what hardware does ? */
      if (cpu)
	cec_exception (cpu, VEC_ILL_RES);
      else
	hw_abort (me, "invalid MMR access and cpu is NULL");
    }

  return false;
}

int
device_io_read_buffer (device *me, void *source, int space,
		       address_word addr, unsigned nr_bytes,
		       SIM_DESC sd, SIM_CPU *cpu, sim_cia cia)
{
  struct hw *dv_me = (struct hw *) me;

  if (STATE_ENVIRONMENT (sd) != OPERATING_ENVIRONMENT)
    return nr_bytes;

  if (bfin_mmr_check (cpu, dv_me, addr, nr_bytes))
    return hw_io_read_buffer (dv_me, source, space, addr, nr_bytes);
  else
    return 0;
}

int
device_io_write_buffer (device *me, const void *source, int space,
			address_word addr, unsigned nr_bytes,
                        SIM_DESC sd, SIM_CPU *cpu, sim_cia cia)
{
  struct hw *dv_me = (struct hw *) me;

  if (STATE_ENVIRONMENT (sd) != OPERATING_ENVIRONMENT)
    return nr_bytes;

  if (bfin_mmr_check (cpu, dv_me, addr, nr_bytes))
    return hw_io_write_buffer (dv_me, source, space, addr, nr_bytes);
  else
    return 0;
}

void device_error (device *me, char* message, ...)
{
  /* ... */
}
