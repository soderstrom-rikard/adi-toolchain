#include <unistd.h>
#include <errno.h>
#include <sys/syscall.h>

_syscall3 (int, cacheflush, char *, start, int, nbytes, int, flags);

