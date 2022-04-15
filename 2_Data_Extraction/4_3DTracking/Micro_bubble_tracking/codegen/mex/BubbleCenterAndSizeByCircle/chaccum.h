/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * chaccum.h
 *
 * Code generation for function 'chaccum'
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
void chaccum(const emlrtStack *sp, const emxArray_uint8_T *varargin_1,
             const real_T varargin_2_data[], const int32_T varargin_2_size[2],
             emxArray_creal_T *accumMatrix, emxArray_real32_T *gradientImg);

/* End of code generation (chaccum.h) */
