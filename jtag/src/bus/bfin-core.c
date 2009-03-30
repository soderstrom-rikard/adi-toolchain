/*
 * bfin-core.c
 *
 * Analog Devices Blackfin bus driver via CORE
 * Copyright (C) 2008 Analog Devices, Inc.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Written by Jie Zhang <jie.zhang@analog.com>, 2008.
 */

#include "sysdep.h"

#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#include "part.h"
#include "bus.h"
#include "chain.h"
#include "bssignal.h"
#include "jtag.h"
#include "buses.h"
#include "generic_bus.h"
#include "bfin.h"

typedef struct {
	uint32_t r0;
	uint32_t p0;
	int ebiu_amctl_initialized;
} bus_params_t;

#define R0	((bus_params_t *) bus->params)->r0
#define P0	((bus_params_t *) bus->params)->p0
#define EBIU_AMCTL_INITIALIZED ((bus_params_t *) bus->params)->ebiu_amctl_initialized

/**
 * bus->driver->(*new_bus)
 *
 */
static bus_t *
bfin_core_bus_new( chain_t *chain, const bus_driver_t *driver, char *cmd_params[] )
{
	bus_t *bus;
	part_t *part;

	bus = calloc( 1, sizeof (bus_t) );
	if (!bus)
		return NULL;

	bus->driver = driver;
	bus->params = calloc( 1, sizeof (bus_params_t) );
	if (!bus->params) {
		free( bus );
		return NULL;
	}
	EBIU_AMCTL_INITIALIZED = 0;

	CHAIN = chain;
	PART = part = chain->parts->parts[chain->active_part];

	return bus;
}

/**
 * bus->driver->(*printinfo)
 *
 */
static void
bfin_core_bus_printinfo( bus_t *bus )
{
	int i;

	for (i = 0; i < CHAIN->parts->len; i++)
		if (PART == CHAIN->parts->parts[i])
			break;
	printf( _("Blackfin bus driver via CORE (JTAG part No. %d)\n"), i );
}

/**
 * bus->driver->(*area)
 *
 */
static int
bfin_core_bus_area( bus_t *bus, uint32_t adr, bus_area_t *area )
{
	area->description = NULL;
	area->start = UINT32_C(0x00000000);
	area->length = UINT64_C(0x100000000);
	area->width = 16;

	return 0;
}

#define EBIU_AMGCTL 0xFFC00A00
#define EBIU_AMBCTL0 0XFFC00A04
#define EBIU_AMBCTL1 0xFFC00A08

#define CONFIG_EBIU_AMGCTL_VAL  0x01F9
#define CONFIG_EBIU_AMBCTL0_VAL 0x7BB07BB0
#define CONFIG_EBIU_AMBCTL1_VAL 0x99b27BB0

/**
 * bus->driver->(*read_start)
 *
 */
static void
bfin_core_bus_read_start( bus_t *bus, uint32_t adr )
{
	chain_t *chain = CHAIN;

	assert ((adr & 0x1) == 0);

	P0 = part_get_p0 (chain, chain->main_part);
	R0 = part_get_r0 (chain, chain->main_part);

	if (EBIU_AMCTL_INITIALIZED == 0)
	  {
	    part_set_p0 (chain, chain->main_part, EBIU_AMGCTL);
	    part_mmr_write_clobber_r0 (chain,
				       chain->main_part,
				       EBIU_AMBCTL0 - EBIU_AMGCTL,
				       CONFIG_EBIU_AMBCTL0_VAL,
				       4);
	    part_mmr_write_clobber_r0 (chain,
				       chain->main_part,
				       EBIU_AMBCTL1 - EBIU_AMGCTL,
				       CONFIG_EBIU_AMBCTL1_VAL,
				       4);
	    part_mmr_write_clobber_r0 (chain,
				       chain->main_part,
				       0,
				       CONFIG_EBIU_AMGCTL_VAL,
				       2);
	    EBIU_AMCTL_INITIALIZED = 1;
	  }

	part_set_p0 (chain, chain->main_part, adr);
	part_scan_select (chain, chain->main_part, DBGCTL_SCAN);
	part_dbgctl_bit_set_emuirlpsz_2 (chain, chain->main_part);
	chain_shift_data_registers_mode (chain, 0, 1, EXITMODE_UPDATE);

	part_emuir_set_2 (chain, chain->main_part, gen_load16zpi (REG_R0, REG_P0),
			  gen_move (REG_EMUDAT, REG_R0), EXITMODE_UPDATE);
}

