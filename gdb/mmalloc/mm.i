# 1 "./mm.c"
 























# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 1 3
 

















 






# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/features.h" 1 3
 




















 



 





























































 




















 





 



 







 
# 145 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/features.h" 3


 









 








 



























# 211 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/features.h" 3


































 



 


 




 










 












 
















 


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/cdefs.h" 1 3
 




















 




 






 





 








 



# 65 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/cdefs.h" 3


 





 




 









 







 

















 














 







 






 








 








 











 










 







 




 


















# 301 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/features.h" 2 3



 








 





 
# 332 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/features.h" 3


 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/uClibc_config.h" 1 3
 
























# 336 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/features.h" 2 3



 


 







 






 

# 370 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/features.h" 3


 
# 431 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/features.h" 3




# 26 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 2 3


 

 


 



 


 


 


 



 



 



 



 






 


 




 


 


 



 



 



















































































# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/posix_opt.h" 1 3
 





















 


 


 


 


 


 


 


 


 


 


 


 


 



 


 


 


 


 


 



 


 


 


 
 

 


 

 


 


 





# 175 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 2 3


 




 





 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/types.h" 1 3
 

















 




typedef unsigned int __socklen_t;  
typedef unsigned int __useconds_t;  
typedef int __clockid_t;  
typedef int __timer_t;  




# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


































typedef long unsigned int size_t;






















 




 

# 271 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


# 283 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 





















# 32 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/types.h" 2 3


 
typedef unsigned char __u_char;
typedef unsigned short __u_short;
typedef unsigned int __u_int;
typedef unsigned long __u_long;

__extension__ typedef unsigned long long int __u_quad_t;
__extension__ typedef long long int __quad_t;
# 51 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/types.h" 3

typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;

__extension__ typedef signed long long int __int64_t;
__extension__ typedef unsigned long long int __uint64_t;

typedef __quad_t *__qaddr_t;

typedef __u_quad_t __dev_t;		 
typedef __u_int __uid_t;		 
typedef __u_int __gid_t;		 
typedef __u_long __ino_t;		 
typedef __u_int __mode_t;		 
typedef __u_int __nlink_t; 		 
typedef long int __off_t;		 
typedef __quad_t __loff_t;		 
typedef int __pid_t;			 
typedef int __ssize_t;			 
typedef __u_long __rlim_t;		 
typedef __u_quad_t __rlim64_t;		 
typedef __u_int __id_t;			 

typedef struct
  {
    int __val[2];
  } __fsid_t;				 

 
typedef int __daddr_t;			 
typedef char *__caddr_t;
typedef long int __time_t;
typedef long int __swblk_t;		 

typedef long int __clock_t;

 
typedef unsigned long int __fd_mask;

 


 




 
typedef struct
  {
     





    __fd_mask __fds_bits[1024  / (8 * sizeof (__fd_mask)) ];


  } __fd_set;


typedef int __key_t;

 
typedef unsigned short int __ipc_pid_t;


 

 
typedef long int __blkcnt_t;
typedef __quad_t __blkcnt64_t;

 
typedef __u_long __fsblkcnt_t;
typedef __u_quad_t __fsblkcnt64_t;

 
typedef __u_long __fsfilcnt_t;
typedef __u_quad_t __fsfilcnt64_t;

 
typedef __u_long __ino64_t;

 
typedef __loff_t __off64_t;

 
typedef long int __t_scalar_t;
typedef unsigned long int __t_uscalar_t;

 
typedef int __intptr_t;


 





# 190 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 2 3



typedef __ssize_t ssize_t;





# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 

# 271 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


# 283 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 





















# 199 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 2 3


# 236 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 3




typedef __intptr_t intptr_t;






 




 






 
extern int access (__const char *__name, int __type)  ;









 







 






 





extern __off_t lseek (int __fd, __off_t __offset, int __whence)  ;
# 301 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 3





 
extern int close (int __fd)  ;

 

extern ssize_t read (int __fd, void *__buf, size_t __nbytes)  ;

 
extern ssize_t write (int __fd, __const void *__buf, size_t __n)  ;

# 348 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 3


 



extern int pipe (int __pipedes[2])  ;

 






extern unsigned int alarm (unsigned int __seconds)  ;

 






extern unsigned int sleep (unsigned int __seconds)  ;


 



extern __useconds_t ualarm (__useconds_t __value, __useconds_t __interval)
      ;

 

extern int usleep (__useconds_t __useconds)  ;



 

extern int pause (void)  ;


 
extern int chown (__const char *__file, __uid_t __owner, __gid_t __group)
      ;


 
extern int fchown (int __fd, __uid_t __owner, __gid_t __group)  ;


 

extern int lchown (__const char *__file, __uid_t __owner, __gid_t __group)
      ;



 
extern int chdir (__const char *__path)  ;


 
extern int fchdir (int __fd)  ;


 






extern char *getcwd (char *__buf, size_t __size)  ;










 


extern char *getwd (char *__buf)  ;



 
extern int dup (int __fd)  ;

 
extern int dup2 (int __fd, int __fd2)  ;

 
extern char **__environ;





 

extern int execve (__const char *__path, char *__const __argv[],
		   char *__const __envp[])  ;










 
extern int execv (__const char *__path, char *__const __argv[])  ;

 

extern int execle (__const char *__path, __const char *__arg, ...)  ;

 

extern int execl (__const char *__path, __const char *__arg, ...)  ;

 

extern int execvp (__const char *__file, char *__const __argv[])  ;

 


extern int execlp (__const char *__file, __const char *__arg, ...)  ;



 
extern int nice (int __inc)  ;



 
extern void _exit (int __status) __attribute__ ((__noreturn__));


 


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/confname.h" 1 3
 






















 
enum
  {
    _PC_LINK_MAX,

    _PC_MAX_CANON,

    _PC_MAX_INPUT,

    _PC_NAME_MAX,

    _PC_PATH_MAX,

    _PC_PIPE_BUF,

    _PC_CHOWN_RESTRICTED,

    _PC_NO_TRUNC,

    _PC_VDISABLE,

    _PC_SYNC_IO,

    _PC_ASYNC_IO,

    _PC_PRIO_IO,

    _PC_SOCK_MAXBUF,

    _PC_FILESIZEBITS,

    _PC_REC_INCR_XFER_SIZE,

    _PC_REC_MAX_XFER_SIZE,

    _PC_REC_MIN_XFER_SIZE,

    _PC_REC_XFER_ALIGN,

    _PC_ALLOC_SIZE_MIN,

    _PC_SYMLINK_MAX

  };

 
