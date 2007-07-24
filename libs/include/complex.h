/************************************************************************
 *
 * complex.h
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

#ifndef __COMPLEX_DEFINED
#define __COMPLEX_DEFINED

#include <complex_typedef.h>
#include <complex_bf.h>

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

        float cabsf (complex_float _a) asm ("__cabsf");

        long double cabsd (complex_long_double _a) asm ("__cabsd");


#ifdef __DOUBLES_ARE_FLOATS__
        double cabs (complex_double _a) asm ("__cabsf");
#else
        double cabs (complex_double _a) asm ("__cabsd");
#endif






/* * * *        conj      * * * *
 *
 *    Complex conjugate
 *
 */

#pragma inline
__attribute__ ((always_inline))
        static complex_float conjf (complex_float _a)
            {complex_float _c; _c.re = _a.re; _c.im = - _a.im; return _c;}

        complex_long_double conjd (complex_long_double _a) asm ("__conjd");


#ifdef __DOUBLES_ARE_FLOATS__
#pragma inline
__attribute__ ((always_inline))
        static complex_double conj (complex_double _a)
        {
           complex_double _c;
           _c.re =  _a.re;
           _c.im = -_a.im;
           return _c;
        }
#else
        complex_double conj (complex_double _a) asm ("__conjd");
#endif





/* * * *        cexp      * * * *
 *
 *    Complex exponential e^x, where x is a real number
 *
 */

        complex_float cexpf (float _x) asm ("__cexpf");

        complex_long_double cexpd (long double _x) asm ("__cexpd");


#ifdef __DOUBLES_ARE_FLOATS__
        complex_double cexp (double _x) asm ("__cexpf");
#else
        complex_double cexp (double _x) asm ("__cexpd");
#endif




/* * * *        arg      * * * *
 *
 *    Get phase of complex number
 *
 */

        float argf (complex_float _a) asm ("__argf");

        long double argd (complex_long_double _a) asm ("__argd");


#ifdef __DOUBLES_ARE_FLOATS__
        double arg (complex_double _a) asm ("__argf");
#else
        double arg (complex_double _a) asm ("__argd");
#endif



#ifdef __cplusplus
}       /* end extern "C" */
#endif


#ifdef _MISRA_RULES
#pragma diag(pop)
#endif /* _MISRA_RULES */


#endif   /* __COMPLEX_DEFINED  (include guard) */
