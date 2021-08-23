/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * imfindcircles.h
 *
 * Code generation for function 'imfindcircles'
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
void imfindcircles(const emlrtStack *sp, const emxArray_boolean_T *varargin_1,
                   const real_T varargin_2[2], real_T varargin_6,
                   emxArray_real_T *centers, emxArray_real_T *r_estimated);

/* End of code generation (imfindcircles.h) */
