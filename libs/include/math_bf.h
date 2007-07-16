/************************************************************************
 *
 * math_bf.h
 *
 * (c) Copyright 2002-2006 Analog Devices, Inc.  All rights reserved.
 *
 ************************************************************************/

#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* math_bf.h */
#endif

/*
   This header file contains all ADSP Blackfin specific
   Analog extensions to the ANSI header file math.h.

   The header file is included by math.h by default.
   To disable the extensions, compile with the option:
        -D__NO_ANSI_EXTENSIONS__
 */
   
#ifndef  _MATH_BF_H
#define  _MATH_BF_H

#include <yvals.h>

#include <fract_typedef.h>
#include <fract_math.h>
#include <ccblkfn.h>

#ifdef _MISRA_RULES
#pragma diag(push)
#pragma diag(suppress:misra_rule_5_7)
#pragma diag(suppress:misra_rule_6_3)
#pragma diag(suppress:misra_rule_8_1)
#pragma diag(suppress:misra_rule_8_5)
#pragma diag(suppress:misra_rule_18_4)
#pragma diag(suppress:misra_rule_19_4)
#endif /* _MISRA_RULES */


_C_STD_BEGIN
_C_LIB_DECL

/* * * *        acos     * * * *
 *    Arc cosine
 */
#pragma linkage_name __acos_fr16
        fract16 acos_fr16 (fract16 _x);


/* * * *        alog     * * * *
 *    Natural anti-log
 */
#pragma linkage_name __alogf
        float alogf (float _x);

#pragma linkage_name __alogd
        long double alogd (long double _x);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __alogf
        double alog (double _x);
#else
#pragma linkage_name __alogd
        double alog (double _x);
#endif


/* * * *        alog10   * * * *
 *    Base-10 anti-log
 */
#pragma linkage_name __alog10f
        float alog10f (float _x);

#pragma linkage_name __alog10d
        long double alog10d (long double _x);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __alog10f
        double alog10 (double _x);
#else
#pragma linkage_name __alog10d
        double alog10 (double _x);
#endif


/* * * *        asin     * * * *
 *    Arc sine
 */
#pragma linkage_name __asin_fr16
        fract16 asin_fr16 (fract16 _x);


/* * * *        atan     * * * *
 *    Arc tangent
 */
#pragma linkage_name __atan_fr16
        fract16 atan_fr16 (fract16 _x);


/* * * *        atan2    * * * *
 *    Arc tangent of quotient
 */
#pragma linkage_name __atan2_fr16
        fract16 atan2_fr16 (fract16 _x, fract16 _y);


/* * * *        cos      * * * *
 *    Cosine
 */
#pragma linkage_name __cos_fr16
        fract16 cos_fr16 (fract16 _x);


/* * * *        rsqrt    * * * *
 *    Inverse Square Root
 */
#pragma linkage_name __rsqrtf
        float rsqrtf (float _x);

#pragma linkage_name __rsqrtd
        long double rsqrtd (long double _x);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __rsqrtf
        double rsqrt (double _x);
#else
#pragma linkage_name __rsqrtd
        double rsqrt (double _x);
#endif


/* * * *        sin      * * * *
 *    Sine
 */
#pragma linkage_name __sin_fr16
        fract16 sin_fr16 (fract16 _x);


/* * * *        sqrt     * * * *
 *    Square Root
 */
#pragma linkage_name __sqrt_fr16
        fract16 sqrt_fr16 (fract16 _x);


/* * * *        tan      * * * *
 *    Tangent
 */
#pragma linkage_name __tan_fr16
        fract16 tan_fr16 (fract16 _x);


/* * * *        max      * * * *
 *    Maximum value
 */

#if !defined(__NO_BUILTIN)
#pragma inline
#pragma always_inline
        static float fmaxf(float _x, float _y) 
                { float res;
                  if (_x > _y) {
                   res = _x;
                  } else {
                   res = _y;
                  }
                  return res;
                }

#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
#pragma always_inline
        static float fmax(double _x, double _y) 
                { float res;
                  if (_x > _y) {
                   res = (float)_x;
                  } else {
                   res = (float)_y;
                  }
                  return res;
                }
#endif 
#else 
#pragma linkage_name __fmaxf
        float fmaxf(float _x, float _y);

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __fmaxf
        double fmax(double _x, double _y);
#endif
#endif

#pragma linkage_name __fmaxd
        long double fmaxd(long double _x, long double _y);

#if !defined( __DOUBLES_ARE_FLOATS__)
#pragma linkage_name __fmaxd
        double fmax(double _x, double _y);
#endif


#if !defined(__NO_BUILTIN) 
        int __builtin_max(int, int);
#pragma inline
#pragma always_inline
        static int max(int _x, int _y) 
                { return __builtin_max(_x,_y); }

        long __builtin_lmax(long, long);
#pragma inline
#pragma always_inline
        static long lmax(long _x, long _y)
          { return __builtin_lmax(_x, _y); }
#else
#pragma linkage_name __max
        int max (int _x, int _y);

#pragma linkage_name __max
        long lmax (long _x, long _y);

#endif /* NO_BUILTIN */

#pragma linkage_name __llmax
        long long  llmax (long long  _x, long long  _y);


/* * * *        min      * * * *
 *    Minimum value
 */

#if !defined(__NO_BUILTIN) 
#pragma inline
#pragma always_inline
        static float fminf(float _x, float _y) 
                { float res;
                  if (_x < _y) {
                   res = _x;
                  } else {
                   res = _y;
                  }
                  return res;
                }

