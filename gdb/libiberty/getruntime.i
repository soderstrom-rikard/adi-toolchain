# 1 "getruntime.c"
 


















# 1 "config.h" 1
 
 

 
 

 
 

 


 
 

 
 

 
 

 
 

 
 

 
 

 


 
 

 


 
 

 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 
 

 


 


 
 

 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 
 

 


 


 


 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 


 
 

 


 


 


 


 
 

 
 

 
 

 


 


 


 


 
 

 

 

 


 
 

 


 


 


 


 


 

 






 
 

 


# 20 "getruntime.c" 2


# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 22 "getruntime.c" 2

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








# 23 "getruntime.c" 2


 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 1 3
 

















 






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




# 26 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 2 3


 

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


 





# 30 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 2 3


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








 


# 27 "getruntime.c" 2


 





# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 1 3
 

















 










 




 


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 


# 126 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 


# 269 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3
















 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 38 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 2 3


 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 1 3
 


















 







 


 





 







# 59 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/time.h" 3
 
# 42 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 2 3


 













 
typedef __clock_t clock_t;




# 72 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 84 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



# 96 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3




# 112 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3





 
struct tm
{
  int tm_sec;			 
  int tm_min;			 
  int tm_hour;			 
  int tm_mday;			 
  int tm_mon;			 
  int tm_year;			 
  int tm_wday;			 
  int tm_yday;			 
  int tm_isdst;			 

# 138 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3

};



 
struct itimerspec
  {
    struct timespec it_interval;
    struct timespec it_value;
  };

 
struct sigevent;











 

extern clock_t clock (void)  ;

 
extern time_t time (time_t *__timer)  ;

 
extern double difftime (time_t __time1, time_t __time0)
       __attribute__ ((__const__));

 
extern time_t mktime (struct tm *__tp)  ;


 


extern size_t strftime (char *__restrict __s, size_t __maxsize,
			__const char *__restrict __format,
			__const struct tm *__restrict __tp)  ;










 

extern struct tm *gmtime (__const time_t *__timer)  ;

 

extern struct tm *localtime (__const time_t *__timer)  ;


 

extern struct tm *gmtime_r (__const time_t *__restrict __timer,
			    struct tm *__restrict __tp)  ;

 

extern struct tm *localtime_r (__const time_t *__restrict __timer,
			       struct tm *__restrict __tp)  ;


 

extern char *asctime (__const struct tm *__tp)  ;

 
extern char *ctime (__const time_t *__timer)  ;


 

 

extern char *asctime_r (__const struct tm *__restrict __tp,
			char *__restrict __buf)  ;

 
extern char *ctime_r (__const time_t *__restrict __timer,
		      char *__restrict __buf)  ;



 
extern char *__tzname[2];	 
extern int __daylight;		 
extern long int __timezone;	 



 
extern char *tzname[2];

 

extern void tzset (void)  ;



extern int daylight;
extern long int timezone;



 

extern int stime (__const time_t *__when)  ;



 






 


 
extern time_t timegm (struct tm *__tp)  ;

 
extern time_t timelocal (struct tm *__tp)  ;

 
extern int dysize (int __year)    __attribute__ ((__const__));




 
extern int nanosleep (__const struct timespec *__requested_time,
		      struct timespec *__remaining)  ;


 
extern int clock_getres (clockid_t __clock_id, struct timespec *__res)  ;

 
extern int clock_gettime (clockid_t __clock_id, struct timespec *__tp)  ;

 
extern int clock_settime (clockid_t __clock_id, __const struct timespec *__tp)
      ;

# 307 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



 
extern int timer_create (clockid_t __clock_id,
			 struct sigevent *__restrict __evp,
			 timer_t *__restrict __timerid)  ;

 
extern int timer_delete (timer_t __timerid)  ;

 
extern int timer_settime (timer_t __timerid, int __flags,
			  __const struct itimerspec *__restrict __value,
			  struct itimerspec *__restrict __ovalue)  ;

 
extern int timer_gettime (timer_t __timerid, struct itimerspec *__value)
      ;

 
extern int timer_getoverrun (timer_t __timerid)  ;



# 351 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3


# 361 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/time.h" 3



 




# 35 "getruntime.c" 2

# 44 "getruntime.c"



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

 


# 47 "getruntime.c" 2





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


 









 







 





 






 




 




# 52 "getruntime.c" 2


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/times.h" 1 3
 

















 












 

 
struct tms
  {
    clock_t tms_utime;		 
    clock_t tms_stime;		 

    clock_t tms_cutime;		 
    clock_t tms_cstime;		 
  };


 



extern clock_t times (struct tms *__buffer)  ;

 


# 54 "getruntime.c" 2




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


 


# 58 "getruntime.c" 2



 








# 78 "getruntime.c"


 











long
get_run_time ()
{

  struct rusage rusage;

  getrusage (0, &rusage);
  return (rusage.ru_utime.tv_sec * 1000000 + rusage.ru_utime.tv_usec
	  + rusage.ru_stime.tv_sec * 1000000 + rusage.ru_stime.tv_usec);
# 115 "getruntime.c"

}
