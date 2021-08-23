//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  chradii.h
//
//  Code generation for function 'chradii'
//


#ifndef CHRADII_H
#define CHRADII_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void chradii(const coder::array<double, 2U> &varargin_1, const coder::
                    array<float, 2U> &varargin_2, const double varargin_3_data[],
                    coder::array<double, 1U> &r_estimated);

#endif

// End of code generation (chradii.h)
