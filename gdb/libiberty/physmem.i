# 1 "physmem.c"
 
















 


# 1 "config.h" 1
 
 

 
 

 
 

 


 
 

 
 

 
 

 
 

 
 

 
 

 


 
 

 


 
 

 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 
 

 


 


 
 

 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 
 

 


 


 


 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 


 
 

 


 


 


 


 
 

 
 

 
 

 


 


 


 


 
 

 

 

 


 
 

 


 


 


 


 


 

 






 
 

 


# 21 "physmem.c" 2




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


 


# 25 "physmem.c" 2




















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








 


# 45 "physmem.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/param.h" 1 3
 




















# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/limits.h" 1 3



 



 



 




 





 



 












 

 




 



 








 



 













 



# 95 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/limits.h" 3




# 22 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/param.h" 2 3

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/limits.h" 1 3



















# 23 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/param.h" 2 3

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/param.h" 1 3



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/asm/param.h" 1 3



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/config.h" 1 3



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/autoconf.h" 1 3
 









 



 



 


 





 




 




 



 



















 



 



 



 











 



 





 



 



 



 


 



 








 



 




 



 



 








 





 






























 






 



 



 






# 4 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/config.h" 2 3



# 4 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/asm/param.h" 2 3





















# 4 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/param.h" 2 3



# 24 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/param.h" 2 3


 









 







 





 






 




 




# 48 "physmem.c" 2




# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/sysctl.h" 1 3
 






















 


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 

# 271 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


# 283 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 





















# 27 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/sysctl.h" 2 3

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/sysctl.h" 1 3
 

























# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/kernel.h" 1 3



 



# 115 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/kernel.h" 3



struct sysinfo {
	long uptime;			 
	unsigned long loads[3];		 
	unsigned long totalram;		 
	unsigned long freeram;		 
	unsigned long sharedram;	 
	unsigned long bufferram;	 
	unsigned long totalswap;	 
	unsigned long freeswap;		 
	unsigned short procs;		 
	unsigned short pad;		 
	unsigned long totalhigh;	 
	unsigned long freehigh;		 
	unsigned int mem_unit;		 
	char _f[20-2*sizeof(long)-sizeof(int)];	 
};


# 27 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/sysctl.h" 2 3

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/types.h" 1 3







# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/posix_types.h" 1 3



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/stddef.h" 1 3














# 4 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/posix_types.h" 2 3


 










 


















typedef struct {
	unsigned long fds_bits [(1024 / (8 * sizeof(unsigned long)) ) ];
} __kernel_fd_set;

 
typedef void (*__kernel_sighandler_t)(int);

 
typedef int __kernel_key_t;

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/asm/posix_types.h" 1 3



 





typedef unsigned short	__kernel_dev_t;
typedef unsigned long	__kernel_ino_t;
typedef unsigned short	__kernel_mode_t;
typedef unsigned short	__kernel_nlink_t;
typedef long		__kernel_off_t;
typedef int		__kernel_pid_t;
typedef unsigned short	__kernel_ipc_pid_t;
typedef unsigned short	__kernel_uid_t;
typedef unsigned short	__kernel_gid_t;
typedef unsigned int	__kernel_size_t;
typedef int		__kernel_ssize_t;
typedef int		__kernel_ptrdiff_t;
typedef long		__kernel_time_t;
typedef long		__kernel_suseconds_t;
typedef long		__kernel_clock_t;
typedef int		__kernel_daddr_t;
typedef char *		__kernel_caddr_t;
typedef unsigned short	__kernel_uid16_t;
typedef unsigned short	__kernel_gid16_t;
typedef unsigned int	__kernel_uid32_t;
typedef unsigned int	__kernel_gid32_t;

typedef unsigned short	__kernel_old_uid_t;
typedef unsigned short	__kernel_old_gid_t;


typedef long long	__kernel_loff_t;


typedef struct {



	int	__val[2];

} __kernel_fsid_t;

# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/asm/posix_types.h" 3



# 46 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/posix_types.h" 2 3



# 8 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/types.h" 2 3

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/asm/types.h" 1 3



 







