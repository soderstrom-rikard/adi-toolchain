/* Support files for GNU libc.  Files in the system namespace go here.
   Files in the C namespace (ie those that do not start with an
   underscore) go in .c.  */

#include <_ansi.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/fcntl.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <sys/times.h>
#include "sys/syscall.h"
#include <errno.h>
#include <reent.h>
#include <unistd.h>
#include "swi.h"

/* Forward prototypes.  */
int     _system     _PARAMS ((const char *));
int     _rename     _PARAMS ((const char *, const char *));
int     isatty		_PARAMS ((int));
clock_t _times		_PARAMS ((struct tms *));
int     _gettimeofday	_PARAMS ((struct timeval *, struct timezone *));
void    _raise 		_PARAMS ((void));
int     _unlink		_PARAMS ((void));
int     _link 		_PARAMS ((void));
int     _stat 		_PARAMS ((const char *, struct stat *));
int     _fstat 		_PARAMS ((int, struct stat *));
caddr_t _sbrk		_PARAMS ((int));
int     _getpid		_PARAMS ((int));
int     _kill		_PARAMS ((int, int));
void    _exit		_PARAMS ((int));
int     _close		_PARAMS ((int));
int     _swiclose	_PARAMS ((int));
int     _open		_PARAMS ((const char *, int, ...));
int     _swiopen	_PARAMS ((const char *, int));
int     _write 		_PARAMS ((int, char *, int));
int     _swiwrite	_PARAMS ((int, char *, int));
int     _lseek		_PARAMS ((int, int, int));
int     _swilseek	_PARAMS ((int, int, int));
int     _read		_PARAMS ((int, char *, int));
int     _swiread	_PARAMS ((int, char *, int));
void    initialise_monitor_handles _PARAMS ((void));

static int	wrap		_PARAMS ((int));
static int	error		_PARAMS ((int));
static int	get_errno	_PARAMS ((void));
static int	remap_handle	_PARAMS ((int));
static int	do_AngelSWI	_PARAMS ((int, void *));
static int 	findslot	_PARAMS ((int));

/* Register name faking - works in collusion with the linker.  */
register char * stack_ptr asm ("SP");


/* following is copied from libc/stdio/local.h to check std streams */
extern void   _EXFUN(__sinit,(struct _reent *));
#define CHECK_INIT(fp) \
  do                                    \
    {                                   \
      if ((fp)->_data == 0)             \
        (fp)->_data = _REENT;           \
      if (!(fp)->_data->__sdidinit)     \
        __sinit ((fp)->_data);          \
    }                                   \
  while (0)

/* Adjust our internal handles to stay away from std* handles.  */
#define FILE_HANDLE_OFFSET (0x20)

static int std_files_checked;
static int monitor_stdin;
static int monitor_stdout;
static int monitor_stderr;

/* Struct used to keep track of the file position, just so we
   can implement fseek(fh,x,SEEK_CUR).  */
typedef struct
{
  int handle;
  int pos;
}
poslog;

#define MAX_OPEN_FILES 20
static poslog openfiles [MAX_OPEN_FILES];

static int
findslot (int fh)
{
  int i;
  for (i = 0; i < MAX_OPEN_FILES; i ++)
    if (openfiles[i].handle == fh)
      break;
  return i;
}

static inline int
do_syscall (int reason, void * arg)
{
  int value = 1;
  asm volatile ("[--sp] = %1;[--sp] = %2;r1 = [sp++]; r0 = [sp++]; r2 = %3; raise 0; %0 = r0"
		: "=r" (value) /* Outputs */
		: "r" (reason), "r" (arg), "i" (AngelSWI) /* Inputs */
		: "R0", "R1", "R2", "R3", "memory", "cc");
  return value;
}

/* Function to convert std(in|out|err) handles to internal versions.  */
static int
remap_handle (int fh)
{
  if (!std_files_checked)
    {
       CHECK_INIT(stdin);
       CHECK_INIT(stdout);
       CHECK_INIT(stderr);
       std_files_checked = 1;
    }
  if (fh == STDIN_FILENO)
    return monitor_stdin;
  if (fh == STDOUT_FILENO)
    return monitor_stdout;
  if (fh == STDERR_FILENO)
    return monitor_stderr;

  return fh - FILE_HANDLE_OFFSET;
}

