# 1 "hashtab.c"
 



















 













# 1 "config.h" 1
 
 

 
 

 
 

 


 
 

 
 

 
 

 
 

 
 

 
 

 


 
 

 


 
 

 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 
 

 


 


 
 

 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 
 

 


 


 


 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 


 
 

 


 


 


 


 
 

 
 

 
 

 


 


 


 


 
 

 

 

 


 
 

 


 


 


 


 


 

 






 
 

 


# 35 "hashtab.c" 2



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








 


# 38 "hashtab.c" 2



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





 


# 41 "hashtab.c" 2




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


 


# 45 "hashtab.c" 2




# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/malloc.h" 1 3
 























 


















# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 







 

 




 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 





















typedef long int ptrdiff_t;









 




 

 


# 188 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3





 




 





























 


























typedef int wchar_t;
























typedef unsigned int  wint_t;




 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 44 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/malloc.h" 2 3




















 








 



# 93 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/malloc.h" 3














 





extern int __malloc_initialized;

 




 
extern void *  malloc  (size_t __size)      ;

 
extern void *  calloc  (size_t __nmemb, size_t __size)    
        ;

 

extern void *  realloc  (void *  __ptr,
					   size_t __size)    
        ;

 
extern void free  (void *  __ptr)    ;

 
extern void cfree  (void *  __ptr)    ;

 
extern void *  memalign  (size_t __alignment, size_t __size)    ;

 
extern void *  valloc  (size_t __size)      ;

 

extern void *   pvalloc  (size_t __size)    
        ;

 

extern void *  (*__morecore)  (ptrdiff_t __size)  ;

 
extern void *  __default_morecore  (ptrdiff_t __size)    
        ;

 
struct mallinfo {
  int arena;     
  int ordblks;   
  int smblks;    
  int hblks;     
  int hblkhd;    
  int usmblks;   
  int fsmblks;   
  int uordblks;  
  int fordblks;  
  int keepcost;  
};

 
extern struct mallinfo mallinfo  (void)    ;

 













 






 
extern int mallopt  (int __param, int __val)    ;

 

extern int malloc_trim  (size_t __pad)    ;

 

extern size_t malloc_usable_size  (void *  __ptr)    ;

 
extern void malloc_stats  (void)    ;

 
extern void *  malloc_get_state  (void)    ;

 

extern int malloc_set_state  (void *  __ptr)    ;


 


extern void (*__malloc_initialize_hook)  (void)  ;
 
extern void (*__free_hook)  (void *  __ptr,
					__const void * )  ;
extern void *  (*__malloc_hook)  (size_t __size,
						    __const void * )  ;
extern void *  (*__realloc_hook)  (void *  __ptr,
						     size_t __size,
						     __const void * )  ;
extern void *  (*__memalign_hook)  (size_t __alignment,
						      size_t __size,
						      __const void * )  ;
extern void (*__after_morecore_hook)  (void)  ;

 
extern void __malloc_check_init  (void)    ;







# 49 "hashtab.c" 2



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










 






 




# 52 "hashtab.c" 2


# 1 "../include/libiberty.h" 1
 








































# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 42 "../include/libiberty.h" 2



 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3
# 342 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3

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








# 54 "hashtab.c" 2

# 1 "../include/hashtab.h" 1
 

















 

























 
typedef unsigned int hashval_t;

 

 
typedef hashval_t (*htab_hash)  (const void *)  ;

 




typedef int (*htab_eq)  (const void *, const void *)  ;

 

typedef void (*htab_del)  (void *)  ;
  
 



typedef int (*htab_trav)  (void **, void *)  ;

 



typedef void *  (*htab_alloc)  (size_t, size_t)  ;

 
typedef void (*htab_free)  (void * )  ;

 

typedef void *  (*htab_alloc_with_arg)  (void *, size_t, size_t)  ;
typedef void (*htab_free_with_arg)  (void *, void *)  ;

 





struct htab  
{
   
  htab_hash hash_f;

   
  htab_eq eq_f;

   
  htab_del del_f;

   
  void *  *   entries;

   
  size_t size;

   
  size_t n_elements;

   
  size_t n_deleted;

   

  unsigned int searches;

   

