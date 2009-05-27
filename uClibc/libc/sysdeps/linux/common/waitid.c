/* vi: set sw=4 ts=4: */
/*
 * Copyright (C) 2007 Erik Andersen <andersen@uclibc.org>
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */

#include <sys/syscall.h>

#if defined __USE_SVID || defined __USE_XOPEN
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

/* The waitid() POSIX interface takes 4 arguments, but the kernel function
 * actually takes 5.  The fifth is a pointer to struct rusage.  Make sure
 * we pass NULL rather than letting whatever was in the register bleed up.
 */
#define __NR_waitid5 __NR_waitid
static _syscall5(int, waitid5, idtype_t, idtype, id_t, id, siginfo_t*, infop,
                 int, options, struct rusage*, ru)

int waitid(idtype_t idtype, id_t id, siginfo_t *infop, int options)
{
	return waitid5(idtype, id, infop, options, NULL);
}

#endif
