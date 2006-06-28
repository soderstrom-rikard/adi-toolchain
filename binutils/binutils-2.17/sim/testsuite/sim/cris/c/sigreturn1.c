/* Test that TRT happens for spurious sigreturn calls.  Single-thread.
#notarget: cris*-*-elf
#xerror:
#output: Invalid sigreturn syscall: no signal handler active (0x1, 0x2, 0x3, 0x4, 0x5, 0x6)\n
#output: program stopped with signal 4.\n
*/

#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>
#include <stdlib.h>

int main (void)
{
  syscall (SYS_sigreturn, 1, 2, 3, 4, 5, 6);
  printf ("xyzzy\n");
  exit (0);
}
