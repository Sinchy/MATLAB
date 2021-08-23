/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * find.c
 *
 * Code generation for function 'find'
 *
 */

/* Include files */
#include "find.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "indexShapeCheck.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo t_emlrtRTEI = { 130,/* lineNo */
  23,                                  /* colNo */
  "eml_find",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo u_emlrtRTEI = { 236,/* lineNo */
  1,                                   /* colNo */
  "find_first_nonempty_triples",       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo ue_emlrtRTEI = { 147,/* lineNo */
  9,                                   /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo ve_emlrtRTEI = { 250,/* lineNo */
  5,                                   /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo we_emlrtRTEI = { 251,/* lineNo */
  5,                                   /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo xe_emlrtRTEI = { 47,/* lineNo */
  20,                                  /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

/* Function Definitions */
void eml_find(const emlrtStack *sp, const emxArray_boolean_T *x,
              emxArray_int32_T *i, emxArray_int32_T *j)
{
  int32_T nx;
  emxArray_boolean_T *v;
  int32_T idx;
  int32_T jj;
  int32_T ii;
  boolean_T exitg1;
  boolean_T guard1 = false;
  int32_T iv[2];
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  nx = x->size[0] * x->size[1];
  if ((x->size[0] == 1) && (x->size[1] > 1)) {
    emlrtErrorWithMessageIdR2018a(sp, &t_emlrtRTEI,
      "Coder:toolbox:find_incompatibleShape",
      "Coder:toolbox:find_incompatibleShape", 0);
  }

  if (nx == 0) {
    i->size[0] = 0;
    j->size[0] = 0;
  } else {
    emxInit_boolean_T(sp, &v, 1, &xe_emlrtRTEI, true);
    st.site = &tf_emlrtRSI;
    idx = 0;
    jj = i->size[0];
    i->size[0] = nx;
    emxEnsureCapacity_int32_T(&st, i, jj, &ue_emlrtRTEI);
    jj = j->size[0];
    j->size[0] = nx;
    emxEnsureCapacity_int32_T(&st, j, jj, &ue_emlrtRTEI);
    jj = v->size[0];
    v->size[0] = nx;
    emxEnsureCapacity_boolean_T(&st, v, jj, &ue_emlrtRTEI);
    ii = 1;
    jj = 1;
    exitg1 = false;
    while ((!exitg1) && (jj <= x->size[1])) {
      guard1 = false;
      if (x->data[(ii + x->size[0] * (jj - 1)) - 1]) {
        idx++;
        i->data[idx - 1] = ii;
        j->data[idx - 1] = jj;
        v->data[idx - 1] = x->data[(ii + x->size[0] * (jj - 1)) - 1];
        if (idx >= nx) {
          exitg1 = true;
        } else {
          guard1 = true;
        }
      } else {
        guard1 = true;
      }

      if (guard1) {
        ii++;
        if (ii > x->size[0]) {
          ii = 1;
          jj++;
        }
      }
    }

    if (idx > nx) {
      emlrtErrorWithMessageIdR2018a(&st, &u_emlrtRTEI,
        "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
    }

    if (nx == 1) {
      if (idx == 0) {
        i->size[0] = 0;
        j->size[0] = 0;
      }
    } else {
      if (1 > idx) {
        jj = 0;
      } else {
        jj = idx;
      }

      iv[0] = 1;
      iv[1] = jj;
      b_st.site = &uf_emlrtRSI;
      indexShapeCheck(&b_st, i->size[0], iv);
      ii = i->size[0];
      i->size[0] = jj;
      emxEnsureCapacity_int32_T(&st, i, ii, &ve_emlrtRTEI);
      if (1 > idx) {
        jj = 0;
      } else {
        jj = idx;
      }

      iv[0] = 1;
      iv[1] = jj;
      b_st.site = &vf_emlrtRSI;
      indexShapeCheck(&b_st, j->size[0], iv);
      ii = j->size[0];
      j->size[0] = jj;
      emxEnsureCapacity_int32_T(&st, j, ii, &we_emlrtRTEI);
      if (1 > idx) {
        idx = 0;
      }

      iv[0] = 1;
      iv[1] = idx;
      b_st.site = &wf_emlrtRSI;
      indexShapeCheck(&b_st, v->size[0], iv);
    }

    emxFree_boolean_T(&v);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (find.c) */
