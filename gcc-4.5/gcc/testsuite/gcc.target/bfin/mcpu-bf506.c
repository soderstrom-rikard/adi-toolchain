/* Test for -mcpu=.  */
/* { dg-do preprocess } */
/* { dg-bfin-options "-mcpu=bf506" } */

#ifndef __ADSPBF506__
#error "__ADSPBF506__ is not defined"
#endif

#ifndef __ADSPBF50x__
#error "__ADSPBF50x__ is not defined"
#endif

#if __SILICON_REVISION__ != 0x0001
#error "__SILICON_REVISION__ is not 0x0001"
#endif

#ifndef __WORKAROUNDS_ENABLED
#error "__WORKAROUNDS_ENABLED is not defined"
#endif

#ifdef __WORKAROUND_RETS
#error "__WORKAROUND_RETS is defined"
#endif

#ifndef __WORKAROUND_SPECULATIVE_LOADS
#error "__WORKAROUND_SPECULATIVE_LOADS is not defined"
#endif

#ifndef __WORKAROUND_UNSAFE_NULL_ADDR
#error "__WORKAROUND_UNSAFE_NULL_ADDR is not defined"
#endif

#ifdef __WORKAROUND_SPECULATIVE_SYNCS
#error "__WORKAROUND_SPECULATIVE_SYNCS is defined"
#endif