  unsigned int collisions;

   
  htab_alloc alloc_f;
  htab_free free_f;

   
  void *    alloc_arg;
  htab_alloc_with_arg alloc_with_arg_f;
  htab_free_with_arg free_with_arg_f;
};

typedef struct htab *htab_t;

 
enum insert_option {NO_INSERT, INSERT};

 

extern htab_t	htab_create_alloc	 (size_t, htab_hash,
						 htab_eq, htab_del,
						 htab_alloc, htab_free)  ;

extern htab_t	htab_create_alloc_ex	 (size_t, htab_hash,
						    htab_eq, htab_del,
						    void * , htab_alloc_with_arg,
						    htab_free_with_arg)  ;

 
extern htab_t htab_create  (size_t, htab_hash, htab_eq, htab_del)  ;
extern htab_t htab_try_create  (size_t, htab_hash, htab_eq, htab_del)  ;

extern void	htab_set_functions_ex	 (htab_t, htab_hash,
						 htab_eq, htab_del,
						 void * , htab_alloc_with_arg,
						 htab_free_with_arg)  ;

extern void	htab_delete	 (htab_t)  ;
extern void	htab_empty	 (htab_t)  ;

extern void * 	htab_find	 (htab_t, const void *)  ;
extern void *      *htab_find_slot	 (htab_t, const void *,
					 enum insert_option)  ;
extern void * 	htab_find_with_hash	   (htab_t, const void *,
						   hashval_t)  ;
extern void *      *htab_find_slot_with_hash   (htab_t, const void *,
						   hashval_t,
						   enum insert_option)  ;
extern void	htab_clear_slot	 (htab_t, void **)  ;
extern void	htab_remove_elt	 (htab_t, void *)  ;

extern void	htab_traverse	 (htab_t, htab_trav, void *)  ;
extern void	htab_traverse_noresize	 (htab_t, htab_trav, void *)  ;

extern size_t	htab_size	 (htab_t)  ;
extern size_t	htab_elements	 (htab_t)  ;
extern double	htab_collisions	 (htab_t)  ;

 
extern htab_hash htab_hash_pointer;

 
extern htab_eq htab_eq_pointer;

 
extern hashval_t htab_hash_string  (const void * )  ;

 
extern hashval_t iterative_hash  (const void * , size_t, hashval_t)  ;
 







# 55 "hashtab.c" 2


 



 




static unsigned long higher_prime_number  (unsigned long)  ;
static hashval_t hash_pointer  (const void *)  ;
static int eq_pointer  (const void *, const void *)  ;
static int htab_expand  (htab_t)  ;
static void *  *find_empty_slot_for_expand   (htab_t, hashval_t)  ;

 


htab_hash htab_hash_pointer = hash_pointer;
htab_eq htab_eq_pointer = eq_pointer;

 


static unsigned long
higher_prime_number (n)
     unsigned long n;
{
   

  static const unsigned long primes[] = {
    (unsigned long) 7,
    (unsigned long) 13,
    (unsigned long) 31,
    (unsigned long) 61,
    (unsigned long) 127,
    (unsigned long) 251,
    (unsigned long) 509,
    (unsigned long) 1021,
    (unsigned long) 2039,
    (unsigned long) 4093,
    (unsigned long) 8191,
    (unsigned long) 16381,
    (unsigned long) 32749,
    (unsigned long) 65521,
    (unsigned long) 131071,
    (unsigned long) 262139,
    (unsigned long) 524287,
    (unsigned long) 1048573,
    (unsigned long) 2097143,
    (unsigned long) 4194301,
    (unsigned long) 8388593,
    (unsigned long) 16777213,
    (unsigned long) 33554393,
    (unsigned long) 67108859,
    (unsigned long) 134217689,
    (unsigned long) 268435399,
    (unsigned long) 536870909,
    (unsigned long) 1073741789,
    (unsigned long) 2147483647,
					 
    ((unsigned long) 2147483647) + ((unsigned long) 2147483644),
  };

  const unsigned long *low = &primes[0];
  const unsigned long *high = &primes[sizeof(primes) / sizeof(primes[0])];

  while (low != high)
    {
      const unsigned long *mid = low + (high - low) / 2;
      if (n > *mid)
	low = mid + 1;
      else
	high = mid;
    }

   
  if (n > *low)
    {
      fprintf (stderr , "Cannot find prime bigger than %lu\n", n);
      abort ();
    }

  return *low;
}

 

