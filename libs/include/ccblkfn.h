#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* ccblkfn.h */
#endif
/************************************************************************
 *
 * ccblkfn.h
 *
 * (c) Copyright 2001-2007 Analog Devices, Inc.  All rights reserved.
 *
 ************************************************************************/

/* ccblkfn definitions */

#ifndef _CCBLKFN_H
#define _CCBLKFN_H

#include <stdlib.h>

#ifdef _MISRA_RULES
#pragma diag(push)
#pragma diag(suppress:misra_rule_5_7)
#pragma diag(suppress:misra_rule_6_3)
#pragma diag(suppress:misra_rule_8_1)
#pragma diag(suppress:misra_rule_8_5)
#pragma diag(suppress:misra_rule_11_2)
#pragma diag(suppress:misra_rule_11_3)
#pragma diag(suppress:misra_rule_11_4)
#pragma diag(suppress:misra_rule_19_1)
#pragma diag(suppress:misra_rule_19_4)
#pragma diag(suppress:misra_rule_19_7)
#endif /* _MISRA_RULES */


#ifdef __cplusplus
extern "C" {
#endif

#ifndef __NO_BUILTIN

void *__builtin_alloca(int _i);

long __builtin_circindex(long _l, long _l2, unsigned long _ul);
void *__builtin_circptr(const void *_pcv, long _l, const void *_pcv2, unsigned long _ul);

/* The following builtins allow for efficient loads and stores from
** misaligned addresses, without the need for using #pragma pack()
*/

/* The following builtins allow for efficient loads and stores from
** misaligned addresses, without the need for using #pragma pack() */
short __builtin_misaligned_load16(void *_pv);
short __builtin_misaligned_load16_vol(volatile void *_pvv);
void __builtin_misaligned_store16(void *_pv, short _s);
void __builtin_misaligned_store16_vol(volatile void *_pvv, short _s);

int __builtin_misaligned_load32(void *_pv);
int __builtin_misaligned_load32_vol(volatile void *_pvv);
void __builtin_misaligned_store32(void *_pv, int _i);
void __builtin_misaligned_store32_vol(volatile void *_pvv, int _i);

long long __builtin_misaligned_load64(void *_pv);
long long __builtin_misaligned_load64_vol(volatile void *_pvv);
void __builtin_misaligned_store64(void *_pv, long long _ll);
void __builtin_misaligned_store64_vol(volatile void *_pvv, long long _ll);

/* The following relate to the instructions used for implementing divides.
*/

#pragma inline
static int __divs(int _x, int _y, int *_paq) {
  _x = __builtin_divs_r1(_x, _y);
  *_paq = __builtin_divs_r2(_x);
  return _x;
}

#pragma inline
static int __divq(int _x, int _y, int *_paq) {
  _x = __builtin_divq_r1(_x, _y, *_paq);
  *_paq = __builtin_divq_r2(_x);
  return _x;
}

/* These are provided for backwards compatibility, but the
** definitions above should be used in preference.
*/

#define __builtin_divs(X, Y, PAQ) __divs((X), (Y), (PAQ))
#define __builtin_divq(X, Y, PAQ) __divq((X), (Y), (PAQ))

#endif

#define __lvitmax2x16(A, B, C, D, E) { \
  (D) = __builtin_lvitmax2x16_r1((A), (B), (C)); \
  (E) = __builtin_lvitmax2x16_r2(D); \
}

#define __rvitmax2x16(A, B, C, D, E) { \
  (D) = __builtin_rvitmax2x16_r1((A), (B), (C)); \
  (E) = __builtin_rvitmax2x16_r2(D); \
}

#define __lvitmax1x16(A, B, C, D) { \
  (C) = __builtin_lvitmax1x16_r1((A), (B)); \
  (D) = __builtin_lvitmax1x16_r2(C); \
}

#define __rvitmax1x16(A,B,C,D) { \
  (C) = __builtin_rvitmax1x16_r1((A),(B)); \
  (D) = __builtin_rvitmax1x16_r2(C); \
}


/* These are provided for backwards compatibility, but the
** definitions above should be used in preference.
*/

