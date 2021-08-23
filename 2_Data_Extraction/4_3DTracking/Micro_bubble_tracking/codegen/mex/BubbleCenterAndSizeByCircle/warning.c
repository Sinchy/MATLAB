/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * warning.c
 *
 * Code generation for function 'warning'
 *
 */

/* Include files */
#include "warning.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtMCInfo b_emlrtMCI = { 14,  /* lineNo */
  25,                                  /* colNo */
  "warning",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\shared\\coder\\coder\\lib\\+coder\\+internal\\warning.m"/* pName */
};

static emlrtMCInfo c_emlrtMCI = { 14,  /* lineNo */
  9,                                   /* colNo */
  "warning",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\shared\\coder\\coder\\lib\\+coder\\+internal\\warning.m"/* pName */
};

static const char_T cv[13] = { 'I', 'M', 'F', 'I', 'N', 'D', 'C', 'I', 'R', 'C',
  'L', 'E', 'S' };

static emlrtRSInfo jl_emlrtRSI = { 14, /* lineNo */
  "warning",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\shared\\coder\\coder\\lib\\+coder\\+internal\\warning.m"/* pathName */
};

/* Function Declarations */
static void b_feval(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                    emlrtMCInfo *location);
static const mxArray *c_feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, const mxArray *d, emlrtMCInfo *location);
static const mxArray *d_feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location);
static const mxArray *feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, const mxArray *d, const mxArray *e, const mxArray *f, const
  mxArray *g, const mxArray *h, const mxArray *i, emlrtMCInfo *location);

/* Function Definitions */
static void b_feval(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                    emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  pArrays[0] = b;
  pArrays[1] = c;
  emlrtCallMATLABR2012b(sp, 0, NULL, 2, pArrays, "feval", true, location);
}

static const mxArray *c_feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, const mxArray *d, emlrtMCInfo *location)
{
  const mxArray *pArrays[3];
  const mxArray *m;
  pArrays[0] = b;
  pArrays[1] = c;
  pArrays[2] = d;
  return emlrtCallMATLABR2012b(sp, 1, &m, 3, pArrays, "feval", true, location);
}

static const mxArray *d_feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  const mxArray *m;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(sp, 1, &m, 2, pArrays, "feval", true, location);
}

static const mxArray *feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, const mxArray *d, const mxArray *e, const mxArray *f, const
  mxArray *g, const mxArray *h, const mxArray *i, emlrtMCInfo *location)
{
  const mxArray *pArrays[8];
  const mxArray *m;
  pArrays[0] = b;
  pArrays[1] = c;
  pArrays[2] = d;
  pArrays[3] = e;
  pArrays[4] = f;
  pArrays[5] = g;
  pArrays[6] = h;
  pArrays[7] = i;
  return emlrtCallMATLABR2012b(sp, 1, &m, 8, pArrays, "feval", true, location);
}

void b_warning(const emlrtStack *sp)
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  const mxArray *m1;
  static const int32_T iv1[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  const mxArray *m2;
  static const int32_T iv2[2] = { 1, 39 };

  static const char_T msgID[39] = { 'i', 'm', 'a', 'g', 'e', 's', ':', 'i', 'm',
    'f', 'i', 'n', 'd', 'c', 'i', 'r', 'c', 'l', 'e', 's', ':', 'w', 'a', 'r',
    'n', 'F', 'o', 'r', 'S', 'm', 'a', 'l', 'l', 'R', 'a', 'd', 'i', 'u', 's' };

  const mxArray *d_y;
  const mxArray *m3;
  static const int32_T iv3[2] = { 1, 13 };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m = emlrtCreateCharArray(2, &iv[0]);
  emlrtInitCharArrayR2013a(sp, 7, m, &u[0]);
  emlrtAssign(&y, m);
  b_y = NULL;
  m1 = emlrtCreateCharArray(2, &iv1[0]);
  emlrtInitCharArrayR2013a(sp, 7, m1, &b_u[0]);
  emlrtAssign(&b_y, m1);
  c_y = NULL;
  m2 = emlrtCreateCharArray(2, &iv2[0]);
  emlrtInitCharArrayR2013a(sp, 39, m2, &msgID[0]);
  emlrtAssign(&c_y, m2);
  d_y = NULL;
  m3 = emlrtCreateCharArray(2, &iv3[0]);
  emlrtInitCharArrayR2013a(sp, 13, m3, &cv[0]);
  emlrtAssign(&d_y, m3);
  st.site = &jl_emlrtRSI;
  b_feval(&st, y, c_feval(&st, b_y, c_y, d_y, &b_emlrtMCI), &c_emlrtMCI);
}

