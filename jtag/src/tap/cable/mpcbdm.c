/*
 * $Id: mpcbdm.c 1090 2008-02-24 14:52:44Z kawk $
 *
 * Mpcbdm JTAG Cable Driver
 * Copyright (C) 2002, 2003 ETC s.r.o.
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
 * Written by Marcel Telka <marcel@telka.sk>, 2002, 2003.
 * Modified for Mpcbdm by Christian Pellegrin <chri@ascensit.com>, 2003.
 *
 * Documentation:
 * [1] http://www.vas-gmbh.de/software/mpcbdm/VDB2.gif
 *
 */

#include "sysdep.h"

#include "cable.h"
#include "parport.h"
#include "chain.h"

#include "generic.h"
#include "generic_parport.h"

/*
 * data D[7:0] (pins 9:2)
 */
#define	TDI	1
#define	TCK	0
#define	TMS	2

/* 
 * control 
 */
#define	HRESET	3	/* the signal is inverted by cable hardware */
#define	SRESET	1	/* the signal is inverted by cable hardware */
#define	TRST	0	/* the signal is inverted by cable hardware */

/* 
 * status
 *
 * 7 - BUSY (pin 11)
 * 6 - ACK (pin 10)
 * 5 - PE (pin 12)
 * 4 - SEL (pin 13)
 * 3 - ERROR (pin 15)
 */
#define	TDO 	5	

static int
mpcbdm_init( cable_t *cable )
{
	if (parport_open( cable->link.port ))
		return -1;

	parport_set_control( cable->link.port, 0 << TRST );
	PARAM_TRST(cable) = 1;

	return 0;
}

static void
mpcbdm_clock( cable_t *cable, int tms, int tdi, int n )
{
	int i;

	tms = tms ? 1 : 0;
	tdi = tdi ? 1 : 0;

	for (i = 0; i < n; i++) {
		parport_set_data( cable->link.port, (0 << TCK) | (tms << TMS) | (tdi << TDI) );
		cable_wait( cable );
		parport_set_data( cable->link.port, (1 << TCK) | (tms << TMS) | (tdi << TDI) );
		cable_wait( cable );
	}
}

static int
mpcbdm_get_tdo( cable_t *cable )
{
	parport_set_data( cable->link.port, 0 << TCK );
	cable_wait( cable );
	return (parport_get_status( cable->link.port ) >> TDO) & 1;
}

static int
mpcbdm_set_trst( cable_t *cable, int trst )
{
	PARAM_TRST(cable) = trst ? 1 : 0;

	parport_set_control( cable->link.port, (PARAM_TRST(cable) ^ 1) << TRST );
	return PARAM_TRST(cable);
}

cable_driver_t mpcbdm_cable_driver = {
	"MPCBDM",
	N_("Mpcbdm JTAG cable"),
	generic_parport_connect,
	generic_disconnect,
	generic_parport_free,
	mpcbdm_init,
	generic_parport_done,
	generic_set_frequency,
	mpcbdm_clock,
	mpcbdm_get_tdo,
	generic_transfer,
	mpcbdm_set_trst,
	generic_get_trst,
	generic_flush_one_by_one,
	generic_parport_help
};
