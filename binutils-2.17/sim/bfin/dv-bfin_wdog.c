/* Blackfin Watchdog (WDOG) model.

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
#include "dv-sockser.h"
#include "devices.h"
#include "dv-bfin_wdog.h"

/* XXX: Should we bother emulating the TX/RX FIFOs ?  */

struct bfin_wdog
{
  bu32 base;

  /* Order after here is important -- matches hardware MMR layout.  */
  bu16 BFIN_MMR_16(wdog_ctl);
  bu32 wdog_cnt, wdog_stat;
};
#define mmr_base()      offsetof(struct bfin_wdog, wdog_ctl)
#define mmr_offset(mmr) (offsetof(struct bfin_wdog, mmr) - mmr_base())

static bool
bfin_wdog_enabled (struct bfin_wdog *wdog)
{
  return ((wdog->wdog_ctl & WDEN) != WDDIS);
}

static unsigned
bfin_wdog_io_write_buffer (struct hw *me, const void *source,
			   int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_wdog *wdog = hw_data (me);
  bu32 mmr_off;
  bu32 value;
  bu16 *value16p;
  bu32 *value32p;
  void *valuep;

  if (nr_bytes == 4)
    value = dv_load_4 (source);
  else
    value = dv_load_2 (source);

  HW_TRACE ((me, "write to 0x%08lx length %d with 0x%x", (long) addr,
	     (int) nr_bytes, value));

  mmr_off = addr - wdog->base;
  valuep = (void *)((unsigned long)wdog + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  switch (mmr_off)
    {
    case mmr_offset(wdog_ctl):
      dv_w1c_2_partial (value16p, value, WDRO);
      /* XXX: Should enable an event here to handle timeouts.  */
      break;

    case mmr_offset(wdog_cnt):
      /* Writes are discarded when enabeld.  */
      if (!bfin_wdog_enabled (wdog))
	{
	  *value32p = value;
	  /* Writes to CNT preloads the STAT.  */
	  wdog->wdog_stat = wdog->wdog_cnt;
	}
      break;

    case mmr_offset(wdog_stat):
      /* When enabled, writes to STAT reload the counter.  */
      if (bfin_wdog_enabled (wdog))
	wdog->wdog_stat = wdog->wdog_cnt;
      /* XXX: When disabled, are writes just ignored ?  */
      break;
    }

  return nr_bytes;
}

static unsigned
bfin_wdog_io_read_buffer (struct hw *me, void *dest,
			  int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_wdog *wdog = hw_data (me);
  bu32 mmr_off;
  bu16 *value16p;
  bu32 *value32p;
  void *valuep;

  HW_TRACE ((me, "read 0x%08lx length %d", (long) addr, (int) nr_bytes));

  mmr_off = addr - wdog->base;
  valuep = (void *)((unsigned long)wdog + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  switch (mmr_off)
    {
    case mmr_offset(wdog_ctl):
      dv_bfin_require_16 (me, addr, nr_bytes);
      dv_store_2 (dest, *value16p);
      break;

    case mmr_offset(wdog_cnt):
    case mmr_offset(wdog_stat):
      dv_store_4 (dest, *value32p);
      break;
    }

  return nr_bytes;
}

static const struct hw_port_descriptor bfin_wdog_ports[] = {
  { "reset", WDEV_RESET, 0, output_port, },
  { "nmi",   WDEV_NMI,   0, output_port, },
  { "gpi",   WDEV_GPI,   0, output_port, },
};

static void
bfin_wdog_port_event (struct hw *me, int my_port, struct hw *source,
		      int source_port, int level)
{
  struct bfin_wdog *wdog = hw_data (me);
  bu16 wdev;

  wdog->wdog_ctl |= WDRO;
  wdev = (wdog->wdog_ctl & WDEV);
  if (wdev != WDEV_NONE)
    hw_port_event (me, wdev, 1);
}

static void
attach_bfin_wdog_regs (struct hw *me, struct bfin_wdog *wdog)
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

  if (attach_size != BFIN_COREMMR_WDOG_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_COREMMR_WDOG_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  wdog->base = attach_address;
}

static void
bfin_wdog_finish (struct hw *me)
{
  struct bfin_wdog *wdog;

  wdog = HW_ZALLOC (me, struct bfin_wdog);

  set_hw_data (me, wdog);
  set_hw_io_read_buffer (me, bfin_wdog_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_wdog_io_write_buffer);
  set_hw_ports (me, bfin_wdog_ports);
  set_hw_port_event (me, bfin_wdog_port_event);

  attach_bfin_wdog_regs (me, wdog);

  /* Initialize the Watchdog.  */
  wdog->wdog_ctl = WDDIS;
}

const struct hw_descriptor dv_bfin_wdog_descriptor[] = {
  {"bfin_wdog", bfin_wdog_finish,},
  {NULL, NULL},
};