enum
  {
    _SC_ARG_MAX,

    _SC_CHILD_MAX,

    _SC_CLK_TCK,

    _SC_NGROUPS_MAX,

    _SC_OPEN_MAX,

    _SC_STREAM_MAX,

    _SC_TZNAME_MAX,

    _SC_JOB_CONTROL,

    _SC_SAVED_IDS,

    _SC_REALTIME_SIGNALS,

    _SC_PRIORITY_SCHEDULING,

    _SC_TIMERS,

    _SC_ASYNCHRONOUS_IO,

    _SC_PRIORITIZED_IO,

    _SC_SYNCHRONIZED_IO,

    _SC_FSYNC,

    _SC_MAPPED_FILES,

    _SC_MEMLOCK,

    _SC_MEMLOCK_RANGE,

    _SC_MEMORY_PROTECTION,

    _SC_MESSAGE_PASSING,

    _SC_SEMAPHORES,

    _SC_SHARED_MEMORY_OBJECTS,

    _SC_AIO_LISTIO_MAX,

    _SC_AIO_MAX,

    _SC_AIO_PRIO_DELTA_MAX,

    _SC_DELAYTIMER_MAX,

    _SC_MQ_OPEN_MAX,

    _SC_MQ_PRIO_MAX,

    _SC_VERSION,

    _SC_PAGESIZE,


    _SC_RTSIG_MAX,

    _SC_SEM_NSEMS_MAX,

    _SC_SEM_VALUE_MAX,

    _SC_SIGQUEUE_MAX,

    _SC_TIMER_MAX,


     

    _SC_BC_BASE_MAX,

    _SC_BC_DIM_MAX,

    _SC_BC_SCALE_MAX,

    _SC_BC_STRING_MAX,

    _SC_COLL_WEIGHTS_MAX,

    _SC_EQUIV_CLASS_MAX,

    _SC_EXPR_NEST_MAX,

    _SC_LINE_MAX,

    _SC_RE_DUP_MAX,

    _SC_CHARCLASS_NAME_MAX,


    _SC_2_VERSION,

    _SC_2_C_BIND,

    _SC_2_C_DEV,

    _SC_2_FORT_DEV,

    _SC_2_FORT_RUN,

    _SC_2_SW_DEV,

    _SC_2_LOCALEDEF,


    _SC_PII,

    _SC_PII_XTI,

    _SC_PII_SOCKET,

    _SC_PII_INTERNET,

    _SC_PII_OSI,

    _SC_POLL,

    _SC_SELECT,

    _SC_UIO_MAXIOV,

    _SC_IOV_MAX = _SC_UIO_MAXIOV ,

    _SC_PII_INTERNET_STREAM,

    _SC_PII_INTERNET_DGRAM,

    _SC_PII_OSI_COTS,

    _SC_PII_OSI_CLTS,

    _SC_PII_OSI_M,

    _SC_T_IOV_MAX,


     
    _SC_THREADS,

    _SC_THREAD_SAFE_FUNCTIONS,

    _SC_GETGR_R_SIZE_MAX,

    _SC_GETPW_R_SIZE_MAX,

    _SC_LOGIN_NAME_MAX,

    _SC_TTY_NAME_MAX,

    _SC_THREAD_DESTRUCTOR_ITERATIONS,

    _SC_THREAD_KEYS_MAX,

    _SC_THREAD_STACK_MIN,

    _SC_THREAD_THREADS_MAX,

    _SC_THREAD_ATTR_STACKADDR,

    _SC_THREAD_ATTR_STACKSIZE,

    _SC_THREAD_PRIORITY_SCHEDULING,

    _SC_THREAD_PRIO_INHERIT,

    _SC_THREAD_PRIO_PROTECT,

    _SC_THREAD_PROCESS_SHARED,


    _SC_NPROCESSORS_CONF,

    _SC_NPROCESSORS_ONLN,

    _SC_PHYS_PAGES,

    _SC_AVPHYS_PAGES,

    _SC_ATEXIT_MAX,

    _SC_PASS_MAX,


    _SC_XOPEN_VERSION,

    _SC_XOPEN_XCU_VERSION,

    _SC_XOPEN_UNIX,

    _SC_XOPEN_CRYPT,

    _SC_XOPEN_ENH_I18N,

    _SC_XOPEN_SHM,


    _SC_2_CHAR_TERM,

    _SC_2_C_VERSION,

    _SC_2_UPE,


    _SC_XOPEN_XPG2,

    _SC_XOPEN_XPG3,

    _SC_XOPEN_XPG4,


    _SC_CHAR_BIT,

    _SC_CHAR_MAX,

    _SC_CHAR_MIN,

    _SC_INT_MAX,

    _SC_INT_MIN,

    _SC_LONG_BIT,

    _SC_WORD_BIT,

    _SC_MB_LEN_MAX,

    _SC_NZERO,

    _SC_SSIZE_MAX,

    _SC_SCHAR_MAX,

    _SC_SCHAR_MIN,

    _SC_SHRT_MAX,

    _SC_SHRT_MIN,

    _SC_UCHAR_MAX,

    _SC_UINT_MAX,

    _SC_ULONG_MAX,

    _SC_USHRT_MAX,


    _SC_NL_ARGMAX,

    _SC_NL_LANGMAX,

    _SC_NL_MSGMAX,

    _SC_NL_NMAX,

    _SC_NL_SETMAX,

    _SC_NL_TEXTMAX,


    _SC_XBS5_ILP32_OFF32,

    _SC_XBS5_ILP32_OFFBIG,

    _SC_XBS5_LP64_OFF64,

    _SC_XBS5_LPBIG_OFFBIG,


    _SC_XOPEN_LEGACY,

    _SC_XOPEN_REALTIME,

    _SC_XOPEN_REALTIME_THREADS,


    _SC_ADVISORY_INFO,

    _SC_BARRIERS,

    _SC_BASE,

    _SC_C_LANG_SUPPORT,

    _SC_C_LANG_SUPPORT_R,

    _SC_CLOCK_SELECTION,

    _SC_CPUTIME,

    _SC_THREAD_CPUTIME,

    _SC_DEVICE_IO,

    _SC_DEVICE_SPECIFIC,

    _SC_DEVICE_SPECIFIC_R,

    _SC_FD_MGMT,

    _SC_FIFO,

    _SC_PIPE,

    _SC_FILE_ATTRIBUTES,

    _SC_FILE_LOCKING,

    _SC_FILE_SYSTEM,

    _SC_MONOTONIC_CLOCK,

    _SC_MULTI_PROCESS,

    _SC_SINGLE_PROCESS,

    _SC_NETWORKING,

    _SC_READER_WRITER_LOCKS,

    _SC_SPIN_LOCKS,

    _SC_REGEXP,

    _SC_REGEX_VERSION,

    _SC_SHELL,

    _SC_SIGNALS,

    _SC_SPAWN,

    _SC_SPORADIC_SERVER,

    _SC_THREAD_SPORADIC_SERVER,

    _SC_SYSTEM_DATABASE,

    _SC_SYSTEM_DATABASE_R,

    _SC_TIMEOUTS,

    _SC_TYPED_MEMORY_OBJECTS,

    _SC_USER_GROUPS,

    _SC_USER_GROUPS_R,

    _SC_2_PBS,

    _SC_2_PBS_ACCOUNTING,

    _SC_2_PBS_LOCATE,

    _SC_2_PBS_MESSAGE,

    _SC_2_PBS_TRACK,

    _SC_SYMLOOP_MAX,

    _SC_STREAMS,

    _SC_2_PBS_CHECKPOINT,


    _SC_V6_ILP32_OFF32,

    _SC_V6_ILP32_OFFBIG,

    _SC_V6_LP64_OFF64,

    _SC_V6_LPBIG_OFFBIG,


    _SC_HOST_NAME_MAX,

    _SC_TRACE,

    _SC_TRACE_EVENT_FILTER,

    _SC_TRACE_INHERIT,

    _SC_TRACE_LOG

  };




 
enum
  {
    _CS_PATH,			 


# 492 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/confname.h" 3


# 527 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/confname.h" 3

# 561 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/confname.h" 3


    _CS_V6_WIDTH_RESTRICTED_ENVS

  };

# 503 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 2 3


 
extern long int pathconf (__const char *__path, int __name)  ;

 
extern long int fpathconf (int __fd, int __name)  ;

 
extern long int sysconf (int __name)   __attribute__ ((__const__));


 
extern size_t confstr (int __name, char *__buf, size_t __len)  ;



 
extern __pid_t getpid (void)  ;

 
extern __pid_t getppid (void)  ;

 


extern __pid_t getpgrp (void)  ;








 
extern __pid_t __getpgid (__pid_t __pid)  ;





 


extern int setpgid (__pid_t __pid, __pid_t __pgid)  ;


 











 

extern int setpgrp (void)  ;

# 577 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 3



 


extern __pid_t setsid (void)  ;






 
extern __uid_t getuid (void)  ;

 
extern __uid_t geteuid (void)  ;

 
extern __gid_t getgid (void)  ;

 
extern __gid_t getegid (void)  ;

 


extern int getgroups (int __size, __gid_t __list[])  ;







 



extern int setuid (__uid_t __uid)  ;


 

extern int setreuid (__uid_t __ruid, __uid_t __euid)  ;



 
extern int seteuid (__uid_t __uid)  ;


 



extern int setgid (__gid_t __gid)  ;


 

extern int setregid (__gid_t __rgid, __gid_t __egid)  ;



 
extern int setegid (__gid_t __gid)  ;



 


extern __pid_t fork (void)  ;


 



extern __pid_t vfork (void)  ;



 

extern char *ttyname (int __fd)  ;

 

extern int ttyname_r (int __fd, char *__buf, size_t __buflen)  ;

 

extern int isatty (int __fd)  ;



 

extern int ttyslot (void)  ;



 
extern int link (__const char *__from, __const char *__to)  ;


 
extern int symlink (__const char *__from, __const char *__to)  ;

 


extern int readlink (__const char *__restrict __path, char *__restrict __buf,
		     size_t __len)  ;


 
extern int unlink (__const char *__name)  ;

 
extern int rmdir (__const char *__path)  ;


 
extern __pid_t tcgetpgrp (int __fd)  ;

 
extern int tcsetpgrp (int __fd, __pid_t __pgrp_id)  ;


 
extern char *getlogin (void)  ;








 
extern int setlogin (__const char *__name)  ;




 



# 1 "../include/getopt.h" 1
 




























 





extern char *optarg;

 











extern int optind;

 


extern int opterr;

 

extern int optopt;

 




















struct option
{

  const char *name;



   

  int has_arg;
  int *flag;
  int val;
};

 






 






 


extern int getopt (int argc, char *const *argv, const char *shortopts);







extern int getopt_long (int argc, char *const *argv, const char *shortopts,
		        const struct option *longopts, int *longind);
extern int getopt_long_only (int argc, char *const *argv,
			     const char *shortopts,
		             const struct option *longopts, int *longind);

 
extern int _getopt_internal (int argc, char *const *argv,
			     const char *shortopts,
		             const struct option *longopts, int *longind,
			     int long_only);













# 730 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 2 3





 


extern int gethostname (char *__name, size_t __len)  ;




 

extern int sethostname (__const char *__name, size_t __len)  ;

 

extern int sethostid (long int __id)  ;


 


extern int getdomainname (char *__name, size_t __len)  ;
extern int setdomainname (__const char *__name, size_t __len)  ;


 


extern int vhangup (void)  ;

 
extern int revoke (__const char *__file)  ;


 




extern int profil (unsigned short int *__sample_buffer, size_t __size,
		   size_t __offset, unsigned int __scale)  ;


 


extern int acct (__const char *__name)  ;


 
extern char *getusershell (void)  ;
extern void endusershell (void)  ;  
extern void setusershell (void)  ;  


 


extern int daemon (int __nochdir, int __noclose)  ;




 

extern int chroot (__const char *__path)  ;

 

extern char *getpass (__const char *__prompt)  ;




 
extern int fsync (int __fd)  ;





 
extern long int gethostid (void)  ;

 
extern void sync (void)  ;


 

extern int getpagesize (void)    __attribute__ ((__const__));


 

