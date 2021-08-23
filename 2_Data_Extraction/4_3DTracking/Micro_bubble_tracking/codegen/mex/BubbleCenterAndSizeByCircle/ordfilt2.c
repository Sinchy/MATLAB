/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ordfilt2.c
 *
 * Code generation for function 'ordfilt2'
 *
 */

/* Include files */
#include "ordfilt2.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "abs.h"
#include "eml_int_forloop_overflow_check.h"
#include "indexShapeCheck.h"
#include "libmwordfilt2.h"
#include "mwmathutil.h"
#include "padarray.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo wg_emlrtRSI = { 25, /* lineNo */
  "ordfilt2",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pathName */
};

static emlrtRSInfo xg_emlrtRSI = { 99, /* lineNo */
  "ordfilt2",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pathName */
};

static emlrtRSInfo yg_emlrtRSI = { 134,/* lineNo */
  "ordfilt2",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pathName */
};

static emlrtRSInfo ah_emlrtRSI = { 137,/* lineNo */
  "ordfilt2",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pathName */
};

static emlrtRSInfo bh_emlrtRSI = { 155,/* lineNo */
  "ordfilt2",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pathName */
};

static emlrtRSInfo fh_emlrtRSI = { 179,/* lineNo */
  "ordfilt2SharedLibrary",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pathName */
};

static emlrtECInfo f_emlrtECI = { -1,  /* nDims */
  153,                                 /* lineNo */
  25,                                  /* colNo */
  "ordfilt2",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pName */
};

static emlrtRTEInfo xh_emlrtRTEI = { 155,/* lineNo */
  13,                                  /* colNo */
  "ordfilt2",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pName */
};

static emlrtRTEInfo yh_emlrtRTEI = { 137,/* lineNo */
  5,                                   /* colNo */
  "ordfilt2",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pName */
};

static emlrtRTEInfo ai_emlrtRTEI = { 134,/* lineNo */
  19,                                  /* colNo */
  "ordfilt2",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\ordfilt2.m"/* pName */
};

