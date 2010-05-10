/* Blackfin System Interrupt Controller (SIC) model.

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

#include "config.h"

#include "sim-main.h"
#include "devices.h"
#include "dv-bfin_sic.h"
#include "dv-bfin_cec.h"

struct bfin_sic
{
  bu32 base;

  /* Order after here is important -- matches hardware MMR layout.  */
  /* XXX: This is the 537 SIC.  */
  bu16 BFIN_MMR_16(swrst);
  bu16 BFIN_MMR_16(syscr);
  bu16 BFIN_MMR_16(rvect);
  bu32 imask;
  union {
    bu32 iar[4];
    struct { bu32 iar0, iar1, iar2, iar3; };
  };
  bu32 isr, iwr;
};
#define mmr_base()      offsetof(struct bfin_sic, swrst)
#define mmr_offset(mmr) (offsetof(struct bfin_sic, mmr) - mmr_base())

static const char * const mmr_names[] = {
  "SWRST", "SYSCR", "SIC_RVECT", "SIC_IMASK", "SIC_IAR0", "SIC_IAR1",
  "SIC_IAR2", "SIC_IAR3", "SIC_ISR", "SIC_IWR",
};
#define mmr_name(off) mmr_names[(off) / 4]

static void
bfn_sic_forward_interrupts (struct hw *me, struct bfin_sic *sic)
{
  int my_port;
  bu32 ipend;

  /* Process pending and unmasked interrupts.  */
  ipend = sic->isr & sic->imask;

  /* Usually none are pending unmasked, so avoid bit twiddling.  */
  if (!ipend)
    return;

  for (my_port = 0; my_port < 32; ++my_port)
    {
      bu32 iar_idx, iar_off, iar;
      bu32 bit = (1 << my_port);

      /* This bit isn't pending, so check next one.  */
      if (!(ipend & bit))
	continue;

      /* The IAR registers map the System input to the Core output.
         Every 4 bits in the IAR are used to map to IVG{7..15}.  */
      iar_idx = my_port / 8;
      iar_off = (my_port % 8) * 4;
      iar = (sic->iar[iar_idx] & (0xf << iar_off)) >> iar_off;
      hw_port_event (me, IVG7 + iar, 1);
    }
}

