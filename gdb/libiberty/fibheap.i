# 1 "fibheap.c"
 





















# 1 "config.h" 1
 
 

 
 

 
 

 


 
 

 
 

 
 

 
 

 
 

 
 

 


 
 

 


 
 

 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 
 

 


 


 
 

 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 
 

 


 


 


 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 


 
 

 


 


 


 


 
 

 
 

 
 

 


 


 


 


 
 

 

 

 


 
 

 


 


 


 


 


 

 






 
 

 


# 23 "fibheap.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/limits.h" 1 3



 



 



 




 





 



 












 

 




 



 








 



 













 




 








 






# 26 "fibheap.c" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 1 3
 

















 





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




# 25 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 2 3


 







# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


































typedef long unsigned int size_t;






















 




 

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


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/sys/types.h" 1 3
 

















 








 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/types.h" 1 3
 

















 




typedef unsigned int __socklen_t;  
typedef unsigned int __useconds_t;  
typedef int __clockid_t;  
typedef int __timer_t;  




# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 


# 19 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3



 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 

# 131 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 

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








 


# 401 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/stdlib.h" 2 3


 



 
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





 


# 29 "fibheap.c" 2



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


 


# 32 "fibheap.c" 2


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








# 34 "fibheap.c" 2

# 1 "../include/fibheap.h" 1
 




















 






















typedef long fibheapkey_t;

typedef struct fibheap
{
  size_t nodes;
  struct fibnode *min;
  struct fibnode *root;
} *fibheap_t;

typedef struct fibnode
{
  struct fibnode *parent;
  struct fibnode *child;
  struct fibnode *left;
  struct fibnode *right;
  fibheapkey_t key;
  void *data;
  unsigned int degree : 31;
  unsigned int mark : 1;
} *fibnode_t;

extern fibheap_t fibheap_new  (void)  ;
extern fibnode_t fibheap_insert  (fibheap_t, fibheapkey_t, void *)  ;
extern int fibheap_empty  (fibheap_t)  ;
extern fibheapkey_t fibheap_min_key  (fibheap_t)  ;
extern fibheapkey_t fibheap_replace_key  (fibheap_t, fibnode_t,
						 fibheapkey_t)  ;
extern void *fibheap_replace_key_data  (fibheap_t, fibnode_t,
					       fibheapkey_t, void *)  ;
extern void *fibheap_extract_min  (fibheap_t)  ;
extern void *fibheap_min  (fibheap_t)  ;
extern void *fibheap_replace_data  (fibheap_t, fibnode_t, void *)  ;
extern void *fibheap_delete_node  (fibheap_t, fibnode_t)  ;
extern void fibheap_delete  (fibheap_t)  ;
extern fibheap_t fibheap_union  (fibheap_t, fibheap_t)  ;


# 35 "fibheap.c" 2





static void fibheap_ins_root  (fibheap_t, fibnode_t)  ;
static void fibheap_rem_root  (fibheap_t, fibnode_t)  ;
static void fibheap_consolidate  (fibheap_t)  ;
static void fibheap_link  (fibheap_t, fibnode_t, fibnode_t)  ;
static void fibheap_cut  (fibheap_t, fibnode_t, fibnode_t)  ;
static void fibheap_cascading_cut  (fibheap_t, fibnode_t)  ;
static fibnode_t fibheap_extr_min_node  (fibheap_t)  ;
static int fibheap_compare  (fibheap_t, fibnode_t, fibnode_t)  ;
static int fibheap_comp_data  (fibheap_t, fibheapkey_t, void *,
				      fibnode_t)  ;
static fibnode_t fibnode_new  (void)  ;
static void fibnode_insert_after  (fibnode_t, fibnode_t)  ;

static fibnode_t fibnode_remove  (fibnode_t)  ;


 
fibheap_t
fibheap_new ()
{
  return (fibheap_t) xcalloc (1, sizeof (struct fibheap));
}

 
static fibnode_t
fibnode_new ()
{
  fibnode_t node;

  node = (fibnode_t) xcalloc (1, sizeof *node);
  node->left = node;
  node->right = node;

  return node;
}

static __inline__  int
fibheap_compare (heap, a, b)
     fibheap_t heap __attribute__ ((__unused__)) ;
     fibnode_t a;
     fibnode_t b;
{
  if (a->key < b->key)
    return -1;
  if (a->key > b->key)
    return 1;
  return 0;
}

