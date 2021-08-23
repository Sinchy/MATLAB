/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BubbleCenterAndSize_terminate.c
 *
 * Code generation for function 'BubbleCenterAndSize_terminate'
 *
 */

/* Include files */
#include "BubbleCenterAndSize_terminate.h"
#include "BubbleCenterAndSize.h"
#include "BubbleCenterAndSize_data.h"
#include "_coder_BubbleCenterAndSize_mex.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void BubbleCenterAndSize_atexit(void)
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

void BubbleCenterAndSize_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (BubbleCenterAndSize_terminate.c) */
