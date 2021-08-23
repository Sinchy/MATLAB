//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  medfilt2.h
//
//  Code generation for function 'medfilt2'
//


#ifndef MEDFILT2_H
#define MEDFILT2_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
extern void medfilt2(coder::array<double, 2U> &inImg, coder::array<double, 2U>
                     &outImg);

#endif

// End of code generation (medfilt2.h)
