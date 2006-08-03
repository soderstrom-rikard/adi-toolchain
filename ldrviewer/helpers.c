/*
 * File:         helpers.c
 * Author:       Mike Frysinger <michael.frysinger@analog.com>
 *
 * Description:  some common utility functions
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

void *xmalloc(size_t size)
{
	void *ret = malloc(size);
	assert(ret != NULL);
	return ret;
}

void *xrealloc(void *ptr, size_t size)
{
	void *ret = realloc(ptr, size);
	assert(ret != NULL);
	return ret;
}
