# 1 "pex-unix.c"
 





















# 1 "pex-common.h" 1
 























# 1 "config.h" 1
 
 

 
 

 
 

 


 
 

 
 

 
 

 
 

 
 

 
 

 


 
 

 


 
 

 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 
 

 


 


 
 

 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 
 

 


 


 


 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 


 
 

 


 


 


 


 
 

 
 

 
 

 


 


 


 


 
 

 

 

 


 
 

 


 


 


 


 


 

 






 
 

 


# 25 "pex-common.h" 2

# 1 "../include/libiberty.h" 1
 








































# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 42 "../include/libiberty.h" 2



 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 







 

 




 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 





















typedef long int ptrdiff_t;









 




 

 


































typedef long unsigned int size_t;






















 




 





























 


























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


 




 








extern char *basename ();



 

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








# 26 "pex-common.h" 2




 


 


 


 



# 23 "pex-unix.c" 2


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 1 3
 


















 







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




# 28 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 2 3


 



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 34 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 2 3


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/types.h" 1 3
 

















 




typedef unsigned int __socklen_t;  
typedef unsigned int __useconds_t;  
typedef int __clockid_t;  
typedef int __timer_t;  




# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

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


 





# 36 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 2 3








 
typedef struct _UC_FILE FILE;








 
typedef struct _UC_FILE __FILE;









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




typedef __ssize_t ssize_t;





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


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

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








 


# 65 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 2 3


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










 






 




# 25 "pex-unix.c" 2

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/errno.h" 1 3
 

















 





 






 

 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/errno.h" 1 3
 























# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/errno.h" 1 3



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/asm/errno.h" 1 3




































































































































# 4 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/errno.h" 2 3


# 24 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/linux/errno.h" 3



# 25 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/errno.h" 2 3


 


 




 
extern int errno;

 
extern int *__errno_location (void)   __attribute__ ((__const__));







 













# 36 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/errno.h" 2 3





 








# 58 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/errno.h" 3



 



 










# 26 "pex-unix.c" 2





# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/string.h" 1 3
 

















 








 

 


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

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


 


# 31 "pex-unix.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 1 3
 

















 








 

 


 



 


 


 


 



 



 



 



 






 


 




 


 


 



 



 



















































































# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/posix_opt.h" 1 3
 





















 


 


 


 


 


 


 


 


 


 


 


 


 



 


 


 


 


 


 



 


 


 


 
 

 


 

 


 


 





# 175 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/unistd.h" 2 3


 




 





 










# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

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


 


# 34 "pex-unix.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 1 3
 

















 







 







# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 35 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 2 3


 




# 94 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 3


 
typedef struct
  {
    int quot;			 
    int rem;			 
  } div_t;

 

typedef struct
  {
    long int quot;		 
    long int rem;		 
  } ldiv_t;



# 121 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 3



 



 












 
extern double atof (__const char *__nptr)    ;

 
extern int atoi (__const char *__nptr)    ;
 
extern long int atol (__const char *__nptr)    ;


 
__extension__ extern long long int atoll (__const char *__nptr)
        ;



 
extern double strtod (__const char *__restrict __nptr,
		      char **__restrict __endptr)  ;











 
extern long int strtol (__const char *__restrict __nptr,
			char **__restrict __endptr, int __base)  ;
 
extern unsigned long int strtoul (__const char *__restrict __nptr,
				  char **__restrict __endptr, int __base)
      ;


 
__extension__
extern long long int strtoq (__const char *__restrict __nptr,
			     char **__restrict __endptr, int __base)  ;
 
__extension__
extern unsigned long long int strtouq (__const char *__restrict __nptr,
				       char **__restrict __endptr, int __base)
      ;



 

 
__extension__
extern long long int strtoll (__const char *__restrict __nptr,
			      char **__restrict __endptr, int __base)  ;
 
__extension__
extern unsigned long long int strtoull (__const char *__restrict __nptr,
					char **__restrict __endptr, int __base)
      ;



# 253 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 3



 



extern double __strtod_internal (__const char *__restrict __nptr,
				 char **__restrict __endptr, int __group)
      ;
extern float __strtof_internal (__const char *__restrict __nptr,
				char **__restrict __endptr, int __group)
      ;
extern long double __strtold_internal (__const char *__restrict __nptr,
				       char **__restrict __endptr,
				       int __group)  ;