typedef unsigned short umode_t;

 




typedef __signed__ char __s8;
typedef unsigned char __u8;

typedef __signed__ short __s16;
typedef unsigned short __u16;

typedef __signed__ int __s32;
typedef unsigned int __u32;

 

typedef __signed__ long long __s64;
typedef unsigned long long __u64;


 


# 57 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/asm/types.h" 3



# 9 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/types.h" 2 3


# 116 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/types.h" 3


 




struct ustat {
	__kernel_daddr_t	f_tfree;
	__kernel_ino_t		f_tinode;
	char			f_fname[6];
	char			f_fpack[6];
};


# 28 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/sysctl.h" 2 3

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/list.h" 1 3



 









struct list_head {
	struct list_head *next, *prev;
};










 





static __inline__ void __list_add(struct list_head * new,
	struct list_head * prev,
	struct list_head * next)
{
	next->prev = new;
	new->next = next;
	new->prev = prev;
	prev->next = new;
}

 







static __inline__ void list_add(struct list_head *new, struct list_head *head)
{
	__list_add(new, head, head->next);
}

 







static __inline__ void list_add_tail(struct list_head *new, struct list_head *head)
{
	__list_add(new, head->prev, head);
}

 






static __inline__ void __list_del(struct list_head * prev,
				  struct list_head * next)
{
	next->prev = prev;
	prev->next = next;
}

 




static __inline__ void list_del(struct list_head *entry)
{
	__list_del(entry->prev, entry->next);
}

 



static __inline__ void list_del_init(struct list_head *entry)
{
	__list_del(entry->prev, entry->next);
	do { ( entry )->next = ( entry ); ( entry )->prev = ( entry ); } while (0) ; 
}

 



static __inline__ int list_empty(struct list_head *head)
{
	return head->next == head;
}

 




static __inline__ void list_splice(struct list_head *list, struct list_head *head)
{
	struct list_head *first = list->next;

	if (first != list) {
		struct list_head *last = list->prev;
		struct list_head *at = head->next;

		first->prev = head;
		head->next = first;

		last->next = at;
		at->prev = last;
	}
}

 








 









# 29 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/sysctl.h" 2 3


struct file;



struct __sysctl_args {
	int *name;
	int nlen;
	void *oldval;
	size_t *oldlenp;
	void *newval;
	size_t newlen;
	unsigned long __unused[4];
};

 

 

 





enum
{
	CTL_KERN=1,		 
	CTL_VM=2,		 
	CTL_NET=3,		 
	CTL_PROC=4,		 
	CTL_FS=5,		 
	CTL_DEBUG=6,		 
	CTL_DEV=7,		 
	CTL_BUS=8		 
};

 
enum
{
	BUS_ISA=1		 
};

 
enum
{
	KERN_OSTYPE=1,		 
	KERN_OSRELEASE=2,	 
	KERN_OSREV=3,		 
	KERN_VERSION=4,		 
	KERN_SECUREMASK=5,	 
	KERN_PROF=6,		 
	KERN_NODENAME=7,
	KERN_DOMAINNAME=8,

	KERN_CAP_BSET=14,	 
	KERN_PANIC=15,		 
	KERN_REALROOTDEV=16,	 

	KERN_SPARC_REBOOT=21,	 
	KERN_CTLALTDEL=22,	 
	KERN_PRINTK=23,		 
	KERN_NAMETRANS=24,	 
	KERN_PPC_HTABRECLAIM=25,  
	KERN_PPC_ZEROPAGED=26,	 
	KERN_PPC_POWERSAVE_NAP=27,  
	KERN_MODPROBE=28,
	KERN_SG_BIG_BUFF=29,
	KERN_ACCT=30,		 
	KERN_PPC_L2CR=31,	 

	KERN_RTSIGNR=32,	 
	KERN_RTSIGMAX=33,	 
	
