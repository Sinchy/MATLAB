/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_BubbleCenterAndSizeByCircle_api.h
 *
 * Code generation for function '_coder_BubbleCenterAndSizeByCircle_api'
 *
 */

#ifndef _CODER_BUBBLECENTERANDSIZEBYCIRCLE_API_H
#define _CODER_BUBBLECENTERANDSIZEBYCIRCLE_API_H

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

#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#define MAX_THREADS                    omp_get_max_threads()

/* Function Declarations */
extern void BubbleCenterAndSizeByCircle(emxArray_boolean_T *img, real_T rmin,
  real_T rmax, real_T sense, emxArray_real_T *centers, emxArray_real_T *radii);
extern void BubbleCenterAndSizeByCircle_api(const mxArray * const prhs[4],
  int32_T nlhs, const mxArray *plhs[2]);
extern void BubbleCenterAndSizeByCircle_atexit(void);
extern void BubbleCenterAndSizeByCircle_initialize(void);
extern void BubbleCenterAndSizeByCircle_terminate(void);
extern void BubbleCenterAndSizeByCircle_xil_shutdown(void);
extern void BubbleCenterAndSizeByCircle_xil_terminate(void);

#endif

/* End of code generation (_coder_BubbleCenterAndSizeByCircle_api.h) */
