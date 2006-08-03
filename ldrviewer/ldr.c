/*
 * File:         ldr.c
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

struct ldr_flag {
	uint16_t flag;
	const char *desc;
};

struct ldr_flag ldr_common_flag_list[] = {
	{ LDR_FLAG_ZEROFILL, "zerofill" },
	{ LDR_FLAG_RESVECT,  "resvect"  },
	{ LDR_FLAG_INIT,     "init"     },
	{ LDR_FLAG_IGNORE,   "ignore"   },
	{ LDR_FLAG_FINAL,    "final"    },
	{ 0, 0 }
};
struct ldr_flag ldr_bf537_flag_list[] = {
	{ LDR_FLAG_PPORT_NONE,  "port_none" },
	{ LDR_FLAG_PPORT_PORTF, "portf"     },
	{ LDR_FLAG_PPORT_PORTG, "portg"     },
	{ LDR_FLAG_PPORT_PORTH, "porth"     },
	{ 0, 0 }
};


/*
 * _ldr_read_bin()
 * Translate the ADI visual dsp ldr binary format into our ldr structure.
 *
 * The LDR format as seen in three different ways:
 *  - [LDR]
 *  - [[DXE][DXE][...]]
 *  - [[[BLOCK][BLOCK][...]][[BLOCK][BLOCK][BLOCK][...]][...]]
 * So one LDR contains an arbitrary number of DXEs and one DXE contains
 * an arbitrary number of blocks.  The end of the LDR is signified by
 * a block with the final flag set.  The start of a DXE is signified
 * by the ignore flag being set.
 *
 * The format of each block:
 * [4 bytes for address]
 * [4 bytes for byte count]
 * [2 bytes for flags]
 * [data]
 * If the zero flag is set, there is no actual data section, otherwise
 * the data block will be [byte count] bytes long.
 */
static LDR *_ldr_read_bin(FILE *fp)
{
	LDR *ldr;
	DXE *dxe;
	BLOCK *block;
	size_t pos = 0, d;
	uint8_t header[LDR_BLOCK_HEADER_LEN];
	uint16_t flags;

	ldr = xmalloc(sizeof(LDR));
	ldr->dxes = NULL;
	ldr->num_dxes = 0;
	d = 0;

	while (!feof(fp)) {
		fread(header, LDR_BLOCK_HEADER_LEN, 1, fp);
		memcpy(&flags, header+8, sizeof(flags));
		if (flags & LDR_FLAG_IGNORE) {
			ldr->dxes = xrealloc(ldr->dxes, (++ldr->num_dxes) * sizeof(DXE));
			dxe = &ldr->dxes[d++];
			dxe->num_blocks = 0;
			dxe->blocks = NULL;
		}

		++dxe->num_blocks;
		dxe->blocks = xrealloc(dxe->blocks, dxe->num_blocks * sizeof(BLOCK));
		block = &dxe->blocks[dxe->num_blocks-1];
		block->offset = pos;
		memcpy(block->header, header, sizeof(header));
		memcpy(&(block->target_address), block->header, sizeof(block->target_address));
		memcpy(&(block->byte_count), block->header+4, sizeof(block->byte_count));
		memcpy(&(block->flags), block->header+8, sizeof(block->flags));
		if (block->flags & LDR_FLAG_ZEROFILL)
			block->data = NULL;
		else {
			block->data = xmalloc(block->byte_count);
			fread(block->data, block->byte_count, 1, fp);
		}

		if (block->flags & LDR_FLAG_FINAL)
			break;

		pos += block->byte_count + sizeof(block->header);
	}

	return ldr;
}

/*
 * _ldr_read_ihex()
 * Translate the Intel HEX32 format into our ldr structure.
 *
 * TODO: implement it
 * Documentation: http://en.wikipedia.org/wiki/Intel_hex
 */
static LDR *_ldr_read_ihex(FILE *fp)
{
	warn("Sorry, but parsing of Intel HEX32 files not supported yet");
	warn("Please convert to binary format:");
	warn(" $ objcopy -I ihex -O binary <infile> <outfile>");
	return NULL;
}

/*
 * _ldr_read_srec()
 * Translate the Motorola SREC format into our ldr structure.
 *
 * TODO: get some documentation on the actual file format and implement it
 */
static LDR *_ldr_read_srec(FILE *fp)
{
	warn("Sorry, but parsing of Motorola SREC files not supported yet");
	warn("Please convert to binary format:");
	warn(" $ objcopy -I srec -O binary <infile> <outfile>");
	return NULL;
}

