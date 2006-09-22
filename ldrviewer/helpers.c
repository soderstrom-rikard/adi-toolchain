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
#include "helpers.h"

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

int parse_bool(const char *boo)
{
	if (strcmp(boo, "1") == 0 || strcasecmp(boo, "yes") == 0 ||	
	    strcasecmp(boo, "y") == 0 || strcasecmp(boo, "true") == 0)
		return 1;
	if (strcmp(boo, "0") == 0 || strcasecmp(boo, "no") == 0 ||
	    strcasecmp(boo, "n") == 0 || strcasecmp(boo, "false") == 0)
		return 0;
	err("Invalid boolean: '%s'", boo);
}
