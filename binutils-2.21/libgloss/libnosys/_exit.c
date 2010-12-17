/* Stub version of _exit.  */

#include <limits.h>
#include "config.h"
#include <_ansi.h>
#include <_syslist.h>

_VOID
_DEFUN (_exit, (rc),
	int rc)
{
#ifdef __BFIN__
  asm ("EXCPT 0;");
#else
  /* Default stub just causes a divide by 0 exception.  */
  int x = rc / INT_MAX;
  x = 4 / x;
  asm volatile ("" : : "r" (x));
#endif

  /* Convince GCC that this function never returns.  */
  for (;;)
    ;
}
