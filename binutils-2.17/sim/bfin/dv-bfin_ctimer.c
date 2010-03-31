/* Blackfin Core Timer model.

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
#include "dv-bfin_ctimer.h"

struct bfin_ctimer
{
  bu32 base;

  /* Order after here is important -- matches hardware MMR layout.  */
  bu32 tcntl, tperiod, tscale, tcount;
};
#define mmr_base()      offsetof(struct bfin_ctimer, tcntl)
#define mmr_offset(mmr) (offsetof(struct bfin_ctimer, mmr) - mmr_base())

static unsigned
bfin_ctimer_io_write_buffer (struct hw *me, const void *source,
			  int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_ctimer *ctimer = hw_data (me);
  bu32 mmr_off;
  bu32 value;
  bu32 *valuep;

  value = dv_load_4 (source);

  HW_TRACE ((me, "write to 0x%08lx length %d with 0x%x", (long) addr,
	     (int) nr_bytes, value));

  mmr_off = addr - ctimer->base;
  valuep = (void *)ctimer + mmr_base() + mmr_off;

  switch (mmr_off)
    {
    case mmr_offset(tcount):
    case mmr_offset(tperiod):
    default:
      *valuep = value;
      break;
    }

  return nr_bytes;
}

static unsigned
bfin_ctimer_io_read_buffer (struct hw *me, void *dest,
			 int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_ctimer *ctimer = hw_data (me);
  bu32 mmr_off;
  bu32 *valuep;

  HW_TRACE ((me, "read 0x%08lx length %d", (long) addr, (int) nr_bytes));

  mmr_off = addr - ctimer->base;
  valuep = (void *)ctimer + mmr_base() + mmr_off;

  dv_store_4 (dest, *valuep);

  return nr_bytes;
}

static void
attach_bfin_ctimer_regs (struct hw *me, struct bfin_ctimer *ctimer)
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

  if (attach_size != BFIN_COREMMR_CTIMER_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_COREMMR_CTIMER_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  ctimer->base = attach_address;
}

static void
bfin_ctimer_finish (struct hw *me)
{
  struct bfin_ctimer *ctimer;

  ctimer = HW_ZALLOC (me, struct bfin_ctimer);

  set_hw_data (me, ctimer);
  set_hw_io_read_buffer (me, bfin_ctimer_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_ctimer_io_write_buffer);

  attach_bfin_ctimer_regs (me, ctimer);

  /* Initialize the Core Timer.  */
}

const struct hw_descriptor dv_bfin_ctimer_descriptor[] = {
  {"bfin_ctimer", bfin_ctimer_finish,},
  {NULL, NULL},
};
