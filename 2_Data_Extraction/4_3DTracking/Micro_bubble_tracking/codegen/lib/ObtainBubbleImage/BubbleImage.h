//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// BubbleImage.h
//
// Code generation for function 'BubbleImage'
//

#ifndef BUBBLEIMAGE_H
#define BUBBLEIMAGE_H

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#include "omp.h"
#include <cstddef>
#include <cstdlib>

// Type Definitions
class BubbleImage {
public:
  BubbleImage();
  ~BubbleImage();
  void ObtainBubbleImage(coder::array<double, 2U> &centers,
                         coder::array<double, 1U> &radii,
                         const coder::array<unsigned char, 2U> &img,
                         coder::array<unsigned char, 2U> &b_i_m);
};

#endif
// End of code generation (BubbleImage.h)
