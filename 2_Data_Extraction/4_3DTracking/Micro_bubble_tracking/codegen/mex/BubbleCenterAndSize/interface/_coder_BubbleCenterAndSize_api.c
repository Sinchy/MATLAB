/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_BubbleCenterAndSize_api.c
 *
 * Code generation for function '_coder_BubbleCenterAndSize_api'
 *
 */

/* Include files */
#include "_coder_BubbleCenterAndSize_api.h"
#include "BubbleCenterAndSize.h"
#include "BubbleCenterAndSize_data.h"
#include "BubbleCenterAndSize_emxutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo db_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "_coder_BubbleCenterAndSize_api",    /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_boolean_T *y);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_boolean_T *ret);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *img, const
  char_T *identifier, emxArray_boolean_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_struct0_T *u);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_boolean_T *y)
{
  c_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
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

static const mxArray *emlrt_marshallOut(const emxArray_struct0_T *u)
{
  const mxArray *y;
  int32_T iv[1];
  static const char * sv[3] = { "Centroid", "MajorAxisLength", "MinorAxisLength"
  };

  int32_T i;
  int32_T b_j0;
  const mxArray *b_y;
  const mxArray *m;
  static const int32_T iv1[2] = { 1, 2 };

  real_T *pData;
  const mxArray *m1;
  const mxArray *m2;
  y = NULL;
  iv[0] = u->size[0];
  emlrtAssign(&y, emlrtCreateStructArray(1, iv, 3, sv));
  emlrtCreateField(y, "Centroid");
  emlrtCreateField(y, "MajorAxisLength");
  emlrtCreateField(y, "MinorAxisLength");
  i = 0;
  for (b_j0 = 0; b_j0 < u->size[0U]; b_j0++) {
    b_y = NULL;
    m = emlrtCreateNumericArray(2, &iv1[0], mxDOUBLE_CLASS, mxREAL);
    pData = emlrtMxGetPr(m);
    pData[0] = u->data[b_j0].Centroid[0];
    pData[1] = u->data[b_j0].Centroid[1];
    emlrtAssign(&b_y, m);
    emlrtSetFieldR2017b(y, i, "Centroid", b_y, 0);
    b_y = NULL;
    m1 = emlrtCreateDoubleScalar(u->data[b_j0].MajorAxisLength);
    emlrtAssign(&b_y, m1);
    emlrtSetFieldR2017b(y, i, "MajorAxisLength", b_y, 1);
    b_y = NULL;
    m2 = emlrtCreateDoubleScalar(u->data[b_j0].MinorAxisLength);
    emlrtAssign(&b_y, m2);
    emlrtSetFieldR2017b(y, i, "MinorAxisLength", b_y, 2);
    i++;
  }

  return y;
}

void BubbleCenterAndSize_api(const mxArray * const prhs[1], int32_T nlhs, const
  mxArray *plhs[1])
{
  emxArray_boolean_T *img;
  emxArray_struct0_T *s;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_boolean_T(&st, &img, 2, &db_emlrtRTEI, true);
  emxInit_struct0_T(&st, &s, 1, &db_emlrtRTEI, true);

  /* Marshall function inputs */
  img->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "img", img);

  /* Invoke the target function */
  BubbleCenterAndSize(&st, img, s);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(s);
  emxFree_struct0_T(&s);
  emxFree_boolean_T(&img);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_BubbleCenterAndSize_api.c) */
