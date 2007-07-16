/************************************************************************
 *
 * fract2float_conv.h
 *
 * (c) Copyright 2000-2007 Analog Devices, Inc.  All rights reserved.
 *
 ************************************************************************/

#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* fract2float_conv.h */
#endif

#ifndef _FRACT2FLOAT_CONV_H
#define _FRACT2FLOAT_CONV_H

/* Conversions between fract16 or fract32 and floats. */

#include <fract_typedef.h>

#ifdef _MISRA_RULES
#pragma diag(push)
#pragma diag(suppress:misra_rule_2_4)
#pragma diag(suppress:misra_rule_6_3)
#pragma diag(suppress:misra_rule_8_5)
#endif /* _MISRA_RULES */

/* Conversions between fract{16|32}'s and floats. */

#ifdef __cplusplus
extern "C" {
#endif

    static fract32 fr16_to_fr32(fract16 _x);
#pragma inline
#pragma always_inline
    static fract32 fr16_to_fr32(fract16 _x) {
       /* convert a fract16 to a fract32 */
       unsigned int val = ((unsigned int)(_x)) << 16;
       return (fract32)val;
    }

    static fract16 fr32_to_fr16(fract32 _x);
#pragma inline
#pragma always_inline
    static fract16 fr32_to_fr16(fract32 _x) {
       /* Convert a fract32 to a fract16. */
       unsigned int val = (unsigned int)_x >> 16;
       return (fract16)val;
    }

    fract32 float_to_fr32 (float _x);
    fract16 float_to_fr16 (float _x);

    float   fr32_to_float (fract32 _x);
    float   fr16_to_float (fract16 _x);

#ifdef __cplusplus
}
#endif

#ifdef _MISRA_RULES
#pragma diag(pop)
#endif /* _MISRA_RULES */

#endif /* _FRACT2FLOAT_CONV_H */
