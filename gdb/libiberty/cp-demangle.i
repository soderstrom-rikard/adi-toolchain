# 1 "cp-demangle.c"
 





























 







# 1 "config.h" 1
 
 

 
 

 
 

 


 
 

 
 

 
 

 
 

 
 

 
 

 


 
 

 


 
 

 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 
 

 


 


 
 

 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 
 

 


 


 


 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 


 
 

 


 


 


 


 
 

 
 

 
 

 


 


 


 


 
 

 

 

 


 
 

 


 


 


 


 


 

 






 
 

 


# 39 "cp-demangle.c" 2



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








 


# 42 "cp-demangle.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 1 3
 

















 







 







# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 

# 271 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


# 283 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 

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


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 

# 271 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


# 283 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 

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





 


# 45 "cp-demangle.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdio.h" 1 3
 


















 









 



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 

# 271 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


# 283 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 

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










 






 




# 48 "cp-demangle.c" 2



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


 


# 51 "cp-demangle.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/ctype.h" 1 3
 
















 






# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/uClibc_ctype.h" 1 3
 
















 

















 









enum {
	__CTYPE_unclassified = 0,
	__CTYPE_alpha_nonupper_nonlower,
	__CTYPE_alpha_lower,
	__CTYPE_alpha_upper_lower,
	__CTYPE_alpha_upper,
	__CTYPE_digit,
	__CTYPE_punct,
	__CTYPE_graph,
	__CTYPE_print_space_nonblank,
	__CTYPE_print_space_blank,
	__CTYPE_space_nonblank_noncntrl,
	__CTYPE_space_blank_noncntrl,
	__CTYPE_cntrl_space_nonblank,
	__CTYPE_cntrl_space_blank,
	__CTYPE_cntrl_nonspace,
};

 













 


 
enum {
	_CTYPE_unclassified = 0,
	_CTYPE_isalnum,
	_CTYPE_isalpha,
	_CTYPE_isblank,
	_CTYPE_iscntrl,
	_CTYPE_isdigit,
	_CTYPE_isgraph,
	_CTYPE_islower,
	_CTYPE_isprint,
	_CTYPE_ispunct,
	_CTYPE_isspace,
	_CTYPE_isupper,
	_CTYPE_isxdigit				 
};


 






 


# 122 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/uClibc_ctype.h" 3














 

enum {
	_CTYPE_tolower = 1,
	_CTYPE_toupper,
	_CTYPE_totitle
};



 

 



























































 
 
 
 

 

 




















 














# 25 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/ctype.h" 2 3


 

extern int isalnum(int c)  ;
extern int isalpha(int c)  ;



extern int iscntrl(int c)  ;
extern int isdigit(int c)  ;
extern int isgraph(int c)  ;
extern int islower(int c)  ;
extern int isprint(int c)  ;
extern int ispunct(int c)  ;
extern int isspace(int c)  ;
extern int isupper(int c)  ;
extern int isxdigit(int c)  ;

extern int tolower(int c)  ;
extern int toupper(int c)  ;


extern int isascii(int c)  ;
extern int toascii(int c)  ;


 




extern int isxlower(int c)  ;	 
extern int isxupper(int c)  ;	 


 
 








 







 



 


# 125 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/ctype.h" 3


 


# 54 "cp-demangle.c" 2


# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 56 "cp-demangle.c" 2

# 1 "../include/libiberty.h" 1
 











































 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 







 

 




 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 





















typedef long int ptrdiff_t;









 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 





























 


























typedef int wchar_t;
























typedef unsigned int  wint_t;




 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 46 "../include/libiberty.h" 2

 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stdarg.h" 1 3
 
































































 










 



 

















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








# 57 "cp-demangle.c" 2

# 1 "../include/dyn-string.h" 1
 





















typedef struct dyn_string
{
  int allocated;	 
  int length;		 
  char *s;		 
}* dyn_string_t;

 



 



 




 




# 69 "../include/dyn-string.h"



extern int dyn_string_init               (struct dyn_string *, int)  ;
extern dyn_string_t dyn_string_new       (int)  ;
extern void dyn_string_delete            (dyn_string_t)  ;
extern char *dyn_string_release          (dyn_string_t)  ;
extern dyn_string_t dyn_string_resize    (dyn_string_t, int)  ;
extern void dyn_string_clear             (dyn_string_t)  ;
extern int dyn_string_copy               (dyn_string_t, dyn_string_t)  ;
extern int dyn_string_copy_cstr          (dyn_string_t, const char *)  ;
extern int dyn_string_prepend            (dyn_string_t, dyn_string_t)  ;
extern int dyn_string_prepend_cstr       (dyn_string_t, const char *)  ;
extern int dyn_string_insert             (dyn_string_t, int,
						 dyn_string_t)  ;
extern int dyn_string_insert_cstr        (dyn_string_t, int,
						 const char *)  ;
extern int dyn_string_insert_char        (dyn_string_t, int, int)  ;
extern int dyn_string_append             (dyn_string_t, dyn_string_t)  ;
extern int dyn_string_append_cstr        (dyn_string_t, const char *)  ;
extern int dyn_string_append_char        (dyn_string_t, int)  ;
extern int dyn_string_substring          (dyn_string_t, 
						 dyn_string_t, int, int)  ;
extern int dyn_string_eq                 (dyn_string_t, dyn_string_t)  ;
# 58 "cp-demangle.c" 2

# 1 "../include/demangle.h" 1
 
























 



















 


 







extern enum demangling_styles
{
  no_demangling = -1,
  unknown_demangling = 0,
  auto_demangling = (1 << 8) ,
  gnu_demangling = (1 << 9) ,
  lucid_demangling = (1 << 10) ,
  arm_demangling = (1 << 11) ,
  hp_demangling = (1 << 12) ,
  edg_demangling = (1 << 13) ,
  gnu_v3_demangling = (1 << 14) ,
  java_demangling = (1 << 2) ,
  gnat_demangling = (1 << 15) 
} current_demangling_style;

 












 












 


extern const struct demangler_engine
{
  const char *const demangling_style_name;
  const enum demangling_styles demangling_style;
  const char *const demangling_style_doc;
} libiberty_demanglers[];

extern char *
cplus_demangle  (const char *mangled, int options)  ;

extern int
cplus_demangle_opname  (const char *opname, char *result, int options)  ;

extern const char *
cplus_mangle_opname  (const char *opname, int options)  ;

 

extern void
set_cplus_marker_for_demangling  (int ch)  ;

extern enum demangling_styles 
cplus_demangle_set_style  (enum demangling_styles style)  ;

extern enum demangling_styles 
cplus_demangle_name_to_style  (const char *name)  ;

 
extern char*
cplus_demangle_v3  (const char* mangled, int options)  ;

extern char*
java_demangle_v3  (const char* mangled)  ;


enum gnu_v3_ctor_kinds {
  gnu_v3_complete_object_ctor = 1,
  gnu_v3_base_object_ctor,
  gnu_v3_complete_object_allocating_ctor
};

 



extern enum gnu_v3_ctor_kinds
	is_gnu_v3_mangled_ctor  (const char *name)  ;


enum gnu_v3_dtor_kinds {
  gnu_v3_deleting_dtor = 1,
  gnu_v3_complete_object_dtor,
  gnu_v3_base_object_dtor
};

 



extern enum gnu_v3_dtor_kinds
	is_gnu_v3_mangled_dtor  (const char *name)  ;


# 59 "cp-demangle.c" 2


 









 






 



 


 




static int flag_verbose;

 

static int flag_strict;

 



struct string_list_def
{
   
  struct dyn_string string;

   



  int caret_position;

   
  struct string_list_def *next;
};

typedef struct string_list_def *string_list_t;

 

struct substitution_def
{
   
  dyn_string_t text;

   
  int template_p : 1;
};

 

struct template_arg_list_def
{
   

  struct template_arg_list_def *next;

   

  string_list_t first_argument;

   
  string_list_t last_argument;
};

typedef struct template_arg_list_def *template_arg_list_t;

 

struct demangling_def
{
   
  const char *name;

   
  const char *next;

   

  string_list_t result;

   
  int num_substitutions;

   
  int substitutions_allocated;

   









  struct substitution_def *substitutions;

   
  template_arg_list_t template_arg_lists;

   
  dyn_string_t last_source_name;
  
   
  int style;

   

  enum gnu_v3_ctor_kinds is_constructor;

   

  enum gnu_v3_dtor_kinds is_destructor;

};

typedef struct demangling_def *demangling_t;

 

typedef const char *status_t;

 





 
static const char *const status_allocation_failed = "Allocation failed.";


 


 











static status_t int_to_dyn_string 
   (int, dyn_string_t)  ;
static string_list_t string_list_new
   (int)  ;
static void string_list_delete
   (string_list_t)  ;
static status_t result_add_separated_char
   (demangling_t, int)  ;
static status_t result_push
   (demangling_t)  ;
static string_list_t result_pop
   (demangling_t)  ;
static int substitution_start
   (demangling_t)  ;
static status_t substitution_add
   (demangling_t, int, int)  ;
static dyn_string_t substitution_get
   (demangling_t, int, int *)  ;




static template_arg_list_t template_arg_list_new
   (void)  ;
static void template_arg_list_delete
   (template_arg_list_t)  ;
static void template_arg_list_add_arg 
   (template_arg_list_t, string_list_t)  ;