#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
#pragma always_inline
        static float fmin(double _x, double _y) 
                { float res;
                  if (_x < _y) {
                   res = (float)_x;
                  } else {
                   res = (float)_y;
                  }
                  return res;
                }
#endif
#else
#pragma linkage_name __fminf
        float fminf(float _x, float _y);

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __fminf
        double fmin(double _x, double _y);
#endif
#endif

#pragma linkage_name __fmind
        long double fmind(long double _x, long double _y);

#if !defined(__DOUBLES_ARE_FLOATS__)
#pragma linkage_name __fmind
        double fmin(double _x, double _y);
#endif


#if !defined(__NO_BUILTIN)
        int __builtin_min(int, int);
#pragma inline
#pragma always_inline
        static int min(int _x, int _y) 
                { return __builtin_min(_x,_y); }

        long __builtin_lmin(long, long);
#pragma inline
#pragma always_inline
        static long lmin(long _x, long _y)
                { return __builtin_lmin(_x,_y); }
#else
#pragma linkage_name __min
        int min (int _x, int _y);

#pragma linkage_name __min
        long lmin (long _x, long _y);
#endif

#pragma linkage_name __llmin
        long long  llmin (long long  _x, long long  _y);


/* * * *        clip     * * * *
 *    Clip value to limit
 *
 */
#pragma linkage_name __fclipf
        float fclipf (float _value, float _limit);

#pragma linkage_name __fclipd
        long double fclipd (long double _value, long double _limit);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __fclipf
#else
#pragma linkage_name __fclipd
#endif
        double fclip (double _value, double _limit);


#pragma linkage_name __clip_fr16
        fract16 clip_fr16 (fract16 _value, fract16 _limit);


#pragma linkage_name __clip
        int clip (int _value, int _limit);

        long lclip (long _value, long _limit);

#pragma linkage_name __llclip
        long long  llclip (long long  _value, long long  _limit);


/* * * *        copysign   * * * *
 *    Copy Sign of y (=reference) to x (=value)
 */
#pragma linkage_name __copysignf
        float copysignf (float _x, float _y);

#pragma linkage_name __copysignd
        long double copysignd (long double _x, long double _y);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __copysignf
        double copysign (double _x, double _y);
#else
#pragma linkage_name __copysignd
        double copysign (double _x, double _y);
#endif


#pragma linkage_name __copysign_fr16
        fract16 copysign_fr16 (fract16 _x, fract16 _y);


/* * * *        countones  * * * *
 *    Count number of 1 bits (parity)
 */
#if !defined(__NO_BUILTIN)
#pragma inline
#pragma always_inline
        static int countones (int _x) 
                { return (int)__builtin_ones(_x); }
#pragma inline
#pragma always_inline
        static int lcountones (long _x) 
                { return (int)__builtin_ones((int)_x); }
#else
#pragma linkage_name __countones
        int countones (int _x);

#pragma linkage_name __lcountones
        int lcountones (long _x);
#endif /* __NO_BUILTIN */

#pragma linkage_name __llcountones
        int  llcountones (long long  _x);


/* * * *        isinf      * * * *
 *      Is number +/- Infinity?
 */
#if !defined(__NO_BUILTIN)
#pragma inline
#pragma always_inline
        static int isinff(float _x) {
                union { float _xx; unsigned long _l; } _v;
                _v._xx = _x;
                return (_v._l & 0x7fffffffu) == 0x7f800000u;
        }

#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
#pragma always_inline
        static int isinf(double _x) {
                union { double _xx; unsigned long _l; } _v;
                _v._xx = _x;
                return (_v._l & 0x7fffffffu) == 0x7f800000u;
        }
#endif
#else
#pragma linkage_name _isinf
        int isinff(float _x);

#ifdef __DOUBLES_ARE_FLOATS__
        int isinf(double _x);
#endif
#endif /* !__NO_BUILTIN */


#pragma linkage_name _isinfd
        int isinfd(long double _x);

#if !defined(__DOUBLES_ARE_FLOATS__)
#pragma linkage_name _isinfd
        int isinf(double _x);
#endif


/* * * *        isnan           * * * *
 *      Is number Not A Number?
 */
#if !defined(__NO_BUILTIN)
#pragma inline
#pragma always_inline
        static int isnanf(float _x) {
                union { float _xx; unsigned long _l; } _v;
                _v._xx = _x;
                return (_v._l & 0x7fffffffu) > 0x7f800000uL;
        }

#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
#pragma always_inline
        static int isnan(double _x) {
                union { double _xx; unsigned long _l; } _v;
                _v._xx = _x;
                return (_v._l & 0x7fffffffu) > 0x7f800000uL;
        }
#endif
#else
#pragma linkage_name _isnan
        int isnanf(float _x);

#ifdef __DOUBLES_ARE_FLOATS__
        int isnan(double _x);
#endif
#endif /* !__NO_BUILTIN */


#pragma linkage_name _isnand
        int isnand(long double _x);

#if !defined(__DOUBLES_ARE_FLOATS__)
#pragma linkage_name _isnand
        int isnan(double _x);
#endif



_END_C_LIB_DECL
_C_STD_END

#ifdef _MISRA_RULES
#pragma diag(pop)
#endif /* _MISRA_RULES */

#endif   /* _MATH_BF_H */
