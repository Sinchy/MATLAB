//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  minOrMax.h
//
//  Code generation for function 'minOrMax'
//


#ifndef MINORMAX_H
#define MINORMAX_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern double b_maximum(const double x[256]);
extern double c_maximum(const double x_data[], const int x_size[2]);
extern double d_maximum(const coder::array<double, 1U> &x);
extern void e_maximum(const coder::array<creal_T, 1U> &x, creal_T *ex, int *idx);
extern float maximum(const coder::array<float, 1U> &x);
extern float minimum(const coder::array<float, 1U> &x);

#endif

// End of code generation (minOrMax.h)
