/************************************************************************
 *
 * fract_complex.h
 *
 * Copyright (C) 1996-2007 Analog Devices, Inc.
 * This file is subject to the terms and conditions of the GNU Lesser
 * General Public License. See the file COPYING.LIB for more details.
 *
 * Non-LGPL License is also available as part of VisualDSP++
 * from Analog Devices, Inc.
 *
 ************************************************************************/

#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* complex.h */
#endif

#ifndef __FRACT_COMPLEX_DEFINED
#define __FRACT_COMPLEX_DEFINED

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



        fract16 cabs_fr16 (complex_fract16 _a) asm ("__cabs_fr16");




/* * * *        conj      * * * *
 *
 *    Complex conjugate
 *
 */


        complex_fract16 conj_fr16 (complex_fract16 _a) asm ("__conj_fr16");




/* * * *        cadd      * * * *
 *
 *    Complex addition
 *
 */



#if defined(__ADSPBLACKFIN__) && !defined(__NO_BUILTIN)
#define COMPFRACT(X) __builtin_compose_2x16((X).im, (X).re)
#define EXTRFRACT(R,X) \
  { \
    (R).re = __builtin_extract_lo(X); \
    (R).im = __builtin_extract_hi(X); \
  }
#pragma inline
__attribute__ ((always_inline))
        static complex_fract16 cadd_fr16 (complex_fract16 _a,
                                          complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_add(COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }
#else
        complex_fract16 cadd_fr16 (complex_fract16 _a, complex_fract16 _b) asm ("__cadd_fr16");
#endif




/* * * *        csub      * * * *
 *
 *    Complex subtraction
 *
 */


#if defined(__ADSPBLACKFIN__) && !defined(__NO_BUILTIN)
#pragma inline
__attribute__ ((always_inline))
        static complex_fract16 csub_fr16 (complex_fract16 _a,
                                          complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_sub(COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }
#else
        complex_fract16 csub_fr16 (complex_fract16 _a, complex_fract16 _b) asm ("__csub_fr16");
#endif




/* * * *        cmlt      * * * *
 *
 *    Complex multiplication
 *
 */



#if defined(__ADSPBLACKFIN__) && !defined(__NO_BUILTIN)
#pragma inline
__attribute__ ((always_inline))
        static complex_fract16 cmlt_fr16 (complex_fract16 _a,
                                          complex_fract16 _b)
        {
           complex_fract16 r;
           int i = __builtin_cmplx_mul(COMPFRACT(_a), COMPFRACT(_b));
           EXTRFRACT(r,i);
           return r;
        }
#else
        complex_fract16 cmlt_fr16 (complex_fract16 _a, complex_fract16 _b) asm ("__cmlt_fr16");
#endif

#if defined(__ADSPBLACKFIN__) && !defined(__NO_BUILTIN)
#pragma inline
__attribute__ ((always_inline))
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
__attribute__ ((always_inline))
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
__attribute__ ((always_inline))
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
__attribute__ ((always_inline))
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
__attribute__ ((always_inline))
         static fract16 csqu_add_fr16 (complex_fract16 _c)
         {
            return (fract16)__builtin_add_fr2x16(
                               __builtin_mult_fr2x16((int)_c.re, (int)_c.re),
                               __builtin_mult_fr2x16((int)_c.im, (int)_c.im));
         }

#pragma inline
__attribute__ ((always_inline))
         static fract32 csqu_add_fr32 (complex_fract16 _c)
         {
            return __builtin_add_fr1x32(__builtin_mult_fr1x32(_c.re, _c.re),
                                        __builtin_mult_fr1x32(_c.im,_c.im));
         }

#pragma inline
__attribute__ ((always_inline))
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
__attribute__ ((always_inline))
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



        complex_fract16 cdiv_fr16 (complex_fract16 _a, complex_fract16 _b) asm ("__cdiv_fr16");








/* * * *        arg      * * * *
 *
 *    Get phase of complex number
 *
 */



        fract16 arg_fr16 (complex_fract16 _a) asm ("__arg_fr16");




/* * * *        polar      * * * *
 *
 *    Convert polar coordinates to cartesian notation
 *
 */


        complex_fract16 polar_fr16 (fract16 _magnitude, fract16 _phase) asm ("__polar_fr16");




/* * * *        cartesian  * * * *
 *
 *    Convert cartesian coordinates to polar notation
 *    (Return value == magnitude)
 *
 */



        fract16 cartesian_fr16 (complex_fract16 _a, fract16* _phase) asm ("__cartesian_fr16");


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
__attribute__ ((always_inline))
        static complex_fract32 ccompose_fr32 (fract32 _real, fract32 _imag)
        {
           composite_complex_fract32 _x;
           _x.raw = __builtin_compose_i64(_real,_imag);
           return _x.x;
        }

#pragma inline
__attribute__ ((always_inline))
        static fract32 real_fr32 (complex_fract32 _a)
        {
           composite_complex_fract32 _x;
           _x.x.re = _a.re; _x.x.im = _a.im;
           return __builtin_real_fr32(_x.raw);
        }

#pragma inline
__attribute__ ((always_inline))
        static fract32 imag_fr32 (complex_fract32 _a)
        {
           composite_complex_fract32 _x;
           _x.x.re = _a.re; _x.x.im = _a.im;
           return __builtin_imag_fr32(_x.raw);
        }

#pragma inline
__attribute__ ((always_inline))
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
__attribute__ ((always_inline))
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
__attribute__ ((always_inline))
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
__attribute__ ((always_inline))
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


#endif   /* __FRACT_COMPLEX_DEFINED  (include guard) */
