# 1 "strerror.c"
 



# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 5 "strerror.c" 2

# 1 "../include/libiberty.h" 1
 











































 
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








# 6 "strerror.c" 2


# 1 "config.h" 1
 
 

 
 

 
 

 


 
 

 
 

 
 

 
 

 
 

 
 

 


 
 

 


 
 

 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 
 

 


 


 
 

 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 
 

 


 


 


 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 


 
 

 


 


 


 


 
 

 
 

 
 

 


 


 


 


 
 

 

 

 


 
 

 


 


 


 


 


 

 






 
 

 


# 8 "strerror.c" 2



 








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

 


extern int sys_nerr__ ;
extern __const char *__const sys_errlist__ [];









 
extern int fileno (FILE *__stream)  ;



 
extern int fileno_unlocked (FILE *__stream)  ;





 
extern FILE *popen (__const char *__command, __const char *__modes)  ;

 
extern int pclose (FILE *__stream)  ;




 
extern char *ctermid (char *__s)  ;









# 603 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 3




 
 
extern void flockfile (FILE *__stream)  ;

 

extern int ftrylockfile (FILE *__stream)  ;

 
extern void funlockfile (FILE *__stream)  ;










 






 




# 20 "strerror.c" 2

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



 



 










# 21 "strerror.c" 2







 


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





 


# 31 "strerror.c" 2






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


 


# 37 "strerror.c" 2









static void init_error_tables  (void)  ;

 










struct error_info
{
  const int value;		 
  const char *const name;	 



};







static const struct error_info error_table[] =
{

  { 1  ,   "EPERM" } ,


  { 2  ,   "ENOENT" } ,


  { 3  ,   "ESRCH" } ,


  { 4  ,   "EINTR" } ,


  { 5  ,   "EIO" } ,


  { 6  ,   "ENXIO" } ,


  { 7  ,   "E2BIG" } ,


  { 8  ,   "ENOEXEC" } ,


  { 9  ,   "EBADF" } ,


  { 10  ,   "ECHILD" } ,


  { 11   ,   "EWOULDBLOCK" } ,


  { 11  ,   "EAGAIN" } ,


  { 12  ,   "ENOMEM" } ,


  { 13  ,   "EACCES" } ,


  { 14  ,   "EFAULT" } ,


  { 15  ,   "ENOTBLK" } ,


  { 16  ,   "EBUSY" } ,


  { 17  ,   "EEXIST" } ,


  { 18  ,   "EXDEV" } ,


  { 19  ,   "ENODEV" } ,


  { 20  ,   "ENOTDIR" } ,


  { 21  ,   "EISDIR" } ,


  { 22  ,   "EINVAL" } ,


  { 23  ,   "ENFILE" } ,


  { 24  ,   "EMFILE" } ,


  { 25  ,   "ENOTTY" } ,


  { 26  ,   "ETXTBSY" } ,


  { 27  ,   "EFBIG" } ,


  { 28  ,   "ENOSPC" } ,


  { 29  ,   "ESPIPE" } ,


  { 30  ,   "EROFS" } ,


  { 31  ,   "EMLINK" } ,


  { 32  ,   "EPIPE" } ,


  { 33  ,   "EDOM" } ,


  { 34  ,   "ERANGE" } ,


  { 42  ,   "ENOMSG" } ,


  { 43  ,   "EIDRM" } ,


  { 44  ,   "ECHRNG" } ,


  { 45  ,   "EL2NSYNC" } ,


  { 46  ,   "EL3HLT" } ,


  { 47  ,   "EL3RST" } ,


  { 48  ,   "ELNRNG" } ,


  { 49  ,   "EUNATCH" } ,


  { 50  ,   "ENOCSI" } ,


  { 51  ,   "EL2HLT" } ,


  { 35  ,   "EDEADLK" } ,


  { 37  ,   "ENOLCK" } ,


  { 52  ,   "EBADE" } ,


  { 53  ,   "EBADR" } ,


  { 54  ,   "EXFULL" } ,


  { 55  ,   "ENOANO" } ,


  { 56  ,   "EBADRQC" } ,


  { 57  ,   "EBADSLT" } ,


  { 35   ,   "EDEADLOCK" } ,


  { 59  ,   "EBFONT" } ,


  { 60  ,   "ENOSTR" } ,


  { 61  ,   "ENODATA" } ,


  { 62  ,   "ETIME" } ,


  { 63  ,   "ENOSR" } ,


  { 64  ,   "ENONET" } ,


  { 65  ,   "ENOPKG" } ,


  { 66  ,   "EREMOTE" } ,


  { 67  ,   "ENOLINK" } ,


  { 68  ,   "EADV" } ,


  { 69  ,   "ESRMNT" } ,


  { 70  ,   "ECOMM" } ,


  { 71  ,   "EPROTO" } ,


  { 72  ,   "EMULTIHOP" } ,


  { 73  ,   "EDOTDOT" } ,


  { 74  ,   "EBADMSG" } ,


  { 36  ,   "ENAMETOOLONG" } ,


  { 75  ,   "EOVERFLOW" } ,


  { 76  ,   "ENOTUNIQ" } ,


  { 77  ,   "EBADFD" } ,


  { 78  ,   "EREMCHG" } ,


  { 79  ,   "ELIBACC" } ,


  { 80  ,   "ELIBBAD" } ,


  { 81  ,   "ELIBSCN" } ,


  { 82  ,   "ELIBMAX" } ,


  { 83  ,   "ELIBEXEC" } ,


  { 84  ,   "EILSEQ" } ,


  { 38  ,   "ENOSYS" } ,


  { 40  ,   "ELOOP" } ,


  { 85  ,   "ERESTART" } ,


  { 86  ,   "ESTRPIPE" } ,


  { 39  ,   "ENOTEMPTY" } ,


  { 87  ,   "EUSERS" } ,


  { 88  ,   "ENOTSOCK" } ,


  { 89  ,   "EDESTADDRREQ" } ,


  { 90  ,   "EMSGSIZE" } ,


  { 91  ,   "EPROTOTYPE" } ,


  { 92  ,   "ENOPROTOOPT" } ,


  { 93  ,   "EPROTONOSUPPORT" } ,


  { 94  ,   "ESOCKTNOSUPPORT" } ,


  { 95  ,   "EOPNOTSUPP" } ,


  { 96  ,   "EPFNOSUPPORT" } ,


  { 97  ,   "EAFNOSUPPORT" } ,


  { 98  ,   "EADDRINUSE" } ,


  { 99  ,   "EADDRNOTAVAIL" } ,


  { 100  ,   "ENETDOWN" } ,


  { 101  ,   "ENETUNREACH" } ,


  { 102  ,   "ENETRESET" } ,


  { 103  ,   "ECONNABORTED" } ,


  { 104  ,   "ECONNRESET" } ,


  { 105  ,   "ENOBUFS" } ,


  { 106  ,   "EISCONN" } ,


  { 107  ,   "ENOTCONN" } ,


  { 108  ,   "ESHUTDOWN" } ,


  { 109  ,   "ETOOMANYREFS" } ,


  { 110  ,   "ETIMEDOUT" } ,


  { 111  ,   "ECONNREFUSED" } ,


  { 112  ,   "EHOSTDOWN" } ,


  { 113  ,   "EHOSTUNREACH" } ,


  { 114  ,   "EALREADY" } ,


  { 115  ,   "EINPROGRESS" } ,


  { 116  ,   "ESTALE" } ,


  { 117  ,   "EUCLEAN" } ,


  { 118  ,   "ENOTNAM" } ,


  { 119  ,   "ENAVAIL" } ,


  { 120  ,   "EISNAM" } ,


  { 121  ,   "EREMOTEIO" } ,

  { 0 ,   ((void *)0)  } 
};








 