void c_warning(const emlrtStack *sp)
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  const mxArray *m1;
  static const int32_T iv1[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  const mxArray *m2;
  static const int32_T iv2[2] = { 1, 34 };

  static const char_T msgID[34] = { 'i', 'm', 'a', 'g', 'e', 's', ':', 'm', 'u',
    'l', 't', 'i', 't', 'h', 'r', 'e', 's', 'h', ':', 'd', 'e', 'g', 'e', 'n',
    'e', 'r', 'a', 't', 'e', 'I', 'n', 'p', 'u', 't' };

  const mxArray *d_y;
  const mxArray *m3;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m = emlrtCreateCharArray(2, &iv[0]);
  emlrtInitCharArrayR2013a(sp, 7, m, &u[0]);
  emlrtAssign(&y, m);
  b_y = NULL;
  m1 = emlrtCreateCharArray(2, &iv1[0]);
  emlrtInitCharArrayR2013a(sp, 7, m1, &b_u[0]);
  emlrtAssign(&b_y, m1);
  c_y = NULL;
  m2 = emlrtCreateCharArray(2, &iv2[0]);
  emlrtInitCharArrayR2013a(sp, 34, m2, &msgID[0]);
  emlrtAssign(&c_y, m2);
  d_y = NULL;
  m3 = emlrtCreateDoubleScalar(1.0);
  emlrtAssign(&d_y, m3);
  st.site = &jl_emlrtRSI;
  b_feval(&st, y, c_feval(&st, b_y, c_y, d_y, &b_emlrtMCI), &c_emlrtMCI);
}

void d_warning(const emlrtStack *sp)
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  const mxArray *m1;
  static const int32_T iv1[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  const mxArray *m2;
  static const int32_T iv2[2] = { 1, 25 };

  static const char_T msgID[25] = { 'i', 'm', 'a', 'g', 'e', 's', ':', 'i', 'm',
    'h', 'i', 's', 't', 'c', ':', 'o', 'u', 't', 'O', 'f', 'R', 'a', 'n', 'g',
    'e' };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m = emlrtCreateCharArray(2, &iv[0]);
  emlrtInitCharArrayR2013a(sp, 7, m, &u[0]);
  emlrtAssign(&y, m);
  b_y = NULL;
  m1 = emlrtCreateCharArray(2, &iv1[0]);
  emlrtInitCharArrayR2013a(sp, 7, m1, &b_u[0]);
  emlrtAssign(&b_y, m1);
  c_y = NULL;
  m2 = emlrtCreateCharArray(2, &iv2[0]);
  emlrtInitCharArrayR2013a(sp, 25, m2, &msgID[0]);
  emlrtAssign(&c_y, m2);
  st.site = &jl_emlrtRSI;
  b_feval(&st, y, d_feval(&st, b_y, c_y, &b_emlrtMCI), &c_emlrtMCI);
}

void e_warning(const emlrtStack *sp)
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  const mxArray *m1;
  static const int32_T iv1[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  const mxArray *m2;
  static const int32_T iv2[2] = { 1, 27 };

  static const char_T msgID[27] = { 'i', 'm', 'a', 'g', 'e', 's', ':', 'i', 'm',
    'h', 'i', 's', 't', 'c', ':', 'i', 'n', 'p', 'u', 't', 'H', 'a', 's', 'N',
    'a', 'N', 's' };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m = emlrtCreateCharArray(2, &iv[0]);
  emlrtInitCharArrayR2013a(sp, 7, m, &u[0]);
  emlrtAssign(&y, m);
  b_y = NULL;
  m1 = emlrtCreateCharArray(2, &iv1[0]);
  emlrtInitCharArrayR2013a(sp, 7, m1, &b_u[0]);
  emlrtAssign(&b_y, m1);
  c_y = NULL;
  m2 = emlrtCreateCharArray(2, &iv2[0]);
  emlrtInitCharArrayR2013a(sp, 27, m2, &msgID[0]);
  emlrtAssign(&c_y, m2);
  st.site = &jl_emlrtRSI;
  b_feval(&st, y, d_feval(&st, b_y, c_y, &b_emlrtMCI), &c_emlrtMCI);
}

