//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  multithresh.h
//
//  Code generation for function 'multithresh'
//


#ifndef MULTITHRESH_H
#define MULTITHRESH_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern float multithresh(const coder::array<float, 2U> &varargin_1);

#endif

// End of code generation (multithresh.h)
