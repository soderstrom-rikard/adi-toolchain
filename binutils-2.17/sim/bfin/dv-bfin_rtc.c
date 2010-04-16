/* Blackfin Real Time Clock (RTC) model.

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

#include <time.h>
#include "sim-main.h"
#include "dv-sockser.h"
#include "devices.h"
#include "dv-bfin_rtc.h"

/* XXX: This read-only stub setup is based on host system clock.  */

struct bfin_rtc
{
  bu32 base;
  bu32 stat_shadow;

  /* Order after here is important -- matches hardware MMR layout.  */
  bu32 rtc_stat;
  bu16 BFIN_MMR_16(rtc_ictl);
  bu16 BFIN_MMR_16(rtc_istat);
  bu16 BFIN_MMR_16(rtc_swcnt);
  bu32 rtc_alarm;
  bu16 BFIN_MMR_16(rtc_pren);
};
#define mmr_base()      offsetof(struct bfin_rtc, rtc_stat)
#define mmr_offset(mmr) (offsetof(struct bfin_rtc, mmr) - mmr_base())

static unsigned
bfin_rtc_io_write_buffer (struct hw *me, const void *source,
			  int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_rtc *rtc = hw_data (me);
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

  mmr_off = addr - rtc->base;
  valuep = (void *)((unsigned long)rtc + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  /* XXX: These probably need more work.  */
  switch (mmr_off)
    {
    case mmr_offset(rtc_stat):
      /* XXX: Ignore these since we are wired to host.  */
      break;
    case mmr_offset(rtc_istat):
      dv_w1c_2 (value16p, value, 1 << 14);
      break;
    case mmr_offset(rtc_alarm):
      break;
    case mmr_offset(rtc_ictl):
      /* XXX: This should schedule an event handler.  */
    case mmr_offset(rtc_swcnt):
    case mmr_offset(rtc_pren):
      break;
    }

  return nr_bytes;
}

static unsigned
bfin_rtc_io_read_buffer (struct hw *me, void *dest,
			 int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_rtc *rtc = hw_data (me);
  bu32 mmr_off;
  bu16 *value16p;
  bu32 *value32p;
  void *valuep;

  HW_TRACE ((me, "read 0x%08lx length %d", (long) addr, (int) nr_bytes));

  mmr_off = addr - rtc->base;
  valuep = (void *)((unsigned long)rtc + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  switch (mmr_off)
    {
    case mmr_offset(rtc_stat):
      {
	time_t t = time (NULL);
	struct tm *tm = localtime (&t);
	bu32 value =
	  (((tm->tm_year - 70) * 365 + tm->tm_yday) << 17) |
	  (tm->tm_hour << 12) |
	  (tm->tm_min << 6) |
	  (tm->tm_sec << 0);
	dv_store_4 (dest, value);
	break;
      }
    case mmr_offset(rtc_alarm):
      dv_store_4 (dest, *value32p);
      break;
    case mmr_offset(rtc_istat):
    case mmr_offset(rtc_ictl):
    case mmr_offset(rtc_swcnt):
    case mmr_offset(rtc_pren):
      dv_store_2 (dest, *value16p);
      break;
    }

  return nr_bytes;
}

static void
attach_bfin_rtc_regs (struct hw *me, struct bfin_rtc *rtc)
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

  if (attach_size != BFIN_MMR_RTC_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_MMR_RTC_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  rtc->base = attach_address;
}

static void
bfin_rtc_finish (struct hw *me)
{
  struct bfin_rtc *rtc;

  rtc = HW_ZALLOC (me, struct bfin_rtc);

  set_hw_data (me, rtc);
  set_hw_io_read_buffer (me, bfin_rtc_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_rtc_io_write_buffer);

  attach_bfin_rtc_regs (me, rtc);

  /* Initialize the RTC.  */
}

const struct hw_descriptor dv_bfin_rtc_descriptor[] = {
  {"bfin_rtc", bfin_rtc_finish,},
  {NULL, NULL},
};
