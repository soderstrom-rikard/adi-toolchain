# 1 "md5.c"
 




















 


# 1 "config.h" 1
 
 

 
 

 
 

 


 
 

 
 

 
 

 
 

 
 

 
 

 


 
 

 


 
 

 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 
 

 


 


 
 

 
 

 


 


 


 


 


 
 

 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 


 
 

 
 

 
 

 


 


 


 


 


 


 


 


 


 


 


 
 

 


 


 


 


 


 


 
 

 


 


 


 


 
 

 
 

 
 

 


 


 


 


 
 

 

 

 


 
 

 


 


 


 


 


 

 






 
 

 


# 25 "md5.c" 2



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








 


# 28 "md5.c" 2











# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 39 "md5.c" 2

# 1 "../include/md5.h" 1
 






















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










 






 




# 24 "../include/md5.h" 2



# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/limits.h" 1 3



 



 



 




 





 



 












 

 




 



 








 



 













 



# 95 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/limits.h" 3




# 27 "../include/md5.h" 2



 












 









   typedef unsigned int md5_uint32;
# 66 "../include/md5.h"










 
struct md5_ctx
{
  md5_uint32 A;
  md5_uint32 B;
  md5_uint32 C;
  md5_uint32 D;

  md5_uint32 total[2];
  md5_uint32 buflen;
  char buffer[128];
};

 




 

extern void md5_init_ctx  (struct md5_ctx *ctx)  ;

 



extern void md5_process_block  (const void *buffer, size_t len,
				    struct md5_ctx *ctx)  ;

 



extern void md5_process_bytes  (const void *buffer, size_t len,
				    struct md5_ctx *ctx)  ;

 






extern void *md5_finish_ctx  (struct md5_ctx *ctx, void *resbuf)  ;


 





extern void *md5_read_ctx  (const struct md5_ctx *ctx, void *resbuf)  ;


 


extern int md5_stream  (FILE *stream, void *resblock)  ;

 



extern void *md5_buffer  (const char *buffer, size_t len, void *resblock)  ;


# 40 "md5.c" 2

















 

static const unsigned char fillbuf[64] = { 0x80, 0   };


 

void
md5_init_ctx (ctx)
     struct md5_ctx *ctx;
{
  ctx->A = (md5_uint32) 0x67452301;
  ctx->B = (md5_uint32) 0xefcdab89;
  ctx->C = (md5_uint32) 0x98badcfe;
  ctx->D = (md5_uint32) 0x10325476;

  ctx->total[0] = ctx->total[1] = 0;
  ctx->buflen = 0;
}

 




void *
md5_read_ctx (ctx, resbuf)
     const struct md5_ctx *ctx;
     void *resbuf;
{
  ((md5_uint32 *) resbuf)[0] = ( ctx->A ) ;
  ((md5_uint32 *) resbuf)[1] = ( ctx->B ) ;
  ((md5_uint32 *) resbuf)[2] = ( ctx->C ) ;
  ((md5_uint32 *) resbuf)[3] = ( ctx->D ) ;

  return resbuf;
}

 




void *
md5_finish_ctx (ctx, resbuf)
     struct md5_ctx *ctx;
     void *resbuf;
{
   
  md5_uint32 bytes = ctx->buflen;
  size_t pad;

   
  ctx->total[0] += bytes;
  if (ctx->total[0] < bytes)
    ++ctx->total[1];

  pad = bytes >= 56 ? 64 + 56 - bytes : 56 - bytes;
  memcpy (&ctx->buffer[bytes], fillbuf, pad);

   
  *(md5_uint32 *) &ctx->buffer[bytes + pad] = ( ctx->total[0] << 3 ) ;
  *(md5_uint32 *) &ctx->buffer[bytes + pad + 4] = ( (ctx->total[1] << 3) |
							(ctx->total[0] >> 29) ) ;

   
  md5_process_block (ctx->buffer, bytes + pad + 8, ctx);

  return md5_read_ctx (ctx, resbuf);
}

 


int
md5_stream (stream, resblock)
     FILE *stream;
     void *resblock;
{
   

  struct md5_ctx ctx;
  char buffer[4096  + 72];
  size_t sum;

   
  md5_init_ctx (&ctx);

   
  while (1)
    {
       


      size_t n;
      sum = 0;

       
      do
	{
	  n = fread (buffer + sum, 1, 4096  - sum, stream);

	  sum += n;
	}
      while (sum < 4096  && n != 0);
      if (n == 0 && ferror (stream))
        return 1;

       
      if (n == 0)
	break;

       


      md5_process_block (buffer, 4096 , &ctx);
    }

   
  if (sum > 0)
    md5_process_bytes (buffer, sum, &ctx);

   
  md5_finish_ctx (&ctx, resblock);
  return 0;
}

 



