//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  unique.h
//
//  Code generation for function 'unique'
//


#ifndef UNIQUE_H
#define UNIQUE_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void unique_vector(const coder::array<float, 1U> &a, coder::array<float,
  1U> &b);

#endif

// End of code generation (unique.h)
