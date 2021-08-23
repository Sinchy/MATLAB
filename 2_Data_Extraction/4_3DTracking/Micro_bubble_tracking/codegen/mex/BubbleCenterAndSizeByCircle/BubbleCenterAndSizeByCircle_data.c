/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BubbleCenterAndSizeByCircle_data.c
 *
 * Code generation for function 'BubbleCenterAndSizeByCircle_data'
 *
 */

/* Include files */
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131594U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "BubbleCenterAndSizeByCircle",       /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 1858410525U, 2505464270U, 328108647U, 1256672073U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

emlrtRSInfo n_emlrtRSI = { 76,         /* lineNo */
  "validateattributes",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\lang\\validateattributes.m"/* pathName */
};

emlrtRSInfo eb_emlrtRSI = { 143,       /* lineNo */
  "allOrAny",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\allOrAny.m"/* pathName */
};

emlrtRSInfo fb_emlrtRSI = { 21,        /* lineNo */
  "eml_int_forloop_overflow_check",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_overflow_check.m"/* pathName */
};

emlrtRSInfo kb_emlrtRSI = { 20,        /* lineNo */
  "padarray",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pathName */
};

emlrtRSInfo lb_emlrtRSI = { 66,        /* lineNo */
  "padarray",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\padarray.m"/* pathName */
};

emlrtRSInfo nb_emlrtRSI = { 28,        /* lineNo */
  "repmat",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\repmat.m"/* pathName */
};

