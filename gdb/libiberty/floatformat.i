# 1 "floatformat.c"
 


















# 1 "../include/ansidecl.h" 1
 


















 
































































































 

 

 









 








 


 












 
 





 




 












 














# 235 "../include/ansidecl.h"


 







 








 
















 








 












 














 







# 20 "floatformat.c" 2

# 1 "../include/floatformat.h" 1
 























 





 

enum floatformat_byteorders {

   


  floatformat_little,

   


  floatformat_big,

   


  floatformat_littlebyte_bigword

};

enum floatformat_intbit { floatformat_intbit_yes, floatformat_intbit_no };

struct floatformat
{
  enum floatformat_byteorders byteorder;
  unsigned int totalsize;	 

   
  unsigned int sign_start;

  unsigned int exp_start;
  unsigned int exp_len;
   
  unsigned int exp_bias;
   


  unsigned int exp_nan;

  unsigned int man_start;
  unsigned int man_len;

   
  enum floatformat_intbit intbit;

   
  const char *name;
};

 

extern const struct floatformat floatformat_ieee_single_big;
extern const struct floatformat floatformat_ieee_single_little;
extern const struct floatformat floatformat_ieee_double_big;
extern const struct floatformat floatformat_ieee_double_little;

 

extern const struct floatformat floatformat_ieee_double_littlebyte_bigword;

 

extern const struct floatformat floatformat_i387_ext;
extern const struct floatformat floatformat_m68881_ext;
extern const struct floatformat floatformat_i960_ext;
extern const struct floatformat floatformat_m88110_ext;
extern const struct floatformat floatformat_m88110_harris_ext;
extern const struct floatformat floatformat_arm_ext_big;
extern const struct floatformat floatformat_arm_ext_littlebyte_bigword;
 
extern const struct floatformat floatformat_ia64_spill_big;
extern const struct floatformat floatformat_ia64_spill_little;
extern const struct floatformat floatformat_ia64_quad_big;
extern const struct floatformat floatformat_ia64_quad_little;

 



extern void
floatformat_to_double  (const struct floatformat *, const char *, double *)  ;

 


extern void
floatformat_from_double  (const struct floatformat *,
				 const double *, char *)  ;

 

extern int
floatformat_is_valid  (const struct floatformat *fmt, const char *from)  ;


# 21 "floatformat.c" 2

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 1 3
 


















 






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




# 27 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 2 3


 

 

# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/huge_val.h" 1 3
 



















   
 







 
















# 63 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/huge_val.h" 3



 

# 106 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/huge_val.h" 3

# 33 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 2 3


 



 
# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/mathdef.h" 1 3
 





















# 40 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/mathdef.h" 3



 

 



# 40 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 2 3



 



















# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/mathcalls.h" 1 3
 


















 






























 

 
extern   double          acos          (double  __x)      ; extern   double         __acos          (double  __x)        ;
 
extern   double          asin          (double  __x)      ; extern   double         __asin          (double  __x)        ;
 
extern   double          atan          (double  __x)      ; extern   double         __atan          (double  __x)        ;
 
extern   double          atan2          (double  __y, double  __x)      ; extern   double         __atan2          (double  __y, double  __x)        ;

 
extern   double          cos          (double  __x)      ; extern   double         __cos          (double  __x)        ;
 
extern   double          sin          (double  __x)      ; extern   double         __sin          (double  __x)        ;
 
extern   double          tan          (double  __x)      ; extern   double         __tan          (double  __x)        ;







 

 
extern   double          cosh          (double  __x)      ; extern   double         __cosh          (double  __x)        ;
 
extern   double          sinh          (double  __x)      ; extern   double         __sinh          (double  __x)        ;
 
extern   double          tanh          (double  __x)      ; extern   double         __tanh          (double  __x)        ;


 
extern   double          acosh          (double  __x)      ; extern   double         __acosh          (double  __x)        ;
 
extern   double          asinh          (double  __x)      ; extern   double         __asinh          (double  __x)        ;
 