static unsigned
bfin_sic_io_write_buffer (struct hw *me, const void *source,
			  int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_sic *sic = hw_data (me);
  bu32 mmr_off;
  bu32 value;
  bu16 *value16p;
  bu32 *value32p;
  void *valuep;

  if (nr_bytes == 4)
    value = dv_load_4 (source);
  else
    value = dv_load_2 (source);

  mmr_off = addr - sic->base;
  valuep = (void *)((unsigned long)sic + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  HW_TRACE_WRITE ();

  /* XXX: Discard all SIC writes for now.  */
  switch (mmr_off)
    {
    case mmr_offset(swrst):
      /* XXX: This should trigger a software reset ...  */
      break;
    case mmr_offset(syscr):
      /* XXX: what to do ...  */
      break;
    case mmr_offset(imask):
      bfn_sic_forward_interrupts (me, sic);
      *value32p = value;
      break;
    case mmr_offset(iar0):
    case mmr_offset(iar1):
    case mmr_offset(iar2):
    case mmr_offset(iar3):
    case mmr_offset(iwr):
      *value32p = value;
      break;
    case mmr_offset(isr):
      /* ISR is read-only.  */
      break;
    default:
      /* XXX: Should discard other writes.  */
      ;
    }

  return nr_bytes;
}

static unsigned
bfin_sic_io_read_buffer (struct hw *me, void *dest,
			 int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_sic *sic = hw_data (me);
  bu32 mmr_off;
  bu16 *value16p;
  bu32 *value32p;
  void *valuep;

  mmr_off = addr - sic->base;
  valuep = (void *)((unsigned long)sic + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  HW_TRACE_READ ();

  switch (mmr_off)
    {
    case mmr_offset(swrst):
    case mmr_offset(syscr):
    case mmr_offset(rvect):
      dv_store_2 (dest, *value16p);
      break;
    case mmr_offset(imask):
    case mmr_offset(iar0):
    case mmr_offset(iar1):
    case mmr_offset(iar2):
    case mmr_offset(iar3):
    case mmr_offset(isr):
    case mmr_offset(iwr):
      dv_store_4 (dest, *value32p);
      break;
    default:
      if (nr_bytes == 2)
	dv_store_2 (dest, 0);
      else
	dv_store_4 (dest, 0);
      break;
    }

  return nr_bytes;
}

/* XXX: This doesn't handle DMA<->peripheral mappings.  */
static const struct hw_port_descriptor bfin_sic_537_ports[] = {
  { "pll",           0, 0, input_port, },
  { "dma_stat",     10, 0, input_port, },
  { "dmar0_block",  11, 0, input_port, },
  { "dmar1_block",  12, 0, input_port, },
  { "dmar0_over",   13, 0, input_port, },
  { "dmar1_over",   14, 0, input_port, },
  { "can_stat",     20, 0, input_port, },
  { "emac_stat",    21, 0, input_port, },
  { "sport@0_stat", 22, 0, input_port, },
  { "sport@1_stat", 23, 0, input_port, },
  { "ppi_stat",     24, 0, input_port, },
  { "spi_stat",     25, 0, input_port, },
  { "uart@0_stat",  26, 0, input_port, },
  { "uart@1_stat",  27, 0, input_port, },
  { "rtc",          30, 0, input_port, },
  { "dma0",         40, 0, input_port, },
  { "dma3",         50, 0, input_port, },
  { "dma4",         60, 0, input_port, },
  { "dma5",         70, 0, input_port, },
  { "dma6",         80, 0, input_port, },
  { "twi",          90, 0, input_port, },
  { "dma7",        100, 0, input_port, },
  { "dma8",        110, 0, input_port, },
  { "dma9",        120, 0, input_port, },
  { "dma10",       130, 0, input_port, },
  { "dma11",       140, 0, input_port, },
  { "can_rx",      150, 0, input_port, },
  { "can_tx",      160, 0, input_port, },
  { "dma1",        170, 0, input_port, },
  { "porth_irq_a", 171, 0, input_port, },
  { "dma2",        180, 0, input_port, },
  { "porth_irq_b", 181, 0, input_port, },
  { "timer0",      190, 0, input_port, },
  { "timer1",      200, 0, input_port, },
  { "timer0",      210, 0, input_port, },
  { "timer3",      220, 0, input_port, },
  { "timer4",      230, 0, input_port, },
  { "timer5",      240, 0, input_port, },
  { "timer6",      250, 0, input_port, },
  { "timer7",      260, 0, input_port, },
  { "portf_irq_a", 270, 0, input_port, },
  { "portg_irq_a", 271, 0, input_port, },
  { "portg_irq_b", 280, 0, input_port, },
  { "mdma0",       290, 0, input_port, },
  { "mdma1",       300, 0, input_port, },
  { "watchdog",    310, 0, input_port, },
  { "portf_irq_b", 311, 0, input_port, },

  { "ivg7",  IVG7,  0, output_port, },
  { "ivg8",  IVG8,  0, output_port, },
  { "ivg9",  IVG9,  0, output_port, },
  { "ivg10", IVG10, 0, output_port, },
  { "ivg11", IVG11, 0, output_port, },
  { "ivg12", IVG12, 0, output_port, },
  { "ivg13", IVG13, 0, output_port, },
  { "ivg14", IVG14, 0, output_port, },
  { "ivg15", IVG15, 0, output_port, },
};

static void
bfin_sic_537_port_event (struct hw *me, int my_port, struct hw *source,
			 int source_port, int level)
{
  struct bfin_sic *sic = hw_data (me);
  bu32 bit = (1 << (my_port / 10));

  /* SIC only exists to forward interrupts from the system to the CEC.  */
  sic->isr |= bit;

  /* XXX: Handle SIC wakeup source ?
  if (sic->iwr & bit)
    What to do ?;
   */

  bfn_sic_forward_interrupts (me, sic);
}

static void
attach_bfin_sic_regs (struct hw *me, struct bfin_sic *sic)
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

  if (attach_size != BFIN_MMR_SIC_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_MMR_SIC_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  sic->base = attach_address;
}

static void
bfin_sic_finish (struct hw *me)
{
  struct bfin_sic *sic;

  sic = HW_ZALLOC (me, struct bfin_sic);

  set_hw_data (me, sic);
  set_hw_io_read_buffer (me, bfin_sic_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_sic_io_write_buffer);
  set_hw_ports (me, bfin_sic_537_ports);
  set_hw_port_event (me, bfin_sic_537_port_event);

  attach_bfin_sic_regs (me, sic);

  /* Initialize the SIC.  */
  sic->imask = 0x00000000;
  sic->iar0 = 0x22211000;
  sic->iar1 = 0x43333332;
  sic->iar2 = 0x55555444;
  sic->iar3 = 0x66655555;
  sic->isr = 0x00000000;
  sic->iwr = 0xFFFFFFFF;
}

const struct hw_descriptor dv_bfin_sic_descriptor[] = {
  {"bfin_sic", bfin_sic_finish,},
  {NULL, NULL},
};