extern int truncate (__const char *__file, __off_t __length)  ;
# 838 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 3





 

extern int ftruncate (int __fd, __off_t __length)  ;













 

extern int getdtablesize (void)  ;






 

extern int brk (void *__addr)  ;

 



extern void *sbrk (intptr_t __delta)  ;




 









extern long int syscall (long int __sysno, ...)  ;





 



 









extern int lockf (int __fd, int __cmd, __off_t __len)  ;














# 937 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 3



 

extern int fdatasync (int __fildes)  ;



 

# 963 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 3



 








 

 









extern int pthread_atfork (void (*__prepare) (void),
			   void (*__parent) (void),
			   void (*__child) (void))  ;


 


# 25 "./mm.c" 2


# 1 "mcalloc.c" 1
 

















# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 1 3
 

















 








 



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/time.h" 1 3
 
























# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 1 3
 

















 














# 51 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3








 
typedef __time_t time_t;




# 84 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 96 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3




# 112 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3




# 366 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 26 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/time.h" 2 3


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 1 3
 


















 



# 43 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 3








 

struct timeval
  {
    __time_t tv_sec;		 
    __time_t tv_usec;		 
  };

 
# 28 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/time.h" 2 3


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/select.h" 1 3
 


















 






 


 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/select.h" 1 3
 






















 











# 31 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/select.h" 2 3


 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigset.h" 1 3
 





















typedef int __sig_atomic_t;

 


typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int))) ];
  } __sigset_t;




 





# 125 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigset.h" 3

# 34 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/select.h" 2 3




typedef __sigset_t sigset_t;


 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 1 3
 

















 














# 51 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 72 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 84 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 96 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3








 

struct timespec
  {
    long int tv_sec;		 
    long int tv_nsec;		 
  };





# 366 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 43 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/select.h" 2 3


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 1 3
 


















 



# 43 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 3




# 58 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 3

 
# 45 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/select.h" 2 3



 
 

 




 
typedef struct
  {
     





    __fd_mask __fds_bits[1024  / (8 * sizeof (__fd_mask)) ];


  } fd_set;

 



 
typedef __fd_mask fd_mask;

 




 






 

 




extern int select (int __nfds, fd_set *__restrict __readfds,
		   fd_set *__restrict __writefds,
		   fd_set *__restrict __exceptfds,
		   struct timeval *__restrict __timeout)  ;

# 110 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/select.h" 3


 


# 30 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/time.h" 2 3

typedef long int __suseconds_t; 






 

# 50 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/time.h" 3




 

struct timezone
  {
    int tz_minuteswest;		 
    int tz_dsttime;		 
  };

typedef struct timezone *__restrict __timezone_ptr_t;




 




extern int gettimeofday (struct timeval *__restrict __tv,
			 __timezone_ptr_t __tz)  ;


 

extern int settimeofday (__const struct timeval *__tv,
			 __const struct timezone *__tz)  ;

 



extern int adjtime (__const struct timeval *__delta,
		    struct timeval *__olddelta)  ;



 
enum __itimer_which
  {
     
    ITIMER_REAL = 0,

     
    ITIMER_VIRTUAL = 1,

     

    ITIMER_PROF = 2

  };

 

struct itimerval
  {
     
    struct timeval it_interval;
     
    struct timeval it_value;
  };






typedef int __itimer_which_t;


 

extern int getitimer (__itimer_which_t __which,
		      struct itimerval *__value)  ;

 


extern int setitimer (__itimer_which_t __which,
		      __const struct itimerval *__restrict __new,
		      struct itimerval *__restrict __old)  ;

 

extern int utimes (__const char *__file, __const struct timeval __tvp[2])
      ;



 








# 160 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/time.h" 3

# 169 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/time.h" 3


 


# 32 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 2 3

 


typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;




typedef __loff_t loff_t;



typedef __ino_t ino_t;











typedef __dev_t dev_t;




typedef __gid_t gid_t;




typedef __mode_t mode_t;




typedef __nlink_t nlink_t;




typedef __uid_t uid_t;





typedef __off_t off_t;











typedef __pid_t pid_t;




typedef __id_t id_t;










typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;





typedef __key_t key_t;









# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 1 3
 

















 














# 51 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 72 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3









 
typedef __clockid_t clockid_t;










 
typedef __timer_t timer_t;





# 112 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3




# 366 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 134 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 2 3


# 145 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 3



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 

# 271 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


# 283 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 





















# 148 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 2 3



 
typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;


 

# 182 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 3


 







typedef int int8_t __attribute__ ((__mode__ (  __QI__ ))) ;
typedef int int16_t __attribute__ ((__mode__ (  __HI__ ))) ;
typedef int int32_t __attribute__ ((__mode__ (  __SI__ ))) ;
typedef int int64_t __attribute__ ((__mode__ (  __DI__ ))) ;


typedef unsigned int u_int8_t __attribute__ ((__mode__ (  __QI__ ))) ;
typedef unsigned int u_int16_t __attribute__ ((__mode__ (  __HI__ ))) ;
typedef unsigned int u_int32_t __attribute__ ((__mode__ (  __SI__ ))) ;
typedef unsigned int u_int64_t __attribute__ ((__mode__ (  __DI__ ))) ;

typedef int register_t __attribute__ ((__mode__ (__word__)));


 






 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/endian.h" 1 3
 






















 











 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/endian.h" 1 3
 






# 37 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/endian.h" 2 3


 



















# 214 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 2 3


 


 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/sysmacros.h" 1 3
 





















 








# 47 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/sysmacros.h" 3



# 220 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 2 3










 


typedef __blkcnt_t blkcnt_t;	  



typedef __fsblkcnt_t fsblkcnt_t;  



typedef __fsfilcnt_t fsfilcnt_t;  


# 257 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 3








 


# 19 "mcalloc.c" 2

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 1 3
 

















 








 

 


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 

# 271 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


# 283 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 





















# 33 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 2 3



 
extern void *memcpy (void *__restrict __dest,
		     __const void *__restrict __src, size_t __n)  ;
 

extern void *memmove (void *__dest, __const void *__src, size_t __n)
      ;

 



extern void *memccpy (void *__restrict __dest, __const void *__restrict __src,
		      int __c, size_t __n)
      ;



 
extern void *memset (void *__s, int __c, size_t __n)  ;

 
extern int memcmp (__const void *__s1, __const void *__s2, size_t __n)
        ;

 
extern void *memchr (__const void *__s, int __c, size_t __n)
         ;

 






 
extern void *memrchr (__const void *__s, int __c, size_t __n)
         ;


 
extern char *strcpy (char *__restrict __dest, __const char *__restrict __src)
      ;
 
extern char *strncpy (char *__restrict __dest,
		      __const char *__restrict __src, size_t __n)  ;

 
extern char *strcat (char *__restrict __dest, __const char *__restrict __src)
      ;
 
extern char *strncat (char *__restrict __dest, __const char *__restrict __src,
		      size_t __n)  ;

 
extern int strcmp (__const char *__s1, __const char *__s2)
        ;
 
extern int strncmp (__const char *__s1, __const char *__s2, size_t __n)
        ;

 
extern int strcoll (__const char *__s1, __const char *__s2)
        ;
 
extern size_t strxfrm (char *__restrict __dest,
		       __const char *__restrict __src, size_t __n)  ;

# 118 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 3



 
extern char *strdup (__const char *__s)    ;


 







# 154 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 3


 
extern char *strchr (__const char *__s, int __c)    ;
 
extern char *strrchr (__const char *__s, int __c)    ;








 

extern size_t strcspn (__const char *__s, __const char *__reject)
        ;
 

extern size_t strspn (__const char *__s, __const char *__accept)
        ;
 
extern char *strpbrk (__const char *__s, __const char *__accept)
        ;
 
extern char *strstr (__const char *__haystack, __const char *__needle)
        ;







 
extern char *strtok (char *__restrict __s, __const char *__restrict __delim)
      ;

 

extern char *__strtok_r (char *__restrict __s,
			 __const char *__restrict __delim,
			 char **__restrict __save_ptr)  ;

extern char *strtok_r (char *__restrict __s, __const char *__restrict __delim,
		       char **__restrict __save_ptr)  ;


# 219 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 3



 
extern size_t strlen (__const char *__s)    ;









 
extern char *strerror (int __errnum)  ;

 


extern char *_glibc_strerror_r (int __errnum, char *__buf, size_t __buflen)  ;
extern int _susv3_strerror_r (int __errnum, char *__buf, size_t buflen)  ;

# 250 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 3


extern char *  strerror_r   
                         (int __errnum, char *__buf, size_t buflen)    __asm__ (""   "_glibc_strerror_r"  ) ;






 

extern void __bzero (void *__s, size_t __n)  ;


 
extern void bcopy (__const void *__src, void *__dest, size_t __n)  ;

 
extern void bzero (void *__s, size_t __n)  ;

 
extern int bcmp (__const void *__s1, __const void *__s2, size_t __n)
        ;

 
extern char *index (__const char *__s, int __c)    ;

 
extern char *rindex (__const char *__s, int __c)    ;

 

extern int ffs (int __i)   __attribute__ ((__const__));

 










 
extern int strcasecmp (__const char *__s1, __const char *__s2)
        ;

 
extern int strncasecmp (__const char *__s1, __const char *__s2, size_t __n)
        ;


# 315 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 3



 

