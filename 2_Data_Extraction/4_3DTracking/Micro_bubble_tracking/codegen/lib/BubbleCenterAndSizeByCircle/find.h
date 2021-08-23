//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  find.h
//
//  Code generation for function 'find'
//


#ifndef FIND_H
#define FIND_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void eml_find(const coder::array<bool, 2U> &x, coder::array<int, 1U> &i,
                     coder::array<int, 1U> &j);

#endif

// End of code generation (find.h)
