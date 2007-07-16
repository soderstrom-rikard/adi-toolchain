/************************************************************************
 *
 * stats.h
 *
 * (c) Copyright 1996-2007 Analog Devices, Inc.  All rights reserved.
 * $Revision: 1.11 $
 ************************************************************************/

#pragma once
#ifndef __NO_BUILTIN
#pragma system_header /* stats.h */
#endif

#ifndef __STATS_DEFINED
#define __STATS_DEFINED


#include <fract_typedef.h>

#ifdef _MISRA_RULES
#pragma diag(push)
#pragma diag(suppress:misra_rule_6_3)
#endif /* _MISRA_RULES */



#ifdef __cplusplus
 extern "C" {
#endif 



/* * * *        autocoh      * * * *
 *
 *    Autocoherence
 * 
 */

#pragma linkage_name __autocoh_fr16
        void autocoh_fr16 ( const fract16 _samples[], 
                            int _sample_length, int _lags, 
                            fract16 _coherence[] );

#pragma linkage_name __autocohf
        void autocohf ( const float _samples[], 
                        int _sample_length, int _lags,
                        float _coherence[] );

#pragma linkage_name __autocohd
        void autocohd ( const long double _samples[], 
                        int _sample_length, int _lags,
                        long double _coherence[] );

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __autocohf
#else
#pragma linkage_name __autocohd
#endif
        void autocoh ( const double _samples[], 
                       int _sample_length, int _lags,
                       double _coherence[]);



/* * * *        autocorr      * * * *
 *
 *    Autocorrelation
 * 
 */

#pragma linkage_name __autocorr_fr16
        void autocorr_fr16 ( const fract16 _samples[], 
                             int _sample_length, int _lags,
                             fract16 _correlation[] );

#pragma linkage_name __autocorrf
        void autocorrf ( const float _samples[],
                         int _sample_length, int _lags,
                         float _correlation[] );

#pragma linkage_name __autocorrd
        void autocorrd ( const long double _samples[], 
                         int _sample_length, int _lags,
                         long double _correlation[] );

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __autocorrf
#else
#pragma linkage_name __autocorrd
#endif
        void autocorr ( const double _samples[], 
                        int _sample_length, int _lags,
                        double _correlation[] );



/* * * *        crosscoh      * * * *
 *
 *    Cross-Coherence
 * 
 */

#pragma linkage_name __crosscoh_fr16
        void crosscoh_fr16 ( const fract16 _samples_x[], 
                             const fract16 _samples_y[], 
                             int _sample_length, int _lags,
                             fract16 _coherence[] );

#pragma linkage_name __crosscohf
        void crosscohf ( const float _samples_x[], 
                         const float _samples_y[], 
                         int _sample_length, int _lags,
                         float _coherence[] );

#pragma linkage_name __crosscohd
        void crosscohd ( const long double _samples_x[], 
                         const long double _samples_y[],
                         int _sample_length, int _lags,
                         long double _coherence[] );

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __crosscohf
#else
#pragma linkage_name __crosscohd
#endif
        void crosscoh ( const double _samples_x[], 
                        const double _samples_y[],
                        int _sample_length, int _lags,
                        double _coherence[] );



/* * * *        crosscorr      * * * *
 *
 *    Cross-Correlation
 * 
 */

#pragma linkage_name __crosscorr_fr16
        void crosscorr_fr16 ( const fract16 _samples_x[], 
                              const fract16 _samples_y[], 
                              int _sample_length, int _lags,
                              fract16 _correlation[]);

#pragma linkage_name __crosscorrf
        void crosscorrf ( const float _samples_x[], 
                          const float _samples_y[],
                          int _sample_length, int _lags, 
                          float _correlation[]);

#pragma linkage_name __crosscorrd
        void crosscorrd ( const long double _samples_x[], 
                          const long double _samples_y[],
                          int _sample_length, int _lags,
                          long double _correlation[] );

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __crosscorrf
#else
#pragma linkage_name __crosscorrd
#endif
        void crosscorr ( const double _samples_x[],
                         const double _samples_y[],
                         int _sample_length, int _lags,
                         double _correlation[] );



/* * * *        histogram      * * * *
 *
 *    Histogram 
 * 
 */

#pragma linkage_name __histogram_fr16
        void histogram_fr16 ( const fract16 _samples_x[], 
                              int _histogram_x[], 
                              fract16 _max_sample, fract16 _min_sample, 
                              int _sample_length, int _bin_count );

#pragma linkage_name __histogramf
        void histogramf ( const float _samples_x[], 
                          int _histogram_x[], 
                          float _max_sample, float _min_sample, 
                          int _sample_length, int _bin_count );

#pragma linkage_name __histogramd
        void histogramd ( const long double _samples_x[], 
                          int _histogram_x[],
                          long double _max_sample, long double _min_sample, 
                          int _sample_length, int _bin_count );

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __histogramf
#else
#pragma linkage_name __histogramd
#endif
        void histogram ( const double _samples_x[],
                          int _histogram_x[],
                          double _max_sample, double _min_sample,
                          int _sample_length, int _bin_count );



/* * * *        mean      * * * *
 *
 *    Mean value
 * 
 */

#pragma linkage_name __mean_fr16
        fract16 mean_fr16 (const fract16 _samples[], int _sample_length);

#pragma linkage_name __meanf
        float meanf (const float _samples[], int _sample_length);

#pragma linkage_name __meand
        long double meand (const long double _samples[], int _sample_length);

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __meanf
#else
#pragma linkage_name __meand
#endif
        double mean (const double _samples[], int _sample_length);



/* * * *        rms      * * * *
 *
 *    Root Mean Square
 * 
 */

#pragma linkage_name __rms_fr16
        fract16 rms_fr16 (const fract16 _samples[], int _sample_length);

#pragma linkage_name __rmsf
        float rmsf (const float _samples[], int _sample_length);

#pragma linkage_name __rmsd
        long double rmsd (const long double _samples[], int _sample_length);

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __rmsf
#else
#pragma linkage_name __rmsd
#endif
        double rms (const double _samples[], int _sample_length);



/* * * *        var      * * * *
 *
 *    Variance
 * 
 */

#pragma linkage_name __var_fr16
        fract16 var_fr16 (const fract16 _samples[], int _sample_length);

#pragma linkage_name __varf
        float varf (const float _samples[], int _sample_length);

#pragma linkage_name __vard
        long double vard (const long double _samples[], int _sample_length);

#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __varf
#else
#pragma linkage_name __vard
#endif
        double var (const double _samples[], int _sample_length);



/* * * *        zero_cross      * * * *
 *
 *    Count zero crossings
 * 
 */

#pragma linkage_name __zero_cross_fr16
        int zero_cross_fr16 (const fract16 _samples[], int _sample_length);

#pragma linkage_name __zero_crossf
        int zero_crossf (const float _samples[], int _sample_length);

#pragma linkage_name __zero_crossd
        int zero_crossd (const long double _samples[], int _sample_length);


#ifdef __DOUBLES_ARE_FLOATS__
#pragma linkage_name __zero_crossf
#else
#pragma linkage_name __zero_crossd
#endif
        int zero_cross (const double _samples[], int _sample_length);



#ifdef __cplusplus
 }	/* end extern "C" */
#endif 

#ifdef _MISRA_RULES
#pragma diag(pop)
#endif /* _MISRA_RULES */

#endif   /* __STATS_DEFINED  (include guard) */


