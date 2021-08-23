/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * chradii.h
 *
 * Code generation for function 'chradii'
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
void chradii(const emlrtStack *sp, const emxArray_real_T *varargin_1, const
             emxArray_real32_T *varargin_2, const real_T varargin_3_data[],
             const int32_T varargin_3_size[2], emxArray_real_T *r_estimated);

/* End of code generation (chradii.h) */