extern long int __strtol_internal (__const char *__restrict __nptr,
				   char **__restrict __endptr,
				   int __base, int __group)  ;



extern unsigned long int __strtoul_internal (__const char *__restrict __nptr,
					     char **__restrict __endptr,
					     int __base, int __group)  ;




__extension__
extern long long int __strtoll_internal (__const char *__restrict __nptr,
					 char **__restrict __endptr,
					 int __base, int __group)  ;



__extension__
extern unsigned long long int __strtoull_internal (__const char *
						   __restrict __nptr,
						   char **__restrict __endptr,
						   int __base, int __group)
      ;




# 388 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 3




 


extern char *l64a (long int __n)  ;

 
extern long int a64l (__const char *__s)    ;




 



 
extern long int random (void)  ;

 
extern void srandom (unsigned int __seed)  ;

 



extern char *initstate (unsigned int __seed, char *__statebuf,
			size_t __statelen)  ;

 

extern char *setstate (char *__statebuf)  ;



 



struct random_data
  {
    int32_t *fptr;		 
    int32_t *rptr;		 
    int32_t *state;		 
    int rand_type;		 
    int rand_deg;		 
    int rand_sep;		 
    int32_t *end_ptr;		 
  };

extern int random_r (struct random_data *__restrict __buf,
		     int32_t *__restrict __result)  ;

extern int srandom_r (unsigned int __seed, struct random_data *__buf)  ;

extern int initstate_r (unsigned int __seed, char *__restrict __statebuf,
			size_t __statelen,
			struct random_data *__restrict __buf)  ;

extern int setstate_r (char *__restrict __statebuf,
		       struct random_data *__restrict __buf)  ;




 
extern int rand (void)  ;
 
extern void srand (unsigned int __seed)  ;


 
extern int rand_r (unsigned int *__seed)  ;




 


 
extern double drand48 (void)  ;
extern double erand48 (unsigned short int __xsubi[3])  ;


 
extern long int lrand48 (void)  ;
extern long int nrand48 (unsigned short int __xsubi[3])  ;

 
extern long int mrand48 (void)  ;
extern long int jrand48 (unsigned short int __xsubi[3])  ;

 
extern void srand48 (long int __seedval)  ;
extern unsigned short int *seed48 (unsigned short int __seed16v[3])  ;
extern void lcong48 (unsigned short int __param[7])  ;


 


struct drand48_data
  {
    unsigned short int __x[3];	 
    unsigned short int __old_x[3];  
    unsigned short int __c;	 
    unsigned short int __init;	 
    unsigned long long int __a;	 
  };


 
extern int drand48_r (struct drand48_data *__restrict __buffer,
		      double *__restrict __result)  ;
extern int erand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      double *__restrict __result)  ;


 
extern int lrand48_r (struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)  ;
extern int nrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)  ;

 
extern int mrand48_r (struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)  ;
extern int jrand48_r (unsigned short int __xsubi[3],
		      struct drand48_data *__restrict __buffer,
		      long int *__restrict __result)  ;

 
extern int srand48_r (long int __seedval, struct drand48_data *__buffer)
      ;

extern int seed48_r (unsigned short int __seed16v[3],
		     struct drand48_data *__buffer)  ;

extern int lcong48_r (unsigned short int __param[7],
		      struct drand48_data *__buffer)  ;







 
extern void *malloc (size_t __size)    ;
 
extern void *calloc (size_t __nmemb, size_t __size)
        ;



 

extern void *realloc (void *__ptr, size_t __size)    ;
 
extern void free (void *__ptr)  ;


 
extern void cfree (void *__ptr)  ;



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/alloca.h" 1 3
 























# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 25 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/alloca.h" 2 3


 

 


 
extern void *alloca (size_t __size)  ;





 


# 561 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 2 3




 
extern void *valloc (size_t __size)    ;








 
extern void abort (void)   __attribute__ ((__noreturn__));


 
extern int atexit (void (*__func) (void))  ;

 




 

extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg)
      ;


 


extern void exit (int __status)   __attribute__ ((__noreturn__));








 
extern char *getenv (__const char *__name)  ;

 

extern char *__secure_getenv (__const char *__name)  ;


 
 

extern int putenv (char *__string)  ;



 

extern int setenv (__const char *__name, __const char *__value, int __replace)
      ;

 
extern int unsetenv (__const char *__name)  ;



 


extern int clearenv (void)  ;




 



