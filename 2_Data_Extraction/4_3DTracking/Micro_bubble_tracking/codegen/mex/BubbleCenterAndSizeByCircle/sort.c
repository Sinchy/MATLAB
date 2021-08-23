/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sort.c
 *
 * Code generation for function 'sort'
 *
 */

/* Include files */
#include "sort.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "sortIdx.h"

/* Variable Definitions */
static emlrtRSInfo jd_emlrtRSI = { 72, /* lineNo */
  "sort",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sort.m"/* pathName */
};

static emlrtRSInfo kd_emlrtRSI = { 105,/* lineNo */
  "sortIdx",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo ld_emlrtRSI = { 308,/* lineNo */
  "block_merge_sort",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo md_emlrtRSI = { 316,/* lineNo */
  "block_merge_sort",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo nd_emlrtRSI = { 317,/* lineNo */
  "block_merge_sort",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo od_emlrtRSI = { 325,/* lineNo */
  "block_merge_sort",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo pd_emlrtRSI = { 333,/* lineNo */
  "block_merge_sort",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo qd_emlrtRSI = { 392,/* lineNo */
  "initialize_vector_sort",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo rd_emlrtRSI = { 420,/* lineNo */
  "initialize_vector_sort",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo sd_emlrtRSI = { 427,/* lineNo */
  "initialize_vector_sort",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo oj_emlrtRSI = { 94, /* lineNo */
  "sortIdx",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo pj_emlrtRSI = { 95, /* lineNo */
  "sortIdx",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo qj_emlrtRSI = { 340,/* lineNo */
  "block_merge_sort",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo rj_emlrtRSI = { 354,/* lineNo */
  "shift_NaNs",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo sj_emlrtRSI = { 363,/* lineNo */
  "shift_NaNs",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRTEInfo qh_emlrtRTEI = { 56,/* lineNo */
  5,                                   /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

static emlrtRTEInfo rh_emlrtRTEI = { 386,/* lineNo */
  1,                                   /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

static emlrtRTEInfo sh_emlrtRTEI = { 388,/* lineNo */
  1,                                   /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

static emlrtRTEInfo th_emlrtRTEI = { 1,/* lineNo */
  20,                                  /* colNo */
  "sort",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sort.m"/* pName */
};

static emlrtRTEInfo uh_emlrtRTEI = { 308,/* lineNo */
  14,                                  /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

static emlrtRTEInfo vh_emlrtRTEI = { 308,/* lineNo */
  20,                                  /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

static emlrtRTEInfo hi_emlrtRTEI = { 61,/* lineNo */
  5,                                   /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

static emlrtRTEInfo ii_emlrtRTEI = { 95,/* lineNo */
  50,                                  /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

static emlrtRTEInfo ji_emlrtRTEI = { 95,/* lineNo */
  59,                                  /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

/* Function Definitions */
void b_sort(const emlrtStack *sp, emxArray_real_T *x, emxArray_int32_T *idx)
{
  int32_T ib;
  int32_T i;
  emxArray_int32_T *b_idx;
  emxArray_real_T *b_x;
  emxArray_int32_T *iwork;
  real_T x4[4];
  int32_T idx4[4];
  int32_T i1;
  emxArray_real_T *xwork;
  int32_T nNaNs;
  boolean_T overflow;
  int32_T k;
  int32_T i4;
  int32_T idx_tmp;
  int8_T perm[4];
  int32_T quartetOffset;
  int32_T i3;
  real_T d;
  real_T d1;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
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
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &jd_emlrtRSI;
  ib = x->size[0];
  i = idx->size[0] * idx->size[1];
  idx->size[0] = ib;
  idx->size[1] = 1;
  emxEnsureCapacity_int32_T(&st, idx, i, &hi_emlrtRTEI);
  for (i = 0; i < ib; i++) {
    idx->data[i] = 0;
  }

  if (x->size[0] != 0) {
    emxInit_int32_T(&st, &b_idx, 1, &th_emlrtRTEI, true);
    b_st.site = &oj_emlrtRSI;
    b_st.site = &pj_emlrtRSI;
    ib = idx->size[0];
    i = b_idx->size[0];
    b_idx->size[0] = idx->size[0];
    emxEnsureCapacity_int32_T(&b_st, b_idx, i, &ii_emlrtRTEI);
    for (i = 0; i < ib; i++) {
      b_idx->data[i] = idx->data[i];
    }

    emxInit_real_T(&b_st, &b_x, 1, &th_emlrtRTEI, true);
    ib = x->size[0];
    i = b_x->size[0];
    b_x->size[0] = ib;
    emxEnsureCapacity_real_T(&b_st, b_x, i, &ji_emlrtRTEI);
    for (i = 0; i < ib; i++) {
      b_x->data[i] = x->data[i];
    }

    emxInit_int32_T(&b_st, &iwork, 1, &uh_emlrtRTEI, true);
    c_st.site = &ld_emlrtRSI;
    i = x->size[0];
    x4[0] = 0.0;
    idx4[0] = 0;
    x4[1] = 0.0;
    idx4[1] = 0;
    x4[2] = 0.0;
    idx4[2] = 0;
    x4[3] = 0.0;
    idx4[3] = 0;
    ib = idx->size[0];
    i1 = iwork->size[0];
    iwork->size[0] = idx->size[0];
    emxEnsureCapacity_int32_T(&c_st, iwork, i1, &rh_emlrtRTEI);
    for (i1 = 0; i1 < ib; i1++) {
      iwork->data[i1] = 0;
    }

    emxInit_real_T(&c_st, &xwork, 1, &vh_emlrtRTEI, true);
    ib = x->size[0];
    i1 = xwork->size[0];
    xwork->size[0] = x->size[0];
    emxEnsureCapacity_real_T(&c_st, xwork, i1, &sh_emlrtRTEI);
    for (i1 = 0; i1 < ib; i1++) {
      xwork->data[i1] = 0.0;
    }

    nNaNs = 0;
    ib = -1;
    d_st.site = &qd_emlrtRSI;
    if (1 > x->size[0]) {
      overflow = false;
    } else {
      overflow = (x->size[0] > 2147483646);
    }

    if (overflow) {
      e_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&e_st);
    }

    for (k = 0; k < i; k++) {
      if (muDoubleScalarIsNaN(b_x->data[k])) {
        idx_tmp = (i - nNaNs) - 1;
        b_idx->data[idx_tmp] = k + 1;
        xwork->data[idx_tmp] = b_x->data[k];
        nNaNs++;
      } else {
        ib++;
        idx4[ib] = k + 1;
        x4[ib] = b_x->data[k];
        if (ib + 1 == 4) {
          quartetOffset = k - nNaNs;
          if (x4[0] >= x4[1]) {
            i1 = 1;
            ib = 2;
          } else {
            i1 = 2;
            ib = 1;
          }

          if (x4[2] >= x4[3]) {
            i3 = 3;
            i4 = 4;
          } else {
            i3 = 4;
            i4 = 3;
          }

          d = x4[i1 - 1];
          d1 = x4[i3 - 1];
          if (d >= d1) {
            d = x4[ib - 1];
            if (d >= d1) {
              perm[0] = (int8_T)i1;
              perm[1] = (int8_T)ib;
              perm[2] = (int8_T)i3;
              perm[3] = (int8_T)i4;
            } else if (d >= x4[i4 - 1]) {
              perm[0] = (int8_T)i1;
              perm[1] = (int8_T)i3;
              perm[2] = (int8_T)ib;
              perm[3] = (int8_T)i4;
            } else {
              perm[0] = (int8_T)i1;
              perm[1] = (int8_T)i3;
              perm[2] = (int8_T)i4;
              perm[3] = (int8_T)ib;
            }
          } else {
            d1 = x4[i4 - 1];
            if (d >= d1) {
              if (x4[ib - 1] >= d1) {
                perm[0] = (int8_T)i3;
                perm[1] = (int8_T)i1;
                perm[2] = (int8_T)ib;
                perm[3] = (int8_T)i4;
              } else {
                perm[0] = (int8_T)i3;
                perm[1] = (int8_T)i1;
                perm[2] = (int8_T)i4;
                perm[3] = (int8_T)ib;
              }
            } else {
              perm[0] = (int8_T)i3;
              perm[1] = (int8_T)i4;
              perm[2] = (int8_T)i1;
              perm[3] = (int8_T)ib;
            }
          }

          idx_tmp = perm[0] - 1;
          b_idx->data[quartetOffset - 3] = idx4[idx_tmp];
          i3 = perm[1] - 1;
          b_idx->data[quartetOffset - 2] = idx4[i3];
          ib = perm[2] - 1;
          b_idx->data[quartetOffset - 1] = idx4[ib];
          i1 = perm[3] - 1;
          b_idx->data[quartetOffset] = idx4[i1];
          b_x->data[quartetOffset - 3] = x4[idx_tmp];
          b_x->data[quartetOffset - 2] = x4[i3];
          b_x->data[quartetOffset - 1] = x4[ib];
          b_x->data[quartetOffset] = x4[i1];
          ib = -1;
        }
      }
    }

    i4 = (x->size[0] - nNaNs) - 1;
    if (ib + 1 > 0) {
      perm[1] = 0;
      perm[2] = 0;
      perm[3] = 0;
      if (ib + 1 == 1) {
        perm[0] = 1;
      } else if (ib + 1 == 2) {
        if (x4[0] >= x4[1]) {
          perm[0] = 1;
          perm[1] = 2;
        } else {
          perm[0] = 2;
          perm[1] = 1;
        }
      } else if (x4[0] >= x4[1]) {
        if (x4[1] >= x4[2]) {
          perm[0] = 1;
          perm[1] = 2;
          perm[2] = 3;
        } else if (x4[0] >= x4[2]) {
          perm[0] = 1;
          perm[1] = 3;
          perm[2] = 2;
        } else {
          perm[0] = 3;
          perm[1] = 1;
          perm[2] = 2;
        }
      } else if (x4[0] >= x4[2]) {
        perm[0] = 2;
        perm[1] = 1;
        perm[2] = 3;
      } else if (x4[1] >= x4[2]) {
        perm[0] = 2;
        perm[1] = 3;
        perm[2] = 1;
      } else {
        perm[0] = 3;
        perm[1] = 2;
        perm[2] = 1;
      }

      d_st.site = &rd_emlrtRSI;
      if (ib + 1 > 2147483646) {
        e_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&e_st);
      }

      for (k = 0; k <= ib; k++) {
        idx_tmp = perm[k] - 1;
        i3 = (i4 - ib) + k;
        b_idx->data[i3] = idx4[idx_tmp];
        b_x->data[i3] = x4[idx_tmp];
      }
    }

    ib = (nNaNs >> 1) + 1;
    d_st.site = &sd_emlrtRSI;
    for (k = 0; k <= ib - 2; k++) {
      i1 = (i4 + k) + 1;
      i3 = b_idx->data[i1];
      idx_tmp = (i - k) - 1;
      b_idx->data[i1] = b_idx->data[idx_tmp];
      b_idx->data[idx_tmp] = i3;
      b_x->data[i1] = xwork->data[idx_tmp];
      b_x->data[idx_tmp] = xwork->data[i1];
    }

    if ((nNaNs & 1) != 0) {
      ib += i4;
      b_x->data[ib] = xwork->data[ib];
    }

    i3 = x->size[0] - nNaNs;
    ib = 2;
    if (i3 > 1) {
      if (x->size[0] >= 256) {
        i1 = i3 >> 8;
        if (i1 > 0) {
          c_st.site = &md_emlrtRSI;
          for (ib = 0; ib < i1; ib++) {
            c_st.site = &nd_emlrtRSI;
            b_merge_pow2_block(b_idx, b_x, ib << 8);
          }

          ib = i1 << 8;
          i1 = i3 - ib;
          if (i1 > 0) {
            c_st.site = &od_emlrtRSI;
            b_merge_block(&c_st, b_idx, b_x, ib, i1, 2, iwork, xwork);
          }

          ib = 8;
        }
      }

      c_st.site = &pd_emlrtRSI;
      b_merge_block(&c_st, b_idx, b_x, 0, i3, ib, iwork, xwork);
    }

    if ((nNaNs > 0) && (i3 > 0)) {
      c_st.site = &qj_emlrtRSI;
      d_st.site = &rj_emlrtRSI;
      if (nNaNs > 2147483646) {
        e_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&e_st);
      }

      for (k = 0; k < nNaNs; k++) {
        ib = i3 + k;
        xwork->data[k] = b_x->data[ib];
        iwork->data[k] = b_idx->data[ib];
      }

      for (k = i3; k >= 1; k--) {
        ib = (nNaNs + k) - 1;
        b_x->data[ib] = b_x->data[k - 1];
        b_idx->data[ib] = b_idx->data[k - 1];
      }

      d_st.site = &sj_emlrtRSI;
      for (k = 0; k < nNaNs; k++) {
        b_x->data[k] = xwork->data[k];
        b_idx->data[k] = iwork->data[k];
      }
    }

    emxFree_real_T(&xwork);
    emxFree_int32_T(&iwork);
    ib = b_idx->size[0];
    for (i = 0; i < ib; i++) {
      idx->data[i] = b_idx->data[i];
    }

    emxFree_int32_T(&b_idx);
    ib = b_x->size[0];
    for (i = 0; i < ib; i++) {
      x->data[i] = b_x->data[i];
    }

    emxFree_real_T(&b_x);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

void sort(const emlrtStack *sp, emxArray_real32_T *x)
{
  emxArray_int32_T *idx;
  int32_T i1;
  int32_T ib;
  emxArray_int32_T *iwork;
  int32_T n;
  int32_T b_n;
  real32_T x4[4];
  int32_T idx4[4];
  emxArray_real32_T *xwork;
  int32_T nNaNs;
  boolean_T overflow;
  int32_T k;
  int32_T i4;
  int32_T idx_tmp;
  int8_T perm[4];
  int32_T quartetOffset;
  int32_T i2;
  real32_T f;
  real32_T f1;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
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
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_int32_T(sp, &idx, 2, &th_emlrtRTEI, true);
  st.site = &jd_emlrtRSI;
  i1 = idx->size[0] * idx->size[1];
  idx->size[0] = 1;
  idx->size[1] = x->size[1];
  emxEnsureCapacity_int32_T(&st, idx, i1, &qh_emlrtRTEI);
  ib = x->size[1];
  for (i1 = 0; i1 < ib; i1++) {
    idx->data[i1] = 0;
  }

  emxInit_int32_T(&st, &iwork, 1, &uh_emlrtRTEI, true);
  b_st.site = &kd_emlrtRSI;
  n = x->size[1];
  c_st.site = &ld_emlrtRSI;
  b_n = x->size[1];
  x4[0] = 0.0F;
  idx4[0] = 0;
  x4[1] = 0.0F;
  idx4[1] = 0;
  x4[2] = 0.0F;
  idx4[2] = 0;
  x4[3] = 0.0F;
  idx4[3] = 0;
  ib = x->size[1];
  i1 = iwork->size[0];
  iwork->size[0] = ib;
  emxEnsureCapacity_int32_T(&c_st, iwork, i1, &rh_emlrtRTEI);
  for (i1 = 0; i1 < ib; i1++) {
    iwork->data[i1] = 0;
  }

  emxInit_real32_T(&c_st, &xwork, 1, &vh_emlrtRTEI, true);
  ib = x->size[1];
  i1 = xwork->size[0];
  xwork->size[0] = ib;
  emxEnsureCapacity_real32_T(&c_st, xwork, i1, &sh_emlrtRTEI);
  for (i1 = 0; i1 < ib; i1++) {
    xwork->data[i1] = 0.0F;
  }

  nNaNs = 0;
  ib = -1;
  d_st.site = &qd_emlrtRSI;
  if (1 > x->size[1]) {
    overflow = false;
  } else {
    overflow = (x->size[1] > 2147483646);
  }

  if (overflow) {
    e_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&e_st);
  }

  for (k = 0; k < b_n; k++) {
    if (muSingleScalarIsNaN(x->data[k])) {
      idx_tmp = (b_n - nNaNs) - 1;
      idx->data[idx_tmp] = k + 1;
      xwork->data[idx_tmp] = x->data[k];
      nNaNs++;
    } else {
      ib++;
      idx4[ib] = k + 1;
      x4[ib] = x->data[k];
      if (ib + 1 == 4) {
        quartetOffset = k - nNaNs;
        if (x4[0] <= x4[1]) {
          i1 = 1;
          i2 = 2;
        } else {
          i1 = 2;
          i2 = 1;
        }

        if (x4[2] <= x4[3]) {
          ib = 3;
          i4 = 4;
        } else {
          ib = 4;
          i4 = 3;
        }

        f = x4[i1 - 1];
        f1 = x4[ib - 1];
        if (f <= f1) {
          f = x4[i2 - 1];
          if (f <= f1) {
            perm[0] = (int8_T)i1;
            perm[1] = (int8_T)i2;
            perm[2] = (int8_T)ib;
            perm[3] = (int8_T)i4;
          } else if (f <= x4[i4 - 1]) {
            perm[0] = (int8_T)i1;
            perm[1] = (int8_T)ib;
            perm[2] = (int8_T)i2;
            perm[3] = (int8_T)i4;
          } else {
            perm[0] = (int8_T)i1;
            perm[1] = (int8_T)ib;
            perm[2] = (int8_T)i4;
            perm[3] = (int8_T)i2;
          }
        } else {
          f1 = x4[i4 - 1];
          if (f <= f1) {
            if (x4[i2 - 1] <= f1) {
              perm[0] = (int8_T)ib;
              perm[1] = (int8_T)i1;
              perm[2] = (int8_T)i2;
              perm[3] = (int8_T)i4;
            } else {
              perm[0] = (int8_T)ib;
              perm[1] = (int8_T)i1;
              perm[2] = (int8_T)i4;
              perm[3] = (int8_T)i2;
            }
          } else {
            perm[0] = (int8_T)ib;
            perm[1] = (int8_T)i4;
            perm[2] = (int8_T)i1;
            perm[3] = (int8_T)i2;
          }
        }

        idx_tmp = perm[0] - 1;
        idx->data[quartetOffset - 3] = idx4[idx_tmp];
        i2 = perm[1] - 1;
        idx->data[quartetOffset - 2] = idx4[i2];
        ib = perm[2] - 1;
        idx->data[quartetOffset - 1] = idx4[ib];
        i1 = perm[3] - 1;
        idx->data[quartetOffset] = idx4[i1];
        x->data[quartetOffset - 3] = x4[idx_tmp];
        x->data[quartetOffset - 2] = x4[i2];
        x->data[quartetOffset - 1] = x4[ib];
        x->data[quartetOffset] = x4[i1];
        ib = -1;
      }
    }
  }

  i4 = (b_n - nNaNs) - 1;
  if (ib + 1 > 0) {
    perm[1] = 0;
    perm[2] = 0;
    perm[3] = 0;
    if (ib + 1 == 1) {
      perm[0] = 1;
    } else if (ib + 1 == 2) {
      if (x4[0] <= x4[1]) {
        perm[0] = 1;
        perm[1] = 2;
      } else {
        perm[0] = 2;
        perm[1] = 1;
      }
    } else if (x4[0] <= x4[1]) {
      if (x4[1] <= x4[2]) {
        perm[0] = 1;
        perm[1] = 2;
        perm[2] = 3;
      } else if (x4[0] <= x4[2]) {
        perm[0] = 1;
        perm[1] = 3;
        perm[2] = 2;
      } else {
        perm[0] = 3;
        perm[1] = 1;
        perm[2] = 2;
      }
    } else if (x4[0] <= x4[2]) {
      perm[0] = 2;
      perm[1] = 1;
      perm[2] = 3;
    } else if (x4[1] <= x4[2]) {
      perm[0] = 2;
      perm[1] = 3;
      perm[2] = 1;
    } else {
      perm[0] = 3;
      perm[1] = 2;
      perm[2] = 1;
    }

    d_st.site = &rd_emlrtRSI;
    if (ib + 1 > 2147483646) {
      e_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&e_st);
    }

    for (k = 0; k <= ib; k++) {
      idx_tmp = perm[k] - 1;
      i2 = (i4 - ib) + k;
      idx->data[i2] = idx4[idx_tmp];
      x->data[i2] = x4[idx_tmp];
    }
  }

  ib = (nNaNs >> 1) + 1;
  d_st.site = &sd_emlrtRSI;
  for (k = 0; k <= ib - 2; k++) {
    i1 = (i4 + k) + 1;
    i2 = idx->data[i1];
    idx_tmp = (b_n - k) - 1;
    idx->data[i1] = idx->data[idx_tmp];
    idx->data[idx_tmp] = i2;
    x->data[i1] = xwork->data[idx_tmp];
    x->data[idx_tmp] = xwork->data[i1];
  }

  if ((nNaNs & 1) != 0) {
    i1 = i4 + ib;
    x->data[i1] = xwork->data[i1];
  }

  i2 = n - nNaNs;
  ib = 2;
  if (i2 > 1) {
    if (n >= 256) {
      i1 = i2 >> 8;
      if (i1 > 0) {
        c_st.site = &md_emlrtRSI;
        for (ib = 0; ib < i1; ib++) {
          c_st.site = &nd_emlrtRSI;
          merge_pow2_block(idx, x, ib << 8);
        }

        ib = i1 << 8;
        i1 = i2 - ib;
        if (i1 > 0) {
          c_st.site = &od_emlrtRSI;
          merge_block(&c_st, idx, x, ib, i1, 2, iwork, xwork);
        }

        ib = 8;
      }
    }

    c_st.site = &pd_emlrtRSI;
    merge_block(&c_st, idx, x, 0, i2, ib, iwork, xwork);
  }

  emxFree_real32_T(&xwork);
  emxFree_int32_T(&iwork);
  emxFree_int32_T(&idx);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (sort.c) */
