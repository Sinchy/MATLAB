/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * validateattributes.c
 *
 * Code generation for function 'validateattributes'
 *
 */

/* Include files */
#include "validateattributes.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo kb_emlrtRTEI = { 18,/* lineNo */
  23,                                  /* colNo */
  "validatencols",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+valattr\\validatencols.m"/* pName */
};

static emlrtRTEInfo lb_emlrtRTEI = { 18,/* lineNo */
  23,                                  /* colNo */
  "validatenumel",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+valattr\\validatenumel.m"/* pName */
};

/* Function Definitions */
void b_validateattributes(const emlrtStack *sp, const real_T a[2])
{
  boolean_T p;
  int32_T k;
  boolean_T exitg1;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!muDoubleScalarIsNaN(a[k])) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonNaN",
      "MATLAB:padarray:expectedNonNaN", 3, 4, 24, "input number 2, PADSIZE,");
  }

  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if ((!muDoubleScalarIsInf(a[k])) && (!muDoubleScalarIsNaN(a[k])) &&
        (muDoubleScalarFloor(a[k]) == a[k])) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedInteger",
      "MATLAB:padarray:expectedInteger", 3, 4, 24, "input number 2, PADSIZE,");
  }
}

void c_validateattributes(const emlrtStack *sp, const emxArray_real_T *a)
{
  boolean_T p;
  int32_T i;
  int32_T k;
  boolean_T exitg1;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &n_emlrtRSI;
  p = true;
  i = a->size[0] * a->size[1];
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k <= i - 1)) {
    if (!muDoubleScalarIsNaN(a->data[k])) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonNaN",
      "MATLAB:imreconstruct:expectedNonNaN", 3, 4, 5, "input");
  }
}

void d_validateattributes(const emlrtStack *sp, const emxArray_real_T *a)
{
  boolean_T p;
  int32_T i;
  int32_T k;
  boolean_T exitg1;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &n_emlrtRSI;
  p = true;
  i = a->size[0] * a->size[1];
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k <= i - 1)) {
    if (!(a->data[k] <= 0.0)) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &j_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedPositive",
      "MATLAB:chradii:expectedPositive", 3, 4, 24, "input number 1, centers,");
  }

  st.site = &n_emlrtRSI;
  if ((a->size[0] == 0) || (a->size[1] == 0)) {
    emlrtErrorWithMessageIdR2018a(&st, &c_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonempty",
      "MATLAB:chradii:expectedNonempty", 3, 4, 24, "input number 1, centers,");
  }

  st.site = &n_emlrtRSI;
  if (a->size[1] != 2) {
    emlrtErrorWithMessageIdR2018a(&st, &kb_emlrtRTEI,
      "Coder:toolbox:ValidateattributesincorrectNumcols",
      "MATLAB:chradii:incorrectNumcols", 5, 4, 24, "input number 1, centers,", 6,
      2.0);
  }
}

void e_validateattributes(const emlrtStack *sp, const real_T a_data[], const
  int32_T a_size[2])
{
  boolean_T p;
  int32_T k;
  boolean_T exitg1;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k <= a_size[1] - 1)) {
    if (!muDoubleScalarIsNaN(a_data[k])) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonNaN",
      "MATLAB:chradii:expectedNonNaN", 3, 4, 18, "input number 3, R,");
  }

  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k <= a_size[1] - 1)) {
    if ((!muDoubleScalarIsInf(a_data[k])) && (!muDoubleScalarIsNaN(a_data[k])) &&
        (muDoubleScalarFloor(a_data[k]) == a_data[k])) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedInteger",
      "MATLAB:chradii:expectedInteger", 3, 4, 18, "input number 3, R,");
  }

  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k <= a_size[1] - 1)) {
    if (!(a_data[k] <= 0.0)) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &j_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedPositive",
      "MATLAB:chradii:expectedPositive", 3, 4, 18, "input number 3, R,");
  }

  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k <= a_size[1] - 1)) {
    if ((!muDoubleScalarIsInf(a_data[k])) && (!muDoubleScalarIsNaN(a_data[k])))
    {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedFinite",
      "MATLAB:chradii:expectedFinite", 3, 4, 18, "input number 3, R,");
  }

  st.site = &n_emlrtRSI;
  if (a_size[1] != 2) {
    emlrtErrorWithMessageIdR2018a(&st, &lb_emlrtRTEI,
      "Coder:toolbox:ValidateattributesincorrectNumel",
      "MATLAB:chradii:incorrectNumel", 5, 4, 18, "input number 3, R,", 6, 2.0);
  }
}

void validateattributes(const emlrtStack *sp, const real_T a[2])
{
  boolean_T p;
  int32_T k;
  boolean_T exitg1;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if ((!muDoubleScalarIsInf(a[k])) && (!muDoubleScalarIsNaN(a[k])) &&
        (muDoubleScalarFloor(a[k]) == a[k])) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedInteger",
      "MATLAB:imfindcircles:expectedInteger", 3, 4, 29,
      "input number 2, RADIUS_RANGE,");
  }

  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!muDoubleScalarIsNaN(a[k])) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonNaN",
      "MATLAB:imfindcircles:expectedNonNaN", 3, 4, 29,
      "input number 2, RADIUS_RANGE,");
  }

  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!(a[k] <= 0.0)) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &j_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedPositive",
      "MATLAB:imfindcircles:expectedPositive", 3, 4, 29,
      "input number 2, RADIUS_RANGE,");
  }

  st.site = &n_emlrtRSI;
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if ((!muDoubleScalarIsInf(a[k])) && (!muDoubleScalarIsNaN(a[k]))) {
      k++;
    } else {
      p = false;
      exitg1 = true;
    }
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedFinite",
      "MATLAB:imfindcircles:expectedFinite", 3, 4, 29,
      "input number 2, RADIUS_RANGE,");
  }
}

/* End of code generation (validateattributes.c) */
