/*
 * File:         ldrviewer.c
 * Author:       Mike Frysinger <michael.frysinger@analog.com>
 *
 * Description:  View LDR contents
 *               Based on the "Visual DSP++ 4.0 Loader Manual"
 *               and misc Blackfin HRMs
 *
 * Rev:          $Id$
 *
 * Modified:     Copyright 2006 Analog Devices Inc.
 *
 * Bugs:         Enter bugs at http://blackfin.uclinux.org/
 *
 * Licensed under the GPL-2, see the file COPYING in this dir
 */

#include "headers.h"
#include "helpers.h"
#include "ldr.h"


static const char *rcsid = "$Id$";
const char *argv0;
int verbose = 0, quiet = 0;


static void show_ldr(const char *filename)
{
	LDR *ldr;
	printf("Showing LDR %s ...\n", filename);
	ldr = ldr_read(filename);
	if (ldr == NULL) {
		printf("Unable to read specified LDR\n");
		return;
	}
	ldr_print(ldr);
	ldr_free(ldr);
}

static void dump_ldr(const char *filename)
{
	LDR *ldr;
	printf("Dumping LDR %s ...\n", filename);
	ldr = ldr_read(filename);
	if (ldr == NULL) {
		printf("Unable to read specified LDR\n");
		return;
	}
	ldr_dump(filename, ldr);
	ldr_free(ldr);
}

static void load_ldr(const char *filename, const char *tty)
{
	LDR *ldr;
	printf("Loading LDR %s ... ", filename);
	ldr = ldr_read(filename);
	if (ldr == NULL) {
		printf("Unable to read specified LDR\n");
		return;
	}
	printf("OK!\n");
	ldr_send(ldr, tty);
	ldr_free(ldr);
}



#define PARSE_FLAGS "sdlvqhV"
#define a_argument required_argument
static struct option const long_opts[] = {
	{"show",     no_argument, NULL, 's'},
	{"dump",     no_argument, NULL, 'd'},
	{"load",     no_argument, NULL, 'l'},
	{"verbose",  no_argument, NULL, 'v'},
	{"quiet",    no_argument, NULL, 'q'},
	{"help",     no_argument, NULL, 'h'},
	{"version",  no_argument, NULL, 'V'},
	{NULL,       no_argument, NULL, 0x0}
};

static const struct {
	const char *desc, *opts;
} opts_help[] = {
	{"Show details of a LDR",         "<ldrs>"},
	{"Break DXEs out of LDR",         "<ldrs>"},
	{"Load LDR over UART to a BF537", "<ldr> <tty>"},
	{"Make a lot of noise",           NULL},
	{"Only show errors",              NULL},
	{"Print this help and exit",      NULL},
	{"Print version and exit",        NULL},
	{NULL,NULL}
};

static void show_usage(int exit_status)
{
	unsigned long i;

	printf("Usage: ldrviewer [options] <arguments>\n\n");
	printf("Options: -[%s]\n", PARSE_FLAGS);
	for (i=0; long_opts[i].name; ++i)
		printf("  -%c, --%-7s %-14s * %s\n",
		       long_opts[i].val, long_opts[i].name,
		       (opts_help[i].opts != NULL ?
		          (long_opts[i].has_arg == no_argument ? opts_help[i].opts : "<arg>") : ""),
		       opts_help[i].desc);

	exit(exit_status);
}

static void show_version(void)
{
	printf("ldrviewer-%s: %s compiled %s\n%s\n",
	       VERSION, __FILE__, __DATE__, rcsid);
	exit(EXIT_SUCCESS);
}

#define set_action(action) \
	do { \
		if (a != NONE) \
			err("Cannot specify more than one action at a time"); \
		a = action; \
	} while (0)

int main(int argc, char *argv[])
{
	typedef enum { SHOW, DUMP, LOAD, NONE } actions;
	actions a = NONE;
	int i;

	argv0 = strchr(argv[0], '/');
	argv0 = (argv0 == NULL ? argv[0] : argv0+1);

	while ((i=getopt_long(argc, argv, PARSE_FLAGS, long_opts, NULL)) != -1) {
		switch (i) {
			case 's': set_action(SHOW); break;
			case 'd': set_action(DUMP); break;
			case 'l': set_action(LOAD); break;
			case 'v': ++verbose; break;
			case 'q': ++quiet; break;
			case 'h': show_usage(0);
			case 'V': show_version();
			case ':': err("Option '%c' is missing parameter", optopt);
			case '?': err("Unknown option '%c' or argument missing", optopt);
			default:  err("Unhandled option '%c'; please report this", i);
		}
	}
	if (optind == argc)
		show_usage(EXIT_FAILURE);

try_again:
	switch (a) {
		case SHOW:
			for (i = optind; i < argc; ++i)
				show_ldr(argv[i]);
			break;
		case DUMP:
			for (i = optind; i < argc; ++i)
				dump_ldr(argv[i]);
			break;
		case LOAD:
			if (optind + 2 != argc)
				err("Load requires exactly two arguments: <ldr> <tty>");
			load_ldr(argv[optind], argv[optind+1]);
			break;
		case NONE:
			/* guess at requested action based upon context */
			if (argc - optind == 1)
				a = SHOW;
			else if (argc - optind == 2) {
				struct stat st;
				if (stat(argv[optind+1], &st) == 0) {
					if (S_ISCHR(st.st_mode))
						a = LOAD;
				}
			}
			if (a != NONE)
				goto try_again;
			show_usage(EXIT_FAILURE);
	}

	return 0;
}