	KERN_SHMMAX=34,          
	KERN_MSGMAX=35,          
	KERN_MSGMNB=36,          
	KERN_MSGPOOL=37,         
	KERN_SYSRQ=38,		 
	KERN_MAX_THREADS=39,	 
 	KERN_RANDOM=40,		 
 	KERN_SHMALL=41,		 
 	KERN_MSGMNI=42,		 
 	KERN_SEM=43,		 
 	KERN_SPARC_STOP_A=44,	 
 	KERN_SHMMNI=45,		 
	KERN_OVERFLOWUID=46,	 
	KERN_OVERFLOWGID=47,	 
	KERN_SHMPATH=48,	 
	KERN_HOTPLUG=49,	 
	KERN_IEEE_EMULATION_WARNINGS=50,  
	KERN_S390_USER_DEBUG_LOGGING=51   
};


 
enum
{
	VM_SWAPCTL=1,		 
	VM_SWAPOUT=2,		 
	VM_FREEPG=3,		 
	VM_BDFLUSH=4,		 
	VM_OVERCOMMIT_MEMORY=5,	 
	VM_BUFFERMEM=6,		 
	VM_PAGECACHE=7,		 
	VM_PAGERDAEMON=8,	 
	VM_PGT_CACHE=9,		 
	VM_PAGE_CLUSTER=10	 
};


 
enum
{
	NET_CORE=1,
	NET_ETHER=2,
	NET_802=3,
	NET_UNIX=4,
	NET_IPV4=5,
	NET_IPX=6,
	NET_ATALK=7,
	NET_NETROM=8,
	NET_AX25=9,
	NET_BRIDGE=10,
	NET_ROSE=11,
	NET_IPV6=12,
	NET_X25=13,
	NET_TR=14,
	NET_DECNET=15,
	NET_ECONET=16,
	NET_KHTTPD=17
};

 
enum
{
	RANDOM_POOLSIZE=1,
	RANDOM_ENTROPY_COUNT=2,
	RANDOM_READ_THRESH=3,
	RANDOM_WRITE_THRESH=4,
	RANDOM_BOOT_ID=5,
	RANDOM_UUID=6
};

 
enum
{
	BUS_ISA_MEM_BASE=1,
	BUS_ISA_PORT_BASE=2,
	BUS_ISA_PORT_SHIFT=3
};

 
enum
{
	NET_CORE_WMEM_MAX=1,
	NET_CORE_RMEM_MAX=2,
	NET_CORE_WMEM_DEFAULT=3,
	NET_CORE_RMEM_DEFAULT=4,
 
	NET_CORE_MAX_BACKLOG=6,
	NET_CORE_FASTROUTE=7,
	NET_CORE_MSG_COST=8,
	NET_CORE_MSG_BURST=9,
	NET_CORE_OPTMEM_MAX=10,
	NET_CORE_HOT_LIST_LENGTH=11,
	NET_CORE_DIVERT_VERSION=12,
	NET_CORE_NO_CONG_THRESH=13,
	NET_CORE_NO_CONG=14,
	NET_CORE_LO_CONG=15,
	NET_CORE_MOD_CONG=16
};

 

 

 

enum
{
	NET_UNIX_DESTROY_DELAY=1,
	NET_UNIX_DELETE_DELAY=2,
	NET_UNIX_MAX_DGRAM_QLEN=3,
};

 
enum
{
	 
	NET_IPV4_FORWARD=8,
	NET_IPV4_DYNADDR=9,

	NET_IPV4_CONF=16,
	NET_IPV4_NEIGH=17,
	NET_IPV4_ROUTE=18,
	NET_IPV4_FIB_HASH=19,

