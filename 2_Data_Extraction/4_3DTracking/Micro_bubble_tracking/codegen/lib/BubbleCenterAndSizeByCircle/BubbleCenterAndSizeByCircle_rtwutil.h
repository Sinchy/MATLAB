//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  BubbleCenterAndSizeByCircle_rtwutil.h
//
//  Code generation for function 'BubbleCenterAndSizeByCircle_rtwutil'
//


#ifndef BUBBLECENTERANDSIZEBYCIRCLE_RTWUTIL_H
#define BUBBLECENTERANDSIZEBYCIRCLE_RTWUTIL_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern int div_s32(int numerator, int denominator);
extern double rt_hypotd_snf(double u0, double u1);
extern double rt_roundd_snf(double u);

#endif

// End of code generation (BubbleCenterAndSizeByCircle_rtwutil.h)
