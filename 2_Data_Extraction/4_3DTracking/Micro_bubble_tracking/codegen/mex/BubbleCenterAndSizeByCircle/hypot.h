/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * hypot.h
 *
 * Code generation for function 'hypot'
 *
 */

#pragma once

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "covrt.h"
#include "rtwtypes.h"
#include "BubbleCenterAndSizeByCircle_types.h"

/* Function Declarations */
void b_hypot(const emlrtStack *sp, const emxArray_real32_T *x, const
             emxArray_real32_T *y, emxArray_real32_T *r);
void c_hypot(const emlrtStack *sp, const emxArray_real_T *x, const
             emxArray_real_T *y, emxArray_real_T *r);

/* End of code generation (hypot.h) */