extern char *mktemp (char *__template)  ;

 





extern int mkstemp (char *__template)  ;













 




extern char *mkdtemp (char *__template)  ;



 
extern int system (__const char *__command)  ;











 





extern char *realpath (__const char *__restrict __name,
		       char *__restrict __resolved)  ;



 


typedef int (*__compar_fn_t) (__const void *, __const void *);






 

extern void *bsearch (__const void *__key, __const void *__base,
		      size_t __nmemb, size_t __size, __compar_fn_t __compar);

 

extern void qsort (void *__base, size_t __nmemb, size_t __size,
		   __compar_fn_t __compar);


 
extern int abs (int __x)   __attribute__ ((__const__));
extern long int labs (long int __x)   __attribute__ ((__const__));






 

 
extern div_t div (int __numer, int __denom)
       __attribute__ ((__const__));
extern ldiv_t ldiv (long int __numer, long int __denom)
       __attribute__ ((__const__));









 


 


extern char *ecvt (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign)  ;

 


extern char *fcvt (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign)  ;

 


extern char *gcvt (double __value, int __ndigit, char *__buf)  ;



 
extern char *qecvt (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign)  ;
extern char *qfcvt (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign)  ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf)  ;


 

extern int ecvt_r (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign, char *__restrict __buf,
		   size_t __len)  ;
extern int fcvt_r (double __value, int __ndigit, int *__restrict __decpt,
		   int *__restrict __sign, char *__restrict __buf,
		   size_t __len)  ;

extern int qecvt_r (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign,
		    char *__restrict __buf, size_t __len)  ;
extern int qfcvt_r (long double __value, int __ndigit,
		    int *__restrict __decpt, int *__restrict __sign,
		    char *__restrict __buf, size_t __len)  ;




# 812 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 3



 



extern int rpmatch (__const char *__response)  ;



# 833 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 3









 






# 864 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 3


# 876 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 3



 


extern int getloadavg (double __loadavg[], int __nelem)  ;





 


# 37 "pex-unix.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/wait.h" 1 3
 

















 









 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 1 3
 

















 











 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigset.h" 1 3
 


















# 33 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigset.h" 3



 












 



 














# 97 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigset.h" 3



 


extern int __sigismember (__const __sigset_t *, int);
extern int __sigaddset (__sigset_t *, int);
extern int __sigdelset (__sigset_t *, int);

# 122 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigset.h" 3




# 33 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 2 3


 




typedef __sig_atomic_t sig_atomic_t;















# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/signum.h" 1 3
 




















 









 










































 





# 56 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 2 3


# 67 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 3



 
typedef void (*__sighandler_t) (int);

 


extern __sighandler_t __sysv_signal (int __sig, __sighandler_t __handler)
      ;





 



extern __sighandler_t signal (int __sig, __sighandler_t __handler)  ;
# 98 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 3








 



extern int kill (__pid_t __pid, int __sig)  ;



 


extern int killpg (__pid_t __pgrp, int __sig)  ;


 
extern int raise (int __sig)  ;


 
extern __sighandler_t ssignal (int __sig, __sighandler_t __handler)  ;
extern int gsignal (int __sig)  ;



 
extern void psignal (int __sig, __const char *__s)  ;



 




extern int __sigpause (int __sig_or_mask, int __is_sig)  ;


 

extern int sigpause (int __mask)  ;

# 155 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 3




 




 


 
extern int sigblock (int __mask)  ;

 
extern int sigsetmask (int __mask)  ;

 
extern int siggetmask (void)  ;











 

typedef __sighandler_t sig_t;





 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 1 3
 

















 














# 51 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 72 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 84 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 96 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3




# 112 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3




# 366 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 196 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 2 3


 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/siginfo.h" 1 3
 


























 
typedef union sigval
  {
    int sival_int;
    void *sival_ptr;
  } sigval_t;




typedef struct siginfo
  {
    int si_signo;		 
    int si_errno;		 

    int si_code;		 

    union
      {
	int _pad[((128  / sizeof (int)) - 3) ];

	  
	struct
	  {
	    __pid_t si_pid;	 
	    __uid_t si_uid;	 
	  } _kill;

	 
	struct
	  {
	    unsigned int _timer1;
	    unsigned int _timer2;
	  } _timer;

	 
	struct
	  {
	    __pid_t si_pid;	 
	    __uid_t si_uid;	 
	    sigval_t si_sigval;	 
	  } _rt;

	 
	struct
	  {
	    __pid_t si_pid;	 
	    __uid_t si_uid;	 
	    int si_status;	 
	    __clock_t si_utime;
	    __clock_t si_stime;
	  } _sigchld;

	 
	struct
	  {
	    void *si_addr;	 
	  } _sigfault;

	 
	struct
	  {
	    int si_band;	 
	    int si_fd;
	  } _sigpoll;
      } _sifields;
  } siginfo_t;


 













 