#define __builtin_lvitmax2x16 __lvitmax2x16
#define __builtin_rvitmax2x16 __rvitmax2x16
#define __builtin_lvitmax1x16 __lvitmax1x16
#define __builtin_rvitmax1x16 __rvitmax1x16

#ifndef __NO_BUILTIN

/* The following two builtins change data from big-endian to little-endian,
** or vice versa
*/

#define byteswap4(A) __builtin_byteswap4(A)
#define byteswap2(A) __builtin_byteswap2(A)

#define expadj1x32 __builtin_expadj1x32
#define expadj2x16 __builtin_expadj2x16
#define expadj1x16 __builtin_expadj1x16

#define divs __builtin_divs
#define divq __builtin_divq
#define rvitmax1x16(A,B,C,D) __builtin_rvitmax1x16((A),(B),(C),(D))
#define lvitmax1x16(A,B,C,D) __builtin_lvitmax1x16((A),(B),(C),(D))
#define rvitmax2x16(A,B,C,D,E) __builtin_rvitmax2x16((A),(B),(C),(D),(E))
#define rvitmax2x16(A,B,C,D,E) __builtin_rvitmax2x16((A),(B),(C),(D),(E))
#define idle() __builtin_idle()

/* halt() and abort() operations are no longer supported by the simulators.
** Invoke the _Exit() system call, which circumvents exit()'s clean-up.
*/

#define sys_halt() _Exit()

#if !defined(abort)

#define sys_abort() _Exit()

#endif

#define ssync() __builtin_ssync()
#define ssync_int() __builtin_ssync_int()
#define csync() __builtin_csync()

#define csync_int() __builtin_csync_int()

#ifdef __AVOID_CLI_ANOMALY__

#pragma inline
#pragma always_inline
static int cli(void) {
  int r, reti;
  __asm volatile("%0 = RETI; RETI = [SP++];\n" : "=d" (reti));
  r = __builtin_cli();
  __asm volatile("[--SP] = RETI; RETI = %0;\n" : : "d" (reti) : "reti");
   return r;
}

#else

#define cli() __builtin_cli()

#endif

#define sti(A) __builtin_sti(A)

#define raise_intr(A) __builtin_raise(A)

#define excpt(A) __builtin_excpt(A)

#define sysreg_read(A) __builtin_sysreg_read(A)
#define sysreg_write(A,B) __builtin_sysreg_write((A),(B))
#define sysreg_read64(A) __builtin_sysreg_read64(A)
#define sysreg_write64(A,B) __builtin_sysreg_write64((A),(B))
#define alloca(N) __builtin_alloca(N)

#define circindex(IDX,INC,ITMS) __builtin_circindex((IDX),(INC),(ITMS))
#define circptr(PTR,INCR,BASE,LEN) __builtin_circptr((PTR),(INCR),(BASE),(LEN))
#define expected_true(_v) __builtin_expected_true(_v)
#define expected_false(_v) __builtin_expected_false(_v)
#define bitmux_shr(X,Y,A)  { \
	int _x = (X), _y = (Y); \
	long long _a = (A); \
	_a = __builtin_bitmux_shr_res1(_a,_x,_y); \
	_x = __builtin_bitmux_shr_res2(_a); \
	_y = __builtin_bitmux_shr_res3(_a); \
	(X) = _x ; \
	(Y) = _y ; \
	(A) = _a ; \
	} 
#define bitmux_shl(X,Y,A)  { \
	int _x = (X), _y = (Y); \
	long long _a = (A); \
	_a = __builtin_bitmux_shl_res1(_a,_x,_y); \
	_x = __builtin_bitmux_shl_res2(_a); \
	_y = __builtin_bitmux_shl_res3(_a); \
	(X) = _x ; \
	(Y) = _y ; \
	(A) = _a ; \
	} 

#define misaligned_load16(_a) __builtin_misaligned_load16(_a);
#define misaligned_load16_vol(_a) __builtin_misaligned_load16_vol(_a);
#define misaligned_store16(_a,_v) __builtin_misaligned_store16((_a),(_v));
#define misaligned_store16_vol(_a,_v) __builtin_misaligned_store16_vol((_a),(_v));

