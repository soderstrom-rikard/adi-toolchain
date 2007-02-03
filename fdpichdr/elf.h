/*
 * File:         elf.h
 * Author:       Mike Frysinger <michael.frysinger@analog.com>
 * Description:  Hide all the ELF defines here.
 * Modified:     Copyright 2006-2007 Analog Devices Inc.
 * Bugs:         Enter bugs at http://blackfin.uclinux.org/
 * Licensed under the GPL-2, see the file COPYING in this dir
 */

#ifndef __FDPICHDR_ELF_H__
#define __FDPICHDR_ELF_H__

/* only support 1 ELF at a time for now ... */
extern char do_reverse_endian;

#define EGET(X) \
	(__extension__ ({ \
		uint32_t __res; \
		if (!do_reverse_endian) {    __res = (X); \
		} else if (sizeof(X) == 1) { __res = (X); \
		} else if (sizeof(X) == 2) { __res = bswap_16((X)); \
		} else if (sizeof(X) == 4) { __res = bswap_32((X)); \
		} else if (sizeof(X) == 8) { printf("64bit types not supported\n"); exit(1); \
		} else { printf("Unknown type size %i\n", (int)sizeof(X)); exit(1); } \
		__res; \
	}))

int set_stack(uint32_t stack, char *argv[]);

#endif
