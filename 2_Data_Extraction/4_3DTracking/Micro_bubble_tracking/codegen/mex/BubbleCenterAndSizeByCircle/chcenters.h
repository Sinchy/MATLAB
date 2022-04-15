/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * chcenters.h
 *
 * Code generation for function 'chcenters'
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
void chcenters(const emlrtStack *sp, const emxArray_creal_T *varargin_1,
               real_T varargin_2, emxArray_real_T *centers,
               emxArray_real_T *metric);

/* End of code generation (chcenters.h) */
