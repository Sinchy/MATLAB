//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  regionprops.h
//
//  Code generation for function 'regionprops'
//


#ifndef REGIONPROPS_H
#define REGIONPROPS_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "BubbleCenterAndSize_types.h"

// Function Declarations
extern void ComputeCentroid(const double imageSize[2], coder::array<b_struct_T,
  1U> &stats, struct_T *statsAlreadyComputed);
extern void ComputeEllipseParams(const double imageSize[2], coder::array<
  b_struct_T, 1U> &stats, struct_T *statsAlreadyComputed);

#endif

// End of code generation (regionprops.h)
