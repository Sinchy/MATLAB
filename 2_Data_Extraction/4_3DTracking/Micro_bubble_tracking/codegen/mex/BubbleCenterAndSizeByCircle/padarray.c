/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * padarray.c
 *
 * Code generation for function 'padarray'
 *
 */

/* Include files */
#include "padarray.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "assertValidSizeArg.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "validateattributes.h"

/* Variable Definitions */
static emlrtRSInfo ch_emlrtRSI = { 72, /* lineNo */
  "padarray",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pathName */
};

static emlrtRSInfo dh_emlrtRSI = { 405,/* lineNo */
  "ConstantPad",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pathName */
};

static emlrtRSInfo eh_emlrtRSI = { 420,/* lineNo */
  "ConstantPad",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pathName */
};

static emlrtBCInfo sc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  400,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "ConstantPad",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo tc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  407,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "ConstantPad",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo uc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  414,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "ConstantPad",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  444,                                 /* lineNo */
  100,                                 /* colNo */
  "",                                  /* aName */
  "ConstantPad",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  444,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "ConstantPad",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  421,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "ConstantPad",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo c_emlrtDCI = { 253, /* lineNo */
  35,                                  /* colNo */
  "ConstantPad",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m",/* pName */
  1                                    /* checkKind */
};

static emlrtRTEInfo wf_emlrtRTEI = { 72,/* lineNo */
  13,                                  /* colNo */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pName */
};

static emlrtRTEInfo xf_emlrtRTEI = { 66,/* lineNo */
  9,                                   /* colNo */
  "padarray",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pName */
};

