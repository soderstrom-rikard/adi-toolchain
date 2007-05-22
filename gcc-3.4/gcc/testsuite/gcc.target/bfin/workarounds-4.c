/* Test for -mcpu= -msi-revision=.  */
/* { dg-do preprocess } */
/* { dg-options "-msi-revision=any -mcpu=bf537" } */

#ifndef __ADSPBF537__
#error "__ADSPBF537__ is not defined"
#endif

#if __SILICON_REVISION__ != 0xffff
#error "__SILICON_REVISION__ is not 0xffff"
#endif

#ifndef __WORKAROUNDS_ENABLED
#error "__WORKAROUNDS_ENABLED is not defined"
#endif

#ifndef __WORKAROUND_SPECULATIVE_LOADS
#error "__WORKAROUND_SPECULATIVE_LOADS is not defined"
#endif

#ifndef __WORKAROUND_SPECULATIVE_SYNCS
#error "__WORKAROUND_SPECULATIVE_SYNCS is defined"
#endif