enum
{
  SI_SIGIO = -5,		 

  SI_ASYNCIO,			 

  SI_MESGQ,			 

  SI_TIMER,			 

  SI_QUEUE,			 

  SI_USER			 

};


 
enum
{
  ILL_ILLOPC = 1,		 

  ILL_ILLOPN,			 

  ILL_ILLADR,			 

  ILL_ILLTRP,			 

  ILL_PRVOPC,			 

  ILL_PRVREG,			 

  ILL_COPROC,			 

  ILL_BADSTK			 

};

 
enum
{
  FPE_INTDIV = 1,		 

  FPE_INTOVF,			 

  FPE_FLTDIV,			 

  FPE_FLTOVF,			 

  FPE_FLTUND,			 

  FPE_FLTRES,			 

  FPE_FLTINV,			 

  FPE_FLTSUB			 

};

 
enum
{
  SEGV_MAPERR = 1,		 

  SEGV_ACCERR			 

};

 
enum
{
  BUS_ADRALN = 1,		 

  BUS_ADRERR,			 

  BUS_OBJERR			 

};

 
enum
{
  TRAP_BRKPT = 1,		 

  TRAP_TRACE			 

};

 
enum
{
  CLD_EXITED = 1,		 

  CLD_KILLED,			 

  CLD_DUMPED,			 

  CLD_TRAPPED,			 

  CLD_STOPPED,			 

  CLD_CONTINUED			 

};

 
enum
{
  POLL_IN = 1,			 

  POLL_OUT,			 

  POLL_MSG,			 

  POLL_ERR,			 

  POLL_PRI,			 

  POLL_HUP			 

};








 



typedef struct sigevent
  {
    sigval_t sigev_value;
    int sigev_signo;
    int sigev_notify;

    union
      {
	int _pad[((64  / sizeof (int)) - 3) ];

	struct
	  {
	    void (*_function)  (sigval_t)    ;  
	    void *_attribute;			   
	  } _sigev_thread;
      } _sigev_un;
  } sigevent_t;

 



 
enum
{
  SIGEV_SIGNAL = 0,		 

  SIGEV_NONE,			 

  SIGEV_THREAD			 

};


# 199 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 2 3



 
extern int sigemptyset (sigset_t *__set)  ;

 
extern int sigfillset (sigset_t *__set)  ;

 
extern int sigaddset (sigset_t *__set, int __signo)  ;

 
extern int sigdelset (sigset_t *__set, int __signo)  ;

 
extern int sigismember (__const sigset_t *__set, int __signo)  ;

# 228 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 3


 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigaction.h" 1 3
 






















 
struct sigaction
  {
     

    union
      {
	 
	__sighandler_t sa_handler;
	 
	void (*sa_sigaction)  (int, siginfo_t *, void *)    ;
      }
    __sigaction_handler;






     
    __sigset_t sa_mask;

     
    int sa_flags;

     
    void (*sa_restorer)  (void)    ;
  };

 














 





 



# 232 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 2 3


 
extern int sigprocmask (int __how, __const sigset_t *__restrict __set,
			sigset_t *__restrict __oset)  ;

 

extern int sigsuspend (__const sigset_t *__set)  ;

 
extern int sigaction (int __sig, __const struct sigaction *__restrict __act,
		      struct sigaction *__restrict __oact)  ;

 
extern int sigpending (sigset_t *__set)  ;


 
extern int sigwait (__const sigset_t *__restrict __set, int *__restrict __sig)
      ;


 
extern int sigwaitinfo (__const sigset_t *__restrict __set,
			siginfo_t *__restrict __info)  ;

 

extern int sigtimedwait (__const sigset_t *__restrict __set,
			 siginfo_t *__restrict __info,
			 __const struct timespec *__restrict __timeout)
      ;

 

extern int sigqueue (__pid_t __pid, int __sig, __const union sigval __val)
      ;






 