static string_list_t template_arg_list_get_arg
   (template_arg_list_t, int)  ;
static void push_template_arg_list
   (demangling_t, template_arg_list_t)  ;
static void pop_to_template_arg_list
   (demangling_t, template_arg_list_t)  ;




static template_arg_list_t current_template_arg_list
   (demangling_t)  ;
static demangling_t demangling_new
   (const char *, int)  ;
static void demangling_delete 
   (demangling_t)  ;

 



 







 


 


 




 



 



 


 


 





 





 





 





 




 





 




 



 






 


static status_t
int_to_dyn_string (value, ds)
     int value;
     dyn_string_t ds;
{
  int i;
  int mask = 1;

   
  if (value == 0)
    {
      if (!dyn_string_append_char (ds, '0'))
	return status_allocation_failed ;
      return ((void *)0)  ;
    }

   
  if (value < 0)
    {
      if (!dyn_string_append_char (ds, '-'))
	return status_allocation_failed ;
      value = -value;
    }
  
   
  i = value;
  while (i > 9)
    {
      mask *= 10;
      i /= 10;
    }

   
  while (mask > 0)
    {
      int digit = value / mask;

      if (!dyn_string_append_char (ds, '0' + digit))
	return status_allocation_failed ;

      value -= digit * mask;
      mask /= 10;
    }

  return ((void *)0)  ;
}

 




static string_list_t 
string_list_new (length)
     int length;
{
  string_list_t s = (string_list_t) malloc (sizeof (struct string_list_def));
  s->caret_position = 0;
  if (s == ((void *)0) )
    return ((void *)0) ;
  if (!dyn_string_init ((dyn_string_t) s, length))
    return ((void *)0) ;
  return s;
}  

 

static void
string_list_delete (node)
     string_list_t node;
{
  while (node != ((void *)0) )
    {
      string_list_t next = node->next;
      dyn_string_delete ((dyn_string_t) node);
      node = next;
    }
}

 


static status_t
result_add_separated_char (dm, character)
     demangling_t dm;
     int character;
{
  char *result = (( (&( dm )->result->string)  )->s) ;
  int caret_pos = ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position) ;

   

  if (caret_pos > 0 && result[caret_pos - 1] == character)
    do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ' ' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
   
  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  character )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  return ((void *)0)  ;
}

 




static status_t
result_push (dm)
     demangling_t dm;
{
  string_list_t new_string = string_list_new (0);
  if (new_string == ((void *)0) )
     
    return status_allocation_failed ;

   
  new_string->next = (string_list_t) dm->result;
  dm->result = new_string;
  return ((void *)0)  ;
}

 



static string_list_t
result_pop (dm)
     demangling_t dm;
{
  string_list_t top = dm->result;
  dm->result = top->next;
  return top;
}

 


static int
result_get_caret (dm)
     demangling_t dm;
{
  return ((string_list_t) (&( dm )->result->string) )->caret_position;
}

 


static void
result_set_caret (dm, position)
     demangling_t dm;
     int position;
{
  ((string_list_t) (&( dm )->result->string) )->caret_position = position;
}

 


static void
result_shift_caret (dm, position_offset)
     demangling_t dm;
     int position_offset;
{
  ((string_list_t) (&( dm )->result->string) )->caret_position += position_offset;
}

 



static int
result_previous_char_is_space (dm)
     demangling_t dm;
{
  char *result = (( (&( dm )->result->string)  )->s) ;
  int pos = ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position) ;
  return pos > 0 && result[pos - 1] == ' ';
}

 



static int
substitution_start (dm)
     demangling_t dm;
{
  return ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position) ;
}

 



static status_t
substitution_add (dm, start_position, template_p)
     demangling_t dm;
     int start_position;
     int template_p;
{
  dyn_string_t result = (&( dm )->result->string) ;
  dyn_string_t substitution = dyn_string_new (0);
  int i;

  if (substitution == ((void *)0) )
    return status_allocation_failed ;

   

  if (!dyn_string_substring (substitution, 
			     result, start_position, ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position) ))
    {
      dyn_string_delete (substitution);
      return status_allocation_failed ;
    }

   
  if (dm->substitutions_allocated == dm->num_substitutions)
    {
      size_t new_array_size;
      if (dm->substitutions_allocated > 0)
	dm->substitutions_allocated *= 2;
      else
	dm->substitutions_allocated = 2;
      new_array_size = 
	sizeof (struct substitution_def) * dm->substitutions_allocated;

      dm->substitutions = (struct substitution_def *)
	realloc (dm->substitutions, new_array_size);
      if (dm->substitutions == ((void *)0) )
	 
	{
	  dyn_string_delete (substitution);
	  return status_allocation_failed ;
	}
    }

   
  i = dm->num_substitutions++;
  dm->substitutions[i].text = substitution;
  dm->substitutions[i].template_p = template_p;





  return ((void *)0)  ;
}

 





static dyn_string_t
substitution_get (dm, n, template_p)
     demangling_t dm;
     int n;
     int *template_p;
{
  struct substitution_def *sub;

   
  if (n < 0 || n >= dm->num_substitutions)
    return ((void *)0) ;

  sub = &(dm->substitutions[n]);
  *template_p = sub->template_p;
  return sub->text;
}

# 660 "cp-demangle.c"


 


static template_arg_list_t
template_arg_list_new ()
{
  template_arg_list_t new_list =
    (template_arg_list_t) malloc (sizeof (struct template_arg_list_def));
  if (new_list == ((void *)0) )
    return ((void *)0) ;
   
  new_list->first_argument = ((void *)0) ;
  new_list->last_argument = ((void *)0) ;
   
  return new_list;
}

 


static void
template_arg_list_delete (list)
     template_arg_list_t list;
{
   
  if (list->first_argument != ((void *)0) )
    string_list_delete (list->first_argument);
   
  free (list);
}

 

static void 
template_arg_list_add_arg (arg_list, arg)
     template_arg_list_t arg_list;
     string_list_t arg;
{
  if (arg_list->first_argument == ((void *)0) )
     
    arg_list->first_argument = arg;
  else
     
    arg_list->last_argument->next = arg;
   
  arg_list->last_argument = arg;
  arg->next = ((void *)0) ;
}

 


static string_list_t
template_arg_list_get_arg (arg_list, index)
     template_arg_list_t arg_list;
     int index;
{
  string_list_t arg = arg_list->first_argument;
   

  while (index--)
    {
      arg = arg->next;
      if (arg == ((void *)0) )
	 

	return ((void *)0) ;
    }
   
  return arg;
}

 

static void
push_template_arg_list (dm, arg_list)
     demangling_t dm;
     template_arg_list_t arg_list;
{
  arg_list->next = dm->template_arg_lists;
  dm->template_arg_lists = arg_list;




}

 



static void
pop_to_template_arg_list (dm, arg_list)
     demangling_t dm;
     template_arg_list_t arg_list;
{
  while (dm->template_arg_lists != arg_list)
    {
      template_arg_list_t top = dm->template_arg_lists;
       
      dm->template_arg_lists = top->next;
       
      template_arg_list_delete (top);



    }
}

# 795 "cp-demangle.c"


 


static template_arg_list_t
current_template_arg_list (dm)
     demangling_t dm;
{
  return dm->template_arg_lists;
}

 



static demangling_t
demangling_new (name, style)
     const char *name;
     int style;
{
  demangling_t dm;
  dm = (demangling_t) malloc (sizeof (struct demangling_def));
  if (dm == ((void *)0) )
    return ((void *)0) ;

  dm->name = name;
  dm->next = name;
  dm->result = ((void *)0) ;
  dm->num_substitutions = 0;
  dm->substitutions_allocated = 10;
  dm->template_arg_lists = ((void *)0) ;
  dm->last_source_name = dyn_string_new (0);
  if (dm->last_source_name == ((void *)0) )
    return ((void *)0) ;
  dm->substitutions = (struct substitution_def *)
    malloc (dm->substitutions_allocated * sizeof (struct substitution_def));
  if (dm->substitutions == ((void *)0) )
    {
      dyn_string_delete (dm->last_source_name);
      return ((void *)0) ;
    }
  dm->style = style;
  dm->is_constructor = (enum gnu_v3_ctor_kinds) 0;
  dm->is_destructor = (enum gnu_v3_dtor_kinds) 0;

  return dm;
}

 


static void
demangling_delete (dm)
     demangling_t dm;
{
  int i;
  template_arg_list_t arg_list = dm->template_arg_lists;

   
  while (arg_list != ((void *)0) )
    {
      template_arg_list_t next = arg_list->next;
      template_arg_list_delete (arg_list);
      arg_list = next;
    }
   
  for (i = dm->num_substitutions; --i >= 0; )
    dyn_string_delete (dm->substitutions[i].text);
  free (dm->substitutions);
   
  string_list_delete (dm->result);
   
  dyn_string_delete (dm->last_source_name);
   
  free (dm);
}

 






static status_t demangle_char
   (demangling_t, int)  ;
static status_t demangle_mangled_name 
   (demangling_t)  ;
static status_t demangle_encoding
   (demangling_t)  ;
static status_t demangle_name
   (demangling_t, int *)  ;
static status_t demangle_nested_name
   (demangling_t, int *)  ;
static status_t demangle_prefix
   (demangling_t, int *)  ;
static status_t demangle_unqualified_name
   (demangling_t, int *)  ;
