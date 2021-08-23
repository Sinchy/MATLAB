/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * imfindcircles.c
 *
 * Code generation for function 'imfindcircles'
 *
 */

/* Include files */
#include "imfindcircles.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "assertValidSizeArg.h"
#include "chaccum.h"
#include "chcenters.h"
#include "chradii.h"
#include "eml_int_forloop_overflow_check.h"
#include "indexShapeCheck.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "validateattributes.h"
#include "warning.h"

/* Variable Definitions */
static emlrtRSInfo b_emlrtRSI = { 6,   /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 16,  /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo d_emlrtRSI = { 24,  /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 28,  /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 32,  /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo g_emlrtRSI = { 38,  /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 46,  /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo i_emlrtRSI = { 60,  /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo j_emlrtRSI = { 66,  /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo k_emlrtRSI = { 84,  /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo l_emlrtRSI = { 97,  /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 117, /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo o_emlrtRSI = { 154, /* lineNo */
  "parseOptionalInputs",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo p_emlrtRSI = { 189, /* lineNo */
  "checkSensitivity",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

static emlrtRSInfo tj_emlrtRSI = { 41, /* lineNo */
  "find",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

static emlrtRSInfo uj_emlrtRSI = { 153,/* lineNo */
  "eml_find",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

static emlrtRSInfo vj_emlrtRSI = { 377,/* lineNo */
  "find_first_indices",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

static emlrtRSInfo wj_emlrtRSI = { 397,/* lineNo */
  "find_first_indices",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

static emlrtRSInfo xj_emlrtRSI = { 66, /* lineNo */
  "repmat",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\repmat.m"/* pathName */
};

static emlrtRSInfo yj_emlrtRSI = { 69, /* lineNo */
  "repmat",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\repmat.m"/* pathName */
};

static emlrtMCInfo emlrtMCI = { 18,    /* lineNo */
  13,                                  /* colNo */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  48,                                  /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  47,                                  /* lineNo */
  19,                                  /* colNo */
  "",                                  /* aName */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo d_emlrtRTEI = { 387,/* lineNo */
  1,                                   /* colNo */
  "find_first_indices",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo f_emlrtRTEI = { 191,/* lineNo */
  1,                                   /* colNo */
  "checkSensitivity",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo g_emlrtRTEI = { 103,/* lineNo */
  1,                                   /* colNo */
  "parseInputs",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo h_emlrtRTEI = { 87,/* lineNo */
  1,                                   /* colNo */
  "parseInputs",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo sb_emlrtRTEI = { 38,/* lineNo */
  2,                                   /* colNo */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo tb_emlrtRTEI = { 46,/* lineNo */
  17,                                  /* colNo */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo ub_emlrtRTEI = { 153,/* lineNo */
  13,                                  /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo vb_emlrtRTEI = { 46,/* lineNo */
  1,                                   /* colNo */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo wb_emlrtRTEI = { 41,/* lineNo */
  5,                                   /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo xb_emlrtRTEI = { 47,/* lineNo */
  1,                                   /* colNo */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo yb_emlrtRTEI = { 66,/* lineNo */
  17,                                  /* colNo */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo ac_emlrtRTEI = { 60,/* lineNo */
  23,                                  /* colNo */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo bc_emlrtRTEI = { 1,/* lineNo */
  43,                                  /* colNo */
  "imfindcircles",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pName */
};

static emlrtRTEInfo cc_emlrtRTEI = { 33,/* lineNo */
  6,                                   /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRSInfo il_emlrtRSI = { 18, /* lineNo */
  "imfindcircles",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfindcircles.m"/* pathName */
};

/* Function Declarations */
static const mxArray *b_sprintf(const emlrtStack *sp, const mxArray *b,
  emlrtMCInfo *location);

/* Function Definitions */
static const mxArray *b_sprintf(const emlrtStack *sp, const mxArray *b,
  emlrtMCInfo *location)
{
  const mxArray *pArray;
  const mxArray *m;
  pArray = b;
  return emlrtCallMATLABR2012b(sp, 1, &m, 1, &pArray, "sprintf", true, location);
}

void imfindcircles(const emlrtStack *sp, const emxArray_boolean_T *varargin_1,
                   const real_T varargin_2[2], real_T varargin_6,
                   emxArray_real_T *centers, emxArray_real_T *r_estimated)
{
  int32_T radiusRange_size[2];
  real_T radiusRange_data[2];
  boolean_T overflow;
  boolean_T p;
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[2] = { 1, 119 };

  static const char_T u[119] = { '\\', 't', '[', 'C', 'E', 'N', 'T', 'E', 'R',
    'S', '1', ',', ' ', 'R', 'A', 'D', 'I', 'I', '1', ',', ' ', 'M', 'E', 'T',
    'R', 'I', 'C', '1', ']', ' ', '=', ' ', 'I', 'M', 'F', 'I', 'N', 'D', 'C',
    'I', 'R', 'C', 'L', 'E', 'S', '(', 'A', ',', ' ', '[', '2', '0', ' ', '6',
    '0', ']', ')', ';', '\\', 'n', '\\', 't', '[', 'C', 'E', 'N', 'T', 'E', 'R',
    'S', '2', ',', ' ', 'R', 'A', 'D', 'I', 'I', '2', ',', ' ', 'M', 'E', 'T',
    'R', 'I', 'C', '2', ']', ' ', '=', ' ', 'I', 'M', 'F', 'I', 'N', 'D', 'C',
    'I', 'R', 'C', 'L', 'E', 'S', '(', 'A', ',', ' ', '[', '6', '1', ' ', '1',
    '0', '0', ']', ')', ';' };

  emxArray_creal_T *accumMatrix;
  emxArray_real32_T *gradientImg;
  int32_T ntilerows;
  boolean_T exitg1;
  emxArray_real_T *b_centers;
  emxArray_real_T *metric;
  int32_T i;
  emxArray_boolean_T *x;
  emxArray_int32_T *ii;
  int32_T nx;
  int32_T idx;
  int32_T iv1[2];
  emxArray_real_T *idx2Keep;
  int32_T i1;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  f_st.prev = sp;
  f_st.tls = sp->tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &b_emlrtRSI;
  b_st.site = &k_emlrtRSI;
  c_st.site = &n_emlrtRSI;
  if ((varargin_1->size[0] == 0) || (varargin_1->size[1] == 0)) {
    emlrtErrorWithMessageIdR2018a(&c_st, &c_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonempty",
      "MATLAB:imfindcircles:expectedNonempty", 3, 4, 18, "input number 1, A,");
  }

  if ((varargin_1->size[0] == 1) || (varargin_1->size[1] == 1)) {
    emlrtErrorWithMessageIdR2018a(&st, &h_emlrtRTEI,
      "images:imfindcircles:invalidInputImage",
      "images:imfindcircles:invalidInputImage", 0);
  }

  b_st.site = &l_emlrtRSI;
  validateattributes(&b_st, varargin_2);
  if (varargin_2[0] > varargin_2[1]) {
    emlrtErrorWithMessageIdR2018a(&st, &g_emlrtRTEI,
      "images:imfindcircles:invalidRadiusRange",
      "images:imfindcircles:invalidRadiusRange", 0);
  }

  if (varargin_2[0] == varargin_2[1]) {
    radiusRange_size[0] = 1;
    radiusRange_size[1] = 1;
    radiusRange_data[0] = varargin_2[0];
  } else {
    radiusRange_size[0] = 1;
    radiusRange_size[1] = 2;
    radiusRange_data[0] = varargin_2[0];
    radiusRange_data[1] = varargin_2[1];
  }

  b_st.site = &m_emlrtRSI;
  c_st.site = &o_emlrtRSI;
  d_st.site = &p_emlrtRSI;
  e_st.site = &n_emlrtRSI;
  overflow = muDoubleScalarIsNaN(varargin_6);
  p = !overflow;
  if (!p) {
    emlrtErrorWithMessageIdR2018a(&e_st, &b_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonNaN",
      "MATLAB:imfindcircles:expectedNonNaN", 3, 4, 11, "Sensitivity");
  }

  e_st.site = &n_emlrtRSI;
  p = ((!muDoubleScalarIsInf(varargin_6)) && (!overflow));
  if (!p) {
    emlrtErrorWithMessageIdR2018a(&e_st, &emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedFinite",
      "MATLAB:imfindcircles:expectedFinite", 3, 4, 11, "Sensitivity");
  }

  if ((varargin_6 > 1.0) || (varargin_6 < 0.0)) {
    emlrtErrorWithMessageIdR2018a(&c_st, &f_emlrtRTEI,
      "images:imfindcircles:outOfRangeSensitivity",
      "images:imfindcircles:outOfRangeSensitivity", 0);
  }

  centers->size[0] = 0;
  centers->size[1] = 0;
  r_estimated->size[0] = 0;
  r_estimated->size[1] = 0;
  if ((radiusRange_size[1] == 2) && ((radiusRange_data[1] > 3.0 *
        radiusRange_data[0]) || (radiusRange_data[1] - radiusRange_data[0] >
        100.0))) {
    y = NULL;
    m = emlrtCreateCharArray(2, &iv[0]);
    emlrtInitCharArrayR2013a(sp, 119, m, &u[0]);
    emlrtAssign(&y, m);
    st.site = &c_emlrtRSI;
    f_st.site = &il_emlrtRSI;
    warning(&st, b_sprintf(&f_st, y, &emlrtMCI));
  }

  if (radiusRange_data[0] <= 5.0) {
    st.site = &d_emlrtRSI;
    b_warning(&st);
  }

  emxInit_creal_T(sp, &accumMatrix, 2, &bc_emlrtRTEI, true);
  emxInit_real32_T(sp, &gradientImg, 2, &bc_emlrtRTEI, true);
  st.site = &e_emlrtRSI;
  chaccum(&st, varargin_1, radiusRange_data, radiusRange_size, accumMatrix,
          gradientImg);
  st.site = &f_emlrtRSI;
  b_st.site = &hd_emlrtRSI;
  p = false;
  c_st.site = &eb_emlrtRSI;
  if (1 > accumMatrix->size[0] * accumMatrix->size[1]) {
    overflow = false;
  } else {
    overflow = (accumMatrix->size[0] * accumMatrix->size[1] > 2147483646);
  }

  if (overflow) {
    d_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  ntilerows = 0;
  exitg1 = false;
  while ((!exitg1) && (ntilerows + 1 <= accumMatrix->size[0] * accumMatrix->
                       size[1])) {
    if (((accumMatrix->data[ntilerows].re == 0.0) && (accumMatrix->
          data[ntilerows].im == 0.0)) || (muDoubleScalarIsNaN(accumMatrix->
          data[ntilerows].re) || muDoubleScalarIsNaN(accumMatrix->data[ntilerows]
          .im))) {
      ntilerows++;
    } else {
      p = true;
      exitg1 = true;
    }
  }

  if (p) {
    emxInit_real_T(sp, &b_centers, 2, &bc_emlrtRTEI, true);
    emxInit_real_T(sp, &metric, 2, &bc_emlrtRTEI, true);
    st.site = &g_emlrtRSI;
    chcenters(&st, accumMatrix, 1.0 - varargin_6, b_centers, metric);
    i = centers->size[0] * centers->size[1];
    centers->size[0] = b_centers->size[0];
    centers->size[1] = b_centers->size[1];
    emxEnsureCapacity_real_T(sp, centers, i, &sb_emlrtRTEI);
    ntilerows = b_centers->size[0] * b_centers->size[1];
    for (i = 0; i < ntilerows; i++) {
      centers->data[i] = b_centers->data[i];
    }

    if ((b_centers->size[0] != 0) && (b_centers->size[1] != 0)) {
      emxInit_boolean_T(sp, &x, 2, &tb_emlrtRTEI, true);
      st.site = &h_emlrtRSI;
      i = x->size[0] * x->size[1];
      x->size[0] = metric->size[0];
      x->size[1] = metric->size[1];
      emxEnsureCapacity_boolean_T(&st, x, i, &tb_emlrtRTEI);
      ntilerows = metric->size[0] * metric->size[1];
      for (i = 0; i < ntilerows; i++) {
        x->data[i] = (metric->data[i] >= 1.0 - varargin_6);
      }

      emxInit_int32_T(&st, &ii, 1, &cc_emlrtRTEI, true);
      b_st.site = &tj_emlrtRSI;
      nx = x->size[0] * x->size[1];
      c_st.site = &uj_emlrtRSI;
      idx = 0;
      i = ii->size[0];
      ii->size[0] = nx;
      emxEnsureCapacity_int32_T(&c_st, ii, i, &ub_emlrtRTEI);
      d_st.site = &vj_emlrtRSI;
      overflow = ((1 <= nx) && (nx > 2147483646));
      if (overflow) {
        e_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&e_st);
      }

      ntilerows = 0;
      exitg1 = false;
      while ((!exitg1) && (ntilerows <= nx - 1)) {
        if (x->data[ntilerows]) {
          idx++;
          ii->data[idx - 1] = ntilerows + 1;
          if (idx >= nx) {
            exitg1 = true;
          } else {
            ntilerows++;
          }
        } else {
          ntilerows++;
        }
      }

      emxFree_boolean_T(&x);
      if (idx > nx) {
        emlrtErrorWithMessageIdR2018a(&c_st, &d_emlrtRTEI,
          "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
      }

      if (nx == 1) {
        if (idx == 0) {
          ii->size[0] = 0;
        }
      } else {
        if (1 > idx) {
          idx = 0;
        }

        iv1[0] = 1;
        iv1[1] = idx;
        d_st.site = &wj_emlrtRSI;
        indexShapeCheck(&d_st, ii->size[0], iv1);
        i = ii->size[0];
        ii->size[0] = idx;
        emxEnsureCapacity_int32_T(&c_st, ii, i, &wb_emlrtRTEI);
      }

      emxInit_real_T(&c_st, &idx2Keep, 1, &vb_emlrtRTEI, true);
      i = idx2Keep->size[0];
      idx2Keep->size[0] = ii->size[0];
      emxEnsureCapacity_real_T(&st, idx2Keep, i, &vb_emlrtRTEI);
      ntilerows = ii->size[0];
      for (i = 0; i < ntilerows; i++) {
        idx2Keep->data[i] = ii->data[i];
      }

      emxFree_int32_T(&ii);
      ntilerows = b_centers->size[1];
      i = centers->size[0] * centers->size[1];
      centers->size[0] = idx2Keep->size[0];
      centers->size[1] = b_centers->size[1];
      emxEnsureCapacity_real_T(sp, centers, i, &xb_emlrtRTEI);
      for (i = 0; i < ntilerows; i++) {
        nx = idx2Keep->size[0];
        for (i1 = 0; i1 < nx; i1++) {
          idx = (int32_T)idx2Keep->data[i1];
          if ((idx < 1) || (idx > b_centers->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, b_centers->size[0],
              &b_emlrtBCI, sp);
          }

          centers->data[i1 + centers->size[0] * i] = b_centers->data[(idx +
            b_centers->size[0] * i) - 1];
        }
      }

      ntilerows = idx2Keep->size[0];
      for (i = 0; i < ntilerows; i++) {
        i1 = (int32_T)idx2Keep->data[i];
        if ((i1 < 1) || (i1 > metric->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, metric->size[0], &emlrtBCI, sp);
        }
      }

      if (idx2Keep->size[0] == 0) {
        centers->size[0] = 0;
        centers->size[1] = 0;
      } else if (radiusRange_size[1] == 1) {
        st.site = &i_emlrtRSI;
        b_st.site = &nb_emlrtRSI;
        b_assertValidSizeArg(&b_st, idx2Keep->size[0]);
        i = r_estimated->size[0] * r_estimated->size[1];
        r_estimated->size[0] = idx2Keep->size[0];
        r_estimated->size[1] = 1;
        emxEnsureCapacity_real_T(&st, r_estimated, i, &ac_emlrtRTEI);
        ntilerows = idx2Keep->size[0];
        b_st.site = &xj_emlrtRSI;
        if (1 > idx2Keep->size[0]) {
          overflow = false;
        } else {
          overflow = (idx2Keep->size[0] > 2147483646);
        }

        b_st.site = &yj_emlrtRSI;
        if (overflow) {
          c_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (nx = 0; nx < ntilerows; nx++) {
          r_estimated->data[nx] = radiusRange_data[0];
        }
      } else {
        st.site = &j_emlrtRSI;
        chradii(&st, centers, gradientImg, radiusRange_data, radiusRange_size,
                idx2Keep);
        i = r_estimated->size[0] * r_estimated->size[1];
        r_estimated->size[0] = idx2Keep->size[0];
        r_estimated->size[1] = 1;
        emxEnsureCapacity_real_T(sp, r_estimated, i, &yb_emlrtRTEI);
        ntilerows = idx2Keep->size[0];
        for (i = 0; i < ntilerows; i++) {
          r_estimated->data[i] = idx2Keep->data[i];
        }
      }

      emxFree_real_T(&idx2Keep);
    }

    emxFree_real_T(&metric);
    emxFree_real_T(&b_centers);
  }

  emxFree_real32_T(&gradientImg);
  emxFree_creal_T(&accumMatrix);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (imfindcircles.c) */
