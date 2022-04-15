//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_BubbleCenterAndSizeByCircle_api.h
//
// Code generation for function 'BubbleCenterAndSizeByCircle'
//

#ifndef _CODER_BUBBLECENTERANDSIZEBYCIRCLE_API_H
#define _CODER_BUBBLECENTERANDSIZEBYCIRCLE_API_H

// Include files
#include "coder_array_mex.h"
#include "emlrt.h"
#include "tmwtypes.h"
#include <algorithm>
#include <cstring>

// Variable Declarations
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

// Function Declarations
void BubbleCenterAndSizeByCircle(coder::array<uint8_T, 2U> *img, real_T rmin,
                                 real_T rmax, real_T sense,
                                 coder::array<real_T, 2U> *centers,
                                 coder::array<real_T, 2U> *radii,
                                 coder::array<real_T, 2U> *metrics);

void BubbleCenterAndSizeByCircle_api(const mxArray *const prhs[4], int32_T nlhs,
                                     const mxArray *plhs[3]);

void BubbleCenterAndSizeByCircle_atexit();

void BubbleCenterAndSizeByCircle_initialize();

void BubbleCenterAndSizeByCircle_terminate();

void BubbleCenterAndSizeByCircle_xil_shutdown();

void BubbleCenterAndSizeByCircle_xil_terminate();

#endif
// End of code generation (_coder_BubbleCenterAndSizeByCircle_api.h)
