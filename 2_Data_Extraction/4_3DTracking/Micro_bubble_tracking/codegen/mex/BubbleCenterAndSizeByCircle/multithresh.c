/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * multithresh.c
 *
 * Code generation for function 'multithresh'
 *
 */

/* Include files */
#include "multithresh.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "abs.h"
#include "any.h"
#include "eml_int_forloop_overflow_check.h"
#include "eps.h"
#include "im2uint8.h"
#include "imhist.h"
#include "mwmathutil.h"
#include "nullAssignment.h"
#include "rt_nonfinite.h"
#include "sort.h"
#include "unique.h"
#include "warning.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo nc_emlrtRSI = { 14, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo oc_emlrtRSI = { 15, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo pc_emlrtRSI = { 24, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo qc_emlrtRSI = { 28, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo rc_emlrtRSI = { 48, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo sc_emlrtRSI = { 89, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo tc_emlrtRSI = { 91, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo uc_emlrtRSI = { 93, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo vc_emlrtRSI = { 95, /* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo wc_emlrtRSI = { 137,/* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo xc_emlrtRSI = { 139,/* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo yc_emlrtRSI = { 140,/* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo ad_emlrtRSI = { 143,/* lineNo */
  "multithresh",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo bd_emlrtRSI = { 669,/* lineNo */
  "getDegenerateThresholds",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo cd_emlrtRSI = { 670,/* lineNo */
  "getDegenerateThresholds",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo dd_emlrtRSI = { 679,/* lineNo */
  "getDegenerateThresholds",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo id_emlrtRSI = { 32, /* lineNo */
  "sort",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\sort.m"/* pathName */
};

static emlrtRSInfo de_emlrtRSI = { 199,/* lineNo */
  "getpdf",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo ee_emlrtRSI = { 217,/* lineNo */
  "getpdf",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo fe_emlrtRSI = { 218,/* lineNo */
  "getpdf",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo ge_emlrtRSI = { 396,/* lineNo */
  "getpdf",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo he_emlrtRSI = { 397,/* lineNo */
  "getpdf",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo we_emlrtRSI = { 554,/* lineNo */
  "checkForDegenerateInput",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo xe_emlrtRSI = { 559,/* lineNo */
  "checkForDegenerateInput",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pathName */
};

static emlrtRSInfo ye_emlrtRSI = { 44, /* lineNo */
  "unique",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtECInfo c_emlrtECI = { 2,   /* nDims */
  559,                                 /* lineNo */
  16,                                  /* colNo */
  "checkForDegenerateInput",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtBCInfo vb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  664,                                 /* lineNo */
  48,                                  /* colNo */
  "",                                  /* aName */
  "getDegenerateThresholds",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  650,                                 /* lineNo */
  57,                                  /* colNo */
  "",                                  /* aName */
  "getDegenerateThresholds",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  647,                                 /* lineNo */
  20,                                  /* colNo */
  "",                                  /* aName */
  "getDegenerateThresholds",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  227,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "getpdf",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ac_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  200,                                 /* lineNo */
  19,                                  /* colNo */
  "",                                  /* aName */
  "getpdf",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  191,                                 /* lineNo */
  35,                                  /* colNo */
  "",                                  /* aName */
  "getpdf",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  18,                                  /* lineNo */
  31,                                  /* colNo */
  "",                                  /* aName */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo dc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  197,                                 /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "getpdf",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ec_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  198,                                 /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "getpdf",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  674,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "getDegenerateThresholds",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo pd_emlrtRTEI = { 15,/* lineNo */
  5,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo qd_emlrtRTEI = { 653,/* lineNo */
  9,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo rd_emlrtRTEI = { 650,/* lineNo */
  9,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo sd_emlrtRTEI = { 663,/* lineNo */
  9,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo td_emlrtRTEI = { 214,/* lineNo */
  13,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo ud_emlrtRTEI = { 226,/* lineNo */
  5,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo vd_emlrtRTEI = { 669,/* lineNo */
  24,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo wd_emlrtRTEI = { 24,/* lineNo */
  1,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo xd_emlrtRTEI = { 669,/* lineNo */
  20,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo yd_emlrtRTEI = { 227,/* lineNo */
  15,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo ae_emlrtRTEI = { 82,/* lineNo */
  13,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo be_emlrtRTEI = { 559,/* lineNo */
  16,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo ce_emlrtRTEI = { 129,/* lineNo */
  5,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo de_emlrtRTEI = { 559,/* lineNo */
  36,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo ee_emlrtRTEI = { 559,/* lineNo */
  5,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo fe_emlrtRTEI = { 637,/* lineNo */
  5,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo ge_emlrtRTEI = { 95,/* lineNo */
  9,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo he_emlrtRTEI = { 145,/* lineNo */
  9,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo ie_emlrtRTEI = { 140,/* lineNo */
  9,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo je_emlrtRTEI = { 9,/* lineNo */
  2,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo ke_emlrtRTEI = { 396,/* lineNo */
  5,                                   /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo le_emlrtRTEI = { 227,/* lineNo */
  17,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

static emlrtRTEInfo me_emlrtRTEI = { 1,/* lineNo */
  29,                                  /* colNo */
  "multithresh",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\multithresh.m"/* pName */
};

/* Function Definitions */
real32_T multithresh(const emlrtStack *sp, const emxArray_real32_T *varargin_1)
{
  real32_T thresh;
  emxArray_real32_T *threshout;
  emxArray_boolean_T *nans;
  emxArray_real_T *uniqueVals_d;
  boolean_T emptyp;
  int32_T idx;
  int32_T N;
  int32_T i;
  boolean_T exitg1;
  emxArray_real32_T *A;
  emxArray_real32_T *threshL;
  real32_T threshCandidate;
  int32_T a;
  boolean_T overflow;
  int32_T k;
  emxArray_real32_T *b_A;
  real32_T y;
  real_T omega[256];
  real_T counts[256];
  real_T idxSum;
  emxArray_real_T *r;
  real_T idxNum;
  emxArray_real_T *b_uniqueVals_d;
  real_T sigma_b_squared[256];
  real_T maxval;
  emxArray_int32_T *r1;
  emxArray_boolean_T *r2;
  emxArray_real32_T b_varargin_1;
  int32_T c_A[1];
  emxArray_uint8_T *Auint8;
  emxArray_boolean_T *r3;
  emxArray_boolean_T *r4;
  int32_T d_A[1];
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack h_st;
  emlrtStack i_st;
  emlrtStack j_st;
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
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  g_st.prev = &f_st;
  g_st.tls = f_st.tls;
  h_st.prev = &g_st;
  h_st.tls = g_st.tls;
  i_st.prev = &h_st;
  i_st.tls = h_st.tls;
  j_st.prev = &i_st;
  j_st.tls = i_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real32_T(sp, &threshout, 2, &pd_emlrtRTEI, true);
  emxInit_boolean_T(sp, &nans, 1, &ud_emlrtRTEI, true);
  emxInit_real_T(sp, &uniqueVals_d, 2, &sd_emlrtRTEI, true);
  if ((varargin_1->size[0] == 0) || (varargin_1->size[1] == 0)) {
    st.site = &nc_emlrtRSI;
    c_warning(&st);
    st.site = &oc_emlrtRSI;
    if (varargin_1->size[0] * varargin_1->size[1] == 0) {
      i = threshout->size[0] * threshout->size[1];
      threshout->size[1] = 1;
      emxEnsureCapacity_real32_T(&st, threshout, i, &pd_emlrtRTEI);
    } else if (1 - varargin_1->size[0] * varargin_1->size[1] > 0) {
      i = varargin_1->size[0] * varargin_1->size[1];
      if (1 > i) {
        emlrtDynamicBoundsCheckR2012b(1, 1, i, &xb_emlrtBCI, &st);
      }

      emxInit_real32_T(&st, &threshL, 2, &rd_emlrtRTEI, true);
      if (varargin_1->data[0] > 1.0F) {
        i = varargin_1->size[0] * varargin_1->size[1];
        if (1 > i) {
          emlrtDynamicBoundsCheckR2012b(1, 1, i, &wb_emlrtBCI, &st);
        }

        N = varargin_1->size[0] * varargin_1->size[1];
        i = threshL->size[0] * threshL->size[1];
        threshL->size[0] = 1;
        threshL->size[1] = N + 1;
        emxEnsureCapacity_real32_T(&st, threshL, i, &rd_emlrtRTEI);
        threshL->data[0] = 1.0F;
        for (i = 0; i < N; i++) {
          threshL->data[i + 1] = varargin_1->data[i];
        }
      } else {
        N = varargin_1->size[0] * varargin_1->size[1];
        i = threshL->size[0] * threshL->size[1];
        threshL->size[0] = 1;
        threshL->size[1] = N;
        emxEnsureCapacity_real32_T(&st, threshL, i, &qd_emlrtRTEI);
        for (i = 0; i < N; i++) {
          threshL->data[i] = varargin_1->data[i];
        }
      }

      if (1.0 - (real_T)threshL->size[1] > 0.0) {
        i = threshout->size[0] * threshout->size[1];
        threshout->size[0] = 1;
        threshout->size[1] = threshL->size[1] + 1;
        emxEnsureCapacity_real32_T(&st, threshout, i, &pd_emlrtRTEI);
        N = threshL->size[1];
        for (i = 0; i < N; i++) {
          threshout->data[i] = threshL->data[i];
        }

        threshout->data[threshL->size[1]] = 0.0F;
        N = varargin_1->size[0] * varargin_1->size[1];
        i = uniqueVals_d->size[0] * uniqueVals_d->size[1];
        uniqueVals_d->size[0] = 1;
        uniqueVals_d->size[1] = N;
        emxEnsureCapacity_real_T(&st, uniqueVals_d, i, &sd_emlrtRTEI);
        for (i = 0; i < N; i++) {
          uniqueVals_d->data[i] = varargin_1->data[i];
        }

        i = varargin_1->size[0] * varargin_1->size[1];
        if (1 > i) {
          emlrtDynamicBoundsCheckR2012b(1, 1, i, &vb_emlrtBCI, &st);
        }

        threshCandidate = varargin_1->data[0];
        N = uniqueVals_d->size[1];
        idx = 1;
        emxInit_real_T(&st, &r, 1, &xd_emlrtRTEI, true);
        emxInit_real_T(&st, &b_uniqueVals_d, 1, &vd_emlrtRTEI, true);
        while (idx <= 1) {
          threshCandidate++;
          i = b_uniqueVals_d->size[0];
          b_uniqueVals_d->size[0] = uniqueVals_d->size[1];
          emxEnsureCapacity_real_T(&st, b_uniqueVals_d, i, &vd_emlrtRTEI);
          for (i = 0; i < N; i++) {
            b_uniqueVals_d->data[i] = uniqueVals_d->data[i] - threshCandidate;
          }

          b_st.site = &bd_emlrtRSI;
          b_abs(&b_st, b_uniqueVals_d, r);
          b_st.site = &cd_emlrtRSI;
          idxNum = eps(threshCandidate);
          i = nans->size[0];
          nans->size[0] = r->size[0];
          emxEnsureCapacity_boolean_T(&st, nans, i, &xd_emlrtRTEI);
          a = r->size[0];
          for (i = 0; i < a; i++) {
            nans->data[i] = (r->data[i] < idxNum);
          }

          b_st.site = &bd_emlrtRSI;
          if (!any(&b_st, nans)) {
            i = threshL->size[1] + 1;
            if ((i < 1) || (i > threshout->size[1])) {
              emlrtDynamicBoundsCheckR2012b(i, 1, threshout->size[1],
                &fc_emlrtBCI, &st);
            }

            threshout->data[i - 1] = threshCandidate;
            idx = 2;
          }
        }

        emxFree_real_T(&b_uniqueVals_d);
        emxFree_real_T(&r);
        b_st.site = &dd_emlrtRSI;
        c_st.site = &id_emlrtRSI;
        sort(&c_st, threshout);
      } else {
        i = threshout->size[0] * threshout->size[1];
        threshout->size[0] = 1;
        threshout->size[1] = threshL->size[1];
        emxEnsureCapacity_real32_T(&st, threshout, i, &pd_emlrtRTEI);
        N = threshL->size[0] * threshL->size[1];
        for (i = 0; i < N; i++) {
          threshout->data[i] = threshL->data[i];
        }
      }

      emxFree_real32_T(&threshL);
    } else {
      N = varargin_1->size[0] * varargin_1->size[1];
      i = threshout->size[0] * threshout->size[1];
      threshout->size[0] = 1;
      threshout->size[1] = N;
      emxEnsureCapacity_real32_T(&st, threshout, i, &pd_emlrtRTEI);
      for (i = 0; i < N; i++) {
        threshout->data[i] = varargin_1->data[i];
      }
    }

    if (1 > threshout->size[1]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, threshout->size[1], &cc_emlrtBCI, sp);
    }

    thresh = 1.0F;
  } else {
    st.site = &pc_emlrtRSI;
    emptyp = true;
    idx = 1;
    N = varargin_1->size[0] * varargin_1->size[1];
    exitg1 = false;
    while ((!exitg1) && (idx <= N)) {
      i = varargin_1->size[0] * varargin_1->size[1];
      if ((idx < 1) || (idx > i)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &bc_emlrtBCI, &st);
      }

      if (muSingleScalarIsInf(varargin_1->data[idx - 1]) || muSingleScalarIsNaN
          (varargin_1->data[idx - 1])) {
        idx++;
      } else {
        exitg1 = true;
      }
    }

    emxInit_real32_T(&st, &A, 1, &yd_emlrtRTEI, true);
    if (idx <= N) {
      i = varargin_1->size[0] * varargin_1->size[1];
      if ((idx < 1) || (idx > i)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &dc_emlrtBCI, &st);
      }

      thresh = varargin_1->data[idx - 1];
      i = varargin_1->size[0] * varargin_1->size[1];
      if (idx > i) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &ec_emlrtBCI, &st);
      }

      threshCandidate = varargin_1->data[idx - 1];
      a = idx + 1;
      b_st.site = &de_emlrtRSI;
      overflow = ((idx + 1 <= N) && (N > 2147483646));
      if (overflow) {
        c_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = a; k <= N; k++) {
        i = varargin_1->size[0] * varargin_1->size[1];
        if ((k < 1) || (k > i)) {
          emlrtDynamicBoundsCheckR2012b(k, 1, i, &ac_emlrtBCI, &st);
        }

        if ((varargin_1->data[k - 1] < thresh) && ((!muSingleScalarIsInf
              (varargin_1->data[k - 1])) && (!muSingleScalarIsNaN
              (varargin_1->data[k - 1])))) {
          thresh = varargin_1->data[k - 1];
        } else {
          if ((varargin_1->data[k - 1] > threshCandidate) &&
              ((!muSingleScalarIsInf(varargin_1->data[k - 1])) &&
               (!muSingleScalarIsNaN(varargin_1->data[k - 1])))) {
            threshCandidate = varargin_1->data[k - 1];
          }
        }
      }

      if (!(thresh == threshCandidate)) {
        emxInit_real32_T(&st, &b_A, 2, &je_emlrtRTEI, true);
        y = threshCandidate - thresh;
        i = b_A->size[0] * b_A->size[1];
        b_A->size[0] = varargin_1->size[0];
        b_A->size[1] = varargin_1->size[1];
        emxEnsureCapacity_real32_T(&st, b_A, i, &td_emlrtRTEI);
        N = varargin_1->size[0] * varargin_1->size[1];
        for (i = 0; i < N; i++) {
          b_A->data[i] = (varargin_1->data[i] - thresh) / y;
        }

        i = nans->size[0];
        nans->size[0] = b_A->size[0] * b_A->size[1];
        emxEnsureCapacity_boolean_T(&st, nans, i, &ud_emlrtRTEI);
        N = b_A->size[0] * b_A->size[1];
        for (i = 0; i < N; i++) {
          nans->data[i] = muSingleScalarIsNaN(b_A->data[i]);
        }

        idx = nans->size[0];
        for (a = 0; a < idx; a++) {
          if (!nans->data[a]) {
            i = b_A->size[0] * b_A->size[1];
            N = a + 1;
            if ((N < 1) || (N > i)) {
              emlrtDynamicBoundsCheckR2012b(N, 1, i, &yb_emlrtBCI, &st);
            }
          }
        }

        idx = nans->size[0];
        N = 0;
        for (a = 0; a < idx; a++) {
          if (!nans->data[a]) {
            N++;
          }
        }

        if (N != 0) {
          idx = nans->size[0] - 1;
          N = 0;
          for (a = 0; a <= idx; a++) {
            if (!nans->data[a]) {
              N++;
            }
          }

          emxInit_int32_T(&st, &r1, 1, &le_emlrtRTEI, true);
          i = r1->size[0];
          r1->size[0] = N;
          emxEnsureCapacity_int32_T(&st, r1, i, &wd_emlrtRTEI);
          N = 0;
          for (a = 0; a <= idx; a++) {
            if (!nans->data[a]) {
              r1->data[N] = a + 1;
              N++;
            }
          }

          i = A->size[0];
          A->size[0] = r1->size[0];
          emxEnsureCapacity_real32_T(&st, A, i, &yd_emlrtRTEI);
          N = r1->size[0];
          for (i = 0; i < N; i++) {
            A->data[i] = b_A->data[r1->data[i] - 1];
          }

          emxFree_int32_T(&r1);
          emxInit_uint8_T(&st, &Auint8, 1, &ke_emlrtRTEI, true);
          b_st.site = &ge_emlrtRSI;
          im2uint8(&b_st, A, Auint8);
          b_st.site = &he_emlrtRSI;
          imhist(&b_st, Auint8, counts);
          idxSum = counts[0];
          emxFree_uint8_T(&Auint8);
          for (k = 0; k < 255; k++) {
            idxSum += counts[k + 1];
          }

          for (i = 0; i < 256; i++) {
            counts[i] /= idxSum;
          }

          emptyp = false;
        }

        emxFree_real32_T(&b_A);
      }
    } else {
      b_st.site = &ee_emlrtRSI;
      c_st.site = &ie_emlrtRSI;
      d_st.site = &je_emlrtRSI;
      e_st.site = &ke_emlrtRSI;
      if (varargin_1->size[0] * varargin_1->size[1] < 1) {
        emlrtErrorWithMessageIdR2018a(&e_st, &m_emlrtRTEI,
          "Coder:toolbox:eml_min_or_max_varDimZero",
          "Coder:toolbox:eml_min_or_max_varDimZero", 0);
      }

      f_st.site = &le_emlrtRSI;
      g_st.site = &me_emlrtRSI;
      N = varargin_1->size[0] * varargin_1->size[1];
      if (varargin_1->size[0] * varargin_1->size[1] <= 2) {
        if (varargin_1->size[0] * varargin_1->size[1] == 1) {
          thresh = varargin_1->data[0];
        } else if ((varargin_1->data[0] > varargin_1->data[1]) ||
                   (muSingleScalarIsNaN(varargin_1->data[0]) &&
                    (!muSingleScalarIsNaN(varargin_1->data[1])))) {
          thresh = varargin_1->data[1];
        } else {
          thresh = varargin_1->data[0];
        }
      } else {
        h_st.site = &mc_emlrtRSI;
        if (!muSingleScalarIsNaN(varargin_1->data[0])) {
          idx = 1;
        } else {
          idx = 0;
          i_st.site = &pb_emlrtRSI;
          if (2 > varargin_1->size[0] * varargin_1->size[1]) {
            overflow = false;
          } else {
            overflow = (varargin_1->size[0] * varargin_1->size[1] > 2147483646);
          }

          if (overflow) {
            j_st.site = &fb_emlrtRSI;
            check_forloop_overflow_error(&j_st);
          }

          k = 2;
          exitg1 = false;
          while ((!exitg1) && (k <= varargin_1->size[0] * varargin_1->size[1]))
          {
            if (!muSingleScalarIsNaN(varargin_1->data[k - 1])) {
              idx = k;
              exitg1 = true;
            } else {
              k++;
            }
          }
        }

        if (idx == 0) {
          thresh = varargin_1->data[0];
        } else {
          h_st.site = &lc_emlrtRSI;
          thresh = varargin_1->data[idx - 1];
          a = idx + 1;
          i_st.site = &qb_emlrtRSI;
          if (idx + 1 > varargin_1->size[0] * varargin_1->size[1]) {
            overflow = false;
          } else {
            overflow = (varargin_1->size[0] * varargin_1->size[1] > 2147483646);
          }

          if (overflow) {
            j_st.site = &fb_emlrtRSI;
            check_forloop_overflow_error(&j_st);
          }

          for (k = a; k <= N; k++) {
            if (thresh > varargin_1->data[k - 1]) {
              thresh = varargin_1->data[k - 1];
            }
          }
        }
      }

      b_st.site = &fe_emlrtRSI;
      c_st.site = &gc_emlrtRSI;
      d_st.site = &hc_emlrtRSI;
      e_st.site = &ic_emlrtRSI;
      if (varargin_1->size[0] * varargin_1->size[1] < 1) {
        emlrtErrorWithMessageIdR2018a(&e_st, &m_emlrtRTEI,
          "Coder:toolbox:eml_min_or_max_varDimZero",
          "Coder:toolbox:eml_min_or_max_varDimZero", 0);
      }

      f_st.site = &jc_emlrtRSI;
      g_st.site = &kc_emlrtRSI;
      N = varargin_1->size[0] * varargin_1->size[1];
      if (varargin_1->size[0] * varargin_1->size[1] <= 2) {
        if (varargin_1->size[0] * varargin_1->size[1] == 1) {
          threshCandidate = varargin_1->data[0];
        } else if ((varargin_1->data[0] < varargin_1->data[1]) ||
                   (muSingleScalarIsNaN(varargin_1->data[0]) &&
                    (!muSingleScalarIsNaN(varargin_1->data[1])))) {
          threshCandidate = varargin_1->data[1];
        } else {
          threshCandidate = varargin_1->data[0];
        }
      } else {
        h_st.site = &mc_emlrtRSI;
        if (!muSingleScalarIsNaN(varargin_1->data[0])) {
          idx = 1;
        } else {
          idx = 0;
          i_st.site = &pb_emlrtRSI;
          if (2 > varargin_1->size[0] * varargin_1->size[1]) {
            overflow = false;
          } else {
            overflow = (varargin_1->size[0] * varargin_1->size[1] > 2147483646);
          }

          if (overflow) {
            j_st.site = &fb_emlrtRSI;
            check_forloop_overflow_error(&j_st);
          }

          k = 2;
          exitg1 = false;
          while ((!exitg1) && (k <= varargin_1->size[0] * varargin_1->size[1]))
          {
            if (!muSingleScalarIsNaN(varargin_1->data[k - 1])) {
              idx = k;
              exitg1 = true;
            } else {
              k++;
            }
          }
        }

        if (idx == 0) {
          threshCandidate = varargin_1->data[0];
        } else {
          h_st.site = &lc_emlrtRSI;
          threshCandidate = varargin_1->data[idx - 1];
          a = idx + 1;
          i_st.site = &qb_emlrtRSI;
          if (idx + 1 > varargin_1->size[0] * varargin_1->size[1]) {
            overflow = false;
          } else {
            overflow = (varargin_1->size[0] * varargin_1->size[1] > 2147483646);
          }

          if (overflow) {
            j_st.site = &fb_emlrtRSI;
            check_forloop_overflow_error(&j_st);
          }

          for (k = a; k <= N; k++) {
            if (threshCandidate < varargin_1->data[k - 1]) {
              threshCandidate = varargin_1->data[k - 1];
            }
          }
        }
      }
    }

    if (emptyp) {
      st.site = &qc_emlrtRSI;
      c_warning(&st);
      if (muSingleScalarIsNaN(thresh)) {
        thresh = 1.0F;
      }
    } else {
      memcpy(&omega[0], &counts[0], 256U * sizeof(real_T));
      for (k = 0; k < 255; k++) {
        omega[k + 1] += omega[k];
      }

      for (i = 0; i < 256; i++) {
        counts[i] *= (real_T)i + 1.0;
      }

      for (k = 0; k < 255; k++) {
        counts[k + 1] += counts[k];
      }

      idxSum = counts[255];
      for (k = 0; k < 256; k++) {
        idxNum = idxSum * omega[k] - counts[k];
        counts[k] = idxNum;
        sigma_b_squared[k] = idxNum * idxNum / (omega[k] * (1.0 - omega[k]));
      }

      st.site = &rc_emlrtRSI;
      b_st.site = &gc_emlrtRSI;
      c_st.site = &hc_emlrtRSI;
      d_st.site = &ic_emlrtRSI;
      e_st.site = &jc_emlrtRSI;
      f_st.site = &kc_emlrtRSI;
      g_st.site = &mc_emlrtRSI;
      if (!muDoubleScalarIsNaN(sigma_b_squared[0])) {
        idx = 1;
      } else {
        idx = 0;
        h_st.site = &pb_emlrtRSI;
        k = 2;
        exitg1 = false;
        while ((!exitg1) && (k <= 256)) {
          if (!muDoubleScalarIsNaN(sigma_b_squared[k - 1])) {
            idx = k;
            exitg1 = true;
          } else {
            k++;
          }
        }
      }

      if (idx == 0) {
        maxval = sigma_b_squared[0];
      } else {
        g_st.site = &lc_emlrtRSI;
        maxval = sigma_b_squared[idx - 1];
        a = idx + 1;
        h_st.site = &qb_emlrtRSI;
        for (k = a; k < 257; k++) {
          idxNum = sigma_b_squared[k - 1];
          if (maxval < idxNum) {
            maxval = idxNum;
          }
        }
      }

      if ((!muDoubleScalarIsInf(maxval)) && (!muDoubleScalarIsNaN(maxval))) {
        idxSum = 0.0;
        idxNum = 0.0;
        for (N = 0; N < 256; N++) {
          if (sigma_b_squared[N] == maxval) {
            idxSum += (real_T)N + 1.0;
            idxNum++;
          }
        }

        i = uniqueVals_d->size[0] * uniqueVals_d->size[1];
        uniqueVals_d->size[0] = 1;
        uniqueVals_d->size[1] = 1;
        emxEnsureCapacity_real_T(sp, uniqueVals_d, i, &ae_emlrtRTEI);
        uniqueVals_d->data[0] = idxSum / idxNum - 1.0;
        idxSum = (real_T)threshCandidate - thresh;
        i = threshout->size[0] * threshout->size[1];
        threshout->size[0] = 1;
        threshout->size[1] = 1;
        emxEnsureCapacity_real32_T(sp, threshout, i, &ce_emlrtRTEI);
        threshout->data[0] = (real32_T)(thresh + uniqueVals_d->data[0] / 255.0 *
          idxSum);
      } else {
        emxInit_boolean_T(sp, &r2, 2, &me_emlrtRTEI, true);
        st.site = &sc_emlrtRSI;
        b_st.site = &we_emlrtRSI;
        N = varargin_1->size[0] * varargin_1->size[1];
        b_varargin_1 = *varargin_1;
        c_A[0] = N;
        b_varargin_1.size = &c_A[0];
        b_varargin_1.numDimensions = 1;
        c_st.site = &ye_emlrtRSI;
        unique_vector(&c_st, &b_varargin_1, A);
        i = r2->size[0] * r2->size[1];
        r2->size[0] = 1;
        r2->size[1] = A->size[0];
        emxEnsureCapacity_boolean_T(&st, r2, i, &be_emlrtRTEI);
        N = A->size[0];
        for (i = 0; i < N; i++) {
          r2->data[i] = muSingleScalarIsInf(A->data[i]);
        }

        emxInit_boolean_T(&st, &r3, 2, &me_emlrtRTEI, true);
        i = r3->size[0] * r3->size[1];
        r3->size[0] = 1;
        r3->size[1] = A->size[0];
        emxEnsureCapacity_boolean_T(&st, r3, i, &de_emlrtRTEI);
        N = A->size[0];
        for (i = 0; i < N; i++) {
          r3->data[i] = muSingleScalarIsNaN(A->data[i]);
        }

        emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])r2->size, *(int32_T (*)[2])
          r3->size, &c_emlrtECI, &st);
        i = threshout->size[0] * threshout->size[1];
        threshout->size[0] = 1;
        threshout->size[1] = A->size[0];
        emxEnsureCapacity_real32_T(&st, threshout, i, &ee_emlrtRTEI);
        N = A->size[0];
        for (i = 0; i < N; i++) {
          threshout->data[i] = A->data[i];
        }

        emxInit_boolean_T(&st, &r4, 2, &be_emlrtRTEI, true);
        i = r4->size[0] * r4->size[1];
        r4->size[0] = 1;
        r4->size[1] = r2->size[1];
        emxEnsureCapacity_boolean_T(&st, r4, i, &be_emlrtRTEI);
        N = r2->size[0] * r2->size[1];
        for (i = 0; i < N; i++) {
          r4->data[i] = (r2->data[i] || r3->data[i]);
        }

        b_st.site = &xe_emlrtRSI;
        nullAssignment(&b_st, threshout, r4);
        if (threshout->size[1] <= 1) {
          st.site = &tc_emlrtRSI;
          c_warning(&st);
        } else {
          st.site = &uc_emlrtRSI;
          f_warning(&st);
        }

        st.site = &vc_emlrtRSI;
        if (threshout->size[1] == 0) {
          i = threshout->size[0] * threshout->size[1];
          threshout->size[0] = 1;
          threshout->size[1] = 1;
          emxEnsureCapacity_real32_T(&st, threshout, i, &fe_emlrtRTEI);
          threshout->data[0] = 1.0F;
        }

        i = uniqueVals_d->size[0] * uniqueVals_d->size[1];
        uniqueVals_d->size[0] = 1;
        uniqueVals_d->size[1] = threshout->size[1];
        emxEnsureCapacity_real_T(sp, uniqueVals_d, i, &ge_emlrtRTEI);
        N = threshout->size[0] * threshout->size[1];
        for (i = 0; i < N; i++) {
          uniqueVals_d->data[i] = threshout->data[i];
        }

        st.site = &wc_emlrtRSI;
        b_st.site = &we_emlrtRSI;
        N = varargin_1->size[0] * varargin_1->size[1];
        b_varargin_1 = *varargin_1;
        d_A[0] = N;
        b_varargin_1.size = &d_A[0];
        b_varargin_1.numDimensions = 1;
        c_st.site = &ye_emlrtRSI;
        unique_vector(&c_st, &b_varargin_1, A);
        i = r2->size[0] * r2->size[1];
        r2->size[0] = 1;
        r2->size[1] = A->size[0];
        emxEnsureCapacity_boolean_T(&st, r2, i, &be_emlrtRTEI);
        N = A->size[0];
        for (i = 0; i < N; i++) {
          r2->data[i] = muSingleScalarIsInf(A->data[i]);
        }

        i = r3->size[0] * r3->size[1];
        r3->size[0] = 1;
        r3->size[1] = A->size[0];
        emxEnsureCapacity_boolean_T(&st, r3, i, &de_emlrtRTEI);
        N = A->size[0];
        for (i = 0; i < N; i++) {
          r3->data[i] = muSingleScalarIsNaN(A->data[i]);
        }

        emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])r2->size, *(int32_T (*)[2])
          r3->size, &c_emlrtECI, &st);
        i = threshout->size[0] * threshout->size[1];
        threshout->size[0] = 1;
        threshout->size[1] = A->size[0];
        emxEnsureCapacity_real32_T(&st, threshout, i, &ee_emlrtRTEI);
        N = A->size[0];
        for (i = 0; i < N; i++) {
          threshout->data[i] = A->data[i];
        }

        i = r4->size[0] * r4->size[1];
        r4->size[0] = 1;
        r4->size[1] = r2->size[1];
        emxEnsureCapacity_boolean_T(&st, r4, i, &be_emlrtRTEI);
        N = r2->size[0] * r2->size[1];
        for (i = 0; i < N; i++) {
          r4->data[i] = (r2->data[i] || r3->data[i]);
        }

        emxFree_boolean_T(&r3);
        emxFree_boolean_T(&r2);
        b_st.site = &xe_emlrtRSI;
        nullAssignment(&b_st, threshout, r4);
        emxFree_boolean_T(&r4);
        if (threshout->size[1] <= 1) {
          st.site = &xc_emlrtRSI;
          c_warning(&st);
          st.site = &yc_emlrtRSI;
          if (threshout->size[1] == 0) {
            i = threshout->size[0] * threshout->size[1];
            threshout->size[0] = 1;
            threshout->size[1] = 1;
            emxEnsureCapacity_real32_T(&st, threshout, i, &ie_emlrtRTEI);
            threshout->data[0] = 1.0F;
          }
        } else {
          st.site = &ad_emlrtRSI;
          f_warning(&st);
          idxSum = (real_T)threshCandidate - thresh;
          i = threshout->size[0] * threshout->size[1];
          threshout->size[0] = 1;
          threshout->size[1] = uniqueVals_d->size[1];
          emxEnsureCapacity_real32_T(sp, threshout, i, &he_emlrtRTEI);
          N = uniqueVals_d->size[0] * uniqueVals_d->size[1];
          for (i = 0; i < N; i++) {
            threshout->data[i] = (real32_T)(thresh + uniqueVals_d->data[i] /
              255.0 * idxSum);
          }
        }
      }

      thresh = threshout->data[0];
    }

    emxFree_real32_T(&A);
  }

  emxFree_real_T(&uniqueVals_d);
  emxFree_boolean_T(&nans);
  emxFree_real32_T(&threshout);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
  return thresh;
}

/* End of code generation (multithresh.c) */