extern   double          atanh          (double  __x)      ; extern   double         __atanh          (double  __x)        ;


 

 
extern   double          exp          (double  __x)      ; extern   double         __exp          (double  __x)        ;








 
extern   double          frexp          (double  __x, int *__exponent)      ; extern   double         __frexp          (double  __x, int *__exponent)        ;

 
extern   double          ldexp          (double  __x, int __exponent)      ; extern   double         __ldexp          (double  __x, int __exponent)        ;

 
extern   double          log          (double  __x)      ; extern   double         __log          (double  __x)        ;

 
extern   double          log10          (double  __x)      ; extern   double         __log10          (double  __x)        ;

 
extern   double          modf          (double  __x, double  *__iptr)      ; extern   double         __modf          (double  __x, double  *__iptr)        ;


 
extern   double          expm1          (double  __x)      ; extern   double         __expm1          (double  __x)        ;

 
extern   double          log1p          (double  __x)      ; extern   double         __log1p          (double  __x)        ;

 
extern   double          logb          (double  __x)      ; extern   double         __logb          (double  __x)        ;











 

 
extern   double          pow          (double  __x, double  __y)      ; extern   double         __pow          (double  __x, double  __y)        ;

 
extern   double          sqrt          (double  __x)      ; extern   double         __sqrt          (double  __x)        ;


 
extern   double          hypot          (double  __x, double  __y)      ; extern   double         __hypot          (double  __x, double  __y)        ;



 
extern   double          cbrt          (double  __x)      ; extern   double         __cbrt          (double  __x)        ;



 

 
extern   double          ceil          (double  __x)      ; extern   double         __ceil          (double  __x)        ;

 
extern   double          fabs          (double  __x)       __attribute__ (    (__const__)  ); extern   double         __fabs          (double  __x)       __attribute__ (    (__const__)  )  ;

 
extern   double          floor          (double  __x)      ; extern   double         __floor          (double  __x)        ;

 
extern   double          fmod          (double  __x, double  __y)      ; extern   double         __fmod          (double  __x, double  __y)        ;


 

extern  int     __isinf      (double  __value)     __attribute__ ((__const__));

 
extern  int     __finite      (double  __value)     __attribute__ ((__const__));


 

extern  int     isinf      (double  __value)     __attribute__ ((__const__));

 
extern  int     finite      (double  __value)     __attribute__ ((__const__));

 
extern   double          drem          (double  __x, double  __y)      ; extern   double         __drem          (double  __x, double  __y)        ;


 
extern   double          significand          (double  __x)      ; extern   double         __significand          (double  __x)        ;



 
extern   double          copysign          (double  __x, double  __y)       __attribute__ (    (__const__)  ); extern   double         __copysign          (double  __x, double  __y)       __attribute__ (    (__const__)  )  ;








 
extern  int     __isnan      (double  __value)     __attribute__ ((__const__));


 
extern  int     isnan      (double  __value)     __attribute__ ((__const__));

 
extern   double          j0          (double )      ; extern   double         __j0          (double )        ;
extern   double          j1          (double )      ; extern   double         __j1          (double )        ;
extern   double          jn          (int, double )      ; extern   double         __jn          (int, double )        ;
extern   double          y0          (double )      ; extern   double         __y0          (double )        ;
extern   double          y1          (double )      ; extern   double         __y1          (double )        ;
extern   double          yn          (int, double )      ; extern   double         __yn          (int, double )        ;




 
extern   double          erf          (double )      ; extern   double         __erf          (double )        ;
extern   double          erfc          (double )      ; extern   double         __erfc          (double )        ;
extern   double          lgamma          (double )      ; extern   double         __lgamma          (double )        ;







 
extern   double          gamma          (double )      ; extern   double         __gamma          (double )        ;



 


extern   double          lgamma_r              (double , int *__signgamp)      ; extern   double         __lgamma_r              (double , int *__signgamp)        ;




 