static status_t demangle_source_name
   (demangling_t)  ;
static status_t demangle_number
   (demangling_t, int *, int, int)  ;
static status_t demangle_number_literally
   (demangling_t, dyn_string_t, int, int)  ;
static status_t demangle_identifier
   (demangling_t, int, dyn_string_t)  ;
static status_t demangle_operator_name
   (demangling_t, int, int *, int *)  ;
static status_t demangle_nv_offset
   (demangling_t)  ;
static status_t demangle_v_offset
   (demangling_t)  ;
static status_t demangle_call_offset
   (demangling_t)  ;
static status_t demangle_special_name
   (demangling_t)  ;
static status_t demangle_ctor_dtor_name
   (demangling_t)  ;
static status_t demangle_type_ptr
   (demangling_t, int *, int)  ;
static status_t demangle_type
   (demangling_t)  ;
static status_t demangle_CV_qualifiers
   (demangling_t, dyn_string_t)  ;
static status_t demangle_builtin_type
   (demangling_t)  ;
static status_t demangle_function_type
   (demangling_t, int *)  ;
static status_t demangle_bare_function_type
   (demangling_t, int *)  ;
static status_t demangle_class_enum_type
   (demangling_t, int *)  ;
static status_t demangle_array_type
   (demangling_t, int *)  ;
static status_t demangle_template_param
   (demangling_t)  ;
static status_t demangle_template_args
   (demangling_t)  ;
static status_t demangle_literal
   (demangling_t)  ;
static status_t demangle_template_arg
   (demangling_t)  ;
static status_t demangle_expression
   (demangling_t)  ;
static status_t demangle_scope_expression
   (demangling_t)  ;
static status_t demangle_expr_primary
   (demangling_t)  ;
static status_t demangle_substitution
   (demangling_t, int *)  ;
static status_t demangle_local_name
   (demangling_t)  ;
static status_t demangle_discriminator 
   (demangling_t, int)  ;
static status_t cp_demangle
   (const char *, dyn_string_t, int)  ;
static status_t cp_demangle_type
   (const char*, dyn_string_t)  ;

 



 


static status_t
demangle_char (dm, c)
     demangling_t dm;
     int c;
{
  static char *error_message = ((void *)0) ;

  if ((*(( dm )->next))  == c)
    {
      (++( dm )->next) ;
      return ((void *)0)  ;
    }
  else
    {
      if (error_message == ((void *)0) )
	error_message = (char *) strdup ("Expected ?");
      error_message[9] = c;
      return error_message;
    }
}

 



