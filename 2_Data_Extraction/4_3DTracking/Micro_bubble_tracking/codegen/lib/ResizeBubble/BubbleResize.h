//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// BubbleResize.h
//
// Code generation for function 'BubbleResize'
//

#ifndef BUBBLERESIZE_H
#define BUBBLERESIZE_H

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#include "omp.h"
#include <cstddef>
#include <cstdlib>

// Type Definitions
class BubbleResize {
public:
  BubbleResize();
  ~BubbleResize();
  void ResizeBubble(const coder::array<unsigned char, 2U> &b_i, double d_b,
                    coder::array<unsigned char, 2U> &img);
};

#endif
// End of code generation (BubbleResize.h)
