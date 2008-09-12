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
#include <unistd.h>

#include <bfin.h>

#define ARRAY_SIZE(a) (sizeof (a) / sizeof ((a)[0]))

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
	  if (!bfin_emulation_enabled (chain))
	    {
	      bfin_emulation_enable (chain);
	      bfin_emulation_trigger (chain);
	    }
	}
      else if (strcmp (params[2], "exit") == 0)
	{
	  if (bfin_emulation_enabled (chain))
	    bfin_emulation_return (chain);

	  bfin_emulation_disable (chain);
	}
      else if (strcmp (params[2], "status") == 0)
	{
	  uint16_t dbgstat, excause;
	  const char *str_excause;

	  dbgstat = bfin_dbgstat_get (chain);
	  excause = (dbgstat & DBGSTAT_EMUCAUSE_MASK) >> 6;
	  switch (excause) {
	  case 0x0: str_excause = "EMUEXCPT was executed"; break;
	  case 0x1: str_excause = "EMUIN pin was asserted"; break;
	  case 0x2: str_excause = "Watchpoint event occurred"; break;
	  case 0x4: str_excause = "Performance Monitor 0 overflowed"; break;
	  case 0x5: str_excause = "Performance Monitor 1 overflowed"; break;
	  case 0x8: str_excause = "Emulation single step"; break;
	  default:  str_excause = "Reserved??"; break;
	  }

	  printf ("DBGSTAT = 0x%"PRIx16"\n", dbgstat);

	  printf ("\tEMUDOF     = %u\n"
		  "\tEMUDIF     = %u\n"
		  "\tEMUDOOVF   = %u\n"
		  "\tEMUDIOVF   = %u\n"
		  "\tEMUREADY   = %u\n"
		  "\tEMUACK     = %u\n"
		  "\tEMUCAUSE   = 0x%x (%s)\n"
		  "\tBIST_DONE  = %u\n"
		  "\tLPDEC0     = %u\n"
		  "\tIN_RESET   = %u\n"
		  "\tIDLE       = %u\n"
		  "\tCORE_FAULT = %u\n"
		  "\tLPDEC1     = %u\n",
		  !!(dbgstat & DBGSTAT_EMUDOF),
		  !!(dbgstat & DBGSTAT_EMUDIF),
		  !!(dbgstat & DBGSTAT_EMUDOOVF),
		  !!(dbgstat & DBGSTAT_EMUDIOVF),
		  !!(dbgstat & DBGSTAT_EMUREADY),
		  !!(dbgstat & DBGSTAT_EMUACK),
		  excause, str_excause,
		  !!(dbgstat & DBGSTAT_BIST_DONE),
		  !!(dbgstat & DBGSTAT_LPDEC0),
		  !!(dbgstat & DBGSTAT_IN_RESET),
		  !!(dbgstat & DBGSTAT_IDLE),
		  !!(dbgstat & DBGSTAT_CORE_FAULT),
		  !!(dbgstat & DBGSTAT_LPDEC1));
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
      int execute_ret = -1;

      if ((bfin_dbgstat_get (chain) & DBGSTAT_EMUREADY) == 0)
	{
	  printf( _("Run \"bfin emulation enter\" first.\n") );
	  return 1;
	}

      if (num_params > 2)
	{
	  int i;
	  struct bfin_insn *insns = NULL;
	  struct bfin_insn **last = &insns;
	  char tmp[8];
	  char *tmpfile = NULL;

	  for (i = 2; i < num_params; i++)
	    {
	      if (params[i][0] == '[' && params[i][1] == '0')
		{
		  uint64_t n;

		  if (sscanf (params[i], "[0%[xX]%"PRIx64"]", tmp, &n) != 2)
		    goto execute_cleanup;

		  *last = (struct bfin_insn *) malloc (sizeof (struct bfin_insn));
		  if (*last == NULL)
		    goto execute_cleanup;

		  (*last)->i = n;
		  (*last)->type = BFIN_INSN_SET_EMUDAT;
		  (*last)->next = NULL;
		  last = &((*last)->next);
		}
	      else if (params[i][0] == '0')
		{
		  uint64_t n;

		  if (sscanf (params[i], "0%[xX]%"PRIx64, tmp, &n) != 2)
		    goto execute_cleanup;

		  *last = (struct bfin_insn *) malloc (sizeof (struct bfin_insn));
		  if (*last == NULL)
		    goto execute_cleanup;

		  (*last)->i = n;
		  (*last)->type = BFIN_INSN_NORMAL;
		  (*last)->next = NULL;
		  last = &((*last)->next);
		}
	      else
		{
		  unsigned char raw_insn[4];
		  char *tmp_buf;
		  char *tuples[] = { "uclinux", "linux-uclibc", "elf" };
		  size_t t;
		  FILE *fp;

		  /* 1024 should be plenty; MAXINPUTLINE is 100 in parse.c */
		  char insns_string[1024];
		  char *p = insns_string;

		  for (; i < num_params; i++)
		    {
		      p += snprintf (p, sizeof (insns_string) - (p - insns_string),
						     "%s ", params[i]);
		      if (params[i][strlen (params[i]) - 1] == '"')
			break;
		      if (params[i][strlen (params[i]) - 1] == ';')
			break;
		    }
		  if (i == num_params)
		    {
		      printf ( _("%s: unbalanced double quotes\n"), "bfin execute" );
		      goto execute_cleanup;
		    }

		  /* p points past the '\0'. p - 1 points to the ending '\0'.
		     p - 2 points to the last double quote.  */
		  *(p - 2) = ';';
		  if (insns_string[0] == '"')
		    insns_string[0] = ' ';

		  /* get a temporary file to work with -- a little racy */
		  if (!tmpfile)
		    {
		      tmpfile = tmpnam (NULL);
		      if (!tmpfile)
			goto execute_cleanup;
		      tmpfile = strdup (tmpfile);
		      if (!tmpfile)
			goto execute_cleanup;
		    }

		  /* try to find a toolchain in $PATH */
		  for (t = 0; t < ARRAY_SIZE(tuples); ++t)
		    {
		      int ret;
		      asprintf (&tmp_buf,
				"echo '%1$s' | bfin-%3$s-as - -o \"%2$s\""
				" && bfin-%3$s-objcopy -O binary \"%2$s\"",
				insns_string, tmpfile, tuples[t]);
		      ret = system (tmp_buf);
		      free (tmp_buf);
		      if (WIFEXITED(ret) && WEXITSTATUS(ret) == 0)
			break;
		    }
		  if (t == ARRAY_SIZE(tuples))
		    {
		      printf( _("Unable to find the Blackfin toolchain in $PATH.\n") );
		      goto execute_cleanup;
		    }

		  /* Read the binary blob from the toolchain */
		  fp = fopen (tmpfile, "rb");
		  if (fp == NULL)
		    goto execute_cleanup;

		  while (fread (raw_insn, 1, 2, fp) == 2)
		    {
		      uint16_t iw = raw_insn[0] | (raw_insn[1] << 8);
		      uint64_t n = iw;
		      int is_multiinsn = INSN_IS_MULTI(raw_insn[1]);

		      if ((iw & 0xf000) >= 0xc000)
			{
			  if (fread (raw_insn, 1, 2, fp) != 2)
			    goto execute_cleanup;

			  iw = raw_insn[0] | (raw_insn[1] << 8);
			  n = (n << 16) | iw;
			}

		      if (is_multiinsn)
			{
			  if (fread (raw_insn, 1, 4, fp) != 4)
			    goto execute_cleanup;

			  n = (n << 32)
			    | ((uint64_t)raw_insn[0] << 16)
			    | ((uint64_t)raw_insn[1] << 24)
			    | raw_insn[2] | (raw_insn[3] << 8);
			}

		      *last = (struct bfin_insn *) malloc (sizeof (struct bfin_insn));
		      if (*last == NULL)
			goto execute_cleanup;

		      (*last)->i = n;
		      (*last)->type = BFIN_INSN_NORMAL;
		      (*last)->next = NULL;
		      last = &((*last)->next);
		    }

		  fclose (fp);
		}
	    }

	  bfin_execute_instructions (chain, insns);
	  execute_ret = 1;

 execute_cleanup:
	  if (tmpfile)
	    {
	      unlink (tmpfile);
	      free (tmpfile);
	    }
	  while (insns)
	    {
	      struct bfin_insn *tmp = insns->next;
	      free (insns);
	      insns = tmp;
	    }
	}

      if (execute_ret == 1)
	{
	  uint64_t emudat = bfin_emudat_get (chain, EXITMODE_UPDATE);
	  uint16_t dbgstat = bfin_dbgstat_get (chain);
	  printf ("EMUDAT = 0x%"PRIx64"\n", emudat);
	  if (dbgstat & DBGSTAT_CORE_FAULT)
	    printf (_("warning: core fault detected\n"));
	}

      return execute_ret;
    }
  else if (strcmp (params[1], "reset") == 0)
    {
      int reset_what = 0;

      if (num_params == 3)
	{
	  if (!strcmp (params[2], "core"))
	    reset_what |= 0x1;
	  else if (!strcmp (params[2], "system"))
	    reset_what |= 0x2;
	  else
	    return -1;
	}
      else if (num_params == 2)
	reset_what = 0x1 | 0x2;
      else
	return -1;

      printf (_("%s: reseting processor ... "), "bfin");
      fflush (stdout);
      if (reset_what == 0x3)
	bfin_software_reset (chain);
      else if (reset_what & 0x1)
	bfin_core_reset (chain);
      else if (reset_what & 0x2)
	bfin_system_reset (chain);
      printf (_("OK\n"));

      return 1;
    }
  else
    {
      printf (_("%s: unknown subcommand '%s'\n"), "bfin", params[1]);
      return 1;
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
	    "INSTRUCTIONs are a sequence of Blackfin encoded instructions,\n"
	    "double quoted assembly statements and [EMUDAT_IN]s\n"
	    ), "bfin", "bfin" );
}

cmd_t cmd_bfin = {
  "bfin",
  N_("Blackfin specific commands"),
  cmd_bfin_help,
  cmd_bfin_run
};
