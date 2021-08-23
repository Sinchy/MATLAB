/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * hypot.c
 *
 * Code generation for function 'hypot'
 *
 */

/* Include files */
#include "hypot.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "scalexpAlloc.h"

/* Variable Definitions */
static emlrtRSInfo yb_emlrtRSI = { 13, /* lineNo */
  "hypot",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\hypot.m"/* pathName */
};

static emlrtRSInfo ac_emlrtRSI = { 46, /* lineNo */
  "applyBinaryScalarFunction",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\applyBinaryScalarFunction.m"/* pathName */
};

static emlrtRSInfo bc_emlrtRSI = { 66, /* lineNo */
  "applyBinaryScalarFunction",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\applyBinaryScalarFunction.m"/* pathName */
};

static emlrtRSInfo cc_emlrtRSI = { 202,/* lineNo */
  "flatIter",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\applyBinaryScalarFunction.m"/* pathName */
};

static emlrtRTEInfo q_emlrtRTEI = { 19,/* lineNo */
  23,                                  /* colNo */
  "scalexpAlloc",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\scalexpAlloc.m"/* pName */
};

static emlrtRTEInfo nd_emlrtRTEI = { 46,/* lineNo */
  6,                                   /* colNo */
  "applyBinaryScalarFunction",         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\applyBinaryScalarFunction.m"/* pName */
};

static emlrtRTEInfo od_emlrtRTEI = { 13,/* lineNo */
  5,                                   /* colNo */
  "hypot",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\hypot.m"/* pName */
};

/* Function Definitions */
void b_hypot(const emlrtStack *sp, const emxArray_real32_T *x, const
             emxArray_real32_T *y, emxArray_real32_T *r)
{
  emxArray_real32_T *z;
  int32_T csz_idx_0;
  int32_T csz_idx_1;
  int32_T i;
  boolean_T overflow;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real32_T(sp, &z, 2, &nd_emlrtRTEI, true);
  st.site = &yb_emlrtRSI;
  b_st.site = &ac_emlrtRSI;
  if (x->size[0] <= y->size[0]) {
    csz_idx_0 = x->size[0];
  } else {
    csz_idx_0 = y->size[0];
  }

  if (x->size[1] <= y->size[1]) {
    csz_idx_1 = x->size[1];
  } else {
    csz_idx_1 = y->size[1];
  }

  i = z->size[0] * z->size[1];
  z->size[0] = csz_idx_0;
  z->size[1] = csz_idx_1;
  emxEnsureCapacity_real32_T(&b_st, z, i, &nd_emlrtRTEI);
  if (!dimagree(z, x, y)) {
    emlrtErrorWithMessageIdR2018a(&b_st, &q_emlrtRTEI, "MATLAB:dimagree",
      "MATLAB:dimagree", 0);
  }

  emxFree_real32_T(&z);
  i = r->size[0] * r->size[1];
  r->size[0] = csz_idx_0;
  r->size[1] = csz_idx_1;
  emxEnsureCapacity_real32_T(&st, r, i, &od_emlrtRTEI);
  b_st.site = &bc_emlrtRSI;
  csz_idx_0 *= csz_idx_1;
  c_st.site = &cc_emlrtRSI;
  overflow = ((1 <= csz_idx_0) && (csz_idx_0 > 2147483646));
  if (overflow) {
    d_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  for (csz_idx_1 = 0; csz_idx_1 < csz_idx_0; csz_idx_1++) {
    r->data[csz_idx_1] = muSingleScalarHypot(x->data[csz_idx_1], y->
      data[csz_idx_1]);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

void c_hypot(const emlrtStack *sp, const emxArray_real_T *x, const
             emxArray_real_T *y, emxArray_real_T *r)
{
  emxArray_real_T *z;
  int32_T csz_idx_0;
  int32_T csz_idx_1;
  int32_T i;
  boolean_T overflow;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &z, 2, &nd_emlrtRTEI, true);
  st.site = &yb_emlrtRSI;
  b_st.site = &ac_emlrtRSI;
  if (x->size[0] <= y->size[0]) {
    csz_idx_0 = x->size[0];
  } else {
    csz_idx_0 = y->size[0];
  }

  if (x->size[1] <= y->size[1]) {
    csz_idx_1 = x->size[1];
  } else {
    csz_idx_1 = y->size[1];
  }

  i = z->size[0] * z->size[1];
  z->size[0] = csz_idx_0;
  z->size[1] = csz_idx_1;
  emxEnsureCapacity_real_T(&b_st, z, i, &nd_emlrtRTEI);
  if (!b_dimagree(z, x, y)) {
    emlrtErrorWithMessageIdR2018a(&b_st, &q_emlrtRTEI, "MATLAB:dimagree",
      "MATLAB:dimagree", 0);
  }

  emxFree_real_T(&z);
  i = r->size[0] * r->size[1];
  r->size[0] = csz_idx_0;
  r->size[1] = csz_idx_1;
  emxEnsureCapacity_real_T(&st, r, i, &od_emlrtRTEI);
  b_st.site = &bc_emlrtRSI;
  csz_idx_0 *= csz_idx_1;
  c_st.site = &cc_emlrtRSI;
  overflow = ((1 <= csz_idx_0) && (csz_idx_0 > 2147483646));
  if (overflow) {
    d_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  for (csz_idx_1 = 0; csz_idx_1 < csz_idx_0; csz_idx_1++) {
    r->data[csz_idx_1] = muDoubleScalarHypot(x->data[csz_idx_1], y->
      data[csz_idx_1]);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (hypot.c) */