static status_t
demangle_mangled_name (dm)
     demangling_t dm;
{
   ;
  do { status_t s =  demangle_char (dm, '_') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_char (dm, 'Z') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_encoding (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  return ((void *)0)  ;
}

 





static status_t
demangle_encoding (dm)
     demangling_t dm;
{
  int encode_return_type;
  int start_position;
  template_arg_list_t old_arg_list = current_template_arg_list (dm);
  char peek = (*(( dm )->next)) ;

   ;
  
   

  start_position = ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position) ;

  if (peek == 'G' || peek == 'T')
    do { status_t s =  demangle_special_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  else
    {
       
      do { status_t s =  demangle_name (dm, &encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

       

      if (! ((*((  dm  )->next))  == '\0')  
	  && (*(( dm )->next))  != 'E')
	{
	  if (encode_return_type)
	     

	    
do { status_t s =  demangle_bare_function_type (dm, &start_position) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  else
	     

	    
do { status_t s =  demangle_bare_function_type (dm, ((void *)0)  ) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ; 
	}
    }

   

  pop_to_template_arg_list (dm, old_arg_list);

  return ((void *)0)  ;
}

 













static status_t
demangle_name (dm, encode_return_type)
     demangling_t dm;
     int *encode_return_type;
{
  int start = substitution_start (dm);
  char peek = (*(( dm )->next)) ;
  int is_std_substitution = 0;

   



  int suppress_return_type = 0;

   ;

  switch (peek)
    {
    case 'N':
       
      do { status_t s =  demangle_nested_name (dm, encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      break;

    case 'Z':
      do { status_t s =  demangle_local_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      *encode_return_type = 0;
      break;

    case 'S':
       

      if (((*((  dm  )->next))  == '\0' ? '\0' : (*(( dm )->next + 1)))  == 't') 
	{
	  (void) (*(( dm )->next)++) ;
	  (void) (*(( dm )->next)++) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  
do { status_t s =  demangle_unqualified_name (dm, &suppress_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  is_std_substitution = 1;
	}
      else
	do { status_t s =  demangle_substitution (dm, encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       

      if ((*(( dm )->next))  == 'I') 
	{
	   

	  if (is_std_substitution)
	    do { status_t s =  substitution_add (dm, start, 0) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	   
	  do { status_t s =  demangle_template_args (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  *encode_return_type = !suppress_return_type;
	}
      else
	*encode_return_type = 0;

      break;

    default:
       
      do { status_t s =  demangle_unqualified_name (dm, &suppress_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

       

      if ((*(( dm )->next))  == 'I')
	{
	   
	  do { status_t s =  substitution_add (dm, start, 0) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

	  do { status_t s =  demangle_template_args (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  *encode_return_type = !suppress_return_type;
	}
      else
	*encode_return_type = 0;

      break;
    }

  return ((void *)0)  ;
}

 



static status_t
demangle_nested_name (dm, encode_return_type)
     demangling_t dm;
     int *encode_return_type;
{
  char peek;

   ;

  do { status_t s =  demangle_char (dm, 'N') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  peek = (*(( dm )->next)) ;
  if (peek == 'r' || peek == 'V' || peek == 'K')
    {
      dyn_string_t cv_qualifiers;
      status_t status;

       
      cv_qualifiers = dyn_string_new (24);
      if (cv_qualifiers == ((void *)0) )
	return status_allocation_failed ;
      demangle_CV_qualifiers (dm, cv_qualifiers);

       
      status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ' ' )) ? ((void *)0)   : status_allocation_failed ) ;
      if ((( status ) == ((void *)0)  ) ) 
	status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  cv_qualifiers )) ? ((void *)0)   : status_allocation_failed ) ;
       




      result_shift_caret (dm, - (( cv_qualifiers )->length)  - 1);
       
      dyn_string_delete (cv_qualifiers);
      do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }

  do { status_t s =  demangle_prefix (dm, encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
   

  do { status_t s =  demangle_char (dm, 'E') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  return ((void *)0)  ;
}

 









static status_t
demangle_prefix (dm, encode_return_type)
     demangling_t dm;
     int *encode_return_type;
{
  int start = substitution_start (dm);
  int nested = 0;

   



   



  int suppress_return_type = 0;

   ;

  while (1)
    {
      char peek;

      if (((*((  dm  )->next))  == '\0') )
	return "Unexpected end of name in <compound-name>.";

      peek = (*(( dm )->next)) ;
      
       





      if (peek != 'I')
	suppress_return_type = 0;

      if ((( (unsigned char) peek ) >= '0' && ( (unsigned char) peek ) <= '9') 
	  || (peek >= 'a' && peek <= 'z')
	  || peek == 'C' || peek == 'D'
	  || peek == 'S')
	{
	   
	  if (nested)
	    do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  (dm->style == (1 << 2)  ? "." : "::")  )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  else
	    nested = 1;

	  if (peek == 'S')
	     

	    do { status_t s =  demangle_substitution (dm, encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  else
	    {
	       
	      
do { status_t s =  demangle_unqualified_name (dm, &suppress_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      *encode_return_type = 0;
	    }
	}
      else if (peek == 'Z')
	do { status_t s =  demangle_local_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      else if (peek == 'I')
	{
	  do { status_t s =  demangle_template_args (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

	   






	  *encode_return_type = !suppress_return_type;
	}
      else if (peek == 'E')
	 
	return ((void *)0)  ;
      else
	return "Unexpected character in <compound-name>.";

      if (peek != 'S'
	  && (*(( dm )->next))  != 'E')
	 
	do { status_t s =  substitution_add (dm, start, *encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }
}

 









static status_t
demangle_unqualified_name (dm, suppress_return_type)
     demangling_t dm;
     int *suppress_return_type;
{
  char peek = (*(( dm )->next)) ;

   ;

   
 
  *suppress_return_type = 0;

  if ((( (unsigned char) peek ) >= '0' && ( (unsigned char) peek ) <= '9') )
    do { status_t s =  demangle_source_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  else if (peek >= 'a' && peek <= 'z')
    {
      int num_args;

       
      if (peek == 'c' && ((*((  dm  )->next))  == '\0' ? '\0' : (*(( dm )->next + 1)))  == 'v')
	*suppress_return_type = 1;

      do { status_t s =  demangle_operator_name (dm, 0, &num_args, ((void *)0) ) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }
  else if (peek == 'C' || peek == 'D')
    {
       
      if (peek == 'C')
	*suppress_return_type = 1;

      do { status_t s =  demangle_ctor_dtor_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }
  else
    return "Unexpected character in <unqualified-name>.";

  return ((void *)0)  ;
}

 



static status_t
demangle_source_name (dm)
     demangling_t dm;
{
  int length;

   ;

   
  do { status_t s =  demangle_number (dm, &length, 10, 0) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  if (length == 0)
    return "Zero length in <source-name>.";

   

  do { status_t s =  demangle_identifier (dm, length, 
					dm->last_source_name) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

   
  do { status_t s =  (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  dm->last_source_name )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  return ((void *)0)  ;
}

 









static status_t
demangle_number (dm, value, base, is_signed)
     demangling_t dm;
     int *value;
     int base;
     int is_signed;
{
  dyn_string_t number = dyn_string_new (10);

   ;

  if (number == ((void *)0) )
    return status_allocation_failed ;

  demangle_number_literally (dm, number, base, is_signed);
  *value = strtol ((( number )->s) , ((void *)0) , base);
  dyn_string_delete (number);

  return ((void *)0)  ;
}

 






static status_t
demangle_number_literally (dm, str, base, is_signed)
     demangling_t dm;
     dyn_string_t str;
     int base;
     int is_signed;
{
   ;

  if (base != 10 && base != 36)
    return "Internal error." ;

   
  if (is_signed && (*(( dm )->next))  == 'n')
    {
       
      (++( dm )->next) ;
       

      if (!dyn_string_append_char (str, '-'))
	return status_allocation_failed ;
    }

   
  while (1)
    {
      char peek = (*(( dm )->next)) ;
      if ((( (unsigned char) peek ) >= '0' && ( (unsigned char) peek ) <= '9') 
	  || (base == 36 && peek >= 'A' && peek <= 'Z'))
	{
	   
	  if (!dyn_string_append_char (str, (*(( dm )->next)++) ))
	    return status_allocation_failed ;
	}
      else
	 
	break;
    }

  return ((void *)0)  ;
}

 


static status_t
demangle_identifier (dm, length, identifier)
     demangling_t dm;
     int length;
     dyn_string_t identifier;
{
   ;

  dyn_string_clear (identifier);
  if (!dyn_string_resize (identifier, length))
    return status_allocation_failed ;

  while (length-- > 0)
    {
      int ch;
      if (((*((  dm  )->next))  == '\0') )
	return "Unexpected end of name in <identifier>.";
      ch = (*(( dm )->next)++) ;

       


      if (ch == '_'
	  && (*(( dm )->next))  == '_'
	  && ((*((  dm  )->next))  == '\0' ? '\0' : (*(( dm )->next + 1)))  == 'U')
	{
	  char buf[10];
	  int pos = 0;
	  (++( dm )->next) ; (++( dm )->next) ; length -= 2;
	  while (length-- > 0)
	    {
	      ch = (*(( dm )->next)++) ;
	      if (!isxdigit (ch))
		break;
	      buf[pos++] = ch;
	    }
	  if (ch != '_' || length < 0)
	    return "Error." ;
	  if (pos == 0)
	    {
	       
	      if (!dyn_string_append_cstr (identifier, "__U"))
		return status_allocation_failed ;
	      continue;
	    }
	  else
	    {
	      buf[pos] = '\0';
	      ch = strtol (buf, 0, 16);
	    }
	}

      if (!dyn_string_append_char (identifier, ch))
	return status_allocation_failed ;
    }

   


  if (!flag_strict)
    {
      char *name = (( identifier )->s) ;
      int prefix_length = strlen ("_GLOBAL_" );

       
      if (strncmp (name, "_GLOBAL_" , prefix_length) == 0)
        {
	  name += prefix_length;
	   


	  if ((*name == '.' || *name == '_' || *name == '$')
	      && *(name + 1) == 'N')
	     

	    dyn_string_copy_cstr (identifier, "(anonymous namespace)");
	}
    }

  return ((void *)0)  ;
}

 



























































static status_t
demangle_operator_name (dm, short_name, num_args, type_arg)
     demangling_t dm;
     int short_name;
     int *num_args;
     int *type_arg;
{
  struct operator_code
  {
     
    const char *const code;
     
    const char *const name;
     
    const int num_args;
  };

  static const struct operator_code operators[] = 
  {
    { "aN", "&="       , 2 },
    { "aS", "="        , 2 },
    { "aa", "&&"       , 2 },
    { "ad", "&"        , 1 },
    { "an", "&"        , 2 },
    { "cl", "()"       , 0 },
    { "cm", ","        , 2 },
    { "co", "~"        , 1 },
    { "dV", "/="       , 2 },
    { "da", " delete[]", 1 },
    { "de", "*"        , 1 },
    { "dl", " delete"  , 1 },
    { "dv", "/"        , 2 },
    { "eO", "^="       , 2 },
    { "eo", "^"        , 2 },
    { "eq", "=="       , 2 },
    { "ge", ">="       , 2 },
    { "gt", ">"        , 2 },
    { "ix", "[]"       , 2 },
    { "lS", "<<="      , 2 },
    { "le", "<="       , 2 },
    { "ls", "<<"       , 2 },
    { "lt", "<"        , 2 },
    { "mI", "-="       , 2 },
    { "mL", "*="       , 2 },
    { "mi", "-"        , 2 },
    { "ml", "*"        , 2 },
    { "mm", "--"       , 1 },
    { "na", " new[]"   , 1 },
    { "ne", "!="       , 2 },
    { "ng", "-"        , 1 },
    { "nt", "!"        , 1 },
    { "nw", " new"     , 1 },
    { "oR", "|="       , 2 },
    { "oo", "||"       , 2 },
    { "or", "|"        , 2 },
    { "pL", "+="       , 2 },
    { "pl", "+"        , 2 },
    { "pm", "->*"      , 2 },
    { "pp", "++"       , 1 },
    { "ps", "+"        , 1 },
    { "pt", "->"       , 2 },
    { "qu", "?"        , 3 },
    { "rM", "%="       , 2 },
    { "rS", ">>="      , 2 },
    { "rm", "%"        , 2 },
    { "rs", ">>"       , 2 },
    { "sz", " sizeof"  , 1 }
  };

  const int num_operators = 
    sizeof (operators) / sizeof (struct operator_code);

  int c0 = (*(( dm )->next)++) ;
  int c1 = (*(( dm )->next)++) ;
  const struct operator_code* p1 = operators;
  const struct operator_code* p2 = operators + num_operators;

   ;

   
  if (type_arg)
    *type_arg = 0;

   
  if (c0 == 'v' && (( c1 ) >= '0' && ( c1 ) <= '9') )
    {
      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "operator " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  demangle_source_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      *num_args = 0;
      return ((void *)0)  ;
    }

   
  if (c0 == 'c' && c1 == 'v')
    {
      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "operator " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       
      do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      *num_args = 0;
      return ((void *)0)  ;
    }

   
  if (c0 == 's' && c1 == 't')
    {
      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " sizeof" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      *num_args = 1;
      if (type_arg)
	*type_arg = 1;
      return ((void *)0)  ;
    }

   
  while (1)
    {
      const struct operator_code* p = p1 + (p2 - p1) / 2;
      char match0 = p->code[0];
      char match1 = p->code[1];

      if (c0 == match0 && c1 == match1)
	 
	{
	  if (!short_name)
	    do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "operator" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  p->name )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  *num_args = p->num_args;

	  return ((void *)0)  ;
	}

      if (p == p1)
	 
	return "Unknown code in <operator-name>.";

       
      if (c0 < match0 || (c0 == match0 && c1 < match1))
	p2 = p;
      else
	p1 = p;
    }
}

 



static status_t
demangle_nv_offset (dm)
     demangling_t dm;
{
  dyn_string_t number;
  status_t status = ((void *)0)  ;

   ;

   
  number = dyn_string_new (4);
  if (number == ((void *)0) )
    return status_allocation_failed ;
  demangle_number_literally (dm, number, 10, 1);

   
  if (flag_verbose)
    {
      status = (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " [nv:" )) ? ((void *)0)   : status_allocation_failed ) ;
      if ((( status ) == ((void *)0)  ) )
	status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  number )) ? ((void *)0)   : status_allocation_failed ) ;
      if ((( status ) == ((void *)0)  ) )
	status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ']' )) ? ((void *)0)   : status_allocation_failed ) ;
    }

   
  dyn_string_delete (number);
  do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  return ((void *)0)  ;
}

 




static status_t
demangle_v_offset (dm)
     demangling_t dm;
{
  dyn_string_t number;
  status_t status = ((void *)0)  ;

   ;

   
  number = dyn_string_new (4);
  if (number == ((void *)0) )
    return status_allocation_failed ;
  demangle_number_literally (dm, number, 10, 1);

   
  if (flag_verbose)
    {
      status = (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " [v:" )) ? ((void *)0)   : status_allocation_failed ) ;
      if ((( status ) == ((void *)0)  ) )
	status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  number )) ? ((void *)0)   : status_allocation_failed ) ;
      if ((( status ) == ((void *)0)  ) )
	(dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ',' )) ? ((void *)0)   : status_allocation_failed ) ;
    }
  dyn_string_delete (number);
  do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

   
  do { status_t s =  demangle_char (dm, '_') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

   
  number = dyn_string_new (4);
  if (number == ((void *)0) )
    return status_allocation_failed ;
  demangle_number_literally (dm, number, 10, 1);

   
  if (flag_verbose)
    {
      status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  number )) ? ((void *)0)   : status_allocation_failed ) ;
      if ((( status ) == ((void *)0)  ) )
	status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ']' )) ? ((void *)0)   : status_allocation_failed ) ;
    }
  dyn_string_delete (number);
  do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  return ((void *)0)  ;
}

 




static status_t
demangle_call_offset (dm)
     demangling_t dm;
{
   ;

  switch ((*(( dm )->next)) )
    {
    case 'h':
      (++( dm )->next) ;
       
      do { status_t s =  demangle_nv_offset (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       
      do { status_t s =  demangle_char (dm, '_') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      break;

    case 'v':
      (++( dm )->next) ;
       
      do { status_t s =  demangle_v_offset (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       
      do { status_t s =  demangle_char (dm, '_') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      break;

    default:
      return "Unrecognized <call-offset>.";
    }

  return ((void *)0)  ;
}

 





























static status_t
demangle_special_name (dm)
     demangling_t dm;
{
  dyn_string_t number;
  int unused;
  char peek = (*(( dm )->next)) ;

   ;

  if (peek == 'G')
    {
       
      (++( dm )->next) ;
      switch ((*(( dm )->next)) )
	{
	case 'V':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "guard variable for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_name (dm, &unused) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'R':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "reference temporary for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_name (dm, &unused) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;
	  
	default:
	  return "Unrecognized <special-name>.";
	}
    }
  else if (peek == 'T')
    {
      status_t status = ((void *)0)  ;

       
      (++( dm )->next) ;

      switch ((*(( dm )->next)) )
	{
	case 'V':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "vtable for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'T':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "VTT for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'I':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "typeinfo for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'F':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "typeinfo fn for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'S':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "typeinfo name for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'J':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "java Class for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'h':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "non-virtual thunk" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_nv_offset (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	   
	  do { status_t s =  demangle_char (dm, '_') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	   
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " to " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_encoding (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'v':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "virtual thunk" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_v_offset (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	   
	  do { status_t s =  demangle_char (dm, '_') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	   
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " to " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_encoding (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'c':
	   
	  (++( dm )->next) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "covariant return thunk" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_call_offset (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_call_offset (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	   
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " to " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_encoding (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'C':
	   
	  if (!flag_strict)
	    {
	      dyn_string_t derived_type;

	      (++( dm )->next) ;
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "construction vtable for " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

	       
	      do { status_t s =  result_push (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      derived_type = (dyn_string_t) result_pop (dm);

	       
	      number = dyn_string_new (4);
	      if (number == ((void *)0) )
		{
		  dyn_string_delete (derived_type);
		  return status_allocation_failed ;
		}
	      demangle_number_literally (dm, number, 10, 1);
	       
	      status = demangle_char (dm, '_');

	       
	      if ((( status ) == ((void *)0)  ) )
		status = demangle_type (dm);

	       
	      if ((( status ) == ((void *)0)  ) )
		status = (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "-in-" )) ? ((void *)0)   : status_allocation_failed ) ;
	      if ((( status ) == ((void *)0)  ) )
		status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  derived_type )) ? ((void *)0)   : status_allocation_failed ) ;
	      dyn_string_delete (derived_type);

	       
	      if (flag_verbose)
		{
		  status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ' ' )) ? ((void *)0)   : status_allocation_failed ) ;
		  if ((( status ) == ((void *)0)  ) )
		    (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  number )) ? ((void *)0)   : status_allocation_failed ) ;
		}
	      dyn_string_delete (number);
	      do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      break;
	    }
	   

	default:
	  return "Unrecognized <special-name>.";
	}
    }
  else
    return "Error." ;

  return ((void *)0)  ;
}

 









static status_t
demangle_ctor_dtor_name (dm)
     demangling_t dm;
{
  static const char *const ctor_flavors[] = 
  {
    "in-charge",
    "not-in-charge",
    "allocating"
  };
  static const char *const dtor_flavors[] = 
  {
    "in-charge deleting",
    "in-charge",
    "not-in-charge"
  };

  int flavor;
  char peek = (*(( dm )->next)) ;

   ;
  
  if (peek == 'C')
    {
       
      (++( dm )->next) ;
      flavor = (*(( dm )->next)++) ;
      if (flavor < '1' || flavor > '3')
	return "Unrecognized constructor.";
      do { status_t s =  (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  dm->last_source_name )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      switch (flavor)
	{
	case '1': dm->is_constructor = gnu_v3_complete_object_ctor;
	  break;
	case '2': dm->is_constructor = gnu_v3_base_object_ctor;
	  break;
	case '3': dm->is_constructor = gnu_v3_complete_object_allocating_ctor;
	  break;
	}
       
      if (flag_verbose)
	{
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "[" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ctor_flavors[flavor - '1'] )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ']' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	}
    }
  else if (peek == 'D')
    {
       
      (++( dm )->next) ;
      flavor = (*(( dm )->next)++) ;
      if (flavor < '0' || flavor > '2')
	return "Unrecognized destructor.";
      do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  '~' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  dm->last_source_name )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      switch (flavor)
	{
	case '0': dm->is_destructor = gnu_v3_deleting_dtor;
	  break;
	case '1': dm->is_destructor = gnu_v3_complete_object_dtor;
	  break;
	case '2': dm->is_destructor = gnu_v3_base_object_dtor;
	  break;
	}
       
      if (flag_verbose)
	{
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " [" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  dtor_flavors[flavor - '0'] )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ']' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	}
    }
  else
    return "Error." ;

  return ((void *)0)  ;
}

 

























static status_t
demangle_type_ptr (dm, insert_pos, substitution_start)
     demangling_t dm;
     int *insert_pos;
     int substitution_start;
{
  status_t status;
  int is_substitution_candidate = 1;

   ;

   

  switch ((*(( dm )->next)) )
    {
    case 'P':
       
      (++( dm )->next) ;
       
      do { status_t s =  demangle_type_ptr (dm, insert_pos, 
					  substitution_start) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       


      if (dm->style != (1 << 2) )
	do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, (  *insert_pos ), (  '*' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       

      ++(*insert_pos);
      break;

    case 'R':
       
      (++( dm )->next) ;
       
      do { status_t s =  demangle_type_ptr (dm, insert_pos, 
					  substitution_start) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       

      do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, (  *insert_pos ), (  '&' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       

      ++(*insert_pos);
      break;

    case 'M':
    {
       
      dyn_string_t class_type;
      
       
      (++( dm )->next) ;
      
       
      do { status_t s =  result_push (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      class_type = (dyn_string_t) result_pop (dm);
      
      if ((*(( dm )->next))  == 'F')
	 




	status = demangle_type_ptr (dm, insert_pos, substitution_start);
      else if ((*(( dm )->next))  == 'A')
	 



	status = demangle_array_type (dm, insert_pos);
      else
        {
	   

	  status = demangle_type (dm);
	   
	  if ((( status ) == ((void *)0)  ) 
	      && !result_previous_char_is_space (dm))
	    status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ' ' )) ? ((void *)0)   : status_allocation_failed ) ;
	   

	  *insert_pos = ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position) ;
	}

       
      if ((( status ) == ((void *)0)  ) )
	status = (dyn_string_insert_cstr (&( dm )->result->string, (  *insert_pos ), (  "::*" )) ? ((void *)0)   : status_allocation_failed ) ;
      if ((( status ) == ((void *)0)  ) )
	status = (dyn_string_insert (&( dm )->result->string, (  *insert_pos ), (  class_type )) ? ((void *)0)   : status_allocation_failed ) ;
       



      *insert_pos += (( class_type )->length)  + 3;

       
      dyn_string_delete (class_type);

      do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }
    break;

    case 'F':
       


      *insert_pos = ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position) ;
       

      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "()" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       


      do { status_t s =  demangle_function_type (dm, insert_pos) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       





      ++(*insert_pos);
      break;

    case 'A':
       

      do { status_t s =  demangle_array_type (dm, insert_pos) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      break;

    default:
       


      do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       

      *insert_pos = ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position) ;
       


      is_substitution_candidate = 0;
      break;
    }
  
  if (is_substitution_candidate)
    do { status_t s =  substitution_add (dm, substitution_start, 0) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  
  return ((void *)0)  ;
}

 
















static status_t
demangle_type (dm)
     demangling_t dm;
{
  int start = substitution_start (dm);
  char peek = (*(( dm )->next)) ;
  char peek_next;
  int encode_return_type = 0;
  template_arg_list_t old_arg_list = current_template_arg_list (dm);
  int insert_pos;

   


  int is_substitution_candidate = 1;

   ;

   

  if ((( (unsigned char) peek ) >= '0' && ( (unsigned char) peek ) <= '9')  || peek == 'N' || peek == 'Z')
    do { status_t s =  demangle_class_enum_type (dm, &encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
   

  else if (peek >= 'a' && peek <= 'z' && peek != 'r')
    {
      do { status_t s =  demangle_builtin_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       
      is_substitution_candidate = 0;
    }
  else
    switch (peek)
      {
      case 'r':
      case 'V':
      case 'K':
	 


	{
	  status_t status;
	  dyn_string_t cv_qualifiers = dyn_string_new (24);
	  int old_caret_position = result_get_caret (dm);

	  if (cv_qualifiers == ((void *)0) )
	    return status_allocation_failed ;

	   
	  demangle_CV_qualifiers (dm, cv_qualifiers);
	   

	  status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  cv_qualifiers )) ? ((void *)0)   : status_allocation_failed ) ;
	  result_shift_caret (dm, - (( cv_qualifiers )->length) );
	   
	  dyn_string_delete (cv_qualifiers);
	  do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	   
	  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ' ' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  result_shift_caret (dm, -1);

	   

	  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

	   
	  result_set_caret (dm, old_caret_position);
	}
	break;

      case 'F':
	return "Non-pointer or -reference function type.";

      case 'A':
	do { status_t s =  demangle_array_type (dm, ((void *)0) ) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	break;

      case 'T':
	 


	do { status_t s =  demangle_template_param (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

	 


	if ((*(( dm )->next))  == 'I')
	  {
	     


	    do { status_t s =  substitution_add (dm, start, encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

	     
	    do { status_t s =  demangle_template_args (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	     


	  }

	break;

      case 'S':
	 



	peek_next = ((*((  dm  )->next))  == '\0' ? '\0' : (*(( dm )->next + 1))) ;
	if ((( peek_next ) >= '0' && ( peek_next ) <= '9')  || peek_next == '_')
	  {
	    do { status_t s =  demangle_substitution (dm, &encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	    
	     


	    if ((*(( dm )->next))  == 'I')
	      do { status_t s =  demangle_template_args (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	    else
	       


	      is_substitution_candidate = 0;
	  }
	else
	  {
	     













 	    const char *next = dm->next;
	     
	    
do { status_t s =  demangle_class_enum_type (dm, &encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	     


	    if (dm->next == next + 2)
	      is_substitution_candidate = 0;
	  }

	break;

      case 'P':
      case 'R':
      case 'M':
	do { status_t s =  demangle_type_ptr (dm, &insert_pos, start) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	 

	is_substitution_candidate = 0;
	break;

      case 'C':
	 
	do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "complex " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	(++( dm )->next) ;
	do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	break;

      case 'G':
	 
	do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "imaginary " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	(++( dm )->next) ;
	do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	break;

      case 'U':
	 
	(++( dm )->next) ;
	do { status_t s =  demangle_source_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ' ' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	break;

      default:
	return "Unexpected character in <type>.";
      }

  if (is_substitution_candidate)
     



    do { status_t s =  substitution_add (dm, start, encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

   

  pop_to_template_arg_list (dm, old_arg_list);

  return ((void *)0)  ;
}

 

static const char *const builtin_type_names[26] = 
{
  "signed char",               
  "bool",                      
  "char",                      
  "double",                    
  "long double",               
  "float",                     
  "__float128",                
  "unsigned char",             
  "int",                       
  "unsigned",                  
  ((void *)0) ,                        
  "long",                      
  "unsigned long",             
  "__int128",                  
  "unsigned __int128",         
  ((void *)0) ,                        
  ((void *)0) ,                        
  ((void *)0) ,                        
  "short",                     
  "unsigned short",            
  ((void *)0) ,                        
  "void",                      
  "wchar_t",                   
  "long long",                 
  "unsigned long long",        
  "..."                        
};

 


static const char *const java_builtin_type_names[26] = 
{
  "signed char",                 
  "boolean",      
  "byte",         
  "double",                      
  "long double",                 
  "float",                       
  "__float128",                  
  "unsigned char",               
  "int",                         
  "unsigned",                    
  ((void *)0) ,                          
  "long",                        
  "unsigned long",               
  "__int128",                    
  "unsigned __int128",           
  ((void *)0) ,                          
  ((void *)0) ,                          
  ((void *)0) ,                          
  "short",                       
  "unsigned short",              
  ((void *)0) ,                          
  "void",                        
  "char",      
  "long",    
  "unsigned long long",          
  "..."                          
};

 
























static status_t
demangle_builtin_type (dm)
     demangling_t dm;
{

  char code = (*(( dm )->next)) ;

   ;

  if (code == 'u')
    {
      (++( dm )->next) ;
      do { status_t s =  demangle_source_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      return ((void *)0)  ;
    }
  else if (code >= 'a' && code <= 'z')
    {
      const char *type_name;
       
      if (dm->style == (1 << 2) )
        type_name = java_builtin_type_names[code - 'a'];
      else
        type_name = builtin_type_names[code - 'a'];
      if (type_name == ((void *)0) )
	return "Unrecognized <builtin-type> code.";

      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  type_name )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      (++( dm )->next) ;
      return ((void *)0)  ;
    }
  else
    return "Non-alphabetic <builtin-type> code.";
}

 



static status_t
demangle_CV_qualifiers (dm, qualifiers)
     demangling_t dm;
     dyn_string_t qualifiers;
{
   ;

  while (1)
    {
      switch ((*(( dm )->next)) )
	{
	case 'r':
	  if (! ((((  qualifiers  )->length)  > 0 && (((   qualifiers   )->s) [((   qualifiers   )->length)  - 1])  != ' ') ? dyn_string_append_char (( qualifiers ), ' ') : 1) )
	    return status_allocation_failed ;
	  if (!dyn_string_append_cstr (qualifiers, "restrict"))
	    return status_allocation_failed ;
	  break;

	case 'V':
	  if (! ((((  qualifiers  )->length)  > 0 && (((   qualifiers   )->s) [((   qualifiers   )->length)  - 1])  != ' ') ? dyn_string_append_char (( qualifiers ), ' ') : 1) )
	    return status_allocation_failed ;
	  if (!dyn_string_append_cstr (qualifiers, "volatile"))
	    return status_allocation_failed ;
	  break;

	case 'K':
	  if (! ((((  qualifiers  )->length)  > 0 && (((   qualifiers   )->s) [((   qualifiers   )->length)  - 1])  != ' ') ? dyn_string_append_char (( qualifiers ), ' ') : 1) )
	    return status_allocation_failed ;
	  if (!dyn_string_append_cstr (qualifiers, "const"))
	    return status_allocation_failed ;
	  break;

	default:
	  return ((void *)0)  ;
	}

      (++( dm )->next) ;
    }
}

 







static status_t
demangle_function_type (dm, function_name_pos)
     demangling_t dm;
     int *function_name_pos;
{
   ;
  do { status_t s =  demangle_char (dm, 'F') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;  
  if ((*(( dm )->next))  == 'Y')
    {
       
      if (flag_verbose)
	do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " [extern \"C\"] " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      (++( dm )->next) ;
    }
  do { status_t s =  demangle_bare_function_type (dm, function_name_pos) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_char (dm, 'E') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  return ((void *)0)  ;
}

 






static status_t
demangle_bare_function_type (dm, return_type_pos)
     demangling_t dm;
     int *return_type_pos;
{
   

  int sequence = 
    (return_type_pos == ((void *)0)   ? 0 : -1);

   ;

  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  '(' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  while (! ((*((  dm  )->next))  == '\0')  && (*(( dm )->next))  != 'E')
    {
      if (sequence == -1)
	 
	{
	  dyn_string_t return_type;
	  status_t status = ((void *)0)  ;

	   
	  do { status_t s =  result_push (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  return_type = (dyn_string_t) result_pop (dm);

	   

	  if (! ((((  return_type  )->length)  > 0 && (((   return_type   )->s) [((   return_type   )->length)  - 1])  != ' ') ? dyn_string_append_char (( return_type ), ' ') : 1) )
	    status = status_allocation_failed ;
	  if ((( status ) == ((void *)0)  ) )
	    {
	      if (!dyn_string_insert ((&( dm )->result->string) , *return_type_pos, 
				      return_type))
		status = status_allocation_failed ;
	      else
		*return_type_pos += (( return_type )->length) ;
	    }

	  dyn_string_delete (return_type);
	  do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	}
      else 
	{
	   


	  if ((*(( dm )->next))  == 'v')
	     
	    (++( dm )->next) ;
	  else
	    {
	       
	      if (sequence > 0)
		do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ", " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	       
	      do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	    }
	}

      ++sequence;
    }
  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ')' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

   


  if (sequence == -1)
    return "Missing function return type.";
  else if (sequence == 0)
    return "Missing function parameter.";

  return ((void *)0)  ;
}

 




static status_t
demangle_class_enum_type (dm, encode_return_type)
     demangling_t dm;
     int *encode_return_type;
{
   ;

  do { status_t s =  demangle_name (dm, encode_return_type) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  return ((void *)0)  ;
}

 
















static status_t
demangle_array_type (dm, ptr_insert_pos)
     demangling_t dm;
     int *ptr_insert_pos;
{
  status_t status = ((void *)0)  ;
  dyn_string_t array_size = ((void *)0) ;
  char peek;

   ;

  do { status_t s =  demangle_char (dm, 'A') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

   
  peek = (*(( dm )->next)) ;
  if (peek == '_')
     
    ;
  else if ((( (*(( dm )->next))  ) >= '0' && ( (*(( dm )->next))  ) <= '9') ) 
    {
       
      array_size = dyn_string_new (10);
      if (array_size == ((void *)0) )
	return status_allocation_failed ;
      status = demangle_number_literally (dm, array_size, 10, 0);
    }
  else
    {
       


      do { status_t s =  result_push (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  demangle_expression (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      array_size = (dyn_string_t) result_pop (dm);
    }
   


   
  if ((( status ) == ((void *)0)  ) )
    status = demangle_char (dm, '_');
  if ((( status ) == ((void *)0)  ) )
    status = demangle_type (dm);

  if (ptr_insert_pos != ((void *)0) )
    {
       


      if ((( status ) == ((void *)0)  ) )
	status = (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " () " )) ? ((void *)0)   : status_allocation_failed ) ;
       
      *ptr_insert_pos = ((( &(  dm  )->result->string )->length)   + ((string_list_t) (&(  dm  )->result->string) )->caret_position)  - 2;
    }

   
  if ((( status ) == ((void *)0)  ) )
    status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  '[' )) ? ((void *)0)   : status_allocation_failed ) ;
  if ((( status ) == ((void *)0)  )  && array_size != ((void *)0) )
    status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  array_size )) ? ((void *)0)   : status_allocation_failed ) ;
  if ((( status ) == ((void *)0)  ) )
    status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ']' )) ? ((void *)0)   : status_allocation_failed ) ;
  if (array_size != ((void *)0) )
    dyn_string_delete (array_size);
  
  do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  return ((void *)0)  ;
}

 




static status_t
demangle_template_param (dm)
     demangling_t dm;
{
  int parm_number;
  template_arg_list_t current_arg_list = current_template_arg_list (dm);
  string_list_t arg;

   ;

   

  if (current_arg_list == ((void *)0) )
    return "Template parameter outside of template.";

  do { status_t s =  demangle_char (dm, 'T') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  if ((*(( dm )->next))  == '_')
    parm_number = 0;
  else
    {
      do { status_t s =  demangle_number (dm, &parm_number, 10, 0) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      ++parm_number;
    }
  do { status_t s =  demangle_char (dm, '_') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  arg = template_arg_list_get_arg (current_arg_list, parm_number);
  if (arg == ((void *)0) )
     

    return "Template parameter number out of bounds.";
  do { status_t s =  (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  (dyn_string_t) arg )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  return ((void *)0)  ;
}

 



static status_t
demangle_template_args (dm)
     demangling_t dm;
{
  int first = 1;
  dyn_string_t old_last_source_name;
  template_arg_list_t arg_list = template_arg_list_new ();

  if (arg_list == ((void *)0) )
    return status_allocation_failed ;

   
  old_last_source_name = dm->last_source_name;
  dm->last_source_name = dyn_string_new (0);

   ;

  if (dm->last_source_name == ((void *)0) )
    return status_allocation_failed ;

  do { status_t s =  demangle_char (dm, 'I') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  result_add_separated_char( dm , '<')  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do
    {
      string_list_t arg;

      if (first)
	first = 0;
      else
	do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ", " )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

       
      do { status_t s =  result_push (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  demangle_template_arg (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      arg = result_pop (dm);

       
      do { status_t s =  (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  (dyn_string_t) arg )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

       
      template_arg_list_add_arg (arg_list, arg);
    }
  while ((*(( dm )->next))  != 'E');
   
  do { status_t s =  result_add_separated_char( dm , '>')  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

   
  (++( dm )->next) ;

   
  dyn_string_delete (dm->last_source_name);
  dm->last_source_name = old_last_source_name;

   


  push_template_arg_list (dm, arg_list);

  return ((void *)0)  ;
}

 








static status_t
demangle_literal (dm)
     demangling_t dm;
{
  char peek = (*(( dm )->next)) ;
  dyn_string_t value_string;
  status_t status;

   ;

  if (!flag_verbose && peek >= 'a' && peek <= 'z')
    {
       





       







      static const char *const code_map = "ibi    iii ll     ii  i  ";

      char code = code_map[peek - 'a'];
       
      if (code == 'u')
	return "Unimplemented." ;
      if (code == 'b')
	{
	   
	  char value;

	   
	  (++( dm )->next) ;
	   

	  value = (*(( dm )->next)) ;
	  if (value == '0')
	    do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "false" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  else if (value == '1')
	    do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "true" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  else
	    return "Unrecognized bool constant.";
	   
	  (++( dm )->next) ;
	  return ((void *)0)  ;
	}
      else if (code == 'i' || code == 'l')
	{
	   

	   
	  (++( dm )->next) ;

	   
	  value_string = dyn_string_new (0);
	  status = demangle_number_literally (dm, value_string, 10, 1);
	  if ((( status ) == ((void *)0)  ) )
	    status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  value_string )) ? ((void *)0)   : status_allocation_failed ) ;
	   
	  if (code == 'l' && (( status ) == ((void *)0)  ) )
	    status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  code )) ? ((void *)0)   : status_allocation_failed ) ;
	  dyn_string_delete (value_string);

	  do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  return ((void *)0)  ;
	}
       

    }

  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  '(' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ')' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  value_string = dyn_string_new (0);
  if (value_string == ((void *)0) )
    return status_allocation_failed ;

  status = demangle_number_literally (dm, value_string, 10, 1);
  if ((( status ) == ((void *)0)  ) )
    status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  value_string )) ? ((void *)0)   : status_allocation_failed ) ;
  dyn_string_delete (value_string);
  do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  return ((void *)0)  ;
}

 






static status_t
demangle_template_arg (dm)
     demangling_t dm;
{
   ;

  switch ((*(( dm )->next)) )
    {
    case 'L':
      (++( dm )->next) ;

      if ((*(( dm )->next))  == 'Z')
	{
	   
	  (++( dm )->next) ;
	   
	  do { status_t s =  demangle_encoding (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	}
      else
	do { status_t s =  demangle_literal (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  demangle_char (dm, 'E') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      break;

    case 'X':
       
      (++( dm )->next) ;
      do { status_t s =  demangle_expression (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  demangle_char (dm, 'E') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      break;

    default:
      do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      break;
    }

  return ((void *)0)  ;
}

 






static status_t
demangle_expression (dm)
     demangling_t dm;
{
  char peek = (*(( dm )->next)) ;

   ;

  if (peek == 'L' || peek == 'T')
    do { status_t s =  demangle_expr_primary (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  else if (peek == 's' && ((*((  dm  )->next))  == '\0' ? '\0' : (*(( dm )->next + 1)))  == 'r')
    do { status_t s =  demangle_scope_expression (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  else
     
    {
      int num_args;
      int type_arg;
      status_t status = ((void *)0)  ;
      dyn_string_t operator_name;

       


      do { status_t s =  result_push (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  demangle_operator_name (dm, 1, &num_args,
					       &type_arg) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      operator_name = (dyn_string_t) result_pop (dm);

       
      if (num_args > 1)
	{
	  status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  '(' )) ? ((void *)0)   : status_allocation_failed ) ;
	  if ((( status ) == ((void *)0)  ) )
	    status = demangle_expression (dm);
	  if ((( status ) == ((void *)0)  ) )
	    status = (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ')' )) ? ((void *)0)   : status_allocation_failed ) ;
	}

         
      if ((( status ) == ((void *)0)  ) )
	status = (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  operator_name )) ? ((void *)0)   : status_allocation_failed ) ;
      dyn_string_delete (operator_name);
      do { status_t s =  status ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      
       
      do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  '(' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      if (type_arg)
	do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      else
	do { status_t s =  demangle_expression (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ')' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

       
      if (num_args == 3)
	{
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ":(" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  demangle_expression (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ')' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	}
    }

  return ((void *)0)  ;
}

 




static status_t
demangle_scope_expression (dm)
     demangling_t dm;
{
  do { status_t s =  demangle_char (dm, 's') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_char (dm, 'r') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_type (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "::" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_encoding (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  return ((void *)0)  ;
}

 





static status_t
demangle_expr_primary (dm)
     demangling_t dm;
{
  char peek = (*(( dm )->next)) ;

   ;

  if (peek == 'T')
    do { status_t s =  demangle_template_param (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  else if (peek == 'L')
    {
       
      (++( dm )->next) ;
      peek = (*(( dm )->next)) ;

      if (peek == '_')
	do { status_t s =  demangle_mangled_name (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      else
	do { status_t s =  demangle_literal (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

      do { status_t s =  demangle_char (dm, 'E') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }
  else
    return "Error." ;

  return ((void *)0)  ;
}

 



















static status_t
demangle_substitution (dm, template_p)
     demangling_t dm;
     int *template_p;
{
  int seq_id;
  int peek;
  dyn_string_t text;

   ;

  do { status_t s =  demangle_char (dm, 'S') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

   

  peek = (*(( dm )->next)) ;
  if (peek == '_')
    seq_id = -1;
   


  else if ((( (unsigned char) peek ) >= '0' && ( (unsigned char) peek ) <= '9')  
	   || (peek >= 'A' && peek <= 'Z'))
    do { status_t s =  demangle_number (dm, &seq_id, 36, 0) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  else 
    {
      const char *new_last_source_name = ((void *)0) ;

      switch (peek)
	{
	case 't':
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  break;

	case 'a':
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::allocator" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  new_last_source_name = "allocator";
	  *template_p = 1;
	  break;

	case 'b':
	  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::basic_string" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  new_last_source_name = "basic_string";
	  *template_p = 1;
	  break;
	  
	case 's':
	  if (!flag_verbose)
	    {
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::string" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      new_last_source_name = "string";
	    }
	  else
	    {
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::basic_string<char, std::char_traits<char>, std::allocator<char> >" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      new_last_source_name = "basic_string";
	    }
	  *template_p = 0;
	  break;

	case 'i':
	  if (!flag_verbose)
	    {
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::istream" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      new_last_source_name = "istream";
	    }
	  else
	    {
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::basic_istream<char, std::char_traits<char> >" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      new_last_source_name = "basic_istream";
	    }
	  *template_p = 0;
	  break;

	case 'o':
	  if (!flag_verbose)
	    {
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::ostream" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      new_last_source_name = "ostream";
	    }
	  else
	    {
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::basic_ostream<char, std::char_traits<char> >" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      new_last_source_name = "basic_ostream";
	    }
	  *template_p = 0;
	  break;

	case 'd':
	  if (!flag_verbose) 
	    {
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::iostream" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      new_last_source_name = "iostream";
	    }
	  else
	    {
	      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "std::basic_iostream<char, std::char_traits<char> >" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	      new_last_source_name = "basic_iostream";
	    }
	  *template_p = 0;
	  break;

	default:
	  return "Unrecognized <substitution>.";
	}
      
       
      (++( dm )->next) ;

      if (new_last_source_name != ((void *)0) )
	{
	  if (!dyn_string_copy_cstr (dm->last_source_name, 
				     new_last_source_name))
	    return status_allocation_failed ;
	}

      return ((void *)0)  ;
    }

   


  text = substitution_get (dm, seq_id + 1, template_p);
  if (text == ((void *)0) ) 
    return "Substitution number out of range.";

   
  do { status_t s =  (dyn_string_insert (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  text )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  do { status_t s =  demangle_char (dm, '_') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  return ((void *)0)  ;
}

 




static status_t
demangle_local_name (dm)
     demangling_t dm;
{
   ;

  do { status_t s =  demangle_char (dm, 'Z') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_encoding (dm) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  demangle_char (dm, 'E') ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
  do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "::" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;

  if ((*(( dm )->next))  == 's')
    {
       
      do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  "string literal" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       
      (++( dm )->next) ;
      do { status_t s =  demangle_discriminator (dm, 0) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }
  else
    {
      int unused;
       
      do { status_t s =  demangle_name (dm, &unused) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
      do { status_t s =  demangle_discriminator (dm, 1) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
     }

   return ((void *)0)  ;
 }

  







static status_t
demangle_discriminator (dm, suppress_first)
     demangling_t dm;
     int suppress_first;
{
   


  if ((*(( dm )->next))  == '_')
    {
       
      (++( dm )->next) ;
      if (flag_verbose)
	do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " [#" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
       
      if ((( (unsigned char) (*(( dm )->next))  ) >= '0' && ( (unsigned char) (*(( dm )->next))  ) <= '9') )
	{
	  int discriminator;
	   
	  do { status_t s =  demangle_number (dm, &discriminator, 10, 0) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	  if (flag_verbose)
	     


	    do { status_t s =  int_to_dyn_string (discriminator + 1,
						(dyn_string_t) dm->result) ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
	}
      else
	return "Error." ;
      if (flag_verbose)
	do { status_t s =  (dyn_string_insert_char (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  ']' )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }
  else if (!suppress_first)
    {
      if (flag_verbose)
	do { status_t s =  (dyn_string_insert_cstr (&( dm )->result->string, ((( &(   dm   )->result->string )->length)   + ((string_list_t) (&(   dm   )->result->string) )->caret_position) , (  " [#0]" )) ? ((void *)0)   : status_allocation_failed )  ; if (! (( s ) == ((void *)0)  ) ) return s; } while (0) ;
    }

  return ((void *)0)  ;
}

 



static status_t
cp_demangle (name, result, style)
     const char *name;
     dyn_string_t result;
     int style;
{
  status_t status;
  int length = strlen (name);

  if (length > 2 && name[0] == '_' && name[1] == 'Z')
    {
      demangling_t dm = demangling_new (name, style);
      if (dm == ((void *)0) )
	return status_allocation_failed ;

      status = result_push (dm);
      if (status != ((void *)0)  )
	{
	  demangling_delete (dm);
	  return status;
	}

      status = demangle_mangled_name (dm);
      if ((( status ) == ((void *)0)  ) )
	{
	  dyn_string_t demangled = (dyn_string_t) result_pop (dm);
	  if (!dyn_string_copy (result, demangled))
	    return status_allocation_failed ;
	  dyn_string_delete (demangled);
	}
      
      demangling_delete (dm);
    }
  else
    {
       


      if (!dyn_string_copy_cstr (result, name))
	return status_allocation_failed ;
      status = ((void *)0)  ;
    }

  return status; 
}

 



static status_t
cp_demangle_type (type_name, result)
     const char* type_name;
     dyn_string_t result;
{
  status_t status;
  demangling_t dm = demangling_new (type_name, (1 << 14) );
  
  if (dm == ((void *)0) )
    return status_allocation_failed ;

   
  status = result_push (dm);
  if (status != ((void *)0)  )
    {
      demangling_delete (dm);
      return status;
    }

  status = demangle_type (dm);

  if ((( status ) == ((void *)0)  ) )
    {
       

      dyn_string_t demangled = (dyn_string_t) result_pop (dm);
      if (!dyn_string_copy (result, demangled))
	return status_allocation_failed ;
      dyn_string_delete (demangled);
    }

   
  demangling_delete (dm);

  return status;
}

# 3749 "cp-demangle.c"


 





char *
cplus_demangle_v3 (mangled, options)
     const char* mangled;
     int options;
{
  dyn_string_t demangled;
  status_t status;
  int type = !!(options & (1 << 4) );

  if (mangled[0] == '_' && mangled[1] == 'Z')
     
    type = 0;
  else
    {
       
      if (!type)
	return ((void *)0) ;
    }

  flag_verbose = !!(options & (1 << 3) );

   
  demangled = dyn_string_new (0);
   
  if (!type)
     
    status = cp_demangle (mangled, demangled, 0);
  else
     
    status = cp_demangle_type (mangled, demangled);

  if ((( status ) == ((void *)0)  ) )
     
    {
       

      char *return_value = dyn_string_release (demangled);
       
      return return_value;
    }
  else if (status == status_allocation_failed )
    {
      fprintf (stderr , "Memory allocation failed.\n");
      abort ();
    }
  else
     
    {
      dyn_string_delete (demangled);
      return ((void *)0) ;
    }
}

 






char *
java_demangle_v3 (mangled)
     const char* mangled;
{
  dyn_string_t demangled;
  char *next;
  char *end;
  int len;
  status_t status;
  int nesting = 0;
  char *cplus_demangled;
  char *return_value;
    
   
  demangled = dyn_string_new (0);

   
  status = cp_demangle ((char *) mangled, demangled, (1 << 2) );

  if ((( status ) == ((void *)0)  ) )
     
    {
       
      cplus_demangled = dyn_string_release (demangled);
    }
  else if (status == status_allocation_failed )
    {
      fprintf (stderr , "Memory allocation failed.\n");
      abort ();
    }
  else
     
    {
      dyn_string_delete (demangled);
      return ((void *)0) ;
    }
  
  len = strlen (cplus_demangled);
  next = cplus_demangled;
  end = next + len;
  demangled = ((void *)0) ;

   
  while (next < end)
    {
      char *open_str = strstr (next, "JArray<");
      char *close_str = ((void *)0) ;
      if (nesting > 0)
	close_str = strchr (next, '>');
    
      if (open_str != ((void *)0)  && (close_str == ((void *)0)  || close_str > open_str))
        {
	  ++nesting;
	  
	  if (!demangled)
	    demangled = dyn_string_new(len);

           
	  if (open_str > next)
	    {
	      open_str[0] = 0;
	      dyn_string_append_cstr (demangled, next);
	    }	  
	  next = open_str + 7;
	}
      else if (close_str != ((void *)0) )
        {
	  --nesting;
	  
           

	  if (close_str > next && next[0] != ' ')
	    {
	      close_str[0] = 0;
	      dyn_string_append_cstr (demangled, next);
	    }
	  dyn_string_append_cstr (demangled, "[]");	  
	  next = close_str + 1;
	}
      else
        {
	   

	  if (next == cplus_demangled)
	    return cplus_demangled;

          dyn_string_append_cstr (demangled, next);
	  next = end;
	}
    }

  free (cplus_demangled);
  
  if (demangled)
    return_value = dyn_string_release (demangled);
  else
    return_value = ((void *)0) ;

  return return_value;
}





 


static demangling_t
demangle_v3_with_details (name)
     const char *name;
{
  demangling_t dm;
  status_t status;

  if (strncmp (name, "_Z", 2))
    return 0;

  dm = demangling_new (name, (1 << 14) );
  if (dm == ((void *)0) )
    {
      fprintf (stderr , "Memory allocation failed.\n");
      abort ();
    }

  status = result_push (dm);
  if (! (( status ) == ((void *)0)  ) )
    {
      demangling_delete (dm);
      fprintf (stderr , "%s\n", status);
      abort ();
    }

  status = demangle_mangled_name (dm);
  if ((( status ) == ((void *)0)  ) )
    return dm;

  demangling_delete (dm);
  return 0;
}


 




enum gnu_v3_ctor_kinds
is_gnu_v3_mangled_ctor (name)
     const char *name;
{
  demangling_t dm = demangle_v3_with_details (name);

  if (dm)
    {
      enum gnu_v3_ctor_kinds result = dm->is_constructor;
      demangling_delete (dm);
      return result;
    }
  else
    return (enum gnu_v3_ctor_kinds) 0;
}


 




enum gnu_v3_dtor_kinds
is_gnu_v3_mangled_dtor (name)
     const char *name;
{
  demangling_t dm = demangle_v3_with_details (name);

  if (dm)
    {
      enum gnu_v3_dtor_kinds result = dm->is_destructor;
      demangling_delete (dm);
      return result;
    }
  else
    return (enum gnu_v3_dtor_kinds) 0;
}



# 4199 "cp-demangle.c"