	NET_IPV4_TCP_TIMESTAMPS=33,
	NET_IPV4_TCP_WINDOW_SCALING=34,
	NET_IPV4_TCP_SACK=35,
	NET_IPV4_TCP_RETRANS_COLLAPSE=36,
	NET_IPV4_DEFAULT_TTL=37,
	NET_IPV4_AUTOCONFIG=38,
	NET_IPV4_NO_PMTU_DISC=39,
	NET_IPV4_TCP_SYN_RETRIES=40,
	NET_IPV4_IPFRAG_HIGH_THRESH=41,
	NET_IPV4_IPFRAG_LOW_THRESH=42,
	NET_IPV4_IPFRAG_TIME=43,
	NET_IPV4_TCP_MAX_KA_PROBES=44,
	NET_IPV4_TCP_KEEPALIVE_TIME=45,
	NET_IPV4_TCP_KEEPALIVE_PROBES=46,
	NET_IPV4_TCP_RETRIES1=47,
	NET_IPV4_TCP_RETRIES2=48,
	NET_IPV4_TCP_FIN_TIMEOUT=49,
	NET_IPV4_IP_MASQ_DEBUG=50,
	NET_TCP_SYNCOOKIES=51,
	NET_TCP_STDURG=52,
	NET_TCP_RFC1337=53,
	NET_TCP_SYN_TAILDROP=54,
	NET_TCP_MAX_SYN_BACKLOG=55,
	NET_IPV4_LOCAL_PORT_RANGE=56,
	NET_IPV4_ICMP_ECHO_IGNORE_ALL=57,
	NET_IPV4_ICMP_ECHO_IGNORE_BROADCASTS=58,
	NET_IPV4_ICMP_SOURCEQUENCH_RATE=59,
	NET_IPV4_ICMP_DESTUNREACH_RATE=60,
	NET_IPV4_ICMP_TIMEEXCEED_RATE=61,
	NET_IPV4_ICMP_PARAMPROB_RATE=62,
	NET_IPV4_ICMP_ECHOREPLY_RATE=63,
	NET_IPV4_ICMP_IGNORE_BOGUS_ERROR_RESPONSES=64,
	NET_IPV4_IGMP_MAX_MEMBERSHIPS=65,
	NET_TCP_TW_RECYCLE=66,
	NET_IPV4_ALWAYS_DEFRAG=67,
	NET_IPV4_TCP_KEEPALIVE_INTVL=68,
	NET_IPV4_INET_PEER_THRESHOLD=69,
	NET_IPV4_INET_PEER_MINTTL=70,
	NET_IPV4_INET_PEER_MAXTTL=71,
	NET_IPV4_INET_PEER_GC_MINTIME=72,
	NET_IPV4_INET_PEER_GC_MAXTIME=73,
	NET_TCP_ORPHAN_RETRIES=74,
	NET_TCP_ABORT_ON_OVERFLOW=75,
	NET_TCP_SYNACK_RETRIES=76,
	NET_TCP_MAX_ORPHANS=77,
	NET_TCP_MAX_TW_BUCKETS=78,
	NET_TCP_FACK=79,
	NET_TCP_REORDERING=80,
	NET_TCP_ECN=81,
	NET_TCP_DSACK=82,
	NET_TCP_MEM=83,
	NET_TCP_WMEM=84,
	NET_TCP_RMEM=85,
	NET_TCP_APP_WIN=86,
	NET_TCP_ADV_WIN_SCALE=87,
	NET_IPV4_NONLOCAL_BIND=88,
};

enum {
	NET_IPV4_ROUTE_FLUSH=1,
	NET_IPV4_ROUTE_MIN_DELAY=2,
	NET_IPV4_ROUTE_MAX_DELAY=3,
	NET_IPV4_ROUTE_GC_THRESH=4,
	NET_IPV4_ROUTE_MAX_SIZE=5,
	NET_IPV4_ROUTE_GC_MIN_INTERVAL=6,
	NET_IPV4_ROUTE_GC_TIMEOUT=7,
	NET_IPV4_ROUTE_GC_INTERVAL=8,
	NET_IPV4_ROUTE_REDIRECT_LOAD=9,
	NET_IPV4_ROUTE_REDIRECT_NUMBER=10,
	NET_IPV4_ROUTE_REDIRECT_SILENCE=11,
	NET_IPV4_ROUTE_ERROR_COST=12,
	NET_IPV4_ROUTE_ERROR_BURST=13,
	NET_IPV4_ROUTE_GC_ELASTICITY=14,
	NET_IPV4_ROUTE_MTU_EXPIRES=15,
	NET_IPV4_ROUTE_MIN_PMTU=16,
	NET_IPV4_ROUTE_MIN_ADVMSS=17
};

