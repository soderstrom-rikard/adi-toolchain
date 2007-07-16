#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* fr2x16_math.h */
#endif
/************************************************************************
 *
 * fr2x16_math.h
 *
 * (c) Copyright 2000-2006 Analog Devices, Inc.  All rights reserved.
 *
 ************************************************************************/

/* Standard library functions for two packed fractional values. */

#ifndef _FR2x16_MATH_H
#define _FR2x16_MATH_H

#include <fract_typedef.h>  /* get definitions for fract16 and fract32 */
#include <fr2x16_base.h>
#include <fr2x16_typedef.h>

#ifdef _MISRA_RULES
#pragma diag(push)
#pragma diag(suppress:misra_rule_2_4)
#pragma diag(suppress:misra_rule_5_3)
#pragma diag(suppress:misra_rule_5_7)
#pragma diag(suppress:misra_rule_6_3)
#pragma diag(suppress:misra_rule_8_1)
#pragma diag(suppress:misra_rule_8_5)
#endif /* _MISRA_RULES */



/*
 * Standard functions:
 * abs({a,b})		=> {abs(a), abs(b)}
 * min({a,b},{c,d})	=> {min(a,c),min(b,d)}
 * max({a,b},{c,d})	=> {max(a,c),max(b,d)}
 */

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __NO_BUILTIN
#pragma inline
#pragma always_inline
static fract2x16 abs_fr2x16(fract2x16 _x) {
	return __builtin_abs_fr2x16(_x);
}
#pragma inline
#pragma always_inline
static fract2x16 min_fr2x16(fract2x16 _x, fract2x16 _y) {
	return __builtin_min_fr2x16(_x, _y);
}
#pragma inline
#pragma always_inline
static fract2x16 max_fr2x16(fract2x16 _x, fract2x16 _y) {
	return __builtin_max_fr2x16(_x, _y);
}

/*
extern fract2x16 __builtin_dspaddsubsat(fract2x16, fract2x16);
extern fract2x16 __builtin_dspsubaddsat(fract2x16, fract2x16);
extern fract16 __builtin_diff_hl_fr2x16(fr2x16);
extern fract16 __builtin_diff_lh_fr2x16(fr2x16); */

#pragma inline
#pragma always_inline
static fract2x16 add_as_fr2x16(fract2x16 x,fract2x16 y) {
        return __builtin_dspaddsubsat(x,y);
        }

#pragma inline
#pragma always_inline
static fract2x16 add_sa_fr2x16(fract2x16 x,fract2x16 y) {
        return __builtin_dspsubaddsat(x,y);
        }

#pragma inline
#pragma always_inline
static fract16 diff_hl_fr2x16(fr2x16 x) {
        return __builtin_diff_hl_fr2x16(x);
        }

#pragma inline
#pragma always_inline
static fract16 diff_lh_fr2x16(fr2x16 x) {
        return __builtin_diff_lh_fr2x16(x);
        }

#endif /* __NO_BUILTIN */

/*
 * Cross-over multiplication:
 * ll({a,b}, {c,d})	=> a*c
 * lh({a,b}, {c,d})	=> a*d
 * hl({a,b}, {c,d})	=> b*c
 * hh({a,b}, {c,d})	=> b*d
 */

#pragma inline
#pragma always_inline
static fract32 mult_ll_fr2x16(fract2x16 _x, fract2x16 _y) {
        return (fract32)low_of_fr2x16(_x)*(fract32)low_of_fr2x16(_y);
}
#pragma inline
#pragma always_inline
static fract32 mult_hl_fr2x16(fract2x16 _x, fract2x16 _y) {
	return (fract32)high_of_fr2x16(_x)*(fract32)low_of_fr2x16(_y);
}
#pragma inline
#pragma always_inline
static fract32 mult_lh_fr2x16(fract2x16 _x, fract2x16 _y) {
	return (fract32)low_of_fr2x16(_x)*(fract32)high_of_fr2x16(_y);
}
#pragma inline
#pragma always_inline
static fract32 mult_hh_fr2x16(fract2x16 _x, fract2x16 _y) {
	return (fract32)high_of_fr2x16(_x)*(fract32)high_of_fr2x16(_y);
}

#ifdef __cplusplus
}
#endif

#ifdef _MISRA_RULES
#pragma diag(pop)
#endif /* _MISRA_RULES */

#endif /* _FR2x16_MATH_H */
