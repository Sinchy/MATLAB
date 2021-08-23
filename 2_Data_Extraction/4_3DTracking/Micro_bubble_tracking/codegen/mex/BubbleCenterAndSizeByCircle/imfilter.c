/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * imfilter.c
 *
 * Code generation for function 'imfilter'
 *
 */

/* Include files */
#include "imfilter.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "assertValidSizeArg.h"
#include "libmwimfilter.h"
#include "libmwippfilter.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "validateattributes.h"

/* Variable Definitions */
static emlrtRSInfo hb_emlrtRSI = { 106,/* lineNo */
  "imfilter",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pathName */
};

static emlrtRSInfo ib_emlrtRSI = { 110,/* lineNo */
  "imfilter",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pathName */
};

static emlrtRSInfo jb_emlrtRSI = { 857,/* lineNo */
  "padImage",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pathName */
};

static emlrtRSInfo mb_emlrtRSI = { 80, /* lineNo */
  "padarray",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pathName */
};

static emlrtRSInfo ob_emlrtRSI = { 736,/* lineNo */
  "getPaddingIndices",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pathName */
};

static emlrtRSInfo rb_emlrtRSI = { 931,/* lineNo */
  "filterPartOrWhole",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pathName */
};

static emlrtRSInfo sb_emlrtRSI = { 1005,/* lineNo */
  "imfiltercore",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pathName */
};

static emlrtECInfo b_emlrtECI = { -1,  /* nDims */
  846,                                 /* lineNo */
  9,                                   /* colNo */
  "ReplicatePad",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pName */
};

static emlrtBCInfo sb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  846,                                 /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "ReplicatePad",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo emlrtDCI = { 830,   /* lineNo */
  33,                                  /* colNo */
  "ReplicatePad",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo tb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  100,                                 /* lineNo */
  30,                                  /* colNo */
  "",                                  /* aName */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ub_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  100,                                 /* lineNo */
  21,                                  /* colNo */
  "",                                  /* aName */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 83,  /* lineNo */
  56,                                  /* colNo */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  1                                    /* checkKind */
};

static emlrtRTEInfo fd_emlrtRTEI = { 857,/* lineNo */
  5,                                   /* colNo */
  "imfilter",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pName */
};

static emlrtRTEInfo gd_emlrtRTEI = { 736,/* lineNo */
  12,                                  /* colNo */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pName */
};

static emlrtRTEInfo id_emlrtRTEI = { 845,/* lineNo */
  9,                                   /* colNo */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pName */
};

static emlrtRTEInfo jd_emlrtRTEI = { 857,/* lineNo */
  9,                                   /* colNo */
  "imfilter",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pName */
};

static emlrtRTEInfo kd_emlrtRTEI = { 80,/* lineNo */
  5,                                   /* colNo */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pName */
};

static emlrtRTEInfo ld_emlrtRTEI = { 839,/* lineNo */
  9,                                   /* colNo */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pName */
};

static emlrtRTEInfo md_emlrtRTEI = { 845,/* lineNo */
  30,                                  /* colNo */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pName */
};

static emlrtRTEInfo oh_emlrtRTEI = { 1005,/* lineNo */
  11,                                  /* colNo */
  "imfilter",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pName */
};

static emlrtRTEInfo ph_emlrtRTEI = { 59,/* lineNo */
  9,                                   /* colNo */
  "imfilter",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pName */
};

/* Function Declarations */
static void padImage(const emlrtStack *sp, const emxArray_real32_T *a_tmp, const
                     real_T pad[2], emxArray_real32_T *a);

