/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_BubbleCenterAndSize_mex.c
 *
 * Code generation for function '_coder_BubbleCenterAndSize_mex'
 *
 */

/* Include files */
#include "_coder_BubbleCenterAndSize_mex.h"
#include "BubbleCenterAndSize.h"
#include "BubbleCenterAndSize_data.h"
#include "BubbleCenterAndSize_initialize.h"
#include "BubbleCenterAndSize_terminate.h"
#include "_coder_BubbleCenterAndSize_api.h"

/* Function Declarations */
MEXFUNCTION_LINKAGE void BubbleCenterAndSize_mexFunction(int32_T nlhs, mxArray
  *plhs[1], int32_T nrhs, const mxArray *prhs[1]);

/* Function Definitions */
void BubbleCenterAndSize_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[1])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 1, 4,
                        19, "BubbleCenterAndSize");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 19,
                        "BubbleCenterAndSize");
  }

  /* Call the function. */
  BubbleCenterAndSize_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(&BubbleCenterAndSize_atexit);

  /* Module initialization. */
  BubbleCenterAndSize_initialize();

  /* Dispatch the entry-point. */
  BubbleCenterAndSize_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  BubbleCenterAndSize_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_BubbleCenterAndSize_mex.c) */
