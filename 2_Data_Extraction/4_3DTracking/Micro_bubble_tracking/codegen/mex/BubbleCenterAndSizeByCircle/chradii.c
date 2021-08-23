/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * chradii.c
 *
 * Code generation for function 'chradii'
 *
 */

/* Include files */
#include "chradii.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "all.h"
#include "colon.h"
#include "eml_int_forloop_overflow_check.h"
#include "hypot.h"
#include "meshgrid.h"
#include "mwmathutil.h"
#include "relop.h"
#include "round.h"
#include "rt_nonfinite.h"
#include "validateattributes.h"

/* Variable Definitions */
static emlrtRSInfo ak_emlrtRSI = { 6,  /* lineNo */
  "chradii",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo bk_emlrtRSI = { 19, /* lineNo */
  "chradii",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo ck_emlrtRSI = { 21, /* lineNo */
  "chradii",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo dk_emlrtRSI = { 69, /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo ek_emlrtRSI = { 70, /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo fk_emlrtRSI = { 71, /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo gk_emlrtRSI = { 72, /* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo hk_emlrtRSI = { 82, /* lineNo */
  "checkCenters",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo ik_emlrtRSI = { 90, /* lineNo */
  "checkGradientImage",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo jk_emlrtRSI = { 98, /* lineNo */
  "checkRadiusRange",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo kk_emlrtRSI = { 109,/* lineNo */
  "validateCenters",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo lk_emlrtRSI = { 110,/* lineNo */
  "validateCenters",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo mk_emlrtRSI = { 32, /* lineNo */
  "radial_histogram",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo nk_emlrtRSI = { 35, /* lineNo */
  "radial_histogram",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo ok_emlrtRSI = { 36, /* lineNo */
  "radial_histogram",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo pk_emlrtRSI = { 45, /* lineNo */
  "radial_histogram",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo qk_emlrtRSI = { 48, /* lineNo */
  "radial_histogram",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pathName */
};

static emlrtRSInfo tk_emlrtRSI = { 16, /* lineNo */
  "max",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\max.m"/* pathName */
};

static emlrtRSInfo uk_emlrtRSI = { 38, /* lineNo */
  "minOrMax",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax.m"/* pathName */
};

static emlrtRSInfo vk_emlrtRSI = { 77, /* lineNo */
  "maximum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax.m"/* pathName */
};

static emlrtRSInfo wk_emlrtRSI = { 165,/* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo xk_emlrtRSI = { 314,/* lineNo */
  "unaryMinOrMaxDispatch",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo yk_emlrtRSI = { 362,/* lineNo */
  "minOrMax1D",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo al_emlrtRSI = { 361,/* lineNo */
  "minOrMax1D",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo bl_emlrtRSI = { 233,/* lineNo */
  "maxFloatOmitNaNRelop",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtBCInfo gf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  22,                                  /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  22,                                  /* lineNo */
  22,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo if_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  52,                                  /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  122,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "accumarraylocal",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo h_emlrtDCI = { 122, /* lineNo */
  5,                                   /* colNo */
  "accumarraylocal",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo kf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  122,                                 /* lineNo */
  20,                                  /* colNo */
  "",                                  /* aName */
  "accumarraylocal",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo i_emlrtDCI = { 122, /* lineNo */
  20,                                  /* colNo */
  "accumarraylocal",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo j_emlrtDCI = { 48,  /* lineNo */
  1,                                   /* colNo */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo k_emlrtDCI = { 48,  /* lineNo */
  1,                                   /* colNo */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo lf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  44,                                  /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo mf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  43,                                  /* lineNo */
  15,                                  /* colNo */
  "",                                  /* aName */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  20,                                  /* lineNo */
  34,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo of_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  20,                                  /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  14,                                  /* lineNo */
  30,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  14,                                  /* lineNo */
  32,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  15,                                  /* lineNo */
  30,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  15,                                  /* lineNo */
  32,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo tf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  16,                                  /* lineNo */
  29,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo uf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  16,                                  /* lineNo */
  31,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  17,                                  /* lineNo */
  31,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  17,                                  /* lineNo */
  33,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  19,                                  /* lineNo */
  46,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  19,                                  /* lineNo */
  50,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ag_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  19,                                  /* lineNo */
  58,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  19,                                  /* lineNo */
  63,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  20,                                  /* lineNo */
  23,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo dg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  20,                                  /* lineNo */
  44,                                  /* colNo */
  "",                                  /* aName */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo e_emlrtECI = { -1,  /* nDims */
  42,                                  /* lineNo */
  8,                                   /* colNo */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtBCInfo eg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  48,                                  /* lineNo */
  30,                                  /* colNo */
  "",                                  /* aName */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  48,                                  /* lineNo */
  62,                                  /* colNo */
  "",                                  /* aName */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo gg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  52,                                  /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  52,                                  /* lineNo */
  32,                                  /* colNo */
  "",                                  /* aName */
  "radial_histogram",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ig_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  101,                                 /* lineNo */
  55,                                  /* colNo */
  "",                                  /* aName */
  "checkRadiusRange",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo ib_emlrtRTEI = { 101,/* lineNo */
  1,                                   /* colNo */
  "checkRadiusRange",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtBCInfo jg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  109,                                 /* lineNo */
  40,                                  /* colNo */
  "",                                  /* aName */
  "validateCenters",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  110,                                 /* lineNo */
  19,                                  /* colNo */
  "",                                  /* aName */
  "validateCenters",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo jb_emlrtRTEI = { 109,/* lineNo */
  1,                                   /* colNo */
  "validateCenters",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtBCInfo lg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  122,                                 /* lineNo */
  35,                                  /* colNo */
  "",                                  /* aName */
  "accumarraylocal",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo tg_emlrtRTEI = { 109,/* lineNo */
  30,                                  /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo ug_emlrtRTEI = { 110,/* lineNo */
  9,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo vg_emlrtRTEI = { 8,/* lineNo */
  1,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo wg_emlrtRTEI = { 33,/* lineNo */
  6,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo xg_emlrtRTEI = { 34,/* lineNo */
  6,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo yg_emlrtRTEI = { 37,/* lineNo */
  1,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo ah_emlrtRTEI = { 19,/* lineNo */
  34,                                  /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo bh_emlrtRTEI = { 39,/* lineNo */
  1,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo ch_emlrtRTEI = { 42,/* lineNo */
  9,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo dh_emlrtRTEI = { 42,/* lineNo */
  21,                                  /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo eh_emlrtRTEI = { 19,/* lineNo */
  5,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo fh_emlrtRTEI = { 45,/* lineNo */
  1,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo gh_emlrtRTEI = { 48,/* lineNo */
  1,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo hh_emlrtRTEI = { 1,/* lineNo */
  24,                                  /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo ih_emlrtRTEI = { 35,/* lineNo */
  1,                                   /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo jh_emlrtRTEI = { 26,/* lineNo */
  39,                                  /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo kh_emlrtRTEI = { 32,/* lineNo */
  20,                                  /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

static emlrtRTEInfo lh_emlrtRTEI = { 32,/* lineNo */
  25,                                  /* colNo */
  "chradii",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chradii.m"/* pName */
};

/* Function Definitions */
void chradii(const emlrtStack *sp, const emxArray_real_T *varargin_1, const
             emxArray_real32_T *varargin_2, const real_T varargin_3_data[],
             const int32_T varargin_3_size[2], emxArray_real_T *r_estimated)
{
  emxArray_boolean_T *b_varargin_1;
  int32_T loop_ub;
  int32_T i;
  boolean_T guard1 = false;
  emxArray_real_T *y;
  real_T varargin_3;
  emxArray_creal_T *h;
  real_T b_varargin_3;
  emxArray_real_T *bins;
  emxArray_real_T *r;
  emxArray_real_T *yy;
  emxArray_real_T *b_r;
  emxArray_real32_T *gradientImg;
  emxArray_boolean_T *c_r;
  emxArray_real_T *b_y;
  emxArray_real_T *d_r;
  emxArray_real_T *b_yy;
  emxArray_real32_T *b_varargin_2;
  int32_T k;
  int32_T i1;
  real_T left;
  real_T right;
  real_T top;
  real_T bottom;
  int32_T i2;
  int32_T trueCount;
  int32_T b_loop_ub;
  int32_T n;
  int32_T b_trueCount;
  int32_T idx;
  boolean_T exitg1;
  boolean_T overflow;
  creal_T ex;
  creal_T h_tmp;
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
  st.site = &ak_emlrtRSI;
  b_st.site = &dk_emlrtRSI;
  c_st.site = &hk_emlrtRSI;
  d_validateattributes(&c_st, varargin_1);
  b_st.site = &ek_emlrtRSI;
  c_st.site = &ik_emlrtRSI;
  d_st.site = &n_emlrtRSI;
  if ((varargin_2->size[0] == 0) || (varargin_2->size[1] == 0)) {
    emlrtErrorWithMessageIdR2018a(&d_st, &c_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonempty",
      "MATLAB:chradii:expectedNonempty", 3, 4, 18, "input number 2, G,");
  }

  b_st.site = &fk_emlrtRSI;
  c_st.site = &jk_emlrtRSI;
  e_validateattributes(&c_st, varargin_3_data, varargin_3_size);
  if (2 > varargin_3_size[1]) {
    emlrtDynamicBoundsCheckR2012b(2, 1, varargin_3_size[1], &ig_emlrtBCI, &b_st);
  }

  if (varargin_3_data[0] >= varargin_3_data[1]) {
    emlrtErrorWithMessageIdR2018a(&b_st, &ib_emlrtRTEI,
      "images:imfindcircles:invalidRadiusRange",
      "images:imfindcircles:invalidRadiusRange", 0);
  }

  b_st.site = &gk_emlrtRSI;
  if (1 > varargin_1->size[1]) {
    emlrtDynamicBoundsCheckR2012b(1, 1, varargin_1->size[1], &jg_emlrtBCI, &b_st);
  }

  emxInit_boolean_T(&b_st, &b_varargin_1, 1, &tg_emlrtRTEI, true);
  loop_ub = varargin_1->size[0];
  i = b_varargin_1->size[0];
  b_varargin_1->size[0] = varargin_1->size[0];
  emxEnsureCapacity_boolean_T(&b_st, b_varargin_1, i, &tg_emlrtRTEI);
  for (i = 0; i < loop_ub; i++) {
    b_varargin_1->data[i] = (varargin_1->data[i] <= varargin_2->size[1]);
  }

  guard1 = false;
  c_st.site = &kk_emlrtRSI;
  if (all(&c_st, b_varargin_1)) {
    if (2 > varargin_1->size[1]) {
      emlrtDynamicBoundsCheckR2012b(2, 1, varargin_1->size[1], &kg_emlrtBCI,
        &b_st);
    }

    loop_ub = varargin_1->size[0];
    i = b_varargin_1->size[0];
    b_varargin_1->size[0] = varargin_1->size[0];
    emxEnsureCapacity_boolean_T(&b_st, b_varargin_1, i, &ug_emlrtRTEI);
    for (i = 0; i < loop_ub; i++) {
      b_varargin_1->data[i] = (varargin_1->data[i + varargin_1->size[0]] <=
        varargin_2->size[0]);
    }

    c_st.site = &lk_emlrtRSI;
    if (!all(&c_st, b_varargin_1)) {
      guard1 = true;
    }
  } else {
    guard1 = true;
  }

  if (guard1) {
    emlrtErrorWithMessageIdR2018a(&b_st, &jb_emlrtRTEI,
      "images:imfindcircles:outOfBoundCenters",
      "images:imfindcircles:outOfBoundCenters", 0);
  }

  i = r_estimated->size[0];
  r_estimated->size[0] = varargin_1->size[0];
  emxEnsureCapacity_real_T(sp, r_estimated, i, &vg_emlrtRTEI);
  loop_ub = varargin_1->size[0];
  for (i = 0; i < loop_ub; i++) {
    r_estimated->data[i] = 0.0;
  }

  i = varargin_1->size[0];
  emxInit_real_T(sp, &y, 2, &kh_emlrtRTEI, true);
  if (0 <= varargin_1->size[0] - 1) {
    varargin_3 = varargin_3_data[0];
    b_varargin_3 = varargin_3_data[1];
  }

  emxInit_creal_T(sp, &h, 1, &hh_emlrtRTEI, true);
  emxInit_real_T(sp, &bins, 1, &hh_emlrtRTEI, true);
  emxInit_real_T(sp, &r, 2, &ih_emlrtRTEI, true);
  emxInit_real_T(sp, &yy, 2, &hh_emlrtRTEI, true);
  emxInit_real_T(sp, &b_r, 1, &ih_emlrtRTEI, true);
  emxInit_real32_T(sp, &gradientImg, 1, &jh_emlrtRTEI, true);
  emxInit_boolean_T(sp, &c_r, 1, &hh_emlrtRTEI, true);
  emxInit_real_T(sp, &b_y, 2, &lh_emlrtRTEI, true);
  emxInit_real_T(sp, &d_r, 2, &wg_emlrtRTEI, true);
  emxInit_real_T(sp, &b_yy, 2, &xg_emlrtRTEI, true);
  emxInit_real32_T(sp, &b_varargin_2, 2, &ah_emlrtRTEI, true);
  for (k = 0; k < i; k++) {
    if (1 > varargin_1->size[1]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, varargin_1->size[1], &qf_emlrtBCI, sp);
    }

    i1 = k + 1;
    if ((i1 < 1) || (i1 > varargin_1->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, varargin_1->size[0], &pf_emlrtBCI, sp);
    }

    left = muDoubleScalarMax(muDoubleScalarFloor(varargin_1->data[k] -
      varargin_3_data[1]), 1.0);
    if (1 > varargin_1->size[1]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, varargin_1->size[1], &sf_emlrtBCI, sp);
    }

    i1 = k + 1;
    if ((i1 < 1) || (i1 > varargin_1->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, varargin_1->size[0], &rf_emlrtBCI, sp);
    }

    right = muDoubleScalarMin(muDoubleScalarCeil(varargin_1->data[k] +
      varargin_3_data[1]), varargin_2->size[1]);
    if (2 > varargin_1->size[1]) {
      emlrtDynamicBoundsCheckR2012b(2, 1, varargin_1->size[1], &uf_emlrtBCI, sp);
    }

    i1 = k + 1;
    if ((i1 < 1) || (i1 > varargin_1->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, varargin_1->size[0], &tf_emlrtBCI, sp);
    }

    top = muDoubleScalarMax(muDoubleScalarFloor(varargin_1->data[k +
      varargin_1->size[0]] - varargin_3_data[1]), 1.0);
    if (2 > varargin_1->size[1]) {
      emlrtDynamicBoundsCheckR2012b(2, 1, varargin_1->size[1], &wf_emlrtBCI, sp);
    }

    i1 = k + 1;
    if ((i1 < 1) || (i1 > varargin_1->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, varargin_1->size[0], &vf_emlrtBCI, sp);
    }

    bottom = muDoubleScalarMin(muDoubleScalarCeil(varargin_1->data[k +
      varargin_1->size[0]] + varargin_3_data[1]), varargin_2->size[0]);
    if (top > bottom) {
      i1 = -1;
      i2 = -1;
    } else {
      if ((int32_T)top > varargin_2->size[0]) {
        emlrtDynamicBoundsCheckR2012b((int32_T)top, 1, varargin_2->size[0],
          &xf_emlrtBCI, sp);
      }

      i1 = (int32_T)top - 2;
      if ((int32_T)bottom > varargin_2->size[0]) {
        emlrtDynamicBoundsCheckR2012b((int32_T)bottom, 1, varargin_2->size[0],
          &yf_emlrtBCI, sp);
      }

      i2 = (int32_T)bottom - 1;
    }

    if (left > right) {
      trueCount = -1;
      b_loop_ub = -1;
    } else {
      if ((int32_T)left > varargin_2->size[1]) {
        emlrtDynamicBoundsCheckR2012b((int32_T)left, 1, varargin_2->size[1],
          &ag_emlrtBCI, sp);
      }

      trueCount = (int32_T)left - 2;
      if ((int32_T)right > varargin_2->size[1]) {
        emlrtDynamicBoundsCheckR2012b((int32_T)right, 1, varargin_2->size[1],
          &bg_emlrtBCI, sp);
      }

      b_loop_ub = (int32_T)right - 1;
    }

    if (1 > varargin_1->size[1]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, varargin_1->size[1], &cg_emlrtBCI, sp);
    }

    if (2 > varargin_1->size[1]) {
      emlrtDynamicBoundsCheckR2012b(2, 1, varargin_1->size[1], &dg_emlrtBCI, sp);
    }

    st.site = &bk_emlrtRSI;
    n = k + 1;
    if ((n < 1) || (n > varargin_1->size[0])) {
      emlrtDynamicBoundsCheckR2012b(n, 1, varargin_1->size[0], &of_emlrtBCI, &st);
    }

    right = (varargin_1->data[n - 1] - left) + 1.0;
    n = k + 1;
    if ((n < 1) || (n > varargin_1->size[0])) {
      emlrtDynamicBoundsCheckR2012b(n, 1, varargin_1->size[0], &nf_emlrtBCI, &st);
    }

    left = (varargin_1->data[(n + varargin_1->size[0]) - 1] - top) + 1.0;
    loop_ub = b_loop_ub - trueCount;
    if (loop_ub < 1) {
      y->size[0] = 1;
      y->size[1] = 0;
    } else {
      b_loop_ub = y->size[0] * y->size[1];
      y->size[0] = 1;
      n = loop_ub - 1;
      y->size[1] = n + 1;
      emxEnsureCapacity_real_T(&st, y, b_loop_ub, &hd_emlrtRTEI);
      for (b_loop_ub = 0; b_loop_ub <= n; b_loop_ub++) {
        y->data[b_loop_ub] = (real_T)b_loop_ub + 1.0;
      }
    }

    n = i2 - i1;
    if (n < 1) {
      b_y->size[0] = 1;
      b_y->size[1] = 0;
    } else {
      i2 = b_y->size[0] * b_y->size[1];
      b_y->size[0] = 1;
      b_loop_ub = n - 1;
      b_y->size[1] = b_loop_ub + 1;
      emxEnsureCapacity_real_T(&st, b_y, i2, &hd_emlrtRTEI);
      for (i2 = 0; i2 <= b_loop_ub; i2++) {
        b_y->data[i2] = (real_T)i2 + 1.0;
      }
    }

    b_st.site = &mk_emlrtRSI;
    meshgrid(&b_st, y, b_y, r, yy);
    i2 = d_r->size[0] * d_r->size[1];
    d_r->size[0] = r->size[0];
    d_r->size[1] = r->size[1];
    emxEnsureCapacity_real_T(&st, d_r, i2, &wg_emlrtRTEI);
    b_loop_ub = r->size[0] * r->size[1];
    for (i2 = 0; i2 < b_loop_ub; i2++) {
      d_r->data[i2] = r->data[i2] - right;
    }

    i2 = b_yy->size[0] * b_yy->size[1];
    b_yy->size[0] = yy->size[0];
    b_yy->size[1] = yy->size[1];
    emxEnsureCapacity_real_T(&st, b_yy, i2, &xg_emlrtRTEI);
    b_loop_ub = yy->size[0] * yy->size[1];
    for (i2 = 0; i2 < b_loop_ub; i2++) {
      b_yy->data[i2] = yy->data[i2] - left;
    }

    b_st.site = &nk_emlrtRSI;
    c_hypot(&b_st, d_r, b_yy, r);
    b_st.site = &ok_emlrtRSI;
    c_round(&b_st, r);
    i2 = b_r->size[0];
    b_r->size[0] = r->size[0] * r->size[1];
    emxEnsureCapacity_real_T(&st, b_r, i2, &yg_emlrtRTEI);
    b_loop_ub = r->size[0] * r->size[1];
    for (i2 = 0; i2 < b_loop_ub; i2++) {
      b_r->data[i2] = r->data[i2];
    }

    i2 = b_varargin_2->size[0] * b_varargin_2->size[1];
    b_varargin_2->size[0] = n;
    b_varargin_2->size[1] = loop_ub;
    emxEnsureCapacity_real32_T(&st, b_varargin_2, i2, &ah_emlrtRTEI);
    for (i2 = 0; i2 < loop_ub; i2++) {
      for (b_loop_ub = 0; b_loop_ub < n; b_loop_ub++) {
        b_varargin_2->data[b_loop_ub + b_varargin_2->size[0] * i2] =
          varargin_2->data[((i1 + b_loop_ub) + varargin_2->size[0] * ((trueCount
          + i2) + 1)) + 1];
      }
    }

    n *= loop_ub;
    i1 = gradientImg->size[0];
    gradientImg->size[0] = n;
    emxEnsureCapacity_real32_T(&st, gradientImg, i1, &bh_emlrtRTEI);
    for (i1 = 0; i1 < n; i1++) {
      gradientImg->data[i1] = b_varargin_2->data[i1];
    }

    i1 = b_varargin_1->size[0];
    b_varargin_1->size[0] = r->size[0] * r->size[1];
    emxEnsureCapacity_boolean_T(&st, b_varargin_1, i1, &ch_emlrtRTEI);
    loop_ub = r->size[0] * r->size[1];
    i1 = c_r->size[0];
    c_r->size[0] = r->size[0] * r->size[1];
    emxEnsureCapacity_boolean_T(&st, c_r, i1, &dh_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_varargin_1->data[i1] = (r->data[i1] >= varargin_3);
      c_r->data[i1] = (r->data[i1] <= b_varargin_3);
    }

    if (b_varargin_1->size[0] != c_r->size[0]) {
      emlrtSizeEqCheck1DR2012b(b_varargin_1->size[0], c_r->size[0], &e_emlrtECI,
        &st);
    }

    n = b_varargin_1->size[0] - 1;
    b_trueCount = 0;
    for (loop_ub = 0; loop_ub <= n; loop_ub++) {
      if (b_varargin_1->data[loop_ub] && c_r->data[loop_ub]) {
        b_trueCount++;
      }
    }

    b_loop_ub = 0;
    for (loop_ub = 0; loop_ub <= n; loop_ub++) {
      if (b_varargin_1->data[loop_ub] && c_r->data[loop_ub]) {
        i1 = loop_ub + 1;
        if ((i1 < 1) || (i1 > gradientImg->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, gradientImg->size[0],
            &mf_emlrtBCI, &st);
        }

        gradientImg->data[b_loop_ub] = gradientImg->data[i1 - 1];
        b_loop_ub++;
      }
    }

    i1 = gradientImg->size[0];
    gradientImg->size[0] = b_trueCount;
    emxEnsureCapacity_real32_T(&st, gradientImg, i1, &eh_emlrtRTEI);
    n = b_varargin_1->size[0] - 1;
    trueCount = 0;
    for (loop_ub = 0; loop_ub <= n; loop_ub++) {
      if (b_varargin_1->data[loop_ub] && c_r->data[loop_ub]) {
        trueCount++;
      }
    }

    b_loop_ub = 0;
    for (loop_ub = 0; loop_ub <= n; loop_ub++) {
      if (b_varargin_1->data[loop_ub] && c_r->data[loop_ub]) {
        i1 = loop_ub + 1;
        if ((i1 < 1) || (i1 > b_r->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, b_r->size[0], &lf_emlrtBCI, &st);
        }

        b_r->data[b_loop_ub] = b_r->data[i1 - 1];
        b_loop_ub++;
      }
    }

    i1 = b_r->size[0];
    b_r->size[0] = trueCount;
    emxEnsureCapacity_real_T(&st, b_r, i1, &eh_emlrtRTEI);
    b_st.site = &pk_emlrtRSI;
    c_st.site = &ie_emlrtRSI;
    d_st.site = &je_emlrtRSI;
    e_st.site = &ke_emlrtRSI;
    if (trueCount < 1) {
      emlrtErrorWithMessageIdR2018a(&e_st, &m_emlrtRTEI,
        "Coder:toolbox:eml_min_or_max_varDimZero",
        "Coder:toolbox:eml_min_or_max_varDimZero", 0);
    }

    f_st.site = &le_emlrtRSI;
    g_st.site = &me_emlrtRSI;
    if (trueCount <= 2) {
      if (trueCount == 1) {
        left = b_r->data[0];
      } else if ((b_r->data[0] > b_r->data[1]) || (muDoubleScalarIsNaN(b_r->
                   data[0]) && (!muDoubleScalarIsNaN(b_r->data[1])))) {
        left = b_r->data[1];
      } else {
        left = b_r->data[0];
      }
    } else {
      h_st.site = &mc_emlrtRSI;
      if (!muDoubleScalarIsNaN(b_r->data[0])) {
        idx = 1;
      } else {
        idx = 0;
        i_st.site = &pb_emlrtRSI;
        if (trueCount > 2147483646) {
          j_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&j_st);
        }

        loop_ub = 2;
        exitg1 = false;
        while ((!exitg1) && (loop_ub <= trueCount)) {
          if (!muDoubleScalarIsNaN(b_r->data[loop_ub - 1])) {
            idx = loop_ub;
            exitg1 = true;
          } else {
            loop_ub++;
          }
        }
      }

      if (idx == 0) {
        left = b_r->data[0];
      } else {
        h_st.site = &lc_emlrtRSI;
        left = b_r->data[idx - 1];
        b_loop_ub = idx + 1;
        i_st.site = &qb_emlrtRSI;
        overflow = ((idx + 1 <= trueCount) && (trueCount > 2147483646));
        if (overflow) {
          j_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&j_st);
        }

        for (loop_ub = b_loop_ub; loop_ub <= trueCount; loop_ub++) {
          right = b_r->data[loop_ub - 1];
          if (left > right) {
            left = right;
          }
        }
      }
    }

    b_st.site = &pk_emlrtRSI;
    c_st.site = &gc_emlrtRSI;
    d_st.site = &hc_emlrtRSI;
    e_st.site = &ic_emlrtRSI;
    f_st.site = &jc_emlrtRSI;
    g_st.site = &kc_emlrtRSI;
    if (trueCount <= 2) {
      if (trueCount == 1) {
        bottom = b_r->data[0];
      } else if ((b_r->data[0] < b_r->data[1]) || (muDoubleScalarIsNaN(b_r->
                   data[0]) && (!muDoubleScalarIsNaN(b_r->data[1])))) {
        bottom = b_r->data[1];
      } else {
        bottom = b_r->data[0];
      }
    } else {
      h_st.site = &mc_emlrtRSI;
      if (!muDoubleScalarIsNaN(b_r->data[0])) {
        idx = 1;
      } else {
        idx = 0;
        i_st.site = &pb_emlrtRSI;
        if (trueCount > 2147483646) {
          j_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&j_st);
        }

        loop_ub = 2;
        exitg1 = false;
        while ((!exitg1) && (loop_ub <= trueCount)) {
          if (!muDoubleScalarIsNaN(b_r->data[loop_ub - 1])) {
            idx = loop_ub;
            exitg1 = true;
          } else {
            loop_ub++;
          }
        }
      }

      if (idx == 0) {
        bottom = b_r->data[0];
      } else {
        h_st.site = &lc_emlrtRSI;
        bottom = b_r->data[idx - 1];
        b_loop_ub = idx + 1;
        i_st.site = &qb_emlrtRSI;
        overflow = ((idx + 1 <= trueCount) && (trueCount > 2147483646));
        if (overflow) {
          j_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&j_st);
        }

        for (loop_ub = b_loop_ub; loop_ub <= trueCount; loop_ub++) {
          right = b_r->data[loop_ub - 1];
          if (bottom < right) {
            bottom = right;
          }
        }
      }
    }

    b_st.site = &pk_emlrtRSI;
    c_st.site = &eg_emlrtRSI;
    if (muDoubleScalarIsNaN(left) || muDoubleScalarIsNaN(bottom)) {
      i1 = y->size[0] * y->size[1];
      y->size[0] = 1;
      y->size[1] = 1;
      emxEnsureCapacity_real_T(&c_st, y, i1, &hd_emlrtRTEI);
      y->data[0] = rtNaN;
    } else if (bottom < left) {
      y->size[0] = 1;
      y->size[1] = 0;
    } else if ((muDoubleScalarIsInf(left) || muDoubleScalarIsInf(bottom)) &&
               (left == bottom)) {
      i1 = y->size[0] * y->size[1];
      y->size[0] = 1;
      y->size[1] = 1;
      emxEnsureCapacity_real_T(&c_st, y, i1, &hd_emlrtRTEI);
      y->data[0] = rtNaN;
    } else if (muDoubleScalarFloor(left) == left) {
      i1 = y->size[0] * y->size[1];
      y->size[0] = 1;
      loop_ub = (int32_T)muDoubleScalarFloor(bottom - left);
      y->size[1] = loop_ub + 1;
      emxEnsureCapacity_real_T(&c_st, y, i1, &hd_emlrtRTEI);
      for (i1 = 0; i1 <= loop_ub; i1++) {
        y->data[i1] = left + (real_T)i1;
      }
    } else {
      d_st.site = &bg_emlrtRSI;
      b_eml_float_colon(&d_st, left, bottom, y);
    }

    i1 = bins->size[0];
    bins->size[0] = y->size[1];
    emxEnsureCapacity_real_T(&st, bins, i1, &fh_emlrtRTEI);
    loop_ub = y->size[1];
    for (i1 = 0; i1 < loop_ub; i1++) {
      bins->data[i1] = y->data[i1];
    }

    if (1 > bins->size[0]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, bins->size[0], &eg_emlrtBCI, &st);
    }

    if (1 > bins->size[0]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, bins->size[0], &fg_emlrtBCI, &st);
    }

    b_st.site = &qk_emlrtRSI;
    for (i1 = 0; i1 < trueCount; i1++) {
      b_r->data[i1] = (b_r->data[i1] - bins->data[0]) + 1.0;
    }

    c_st.site = &gc_emlrtRSI;
    d_st.site = &hc_emlrtRSI;
    e_st.site = &ic_emlrtRSI;
    f_st.site = &jc_emlrtRSI;
    g_st.site = &kc_emlrtRSI;
    n = b_r->size[0];
    if (b_r->size[0] <= 2) {
      if (b_r->size[0] == 1) {
        left = b_r->data[0];
      } else if ((b_r->data[0] < b_r->data[1]) || (muDoubleScalarIsNaN(b_r->
                   data[0]) && (!muDoubleScalarIsNaN(b_r->data[1])))) {
        left = b_r->data[1];
      } else {
        left = b_r->data[0];
      }
    } else {
      h_st.site = &mc_emlrtRSI;
      if (!muDoubleScalarIsNaN(b_r->data[0])) {
        idx = 1;
      } else {
        idx = 0;
        i_st.site = &pb_emlrtRSI;
        if (b_r->size[0] > 2147483646) {
          j_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&j_st);
        }

        loop_ub = 2;
        exitg1 = false;
        while ((!exitg1) && (loop_ub <= b_r->size[0])) {
          if (!muDoubleScalarIsNaN(b_r->data[loop_ub - 1])) {
            idx = loop_ub;
            exitg1 = true;
          } else {
            loop_ub++;
          }
        }
      }

      if (idx == 0) {
        left = b_r->data[0];
      } else {
        h_st.site = &lc_emlrtRSI;
        left = b_r->data[idx - 1];
        b_loop_ub = idx + 1;
        i_st.site = &qb_emlrtRSI;
        if (idx + 1 > b_r->size[0]) {
          overflow = false;
        } else {
          overflow = (b_r->size[0] > 2147483646);
        }

        if (overflow) {
          j_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&j_st);
        }

        for (loop_ub = b_loop_ub; loop_ub <= n; loop_ub++) {
          right = b_r->data[loop_ub - 1];
          if (left < right) {
            left = right;
          }
        }
      }
    }

    b_st.site = &qk_emlrtRSI;
    if (!(left >= 0.0)) {
      emlrtNonNegativeCheckR2012b(left, &j_emlrtDCI, &b_st);
    }

    i1 = (int32_T)muDoubleScalarFloor(left);
    if (left != i1) {
      emlrtIntegerCheckR2012b(left, &k_emlrtDCI, &b_st);
    }

    loop_ub = (int32_T)left;
    i2 = h->size[0];
    h->size[0] = (int32_T)left;
    emxEnsureCapacity_creal_T(&b_st, h, i2, &gh_emlrtRTEI);
    if ((int32_T)left != i1) {
      emlrtIntegerCheckR2012b(left, &k_emlrtDCI, &b_st);
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      h->data[i1].re = 0.0;
      h->data[i1].im = 0.0;
    }

    i1 = b_r->size[0];
    for (idx = 0; idx < i1; idx++) {
      i2 = idx + 1;
      if ((i2 < 1) || (i2 > b_r->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, b_r->size[0], &kf_emlrtBCI, &b_st);
      }

      right = b_r->data[i2 - 1];
      if (right != (int32_T)muDoubleScalarFloor(right)) {
        emlrtIntegerCheckR2012b(right, &i_emlrtDCI, &b_st);
      }

      i2 = (int32_T)right;
      if ((i2 < 1) || (i2 > h->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, h->size[0], &kf_emlrtBCI, &b_st);
      }

      trueCount = idx + 1;
      if ((trueCount < 1) || (trueCount > b_r->size[0])) {
        emlrtDynamicBoundsCheckR2012b(trueCount, 1, b_r->size[0], &kf_emlrtBCI,
          &b_st);
      }

      right = b_r->data[trueCount - 1];
      if (right != (int32_T)muDoubleScalarFloor(right)) {
        emlrtIntegerCheckR2012b(b_r->data[trueCount - 1], &i_emlrtDCI, &b_st);
      }

      trueCount = (int32_T)right;
      if ((trueCount < 1) || (trueCount > h->size[0])) {
        emlrtDynamicBoundsCheckR2012b(trueCount, 1, h->size[0], &kf_emlrtBCI,
          &b_st);
      }

      b_loop_ub = idx + 1;
      if ((b_loop_ub < 1) || (b_loop_ub > b_trueCount)) {
        emlrtDynamicBoundsCheckR2012b(b_loop_ub, 1, b_trueCount, &lg_emlrtBCI,
          &b_st);
      }

      n = idx + 1;
      if ((n < 1) || (n > b_r->size[0])) {
        emlrtDynamicBoundsCheckR2012b(n, 1, b_r->size[0], &jf_emlrtBCI, &b_st);
      }

      right = b_r->data[n - 1];
      if (right != (int32_T)muDoubleScalarFloor(right)) {
        emlrtIntegerCheckR2012b(right, &h_emlrtDCI, &b_st);
      }

      n = (int32_T)right;
      if ((n < 1) || (n > h->size[0])) {
        emlrtDynamicBoundsCheckR2012b(n, 1, h->size[0], &jf_emlrtBCI, &b_st);
      }

      h->data[n - 1].re = (real32_T)h->data[i2 - 1].re + gradientImg->
        data[b_loop_ub - 1];
      i2 = idx + 1;
      if ((i2 < 1) || (i2 > b_r->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, b_r->size[0], &jf_emlrtBCI, &b_st);
      }

      right = b_r->data[i2 - 1];
      if (right != (int32_T)muDoubleScalarFloor(right)) {
        emlrtIntegerCheckR2012b(b_r->data[i2 - 1], &h_emlrtDCI, &b_st);
      }

      i2 = (int32_T)right;
      if ((i2 < 1) || (i2 > h->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, h->size[0], &jf_emlrtBCI, &b_st);
      }

      h->data[i2 - 1].im = (real32_T)h->data[trueCount - 1].im;
    }

    i1 = h->size[0];
    for (idx = 0; idx < i1; idx++) {
      i2 = idx + 1;
      if ((i2 < 1) || (i2 > h->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, h->size[0], &gg_emlrtBCI, &st);
      }

      i2 = idx + 1;
      if ((i2 < 1) || (i2 > bins->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, bins->size[0], &hg_emlrtBCI, &st);
      }

      left = 6.2831853071795862 * bins->data[idx];
      if (h->data[idx].im == 0.0) {
        right = h->data[idx].re / left;
        left = 0.0;
      } else if (h->data[idx].re == 0.0) {
        right = 0.0;
        left = h->data[idx].im / left;
      } else {
        right = h->data[idx].re / left;
        left = h->data[idx].im / left;
      }

      i2 = idx + 1;
      if ((i2 < 1) || (i2 > h->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, h->size[0], &if_emlrtBCI, &st);
      }

      h->data[i2 - 1].re = right;
      i2 = idx + 1;
      if ((i2 < 1) || (i2 > h->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, h->size[0], &if_emlrtBCI, &st);
      }

      h->data[i2 - 1].im = left;
    }

    st.site = &ck_emlrtRSI;
    b_st.site = &tk_emlrtRSI;
    c_st.site = &uk_emlrtRSI;
    d_st.site = &vk_emlrtRSI;
    if (h->size[0] < 1) {
      emlrtErrorWithMessageIdR2018a(&d_st, &m_emlrtRTEI,
        "Coder:toolbox:eml_min_or_max_varDimZero",
        "Coder:toolbox:eml_min_or_max_varDimZero", 0);
    }

    e_st.site = &wk_emlrtRSI;
    n = h->size[0];
    f_st.site = &xk_emlrtRSI;
    b_loop_ub = 1;
    ex = h->data[0];
    g_st.site = &al_emlrtRSI;
    if (2 > h->size[0]) {
      overflow = false;
    } else {
      overflow = (h->size[0] > 2147483646);
    }

    if (overflow) {
      h_st.site = &fb_emlrtRSI;
      check_forloop_overflow_error(&h_st);
    }

    for (loop_ub = 2; loop_ub <= n; loop_ub++) {
      g_st.site = &yk_emlrtRSI;
      h_tmp = h->data[loop_ub - 1];
      h_st.site = &bl_emlrtRSI;
      overflow = relop(ex, h_tmp);
      if (overflow) {
        ex = h_tmp;
        b_loop_ub = loop_ub;
      }
    }

    i1 = k + 1;
    if ((i1 < 1) || (i1 > r_estimated->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, r_estimated->size[0], &gf_emlrtBCI,
        sp);
    }

    if (b_loop_ub > bins->size[0]) {
      emlrtDynamicBoundsCheckR2012b(b_loop_ub, 1, bins->size[0], &hf_emlrtBCI,
        sp);
    }

    r_estimated->data[i1 - 1] = bins->data[b_loop_ub - 1];
  }

  emxFree_real32_T(&b_varargin_2);
  emxFree_real_T(&b_yy);
  emxFree_real_T(&d_r);
  emxFree_boolean_T(&b_varargin_1);
  emxFree_real_T(&b_y);
  emxFree_real_T(&y);
  emxFree_boolean_T(&c_r);
  emxFree_real32_T(&gradientImg);
  emxFree_real_T(&b_r);
  emxFree_real_T(&yy);
  emxFree_real_T(&r);
  emxFree_real_T(&bins);
  emxFree_creal_T(&h);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (chradii.c) */
