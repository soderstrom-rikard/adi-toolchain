/* Blackfin Direct Memory Access (DMA) Controller model.

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
#include "hw-device.h"
#include "dv-bfin_dma.h"

struct bfin_dma
{
  bu32 base;
  unsigned ele_size;
  const char *peer;

  /* Order after here is important -- matches hardware MMR layout.  */
  bu32 next_desc_ptr, start_addr;
  bu16 BFIN_MMR_16 (config);
  bu32 _pad0;
  bu16 BFIN_MMR_16 (x_count);
  bs16 BFIN_MMR_16 (x_modify);
  bu16 BFIN_MMR_16 (y_count);
  bs16 BFIN_MMR_16 (y_modify);
  bu32 curr_desc_ptr, curr_addr;
  bu16 BFIN_MMR_16 (irq_status);
  bu16 BFIN_MMR_16 (peripheral_map);
  bu16 BFIN_MMR_16 (curr_x_count);
  bu32 _pad1;
  bu16 BFIN_MMR_16 (curr_y_count);
  bu32 _pad2;
};
#define mmr_base()      offsetof(struct bfin_dma, next_desc_ptr)
#define mmr_offset(mmr) (offsetof(struct bfin_dma, mmr) - mmr_base())

static const char * const mmr_names[] = {
  "NEXT_DESC_PTR", "START_ADDR", "CONFIG", "<INV>", "X_COUNT", "X_MODIFY",
  "Y_COUNT", "Y_MODIFY", "CURR_DESC_PTR", "CURR_ADDR", "IRQ_STATUS",
  "PERIPHERAL_MAP", "CURR_X_COUNT", "<INV>", "CURR_Y_COUNT", "<INV>",
};
#define mmr_name(off) mmr_names[(off) / 4]

static bool
bfin_dma_enabled (struct bfin_dma *dma)
{
  return (dma->config & DMAEN);
}

static struct hw *
bfin_dma_get_peer (struct hw *me, struct bfin_dma *dma)
{
  /* Delay the stub check until when people try to use it.  */
  if (dma->peer == NULL)
    hw_abort (me, "Stub DMA -- missing \"peer\" property");
  return hw_tree_find_device (me, dma->peer);
}

static void
bfin_dma_process_desc (struct hw *me, struct bfin_dma *dma)
{
  switch (dma->config & NDSIZE)
    {
    case 0:
      break;
    default:
      hw_abort (me, "DMA config (NDSIZE) %#x not supported", dma->config);
    }

  switch (dma->config & DMAFLOW)
    {
    case 0:
      break;
    default:
      hw_abort (me, "DMA config (DMAFLOW) %#x not supported", dma->config);
    }

  if (dma->config & DMA2D)
    hw_abort (me, "DMA config (2D) %#x not supported", dma->config);

  switch (dma->config & WDSIZE)
    {
    case WDSIZE_32:
      dma->ele_size = 4;
      break;
    case WDSIZE_16:
      dma->ele_size = 2;
      break;
    default:
      dma->ele_size = 1;
      break;
    }

  if (dma->ele_size != (unsigned)dma->x_modify)
    hw_abort (me, "DMA config (striding) %#x not supported", dma->config);

  dma->curr_addr = dma->start_addr;
  dma->curr_x_count = dma->x_count;
}

/* Chew through the DMA over and over.  */
static void
bfin_dma_hw_event_callback (struct hw *me, void *data)
{
  struct bfin_dma *dma = data;
  struct hw *peer;
  bu8 buf[1024];
  unsigned ret, nr_bytes, ele_count;

  peer = bfin_dma_get_peer (me, dma);
  nr_bytes = MIN (sizeof (buf), dma->curr_x_count * dma->ele_size);

  /* Pumping a chunk!  */
  if (dma->config & WNR)
    {
      ret = hw_dma_read_buffer(peer, buf, 0, 0, nr_bytes);
      /* XXX: How to handle partial DMA transfers ?  */
      /* Has the DMA stalled ?  abort for now.  */
      if (ret != nr_bytes)
	goto error;
      ret = sim_write (hw_system (me), dma->curr_addr, buf, nr_bytes);
    }
  else
    {
      ret = sim_read (hw_system (me), dma->curr_addr, buf, nr_bytes);
      if (ret != nr_bytes)
	goto error;
      ret = hw_dma_write_buffer(peer, buf, 0, 0, nr_bytes, 0);
    }

  /* Ignore partial writes.  */
  ele_count = ret / dma->ele_size;
  dma->curr_addr += ele_count * dma->x_modify;
  dma->curr_x_count -= ele_count;

  if (!dma->curr_x_count)
    {
      /* XXX: This would be the time to process the next descriptor.  */
      /* XXX: Should this toggle Enable in dma->config ?  */
      dma->irq_status = (dma->irq_status & ~DMA_RUN) | DMA_DONE;
    }
  else
    /* Still got work to do, so schedule again.  */
    hw_event_queue_schedule (me, 1, bfin_dma_hw_event_callback, dma);

  return;

 error:
  /* Don't reschedule on errors ...  */
  dma->irq_status |= DMA_ERR;
}

