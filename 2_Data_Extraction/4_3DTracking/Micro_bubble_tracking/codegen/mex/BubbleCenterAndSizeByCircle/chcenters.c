/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * chcenters.c
 *
 * Code generation for function 'chcenters'
 *
 */

/* Include files */
#include "chcenters.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "all.h"
#include "eml_int_forloop_overflow_check.h"
#include "eps.h"
#include "indexShapeCheck.h"
#include "libmwimregionalmax.h"
#include "libmwippreconstruct.h"
#include "mwmathutil.h"
#include "ordfilt2.h"
#include "regionprops.h"
#include "round.h"
#include "rt_nonfinite.h"
#include "sort.h"
#include "sub2ind.h"
#include "validateattributes.h"

/* Variable Definitions */
static emlrtRSInfo gg_emlrtRSI = { 6,  /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo hg_emlrtRSI = { 13, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo ig_emlrtRSI = { 16, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo jg_emlrtRSI = { 29, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo kg_emlrtRSI = { 33, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo lg_emlrtRSI = { 34, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo mg_emlrtRSI = { 35, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo ng_emlrtRSI = { 36, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo og_emlrtRSI = { 48, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo pg_emlrtRSI = { 53, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo qg_emlrtRSI = { 55, /* lineNo */
  "chcenters",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo rg_emlrtRSI = { 96, /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo sg_emlrtRSI = { 97, /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo tg_emlrtRSI = { 102,/* lineNo */
  "checkAccumArray",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo ug_emlrtRSI = { 107,/* lineNo */
  "checkSuppressionThresh",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pathName */
};

static emlrtRSInfo vg_emlrtRSI = { 37, /* lineNo */
  "medfilt2",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\medfilt2.m"/* pathName */
};

static emlrtRSInfo gh_emlrtRSI = { 66, /* lineNo */
  "imhmax",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\imhmax.m"/* pathName */
};

static emlrtRSInfo hh_emlrtRSI = { 10, /* lineNo */
  "imreconstruct",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imreconstruct.m"/* pathName */
};

static emlrtRSInfo ih_emlrtRSI = { 14, /* lineNo */
  "imreconstruct",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imreconstruct.m"/* pathName */
};

static emlrtRSInfo jh_emlrtRSI = { 76, /* lineNo */
  "imreconstruct",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imreconstruct.m"/* pathName */
};

static emlrtRSInfo kh_emlrtRSI = { 14, /* lineNo */
  "imregionalmax",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imregionalmax.m"/* pathName */
};

static emlrtRSInfo lh_emlrtRSI = { 35, /* lineNo */
  "imregionalmax",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imregionalmax.m"/* pathName */
};

static emlrtRSInfo mh_emlrtRSI = { 37, /* lineNo */
  "imregionalmax",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imregionalmax.m"/* pathName */
};

static emlrtRSInfo gj_emlrtRSI = { 22, /* lineNo */
  "nullAssignment",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRSInfo hj_emlrtRSI = { 26, /* lineNo */
  "nullAssignment",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRSInfo ij_emlrtRSI = { 275,/* lineNo */
  "delete_rows",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRSInfo jj_emlrtRSI = { 276,/* lineNo */
  "delete_rows",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pathName */
};

static emlrtRSInfo nj_emlrtRSI = { 27, /* lineNo */
  "sort",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\sort.m"/* pathName */
};

static emlrtBCInfo lc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  53,                                  /* lineNo */
  21,                                  /* colNo */
  "",                                  /* aName */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo y_emlrtRTEI = { 298,/* lineNo */
  1,                                   /* colNo */
  "delete_rows",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pName */
};

static emlrtRTEInfo ab_emlrtRTEI = { 81,/* lineNo */
  27,                                  /* colNo */
  "validate_inputs",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pName */
};

static emlrtRTEInfo bb_emlrtRTEI = { 13,/* lineNo */
  13,                                  /* colNo */
  "toLogicalCheck",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\toLogicalCheck.m"/* pName */
};

static emlrtRTEInfo cb_emlrtRTEI = { 23,/* lineNo */
  1,                                   /* colNo */
  "imreconstruct",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imreconstruct.m"/* pName */
};

static emlrtRTEInfo db_emlrtRTEI = { 109,/* lineNo */
  1,                                   /* colNo */
  "checkSuppressionThresh",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtBCInfo mc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  47,                                  /* lineNo */
  51,                                  /* colNo */
  "",                                  /* aName */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  47,                                  /* lineNo */
  26,                                  /* colNo */
  "",                                  /* aName */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo eb_emlrtRTEI = { 46,/* lineNo */
  15,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtECInfo d_emlrtECI = { -1,  /* nDims */
  42,                                  /* lineNo */
  9,                                   /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtBCInfo oc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  42,                                  /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  16,                                  /* lineNo */
  46,                                  /* colNo */
  "",                                  /* aName */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  42,                                  /* lineNo */
  26,                                  /* colNo */
  "",                                  /* aName */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  27,                                  /* colNo */
  "",                                  /* aName */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo bf_emlrtRTEI = { 16,/* lineNo */
  12,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo cf_emlrtRTEI = { 31,/* lineNo */
  5,                                   /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo df_emlrtRTEI = { 29,/* lineNo */
  5,                                   /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo ef_emlrtRTEI = { 66,/* lineNo */
  20,                                  /* colNo */
  "imhmax",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\imhmax.m"/* pName */
};

static emlrtRTEInfo ff_emlrtRTEI = { 79,/* lineNo */
  13,                                  /* colNo */
  "imreconstruct",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imreconstruct.m"/* pName */
};

static emlrtRTEInfo gf_emlrtRTEI = { 34,/* lineNo */
  1,                                   /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo hf_emlrtRTEI = { 35,/* lineNo */
  1,                                   /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo if_emlrtRTEI = { 1,/* lineNo */
  30,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo jf_emlrtRTEI = { 53,/* lineNo */
  38,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo kf_emlrtRTEI = { 48,/* lineNo */
  13,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo lf_emlrtRTEI = { 53,/* lineNo */
  58,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo mf_emlrtRTEI = { 53,/* lineNo */
  21,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo nf_emlrtRTEI = { 27,/* lineNo */
  6,                                   /* colNo */
  "sort",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\sort.m"/* pName */
};

static emlrtRTEInfo of_emlrtRTEI = { 55,/* lineNo */
  10,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo pf_emlrtRTEI = { 299,/* lineNo */
  5,                                   /* colNo */
  "nullAssignment",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pName */
};

static emlrtRTEInfo qf_emlrtRTEI = { 56,/* lineNo */
  19,                                  /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo rf_emlrtRTEI = { 26,/* lineNo */
  13,                                  /* colNo */
  "nullAssignment",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\nullAssignment.m"/* pName */
};

static emlrtRTEInfo sf_emlrtRTEI = { 56,/* lineNo */
  9,                                   /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo tf_emlrtRTEI = { 13,/* lineNo */
  1,                                   /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo uf_emlrtRTEI = { 36,/* lineNo */
  1,                                   /* colNo */
  "chcenters",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chcenters.m"/* pName */
};

static emlrtRTEInfo vf_emlrtRTEI = { 16,/* lineNo */
  14,                                  /* colNo */
  "sub2ind",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\sub2ind.m"/* pName */
};

/* Function Definitions */
void chcenters(const emlrtStack *sp, const emxArray_creal_T *varargin_1, real_T
               varargin_2, emxArray_real_T *centers, emxArray_real_T *metric)
{
  boolean_T overflow;
  boolean_T p;
  emxArray_real_T *accumMatrixRe;
  int32_T nx;
  int32_T i;
  int32_T k;
  emxArray_boolean_T *b_accumMatrixRe;
  emxArray_real_T *Hd;
  emxArray_real_T *marker;
  real_T x;
  real_T imSizeT[2];
  real_T connSizeT[2];
  boolean_T exitg1;
  emxArray_real_T *mask;
  emxArray_boolean_T *bw;
  emxArray_struct_T *s;
  boolean_T conn[9];
  int32_T iv[2];
  int32_T idx;
  int32_T iv1[2];
  int32_T i1;
  emxArray_real_T *b_x;
  emxArray_real_T *c_x;
  int32_T b_idx;
  emxArray_real_T *b_varargin_1;
  boolean_T guard1 = false;
  emxArray_real_T *b_varargin_2;
  emxArray_int32_T *r;
  emxArray_real_T *b_metric;
  emxArray_int32_T *iidx;
  emxArray_real_T *b_centers;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &gg_emlrtRSI;
  b_st.site = &rg_emlrtRSI;
  c_st.site = &tg_emlrtRSI;
  d_st.site = &n_emlrtRSI;
  if ((varargin_1->size[0] == 0) || (varargin_1->size[1] == 0)) {
    emlrtErrorWithMessageIdR2018a(&d_st, &c_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonempty",
      "MATLAB:chcenters:expectedNonempty", 3, 4, 18, "input number 1, H,");
  }

  b_st.site = &sg_emlrtRSI;
  c_st.site = &ug_emlrtRSI;
  d_st.site = &n_emlrtRSI;
  overflow = muDoubleScalarIsNaN(varargin_2);
  p = !overflow;
  if (!p) {
    emlrtErrorWithMessageIdR2018a(&d_st, &b_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonNaN",
      "MATLAB:chcenters:expectedNonNaN", 3, 4, 34,
      "input number 2, SuppressionThresh,");
  }

  d_st.site = &n_emlrtRSI;
  p = ((!muDoubleScalarIsInf(varargin_2)) && (!overflow));
  if (!p) {
    emlrtErrorWithMessageIdR2018a(&d_st, &emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedFinite",
      "MATLAB:chcenters:expectedFinite", 3, 4, 34,
      "input number 2, SuppressionThresh,");
  }

  if ((varargin_2 > 1.0) || (varargin_2 < 0.0)) {
    emlrtErrorWithMessageIdR2018a(&b_st, &db_emlrtRTEI,
      "images:imfindcircles:outOfRangeSuppressionThresh",
      "images:imfindcircles:outOfRangeSuppressionThresh", 0);
  }

  emxInit_real_T(&b_st, &accumMatrixRe, 2, &tf_emlrtRTEI, true);
  centers->size[0] = 0;
  centers->size[1] = 0;
  metric->size[0] = 0;
  metric->size[1] = 0;
  st.site = &hg_emlrtRSI;
  b_st.site = &ed_emlrtRSI;
  nx = varargin_1->size[0] * varargin_1->size[1];
  i = accumMatrixRe->size[0] * accumMatrixRe->size[1];
  accumMatrixRe->size[0] = varargin_1->size[0];
  accumMatrixRe->size[1] = varargin_1->size[1];
  emxEnsureCapacity_real_T(&b_st, accumMatrixRe, i, &ne_emlrtRTEI);
  c_st.site = &fd_emlrtRSI;
  overflow = ((1 <= nx) && (nx > 2147483646));
  if (overflow) {
    d_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  for (k = 0; k < nx; k++) {
    accumMatrixRe->data[k] = muDoubleScalarHypot(varargin_1->data[k].re,
      varargin_1->data[k].im);
  }

  i = accumMatrixRe->size[0] * accumMatrixRe->size[1];
  if (1 > i) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i, &pc_emlrtBCI, sp);
  }

  emxInit_boolean_T(sp, &b_accumMatrixRe, 1, &bf_emlrtRTEI, true);
  nx = accumMatrixRe->size[0] * accumMatrixRe->size[1];
  i = b_accumMatrixRe->size[0];
  b_accumMatrixRe->size[0] = nx;
  emxEnsureCapacity_boolean_T(sp, b_accumMatrixRe, i, &bf_emlrtRTEI);
  for (i = 0; i < nx; i++) {
    b_accumMatrixRe->data[i] = (accumMatrixRe->data[i] == accumMatrixRe->data[0]);
  }

  st.site = &ig_emlrtRSI;
  overflow = all(&st, b_accumMatrixRe);
  emxFree_boolean_T(&b_accumMatrixRe);
  if (!overflow) {
    if ((uint32_T)accumMatrixRe->size[0] > (uint32_T)accumMatrixRe->size[1]) {
      nx = accumMatrixRe->size[1];
    } else {
      nx = accumMatrixRe->size[0];
    }

    emxInit_real_T(sp, &Hd, 2, &df_emlrtRTEI, true);
    if (nx > 5) {
      st.site = &jg_emlrtRSI;
      i = Hd->size[0] * Hd->size[1];
      Hd->size[0] = accumMatrixRe->size[0];
      Hd->size[1] = accumMatrixRe->size[1];
      emxEnsureCapacity_real_T(&st, Hd, i, &df_emlrtRTEI);
      k = accumMatrixRe->size[0] * accumMatrixRe->size[1];
      for (i = 0; i < k; i++) {
        Hd->data[i] = accumMatrixRe->data[i];
      }

      b_st.site = &vg_emlrtRSI;
      ordfilt2(&b_st, Hd);
    } else {
      i = Hd->size[0] * Hd->size[1];
      Hd->size[0] = accumMatrixRe->size[0];
      Hd->size[1] = accumMatrixRe->size[1];
      emxEnsureCapacity_real_T(sp, Hd, i, &cf_emlrtRTEI);
      k = accumMatrixRe->size[0] * accumMatrixRe->size[1];
      for (i = 0; i < k; i++) {
        Hd->data[i] = accumMatrixRe->data[i];
      }
    }

    emxInit_real_T(sp, &marker, 2, &ef_emlrtRTEI, true);
    st.site = &kg_emlrtRSI;
    x = varargin_2 - eps(varargin_2);
    x = muDoubleScalarMax(x, 0.0);
    st.site = &lg_emlrtRSI;
    b_st.site = &gh_emlrtRSI;
    i = marker->size[0] * marker->size[1];
    marker->size[0] = Hd->size[0];
    marker->size[1] = Hd->size[1];
    emxEnsureCapacity_real_T(&b_st, marker, i, &ef_emlrtRTEI);
    k = Hd->size[0] * Hd->size[1];
    for (i = 0; i < k; i++) {
      marker->data[i] = Hd->data[i] - x;
    }

    c_st.site = &hh_emlrtRSI;
    c_validateattributes(&c_st, marker);
    c_st.site = &ih_emlrtRSI;
    c_validateattributes(&c_st, Hd);
    imSizeT[0] = marker->size[0];
    connSizeT[0] = Hd->size[0];
    imSizeT[1] = marker->size[1];
    connSizeT[1] = Hd->size[1];
    overflow = true;
    k = 0;
    exitg1 = false;
    while ((!exitg1) && (k < 2)) {
      if (imSizeT[k] != connSizeT[k]) {
        overflow = false;
        exitg1 = true;
      } else {
        k++;
      }
    }

    p = (int32_T)overflow;
    if (!p) {
      emlrtErrorWithMessageIdR2018a(&b_st, &cb_emlrtRTEI,
        "images:imreconstruct:notSameSize", "images:imreconstruct:notSameSize",
        0);
    }

    emxInit_real_T(&b_st, &mask, 2, &ff_emlrtRTEI, true);
    c_st.site = &jh_emlrtRSI;
    i = mask->size[0] * mask->size[1];
    mask->size[0] = Hd->size[0];
    mask->size[1] = Hd->size[1];
    emxEnsureCapacity_real_T(&c_st, mask, i, &ff_emlrtRTEI);
    k = Hd->size[0] * Hd->size[1];
    for (i = 0; i < k; i++) {
      mask->data[i] = Hd->data[i];
    }

    imSizeT[0] = marker->size[0];
    imSizeT[1] = marker->size[1];
    i = Hd->size[0] * Hd->size[1];
    Hd->size[0] = marker->size[0];
    Hd->size[1] = marker->size[1];
    emxEnsureCapacity_real_T(&c_st, Hd, i, &gf_emlrtRTEI);
    k = marker->size[0] * marker->size[1];
    for (i = 0; i < k; i++) {
      Hd->data[i] = marker->data[i];
    }

    emxFree_real_T(&marker);
    ippreconstruct_real64(&Hd->data[0], &mask->data[0], imSizeT, 2.0);
    st.site = &mg_emlrtRSI;
    b_st.site = &kh_emlrtRSI;
    c_st.site = &n_emlrtRSI;
    p = true;
    i = Hd->size[0] * Hd->size[1];
    k = 0;
    emxFree_real_T(&mask);
    exitg1 = false;
    while ((!exitg1) && (k <= i - 1)) {
      if (!muDoubleScalarIsNaN(Hd->data[k])) {
        k++;
      } else {
        p = false;
        exitg1 = true;
      }
    }

    if (!p) {
      emlrtErrorWithMessageIdR2018a(&c_st, &b_emlrtRTEI,
        "Coder:toolbox:ValidateattributesexpectedNonNaN",
        "MATLAB:imregionalmax:expectedNonNaN", 3, 4, 18, "input number 1, I,");
    }

    b_st.site = &lh_emlrtRSI;
    i = Hd->size[0] * Hd->size[1];
    for (k = 0; k < i; k++) {
      if (muDoubleScalarIsNaN(Hd->data[k])) {
        emlrtErrorWithMessageIdR2018a(&b_st, &bb_emlrtRTEI,
          "MATLAB:nologicalnan", "MATLAB:nologicalnan", 0);
      }
    }

    emxInit_boolean_T(&b_st, &bw, 2, &hf_emlrtRTEI, true);
    i = bw->size[0] * bw->size[1];
    bw->size[0] = Hd->size[0];
    bw->size[1] = Hd->size[1];
    emxEnsureCapacity_boolean_T(&st, bw, i, &hf_emlrtRTEI);
    b_st.site = &mh_emlrtRSI;
    imSizeT[0] = Hd->size[0];
    imSizeT[1] = Hd->size[1];
    for (i = 0; i < 9; i++) {
      conn[i] = true;
    }

    emxInit_struct_T(&b_st, &s, 1, &uf_emlrtRTEI, true);
    connSizeT[0] = 3.0;
    connSizeT[1] = 3.0;
    imregionalmax_real64(&Hd->data[0], &bw->data[0], 2.0, imSizeT, conn, 2.0,
                         connSizeT);
    st.site = &ng_emlrtRSI;
    regionprops(&st, bw, accumMatrixRe, s);
    emxFree_boolean_T(&bw);
    if (s->size[0] != 0) {
      i = centers->size[0] * centers->size[1];
      centers->size[0] = s->size[0];
      centers->size[1] = 2;
      emxEnsureCapacity_real_T(sp, centers, i, &if_emlrtRTEI);
      i = s->size[0];
      if (0 <= s->size[0] - 1) {
        iv[0] = 1;
        iv1[0] = 1;
        iv[1] = 2;
        iv1[1] = 2;
      }

      for (idx = 0; idx < i; idx++) {
        i1 = idx + 1;
        if ((i1 < 1) || (i1 > centers->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, centers->size[0], &oc_emlrtBCI,
            sp);
        }

        emlrtSubAssignSizeCheckR2012b(&iv[0], 2, &iv1[0], 2, &d_emlrtECI, sp);
        i1 = idx + 1;
        if ((i1 < 1) || (i1 > s->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, s->size[0], &qc_emlrtBCI, sp);
        }

        centers->data[idx] = s->data[i1 - 1].WeightedCentroid[0];
        i1 = idx + 1;
        if ((i1 < 1) || (i1 > s->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, s->size[0], &qc_emlrtBCI, sp);
        }

        centers->data[idx + centers->size[0]] = s->data[i1 - 1]
          .WeightedCentroid[1];
      }

      i = centers->size[0];
      i1 = (int32_T)(((-1.0 - (real_T)centers->size[0]) + 1.0) / -1.0);
      emlrtForLoopVectorCheckR2012b(centers->size[0], -1.0, 1.0, mxDOUBLE_CLASS,
        i1, &eb_emlrtRTEI, sp);
      emxInit_real_T(sp, &b_x, 2, &kf_emlrtRTEI, true);
      emxInit_real_T(sp, &c_x, 2, &pf_emlrtRTEI, true);
      for (idx = 0; idx < i1; idx++) {
        b_idx = i - idx;
        if ((b_idx < 1) || (b_idx > centers->size[0])) {
          emlrtDynamicBoundsCheckR2012b(b_idx, 1, centers->size[0], &nc_emlrtBCI,
            sp);
        }

        guard1 = false;
        if (muDoubleScalarIsNaN(centers->data[b_idx - 1])) {
          guard1 = true;
        } else {
          if (b_idx > centers->size[0]) {
            emlrtDynamicBoundsCheckR2012b(b_idx, 1, centers->size[0],
              &mc_emlrtBCI, sp);
          }

          if (muDoubleScalarIsNaN(centers->data[(b_idx + centers->size[0]) - 1]))
          {
            guard1 = true;
          }
        }

        if (guard1) {
          st.site = &og_emlrtRSI;
          nx = b_x->size[0] * b_x->size[1];
          b_x->size[0] = centers->size[0];
          b_x->size[1] = centers->size[1];
          emxEnsureCapacity_real_T(&st, b_x, nx, &kf_emlrtRTEI);
          k = centers->size[0] * centers->size[1];
          for (nx = 0; nx < k; nx++) {
            b_x->data[nx] = centers->data[nx];
          }

          b_st.site = &gj_emlrtRSI;
          if (b_idx > centers->size[0]) {
            emlrtErrorWithMessageIdR2018a(&b_st, &ab_emlrtRTEI,
              "MATLAB:subsdeldimmismatch", "MATLAB:subsdeldimmismatch", 0);
          }

          b_st.site = &hj_emlrtRSI;
          nx = centers->size[0] - 1;
          c_st.site = &ij_emlrtRSI;
          c_st.site = &jj_emlrtRSI;
          for (k = b_idx; k <= nx; k++) {
            b_x->data[k - 1] = b_x->data[k];
          }

          c_st.site = &jj_emlrtRSI;
          for (k = b_idx; k <= nx; k++) {
            b_x->data[(k + b_x->size[0]) - 1] = b_x->data[k + b_x->size[0]];
          }

          if (centers->size[0] - 1 > centers->size[0]) {
            emlrtErrorWithMessageIdR2018a(&b_st, &y_emlrtRTEI,
              "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed",
              0);
          }

          if (1 > centers->size[0] - 1) {
            k = 0;
          } else {
            k = centers->size[0] - 1;
          }

          nx = c_x->size[0] * c_x->size[1];
          c_x->size[0] = k;
          c_x->size[1] = 2;
          emxEnsureCapacity_real_T(&b_st, c_x, nx, &pf_emlrtRTEI);
          for (nx = 0; nx < k; nx++) {
            c_x->data[nx] = b_x->data[nx];
          }

          for (nx = 0; nx < k; nx++) {
            c_x->data[nx + c_x->size[0]] = b_x->data[nx + b_x->size[0]];
          }

          nx = b_x->size[0] * b_x->size[1];
          b_x->size[0] = c_x->size[0];
          b_x->size[1] = 2;
          emxEnsureCapacity_real_T(&b_st, b_x, nx, &rf_emlrtRTEI);
          k = c_x->size[0] * c_x->size[1];
          for (nx = 0; nx < k; nx++) {
            b_x->data[nx] = c_x->data[nx];
          }

          nx = centers->size[0] * centers->size[1];
          centers->size[0] = b_x->size[0];
          centers->size[1] = 2;
          emxEnsureCapacity_real_T(sp, centers, nx, &kf_emlrtRTEI);
          k = b_x->size[0] * b_x->size[1];
          for (nx = 0; nx < k; nx++) {
            centers->data[nx] = b_x->data[nx];
          }
        }
      }

      emxFree_real_T(&c_x);
      emxFree_real_T(&b_x);
      if (centers->size[0] != 0) {
        emxInit_real_T(sp, &b_varargin_1, 1, &jf_emlrtRTEI, true);
        st.site = &pg_emlrtRSI;
        k = centers->size[0];
        i = b_varargin_1->size[0];
        b_varargin_1->size[0] = centers->size[0];
        emxEnsureCapacity_real_T(&st, b_varargin_1, i, &jf_emlrtRTEI);
        for (i = 0; i < k; i++) {
          b_varargin_1->data[i] = centers->data[i + centers->size[0]];
        }

        emxInit_real_T(&st, &b_varargin_2, 1, &lf_emlrtRTEI, true);
        b_st.site = &pg_emlrtRSI;
        b_round(&b_st, b_varargin_1);
        k = centers->size[0];
        i = b_varargin_2->size[0];
        b_varargin_2->size[0] = centers->size[0];
        emxEnsureCapacity_real_T(&st, b_varargin_2, i, &lf_emlrtRTEI);
        for (i = 0; i < k; i++) {
          b_varargin_2->data[i] = centers->data[i];
        }

        emxInit_int32_T(&st, &r, 1, &vf_emlrtRTEI, true);
        b_st.site = &pg_emlrtRSI;
        b_round(&b_st, b_varargin_2);
        b_st.site = &xf_emlrtRSI;
        eml_sub2ind(&b_st, *(int32_T (*)[2])Hd->size, b_varargin_1, b_varargin_2,
                    r);
        i = b_varargin_1->size[0];
        b_varargin_1->size[0] = r->size[0];
        emxEnsureCapacity_real_T(&st, b_varargin_1, i, &mf_emlrtRTEI);
        k = r->size[0];
        emxFree_real_T(&b_varargin_2);
        for (i = 0; i < k; i++) {
          b_varargin_1->data[i] = r->data[i];
        }

        emxFree_int32_T(&r);
        st.site = &pg_emlrtRSI;
        b_indexShapeCheck(&st, *(int32_T (*)[2])Hd->size, b_varargin_1->size[0]);
        nx = Hd->size[0] * Hd->size[1];
        k = b_varargin_1->size[0];
        for (i = 0; i < k; i++) {
          i1 = (int32_T)b_varargin_1->data[i];
          if ((i1 < 1) || (i1 > nx)) {
            emlrtDynamicBoundsCheckR2012b(i1, 1, nx, &lc_emlrtBCI, sp);
          }
        }

        emxInit_real_T(sp, &b_metric, 2, &if_emlrtRTEI, true);
        st.site = &qg_emlrtRSI;
        i = b_metric->size[0] * b_metric->size[1];
        b_metric->size[0] = b_varargin_1->size[0];
        b_metric->size[1] = 1;
        emxEnsureCapacity_real_T(&st, b_metric, i, &nf_emlrtRTEI);
        k = b_varargin_1->size[0];
        for (i = 0; i < k; i++) {
          b_metric->data[i] = Hd->data[(int32_T)b_varargin_1->data[i] - 1];
        }

        emxFree_real_T(&b_varargin_1);
        emxInit_int32_T(&st, &iidx, 2, &if_emlrtRTEI, true);
        b_st.site = &nj_emlrtRSI;
        b_sort(&b_st, b_metric, iidx);
        i = metric->size[0] * metric->size[1];
        metric->size[0] = b_metric->size[0];
        metric->size[1] = 1;
        emxEnsureCapacity_real_T(sp, metric, i, &of_emlrtRTEI);
        k = b_metric->size[0] * b_metric->size[1];
        for (i = 0; i < k; i++) {
          metric->data[i] = b_metric->data[i];
        }

        emxFree_real_T(&b_metric);
        emxInit_real_T(sp, &b_centers, 2, &qf_emlrtRTEI, true);
        i = b_centers->size[0] * b_centers->size[1];
        b_centers->size[0] = iidx->size[0];
        b_centers->size[1] = 2;
        emxEnsureCapacity_real_T(sp, b_centers, i, &qf_emlrtRTEI);
        k = iidx->size[0];
        for (i = 0; i < k; i++) {
          if ((iidx->data[i] < 1) || (iidx->data[i] > centers->size[0])) {
            emlrtDynamicBoundsCheckR2012b(iidx->data[i], 1, centers->size[0],
              &rc_emlrtBCI, sp);
          }

          b_centers->data[i] = centers->data[iidx->data[i] - 1];
        }

        for (i = 0; i < k; i++) {
          if ((iidx->data[i] < 1) || (iidx->data[i] > centers->size[0])) {
            emlrtDynamicBoundsCheckR2012b(iidx->data[i], 1, centers->size[0],
              &rc_emlrtBCI, sp);
          }

          b_centers->data[i + b_centers->size[0]] = centers->data[(iidx->data[i]
            + centers->size[0]) - 1];
        }

        emxFree_int32_T(&iidx);
        i = centers->size[0] * centers->size[1];
        centers->size[0] = b_centers->size[0];
        centers->size[1] = b_centers->size[1];
        emxEnsureCapacity_real_T(sp, centers, i, &sf_emlrtRTEI);
        k = b_centers->size[0] * b_centers->size[1];
        for (i = 0; i < k; i++) {
          centers->data[i] = b_centers->data[i];
        }

        emxFree_real_T(&b_centers);
      }
    }

    emxFree_struct_T(&s);
    emxFree_real_T(&Hd);
  }

  emxFree_real_T(&accumMatrixRe);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (chcenters.c) */