extern   double          rint          (double  __x)      ; extern   double         __rint          (double  __x)        ;

 
extern   double          nextafter          (double  __x, double  __y)       __attribute__ (    (__const__)  ); extern   double         __nextafter          (double  __x, double  __y)       __attribute__ (    (__const__)  )  ;




 
extern   double          remainder          (double  __x, double  __y)      ; extern   double         __remainder          (double  __x, double  __y)        ;


 
extern   double          scalb          (double  __x, double  __n)      ; extern   double         __scalb          (double  __x, double  __n)        ;



 
extern   double          scalbn          (double  __x, int __n)      ; extern   double         __scalbn          (double  __x, int __n)        ;


 
extern   int        ilogb        (double  __x)     ; extern   int        __ilogb        (double  __x)      ;


# 333 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/mathcalls.h" 3

# 63 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 2 3







 











# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/mathcalls.h" 1 3
 


















 






























 

 
extern   float          acosf         (float   __x)      ; extern   float         __acosf         (float   __x)        ;
 
extern   float          asinf         (float   __x)      ; extern   float         __asinf         (float   __x)        ;
 
extern   float          atanf         (float   __x)      ; extern   float         __atanf         (float   __x)        ;
 
extern   float          atan2f         (float   __y, float   __x)      ; extern   float         __atan2f         (float   __y, float   __x)        ;

 
extern   float          cosf         (float   __x)      ; extern   float         __cosf         (float   __x)        ;
 
extern   float          sinf         (float   __x)      ; extern   float         __sinf         (float   __x)        ;
 
extern   float          tanf         (float   __x)      ; extern   float         __tanf         (float   __x)        ;







 

 
extern   float          coshf         (float   __x)      ; extern   float         __coshf         (float   __x)        ;
 
extern   float          sinhf         (float   __x)      ; extern   float         __sinhf         (float   __x)        ;
 
extern   float          tanhf         (float   __x)      ; extern   float         __tanhf         (float   __x)        ;


 
extern   float          acoshf         (float   __x)      ; extern   float         __acoshf         (float   __x)        ;
 
extern   float          asinhf         (float   __x)      ; extern   float         __asinhf         (float   __x)        ;
 
extern   float          atanhf         (float   __x)      ; extern   float         __atanhf         (float   __x)        ;


 

 
extern   float          expf         (float   __x)      ; extern   float         __expf         (float   __x)        ;








 
extern   float          frexpf         (float   __x, int *__exponent)      ; extern   float         __frexpf         (float   __x, int *__exponent)        ;

 
extern   float          ldexpf         (float   __x, int __exponent)      ; extern   float         __ldexpf         (float   __x, int __exponent)        ;

 
extern   float          logf         (float   __x)      ; extern   float         __logf         (float   __x)        ;

 
extern   float          log10f         (float   __x)      ; extern   float         __log10f         (float   __x)        ;

 
extern   float          modff         (float   __x, float   *__iptr)      ; extern   float         __modff         (float   __x, float   *__iptr)        ;


 
extern   float          expm1f         (float   __x)      ; extern   float         __expm1f         (float   __x)        ;

 
extern   float          log1pf         (float   __x)      ; extern   float         __log1pf         (float   __x)        ;

 
extern   float          logbf         (float   __x)      ; extern   float         __logbf         (float   __x)        ;











 

 
extern   float          powf         (float   __x, float   __y)      ; extern   float         __powf         (float   __x, float   __y)        ;

 
extern   float          sqrtf         (float   __x)      ; extern   float         __sqrtf         (float   __x)        ;


 
extern   float          hypotf         (float   __x, float   __y)      ; extern   float         __hypotf         (float   __x, float   __y)        ;



 
extern   float          cbrtf         (float   __x)      ; extern   float         __cbrtf         (float   __x)        ;



 

 
extern   float          ceilf         (float   __x)      ; extern   float         __ceilf         (float   __x)        ;

 
extern   float          fabsf         (float   __x)       __attribute__ (    (__const__)  ); extern   float         __fabsf         (float   __x)       __attribute__ (    (__const__)  )  ;

 
extern   float          floorf         (float   __x)      ; extern   float         __floorf         (float   __x)        ;

 
extern   float          fmodf         (float   __x, float   __y)      ; extern   float         __fmodf         (float   __x, float   __y)        ;


 

