/* Blackfin Trace (TBUF) model.

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
#include "dv-bfin_trace.h"

/* XXX: This is a stub implementation -- it always returns an empty trace.  */

struct bfin_trace
{
  bu32 base;
  bu32 buffer[32];

  /* Order after here is important -- matches hardware MMR layout.  */
  bu32 tbufctl, tbufstat;
  char _pad[0x100 - 0x8];
  bu32 tbuf;
};
#define mmr_base()      offsetof(struct bfin_trace, tbufctl)
#define mmr_offset(mmr) (offsetof(struct bfin_trace, mmr) - mmr_base())

static unsigned
bfin_trace_io_write_buffer (struct hw *me, const void *source,
			  int space, unsigned_word addr, unsigned nr_bytes)
{
  struct bfin_trace *trace = hw_data (me);
  bu32 value;

  value = dv_load_4 (source);

  HW_TRACE ((me, "write to 0x%08lx length %d with 0x%x", (long) addr,
	     (int) nr_bytes, value));

  switch (addr - trace->base)
    {
    case mmr_offset(tbufctl):
      trace->tbufctl = value;
      break;
    case mmr_offset(tbufstat):
    case mmr_offset(tbuf):
      /* Discard writes to these.  */
      break;
    default:
      dv_bfin_invalid_mmr (me, addr, nr_bytes);
      break;
    }

  return nr_bytes;
}

static unsigned
bfin_trace_io_read_buffer (struct hw *me, void *dest,
			 int space, unsigned_word addr, unsigned nr_bytes)
{
  struct bfin_trace *trace = hw_data (me);
  bu32 value;

  HW_TRACE ((me, "read 0x%08lx length %d", (long) addr, (int) nr_bytes));

  switch (addr - trace->base)
    {
    case mmr_offset(tbufctl):
      value = trace->tbufctl;
    case mmr_offset(tbufstat):
    case mmr_offset(tbuf):
      value = 0;
      break;
    default:
      dv_bfin_invalid_mmr (me, addr, nr_bytes);
      break;
    }

  dv_store_4 (dest, value);

  return nr_bytes;
}

static void
attach_bfin_trace_regs (struct hw *me, struct bfin_trace *trace)
{
  unsigned_word attach_address;
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

  if (attach_size != BFIN_COREMMR_TRACE_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_COREMMR_TRACE_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  trace->base = attach_address;
}

static void
bfin_trace_finish (struct hw *me)
{
  struct bfin_trace *trace;

  trace = HW_ZALLOC (me, struct bfin_trace);

  set_hw_data (me, trace);
  set_hw_io_read_buffer (me, bfin_trace_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_trace_io_write_buffer);

  attach_bfin_trace_regs (me, trace);
}

const struct hw_descriptor dv_bfin_trace_descriptor[] = {
  {"bfin_trace", bfin_trace_finish,},
  {NULL},
};
