//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  imhist.h
//
//  Code generation for function 'imhist'
//


#ifndef IMHIST_H
#define IMHIST_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void imhist(const coder::array<unsigned char, 1U> &varargin_1, double
                   yout[256]);

#endif

// End of code generation (imhist.h)