void *
md5_buffer (buffer, len, resblock)
     const char *buffer;
     size_t len;
     void *resblock;
{
  struct md5_ctx ctx;

   
  md5_init_ctx (&ctx);

   
  md5_process_bytes (buffer, len, &ctx);

   
  return md5_finish_ctx (&ctx, resblock);
}


void
md5_process_bytes (buffer, len, ctx)
     const void *buffer;
     size_t len;
     struct md5_ctx *ctx;
{
   

  if (ctx->buflen != 0)
    {
      size_t left_over = ctx->buflen;
      size_t add = 128 - left_over > len ? len : 128 - left_over;

      memcpy (&ctx->buffer[left_over], buffer, add);
      ctx->buflen += add;

      if (left_over + add > 64)
	{
	  md5_process_block (ctx->buffer, (left_over + add) & ~63, ctx);
	   
	  memcpy (ctx->buffer, &ctx->buffer[(left_over + add) & ~63],
		  (left_over + add) & 63);
	  ctx->buflen = (left_over + add) & 63;
	}

      buffer = (const void *) ((const char *) buffer + add);
      len -= add;
    }

   
  if (len > 64)
    {
      md5_process_block (buffer, len & ~63, ctx);
      buffer = (const void *) ((const char *) buffer + (len & ~63));
      len &= 63;
    }

   
  if (len > 0)
    {
      memcpy (ctx->buffer, buffer, len);
      ctx->buflen = len;
    }
}


 


 





 


void
md5_process_block (buffer, len, ctx)
     const void *buffer;
     size_t len;
     struct md5_ctx *ctx;
{
  md5_uint32 correct_words[16];
  const md5_uint32 *words = (const md5_uint32 *) buffer;
  size_t nwords = len / sizeof (md5_uint32);
  const md5_uint32 *endp = words + nwords;
  md5_uint32 A = ctx->A;
  md5_uint32 B = ctx->B;
  md5_uint32 C = ctx->C;
  md5_uint32 D = ctx->D;

   


  ctx->total[0] += len;
  if (ctx->total[0] < len)
    ++ctx->total[1];

   

