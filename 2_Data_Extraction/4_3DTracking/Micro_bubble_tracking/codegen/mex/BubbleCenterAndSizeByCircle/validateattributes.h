/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * validateattributes.h
 *
 * Code generation for function 'validateattributes'
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
void b_validateattributes(const emlrtStack *sp, const real_T a[2]);
void c_validateattributes(const emlrtStack *sp, const emxArray_real_T *a);
void d_validateattributes(const emlrtStack *sp, const emxArray_real_T *a);
void e_validateattributes(const emlrtStack *sp, const real_T a_data[], const
  int32_T a_size[2]);
void validateattributes(const emlrtStack *sp, const real_T a[2]);

/* End of code generation (validateattributes.h) */