static unsigned
bfin_dma_io_write_buffer (struct hw *me, const void *source,
			  int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_dma *dma = hw_data (me);
  bu32 mmr_off;
  bu32 value;
  bu16 *value16p;
  bu32 *value32p;
  void *valuep;

  if (nr_bytes == 4)
    value = dv_load_4 (source);
  else
    value = dv_load_2 (source);

  mmr_off = addr - dma->base;
  valuep = (void *)((unsigned long)dma + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  HW_TRACE_WRITE ();

  /* XXX: All registers are RO when DMA is enabled (except IRQ_STATUS).
          But does the HW discard writes or send up IVGHW ?  The sim
          simply discards atm ... */
  switch (mmr_off)
    {
    case mmr_offset(next_desc_ptr):
    case mmr_offset(start_addr):
    case mmr_offset(curr_desc_ptr):
    case mmr_offset(curr_addr):
      /* Don't require 32bit access as all DMA MMRs can be used as 16bit.  */
      if (!bfin_dma_enabled (dma))
	{
	  if (nr_bytes == 4)
	    *value32p = value;
	  else
	   *value16p = value;
	}
      break;
    case mmr_offset(x_count):
    case mmr_offset(x_modify):
    case mmr_offset(y_count):
    case mmr_offset(y_modify):
    case mmr_offset(peripheral_map):
      if (!bfin_dma_enabled (dma))
	*value16p = value;
      break;
    case mmr_offset(config):
      if (!bfin_dma_enabled (dma) || !(value & DMAEN))
	{
	  if (nr_bytes == 4)
	    *value32p = value;
	  else
	    *value16p = value;

	  if (bfin_dma_enabled (dma))
	    {
	      dma->irq_status |= DMA_RUN;
	      bfin_dma_process_desc (me, dma);
	      hw_event_queue_schedule (me, 1, bfin_dma_hw_event_callback, dma);
	    }
	}
      break;
    case mmr_offset(irq_status):
      dv_w1c_2 (value16p, value, DMA_DONE | DMA_ERR);
      break;
    case mmr_offset(curr_x_count):
    case mmr_offset(curr_y_count):
      if (!bfin_dma_enabled (dma))
	*value16p = value;
      break;
    default:
      /* XXX: The HW lets the pad regions be read/written ...  */
      /* XXX: This should send up Hardware Error, not Exception ... */
      dv_bfin_invalid_mmr (me, addr, nr_bytes);
      break;
    }

  return nr_bytes;
}

static unsigned
bfin_dma_io_read_buffer (struct hw *me, void *dest,
			 int space, address_word addr, unsigned nr_bytes)
{
  struct bfin_dma *dma = hw_data (me);
  bu32 mmr_off;
  bu32 value;
  bu16 *value16p;
  bu32 *value32p;
  void *valuep;

  mmr_off = addr - dma->base;
  valuep = (void *)((unsigned long)dma + mmr_base() + mmr_off);
  value16p = valuep;
  value32p = valuep;

  HW_TRACE_READ ();

  /* Hardware lets you read all MMRs as 16 or 32 bits, even reserved.  */
  if (nr_bytes == 4)
    dv_store_4 (dest, *value32p);
  else
    dv_store_2 (dest, *value16p);

  return nr_bytes;
}

static unsigned
bfin_dma_hw_dma_read_buffer_method (struct hw *bus, void *dest, int space,
				    unsigned_word addr, unsigned nr_bytes)
{
  struct bfin_dma *dma = hw_data (bus);
  unsigned ret, ele_count;

  /* If someone is trying to read from me, I have to be enabled.  */
  if (!bfin_dma_enabled (dma))
    return 0;

  /* XXX: handle x_modify ...  */
  ret = sim_read (hw_system (bus), dma->curr_addr, dest, nr_bytes);
  /* Ignore partial writes.  */
  ele_count = ret / dma->ele_size;
  /* Has the DMA stalled ?  abort for now.  */
  if (!ele_count)
    return 0;

  dma->curr_addr += ele_count * dma->x_modify;
  dma->curr_x_count -= ele_count;

  /* XXX: Should this toggle Enable in dma->config ?  */
  if (dma->curr_x_count == 0)
    dma->irq_status = (dma->irq_status & ~DMA_RUN) | DMA_DONE;

  return ret;
}

static unsigned
bfin_dma_hw_dma_write_buffer_method (struct hw *bus, const void *source,
				     int space, unsigned_word addr,
				     unsigned nr_bytes,
				     int violate_read_only_section)
{
  struct bfin_dma *dma = hw_data (bus);
  unsigned ret, ele_count;

  /* If someone is trying to write to me, I have to be enabled.  */
  if (!bfin_dma_enabled (dma))
    return 0;

  /* XXX: handle x_modify ...  */
  ret = sim_write (hw_system (bus), dma->curr_addr, source, nr_bytes);
  /* Ignore partial writes.  */
  ele_count = ret / dma->ele_size;
  /* Has the DMA stalled ?  abort for now.  */
  if (!ele_count)
    return 0;

  dma->curr_addr += ele_count * dma->x_modify;
  dma->curr_x_count -= ele_count;

  /* XXX: Should this toggle Enable in dma->config ?  */
  if (dma->curr_x_count == 0)
    dma->irq_status = (dma->irq_status & ~DMA_RUN) | DMA_DONE;

  return ret;
}

static void
attach_bfin_dma_regs (struct hw *me, struct bfin_dma *dma)
{
  address_word attach_address;
  int attach_space;
  unsigned attach_size;
  reg_property_spec reg;

  if (hw_find_property (me, "reg") == NULL)
    hw_abort (me, "Missing \"reg\" property");

  if (!hw_find_reg_array_property (me, "reg", 0, &reg))
    hw_abort (me, "\"reg\" property must contain three addr/size entries");

  if (hw_find_property (me, "peer"))
    {
      dma->peer = hw_find_string_property (me, "peer");
      if (dma->peer == NULL)
        hw_abort (me, "\"peer\" property must name a device");
    }
  else
    {
      /* Ignore for now -- let's people stub things out.  */
      /* hw_abort (me, "Missing \"peer\" property"); */
    }

  hw_unit_address_to_attach_address (hw_parent (me),
				     &reg.address,
				     &attach_space, &attach_address, me);
  hw_unit_size_to_attach_size (hw_parent (me), &reg.size, &attach_size, me);

  if (attach_size != BFIN_MMR_DMA_SIZE)
    hw_abort (me, "\"reg\" size must be %#x", BFIN_MMR_DMA_SIZE);

  hw_attach_address (hw_parent (me),
		     0, attach_space, attach_address, attach_size, me);

  dma->base = attach_address;
}

static void
bfin_dma_finish (struct hw *me)
{
  struct bfin_dma *dma;

  dma = HW_ZALLOC (me, struct bfin_dma);

  set_hw_data (me, dma);
  set_hw_io_read_buffer (me, bfin_dma_io_read_buffer);
  set_hw_io_write_buffer (me, bfin_dma_io_write_buffer);
  set_hw_dma_read_buffer (me, bfin_dma_hw_dma_read_buffer_method);
  set_hw_dma_write_buffer (me, bfin_dma_hw_dma_write_buffer_method);

  /* XXX: A better model might be:
      .../bfin_mdma/
                    src_channel/
                    dst_channel/
     But got to figure out how first ...  */
  attach_bfin_dma_regs (me, dma);
}

const struct hw_descriptor dv_bfin_dma_descriptor[] = {
  {"bfin_dma", bfin_dma_finish,},
  {NULL, NULL},
};
