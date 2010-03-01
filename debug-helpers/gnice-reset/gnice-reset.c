/* Blackfin gnICE JTAG GPIO reset utility
 * Michael Hennerich Copyright 2009 Analog Devices Inc.
 *
 * Licensed under the GPL-2 or later
 *
 * For more information see:
 * - gnICE schematics
 * - libftdi
 * - Future Technology Devices International Limited (FTDI)
 *   Application Note AN_108 Command Processor for MPSSE and
 *   MCU Host Bus Emulation Modes
 */

#include <getopt.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <ftdi.h>

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))

#define GNICE_VID 0x0456
const int pids[] = {
	0xF000,	/* gnICE */
	0xF001, /* gnICE+ */
};

#ifdef WIN32
# define usleep(x) Sleep((x) / 1000000 ? : 1)
#endif

const char *argv0;

#define FLAGS "g:hl:s:"
#define a_argument required_argument
static struct option const long_opts[] = {
	{"gpio",     a_argument, NULL, 'g'},
	{"help",    no_argument, NULL, 'h'},
	{"led",      a_argument, NULL, 'l'},
	{"serial",   a_argument, NULL, 's'},
};

void usage(int exit_status)
{
	int i;
	FILE *fp = exit_status ? stderr : stdout;
	fprintf(fp, "Usage: %s [options]\n\nOptions: -[%s]\n", argv0, FLAGS);
	for (i = 0; i < ARRAY_SIZE(long_opts); ++i)
		fprintf(fp, "  -%c, --%s\n", long_opts[i].val, long_opts[i].name);
	exit(exit_status);
}

int main(int argc, char *argv[])
{
	struct ftdi_context con;
	unsigned char buf[3];
	const char *desc;
	int i, f, gpio, led, bitmask;

	argv0 = argv[0];

	gpio = 2;	/* ACBUS2 */
	led = 3;	/* ACBUS3 */
	desc = NULL;
	while ((i = getopt_long(argc, argv, FLAGS, long_opts, NULL)) != -1) {
		switch (i) {
			case 'g': gpio = atoi(optarg); break;
			case 'h': usage(0);
			case 'l': led = atoi(optarg); break;
			case 's': desc = optarg;
			default:  usage(1);
		}
	}
	bitmask = (1 << gpio) | (1 << led);

	ftdi_init(&con);
	ftdi_set_interface(&con, INTERFACE_A);

	if (desc) {
		for (i = 0; i < ARRAY_SIZE(pids); ++i) {
			f = ftdi_usb_open_desc(&con, GNICE_VID, pids[i],
					       NULL, argv[2]);
			if (f >= 0)
				break;
		}
	} else {
		for (i = 0; i < ARRAY_SIZE(pids); ++i) {
			f = ftdi_usb_open(&con, GNICE_VID, pids[i]);
			if (f >= 0)
				break;
		}
	}

	if (f < 0 && f != -5) {
		fprintf(stderr, "unable to open ftdi device: %d (%s)\n", f,
			ftdi_get_error_string(&con));
		exit(-1);
	}

	ftdi_disable_bitbang(&con);
	/* in order to use ACBUS we need to enable MPSSE mode */
	ftdi_set_bitmode(&con, 0x0, BITMODE_MPSSE);

	/* drive LED and RESET GPIO HIGH */
	buf[0] = SET_BITS_HIGH;
	buf[1] = bitmask;	/* VAL */
	buf[2] = bitmask;	/* DIR */

	f = ftdi_write_data(&con, buf, 3);
	if (f < 0)
		fprintf(stderr,
			"write failed error %d (%s)\n",
			f, ftdi_get_error_string(&con));
	usleep(50000); /* 50ms */

	/* drive LED and RESET GPIO LOW */
	buf[0] = SET_BITS_HIGH;
	buf[1] = 0;
	buf[2] = bitmask;

	f = ftdi_write_data(&con, buf, 3);
	if (f < 0)
		fprintf(stderr,
			"write failed error %d (%s)\n",
			f, ftdi_get_error_string(&con));
	usleep(50000); /* 50ms */

	/* ACBUS HIGH Input */
	buf[0] = SET_BITS_HIGH;
	buf[1] = 0;
	buf[2] = 0;

	f = ftdi_write_data(&con, buf, 3);
	if (f < 0)
		fprintf(stderr,
			"write failed error %d (%s)\n",
			f, ftdi_get_error_string(&con));

	/* cleanup and exit */
	ftdi_disable_bitbang(&con);
	ftdi_usb_close(&con);
	ftdi_deinit(&con);

	return 0;
}
