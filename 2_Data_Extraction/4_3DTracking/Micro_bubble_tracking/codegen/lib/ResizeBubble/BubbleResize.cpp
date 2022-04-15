//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// BubbleResize.cpp
//
// Code generation for function 'BubbleResize'
//

// Include files
#include "BubbleResize.h"
#include "ResizeBubble_data.h"
#include "imresize.h"
#include "rt_nonfinite.h"
#include "coder_array.h"
#include <cmath>

// Function Definitions
BubbleResize::BubbleResize()
{
  omp_init_nest_lock(&emlrtNestLockGlobal);
}

BubbleResize::~BubbleResize()
{
  omp_destroy_nest_lock(&emlrtNestLockGlobal);
}

void BubbleResize::ResizeBubble(const coder::array<unsigned char, 2U> &b_i,
                                double d_b,
                                coder::array<unsigned char, 2U> &img)
{
  coder::array<double, 2U> weights;
  coder::array<int, 2U> indices;
  coder::array<unsigned char, 2U> out;
  double outputSize_idx_0;
  double outputSize_idx_1;
  double scale_idx_0;
  double scale_idx_1;
  if (std::isnan(d_b)) {
    outputSize_idx_0 = std::ceil(d_b * static_cast<double>(b_i.size(0)) /
                                 static_cast<double>(b_i.size(1)));
    outputSize_idx_1 = std::ceil(d_b);
    scale_idx_0 = outputSize_idx_1 / static_cast<double>(b_i.size(1));
    scale_idx_1 = outputSize_idx_1 / static_cast<double>(b_i.size(1));
  } else if (std::isnan(d_b)) {
    outputSize_idx_0 = std::ceil(d_b);
    outputSize_idx_1 = std::ceil(d_b * static_cast<double>(b_i.size(1)) /
                                 static_cast<double>(b_i.size(0)));
    scale_idx_0 = outputSize_idx_0 / static_cast<double>(b_i.size(0));
    scale_idx_1 = outputSize_idx_0 / static_cast<double>(b_i.size(0));
  } else {
    outputSize_idx_0 = std::ceil(d_b);
    outputSize_idx_1 = outputSize_idx_0;
    scale_idx_0 = outputSize_idx_0 / static_cast<double>(b_i.size(0));
    scale_idx_1 = outputSize_idx_0 / static_cast<double>(b_i.size(1));
  }
  if (scale_idx_0 <= scale_idx_1) {
    //  Resize first dimension
    coder::contributions(b_i.size(0), outputSize_idx_0, scale_idx_0, 4.0,
                         weights, indices);
    out.set_size(weights.size(1), b_i.size(1));
    coder::resizeAlongDim2D(b_i, weights, indices,
                            static_cast<double>(weights.size(1)), out);
    //  Resize second dimension
    coder::contributions(b_i.size(1), outputSize_idx_1, scale_idx_1, 4.0,
                         weights, indices);
    img.set_size(out.size(0), weights.size(1));
    coder::b_resizeAlongDim2D(out, weights, indices,
                              static_cast<double>(weights.size(1)), img);
  } else {
    coder::contributions(b_i.size(1), outputSize_idx_1, scale_idx_1, 4.0,
                         weights, indices);
    out.set_size(b_i.size(0), weights.size(1));
    coder::b_resizeAlongDim2D(b_i, weights, indices,
                              static_cast<double>(weights.size(1)), out);
    //  Resize second dimension
    coder::contributions(b_i.size(0), outputSize_idx_0, scale_idx_0, 4.0,
                         weights, indices);
    img.set_size(weights.size(1), out.size(1));
    coder::resizeAlongDim2D(out, weights, indices,
                            static_cast<double>(weights.size(1)), img);
  }
}

// End of code generation (BubbleResize.cpp)
