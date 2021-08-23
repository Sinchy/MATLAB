//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  chcenters.h
//
//  Code generation for function 'chcenters'
//


#ifndef CHCENTERS_H
#define CHCENTERS_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void chcenters(const coder::array<creal_T, 2U> &varargin_1, double
                      varargin_2, coder::array<double, 2U> &centers, coder::
                      array<double, 2U> &metric);

#endif

// End of code generation (chcenters.h)
