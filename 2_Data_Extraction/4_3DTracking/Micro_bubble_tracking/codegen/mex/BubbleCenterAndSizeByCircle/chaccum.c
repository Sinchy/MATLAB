/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * chaccum.c
 *
 * Code generation for function 'chaccum'
 *
 */

/* Include files */
#include "chaccum.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "all.h"
#include "colon.h"
#include "eml_int_forloop_overflow_check.h"
#include "find.h"
#include "hypot.h"
#include "imfilter.h"
#include "multithresh.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "sub2ind.h"
#include "validatenonnan.h"
#include "validatepositive.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo q_emlrtRSI = { 6,   /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo r_emlrtRSI = { 12,  /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo s_emlrtRSI = { 24,  /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo t_emlrtRSI = { 28,  /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo u_emlrtRSI = { 31,  /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo v_emlrtRSI = { 32,  /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo w_emlrtRSI = { 36,  /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo x_emlrtRSI = { 76,  /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo y_emlrtRSI = { 136, /* lineNo */
  "chaccum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo ab_emlrtRSI = { 254,/* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo bb_emlrtRSI = { 251,/* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo cb_emlrtRSI = { 241,/* lineNo */
  "parseInputs",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo gb_emlrtRSI = { 216,/* lineNo */
  "getGrayImage",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo vb_emlrtRSI = { 174,/* lineNo */
  "imgradientlocal",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo wb_emlrtRSI = { 175,/* lineNo */
  "imgradientlocal",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo xb_emlrtRSI = { 178,/* lineNo */
  "imgradientlocal",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo dc_emlrtRSI = { 187,/* lineNo */
  "getEdgePixels",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo ec_emlrtRSI = { 190,/* lineNo */
  "getEdgePixels",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo fc_emlrtRSI = { 195,/* lineNo */
  "getEdgePixels",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtRSInfo fg_emlrtRSI = { 161,/* lineNo */
  "accumarraylocal",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pathName */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  109,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  162,                                 /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "accumarraylocal",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  162,                                 /* lineNo */
  28,                                  /* colNo */
  "",                                  /* aName */
  "accumarraylocal",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  108,                                 /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  131,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  131,                                 /* lineNo */
  36,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  130,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  130,                                 /* lineNo */
  61,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  104,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo m_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  104,                                 /* lineNo */
  29,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  129,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  129,                                 /* lineNo */
  61,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  127,                                 /* lineNo */
  38,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  43,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo s_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  127,                                 /* lineNo */
  16,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo t_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  107,                                 /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo u_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  77,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo v_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  102,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo w_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  102,                                 /* lineNo */
  43,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo x_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  102,                                 /* lineNo */
  107,                                 /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo y_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  102,                                 /* lineNo */
  77,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ab_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  85,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  85,                                  /* lineNo */
  27,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  84,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo db_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  84,                                  /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo eb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  83,                                  /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  83,                                  /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo gb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  12,                                  /* lineNo */
  22,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo k_emlrtRTEI = { 75,/* lineNo */
  9,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtBCInfo hb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  102,                                 /* lineNo */
  65,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ib_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  103,                                 /* lineNo */
  65,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  38,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  43,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo lb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  61,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo mb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  66,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  84,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ob_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  89,                                  /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  107,                                 /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  105,                                 /* lineNo */
  112,                                 /* colNo */
  "",                                  /* aName */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo emlrtECI = { 2,     /* nDims */
  136,                                 /* lineNo */
  19,                                  /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtBCInfo rb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  162,                                 /* lineNo */
  51,                                  /* colNo */
  "",                                  /* aName */
  "accumarraylocal",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo mg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  265,                                 /* lineNo */
  43,                                  /* colNo */
  "",                                  /* aName */
  "parseInputs",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo mb_emlrtRTEI = { 260,/* lineNo */
  1,                                   /* colNo */
  "parseInputs",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtBCInfo ng_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  260,                                 /* lineNo */
  90,                                  /* colNo */
  "",                                  /* aName */
  "parseInputs",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo nb_emlrtRTEI = { 244,/* lineNo */
  1,                                   /* colNo */
  "parseInputs",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo dc_emlrtRTEI = { 6,/* lineNo */
  2,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo ec_emlrtRTEI = { 12,/* lineNo */
  12,                                  /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo fc_emlrtRTEI = { 14,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo gc_emlrtRTEI = { 24,/* lineNo */
  1,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo hc_emlrtRTEI = { 16,/* lineNo */
  9,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo ic_emlrtRTEI = { 174,/* lineNo */
  1,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo jc_emlrtRTEI = { 175,/* lineNo */
  1,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo kc_emlrtRTEI = { 47,/* lineNo */
  9,                                   /* colNo */
  "div",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\div.m"/* pName */
};

static emlrtRTEInfo lc_emlrtRTEI = { 195,/* lineNo */
  17,                                  /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo mc_emlrtRTEI = { 38,/* lineNo */
  5,                                   /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo nc_emlrtRTEI = { 39,/* lineNo */
  5,                                   /* colNo */
  "find",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pName */
};

static emlrtRTEInfo oc_emlrtRTEI = { 32,/* lineNo */
  1,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo pc_emlrtRTEI = { 38,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo qc_emlrtRTEI = { 36,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo rc_emlrtRTEI = { 53,/* lineNo */
  9,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo sc_emlrtRTEI = { 73,/* lineNo */
  1,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo tc_emlrtRTEI = { 1,/* lineNo */
  39,                                  /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo uc_emlrtRTEI = { 98,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo vc_emlrtRTEI = { 136,/* lineNo */
  33,                                  /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo wc_emlrtRTEI = { 77,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo xc_emlrtRTEI = { 79,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo yc_emlrtRTEI = { 92,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo ad_emlrtRTEI = { 94,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo bd_emlrtRTEI = { 95,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo cd_emlrtRTEI = { 120,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo dd_emlrtRTEI = { 121,/* lineNo */
  5,                                   /* colNo */
  "chaccum",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\chaccum.m"/* pName */
};

static emlrtRTEInfo ed_emlrtRTEI = { 103,/* lineNo */
  9,                                   /* colNo */
  "colon",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pName */
};

/* Function Declarations */
static void parseInputs(const emlrtStack *sp, const emxArray_boolean_T
  *varargin_1, const real_T varargin_2_data[], int32_T varargin_2_size[2]);

/* Function Definitions */
static void parseInputs(const emlrtStack *sp, const emxArray_boolean_T
  *varargin_1, const real_T varargin_2_data[], int32_T varargin_2_size[2])
{
  boolean_T p;
  int32_T k;
  boolean_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &cb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b_st.site = &n_emlrtRSI;
  if ((varargin_1->size[0] == 0) || (varargin_1->size[1] == 0)) {
    emlrtErrorWithMessageIdR2018a(&b_st, &c_emlrtRTEI,
      "Coder:toolbox:ValidateattributesexpectedNonempty",
      "MATLAB:chaccum:expectedNonempty", 3, 4, 18, "input number 1, A,");
  }

  if ((varargin_1->size[0] == 1) || (varargin_1->size[1] == 1)) {
    emlrtErrorWithMessageIdR2018a(sp, &nb_emlrtRTEI,
      "images:imfindcircles:invalidInputImage",
      "images:imfindcircles:invalidInputImage", 0);
  }

  if (varargin_2_size[1] == 1) {
    st.site = &bb_emlrtRSI;
    b_st.site = &n_emlrtRSI;
    validatenonnan(&b_st, varargin_2_data, varargin_2_size);
    b_st.site = &n_emlrtRSI;
    validatepositive(&b_st, varargin_2_data, varargin_2_size);
    b_st.site = &n_emlrtRSI;
    p = true;
    k = 0;
    exitg1 = false;
    while ((!exitg1) && (k <= varargin_2_size[1] - 1)) {
      if ((!muDoubleScalarIsInf(varargin_2_data[k])) && (!muDoubleScalarIsNaN
           (varargin_2_data[k]))) {
        k++;
      } else {
        p = false;
        exitg1 = true;
      }
    }

    if (!p) {
      emlrtErrorWithMessageIdR2018a(&b_st, &emlrtRTEI,
        "Coder:toolbox:ValidateattributesexpectedFinite",
        "MATLAB:chaccum:expectedFinite", 3, 4, 29,
        "input number 2, RADIUS_RANGE,");
    }
  } else {
    st.site = &ab_emlrtRSI;
    b_st.site = &n_emlrtRSI;
    p = true;
    k = 0;
    exitg1 = false;
    while ((!exitg1) && (k <= varargin_2_size[1] - 1)) {
      if ((!muDoubleScalarIsInf(varargin_2_data[k])) && (!muDoubleScalarIsNaN
           (varargin_2_data[k])) && (muDoubleScalarFloor(varargin_2_data[k]) ==
           varargin_2_data[k])) {
        k++;
      } else {
        p = false;
        exitg1 = true;
      }
    }

    if (!p) {
      emlrtErrorWithMessageIdR2018a(&b_st, &i_emlrtRTEI,
        "Coder:toolbox:ValidateattributesexpectedInteger",
        "MATLAB:chaccum:expectedInteger", 3, 4, 29,
        "input number 2, RADIUS_RANGE,");
    }

    b_st.site = &n_emlrtRSI;
    validatenonnan(&b_st, varargin_2_data, varargin_2_size);
    b_st.site = &n_emlrtRSI;
    validatepositive(&b_st, varargin_2_data, varargin_2_size);
    b_st.site = &n_emlrtRSI;
    p = true;
    k = 0;
    exitg1 = false;
    while ((!exitg1) && (k <= varargin_2_size[1] - 1)) {
      if ((!muDoubleScalarIsInf(varargin_2_data[k])) && (!muDoubleScalarIsNaN
           (varargin_2_data[k]))) {
        k++;
      } else {
        p = false;
        exitg1 = true;
      }
    }

    if (!p) {
      emlrtErrorWithMessageIdR2018a(&b_st, &emlrtRTEI,
        "Coder:toolbox:ValidateattributesexpectedFinite",
        "MATLAB:chaccum:expectedFinite", 3, 4, 29,
        "input number 2, RADIUS_RANGE,");
    }
  }

  if (varargin_2_size[1] == 2) {
    k = varargin_2_size[1];
    if (2 > k) {
      emlrtDynamicBoundsCheckR2012b(2, 1, k, &ng_emlrtBCI, sp);
    }

    if (varargin_2_data[0] > varargin_2_data[1]) {
      emlrtErrorWithMessageIdR2018a(sp, &mb_emlrtRTEI,
        "images:imfindcircles:invalidRadiusRange",
        "images:imfindcircles:invalidRadiusRange", 0);
    }
  }

  if (varargin_2_size[1] == 2) {
    k = varargin_2_size[1];
    if (2 > k) {
      emlrtDynamicBoundsCheckR2012b(2, 1, k, &mg_emlrtBCI, sp);
    }

    if (varargin_2_data[0] == varargin_2_data[1]) {
      varargin_2_size[0] = 1;
      varargin_2_size[1] = 1;
    }
  } else {
    varargin_2_size[0] = 1;
    varargin_2_size[1] = 1;
  }
}

void chaccum(const emlrtStack *sp, const emxArray_boolean_T *varargin_1, const
             real_T varargin_2_data[], const int32_T varargin_2_size[2],
             emxArray_creal_T *accumMatrix, emxArray_real32_T *gradientImg)
{
  emxArray_boolean_T *inside;
  int32_T i;
  int32_T n;
  int32_T radiusRangeIn_size[2];
  real_T radiusRangeIn_data[2];
  emxArray_boolean_T *rows_to_keep;
  boolean_T flat;
  emxArray_real32_T *A;
  emxArray_real32_T *Gx;
  emxArray_real32_T *Gy;
  real32_T Gmax;
  int32_T idx;
  emxArray_real32_T *yc;
  int32_T idxEdge;
  int32_T k;
  boolean_T exitg1;
  real32_T edgeThresh;
  emxArray_int32_T *xckeep;
  emxArray_int32_T *yckeep;
  emxArray_real_T *Ey;
  emxArray_real_T *Ex;
  emxArray_int32_T *idxE;
  emxArray_real_T *radiusRange;
  emxArray_real_T *w0;
  real_T xcStep;
  int32_T N;
  int32_T M;
  int32_T i1;
  emxArray_real_T *Ex_chunk;
  int32_T i2;
  emxArray_int32_T *idxE_chunk;
  int32_T sz_idx_0;
  emxArray_real_T *w;
  int32_T sz_idx_1;
  emxArray_creal_T *r;
  int32_T loop_ub;
  emxArray_real_T *r1;
  int32_T b_i;
  real_T c_i;
  int32_T i3;
  int32_T idxkeep;
  int32_T i4;
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
  emxInit_boolean_T(sp, &inside, 2, &bd_emlrtRTEI, true);
  i = inside->size[0] * inside->size[1];
  inside->size[0] = varargin_1->size[0];
  inside->size[1] = varargin_1->size[1];
  emxEnsureCapacity_boolean_T(sp, inside, i, &dc_emlrtRTEI);
  n = varargin_1->size[0] * varargin_1->size[1];
  for (i = 0; i < n; i++) {
    inside->data[i] = varargin_1->data[i];
  }

  radiusRangeIn_size[0] = 1;
  radiusRangeIn_size[1] = varargin_2_size[1];
  n = varargin_2_size[0] * varargin_2_size[1];
  if (0 <= n - 1) {
    memcpy(&radiusRangeIn_data[0], &varargin_2_data[0], n * sizeof(real_T));
  }

  st.site = &q_emlrtRSI;
  parseInputs(&st, inside, radiusRangeIn_data, radiusRangeIn_size);
  i = inside->size[0] * inside->size[1];
  if (1 > i) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i, &gb_emlrtBCI, sp);
  }

  emxInit_boolean_T(sp, &rows_to_keep, 1, &uc_emlrtRTEI, true);
  n = inside->size[0] * inside->size[1];
  i = rows_to_keep->size[0];
  rows_to_keep->size[0] = n;
  emxEnsureCapacity_boolean_T(sp, rows_to_keep, i, &ec_emlrtRTEI);
  for (i = 0; i < n; i++) {
    rows_to_keep->data[i] = (inside->data[i] == inside->data[0]);
  }

  st.site = &r_emlrtRSI;
  flat = all(&st, rows_to_keep);
  if (flat) {
    i = accumMatrix->size[0] * accumMatrix->size[1];
    accumMatrix->size[0] = inside->size[0];
    accumMatrix->size[1] = inside->size[1];
    emxEnsureCapacity_creal_T(sp, accumMatrix, i, &fc_emlrtRTEI);
    n = inside->size[0] * inside->size[1];
    for (i = 0; i < n; i++) {
      accumMatrix->data[i].re = 0.0;
      accumMatrix->data[i].im = 0.0;
    }

    i = gradientImg->size[0] * gradientImg->size[1];
    gradientImg->size[0] = inside->size[0];
    gradientImg->size[1] = inside->size[1];
    emxEnsureCapacity_real32_T(sp, gradientImg, i, &hc_emlrtRTEI);
    n = inside->size[0] * inside->size[1];
    for (i = 0; i < n; i++) {
      gradientImg->data[i] = 0.0F;
    }
  } else {
    emxInit_real32_T(sp, &A, 2, &dc_emlrtRTEI, true);
    st.site = &s_emlrtRSI;
    i = A->size[0] * A->size[1];
    A->size[0] = inside->size[0];
    A->size[1] = inside->size[1];
    emxEnsureCapacity_real32_T(&st, A, i, &gc_emlrtRTEI);
    n = inside->size[0] * inside->size[1];
    for (i = 0; i < n; i++) {
      A->data[i] = inside->data[i];
    }

    emxInit_real32_T(&st, &Gx, 2, &tc_emlrtRTEI, true);
    b_st.site = &gb_emlrtRSI;
    imfilter(&b_st, A);
    st.site = &t_emlrtRSI;
    i = Gx->size[0] * Gx->size[1];
    Gx->size[0] = A->size[0];
    Gx->size[1] = A->size[1];
    emxEnsureCapacity_real32_T(&st, Gx, i, &ic_emlrtRTEI);
    n = A->size[0] * A->size[1];
    for (i = 0; i < n; i++) {
      Gx->data[i] = A->data[i];
    }

    emxInit_real32_T(&st, &Gy, 2, &tc_emlrtRTEI, true);
    b_st.site = &vb_emlrtRSI;
    b_imfilter(&b_st, Gx);
    i = Gy->size[0] * Gy->size[1];
    Gy->size[0] = A->size[0];
    Gy->size[1] = A->size[1];
    emxEnsureCapacity_real32_T(&st, Gy, i, &jc_emlrtRTEI);
    n = A->size[0] * A->size[1];
    for (i = 0; i < n; i++) {
      Gy->data[i] = A->data[i];
    }

    b_st.site = &wb_emlrtRSI;
    c_imfilter(&b_st, Gy);
    b_st.site = &xb_emlrtRSI;
    b_hypot(&b_st, Gx, Gy, gradientImg);
    st.site = &u_emlrtRSI;
    b_st.site = &dc_emlrtRSI;
    c_st.site = &gc_emlrtRSI;
    d_st.site = &hc_emlrtRSI;
    e_st.site = &ic_emlrtRSI;
    if (gradientImg->size[0] * gradientImg->size[1] < 1) {
      emlrtErrorWithMessageIdR2018a(&e_st, &m_emlrtRTEI,
        "Coder:toolbox:eml_min_or_max_varDimZero",
        "Coder:toolbox:eml_min_or_max_varDimZero", 0);
    }

    f_st.site = &jc_emlrtRSI;
    g_st.site = &kc_emlrtRSI;
    n = gradientImg->size[0] * gradientImg->size[1];
    if (gradientImg->size[0] * gradientImg->size[1] <= 2) {
      if (gradientImg->size[0] * gradientImg->size[1] == 1) {
        Gmax = gradientImg->data[0];
      } else if ((gradientImg->data[0] < gradientImg->data[1]) ||
                 (muSingleScalarIsNaN(gradientImg->data[0]) &&
                  (!muSingleScalarIsNaN(gradientImg->data[1])))) {
        Gmax = gradientImg->data[1];
      } else {
        Gmax = gradientImg->data[0];
      }
    } else {
      h_st.site = &mc_emlrtRSI;
      if (!muSingleScalarIsNaN(gradientImg->data[0])) {
        idx = 1;
      } else {
        idx = 0;
        i_st.site = &pb_emlrtRSI;
        if (2 > gradientImg->size[0] * gradientImg->size[1]) {
          flat = false;
        } else {
          flat = (gradientImg->size[0] * gradientImg->size[1] > 2147483646);
        }

        if (flat) {
          j_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&j_st);
        }

        k = 2;
        exitg1 = false;
        while ((!exitg1) && (k <= gradientImg->size[0] * gradientImg->size[1]))
        {
          if (!muSingleScalarIsNaN(gradientImg->data[k - 1])) {
            idx = k;
            exitg1 = true;
          } else {
            k++;
          }
        }
      }

      if (idx == 0) {
        Gmax = gradientImg->data[0];
      } else {
        h_st.site = &lc_emlrtRSI;
        Gmax = gradientImg->data[idx - 1];
        idxEdge = idx + 1;
        i_st.site = &qb_emlrtRSI;
        if (idx + 1 > gradientImg->size[0] * gradientImg->size[1]) {
          flat = false;
        } else {
          flat = (gradientImg->size[0] * gradientImg->size[1] > 2147483646);
        }

        if (flat) {
          j_st.site = &fb_emlrtRSI;
          check_forloop_overflow_error(&j_st);
        }

        for (k = idxEdge; k <= n; k++) {
          if (Gmax < gradientImg->data[k - 1]) {
            Gmax = gradientImg->data[k - 1];
          }
        }
      }
    }

    emxInit_real32_T(&g_st, &yc, 2, &yc_emlrtRTEI, true);
    i = yc->size[0] * yc->size[1];
    yc->size[0] = gradientImg->size[0];
    yc->size[1] = gradientImg->size[1];
    emxEnsureCapacity_real32_T(&st, yc, i, &kc_emlrtRTEI);
    n = gradientImg->size[0] * gradientImg->size[1];
    for (i = 0; i < n; i++) {
      yc->data[i] = gradientImg->data[i] / Gmax;
    }

    b_st.site = &ec_emlrtRSI;
    edgeThresh = multithresh(&b_st, yc);
    Gmax *= edgeThresh;
    b_st.site = &fc_emlrtRSI;
    i = inside->size[0] * inside->size[1];
    inside->size[0] = gradientImg->size[0];
    inside->size[1] = gradientImg->size[1];
    emxEnsureCapacity_boolean_T(&b_st, inside, i, &lc_emlrtRTEI);
    n = gradientImg->size[0] * gradientImg->size[1];
    for (i = 0; i < n; i++) {
      inside->data[i] = (gradientImg->data[i] > Gmax);
    }

    emxInit_int32_T(&b_st, &xckeep, 1, &cd_emlrtRTEI, true);
    emxInit_int32_T(&b_st, &yckeep, 1, &dd_emlrtRTEI, true);
    emxInit_real_T(&b_st, &Ey, 1, &tc_emlrtRTEI, true);
    c_st.site = &sf_emlrtRSI;
    eml_find(&c_st, inside, xckeep, yckeep);
    i = Ey->size[0];
    Ey->size[0] = xckeep->size[0];
    emxEnsureCapacity_real_T(&b_st, Ey, i, &mc_emlrtRTEI);
    n = xckeep->size[0];
    for (i = 0; i < n; i++) {
      Ey->data[i] = xckeep->data[i];
    }

    emxInit_real_T(&b_st, &Ex, 1, &tc_emlrtRTEI, true);
    i = Ex->size[0];
    Ex->size[0] = yckeep->size[0];
    emxEnsureCapacity_real_T(&b_st, Ex, i, &nc_emlrtRTEI);
    n = yckeep->size[0];
    for (i = 0; i < n; i++) {
      Ex->data[i] = yckeep->data[i];
    }

    emxInit_int32_T(&b_st, &idxE, 1, &oc_emlrtRTEI, true);
    st.site = &v_emlrtRSI;
    b_st.site = &xf_emlrtRSI;
    eml_sub2ind(&b_st, *(int32_T (*)[2])gradientImg->size, Ey, Ex, xckeep);
    i = idxE->size[0];
    idxE->size[0] = xckeep->size[0];
    emxEnsureCapacity_int32_T(&st, idxE, i, &oc_emlrtRTEI);
    n = xckeep->size[0];
    for (i = 0; i < n; i++) {
      idxE->data[i] = xckeep->data[i];
    }

    emxInit_real_T(sp, &radiusRange, 2, &qc_emlrtRTEI, true);
    if (radiusRangeIn_size[1] > 1) {
      st.site = &w_emlrtRSI;
      if (muDoubleScalarIsNaN(radiusRangeIn_data[0]) || muDoubleScalarIsNaN
          (radiusRangeIn_data[1])) {
        i = radiusRange->size[0] * radiusRange->size[1];
        radiusRange->size[0] = 1;
        radiusRange->size[1] = 1;
        emxEnsureCapacity_real_T(&st, radiusRange, i, &qc_emlrtRTEI);
        radiusRange->data[0] = rtNaN;
      } else if (radiusRangeIn_data[1] < radiusRangeIn_data[0]) {
        radiusRange->size[0] = 1;
        radiusRange->size[1] = 0;
      } else if ((muDoubleScalarIsInf(radiusRangeIn_data[0]) ||
                  muDoubleScalarIsInf(radiusRangeIn_data[1])) &&
                 (radiusRangeIn_data[0] == radiusRangeIn_data[1])) {
        i = radiusRange->size[0] * radiusRange->size[1];
        radiusRange->size[0] = 1;
        radiusRange->size[1] = 1;
        emxEnsureCapacity_real_T(&st, radiusRange, i, &qc_emlrtRTEI);
        radiusRange->data[0] = rtNaN;
      } else {
        b_st.site = &bg_emlrtRSI;
        eml_float_colon(&b_st, radiusRangeIn_data[0], radiusRangeIn_data[1],
                        radiusRange);
      }
    } else {
      i = radiusRange->size[0] * radiusRange->size[1];
      radiusRange->size[0] = 1;
      radiusRange->size[1] = 1;
      emxEnsureCapacity_real_T(sp, radiusRange, i, &pc_emlrtRTEI);
      radiusRange->data[0] = radiusRangeIn_data[0];
    }

    emxInit_real_T(sp, &w0, 2, &rc_emlrtRTEI, true);
    i = w0->size[0] * w0->size[1];
    w0->size[0] = 1;
    w0->size[1] = radiusRange->size[1];
    emxEnsureCapacity_real_T(sp, w0, i, &rc_emlrtRTEI);
    n = radiusRange->size[0] * radiusRange->size[1];
    for (i = 0; i < n; i++) {
      w0->data[i] = 1.0 / (6.2831853071795862 * radiusRange->data[i]);
    }

    xcStep = muDoubleScalarFloor(1.0E+6 / (real_T)radiusRange->size[1]);
    N = A->size[1];
    M = A->size[0];
    i = accumMatrix->size[0] * accumMatrix->size[1];
    accumMatrix->size[0] = A->size[0];
    accumMatrix->size[1] = A->size[1];
    emxEnsureCapacity_creal_T(sp, accumMatrix, i, &sc_emlrtRTEI);
    n = A->size[0] * A->size[1];
    for (i = 0; i < n; i++) {
      accumMatrix->data[i].re = 0.0;
      accumMatrix->data[i].im = 0.0;
    }

    i = (int32_T)(((real_T)Ex->size[0] + (xcStep - 1.0)) / xcStep);
    emlrtForLoopVectorCheckR2012b(1.0, xcStep, Ex->size[0], mxDOUBLE_CLASS, i,
      &k_emlrtRTEI, sp);
    if (0 <= i - 1) {
      i1 = radiusRange->size[1];
      i2 = radiusRange->size[1];
      sz_idx_0 = A->size[0];
      sz_idx_1 = A->size[1];
      loop_ub = A->size[0] * A->size[1];
    }

    emxInit_real_T(sp, &Ex_chunk, 1, &wc_emlrtRTEI, true);
    emxInit_int32_T(sp, &idxE_chunk, 1, &xc_emlrtRTEI, true);
    emxInit_real_T(sp, &w, 2, &ad_emlrtRTEI, true);
    emxInit_creal_T(sp, &r, 2, &tc_emlrtRTEI, true);
    emxInit_real_T(sp, &r1, 2, &ed_emlrtRTEI, true);
    for (b_i = 0; b_i < i; b_i++) {
      c_i = (real_T)b_i * xcStep + 1.0;
      n = (int32_T)muDoubleScalarMin((c_i + xcStep) - 1.0, Ex->size[0]);
      st.site = &x_emlrtRSI;
      b_st.site = &eg_emlrtRSI;
      if (muDoubleScalarIsNaN(c_i)) {
        n = 1;
      } else if (n < c_i) {
        n = 0;
      } else if (c_i == c_i) {
        n = (int32_T)((real_T)n - c_i) + 1;
      } else {
        c_st.site = &bg_emlrtRSI;
        b_eml_float_colon(&c_st, c_i, n, r1);
        n = r1->size[1];
      }

      i3 = Ex_chunk->size[0];
      Ex_chunk->size[0] = n;
      emxEnsureCapacity_real_T(sp, Ex_chunk, i3, &tc_emlrtRTEI);
      i3 = xckeep->size[0];
      xckeep->size[0] = n;
      emxEnsureCapacity_int32_T(sp, xckeep, i3, &tc_emlrtRTEI);
      i3 = idxE_chunk->size[0];
      idxE_chunk->size[0] = n;
      emxEnsureCapacity_int32_T(sp, idxE_chunk, i3, &tc_emlrtRTEI);
      idxEdge = (int32_T)c_i;
      for (idx = 0; idx < n; idx++) {
        i3 = idx + 1;
        if ((i3 < 1) || (i3 > Ex_chunk->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, Ex_chunk->size[0], &eb_emlrtBCI,
            sp);
        }

        if ((idxEdge < 1) || (idxEdge > Ex->size[0])) {
          emlrtDynamicBoundsCheckR2012b(idxEdge, 1, Ex->size[0], &fb_emlrtBCI,
            sp);
        }

        Ex_chunk->data[i3 - 1] = Ex->data[idxEdge - 1];
        i3 = idx + 1;
        if ((i3 < 1) || (i3 > xckeep->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, xckeep->size[0], &cb_emlrtBCI, sp);
        }

        if (idxEdge > Ey->size[0]) {
          emlrtDynamicBoundsCheckR2012b(idxEdge, 1, Ey->size[0], &db_emlrtBCI,
            sp);
        }

        xckeep->data[i3 - 1] = (int32_T)Ey->data[idxEdge - 1];
        i3 = idx + 1;
        if ((i3 < 1) || (i3 > idxE_chunk->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, idxE_chunk->size[0], &ab_emlrtBCI,
            sp);
        }

        if (idxEdge > idxE->size[0]) {
          emlrtDynamicBoundsCheckR2012b(idxEdge, 1, idxE->size[0], &bb_emlrtBCI,
            sp);
        }

        idxE_chunk->data[i3 - 1] = idxE->data[idxEdge - 1];
        idxEdge++;
      }

      i3 = A->size[0] * A->size[1];
      A->size[0] = idxE_chunk->size[0];
      A->size[1] = radiusRange->size[1];
      emxEnsureCapacity_real32_T(sp, A, i3, &tc_emlrtRTEI);
      i3 = yc->size[0] * yc->size[1];
      yc->size[0] = idxE_chunk->size[0];
      yc->size[1] = radiusRange->size[1];
      emxEnsureCapacity_real32_T(sp, yc, i3, &tc_emlrtRTEI);
      i3 = w->size[0] * w->size[1];
      w->size[0] = idxE_chunk->size[0];
      w->size[1] = radiusRange->size[1];
      emxEnsureCapacity_real_T(sp, w, i3, &tc_emlrtRTEI);
      i3 = inside->size[0] * inside->size[1];
      inside->size[0] = idxE_chunk->size[0];
      inside->size[1] = radiusRange->size[1];
      emxEnsureCapacity_boolean_T(sp, inside, i3, &tc_emlrtRTEI);
      i3 = rows_to_keep->size[0];
      rows_to_keep->size[0] = idxE_chunk->size[0];
      emxEnsureCapacity_boolean_T(sp, rows_to_keep, i3, &uc_emlrtRTEI);
      n = idxE_chunk->size[0];
      for (i3 = 0; i3 < n; i3++) {
        rows_to_keep->data[i3] = false;
      }

      for (n = 0; n < i1; n++) {
        i3 = idxE_chunk->size[0];
        for (idx = 0; idx < i3; idx++) {
          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > idxE_chunk->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, idxE_chunk->size[0],
              &y_emlrtBCI, sp);
          }

          k = Gx->size[0] * Gx->size[1];
          idxEdge = idxE_chunk->data[idxEdge - 1];
          if ((idxEdge < 1) || (idxEdge > k)) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, k, &y_emlrtBCI, sp);
          }

          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > idxE_chunk->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, idxE_chunk->size[0],
              &x_emlrtBCI, sp);
          }

          k = gradientImg->size[0] * gradientImg->size[1];
          idxEdge = idxE_chunk->data[idxEdge - 1];
          if ((idxEdge < 1) || (idxEdge > k)) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, k, &x_emlrtBCI, sp);
          }

          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > radiusRange->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, radiusRange->size[1],
              &hb_emlrtBCI, sp);
          }

          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > Ex_chunk->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, Ex_chunk->size[0],
              &w_emlrtBCI, sp);
          }

          Gmax = (real32_T)Ex_chunk->data[idxEdge - 1] + (real32_T)
            -radiusRange->data[n] * (Gx->data[idxE_chunk->data[idx] - 1] /
            gradientImg->data[idxE_chunk->data[idx] - 1]);
          if (Gmax > 0.0F) {
            idxEdge = n + 1;
            if ((idxEdge < 1) || (idxEdge > A->size[1])) {
              emlrtDynamicBoundsCheckR2012b(idxEdge, 1, A->size[1], &v_emlrtBCI,
                sp);
            }

            k = idx + 1;
            if ((k < 1) || (k > A->size[0])) {
              emlrtDynamicBoundsCheckR2012b(k, 1, A->size[0], &v_emlrtBCI, sp);
            }

            A->data[(k + A->size[0] * (idxEdge - 1)) - 1] = Gmax + 0.5F;
          } else if (Gmax < 0.0F) {
            idxEdge = n + 1;
            if ((idxEdge < 1) || (idxEdge > A->size[1])) {
              emlrtDynamicBoundsCheckR2012b(idxEdge, 1, A->size[1], &v_emlrtBCI,
                sp);
            }

            k = idx + 1;
            if ((k < 1) || (k > A->size[0])) {
              emlrtDynamicBoundsCheckR2012b(k, 1, A->size[0], &v_emlrtBCI, sp);
            }

            A->data[(k + A->size[0] * (idxEdge - 1)) - 1] = Gmax - 0.5F;
          } else {
            idxEdge = n + 1;
            if ((idxEdge < 1) || (idxEdge > A->size[1])) {
              emlrtDynamicBoundsCheckR2012b(idxEdge, 1, A->size[1], &v_emlrtBCI,
                sp);
            }

            k = idx + 1;
            if ((k < 1) || (k > A->size[0])) {
              emlrtDynamicBoundsCheckR2012b(k, 1, A->size[0], &v_emlrtBCI, sp);
            }

            A->data[(k + A->size[0] * (idxEdge - 1)) - 1] = 0.0F;
          }

          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > idxE_chunk->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, idxE_chunk->size[0],
              &u_emlrtBCI, sp);
          }

          k = Gy->size[0] * Gy->size[1];
          idxEdge = idxE_chunk->data[idxEdge - 1];
          if ((idxEdge < 1) || (idxEdge > k)) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, k, &u_emlrtBCI, sp);
          }

          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > idxE_chunk->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, idxE_chunk->size[0],
              &t_emlrtBCI, sp);
          }

          k = gradientImg->size[0] * gradientImg->size[1];
          idxEdge = idxE_chunk->data[idxEdge - 1];
          if ((idxEdge < 1) || (idxEdge > k)) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, k, &t_emlrtBCI, sp);
          }

          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > radiusRange->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, radiusRange->size[1],
              &ib_emlrtBCI, sp);
          }

          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > xckeep->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, xckeep->size[0],
              &r_emlrtBCI, sp);
          }

          Gmax = (real32_T)xckeep->data[idxEdge - 1] + (real32_T)
            -radiusRange->data[n] * (Gy->data[idxE_chunk->data[idx] - 1] /
            gradientImg->data[idxE_chunk->data[idx] - 1]);
          if (Gmax > 0.0F) {
            idxEdge = n + 1;
            if ((idxEdge < 1) || (idxEdge > yc->size[1])) {
              emlrtDynamicBoundsCheckR2012b(idxEdge, 1, yc->size[1], &p_emlrtBCI,
                sp);
            }

            k = idx + 1;
            if ((k < 1) || (k > yc->size[0])) {
              emlrtDynamicBoundsCheckR2012b(k, 1, yc->size[0], &p_emlrtBCI, sp);
            }

            yc->data[(k + yc->size[0] * (idxEdge - 1)) - 1] = Gmax + 0.5F;
          } else if (Gmax < 0.0F) {
            idxEdge = n + 1;
            if ((idxEdge < 1) || (idxEdge > yc->size[1])) {
              emlrtDynamicBoundsCheckR2012b(idxEdge, 1, yc->size[1], &p_emlrtBCI,
                sp);
            }

            k = idx + 1;
            if ((k < 1) || (k > yc->size[0])) {
              emlrtDynamicBoundsCheckR2012b(k, 1, yc->size[0], &p_emlrtBCI, sp);
            }

            yc->data[(k + yc->size[0] * (idxEdge - 1)) - 1] = Gmax - 0.5F;
          } else {
            idxEdge = n + 1;
            if ((idxEdge < 1) || (idxEdge > yc->size[1])) {
              emlrtDynamicBoundsCheckR2012b(idxEdge, 1, yc->size[1], &p_emlrtBCI,
                sp);
            }

            k = idx + 1;
            if ((k < 1) || (k > yc->size[0])) {
              emlrtDynamicBoundsCheckR2012b(k, 1, yc->size[0], &p_emlrtBCI, sp);
            }

            yc->data[(k + yc->size[0] * (idxEdge - 1)) - 1] = 0.0F;
          }

          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > w->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, w->size[1], &l_emlrtBCI,
              sp);
          }

          k = idx + 1;
          if ((k < 1) || (k > w->size[0])) {
            emlrtDynamicBoundsCheckR2012b(k, 1, w->size[0], &l_emlrtBCI, sp);
          }

          i4 = n + 1;
          if ((i4 < 1) || (i4 > w0->size[1])) {
            emlrtDynamicBoundsCheckR2012b(i4, 1, w0->size[1], &m_emlrtBCI, sp);
          }

          w->data[(k + w->size[0] * (idxEdge - 1)) - 1] = w0->data[i4 - 1];
          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > A->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, A->size[0], &jb_emlrtBCI,
              sp);
          }

          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > A->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, A->size[1], &kb_emlrtBCI,
              sp);
          }

          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > A->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, A->size[0], &lb_emlrtBCI,
              sp);
          }

          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > A->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, A->size[1], &mb_emlrtBCI,
              sp);
          }

          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > yc->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, yc->size[0], &nb_emlrtBCI,
              sp);
          }

          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > yc->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, yc->size[1], &ob_emlrtBCI,
              sp);
          }

          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > yc->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, yc->size[0], &pb_emlrtBCI,
              sp);
          }

          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > yc->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, yc->size[1], &qb_emlrtBCI,
              sp);
          }

          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > inside->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, inside->size[1],
              &g_emlrtBCI, sp);
          }

          k = idx + 1;
          if ((k < 1) || (k > inside->size[0])) {
            emlrtDynamicBoundsCheckR2012b(k, 1, inside->size[0], &g_emlrtBCI, sp);
          }

          inside->data[(k + inside->size[0] * (idxEdge - 1)) - 1] = ((A->
            data[idx + A->size[0] * n] >= 1.0F) && ((real_T)A->data[idx +
            A->size[0] * n] <= N) && (yc->data[idx + yc->size[0] * n] >= 1.0F) &&
            ((real_T)yc->data[idx + yc->size[0] * n] < M));
          idxEdge = n + 1;
          if ((idxEdge < 1) || (idxEdge > inside->size[1])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, inside->size[1],
              &f_emlrtBCI, sp);
          }

          k = idx + 1;
          if ((k < 1) || (k > inside->size[0])) {
            emlrtDynamicBoundsCheckR2012b(k, 1, inside->size[0], &f_emlrtBCI, sp);
          }

          if (inside->data[(k + inside->size[0] * (idxEdge - 1)) - 1]) {
            idxEdge = idx + 1;
            if ((idxEdge < 1) || (idxEdge > rows_to_keep->size[0])) {
              emlrtDynamicBoundsCheckR2012b(idxEdge, 1, rows_to_keep->size[0],
                &c_emlrtBCI, sp);
            }

            rows_to_keep->data[idxEdge - 1] = true;
          }
        }
      }

      i3 = xckeep->size[0];
      xckeep->size[0] = A->size[0] * A->size[1];
      emxEnsureCapacity_int32_T(sp, xckeep, i3, &tc_emlrtRTEI);
      i3 = yckeep->size[0];
      yckeep->size[0] = yc->size[0] * yc->size[1];
      emxEnsureCapacity_int32_T(sp, yckeep, i3, &tc_emlrtRTEI);
      i3 = Ex_chunk->size[0];
      Ex_chunk->size[0] = w->size[0] * w->size[1];
      emxEnsureCapacity_real_T(sp, Ex_chunk, i3, &tc_emlrtRTEI);
      idxkeep = 0;
      for (n = 0; n < i2; n++) {
        i3 = idxE_chunk->size[0];
        for (idx = 0; idx < i3; idx++) {
          idxEdge = idx + 1;
          if ((idxEdge < 1) || (idxEdge > rows_to_keep->size[0])) {
            emlrtDynamicBoundsCheckR2012b(idxEdge, 1, rows_to_keep->size[0],
              &s_emlrtBCI, sp);
          }

          if (rows_to_keep->data[idxEdge - 1]) {
            idxEdge = n + 1;
            if ((idxEdge < 1) || (idxEdge > inside->size[1])) {
              emlrtDynamicBoundsCheckR2012b(idxEdge, 1, inside->size[1],
                &q_emlrtBCI, sp);
            }

            k = idx + 1;
            if ((k < 1) || (k > inside->size[0])) {
              emlrtDynamicBoundsCheckR2012b(k, 1, inside->size[0], &q_emlrtBCI,
                sp);
            }

            if (inside->data[(k + inside->size[0] * (idxEdge - 1)) - 1]) {
              idxkeep++;
              if ((idxkeep < 1) || (idxkeep > xckeep->size[0])) {
                emlrtDynamicBoundsCheckR2012b(idxkeep, 1, xckeep->size[0],
                  &n_emlrtBCI, sp);
              }

              idxEdge = n + 1;
              if ((idxEdge < 1) || (idxEdge > A->size[1])) {
                emlrtDynamicBoundsCheckR2012b(idxEdge, 1, A->size[1],
                  &o_emlrtBCI, sp);
              }

              k = idx + 1;
              if ((k < 1) || (k > A->size[0])) {
                emlrtDynamicBoundsCheckR2012b(k, 1, A->size[0], &o_emlrtBCI, sp);
              }

              xckeep->data[idxkeep - 1] = (int32_T)A->data[(k + A->size[0] *
                (idxEdge - 1)) - 1];
              if (idxkeep > yckeep->size[0]) {
                emlrtDynamicBoundsCheckR2012b(idxkeep, 1, yckeep->size[0],
                  &j_emlrtBCI, sp);
              }

              idxEdge = n + 1;
              if ((idxEdge < 1) || (idxEdge > yc->size[1])) {
                emlrtDynamicBoundsCheckR2012b(idxEdge, 1, yc->size[1],
                  &k_emlrtBCI, sp);
              }

              k = idx + 1;
              if ((k < 1) || (k > yc->size[0])) {
                emlrtDynamicBoundsCheckR2012b(k, 1, yc->size[0], &k_emlrtBCI, sp);
              }

              yckeep->data[idxkeep - 1] = (int32_T)yc->data[(k + yc->size[0] *
                (idxEdge - 1)) - 1];
              if (idxkeep > Ex_chunk->size[0]) {
                emlrtDynamicBoundsCheckR2012b(idxkeep, 1, Ex_chunk->size[0],
                  &h_emlrtBCI, sp);
              }

              idxEdge = n + 1;
              if ((idxEdge < 1) || (idxEdge > w->size[1])) {
                emlrtDynamicBoundsCheckR2012b(idxEdge, 1, w->size[1],
                  &i_emlrtBCI, sp);
              }

              k = idx + 1;
              if ((k < 1) || (k > w->size[0])) {
                emlrtDynamicBoundsCheckR2012b(k, 1, w->size[0], &i_emlrtBCI, sp);
              }

              Ex_chunk->data[idxkeep - 1] = w->data[(k + w->size[0] * (idxEdge -
                1)) - 1];
            }
          }
        }
      }

      st.site = &y_emlrtRSI;
      i3 = r->size[0] * r->size[1];
      r->size[0] = sz_idx_0;
      r->size[1] = sz_idx_1;
      emxEnsureCapacity_creal_T(&st, r, i3, &vc_emlrtRTEI);
      for (i3 = 0; i3 < loop_ub; i3++) {
        r->data[i3].re = 0.0;
        r->data[i3].im = 0.0;
      }

      b_st.site = &fg_emlrtRSI;
      flat = ((1 <= idxkeep) && (idxkeep > 2147483646));
      if (flat) {
        c_st.site = &fb_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < idxkeep; idx++) {
        i3 = idx + 1;
        if (i3 > yckeep->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, yckeep->size[0], &d_emlrtBCI, &st);
        }

        i3 = yckeep->data[i3 - 1];
        if ((i3 < 1) || (i3 > r->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, r->size[0], &d_emlrtBCI, &st);
        }

        idxEdge = idx + 1;
        if (idxEdge > xckeep->size[0]) {
          emlrtDynamicBoundsCheckR2012b(idxEdge, 1, xckeep->size[0], &d_emlrtBCI,
            &st);
        }

        idxEdge = xckeep->data[idxEdge - 1];
        if ((idxEdge < 1) || (idxEdge > r->size[1])) {
          emlrtDynamicBoundsCheckR2012b(idxEdge, 1, r->size[1], &d_emlrtBCI, &st);
        }

        k = idx + 1;
        if (k > yckeep->size[0]) {
          emlrtDynamicBoundsCheckR2012b(k, 1, yckeep->size[0], &e_emlrtBCI, &st);
        }

        k = yckeep->data[k - 1];
        if ((k < 1) || (k > r->size[0])) {
          emlrtDynamicBoundsCheckR2012b(k, 1, r->size[0], &e_emlrtBCI, &st);
        }

        i4 = idx + 1;
        if (i4 > xckeep->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i4, 1, xckeep->size[0], &e_emlrtBCI, &st);
        }

        i4 = xckeep->data[i4 - 1];
        if ((i4 < 1) || (i4 > r->size[1])) {
          emlrtDynamicBoundsCheckR2012b(i4, 1, r->size[1], &e_emlrtBCI, &st);
        }

        n = idx + 1;
        if (n > Ex_chunk->size[0]) {
          emlrtDynamicBoundsCheckR2012b(n, 1, Ex_chunk->size[0], &rb_emlrtBCI,
            &st);
        }

        r->data[(i3 + r->size[0] * (idxEdge - 1)) - 1].re = r->data[(k + r->
          size[0] * (i4 - 1)) - 1].re + Ex_chunk->data[n - 1];
        i3 = idx + 1;
        if (i3 > xckeep->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, xckeep->size[0], &d_emlrtBCI, &st);
        }

        idxEdge = xckeep->data[i3 - 1];
        if ((idxEdge < 1) || (idxEdge > r->size[1])) {
          emlrtDynamicBoundsCheckR2012b(xckeep->data[i3 - 1], 1, r->size[1],
            &d_emlrtBCI, &st);
        }

        i3 = idx + 1;
        if (i3 > yckeep->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, yckeep->size[0], &d_emlrtBCI, &st);
        }

        k = yckeep->data[i3 - 1];
        if ((k < 1) || (k > r->size[0])) {
          emlrtDynamicBoundsCheckR2012b(yckeep->data[i3 - 1], 1, r->size[0],
            &d_emlrtBCI, &st);
        }

        i3 = idx + 1;
        if (i3 > xckeep->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, xckeep->size[0], &e_emlrtBCI, &st);
        }

        i4 = xckeep->data[i3 - 1];
        if ((i4 < 1) || (i4 > r->size[1])) {
          emlrtDynamicBoundsCheckR2012b(xckeep->data[i3 - 1], 1, r->size[1],
            &e_emlrtBCI, &st);
        }

        i3 = idx + 1;
        if (i3 > yckeep->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i3, 1, yckeep->size[0], &e_emlrtBCI, &st);
        }

        n = yckeep->data[i3 - 1];
        if ((n < 1) || (n > r->size[0])) {
          emlrtDynamicBoundsCheckR2012b(yckeep->data[i3 - 1], 1, r->size[0],
            &e_emlrtBCI, &st);
        }

        r->data[(k + r->size[0] * (idxEdge - 1)) - 1].im = r->data[(n + r->size
          [0] * (i4 - 1)) - 1].im;
      }

      emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])accumMatrix->size, *(int32_T (*)
        [2])r->size, &emlrtECI, sp);
      n = accumMatrix->size[0] * accumMatrix->size[1];
      for (i3 = 0; i3 < n; i3++) {
        accumMatrix->data[i3].re += r->data[i3].re;
        accumMatrix->data[i3].im += r->data[i3].im;
      }
    }

    emxFree_real_T(&r1);
    emxFree_real_T(&Ex);
    emxFree_real_T(&Ey);
    emxFree_creal_T(&r);
    emxFree_real32_T(&A);
    emxFree_real32_T(&Gy);
    emxFree_real32_T(&Gx);
    emxFree_int32_T(&yckeep);
    emxFree_int32_T(&xckeep);
    emxFree_real_T(&w);
    emxFree_real32_T(&yc);
    emxFree_int32_T(&idxE_chunk);
    emxFree_real_T(&Ex_chunk);
    emxFree_real_T(&w0);
    emxFree_real_T(&radiusRange);
    emxFree_int32_T(&idxE);
  }

  emxFree_boolean_T(&rows_to_keep);
  emxFree_boolean_T(&inside);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (chaccum.c) */
