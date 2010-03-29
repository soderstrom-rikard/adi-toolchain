/* Blackfin Event Vector Table (EVT) model.

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
#include "devices.h"
#include "dv-bfin_cec.h"
#include "dv-bfin_evt.h"

struct bfin_evt
{
  bu32 base;
  bu32 evt[16];
};

static unsigned
bfin_evt_io_write_buffer (struct hw *me, const void *source,
			  int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_evt *evt = hw_data (me);
  bu32 value;

  value = dv_load_4 (source);

  HW_TRACE ((me, "write to 0x%08lx length %d with 0x%x", (long) addr,
	     (int) nr_bytes, value));

  evt->evt[(addr - evt->base) / 4] = value;

  return nr_bytes;
}

static unsigned
bfin_evt_io_read_buffer (struct hw *me, void *dest,
			 int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_evt *evt = hw_data (me);
  bu32 value;

  HW_TRACE ((me, "read 0x%08lx length %d", (long) addr, (int) nr_bytes));

  value = evt->evt[(addr - evt->base) / 4];

  dv_store_4 (dest, value);

  return nr_bytes;
}

static void
attach_bfin_evt_regs (struct hw *me, struct bfin_evt *evt)
{
  address_word attach_address;
  int attach_space;
  unsigned attach_size;
  reg_property_spec reg;

  if (hw_find_property (me, "reg") == NULL)
    hw_abort (me, "Missing \"reg\" property");

  if (!hw_find_reg_array_property (me, "reg", 0, &reg))
    hw_abort (me, "\"reg\" property must contain three addr/size entries");

  hw_unit_address_to_attach_address (hw_parent (me),
				     &reg.address,
				     &attach_space, &attach_address, me);
  hw_unit_size_to_attach_size (hw_parent (me), &reg.size, &attach_size, me);

  if (attach_size != BFIN_COREMMR_EVT_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_COREMMR_EVT_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  evt->base = attach_address;
}

static void
bfin_evt_finish (struct hw *me)
{
  struct bfin_evt *evt;

  evt = HW_ZALLOC (me, struct bfin_evt);

  set_hw_data (me, evt);
  set_hw_io_read_buffer (me, bfin_evt_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_evt_io_write_buffer);

  attach_bfin_evt_regs (me, evt);
}

const struct hw_descriptor dv_bfin_evt_descriptor[] = {
  {"bfin_evt", bfin_evt_finish,},
  {NULL},
};

#define EVT_STATE(cpu) ((struct bfin_evt *) dv_get_state (cpu, "/core/bfin_evt"))

void
cec_set_evt (SIM_CPU *cpu, int ivg, bu32 handler_addr)
{
  if (ivg > IVG15 || ivg < 0)
    sim_io_error (CPU_STATE (cpu), "%s: ivg %i out of range !", __func__, ivg);

  EVT_STATE (cpu)->evt[ivg] = handler_addr;
}

bu32
cec_get_evt (SIM_CPU *cpu, int ivg)
{
  if (ivg > IVG15 || ivg < 0)
    sim_io_error (CPU_STATE (cpu), "%s: ivg %i out of range !", __func__, ivg);

  return EVT_STATE (cpu)->evt[ivg];
}

bu32
cec_get_reset_evt (SIM_CPU *cpu)
{
  /* XXX: This should tail into the model to get via BMODE pins.  */
  return 0xef000000;
}
