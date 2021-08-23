//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  imfilter.h
//
//  Code generation for function 'imfilter'
//


#ifndef IMFILTER_H
#define IMFILTER_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void imfilter(coder::array<float, 2U> &varargin_1);
extern void padImage(const coder::array<float, 2U> &a_tmp, const double pad[2],
                     coder::array<float, 2U> &a);

#endif

// End of code generation (imfilter.h)
