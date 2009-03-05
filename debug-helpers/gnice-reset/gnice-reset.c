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

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <ftdi.h>

#define GNICE_VID 0x0456
#define GNICE_PID 0xF000

/* MPSSE only ACBUS */
#define BIT_GNICE_nGPIO		2 /* ACBUS2 */
#define BIT_GNICE_nLED		3 /* ACBUS3 */

#define BITMASK_GNICE_nGPIO	(1 << BIT_GNICE_nGPIO)
#define BITMASK_GNICE_nLED	(1 << BIT_GNICE_nLED)

#ifdef WIN32
# define usleep(x) Sleep((x) / 1000000 ? : 1)
#endif

int main(int argc, char *argv[])
{
	struct ftdi_context con;
	unsigned char buf[3];
	int f;

	ftdi_init(&con);
	ftdi_set_interface(&con, INTERFACE_A);

	if (argc > 1) {
		if (strcmp(argv[1], "--serial")) {
			fprintf(stderr, "usage: %s [--serial USBSERIAL]\n",
						 argv[0]);
			exit(-1);
		}

		f = ftdi_usb_open_desc(&con, GNICE_VID, GNICE_PID,
				       NULL, argv[2]);
	} else
		f = ftdi_usb_open(&con, GNICE_VID, GNICE_PID);

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
	buf[1] = BITMASK_GNICE_nGPIO | BITMASK_GNICE_nLED;	/* VAL */
	buf[2] = BITMASK_GNICE_nGPIO | BITMASK_GNICE_nLED;	/* DIR */

	f = ftdi_write_data(&con, buf, 3);
	if (f < 0)
		fprintf(stderr,
			"write failed error %d (%s)\n",
			f, ftdi_get_error_string(&con));
	usleep(50000); /* 50ms */

	/* drive LED and RESET GPIO LOW */
	buf[0] = SET_BITS_HIGH;
	buf[1] = 0;
	buf[2] = BITMASK_GNICE_nGPIO | BITMASK_GNICE_nLED;

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