  while (words < endp)
    {
      md5_uint32 *cwp = correct_words;
      md5_uint32 A_save = A;
      md5_uint32 B_save = B;
      md5_uint32 C_save = C;
      md5_uint32 D_save = D;

       







# 313 "md5.c"

       



       





       
      do	{	 A  += (    D   ^ (   B   & (    C   ^     D  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xd76aa478 ;	++words;	(  A   = (  A   <<      7  ) | (  A   >> (32 -      7  ))) ;	 A  +=   B ;	}	while (0) ;
      do	{	 D  += (    C   ^ (   A   & (    B   ^     C  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xe8c7b756 ;	++words;	(  D   = (  D   <<     12  ) | (  D   >> (32 -     12  ))) ;	 D  +=   A ;	}	while (0) ;
      do	{	 C  += (    B   ^ (   D   & (    A   ^     B  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0x242070db ;	++words;	(  C   = (  C   <<     17  ) | (  C   >> (32 -     17  ))) ;	 C  +=   D ;	}	while (0) ;
      do	{	 B  += (    A   ^ (   C   & (    D   ^     A  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xc1bdceee ;	++words;	(  B   = (  B   <<     22  ) | (  B   >> (32 -     22  ))) ;	 B  +=   C ;	}	while (0) ;
      do	{	 A  += (    D   ^ (   B   & (    C   ^     D  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xf57c0faf ;	++words;	(  A   = (  A   <<      7  ) | (  A   >> (32 -      7  ))) ;	 A  +=   B ;	}	while (0) ;
      do	{	 D  += (    C   ^ (   A   & (    B   ^     C  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0x4787c62a ;	++words;	(  D   = (  D   <<     12  ) | (  D   >> (32 -     12  ))) ;	 D  +=   A ;	}	while (0) ;
      do	{	 C  += (    B   ^ (   D   & (    A   ^     B  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xa8304613 ;	++words;	(  C   = (  C   <<     17  ) | (  C   >> (32 -     17  ))) ;	 C  +=   D ;	}	while (0) ;
      do	{	 B  += (    A   ^ (   C   & (    D   ^     A  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xfd469501 ;	++words;	(  B   = (  B   <<     22  ) | (  B   >> (32 -     22  ))) ;	 B  +=   C ;	}	while (0) ;
      do	{	 A  += (    D   ^ (   B   & (    C   ^     D  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0x698098d8 ;	++words;	(  A   = (  A   <<      7  ) | (  A   >> (32 -      7  ))) ;	 A  +=   B ;	}	while (0) ;
      do	{	 D  += (    C   ^ (   A   & (    B   ^     C  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0x8b44f7af ;	++words;	(  D   = (  D   <<     12  ) | (  D   >> (32 -     12  ))) ;	 D  +=   A ;	}	while (0) ;
      do	{	 C  += (    B   ^ (   D   & (    A   ^     B  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xffff5bb1 ;	++words;	(  C   = (  C   <<     17  ) | (  C   >> (32 -     17  ))) ;	 C  +=   D ;	}	while (0) ;
      do	{	 B  += (    A   ^ (   C   & (    D   ^     A  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0x895cd7be ;	++words;	(  B   = (  B   <<     22  ) | (  B   >> (32 -     22  ))) ;	 B  +=   C ;	}	while (0) ;
      do	{	 A  += (    D   ^ (   B   & (    C   ^     D  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0x6b901122 ;	++words;	(  A   = (  A   <<      7  ) | (  A   >> (32 -      7  ))) ;	 A  +=   B ;	}	while (0) ;
      do	{	 D  += (    C   ^ (   A   & (    B   ^     C  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xfd987193 ;	++words;	(  D   = (  D   <<     12  ) | (  D   >> (32 -     12  ))) ;	 D  +=   A ;	}	while (0) ;
      do	{	 C  += (    B   ^ (   D   & (    A   ^     B  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0xa679438e ;	++words;	(  C   = (  C   <<     17  ) | (  C   >> (32 -     17  ))) ;	 C  +=   D ;	}	while (0) ;
      do	{	 B  += (    A   ^ (   C   & (    D   ^     A  )))  + (*cwp++ = ( *words ) ) +   (md5_uint32) 0x49b40821 ;	++words;	(  B   = (  B   <<     22  ) | (  B   >> (32 -     22  ))) ;	 B  +=   C ;	}	while (0) ;

       














       
      do {	 A  += (        C     ^ (       D     & (      B     ^         C    )))    + correct_words[   1 ] +   (md5_uint32) 0xf61e2562 ;	(  A   = (  A   <<      5  ) | (  A   >> (32 -      5  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (        B     ^ (       C     & (      A     ^         B    )))    + correct_words[   6 ] +   (md5_uint32) 0xc040b340 ;	(  D   = (  D   <<      9  ) | (  D   >> (32 -      9  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (        A     ^ (       B     & (      D     ^         A    )))    + correct_words[  11 ] +   (md5_uint32) 0x265e5a51 ;	(  C   = (  C   <<     14  ) | (  C   >> (32 -     14  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (        D     ^ (       A     & (      C     ^         D    )))    + correct_words[   0 ] +   (md5_uint32) 0xe9b6c7aa ;	(  B   = (  B   <<     20  ) | (  B   >> (32 -     20  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (        C     ^ (       D     & (      B     ^         C    )))    + correct_words[   5 ] +   (md5_uint32) 0xd62f105d ;	(  A   = (  A   <<      5  ) | (  A   >> (32 -      5  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (        B     ^ (       C     & (      A     ^         B    )))    + correct_words[  10 ] +   (md5_uint32) 0x02441453 ;	(  D   = (  D   <<      9  ) | (  D   >> (32 -      9  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (        A     ^ (       B     & (      D     ^         A    )))    + correct_words[  15 ] +   (md5_uint32) 0xd8a1e681 ;	(  C   = (  C   <<     14  ) | (  C   >> (32 -     14  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (        D     ^ (       A     & (      C     ^         D    )))    + correct_words[   4 ] +   (md5_uint32) 0xe7d3fbc8 ;	(  B   = (  B   <<     20  ) | (  B   >> (32 -     20  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (        C     ^ (       D     & (      B     ^         C    )))    + correct_words[   9 ] +   (md5_uint32) 0x21e1cde6 ;	(  A   = (  A   <<      5  ) | (  A   >> (32 -      5  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (        B     ^ (       C     & (      A     ^         B    )))    + correct_words[  14 ] +   (md5_uint32) 0xc33707d6 ;	(  D   = (  D   <<      9  ) | (  D   >> (32 -      9  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (        A     ^ (       B     & (      D     ^         A    )))    + correct_words[   3 ] +   (md5_uint32) 0xf4d50d87 ;	(  C   = (  C   <<     14  ) | (  C   >> (32 -     14  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (        D     ^ (       A     & (      C     ^         D    )))    + correct_words[   8 ] +   (md5_uint32) 0x455a14ed ;	(  B   = (  B   <<     20  ) | (  B   >> (32 -     20  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (        C     ^ (       D     & (      B     ^         C    )))    + correct_words[  13 ] +   (md5_uint32) 0xa9e3e905 ;	(  A   = (  A   <<      5  ) | (  A   >> (32 -      5  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (        B     ^ (       C     & (      A     ^         B    )))    + correct_words[   2 ] +   (md5_uint32) 0xfcefa3f8 ;	(  D   = (  D   <<      9  ) | (  D   >> (32 -      9  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (        A     ^ (       B     & (      D     ^         A    )))    + correct_words[   7 ] +   (md5_uint32) 0x676f02d9 ;	(  C   = (  C   <<     14  ) | (  C   >> (32 -     14  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (        D     ^ (       A     & (      C     ^         D    )))    + correct_words[  12 ] +   (md5_uint32) 0x8d2a4c8a ;	(  B   = (  B   <<     20  ) | (  B   >> (32 -     20  ))) ;	 B  +=   C ;	}	while (0) ;




       
      do {	 A  += (    B    ^       C    ^       D   )   + correct_words[   5 ] +   (md5_uint32) 0xfffa3942 ;	(  A   = (  A   <<      4  ) | (  A   >> (32 -      4  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (    A    ^       B    ^       C   )   + correct_words[   8 ] +   (md5_uint32) 0x8771f681 ;	(  D   = (  D   <<     11  ) | (  D   >> (32 -     11  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (    D    ^       A    ^       B   )   + correct_words[  11 ] +   (md5_uint32) 0x6d9d6122 ;	(  C   = (  C   <<     16  ) | (  C   >> (32 -     16  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (    C    ^       D    ^       A   )   + correct_words[  14 ] +   (md5_uint32) 0xfde5380c ;	(  B   = (  B   <<     23  ) | (  B   >> (32 -     23  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (    B    ^       C    ^       D   )   + correct_words[   1 ] +   (md5_uint32) 0xa4beea44 ;	(  A   = (  A   <<      4  ) | (  A   >> (32 -      4  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (    A    ^       B    ^       C   )   + correct_words[   4 ] +   (md5_uint32) 0x4bdecfa9 ;	(  D   = (  D   <<     11  ) | (  D   >> (32 -     11  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (    D    ^       A    ^       B   )   + correct_words[   7 ] +   (md5_uint32) 0xf6bb4b60 ;	(  C   = (  C   <<     16  ) | (  C   >> (32 -     16  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (    C    ^       D    ^       A   )   + correct_words[  10 ] +   (md5_uint32) 0xbebfbc70 ;	(  B   = (  B   <<     23  ) | (  B   >> (32 -     23  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (    B    ^       C    ^       D   )   + correct_words[  13 ] +   (md5_uint32) 0x289b7ec6 ;	(  A   = (  A   <<      4  ) | (  A   >> (32 -      4  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (    A    ^       B    ^       C   )   + correct_words[   0 ] +   (md5_uint32) 0xeaa127fa ;	(  D   = (  D   <<     11  ) | (  D   >> (32 -     11  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (    D    ^       A    ^       B   )   + correct_words[   3 ] +   (md5_uint32) 0xd4ef3085 ;	(  C   = (  C   <<     16  ) | (  C   >> (32 -     16  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (    C    ^       D    ^       A   )   + correct_words[   6 ] +   (md5_uint32) 0x04881d05 ;	(  B   = (  B   <<     23  ) | (  B   >> (32 -     23  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (    B    ^       C    ^       D   )   + correct_words[   9 ] +   (md5_uint32) 0xd9d4d039 ;	(  A   = (  A   <<      4  ) | (  A   >> (32 -      4  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (    A    ^       B    ^       C   )   + correct_words[  12 ] +   (md5_uint32) 0xe6db99e5 ;	(  D   = (  D   <<     11  ) | (  D   >> (32 -     11  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (    D    ^       A    ^       B   )   + correct_words[  15 ] +   (md5_uint32) 0x1fa27cf8 ;	(  C   = (  C   <<     16  ) | (  C   >> (32 -     16  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (    C    ^       D    ^       A   )   + correct_words[   2 ] +   (md5_uint32) 0xc4ac5665 ;	(  B   = (  B   <<     23  ) | (  B   >> (32 -     23  ))) ;	 B  +=   C ;	}	while (0) ;




       
      do {	 A  += (      C    ^ (    B    | ~      D   ))   + correct_words[   0 ] +   (md5_uint32) 0xf4292244 ;	(  A   = (  A   <<      6  ) | (  A   >> (32 -      6  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (      B    ^ (    A    | ~      C   ))   + correct_words[   7 ] +   (md5_uint32) 0x432aff97 ;	(  D   = (  D   <<     10  ) | (  D   >> (32 -     10  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (      A    ^ (    D    | ~      B   ))   + correct_words[  14 ] +   (md5_uint32) 0xab9423a7 ;	(  C   = (  C   <<     15  ) | (  C   >> (32 -     15  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (      D    ^ (    C    | ~      A   ))   + correct_words[   5 ] +   (md5_uint32) 0xfc93a039 ;	(  B   = (  B   <<     21  ) | (  B   >> (32 -     21  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (      C    ^ (    B    | ~      D   ))   + correct_words[  12 ] +   (md5_uint32) 0x655b59c3 ;	(  A   = (  A   <<      6  ) | (  A   >> (32 -      6  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (      B    ^ (    A    | ~      C   ))   + correct_words[   3 ] +   (md5_uint32) 0x8f0ccc92 ;	(  D   = (  D   <<     10  ) | (  D   >> (32 -     10  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (      A    ^ (    D    | ~      B   ))   + correct_words[  10 ] +   (md5_uint32) 0xffeff47d ;	(  C   = (  C   <<     15  ) | (  C   >> (32 -     15  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (      D    ^ (    C    | ~      A   ))   + correct_words[   1 ] +   (md5_uint32) 0x85845dd1 ;	(  B   = (  B   <<     21  ) | (  B   >> (32 -     21  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (      C    ^ (    B    | ~      D   ))   + correct_words[   8 ] +   (md5_uint32) 0x6fa87e4f ;	(  A   = (  A   <<      6  ) | (  A   >> (32 -      6  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (      B    ^ (    A    | ~      C   ))   + correct_words[  15 ] +   (md5_uint32) 0xfe2ce6e0 ;	(  D   = (  D   <<     10  ) | (  D   >> (32 -     10  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (      A    ^ (    D    | ~      B   ))   + correct_words[   6 ] +   (md5_uint32) 0xa3014314 ;	(  C   = (  C   <<     15  ) | (  C   >> (32 -     15  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (      D    ^ (    C    | ~      A   ))   + correct_words[  13 ] +   (md5_uint32) 0x4e0811a1 ;	(  B   = (  B   <<     21  ) | (  B   >> (32 -     21  ))) ;	 B  +=   C ;	}	while (0) ;
      do {	 A  += (      C    ^ (    B    | ~      D   ))   + correct_words[   4 ] +   (md5_uint32) 0xf7537e82 ;	(  A   = (  A   <<      6  ) | (  A   >> (32 -      6  ))) ;	 A  +=   B ;	}	while (0) ;
      do {	 D  += (      B    ^ (    A    | ~      C   ))   + correct_words[  11 ] +   (md5_uint32) 0xbd3af235 ;	(  D   = (  D   <<     10  ) | (  D   >> (32 -     10  ))) ;	 D  +=   A ;	}	while (0) ;
      do {	 C  += (      A    ^ (    D    | ~      B   ))   + correct_words[   2 ] +   (md5_uint32) 0x2ad7d2bb ;	(  C   = (  C   <<     15  ) | (  C   >> (32 -     15  ))) ;	 C  +=   D ;	}	while (0) ;
      do {	 B  += (      D    ^ (    C    | ~      A   ))   + correct_words[   9 ] +   (md5_uint32) 0xeb86d391 ;	(  B   = (  B   <<     21  ) | (  B   >> (32 -     21  ))) ;	 B  +=   C ;	}	while (0) ;

       
      A += A_save;
      B += B_save;
      C += C_save;
      D += D_save;
    }

   
  ctx->A = A;
  ctx->B = B;
  ctx->C = C;
  ctx->D = D;
}
