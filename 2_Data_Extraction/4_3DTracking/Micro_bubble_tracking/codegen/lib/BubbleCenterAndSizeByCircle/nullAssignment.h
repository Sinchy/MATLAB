//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  nullAssignment.h
//
//  Code generation for function 'nullAssignment'
//


#ifndef NULLASSIGNMENT_H
#define NULLASSIGNMENT_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void nullAssignment(coder::array<float, 2U> &x, const coder::array<bool,
  2U> &idx);

#endif

// End of code generation (nullAssignment.h)
