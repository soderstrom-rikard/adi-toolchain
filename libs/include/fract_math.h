#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* fract_math.h */
#endif
/************************************************************************
 *
 * fract_math.h
 *
 * (c) Copyright 2000-2007 Analog Devices, Inc.  All rights reserved.
 *
 ************************************************************************/

/* Definitions of math.h-style functions for fractional types. */

#ifndef _FRACT_MATH_H
#define _FRACT_MATH_H

#include <fract_typedef.h>
#include <ccblkfn.h>
#include <fr2x16_math.h>

#ifdef _MISRA_RULES
#pragma diag(push)
#pragma diag(suppress:misra_rule_2_4)
#pragma diag(suppress:misra_rule_6_3)
#pragma diag(suppress:misra_rule_8_1)
#pragma diag(suppress:misra_rule_8_5)
#pragma diag(suppress:misra_rule_18_4)
#pragma diag(suppress:misra_rule_19_1)
#pragma diag(suppress:misra_rule_19_4)
#pragma diag(suppress:misra_rule_19_6)
#pragma diag(suppress:misra_rule_19_7)
#pragma diag(suppress:misra_rule_20_1)
#endif /* _MISRA_RULES */


#if !defined(__NO_BUILTIN)
#ifdef __cplusplus
extern "C" {
#endif

/****************************************/
/*                                      */
/*   fract16 and fract2x16 arithmetic   */
/*                                      */
/****************************************/

/* Adds two packed fracts.
 * Input: _x{a,b} _y{c,d}
 * Returns: {a+c,b+d} */
#pragma inline
#pragma always_inline
static fract2x16 add_fr2x16(fract2x16 _x, fract2x16 _y)
  { return __builtin_add_fr2x16(_x,_y); }

/* Performs 16-bit addition of the two input parameters (_x+_y) */
#pragma inline
#pragma always_inline
static fract16 add_fr1x16(fract16 _x, fract16 _y)
  { return __builtin_add_fr1x16(_x,_y); }

/* Subtracts two packed fracts.
 * Input: _x{a,b} _y{c,d}
 * Returns: {a-c,b-d} */
#pragma inline
#pragma always_inline
static fract2x16 sub_fr2x16(fract2x16 _x, fract2x16 _y)
  { return __builtin_sub_fr2x16(_x,_y); }

/* Performs 16-bit subtraction of the two input parameters (_x-_y) */
#pragma inline
#pragma always_inline
static fract16 sub_fr1x16(fract16 _x, fract16 _y)
  { return __builtin_sub_fr1x16(_x,_y); }

/* Multiplies two packed fracts.  Truncates the results to 16 bits.
 * Inputs: _x{a,b} _y{c,d}
 * Returns: {trunc16(a*c),trunc16(b*d)} */
#pragma inline
#pragma always_inline
static fract2x16 mult_fr2x16(fract2x16 _x, fract2x16 _y)
  { return __builtin_mult_fr2x16(_x,_y); }

/* Performs 16-bit multiplication of the input parameters (_x*_y). 
 * The result is truncated to 16 bits. */
#pragma inline
#pragma always_inline
static fract16 mult_fr1x16(fract16 _x, fract16 _y)
  { return __builtin_mult_fr1x16(_x,_y); }

/* Multiplies two packed fracts.  Rounds the result to 16 bits.  Whether the 
 * rounding is biased or unbiased depends on what the RND_MOD bit in the ASTAT 
 * register is set to.
 * Input: _x{a,b} _y{c,d}
 *  Returns: {round16{a*c},round16{b*d}} */
#pragma inline
#pragma always_inline
static fract2x16 multr_fr2x16(fract2x16 _x, fract2x16 _y)
  { return __builtin_multr_fr2x16(_x,_y); }

/* Performs a 16-bit fractional multiplication (_x*_y) of the two input 
 * parameters. The result is rounded to 16 bits. Whether the rounding is biased
 * or unbiased depends what the RND_MOD bit in the ASTAT register is set to. */
#pragma inline
#pragma always_inline
static fract16 multr_fr1x16(fract16 _x, fract16 _y) 
  { return __builtin_multr_fr1x16(_x,_y); }

/* Negates both 16 bit fracts in the packed fract.  If one of the fract16 values 
 * is 0x8000, saturation occurs and 0x7fff is the result of the negation.
 * Input: _x{a,b}
 * Returns: {-a,-b} */
#pragma inline
#pragma always_inline
static fract2x16 negate_fr2x16(fract2x16 _x)
  { return __builtin_negate_fr2x16(_x); }

/* Returns the 16-bit result of the negation of the input parameter (-_x).  If 
 * the input is 0x8000, saturation occurs and 0x7fff is returned. */
#pragma inline
#pragma always_inline
static fract16 negate_fr1x16(fract16 _x)
  { return (fract16)__builtin_negate_fr2x16((int)_x); }

/* Arithmetically shifts both fract16s in the fract2x16 left by _y places,and 
 * returns the packed result.  The empty bits are zero filled.  If shft is 
 * negative, the shift is to the right by abs(shft) places with sign extension.
 * 
 * WARNING: All the bits except for the lowest 5 bits of
 * _y are ignored.  If you want to shift by numbers larger than 5 bit signed ints,
 * you should use shl_fr2x16_clip.
 *
 * Inputs: _x{a,b} _y
 * Returns: {a<<shft,b<<shft} */
#pragma inline
#pragma always_inline
static fract2x16 shl_fr2x16(fract2x16 _x, int _y)
  { return __builtin_shl_fr2x16(_x,(short)_y); }

/* Arithmetically shifts both fract16s in the fract2x16 left by _y places,and 
 * returns the packed result.  The empty bits are zero filled.  If shft is 
 * negative, the shift is to the right by abs(_y) places with sign extension.
 * 
 * This avoids the limitation whereby all the bits 
 * except the lowest 5 bits of _y are ignored.
 *
 * Inputs: _x{a,b} _y
 * Returns: {a<<_y,b<<_y} 
 */
#pragma inline
#pragma always_inline
static fract2x16 shl_fr2x16_clip(fract2x16 _x, int _y)
	{ return __builtin_shl_fr2x16(_x,(fract16)__builtin_max(__builtin_min(_y,15),-16)); }

/* Arithmetically shifts the src variable left by _y places.  The empty bits 
 * are zero filled. If shft is negative, the shift is to the right by abs(_y)
 * places with sign extension.
 *
 * WARNING: All the bits except for the lowest 5 bits
 * of _y are ignored.  To shift by numbers larger than 5 bit signed
 * ints, shl_fr1x16_clip should be used. 
 */
#pragma inline
#pragma always_inline
static fract16 shl_fr1x16(fract16 _x, int _y)
  { return __builtin_shl_fr1x16(_x,(short)_y); }

/* Arithmetically shifts the src variable left by _y places.  The empty bits 
 * are zero filled. If shft is negative, the shift is to the right by abs(shft)
 * places with sign extension.
 *
 * This clipping variant allows shifts of numbers that are too big to be
 * represented in 5 bits. 
 */
#pragma inline
#pragma always_inline
static fract16 shl_fr1x16_clip(fract16 _x, int _y)
  { return __builtin_shl_fr1x16(_x,(fract16)__builtin_max(__builtin_min(_y,15),-16)); }

/* Arithmetically shifts both fract16s in the fract2x16 right by shft places 
 * with sign extension, and returns the packed result.  If shft is negative, 
 * the shift is to the left by abs(shft) places, and the empty bits are zero 
 * filled.
 *
 * WARNING: All the bits except for the lowest 5 bits of
 * _y are ignored.  If you want to shift by numbers larger than 5 bit signed ints,
 * you should use shr_fr2x16_clip.
 *
 * Inputs: _x{a,b} _y
 * Returns: {a<<shft,b<<shft} 
 */
#pragma inline
#pragma always_inline
static fract2x16 shr_fr2x16(fract2x16 _x, int _y)
  { return __builtin_shr_fr2x16(_x,(short)_y); }

/* Arithmetically shifts both fract16s in the fract2x16 right by shft places 
 * with sign extension, and returns the packed result.  If shft is negative, 
 * the shift is to the left by abs(_y) places, and the empty bits are zero 
 * filled.
 *
 * This clipping variant allows shifts of numbers that are too big to be
 * represented in 5 bits. 
 */
#pragma inline
#pragma always_inline
static fract2x16 shr_fr2x16_clip(fract2x16 _x, int _y)
  { return __builtin_shr_fr2x16(_x,(short)__builtin_max(__builtin_min(_y,16),-15)); }

/* Arithmetically shifts the src variable right by shft places with sign 
 * extension.  If shft is negative, the shift is to the left by abs(_y) places, 
 * and the empty bits are zero filled.
 *
 * WARNING: All the bits except for the lowest 5 bits of
 * _y are ignored.  If you want to shift by numbers larger than 5 bit signed ints,
 * you should use shr_fr1x16_clip.
 */
#pragma inline
#pragma always_inline
static fract16 shr_fr1x16(fract16 _x, int _y)
  { return (fract16)__builtin_shr_fr1x16(_x,(short)_y); }

/* Arithmetically shifts the src variable right by shft places with sign 
 * extension.  If shft is negative, the shift is to the left by abs(_y) places, 
 * and the empty bits are zero filled.
 *
 * This clipping variant allows shifts of numbers that are too big to be
 * represented in 5 bits. 
 */
#pragma inline
#pragma always_inline
static fract16 shr_fr1x16_clip(fract16 _x, int _y)
  { return (fract16)__builtin_shr_fr1x16(_x,(fract16)__builtin_max(__builtin_min(_y,16),-15)); }


/* Logically shifts both fract16s in the fract2x16 right by shft places.  There
 * is no sign extension and no saturation - the empty bits are zero filled.
 *
 * WARNING: All the bits except for the lowest 5 bits of
 * _y are ignored.  If you want to shift by numbers larger than 5 bit signed ints,
 * you should use shrl_fr2x16_clip.
 */
#pragma inline
#pragma always_inline
static fract2x16 shrl_fr2x16(fract2x16 _x, int _y)
	{ return __builtin_shrl_fr2x16(_x,(short)_y); }

/* Logically shifts both fract16s in the fract2x16 right by shft places.  There
 * is no sign extension and no saturation - the empty bits are zero filled.
 *
 * This clipping variant allows shifts of numbers that are too big to be
 * represented in 5 bits. 
 */
#pragma inline
#pragma always_inline
static fract2x16 shrl_fr2x16_clip(fract2x16 _x, int _y)
	{ return __builtin_shrl_fr2x16(_x,(short)__builtin_max(__builtin_min(_y,16),-15)); }


/* Logically shifts a fract16 right by shft places.  There is no sign extension
 * and no saturation - the empty bits are zero filled.
 *
 * WARNING: All the bits except for the lowest 5 bits of
 * _y are ignored.  If you want to shift by numbers larger than 5 bit signed ints,
 * you should use shrl_fr1x16_clip.
 */
#pragma inline
#pragma always_inline
static fract16 shrl_fr1x16(fract16 _x, int _y)
	{ return (fract16)__builtin_shrl_fr2x16((int)_x,(short)_y); }

/* Logically shifts a fract16 right by _x places.  There is no sign extension
 * and no saturation - the empty bits are zero filled.
 *
 * This clipping variant allows shifts of numbers that are too big to be
 * represented in 5 bits. 
 */
#pragma inline
#pragma always_inline
static fract16 shrl_fr1x16_clip(fract16 _x, int _y)
	{ return (fract16)__builtin_shrl_fr2x16((int)_x,(short)__builtin_max(__builtin_min(_y,16),-15)); }



/**************************/
/*                        */
/*   fract32 arithmetic   */
/*                        */
/**************************/

/* Performs 32-bit addition of the two input parameters (_x+_y). */
#pragma inline
#pragma always_inline
static fract32 add_fr1x32(fract32 _x, fract32 _y)
  { return __builtin_add_fr1x32(_x,_y); }

/* Performs 32-bit subtraction of the two input parameters (_x-_y). */
#pragma inline
#pragma always_inline
static fract32 sub_fr1x32(fract32 _x, fract32 _y)
  { return __builtin_sub_fr1x32(_x,_y); }

/* Performs 32-bit multiplication of the input parameters (_x*_y).  
 * The result (which is calculated internally with an accuracy of 40 bits) 
 * is rounded (biased rounding) to 32 bits.  */
#pragma inline
#pragma always_inline
static fract32 mult_fr1x32x32(fract32 _x, fract32 _y)
  { return __builtin_mult_fr1x32x32(_x,_y); }

/* Performs 32-bit non-saturating multiplication of the input parameters 
 * (_x*_y). This is somewhat faster than mult_fr1x32x32. The result (which is 
 * calculated internally with an accuracy of 40 bits) is rounded (biased 
 * rounding) to 32 bits.  */
#pragma inline
#pragma always_inline
static fract32 mult_fr1x32x32NS(fract32 _x, fract32 _y)
  { return __builtin_mult_fr1x32x32NS(_x,_y); }

/* Returns the 32-bit value that is the absolute value of the input parameter.
 * Where the input is 0x80000000, saturation occurs and 0x7fffffff is returned.
 */
#pragma inline
#pragma always_inline
static fract32 abs_fr1x32(fract32 _x)
  { return __builtin_abs_fr1x32(_x); }

/* Returns the 32-bit result of the negation of the input parameter (-_x).  If
 * the input is 0x80000000, saturation occurs and 0x7fffffff is returned.  */
#pragma inline
#pragma always_inline
static fract32 negate_fr1x32(fract32 _x) {
  return __builtin_negate_fr1x32(_x);
}

/* Returns the minimum of the two input parameters */
#pragma inline
#pragma always_inline
static fract32 min_fr1x32(fract32 _x, fract32 _y)
  { return __builtin_min_fr1x32(_x,_y); }

/* Returns the maximum of the two input parameters */
#pragma inline
#pragma always_inline
static fract32 max_fr1x32(fract32 _x, fract32 _y)
  { return __builtin_max_fr1x32(_x,_y); }

/* Arithmetically shifts the src variable left by shft places.  The empty bits 
 * are zero filled. If shft is negative, the shift is to the right by abs(shft)
 * places with sign extension.
 *
 * WARNING: All the bits except for the lowest 6 bits of
 * _y are ignored.  If you want to shift by numbers larger than 6 bit signed ints,
 * you should use shl_fr1x32_clip.
*/
#pragma inline
#pragma always_inline
static fract32 shl_fr1x32(fract32 _x, int _y)
  { return __builtin_shl_fr1x32(_x,(short)_y); }

/* Arithmetically shifts the src variable left by shft places.  The empty bits 
 * are zero filled. If shft is negative, the shift is to the right by abs(_y)
 * places with sign extension.
 *
 * This clipping variant allows shifts of numbers that are too big to be represented
 * in 6 bits.
*/
#pragma inline
#pragma always_inline
static fract32 shl_fr1x32_clip(fract32 _x, int _y)
	{ return __builtin_shl_fr1x32(_x,(fract16)__builtin_max(__builtin_min(_y,31),-32)); }

/* Arithmetically shifts the src variable right by shft places with sign 
 * extension.  If shft is negative, the shift is to the left by abs(_y) places, 
 * and the empty bits are zero filled.
 *
 * WARNING: All the bits except for the lowest 6 bits of
 * _y are ignored.  If you want to shift by numbers larger than 6 bit signed ints,
 * you should use shr_fr1x32_clip.
*/
#pragma inline
#pragma always_inline
static fract32 shr_fr1x32(fract32 _x, int _y)
  { return __builtin_shr_fr1x32(_x,(short)_y); }

/* Arithmetically shifts the src variable right by shft places with sign 
 * extension.  If shft is negative, the shift is to the left by abs(_y) places, 
 * and the empty bits are zero filled.
 *
 * This clipping variant allows shifts of numbers that are too big to be represented
 * in 6 bits.
*/
#pragma inline
#pragma always_inline
static fract32 shr_fr1x32_clip(fract32 _x, int _y)
	{ return __builtin_shr_fr1x32(_x,(short)__builtin_max(__builtin_min(_y,32),-31)); }

/* Performs a fractional multiplication on two 16-bit fractions, returning the 
 * 32-bit result. There will be loss of precision. */
#pragma inline
#pragma always_inline
static fract32 mult_fr1x32(fract16 _x, fract16 _y)
  { return __builtin_mult_fr1x32(_x,_y); }

/*****************************/
/*                           */
/*   Conversion operations   */
/*                           */
/*****************************/

/* If _x>0x00007fff, returns 0x7fff. If _x<0xffff8000, returns 0x8000.
   Otherwise returns the lower 16 bits of _x. */
#pragma inline
#pragma always_inline
static fract16 sat_fr1x32(fract32 _x)
  {
   /* cast conversions due to MISRA */
   unsigned int val;
   val = (unsigned int)shl_fr1x32(_x,16)>>16;
   return (fract16)val;
  }

/* This function rounds the 32-bit fract to a 16-bit fract using biased 
 * rounding.  */
#pragma inline
#pragma always_inline
static fract16 round_fr1x32(fract32 _x)
  { return __builtin_round_fr1x32(_x); }

/* Returns the number of left shifts required to normalize the input variable 
 * so that it is either in the interval 0x40000000 to 0x7fffffff, or in the 
 * interval 0x80000000 to 0xc0000000.  In other words,
 *  
 *  fract32 x;
 *  shl_fr1x32(x,norm_fr1x32(x));
 *
 * will return a value in the range 0x40000000 to 0x7fffffff, or in the range 
 * 0x80000000 to 0xc0000000.
 */
#pragma inline
#pragma always_inline
static int norm_fr1x32(fract32 _x)
  { return (int)__builtin_norm_fr1x32(_x); }

/* Returns the number of left shifts required to normalize the input variable 
 * so that it is either in the interval 0x4000 to 0x7fff, or in the interval
 * 0x8000 to 0xc000. In other words,
 *
 *  fract16 x;
 *  shl_fr1x16(x,norm_fr1x32(x));
 *
 * will return a value in the range 0x4000 to 0x7fff, or in the range 0x8000 
 * to 0xc000.
 */
#pragma inline
#pragma always_inline
static int norm_fr1x16(fract16 _x)
  { return (int)__builtin_norm_fr1x16(_x); } 

/* This function returns the top 16 bits of _x, i.e. it truncates _x to 16
 * bits.  */
#pragma inline
#pragma always_inline
static fract16 trunc_fr1x32(fract32 _x)
  { unsigned int res = (unsigned int)_x>>16;
    return (fract16)res; }

/* Returns the 16-bit value that is the absolute value of the input parameter.
 * Where the input is 0x8000, saturation occurs and 0x7fff is returned. */
#pragma inline
#pragma always_inline
static fract16 abs_fr16 (fract16 _x)
  { return (fract16)__builtin_abs_fr2x16 ((int)_x); }

/* Returns the 16-bit value that is the absolute value of the input parameter.
 * Where the input is 0x8000, saturation occurs and 0x7fff is returned. */
#pragma inline
#pragma always_inline
static fract16 abs_fr1x16 (fract16 _x)
  { return (fract16)__builtin_abs_fr2x16((int)_x); }

/* Returns the maximum of the two input parameters. */
#pragma inline
#pragma always_inline
static fract16 max_fr16 (fract16 _x, fract16 _y)
  { return (fract16)__builtin_max_fr2x16 ((int)_x,(int)_y); }

/* Returns the maximum of the two input parameters. */
#pragma inline
#pragma always_inline
static fract16 min_fr16 (fract16 _x, fract16 _y)
  { return (fract16)__builtin_min_fr2x16 ((int)_x, (int)_y); }

#pragma inline
#pragma always_inline
static fract16 max_fr1x16 (fract16 _x, fract16 _y)
  { return (fract16)__builtin_max_fr2x16 ((int)_x, (int)_y); }

/* Returns the maximum of the two input parameters. */
#pragma inline
#pragma always_inline
static fract16 min_fr1x16 (fract16 _x, fract16 _y)
  { return (fract16)__builtin_min_fr2x16 ((int)_x, (int)_y); }

/*********************/
/*                   */
/*   ETSI Builtins   */
/*                   */
/*********************/

#ifdef ETSI_SOURCE /* { */
#ifndef NO_ETSI_BUILTINS /* { */
#pragma inline
#pragma always_inline
static fract16 add(fract16 _x, fract16 _y) { return (fract16)add_fr1x16(_x, _y); }
#pragma inline
#pragma always_inline
static fract16 sub(fract16 _x, fract16 _y) { return (fract16)sub_fr1x16(_x, _y); }
#pragma inline
#pragma always_inline
static fract16 abs_s(fract16 _x) { return (fract16)abs_fr1x16(_x); }
#if defined(_ADI_FAST_ETSI)
/* These are fast, but see the shift fr1x16 documentation for their limitations */
#pragma inline
#pragma always_inline
static fract16 shl(fract16 _x, short _y) { return (fract16)shl_fr1x16(_x, _y); }
#pragma inline
#pragma always_inline
static fract16 shr(fract16 _x, short _y) { return (fract16)shr_fr1x16(_x, _y); }
#else /* _ADI_FAST_ETSI */
/* These are conformant, but not so fast */
#pragma inline
#pragma always_inline
static fract16 shl(fract16 _x, short _y) { return (fract16)shl_fr1x16_clip(_x, (int)_y); }
#pragma inline
#pragma always_inline
static fract16 shr(fract16 _x, short _y) { return (fract16)shr_fr1x16_clip(_x, (int)_y); }
#endif /* _ADI_FAST_ETSi */
#pragma inline
#pragma always_inline
static fract16 mult(fract16 _x, fract16 _y) { return mult_fr1x16(_x, _y); }
#pragma inline
#pragma always_inline
static fract16 mult_r(fract16 _x, fract16 _y) { return multr_fr1x16(_x, _y); }
#ifndef RENAME_ETSI_NEGATE
#pragma inline
#pragma always_inline
static fract16 negate(fract16 _x) { return (fract16)negate_fr1x16(_x); }
#else
/* The ETSI negate function conflicts with the C++ standard declaration of
   the template negate.
 */
#pragma inline
#pragma always_inline
static fract16 etsi_negate(fract16 _x) { return (fract16)negate_fr1x16(_x); }
#endif
#pragma inline
#pragma always_inline
static fract16 round(fract32 _x) { return (fract16)round_fr1x32(_x); }
#pragma inline
#pragma always_inline
static fract32 L_add(fract32 _x, fract32 _y) { return add_fr1x32(_x, _y); }
#pragma inline
#pragma always_inline
static fract32 L_sub(fract32 _x, fract32 _y) { return sub_fr1x32(_x, _y); }
#pragma inline
#pragma always_inline
static fract32 L_abs(fract32 _x) { return abs_fr1x32(_x); }
#pragma inline
#pragma always_inline
static fract32 L_negate(fract32 _x) { return negate_fr1x32(_x); }
#if defined(_ADI_FAST_ETSI)
/* These are fast, but see the shift fr1x32 documentation for their limitations */
#pragma inline
#pragma always_inline
static fract32 L_shl(fract32 _x, short _y) { return shl_fr1x32(_x, _y); }
#pragma inline
#pragma always_inline
static fract32 L_shr(fract32 _x, short _y) { return shr_fr1x32(_x, _y); }
#else /* _ADI_FAST_ETSI */
/* These are conformant, but not so fast */
#pragma inline
#pragma always_inline
static fract32 L_shl(fract32 _x, short _y) { return shl_fr1x32_clip(_x, (int)_y); }
#pragma inline
#pragma always_inline
static fract32 L_shr(fract32 _x, short _y) { return shr_fr1x32_clip(_x, (int)_y); }
#endif /* _ADI_FAST_ETSI */
#pragma inline
#pragma always_inline
static fract32 L_mult(fract16 _x, fract16 _y) { return mult_fr1x32(_x, _y); }
#pragma inline
#pragma always_inline
static fract16 saturate(fract32 _x) { return sat_fr1x32(_x); }
#pragma inline
#pragma always_inline
static fract32 L_mac(fract32 _a,fract16 _x, fract16 _y) { return (L_add(_a,L_mult(_x, _y))); }
#pragma inline
#pragma always_inline
static fract32 L_msu(fract32 _a,fract16 _x, fract16 _y) { return (L_sub(_a,L_mult(_x, _y))); }
#pragma inline
#pragma always_inline
static fract16 extract_h(fract32 _x) { 
  unsigned int u = (unsigned int)_x;
  u >>= 16;
  return (fract16)u;
}
#pragma inline
#pragma always_inline
static fract16 extract_l(fract32 _x) { return (fract16)(_x); }
#pragma inline
#pragma always_inline
static fract32 L_deposit_h(fract16 _x) {
  unsigned int u = (unsigned int)_x;
  u <<= 16;
  return (fract32)u;
}
#pragma inline
#pragma always_inline
static fract32 L_deposit_l(fract16 _x) { return ((int)((fract16)(_x))); }
#pragma inline
#pragma always_inline
static fract32 L_Comp(fract16 _x, fract16 _y) { return L_add(L_deposit_h(_x), L_shl((fract32)_y,1))  ; }

#pragma inline
#pragma always_inline
static int norm_l(fract32 _x) {
  return _x==0 ? 0 : norm_fr1x32(_x);
}

#pragma inline
#pragma always_inline
static int norm_s(fract32 _x) {
  return _x==0 ? 0 : norm_fr1x16((fract16)_x);
}

/* Multiplies a fract32 (decomposed to hi and lo) by a fract16, and returns the
 * result as a fract32. */
#pragma inline
#pragma always_inline
static fract32 Mpy_32_16(short _a, short _b, short _c) {
  return L_mac(L_mult(_a,_c), mult(_b,_c),1);
}

/* Decomposes a 32-bit fract into two 16-bit fracts. */
#pragma inline
#pragma always_inline
static void L_Extract(fract32 _a, fract16 *_b, fract16 *_c) {
  *_b=extract_h(_a);
  *_c=(fract16)L_msu(L_shr(_a,1), *_b, 16384);
}                         

/* Multiplies two fract32 numbers, and returns the result as a fract32.  The 
 * input fracts have both been split up into two shorts. */
#pragma inline
#pragma always_inline
static fract32 Mpy_32(short _a, short _b, short _c, short _d) {
  int x = L_mult(_a, _c);
  x = L_mac(x, mult(_a, _d), 1);
  return L_mac(x, mult(_b, _c), 1);
}                       

/* Produces a result which is the fractional division of f1 by f2. Not a builtin 
 * as written in C code. */
#pragma inline
#pragma always_inline
static fract16 div_s(fract16 _a, fract16 _b) {
  int x = (int)_a;
  int y = (int)_b;
  fract16 rtn;
  int i;
  int aq;
  if (x==0) {
    rtn = 0;
  }
  else if (x>=y) {
    rtn = 0x7fff;
  }
  else {
    x <<= 16;
    x = __builtin_divs(x, y, &aq);
    for (i=0; i<15; i++) {
      x = __builtin_divq(x, y, &aq);
    }
    rtn = (fract16) x;
  }
  return rtn;
} 

#endif /*  } NO_ETSI_BUILTINS */
#include <libetsi.h>
#endif /* } ETSI_SOURCE */

#undef __OP1RT
#undef __BOP1RT
#undef __OP2RT
#undef __BOP2RT
#undef __OP1
#undef __BOP1
#undef __OP2
#undef __BOP2

#ifdef __cplusplus
}
#endif

#else

#pragma linkage_name __fmax_fr16
  fract16 max_fr16 (fract16 _x, fract16 _y);

#pragma linkage_name __fmin_fr16
 fract16 min_fr16 (fract16 _x, fract16 _y);

#pragma	linkage_name __abs_fr16
 fract16 abs_fr16 (fract16 _x);

#include <math_bf.h>

#endif /* __ADSPBLACKFIN__  && !__NO_BUILTIN */

#ifdef _MISRA_RULES
#pragma diag(pop)
#endif /* _MISRA_RULES */

#endif /* _FRACT_MATH_H */
