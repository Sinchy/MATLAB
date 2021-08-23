/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * colon.c
 *
 * Code generation for function 'colon'
 *
 */

/* Include files */
#include "colon.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo cg_emlrtRSI = { 288,/* lineNo */
  "eml_float_colon",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pathName */
};

static emlrtRTEInfo x_emlrtRTEI = { 405,/* lineNo */
  15,                                  /* colNo */
  "assert_pmaxsize",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pName */
};

static emlrtRTEInfo af_emlrtRTEI = { 279,/* lineNo */
  14,                                  /* colNo */
  "colon",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pName */
};

/* Function Definitions */
void b_eml_float_colon(const emlrtStack *sp, real_T a, real_T b, emxArray_real_T
  *y)
{
  real_T ndbl;
  real_T apnd;
  real_T cdiff;
  real_T absa;
  real_T absb;
  int32_T n;
  int32_T nm1d2;
  int32_T k;
  int32_T y_tmp;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  ndbl = muDoubleScalarFloor((b - a) + 0.5);
  apnd = a + ndbl;
  cdiff = apnd - b;
  absa = muDoubleScalarAbs(a);
  absb = muDoubleScalarAbs(b);
  if (absa > absb) {
    absb = absa;
  }

  if (muDoubleScalarAbs(cdiff) < 4.4408920985006262E-16 * absb) {
    ndbl++;
    apnd = b;
  } else if (cdiff > 0.0) {
    apnd = a + (ndbl - 1.0);
  } else {
    ndbl++;
  }

  if (ndbl >= 0.0) {
    n = (int32_T)ndbl;
  } else {
    n = 0;
  }

  st.site = &cg_emlrtRSI;
  if (ndbl > 2.147483647E+9) {
    emlrtErrorWithMessageIdR2018a(&st, &x_emlrtRTEI, "Coder:MATLAB:pmaxsize",
      "Coder:MATLAB:pmaxsize", 0);
  }

  nm1d2 = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = n;
  emxEnsureCapacity_real_T(sp, y, nm1d2, &af_emlrtRTEI);
  if (n > 0) {
    y->data[0] = a;
    if (n > 1) {
      y->data[n - 1] = apnd;
      nm1d2 = (n - 1) / 2;
      for (k = 0; k <= nm1d2 - 2; k++) {
        y_tmp = k + 1;
        y->data[k + 1] = a + (real_T)y_tmp;
        y->data[(n - k) - 2] = apnd - (real_T)y_tmp;
      }

      if (nm1d2 << 1 == n - 1) {
        y->data[nm1d2] = (a + apnd) / 2.0;
      } else {
        y->data[nm1d2] = a + (real_T)nm1d2;
        y->data[nm1d2 + 1] = apnd - (real_T)nm1d2;
      }
    }
  }
}

void eml_float_colon(const emlrtStack *sp, real_T a, real_T b, emxArray_real_T
                     *y)
{
  real_T ndbl;
  real_T apnd;
  real_T cdiff;
  real_T absa;
  real_T absb;
  int32_T n;
  int32_T nm1d2;
  int32_T k;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  ndbl = muDoubleScalarFloor((b - a) / 0.5 + 0.5);
  apnd = a + ndbl * 0.5;
  cdiff = apnd - b;
  absa = muDoubleScalarAbs(a);
  absb = muDoubleScalarAbs(b);
  if (absa > absb) {
    absb = absa;
  }

  if (muDoubleScalarAbs(cdiff) < 4.4408920985006262E-16 * absb) {
    ndbl++;
    apnd = b;
  } else if (cdiff > 0.0) {
    apnd = a + (ndbl - 1.0) * 0.5;
  } else {
    ndbl++;
  }

  if (ndbl >= 0.0) {
    n = (int32_T)ndbl;
  } else {
    n = 0;
  }

  st.site = &cg_emlrtRSI;
  if (ndbl > 2.147483647E+9) {
    emlrtErrorWithMessageIdR2018a(&st, &x_emlrtRTEI, "Coder:MATLAB:pmaxsize",
      "Coder:MATLAB:pmaxsize", 0);
  }

  nm1d2 = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = n;
  emxEnsureCapacity_real_T(sp, y, nm1d2, &af_emlrtRTEI);
  if (n > 0) {
    y->data[0] = a;
    if (n > 1) {
      y->data[n - 1] = apnd;
      nm1d2 = (n - 1) / 2;
      for (k = 0; k <= nm1d2 - 2; k++) {
        ndbl = ((real_T)k + 1.0) * 0.5;
        y->data[k + 1] = a + ndbl;
        y->data[(n - k) - 2] = apnd - ndbl;
      }

      if (nm1d2 << 1 == n - 1) {
        y->data[nm1d2] = (a + apnd) / 2.0;
      } else {
        ndbl = (real_T)nm1d2 * 0.5;
        y->data[nm1d2] = a + ndbl;
        y->data[nm1d2 + 1] = apnd - ndbl;
      }
    }
  }
}

/* End of code generation (colon.c) */