static const char **error_names;
static int num_error_names = 0;

 














extern int sys_nerr;
extern char *sys_errlist[];




 



























static void
init_error_tables ()
{
  const struct error_info *eip;
  int nbytes;

   


  if (num_error_names == 0)
    {
      for (eip = error_table; eip -> name != ((void *)0) ; eip++)
	{
	  if (eip -> value >= num_error_names)
	    {
	      num_error_names = eip -> value + 1;
	    }
	}
    }

   


  if (error_names == ((void *)0) )
    {
      nbytes = num_error_names * sizeof (char *);
      if ((error_names = (const char **) malloc (nbytes)) != ((void *)0) )
	{
	  memset (error_names, 0, nbytes);
	  for (eip = error_table; eip -> name != ((void *)0) ; eip++)
	    {
	      error_names[eip -> value] = eip -> name;
	    }
	}
    }

# 559 "strerror.c"


}

 





















int
errno_max ()
{
  int maxsize;

  if (error_names == ((void *)0) )
    {
      init_error_tables ();
    }
  maxsize = (( sys_nerr ) > (  num_error_names ) ? ( sys_nerr ) : (  num_error_names )) ;
  return (maxsize - 1);
}

# 665 "strerror.c"



 






















const char *
strerrno (errnoval)
  int errnoval;
{
  const char *name;
  static char buf[32];

  if (error_names == ((void *)0) )
    {
      init_error_tables ();
    }

  if ((errnoval < 0) || (errnoval >= num_error_names))
    {





       
      name = ((void *)0) ;
    }
  else if ((error_names == ((void *)0) ) || (error_names[errnoval] == ((void *)0) ))
    {
       
      sprintf (buf, "Error %d", errnoval);
      name = (const char *) buf;
    }
  else
    {
       
      name = error_names[errnoval];
    }

  return (name);
}

 










int
strtoerrno (name)
     const char *name;
{
  int errnoval = 0;

  if (name != ((void *)0) )
    {
      if (error_names == ((void *)0) )
	{
	  init_error_tables ();
	}
      for (errnoval = 0; errnoval < num_error_names; errnoval++)
	{
	  if ((error_names[errnoval] != ((void *)0) ) &&
	      (strcmp (name, error_names[errnoval]) == 0))
	    {
	      break;
	    }
	}
      if (errnoval == num_error_names)
	{





	  errnoval = 0;
	}
    }
  return (errnoval);
}


 


# 811 "strerror.c"