enum
{
	NET_PROTO_CONF_ALL=-2,
	NET_PROTO_CONF_DEFAULT=-3

	 
};

enum
{
	NET_IPV4_CONF_FORWARDING=1,
	NET_IPV4_CONF_MC_FORWARDING=2,
	NET_IPV4_CONF_PROXY_ARP=3,
	NET_IPV4_CONF_ACCEPT_REDIRECTS=4,
	NET_IPV4_CONF_SECURE_REDIRECTS=5,
	NET_IPV4_CONF_SEND_REDIRECTS=6,
	NET_IPV4_CONF_SHARED_MEDIA=7,
	NET_IPV4_CONF_RP_FILTER=8,
	NET_IPV4_CONF_ACCEPT_SOURCE_ROUTE=9,
	NET_IPV4_CONF_BOOTP_RELAY=10,
	NET_IPV4_CONF_LOG_MARTIANS=11,
	NET_IPV4_CONF_TAG=12,
	NET_IPV4_CONF_ARPFILTER=13
};

 
enum {
	NET_IPV6_CONF=16,
	NET_IPV6_NEIGH=17,
	NET_IPV6_ROUTE=18
};

enum {
	NET_IPV6_ROUTE_FLUSH=1,
	NET_IPV6_ROUTE_GC_THRESH=2,
	NET_IPV6_ROUTE_MAX_SIZE=3,
	NET_IPV6_ROUTE_GC_MIN_INTERVAL=4,
	NET_IPV6_ROUTE_GC_TIMEOUT=5,
	NET_IPV6_ROUTE_GC_INTERVAL=6,
	NET_IPV6_ROUTE_GC_ELASTICITY=7,
	NET_IPV6_ROUTE_MTU_EXPIRES=8,
	NET_IPV6_ROUTE_MIN_ADVMSS=9
};

