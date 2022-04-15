/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BubbleCenterAndSizeByCircle.h
 *
 * Code generation for function 'BubbleCenterAndSizeByCircle'
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
void BubbleCenterAndSizeByCircle(const emlrtStack *sp,
                                 const emxArray_uint8_T *img, real_T rmin,
                                 real_T rmax, real_T sense,
                                 emxArray_real_T *centers,
                                 emxArray_real_T *radii,
                                 emxArray_real_T *metrics);

/* End of code generation (BubbleCenterAndSizeByCircle.h) */
