#include <_ansi.h>

_VOID
_DEFUN (_exit, (rc),
	int rc)
{
  while (1)
    asm volatile ("EXCPT 0;");
}
