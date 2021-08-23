//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  imhist.cpp
//
//  Code generation for function 'imhist'
//


// Include files
#include "imhist.h"
#include "CircleIdentifier.h"
#include "rt_nonfinite.h"
#include <cstring>

// Function Definitions
void imhist(const coder::array<unsigned char, 1U> &varargin_1, double yout[256])
{
  double localBins1[256];
  double localBins2[256];
  double localBins3[256];
  int i;
  std::memset(&yout[0], 0, 256U * sizeof(double));
  std::memset(&localBins1[0], 0, 256U * sizeof(double));
  std::memset(&localBins2[0], 0, 256U * sizeof(double));
  std::memset(&localBins3[0], 0, 256U * sizeof(double));
  for (i = 0; i + 4 <= varargin_1.size(0); i += 4) {
    int localBins2_tmp;
    localBins1[varargin_1[i]]++;
    localBins2_tmp = varargin_1[i + 1];
    localBins2[localBins2_tmp]++;
    localBins2_tmp = varargin_1[i + 2];
    localBins3[localBins2_tmp]++;
    localBins2_tmp = varargin_1[i + 3];
    yout[localBins2_tmp]++;
  }

  while (i + 1 <= varargin_1.size(0)) {
    yout[varargin_1[i]]++;
    i++;
  }

  for (i = 0; i < 256; i++) {
    yout[i] = ((yout[i] + localBins1[i]) + localBins2[i]) + localBins3[i];
  }
}

// End of code generation (imhist.cpp)