enum {
	NET_IPV6_FORWARDING=1,
	NET_IPV6_HOP_LIMIT=2,
	NET_IPV6_MTU=3,
	NET_IPV6_ACCEPT_RA=4,
	NET_IPV6_ACCEPT_REDIRECTS=5,
	NET_IPV6_AUTOCONF=6,
	NET_IPV6_DAD_TRANSMITS=7,
	NET_IPV6_RTR_SOLICITS=8,
	NET_IPV6_RTR_SOLICIT_INTERVAL=9,
	NET_IPV6_RTR_SOLICIT_DELAY=10
};

 
enum {
	NET_NEIGH_MCAST_SOLICIT=1,
	NET_NEIGH_UCAST_SOLICIT=2,
	NET_NEIGH_APP_SOLICIT=3,
	NET_NEIGH_RETRANS_TIME=4,
	NET_NEIGH_REACHABLE_TIME=5,
	NET_NEIGH_DELAY_PROBE_TIME=6,
	NET_NEIGH_GC_STALE_TIME=7,
	NET_NEIGH_UNRES_QLEN=8,
	NET_NEIGH_PROXY_QLEN=9,
	NET_NEIGH_ANYCAST_DELAY=10,
	NET_NEIGH_PROXY_DELAY=11,
	NET_NEIGH_LOCKTIME=12,
	NET_NEIGH_GC_INTERVAL=13,
	NET_NEIGH_GC_THRESH1=14,
	NET_NEIGH_GC_THRESH2=15,
	NET_NEIGH_GC_THRESH3=16
};

 
enum {
	NET_IPX_PPROP_BROADCASTING=1,
	NET_IPX_FORWARDING=2
};


 
enum {
	NET_ATALK_AARP_EXPIRY_TIME=1,
	NET_ATALK_AARP_TICK_TIME=2,
	NET_ATALK_AARP_RETRANSMIT_LIMIT=3,
	NET_ATALK_AARP_RESOLVE_TIME=4
};


 
enum {
	NET_NETROM_DEFAULT_PATH_QUALITY=1,
	NET_NETROM_OBSOLESCENCE_COUNT_INITIALISER=2,
	NET_NETROM_NETWORK_TTL_INITIALISER=3,
	NET_NETROM_TRANSPORT_TIMEOUT=4,
	NET_NETROM_TRANSPORT_MAXIMUM_TRIES=5,
	NET_NETROM_TRANSPORT_ACKNOWLEDGE_DELAY=6,
	NET_NETROM_TRANSPORT_BUSY_DELAY=7,
	NET_NETROM_TRANSPORT_REQUESTED_WINDOW_SIZE=8,
	NET_NETROM_TRANSPORT_NO_ACTIVITY_TIMEOUT=9,
	NET_NETROM_ROUTING_CONTROL=10,
	NET_NETROM_LINK_FAILS_COUNT=11
};

 
enum {
	NET_AX25_IP_DEFAULT_MODE=1,
	NET_AX25_DEFAULT_MODE=2,
	NET_AX25_BACKOFF_TYPE=3,
	NET_AX25_CONNECT_MODE=4,
	NET_AX25_STANDARD_WINDOW=5,
	NET_AX25_EXTENDED_WINDOW=6,
	NET_AX25_T1_TIMEOUT=7,
	NET_AX25_T2_TIMEOUT=8,
	NET_AX25_T3_TIMEOUT=9,
	NET_AX25_IDLE_TIMEOUT=10,
	NET_AX25_N2=11,
	NET_AX25_PACLEN=12,
	NET_AX25_PROTOCOL=13,
	NET_AX25_DAMA_SLAVE_TIMEOUT=14
};

 
enum {
	NET_ROSE_RESTART_REQUEST_TIMEOUT=1,
	NET_ROSE_CALL_REQUEST_TIMEOUT=2,
	NET_ROSE_RESET_REQUEST_TIMEOUT=3,
	NET_ROSE_CLEAR_REQUEST_TIMEOUT=4,
	NET_ROSE_ACK_HOLD_BACK_TIMEOUT=5,
	NET_ROSE_ROUTING_CONTROL=6,
	NET_ROSE_LINK_FAIL_TIMEOUT=7,
	NET_ROSE_MAX_VCS=8,
	NET_ROSE_WINDOW_SIZE=9,
	NET_ROSE_NO_ACTIVITY_TIMEOUT=10
};

 
enum {
	NET_X25_RESTART_REQUEST_TIMEOUT=1,
	NET_X25_CALL_REQUEST_TIMEOUT=2,
	NET_X25_RESET_REQUEST_TIMEOUT=3,
	NET_X25_CLEAR_REQUEST_TIMEOUT=4,
	NET_X25_ACK_HOLD_BACK_TIMEOUT=5
};

 
enum
{
	NET_TR_RIF_TIMEOUT=1
};

 
enum {
	NET_DECNET_NODE_TYPE = 1,
	NET_DECNET_NODE_ADDRESS = 2,
	NET_DECNET_NODE_NAME = 3,
	NET_DECNET_DEFAULT_DEVICE = 4,
	NET_DECNET_TIME_WAIT = 5,
	NET_DECNET_DN_COUNT = 6,
	NET_DECNET_DI_COUNT = 7,
	NET_DECNET_DR_COUNT = 8,
	NET_DECNET_DST_GC_INTERVAL = 9,
	NET_DECNET_CONF = 10,
	NET_DECNET_DEBUG_LEVEL = 255
};

 
enum {
	NET_KHTTPD_DOCROOT	= 1,
	NET_KHTTPD_START	= 2,
	NET_KHTTPD_STOP		= 3,
	NET_KHTTPD_UNLOAD	= 4,
	NET_KHTTPD_CLIENTPORT	= 5,
	NET_KHTTPD_PERMREQ	= 6,
	NET_KHTTPD_PERMFORBID	= 7,
	NET_KHTTPD_LOGGING	= 8,
	NET_KHTTPD_SERVERPORT	= 9,
	NET_KHTTPD_DYNAMICSTRING= 10,
	NET_KHTTPD_SLOPPYMIME   = 11,
	NET_KHTTPD_THREADS	= 12,
	NET_KHTTPD_MAXCONNECT	= 13
};

 
enum {
	NET_DECNET_CONF_LOOPBACK = -2,
	NET_DECNET_CONF_DDCMP = -3,
	NET_DECNET_CONF_PPP = -4,
	NET_DECNET_CONF_X25 = -5,
	NET_DECNET_CONF_GRE = -6,
	NET_DECNET_CONF_ETHER = -7

	 
};

 
enum {
	NET_DECNET_CONF_DEV_PRIORITY = 1,
	NET_DECNET_CONF_DEV_T1 = 2,
	NET_DECNET_CONF_DEV_T2 = 3,
	NET_DECNET_CONF_DEV_T3 = 4,
	NET_DECNET_CONF_DEV_FORWARDING = 5,
	NET_DECNET_CONF_DEV_BLKSIZE = 6,
	NET_DECNET_CONF_DEV_STATE = 7
};

 

 
enum
{
	FS_NRINODE=1,	 
	FS_STATINODE=2,
	FS_MAXINODE=3,	 
	FS_NRDQUOT=4,	 
	FS_MAXDQUOT=5,	 
	FS_NRFILE=6,	 
	FS_MAXFILE=7,	 
	FS_DENTRY=8,
	FS_NRSUPER=9,	 
	FS_MAXSUPER=10,	 
	FS_OVERFLOWUID=11,	 
	FS_OVERFLOWGID=12,	 
	FS_LEASES=13,	 
	FS_DIR_NOTIFY=14,	 
	FS_LEASE_TIME=15,	 
};

 

 
enum {
	DEV_CDROM=1,
	DEV_HWMON=2,
	DEV_PARPORT=3,
	DEV_RAID=4,
	DEV_MAC_HID=5
};

 
enum {
	DEV_CDROM_INFO=1,
	DEV_CDROM_AUTOCLOSE=2,
	DEV_CDROM_AUTOEJECT=3,
	DEV_CDROM_DEBUG=4,
	DEV_CDROM_LOCK=5,
	DEV_CDROM_CHECK_MEDIA=6
};

 
enum {
	DEV_PARPORT_DEFAULT=-3
};

 
enum {
	DEV_RAID_SPEED_LIMIT_MIN=1,
	DEV_RAID_SPEED_LIMIT_MAX=2
};

 
enum {
	DEV_PARPORT_DEFAULT_TIMESLICE=1,
	DEV_PARPORT_DEFAULT_SPINTIME=2
};

 
enum {
	DEV_PARPORT_SPINTIME=1,
	DEV_PARPORT_BASE_ADDR=2,
	DEV_PARPORT_IRQ=3,
	DEV_PARPORT_DMA=4,
	DEV_PARPORT_MODES=5,
	DEV_PARPORT_DEVICES=6,
	DEV_PARPORT_AUTOPROBE=16
};

 
enum {
	DEV_PARPORT_DEVICES_ACTIVE=-3,
};

 
enum {
	DEV_PARPORT_DEVICE_TIMESLICE=1,
};

 
enum {
	DEV_MAC_HID_KEYBOARD_SENDS_LINUX_KEYCODES=1,
	DEV_MAC_HID_KEYBOARD_LOCK_KEYCODES=2,
	DEV_MAC_HID_MOUSE_BUTTON_EMULATION=3,
	DEV_MAC_HID_MOUSE_BUTTON2_KEYCODE=4,
	DEV_MAC_HID_MOUSE_BUTTON3_KEYCODE=5,
	DEV_MAC_HID_ADB_MOUSE_SENDS_KEYCODES=6
};