void f_warning(const emlrtStack *sp)
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  const mxArray *m1;
  static const int32_T iv1[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  const mxArray *m2;
  static const int32_T iv2[2] = { 1, 32 };

  static const char_T msgID[32] = { 'i', 'm', 'a', 'g', 'e', 's', ':', 'm', 'u',
    'l', 't', 'i', 't', 'h', 'r', 'e', 's', 'h', ':', 'n', 'o', 'C', 'o', 'n',
    'v', 'e', 'r', 'g', 'e', 'n', 'c', 'e' };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m = emlrtCreateCharArray(2, &iv[0]);
  emlrtInitCharArrayR2013a(sp, 7, m, &u[0]);
  emlrtAssign(&y, m);
  b_y = NULL;
  m1 = emlrtCreateCharArray(2, &iv1[0]);
  emlrtInitCharArrayR2013a(sp, 7, m1, &b_u[0]);
  emlrtAssign(&b_y, m1);
  c_y = NULL;
  m2 = emlrtCreateCharArray(2, &iv2[0]);
  emlrtInitCharArrayR2013a(sp, 32, m2, &msgID[0]);
  emlrtAssign(&c_y, m2);
  st.site = &jl_emlrtRSI;
  b_feval(&st, y, d_feval(&st, b_y, c_y, &b_emlrtMCI), &c_emlrtMCI);
}

void warning(const emlrtStack *sp, const mxArray *varargin_6)
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  const mxArray *m1;
  static const int32_T iv1[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  const mxArray *m2;
  static const int32_T iv2[2] = { 1, 44 };

  static const char_T msgID[44] = { 'i', 'm', 'a', 'g', 'e', 's', ':', 'i', 'm',
    'f', 'i', 'n', 'd', 'c', 'i', 'r', 'c', 'l', 'e', 's', ':', 'w', 'a', 'r',
    'n', 'F', 'o', 'r', 'L', 'a', 'r', 'g', 'e', 'R', 'a', 'd', 'i', 'u', 's',
    'R', 'a', 'n', 'g', 'e' };

  const mxArray *d_y;
  const mxArray *m3;
  static const int32_T iv3[2] = { 1, 13 };

  const mxArray *e_y;
  const mxArray *m4;
  static const int32_T iv4[2] = { 1, 13 };

  static const char_T varargin_2[13] = { 'R', 'm', 'a', 'x', ' ', '<', ' ', '3',
    '*', 'R', 'm', 'i', 'n' };

  const mxArray *f_y;
  const mxArray *m5;
  static const int32_T iv5[2] = { 1, 19 };

  static const char_T varargin_3[19] = { '(', 'R', 'm', 'a', 'x', ' ', '-', ' ',
    'R', 'm', 'i', 'n', ')', ' ', '<', ' ', '1', '0', '0' };

  const mxArray *g_y;
  const mxArray *m6;
  static const int32_T iv6[2] = { 1, 8 };

  static const char_T varargin_4[8] = { '[', '2', '0', ' ', '1', '0', '0', ']' };

  const mxArray *h_y;
  const mxArray *m7;
  static const int32_T iv7[2] = { 1, 13 };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  y = NULL;
  m = emlrtCreateCharArray(2, &iv[0]);
  emlrtInitCharArrayR2013a(sp, 7, m, &u[0]);
  emlrtAssign(&y, m);
  b_y = NULL;
  m1 = emlrtCreateCharArray(2, &iv1[0]);
  emlrtInitCharArrayR2013a(sp, 7, m1, &b_u[0]);
  emlrtAssign(&b_y, m1);
  c_y = NULL;
  m2 = emlrtCreateCharArray(2, &iv2[0]);
  emlrtInitCharArrayR2013a(sp, 44, m2, &msgID[0]);
  emlrtAssign(&c_y, m2);
  d_y = NULL;
  m3 = emlrtCreateCharArray(2, &iv3[0]);
  emlrtInitCharArrayR2013a(sp, 13, m3, &cv[0]);
  emlrtAssign(&d_y, m3);
  e_y = NULL;
  m4 = emlrtCreateCharArray(2, &iv4[0]);
  emlrtInitCharArrayR2013a(sp, 13, m4, &varargin_2[0]);
  emlrtAssign(&e_y, m4);
  f_y = NULL;
  m5 = emlrtCreateCharArray(2, &iv5[0]);
  emlrtInitCharArrayR2013a(sp, 19, m5, &varargin_3[0]);
  emlrtAssign(&f_y, m5);
  g_y = NULL;
  m6 = emlrtCreateCharArray(2, &iv6[0]);
  emlrtInitCharArrayR2013a(sp, 8, m6, &varargin_4[0]);
  emlrtAssign(&g_y, m6);
  h_y = NULL;
  m7 = emlrtCreateCharArray(2, &iv7[0]);
  emlrtInitCharArrayR2013a(sp, 13, m7, &cv[0]);
  emlrtAssign(&h_y, m7);
  st.site = &jl_emlrtRSI;
  b_feval(&st, y, feval(&st, b_y, c_y, d_y, e_y, f_y, g_y, h_y, emlrtAlias
                        (varargin_6), &b_emlrtMCI), &c_emlrtMCI);
  emlrtDestroyArray(&varargin_6);
}

/* End of code generation (warning.c) */
