/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * imhist.c
 *
 * Code generation for function 'imhist'
 *
 */

/* Include files */
#include "imhist.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "libmwgetnumcores.h"
#include "libmwtbbhist.h"
#include "rt_nonfinite.h"
#include "warning.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo qe_emlrtRSI = { 133,/* lineNo */
  "imhist",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m"/* pathName */
};

static emlrtRSInfo te_emlrtRSI = { 203,/* lineNo */
  "calcHistogram",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m"/* pathName */
};

static emlrtRSInfo ue_emlrtRSI = { 428,/* lineNo */
  "calcHistogram",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m"/* pathName */
};

static emlrtRSInfo ve_emlrtRSI = { 432,/* lineNo */
  "calcHistogram",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m"/* pathName */
};

static emlrtBCInfo gc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  808,                                 /* lineNo */
  47,                                  /* colNo */
  "",                                  /* aName */
  "imhistAlgo_integer",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  796,                                 /* lineNo */
  48,                                  /* colNo */
  "",                                  /* aName */
  "imhistAlgo_integer",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ic_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  795,                                 /* lineNo */
  48,                                  /* colNo */
  "",                                  /* aName */
  "imhistAlgo_integer",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  794,                                 /* lineNo */
  48,                                  /* colNo */
  "",                                  /* aName */
  "imhistAlgo_integer",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  793,                                 /* lineNo */
  48,                                  /* colNo */
  "",                                  /* aName */
  "imhistAlgo_integer",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void imhist(const emlrtStack *sp, const emxArray_uint8_T *varargin_1, real_T
            yout[256])
{
  real_T numCores;
  boolean_T nanFlag;
  real_T localBins1[256];
  boolean_T rngFlag;
  real_T localBins2[256];
  real_T localBins3[256];
  int32_T i;
  int32_T yout_tmp;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &qe_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  numCores = 1.0;
  getnumcores(&numCores);
  if ((varargin_1->size[0] > 500000) && (numCores > 1.0)) {
    nanFlag = false;
    rngFlag = false;
    tbbhist_uint8(&varargin_1->data[0], (real_T)varargin_1->size[0], (real_T)
                  varargin_1->size[0], (real_T)varargin_1->size[0] / (real_T)
                  varargin_1->size[0], yout, 256.0, 256.0, &rngFlag, &nanFlag);
  } else {
    b_st.site = &te_emlrtRSI;
    memset(&yout[0], 0, 256U * sizeof(real_T));
    memset(&localBins1[0], 0, 256U * sizeof(real_T));
    memset(&localBins2[0], 0, 256U * sizeof(real_T));
    memset(&localBins3[0], 0, 256U * sizeof(real_T));
    for (i = 1; i + 3 <= varargin_1->size[0]; i += 4) {
      if ((i < 1) || (i > varargin_1->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, varargin_1->size[0], &kc_emlrtBCI,
          &b_st);
      }

      yout_tmp = i + 1;
      if ((yout_tmp < 1) || (yout_tmp > varargin_1->size[0])) {
        emlrtDynamicBoundsCheckR2012b(yout_tmp, 1, varargin_1->size[0],
          &jc_emlrtBCI, &b_st);
      }

      yout_tmp = i + 2;
      if ((yout_tmp < 1) || (yout_tmp > varargin_1->size[0])) {
        emlrtDynamicBoundsCheckR2012b(yout_tmp, 1, varargin_1->size[0],
          &ic_emlrtBCI, &b_st);
      }

      yout_tmp = i + 3;
      if ((yout_tmp < 1) || (yout_tmp > varargin_1->size[0])) {
        emlrtDynamicBoundsCheckR2012b(yout_tmp, 1, varargin_1->size[0],
          &hc_emlrtBCI, &b_st);
      }

      yout_tmp = varargin_1->data[i - 1];
      localBins1[yout_tmp]++;
      localBins2[varargin_1->data[i]]++;
      yout_tmp = varargin_1->data[i + 1];
      localBins3[yout_tmp]++;
      yout_tmp = varargin_1->data[i + 2];
      yout[yout_tmp]++;
    }

    while (i <= varargin_1->size[0]) {
      if ((i < 1) || (i > varargin_1->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, varargin_1->size[0], &gc_emlrtBCI,
          &b_st);
      }

      yout_tmp = varargin_1->data[i - 1];
      yout[yout_tmp]++;
      i++;
    }

    for (i = 0; i < 256; i++) {
      yout[i] = ((yout[i] + localBins1[i]) + localBins2[i]) + localBins3[i];
    }

    rngFlag = false;
    nanFlag = false;
  }

  if (rngFlag) {
    b_st.site = &ue_emlrtRSI;
    d_warning(&b_st);
  }

  if (nanFlag) {
    b_st.site = &ve_emlrtRSI;
    e_warning(&b_st);
  }
}

/* End of code generation (imhist.c) */