static __inline__  int
fibheap_comp_data (heap, key, data, b)
     fibheap_t heap;
     fibheapkey_t key;
     void *data;
     fibnode_t b;
{
  struct fibnode a;

  a.key = key;
  a.data = data;

  return fibheap_compare (heap, &a, b);
}

 
fibnode_t
fibheap_insert (heap, key, data)
     fibheap_t heap;
     fibheapkey_t key;
     void *data;
{
  fibnode_t node;

   
  node = fibnode_new ();

   
  node->data = data;
  node->key = key;

   
  fibheap_ins_root (heap, node);

   

  if (heap->min == ((void *)0)  || node->key < heap->min->key)
    heap->min = node;

  heap->nodes++;

  return node;
}

 
void *
fibheap_min (heap)
     fibheap_t heap;
{
   
  if (heap->min == ((void *)0) )
    return ((void *)0) ;
  return heap->min->data;
}

 
fibheapkey_t
fibheap_min_key (heap)
     fibheap_t heap;
{
   
  if (heap->min == ((void *)0) )
    return 0;
  return heap->min->key;
}

 
fibheap_t
fibheap_union (heapa, heapb)
     fibheap_t heapa;
     fibheap_t heapb;
{
  fibnode_t a_root, b_root, temp;

   
  if ((a_root = heapa->root) == ((void *)0) )
    {
      free (heapa);
      return heapb;
    }
  if ((b_root = heapb->root) == ((void *)0) )
    {
      free (heapb);
      return heapa;
    }

   
  a_root->left->right = b_root;
  b_root->left->right = a_root;
  temp = a_root->left;
  a_root->left = b_root->left;
  b_root->left = temp;
  heapa->nodes += heapb->nodes;

   
  if (fibheap_compare (heapa, heapb->min, heapa->min) < 0)
    heapa->min = heapb->min;

  free (heapb);
  return heapa;
}

 
void *
fibheap_extract_min (heap)
     fibheap_t heap;
{
  fibnode_t z;
  void *ret = ((void *)0) ;

   
  if (heap->min != ((void *)0) )
    {
       

      z = fibheap_extr_min_node (heap);
      ret = z->data;
      free (z);
    }

  return ret;
}

 
void *
fibheap_replace_key_data (heap, node, key, data)
     fibheap_t heap;
     fibnode_t node;
     fibheapkey_t key;
     void *data;
{
  void *odata;
  int okey;
  fibnode_t y;

   


  if (fibheap_comp_data (heap, key, data, node) > 0)
    return ((void *)0) ;

  odata = node->data;
  okey = node->key;
  node->data = data;
  node->key = key;
  y = node->parent;

  if (okey == key)
    return odata;

   


  if (y != ((void *)0)  && fibheap_compare (heap, node, y) <= 0)
    {
      fibheap_cut (heap, node, y);
      fibheap_cascading_cut (heap, y);
    }

  if (fibheap_compare (heap, node, heap->min) <= 0)
    heap->min = node;

  return odata;
}

 
void *
fibheap_replace_data (heap, node, data)
     fibheap_t heap;
     fibnode_t node;
     void *data;
{
  return fibheap_replace_key_data (heap, node, node->key, data);
}

 
fibheapkey_t
fibheap_replace_key (heap, node, key)
     fibheap_t heap;
     fibnode_t node;
     fibheapkey_t key;
{
  int okey = node->key;
  fibheap_replace_key_data (heap, node, key, node->data);
  return okey;
}

 
void *
fibheap_delete_node (heap, node)
     fibheap_t heap;
     fibnode_t node;
{
  void *ret = node->data;

   
  fibheap_replace_key (heap, node, (- 2147483647L  -1)  );
  fibheap_extract_min (heap);

  return ret;
}

 
void
fibheap_delete (heap)
     fibheap_t heap;
{
  while (heap->min != ((void *)0) )
    free (fibheap_extr_min_node (heap));

  free (heap);
}

 
int
fibheap_empty (heap)
     fibheap_t heap;
{
  return heap->nodes == 0;
}

 
static fibnode_t
fibheap_extr_min_node (heap)
     fibheap_t heap;
{
  fibnode_t ret = heap->min;
  fibnode_t x, y, orig;

   

  for (x = ret->child, orig = ((void *)0) ; x != orig && x != ((void *)0) ; x = y)
    {
      if (orig == ((void *)0) )
	orig = x;
      y = x->right;
      x->parent = ((void *)0) ;
      fibheap_ins_root (heap, x);
    }

   
  fibheap_rem_root (heap, ret);
  heap->nodes--;

   
  if (heap->nodes == 0)
    heap->min = ((void *)0) ;
  else
    {
       

      heap->min = ret->right;
      fibheap_consolidate (heap);
    }

  return ret;
}

 
static void
fibheap_ins_root (heap, node)
     fibheap_t heap;
     fibnode_t node;
{
   

  if (heap->root == ((void *)0) )
    {
      heap->root = node;
      node->left = node;
      node->right = node;
      return;
    }

   

  fibnode_insert_after (heap->root, node);
}

 
static void
fibheap_rem_root (heap, node)
     fibheap_t heap;
     fibnode_t node;
{
  if (node->left == node)
    heap->root = ((void *)0) ;
  else
    heap->root = fibnode_remove (node);
}

 
static void
fibheap_consolidate (heap)
     fibheap_t heap;
{
  fibnode_t a[1 + 8 * sizeof (long)];
  fibnode_t w;
  fibnode_t y;
  fibnode_t x;
  int i;
  int d;
  int D;

  D = 1 + 8 * sizeof (long);

  memset (a, 0, sizeof (fibnode_t) * D);

  while ((w = heap->root) != ((void *)0) )
    {
      x = w;
      fibheap_rem_root (heap, w);
      d = x->degree;
      while (a[d] != ((void *)0) )
	{
	  y = a[d];
	  if (fibheap_compare (heap, x, y) > 0)
	    {
	      fibnode_t temp;
	      temp = x;
	      x = y;
	      y = temp;
	    }
	  fibheap_link (heap, y, x);
	  a[d] = ((void *)0) ;
	  d++;
	}
      a[d] = x;
    }
  heap->min = ((void *)0) ;
  for (i = 0; i < D; i++)
    if (a[i] != ((void *)0) )
      {
	fibheap_ins_root (heap, a[i]);
	if (heap->min == ((void *)0)  || fibheap_compare (heap, a[i], heap->min) < 0)
	  heap->min = a[i];
      }
}

 
static void
fibheap_link (heap, node, parent)
     fibheap_t heap __attribute__ ((__unused__)) ;
     fibnode_t node;
     fibnode_t parent;
{
  if (parent->child == ((void *)0) )
    parent->child = node;
  else
    fibnode_insert_after ( parent->child ->left,   node ) ;
  node->parent = parent;
  parent->degree++;
  node->mark = 0;
}

 
static void
fibheap_cut (heap, node, parent)
     fibheap_t heap;
     fibnode_t node;
     fibnode_t parent;
{
  fibnode_remove (node);
  parent->degree--;
  fibheap_ins_root (heap, node);
  node->parent = ((void *)0) ;
  node->mark = 0;
}

static void
fibheap_cascading_cut (heap, y)
     fibheap_t heap;
     fibnode_t y;
{
  fibnode_t z;

  while ((z = y->parent) != ((void *)0) )
    {
      if (y->mark == 0)
	{
	  y->mark = 1;
	  return;
	}
      else
	{
	  fibheap_cut (heap, y, z);
	  y = z;
	}
    }
}

static void
fibnode_insert_after (a, b)
     fibnode_t a;
     fibnode_t b;
{
  if (a == a->right)
    {
      a->right = b;
      a->left = b;
      b->right = a;
      b->left = a;
    }
  else
    {
      b->right = a->right;
      a->right->left = b;
      a->right = b;
      b->left = a;
    }
}

static fibnode_t
fibnode_remove (node)
     fibnode_t node;
{
  fibnode_t ret;

  if (node == node->left)
    ret = ((void *)0) ;
  else
    ret = node->left;

  if (node->parent != ((void *)0)  && node->parent->child == node)
    node->parent->child = ret;

  node->right->left = node->left;
  node->left->right = node->right;

  node->parent = ((void *)0) ;
  node->left = node;
  node->right = node;

  return ret;
}
