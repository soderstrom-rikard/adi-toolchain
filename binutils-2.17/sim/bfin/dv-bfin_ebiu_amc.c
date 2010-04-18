/* Blackfin External Bus Interface Unit (EBIU) Asynchronous Memory Controller
   (AMC) model.

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
#include "dv-bfin_ebiu_amc.h"

struct bfin_ebiu_amc
{
  bu32 base, reg_size, bank_size;

  /* Order after here is important -- matches hardware MMR layout.  */
  bu16 BFIN_MMR_16(amgctl);
  bu32 ambctl0, ambctl1;
  /* Newer controllers offer these.  */
  bu32 BFIN_MMR_16(mbsctl);
  bu32 arbstat, mode;
  bu16 BFIN_MMR_16(fctl);
};
#define mmr_base()      offsetof(struct bfin_ebiu_amc, amgctl)
#define mmr_offset(mmr) (offsetof(struct bfin_ebiu_amc, mmr) - mmr_base())

static const char * const mmr_names[] = {
  "AMGCTL", "AMBCTL0", "AMBCTL1", "MSBCTL", "ARBSTAT", "MODE", "FCTL",
};
#define mmr_name(off) mmr_names[(off) / 4]

static void
bfin_ebiu_amc_write_amgctl (struct hw *me, struct bfin_ebiu_amc *amc,
			    bu16 amgctl)
{
  int old_cnt, new_cnt;
  bu32 old_size, new_size;

  old_cnt = MIN ((amc->amgctl >> 1) & 0x7, 4);
  new_cnt = MIN ((amgctl >> 1) & 0x7, 4);
  old_size = old_cnt * amc->bank_size;
  new_size = new_cnt * amc->bank_size;

  amc->amgctl = amgctl;

#if 0
  /* XXX: be nice if this was realloc() ...  */
  if (old_cnt)
    hw_detach_address (hw_parent (me), 0, 0, 

    hw_attach_address (hw_parent (me), 0, 0, BFIN_ASYNC_BASE, new_size, me);
		     0, attach_space, attach_address, attach_size, me);
    hw_attach_address (me, BFIN_ASYNC_BASE
#endif
}

static unsigned
bfin_ebiu_amc_io_write_buffer (struct hw *me, const void *source,
			       int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_ebiu_amc *amc = hw_data (me);
  bu32 mmr_off;
  bu32 value;

  value = dv_load_4 (source);
  mmr_off = addr - amc->base;

  HW_TRACE_WRITE ();

  switch (mmr_off)
    {
    case mmr_offset(amgctl):
      dv_bfin_mmr_require_16 (me, addr, nr_bytes);
      bfin_ebiu_amc_write_amgctl (me, amc, value);
      break;
    case mmr_offset(ambctl0):
      amc->ambctl0 = value;
      break;
    case mmr_offset(ambctl1):
      amc->ambctl1 = value;
      break;
    case mmr_offset(mbsctl):
      /* XXX: implement this.  */
      dv_bfin_mmr_require_16 (me, addr, nr_bytes);
      break;
    case mmr_offset(arbstat):
      /* XXX: implement this.  */
      break;
    case mmr_offset(mode):
      /* XXX: implement this.  */
      break;
    case mmr_offset(fctl):
      /* XXX: implement this.  */
      dv_bfin_mmr_require_16 (me, addr, nr_bytes);
      break;
    default:
      dv_bfin_mmr_invalid (me, addr, nr_bytes);
      break;
    }

  return nr_bytes;
}

static unsigned
bfin_ebiu_amc_io_read_buffer (struct hw *me, void *dest,
			      int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_ebiu_amc *amc = hw_data (me);
  bu32 mmr_off;
  bu32 *value32;
  bu16 *value16;
  void *valuep;

  mmr_off = addr - amc->base;
  valuep = (void *)((unsigned long)amc + mmr_base() + mmr_off);
  value16 = valuep;
  value32 = valuep;

  HW_TRACE_READ ();

  switch (mmr_off)
    {
    case mmr_offset(amgctl):
    case mmr_offset(mbsctl):
    case mmr_offset(fctl):
      dv_bfin_mmr_require_16 (me, addr, nr_bytes);
      dv_store_2 (dest, *value16);
      break;
    case mmr_offset(ambctl0):
    case mmr_offset(ambctl1):
    case mmr_offset(arbstat):
    case mmr_offset(mode):
      dv_store_4 (dest, *value32);
      break;
    default:
      dv_bfin_mmr_invalid (me, addr, nr_bytes);
      break;
    }

  return nr_bytes;
}

static void
attach_bfin_ebiu_amc_regs (struct hw *me, struct bfin_ebiu_amc *amc)
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

  if (attach_size != BFIN_MMR_EBIU_AMC_SIZE &&
      attach_size != BF54X_MMR_EBIU_AMC_SIZE)
    hw_abort (me, "\"reg\" size must be %#x or %#x",
	      BFIN_MMR_EBIU_AMC_SIZE, BF54X_MMR_EBIU_AMC_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  amc->base = attach_address;
  amc->reg_size = attach_size;
  /* XXX: This is 16MB on some parts.  */
  amc->bank_size = 1 * 1024 * 1024;
}

static void
bfin_ebiu_amc_finish (struct hw *me)
{
  struct bfin_ebiu_amc *amc;

  amc = HW_ZALLOC (me, struct bfin_ebiu_amc);

  set_hw_data (me, amc);
  set_hw_io_read_buffer (me, bfin_ebiu_amc_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_ebiu_amc_io_write_buffer);

  attach_bfin_ebiu_amc_regs (me, amc);

  /* Initialize the AMC.  */
  bfin_ebiu_amc_write_amgctl (me, amc, 0x00f2);
  amc->ambctl0 = amc->ambctl1 = 0xffc2ffc2;
  if (amc->reg_size == BF54X_MMR_EBIU_AMC_SIZE)
    {
      /* XXX: init these ...  */
    }
}

const struct hw_descriptor dv_bfin_ebiu_amc_descriptor[] = {
  {"bfin_ebiu_amc", bfin_ebiu_amc_finish,},
  {NULL, NULL},
};
