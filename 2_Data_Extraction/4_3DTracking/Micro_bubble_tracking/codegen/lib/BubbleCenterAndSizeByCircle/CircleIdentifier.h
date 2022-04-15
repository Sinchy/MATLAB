//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// CircleIdentifier.h
//
// Code generation for function 'CircleIdentifier'
//

#ifndef CIRCLEIDENTIFIER_H
#define CIRCLEIDENTIFIER_H

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#include "omp.h"
#include <cstddef>
#include <cstdlib>

// Type Definitions
class CircleIdentifier {
public:
  CircleIdentifier();
  ~CircleIdentifier();
  void BubbleCenterAndSizeByCircle(const coder::array<unsigned char, 2U> &img,
                                   double rmin, double rmax, double sense,
                                   coder::array<double, 2U> &centers,
                                   coder::array<double, 2U> &radii,
                                   coder::array<double, 2U> &metrics);
};

#endif
// End of code generation (CircleIdentifier.h)