# 716 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/sysctl.h" 3





# 28 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/sysctl.h" 2 3


 
extern int sysctl (int *__name, int __nlen, void *__oldval,
		   size_t *__oldlenp, void *__newval, size_t __newlen)  ;

 


# 52 "physmem.c" 2







# 77 "physmem.c"


# 1 "../include/libiberty.h" 1
 








































# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 42 "../include/libiberty.h" 2



 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 







 

 




 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 





















typedef long int ptrdiff_t;









 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 





























 


























typedef int wchar_t;
























typedef unsigned int  wint_t;




 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 46 "../include/libiberty.h" 2

 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stdarg.h" 1 3
 
































































 






typedef void *__gnuc_va_list;



 



 

















void va_end (__gnuc_va_list);		 


 








 







 























 
 













# 175 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stdarg.h" 3


 




 

 

 

typedef __gnuc_va_list va_list;
























# 48 "../include/libiberty.h" 2



 


extern char **buildargv  (const char *)    ;

 

extern void freeargv  (char **)  ;

 


extern char **dupargv  (char **)    ;


 




 






extern char *basename  (const char *)  ;





 

extern const char *lbasename  (const char *)  ;

 

extern char *lrealpath  (const char *)  ;

 



extern char *concat  (const char *, ...)    ;

 






