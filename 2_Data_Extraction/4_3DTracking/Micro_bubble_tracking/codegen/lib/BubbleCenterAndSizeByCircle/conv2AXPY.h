//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  conv2AXPY.h
//
//  Code generation for function 'conv2AXPY'
//


#ifndef CONV2AXPY_H
#define CONV2AXPY_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void b_conv2AXPYSameCMP(const coder::array<double, 2U> &a, coder::array<
  double, 2U> &c);
extern void c_conv2AXPYSameCMP(const coder::array<double, 2U> &a, coder::array<
  double, 2U> &c);
extern void conv2AXPYSameCMP(const coder::array<double, 2U> &a, coder::array<
  double, 2U> &c);

#endif

// End of code generation (conv2AXPY.h)