/* Function Definitions */
void ordfilt2(const emlrtStack *sp, emxArray_real_T *varargin_1)
{
  int32_T idx;
  int32_T ii;
  int32_T jj;
  boolean_T exitg1;
  int32_T loop_ub;
  int32_T indices_data[25];
  int8_T j_data[25];
  int32_T iv[2];
  int32_T rows_size[1];
  int32_T cols_size[1];
  real_T rows_data[25];
  emxArray_real_T *b_varargin_1;
  real_T cols_data[25];
  emxArray_real_T b_rows_data;
  real_T padSize;
  boolean_T overflow;
  emxArray_real_T b_cols_data;
  real_T d;
  real_T ex;
  emxArray_real_T *Apad;
  real_T startIdx[2];
  real_T domainSizeT[2];
  real_T c_varargin_1[2];
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack h_st;
  emlrtStack i_st;
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
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &wg_emlrtRSI;
  st.site = &xg_emlrtRSI;
  b_st.site = &sf_emlrtRSI;
  c_st.site = &tf_emlrtRSI;
  idx = 0;
  ii = 1;
  jj = 1;
  exitg1 = false;
  while ((!exitg1) && (jj <= 5)) {
    idx++;
    indices_data[idx - 1] = ii;
    j_data[idx - 1] = (int8_T)jj;
    if (idx >= 25) {
      exitg1 = true;
    } else {
      ii++;
      if (ii > 5) {
        ii = 1;
        jj++;
      }
    }
  }

  if (1 > idx) {
    loop_ub = 0;
  } else {
    loop_ub = idx;
  }

  iv[0] = 1;
  iv[1] = loop_ub;
  d_st.site = &uf_emlrtRSI;
  indexShapeCheck(&d_st, 25, iv);
  if (1 > idx) {
    ii = 0;
  } else {
    ii = idx;
  }

  iv[0] = 1;
  iv[1] = ii;
  d_st.site = &vf_emlrtRSI;
  indexShapeCheck(&d_st, 25, iv);
  if (1 > idx) {
    idx = 0;
  }

  iv[0] = 1;
  iv[1] = idx;
  d_st.site = &wf_emlrtRSI;
  indexShapeCheck(&d_st, 25, iv);
  rows_size[0] = loop_ub;
  for (idx = 0; idx < loop_ub; idx++) {
    rows_data[idx] = (real_T)indices_data[idx] - 3.0;
  }

  cols_size[0] = ii;
  for (idx = 0; idx < ii; idx++) {
    cols_data[idx] = (real_T)j_data[idx] - 3.0;
  }

  emxInit_real_T(sp, &b_varargin_1, 1, &ai_emlrtRTEI, true);
  st.site = &yg_emlrtRSI;
  b_rows_data.data = &rows_data[0];
  b_rows_data.size = &rows_size[0];
  b_rows_data.allocatedSize = 25;
  b_rows_data.numDimensions = 1;
  b_rows_data.canFreeData = false;
  b_st.site = &yg_emlrtRSI;
  b_abs(&b_st, &b_rows_data, b_varargin_1);
  b_st.site = &gc_emlrtRSI;
  c_st.site = &hc_emlrtRSI;
  d_st.site = &ic_emlrtRSI;
  if (b_varargin_1->size[0] < 1) {
    emlrtErrorWithMessageIdR2018a(&d_st, &m_emlrtRTEI,
      "Coder:toolbox:eml_min_or_max_varDimZero",
      "Coder:toolbox:eml_min_or_max_varDimZero", 0);
  }

  e_st.site = &jc_emlrtRSI;
  f_st.site = &kc_emlrtRSI;
  ii = b_varargin_1->size[0];
  if (b_varargin_1->size[0] <= 2) {
    if (b_varargin_1->size[0] == 1) {
      padSize = b_varargin_1->data[0];
    } else if ((b_varargin_1->data[0] < b_varargin_1->data[1]) ||
               (muDoubleScalarIsNaN(b_varargin_1->data[0]) &&
                (!muDoubleScalarIsNaN(b_varargin_1->data[1])))) {
      padSize = b_varargin_1->data[1];
    } else {
      padSize = b_varargin_1->data[0];
    }
  } else {
    g_st.site = &mc_emlrtRSI;
    if (!muDoubleScalarIsNaN(b_varargin_1->data[0])) {
      idx = 1;
    } else {
      idx = 0;
      h_st.site = &pb_emlrtRSI;
      if (b_varargin_1->size[0] > 2147483646) {
        i_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&i_st);
      }

      loop_ub = 2;
      exitg1 = false;
      while ((!exitg1) && (loop_ub <= b_varargin_1->size[0])) {
        if (!muDoubleScalarIsNaN(b_varargin_1->data[loop_ub - 1])) {
          idx = loop_ub;
          exitg1 = true;
        } else {
          loop_ub++;
        }
      }
    }

    if (idx == 0) {
      padSize = b_varargin_1->data[0];
    } else {
      g_st.site = &lc_emlrtRSI;
      padSize = b_varargin_1->data[idx - 1];
      jj = idx + 1;
      h_st.site = &qb_emlrtRSI;
      if (idx + 1 > b_varargin_1->size[0]) {
        overflow = false;
      } else {
        overflow = (b_varargin_1->size[0] > 2147483646);
      }

      if (overflow) {
        i_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&i_st);
      }

      for (loop_ub = jj; loop_ub <= ii; loop_ub++) {
        d = b_varargin_1->data[loop_ub - 1];
        if (padSize < d) {
          padSize = d;
        }
      }
    }
  }

  st.site = &yg_emlrtRSI;
  b_cols_data.data = &cols_data[0];
  b_cols_data.size = &cols_size[0];
  b_cols_data.allocatedSize = 25;
  b_cols_data.numDimensions = 1;
  b_cols_data.canFreeData = false;
  b_st.site = &yg_emlrtRSI;
  b_abs(&b_st, &b_cols_data, b_varargin_1);
  b_st.site = &gc_emlrtRSI;
  c_st.site = &hc_emlrtRSI;
  d_st.site = &ic_emlrtRSI;
  if (b_varargin_1->size[0] < 1) {
    emlrtErrorWithMessageIdR2018a(&d_st, &m_emlrtRTEI,
      "Coder:toolbox:eml_min_or_max_varDimZero",
      "Coder:toolbox:eml_min_or_max_varDimZero", 0);
  }

  e_st.site = &jc_emlrtRSI;
  f_st.site = &kc_emlrtRSI;
  ii = b_varargin_1->size[0];
  if (b_varargin_1->size[0] <= 2) {
    if (b_varargin_1->size[0] == 1) {
      ex = b_varargin_1->data[0];
    } else if ((b_varargin_1->data[0] < b_varargin_1->data[1]) ||
               (muDoubleScalarIsNaN(b_varargin_1->data[0]) &&
                (!muDoubleScalarIsNaN(b_varargin_1->data[1])))) {
      ex = b_varargin_1->data[1];
    } else {
      ex = b_varargin_1->data[0];
    }
  } else {
    g_st.site = &mc_emlrtRSI;
    if (!muDoubleScalarIsNaN(b_varargin_1->data[0])) {
      idx = 1;
    } else {
      idx = 0;
      h_st.site = &pb_emlrtRSI;
      if (b_varargin_1->size[0] > 2147483646) {
        i_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&i_st);
      }

      loop_ub = 2;
      exitg1 = false;
      while ((!exitg1) && (loop_ub <= b_varargin_1->size[0])) {
        if (!muDoubleScalarIsNaN(b_varargin_1->data[loop_ub - 1])) {
          idx = loop_ub;
          exitg1 = true;
        } else {
          loop_ub++;
        }
      }
    }

    if (idx == 0) {
      ex = b_varargin_1->data[0];
    } else {
      g_st.site = &lc_emlrtRSI;
      ex = b_varargin_1->data[idx - 1];
      jj = idx + 1;
      h_st.site = &qb_emlrtRSI;
      if (idx + 1 > b_varargin_1->size[0]) {
        overflow = false;
      } else {
        overflow = (b_varargin_1->size[0] > 2147483646);
      }

      if (overflow) {
        i_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&i_st);
      }

      for (loop_ub = jj; loop_ub <= ii; loop_ub++) {
        d = b_varargin_1->data[loop_ub - 1];
        if (ex < d) {
          ex = d;
        }
      }
    }
  }

  emxFree_real_T(&b_varargin_1);
  emxInit_real_T(&f_st, &Apad, 2, &yh_emlrtRTEI, true);
  padSize = muDoubleScalarMax(padSize, ex);
  startIdx[0] = padSize;
  startIdx[1] = padSize;
  st.site = &ah_emlrtRSI;
  padarray(&st, varargin_1, startIdx, Apad);
  if ((varargin_1->size[0] != 0) && (varargin_1->size[1] != 0)) {
    loop_ub = cols_size[0];
    for (idx = 0; idx < loop_ub; idx++) {
      cols_data[idx] *= (real_T)Apad->size[0];
    }

    if (cols_size[0] != rows_size[0]) {
      emlrtSizeEqCheck1DR2012b(cols_size[0], rows_size[0], &f_emlrtECI, sp);
    }

    ii = cols_size[0];
    loop_ub = cols_size[0];
    for (idx = 0; idx < loop_ub; idx++) {
      d = muDoubleScalarRound(cols_data[idx] + rows_data[idx]);
      if (d < 2.147483648E+9) {
        if (d >= -2.147483648E+9) {
          jj = (int32_T)d;
        } else {
          jj = MIN_int32_T;
        }
      } else if (d >= 2.147483648E+9) {
        jj = MAX_int32_T;
      } else {
        jj = 0;
      }

      indices_data[idx] = jj;
    }

    startIdx[0] = padSize;
    startIdx[1] = padSize;
    st.site = &bh_emlrtRSI;
    domainSizeT[1] = varargin_1->size[1];
    idx = varargin_1->size[0] * varargin_1->size[1];
    varargin_1->size[1] = (int32_T)domainSizeT[1];
    emxEnsureCapacity_real_T(&st, varargin_1, idx, &xh_emlrtRTEI);
    b_st.site = &fh_emlrtRSI;
    domainSizeT[0] = 5.0;
    c_varargin_1[0] = varargin_1->size[0];
    domainSizeT[1] = 5.0;
    c_varargin_1[1] = varargin_1->size[1];
    ordfilt2_real64(&Apad->data[0], (real_T)Apad->size[0], startIdx,
                    &indices_data[0], (real_T)ii, domainSizeT, 12.0,
                    &varargin_1->data[0], c_varargin_1, true);
  }

  emxFree_real_T(&Apad);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (ordfilt2.c) */
