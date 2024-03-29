/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * regionprops.h
 *
 * Code generation for function 'regionprops'
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
void regionprops(const emlrtStack *sp, const emxArray_boolean_T *varargin_1,
                 const emxArray_real_T *varargin_2,
                 emxArray_struct_T *outstats);

/* End of code generation (regionprops.h) */