/* Function Definitions */
void padarray(const emlrtStack *sp, const emxArray_real_T *varargin_1, const
              real_T varargin_2[2], emxArray_real_T *b)
{
  real_T sizeB_idx_0;
  real_T sizeB_idx_1;
  real_T b_varargin_1[2];
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T j;
  int32_T a_tmp;
  int32_T a;
  int32_T b_b;
  int32_T b_i;
  boolean_T overflow;
  int32_T i3;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &kb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_validateattributes(&st, varargin_2);
  if ((varargin_1->size[0] == 0) || (varargin_1->size[1] == 0)) {
    sizeB_idx_0 = (real_T)varargin_1->size[0] + 2.0 * varargin_2[0];
    sizeB_idx_1 = (real_T)varargin_1->size[1] + 2.0 * varargin_2[1];
    st.site = &lb_emlrtRSI;
    b_varargin_1[0] = sizeB_idx_0;
    b_varargin_1[1] = sizeB_idx_1;
    b_st.site = &nb_emlrtRSI;
    assertValidSizeArg(&b_st, b_varargin_1);
    i = (int32_T)sizeB_idx_0;
    i1 = b->size[0] * b->size[1];
    b->size[0] = i;
    i2 = (int32_T)sizeB_idx_1;
    b->size[1] = i2;
    emxEnsureCapacity_real_T(&st, b, i1, &xf_emlrtRTEI);
    a_tmp = i * i2;
    for (i = 0; i < a_tmp; i++) {
      b->data[i] = 0.0;
    }
  } else {
    st.site = &ch_emlrtRSI;
    sizeB_idx_0 = (real_T)varargin_1->size[0] + 2.0 * varargin_2[0];
    if (sizeB_idx_0 != (int32_T)muDoubleScalarFloor(sizeB_idx_0)) {
      emlrtIntegerCheckR2012b(sizeB_idx_0, &c_emlrtDCI, &st);
    }

    sizeB_idx_1 = (real_T)varargin_1->size[1] + 2.0 * varargin_2[1];
    if (sizeB_idx_1 != (int32_T)muDoubleScalarFloor(sizeB_idx_1)) {
      emlrtIntegerCheckR2012b(sizeB_idx_1, &c_emlrtDCI, &st);
    }

    i = b->size[0] * b->size[1];
    b->size[0] = (int32_T)sizeB_idx_0;
    b->size[1] = (int32_T)sizeB_idx_1;
    emxEnsureCapacity_real_T(&st, b, i, &wf_emlrtRTEI);
    i = (int32_T)varargin_2[1];
    for (j = 0; j < i; j++) {
      i1 = b->size[0];
      for (b_i = 0; b_i < i1; b_i++) {
        i2 = b_i + 1;
        if ((i2 < 1) || (i2 > b->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, b->size[0], &sc_emlrtBCI, &st);
        }

        a_tmp = (int32_T)(j + 1U);
        if ((a_tmp < 1) || (a_tmp > b->size[1])) {
          emlrtDynamicBoundsCheckR2012b(a_tmp, 1, b->size[1], &sc_emlrtBCI, &st);
        }

        b->data[(i2 + b->size[0] * (a_tmp - 1)) - 1] = 0.0;
      }
    }

    a = (varargin_1->size[1] + i) + 1;
    b_b = b->size[1];
    b_st.site = &dh_emlrtRSI;
    if ((varargin_1->size[1] + i) + 1 > b->size[1]) {
      overflow = false;
    } else {
      overflow = (b->size[1] > 2147483646);
    }

    if (overflow) {
      c_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (j = a; j <= b_b; j++) {
      i1 = b->size[0];
      for (b_i = 0; b_i < i1; b_i++) {
        i2 = b_i + 1;
        if ((i2 < 1) || (i2 > b->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, b->size[0], &tc_emlrtBCI, &st);
        }

        if ((j < 1) || (j > b->size[1])) {
          emlrtDynamicBoundsCheckR2012b(j, 1, b->size[1], &tc_emlrtBCI, &st);
        }

        b->data[(i2 + b->size[0] * (j - 1)) - 1] = 0.0;
      }
    }

    i1 = varargin_1->size[1];
    for (j = 0; j < i1; j++) {
      i2 = (int32_T)varargin_2[0];
      for (b_i = 0; b_i < i2; b_i++) {
        a_tmp = (int32_T)(b_i + 1U);
        if ((a_tmp < 1) || (a_tmp > b->size[0])) {
          emlrtDynamicBoundsCheckR2012b(a_tmp, 1, b->size[0], &uc_emlrtBCI, &st);
        }

        a = (j + i) + 1;
        if ((a < 1) || (a > b->size[1])) {
          emlrtDynamicBoundsCheckR2012b(a, 1, b->size[1], &uc_emlrtBCI, &st);
        }

        b->data[(a_tmp + b->size[0] * (a - 1)) - 1] = 0.0;
      }
    }

    i1 = varargin_1->size[1];
    for (j = 0; j < i1; j++) {
      a_tmp = (int32_T)varargin_2[0];
      a = (a_tmp + varargin_1->size[0]) + 1;
      b_b = b->size[0];
      b_st.site = &eh_emlrtRSI;
      if ((a_tmp + varargin_1->size[0]) + 1 > b->size[0]) {
        overflow = false;
      } else {
        overflow = (b->size[0] > 2147483646);
      }

      if (overflow) {
        c_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (b_i = a; b_i <= b_b; b_i++) {
        if ((b_i < 1) || (b_i > b->size[0])) {
          emlrtDynamicBoundsCheckR2012b(b_i, 1, b->size[0], &xc_emlrtBCI, &st);
        }

        i2 = (j + i) + 1;
        if ((i2 < 1) || (i2 > b->size[1])) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, b->size[1], &xc_emlrtBCI, &st);
        }

        b->data[(b_i + b->size[0] * (i2 - 1)) - 1] = 0.0;
      }
    }

    i1 = varargin_1->size[1];
    for (j = 0; j < i1; j++) {
      i2 = varargin_1->size[0];
      for (b_i = 0; b_i < i2; b_i++) {
        a_tmp = b_i + 1;
        if ((a_tmp < 1) || (a_tmp > varargin_1->size[0])) {
          emlrtDynamicBoundsCheckR2012b(a_tmp, 1, varargin_1->size[0],
            &vc_emlrtBCI, &st);
        }

        a = j + 1;
        if ((a < 1) || (a > varargin_1->size[1])) {
          emlrtDynamicBoundsCheckR2012b(a, 1, varargin_1->size[1], &vc_emlrtBCI,
            &st);
        }

        b_b = (b_i + (int32_T)varargin_2[0]) + 1;
        if ((b_b < 1) || (b_b > b->size[0])) {
          emlrtDynamicBoundsCheckR2012b(b_b, 1, b->size[0], &wc_emlrtBCI, &st);
        }

        i3 = (j + i) + 1;
        if ((i3 < 1) || (i3 > b->size[1])) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, b->size[1], &wc_emlrtBCI, &st);
        }

        b->data[(b_b + b->size[0] * (i3 - 1)) - 1] = varargin_1->data[(a_tmp +
          varargin_1->size[0] * (a - 1)) - 1];
      }
    }
  }
}

/* End of code generation (padarray.c) */