/* Function Definitions */
static void padImage(const emlrtStack *sp, const emxArray_real32_T *a_tmp, const
                     real_T pad[2], emxArray_real32_T *a)
{
  real_T sizeA_idx_0;
  real_T sizeA_idx_1;
  uint32_T varargin_1_tmp_tmp;
  real_T varargin_1[2];
  uint32_T b_varargin_1_tmp_tmp;
  int32_T i;
  int32_T i1;
  int32_T loop_ub;
  emxArray_int32_T *idxA;
  emxArray_real_T *y;
  int32_T b_loop_ub;
  emxArray_uint32_T *idxDir;
  uint32_T u;
  int32_T j;
  int32_T b_i;
  int32_T i2;
  int32_T i3;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &jb_emlrtRSI;
  b_st.site = &kb_emlrtRSI;
  b_validateattributes(&b_st, pad);
  if ((a_tmp->size[0] == 0) || (a_tmp->size[1] == 0)) {
    sizeA_idx_0 = (real_T)a_tmp->size[0] + 2.0 * pad[0];
    sizeA_idx_1 = (real_T)a_tmp->size[1] + 2.0 * pad[1];
    b_st.site = &lb_emlrtRSI;
    varargin_1[0] = sizeA_idx_0;
    varargin_1[1] = sizeA_idx_1;
    c_st.site = &nb_emlrtRSI;
    assertValidSizeArg(&c_st, varargin_1);
    i = (int32_T)sizeA_idx_0;
    i1 = a->size[0] * a->size[1];
    a->size[0] = i;
    loop_ub = (int32_T)sizeA_idx_1;
    a->size[1] = loop_ub;
    emxEnsureCapacity_real32_T(&b_st, a, i1, &fd_emlrtRTEI);
    loop_ub *= i;
    for (i = 0; i < loop_ub; i++) {
      a->data[i] = 0.0F;
    }
  } else {
    b_st.site = &mb_emlrtRSI;
    c_st.site = &ob_emlrtRSI;
    varargin_1_tmp_tmp = (uint32_T)a_tmp->size[0];
    varargin_1[0] = 2.0 * pad[0] + (real_T)varargin_1_tmp_tmp;
    b_varargin_1_tmp_tmp = (uint32_T)a_tmp->size[1];
    varargin_1[1] = 2.0 * pad[1] + (real_T)b_varargin_1_tmp_tmp;
    if ((varargin_1[0] < varargin_1[1]) || (muDoubleScalarIsNaN(varargin_1[0]) &&
         (!muDoubleScalarIsNaN(varargin_1[1])))) {
      sizeA_idx_0 = varargin_1[1];
    } else {
      sizeA_idx_0 = varargin_1[0];
    }

    if (sizeA_idx_0 != (int32_T)muDoubleScalarFloor(sizeA_idx_0)) {
      emlrtIntegerCheckR2012b(sizeA_idx_0, &emlrtDCI, &c_st);
    }

    emxInit_int32_T(&c_st, &idxA, 2, &kd_emlrtRTEI, true);
    i = (int32_T)sizeA_idx_0;
    i1 = idxA->size[0] * idxA->size[1];
    idxA->size[0] = i;
    idxA->size[1] = 2;
    emxEnsureCapacity_int32_T(&c_st, idxA, i1, &gd_emlrtRTEI);
    loop_ub = (int32_T)pad[0];
    emxInit_real_T(&c_st, &y, 2, &md_emlrtRTEI, true);
    i1 = y->size[0] * y->size[1];
    y->size[0] = 1;
    b_loop_ub = (int32_T)((real_T)varargin_1_tmp_tmp - 1.0);
    y->size[1] = b_loop_ub + 1;
    emxEnsureCapacity_real_T(&c_st, y, i1, &hd_emlrtRTEI);
    for (i1 = 0; i1 <= b_loop_ub; i1++) {
      y->data[i1] = (real_T)i1 + 1.0;
    }

    emxInit_uint32_T(&c_st, &idxDir, 2, &ld_emlrtRTEI, true);
    i1 = idxDir->size[0] * idxDir->size[1];
    idxDir->size[0] = 1;
    idxDir->size[1] = (loop_ub + y->size[1]) + loop_ub;
    emxEnsureCapacity_uint32_T(&c_st, idxDir, i1, &id_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      idxDir->data[i1] = 1U;
    }

    b_loop_ub = y->size[1];
    for (i1 = 0; i1 < b_loop_ub; i1++) {
      sizeA_idx_0 = muDoubleScalarRound(y->data[i1]);
      if (sizeA_idx_0 < 4.294967296E+9) {
        if (sizeA_idx_0 >= 0.0) {
          u = (uint32_T)sizeA_idx_0;
        } else {
          u = 0U;
        }
      } else if (sizeA_idx_0 >= 4.294967296E+9) {
        u = MAX_uint32_T;
      } else {
        u = 0U;
      }

      idxDir->data[i1 + loop_ub] = u;
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      idxDir->data[(i1 + loop_ub) + y->size[1]] = varargin_1_tmp_tmp;
    }

    if ((idxDir->size[1] < 1) || (idxDir->size[1] > i)) {
      emlrtDynamicBoundsCheckR2012b(idxDir->size[1], 1, i, &sb_emlrtBCI, &c_st);
    }

    emlrtSubAssignSizeCheckR2012b(&idxDir->size[1], 1, &idxDir->size[0], 2,
      &b_emlrtECI, &c_st);
    loop_ub = idxDir->size[1];
    for (i = 0; i < loop_ub; i++) {
      idxA->data[i] = (int32_T)idxDir->data[i];
    }

    loop_ub = (int32_T)pad[1];
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    b_loop_ub = (int32_T)((real_T)b_varargin_1_tmp_tmp - 1.0);
    y->size[1] = b_loop_ub + 1;
    emxEnsureCapacity_real_T(&c_st, y, i, &hd_emlrtRTEI);
    for (i = 0; i <= b_loop_ub; i++) {
      y->data[i] = (real_T)i + 1.0;
    }

    i = idxDir->size[0] * idxDir->size[1];
    idxDir->size[0] = 1;
    idxDir->size[1] = (loop_ub + y->size[1]) + loop_ub;
    emxEnsureCapacity_uint32_T(&c_st, idxDir, i, &id_emlrtRTEI);
    for (i = 0; i < loop_ub; i++) {
      idxDir->data[i] = 1U;
    }

    b_loop_ub = y->size[1];
    for (i = 0; i < b_loop_ub; i++) {
      sizeA_idx_0 = muDoubleScalarRound(y->data[i]);
      if (sizeA_idx_0 < 4.294967296E+9) {
        if (sizeA_idx_0 >= 0.0) {
          u = (uint32_T)sizeA_idx_0;
        } else {
          u = 0U;
        }
      } else if (sizeA_idx_0 >= 4.294967296E+9) {
        u = MAX_uint32_T;
      } else {
        u = 0U;
      }

      idxDir->data[i + loop_ub] = u;
    }

    for (i = 0; i < loop_ub; i++) {
      idxDir->data[(i + loop_ub) + y->size[1]] = b_varargin_1_tmp_tmp;
    }

    emxFree_real_T(&y);
    if ((idxDir->size[1] < 1) || (idxDir->size[1] > idxA->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idxDir->size[1], 1, idxA->size[0],
        &sb_emlrtBCI, &c_st);
    }

    emlrtSubAssignSizeCheckR2012b(&idxDir->size[1], 1, &idxDir->size[0], 2,
      &b_emlrtECI, &c_st);
    loop_ub = idxDir->size[1];
    for (i = 0; i < loop_ub; i++) {
      idxA->data[i + idxA->size[0]] = (int32_T)idxDir->data[i];
    }

    emxFree_uint32_T(&idxDir);
    sizeA_idx_0 = (real_T)a_tmp->size[0] + 2.0 * pad[0];
    if (sizeA_idx_0 != (int32_T)muDoubleScalarFloor(sizeA_idx_0)) {
      emlrtIntegerCheckR2012b(sizeA_idx_0, &b_emlrtDCI, &st);
    }

    sizeA_idx_1 = (real_T)a_tmp->size[1] + 2.0 * pad[1];
    if (sizeA_idx_1 != (int32_T)muDoubleScalarFloor(sizeA_idx_1)) {
      emlrtIntegerCheckR2012b(sizeA_idx_1, &b_emlrtDCI, &st);
    }

    i = a->size[0] * a->size[1];
    a->size[0] = (int32_T)sizeA_idx_0;
    i1 = (int32_T)sizeA_idx_1;
    a->size[1] = i1;
    emxEnsureCapacity_real32_T(&st, a, i, &jd_emlrtRTEI);
    for (j = 0; j < i1; j++) {
      i = a->size[0];
      for (b_i = 0; b_i < i; b_i++) {
        loop_ub = b_i + 1;
        if ((loop_ub < 1) || (loop_ub > idxA->size[0])) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, idxA->size[0], &tb_emlrtBCI,
            &st);
        }

        loop_ub = idxA->data[loop_ub - 1];
        if ((loop_ub < 1) || (loop_ub > a_tmp->size[0])) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, a_tmp->size[0], &tb_emlrtBCI,
            &st);
        }

        b_loop_ub = j + 1;
        if ((b_loop_ub < 1) || (b_loop_ub > idxA->size[0])) {
          emlrtDynamicBoundsCheckR2012b(b_loop_ub, 1, idxA->size[0],
            &tb_emlrtBCI, &st);
        }

        b_loop_ub = idxA->data[(b_loop_ub + idxA->size[0]) - 1];
        if ((b_loop_ub < 1) || (b_loop_ub > a_tmp->size[1])) {
          emlrtDynamicBoundsCheckR2012b(b_loop_ub, 1, a_tmp->size[1],
            &tb_emlrtBCI, &st);
        }

        i2 = b_i + 1;
        if ((i2 < 1) || (i2 > a->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, a->size[0], &ub_emlrtBCI, &st);
        }

        i3 = j + 1;
        if ((i3 < 1) || (i3 > a->size[1])) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, a->size[1], &ub_emlrtBCI, &st);
        }

        a->data[(i2 + a->size[0] * (i3 - 1)) - 1] = a_tmp->data[(loop_ub +
          a_tmp->size[0] * (b_loop_ub - 1)) - 1];
      }
    }

    emxFree_int32_T(&idxA);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