extern char *strsep (char **__restrict __stringp,
		     __const char *__restrict __delim)  ;


# 362 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 3


# 393 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 3



 
extern size_t strlcat(char *__restrict dst, const char *__restrict src,
                      size_t n)  ;
extern size_t strlcpy(char *__restrict dst, const char *__restrict src,
                      size_t n)  ;


 


# 20 "mcalloc.c" 2


# 1 "mmprivate.h" 1
 



























# 1 "mmalloc.h" 1




# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 







 

 




 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 





















typedef long int ptrdiff_t;









 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 





























 


























typedef int wchar_t;
























typedef unsigned int  wint_t;




 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 5 "mmalloc.h" 2






# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 11 "mmalloc.h" 2

 
 

extern void *  mmalloc  (void * , size_t)  ;

 


extern void *  mrealloc  (void * , void * , size_t)  ;

 

extern void *  mcalloc  (void * , size_t, size_t)  ;

 

extern void mfree  (void * , void * )  ;

 

extern void *  mmemalign  (void * , size_t, size_t)  ;

 

extern void *  mvalloc  (void * , size_t)  ;

 

extern int mmcheck  (void * , void (*) (void))  ;

extern int mmcheckf  (void * , void (*) (void), int)  ;

 

extern struct mstats mmstats  (void * )  ;

extern void *  mmalloc_attach  (int, void * )  ;

extern void *  mmalloc_detach  (void * )  ;

extern int mmalloc_setkey  (void * , int, void * )  ;

extern void *  mmalloc_getkey  (void * , int)  ;

extern int mmalloc_errno  (void * )  ;

extern int mmtrace  (void)  ;

extern void *  mmalloc_findbase  (int)  ;


# 29 "mmprivate.h" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/limits.h" 1 3



 



 



 




 





 



 












 

 




 



 








 



 













 



# 95 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/limits.h" 3




# 32 "mmprivate.h" 2
















 










 









 




 




 






 





 

typedef union
  {
     
    struct
      {
	 

	int type;
	union
	  {
	    struct
	      {
		size_t nfree;	 
		size_t first;	 
	      } frag;
	     
	    size_t size;
	  } info;
      } busy;
     

    struct
      {
	size_t size;		 
	size_t next;		 
	size_t prev;		 
      } free;
  } malloc_info;

 

struct alignlist
  {
    struct alignlist *next;
    void *  aligned;		 
    void *  exact;			 
  };

 

struct list
  {
    struct list *next;
    struct list *prev;
  };

 





struct mstats
  {
    size_t bytes_total;		 
    size_t chunks_used;		 
    size_t bytes_used;		 
    size_t chunks_free;		 
    size_t bytes_free;		 
  };

 




struct mdesc
{
   

  char magic[8 ];

   


  unsigned int headersize;

   

  unsigned char version;

   

  unsigned int flags;

   


  int saved_errno;

   









  void *  (*morecore)  (struct mdesc *, int)  ;
     
   






  void (*abortfunc)  (void)  ;

   




  void (*mfree_hook)  (void * , void * )  ;

   




  void *  (*mmalloc_hook)  (void * , size_t)  ;

   




  void *  (*mrealloc_hook)  (void * , void * , size_t)  ;

   

  size_t heapsize;

   

  char *heapbase;

   
   

  size_t heapindex;

   

  size_t heaplimit;

   

   

  malloc_info *heapinfo;

   

  struct mstats heapstats;

   
   

  struct list fraghead[((8  * sizeof(int))  > 16 ? 12 : 9) ];

   

  struct alignlist *aligned_blocks;

   



  char *base;

   


  char *breakval;

   


  char *top;

   




  int fd;

   


  void *  keys[16 ];

};

 





 

extern void __mmalloc_free  (struct mdesc *, void * )  ;

 

extern void (*__mfree_hook)  (void * , void * )  ;
extern void *  (*__mmalloc_hook)  (void * , size_t)  ;
extern void *  (*__mrealloc_hook)  (void * , void * , size_t)  ;

 

extern struct mdesc *__mmalloc_default_mdp;

 


extern struct mdesc *__mmalloc_sbrk_init  (void)  ;

 








 

extern void *  __mmalloc_remap_core  (struct mdesc *)  ;

 













# 22 "mcalloc.c" 2


 


void * 
mcalloc (md, nmemb, size)
  void *  md;
  register size_t nmemb;
  register size_t size;
{
  register void *  result;

  if ((result = mmalloc (md, nmemb * size)) != ((void *)0) )
    {
      memset (result, 0, nmemb * size);
    }
  return (result);
}

 





void * 
calloc (nmemb, size)
  size_t nmemb;
  size_t size;
{
  return (mcalloc ((void * ) ((void *)0) , nmemb, size));
}
# 27 "./mm.c" 2

# 1 "mfree.c" 1
 

























 


