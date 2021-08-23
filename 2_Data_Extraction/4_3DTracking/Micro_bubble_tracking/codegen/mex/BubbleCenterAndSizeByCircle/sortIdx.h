/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sortIdx.h
 *
 * Code generation for function 'sortIdx'
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
void b_merge_block(const emlrtStack *sp, emxArray_int32_T *idx, emxArray_real_T *
                   x, int32_T offset, int32_T n, int32_T preSortLevel,
                   emxArray_int32_T *iwork, emxArray_real_T *xwork);
void b_merge_pow2_block(emxArray_int32_T *idx, emxArray_real_T *x, int32_T
  offset);
void merge_block(const emlrtStack *sp, emxArray_int32_T *idx, emxArray_real32_T *
                 x, int32_T offset, int32_T n, int32_T preSortLevel,
                 emxArray_int32_T *iwork, emxArray_real32_T *xwork);
void merge_pow2_block(emxArray_int32_T *idx, emxArray_real32_T *x, int32_T
                      offset);

/* End of code generation (sortIdx.h) */