static hashval_t
hash_pointer (p)
     const void *  p;
{
  return (hashval_t) ((long)p >> 3);
}

 

static int
eq_pointer (p1, p2)
     const void *  p1;
     const void *  p2;
{
  return p1 == p2;
}

 




htab_t
htab_create_alloc (size, hash_f, eq_f, del_f, alloc_f, free_f)
     size_t size;
     htab_hash hash_f;
     htab_eq eq_f;
     htab_del del_f;
     htab_alloc alloc_f;
     htab_free free_f;
{
  htab_t result;

  size = higher_prime_number (size);
  result = (htab_t) (*alloc_f) (1, sizeof (struct htab));
  if (result == ((void *)0) )
    return ((void *)0) ;
  result->entries = (void *  *) (*alloc_f) (size, sizeof (void * ));
  if (result->entries == ((void *)0) )
    {
      if (free_f != ((void *)0) )
	(*free_f) (result);
      return ((void *)0) ;
    }
  result->size = size;
  result->hash_f = hash_f;
  result->eq_f = eq_f;
  result->del_f = del_f;
  result->alloc_f = alloc_f;
  result->free_f = free_f;
  return result;
}

 


htab_t
htab_create_alloc_ex (size, hash_f, eq_f, del_f, alloc_arg, alloc_f,
		      free_f)
     size_t size;
     htab_hash hash_f;
     htab_eq eq_f;
     htab_del del_f;
     void *  alloc_arg;
     htab_alloc_with_arg alloc_f;
     htab_free_with_arg free_f;
{
  htab_t result;

  size = higher_prime_number (size);
  result = (htab_t) (*alloc_f) (alloc_arg, 1, sizeof (struct htab));
  if (result == ((void *)0) )
    return ((void *)0) ;
  result->entries = (void *  *) (*alloc_f) (alloc_arg, size, sizeof (void * ));
  if (result->entries == ((void *)0) )
    {
      if (free_f != ((void *)0) )
	(*free_f) (alloc_arg, result);
      return ((void *)0) ;
    }
  result->size = size;
  result->hash_f = hash_f;
  result->eq_f = eq_f;
  result->del_f = del_f;
  result->alloc_arg = alloc_arg;
  result->alloc_with_arg_f = alloc_f;
  result->free_with_arg_f = free_f;
  return result;
}

 

void
htab_set_functions_ex (htab, hash_f, eq_f, del_f, alloc_arg, alloc_f, free_f)
     htab_t htab;
     htab_hash hash_f;
     htab_eq eq_f;
     htab_del del_f;
     void *  alloc_arg;
     htab_alloc_with_arg alloc_f;
     htab_free_with_arg free_f;
{
  htab->hash_f = hash_f;
  htab->eq_f = eq_f;
  htab->del_f = del_f;
  htab->alloc_arg = alloc_arg;
  htab->alloc_with_arg_f = alloc_f;
  htab->free_with_arg_f = free_f;
}

 


htab_t
htab_create (size, hash_f, eq_f, del_f)
     size_t size;
     htab_hash hash_f;
     htab_eq eq_f;
     htab_del del_f;
{
  return htab_create_alloc (size, hash_f, eq_f, del_f, xcalloc, free);
}

htab_t
htab_try_create (size, hash_f, eq_f, del_f)
     size_t size;
     htab_hash hash_f;
     htab_eq eq_f;
     htab_del del_f;
{
  return htab_create_alloc (size, hash_f, eq_f, del_f, calloc, free);
}

 


void
htab_delete (htab)
     htab_t htab;
{
  int i;

  if (htab->del_f)
    for (i = htab->size - 1; i >= 0; i--)
      if (htab->entries[i] != ((void * ) 0) 
	  && htab->entries[i] != ((void * ) 1) )
	(*htab->del_f) (htab->entries[i]);

  if (htab->free_f != ((void *)0) )
    {
      (*htab->free_f) (htab->entries);
      (*htab->free_f) (htab);
    }
  else if (htab->free_with_arg_f != ((void *)0) )
    {
      (*htab->free_with_arg_f) (htab->alloc_arg, htab->entries);
      (*htab->free_with_arg_f) (htab->alloc_arg, htab);
    }
}

 

