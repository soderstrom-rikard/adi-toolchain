/*
 * $Id$
 *
 * Copyright (C) 2008, Analog Devices, Inc.
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
 *
 */


#include "sysdep.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <inttypes.h>
#include <cmd.h>

#include <bfin.h>

static int
cmd_bfin_run( chain_t *chain, char *params[] )
{
  int num_params;
  part_t *part;

  num_params = cmd_params(params);

  if (num_params < 2)
    return -1;

  if (!cmd_test_cable( chain ))
    return 1;

  if (!chain->parts) {
    printf( _("Run \"detect\" first.\n") );
    return 1;
  }

  if (chain->active_part >= chain->parts->len) {
    printf( _("%s: no active part\n"), "initbus" );
    return 1;
  }

  part = chain->parts->parts[chain->active_part];

  assert (part);

  if (strcmp (params[1], "emulation") == 0)
    {
      if (num_params != 3)
	return -1;

      if (strcmp (params[2], "enter") == 0)
	{
	  if ((bfin_dbgstat_get (chain) & DBGSTAT_EMUREADY) == 0)
	    {
	      bfin_emulation_enable (chain);
	      bfin_emulation_trigger (chain);
	    }
	}
      else if (strcmp (params[2], "exit") == 0)
	{
	  if (bfin_dbgstat_get (chain) & DBGSTAT_EMUREADY)
	    bfin_emulation_return (chain);

	  bfin_emulation_disable (chain);
	}
      else if (strcmp (params[2], "status") == 0)
	{
	  uint16_t dbgstat;

	  dbgstat = bfin_dbgstat_get (chain);

	  printf ("DBGSTAT = 0x%"PRIx16"\n", dbgstat);
	}
      else
	{
	  printf (_("%s: unknown emulation subcommand '%s'\n"), "bfin emulation", params[2]);
	  return -1;
	}

      return 1;
    }
  else if (strcmp (params[1], "execute") == 0)
    {
      uint64_t emudat;

      if ((bfin_dbgstat_get (chain) & DBGSTAT_EMUREADY) == 0)
	{
	  printf( _("Run \"bfin emulation enter\" first.\n") );
	  return 1;
	}

      if (num_params > 2)
	{
	  int start, i;
	  uint64_t *insns;
	  char tmp[8];

	  insns = (uint64_t *) malloc ((num_params - 2) * sizeof (uint64_t));

	  for (i = 2; i < num_params; i++)
	    {
	      if (params[i][0] == '[')
		{
		  if (sscanf (params[i], "[0%[xX]%"PRIx64"]", tmp, &insns[i - 2]) != 2)
		    {
		      free (insns);
		      return -1;
		    }
		}
	      else
		{
		  if (sscanf (params[i], "0%[xX]%"PRIx64, tmp, &insns[i - 2]) != 2)
		    {
		      free (insns);
		      return -1;
		    }
		}
	    }

	  start = 2;
	  i = 2;
	  while (i < num_params)
	    {
	      if (params[i][0] == '[')
		{
		  bfin_execute_instructions (chain, i - start, &insns[start - 2]);

		  bfin_emudat_set (chain, insns[i - 2], EXITMODE_UPDATE);
		  i++;
		  start = i;
		}
	      else
		i++;
	    }
	  bfin_execute_instructions (chain, num_params - start, &insns[start - 2]);
	  free (insns);
	}

      emudat = bfin_emudat_get (chain, EXITMODE_UPDATE);

      printf ("EMUDAT = 0x%"PRIx64"\n", emudat);
    }

  return 1;
}


static void
cmd_bfin_help( void )
{
  printf( _(
	    "Usage: %s execute INSTRUCTIONs\n"
	    "Usage: %s emulation enter|exit|status\n"
	    "Blackfin specific commands\n"
	    "\n"
	    "INSTRUCTIONs are a sequence of Blackfin instructions and [EMUDAT_IN]s\n"
	    ), "bfin", "bfin" );
}

cmd_t cmd_bfin = {
  "bfin",
  N_("Blackfin specific commands"),
  cmd_bfin_help,
  cmd_bfin_run
};