extern  int    __isinff     (float   __value)     __attribute__ ((__const__));

 
extern  int    __finitef     (float   __value)     __attribute__ ((__const__));


 

extern  int    isinff     (float   __value)     __attribute__ ((__const__));

 
extern  int    finitef     (float   __value)     __attribute__ ((__const__));

 
extern   float          dremf         (float   __x, float   __y)      ; extern   float         __dremf         (float   __x, float   __y)        ;


 
extern   float          significandf         (float   __x)      ; extern   float         __significandf         (float   __x)        ;



 
extern   float          copysignf         (float   __x, float   __y)       __attribute__ (    (__const__)  ); extern   float         __copysignf         (float   __x, float   __y)       __attribute__ (    (__const__)  )  ;








 
extern  int    __isnanf     (float   __value)     __attribute__ ((__const__));


 
extern  int    isnanf     (float   __value)     __attribute__ ((__const__));

 
extern   float          j0f         (float  )      ; extern   float         __j0f         (float  )        ;
extern   float          j1f         (float  )      ; extern   float         __j1f         (float  )        ;
extern   float          jnf         (int, float  )      ; extern   float         __jnf         (int, float  )        ;
extern   float          y0f         (float  )      ; extern   float         __y0f         (float  )        ;
extern   float          y1f         (float  )      ; extern   float         __y1f         (float  )        ;
extern   float          ynf         (int, float  )      ; extern   float         __ynf         (int, float  )        ;




 
extern   float          erff         (float  )      ; extern   float         __erff         (float  )        ;
extern   float          erfcf         (float  )      ; extern   float         __erfcf         (float  )        ;
extern   float          lgammaf         (float  )      ; extern   float         __lgammaf         (float  )        ;







 
extern   float          gammaf         (float  )      ; extern   float         __gammaf         (float  )        ;



 


extern   float          lgammaf_r            (float  , int *__signgamp)      ; extern   float         __lgammaf_r            (float  , int *__signgamp)        ;




 

extern   float          rintf         (float   __x)      ; extern   float         __rintf         (float   __x)        ;

 
extern   float          nextafterf         (float   __x, float   __y)       __attribute__ (    (__const__)  ); extern   float         __nextafterf         (float   __x, float   __y)       __attribute__ (    (__const__)  )  ;




 
extern   float          remainderf         (float   __x, float   __y)      ; extern   float         __remainderf         (float   __x, float   __y)        ;


 
extern   float          scalbf         (float   __x, float   __n)      ; extern   float         __scalbf         (float   __x, float   __n)        ;



 
extern   float          scalbnf         (float   __x, int __n)      ; extern   float         __scalbnf         (float   __x, int __n)        ;


 
extern   int       ilogbf       (float   __x)     ; extern   int       __ilogbf       (float   __x)      ;


# 333 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/bits/mathcalls.h" 3

# 82 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 2 3




# 103 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 3









 
extern int signgam;



 
# 236 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 3



 
typedef enum
{
  _IEEE_ = -1,	 
  _SVID_,	 
  _XOPEN_,	 
  _POSIX_,
  _ISOC_	 
} _LIB_VERSION_TYPE;

 


extern _LIB_VERSION_TYPE _LIB_VERSION;




 







struct exception

  {
    int type;
    char *name;
    double arg1;
    double arg2;
    double retval;
  };




extern int matherr (struct exception *__exc);




 







 












 
















 


# 338 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 3



 






 





# 409 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/../../../../nisa-elf/include/math.h" 3


 



# 22 "floatformat.c" 2


# 1 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 1 3






 







 

 




 


 





 