void b_imfilter(const emlrtStack *sp, emxArray_real32_T *varargin_1)
{
  real_T outSizeT[2];
  real_T startT[2];
  emxArray_real32_T *a;
  boolean_T tooBig;
  int32_T i;
  real_T padSizeT[2];
  real_T connDimsT[2];
  static const real_T nonZeroKernel[6] = { -1.0, -2.0, -1.0, 1.0, 2.0, 1.0 };

  static const boolean_T conn[9] = { true, true, true, false, false, false, true,
    true, true };

  static const real_T kernel[9] = { -1.0, -2.0, -1.0, -0.0, -0.0, -0.0, 1.0, 2.0,
    1.0 };

  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  outSizeT[0] = varargin_1->size[0];
  startT[0] = 1.0;
  outSizeT[1] = varargin_1->size[1];
  startT[1] = 1.0;
  if ((varargin_1->size[0] != 0) && (varargin_1->size[1] != 0)) {
    emxInit_real32_T(sp, &a, 2, &ph_emlrtRTEI, true);
    st.site = &hb_emlrtRSI;
    padImage(&st, varargin_1, startT, a);
    st.site = &ib_emlrtRSI;
    b_st.site = &rb_emlrtRSI;
    tooBig = (outSizeT[0] > 65500.0);
    if ((!tooBig) || (!(outSizeT[1] > 65500.0))) {
      tooBig = false;
    }

    tooBig = !tooBig;
    c_st.site = &sb_emlrtRSI;
    i = varargin_1->size[0] * varargin_1->size[1];
    varargin_1->size[0] = (int32_T)outSizeT[0];
    varargin_1->size[1] = (int32_T)outSizeT[1];
    emxEnsureCapacity_real32_T(&c_st, varargin_1, i, &oh_emlrtRTEI);
    if (tooBig) {
      padSizeT[0] = a->size[0];
      startT[0] = 3.0;
      padSizeT[1] = a->size[1];
      startT[1] = 3.0;
      ippfilter_real32(&a->data[0], &varargin_1->data[0], outSizeT, 2.0,
                       padSizeT, kernel, startT, true);
    } else {
      padSizeT[0] = a->size[0];
      connDimsT[0] = 3.0;
      padSizeT[1] = a->size[1];
      connDimsT[1] = 3.0;
      imfilter_real32(&a->data[0], &varargin_1->data[0], 2.0, outSizeT, 2.0,
                      padSizeT, nonZeroKernel, 6.0, conn, 2.0, connDimsT, startT,
                      2.0, true, true);
    }

    emxFree_real32_T(&a);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

void c_imfilter(const emlrtStack *sp, emxArray_real32_T *varargin_1)
{
  real_T outSizeT[2];
  real_T startT[2];
  emxArray_real32_T *a;
  boolean_T tooBig;
  int32_T i;
  real_T padSizeT[2];
  real_T connDimsT[2];
  static const real_T nonZeroKernel[6] = { -1.0, 1.0, -2.0, 2.0, -1.0, 1.0 };

  static const boolean_T conn[9] = { true, false, true, true, false, true, true,
    false, true };

  static const real_T kernel[9] = { -1.0, -0.0, 1.0, -2.0, -0.0, 2.0, -1.0, -0.0,
    1.0 };

  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  outSizeT[0] = varargin_1->size[0];
  startT[0] = 1.0;
  outSizeT[1] = varargin_1->size[1];
  startT[1] = 1.0;
  if ((varargin_1->size[0] != 0) && (varargin_1->size[1] != 0)) {
    emxInit_real32_T(sp, &a, 2, &ph_emlrtRTEI, true);
    st.site = &hb_emlrtRSI;
    padImage(&st, varargin_1, startT, a);
    st.site = &ib_emlrtRSI;
    b_st.site = &rb_emlrtRSI;
    tooBig = (outSizeT[0] > 65500.0);
    if ((!tooBig) || (!(outSizeT[1] > 65500.0))) {
      tooBig = false;
    }

    tooBig = !tooBig;
    c_st.site = &sb_emlrtRSI;
    i = varargin_1->size[0] * varargin_1->size[1];
    varargin_1->size[0] = (int32_T)outSizeT[0];
    varargin_1->size[1] = (int32_T)outSizeT[1];
    emxEnsureCapacity_real32_T(&c_st, varargin_1, i, &oh_emlrtRTEI);
    if (tooBig) {
      padSizeT[0] = a->size[0];
      startT[0] = 3.0;
      padSizeT[1] = a->size[1];
      startT[1] = 3.0;
      ippfilter_real32(&a->data[0], &varargin_1->data[0], outSizeT, 2.0,
                       padSizeT, kernel, startT, true);
    } else {
      padSizeT[0] = a->size[0];
      connDimsT[0] = 3.0;
      padSizeT[1] = a->size[1];
      connDimsT[1] = 3.0;
      imfilter_real32(&a->data[0], &varargin_1->data[0], 2.0, outSizeT, 2.0,
                      padSizeT, nonZeroKernel, 6.0, conn, 2.0, connDimsT, startT,
                      2.0, true, true);
    }

    emxFree_real32_T(&a);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

void imfilter(const emlrtStack *sp, emxArray_real32_T *varargin_1)
{
  real_T outSizeT[2];
  real_T startT[2];
  emxArray_real32_T *a;
  boolean_T tooBig;
  int32_T i;
  real_T padSizeT[2];
  real_T connDimsT[2];
  boolean_T conn[25];
  static const real_T kernel[25] = { 0.014418818362460822, 0.028084023356349175,
    0.0350727008055935, 0.028084023356349175, 0.014418818362460822,
    0.028084023356349175, 0.054700208300935887, 0.068312293270780214,
    0.054700208300935887, 0.028084023356349175, 0.0350727008055935,
    0.068312293270780214, 0.085311730190125085, 0.068312293270780214,
    0.0350727008055935, 0.028084023356349175, 0.054700208300935887,
    0.068312293270780214, 0.054700208300935887, 0.028084023356349175,
    0.014418818362460822, 0.028084023356349175, 0.0350727008055935,
    0.028084023356349175, 0.014418818362460822 };

  static const real_T nonZeroKernel[25] = { 0.014418818362460822,
    0.028084023356349175, 0.0350727008055935, 0.028084023356349175,
    0.014418818362460822, 0.028084023356349175, 0.054700208300935887,
    0.068312293270780214, 0.054700208300935887, 0.028084023356349175,
    0.0350727008055935, 0.068312293270780214, 0.085311730190125085,
    0.068312293270780214, 0.0350727008055935, 0.028084023356349175,
    0.054700208300935887, 0.068312293270780214, 0.054700208300935887,
    0.028084023356349175, 0.014418818362460822, 0.028084023356349175,
    0.0350727008055935, 0.028084023356349175, 0.014418818362460822 };

  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  outSizeT[0] = varargin_1->size[0];
  startT[0] = 2.0;
  outSizeT[1] = varargin_1->size[1];
  startT[1] = 2.0;
  if ((varargin_1->size[0] != 0) && (varargin_1->size[1] != 0)) {
    emxInit_real32_T(sp, &a, 2, &ph_emlrtRTEI, true);
    st.site = &hb_emlrtRSI;
    padImage(&st, varargin_1, startT, a);
    st.site = &ib_emlrtRSI;
    b_st.site = &rb_emlrtRSI;
    tooBig = (outSizeT[0] > 65500.0);
    if ((!tooBig) || (!(outSizeT[1] > 65500.0))) {
      tooBig = false;
    }

    tooBig = !tooBig;
    c_st.site = &sb_emlrtRSI;
    i = varargin_1->size[0] * varargin_1->size[1];
    varargin_1->size[0] = (int32_T)outSizeT[0];
    varargin_1->size[1] = (int32_T)outSizeT[1];
    emxEnsureCapacity_real32_T(&c_st, varargin_1, i, &oh_emlrtRTEI);
    if (tooBig) {
      padSizeT[0] = a->size[0];
      startT[0] = 5.0;
      padSizeT[1] = a->size[1];
      startT[1] = 5.0;
      ippfilter_real32(&a->data[0], &varargin_1->data[0], outSizeT, 2.0,
                       padSizeT, kernel, startT, false);
    } else {
      padSizeT[0] = a->size[0];
      padSizeT[1] = a->size[1];
      for (i = 0; i < 25; i++) {
        conn[i] = true;
      }

      connDimsT[0] = 5.0;
      connDimsT[1] = 5.0;
      imfilter_real32(&a->data[0], &varargin_1->data[0], 2.0, outSizeT, 2.0,
                      padSizeT, nonZeroKernel, 25.0, conn, 2.0, connDimsT,
                      startT, 2.0, true, false);
    }

    emxFree_real32_T(&a);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (imfilter.c) */
