/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_BubbleCenterAndSize_api.h
 *
 * Code generation for function '_coder_BubbleCenterAndSize_api'
 *
 */

#ifndef _CODER_BUBBLECENTERANDSIZE_API_H
#define _CODER_BUBBLECENTERANDSIZE_API_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Type Definitions */
#ifndef struct_emxArray_boolean_T
#define struct_emxArray_boolean_T

struct emxArray_boolean_T
{
  boolean_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_boolean_T*/

#ifndef typedef_emxArray_boolean_T
#define typedef_emxArray_boolean_T

typedef struct emxArray_boolean_T emxArray_boolean_T;

#endif                                 /*typedef_emxArray_boolean_T*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  real_T Centroid[2];
  real_T MajorAxisLength;
  real_T MinorAxisLength;
} struct0_T;

#endif                                 /*typedef_struct0_T*/

#ifndef typedef_emxArray_struct0_T
#define typedef_emxArray_struct0_T

typedef struct {
  struct0_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
} emxArray_struct0_T;

#endif                                 /*typedef_emxArray_struct0_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void BubbleCenterAndSize(emxArray_boolean_T *img, emxArray_struct0_T *s);
extern void BubbleCenterAndSize_api(const mxArray * const prhs[1], int32_T nlhs,
  const mxArray *plhs[1]);
extern void BubbleCenterAndSize_atexit(void);
extern void BubbleCenterAndSize_initialize(void);
extern void BubbleCenterAndSize_terminate(void);
extern void BubbleCenterAndSize_xil_shutdown(void);
extern void BubbleCenterAndSize_xil_terminate(void);

#endif

/* End of code generation (_coder_BubbleCenterAndSize_api.h) */