#define misaligned_load32(_a) __builtin_misaligned_load32(_a);
#define misaligned_load32_vol(_a) __builtin_misaligned_load32_vol(_a);
#define misaligned_store32(_a,_v) __builtin_misaligned_store32((_a), (_v));
#define misaligned_store32_vol(_a,_v) __builtin_misaligned_store32_vol((_a), (_v));

#define misaligned_load64(_a) __builtin_misaligned_load64(_a);
#define misaligned_load64_vol(_a) __builtin_misaligned_load64_vol(_a);
#define misaligned_store64(_a,_v) __builtin_misaligned_store64((_a), (_v));
#define misaligned_store64_vol(_a,_v) __builtin_misaligned_store64_vol((_a), (_v));

#endif /* !__NO_BUILTIN */

/* Copy from L1 Instruction memory */

void *_l1_memcpy(void *datap, const void *instrp, size_t n);

/* Copy to L1 Instruction memory */

void *_memcpy_l1(void *instrp, const void *datap, size_t n);

/*
** Routines for set/unsetting atomic access bit in value pointed to.
** These routines use the TESTSET instruction to gain exclusive access
** to a flag variable.
**
** Obtaining the flag provides atomic access for the core that claims
** the flag that is passed in.
**
** NOTE: It is assumed that the routines will be called in a lock/unlock
**       order.  No checking is performed in the unlock routine to ensure
**       that the current core has the lock.  As long as the routines
**       are used correctly there is no need for this functionality.
**
** For Multi-Core Processors Only
*/

#include <sys/mc_typedef.h>

#ifdef __WORKAROUND_L2_TESTSET_STALL 
extern int __builtin_testset_05000248(char *_s);
#else
extern int __builtin_testset(char *_s);
#endif
extern void __builtin_untestset(char *_s);

#pragma inline
#pragma always_inline
static void adi_acquire_lock(testset_t *_t) {
  int  tVal;

  __builtin_csync();
#ifdef __WORKAROUND_L2_TESTSET_STALL
  tVal = __builtin_testset_05000248((char *) _t);
#else
  tVal = __builtin_testset((char *) _t);
#endif
  while (tVal == 0) {
    __builtin_csync();
#ifdef __WORKAROUND_L2_TESTSET_STALL
    tVal = __builtin_testset_05000248((char *) _t);
#else
    tVal = __builtin_testset((char *) _t);
#endif
  }
}

#pragma inline
#pragma always_inline
static int adi_try_lock(testset_t *_t) {
  __builtin_csync();
#ifdef __WORKAROUND_L2_TESTSET_STALL
    return __builtin_testset_05000248((char *) _t);
#else
    return __builtin_testset((char *) _t);
#endif
}

#pragma inline
#pragma always_inline
static void adi_release_lock(testset_t *_t) {
  __builtin_untestset((char *) _t);
  __builtin_ssync();
}

/* Legacy routines - will be depracated */

#pragma inline
#pragma always_inline
static void claim_atomic_access(testset_t *_t) {
  adi_acquire_lock(_t);
}

#pragma inline
#pragma always_inline
static void release_atomic_access(testset_t *_t) {
  adi_release_lock(_t);
}

#if defined(__ADSPBF561__)

#include <cdefBF561.h>

#pragma inline
#pragma always_inline
static int adi_core_id(void) {
  /* Returns the Core ID: 0 for coreA, 1 for coreB
  ** This method is actually quicker than extracting the relevant
  ** From the DSPID register.
  */
  return (((unsigned long) * (unsigned long *) SRAM_BASE_ADDRESS) == 0xFF800000  ? (int)0 : (int)1);
}

#pragma inline
#pragma always_inline
static void adi_core_b_enable(void)
{
        /* clearing bit 5 releases Core B and allows it to run. */
        *pSICA_SYSCR &= 0xFFDFu;
}

#else

/* NULL versions, for when the Core-A part of an application
** is run on a single-core system.
*/

#pragma inline
#pragma always_inline
static int adi_core_id(void) {
  return 0;
}

#pragma inline
#pragma always_inline
static void adi_core_b_enable(void)
{
  /* do nothing */
}

#endif /* defined(__ADSPBF561__) */

#ifdef __cplusplus
} /* extern "C" */
#endif

#ifdef _MISRA_RULES
#pragma diag(pop)
#endif /* _MISRA_RULES */

#endif  /* _CCBLKFN_H */