emlrtRSInfo pb_emlrtRSI = { 975,       /* lineNo */
  "findFirst",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

emlrtRSInfo qb_emlrtRSI = { 992,       /* lineNo */
  "minOrMaxRealVectorKernel",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

emlrtRSInfo tb_emlrtRSI = { 1033,      /* lineNo */
  "imfiltercoreAlgo",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pathName */
};

emlrtRSInfo ub_emlrtRSI = { 1045,      /* lineNo */
  "imfiltercoreAlgo",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imfilter.m"/* pathName */
};

emlrtRSInfo gc_emlrtRSI = { 14,        /* lineNo */
  "max",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\max.m"/* pathName */
};

emlrtRSInfo hc_emlrtRSI = { 44,        /* lineNo */
  "minOrMax",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax.m"/* pathName */
};

emlrtRSInfo ic_emlrtRSI = { 79,        /* lineNo */
  "maximum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax.m"/* pathName */
};

emlrtRSInfo jc_emlrtRSI = { 145,       /* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

emlrtRSInfo kc_emlrtRSI = { 1019,      /* lineNo */
  "maxRealVectorOmitNaN",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

emlrtRSInfo lc_emlrtRSI = { 932,       /* lineNo */
  "minOrMaxRealVector",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

emlrtRSInfo mc_emlrtRSI = { 924,       /* lineNo */
  "minOrMaxRealVector",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

emlrtRSInfo ed_emlrtRSI = { 18,        /* lineNo */
  "abs",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\abs.m"/* pathName */
};

emlrtRSInfo fd_emlrtRSI = { 75,        /* lineNo */
  "applyScalarFunction",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\applyScalarFunction.m"/* pathName */
};

emlrtRSInfo hd_emlrtRSI = { 13,        /* lineNo */
  "any",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\any.m"/* pathName */
};

emlrtRSInfo td_emlrtRSI = { 587,       /* lineNo */
  "merge_pow2_block",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

emlrtRSInfo ud_emlrtRSI = { 589,       /* lineNo */
  "merge_pow2_block",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

emlrtRSInfo vd_emlrtRSI = { 617,       /* lineNo */
  "merge_pow2_block",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

emlrtRSInfo xd_emlrtRSI = { 506,       /* lineNo */
  "merge_block",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\sortIdx.m"/* pathName */
};

emlrtRSInfo ie_emlrtRSI = { 14,        /* lineNo */
  "min",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\min.m"/* pathName */
};

emlrtRSInfo je_emlrtRSI = { 46,        /* lineNo */
  "minOrMax",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax.m"/* pathName */
};

emlrtRSInfo ke_emlrtRSI = { 92,        /* lineNo */
  "minimum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax.m"/* pathName */
};

emlrtRSInfo le_emlrtRSI = { 155,       /* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

emlrtRSInfo me_emlrtRSI = { 1015,      /* lineNo */
  "minRealVectorOmitNaN",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

emlrtRSInfo pe_emlrtRSI = { 19,        /* lineNo */
  "grayto8",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\private\\grayto8.m"/* pathName */
};

emlrtRSInfo re_emlrtRSI = { 166,       /* lineNo */
  "calcHistogram",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m"/* pathName */
};

emlrtRSInfo se_emlrtRSI = { 192,       /* lineNo */
  "calcHistogram",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\imhist.m"/* pathName */
};

emlrtRSInfo sf_emlrtRSI = { 37,        /* lineNo */
  "find",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

emlrtRSInfo tf_emlrtRSI = { 147,       /* lineNo */
  "eml_find",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

emlrtRSInfo uf_emlrtRSI = { 250,       /* lineNo */
  "find_first_nonempty_triples",       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

emlrtRSInfo vf_emlrtRSI = { 251,       /* lineNo */
  "find_first_nonempty_triples",       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

emlrtRSInfo wf_emlrtRSI = { 252,       /* lineNo */
  "find_first_nonempty_triples",       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\find.m"/* pathName */
};

emlrtRSInfo xf_emlrtRSI = { 16,        /* lineNo */
  "sub2ind",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\sub2ind.m"/* pathName */
};

emlrtRSInfo yf_emlrtRSI = { 39,        /* lineNo */
  "eml_sub2ind",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\sub2ind.m"/* pathName */
};

emlrtRSInfo ag_emlrtRSI = { 71,        /* lineNo */
  "prodsub",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\sub2ind.m"/* pathName */
};

emlrtRSInfo bg_emlrtRSI = { 103,       /* lineNo */
  "colon",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pathName */
};

emlrtRSInfo dg_emlrtRSI = { 306,       /* lineNo */
  "eml_float_colon",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pathName */
};

emlrtRSInfo eg_emlrtRSI = { 28,        /* lineNo */
  "colon",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pathName */
};

emlrtRSInfo hi_emlrtRSI = { 20,        /* lineNo */
  "sum",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m"/* pathName */
};

emlrtRSInfo ii_emlrtRSI = { 99,        /* lineNo */
  "sumprod",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pathName */
};

emlrtRSInfo ji_emlrtRSI = { 125,       /* lineNo */
  "combineVectorElements",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

emlrtRSInfo ki_emlrtRSI = { 185,       /* lineNo */
  "colMajorFlatIter",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

emlrtRSInfo li_emlrtRSI = { 14,        /* lineNo */
  "cumsum",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\cumsum.m"/* pathName */
};

emlrtRSInfo mi_emlrtRSI = { 16,        /* lineNo */
  "cumop",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\cumop.m"/* pathName */
};

emlrtRSInfo pi_emlrtRSI = { 125,       /* lineNo */
  "looper",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\cumop.m"/* pathName */
};

emlrtRSInfo qi_emlrtRSI = { 290,       /* lineNo */
  "vcumop",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\cumop.m"/* pathName */
};

emlrtRSInfo cl_emlrtRSI = { 105,       /* lineNo */
  "relop",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\relop.m"/* pathName */
};

emlrtRSInfo dl_emlrtRSI = { 156,       /* lineNo */
  "absRelopProxies",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\relop.m"/* pathName */
};

emlrtRSInfo el_emlrtRSI = { 170,       /* lineNo */
  "absRelopProxies",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\relop.m"/* pathName */
};

emlrtRSInfo fl_emlrtRSI = { 173,       /* lineNo */
  "absRelopProxies",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\relop.m"/* pathName */
};

emlrtRSInfo gl_emlrtRSI = { 175,       /* lineNo */
  "absRelopProxies",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\relop.m"/* pathName */
};

emlrtRSInfo hl_emlrtRSI = { 192,       /* lineNo */
  "iseq",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\relop.m"/* pathName */
};

emlrtRTEInfo emlrtRTEI = { 14,         /* lineNo */
  37,                                  /* colNo */
  "validatefinite",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+valattr\\validatefinite.m"/* pName */
};

emlrtRTEInfo b_emlrtRTEI = { 14,       /* lineNo */
  37,                                  /* colNo */
  "validatenonnan",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+valattr\\validatenonnan.m"/* pName */
};

emlrtRTEInfo c_emlrtRTEI = { 13,       /* lineNo */
  37,                                  /* colNo */
  "validatenonempty",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+valattr\\validatenonempty.m"/* pName */
};

emlrtRTEInfo e_emlrtRTEI = { 47,       /* lineNo */
  19,                                  /* colNo */
  "allOrAny",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\allOrAny.m"/* pName */
};

emlrtRTEInfo i_emlrtRTEI = { 13,       /* lineNo */
  37,                                  /* colNo */
  "validateinteger",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+valattr\\validateinteger.m"/* pName */
};

emlrtRTEInfo j_emlrtRTEI = { 14,       /* lineNo */
  37,                                  /* colNo */
  "validatepositive",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+valattr\\validatepositive.m"/* pName */
};

emlrtRTEInfo l_emlrtRTEI = { 26,       /* lineNo */
  27,                                  /* colNo */
  "unaryMinOrMax",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pName */
};

emlrtRTEInfo m_emlrtRTEI = { 95,       /* lineNo */
  27,                                  /* colNo */
  "unaryMinOrMax",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pName */
};

emlrtRTEInfo hb_emlrtRTEI = { 46,      /* lineNo */
  23,                                  /* colNo */
  "sumprod",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pName */
};

emlrtRTEInfo hd_emlrtRTEI = { 28,      /* lineNo */
  9,                                   /* colNo */
  "colon",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pName */
};

emlrtRTEInfo ne_emlrtRTEI = { 18,      /* lineNo */
  5,                                   /* colNo */
  "abs",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\abs.m"/* pName */
};

covrtInstance emlrtCoverageInstance;

/* End of code generation (BubbleCenterAndSizeByCircle_data.c) */
