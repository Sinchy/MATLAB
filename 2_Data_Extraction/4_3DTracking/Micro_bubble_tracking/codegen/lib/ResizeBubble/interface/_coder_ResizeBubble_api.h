//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_ResizeBubble_api.h
//
// Code generation for function 'ResizeBubble'
//

#ifndef _CODER_RESIZEBUBBLE_API_H
#define _CODER_RESIZEBUBBLE_API_H

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
void ResizeBubble(coder::array<uint8_T, 2U> *b_i, real_T d_b,
                  coder::array<uint8_T, 2U> *img);

void ResizeBubble_api(const mxArray *const prhs[2], const mxArray **plhs);

void ResizeBubble_atexit();

void ResizeBubble_initialize();

void ResizeBubble_terminate();

void ResizeBubble_xil_shutdown();

void ResizeBubble_xil_terminate();

#endif
// End of code generation (_coder_ResizeBubble_api.h)
