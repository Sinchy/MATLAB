/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BubbleCenterAndSize.c
 *
 * Code generation for function 'BubbleCenterAndSize'
 *
 */

/* Include files */
#include "BubbleCenterAndSize.h"
#include "BubbleCenterAndSize_data.h"
#include "regionprops.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 2,     /* lineNo */
  "BubbleCenterAndSize",               /* fcnName */
  "D:\\0.Code\\MATLAB\\2_Data_Extraction\\4_3DTracking\\Micro_bubble_tracking\\BubbleCenterAndSize.m"/* pathName */
};

/* Function Definitions */
void BubbleCenterAndSize(const emlrtStack *sp, const emxArray_boolean_T *img,
  emxArray_struct0_T *s)
{
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  covrtLogFcn(&emlrtCoverageInstance, 0U, 0U);
  covrtLogBasicBlock(&emlrtCoverageInstance, 0U, 0U);
  st.site = &emlrtRSI;
  regionprops(&st, img, s);
}

/* End of code generation (BubbleCenterAndSize.c) */