void
initialise_monitor_handles (void)
{
  int i;
  
  int volatile block[3];
  
  block[0] = (int) ":tt";
  block[2] = 3;     /* length of filename */
  block[1] = 0;     /* mode "r" */
  monitor_stdin = do_syscall (SYS_open, (void *) block);

  block[0] = (int) ":tt";
  block[2] = 3;     /* length of filename */
  block[1] = 4;     /* mode "w" */
  monitor_stdout = monitor_stderr = do_syscall (AngelSWI_Reason_Open, (void *) block);

  for (i = 0; i < MAX_OPEN_FILES; i ++)
    openfiles[i].handle = -1;

  openfiles[0].handle = monitor_stdin;
  openfiles[0].pos = 0;
  openfiles[1].handle = monitor_stdout;
  openfiles[1].pos = 0;
}

static int
get_errno (void)
{
  return 0 /*do_syscall (SYS_errno, NULL) */;
}

static int
error (int result)
{
  errno = get_errno ();
  return result;
}

static int
wrap (int result)
{
  if (result == -1)
    return error (-1);
  return result;
}

/* Returns # chars not! written.  */
int
_swiread (int file,
	  char * ptr,
	  int len)
{
  int fh = remap_handle (file);
  int block[3];
  
  block[0] = fh;
  block[1] = (int) ptr;
  block[2] = len;
  
  return do_syscall (AngelSWI_Reason_Read, block);
}

int
_read (int file,
       char * ptr,
       int len)
{
  int slot = findslot (remap_handle (file));
  int x = _swiread (file, ptr, len);

  if (x < 0)
    return error (-1);

  if (slot != MAX_OPEN_FILES)
    openfiles [slot].pos += len - x;

  /* x == len is not an error, at least if we want feof() to work.  */
  return len - x;
}

int
_swilseek (int file,
	   int ptr,
	   int dir)
{
  int res;
  int fh = remap_handle (file);
  int slot = findslot (fh);
  int block[2];

  if (dir == SEEK_CUR)
    {
      if (slot == MAX_OPEN_FILES)
	return -1;
      ptr = openfiles[slot].pos + ptr;
      dir = SEEK_SET;
    }
  
  if (dir == SEEK_END)
    {
      block[0] = fh;
      ptr += do_syscall (AngelSWI_Reason_FLen, block);
    }
  
  /* This code only does absolute seeks.  */
  block[0] = remap_handle (file);
  block[1] = ptr;
  res = do_syscall (AngelSWI_Reason_Seek, block);

  if (slot != MAX_OPEN_FILES && res == 0)
    openfiles[slot].pos = ptr;

  /* This is expected to return the position in the file.  */
  return res == 0 ? ptr : -1;
}

int
_lseek (int file,
	int ptr,
	int dir)
{
  return wrap (_swilseek (file, ptr, dir));
}

/* Returns #chars not! written.  */
int
_swiwrite (
	   int    file,
	   char * ptr,
	   int    len)
{
  int fh = remap_handle (file);
  int block[3];
  
  block[0] = fh;
  block[1] = (int) ptr;
  block[2] = len;
  
  return do_syscall (AngelSWI_Reason_Write, block);
}

int
_write (int    file,
	char * ptr,
	int    len)
{
  int slot = findslot (remap_handle (file));
  int x = _swiwrite (file, ptr,len);

  if (x == -1 || x == len)
    return error (-1);
  
  if (slot != MAX_OPEN_FILES)
    openfiles[slot].pos += len - x;
  
  return len - x;
}

extern int strlen (const char *);