# 61 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3


 





 


















 





 

 





















typedef long int ptrdiff_t;









 




 

 


































typedef long unsigned int size_t;






















 




 





























 


























typedef int wchar_t;
























typedef unsigned int  wint_t;




 

 

# 317 "/opt/uClinux/blackfin/lib/gcc-lib/nisa-elf/2.95.3/include/stddef.h" 3




 













 







# 24 "floatformat.c" 2

extern void *memcpy (void *s1, const void *s2, size_t n);
extern void *memset (void *s, int c, size_t n);





 




 
const struct floatformat floatformat_ieee_single_big =
{
  floatformat_big, 32, 0, 1, 8, 127, 255, 9, 23,
  floatformat_intbit_no,
  "floatformat_ieee_single_big"
};
const struct floatformat floatformat_ieee_single_little =
{
  floatformat_little, 32, 0, 1, 8, 127, 255, 9, 23,
  floatformat_intbit_no,
  "floatformat_ieee_single_little"
};
const struct floatformat floatformat_ieee_double_big =
{
  floatformat_big, 64, 0, 1, 11, 1023, 2047, 12, 52,
  floatformat_intbit_no,
  "floatformat_ieee_double_big"
};
const struct floatformat floatformat_ieee_double_little =
{
  floatformat_little, 64, 0, 1, 11, 1023, 2047, 12, 52,
  floatformat_intbit_no,
  "floatformat_ieee_double_little"
};

 


const struct floatformat floatformat_ieee_double_littlebyte_bigword =
{
  floatformat_littlebyte_bigword, 64, 0, 1, 11, 1023, 2047, 12, 52,
  floatformat_intbit_no,
  "floatformat_ieee_double_littlebyte_bigword"
};

const struct floatformat floatformat_i387_ext =
{
  floatformat_little, 80, 0, 1, 15, 0x3fff, 0x7fff, 16, 64,
  floatformat_intbit_yes,
  "floatformat_i387_ext"
};
const struct floatformat floatformat_m68881_ext =
{
   
  floatformat_big, 96, 0, 1, 15, 0x3fff, 0x7fff, 32, 64,
  floatformat_intbit_yes,
  "floatformat_m68881_ext"
};
const struct floatformat floatformat_i960_ext =
{
   
  floatformat_little, 96, 16, 17, 15, 0x3fff, 0x7fff, 32, 64,
  floatformat_intbit_yes,
  "floatformat_i960_ext"
};
const struct floatformat floatformat_m88110_ext =
{
  floatformat_big, 80, 0, 1, 15, 0x3fff, 0x7fff, 16, 64,
  floatformat_intbit_yes,
  "floatformat_m88110_ext"
};
const struct floatformat floatformat_m88110_harris_ext =
{
   

  floatformat_big,128, 0, 1, 11,  0x3ff,  0x7ff, 12, 52,
  floatformat_intbit_no,
  "floatformat_m88110_ext_harris"
};
const struct floatformat floatformat_arm_ext_big =
{
   
  floatformat_big, 96, 0, 17, 15, 0x3fff, 0x7fff, 32, 64,
  floatformat_intbit_yes,
  "floatformat_arm_ext_big"
};
const struct floatformat floatformat_arm_ext_littlebyte_bigword =
{
   
  floatformat_littlebyte_bigword, 96, 0, 17, 15, 0x3fff, 0x7fff, 32, 64,
  floatformat_intbit_yes,
  "floatformat_arm_ext_littlebyte_bigword"
};
const struct floatformat floatformat_ia64_spill_big =
{
  floatformat_big, 128, 0, 1, 17, 65535, 0x1ffff, 18, 64,
  floatformat_intbit_yes,
  "floatformat_ia64_spill_big"
};
const struct floatformat floatformat_ia64_spill_little =
{
  floatformat_little, 128, 0, 1, 17, 65535, 0x1ffff, 18, 64,
  floatformat_intbit_yes,
  "floatformat_ia64_spill_little"
};
const struct floatformat floatformat_ia64_quad_big =
{
  floatformat_big, 128, 0, 1, 15, 16383, 0x7fff, 16, 112,
  floatformat_intbit_no,
  "floatformat_ia64_quad_big"
};
const struct floatformat floatformat_ia64_quad_little =
{
  floatformat_little, 128, 0, 1, 15, 16383, 0x7fff, 16, 112,
  floatformat_intbit_no,
  "floatformat_ia64_quad_little"
};

