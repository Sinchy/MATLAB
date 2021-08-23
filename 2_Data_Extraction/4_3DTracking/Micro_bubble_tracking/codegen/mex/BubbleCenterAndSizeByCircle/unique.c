/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * unique.c
 *
 * Code generation for function 'unique'
 *
 */

/* Include files */
#include "unique.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "indexShapeCheck.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Variable Definitions */
static emlrtRSInfo gd_emlrtRSI = { 46, /* lineNo */
  "eps",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\eps.m"/* pathName */
};

static emlrtRSInfo af_emlrtRSI = { 158,/* lineNo */
  "unique_vector",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtRSInfo bf_emlrtRSI = { 160,/* lineNo */
  "unique_vector",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtRSInfo cf_emlrtRSI = { 195,/* lineNo */
  "unique_vector",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtRSInfo df_emlrtRSI = { 202,/* lineNo */
  "unique_vector",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtRSInfo ef_emlrtRSI = { 215,/* lineNo */
  "unique_vector",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtRSInfo ff_emlrtRSI = { 226,/* lineNo */
  "unique_vector",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtRSInfo gf_emlrtRSI = { 234,/* lineNo */
  "unique_vector",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtRSInfo hf_emlrtRSI = { 240,/* lineNo */
  "unique_vector",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pathName */
};

static emlrtRSInfo if_emlrtRSI = { 145,/* lineNo */
  "sortIdx",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

static emlrtRSInfo jf_emlrtRSI = { 57, /* lineNo */
  "mergesort",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\mergesort.m"/* pathName */
};

static emlrtRSInfo kf_emlrtRSI = { 113,/* lineNo */
  "mergesort",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\mergesort.m"/* pathName */
};

static emlrtRSInfo lf_emlrtRSI = { 40, /* lineNo */
  "safeEq",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\safeEq.m"/* pathName */
};

static emlrtRTEInfo r_emlrtRTEI = { 233,/* lineNo */
  1,                                   /* colNo */
  "unique_vector",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pName */
};

static emlrtRTEInfo pe_emlrtRTEI = { 158,/* lineNo */
  1,                                   /* colNo */
  "unique",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pName */
};

static emlrtRTEInfo qe_emlrtRTEI = { 145,/* lineNo */
  23,                                  /* colNo */
  "sortIdx",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pName */
};

static emlrtRTEInfo re_emlrtRTEI = { 128,/* lineNo */
  24,                                  /* colNo */
  "unique",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pName */
};

static emlrtRTEInfo se_emlrtRTEI = { 234,/* lineNo */
  1,                                   /* colNo */
  "unique",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\unique.m"/* pName */
};

static emlrtRTEInfo te_emlrtRTEI = { 52,/* lineNo */
  1,                                   /* colNo */
  "mergesort",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\mergesort.m"/* pName */
};

/* Function Definitions */
void unique_vector(const emlrtStack *sp, const emxArray_real32_T *a,
                   emxArray_real32_T *b)
{
  emxArray_int32_T *idx;
  int32_T na;
  int32_T n;
  int32_T i;
  int32_T b_i;
  emxArray_int32_T *iwork;
  boolean_T overflow;
  int32_T k;
  int32_T pEnd;
  boolean_T exitg1;
  int32_T i2;
  int32_T j;
  real32_T absx;
  int32_T q;
  int32_T p;
  real32_T x;
  int32_T qEnd;
  int32_T exitg2;
  int32_T kEnd;
  int32_T exponent;
  int32_T iv[2];
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
  emxInit_int32_T(sp, &idx, 1, &pe_emlrtRTEI, true);
  na = a->size[0];
  st.site = &af_emlrtRSI;
  n = a->size[0] + 1;
  i = idx->size[0];
  idx->size[0] = a->size[0];
  emxEnsureCapacity_int32_T(&st, idx, i, &pe_emlrtRTEI);
  b_i = a->size[0];
  for (i = 0; i < b_i; i++) {
    idx->data[i] = 0;
  }

  if (a->size[0] != 0) {
    emxInit_int32_T(&st, &iwork, 1, &te_emlrtRTEI, true);
    b_st.site = &if_emlrtRSI;
    i = iwork->size[0];
    iwork->size[0] = a->size[0];
    emxEnsureCapacity_int32_T(&b_st, iwork, i, &qe_emlrtRTEI);
    b_i = a->size[0] - 1;
    c_st.site = &jf_emlrtRSI;
    if (1 > a->size[0] - 1) {
      overflow = false;
    } else {
      overflow = (a->size[0] - 1 > 2147483645);
    }

    if (overflow) {
      d_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 1; k <= b_i; k += 2) {
      if ((a->data[k - 1] <= a->data[k]) || muSingleScalarIsNaN(a->data[k])) {
        idx->data[k - 1] = k;
        idx->data[k] = k + 1;
      } else {
        idx->data[k - 1] = k + 1;
        idx->data[k] = k;
      }
    }

    if ((a->size[0] & 1) != 0) {
      idx->data[a->size[0] - 1] = a->size[0];
    }

    b_i = 2;
    while (b_i < n - 1) {
      i2 = b_i << 1;
      j = 1;
      for (pEnd = b_i + 1; pEnd < n; pEnd = qEnd + b_i) {
        p = j;
        q = pEnd - 1;
        qEnd = j + i2;
        if (qEnd > n) {
          qEnd = n;
        }

        k = 0;
        kEnd = qEnd - j;
        while (k + 1 <= kEnd) {
          absx = a->data[idx->data[q] - 1];
          i = idx->data[p - 1];
          if ((a->data[i - 1] <= absx) || muSingleScalarIsNaN(absx)) {
            iwork->data[k] = i;
            p++;
            if (p == pEnd) {
              while (q + 1 < qEnd) {
                k++;
                iwork->data[k] = idx->data[q];
                q++;
              }
            }
          } else {
            iwork->data[k] = idx->data[q];
            q++;
            if (q + 1 == qEnd) {
              while (p < pEnd) {
                k++;
                iwork->data[k] = idx->data[p - 1];
                p++;
              }
            }
          }

          k++;
        }

        c_st.site = &kf_emlrtRSI;
        for (k = 0; k < kEnd; k++) {
          idx->data[(j + k) - 1] = iwork->data[k];
        }

        j = qEnd;
      }

      b_i = i2;
    }

    emxFree_int32_T(&iwork);
  }

  i = b->size[0];
  b->size[0] = a->size[0];
  emxEnsureCapacity_real32_T(sp, b, i, &re_emlrtRTEI);
  st.site = &bf_emlrtRSI;
  if (1 > a->size[0]) {
    overflow = false;
  } else {
    overflow = (a->size[0] > 2147483646);
  }

  if (overflow) {
    b_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (k = 0; k < na; k++) {
    b->data[k] = a->data[idx->data[k] - 1];
  }

  emxFree_int32_T(&idx);
  k = a->size[0];
  while ((k >= 1) && muSingleScalarIsNaN(b->data[k - 1])) {
    k--;
  }

  pEnd = a->size[0] - k;
  exitg1 = false;
  while ((!exitg1) && (k >= 1)) {
    absx = b->data[k - 1];
    if (muSingleScalarIsInf(absx) && (absx > 0.0F)) {
      k--;
    } else {
      exitg1 = true;
    }
  }

  b_i = (a->size[0] - k) - pEnd;
  q = 0;
  p = 0;
  while (p + 1 <= k) {
    x = b->data[p];
    i2 = p;
    do {
      exitg2 = 0;
      p++;
      if (p + 1 > k) {
        exitg2 = 1;
      } else {
        st.site = &cf_emlrtRSI;
        b_st.site = &lf_emlrtRSI;
        c_st.site = &gd_emlrtRSI;
        absx = muSingleScalarAbs(x / 2.0F);
        if ((!muSingleScalarIsInf(absx)) && (!muSingleScalarIsNaN(absx))) {
          if (absx <= 1.17549435E-38F) {
            absx = 1.4013E-45F;
          } else {
            frexp(absx, &exponent);
            absx = (real32_T)ldexp(1.0, exponent - 24);
          }
        } else {
          absx = rtNaNF;
        }

        if ((muSingleScalarAbs(x - b->data[p]) < absx) || (muSingleScalarIsInf
             (b->data[p]) && muSingleScalarIsInf(x) && ((b->data[p] > 0.0F) ==
              (x > 0.0F)))) {
          overflow = true;
        } else {
          overflow = false;
        }

        if (!overflow) {
          exitg2 = 1;
        }
      }
    } while (exitg2 == 0);

    q++;
    b->data[q - 1] = x;
    st.site = &df_emlrtRSI;
    overflow = ((i2 + 1 <= p) && (p > 2147483646));
    if (overflow) {
      b_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }
  }

  if (b_i > 0) {
    q++;
    b->data[q - 1] = b->data[k];
    st.site = &ef_emlrtRSI;
    if (b_i > 2147483646) {
      b_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }
  }

  p = k + b_i;
  st.site = &ff_emlrtRSI;
  overflow = ((1 <= pEnd) && (pEnd > 2147483646));
  if (overflow) {
    b_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (j = 0; j < pEnd; j++) {
    q++;
    b->data[q - 1] = b->data[p + j];
  }

  if (q > a->size[0]) {
    emlrtErrorWithMessageIdR2018a(sp, &r_emlrtRTEI,
      "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
  }

  if (1 > q) {
    i = 0;
  } else {
    i = q;
  }

  iv[0] = 1;
  iv[1] = i;
  st.site = &gf_emlrtRSI;
  indexShapeCheck(&st, b->size[0], iv);
  b_i = b->size[0];
  b->size[0] = i;
  emxEnsureCapacity_real32_T(sp, b, b_i, &se_emlrtRTEI);
  st.site = &hf_emlrtRSI;
  overflow = ((1 <= q) && (q > 2147483646));
  if (overflow) {
    b_st.site = &fb_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (unique.c) */