/**
 * bus->driver->(*read_next)
 *
 */
static uint32_t
bfin_core_bus_read_next( bus_t *bus, uint32_t adr )
{
	chain_t *chain = CHAIN;
	uint32_t d = 0;

	d = part_emudat_get (chain, chain->main_part, EXITMODE_IDLE);

	return d;
}

/**
 * bus->driver->(*read_end)
 *
 */
static uint32_t
bfin_core_bus_read_end( bus_t *bus )
{
	chain_t *chain = CHAIN;
	uint32_t d = 0;

	d = part_emudat_get (chain, chain->main_part, EXITMODE_IDLE);

	part_scan_select (chain, chain->main_part, DBGCTL_SCAN);
	part_dbgctl_bit_clear_emuirlpsz_2 (chain, chain->main_part);
	chain_shift_data_registers_mode (chain, 0, 1, EXITMODE_UPDATE);

	part_emuir_set (chain, chain->main_part, INSN_NOP, EXITMODE_UPDATE);

	part_set_p0 (chain, chain->main_part, P0);
	part_set_r0 (chain, chain->main_part, R0);

	return d;
}

/**
 * bus->driver->(*write_start)
 *
 */
static void
bfin_core_bus_write (bus_t *bus, uint32_t adr, uint32_t data)
{
	chain_t *chain = CHAIN;

	assert ((adr & 0x1) == 0);
	P0 = part_get_p0 (chain, chain->main_part);
	R0 = part_get_r0 (chain, chain->main_part);

	if (EBIU_AMCTL_INITIALIZED == 0)
	  {
	    part_set_p0 (chain, chain->main_part, EBIU_AMGCTL);
	    part_mmr_write_clobber_r0 (chain,
				       chain->main_part,
				       EBIU_AMBCTL0 - EBIU_AMGCTL,
				       CONFIG_EBIU_AMBCTL0_VAL,
				       4);
	    part_mmr_write_clobber_r0 (chain,
				       chain->main_part,
				       EBIU_AMBCTL1 - EBIU_AMGCTL,
				       CONFIG_EBIU_AMBCTL1_VAL,
				       4);
	    part_mmr_write_clobber_r0 (chain,
				       chain->main_part,
				       0,
				       CONFIG_EBIU_AMGCTL_VAL,
				       2);
	    EBIU_AMCTL_INITIALIZED = 1;
	  }

	part_set_p0 (chain, chain->main_part, adr);

	part_scan_select (chain, chain->main_part, DBGCTL_SCAN);
	part_dbgctl_bit_set_emuirlpsz_2 (chain, chain->main_part);
	chain_shift_data_registers_mode (chain, 0, 1, EXITMODE_UPDATE);
	
	part_emuir_set_2 (chain, chain->main_part, gen_move (REG_R0, REG_EMUDAT),
			  gen_store16pi (REG_P0, REG_R0), EXITMODE_UPDATE);

	part_emudat_set (chain, chain->main_part, data, EXITMODE_IDLE);

	part_scan_select (chain, chain->main_part, DBGCTL_SCAN);
	part_dbgctl_bit_clear_emuirlpsz_2 (chain, chain->main_part);
	chain_shift_data_registers_mode (chain, 0, 1, EXITMODE_UPDATE);

	part_emuir_set (chain, chain->main_part, INSN_NOP, EXITMODE_IDLE);

	part_set_p0 (chain, chain->main_part, P0);
	part_set_r0 (chain, chain->main_part, R0);
}

const bus_driver_t bfin_core_bus = {
	"bfin_core",
	N_("Blackfin bus driver via CORE"),
	bfin_core_bus_new,
	generic_bus_free,
	bfin_core_bus_printinfo,
	generic_bus_prepare_extest,
	bfin_core_bus_area,
	bfin_core_bus_read_start,
	bfin_core_bus_read_next,
	bfin_core_bus_read_end,
	generic_bus_read,
	bfin_core_bus_write,
	generic_bus_no_init
};
