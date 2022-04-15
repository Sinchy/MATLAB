//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_ObtainBubbleImage_api.h
//
// Code generation for function 'ObtainBubbleImage'
//

#ifndef _CODER_OBTAINBUBBLEIMAGE_API_H
#define _CODER_OBTAINBUBBLEIMAGE_API_H

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
void ObtainBubbleImage(coder::array<real_T, 2U> *centers,
                       coder::array<real_T, 1U> *radii,
                       coder::array<uint8_T, 2U> *img,
                       coder::array<uint8_T, 2U> *b_i_m);

void ObtainBubbleImage_api(const mxArray *const prhs[3], const mxArray **plhs);

void ObtainBubbleImage_atexit();

void ObtainBubbleImage_initialize();

void ObtainBubbleImage_terminate();

void ObtainBubbleImage_xil_shutdown();

void ObtainBubbleImage_xil_terminate();

#endif
// End of code generation (_coder_ObtainBubbleImage_api.h)
