/*
 * File:         helpers.h
 * Author:       Mike Frysinger <michael.frysinger@analog.com>
 *
 * Description:  I'm too lazy to update headers in multiple files ...
 *               just move all that crap here ;)
 *
 * Rev:          $Id$
 *
 * Modified:     Copyright 2006 Analog Devices Inc.
 *
 * Bugs:         Enter bugs at http://blackfin.uclinux.org/
 *
 * Licensed under the GPL-2, see the file COPYING in this dir
 */

#ifndef __HEADERS_H__
#define __HEADERS_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <assert.h>
#include <stdint.h>
#include <sys/types.h>
#include <fcntl.h>
#include <ctype.h>
#include <unistd.h>
#include <getopt.h>
#include <termios.h>
#include <sys/stat.h>
#include <endian.h>

#ifndef BYTE_ORDER
# error unable to detect endian
#endif
#if BYTE_ORDER == BIG_ENDIAN
# define ldr_make_little_endian_16(x) \
	x = ((((x) & 0xff00) >> 8) | \
	     (((x) & 0x00ff) << 8))
# define ldr_make_little_endian_32(x) \
	x = ((((x) & 0xff000000) >> 24) | \
	     (((x) & 0x00ff0000) >>  8) | \
	     (((x) & 0x0000ff00) <<  8) | \
	     (((x) & 0x000000ff) << 24))
#elif BYTE_ORDER == LITTLE_ENDIAN
# define ldr_make_little_endian_16(x)
# define ldr_make_little_endian_32(x)
#else
# error unknown endian
#endif

#endif
