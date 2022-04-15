/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sub2ind.h
 *
 * Code generation for function 'sub2ind'
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
void eml_sub2ind(const emlrtStack *sp, const int32_T siz[2],
                 const emxArray_real_T *varargin_1,
                 const emxArray_real_T *varargin_2, emxArray_int32_T *idx);

/* End of code generation (sub2ind.h) */
