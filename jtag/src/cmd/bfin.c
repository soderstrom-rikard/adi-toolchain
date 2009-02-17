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

/* For "bfin execute", Blackfin assembler assembles instruction(s)
   into a temporary object file. When this variable is non-zero, there
   should be only one instruction in the object file. For example,
   assembler assembles one instruction a time, which is how we do now.

   Blackfin GAS rounds the section size to 4 bytes. Usually we don't
   want the padding bytes to be executed as a NOP. With this variable
   set, only the first instruction in the object file will be
   executed.  */

int bfin_one_insn_a_file = 1;

#define ARRAY_SIZE(a) (sizeof (a) / sizeof ((a)[0]))

static int
cmd_bfin_run( chain_t *chain, char *params[] )
{
  int num_params;
  part_t *part;

  num_params = cmd_params(params);

  if (num_params < 2)
    return -1;

  /* These commands don't need cable or parts.  */

  if (strcmp (params[1], "set") == 0)
    {
      if (num_params != 4)
	return -1;

      if (strcmp (params[2], "one-insn-a-file") == 0)
	{
	  if (strcmp (params[3], "0") == 0)
	    bfin_one_insn_a_file = 0;
	  else if (strcmp (params[3], "1") == 0)
	    bfin_one_insn_a_file = 1;
	  else
	    {
	      printf (_("%s: bad value for one-insn-a-file '%s'\n"), "bfin set", params[3]);
	      return -1;
	    }
	}
      else
	{
	  printf (_("%s: unknown set variable '%s'\n"), "bfin set", params[2]);
	  return -1;
	}

      return 1;
    }
  else if (strcmp (params[1], "show") == 0)
    {
      int found = 0;

      if (num_params > 3)
	return -1;

      if (num_params == 2 || strcmp (params[2], "one-insn-a-file") == 0)
	{
	  found = 1;
	  printf ("one-insn-a-file: %d\n", bfin_one_insn_a_file);
	}

      if (!found && num_params == 3)
	{
	  printf (_("%s: unknown set variable '%s'\n"), "bfin set", params[2]);
	  return -1;
	}

      return 1;
    }

  /* The remaining commands require cable or parts.  */

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

  /* Do part specific initialization.  */
  bfin_part_init (part);

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

	  dbgstat = BFIN_DBGSTAT_GET (chain);
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
      else if (strcmp (params[2], "singlestep") == 0)
	{
	  if ((BFIN_DBGSTAT_GET (chain) & DBGSTAT_EMUREADY) == 0)
	    {
	      printf( _("Run \"bfin emulation enter\" first.\n") );
	      return 1;
	    }

	  /* TODO  Allow an argument to specify how many single steps.  */

	  BFIN_DBGCTL_BIT_SET (chain, DBGCTL_ESSTEP, EXITMODE_UPDATE);
	  BFIN_EMUIR_SET (chain, INSN_RTE, EXITMODE_UPDATE);
	  BFIN_DBGCTL_BIT_CLEAR (chain, DBGCTL_EMEEN | DBGCTL_WAKEUP, EXITMODE_IDLE);
	  BFIN_EMUIR_SET (chain, INSN_NOP, EXITMODE_UPDATE);
	  BFIN_DBGCTL_BIT_SET (chain, DBGCTL_EMEEN | DBGCTL_WAKEUP, EXITMODE_IDLE);
	  BFIN_DBGCTL_BIT_CLEAR (chain, DBGCTL_ESSTEP, EXITMODE_UPDATE);
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

      if ((BFIN_DBGSTAT_GET (chain) & DBGSTAT_EMUREADY) == 0)
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
#ifdef __MINGW32__
		  printf ( _("Sorry, dynamic code not available in windows\n") );
		  goto execute_cleanup;
#else
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

		  /* HRM states that branches and hardware loop setup results
		     in undefined behavior.  Should check opcode instead?  */
		  if (strcasestr(insns_string, "jump") ||
		      strcasestr(insns_string, "call") ||
		      strcasestr(insns_string, "lsetup"))
		    printf( _("%s: warning: "
			    "jump/call/lsetup insns may not work in emulation\n"),
			    "bfin execute" );

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
				"bfin-%3$s-as --version >/dev/null 2>&1 || exit $?;"
				"echo '%1$s' | bfin-%3$s-as - -o \"%2$s\""
				" && bfin-%3$s-objcopy -O binary \"%2$s\"",
				insns_string, tmpfile, tuples[t]);
		      ret = system (tmp_buf);
		      free (tmp_buf);
		      if (WIFEXITED(ret))
			{
			  if (WEXITSTATUS(ret) == 0)
			    break;
			  /* 127 -> not found in $PATH */
			  else if (WEXITSTATUS(ret) == 127)
			    continue;
			  else
			    {
			      printf( _("%s: GAS failed parsing: %s\n"),
				      "bfin execute",
				      insns_string);
			      goto execute_cleanup;
			    }
			}
		    }
		  if (t == ARRAY_SIZE(tuples))
		    {
		      printf( _("%s: "
			      "unable to find Blackfin toolchain in $PATH\n"),
			      "bfin execute" );
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

		      if (bfin_one_insn_a_file)
			break;
		    }

		  fclose (fp);
#endif
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
	  uint64_t emudat = BFIN_EMUDAT_GET (chain, EXITMODE_UPDATE);
	  uint16_t dbgstat = BFIN_DBGSTAT_GET (chain);
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
  else if (strcmp (params[1], "reset579") == 0)
    {
      int init_sram;

      if (num_params == 3)
	{
	  if (!strcmp (params[2], "stop"))
	    init_sram = 1;
	  else if (!strcmp (params[2], "run"))
	    init_sram = 0;
	  else
	    return -1;
	}
      else
	return -1;

      printf (_("%s: reseting processor ... "), "bfin");
      fflush (stdout);
      bf579_core_reset (chain, init_sram);
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
	    "Usage: %s emulation enter|exit|singlestep|status\n"
	    "Usage: %s reset [core|system]\n"
	    "Usage: %s set one-insn-a-file VALUE\n"
	    "Usage: %s show [one-insn-a-file]\n"
	    "Blackfin specific commands\n"
	    "\n"
	    "INSTRUCTIONs are a sequence of Blackfin encoded instructions,\n"
	    "double quoted assembly statements and [EMUDAT_IN]s\n"
	    ), "bfin", "bfin", "bfin", "bfin", "bfin" );
}

cmd_t cmd_bfin = {
  "bfin",
  N_("Blackfin specific commands"),
  cmd_bfin_help,
  cmd_bfin_run
};
