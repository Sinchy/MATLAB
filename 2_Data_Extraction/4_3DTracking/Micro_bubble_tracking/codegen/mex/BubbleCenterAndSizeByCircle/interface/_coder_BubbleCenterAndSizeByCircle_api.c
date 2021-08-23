/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_BubbleCenterAndSizeByCircle_api.c
 *
 * Code generation for function '_coder_BubbleCenterAndSizeByCircle_api'
 *
 */

/* Include files */
#include "_coder_BubbleCenterAndSizeByCircle_api.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo nh_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "_coder_BubbleCenterAndSizeByCircle_api",/* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_boolean_T *y);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *rmin,
  const char_T *identifier);
static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_boolean_T *ret);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *img, const
  char_T *identifier, emxArray_boolean_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_boolean_T *y)
{
  e_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *rmin,
  const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(rmin), &thisId);
  emlrtDestroyArray(&rmin);
  return y;
}

static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = f_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_boolean_T *ret)
{
  static const int32_T dims[2] = { -1, -1 };

  const boolean_T bv[2] = { true, true };

  int32_T iv[2];
  int32_T i;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "logical", false, 2U, dims, &bv[0],
    iv);
  ret->allocatedSize = iv[0] * iv[1];
  i = ret->size[0] * ret->size[1];
  ret->size[0] = iv[0];
  ret->size[1] = iv[1];
  emxEnsureCapacity_boolean_T(sp, ret, i, (emlrtRTEInfo *)NULL);
  ret->data = (boolean_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *img, const
  char_T *identifier, emxArray_boolean_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(img), &thisId, y);
  emlrtDestroyArray(&img);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[2] = { 0, 0 };

  y = NULL;
  m = emlrtCreateNumericArray(2, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, &u->data[0]);
  emlrtSetDimensions((mxArray *)m, u->size, 2);
  emlrtAssign(&y, m);
  return y;
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void BubbleCenterAndSizeByCircle_api(const mxArray * const prhs[4], int32_T nlhs,
  const mxArray *plhs[2])
{
  emxArray_boolean_T *img;
  emxArray_real_T *centers;
  emxArray_real_T *radii;
  real_T rmin;
  real_T rmax;
  real_T sense;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_boolean_T(&st, &img, 2, &nh_emlrtRTEI, true);
  emxInit_real_T(&st, &centers, 2, &nh_emlrtRTEI, true);
  emxInit_real_T(&st, &radii, 2, &nh_emlrtRTEI, true);

  /* Marshall function inputs */
  img->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "img", img);
  rmin = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "rmin");
  rmax = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "rmax");
  sense = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "sense");

  /* Invoke the target function */
  BubbleCenterAndSizeByCircle(&st, img, rmin, rmax, sense, centers, radii);

  /* Marshall function outputs */
  centers->canFreeData = false;
  plhs[0] = emlrt_marshallOut(centers);
  emxFree_real_T(&centers);
  emxFree_boolean_T(&img);
  if (nlhs > 1) {
    radii->canFreeData = false;
    plhs[1] = emlrt_marshallOut(radii);
  }

  emxFree_real_T(&radii);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_BubbleCenterAndSizeByCircle_api.c) */