void
__mmalloc_free (mdp, ptr)
  struct mdesc *mdp;
  void *  ptr;
{
  int type;
  size_t block, blocks;
  register size_t i;
  struct list *prev, *next;

  block = (((char *) ( ptr ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1) ;

  type = mdp -> heapinfo[block].busy.type;
  switch (type)
    {
    case 0:
       
      mdp -> heapstats.chunks_used--;
      mdp -> heapstats.bytes_used -=
	  mdp -> heapinfo[block].busy.info.size * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;
      mdp -> heapstats.bytes_free +=
	  mdp -> heapinfo[block].busy.info.size * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;

       


      i = mdp -> heapindex;
      if (i > block)
	{
	  while (i > block)
	    {
	      i = mdp -> heapinfo[i].free.prev;
	    }
	}
      else
	{
	  do
	    {
	      i = mdp -> heapinfo[i].free.next;
	    }
	  while ((i != 0) && (i < block));
	  i = mdp -> heapinfo[i].free.prev;
	}

       
      if (block == i + mdp -> heapinfo[i].free.size)
	{
	   
	  mdp -> heapinfo[i].free.size +=
	    mdp -> heapinfo[block].busy.info.size;
	  block = i;
	}
      else
	{
	   
	  mdp -> heapinfo[block].free.size =
	    mdp -> heapinfo[block].busy.info.size;
	  mdp -> heapinfo[block].free.next = mdp -> heapinfo[i].free.next;
	  mdp -> heapinfo[block].free.prev = i;
	  mdp -> heapinfo[i].free.next = block;
	  mdp -> heapinfo[mdp -> heapinfo[block].free.next].free.prev = block;
	  mdp -> heapstats.chunks_free++;
	}

       


      if (block + mdp -> heapinfo[block].free.size ==
	  mdp -> heapinfo[block].free.next)
	{
	  mdp -> heapinfo[block].free.size
	    += mdp -> heapinfo[mdp -> heapinfo[block].free.next].free.size;
	  mdp -> heapinfo[block].free.next
	    = mdp -> heapinfo[mdp -> heapinfo[block].free.next].free.next;
	  mdp -> heapinfo[mdp -> heapinfo[block].free.next].free.prev = block;
	  mdp -> heapstats.chunks_free--;
	}

       
      blocks = mdp -> heapinfo[block].free.size;
      if (blocks >= 8  && block + blocks == mdp -> heaplimit
	  && mdp -> morecore (mdp, 0) == ((void * ) ((( block + blocks ) - 1) * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + mdp -> heapbase)) )
	{
	  register size_t bytes = blocks * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;
	  mdp -> heaplimit -= blocks;
	  mdp -> morecore (mdp, -bytes);
	  mdp -> heapinfo[mdp -> heapinfo[block].free.prev].free.next
	    = mdp -> heapinfo[block].free.next;
	  mdp -> heapinfo[mdp -> heapinfo[block].free.next].free.prev
	    = mdp -> heapinfo[block].free.prev;
	  block = mdp -> heapinfo[block].free.prev;
	  mdp -> heapstats.chunks_free--;
	  mdp -> heapstats.bytes_free -= bytes;
	}

       
      mdp -> heapindex = block;
      break;

    default:
       
      mdp -> heapstats.chunks_used--;
      mdp -> heapstats.bytes_used -= 1 << type;
      mdp -> heapstats.chunks_free++;
      mdp -> heapstats.bytes_free += 1 << type;

       
      prev = (struct list *)
	((char *) ((void * ) ((( block ) - 1) * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + mdp -> heapbase))  +
	 (mdp -> heapinfo[block].busy.info.frag.first << type));

      if (mdp -> heapinfo[block].busy.info.frag.nfree ==
	  (((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  >> type) - 1)
	{
	   

	  next = prev;
	  for (i = 1; i < (size_t) (((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  >> type); ++i)
	    {
	      next = next -> next;
	    }
	  prev -> prev -> next = next;
	  if (next != ((void *)0) )
	    {
	      next -> prev = prev -> prev;
	    }
	  mdp -> heapinfo[block].busy.type = 0;
	  mdp -> heapinfo[block].busy.info.size = 1;

	   
	  mdp -> heapstats.chunks_used++;
	  mdp -> heapstats.bytes_used += ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;
	  mdp -> heapstats.chunks_free -= ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  >> type;
	  mdp -> heapstats.bytes_free -= ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;

	  mfree ((void * ) mdp, (void * ) ((void * ) ((( block ) - 1) * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + mdp -> heapbase)) );
	}
      else if (mdp -> heapinfo[block].busy.info.frag.nfree != 0)
	{
	   


	  next = (struct list *) ptr;
	  next -> next = prev -> next;
	  next -> prev = prev;
	  prev -> next = next;
	  if (next -> next != ((void *)0) )
	    {
	      next -> next -> prev = next;
	    }
	  ++mdp -> heapinfo[block].busy.info.frag.nfree;
	}
      else
	{
	   


	  prev = (struct list *) ptr;
	  mdp -> heapinfo[block].busy.info.frag.nfree = 1;
	  mdp -> heapinfo[block].busy.info.frag.first =
	    ((unsigned int) (((unsigned int) ((char *) (  ptr  ) - (char *) ((void *)0) ))  % (  ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  )))  >> type;
	  prev -> next = mdp -> fraghead[type].next;
	  prev -> prev = &mdp -> fraghead[type];
	  prev -> prev -> next = prev;
	  if (prev -> next != ((void *)0) )
	    {
	      prev -> next -> prev = prev;
	    }
	}
      break;
    }
}

 

void
mfree (md, ptr)
  void *  md;
  void *  ptr;
{
  struct mdesc *mdp;
  register struct alignlist *l;

  if (ptr != ((void *)0) )
    {
      mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
      for (l = mdp -> aligned_blocks; l != ((void *)0) ; l = l -> next)
	{
	  if (l -> aligned == ptr)
	    {
	      l -> aligned = ((void *)0) ;   
	      ptr = l -> exact;
	      break;
	    }
	}      
      if (mdp -> mfree_hook != ((void *)0) )
	{
	  (*mdp -> mfree_hook) (md, ptr);
	}
      else
	{
	  __mmalloc_free (mdp, ptr);
	}
    }
}

 





void
free (ptr)
  void *  ptr;
{
  mfree ((void * ) ((void *)0) , ptr);
}
# 28 "./mm.c" 2

# 1 "mmalloc.c" 1
 



























 

static int initialize  (struct mdesc *)  ;
static void *  morecore  (struct mdesc *, size_t)  ;
static void *  align  (struct mdesc *, size_t)  ;

 

static void * 
align (mdp, size)
  struct mdesc *mdp;
  size_t size;
{
  void *  result;
  unsigned long int adj;

  result = mdp -> morecore (mdp, size);
  adj = ((unsigned int) (((unsigned int) ((char *) (  result  ) - (char *) ((void *)0) ))  % (  ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  ))) ;
  if (adj != 0)
    {
      adj = ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  - adj;
      mdp -> morecore (mdp, adj);
      result = (char *) result + adj;
    }
  return (result);
}

 

static int
initialize (mdp)
  struct mdesc *mdp;
{
  mdp -> heapsize = ((8  * sizeof(int))  > 16 ? 4194304 : 65536)  / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;
  mdp -> heapinfo = (malloc_info *) 
    align (mdp, mdp -> heapsize * sizeof (malloc_info));
  if (mdp -> heapinfo == ((void *)0) )
    {
      return (0);
    }
  memset ((void * )mdp -> heapinfo, 0, mdp -> heapsize * sizeof (malloc_info));
  mdp -> heapinfo[0].free.size = 0;
  mdp -> heapinfo[0].free.next = mdp -> heapinfo[0].free.prev = 0;
  mdp -> heapindex = 0;
  mdp -> heapbase = (char *) mdp -> heapinfo;
  mdp -> flags |= (1 << 1) ;
  return (1);
}

 


static void * 
morecore (mdp, size)
  struct mdesc *mdp;
  size_t size;
{
  void *  result;
  malloc_info *newinfo, *oldinfo;
  size_t newsize;

  result = align (mdp, size);
  if (result == ((void *)0) )
    {
      return (((void *)0) );
    }

   
  if ((size_t) (((char *) ( (char *) result + size ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1)  > mdp -> heapsize)
    {
      newsize = mdp -> heapsize;
      while ((size_t) (((char *) ( (char *) result + size ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1)  > newsize)
	{
	  newsize *= 2;
	}
      newinfo = (malloc_info *) align (mdp, newsize * sizeof (malloc_info));
      if (newinfo == ((void *)0) )
	{
	  mdp -> morecore (mdp, -size);
	  return (((void *)0) );
	}
      memset ((void * ) newinfo, 0, newsize * sizeof (malloc_info));
      memcpy ((void * ) newinfo, (void * ) mdp -> heapinfo,
	      mdp -> heapsize * sizeof (malloc_info));
      oldinfo = mdp -> heapinfo;
      newinfo[(((char *) ( oldinfo ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1) ].busy.type = 0;
      newinfo[(((char *) ( oldinfo ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1) ].busy.info.size
	= ((( mdp -> heapsize * sizeof (malloc_info) ) + ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  - 1) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ) ;
      mdp -> heapinfo = newinfo;
      __mmalloc_free (mdp, (void * )oldinfo);
      mdp -> heapsize = newsize;
    }

  mdp -> heaplimit = (((char *) ( (char *) result + size ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1) ;
  return (result);
}

 

void * 
mmalloc (md, size)
  void *  md;
  size_t size;
{
  struct mdesc *mdp;
  void *  result;
  size_t block, blocks, lastblocks, start;
  register size_t i;
  struct list *next;
  register size_t log;

  if (size == 0)
    {
      return (((void *)0) );
    }

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
      
  if (mdp -> mmalloc_hook != ((void *)0) )
    {
      return ((*mdp -> mmalloc_hook) (md, size));
    }

  if (!(mdp -> flags & (1 << 1) ))
    {
      if (!initialize (mdp))
	{
	  return (((void *)0) );
	}
    }

  if (size < sizeof (struct list))
    {
      size = sizeof (struct list);
    }

   
  if (size <= ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  / 2)
    {
       

      log = 1;
      --size;
      while ((size /= 2) != 0)
	{
	  ++log;
	}

       

      next = mdp -> fraghead[log].next;
      if (next != ((void *)0) )
	{
	   


	  result = (void * ) next;
	  next -> prev -> next = next -> next;
	  if (next -> next != ((void *)0) )
	    {
	      next -> next -> prev = next -> prev;
	    }
	  block = (((char *) ( result ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1) ;
	  if (--mdp -> heapinfo[block].busy.info.frag.nfree != 0)
	    {
	      mdp -> heapinfo[block].busy.info.frag.first =
		((unsigned int) (((unsigned int) ((char *) (  next -> next  ) - (char *) ((void *)0) ))  % (  ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  )))  >> log;
	    }

	   
	  mdp -> heapstats.chunks_used++;
	  mdp -> heapstats.bytes_used += 1 << log;
	  mdp -> heapstats.chunks_free--;
	  mdp -> heapstats.bytes_free -= 1 << log;
	}
      else
	{
	   

	  result = mmalloc (md, ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) );
	  if (result == ((void *)0) )
	    {
	      return (((void *)0) );
	    }

	   
	  for (i = 1; i < (size_t) (((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  >> log); ++i)
	    {
	      next = (struct list *) ((char *) result + (i << log));
	      next -> next = mdp -> fraghead[log].next;
	      next -> prev = &mdp -> fraghead[log];
	      next -> prev -> next = next;
	      if (next -> next != ((void *)0) )
		{
		  next -> next -> prev = next;
		}
	    }

	   
	  block = (((char *) ( result ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1) ;
	  mdp -> heapinfo[block].busy.type = log;
	  mdp -> heapinfo[block].busy.info.frag.nfree = i - 1;
	  mdp -> heapinfo[block].busy.info.frag.first = i - 1;

	  mdp -> heapstats.chunks_free += (((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  >> log) - 1;
	  mdp -> heapstats.bytes_free += ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  - (1 << log);
 	  mdp -> heapstats.bytes_used -= ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  - (1 << log);
	}
    }
  else
    {
       



      blocks = ((( size ) + ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  - 1) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ) ;
      start = block = mdp -> heapindex ;
      while (mdp -> heapinfo[block].free.size < blocks)
	{
	  block = mdp -> heapinfo[block].free.next;
	  if (block == start)
	    {
	       


	      block = mdp -> heapinfo[0].free.prev;
	      lastblocks = mdp -> heapinfo[block].free.size;
	      if (mdp -> heaplimit != 0 &&
		  block + lastblocks == mdp -> heaplimit &&
		  mdp -> morecore (mdp, 0) == ((void * ) ((( block + lastblocks ) - 1) * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + mdp -> heapbase))  &&
		  (morecore (mdp, (blocks - lastblocks) * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) )) != ((void *)0) )
		{
		   


		  block = mdp -> heapinfo[0].free.prev;

		  mdp -> heapinfo[block].free.size += (blocks - lastblocks);
		  mdp -> heapstats.bytes_free +=
		      (blocks - lastblocks) * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;
		  continue;
		}
	      result = morecore(mdp, blocks * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) );
	      if (result == ((void *)0) )
		{
		  return (((void *)0) );
		}
	      block = (((char *) ( result ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1) ;
	      mdp -> heapinfo[block].busy.type = 0;
	      mdp -> heapinfo[block].busy.info.size = blocks;
	      mdp -> heapstats.chunks_used++;
	      mdp -> heapstats.bytes_used += blocks * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;
	      return (result);
	    }
	}

       

      result = ((void * ) ((( block ) - 1) * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + mdp -> heapbase)) ;
      if (mdp -> heapinfo[block].free.size > blocks)
	{
	   

	  mdp -> heapinfo[block + blocks].free.size
	    = mdp -> heapinfo[block].free.size - blocks;
	  mdp -> heapinfo[block + blocks].free.next
	    = mdp -> heapinfo[block].free.next;
	  mdp -> heapinfo[block + blocks].free.prev
	    = mdp -> heapinfo[block].free.prev;
	  mdp -> heapinfo[mdp -> heapinfo[block].free.prev].free.next
	    = mdp -> heapinfo[mdp -> heapinfo[block].free.next].free.prev
	      = mdp -> heapindex = block + blocks;
	}
      else
	{
	   

	  mdp -> heapinfo[mdp -> heapinfo[block].free.next].free.prev
	    = mdp -> heapinfo[block].free.prev;
	  mdp -> heapinfo[mdp -> heapinfo[block].free.prev].free.next
	    = mdp -> heapindex = mdp -> heapinfo[block].free.next;
	  mdp -> heapstats.chunks_free--;
	}

      mdp -> heapinfo[block].busy.type = 0;
      mdp -> heapinfo[block].busy.info.size = blocks;
      mdp -> heapstats.chunks_used++;
      mdp -> heapstats.bytes_used += blocks * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;
      mdp -> heapstats.bytes_free -= blocks * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ;
    }

  return (result);
}

 





void * 
malloc (size)
  size_t size;
{
  void *  result;

  result = mmalloc ((void * ) ((void *)0) , size);
  return (result);
}
# 29 "./mm.c" 2

# 1 "mmcheck.c" 1
 

























 



extern void abort  (void)  ;

 





 








struct hdr
  {
    size_t size;		 
    unsigned long int magic;	 
  };

static void checkhdr  (struct mdesc *, const  struct hdr *)  ;
static void mfree_check  (void * , void * )  ;
static void *  mmalloc_check  (void * , size_t)  ;
static void *  mrealloc_check  (void * , void * , size_t)  ;

 


static void
checkhdr (mdp, hdr)
  struct mdesc *mdp;
  const  struct hdr *hdr;
{
  if (hdr -> magic != (unsigned int) 0xfedabeeb  ||
      ((char *) &hdr[1])[hdr -> size] != ((char) 0xd7) )
    {
      (*mdp -> abortfunc)();
    }
}

static void
mfree_check (md, ptr)
  void *  md;
  void *  ptr;
{
  struct hdr *hdr = ((struct hdr *) ptr) - 1;
  struct mdesc *mdp;

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
  checkhdr (mdp, hdr);
  hdr -> magic = (unsigned int) 0xdeadbeef ;
  mdp -> mfree_hook = ((void *)0) ;
  mfree (md, (void * )hdr);
  mdp -> mfree_hook = mfree_check;
}

static void * 
mmalloc_check (md, size)
  void *  md;
  size_t size;
{
  struct hdr *hdr;
  struct mdesc *mdp;
  size_t nbytes;

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
  mdp -> mmalloc_hook = ((void *)0) ;
  nbytes = sizeof (struct hdr) + size + 1;
  hdr = (struct hdr *) mmalloc (md, nbytes);
  mdp -> mmalloc_hook = mmalloc_check;
  if (hdr != ((void *)0) )
    {
      hdr -> size = size;
      hdr -> magic = (unsigned int) 0xfedabeeb ;
      hdr++;
      *((char *) hdr + size) = ((char) 0xd7) ;
    }
  return ((void * ) hdr);
}

static void * 
mrealloc_check (md, ptr, size)
  void *  md;
  void *  ptr;
  size_t size;
{
  struct hdr *hdr = ((struct hdr *) ptr) - 1;
  struct mdesc *mdp;
  size_t nbytes;

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
  checkhdr (mdp, hdr);
  mdp -> mfree_hook = ((void *)0) ;
  mdp -> mmalloc_hook = ((void *)0) ;
  mdp -> mrealloc_hook = ((void *)0) ;
  nbytes = sizeof (struct hdr) + size + 1;
  hdr = (struct hdr *) mrealloc (md, (void * ) hdr, nbytes);
  mdp -> mfree_hook = mfree_check;
  mdp -> mmalloc_hook = mmalloc_check;
  mdp -> mrealloc_hook = mrealloc_check;
  if (hdr != ((void *)0) )
    {
      hdr -> size = size;
      hdr++;
      *((char *) hdr + size) = ((char) 0xd7) ;
    }
  return ((void * ) hdr);
}

 





























int
mmcheckf (md, func, force)
  void *  md;
  void (*func)  (void)  ;
  int force;
{
  struct mdesc *mdp;
  int rtnval;

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;

   


  mdp -> abortfunc = (func != ((void *)0)  ? func : abort);

   



  if (force ||
      !(mdp -> flags & (1 << 1) ) ||
      (mdp -> mfree_hook != ((void *)0) ))
    {
      mdp -> mfree_hook = mfree_check;
      mdp -> mmalloc_hook = mmalloc_check;
      mdp -> mrealloc_hook = mrealloc_check;
      mdp -> flags |= (1 << 2) ;
      rtnval = 1;
    }
  else
    {
      rtnval = 0;
    }

  return (rtnval);
}

 


int
mmcheck (md, func)
  void *  md;
  void (*func)  (void)  ;
{
  int rtnval;

  rtnval = mmcheckf (md, func, 0);
  return (rtnval);
}
# 30 "./mm.c" 2

# 1 "mmemalign.c" 1
 



















void * 
mmemalign (md, alignment, size)
  void *  md;
  size_t alignment;
  size_t size;
{
  void *  result;
  unsigned long int adj;
  struct alignlist *l;
  struct mdesc *mdp;

  if ((result = mmalloc (md, size + alignment - 1)) != ((void *)0) )
    {
      adj = ((unsigned int) (((unsigned int) ((char *) (  result  ) - (char *) ((void *)0) ))  % (  alignment ))) ;
      if (adj != 0)
	{
	  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
	  for (l = mdp -> aligned_blocks; l != ((void *)0) ; l = l -> next)
	    {
	      if (l -> aligned == ((void *)0) )
		{
		   
		  break;
		}
	    }
	  if (l == ((void *)0) )
	    {
	      l = (struct alignlist *) mmalloc (md, sizeof (struct alignlist));
	      if (l == ((void *)0) )
		{
		  mfree (md, result);
		  return (((void *)0) );
		}
	      l -> next = mdp -> aligned_blocks;
	      mdp -> aligned_blocks = l;
	    }
	  l -> exact = result;
	  result = l -> aligned = (char *) result + alignment - adj;
	}
    }
  return (result);
}
# 31 "./mm.c" 2

# 1 "mmstats.c" 1
 

























 



struct mstats
mmstats (md)
  void *  md;
{
  struct mstats result;
  struct mdesc *mdp;

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
  result.bytes_total =
      (char *) mdp -> morecore (mdp, 0) - mdp -> heapbase;
  result.chunks_used = mdp -> heapstats.chunks_used;
  result.bytes_used = mdp -> heapstats.bytes_used;
  result.chunks_free = mdp -> heapstats.chunks_free;
  result.bytes_free = mdp -> heapstats.bytes_free;
  return (result);
}
# 32 "./mm.c" 2

# 1 "mmtrace.c" 1
 























# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 1 3
 


















 









 



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 34 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 2 3










 
typedef struct _UC_FILE FILE;








 
typedef struct _UC_FILE __FILE;











# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/uClibc_stdio.h" 1 3
 

















 












 














 
# 58 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/uClibc_stdio.h" 3












 
 


# 82 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/uClibc_stdio.h" 3






 
 
 

 


 


 

 






 


 
 

 
 
 
 

 

 














 

# 156 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/uClibc_stdio.h" 3








 








typedef struct {
	__off_t __pos;



} __stdio_fpos_t;











 



typedef __off_t __offmax_t;		 


 



typedef __ssize_t __io_read_fn(void *cookie,
							   char *buf, size_t bufsize);
typedef __ssize_t __io_write_fn(void *cookie,
								const char *buf, size_t bufsize);
 



typedef int __io_seek_fn(void *cookie,
						 __offmax_t *pos, int whence);
typedef int __io_close_fn(void *cookie);

typedef struct {
	__io_read_fn *read;
	__io_write_fn *write;
	__io_seek_fn *seek;
	__io_close_fn *close;
} _IO_cookie_io_functions_t;












 











struct _UC_FILE  {
	unsigned short modeflags;
	 





	unsigned char ungot[2];

	int filedes;

	struct _UC_FILE  *nextopen;


	unsigned char *bufstart;	 
	unsigned char *bufend;		 
	unsigned char *bufpos;
	unsigned char *bufread;		 

	unsigned char *bufgetc;		 


	unsigned char *bufputc;		 



	void *cookie;
	_IO_cookie_io_functions_t gcs;








 



};


 

























 


extern __ssize_t _cs_read(void *cookie, char *buf, size_t bufsize);
extern __ssize_t _cs_write(void *cookie, const char *buf, size_t bufsize);
extern int _cs_seek(void *cookie, __offmax_t *pos, int whence);
extern int _cs_close(void *cookie);


 









 

 









 








































 



extern FILE *_stdio_openlist;






extern int _stdio_adjpos(FILE * __restrict stream, __offmax_t * pos);
extern int _stdio_lseek(FILE *stream, __offmax_t *pos, int whence);
 
extern size_t _stdio_fwrite(const unsigned char *buffer, size_t bytes,
							  FILE *stream);
extern size_t _stdio_fread(unsigned char *buffer, size_t bytes,
							 FILE *stream);

extern FILE *_stdio_fopen(const char * __restrict filename,
							const char * __restrict mode,
							FILE * __restrict stream, int filedes);

extern FILE *_stdio_fsfopen(const char * __restrict filename,
							const char * __restrict mode,
							register FILE * __restrict stream);

extern void _stdio_init(void);
extern void _stdio_term(void);


extern void __stdio_validate_FILE(FILE *stream);




 


# 505 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/uClibc_stdio.h" 3

 
 
 

 
typedef __stdio_fpos_t		_UC_fpos_t;









# 67 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 2 3


 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stdarg.h" 1 3
 
































































 






typedef void *__gnuc_va_list;



 

# 122 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stdarg.h" 3




















# 209 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stdarg.h" 3




# 71 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 2 3


 

typedef _UC_fpos_t fpos_t;







 





 





 






 







 




 








# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/stdio_lim.h" 1 3
 




































# 124 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 2 3



 
extern FILE *stdin;		 
extern FILE *stdout;		 
extern FILE *stderr;		 

 





 
extern int remove (__const char *__filename)  ;
 
extern int rename (__const char *__old, __const char *__new)  ;


 

extern FILE *tmpfile (void)  ;










 
extern char *tmpnam (char *__s)  ;


 

extern char *tmpnam_r (char *__s)  ;




 






extern char *tempnam (__const char *__dir, __const char *__pfx)
        ;



 
extern int fclose (FILE *__stream)  ;
 
extern int fflush (FILE *__stream)  ;


 
extern int fflush_unlocked (FILE *__stream)  ;









 
extern FILE *fopen (__const char *__restrict __filename,
		    __const char *__restrict __modes)  ;
 
extern FILE *freopen (__const char *__restrict __filename,
		      __const char *__restrict __modes,
		      FILE *__restrict __stream)  ;
# 217 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 3










 
extern FILE *fdopen (int __fd, __const char *__modes)  ;


# 248 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 3



 

extern void setbuf (FILE *__restrict __stream, char *__restrict __buf)  ;
 


extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
		    int __modes, size_t __n)  ;


 

extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
		       size_t __size)  ;

 
extern void setlinebuf (FILE *__stream)  ;



 
extern int fprintf (FILE *__restrict __stream,
		    __const char *__restrict __format, ...)  ;
 
extern int printf (__const char *__restrict __format, ...)  ;
 
extern int sprintf (char *__restrict __s,
		    __const char *__restrict __format, ...)  ;

 
extern int vfprintf (FILE *__restrict __s, __const char *__restrict __format,
		     __gnuc_va_list __arg)  ;
 
extern int vprintf (__const char *__restrict __format, __gnuc_va_list __arg)
      ;
 
extern int vsprintf (char *__restrict __s, __const char *__restrict __format,
		     __gnuc_va_list __arg)  ;


 
extern int snprintf (char *__restrict __s, size_t __maxlen,
		     __const char *__restrict __format, ...)
       __attribute__ ((__format__ (__printf__, 3, 4)));

extern int vsnprintf (char *__restrict __s, size_t __maxlen,
		      __const char *__restrict __format, __gnuc_va_list __arg)
       __attribute__ ((__format__ (__printf__, 3, 0)));


# 320 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 3



 
extern int fscanf (FILE *__restrict __stream,
		   __const char *__restrict __format, ...)  ;
 
extern int scanf (__const char *__restrict __format, ...)  ;
 
extern int sscanf (__const char *__restrict __s,
		   __const char *__restrict __format, ...)  ;

# 346 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 3



 
extern int fgetc (FILE *__stream)  ;
extern int getc (FILE *__stream)  ;

 
extern int getchar (void)  ;

 




 
extern int getc_unlocked (FILE *__stream)  ;
extern int getchar_unlocked (void)  ;



 
extern int fgetc_unlocked (FILE *__stream)  ;



 
extern int fputc (int __c, FILE *__stream)  ;
extern int putc (int __c, FILE *__stream)  ;

 
extern int putchar (int __c)  ;

 




 
extern int fputc_unlocked (int __c, FILE *__stream)  ;



 
extern int putc_unlocked (int __c, FILE *__stream)  ;
extern int putchar_unlocked (int __c)  ;




 
extern int getw (FILE *__stream)  ;

 
extern int putw (int __w, FILE *__stream)  ;



 
extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
      ;


 
extern char *fgets_unlocked (char *__restrict __s, int __n,
			     FILE *__restrict __stream)  ;


 

extern char *gets (char *__s)  ;


# 436 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 3



 
extern int fputs (__const char *__restrict __s, FILE *__restrict __stream)
      ;







 
extern int puts (__const char *__s)  ;


 
extern int ungetc (int __c, FILE *__stream)  ;


 
extern size_t fread (void *__restrict __ptr, size_t __size,
		     size_t __n, FILE *__restrict __stream)  ;
 
extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
		      size_t __n, FILE *__restrict __s)  ;


 
extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
			      size_t __n, FILE *__restrict __stream)  ;
extern size_t fwrite_unlocked (__const void *__restrict __ptr, size_t __size,
			       size_t __n, FILE *__restrict __stream)  ;



 
extern int fseek (FILE *__stream, long int __off, int __whence)  ;
 
extern long int ftell (FILE *__stream)  ;
 
extern void rewind (FILE *__stream)  ;

 












 
extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos)
      ;
 
extern int fsetpos (FILE *__stream, __const fpos_t *__pos)  ;
# 519 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 3










 
extern void clearerr (FILE *__stream)  ;
 
extern int feof (FILE *__stream)  ;
 
extern int ferror (FILE *__stream)  ;


 
extern void clearerr_unlocked (FILE *__stream)  ;
extern int feof_unlocked (FILE *__stream)  ;
extern int ferror_unlocked (FILE *__stream)  ;



 
extern void perror (__const char *__s)  ;

 


extern int sys_nerr;
extern __const char *__const sys_errlist[];









 
extern int fileno (FILE *__stream)  ;



 
extern int fileno_unlocked (FILE *__stream)  ;





 
extern FILE *popen (__const char *__command, __const char *__modes)  ;

 
extern int pclose (FILE *__stream)  ;




 
extern char *ctermid (char *__s)  ;









# 603 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 3




 
 
extern void flockfile (FILE *__stream)  ;

 

extern int ftrylockfile (FILE *__stream)  ;

 
extern void funlockfile (FILE *__stream)  ;










 






 




# 25 "mmtrace.c" 2



static void tr_break  (void)  ;
static void tr_freehook  (void * , void * )  ;
static void *  tr_mallochook  (void * , size_t)  ;
static void *  tr_reallochook  (void * , void * , size_t)  ;





static FILE *mallstream;






 
static void *  mallwatch;

 

static void (*old_mfree_hook)  (void * , void * )  ;
static void *  (*old_mmalloc_hook)  (void * , size_t)  ;
static void *  (*old_mrealloc_hook)  (void * , void * , size_t)  ;

 




static void
tr_break ()
{
}

static void
tr_freehook (md, ptr)
  void *  md;
  void *  ptr;
{
  struct mdesc *mdp;

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
   
  fprintf (mallstream, "- %08lx\n", (unsigned long) ptr);
  if (ptr == mallwatch)
    tr_break ();
  mdp -> mfree_hook = old_mfree_hook;
  mfree (md, ptr);
  mdp -> mfree_hook = tr_freehook;
}

static void * 
tr_mallochook (md, size)
  void *  md;
  size_t size;
{
  void *  hdr;
  struct mdesc *mdp;

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;
  mdp -> mmalloc_hook = old_mmalloc_hook;
  hdr = (void * ) mmalloc (md, size);
  mdp -> mmalloc_hook = tr_mallochook;

   
  fprintf (mallstream, "+ %08lx %x\n", (unsigned long) hdr, size);

  if (hdr == mallwatch)
    tr_break ();

  return (hdr);
}

static void * 
tr_reallochook (md, ptr, size)
  void *  md;
  void *  ptr;
  size_t size;
{
  void *  hdr;
  struct mdesc *mdp;

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;

  if (ptr == mallwatch)
    tr_break ();

  mdp -> mfree_hook = old_mfree_hook;
  mdp -> mmalloc_hook = old_mmalloc_hook;
  mdp -> mrealloc_hook = old_mrealloc_hook;
  hdr = (void * ) mrealloc (md, ptr, size);
  mdp -> mfree_hook = tr_freehook;
  mdp -> mmalloc_hook = tr_mallochook;
  mdp -> mrealloc_hook = tr_reallochook;
  if (hdr == ((void *)0) )
     
    fprintf (mallstream, "! %08lx %x\n", (unsigned long) ptr, size);
  else
    fprintf (mallstream, "< %08lx\n> %08lx %x\n", (unsigned long) ptr,
	     (unsigned long) hdr, size);

  if (hdr == mallwatch)
    tr_break ();

  return hdr;
}

 




int
mmtrace ()
{
# 167 "mmtrace.c"


  return (1);
}

# 33 "./mm.c" 2

# 1 "mrealloc.c" 1
 

























 






void * 
mrealloc (md, ptr, size)
  void *  md;
  void *  ptr;
  size_t size;
{
  struct mdesc *mdp;
  void *  result;
  int type;
  size_t block, blocks, oldlimit;

  if (size == 0)
    {
      mfree (md, ptr);
      return (mmalloc (md, 0));
    }
  else if (ptr == ((void *)0) )
    {
      return (mmalloc (md, size));
    }

  mdp = (( md ) == ((void *)0)  ? (__mmalloc_default_mdp == ((void *)0)  ? __mmalloc_sbrk_init () : __mmalloc_default_mdp) : (struct mdesc *) ( md )) ;

  if (mdp -> mrealloc_hook != ((void *)0) )
    {
      return ((*mdp -> mrealloc_hook) (md, ptr, size));
    }

  block = (((char *) ( ptr ) - mdp -> heapbase) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + 1) ;

  type = mdp -> heapinfo[block].busy.type;
  switch (type)
    {
    case 0:
       
      if (size <= ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  / 2)
	{
	  result = mmalloc (md, size);
	  if (result != ((void *)0) )
	    {
	      memcpy (result, ptr, size);
	      mfree (md, ptr);
	      return (result);
	    }
	}

       

      blocks = ((( size ) + ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  - 1) / ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) ) ;
      if (blocks < mdp -> heapinfo[block].busy.info.size)
	{
	   
	  mdp -> heapinfo[block + blocks].busy.type = 0;
	  mdp -> heapinfo[block + blocks].busy.info.size
	    = mdp -> heapinfo[block].busy.info.size - blocks;
	  mdp -> heapinfo[block].busy.info.size = blocks;
	  mfree (md, ((void * ) ((( block + blocks ) - 1) * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  + mdp -> heapbase)) );
	  result = ptr;
	}
      else if (blocks == mdp -> heapinfo[block].busy.info.size)
	{
	   
	  result = ptr;
	}
      else
	{
	   


	  blocks = mdp -> heapinfo[block].busy.info.size;
	   
	  oldlimit = mdp -> heaplimit;
	  mdp -> heaplimit = 0;
	  mfree (md, ptr);
	  mdp -> heaplimit = oldlimit;
	  result = mmalloc (md, size);
	  if (result == ((void *)0) )
	    {
	      mmalloc (md, blocks * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) );
	      return (((void *)0) );
	    }
	  if (ptr != result)
	    {
	      memmove (result, ptr, blocks * ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) ) );
	    }
	}
      break;

    default:
       

      if (size > (size_t) (1 << (type - 1)) && size <= (size_t) (1 << type))
	{
	   
	  result = ptr;
	}
      else
	{
	   

	  result = mmalloc (md, size);
	  if (result == ((void *)0) )
	    {
	      return (((void *)0) );
	    }
	  memcpy (result, ptr, (( size ) < (  (size_t) 1 << type ) ? ( size ) : (  (size_t) 1 << type )) );
	  mfree (md, ptr);
	}
      break;
    }

  return (result);
}

 





void * 
realloc (ptr, size)
  void *  ptr;
  size_t size;
{
  void *  result;

  result = mrealloc ((void * ) ((void *)0) , ptr, size);
  return (result);
}
# 34 "./mm.c" 2

# 1 "mvalloc.c" 1
 



















 




static size_t cache_pagesize;




void * 
mvalloc (md, size)
  void *  md;
  size_t size;
{
  if (cache_pagesize == 0)
    {
      cache_pagesize = getpagesize ();
    }

  return (mmemalign (md, cache_pagesize, size));
}


void * 
valloc (size)
  size_t size;
{
  return mvalloc ((void * ) ((void *)0) , size);
}
# 35 "./mm.c" 2

# 1 "mmap-sup.c" 1
 





















# 217 "mmap-sup.c"

 
static char ansi_c_idiots = 69;

# 36 "./mm.c" 2

# 1 "attach.c" 1
 






















# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/fcntl.h" 1 3
 

















 








 
 

 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/fcntl.h" 1 3
 

























 





















 




 







 









 














 


 




 




 







struct flock
  {
    short int l_type;	 
    short int l_whence;	 

    __off_t l_start;	 
    __off_t l_len;	 




    __pid_t l_pid;	 
  };

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/fcntl.h" 3


 








# 33 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/fcntl.h" 2 3


 















 






 


extern int fcntl (int __fd, int __cmd, ...)  ;









 



extern int open (__const char *__file, int __oflag, ...)  ;












 



extern int creat (__const char *__file, __mode_t __mode)  ;












# 133 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/fcntl.h" 3


# 172 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/fcntl.h" 3


 


# 24 "attach.c" 2

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/stat.h" 1 3
 

















 










# 78 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/stat.h" 3


# 95 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/stat.h" 3


 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/stat.h" 1 3
 





















 






 





struct stat {
	unsigned short st_dev;
	unsigned short __pad1;
	unsigned long st_ino;
	unsigned short st_mode;
	unsigned short st_nlink;
	unsigned short st_uid;
	unsigned short st_gid;
	unsigned short st_rdev;
	unsigned short __pad2;
	unsigned long  st_size;
	unsigned long  st_blksize;
	unsigned long  st_blocks;
	unsigned long  st_atime;
	unsigned long  __unused1;
	unsigned long  st_mtime;
	unsigned long  __unused2;
	unsigned long  st_ctime;
	unsigned long  __unused3;
	unsigned long  __unused4;
	unsigned long  __unused5;
};


# 97 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/stat.h" 3


# 125 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/stat.h" 3




 



 



 






 



 







# 99 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/stat.h" 2 3




















 























 










 





 






 











 





 




 









 
extern int stat (__const char *__restrict __file,
		 struct stat *__restrict __buf)  ;

 

extern int fstat (int __fd, struct stat *__buf)  ;
# 218 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/stat.h" 3









 

extern int lstat (__const char *__restrict __file,
		  struct stat *__restrict __buf)  ;
# 240 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/stat.h" 3







 


extern int chmod (__const char *__file, __mode_t __mode)  ;

 

extern int fchmod (int __fd, __mode_t __mode)  ;



 

extern __mode_t umask (__mode_t __mask)  ;







 
extern int mkdir (__const char *__path, __mode_t __mode)  ;

 



extern int mknod (__const char *__path, __mode_t __mode, __dev_t __dev)
      ;


 
extern int mkfifo (__const char *__path, __mode_t __mode)  ;

 



# 25 "attach.c" 2












# 205 "attach.c"


 



 
void * 
mmalloc_attach (fd, baseaddr)
  int fd;
  void *  baseaddr;
{
   return (((void *)0) );
}



# 37 "./mm.c" 2

# 1 "detach.c" 1
 
























 













void * 
mmalloc_detach (md)
     void *  md;
{
  struct mdesc mtemp;

  if (md != ((void *)0) )
    {

      mtemp = *(struct mdesc *) md;
      
       

      
      if ((mtemp.morecore (&mtemp, mtemp.base - mtemp.breakval)) == ((void *)0) )
	{
	   

	  *(struct mdesc *) md = mtemp;
	}
      else
	{
	  if (mtemp.flags & (1 << 0) )
	    {
	      close (mtemp.fd);
	    }
	  md = ((void *)0) ;
	}
    }

  return (md);
}
# 38 "./mm.c" 2

# 1 "keys.c" 1
 





















 












int
mmalloc_setkey (md, keynum, key)
  void *  md;     
  int keynum;
  void *  key;
{
  struct mdesc *mdp = (struct mdesc *) md;
  int result = 0;

  if ((mdp != ((void *)0) ) && (keynum >= 0) && (keynum < 16 ))
    {
      mdp -> keys [keynum] = key;
      result++;
    }
  return (result);
}

void * 
mmalloc_getkey (md, keynum)
  void *  md;     
  int keynum;
{
  struct mdesc *mdp = (struct mdesc *) md;
  void *  keyval = ((void *)0) ;

  if ((mdp != ((void *)0) ) && (keynum >= 0) && (keynum < 16 ))
    {
      keyval = mdp -> keys [keynum];
    }
  return (keyval);
}
# 39 "./mm.c" 2

# 1 "sbrk-sup.c" 1
 



























static void *  sbrk_morecore  (struct mdesc *, int)  ;




 





struct mdesc *__mmalloc_default_mdp;

 

static void * 
sbrk_morecore (mdp, size)
  struct mdesc *mdp;
  int size;
{
  void *  result;

  if ((result = sbrk (size)) == (void * ) -1)
    {
      result = ((void *)0) ;
    }
  else
    {
      mdp -> breakval += size;
      mdp -> top += size;
    }
  return (result);
}

 
















struct mdesc *
__mmalloc_sbrk_init ()
{
  void *  base;
  unsigned int adj;

  base = sbrk (0);
  adj = ((unsigned int) (((unsigned int) ((char *) (  base  ) - (char *) ((void *)0) ))  % (  ((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  ))) ;
  if (adj != 0)
    {
      sbrk (((unsigned int) 1 << ((8  * sizeof(int))  > 16 ? 12 : 9) )  - adj);
      base = sbrk (0);
    }
  __mmalloc_default_mdp = (struct mdesc *) sbrk (sizeof (struct mdesc));
  memset ((char *) __mmalloc_default_mdp, 0, sizeof (struct mdesc));
  __mmalloc_default_mdp -> morecore = sbrk_morecore;
  __mmalloc_default_mdp -> base = base;
  __mmalloc_default_mdp -> breakval = __mmalloc_default_mdp -> top = sbrk (0);
  __mmalloc_default_mdp -> fd = -1;
  return (__mmalloc_default_mdp);
}


# 40 "./mm.c" 2

