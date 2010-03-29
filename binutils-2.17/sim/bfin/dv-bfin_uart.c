/* Blackfin UART model.

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
#include "dv-bfin_uart.h"

/* XXX: Should we bother emulating the TX/RX FIFOs ?  */

struct bfin_uart
{
  bu32 base;

  /* These are aliased to DLL.  */
  bu16 BFIN_MMR_16(thr), BFIN_MMR_16(rbr);
  /* This is aliased to DLH.  */
  bu16 BFIN_MMR_16(ier);

  /* Order after here is important -- matches hardware MMR layout.  */
  bu16 BFIN_MMR_16(dll);
  bu16 BFIN_MMR_16(dlh);
  bu16 BFIN_MMR_16(iir);
  bu16 BFIN_MMR_16(lcr);
  bu16 BFIN_MMR_16(mcr);
  bu16 BFIN_MMR_16(lsr);
  bu16 BFIN_MMR_16(msr);
  bu16 BFIN_MMR_16(scr);
  bu32 _pad0;
  bu16 BFIN_MMR_16(gctl);

  /* XXX: This is for newer UARTs (BF54x)
  bu16 BFIN_MMR_16(gctl);
  bu16 BFIN_MMR_16(lcr);
  bu16 BFIN_MMR_16(mcr);
  bu16 BFIN_MMR_16(lsr);
  bu16 BFIN_MMR_16(msr);
  bu16 BFIN_MMR_16(scr);
  bu16 BFIN_MMR_16(ier_set);
  bu16 BFIN_MMR_16(ier_clear);
  bu16 BFIN_MMR_16(thr);
  bu16 BFIN_MMR_16(rbr);
  */
};
#define mmr_base()      offsetof(struct bfin_uart, dll)
#define mmr_offset(mmr) (offsetof(struct bfin_uart, mmr) - mmr_base())

static unsigned
bfin_uart_io_write_buffer (struct hw *me, const void *source,
			  int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_uart *uart = hw_data (me);
  bu32 mmr_off;
  bu32 value;
  bu16 *valuep;

  value = dv_load_2 (source);

  HW_TRACE ((me, "write to 0x%08lx length %d with 0x%x", (long) addr,
	     (int) nr_bytes, value));

  dv_bfin_require_16 (me, addr, nr_bytes);

  /* XXX: All MMRs are "8bit" ... what happens to high 8bits ?  */

  mmr_off = addr - uart->base;
  valuep = (void *)uart + mmr_base() + mmr_off;

  switch (mmr_off)
    {
    case mmr_offset(dll):
      if (uart->lcr & DLAB)
	uart->dll = value;
      else
	{
	  SIM_DESC sd = hw_system (me);
	  int status = dv_sockser_status (sd);

	  uart->thr = value;

	  if (status & DV_SOCKSER_DISCONNECTED)
	    {
	      char ch = value;
	      sim_io_write_stdout (sd, &ch, 1);
	      sim_io_flush_stdout (sd);
	    }
	  else
	    dv_sockser_write (sd, value);

	  break;
	}
    case mmr_offset(dlh):
      if (uart->lcr & DLAB)
	uart->dlh = value;
      else
	uart->ier = value;
      break;
    case mmr_offset(iir):
    case mmr_offset(lsr):
      /* XXX: Writes are ignored ?  */
      break;
    case mmr_offset(lcr):
    case mmr_offset(mcr):
    case mmr_offset(scr):
    case mmr_offset(gctl):
      *valuep = value;
      break;
    default:
      dv_bfin_invalid_mmr (me, addr, nr_bytes);
      break;
    }

  return nr_bytes;
}

static unsigned
bfin_uart_io_read_buffer (struct hw *me, void *dest,
			 int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_uart *uart = hw_data (me);
  bu32 mmr_off;
  bu16 *valuep;

  HW_TRACE ((me, "read 0x%08lx length %d", (long) addr, (int) nr_bytes));

  dv_bfin_require_16 (me, addr, nr_bytes);

  mmr_off = addr - uart->base;
  valuep = (void *)uart + mmr_base() + mmr_off;

  switch (mmr_off)
    {
    case mmr_offset(dll):
      if (uart->lcr & DLAB)
	dv_store_2 (dest, uart->dll);
      else
	{
	  SIM_DESC sd = hw_system (me);
	  int status = dv_sockser_status (sd);

	  if (!(status & DV_SOCKSER_DISCONNECTED))
	    uart->rbr = dv_sockser_read (sd);

	  dv_store_2 (dest, uart->rbr);
	}
      break;
    case mmr_offset(dlh):
      if (uart->lcr & DLAB)
	dv_store_2 (dest, uart->dlh);
      else
	dv_store_2 (dest, uart->ier);
      break;
    case mmr_offset(lsr):
      {
	/* XXX: Reads are destructive ...  */
	SIM_DESC sd = hw_system (me);
	int status = dv_sockser_status (sd);

	if (status & DV_SOCKSER_DISCONNECTED)
	  /* XXX: Peek/poll stdin ?  */
	  uart->lsr |= TEMT | THRE;
	else
	  uart->lsr |=
		(status & DV_SOCKSER_INPUT_EMPTY ? 0 : DR) |
		(status & DV_SOCKSER_OUTPUT_EMPTY ? TEMT | THRE : 0);

	dv_store_2 (dest, *valuep);
	uart->lsr = 0;

	break;
      }
    case mmr_offset(iir):
      /* XXX: Reads are destructive ...  */
    case mmr_offset(lcr):
    case mmr_offset(mcr):
    case mmr_offset(scr):
    case mmr_offset(gctl):
      dv_store_2 (dest, *valuep);
      break;
    default:
      dv_bfin_invalid_mmr (me, addr, nr_bytes);
      break;
    }

  return nr_bytes;
}

static void
attach_bfin_uart_regs (struct hw *me, struct bfin_uart *uart)
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

  if (attach_size != BFIN_COREMMR_UART_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_COREMMR_UART_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  uart->base = attach_address;
}

static void
bfin_uart_finish (struct hw *me)
{
  struct bfin_uart *uart;

  uart = HW_ZALLOC (me, struct bfin_uart);

  set_hw_data (me, uart);
  set_hw_io_read_buffer (me, bfin_uart_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_uart_io_write_buffer);

  attach_bfin_uart_regs (me, uart);

  /* Initialize the UART.  */
  uart->dll = 0x0001;
  uart->iir = 0x0001;
  uart->lsr = 0x0060;
}

const struct hw_descriptor dv_bfin_uart_descriptor[] = {
  {"bfin_uart", bfin_uart_finish,},
  {NULL},
};
