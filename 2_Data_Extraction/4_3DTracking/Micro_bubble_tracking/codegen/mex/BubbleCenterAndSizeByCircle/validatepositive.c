/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * validatepositive.c
 *
 * Code generation for function 'validatepositive'
 *
 */

/* Include files */
#include "validatepositive.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void validatepositive(const emlrtStack *sp, const real_T a_data[], const int32_T
                      a_size[2])
{
  boolean_T p;
  int32_T k;
  boolean_T exitg1;
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
    emlrtErrorWithMessageIdR2018a(sp, &j_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedPositive",
      "MATLAB:chaccum:expectedPositive", 3, 4, 29,
      "input number 2, RADIUS_RANGE,");
  }
}

/* End of code generation (validatepositive.c) */
