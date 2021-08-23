//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  chaccum.h
//
//  Code generation for function 'chaccum'
//


#ifndef CHACCUM_H
#define CHACCUM_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void chaccum(const coder::array<bool, 2U> &varargin_1, const double
                    varargin_2_data[], const int varargin_2_size[2], coder::
                    array<creal_T, 2U> &accumMatrix, coder::array<float, 2U>
                    &gradientImg);

#endif

// End of code generation (chaccum.h)