/*
 * ldr_read()
 * Open the specified file, figure out what format it is, and
 * then call the function to translate the format into our own
 * ldr memory structure.
 */
LDR *ldr_read(const char *filename)
{
	FILE *fp;
	LDR *ret;
	char byte_header[2];

	fp = fopen(filename, "r");
	if (fp == NULL)
		return NULL;

	fread(byte_header, 1, 2, fp);
	rewind(fp);

	/* this of course assumes the address itself doesnt happen to translate
	 * into the corresponding ASCII value ... but this is a pretty safe bet
	 * anyways, so lets do it ...
	 */
	switch (byte_header[0]) {
		case ':': ret = _ldr_read_ihex(fp); break;
		case 'S': ret = _ldr_read_srec(fp); break;
		default:  ret = _ldr_read_bin(fp); break;
	}

	fclose(fp);

	return ret;
}

/*
 * ldr_free()
 * Free all the memory taken up by our ldr structure.
 */
void ldr_free(LDR *ldr)
{
	size_t d, b;
	for (d = 0; d < ldr->num_dxes; ++d) {
		for (b = 0; b < ldr->dxes[d].num_blocks; ++b)
			free(ldr->dxes[d].blocks[b].data);
		free(ldr->dxes[d].blocks);
	}
	free(ldr->dxes);
	free(ldr);
}

/*
 * ldr_print()
 * Translate our ldr structure into something human readable.
 */
int ldr_print(LDR *ldr)
{
	size_t i, d, b;

	if (ldr == NULL)
		return -1;

	for (d = 0; d < ldr->num_dxes; ++d) {
		printf("  DXE %zu at 0x%08zX:\n", d+1, ldr->dxes[d].blocks[0].offset);
		if (quiet)
			printf("              Offset      Address     Bytes    Flags\n");
		for (b = 0; b < ldr->dxes[d].num_blocks; ++b) {
			BLOCK *block = &(ldr->dxes[d].blocks[b]);
			if (quiet)
				printf("    Block %zu 0x%08zX: ", b+1, block->offset);
			else
				printf("    Block %zu at 0x%08zX\n", b+1, block->offset);

			if (quiet) {
				printf("0x%08X 0x%08X 0x%04X ( ", block->target_address, block->byte_count, block->flags);
			} else if (verbose) {
				printf("\t\tTarget Address: 0x%08X ( %s )\n", block->target_address,
					(block->target_address > 0xFF000000 ? "L1" : "SDRAM"));
				printf("\t\t    Byte Count: 0x%08X ( %u bytes )\n", block->byte_count, block->byte_count);
				printf("\t\t         Flags: 0x%04X     ( ", block->flags);
			} else {
				printf("         Addr: 0x%08X Bytes: 0x%08X Flags: 0x%04X ( ",
					block->target_address, block->byte_count, block->flags);
			}

			for (i = 0; ldr_common_flag_list[i].desc; ++i)
				if (block->flags & ldr_common_flag_list[i].flag)
					printf("%s ", ldr_common_flag_list[i].desc);
			if (block->flags & LDR_FLAG_RESVECT) {
				uint16_t pport;
				pport = block->flags & LDR_FLAG_PPORT_MASK;
				if (pport)
					for (i = 0; ldr_bf537_flag_list[i].desc; ++i)
						if (pport == ldr_bf537_flag_list[i].flag)
							printf("%s ", ldr_bf537_flag_list[i].desc);
				pport = (block->flags & LDR_FLAG_PFLAG_MASK) >> 5;
				if (pport)
					printf("gpio%i ", pport);
			}
			printf(")\n");
		}
	}

	return 0;
}

/*
 * ldr_dump()
 * Dump the individual DXEs into separate files.
 */
int ldr_dump(const char *base, LDR *ldr)
{
	char filename[1024];
	FILE *fp;
	size_t d, b;

	if (ldr == NULL)
		return -1;

	for (d = 0; d < ldr->num_dxes; ++d) {
		snprintf(filename, sizeof(filename), "%s-%zi.dxe", base, d);
		if (!quiet)
			printf("  Dumping DXE %zi to %s\n", d, filename);
		fp = fopen(filename, "w");
		if (fp == NULL) {
			perror("Unable to open output");
			return -1;
		}
		for (b = 0; b < ldr->dxes[d].num_blocks; ++b) {
			BLOCK *block = &(ldr->dxes[d].blocks[b]);
			fwrite(block->data, 1, block->byte_count, fp);
		}
		fclose(fp);
	}

	return 0;
}

