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
int force = 0, verbose = 0, quiet = 0;


struct option_help {
	const char *desc, *opts;
};

static void show_some_usage(struct option const opts[], struct option_help const help[], const char *flags, int exit_status)
{
	unsigned long i;

	printf("Usage: ldrviewer [options] <-s|-d|-l|-c> [command options] <arguments>\n\n");
	printf("Options: -[%s]\n", flags);
	for (i=0; opts[i].name; ++i)
		printf("  -%c, --%-7s %-14s * %s\n",
		       opts[i].val, opts[i].name,
		       (help[i].opts != NULL ? help[i].opts :
		          (opts[i].has_arg == no_argument ? "" : "<arg>")),
		       help[i].desc);

	exit(exit_status);
}

#define PARSE_FLAGS "sdlcfvqhV"
#define a_argument required_argument
static struct option const long_opts[] = {
	{"show",     no_argument, NULL, 's'},
	{"dump",     no_argument, NULL, 'd'},
	{"load",     no_argument, NULL, 'l'},
	{"create",   no_argument, NULL, 'c'},
	{"force",    no_argument, NULL, 'f'},
	{"verbose",  no_argument, NULL, 'v'},
	{"quiet",    no_argument, NULL, 'q'},
	{"help",     no_argument, NULL, 'h'},
	{"version",  no_argument, NULL, 'V'},
	{NULL,       no_argument, NULL, 0x0}
};
static struct option_help const opts_help[] = {
	{"Show details of a LDR",         "<ldrs>"},
	{"Break DXEs out of LDR",         "<ldrs>"},
	{"Load LDR over UART to a BF537", "<ldr> <tty>"},
	{"Create LDR from binaries",      "<ldr> <bins>"},
	{"Ignore errors",                 NULL},
	{"Make a lot of noise",           NULL},
	{"Only show errors",              NULL},
	{"Print this help and exit",      NULL},
	{"Print version and exit",        NULL},
	{NULL,NULL}
};
#define show_usage(status) show_some_usage(long_opts, opts_help, PARSE_FLAGS, status)

#define CREATE_PARSE_FLAGS "i:rp:g:h"
static struct option const create_long_opts[] = {
	/*{"cpu",       a_argument, NULL, 'C'},*/
	{"init",      a_argument, NULL, 'i'},
	{"resvec",   no_argument, NULL, 'r'},
	{"port",      a_argument, NULL, 'p'},
	{"gpio",      a_argument, NULL, 'g'},
	{"help",     no_argument, NULL, 'h'},
	{NULL,       no_argument, NULL, 0x0}
};
static struct option_help const create_opts_help[] = {
	/*{"Select target CPU type",        "<BFXXX>"},*/
	{"Control optional init code",    "<NONE|file>"},
	{"Enable resvec bit",             NULL},
	{"Select port for HWAIT signal",  "<F|G|H>"},
	{"Select GPIO for HWAIT signal",  "<#>"},
	{"Print this help and exit",      NULL},
	{NULL,NULL}
};
#define show_create_usage(status) show_some_usage(create_long_opts, create_opts_help, CREATE_PARSE_FLAGS, status)


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
		perror("Unable to read specified LDR");
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
		perror("Unable to read specified LDR");
		return;
	}
	printf("OK!\n");
	ldr_send(ldr, tty);
	ldr_free(ldr);
}

static void create_ldr(int argc, char *argv[])
{
	int i;
	struct ldr_create_options opts = {
		.init_file = (char*)-1,
		.resvec = 0,
		.port = '?',
		.gpio = 0,
	};

	optind = 0;
	while ((i=getopt_long(argc, argv, CREATE_PARSE_FLAGS, create_long_opts, NULL)) != -1) {
		switch (i) {
			case 'i': opts.init_file = (strcmp("NONE", optarg) == 0 ? NULL : optarg); break;
			case 'r': opts.resvec = 1; break;
			case 'p': opts.port = toupper(optarg[0]); break;
			case 'g': opts.gpio = atoi(optarg); break;
			case 'h': show_create_usage(0);
			case ':': err("Option '%c' is missing parameter", optopt);
			case '?': err("Unknown option '%c' or argument missing", optopt);
			default:  err("Unhandled option '%c'; please report this", i);
		}
	}	
	if (argc < optind + 2)
		err("Create requires at least two arguments: <ldr> <bins>");
	if (strchr("?FGH", opts.port) == NULL)
		err("Invalid PORT '%c'.  Valid PORT values are 'F', 'G', and 'H'.", opts.port);
	if (opts.gpio < 0 || opts.gpio > 16)
		err("Invalid GPIO '%i'.  Valid GPIO values are 0 - 16.", opts.gpio);

	printf("Creating LDR %s ...\n", *(argv+optind));
	if (ldr_create(argv+optind, &opts) != 0)
		perror("Failed to create LDR");
	else
		printf("Done!\n");
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
	typedef enum { SHOW, DUMP, LOAD, CREATE, NONE } actions;
	actions a = NONE;
	int i;

	argv0 = strchr(argv[0], '/');
	argv0 = (argv0 == NULL ? argv[0] : argv0+1);

	while ((i=getopt_long(argc, argv, PARSE_FLAGS, long_opts, NULL)) != -1) {
		switch (i) {
			case 's': set_action(SHOW); break;
			case 'd': set_action(DUMP); break;
			case 'l': set_action(LOAD); break;
			case 'c': set_action(CREATE); goto parse_action; /* create has sub options */
			case 'f': ++force; break;
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

parse_action:
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
		case CREATE:
			--optind;
			argc -= optind;
			argv += optind;
			argv[0] = "create";
			create_ldr(argc, argv);
			break;
		case NONE:
			/* guess at requested action based upon context
			 *  - one argument: show ldr
			 *  - two arguments, second is a char device: load ldr
			 */
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
				goto parse_action;
			show_usage(EXIT_FAILURE);
	}

	return 0;
}
