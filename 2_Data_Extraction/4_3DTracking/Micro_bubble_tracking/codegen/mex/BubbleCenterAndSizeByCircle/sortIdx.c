/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sortIdx.c
 *
 * Code generation for function 'sortIdx'
 *
 */

/* Include files */
#include "sortIdx.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo wd_emlrtRSI = { 499,/* lineNo */
  "merge_block",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo yd_emlrtRSI = { 507,/* lineNo */
  "merge_block",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo ae_emlrtRSI = { 514,/* lineNo */
  "merge_block",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo be_emlrtRSI = { 561,/* lineNo */
  "merge",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo ce_emlrtRSI = { 530,/* lineNo */
  "merge",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

/* Function Declarations */
static void b_merge(const emlrtStack *sp, emxArray_int32_T *idx, emxArray_real_T
                    *x, int32_T offset, int32_T np, int32_T nq, emxArray_int32_T
                    *iwork, emxArray_real_T *xwork);
static void merge(const emlrtStack *sp, emxArray_int32_T *idx, emxArray_real32_T
                  *x, int32_T offset, int32_T np, int32_T nq, emxArray_int32_T
                  *iwork, emxArray_real32_T *xwork);

/* Function Definitions */
static void b_merge(const emlrtStack *sp, emxArray_int32_T *idx, emxArray_real_T
                    *x, int32_T offset, int32_T np, int32_T nq, emxArray_int32_T
                    *iwork, emxArray_real_T *xwork)
{
  int32_T n_tmp;
  boolean_T overflow;
  int32_T j;
  int32_T p;
  int32_T iout;
  int32_T q;
  int32_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if (nq != 0) {
    n_tmp = np + nq;
    st.site = &ce_emlrtRSI;
    overflow = ((1 <= n_tmp) && (n_tmp > 2147483646));
    if (overflow) {
      b_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (j = 0; j < n_tmp; j++) {
      iout = offset + j;
      iwork->data[j] = idx->data[iout];
      xwork->data[j] = x->data[iout];
    }

    p = 0;
    q = np;
    iout = offset - 1;
    do {
      exitg1 = 0;
      iout++;
      if (xwork->data[p] >= xwork->data[q]) {
        idx->data[iout] = iwork->data[p];
        x->data[iout] = xwork->data[p];
        if (p + 1 < np) {
          p++;
        } else {
          exitg1 = 1;
        }
      } else {
        idx->data[iout] = iwork->data[q];
        x->data[iout] = xwork->data[q];
        if (q + 1 < n_tmp) {
          q++;
        } else {
          q = iout - p;
          st.site = &be_emlrtRSI;
          overflow = ((p + 1 <= np) && (np > 2147483646));
          if (overflow) {
            b_st.site = &fb_emlrtRSI;
            check_forloop_overflow_error(&b_st);
          }

          for (j = p + 1; j <= np; j++) {
            iout = q + j;
            idx->data[iout] = iwork->data[j - 1];
            x->data[iout] = xwork->data[j - 1];
          }

          exitg1 = 1;
        }
      }
    } while (exitg1 == 0);
  }
}

static void merge(const emlrtStack *sp, emxArray_int32_T *idx, emxArray_real32_T
                  *x, int32_T offset, int32_T np, int32_T nq, emxArray_int32_T
                  *iwork, emxArray_real32_T *xwork)
{
  int32_T n_tmp;
  boolean_T overflow;
  int32_T j;
  int32_T p;
  int32_T iout;
  int32_T q;
  int32_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if (nq != 0) {
    n_tmp = np + nq;
    st.site = &ce_emlrtRSI;
    overflow = ((1 <= n_tmp) && (n_tmp > 2147483646));
    if (overflow) {
      b_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (j = 0; j < n_tmp; j++) {
      iout = offset + j;
      iwork->data[j] = idx->data[iout];
      xwork->data[j] = x->data[iout];
    }

    p = 0;
    q = np;
    iout = offset - 1;
    do {
      exitg1 = 0;
      iout++;
      if (xwork->data[p] <= xwork->data[q]) {
        idx->data[iout] = iwork->data[p];
        x->data[iout] = xwork->data[p];
        if (p + 1 < np) {
          p++;
        } else {
          exitg1 = 1;
        }
      } else {
        idx->data[iout] = iwork->data[q];
        x->data[iout] = xwork->data[q];
        if (q + 1 < n_tmp) {
          q++;
        } else {
          q = iout - p;
          st.site = &be_emlrtRSI;
          overflow = ((p + 1 <= np) && (np > 2147483646));
          if (overflow) {
            b_st.site = &fb_emlrtRSI;
            check_forloop_overflow_error(&b_st);
          }

          for (j = p + 1; j <= np; j++) {
            iout = q + j;
            idx->data[iout] = iwork->data[j - 1];
            x->data[iout] = xwork->data[j - 1];
          }

          exitg1 = 1;
        }
      }
    } while (exitg1 == 0);
  }
}

void b_merge_block(const emlrtStack *sp, emxArray_int32_T *idx, emxArray_real_T *
                   x, int32_T offset, int32_T n, int32_T preSortLevel,
                   emxArray_int32_T *iwork, emxArray_real_T *xwork)
{
  int32_T nPairs;
  int32_T bLen;
  int32_T tailOffset;
  int32_T nTail;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  nPairs = n >> preSortLevel;
  bLen = 1 << preSortLevel;
  while (nPairs > 1) {
    if ((nPairs & 1) != 0) {
      nPairs--;
      tailOffset = bLen * nPairs;
      nTail = n - tailOffset;
      if (nTail > bLen) {
        st.site = &wd_emlrtRSI;
        b_merge(&st, idx, x, offset + tailOffset, bLen, nTail - bLen, iwork,
                xwork);
      }
    }

    tailOffset = bLen << 1;
    nPairs >>= 1;
    for (nTail = 0; nTail < nPairs; nTail++) {
      st.site = &yd_emlrtRSI;
      b_merge(&st, idx, x, offset + nTail * tailOffset, bLen, bLen, iwork, xwork);
    }

    bLen = tailOffset;
  }

  if (n > bLen) {
    st.site = &ae_emlrtRSI;
    b_merge(&st, idx, x, offset, bLen, n - bLen, iwork, xwork);
  }
}

void b_merge_pow2_block(emxArray_int32_T *idx, emxArray_real_T *x, int32_T
  offset)
{
  int32_T b;
  int32_T bLen;
  int32_T bLen2;
  int32_T nPairs;
  int32_T k;
  int32_T blockOffset;
  int32_T j;
  int32_T p;
  int32_T iout;
  int32_T q;
  int32_T iwork[256];
  real_T xwork[256];
  int32_T exitg1;
  for (b = 0; b < 6; b++) {
    bLen = 1 << (b + 2);
    bLen2 = bLen << 1;
    nPairs = 256 >> (b + 3);
    for (k = 0; k < nPairs; k++) {
      blockOffset = offset + k * bLen2;
      for (j = 0; j < bLen2; j++) {
        iout = blockOffset + j;
        iwork[j] = idx->data[iout];
        xwork[j] = x->data[iout];
      }

      p = 0;
      q = bLen;
      iout = blockOffset - 1;
      do {
        exitg1 = 0;
        iout++;
        if (xwork[p] >= xwork[q]) {
          idx->data[iout] = iwork[p];
          x->data[iout] = xwork[p];
          if (p + 1 < bLen) {
            p++;
          } else {
            exitg1 = 1;
          }
        } else {
          idx->data[iout] = iwork[q];
          x->data[iout] = xwork[q];
          if (q + 1 < bLen2) {
            q++;
          } else {
            iout -= p;
            for (j = p + 1; j <= bLen; j++) {
              q = iout + j;
              idx->data[q] = iwork[j - 1];
              x->data[q] = xwork[j - 1];
            }

            exitg1 = 1;
          }
        }
      } while (exitg1 == 0);
    }
  }
}

void merge_block(const emlrtStack *sp, emxArray_int32_T *idx, emxArray_real32_T *
                 x, int32_T offset, int32_T n, int32_T preSortLevel,
                 emxArray_int32_T *iwork, emxArray_real32_T *xwork)
{
  int32_T nPairs;
  int32_T bLen;
  int32_T tailOffset;
  int32_T nTail;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  nPairs = n >> preSortLevel;
  bLen = 1 << preSortLevel;
  while (nPairs > 1) {
    if ((nPairs & 1) != 0) {
      nPairs--;
      tailOffset = bLen * nPairs;
      nTail = n - tailOffset;
      if (nTail > bLen) {
        st.site = &wd_emlrtRSI;
        merge(&st, idx, x, offset + tailOffset, bLen, nTail - bLen, iwork, xwork);
      }
    }

    tailOffset = bLen << 1;
    nPairs >>= 1;
    for (nTail = 0; nTail < nPairs; nTail++) {
      st.site = &yd_emlrtRSI;
      merge(&st, idx, x, offset + nTail * tailOffset, bLen, bLen, iwork, xwork);
    }

    bLen = tailOffset;
  }

  if (n > bLen) {
    st.site = &ae_emlrtRSI;
    merge(&st, idx, x, offset, bLen, n - bLen, iwork, xwork);
  }
}

void merge_pow2_block(emxArray_int32_T *idx, emxArray_real32_T *x, int32_T
                      offset)
{
  int32_T b;
  int32_T bLen;
  int32_T bLen2;
  int32_T nPairs;
  int32_T k;
  int32_T blockOffset;
  int32_T j;
  int32_T p;
  int32_T iout;
  int32_T q;
  int32_T iwork[256];
  real32_T xwork[256];
  int32_T exitg1;
  for (b = 0; b < 6; b++) {
    bLen = 1 << (b + 2);
    bLen2 = bLen << 1;
    nPairs = 256 >> (b + 3);
    for (k = 0; k < nPairs; k++) {
      blockOffset = offset + k * bLen2;
      for (j = 0; j < bLen2; j++) {
        iout = blockOffset + j;
        iwork[j] = idx->data[iout];
        xwork[j] = x->data[iout];
      }

      p = 0;
      q = bLen;
      iout = blockOffset - 1;
      do {
        exitg1 = 0;
        iout++;
        if (xwork[p] <= xwork[q]) {
          idx->data[iout] = iwork[p];
          x->data[iout] = xwork[p];
          if (p + 1 < bLen) {
            p++;
          } else {
            exitg1 = 1;
          }
        } else {
          idx->data[iout] = iwork[q];
          x->data[iout] = xwork[q];
          if (q + 1 < bLen2) {
            q++;
          } else {
            iout -= p;
            for (j = p + 1; j <= bLen; j++) {
              q = iout + j;
              idx->data[q] = iwork[j - 1];
              x->data[q] = xwork[j - 1];
            }

            exitg1 = 1;
          }
        }
      } while (exitg1 == 0);
    }
  }
}

/* End of code generation (sortIdx.c) */
