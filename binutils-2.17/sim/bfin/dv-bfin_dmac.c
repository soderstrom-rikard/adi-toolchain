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

#include "config.h"

#include "sim-main.h"
#include "sim-hw.h"
#include "devices.h"
#include "hw-device.h"
#include "dv-bfin_dma.h"
#include "dv-bfin_dmac.h"

struct bfin_dmac
{
  /* This top portion matches common dv_bfin struct.  */
  bu32 base;
  struct hw *dma_master;
  bool acked;

  const char **pmap;
  unsigned int pmap_count;
  const unsigned int *mdma_map;
  unsigned int mdma_count;
};

struct hw *
bfin_dmac_get_peer (struct hw *dma, bu16 pmap)
{
  struct hw *ret, *me;
  struct bfin_dmac *dmac;
  char peer[100];

  me = hw_parent (dma);
  dmac = hw_data (me);
  if (pmap & CTYPE)
    {
      /* MDMA channel.  */
      unsigned int chan_num = dv_get_bus_num (dma);
      if (chan_num < dmac->mdma_count && dmac->mdma_map[chan_num])
	chan_num = dmac->mdma_map[chan_num];
      else
	hw_abort (me, "No map for mdma channel %i", chan_num);
      sprintf (peer, "%s/bfin_dma@%u", hw_path (me), chan_num);
    }
  else
    {
      unsigned int idx = pmap >> 12;
      if (idx >= dmac->pmap_count)
	hw_abort (me, "Invalid DMA peripheral_map %#x", pmap);
      else
	sprintf (peer, "/core/bfin_%s", dmac->pmap[idx]);
    }

  ret = hw_tree_find_device (me, peer);
  if (!ret)
    hw_abort (me, "Unable to locate peer for %s (%#x)", hw_name (dma), pmap);
  return ret;
}

bu16
bfin_dmac_default_pmap (struct hw *dma)
{
  struct hw *me = hw_parent (dma);
  struct bfin_dmac *dmac = hw_data (me);
  unsigned int chan_num = dv_get_bus_num (dma);
  if (chan_num < dmac->pmap_count)
    return chan_num << 12;
  else
    return CTYPE;	/* MDMA */
}

static const unsigned int bfin_dmac_537_mdma_map[] = {
  /* MDMA0 */
  [12] = 13,
  [13] = 12,
  /* MDMA1 */
  [14] = 15,
  [15] = 14,
};

static const char *bfin_dmac_537_pmap[] = {
  "ppi", "emac", "emac", "sport@0", "sport@0", "sport@1",
  "sport@1", "spi", "uart@0", "uart@0", "uart@1", "uart@1",
};

static const struct hw_port_descriptor bfin_dmac_537_ports[] = {
  { "ppi",         0, 0, input_port, },
  { "emac_rx",     1, 0, input_port, },
  { "emac_tx",     2, 0, input_port, },
  { "sport@0_tx",  3, 0, input_port, },
  { "sport@0_rx",  4, 0, input_port, },
  { "sport@1_tx",  5, 0, input_port, },
  { "sport@1_rx",  6, 0, input_port, },
  { "spi",         7, 0, input_port, },
  { "uart@0_tx",   8, 0, input_port, },
  { "uart@0_rx",   9, 0, input_port, },
  { "uart@1_tx",  10, 0, input_port, },
  { "uart@1_rx",  11, 0, input_port, },
};

static void
bfin_dmac_port_event (struct hw *me, int my_port, struct hw *source,
		      int source_port, int level)
{
  SIM_DESC sd = hw_system (me);
  struct bfin_dmac *dmac = hw_data (me);
  struct hw *dma = hw_child (me);

  while (dma)
    {
      bu16 pmap;
      sim_hw_io_read_buffer (sd, dma, &pmap, 0, 0x2c, sizeof (pmap));
      pmap >>= 12;
      if (pmap == my_port)
	break;
      dma = hw_sibling (dma);
    }

  if (!dma)
    hw_abort (me, "no valid dma mapping found for %s", dmac->pmap[my_port]);

  /* Have the DMA channel raise its interrupt to the SIC.  */
  hw_port_event (dma, 0, 1);
}

static void
bfin_dmac_finish (struct hw *me)
{
  struct bfin_dmac *dmac;

  dmac = HW_ZALLOC (me, struct bfin_dmac);

  set_hw_data (me, dmac);
  set_hw_port_event (me, bfin_dmac_port_event);

  /* Initialize the DMA Controller.  */
  if (hw_find_property (me, "type") == NULL)
    hw_abort (me, "Missing \"type\" property");

  switch (hw_find_integer_property (me, "type"))
    {
    case 534:
    case 536:
    case 537:
      dmac->pmap = bfin_dmac_537_pmap;
      dmac->pmap_count = ARRAY_SIZE (bfin_dmac_537_pmap);
      dmac->mdma_map = bfin_dmac_537_mdma_map;
      dmac->mdma_count = ARRAY_SIZE (bfin_dmac_537_mdma_map);
      set_hw_ports (me, bfin_dmac_537_ports);
      break;
    default:
      hw_abort (me, "no support for DMAC on this Blackfin model yet");
    }
}

const struct hw_descriptor dv_bfin_dmac_descriptor[] = {
  {"bfin_dmac", bfin_dmac_finish,},
  {NULL, NULL},
};
