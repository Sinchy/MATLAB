//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_BubbleCenterAndSizeByCircle_mex.cpp
//
// Code generation for function 'BubbleCenterAndSizeByCircle'
//

// Include files
#include "_coder_BubbleCenterAndSizeByCircle_mex.h"
#include "_coder_BubbleCenterAndSizeByCircle_api.h"

// Function Definitions
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&BubbleCenterAndSizeByCircle_atexit);
  // Module initialization.
  BubbleCenterAndSizeByCircle_initialize();
  try {
    emlrtShouldCleanupOnError((emlrtCTX *)emlrtRootTLSGlobal, false);
    // Dispatch the entry-point.
    unsafe_BubbleCenterAndSizeByCircle_mexFunction(nlhs, plhs, nrhs, prhs);
    // Module termination.
    BubbleCenterAndSizeByCircle_terminate();
  } catch (...) {
    emlrtCleanupOnException((emlrtCTX *)emlrtRootTLSGlobal);
    throw;
  }
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLSR2021a(&emlrtRootTLSGlobal, &emlrtContextGlobal, nullptr, 1,
                           nullptr);
  return emlrtRootTLSGlobal;
}

void unsafe_BubbleCenterAndSizeByCircle_mexFunction(int32_T nlhs,
                                                    mxArray *plhs[3],
                                                    int32_T nrhs,
                                                    const mxArray *prhs[4])
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  const mxArray *outputs[3];
  int32_T b_nlhs;
  st.tls = emlrtRootTLSGlobal;
  // Check for proper number of arguments.
  if (nrhs != 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 4, 4,
                        27, "BubbleCenterAndSizeByCircle");
  }
  if (nlhs > 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 27,
                        "BubbleCenterAndSizeByCircle");
  }
  // Call the function.
  BubbleCenterAndSizeByCircle_api(prhs, nlhs, outputs);
  // Copy over outputs to the caller.
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }
  emlrtReturnArrays(b_nlhs, &plhs[0], &outputs[0]);
}

// End of code generation (_coder_BubbleCenterAndSizeByCircle_mex.cpp)
