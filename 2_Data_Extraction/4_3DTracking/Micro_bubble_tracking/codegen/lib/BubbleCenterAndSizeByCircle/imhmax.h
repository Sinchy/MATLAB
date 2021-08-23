//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  imhmax.h
//
//  Code generation for function 'imhmax'
//


#ifndef IMHMAX_H
#define IMHMAX_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void imhmax(const coder::array<double, 2U> &b_I, double H, coder::array<
                   double, 2U> &J);

#endif

// End of code generation (imhmax.h)