void
htab_empty (htab)
     htab_t htab;
{
  int i;

  if (htab->del_f)
    for (i = htab->size - 1; i >= 0; i--)
      if (htab->entries[i] != ((void * ) 0) 
	  && htab->entries[i] != ((void * ) 1) )
	(*htab->del_f) (htab->entries[i]);

  memset (htab->entries, 0, htab->size * sizeof (void * ));
}

 






static void *  *
find_empty_slot_for_expand (htab, hash)
     htab_t htab;
     hashval_t hash;
{
  size_t size = htab->size;
  unsigned int index = hash % size;
  void *  *slot = htab->entries + index;
  hashval_t hash2;

  if (*slot == ((void * ) 0) )
    return slot;
  else if (*slot == ((void * ) 1) )
    abort ();

  hash2 = 1 + hash % (size - 2);
  for (;;)
    {
      index += hash2;
      if (index >= size)
	index -= size;

      slot = htab->entries + index;
      if (*slot == ((void * ) 0) )
	return slot;
      else if (*slot == ((void * ) 1) )
	abort ();
    }
}

 







static int
htab_expand (htab)
     htab_t htab;
{
  void *  *oentries;
  void *  *olimit;
  void *  *p;
  void *  *nentries;
  size_t nsize;

  oentries = htab->entries;
  olimit = oentries + htab->size;

   

  if ((htab->n_elements - htab->n_deleted) * 2 > htab->size
      || ((htab->n_elements - htab->n_deleted) * 8 < htab->size
	  && htab->size > 32))
    nsize = higher_prime_number ((htab->n_elements - htab->n_deleted) * 2);
  else
    nsize = htab->size;

  if (htab->alloc_with_arg_f != ((void *)0) )
    nentries = (void *  *) (*htab->alloc_with_arg_f) (htab->alloc_arg, nsize,
						  sizeof (void *  *));
  else
    nentries = (void *  *) (*htab->alloc_f) (nsize, sizeof (void *  *));
  if (nentries == ((void *)0) )
    return 0;
  htab->entries = nentries;
  htab->size = nsize;

  htab->n_elements -= htab->n_deleted;
  htab->n_deleted = 0;

  p = oentries;
  do
    {
      void *  x = *p;

      if (x != ((void * ) 0)  && x != ((void * ) 1) )
	{
	  void *  *q = find_empty_slot_for_expand (htab, (*htab->hash_f) (x));

	  *q = x;
	}

      p++;
    }
  while (p < olimit);

  if (htab->free_f != ((void *)0) )
    (*htab->free_f) (oentries);
  else if (htab->free_with_arg_f != ((void *)0) )
    (*htab->free_with_arg_f) (htab->alloc_arg, oentries);
  return 1;
}

 


void * 
htab_find_with_hash (htab, element, hash)
     htab_t htab;
     const void *  element;
     hashval_t hash;
{
  unsigned int index;
  hashval_t hash2;
  size_t size;
  void *  entry;

  htab->searches++;
  size = htab->size;
  index = hash % size;

  entry = htab->entries[index];
  if (entry == ((void * ) 0) 
      || (entry != ((void * ) 1)  && (*htab->eq_f) (entry, element)))
    return entry;

  hash2 = 1 + hash % (size - 2);

  for (;;)
    {
      htab->collisions++;
      index += hash2;
      if (index >= size)
	index -= size;

      entry = htab->entries[index];
      if (entry == ((void * ) 0) 
	  || (entry != ((void * ) 1)  && (*htab->eq_f) (entry, element)))
	return entry;
    }
}

 


void * 
htab_find (htab, element)
     htab_t htab;
     const void *  element;
{
  return htab_find_with_hash (htab, element, (*htab->hash_f) (element));
}

 







void *  *
htab_find_slot_with_hash (htab, element, hash, insert)
     htab_t htab;
     const void *  element;
     hashval_t hash;
     enum insert_option insert;
{
  void *  *first_deleted_slot;
  unsigned int index;
  hashval_t hash2;
  size_t size;
  void *  entry;

  if (insert == INSERT && htab->size * 3 <= htab->n_elements * 4
      && htab_expand (htab) == 0)
    return ((void *)0) ;

