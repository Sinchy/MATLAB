/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BubbleCenterAndSizeByCircle_emxutil.h
 *
 * Code generation for function 'BubbleCenterAndSizeByCircle_emxutil'
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
void emxCopyMatrix_real_T(real_T dst[2], const real_T src[2]);

void emxCopyMatrix_real_T1(real_T dst[4], const real_T src[4]);

void emxCopyMatrix_real_T2(real_T dst[16], const real_T src[16]);

void emxCopyStruct_struct_T(const emlrtStack *sp, b_struct_T *dst,
                            const b_struct_T *src,
                            const emlrtRTEInfo *srcLocation);

void emxCopy_boolean_T_0x0(emxArray_boolean_T_0x0 *dst,
                           const emxArray_boolean_T_0x0 *src);

void emxCopy_real_T(const emlrtStack *sp, emxArray_real_T **dst,
                    emxArray_real_T *const *src,
                    const emlrtRTEInfo *srcLocation);

void emxCopy_real_T_1x0(emxArray_real_T_1x0 *dst,
                        const emxArray_real_T_1x0 *src);

void emxEnsureCapacity_boolean_T(const emlrtStack *sp,
                                 emxArray_boolean_T *emxArray, int32_T oldNumel,
                                 const emlrtRTEInfo *srcLocation);

void emxEnsureCapacity_creal_T(const emlrtStack *sp, emxArray_creal_T *emxArray,
                               int32_T oldNumel,
                               const emlrtRTEInfo *srcLocation);

void emxEnsureCapacity_int32_T(const emlrtStack *sp, emxArray_int32_T *emxArray,
                               int32_T oldNumel,
                               const emlrtRTEInfo *srcLocation);

void emxEnsureCapacity_real32_T(const emlrtStack *sp,
                                emxArray_real32_T *emxArray, int32_T oldNumel,
                                const emlrtRTEInfo *srcLocation);

void emxEnsureCapacity_real_T(const emlrtStack *sp, emxArray_real_T *emxArray,
                              int32_T oldNumel,
                              const emlrtRTEInfo *srcLocation);

void emxEnsureCapacity_struct_T(const emlrtStack *sp,
                                emxArray_struct_T *emxArray, int32_T oldNumel,
                                const emlrtRTEInfo *srcLocation);

void emxEnsureCapacity_struct_T1(const emlrtStack *sp,
                                 b_emxArray_struct_T *emxArray,
                                 int32_T oldNumel,
                                 const emlrtRTEInfo *srcLocation);

void emxEnsureCapacity_uint32_T(const emlrtStack *sp,
                                emxArray_uint32_T *emxArray, int32_T oldNumel,
                                const emlrtRTEInfo *srcLocation);

void emxEnsureCapacity_uint8_T(const emlrtStack *sp, emxArray_uint8_T *emxArray,
                               int32_T oldNumel,
                               const emlrtRTEInfo *srcLocation);

void emxExpand_struct_T(const emlrtStack *sp, b_emxArray_struct_T *emxArray,
                        int32_T fromIndex, int32_T toIndex,
                        const emlrtRTEInfo *srcLocation);

void emxFreeStruct_struct_T(b_struct_T *pStruct);

void emxFree_boolean_T(emxArray_boolean_T **pEmxArray);

void emxFree_creal_T(emxArray_creal_T **pEmxArray);

void emxFree_int32_T(emxArray_int32_T **pEmxArray);

void emxFree_real32_T(emxArray_real32_T **pEmxArray);

void emxFree_real_T(emxArray_real_T **pEmxArray);

void emxFree_struct_T(emxArray_struct_T **pEmxArray);

void emxFree_struct_T1(b_emxArray_struct_T **pEmxArray);

void emxFree_uint32_T(emxArray_uint32_T **pEmxArray);

void emxFree_uint8_T(emxArray_uint8_T **pEmxArray);

void emxInitStruct_struct_T(const emlrtStack *sp, b_struct_T *pStruct,
                            const emlrtRTEInfo *srcLocation, boolean_T doPush);

void emxInit_boolean_T(const emlrtStack *sp, emxArray_boolean_T **pEmxArray,
                       int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                       boolean_T doPush);

void emxInit_creal_T(const emlrtStack *sp, emxArray_creal_T **pEmxArray,
                     int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                     boolean_T doPush);

void emxInit_int32_T(const emlrtStack *sp, emxArray_int32_T **pEmxArray,
                     int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                     boolean_T doPush);

void emxInit_real32_T(const emlrtStack *sp, emxArray_real32_T **pEmxArray,
                      int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                      boolean_T doPush);

void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray,
                    int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                    boolean_T doPush);

void emxInit_struct_T(const emlrtStack *sp, emxArray_struct_T **pEmxArray,
                      int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                      boolean_T doPush);

void emxInit_struct_T1(const emlrtStack *sp, b_emxArray_struct_T **pEmxArray,
                       int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                       boolean_T doPush);

void emxInit_uint32_T(const emlrtStack *sp, emxArray_uint32_T **pEmxArray,
                      int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                      boolean_T doPush);

void emxInit_uint8_T(const emlrtStack *sp, emxArray_uint8_T **pEmxArray,
                     int32_T numDimensions, const emlrtRTEInfo *srcLocation,
                     boolean_T doPush);

void emxTrim_struct_T(b_emxArray_struct_T *emxArray, int32_T fromIndex,
                      int32_T toIndex);

/* End of code generation (BubbleCenterAndSizeByCircle_emxutil.h) */
