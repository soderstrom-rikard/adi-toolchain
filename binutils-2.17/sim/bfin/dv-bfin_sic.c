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
  bu16 BFIN_MMR_16(sic_rvect);
  bu32 sic_imask;
  union {
    bu32 sic_iar[4];
    struct { bu32 sic_iar0, sic_iar1, sic_iar2, sic_iar3; };
  };
  bu32 sic_isr, sic_iwr;
};
#define mmr_base()      offsetof(struct bfin_sic, swrst)
#define mmr_offset(mmr) (offsetof(struct bfin_sic, mmr) - mmr_base())

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

  HW_TRACE ((me, "write to 0x%08lx length %d with 0x%x", (long) addr,
	     (int) nr_bytes, value));

  mmr_off = addr - sic->base;
  valuep = (void *)((unsigned long)sic + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  /* XXX: Discard all SIC writes for now.  */
  switch (mmr_off)
    {
    case mmr_offset(swrst):
      /* XXX: This should trigger a software reset ...  */
      break;
    case mmr_offset(syscr):
      /* XXX: what to do ...  */
      break;
    case mmr_offset(sic_imask):
      /* XXX: See if there are any pending interrupts.  */
    case mmr_offset(sic_iar0):
    case mmr_offset(sic_iar1):
    case mmr_offset(sic_iar2):
    case mmr_offset(sic_iar3):
    case mmr_offset(sic_iwr):
      *value32p = value;
      break;
    case mmr_offset(sic_isr):
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
  bu32 *valuep;

  HW_TRACE ((me, "read 0x%08lx length %d", (long) addr, (int) nr_bytes));

  mmr_off = addr - sic->base;
  valuep = (void *)((unsigned long)sic + mmr_base() + mmr_off);

  switch (mmr_off)
    {
    case mmr_offset(swrst):
    case mmr_offset(syscr):
      dv_store_4 (dest, *valuep);
      break;
    default:
      dv_store_4 (dest, 0);
    }

  return nr_bytes;
}

/* XXX: This doesn't handle DMA<->peripheral mappings.  */
static const struct hw_port_descriptor bfin_sic_537_ports[] = {
  { "pll",             0, 0, input_port, },
  { "dma_err",         1, 0, input_port, },
  { "dmar0_block",     1, 0, input_port, },
  { "dmar1_block",     1, 0, input_port, },
  { "dmar0_over",      1, 0, input_port, },
  { "dmar1_over",      1, 0, input_port, },
  { "can_err",         2, 0, input_port, },
  { "mac_err",         2, 0, input_port, },
  { "sport0_err",      2, 0, input_port, },
  { "sport1_err",      2, 0, input_port, },
  { "ppi_err",         2, 0, input_port, },
  { "spi_err",         2, 0, input_port, },
  { "uart0_err",       2, 0, input_port, },
  { "uart1_err",       2, 0, input_port, },
  { "rtc",             3, 0, input_port, },
  { "ppi_dma0",        4, 0, input_port, },
  { "sport0_rx_dma3",  5, 0, input_port, },
  { "sport0_tx_dma4",  6, 0, input_port, },
  { "sport1_rx_dma5",  7, 0, input_port, },
  { "sport1_rx_dma6",  8, 0, input_port, },
  { "twi",             9, 0, input_port, },
  { "spi_dma7",       10, 0, input_port, },
  { "uart0_rx_dma8",  11, 0, input_port, },
  { "uart0_tx_dma9",  12, 0, input_port, },
  { "uart1_rx_dma10", 13, 0, input_port, },
  { "uart1_tx_dma11", 14, 0, input_port, },
  { "can_rx",         15, 0, input_port, },
  { "can_tx",         16, 0, input_port, },
  { "mac_rx_dma1",    17, 0, input_port, },
  { "porth_irq_a",    17, 0, input_port, },
  { "mac_tx_dma2",    18, 0, input_port, },
  { "porth_irq_b",    18, 0, input_port, },
  { "timer0",         19, 0, input_port, },
  { "timer1",         20, 0, input_port, },
  { "timer0",         21, 0, input_port, },
  { "timer3",         22, 0, input_port, },
  { "timer4",         23, 0, input_port, },
  { "timer5",         24, 0, input_port, },
  { "timer6",         25, 0, input_port, },
  { "timer7",         26, 0, input_port, },
  { "portf_irq_a",    27, 0, input_port, },
  { "portg_irq_a",    27, 0, input_port, },
  { "portg_irq_b",    28, 0, input_port, },
  { "mdma0",          29, 0, input_port, },
  { "mdma1",          30, 0, input_port, },
  { "watchdog",       31, 0, input_port, },
  { "portf_irq_b",    31, 0, input_port, },

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
  bu32 bit = (1 << my_port);
  bu32 iar_idx, iar_off, iar;

  /* SIC only exists to forward interrupts from the system to the CEC.  */
  sic->sic_isr |= bit;

  /* XXX: Handle SIC wakeup source ?
  if (sic->sic_iwr & bit)
    What to do ?;
   */

  /* It's masked, so return.  */
  if (!(sic->sic_imask & bit))
    return;

  /* The IAR registers map the System input to the Core output.
     Every 4 bits in the IAR are used to map to IVG{7..15}.  */
  iar_idx = my_port / 8;
  iar_off = (my_port % 8) * 4;
  iar = (sic->sic_iar[iar_idx] & (0xf << iar_off)) >> iar_off;
  hw_port_event (me, IVG7 + iar, 1);
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
  sic->sic_imask = 0x00000000;
  sic->sic_iar0 = 0x22211000;
  sic->sic_iar1 = 0x43333332;
  sic->sic_iar2 = 0x55555444;
  sic->sic_iar3 = 0x66655555;
  sic->sic_isr = 0x00000000;
  sic->sic_iwr = 0xFFFFFFFF;
}

const struct hw_descriptor dv_bfin_sic_descriptor[] = {
  {"bfin_sic", bfin_sic_finish,},
  {NULL, NULL},
};