  size = htab->size;
  index = hash % size;

  htab->searches++;
  first_deleted_slot = ((void *)0) ;

  entry = htab->entries[index];
  if (entry == ((void * ) 0) )
    goto empty_entry;
  else if (entry == ((void * ) 1) )
    first_deleted_slot = &htab->entries[index];
  else if ((*htab->eq_f) (entry, element))
    return &htab->entries[index];
      
  hash2 = 1 + hash % (size - 2);
  for (;;)
    {
      htab->collisions++;
      index += hash2;
      if (index >= size)
	index -= size;
      
      entry = htab->entries[index];
      if (entry == ((void * ) 0) )
	goto empty_entry;
      else if (entry == ((void * ) 1) )
	{
	  if (!first_deleted_slot)
	    first_deleted_slot = &htab->entries[index];
	}
      else if ((*htab->eq_f) (entry, element))
	return &htab->entries[index];
    }

 empty_entry:
  if (insert == NO_INSERT)
    return ((void *)0) ;

  htab->n_elements++;

  if (first_deleted_slot)
    {
      *first_deleted_slot = ((void * ) 0) ;
      return first_deleted_slot;
    }

  return &htab->entries[index];
}

 


void *  *
htab_find_slot (htab, element, insert)
     htab_t htab;
     const void *  element;
     enum insert_option insert;
{
  return htab_find_slot_with_hash (htab, element, (*htab->hash_f) (element),
				   insert);
}

 



void
htab_remove_elt (htab, element)
     htab_t htab;
     void *  element;
{
  void *  *slot;

  slot = htab_find_slot (htab, element, NO_INSERT);
  if (*slot == ((void * ) 0) )
    return;

  if (htab->del_f)
    (*htab->del_f) (*slot);

  *slot = ((void * ) 1) ;
  htab->n_deleted++;
}

 



void
htab_clear_slot (htab, slot)
     htab_t htab;
     void *  *slot;
{
  if (slot < htab->entries || slot >= htab->entries + htab->size
      || *slot == ((void * ) 0)  || *slot == ((void * ) 1) )
    abort ();

  if (htab->del_f)
    (*htab->del_f) (*slot);

  *slot = ((void * ) 1) ;
  htab->n_deleted++;
}

 




void
htab_traverse_noresize (htab, callback, info)
     htab_t htab;
     htab_trav callback;
     void *  info;
{
  void *  *slot;
  void *  *limit;

  slot = htab->entries;
  limit = slot + htab->size;

  do
    {
      void *  x = *slot;

      if (x != ((void * ) 0)  && x != ((void * ) 1) )
	if (!(*callback) (slot, info))
	  break;
    }
  while (++slot < limit);
}

 


void
htab_traverse (htab, callback, info)
     htab_t htab;
     htab_trav callback;
     void *  info;
{
  if ((htab->n_elements - htab->n_deleted) * 8 < htab->size)
    htab_expand (htab);

  htab_traverse_noresize (htab, callback, info);
}

 

size_t
htab_size (htab)
     htab_t htab;
{
  return htab->size;
}

 

size_t
htab_elements (htab)
     htab_t htab;
{
  return htab->n_elements - htab->n_deleted;
}

 


double
htab_collisions (htab)
     htab_t htab;
{
  if (htab->searches == 0)
    return 0.0;

  return (double) htab->collisions / (double) htab->searches;
}

 
























hashval_t
htab_hash_string (p)
     const void *  p;
{
  const unsigned char *str = (const unsigned char *) p;
  hashval_t r = 0;
  unsigned char c;

  while ((c = *str++) != 0)
    r = r * 67 + c - 113;

  return r;
}

 








 

























 

# 765 "hashtab.c"

 



