static unsigned long get_field  (const unsigned char *,
					enum floatformat_byteorders,
					unsigned int,
					unsigned int,
					unsigned int)  ;

 

static unsigned long
get_field (data, order, total_len, start, len)
     const unsigned char *data;
     enum floatformat_byteorders order;
     unsigned int total_len;
     unsigned int start;
     unsigned int len;
{
  unsigned long result;
  unsigned int cur_byte;
  int cur_bitshift;

   
  cur_byte = (start + len) / 8 ;
  if (order == floatformat_little)
    cur_byte = (total_len / 8 ) - cur_byte - 1;
  cur_bitshift =
    ((start + len) % 8 ) - 8 ;
  result = *(data + cur_byte) >> (-cur_bitshift);
  cur_bitshift += 8 ;
  if (order == floatformat_little)
    ++cur_byte;
  else
    --cur_byte;

   
  while ((unsigned int) cur_bitshift < len)
    {
      if (len - cur_bitshift < 8 )
	 

	result |=
	  (*(data + cur_byte) & ((1 << (len - cur_bitshift)) - 1))
	    << cur_bitshift;
      else
	result |= *(data + cur_byte) << cur_bitshift;
      cur_bitshift += 8 ;
      if (order == floatformat_little)
	++cur_byte;
      else
	--cur_byte;
    }
  return result;
}
  




 



void
floatformat_to_double (fmt, from, to)
     const struct floatformat *fmt;
     const char *from;
     double *to;
{
  const unsigned char *ufrom = (const unsigned char *)from;
  double dto;
  long exponent;
  unsigned long mant;
  unsigned int mant_bits, mant_off;
  int mant_bits_left;
  int special_exponent;		 

  exponent = get_field (ufrom, fmt->byteorder, fmt->totalsize,
			fmt->exp_start, fmt->exp_len);
   



  mant_bits_left = fmt->man_len;
  mant_off = fmt->man_start;
  dto = 0.0;

  special_exponent = exponent == 0 || (unsigned long) exponent == fmt->exp_nan;

   
  if (!special_exponent)
    exponent -= fmt->exp_bias;

   


   


  if (!special_exponent)
    {
      if (fmt->intbit == floatformat_intbit_no)
	dto = ldexp (1.0, exponent);
      else
	exponent++;
    }

  while (mant_bits_left > 0)
    {
      mant_bits = (( mant_bits_left ) < (  32 ) ? ( mant_bits_left ) : (  32 )) ;

      mant = get_field (ufrom, fmt->byteorder, fmt->totalsize,
			 mant_off, mant_bits);

      dto += ldexp ((double)mant, exponent - mant_bits);
      exponent -= mant_bits;
      mant_off += mant_bits;
      mant_bits_left -= mant_bits;
    }

   
  if (get_field (ufrom, fmt->byteorder, fmt->totalsize, fmt->sign_start, 1))
    dto = -dto;
  *to = dto;
}

static void put_field  (unsigned char *, enum floatformat_byteorders,
			       unsigned int,
			       unsigned int,
			       unsigned int,
			       unsigned long)  ;

 

