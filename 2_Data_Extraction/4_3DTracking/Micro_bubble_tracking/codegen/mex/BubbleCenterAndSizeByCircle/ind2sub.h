/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ind2sub.h
 *
 * Code generation for function 'ind2sub'
 *
 */

#pragma once

/* Include files */
#include "BubbleCenterAndSizeByCircle_types.h"
#include "rtwtypes.h"
#include "covrt.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void ind2sub_indexClass(const emlrtStack *sp, const real_T siz[2],
                        const emxArray_real_T *ndx,
                        emxArray_int32_T *varargout_1,
                        emxArray_int32_T *varargout_2);

/* End of code generation (ind2sub.h) */