extern char *reconcat  (char *, const char *, ...)    ;

 



extern unsigned long concat_length  (const char *, ...)  ;

 




extern char *concat_copy  (char *, const char *, ...)  ;

 




extern char *concat_copy2  (const char *, ...)  ;

 

extern char *libiberty_concat_ptr;

 







 

extern int fdmatch  (int fd1, int fd2)  ;

 


extern char * getpwd  (void)  ;

 

extern long get_run_time  (void)  ;

 


extern char *make_relative_prefix  (const char *, const char *,
					   const char *)  ;

 

extern char *choose_temp_base  (void)    ;

 

extern char *make_temp_file  (const char *)    ;

 

extern const char *spaces  (int count)  ;

 


extern int errno_max  (void)  ;

 


extern const char *strerrno  (int)  ;

 

extern int strtoerrno  (const char *)  ;

 

extern char *xstrerror  (int)  ;

 


extern int signo_max  (void)  ;

 

 


 

 


extern const char *strsigno  (int)  ;

 

extern int strtosigno  (const char *)  ;

 

extern int xatexit  (void (*fn) (void))  ;

 

extern void xexit  (int status)   __attribute__ ((__noreturn__)) ;

 

extern void xmalloc_set_program_name  (const char *)  ;

 
extern void xmalloc_failed  (size_t)   __attribute__ ((__noreturn__)) ;

 



extern void *  xmalloc  (size_t)    ;

 



extern void *  xrealloc  (void * , size_t)  ;

 


extern void *  xcalloc  (size_t, size_t)    ;

 

extern char *xstrdup  (const char *)    ;

 

extern void *  xmemdup  (const void * , size_t, size_t)    ;

 
extern double physmem_total  (void)  ;
extern double physmem_available  (void)  ;

 



extern const unsigned char _hex_value[256 ];
extern void hex_init  (void)  ;

 



 







 

extern int pexecute  (const char *, char * const *, const char *,
			    const char *, char **, char **, int)  ;

 

extern int pwait  (int, int *, int)  ;


 


extern int asprintf  (char **, const char *, ...)   __attribute__ ((__format__ (__printf__,  2 ,   3 )))    ;



 


extern int vasprintf  (char **, const char *, va_list)  
  __attribute__ ((__format__ (__printf__,  2 ,  0 )))   ;




 





extern void *  C_alloca  (size_t)    ;









# 328 "../include/libiberty.h"








# 79 "physmem.c" 2


 
double
physmem_total ()
{

  {  
    double pages = sysconf (_SC_PHYS_PAGES );
    double pagesize = sysconf (_SC_PAGESIZE );
    if (0 <= pages && 0 <= pagesize)
      return pages * pagesize;
  }


# 105 "physmem.c"


# 118 "physmem.c"


# 133 "physmem.c"


# 145 "physmem.c"







# 179 "physmem.c"


   
  return 0;
}

 
double
physmem_available ()
{

  {  
    double pages = sysconf (_SC_AVPHYS_PAGES );
    double pagesize = sysconf (_SC_PAGESIZE );
    if (0 <= pages && 0 <= pagesize)
      return pages * pagesize;
  }


# 211 "physmem.c"


# 224 "physmem.c"


# 239 "physmem.c"


# 251 "physmem.c"


# 280 "physmem.c"


   
  return physmem_total () / 4;
}


# 299 "physmem.c"


 