static void
put_field (data, order, total_len, start, len, stuff_to_put)
     unsigned char *data;
     enum floatformat_byteorders order;
     unsigned int total_len;
     unsigned int start;
     unsigned int len;
     unsigned long stuff_to_put;
{
  unsigned int cur_byte;
  int cur_bitshift;

   
  cur_byte = (start + len) / 8 ;
  if (order == floatformat_little)
    cur_byte = (total_len / 8 ) - cur_byte - 1;
  cur_bitshift =
    ((start + len) % 8 ) - 8 ;
  *(data + cur_byte) &=
    ~(((1 << ((start + len) % 8 )) - 1) << (-cur_bitshift));
  *(data + cur_byte) |=
    (stuff_to_put & ((1 << 8 ) - 1)) << (-cur_bitshift);
  cur_bitshift += 8 ;
  if (order == floatformat_little)
    ++cur_byte;
  else
    --cur_byte;

   
  while ((unsigned int) cur_bitshift < len)
    {
      if (len - cur_bitshift < 8 )
	{
	   
	  *(data + cur_byte) &=
	    ~((1 << (len - cur_bitshift)) - 1);
	  *(data + cur_byte) |= (stuff_to_put >> cur_bitshift);
	}
      else
	*(data + cur_byte) = ((stuff_to_put >> cur_bitshift)
			      & ((1 << 8 ) - 1));
      cur_bitshift += 8 ;
      if (order == floatformat_little)
	++cur_byte;
      else
	--cur_byte;
    }
}

 



void
floatformat_from_double (fmt, from, to)
     const struct floatformat *fmt;
     const double *from;
     char *to;
{
  double dfrom;
  int exponent;
  double mant;
  unsigned int mant_bits, mant_off;
  int mant_bits_left;
  unsigned char *uto = (unsigned char *)to;

  memcpy (&dfrom, from, sizeof (dfrom));
  memset (uto, 0, fmt->totalsize / 8 );
  if (dfrom == 0)
    return;			 
  if (dfrom != dfrom)
    {
       
      put_field (uto, fmt->byteorder, fmt->totalsize, fmt->exp_start,
		 fmt->exp_len, fmt->exp_nan);
       
      put_field (uto, fmt->byteorder, fmt->totalsize, fmt->man_start,
		 32, 1);
      return;
    }

   
  if (dfrom < 0)
    {
      put_field (uto, fmt->byteorder, fmt->totalsize, fmt->sign_start, 1, 1);
      dfrom = -dfrom;
    }

   

  mant = frexp (dfrom, &exponent);
  put_field (uto, fmt->byteorder, fmt->totalsize, fmt->exp_start, fmt->exp_len,
	     exponent + fmt->exp_bias - 1);

  mant_bits_left = fmt->man_len;
  mant_off = fmt->man_start;
  while (mant_bits_left > 0)
    {
      unsigned long mant_long;
      mant_bits = mant_bits_left < 32 ? mant_bits_left : 32;

      mant *= 4294967296.0;
      mant_long = (unsigned long)mant;
      mant -= mant_long;

       



      if ((unsigned int) mant_bits_left == fmt->man_len
	  && fmt->intbit == floatformat_intbit_no)
	{
	  mant_long &= 0x7fffffff;
	  mant_bits -= 1;
	}
      else if (mant_bits < 32)
	{
	   

	  mant_long >>= 32 - mant_bits;
	}

      put_field (uto, fmt->byteorder, fmt->totalsize,
		 mant_off, mant_bits, mant_long);
      mant_off += mant_bits;
      mant_bits_left -= mant_bits;
    }
}

 

int
floatformat_is_valid (fmt, from)
     const struct floatformat *fmt;
     const char *from;
{
  if (fmt == &floatformat_i387_ext)
    {
       




      unsigned long exponent, int_bit;
      const unsigned char *ufrom = (const unsigned char *) from;

      exponent = get_field (ufrom, fmt->byteorder, fmt->totalsize,
			    fmt->exp_start, fmt->exp_len);
      int_bit = get_field (ufrom, fmt->byteorder, fmt->totalsize,
			   fmt->man_start, 1);

      if ((exponent == 0) != (int_bit == 0))
	return 0;
      else
	return 1;
    }

   

  return 1;
}


# 485 "floatformat.c"

