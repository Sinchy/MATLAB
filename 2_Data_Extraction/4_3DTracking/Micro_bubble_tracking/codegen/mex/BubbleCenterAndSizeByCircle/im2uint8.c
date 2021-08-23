/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * im2uint8.c
 *
 * Code generation for function 'im2uint8'
 *
 */

/* Include files */
#include "im2uint8.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "libmwgrayto8.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo ne_emlrtRSI = { 39, /* lineNo */
  "im2uint8",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\im2uint8.m"/* pathName */
};

static emlrtRSInfo oe_emlrtRSI = { 138,/* lineNo */
  "uint8SharedLibraryAlgo",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\im2uint8.m"/* pathName */
};

static emlrtRTEInfo oe_emlrtRTEI = { 138,/* lineNo */
  9,                                   /* colNo */
  "im2uint8",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\im2uint8.m"/* pName */
};

/* Function Definitions */
void im2uint8(const emlrtStack *sp, const emxArray_real32_T *img,
              emxArray_uint8_T *u)
{
  int32_T i;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ne_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b_st.site = &oe_emlrtRSI;
  i = u->size[0];
  u->size[0] = img->size[0];
  emxEnsureCapacity_uint8_T(&b_st, u, i, &oe_emlrtRTEI);
  grayto8_real32(&img->data[0], &u->data[0], (real_T)img->size[0]);
}

/* End of code generation (im2uint8.c) */
