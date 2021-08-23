/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BubbleCenterAndSizeByCircle_terminate.c
 *
 * Code generation for function 'BubbleCenterAndSizeByCircle_terminate'
 *
 */

/* Include files */
#include "BubbleCenterAndSizeByCircle_terminate.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "_coder_BubbleCenterAndSizeByCircle_mex.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void BubbleCenterAndSizeByCircle_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);

  /* Free instance data */
  covrtFreeInstanceData(&emlrtCoverageInstance);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void BubbleCenterAndSizeByCircle_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (BubbleCenterAndSizeByCircle_terminate.c) */
