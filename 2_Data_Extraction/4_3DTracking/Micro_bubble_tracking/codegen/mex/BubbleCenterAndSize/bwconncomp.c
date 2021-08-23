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
#include "BubbleCenterAndSize.h"
#include "BubbleCenterAndSize_data.h"
#include "BubbleCenterAndSize_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo j_emlrtRSI = { 23,  /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo k_emlrtRSI = { 44,  /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo l_emlrtRSI = { 57,  /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 69,  /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo n_emlrtRSI = { 70,  /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo o_emlrtRSI = { 71,  /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo p_emlrtRSI = { 79,  /* lineNo */
  "bwconncomp",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pathName */
};

static emlrtRSInfo q_emlrtRSI = { 33,  /* lineNo */
  "intermediateLabelRuns",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo r_emlrtRSI = { 51,  /* lineNo */
  "intermediateLabelRuns",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo s_emlrtRSI = { 114, /* lineNo */
  "intermediateLabelRuns",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo t_emlrtRSI = { 149, /* lineNo */
  "uf_new_pair",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo u_emlrtRSI = { 150, /* lineNo */
  "uf_new_pair",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo v_emlrtRSI = { 153, /* lineNo */
  "uf_new_pair",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pathName */
};

static emlrtRSInfo eb_emlrtRSI = { 32, /* lineNo */
  "useConstantDim",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\useConstantDim.m"/* pathName */
};

static emlrtRSInfo fb_emlrtRSI = { 99, /* lineNo */
  "ndlooper",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\cumop.m"/* pathName */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  34,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo m_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  22,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  35,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  168,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_union",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  171,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_union",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  167,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_union",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  170,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_union",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo s_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  183,                                 /* lineNo */
  12,                                  /* colNo */
  "",                                  /* aName */
  "uf_find_root",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo t_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  182,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "uf_find_root",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo u_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  182,                                 /* lineNo */
  20,                                  /* colNo */
  "",                                  /* aName */
  "uf_find_root",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo v_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  181,                                 /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "uf_find_root",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo w_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  21,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo x_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  42,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo y_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  108,                                 /* lineNo */
  47,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ab_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  108,                                 /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  99,                                  /* lineNo */
  21,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  95,                                  /* lineNo */
  73,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo db_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  95,                                  /* lineNo */
  57,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo eb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  95,                                  /* lineNo */
  32,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  95,                                  /* lineNo */
  18,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo gb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  134,                                 /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo emlrtDCI = { 69,    /* lineNo */
  37,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 69,  /* lineNo */
  37,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo hb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  130,                                 /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ib_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  86,                                  /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  238,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo lb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  235,                                 /* lineNo */
  35,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo mb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  62,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ob_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  62,                                  /* lineNo */
  67,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  62,                                  /* lineNo */
  55,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  62,                                  /* lineNo */
  46,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  234,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo tb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  233,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ub_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  232,                                 /* lineNo */
  28,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  228,                                 /* lineNo */
  31,                                  /* colNo */
  "",                                  /* aName */
  "fillRunVectors",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  48,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  52,                                  /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  52,                                  /* lineNo */
  27,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ac_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  46,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo c_emlrtDCI = { 55,  /* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo bc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  204,                                 /* lineNo */
  38,                                  /* colNo */
  "",                                  /* aName */
  "numberOfRuns",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  204,                                 /* lineNo */
  18,                                  /* colNo */
  "",                                  /* aName */
  "numberOfRuns",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = { 48,  /* lineNo */
  33,                                  /* colNo */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  4                                    /* checkKind */
};

static emlrtBCInfo dc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  198,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "numberOfRuns",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ec_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  59,                                  /* lineNo */
  52,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  73,                                  /* lineNo */
  82,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo gc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  63,                                  /* colNo */
  "",                                  /* aName */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo q_emlrtRTEI = { 23,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo r_emlrtRTEI = { 1, /* lineNo */
  15,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo s_emlrtRTEI = { 55,/* lineNo */
  1,                                   /* colNo */
  "intermediateLabelRuns",             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\+images\\+internal\\+coder\\intermediateLabelRuns.m"/* pName */
};

static emlrtRTEInfo t_emlrtRTEI = { 33,/* lineNo */
  5,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo u_emlrtRTEI = { 55,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo v_emlrtRTEI = { 69,/* lineNo */
  31,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo w_emlrtRTEI = { 70,/* lineNo */
  46,                                  /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo x_emlrtRTEI = { 70,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo y_emlrtRTEI = { 89,/* lineNo */
  1,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo ab_emlrtRTEI = { 11,/* lineNo */
  6,                                   /* colNo */
  "bwconncomp",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\bwconncomp.m"/* pName */
};

static emlrtRTEInfo bb_emlrtRTEI = { 39,/* lineNo */
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
  st.site = &j_emlrtRSI;
  b_st.site = &q_emlrtRSI;
  numRuns = 0;
  if ((varargin_1->size[0] != 0) && (varargin_1->size[1] != 0)) {
    i = varargin_1->size[1];
    for (firstRunOnThisColumn = 0; firstRunOnThisColumn < i;
         firstRunOnThisColumn++) {
      lastRunOnPreviousColumn = firstRunOnThisColumn + 1;
      if ((lastRunOnPreviousColumn < 1) || (lastRunOnPreviousColumn >
           varargin_1->size[1])) {
        emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1,
          varargin_1->size[1], &dc_emlrtBCI, &b_st);
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
            &cc_emlrtBCI, &b_st);
        }

        runCounter = k + 2;
        if ((runCounter < 1) || (runCounter > varargin_1->size[0])) {
          emlrtDynamicBoundsCheckR2012b(runCounter, 1, varargin_1->size[0],
            &cc_emlrtBCI, &b_st);
        }

        if (varargin_1->data[(runCounter + varargin_1->size[0] * (currentColumn
              - 1)) - 1]) {
          currentColumn = firstRunOnThisColumn + 1;
          if ((currentColumn < 1) || (currentColumn > varargin_1->size[1])) {
            emlrtDynamicBoundsCheckR2012b(currentColumn, 1, varargin_1->size[1],
              &bc_emlrtBCI, &b_st);
          }

          runCounter = k + 1;
          if ((runCounter < 1) || (runCounter > varargin_1->size[0])) {
            emlrtDynamicBoundsCheckR2012b(runCounter, 1, varargin_1->size[0],
              &bc_emlrtBCI, &b_st);
          }

          if (!varargin_1->data[(runCounter + varargin_1->size[0] *
                                 (currentColumn - 1)) - 1]) {
            numRuns++;
          }
        }
      }
    }
  }

  emxInit_int32_T(&st, &startRow, 1, &r_emlrtRTEI, true);
  emxInit_int32_T(&st, &endRow, 1, &r_emlrtRTEI, true);
  emxInit_int32_T(&st, &startCol, 1, &r_emlrtRTEI, true);
  if (numRuns == 0) {
    startRow->size[0] = 0;
    endRow->size[0] = 0;
    startCol->size[0] = 0;
    CC_RegionLengths->size[0] = 0;
  } else {
    if (numRuns < 0) {
      emlrtNonNegativeCheckR2012b(numRuns, &d_emlrtDCI, &st);
    }

    i = startRow->size[0];
    startRow->size[0] = numRuns;
    emxEnsureCapacity_int32_T(&st, startRow, i, &q_emlrtRTEI);
    i = endRow->size[0];
    endRow->size[0] = numRuns;
    emxEnsureCapacity_int32_T(&st, endRow, i, &q_emlrtRTEI);
    i = startCol->size[0];
    startCol->size[0] = numRuns;
    emxEnsureCapacity_int32_T(&st, startCol, i, &q_emlrtRTEI);
    b_st.site = &r_emlrtRSI;
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
              varargin_1->size[1], &vb_emlrtBCI, &b_st);
          }

          if ((row < 1) || (row > varargin_1->size[0])) {
            emlrtDynamicBoundsCheckR2012b(row, 1, varargin_1->size[0],
              &vb_emlrtBCI, &b_st);
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
              varargin_1->size[1], &ub_emlrtBCI, &b_st);
          }

          if (row > varargin_1->size[0]) {
            emlrtDynamicBoundsCheckR2012b(row, 1, varargin_1->size[0],
              &ub_emlrtBCI, &b_st);
          }

          if (varargin_1->data[(row + varargin_1->size[0] *
                                (lastRunOnPreviousColumn - 1)) - 1]) {
            if ((runCounter < 1) || (runCounter > startCol->size[0])) {
              emlrtDynamicBoundsCheckR2012b(runCounter, 1, startCol->size[0],
                &tb_emlrtBCI, &b_st);
            }

            startCol->data[runCounter - 1] = firstRunOnThisColumn + 1;
            if (runCounter > startRow->size[0]) {
              emlrtDynamicBoundsCheckR2012b(runCounter, 1, startRow->size[0],
                &sb_emlrtBCI, &b_st);
            }

            startRow->data[runCounter - 1] = row;
            exitg1 = false;
            while ((!exitg1) && (row <= currentColumn)) {
              lastRunOnPreviousColumn = firstRunOnThisColumn + 1;
              if ((lastRunOnPreviousColumn < 1) || (lastRunOnPreviousColumn >
                   varargin_1->size[1])) {
                emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1,
                  varargin_1->size[1], &lb_emlrtBCI, &b_st);
              }

              if ((row < 1) || (row > varargin_1->size[0])) {
                emlrtDynamicBoundsCheckR2012b(row, 1, varargin_1->size[0],
                  &lb_emlrtBCI, &b_st);
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
                &kb_emlrtBCI, &b_st);
            }

            endRow->data[runCounter - 1] = row - 1;
            runCounter++;
          }
        }
      }
    }

    i = CC_RegionLengths->size[0];
    CC_RegionLengths->size[0] = numRuns;
    emxEnsureCapacity_int32_T(&st, CC_RegionLengths, i, &s_emlrtRTEI);
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
        emlrtDynamicBoundsCheckR2012b(k, 1, startCol->size[0], &rb_emlrtBCI, &st);
      }

      i = startCol->data[k - 1];
      if (i == currentColumn + 1) {
        row = firstRunOnThisColumn;
        firstRunOnThisColumn = k;
        lastRunOnPreviousColumn = k - 1;
        if (k > startCol->size[0]) {
          emlrtDynamicBoundsCheckR2012b(k, 1, startCol->size[0], &jb_emlrtBCI,
            &st);
        }

        currentColumn = i;
      } else {
        if (k > startCol->size[0]) {
          emlrtDynamicBoundsCheckR2012b(k, 1, startCol->size[0], &mb_emlrtBCI,
            &st);
        }

        if (i > currentColumn + 1) {
          row = -1;
          lastRunOnPreviousColumn = -1;
          firstRunOnThisColumn = k;
          if (k > startCol->size[0]) {
            emlrtDynamicBoundsCheckR2012b(k, 1, startCol->size[0], &ib_emlrtBCI,
              &st);
          }

          currentColumn = i;
        }
      }

      if (row >= 0) {
        for (p = row; p <= lastRunOnPreviousColumn; p++) {
          if ((p < 1) || (p > startRow->size[0])) {
            emlrtDynamicBoundsCheckR2012b(p, 1, startRow->size[0], &eb_emlrtBCI,
              &st);
          }

          if (k > endRow->size[0]) {
            emlrtDynamicBoundsCheckR2012b(k, 1, endRow->size[0], &fb_emlrtBCI,
              &st);
          }

          if (endRow->data[k - 1] >= startRow->data[p - 1] - 1) {
            if (p > endRow->size[0]) {
              emlrtDynamicBoundsCheckR2012b(p, 1, endRow->size[0], &cb_emlrtBCI,
                &st);
            }

            if (k > startRow->size[0]) {
              emlrtDynamicBoundsCheckR2012b(k, 1, startRow->size[0],
                &db_emlrtBCI, &st);
            }

            if (startRow->data[k - 1] <= endRow->data[p - 1] + 1) {
              if (k > CC_RegionLengths->size[0]) {
                emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
                  &bb_emlrtBCI, &st);
              }

              i = CC_RegionLengths->data[k - 1];
              if (i == 0) {
                if (k > CC_RegionLengths->size[0]) {
                  emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
                    &w_emlrtBCI, &st);
                }

                if (p > CC_RegionLengths->size[0]) {
                  emlrtDynamicBoundsCheckR2012b(p, 1, CC_RegionLengths->size[0],
                    &x_emlrtBCI, &st);
                }

                CC_RegionLengths->data[k - 1] = CC_RegionLengths->data[p - 1];
                runCounter++;
              } else {
                if (p > CC_RegionLengths->size[0]) {
                  emlrtDynamicBoundsCheckR2012b(p, 1, CC_RegionLengths->size[0],
                    &y_emlrtBCI, &st);
                }

                if (k > CC_RegionLengths->size[0]) {
                  emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
                    &ab_emlrtBCI, &st);
                }

                if (i != CC_RegionLengths->data[p - 1]) {
                  b_st.site = &s_emlrtRSI;
                  c_st.site = &t_emlrtRSI;
                  root_k = k;
                  do {
                    exitg2 = 0;
                    if ((root_k < 1) || (root_k > CC_RegionLengths->size[0])) {
                      emlrtDynamicBoundsCheckR2012b(root_k, 1,
                        CC_RegionLengths->size[0], &v_emlrtBCI, &c_st);
                    }

                    i = CC_RegionLengths->data[root_k - 1];
                    if (root_k != i) {
                      if (root_k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_k, 1,
                          CC_RegionLengths->size[0], &t_emlrtBCI, &c_st);
                      }

                      if (root_k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_k, 1,
                          CC_RegionLengths->size[0], &u_emlrtBCI, &c_st);
                      }

                      if ((i < 1) || (i > CC_RegionLengths->size[0])) {
                        emlrtDynamicBoundsCheckR2012b(CC_RegionLengths->
                          data[root_k - 1], 1, CC_RegionLengths->size[0],
                          &u_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[root_k - 1] =
                        CC_RegionLengths->data[i - 1];
                      if (root_k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_k, 1,
                          CC_RegionLengths->size[0], &s_emlrtBCI, &c_st);
                      }

                      root_k = CC_RegionLengths->data[root_k - 1];
                    } else {
                      exitg2 = 1;
                    }
                  } while (exitg2 == 0);

                  c_st.site = &u_emlrtRSI;
                  root_p = p;
                  do {
                    exitg2 = 0;
                    if ((root_p < 1) || (root_p > CC_RegionLengths->size[0])) {
                      emlrtDynamicBoundsCheckR2012b(root_p, 1,
                        CC_RegionLengths->size[0], &v_emlrtBCI, &c_st);
                    }

                    i = CC_RegionLengths->data[root_p - 1];
                    if (root_p != i) {
                      if (root_p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_p, 1,
                          CC_RegionLengths->size[0], &t_emlrtBCI, &c_st);
                      }

                      if (root_p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_p, 1,
                          CC_RegionLengths->size[0], &u_emlrtBCI, &c_st);
                      }

                      if ((i < 1) || (i > CC_RegionLengths->size[0])) {
                        emlrtDynamicBoundsCheckR2012b(CC_RegionLengths->
                          data[root_p - 1], 1, CC_RegionLengths->size[0],
                          &u_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[root_p - 1] =
                        CC_RegionLengths->data[i - 1];
                      if (root_p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_p, 1,
                          CC_RegionLengths->size[0], &s_emlrtBCI, &c_st);
                      }

                      root_p = CC_RegionLengths->data[root_p - 1];
                    } else {
                      exitg2 = 1;
                    }
                  } while (exitg2 == 0);

                  if (root_k != root_p) {
                    c_st.site = &v_emlrtRSI;
                    if (root_p < root_k) {
                      if (root_k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_k, 1,
                          CC_RegionLengths->size[0], &q_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[root_k - 1] = root_p;
                      if (k > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(k, 1,
                          CC_RegionLengths->size[0], &o_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[k - 1] = root_p;
                    } else {
                      if (root_p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(root_p, 1,
                          CC_RegionLengths->size[0], &r_emlrtBCI, &c_st);
                      }

                      CC_RegionLengths->data[root_p - 1] = root_k;
                      if (p > CC_RegionLengths->size[0]) {
                        emlrtDynamicBoundsCheckR2012b(p, 1,
                          CC_RegionLengths->size[0], &p_emlrtBCI, &c_st);
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
          &hb_emlrtBCI, &st);
      }

      if (CC_RegionLengths->data[k - 1] == 0) {
        if (k > CC_RegionLengths->size[0]) {
          emlrtDynamicBoundsCheckR2012b(k, 1, CC_RegionLengths->size[0],
            &gb_emlrtBCI, &st);
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
    emxEnsureCapacity_int32_T(sp, CC_RegionLengths, i, &t_emlrtRTEI);
    CC_RegionLengths->data[0] = 0;
  } else {
    emxInit_int32_T(sp, &labelsRenumbered, 1, &bb_emlrtRTEI, true);
    i = labelsRenumbered->size[0];
    labelsRenumbered->size[0] = CC_RegionLengths->size[0];
    emxEnsureCapacity_int32_T(sp, labelsRenumbered, i, &r_emlrtRTEI);
    numComponents = 0.0;
    st.site = &k_emlrtRSI;
    for (k = 0; k < numRuns; k++) {
      i = k + 1;
      if (i > CC_RegionLengths->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, CC_RegionLengths->size[0],
          &ac_emlrtBCI, sp);
      }

      if (CC_RegionLengths->data[i - 1] == k + 1) {
        numComponents++;
        i = k + 1;
        if (i > labelsRenumbered->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, labelsRenumbered->size[0],
            &wb_emlrtBCI, sp);
        }

        labelsRenumbered->data[i - 1] = (int32_T)numComponents;
      }

      i = k + 1;
      if (i > labelsRenumbered->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, labelsRenumbered->size[0],
          &xb_emlrtBCI, sp);
      }

      lastRunOnPreviousColumn = k + 1;
      if (lastRunOnPreviousColumn > CC_RegionLengths->size[0]) {
        emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1,
          CC_RegionLengths->size[0], &yb_emlrtBCI, sp);
      }

      currentColumn = CC_RegionLengths->data[lastRunOnPreviousColumn - 1];
      if ((currentColumn < 1) || (currentColumn > labelsRenumbered->size[0])) {
        emlrtDynamicBoundsCheckR2012b(CC_RegionLengths->
          data[lastRunOnPreviousColumn - 1], 1, labelsRenumbered->size[0],
          &yb_emlrtBCI, sp);
      }

      labelsRenumbered->data[i - 1] = labelsRenumbered->data[currentColumn - 1];
    }

    i = (int32_T)numComponents;
    if (numComponents != i) {
      emlrtIntegerCheckR2012b(numComponents, &c_emlrtDCI, sp);
    }

    runCounter = (int32_T)numComponents;
    lastRunOnPreviousColumn = CC_RegionLengths->size[0];
    CC_RegionLengths->size[0] = (int32_T)numComponents;
    emxEnsureCapacity_int32_T(sp, CC_RegionLengths, lastRunOnPreviousColumn,
      &u_emlrtRTEI);
    if ((int32_T)numComponents != i) {
      emlrtIntegerCheckR2012b(numComponents, &c_emlrtDCI, sp);
    }

    for (i = 0; i < runCounter; i++) {
      CC_RegionLengths->data[i] = 0;
    }

    st.site = &l_emlrtRSI;
    for (k = 0; k < numRuns; k++) {
      i = k + 1;
      if (i > labelsRenumbered->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, labelsRenumbered->size[0],
          &ec_emlrtBCI, sp);
      }

      if (labelsRenumbered->data[k] > 0) {
        if ((labelsRenumbered->data[k] < 1) || (labelsRenumbered->data[k] >
             CC_RegionLengths->size[0])) {
          emlrtDynamicBoundsCheckR2012b(labelsRenumbered->data[k], 1,
            CC_RegionLengths->size[0], &nb_emlrtBCI, sp);
        }

        i = k + 1;
        if (i > startRow->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, startRow->size[0], &ob_emlrtBCI,
            sp);
        }

        lastRunOnPreviousColumn = k + 1;
        if (lastRunOnPreviousColumn > endRow->size[0]) {
          emlrtDynamicBoundsCheckR2012b(lastRunOnPreviousColumn, 1, endRow->
            size[0], &pb_emlrtBCI, sp);
        }

        if ((labelsRenumbered->data[k] < 1) || (labelsRenumbered->data[k] >
             CC_RegionLengths->size[0])) {
          emlrtDynamicBoundsCheckR2012b(labelsRenumbered->data[k], 1,
            CC_RegionLengths->size[0], &qb_emlrtBCI, sp);
        }

        CC_RegionLengths->data[labelsRenumbered->data[k] - 1] =
          ((CC_RegionLengths->data[labelsRenumbered->data[k] - 1] + endRow->
            data[lastRunOnPreviousColumn - 1]) - startRow->data[i - 1]) + 1;
      }
    }

    st.site = &m_emlrtRSI;
    b_st.site = &x_emlrtRSI;
    c_st.site = &y_emlrtRSI;
    currentColumn = CC_RegionLengths->size[0];
    if (CC_RegionLengths->size[0] == 0) {
      y = 0.0;
    } else {
      d_st.site = &ab_emlrtRSI;
      y = CC_RegionLengths->data[0];
      e_st.site = &bb_emlrtRSI;
      if (2 > CC_RegionLengths->size[0]) {
        overflow = false;
      } else {
        overflow = (CC_RegionLengths->size[0] > 2147483646);
      }

      if (overflow) {
        f_st.site = &w_emlrtRSI;
        check_forloop_overflow_error(&f_st);
      }

      for (k = 2; k <= currentColumn; k++) {
        y += (real_T)CC_RegionLengths->data[k - 1];
      }
    }

    if (!(y >= 0.0)) {
      emlrtNonNegativeCheckR2012b(y, &emlrtDCI, sp);
    }

    i = (int32_T)y;
    if (y != i) {
      emlrtIntegerCheckR2012b(y, &b_emlrtDCI, sp);
    }

    emxInit_int32_T(sp, &pixelIdxList, 1, &ab_emlrtRTEI, true);
    emxInit_int32_T(sp, &x, 1, &w_emlrtRTEI, true);
    lastRunOnPreviousColumn = pixelIdxList->size[0];
    pixelIdxList->size[0] = i;
    emxEnsureCapacity_int32_T(sp, pixelIdxList, lastRunOnPreviousColumn,
      &v_emlrtRTEI);
    st.site = &n_emlrtRSI;
    i = x->size[0];
    x->size[0] = CC_RegionLengths->size[0];
    emxEnsureCapacity_int32_T(&st, x, i, &w_emlrtRTEI);
    runCounter = CC_RegionLengths->size[0];
    for (i = 0; i < runCounter; i++) {
      x->data[i] = CC_RegionLengths->data[i];
    }

    b_st.site = &cb_emlrtRSI;
    currentColumn = 2;
    if (CC_RegionLengths->size[0] != 1) {
      currentColumn = 1;
    }

    c_st.site = &db_emlrtRSI;
    if (1 == currentColumn) {
      d_st.site = &eb_emlrtRSI;
      e_st.site = &fb_emlrtRSI;
      if ((CC_RegionLengths->size[0] != 0) && (CC_RegionLengths->size[0] != 1))
      {
        currentColumn = CC_RegionLengths->size[0];
        for (k = 0; k <= currentColumn - 2; k++) {
          x->data[k + 1] += x->data[k];
        }
      }
    }

    emxInit_int32_T(&c_st, &idxCount, 1, &x_emlrtRTEI, true);
    i = idxCount->size[0];
    idxCount->size[0] = x->size[0] + 1;
    emxEnsureCapacity_int32_T(sp, idxCount, i, &x_emlrtRTEI);
    idxCount->data[0] = 0;
    runCounter = x->size[0];
    for (i = 0; i < runCounter; i++) {
      idxCount->data[i + 1] = x->data[i];
    }

    emxFree_int32_T(&x);
    st.site = &o_emlrtRSI;
    for (k = 0; k < numRuns; k++) {
      i = k + 1;
      if (i > startCol->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, startCol->size[0], &fc_emlrtBCI, sp);
      }

      runCounter = (startCol->data[k] - 1) * varargin_1->size[0];
      i = k + 1;
      if (i > labelsRenumbered->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, labelsRenumbered->size[0],
          &n_emlrtBCI, sp);
      }

      row = labelsRenumbered->data[i - 1];
      if (labelsRenumbered->data[k] > 0) {
        i = k + 1;
        if (i > startRow->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, startRow->size[0], &m_emlrtBCI, sp);
        }

        lastRunOnPreviousColumn = startRow->data[i - 1];
        i = k + 1;
        if (i > endRow->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, endRow->size[0], &l_emlrtBCI, sp);
        }

        currentColumn = endRow->data[i - 1];
        st.site = &p_emlrtRSI;
        for (firstRunOnThisColumn = lastRunOnPreviousColumn;
             firstRunOnThisColumn <= currentColumn; firstRunOnThisColumn++) {
          if ((row < 1) || (row > idxCount->size[0])) {
            emlrtDynamicBoundsCheckR2012b(row, 1, idxCount->size[0],
              &gc_emlrtBCI, sp);
          }

          if (row > idxCount->size[0]) {
            emlrtDynamicBoundsCheckR2012b(row, 1, idxCount->size[0], &k_emlrtBCI,
              sp);
          }

          idxCount->data[row - 1]++;
          if (row > idxCount->size[0]) {
            emlrtDynamicBoundsCheckR2012b(row, 1, idxCount->size[0], &j_emlrtBCI,
              sp);
          }

          if ((idxCount->data[row - 1] < 1) || (idxCount->data[row - 1] >
               pixelIdxList->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxCount->data[row - 1], 1,
              pixelIdxList->size[0], &j_emlrtBCI, sp);
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
    emxEnsureCapacity_real_T(sp, CC_RegionIndices, i, &y_emlrtRTEI);
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
