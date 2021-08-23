/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * bwconncomp.c
 *
 * Code generation for function 'bwconncomp'
 *
 */

/* Include files */
#include "bwconncomp.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo th_emlrtRSI = { 23, /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo uh_emlrtRSI = { 44, /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo vh_emlrtRSI = { 57, /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo wh_emlrtRSI = { 69, /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo xh_emlrtRSI = { 70, /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo yh_emlrtRSI = { 71, /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo ai_emlrtRSI = { 79, /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo bi_emlrtRSI = { 33, /* lineNo */
  "intermediateLabelRuns",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo ci_emlrtRSI = { 51, /* lineNo */
  "intermediateLabelRuns",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo di_emlrtRSI = { 114,/* lineNo */
  "intermediateLabelRuns",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo ei_emlrtRSI = { 149,/* lineNo */
  "uf_new_pair",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo fi_emlrtRSI = { 150,/* lineNo */
  "uf_new_pair",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo gi_emlrtRSI = { 153,/* lineNo */
  "uf_new_pair",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo ni_emlrtRSI = { 32, /* lineNo */
  "useConstantDim",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\useConstantDim.m"/* pathName */
};

static emlrtRSInfo oi_emlrtRSI = { 99, /* lineNo */
  "ndlooper",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\cumop.m"/* pathName */
};

static emlrtBCInfo id_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  34,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ld_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  22,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo md_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  35,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  168,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_union",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo od_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  171,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_union",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  167,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_union",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  170,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_union",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  183,                                 /* lineNo */
  12,                                  /* colNo */
  "",                                  /* aName */
  "uf_find_root",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  182,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_find_root",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo td_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  182,                                 /* lineNo */
  20,                                  /* colNo */
  "",                                  /* aName */
  "uf_find_root",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ud_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  181,                                 /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "uf_find_root",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  21,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  42,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  108,                                 /* lineNo */
  47,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  108,                                 /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ae_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  99,                                  /* lineNo */
  21,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo be_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  95,                                  /* lineNo */
  73,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ce_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  95,                                  /* lineNo */
  57,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo de_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  95,                                  /* lineNo */
  32,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ee_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  95,                                  /* lineNo */
  18,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fe_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  134,                                 /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = { 69,  /* lineNo */
  37,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo e_emlrtDCI = { 69,  /* lineNo */
  37,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo ge_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  130,                                 /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo he_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  86,                                  /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ie_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo je_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  238,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ke_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  235,                                 /* lineNo */
  35,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo le_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo me_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  62,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ne_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  62,                                  /* lineNo */
  67,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo oe_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  62,                                  /* lineNo */
  55,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pe_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  62,                                  /* lineNo */
  46,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qe_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo re_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  234,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo se_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  233,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo te_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  232,                                 /* lineNo */
  28,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ue_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  228,                                 /* lineNo */
  31,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ve_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  48,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo we_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  52,                                  /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xe_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  52,                                  /* lineNo */
  27,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ye_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  46,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo f_emlrtDCI = { 55,  /* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo af_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  204,                                 /* lineNo */
  38,                                  /* colNo */
  "",                                  /* aName */
  "numberOfRuns",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  204,                                 /* lineNo */
  18,                                  /* colNo */
  "",                                  /* aName */
  "numberOfRuns",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo g_emlrtDCI = { 48,  /* lineNo */
  33,                                  /* colNo */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  4                                    /* checkKind */
};

static emlrtBCInfo cf_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  198,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "numberOfRuns",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo df_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  59,                                  /* lineNo */
  52,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ef_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  73,                                  /* lineNo */
  82,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ff_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  63,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo ig_emlrtRTEI = { 23,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo jg_emlrtRTEI = { 1,/* lineNo */
  15,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo kg_emlrtRTEI = { 55,/* lineNo */
  1,                                   /* colNo */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pName */
};

static emlrtRTEInfo lg_emlrtRTEI = { 33,/* lineNo */
  5,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo mg_emlrtRTEI = { 55,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo ng_emlrtRTEI = { 69,/* lineNo */
  31,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo og_emlrtRTEI = { 70,/* lineNo */
  46,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo pg_emlrtRTEI = { 70,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo qg_emlrtRTEI = { 89,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo rg_emlrtRTEI = { 11,/* lineNo */
  6,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo sg_emlrtRTEI = { 39,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

/* Function Definitions */
void bwconncomp(const emlrtStack *sp, const emxArray_boolean_T *varargin_1,
                real_T *CC_Connectivity, real_T CC_ImageSize[2], real_T
                *CC_NumObjects, emxArray_real_T *CC_RegionIndices,
                emxArray_int32_T *CC_RegionLengths)
{
  int32_T numRuns;
  int32_T i;
  int32_T firstRunOnThisColumn;
  emxArray_int32_T *startRow;
  emxArray_int32_T *endRow;
  int32_T lastRunOnPreviousColumn;
  emxArray_int32_T *startCol;
  int32_T k;
  int32_T currentColumn;
  emxArray_int32_T *labelsRenumbered;
  int32_T runCounter;
  real_T numComponents;
  int32_T row;
  boolean_T exitg1;
  real_T y;
  boolean_T overflow;
  int32_T p;
  emxArray_int32_T *pixelIdxList;
  emxArray_int32_T *x;
  int32_T root_k;
  emxArray_int32_T *idxCount;
  int32_T exitg2;
  int32_T root_p;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
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
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &th_emlrtRSI;
  b_st.site = &bi_emlrtRSI;
  numRuns = 0;
  if ((varargin_1->size[0] != 0) && (varargin_1->size[1] != 0)) {
    i = varargin_1->size[1];
    for (firstRunOnThisColumn = 0; firstRunOnThisColumn < i;
         firstRunOnThisColumn++) {
      lastRunOnPreviousColumn = firstRunOnThisColumn + 1;
      if ((lastRunOnPreviousColumn < 1) || (lastRunOnPreviousColumn >
           varargin_1->size[1])) {
        emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1,
          varargin_1->size[1], &cf_emlrtBCI, &b_st);
      }

      if (varargin_1->data[varargin_1->size[0] * (lastRunOnPreviousColumn - 1)])
      {
        numRuns++;
      }

      lastRunOnPreviousColumn = varargin_1->size[0];
      for (k = 0; k <= lastRunOnPreviousColumn - 2; k++) {
        currentColumn = firstRunOnThisColumn + 1;
        if ((currentColumn < 1) || (currentColumn > varargin_1->size[1])) {
          emlrtDynamicBoundsCheckR2012b(currentColumn, 1, varargin_1->size[1],
            &bf_emlrtBCI, &b_st);
        }

        runCounter = k + 2;
        if ((runCounter < 1) || (runCounter > varargin_1->size[0])) {
          emlrtDynamicBoundsCheckR2012b(runCounter, 1, varargin_1->size[0],
            &bf_emlrtBCI, &b_st);
        }

        if (varargin_1->data[(runCounter + varargin_1->size[0] * (currentColumn
              - 1)) - 1]) {
          currentColumn = firstRunOnThisColumn + 1;
          if ((currentColumn < 1) || (currentColumn > varargin_1->size[1])) {
            emlrtDynamicBoundsCheckR2012b(currentColumn, 1, varargin_1->size[1],
              &af_emlrtBCI, &b_st);
          }

          runCounter = k + 1;
          if ((runCounter < 1) || (runCounter > varargin_1->size[0])) {
            emlrtDynamicBoundsCheckR2012b(runCounter, 1, varargin_1->size[0],
              &af_emlrtBCI, &b_st);
          }

          if (!varargin_1->data[(runCounter + varargin_1->size[0] *
                                 (currentColumn - 1)) - 1]) {
            numRuns++;
          }
        }
      }
    }
  }

  emxInit_int32_T(&st, &startRow, 1, &jg_emlrtRTEI, true);
  emxInit_int32_T(&st, &endRow, 1, &jg_emlrtRTEI, true);
  emxInit_int32_T(&st, &startCol, 1, &jg_emlrtRTEI, true);
  if (numRuns == 0) {
    startRow->size[0] = 0;
    endRow->size[0] = 0;
    startCol->size[0] = 0;
    CC_RegionLengths->size[0] = 0;
  } else {
    if (numRuns < 0) {
      emlrtNonNegativeCheckR2012b(numRuns, &g_emlrtDCI, &st);
    }

    i = startRow->size[0];
    startRow->size[0] = numRuns;
    emxEnsureCapacity_int32_T(&st, startRow, i, &ig_emlrtRTEI);
    i = endRow->size[0];
    endRow->size[0] = numRuns;
    emxEnsureCapacity_int32_T(&st, endRow, i, &ig_emlrtRTEI);
    i = startCol->size[0];
    startCol->size[0] = numRuns;
    emxEnsureCapacity_int32_T(&st, startCol, i, &ig_emlrtRTEI);
    b_st.site = &ci_emlrtRSI;
    currentColumn = varargin_1->size[0];
    runCounter = 1;
    i = varargin_1->size[1];
    for (firstRunOnThisColumn = 0; firstRunOnThisColumn < i;
         firstRunOnThisColumn++) {
      row = 1;
      while (row <= currentColumn) {
        exitg1 = false;
        while ((!exitg1) && (row <= currentColumn)) {
          lastRunOnPreviousColumn = firstRunOnThisColumn + 1;
          if ((lastRunOnPreviousColumn < 1) || (lastRunOnPreviousColumn >
               varargin_1->size[1])) {
            emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1,
              varargin_1->size[1], &ue_emlrtBCI, &b_st);
          }

          if ((row < 1) || (row > varargin_1->size[0])) {
            emlrtDynamicBoundsCheckR2012b(row, 1, varargin_1->size[0],
              &ue_emlrtBCI, &b_st);
          }

          if (!varargin_1->data[(row + varargin_1->size[0] *
                                 (lastRunOnPreviousColumn - 1)) - 1]) {
            row++;
          } else {
            exitg1 = true;
          }
        }

        if (row <= currentColumn) {
          lastRunOnPreviousColumn = firstRunOnThisColumn + 1;
          if ((lastRunOnPreviousColumn < 1) || (lastRunOnPreviousColumn >
               varargin_1->size[1])) {
            emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1,
              varargin_1->size[1], &te_emlrtBCI, &b_st);
          }

          if (row > varargin_1->size[0]) {
            emlrtDynamicBoundsCheckR2012b(row, 1, varargin_1->size[0],
              &te_emlrtBCI, &b_st);
          }

          if (varargin_1->data[(row + varargin_1->size[0] *
                                (lastRunOnPreviousColumn - 1)) - 1]) {
            if ((runCounter < 1) || (runCounter > startCol->size[0])) {
              emlrtDynamicBoundsCheckR2012b(runCounter, 1, startCol->size[0],
                &se_emlrtBCI, &b_st);
            }

            startCol->data[runCounter - 1] = firstRunOnThisColumn + 1;
            if (runCounter > startRow->size[0]) {
              emlrtDynamicBoundsCheckR2012b(runCounter, 1, startRow->size[0],
                &re_emlrtBCI, &b_st);
            }

            startRow->data[runCounter - 1] = row;
            exitg1 = false;
            while ((!exitg1) && (row <= currentColumn)) {
              lastRunOnPreviousColumn = firstRunOnThisColumn + 1;
              if ((lastRunOnPreviousColumn < 1) || (lastRunOnPreviousColumn >
                   varargin_1->size[1])) {
                emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1,
                  varargin_1->size[1], &ke_emlrtBCI, &b_st);
              }

              if ((row < 1) || (row > varargin_1->size[0])) {
                emlrtDynamicBoundsCheckR2012b(row, 1, varargin_1->size[0],
                  &ke_emlrtBCI, &b_st);
              }

              if (varargin_1->data[(row + varargin_1->size[0] *
                                    (lastRunOnPreviousColumn - 1)) - 1]) {
                row++;
              } else {
                exitg1 = true;
              }
            }

            if (runCounter > endRow->size[0]) {
              emlrtDynamicBoundsCheckR2012b(runCounter, 1, endRow->size[0],
                &je_emlrtBCI, &b_st);
            }

            endRow->data[runCounter - 1] = row - 1;
            runCounter++;
          }
        }
      }
    }

    i = CC_RegionLengths->size[0];
    CC_RegionLengths->size[0] = numRuns;
    emxEnsureCapacity_int32_T(&st, CC_RegionLengths, i, &kg_emlrtRTEI);
    for (i = 0; i < numRuns; i++) {
      CC_RegionLengths->data[i] = 0;
    }

    k = 1;
    currentColumn = 1;
    runCounter = 1;
    row = -1;
    lastRunOnPreviousColumn = -1;
    firstRunOnThisColumn = 1;
    while (k <= numRuns) {
      if ((k < 1) || (k > startCol->size[0])) {
        emlrtDynamicBoundsCheckR2012b(k, 1, startCol->size[0], &qe_emlrtBCI, &st);
      }

      i = startCol->data[k - 1];
      if (i == currentColumn + 1) {
        row = firstRunOnThisColumn;
        firstRunOnThisColumn = k;
        lastRunOnPreviousColumn = k - 1;
        if (k > startCol->size[0]) {
          emlrtDynamicBoundsCheckR2012b(k, 1, startCol->size[0], &ie_emlrtBCI,
            &st);
        }

        currentColumn = i;
      } else {
        if (k > startCol->size[0]) {
          emlrtDynamicBoundsCheckR2012b(k, 1, startCol->size[0], &le_emlrtBCI,
            &st);
        }

        if (i > currentColumn + 1) {
          row = -1;
          lastRunOnPreviousColumn = -1;
          firstRunOnThisColumn = k;
          if (k > startCol->size[0]) {
            emlrtDynamicBoundsCheckR2012b(k, 1, startCol->size[0], &he_emlrtBCI,
              &st);
          }

          currentColumn = i;
        }
      }

      if (row >= 0) {
        for (p = row; p <= lastRunOnPreviousColumn; p++) {
          if ((p < 1) || (p > startRow->size[0])) {
            emlrtDynamicBoundsCheckR2012b(p, 1, startRow->size[0], &de_emlrtBCI,
              &st);
          }

          if (k > endRow->size[0]) {
            emlrtDynamicBoundsCheckR2012b(k, 1, endRow->size[0], &ee_emlrtBCI,
              &st);
          }

          if (endRow->data[k - 1] >= startRow->data[p - 1] - 1) {
            if (p > endRow->size[0]) {
              emlrtDynamicBoundsCheckR2012b(p, 1, endRow->size[0], &be_emlrtBCI,
                &st);
            }

            if (k > startRow->size[0]) {
              emlrtDynamicBoundsCheckR2012b(k, 1, startRow->size[0],
                &ce_emlrtBCI, &st);
            }

            if (startRow->data[k - 1] <= endRow->data[p - 1] + 1) {
              if (k > CC_RegionLengths->size[0]) {
                emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
                  &ae_emlrtBCI, &st);
              }

              i = CC_RegionLengths->data[k - 1];
              if (i == 0) {
                if (k > CC_RegionLengths->size[0]) {
                  emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
                    &vd_emlrtBCI, &st);
                }

                if (p > CC_RegionLengths->size[0]) {
                  emlrtDynamicBoundsCheckR2012b(p, 1, CC_RegionLengths->size[0],
                    &wd_emlrtBCI, &st);
                }

                CC_RegionLengths->data[k - 1] = CC_RegionLengths->data[p - 1];
                runCounter++;
              } else {
                if (p > CC_RegionLengths->size[0]) {
                  emlrtDynamicBoundsCheckR2012b(p, 1, CC_RegionLengths->size[0],
                    &xd_emlrtBCI, &st);
                }

                if (k > CC_RegionLengths->size[0]) {
                  emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
                    &yd_emlrtBCI, &st);
                }

                if (i != CC_RegionLengths->data[p - 1]) {
                  b_st.site = &di_emlrtRSI;
                  c_st.site = &ei_emlrtRSI;
                  root_k = k;
                  do {
                    exitg2 = 0;
                    if ((root_k < 1) || (root_k > CC_RegionLengths->size[0])) {
                      emlrtDynamicBoundsCheckR2012b(root_k, 1,
                        CC_RegionLengths->size[0], &ud_emlrtBCI, &c_st);
                    }

                    i = CC_RegionLengths->data[root_k - 1];
                    if (root_k != i) {
                      if (root_k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_k, 1,
                          CC_RegionLengths->size[0], &sd_emlrtBCI, &c_st);
                      }

                      if (root_k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_k, 1,
                          CC_RegionLengths->size[0], &td_emlrtBCI, &c_st);
                      }

                      if ((i < 1) || (i > CC_RegionLengths->size[0])) {
                        emlrtDynamicBoundsCheckR2012b(CC_RegionLengths->
                          data[root_k - 1], 1, CC_RegionLengths->size[0],
                          &td_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[root_k - 1] =
                        CC_RegionLengths->data[i - 1];
                      if (root_k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_k, 1,
                          CC_RegionLengths->size[0], &rd_emlrtBCI, &c_st);
                      }

                      root_k = CC_RegionLengths->data[root_k - 1];
                    } else {
                      exitg2 = 1;
                    }
                  } while (exitg2 == 0);

                  c_st.site = &fi_emlrtRSI;
                  root_p = p;
                  do {
                    exitg2 = 0;
                    if ((root_p < 1) || (root_p > CC_RegionLengths->size[0])) {
                      emlrtDynamicBoundsCheckR2012b(root_p, 1,
                        CC_RegionLengths->size[0], &ud_emlrtBCI, &c_st);
                    }

                    i = CC_RegionLengths->data[root_p - 1];
                    if (root_p != i) {
                      if (root_p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_p, 1,
                          CC_RegionLengths->size[0], &sd_emlrtBCI, &c_st);
                      }

                      if (root_p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_p, 1,
                          CC_RegionLengths->size[0], &td_emlrtBCI, &c_st);
                      }

                      if ((i < 1) || (i > CC_RegionLengths->size[0])) {
                        emlrtDynamicBoundsCheckR2012b(CC_RegionLengths->
                          data[root_p - 1], 1, CC_RegionLengths->size[0],
                          &td_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[root_p - 1] =
                        CC_RegionLengths->data[i - 1];
                      if (root_p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_p, 1,
                          CC_RegionLengths->size[0], &rd_emlrtBCI, &c_st);
                      }

                      root_p = CC_RegionLengths->data[root_p - 1];
                    } else {
                      exitg2 = 1;
                    }
                  } while (exitg2 == 0);

                  if (root_k != root_p) {
                    c_st.site = &gi_emlrtRSI;
                    if (root_p < root_k) {
                      if (root_k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_k, 1,
                          CC_RegionLengths->size[0], &pd_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[root_k - 1] = root_p;
                      if (k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(k, 1,
                          CC_RegionLengths->size[0], &nd_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[k - 1] = root_p;
                    } else {
                      if (root_p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_p, 1,
                          CC_RegionLengths->size[0], &qd_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[root_p - 1] = root_k;
                      if (p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(p, 1,
                          CC_RegionLengths->size[0], &od_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[p - 1] = root_k;
                    }
                  }
                }
              }
            }
          }
        }
      }

      if (k > CC_RegionLengths->size[0]) {
        emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
          &ge_emlrtBCI, &st);
      }

      if (CC_RegionLengths->data[k - 1] == 0) {
        if (k > CC_RegionLengths->size[0]) {
          emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
            &fe_emlrtBCI, &st);
        }

        CC_RegionLengths->data[k - 1] = runCounter;
        runCounter++;
      }

      k++;
    }
  }

  if (numRuns == 0) {
    CC_ImageSize[0] = varargin_1->size[0];
    CC_ImageSize[1] = varargin_1->size[1];
    currentColumn = 0;
    CC_RegionIndices->size[0] = 0;
    i = CC_RegionLengths->size[0];
    CC_RegionLengths->size[0] = 1;
    emxEnsureCapacity_int32_T(sp, CC_RegionLengths, i, &lg_emlrtRTEI);
    CC_RegionLengths->data[0] = 0;
  } else {
    emxInit_int32_T(sp, &labelsRenumbered, 1, &sg_emlrtRTEI, true);
    i = labelsRenumbered->size[0];
    labelsRenumbered->size[0] = CC_RegionLengths->size[0];
    emxEnsureCapacity_int32_T(sp, labelsRenumbered, i, &jg_emlrtRTEI);
    numComponents = 0.0;
    st.site = &uh_emlrtRSI;
    for (k = 0; k < numRuns; k++) {
      i = k + 1;
      if (i > CC_RegionLengths->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, CC_RegionLengths->size[0],
          &ye_emlrtBCI, sp);
      }

      if (CC_RegionLengths->data[i - 1] == k + 1) {
        numComponents++;
        i = k + 1;
        if (i > labelsRenumbered->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, labelsRenumbered->size[0],
            &ve_emlrtBCI, sp);
        }

        labelsRenumbered->data[i - 1] = (int32_T)numComponents;
      }

      i = k + 1;
      if (i > labelsRenumbered->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, labelsRenumbered->size[0],
          &we_emlrtBCI, sp);
      }

      lastRunOnPreviousColumn = k + 1;
      if (lastRunOnPreviousColumn > CC_RegionLengths->size[0]) {
        emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1,
          CC_RegionLengths->size[0], &xe_emlrtBCI, sp);
      }

      currentColumn = CC_RegionLengths->data[lastRunOnPreviousColumn - 1];
      if ((currentColumn < 1) || (currentColumn > labelsRenumbered->size[0])) {
        emlrtDynamicBoundsCheckR2012b(CC_RegionLengths->
          data[lastRunOnPreviousColumn - 1], 1, labelsRenumbered->size[0],
          &xe_emlrtBCI, sp);
      }

      labelsRenumbered->data[i - 1] = labelsRenumbered->data[currentColumn - 1];
    }

    i = (int32_T)numComponents;
    if (numComponents != i) {
      emlrtIntegerCheckR2012b(numComponents, &f_emlrtDCI, sp);
    }

    runCounter = (int32_T)numComponents;
    lastRunOnPreviousColumn = CC_RegionLengths->size[0];
    CC_RegionLengths->size[0] = (int32_T)numComponents;
    emxEnsureCapacity_int32_T(sp, CC_RegionLengths, lastRunOnPreviousColumn,
      &mg_emlrtRTEI);
    if ((int32_T)numComponents != i) {
      emlrtIntegerCheckR2012b(numComponents, &f_emlrtDCI, sp);
    }

    for (i = 0; i < runCounter; i++) {
      CC_RegionLengths->data[i] = 0;
    }

    st.site = &vh_emlrtRSI;
    for (k = 0; k < numRuns; k++) {
      i = k + 1;
      if (i > labelsRenumbered->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, labelsRenumbered->size[0],
          &df_emlrtBCI, sp);
      }

      if (labelsRenumbered->data[k] > 0) {
        if ((labelsRenumbered->data[k] < 1) || (labelsRenumbered->data[k] >
             CC_RegionLengths->size[0])) {
          emlrtDynamicBoundsCheckR2012b(labelsRenumbered->data[k], 1,
            CC_RegionLengths->size[0], &me_emlrtBCI, sp);
        }

        i = k + 1;
        if (i > startRow->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, startRow->size[0], &ne_emlrtBCI,
            sp);
        }

        lastRunOnPreviousColumn = k + 1;
        if (lastRunOnPreviousColumn > endRow->size[0]) {
          emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1, endRow->
            size[0], &oe_emlrtBCI, sp);
        }

        if ((labelsRenumbered->data[k] < 1) || (labelsRenumbered->data[k] >
             CC_RegionLengths->size[0])) {
          emlrtDynamicBoundsCheckR2012b(labelsRenumbered->data[k], 1,
            CC_RegionLengths->size[0], &pe_emlrtBCI, sp);
        }

        CC_RegionLengths->data[labelsRenumbered->data[k] - 1] =
          ((CC_RegionLengths->data[labelsRenumbered->data[k] - 1] + endRow->
            data[lastRunOnPreviousColumn - 1]) - startRow->data[i - 1]) + 1;
      }
    }

    st.site = &wh_emlrtRSI;
    b_st.site = &hi_emlrtRSI;
    c_st.site = &ii_emlrtRSI;
    currentColumn = CC_RegionLengths->size[0];
    if (CC_RegionLengths->size[0] == 0) {
      y = 0.0;
    } else {
      d_st.site = &ji_emlrtRSI;
      y = CC_RegionLengths->data[0];
      e_st.site = &ki_emlrtRSI;
      if (2 > CC_RegionLengths->size[0]) {
        overflow = false;
      } else {
        overflow = (CC_RegionLengths->size[0] > 2147483646);
      }

      if (overflow) {
        f_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&f_st);
      }

      for (k = 2; k <= currentColumn; k++) {
        y += (real_T)CC_RegionLengths->data[k - 1];
      }
    }

    if (!(y >= 0.0)) {
      emlrtNonNegativeCheckR2012b(y, &d_emlrtDCI, sp);
    }

    i = (int32_T)y;
    if (y != i) {
      emlrtIntegerCheckR2012b(y, &e_emlrtDCI, sp);
    }

    emxInit_int32_T(sp, &pixelIdxList, 1, &rg_emlrtRTEI, true);
    emxInit_int32_T(sp, &x, 1, &og_emlrtRTEI, true);
    lastRunOnPreviousColumn = pixelIdxList->size[0];
    pixelIdxList->size[0] = i;
    emxEnsureCapacity_int32_T(sp, pixelIdxList, lastRunOnPreviousColumn,
      &ng_emlrtRTEI);
    st.site = &xh_emlrtRSI;
    i = x->size[0];
    x->size[0] = CC_RegionLengths->size[0];
    emxEnsureCapacity_int32_T(&st, x, i, &og_emlrtRTEI);
    runCounter = CC_RegionLengths->size[0];
    for (i = 0; i < runCounter; i++) {
      x->data[i] = CC_RegionLengths->data[i];
    }

    b_st.site = &li_emlrtRSI;
    currentColumn = 2;
    if (CC_RegionLengths->size[0] != 1) {
      currentColumn = 1;
    }

    c_st.site = &mi_emlrtRSI;
    if (1 == currentColumn) {
      d_st.site = &ni_emlrtRSI;
      e_st.site = &oi_emlrtRSI;
      if ((CC_RegionLengths->size[0] != 0) && (CC_RegionLengths->size[0] != 1))
      {
        currentColumn = CC_RegionLengths->size[0];
        for (k = 0; k <= currentColumn - 2; k++) {
          x->data[k + 1] += x->data[k];
        }
      }
    }

    emxInit_int32_T(&c_st, &idxCount, 1, &pg_emlrtRTEI, true);
    i = idxCount->size[0];
    idxCount->size[0] = x->size[0] + 1;
    emxEnsureCapacity_int32_T(sp, idxCount, i, &pg_emlrtRTEI);
    idxCount->data[0] = 0;
    runCounter = x->size[0];
    for (i = 0; i < runCounter; i++) {
      idxCount->data[i + 1] = x->data[i];
    }

    emxFree_int32_T(&x);
    st.site = &yh_emlrtRSI;
    for (k = 0; k < numRuns; k++) {
      i = k + 1;
      if (i > startCol->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, startCol->size[0], &ef_emlrtBCI, sp);
      }

      runCounter = (startCol->data[k] - 1) * varargin_1->size[0];
      i = k + 1;
      if (i > labelsRenumbered->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, labelsRenumbered->size[0],
          &md_emlrtBCI, sp);
      }

      row = labelsRenumbered->data[i - 1];
      if (labelsRenumbered->data[k] > 0) {
        i = k + 1;
        if (i > startRow->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, startRow->size[0], &ld_emlrtBCI,
            sp);
        }

        lastRunOnPreviousColumn = startRow->data[i - 1];
        i = k + 1;
        if (i > endRow->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, endRow->size[0], &kd_emlrtBCI, sp);
        }

        currentColumn = endRow->data[i - 1];
        st.site = &ai_emlrtRSI;
        for (firstRunOnThisColumn = lastRunOnPreviousColumn;
             firstRunOnThisColumn <= currentColumn; firstRunOnThisColumn++) {
          if ((row < 1) || (row > idxCount->size[0])) {
            emlrtDynamicBoundsCheckR2012b(row, 1, idxCount->size[0],
              &ff_emlrtBCI, sp);
          }

          if (row > idxCount->size[0]) {
            emlrtDynamicBoundsCheckR2012b(row, 1, idxCount->size[0],
              &jd_emlrtBCI, sp);
          }

          idxCount->data[row - 1]++;
          if (row > idxCount->size[0]) {
            emlrtDynamicBoundsCheckR2012b(row, 1, idxCount->size[0],
              &id_emlrtBCI, sp);
          }

          if ((idxCount->data[row - 1] < 1) || (idxCount->data[row - 1] >
               pixelIdxList->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxCount->data[row - 1], 1,
              pixelIdxList->size[0], &id_emlrtBCI, sp);
          }

          pixelIdxList->data[idxCount->data[row - 1] - 1] = firstRunOnThisColumn
            + runCounter;
        }
      }
    }

    emxFree_int32_T(&idxCount);
    emxFree_int32_T(&labelsRenumbered);
    CC_ImageSize[0] = varargin_1->size[0];
    CC_ImageSize[1] = varargin_1->size[1];
    currentColumn = (int32_T)numComponents;
    i = CC_RegionIndices->size[0];
    CC_RegionIndices->size[0] = pixelIdxList->size[0];
    emxEnsureCapacity_real_T(sp, CC_RegionIndices, i, &qg_emlrtRTEI);
    runCounter = pixelIdxList->size[0];
    for (i = 0; i < runCounter; i++) {
      CC_RegionIndices->data[i] = pixelIdxList->data[i];
    }

    emxFree_int32_T(&pixelIdxList);
  }

  emxFree_int32_T(&startCol);
  emxFree_int32_T(&endRow);
  emxFree_int32_T(&startRow);
  *CC_Connectivity = 8.0;
  *CC_NumObjects = currentColumn;
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (bwconncomp.c) */