hashval_t iterative_hash (k_in, length, initval)
     const void *  k_in;                
     register size_t  length;       
     register hashval_t  initval;   
{
  register const unsigned char *k = (const unsigned char *)k_in;
  register hashval_t a,b,c,len;

   
  len = length;
  a = b = 0x9e3779b9;   
  c = initval;            

   

   


  if (sizeof (hashval_t) == 4 && (((size_t)k)&3) == 0)
    while (len >= 12)     
      {
	a += *(hashval_t *)(k+0);
	b += *(hashval_t *)(k+4);
	c += *(hashval_t *)(k+8);
	{  a  -=  b ;  a  -=  c ;  a  ^= ( c >>13);  b  -=  c ;  b  -=  a ;  b  ^= ( a << 8);  c  -=  a ;  c  -=  b ;  c  ^= (( b &0xffffffff)>>13);  a  -=  b ;  a  -=  c ;  a  ^= (( c &0xffffffff)>>12);  b  -=  c ;  b  -=  a ;  b  = ( b  ^ ( a <<16)) & 0xffffffff;  c  -=  a ;  c  -=  b ;  c  = ( c  ^ ( b >> 5)) & 0xffffffff;  a  -=  b ;  a  -=  c ;  a  = ( a  ^ ( c >> 3)) & 0xffffffff;  b  -=  c ;  b  -=  a ;  b  = ( b  ^ ( a <<10)) & 0xffffffff;  c  -=  a ;  c  -=  b ;  c  = ( c  ^ ( b >>15)) & 0xffffffff; } ;
	k += 12; len -= 12;
      }
  else  

    while (len >= 12)
      {
	a += (k[0] +((hashval_t)k[1]<<8) +((hashval_t)k[2]<<16) +((hashval_t)k[3]<<24));
	b += (k[4] +((hashval_t)k[5]<<8) +((hashval_t)k[6]<<16) +((hashval_t)k[7]<<24));
	c += (k[8] +((hashval_t)k[9]<<8) +((hashval_t)k[10]<<16)+((hashval_t)k[11]<<24));
	{  a  -=  b ;  a  -=  c ;  a  ^= ( c >>13);  b  -=  c ;  b  -=  a ;  b  ^= ( a << 8);  c  -=  a ;  c  -=  b ;  c  ^= (( b &0xffffffff)>>13);  a  -=  b ;  a  -=  c ;  a  ^= (( c &0xffffffff)>>12);  b  -=  c ;  b  -=  a ;  b  = ( b  ^ ( a <<16)) & 0xffffffff;  c  -=  a ;  c  -=  b ;  c  = ( c  ^ ( b >> 5)) & 0xffffffff;  a  -=  b ;  a  -=  c ;  a  = ( a  ^ ( c >> 3)) & 0xffffffff;  b  -=  c ;  b  -=  a ;  b  = ( b  ^ ( a <<10)) & 0xffffffff;  c  -=  a ;  c  -=  b ;  c  = ( c  ^ ( b >>15)) & 0xffffffff; } ;
	k += 12; len -= 12;
      }

   
  c += length;
  switch(len)               
    {
    case 11: c+=((hashval_t)k[10]<<24);
    case 10: c+=((hashval_t)k[9]<<16);
    case 9 : c+=((hashval_t)k[8]<<8);
       
    case 8 : b+=((hashval_t)k[7]<<24);
    case 7 : b+=((hashval_t)k[6]<<16);
    case 6 : b+=((hashval_t)k[5]<<8);
    case 5 : b+=k[4];
    case 4 : a+=((hashval_t)k[3]<<24);
    case 3 : a+=((hashval_t)k[2]<<16);
    case 2 : a+=((hashval_t)k[1]<<8);
    case 1 : a+=k[0];
       
    }
  {  a  -=  b ;  a  -=  c ;  a  ^= ( c >>13);  b  -=  c ;  b  -=  a ;  b  ^= ( a << 8);  c  -=  a ;  c  -=  b ;  c  ^= (( b &0xffffffff)>>13);  a  -=  b ;  a  -=  c ;  a  ^= (( c &0xffffffff)>>12);  b  -=  c ;  b  -=  a ;  b  = ( b  ^ ( a <<16)) & 0xffffffff;  c  -=  a ;  c  -=  b ;  c  = ( c  ^ ( b >> 5)) & 0xffffffff;  a  -=  b ;  a  -=  c ;  a  = ( a  ^ ( c >> 3)) & 0xffffffff;  b  -=  c ;  b  -=  a ;  b  = ( b  ^ ( a <<10)) & 0xffffffff;  c  -=  a ;  c  -=  b ;  c  = ( c  ^ ( b >>15)) & 0xffffffff; } ;
   
  return c;
}
