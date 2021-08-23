//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  sort.h
//
//  Code generation for function 'sort'
//


#ifndef SORT_H
#define SORT_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void b_sort(coder::array<double, 2U> &x, coder::array<int, 2U> &idx);
extern void sort(coder::array<float, 2U> &x);

#endif

// End of code generation (sort.h)
