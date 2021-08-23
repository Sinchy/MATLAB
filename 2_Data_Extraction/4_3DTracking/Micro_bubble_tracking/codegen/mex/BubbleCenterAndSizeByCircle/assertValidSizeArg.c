/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * assertValidSizeArg.c
 *
 * Code generation for function 'assertValidSizeArg'
 *
 */

/* Include files */
#include "assertValidSizeArg.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo o_emlrtRTEI = { 49,/* lineNo */
  19,                                  /* colNo */
  "assertValidSizeArg",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\assertValidSizeArg.m"/* pName */
};

static emlrtRTEInfo p_emlrtRTEI = { 64,/* lineNo */
  15,                                  /* colNo */
  "assertValidSizeArg",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\assertValidSizeArg.m"/* pName */
};

static emlrtRTEInfo gb_emlrtRTEI = { 58,/* lineNo */
  23,                                  /* colNo */
  "assertValidSizeArg",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\assertValidSizeArg.m"/* pName */
};

/* Function Definitions */
void assertValidSizeArg(const emlrtStack *sp, const real_T varargin_1[2])
{
  int32_T k;
  boolean_T guard1 = false;
  int32_T exitg2;
  boolean_T exitg1;
  real_T n;
  k = 0;
  guard1 = false;
  do {
    exitg2 = 0;
    if (k < 2) {
      if ((varargin_1[k] != varargin_1[k]) || muDoubleScalarIsInf(varargin_1[k]))
      {
        guard1 = true;
        exitg2 = 1;
      } else {
        k++;
        guard1 = false;
      }
    } else {
      k = 0;
      exitg2 = 2;
    }
  } while (exitg2 == 0);

  if (exitg2 != 1) {
    exitg1 = false;
    while ((!exitg1) && (k < 2)) {
      if (varargin_1[k] > 2.147483647E+9) {
        guard1 = true;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }

  if (guard1) {
    emlrtErrorWithMessageIdR2018a(sp, &o_emlrtRTEI,
      "Coder:toolbox:eml_assert_valid_size_arg_invalidSizeVector",
      "Coder:toolbox:eml_assert_valid_size_arg_invalidSizeVector", 4, 12,
      MIN_int32_T, 12, MAX_int32_T);
  }

  if (varargin_1[0] <= 0.0) {
    n = 0.0;
  } else {
    n = varargin_1[0];
  }

  if (varargin_1[1] <= 0.0) {
    n = 0.0;
  } else {
    n *= varargin_1[1];
  }

  if (!(n <= 2.147483647E+9)) {
    emlrtErrorWithMessageIdR2018a(sp, &p_emlrtRTEI, "Coder:MATLAB:pmaxsize",
      "Coder:MATLAB:pmaxsize", 0);
  }
}

void b_assertValidSizeArg(const emlrtStack *sp, real_T varargin_1)
{
  real_T n;
  if ((varargin_1 != varargin_1) || muDoubleScalarIsInf(varargin_1) ||
      (varargin_1 > 2.147483647E+9)) {
    emlrtErrorWithMessageIdR2018a(sp, &gb_emlrtRTEI,
      "Coder:MATLAB:NonIntegerInput", "Coder:MATLAB:NonIntegerInput", 4, 12,
      MIN_int32_T, 12, MAX_int32_T);
  }

  if (varargin_1 <= 0.0) {
    n = 0.0;
  } else {
    n = varargin_1;
  }

  if (!(n <= 2.147483647E+9)) {
    emlrtErrorWithMessageIdR2018a(sp, &p_emlrtRTEI, "Coder:MATLAB:pmaxsize",
      "Coder:MATLAB:pmaxsize", 0);
  }
}

/* End of code generation (assertValidSizeArg.c) */
