//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  CircleIdentifier.h
//
//  Code generation for function 'CircleIdentifier'
//


#ifndef CIRCLEIDENTIFIER_H
#define CIRCLEIDENTIFIER_H

// Include files
#include <cstddef>
#include <cstdlib>
#include "rtwtypes.h"
#include "omp.h"
#include "BubbleCenterAndSizeByCircle_types.h"

// Type Definitions
class CircleIdentifier
{
 public:
  CircleIdentifier();
  ~CircleIdentifier();
  void BubbleCenterAndSizeByCircle(const coder::array<bool, 2U> &img, double
    rmin, double rmax, double sense, coder::array<double, 2U> &centers, coder::
    array<double, 2U> &radii);
};

#define MAX_THREADS                    omp_get_max_threads()
#endif

// End of code generation (CircleIdentifier.h)
