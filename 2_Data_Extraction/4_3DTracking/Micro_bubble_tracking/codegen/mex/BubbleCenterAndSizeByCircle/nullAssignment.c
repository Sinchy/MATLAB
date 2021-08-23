/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nullAssignment.c
 *
 * Code generation for function 'nullAssignment'
 *
 */

/* Include files */
#include "nullAssignment.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo nf_emlrtRSI = { 13, /* lineNo */
  "nullAssignment",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRSInfo of_emlrtRSI = { 17, /* lineNo */
  "nullAssignment",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRSInfo pf_emlrtRSI = { 170,/* lineNo */
  "onearg_null_assignment",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRSInfo qf_emlrtRSI = { 173,/* lineNo */
  "onearg_null_assignment",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRSInfo rf_emlrtRSI = { 132,/* lineNo */
  "num_true",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRTEInfo ob_emlrtRTEI = { 85,/* lineNo */
  27,                                  /* colNo */
  "validate_inputs",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pName */
};

static emlrtRTEInfo pb_emlrtRTEI = { 185,/* lineNo */
  9,                                   /* colNo */
  "onearg_null_assignment",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pName */
};

static emlrtRTEInfo wh_emlrtRTEI = { 17,/* lineNo */
  9,                                   /* colNo */
  "nullAssignment",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pName */
};

/* Function Definitions */
void nullAssignment(const emlrtStack *sp, emxArray_real32_T *x, const
                    emxArray_boolean_T *idx)
{
  int32_T k;
  int32_T nxin;
  int32_T k0;
  int32_T nxout;
  boolean_T overflow;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &nf_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  k = idx->size[1];
  while ((k >= 1) && (!idx->data[k - 1])) {
    k--;
  }

  if (k > x->size[1]) {
    emlrtErrorWithMessageIdR2018a(&st, &ob_emlrtRTEI,
      "MATLAB:subsdeldimmismatch", "MATLAB:subsdeldimmismatch", 0);
  }

  st.site = &of_emlrtRSI;
  nxin = x->size[1];
  b_st.site = &pf_emlrtRSI;
  k0 = 0;
  nxout = idx->size[1];
  c_st.site = &rf_emlrtRSI;
  if (1 > idx->size[1]) {
    overflow = false;
  } else {
    overflow = (idx->size[1] > 2147483646);
  }

  if (overflow) {
    d_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  for (k = 0; k < nxout; k++) {
    k0 += idx->data[k];
  }

  nxout = x->size[1] - k0;
  k0 = -1;
  b_st.site = &qf_emlrtRSI;
  if (1 > x->size[1]) {
    overflow = false;
  } else {
    overflow = (x->size[1] > 2147483646);
  }

  if (overflow) {
    c_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < nxin; k++) {
    if ((k + 1 > idx->size[1]) || (!idx->data[k])) {
      k0++;
      x->data[k0] = x->data[k];
    }
  }

  if (nxout > nxin) {
    emlrtErrorWithMessageIdR2018a(&st, &pb_emlrtRTEI,
      "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
  }

  if (1 > nxout) {
    x->size[1] = 0;
  } else {
    k0 = x->size[0] * x->size[1];
    x->size[1] = nxout;
    emxEnsureCapacity_real32_T(&st, x, k0, &wh_emlrtRTEI);
  }
}

/* End of code generation (nullAssignment.c) */