/*
 * _tty_speed_to_baud()
 * Annoying function for translating the termios baud representation
 * into the actual decimal value.
 */
static inline size_t _tty_speed_to_baud(const speed_t speed)
{
	struct {
		speed_t s;
		size_t b;
	} speeds[] = {
		{B0, 0}, {B50, 50}, {B75, 75}, {B110, 110}, {B134, 134}, {B150, 150},
		{B200, 200}, {B300, 300}, {B600, 600}, {B1200, 1200}, {B1800, 1800},
		{B2400, 2400}, {B4800, 4800}, {B9600, 9600}, {B19200, 19200},
		{B38400, 38400}, {B57600, 57600}, {B115200, 115200}, {B230400, 230400}
	};
	size_t i;

	for (i = 0; i < sizeof(speeds)/sizeof(*speeds); ++i)
		if (speeds[i].s == speed)
			return speeds[i].b;

	return 0;
}

/*
 * _tty_get_baud()
 * Helper function to return the baud rate the specified fd is running at.
 */
static inline size_t _tty_get_baud(const int fd)
{
	struct termios term;
	tcgetattr(fd, &term);
	return _tty_speed_to_baud(cfgetispeed(&term));
}

/*
 * ldr_send()
 * Transmit the specified ldr over the serial line to a BF537.  Used when
 * you want to boot over the UART.
 *
 * The way this works is:
 *  - reboot board
 *  - write @ so the board autodetects the baudrate
 *  - read 4 bytes from the board (0xBF UART_DLL UART_DLH 0x00)
 *  - start writing the blocks
 *  - if data is being sent too fast, the board will assert CTS until
 *    it is ready for more ... we let the kernel worry about this crap
 *    in the call to write()
 */
int ldr_send(LDR *ldr, const char *tty)
{
	unsigned char autobaud[4] = { 0xFF, 0xFF, 0xFF, 0xFF };
	int fd;
	ssize_t ret;
	size_t d, b, baud, sclock;

	setbuf(stdout, NULL);

	printf("Opening %s ... ", tty);
	fd = open(tty, O_RDWR);
	if (fd == -1) {
canned_failure:
		perror("Failed");
		return -1;
	}
	printf("OK!\n");

	printf("Trying to send autobaud ... ");
	ret = write(fd, "@", 1);
	if (ret != 1)
		goto canned_failure;
	printf("OK!\n");

	printf("Trying to read autobaud ... ");
	ret = read(fd, autobaud, 4);
	if (ret != 4)
		goto canned_failure;
	printf("OK!\n");

	printf("Checking autobaud ... ");
	if (autobaud[0] != 0xBF || autobaud[3] != 0x00) {
		printf("Failed: wanted {0xBF,..,..,0x00} but got {0x%02X,..,..,0x%02X}\n",
			autobaud[0], autobaud[3]);
		return -1;
	}
	printf("OK!\n");

	/* bitrate = SCLK / (16 * Divisor) */
	baud = _tty_get_baud(fd);
	sclock = baud * 16 * (autobaud[1] + (autobaud[2] << 8));
	printf("Autobaud result: %zibps %zi.%zimhz (header:0x%02X DLL:0x%02X DLH:0x%02X fin:0x%02X)\n",
	       baud, sclock / 1000000, sclock / 1000 - sclock / 1000000 * 1000,
	       autobaud[0], autobaud[1], autobaud[2], autobaud[3]);

	for (d = 0; d < ldr->num_dxes; ++d) {
		printf("Sending blocks of DXE %zi ... ", d+1);
		for (b = 0; b < ldr->dxes[d].num_blocks; ++b) {
			BLOCK *block = &(ldr->dxes[d].blocks[b]);

			printf("[%zi/", b+1);
			ret = write(fd, block->header, sizeof(block->header));
			if (ret != sizeof(block->header))
				goto canned_failure;

			printf("%zi] ", ldr->dxes[d].num_blocks);
			if (block->data != NULL) {
				ret = write(fd, block->data, block->byte_count);
				if (ret != block->byte_count)
					goto canned_failure;
			}
		}
		printf("OK!\n");
	}

	close(fd);

	if (!quiet)
		printf("You may want to run minicom or kermit now\n"
		       "Quick tip: run 'ldrviewer <ldr> <tty> && minicom'\n");

	return 0;
}
