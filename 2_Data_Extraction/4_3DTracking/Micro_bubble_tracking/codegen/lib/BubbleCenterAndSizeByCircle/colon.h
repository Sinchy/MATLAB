//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  colon.h
//
//  Code generation for function 'colon'
//


#ifndef COLON_H
#define COLON_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void b_eml_float_colon(double a, double b, coder::array<double, 2U> &y);
extern void eml_float_colon(double a, double b, coder::array<double, 2U> &y);

#endif

// End of code generation (colon.h)