extern __const char *__const _sys_siglist[64 ];
extern __const char *__const sys_siglist[64 ];

 
struct sigvec
  {
    __sighandler_t sv_handler;	 
    int sv_mask;		 

    int sv_flags;		 

  };

 





 




extern int sigvec (int __sig, __const struct sigvec *__vec,
		   struct sigvec *__ovec)  ;


 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigcontext.h" 1 3
 






















 



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/asm/sigcontext.h" 1 3



struct sigcontext {
	unsigned long  sc_mask; 	 
	unsigned long  sc_usp;		 
	unsigned long  sc_r0;
	unsigned long  sc_r1;
	unsigned long  sc_p0;
	unsigned long  sc_p1;
	unsigned short sc_seqstat;
	unsigned long  sc_pc;
};


# 28 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigcontext.h" 2 3


# 307 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 2 3


 
extern int sigreturn (struct sigcontext *__scp)  ;






 


extern int siginterrupt (int __sig, int __interrupt)  ;

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/sigstack.h" 1 3
 























 
struct sigstack
  {
    void *  ss_sp;		 
    int ss_onstack;		 
  };


 
enum
{
  SS_ONSTACK = 1,

  SS_DISABLE

};

 


 



 
typedef struct sigaltstack
  {
    void *  ss_sp;
    int ss_flags;
    size_t ss_size;
  } stack_t;
# 322 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 2 3





 


extern int sigstack (struct sigstack *__ss, struct sigstack *__oss)  ;

 

extern int sigaltstack (__const struct sigaltstack *__restrict __ss,
			struct sigaltstack *__restrict __oss)  ;



# 353 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/signal.h" 3








 


 
extern int __libc_current_sigrtmin (void)  ;
 
extern int __libc_current_sigrtmax (void)  ;



 


# 31 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/wait.h" 2 3

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/resource.h" 1 3
 






















 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/resource.h" 1 3
 
























 




 
enum __rlimit_resource
{
   
  RLIMIT_CPU = 0,


   
  RLIMIT_FSIZE = 1,


   
  RLIMIT_DATA = 2,


   
  RLIMIT_STACK = 3,


   
  RLIMIT_CORE = 4,


   



  RLIMIT_RSS = 5,


   
  RLIMIT_NOFILE = 7,
  RLIMIT_OFILE = RLIMIT_NOFILE,  



   
  RLIMIT_AS = 9,


   
  RLIMIT_NPROC = 6,


   
  RLIMIT_MEMLOCK = 8,


   
  RLIMIT_LOCKS = 10,


  RLIMIT_NLIMITS = 11,
  RLIM_NLIMITS = RLIMIT_NLIMITS


};

 










 




 

typedef __rlim_t rlim_t;







struct rlimit
  {
     
    rlim_t rlim_cur;
     
    rlim_t rlim_max;
  };

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/resource.h" 3


 
enum __rusage_who
{
   
  RUSAGE_SELF = 0,


   
  RUSAGE_CHILDREN = -1,


   
  RUSAGE_BOTH = -2

};


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 1 3
 


















 



# 43 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 3




# 58 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 3

 
# 150 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/resource.h" 2 3


 
struct rusage
  {
     
    struct timeval ru_utime;
     
    struct timeval ru_stime;
     
    long int ru_maxrss;
     

    long int ru_ixrss;
     
    long int ru_idrss;
     
    long int ru_isrss;
     

    long int ru_minflt;
     
    long int ru_majflt;
     
    long int ru_nswap;
     

    long int ru_inblock;
     
    long int ru_oublock;
     
    long int ru_msgsnd;
     
    long int ru_msgrcv;
     
    long int ru_nsignals;
     


    long int ru_nvcsw;
     

    long int ru_nivcsw;
  };

 



 

enum __priority_which
{
  PRIO_PROCESS = 0,		 

  PRIO_PGRP = 1,		 

  PRIO_USER = 2			 

};
# 25 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/resource.h" 2 3







 

 








typedef int __rlimit_resource_t;
typedef int __rusage_who_t;
typedef int __priority_which_t;


 


extern int getrlimit (__rlimit_resource_t __resource,
		      struct rlimit *__rlimits)  ;
# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/resource.h" 3






 



extern int setrlimit (__rlimit_resource_t __resource,
		      __const struct rlimit *__rlimits)  ;
# 81 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/resource.h" 3






 

extern int getrusage (__rusage_who_t __who, struct rusage *__usage)  ;

 



