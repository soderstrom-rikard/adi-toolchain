/************************************************************************
 *
 * complex.h
 *
 * (c) Copyright 1996-2007 Analog Devices, Inc.  All rights reserved.
 * $Revision: 1.18 $
 ************************************************************************/

#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* complex.h */
#endif

#ifndef __COMPLEX_DEFINED
#define __COMPLEX_DEFINED

#include <complex_typedef.h>

#ifdef _MISRA_RULES
#pragma diag(push)
#pragma diag(suppress:misra_rule_6_3)
#pragma diag(suppress:misra_rule_8_1)
#pragma diag(suppress:misra_rule_8_5)
#pragma diag(suppress:misra_rule_19_4)
#pragma diag(suppress:misra_rule_19_6)
#pragma diag(suppress:misra_rule_19_7)
#endif /* _MISRA_RULES */


#ifdef __cplusplus
  extern "C" {
#endif


/* * * *        cabs      * * * *
 *
 *    Complex absolute value
 *
 */

#pragma linkage_name __cabsf
        float cabsf (complex_float _a);

#pragma linkage_name __cabsd
        long double cabsd (complex_long_double _a);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __cabsf
#else
#pragma linkage_name __cabsd
#endif
        double cabs (complex_double _a);


#pragma linkage_name __cabs_fr16
        fract16 cabs_fr16 (complex_fract16 _a);




/* * * *        conj      * * * *
 *
 *    Complex conjugate
 *
 */

#pragma inline
#pragma always_inline
        static complex_float conjf (complex_float _a)
            {complex_float _c; _c.re = _a.re; _c.im = - _a.im; return _c;}

#pragma linkage_name __conjd
        complex_long_double conjd (complex_long_double _a);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
#pragma always_inline
        static complex_double conj (complex_double _a)
        {
           complex_double _c;
           _c.re =  _a.re;
           _c.im = -_a.im;
           return _c;
        }
#else
#pragma linkage_name __conjd
        complex_double conj (complex_double _a);
#endif

#pragma linkage_name __conj_fr16
        complex_fract16 conj_fr16 (complex_fract16 _a);




/* * * *        cadd      * * * *
 *
 *    Complex addition
 *
 */

#pragma inline
#pragma always_inline
        static complex_float caddf (complex_float _a,
                                    complex_float _b)
        {
           complex_float _c;
           _c.re = _a.re + _b.re;
           _c.im = _a.im + _b.im;
           return _c;
        }

#pragma linkage_name __caddd
        complex_long_double caddd (complex_long_double _a,
                                   complex_long_double _b);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
#pragma always_inline
        static complex_double cadd (complex_double _a,
                                    complex_double _b)
        {
           complex_double _c;
           _c.re = _a.re + _b.re;
           _c.im = _a.im + _b.im;
           return _c;
        }
#else
#pragma linkage_name __caddd
        complex_double cadd (complex_double _a, complex_double _b);
#endif


#if defined(__ADSPBLACKFIN__) && !defined(__NO_BUILTIN)
#define COMPFRACT(X) __builtin_compose_2x16((X).im, (X).re)
#define EXTRFRACT(R,X) \
  { \
    (R).re = __builtin_extract_lo(X); \
    (R).im = __builtin_extract_hi(X); \
  }
#pragma inline
#pragma always_inline
        static complex_fract16 cadd_fr16 (complex_fract16 _a,
                                          complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_add(COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }
#else
#pragma linkage_name __cadd_fr16
        complex_fract16 cadd_fr16 (complex_fract16 _a, complex_fract16 _b);
#endif




/* * * *        csub      * * * *
 *
 *    Complex subtraction
 *
 */

#pragma inline
#pragma always_inline
        static complex_float csubf (complex_float _a,
                                    complex_float _b)
        {
           complex_float _c;
           _c.re = _a.re - _b.re;
           _c.im = _a.im - _b.im;
           return _c;
        }

#pragma linkage_name __csubd
        complex_long_double csubd (complex_long_double _a,
                                   complex_long_double _b);

#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
#pragma always_inline
        static complex_double csub (complex_double _a,
                                    complex_double _b)
        {
           complex_double _c;
           _c.re = _a.re - _b.re;
           _c.im = _a.im - _b.im;
           return _c;
        }
#else
#pragma linkage_name __csubd
        complex_double csub (complex_double _a, complex_double _b);
#endif

#if defined(__ADSPBLACKFIN__) && !defined(__NO_BUILTIN)
#pragma inline
#pragma always_inline
        static complex_fract16 csub_fr16 (complex_fract16 _a,
                                          complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_sub(COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }
#else
#pragma linkage_name __csub_fr16
        complex_fract16 csub_fr16 (complex_fract16 _a, complex_fract16 _b);
#endif




/* * * *        cmlt      * * * *
 *
 *    Complex multiplication
 *
 */

#pragma inline
#pragma always_inline
        static complex_float cmltf (complex_float _a,
                                    complex_float _b)
        {
           complex_float _c;
           _c.re = (_a.re * _b.re) - (_a.im* + _b.im);
           _c.im = (_a.re * _b.im) + (_a.im* + _b.re);
           return _c;
        }

#pragma linkage_name __cmltd
        complex_long_double cmltd (complex_long_double _a,
                                   complex_long_double _b);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
#pragma always_inline
        static complex_double cmlt (complex_double _a,
                                    complex_double _b)
        {
           complex_double _c;
           _c.re = (_a.re * _b.re) - (_a.im* + _b.im);
           _c.im = (_a.re * _b.im) + (_a.im* + _b.re);
           return _c;
        }
#else
#pragma linkage_name __cmltd
        complex_double cmlt (complex_double _a,
                             complex_double _b);
#endif


#if defined(__ADSPBLACKFIN__) && !defined(__NO_BUILTIN)
#pragma inline
#pragma always_inline
        static complex_fract16 cmlt_fr16 (complex_fract16 _a,
                                          complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_mul(COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }
#else
#pragma linkage_name __cmlt_fr16
        complex_fract16 cmlt_fr16 (complex_fract16 _a, complex_fract16 _b);
#endif

#if defined(__ADSPBLACKFIN__) && !defined(__NO_BUILTIN)
#pragma inline
#pragma always_inline
        /*  Complex fract16 multiply accumulate operation with 32-bit internal
         **  saturation.
         */
        static complex_fract16 cmac_fr16 (complex_fract16 _sum,
                                          complex_fract16 _a,
                                          complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_mac(COMPFRACT(_sum),
           COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }

#pragma inline
#pragma always_inline
        /*  Complex fract16 multiply subtract operation with 32-bit internal
         **  saturation.
         */
        static complex_fract16 cmsu_fr16 (complex_fract16 _sum,
                                          complex_fract16 _a,
                                          complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_msu(COMPFRACT(_sum),
           COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }

#pragma inline
#pragma always_inline
        /*  Complex fract16 multiply accumulate operation with 40-bit internal
         **  saturation.
         */
        static complex_fract16 cmac_fr16_s40 (complex_fract16 _sum,
                                              complex_fract16 _a,
                                              complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_mac_s40(COMPFRACT(_sum),
           COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }

#pragma inline
#pragma always_inline
        /*  Complex fract16 multiply subtract operation with 40-bit internal
         **  saturation.
         */
        static complex_fract16 cmsu_fr16_s40 (complex_fract16 _sum,
                                              complex_fract16 _a,
                                              complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_msu_s40(COMPFRACT(_sum),
           COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }

#pragma inline
#pragma always_inline
         static fract16 csqu_add_fr16 (complex_fract16 _c)
         {
            return (fract16)__builtin_add_fr2x16(
                               __builtin_mult_fr2x16((int)_c.re, (int)_c.re),
                               __builtin_mult_fr2x16((int)_c.im, (int)_c.im));
         }

#pragma inline
#pragma always_inline
         static fract32 csqu_add_fr32 (complex_fract16 _c)
         {
            return __builtin_add_fr1x32(__builtin_mult_fr1x32(_c.re, _c.re),
                                        __builtin_mult_fr1x32(_c.im,_c.im));
         }

#pragma inline
#pragma always_inline
         static fract16 cdst_fr16 (complex_fract16 _x,
                                   complex_fract16 _y)
         {
            return (fract16)__builtin_add_fr2x16(
                               __builtin_mult_fr2x16(
                                  __builtin_sub_fr2x16((int)_x.re,(int)_y.re),
                                  __builtin_sub_fr2x16((int)_x.re,(int)_y.re)),
                               __builtin_mult_fr2x16(
                                  __builtin_sub_fr2x16((int)_x.im,(int)_y.im),
                                  __builtin_sub_fr2x16((int)_x.im,(int)_y.im)));
         }

#pragma inline
#pragma always_inline
         static fract32 cdst_fr32 (complex_fract16 _x,
                                   complex_fract16 _y)
         {
            return __builtin_add_fr1x32(
                      __builtin_mult_fr1x32(
                         (fract16)__builtin_sub_fr2x16((int)_x.re,(int)_y.re),
                         (fract16)__builtin_sub_fr2x16((int)_x.re,(int)_y.re)),
                      __builtin_mult_fr1x32(
                         (fract16)__builtin_sub_fr2x16((int)_x.im,(int)_y.im),
                         (fract16)__builtin_sub_fr2x16((int)_x.im,(int)_y.im)));
         }

#undef COMPFRACT
#undef EXTRFRACT
#endif /* __ADSPBLACKFIN__ */




/* * * *        cdiv      * * * *
 *
 *    Complex division
 *
 */

#pragma linkage_name __cdivf
        complex_float cdivf (complex_float _a, complex_float _b);

#pragma linkage_name __cdivd
        complex_long_double cdivd (complex_long_double _a,
                                   complex_long_double _b);

#ifdef __DOUBLES_ARE_FLOATS__

#pragma linkage_name __cdivf
#else
#pragma linkage_name __cdivd
#endif
        complex_double cdiv (complex_double _a, complex_double _b);


#pragma linkage_name __cdiv_fr16
        complex_fract16 cdiv_fr16 (complex_fract16 _a, complex_fract16 _b);




/* * * *        norm      * * * *
 *
 *    Normalize complex number
 *
 */

#pragma linkage_name __normf
        complex_float normf (complex_float _a);

#pragma linkage_name __normd
        complex_long_double normd (complex_long_double _a);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __normf
#else
#pragma linkage_name __normd
#endif
        complex_double norm (complex_double _a);




/* * * *        cexp      * * * *
 *
 *    Complex exponential e^x, where x is a real number
 *
 */

#pragma linkage_name __cexpf
        complex_float cexpf (float _x);

#pragma linkage_name __cexpd
        complex_long_double cexpd (long double _x);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __cexpf
#else
#pragma linkage_name __cexpd
#endif
        complex_double cexp (double _x);




/* * * *        arg      * * * *
 *
 *    Get phase of complex number
 *
 */

#pragma linkage_name __argf
        float argf (complex_float _a);

#pragma linkage_name __argd
        long double argd (complex_long_double _a);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __argf
#else
#pragma linkage_name __argd
#endif
        double arg (complex_double _a);


#pragma linkage_name __arg_fr16
        fract16 arg_fr16 (complex_fract16 _a);




/* * * *        polar      * * * *
 *
 *    Convert polar coordinates to cartesian notation
 *
 */

#pragma linkage_name __polarf
        complex_float polarf (float _magnitude, float _phase);

#pragma linkage_name __polard
        complex_long_double polard (long double _magnitude,
                                    long double _phase);

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __polarf
#else
#pragma linkage_name __polard
#endif
        complex_double polar (double _magnitude, double _phase);

#pragma linkage_name __polar_fr16
        complex_fract16 polar_fr16 (fract16 _magnitude, fract16 _phase);




/* * * *        cartesian  * * * *
 *
 *    Convert cartesian coordinates to polar notation
 *    (Return value == magnitude)
 *
 */

#pragma linkage_name __cartesianf
        float cartesianf (complex_float _a, float* _phase);

#pragma linkage_name __cartesiand
        long double cartesiand (complex_long_double _a, long double* _phase);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __cartesianf
#else
#pragma linkage_name __cartesiand
#endif
        double cartesian (complex_double _a, double* _phase);


#pragma linkage_name __cartesian_fr16
        fract16 cartesian_fr16 (complex_fract16 _a, fract16* _phase);


#if !defined(__NO_BUILTIN)

/* complex_fract32 support routines */

extern int        __builtin_real_fr32 (long long _a);
extern int        __builtin_imag_fr32 (long long _a);
extern long long  __builtin_cadd_fr32 (long long _a, long long _b);
extern long long  __builtin_csub_fr32 (long long _a, long long _b);
extern long long  __builtin_conj_fr32 (long long _a);
extern int        __builtin_csqu_fr16 (int _a);
extern long long  __builtin_compose_i64 (int _a, int _b);

#pragma inline
#pragma always_inline
        static complex_fract32 ccompose_fr32 (fract32 _real, fract32 _imag)
        {
           composite_complex_fract32 _x;
           _x.raw = __builtin_compose_i64(_real,_imag);
           return _x.x;
        }

#pragma inline
#pragma always_inline
        static fract32 real_fr32 (complex_fract32 _a)
        {
           composite_complex_fract32 _x;
           _x.x.re = _a.re; _x.x.im = _a.im;
           return __builtin_real_fr32(_x.raw);
        }

#pragma inline
#pragma always_inline
        static fract32 imag_fr32 (complex_fract32 _a)
        {
           composite_complex_fract32 _x;
           _x.x.re = _a.re; _x.x.im = _a.im;
           return __builtin_imag_fr32(_x.raw);
        }

#pragma inline
#pragma always_inline
        static complex_fract32 cadd_fr32 (complex_fract32 _a,
                                          complex_fract32 _b)
        {
           composite_complex_fract32 _x,_y;
           _x.x.re = _a.re; _x.x.im = _a.im;
           _y.x.re = _b.re; _y.x.im = _b.im;
           _y.raw = __builtin_cadd_fr32(_x.raw,_y.raw);
           return _y.x;
        }

#pragma inline
#pragma always_inline
        static complex_fract32 csub_fr32 (complex_fract32 _a,
                                          complex_fract32 _b)
        {
           composite_complex_fract32 _x, _y;
           _x.x.re = _a.re; _x.x.im = _a.im;
           _y.x.re = _b.re; _y.x.im = _b.im;
           _y.raw =  __builtin_csub_fr32(_x.raw,_y.raw);
           return _y.x;
        }

#pragma inline
#pragma always_inline
        static complex_fract32 conj_fr32 (complex_fract32 _a)
        {
           composite_complex_fract32 _x;
           _x.x.re = _a.re; _x.x.im = _a.im;
           _x.raw = __builtin_conj_fr32(_x.raw);
           return _x.x;
        }

extern complex_fract32 cmul_fr32 (complex_fract32 _a, complex_fract32 _b);

/* Other builtins */
#pragma inline
#pragma always_inline
        static complex_fract16 csqu_fr16 (complex_fract16 _a)
        {
           composite_complex_fract16 _x;
           _x.x.re = _a.re; _x.x.im = _a.im;
           _x.raw = __builtin_csqu_fr16(_x.raw);
           return _x.x;
        }
#endif /* !__NO_BUILTIN */

#ifdef __cplusplus
}       /* end extern "C" */
#endif


#ifdef _MISRA_RULES
#pragma diag(pop)
#endif /* _MISRA_RULES */


#endif   /* __COMPLEX_DEFINED  (include guard) */
