/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * meshgrid.c
 *
 * Code generation for function 'meshgrid'
 *
 */

/* Include files */
#include "meshgrid.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo rk_emlrtRSI = { 31, /* lineNo */
  "meshgrid",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\meshgrid.m"/* pathName */
};

static emlrtRSInfo sk_emlrtRSI = { 32, /* lineNo */
  "meshgrid",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\meshgrid.m"/* pathName */
};

static emlrtRTEInfo mh_emlrtRTEI = { 1,/* lineNo */
  23,                                  /* colNo */
  "meshgrid",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\meshgrid.m"/* pName */
};

/* Function Definitions */
void meshgrid(const emlrtStack *sp, const emxArray_real_T *x, const
              emxArray_real_T *y, emxArray_real_T *xx, emxArray_real_T *yy)
{
  int32_T nx;
  int32_T ny;
  int32_T j;
  boolean_T overflow;
  int32_T i;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nx = x->size[1];
  ny = y->size[1];
  j = xx->size[0] * xx->size[1];
  xx->size[0] = y->size[1];
  xx->size[1] = x->size[1];
  emxEnsureCapacity_real_T(sp, xx, j, &mh_emlrtRTEI);
  j = yy->size[0] * yy->size[1];
  yy->size[0] = y->size[1];
  yy->size[1] = x->size[1];
  emxEnsureCapacity_real_T(sp, yy, j, &mh_emlrtRTEI);
  if ((x->size[1] != 0) && (y->size[1] != 0)) {
    st.site = &rk_emlrtRSI;
    if (x->size[1] > 2147483646) {
      b_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    if (0 <= x->size[1] - 1) {
      if (1 > y->size[1]) {
        overflow = false;
      } else {
        overflow = (y->size[1] > 2147483646);
      }
    }

    for (j = 0; j < nx; j++) {
      st.site = &sk_emlrtRSI;
      if (overflow) {
        b_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (i = 0; i < ny; i++) {
        xx->data[i + xx->size[0] * j] = x->data[j];
        yy->data[i + yy->size[0] * j] = y->data[i];
      }
    }
  }
}

/* End of code generation (meshgrid.c) */
