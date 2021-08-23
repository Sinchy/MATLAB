/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_BubbleCenterAndSizeByCircle_mex.c
 *
 * Code generation for function '_coder_BubbleCenterAndSizeByCircle_mex'
 *
 */

/* Include files */
#include "_coder_BubbleCenterAndSizeByCircle_mex.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_initialize.h"
#include "BubbleCenterAndSizeByCircle_terminate.h"
#include "_coder_BubbleCenterAndSizeByCircle_api.h"

/* Function Declarations */
MEXFUNCTION_LINKAGE void c_BubbleCenterAndSizeByCircle_m(int32_T nlhs, mxArray
  *plhs[2], int32_T nrhs, const mxArray *prhs[4]);

/* Function Definitions */
void c_BubbleCenterAndSizeByCircle_m(int32_T nlhs, mxArray *plhs[2], int32_T
  nrhs, const mxArray *prhs[4])
{
  const mxArray *outputs[2];
  int32_T nOutputs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 4, 4,
                        27, "BubbleCenterAndSizeByCircle");
  }

  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 27,
                        "BubbleCenterAndSizeByCircle");
  }

  /* Call the function. */
  BubbleCenterAndSizeByCircle_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    nOutputs = 1;
  } else {
    nOutputs = nlhs;
  }

  emlrtReturnArrays(nOutputs, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(&BubbleCenterAndSizeByCircle_atexit);

  /* Module initialization. */
  BubbleCenterAndSizeByCircle_initialize();

  /* Dispatch the entry-point. */
  c_BubbleCenterAndSizeByCircle_m(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  BubbleCenterAndSizeByCircle_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_BubbleCenterAndSizeByCircle_mex.c) */