extern int getpriority (__priority_which_t __which, id_t __who)  ;

 

extern int setpriority (__priority_which_t __which, id_t __who, int __prio)
      ;

 


# 32 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/wait.h" 2 3


 

 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/waitflags.h" 1 3
 

















# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/wait.h" 1 3
 

















 




# 176 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/wait.h" 3

# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/waitflags.h" 2 3






 





# 38 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/wait.h" 2 3




 










 








 
 

















 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/waitstatus.h" 1 3
 























 


 


 


 


 


 








 


 


 









union wait
  {
    int w_status;
    struct
      {

	unsigned int __w_termsig:7;  
	unsigned int __w_coredump:1;  
	unsigned int __w_retcode:8;  
	unsigned int:16;







      } __wait_terminated;
    struct
      {

	unsigned int __w_stopval:8;  
	unsigned int __w_stopsig:8;  
	unsigned int:16;






      } __wait_stopped;
  };








# 82 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/wait.h" 2 3

















 

typedef enum
{
  P_ALL,		 
  P_PID,		 
  P_PGID		 
} idtype_t;



 

extern __pid_t wait (int*  __stat_loc)  ;


 




 











extern __pid_t waitpid (__pid_t __pid, int *__stat_loc, int __options)  ;



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/siginfo.h" 1 3
 






















# 236 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/siginfo.h" 3



# 279 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/siginfo.h" 3

# 136 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/wait.h" 2 3

 







extern int waitid (idtype_t __idtype, __id_t __id, siginfo_t *__infop,
		   int __options)  ;



 

struct rusage;

 




extern __pid_t wait3 (int*  __stat_loc, int __options,
		      struct rusage * __usage)  ;



 

struct rusage;

 
extern __pid_t wait4 (__pid_t __pid, int*  __stat_loc, int __options,
		      struct rusage *__usage)  ;



 


# 40 "pex-unix.c" 2







extern int execv ();
extern int execvp ();

int
pexecute (program, argv, this_pname, temp_base, errmsg_fmt, errmsg_arg, flags)
     const char *program;
     char * const *argv;
     const char *this_pname;
     const char *temp_base __attribute__ ((__unused__)) ;
     char **errmsg_fmt, **errmsg_arg;
     int flags;
{
  int (*func)() = (flags & 4  ? execvp : execv);
  int pid;
  int pdes[2];
  int input_desc, output_desc;
  int retries, sleep_interval;
   


  static int last_pipe_input;

   
  if (flags & 1 )
    last_pipe_input = 0 ;

  input_desc = last_pipe_input;

   

  if (! (flags & 2 ))
    {
      if (pipe (pdes) < 0)
	{
	  *errmsg_fmt = "pipe";
	  *errmsg_arg = ((void *)0) ;
	  return -1;
	}
      output_desc = pdes[1 ];
      last_pipe_input = pdes[0 ];
    }
  else
    {
       
      output_desc = 1 ;
      last_pipe_input = 0 ;
    }

   
  sleep_interval = 1;
  pid = -1;
  for (retries = 0; retries < 4; retries++)
    {
      pid = fork ();
      if (pid >= 0)
	break;
      sleep (sleep_interval);
      sleep_interval *= 2;
    }

  switch (pid)
    {
    case -1:
      *errmsg_fmt = "fork";
      *errmsg_arg = ((void *)0) ;
      return -1;

    case 0:  
       
      if (input_desc != 0 )
	{
	  close (0 );
	  dup (input_desc);
	  close (input_desc);
	}
      if (output_desc != 1 )
	{
	  close (1 );
	  dup (output_desc);
	  close (output_desc);
	}

       
      if (last_pipe_input != 0 )
	close (last_pipe_input);

       
      (*func) (program, argv);

      fprintf (stderr , "%s: ", this_pname);
      fprintf (stderr , "installation problem, cannot exec `%s'" , program);
      fprintf (stderr , ": %s\n", xstrerror ((*__errno_location ()) ));
      exit (-1);
       
      return 0;

    default:
       

      if (input_desc != 0 )
	close (input_desc);
      if (output_desc != 1 )
	close (output_desc);

       
      return pid;
    }
}

int
pwait (pid, status, flags)
     int pid;
     int *status;
     int flags __attribute__ ((__unused__)) ;
{
   

  pid = waitpid (pid, status, 0);
  return pid;
}