int
_swiopen (const char * path,
	  int          flags)
{
  int aflags = 0, fh;
  int block[3];
  
  int i = findslot (-1);
  
  if (i == MAX_OPEN_FILES)
    return -1;

  block[0] = (int) path;
  block[1] = flags;

  fh = do_syscall (SYS_open, block);

  if (fh >= 0)
    {
      openfiles[i].handle = fh;
      openfiles[i].pos = 0;
    }

  return fh >= 0 ? fh + FILE_HANDLE_OFFSET : error (fh);
}

int
_open (const char * path,
       int          flags,
       ...)
{
  return wrap (_swiopen (path, flags));
}

int
_swiclose (int file)
{
  int myhan = remap_handle (file);
  int slot = findslot (myhan);
  
  if (slot != MAX_OPEN_FILES)
    openfiles[slot].handle = -1;

  return do_syscall (SYS_close, & myhan);
}

int
_close (int file)
{
  return wrap (_swiclose (file));
}

void
_exit (int n)
{
  /* FIXME: return code is thrown away.  */
  
  do_syscall (SYS_exit, (void *) &n);
}

int
_kill (int n, int m)
{
  int block[2];
  block[0] = n;
  block[1] = m;
  return do_syscall (SYS_kill, block);
}

int
_getpid (int n)
{
  return 1;
  n = n;
}

caddr_t
_sbrk (int incr)
{
  extern char   end asm ("end");	/* Defined by the linker.  */
  static char * heap_end;
  char *        prev_heap_end;

  if (heap_end == NULL)
    heap_end = & end;
  
  prev_heap_end = heap_end;
  
  if (heap_end + incr > stack_ptr)
    {
      /* Some of the libstdc++-v3 tests rely upon detecting
	 out of memory errors, so do not abort here.  */
#if 0
      extern void abort (void);

      _write (1, "_sbrk: Heap and stack collision\n", 32);
      
      abort ();
#else
      errno = ENOMEM;
      return (caddr_t) -1;
#endif
    }
  
  heap_end += incr;

  return (caddr_t) prev_heap_end;
}

extern void memset (struct stat *, int, unsigned int);

int
_fstat (int file, struct stat * st)
{
  memset (st, 0, sizeof (* st));
  st->st_mode = S_IFCHR;
  st->st_blksize = 1024;
  return 0;
  file = file;
}

int _stat (const char *fname, struct stat *st)
{
  int file;

  /* The best we can do is try to open the file readonly.  If it exists,
     then we can guess a few things about it.  */
  if ((file = _open (fname, O_RDONLY)) < 0)
    return -1;

  memset (st, 0, sizeof (* st));
  st->st_mode = S_IFREG | S_IREAD;
  st->st_blksize = 1024;
  _swiclose (file); /* Not interested in the error.  */
  return 0;
}

int
_link (void)
{
  return -1;
}

int
_unlink (void)
{
  return -1;
}

void
_raise (void)
{
  return;
}

int
_gettimeofday (struct timeval * tp, struct timezone * tzp)
{

  if (tp)
    {
    /* Ask the host for the seconds since the Unix epoch.  */
      tp->tv_sec = do_syscall (AngelSWI_Reason_Time,NULL);
      tp->tv_usec = 0;
    }

  /* Return fixed data for the timezone.  */
  if (tzp)
    {
      tzp->tz_minuteswest = 0;
      tzp->tz_dsttime = 0;
    }

  return 0;
}

/* Return a clock that ticks at 100Hz.  */
clock_t 
_times (struct tms * tp)
{
  clock_t timeval;

  timeval = do_syscall (AngelSWI_Reason_Clock,NULL);

  if (tp)
    {
      tp->tms_utime  = timeval;	/* user time */
      tp->tms_stime  = 0;	/* system time */
      tp->tms_cutime = 0;	/* user time, children */
      tp->tms_cstime = 0;	/* system time, children */
    }
  
  return timeval;
};


int
isatty (int fd)
{
  return 1;
  fd = fd;
}

int
_system (const char *s)
{
  if (s == NULL)
    return 0;
  errno = ENOSYS;
  return -1;
}

int
_rename (const char * oldpath, const char * newpath)
{
  errno = ENOSYS;
  return -1;
}
