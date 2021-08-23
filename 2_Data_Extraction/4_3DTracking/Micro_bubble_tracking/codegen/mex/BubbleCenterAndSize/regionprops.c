/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * regionprops.c
 *
 * Code generation for function 'regionprops'
 *
 */

/* Include files */
#include "regionprops.h"
#include "BubbleCenterAndSize.h"
#include "BubbleCenterAndSize_data.h"
#include "BubbleCenterAndSize_emxutil.h"
#include "assertValidSizeArg.h"
#include "bwconncomp.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "power.h"
#include "rt_nonfinite.h"
#include "sum.h"
#include <string.h>

/* Type Definitions */
#ifndef typedef_struct_T
#define typedef_struct_T

typedef struct {
  boolean_T Area;
  boolean_T Centroid;
  boolean_T BoundingBox;
  boolean_T MajorAxisLength;
  boolean_T MinorAxisLength;
  boolean_T Eccentricity;
  boolean_T Orientation;
  boolean_T Image;
  boolean_T FilledImage;
  boolean_T FilledArea;
  boolean_T EulerNumber;
  boolean_T Extrema;
  boolean_T EquivDiameter;
  boolean_T Extent;
  boolean_T PixelIdxList;
  boolean_T PixelList;
  boolean_T Perimeter;
  boolean_T Circularity;
  boolean_T PixelValues;
  boolean_T WeightedCentroid;
  boolean_T MeanIntensity;
  boolean_T MinIntensity;
  boolean_T MaxIntensity;
  boolean_T SubarrayIdx;
} struct_T;

#endif                                 /*typedef_struct_T*/

/* Variable Definitions */
static emlrtRSInfo b_emlrtRSI = { 197, /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 127, /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo d_emlrtRSI = { 123, /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 99,  /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 78,  /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo g_emlrtRSI = { 75,  /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 73,  /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo i_emlrtRSI = { 32,  /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ib_emlrtRSI = { 1287,/* lineNo */
  "parseInputsAndInitializeOutStruct", /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo jb_emlrtRSI = { 1462,/* lineNo */
  "getPropsFromInputAndInitializeOutStruct",/* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo kb_emlrtRSI = { 28, /* lineNo */
  "repmat",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\repmat.m"/* pathName */
};

static emlrtRSInfo lb_emlrtRSI = { 1834,/* lineNo */
  "initializeStatsStruct",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo mb_emlrtRSI = { 295,/* lineNo */
  "ComputePixelIdxList",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo nb_emlrtRSI = { 764,/* lineNo */
  "ComputePixelList",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ob_emlrtRSI = { 766,/* lineNo */
  "ComputePixelList",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo pb_emlrtRSI = { 19, /* lineNo */
  "ind2sub",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\ind2sub.m"/* pathName */
};

static emlrtRSInfo qb_emlrtRSI = { 22, /* lineNo */
  "cat",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pathName */
};

static emlrtRSInfo rb_emlrtRSI = { 102,/* lineNo */
  "cat_impl",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pathName */
};

static emlrtRSInfo sb_emlrtRSI = { 414,/* lineNo */
  "ComputeCentroid",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo tb_emlrtRSI = { 418,/* lineNo */
  "ComputeCentroid",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ub_emlrtRSI = { 49, /* lineNo */
  "mean",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\mean.m"/* pathName */
};

static emlrtRSInfo vb_emlrtRSI = { 600,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo wb_emlrtRSI = { 602,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo xb_emlrtRSI = { 629,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo yb_emlrtRSI = { 630,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ac_emlrtRSI = { 631,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo bc_emlrtRSI = { 634,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo cc_emlrtRSI = { 635,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo dc_emlrtRSI = { 636,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ec_emlrtRSI = { 637,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo fc_emlrtRSI = { 638,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo gc_emlrtRSI = { 643,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo hc_emlrtRSI = { 647,/* lineNo */
  "ComputeEllipseParams",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  1893,                                /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "populateOutputStatsStructure",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  1893,                                /* lineNo */
  49,                                  /* colNo */
  "",                                  /* aName */
  "populateOutputStatsStructure",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  1892,                                /* lineNo */
  42,                                  /* colNo */
  "",                                  /* aName */
  "populateOutputStatsStructure",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  1890,                                /* lineNo */
  56,                                  /* colNo */
  "",                                  /* aName */
  "populateOutputStatsStructure",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  65,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  51,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  74,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  60,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  766,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelList",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ic_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  768,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelList",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo e_emlrtRTEI = { 38,/* lineNo */
  15,                                  /* colNo */
  "ind2sub_indexClass",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\ind2sub.m"/* pName */
};

static emlrtRTEInfo f_emlrtRTEI = { 283,/* lineNo */
  27,                                  /* colNo */
  "check_non_axis_size",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pName */
};

static emlrtBCInfo jc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  764,                                 /* lineNo */
  47,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelList",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  763,                                 /* lineNo */
  27,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelList",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo lc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  418,                                 /* lineNo */
  40,                                  /* colNo */
  "",                                  /* aName */
  "ComputeCentroid",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo mc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  418,                                 /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "ComputeCentroid",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo g_emlrtRTEI = { 13,/* lineNo */
  9,                                   /* colNo */
  "sqrt",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\sqrt.m"/* pName */
};

static emlrtECInfo emlrtECI = { -1,    /* nDims */
  631,                                 /* lineNo */
  23,                                  /* colNo */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtBCInfo nc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  618,                                 /* lineNo */
  26,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo oc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  617,                                 /* lineNo */
  26,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  606,                                 /* lineNo */
  22,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  608,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  609,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  610,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo tc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  611,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo uc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  635,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  636,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  637,                                 /* lineNo */
  45,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  638,                                 /* lineNo */
  18,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  639,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ad_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  637,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  652,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  650,                                 /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "ComputeEllipseParams",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo h_emlrtRTEI = { 1462,/* lineNo */
  1,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo i_emlrtRTEI = { 1834,/* lineNo */
  1,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo j_emlrtRTEI = { 295,/* lineNo */
  5,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo k_emlrtRTEI = { 298,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo l_emlrtRTEI = { 32,/* lineNo */
  9,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo m_emlrtRTEI = { 1, /* lineNo */
  23,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo n_emlrtRTEI = { 1713,/* lineNo */
  5,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo o_emlrtRTEI = { 220,/* lineNo */
  9,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo p_emlrtRTEI = { 234,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo eb_emlrtRTEI = { 30,/* lineNo */
  1,                                   /* colNo */
  "ind2sub",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\ind2sub.m"/* pName */
};

static emlrtRTEInfo fb_emlrtRTEI = { 768,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo gb_emlrtRTEI = { 42,/* lineNo */
  5,                                   /* colNo */
  "ind2sub",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\ind2sub.m"/* pName */
};

static emlrtRTEInfo hb_emlrtRTEI = { 766,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo ib_emlrtRTEI = { 620,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo jb_emlrtRTEI = { 621,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo kb_emlrtRTEI = { 631,/* lineNo */
  23,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo lb_emlrtRTEI = { 629,/* lineNo */
  23,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRSInfo nc_emlrtRSI = { 18, /* lineNo */
  "indexDivide",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\indexDivide.m"/* pathName */
};

/* Function Declarations */
static void ComputeCentroid(const emlrtStack *sp, const real_T imageSize[2],
  emxArray_struct_T *stats, struct_T *statsAlreadyComputed);
static void ComputeEllipseParams(const emlrtStack *sp, const real_T imageSize[2],
  emxArray_struct_T *stats, struct_T *statsAlreadyComputed);
static void ComputePixelList(const emlrtStack *sp, const real_T imageSize[2],
  emxArray_struct_T *stats, struct_T *statsAlreadyComputed);
static int32_T div_s32(const emlrtStack *sp, int32_T numerator, int32_T
  denominator);

/* Function Definitions */
static void ComputeCentroid(const emlrtStack *sp, const real_T imageSize[2],
  emxArray_struct_T *stats, struct_T *statsAlreadyComputed)
{
  int32_T i;
  int32_T k;
  int32_T b_k;
  int32_T vlen;
  real_T y_idx_0;
  boolean_T overflow;
  real_T y_idx_1;
  int32_T xpageoffset;
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
  if (!statsAlreadyComputed->Centroid) {
    statsAlreadyComputed->Centroid = true;
    st.site = &sb_emlrtRSI;
    ComputePixelList(&st, imageSize, stats, statsAlreadyComputed);
    i = stats->size[0];
    for (k = 0; k < i; k++) {
      st.site = &tb_emlrtRSI;
      b_k = stats->size[0];
      vlen = k + 1;
      if ((vlen < 1) || (vlen > b_k)) {
        emlrtDynamicBoundsCheckR2012b(vlen, 1, b_k, &lc_emlrtBCI, &st);
      }

      b_st.site = &ub_emlrtRSI;
      vlen = stats->data[k].PixelList->size[0];
      if (stats->data[k].PixelList->size[0] == 0) {
        y_idx_0 = 0.0;
        y_idx_1 = 0.0;
      } else {
        c_st.site = &ab_emlrtRSI;
        overflow = ((2 <= vlen) && (vlen > 2147483646));
        y_idx_0 = stats->data[k].PixelList->data[0];
        d_st.site = &bb_emlrtRSI;
        if (overflow) {
          e_st.site = &w_emlrtRSI;
          check_forloop_overflow_error(&e_st);
        }

        for (b_k = 2; b_k <= vlen; b_k++) {
          y_idx_0 += stats->data[k].PixelList->data[b_k - 1];
        }

        xpageoffset = stats->data[k].PixelList->size[0];
        y_idx_1 = stats->data[k].PixelList->data[xpageoffset];
        d_st.site = &bb_emlrtRSI;
        for (b_k = 2; b_k <= vlen; b_k++) {
          y_idx_1 += stats->data[k].PixelList->data[(xpageoffset + b_k) - 1];
        }
      }

      vlen = stats->data[k].PixelList->size[0];
      xpageoffset = stats->size[0];
      b_k = (int32_T)(k + 1U);
      if ((b_k < 1) || (b_k > xpageoffset)) {
        emlrtDynamicBoundsCheckR2012b(b_k, 1, xpageoffset, &mc_emlrtBCI, &st);
      }

      stats->data[b_k - 1].Centroid[0] = y_idx_0 / (real_T)vlen;
      if (b_k > xpageoffset) {
        emlrtDynamicBoundsCheckR2012b(b_k, 1, xpageoffset, &mc_emlrtBCI, &st);
      }

      stats->data[b_k - 1].Centroid[1] = y_idx_1 / (real_T)vlen;
    }
  }
}

static void ComputeEllipseParams(const emlrtStack *sp, const real_T imageSize[2],
  emxArray_struct_T *stats, struct_T *statsAlreadyComputed)
{
  int32_T i;
  emxArray_real_T *x;
  emxArray_real_T *y;
  emxArray_real_T *r;
  int32_T k;
  int32_T i1;
  int32_T loop_ub;
  real_T common;
  real_T uxx;
  real_T uyy;
  real_T uxy;
  real_T a_tmp;
  real_T common_tmp;
  real_T b_common_tmp;
  real_T num;
  real_T b_x;
  int32_T i2;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  if ((!statsAlreadyComputed->MajorAxisLength) ||
      (!statsAlreadyComputed->MinorAxisLength) ||
      (!statsAlreadyComputed->Orientation) ||
      (!statsAlreadyComputed->Eccentricity)) {
    statsAlreadyComputed->MajorAxisLength = true;
    statsAlreadyComputed->MinorAxisLength = true;
    statsAlreadyComputed->Eccentricity = true;
    statsAlreadyComputed->Orientation = true;
    st.site = &vb_emlrtRSI;
    ComputePixelList(&st, imageSize, stats, statsAlreadyComputed);
    st.site = &wb_emlrtRSI;
    ComputeCentroid(&st, imageSize, stats, statsAlreadyComputed);
    i = stats->size[0];
    emxInit_real_T(sp, &x, 1, &ib_emlrtRTEI, true);
    emxInit_real_T(sp, &y, 1, &jb_emlrtRTEI, true);
    emxInit_real_T(sp, &r, 1, &lb_emlrtRTEI, true);
    for (k = 0; k < i; k++) {
      i1 = stats->size[0];
      loop_ub = k + 1;
      if ((loop_ub < 1) || (loop_ub > i1)) {
        emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &pc_emlrtBCI, sp);
      }

      if (stats->data[k].PixelList->size[0] == 0) {
        i1 = stats->size[0];
        loop_ub = (int32_T)(k + 1U);
        if ((loop_ub < 1) || (loop_ub > i1)) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &qc_emlrtBCI, sp);
        }

        stats->data[loop_ub - 1].MajorAxisLength = 0.0;
        i1 = stats->size[0];
        if (loop_ub > i1) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &rc_emlrtBCI, sp);
        }

        stats->data[loop_ub - 1].MinorAxisLength = 0.0;
        i1 = stats->size[0];
        if (loop_ub > i1) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &sc_emlrtBCI, sp);
        }

        stats->data[loop_ub - 1].Eccentricity = 0.0;
        i1 = stats->size[0];
        if (loop_ub > i1) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &tc_emlrtBCI, sp);
        }

        stats->data[loop_ub - 1].Orientation = 0.0;
      } else {
        i1 = stats->size[0];
        loop_ub = k + 1;
        if ((loop_ub < 1) || (loop_ub > i1)) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &oc_emlrtBCI, sp);
        }

        i1 = stats->size[0];
        loop_ub = k + 1;
        if ((loop_ub < 1) || (loop_ub > i1)) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &nc_emlrtBCI, sp);
        }

        common = stats->data[k].Centroid[0];
        loop_ub = stats->data[k].PixelList->size[0];
        i1 = x->size[0];
        x->size[0] = loop_ub;
        emxEnsureCapacity_real_T(sp, x, i1, &ib_emlrtRTEI);
        for (i1 = 0; i1 < loop_ub; i1++) {
          x->data[i1] = stats->data[k].PixelList->data[i1] - common;
        }

        common = stats->data[k].Centroid[1];
        loop_ub = stats->data[k].PixelList->size[0];
        i1 = y->size[0];
        y->size[0] = loop_ub;
        emxEnsureCapacity_real_T(sp, y, i1, &jb_emlrtRTEI);
        for (i1 = 0; i1 < loop_ub; i1++) {
          y->data[i1] = -(stats->data[k].PixelList->data[i1 + stats->data[k].
                          PixelList->size[0]] - common);
        }

        st.site = &xb_emlrtRSI;
        power(&st, x, r);
        st.site = &xb_emlrtRSI;
        uxx = sum(&st, r) / (real_T)x->size[0] + 0.083333333333333329;
        st.site = &yb_emlrtRSI;
        power(&st, y, r);
        st.site = &yb_emlrtRSI;
        uyy = sum(&st, r) / (real_T)x->size[0] + 0.083333333333333329;
        if (x->size[0] != y->size[0]) {
          emlrtSizeEqCheck1DR2012b(x->size[0], y->size[0], &emlrtECI, sp);
        }

        i1 = y->size[0];
        y->size[0] = x->size[0];
        emxEnsureCapacity_real_T(sp, y, i1, &kb_emlrtRTEI);
        loop_ub = x->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          y->data[i1] *= x->data[i1];
        }

        st.site = &ac_emlrtRSI;
        uxy = sum(&st, y) / (real_T)x->size[0];
        a_tmp = uxx - uyy;
        st.site = &bc_emlrtRSI;
        common_tmp = 4.0 * (uxy * uxy);
        b_common_tmp = a_tmp * a_tmp + common_tmp;
        if (b_common_tmp < 0.0) {
          emlrtErrorWithMessageIdR2018a(&st, &g_emlrtRTEI,
            "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError",
            3, 4, 4, "sqrt");
        }

        common = muDoubleScalarSqrt(b_common_tmp);
        st.site = &cc_emlrtRSI;
        num = uxx + uyy;
        b_x = num + common;
        if (b_x < 0.0) {
          emlrtErrorWithMessageIdR2018a(&st, &g_emlrtRTEI,
            "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError",
            3, 4, 4, "sqrt");
        }

        b_x = muDoubleScalarSqrt(b_x);
        i1 = stats->size[0];
        loop_ub = (int32_T)(k + 1U);
        if ((loop_ub < 1) || (loop_ub > i1)) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &uc_emlrtBCI, sp);
        }

        stats->data[loop_ub - 1].MajorAxisLength = 2.8284271247461903 * b_x;
        st.site = &dc_emlrtRSI;
        b_x = num - common;
        if (b_x < 0.0) {
          emlrtErrorWithMessageIdR2018a(&st, &g_emlrtRTEI,
            "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError",
            3, 4, 4, "sqrt");
        }

        b_x = muDoubleScalarSqrt(b_x);
        i1 = stats->size[0];
        loop_ub = (int32_T)(k + 1U);
        if ((loop_ub < 1) || (loop_ub > i1)) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &vc_emlrtBCI, sp);
        }

        stats->data[loop_ub - 1].MinorAxisLength = 2.8284271247461903 * b_x;
        st.site = &ec_emlrtRSI;
        i1 = stats->size[0];
        loop_ub = (int32_T)(k + 1U);
        if ((loop_ub < 1) || (loop_ub > i1)) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &wc_emlrtBCI, &st);
        }

        common = stats->data[loop_ub - 1].MajorAxisLength / 2.0;
        st.site = &fc_emlrtRSI;
        i1 = stats->size[0];
        loop_ub = (int32_T)(k + 1U);
        if ((loop_ub < 1) || (loop_ub > i1)) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &xc_emlrtBCI, &st);
        }

        num = stats->data[loop_ub - 1].MinorAxisLength / 2.0;
        st.site = &ec_emlrtRSI;
        b_x = common * common - num * num;
        if (b_x < 0.0) {
          emlrtErrorWithMessageIdR2018a(&st, &g_emlrtRTEI,
            "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError",
            3, 4, 4, "sqrt");
        }

        b_x = muDoubleScalarSqrt(b_x);
        i1 = stats->size[0];
        loop_ub = (int32_T)(k + 1U);
        if ((loop_ub < 1) || (loop_ub > i1)) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &yc_emlrtBCI, sp);
        }

        i1 = stats->size[0];
        i2 = (int32_T)(k + 1U);
        if ((i2 < 1) || (i2 > i1)) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &ad_emlrtBCI, sp);
        }

        stats->data[i2 - 1].Eccentricity = 2.0 * b_x / stats->data[loop_ub - 1].
          MajorAxisLength;
        if (uyy > uxx) {
          a_tmp = uyy - uxx;
          st.site = &gc_emlrtRSI;
          b_x = a_tmp * a_tmp + common_tmp;
          if (b_x < 0.0) {
            emlrtErrorWithMessageIdR2018a(&st, &g_emlrtRTEI,
              "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError",
              3, 4, 4, "sqrt");
          }

          b_x = muDoubleScalarSqrt(b_x);
          num = a_tmp + b_x;
          common = 2.0 * uxy;
        } else {
          num = 2.0 * uxy;
          st.site = &hc_emlrtRSI;
          if (b_common_tmp < 0.0) {
            emlrtErrorWithMessageIdR2018a(&st, &g_emlrtRTEI,
              "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError",
              3, 4, 4, "sqrt");
          }

          common = a_tmp + muDoubleScalarSqrt(b_common_tmp);
        }

        if ((num == 0.0) && (common == 0.0)) {
          i1 = stats->size[0];
          loop_ub = (int32_T)(k + 1U);
          if ((loop_ub < 1) || (loop_ub > i1)) {
            emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &cd_emlrtBCI, sp);
          }

          stats->data[loop_ub - 1].Orientation = 0.0;
        } else {
          i1 = stats->size[0];
          loop_ub = (int32_T)(k + 1U);
          if ((loop_ub < 1) || (loop_ub > i1)) {
            emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &bd_emlrtBCI, sp);
          }

          stats->data[loop_ub - 1].Orientation = 57.295779513082323 *
            muDoubleScalarAtan(num / common);
        }
      }
    }

    emxFree_real_T(&r);
    emxFree_real_T(&y);
    emxFree_real_T(&x);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

static void ComputePixelList(const emlrtStack *sp, const real_T imageSize[2],
  emxArray_struct_T *stats, struct_T *statsAlreadyComputed)
{
  int32_T i;
  emxArray_int32_T *idx;
  emxArray_int32_T *vk;
  int32_T k;
  int32_T i1;
  int32_T hi;
  int32_T loop_ub;
  int32_T hi_tmp;
  int32_T b_k;
  boolean_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  if (!statsAlreadyComputed->PixelList) {
    statsAlreadyComputed->PixelList = true;
    i = stats->size[0];
    emxInit_int32_T(sp, &idx, 1, &eb_emlrtRTEI, true);
    emxInit_int32_T(sp, &vk, 1, &gb_emlrtRTEI, true);
    for (k = 0; k < i; k++) {
      i1 = stats->size[0];
      hi = k + 1;
      if ((hi < 1) || (hi > i1)) {
        emlrtDynamicBoundsCheckR2012b(hi, 1, i1, &kc_emlrtBCI, sp);
      }

      if (stats->data[k].PixelIdxList->size[0] != 0) {
        st.site = &nb_emlrtRSI;
        i1 = stats->size[0];
        hi = k + 1;
        if ((hi < 1) || (hi > i1)) {
          emlrtDynamicBoundsCheckR2012b(hi, 1, i1, &jc_emlrtBCI, &st);
        }

        b_st.site = &pb_emlrtRSI;
        i1 = idx->size[0];
        idx->size[0] = stats->data[k].PixelIdxList->size[0];
        emxEnsureCapacity_int32_T(&b_st, idx, i1, &eb_emlrtRTEI);
        loop_ub = stats->data[k].PixelIdxList->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          idx->data[i1] = (int32_T)stats->data[k].PixelIdxList->data[i1];
        }

        hi_tmp = (int32_T)imageSize[0];
        hi = hi_tmp * (int32_T)imageSize[1];
        b_k = 0;
        exitg1 = false;
        while ((!exitg1) && (b_k <= idx->size[0] - 1)) {
          if ((idx->data[b_k] >= 1) && (idx->data[b_k] <= hi)) {
            b_k++;
          } else {
            emlrtErrorWithMessageIdR2018a(&b_st, &e_emlrtRTEI,
              "Coder:MATLAB:ind2sub_IndexOutOfRange",
              "Coder:MATLAB:ind2sub_IndexOutOfRange", 0);
          }
        }

        loop_ub = idx->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          idx->data[i1]--;
        }

        i1 = vk->size[0];
        vk->size[0] = idx->size[0];
        emxEnsureCapacity_int32_T(&b_st, vk, i1, &gb_emlrtRTEI);
        loop_ub = idx->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          c_st.site = &nc_emlrtRSI;
          vk->data[i1] = div_s32(&c_st, idx->data[i1], hi_tmp);
        }

        loop_ub = idx->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          idx->data[i1] -= vk->data[i1] * hi_tmp;
        }

        loop_ub = idx->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          idx->data[i1]++;
        }

        loop_ub = vk->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          vk->data[i1]++;
        }

        st.site = &ob_emlrtRSI;
        b_st.site = &qb_emlrtRSI;
        c_st.site = &rb_emlrtRSI;
        if (idx->size[0] != vk->size[0]) {
          emlrtErrorWithMessageIdR2018a(&c_st, &f_emlrtRTEI,
            "MATLAB:catenate:matrixDimensionMismatch",
            "MATLAB:catenate:matrixDimensionMismatch", 0);
        }

        b_k = stats->size[0];
        i1 = (int32_T)(k + 1U);
        if ((i1 < 1) || (i1 > b_k)) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, b_k, &hc_emlrtBCI, &b_st);
        }

        hi = stats->data[i1 - 1].PixelList->size[0] * stats->data[i1 - 1].
          PixelList->size[1];
        stats->data[i1 - 1].PixelList->size[0] = vk->size[0];
        emxEnsureCapacity_real_T(&b_st, stats->data[i1 - 1].PixelList, hi,
          &hb_emlrtRTEI);
        i1 = (int32_T)(k + 1U);
        if ((i1 < 1) || (i1 > b_k)) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, b_k, &hc_emlrtBCI, &b_st);
        }

        hi = stats->data[i1 - 1].PixelList->size[0] * stats->data[i1 - 1].
          PixelList->size[1];
        stats->data[i1 - 1].PixelList->size[1] = 2;
        emxEnsureCapacity_real_T(&b_st, stats->data[i1 - 1].PixelList, hi,
          &hb_emlrtRTEI);
        loop_ub = vk->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          hi = (int32_T)(k + 1U);
          if ((hi < 1) || (hi > b_k)) {
            emlrtDynamicBoundsCheckR2012b(hi, 1, b_k, &hc_emlrtBCI, &b_st);
          }

          stats->data[hi - 1].PixelList->data[i1] = vk->data[i1];
        }

        loop_ub = idx->size[0];
        for (i1 = 0; i1 < loop_ub; i1++) {
          hi = (int32_T)(k + 1U);
          if ((hi < 1) || (hi > b_k)) {
            emlrtDynamicBoundsCheckR2012b(hi, 1, b_k, &hc_emlrtBCI, &b_st);
          }

          stats->data[hi - 1].PixelList->data[i1 + stats->data[hi - 1].
            PixelList->size[0]] = idx->data[i1];
        }
      } else {
        i1 = stats->size[0];
        hi = (int32_T)(k + 1U);
        if ((hi < 1) || (hi > i1)) {
          emlrtDynamicBoundsCheckR2012b(hi, 1, i1, &ic_emlrtBCI, sp);
        }

        stats->data[hi - 1].PixelList->size[0] = 0;
        i1 = stats->size[0];
        if (hi > i1) {
          emlrtDynamicBoundsCheckR2012b(hi, 1, i1, &ic_emlrtBCI, sp);
        }

        i1 = stats->data[hi - 1].PixelList->size[0] * stats->data[hi - 1].
          PixelList->size[1];
        stats->data[hi - 1].PixelList->size[1] = 2;
        emxEnsureCapacity_real_T(sp, stats->data[hi - 1].PixelList, i1,
          &fb_emlrtRTEI);
        i1 = stats->size[0];
        if (hi > i1) {
          emlrtDynamicBoundsCheckR2012b(hi, 1, i1, &ic_emlrtBCI, sp);
        }

        i1 = stats->size[0];
        if (hi > i1) {
          emlrtDynamicBoundsCheckR2012b(hi, 1, i1, &ic_emlrtBCI, sp);
        }
      }
    }

    emxFree_int32_T(&vk);
    emxFree_int32_T(&idx);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

static int32_T div_s32(const emlrtStack *sp, int32_T numerator, int32_T
  denominator)
{
  int32_T quotient;
  uint32_T b_numerator;
  uint32_T b_denominator;
  if (denominator == 0) {
    emlrtDivisionByZeroErrorR2012b(NULL, sp);
  } else {
    if (numerator < 0) {
      b_numerator = ~(uint32_T)numerator + 1U;
    } else {
      b_numerator = (uint32_T)numerator;
    }

    if (denominator < 0) {
      b_denominator = ~(uint32_T)denominator + 1U;
    } else {
      b_denominator = (uint32_T)denominator;
    }

    b_numerator /= b_denominator;
    if ((numerator < 0) != (denominator < 0)) {
      quotient = -(int32_T)b_numerator;
    } else {
      quotient = (int32_T)b_numerator;
    }
  }

  return quotient;
}

void regionprops(const emlrtStack *sp, const emxArray_boolean_T *varargin_1,
                 emxArray_struct0_T *outstats)
{
  emxArray_real_T *CC_RegionIndices;
  emxArray_int32_T *regionLengths;
  real_T expl_temp;
  real_T CC_ImageSize[2];
  real_T CC_NumObjects;
  struct0_T s;
  int32_T loop_ub;
  int32_T i;
  b_struct_T statsOneObj;
  struct_T statsAlreadyComputed;
  emxArray_struct_T *stats;
  int32_T varargin_3;
  emxArray_int32_T *idxCount;
  int32_T k;
  int32_T i1;
  int32_T i2;
  int32_T b_stats;
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
  emxInit_real_T(sp, &CC_RegionIndices, 1, &l_emlrtRTEI, true);
  emxInit_int32_T(sp, &regionLengths, 1, &o_emlrtRTEI, true);
  st.site = &i_emlrtRSI;
  bwconncomp(&st, varargin_1, &expl_temp, CC_ImageSize, &CC_NumObjects,
             CC_RegionIndices, regionLengths);
  st.site = &h_emlrtRSI;
  b_st.site = &ib_emlrtRSI;
  c_st.site = &jb_emlrtRSI;
  d_st.site = &kb_emlrtRSI;
  assertValidSizeArg(&d_st, CC_NumObjects);
  s.Centroid[0] = 0.0;
  s.Centroid[1] = 0.0;
  s.MajorAxisLength = 0.0;
  s.MinorAxisLength = 0.0;
  loop_ub = (int32_T)CC_NumObjects;
  i = outstats->size[0];
  outstats->size[0] = loop_ub;
  emxEnsureCapacity_struct0_T(&c_st, outstats, i, &h_emlrtRTEI);
  for (i = 0; i < loop_ub; i++) {
    outstats->data[i] = s;
  }

  emxInitStruct_struct_T(&c_st, &statsOneObj, &n_emlrtRTEI, true);
  st.site = &g_emlrtRSI;
  statsAlreadyComputed.Area = false;
  statsOneObj.Area = 0.0;
  statsAlreadyComputed.Centroid = false;
  statsOneObj.Centroid[0] = 0.0;
  statsOneObj.Centroid[1] = 0.0;
  statsAlreadyComputed.BoundingBox = false;
  statsOneObj.BoundingBox[0] = 0.0;
  statsOneObj.BoundingBox[1] = 0.0;
  statsOneObj.BoundingBox[2] = 0.0;
  statsOneObj.BoundingBox[3] = 0.0;
  statsAlreadyComputed.MajorAxisLength = false;
  statsOneObj.MajorAxisLength = 0.0;
  statsAlreadyComputed.MinorAxisLength = false;
  statsOneObj.MinorAxisLength = 0.0;
  statsAlreadyComputed.Eccentricity = false;
  statsOneObj.Eccentricity = 0.0;
  statsAlreadyComputed.Orientation = false;
  statsOneObj.Orientation = 0.0;
  statsAlreadyComputed.Image = false;
  statsOneObj.Image->size[0] = 0;
  statsOneObj.Image->size[1] = 0;
  statsAlreadyComputed.FilledImage = false;
  statsOneObj.FilledImage->size[0] = 0;
  statsOneObj.FilledImage->size[1] = 0;
  statsAlreadyComputed.FilledArea = false;
  statsOneObj.FilledArea = 0.0;
  statsAlreadyComputed.EulerNumber = false;
  statsOneObj.EulerNumber = 0.0;
  statsAlreadyComputed.Extrema = false;
  memset(&statsOneObj.Extrema[0], 0, 16U * sizeof(real_T));
  emxInit_struct_T(&st, &stats, 1, &m_emlrtRTEI, true);
  statsAlreadyComputed.EquivDiameter = false;
  statsOneObj.EquivDiameter = 0.0;
  statsAlreadyComputed.Extent = false;
  statsOneObj.Extent = 0.0;
  statsOneObj.PixelIdxList->size[0] = 0;
  statsAlreadyComputed.PixelList = false;
  statsOneObj.PixelList->size[0] = 0;
  statsOneObj.PixelList->size[1] = 2;
  statsAlreadyComputed.Perimeter = false;
  statsOneObj.Perimeter = 0.0;
  statsAlreadyComputed.Circularity = false;
  statsOneObj.Circularity = 0.0;
  statsAlreadyComputed.PixelValues = false;
  statsOneObj.PixelValues->size[0] = 0;
  statsAlreadyComputed.WeightedCentroid = false;
  statsAlreadyComputed.MeanIntensity = false;
  statsOneObj.MeanIntensity = 0.0;
  statsAlreadyComputed.MinIntensity = false;
  statsOneObj.MinIntensity = 0.0;
  statsAlreadyComputed.MaxIntensity = false;
  statsOneObj.MaxIntensity = 0.0;
  statsAlreadyComputed.SubarrayIdx = false;
  statsOneObj.SubarrayIdx->size[0] = 1;
  statsOneObj.SubarrayIdx->size[1] = 0;
  statsOneObj.WeightedCentroid[0] = 0.0;
  statsOneObj.SubarrayIdxLengths[0] = 0.0;
  statsOneObj.WeightedCentroid[1] = 0.0;
  statsOneObj.SubarrayIdxLengths[1] = 0.0;
  b_st.site = &lb_emlrtRSI;
  c_st.site = &kb_emlrtRSI;
  assertValidSizeArg(&c_st, CC_NumObjects);
  i = stats->size[0];
  stats->size[0] = loop_ub;
  emxEnsureCapacity_struct_T(&b_st, stats, i, &i_emlrtRTEI);
  for (i = 0; i < loop_ub; i++) {
    emxCopyStruct_struct_T(&b_st, &stats->data[i], &statsOneObj, &i_emlrtRTEI);
  }

  emxFreeStruct_struct_T(&statsOneObj);
  st.site = &f_emlrtRSI;
  statsAlreadyComputed.PixelIdxList = true;
  if (CC_NumObjects != 0.0) {
    b_st.site = &mb_emlrtRSI;
    c_st.site = &cb_emlrtRSI;
    varargin_3 = 2;
    if (regionLengths->size[0] != 1) {
      varargin_3 = 1;
    }

    d_st.site = &db_emlrtRSI;
    if ((1 == varargin_3) && (regionLengths->size[0] != 0) &&
        (regionLengths->size[0] != 1)) {
      varargin_3 = regionLengths->size[0];
      for (k = 0; k <= varargin_3 - 2; k++) {
        regionLengths->data[k + 1] += regionLengths->data[k];
      }
    }

    emxInit_int32_T(&d_st, &idxCount, 1, &p_emlrtRTEI, true);
    i = idxCount->size[0];
    idxCount->size[0] = regionLengths->size[0] + 1;
    emxEnsureCapacity_int32_T(&st, idxCount, i, &j_emlrtRTEI);
    idxCount->data[0] = 0;
    varargin_3 = regionLengths->size[0];
    for (i = 0; i < varargin_3; i++) {
      idxCount->data[i + 1] = regionLengths->data[i];
    }

    for (k = 0; k < loop_ub; k++) {
      i = k + 1;
      if ((i < 1) || (i > idxCount->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, idxCount->size[0], &i_emlrtBCI, &st);
      }

      i = (int32_T)(((real_T)k + 1.0) + 1.0);
      if ((i < 1) || (i > idxCount->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, idxCount->size[0], &h_emlrtBCI, &st);
      }

      i = idxCount->data[k + 1];
      if (idxCount->data[k] + 1 > i) {
        i1 = 0;
        i = 0;
      } else {
        i1 = idxCount->data[k] + 1;
        if ((i1 < 1) || (i1 > CC_RegionIndices->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, CC_RegionIndices->size[0],
            &g_emlrtBCI, &st);
        }

        i1--;
        if ((i < 1) || (i > CC_RegionIndices->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i, 1, CC_RegionIndices->size[0],
            &f_emlrtBCI, &st);
        }
      }

      b_stats = stats->size[0];
      i2 = k + 1;
      if ((i2 < 1) || (i2 > stats->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, stats->size[0], &emlrtBCI, &st);
      }

      varargin_3 = i - i1;
      i = stats->data[i2 - 1].PixelIdxList->size[0];
      stats->data[i2 - 1].PixelIdxList->size[0] = varargin_3;
      emxEnsureCapacity_real_T(&st, stats->data[i2 - 1].PixelIdxList, i,
        &k_emlrtRTEI);
      for (i = 0; i < varargin_3; i++) {
        i2 = k + 1;
        if ((i2 < 1) || (i2 > b_stats)) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, b_stats, &emlrtBCI, &st);
        }

        stats->data[i2 - 1].PixelIdxList->data[i] = CC_RegionIndices->data[i1 +
          i];
      }
    }

    emxFree_int32_T(&idxCount);
  }

  emxFree_int32_T(&regionLengths);
  emxFree_real_T(&CC_RegionIndices);
  st.site = &e_emlrtRSI;
  ComputeCentroid(&st, CC_ImageSize, stats, &statsAlreadyComputed);
  st.site = &d_emlrtRSI;
  ComputeEllipseParams(&st, CC_ImageSize, stats, &statsAlreadyComputed);
  st.site = &c_emlrtRSI;
  ComputeEllipseParams(&st, CC_ImageSize, stats, &statsAlreadyComputed);
  st.site = &b_emlrtRSI;
  i = stats->size[0];
  for (k = 0; k < i; k++) {
    i1 = k + 1;
    if ((i1 < 1) || (i1 > stats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, stats->size[0], &e_emlrtBCI, &st);
    }

    i1 = k + 1;
    if ((i1 < 1) || (i1 > outstats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, outstats->size[0], &d_emlrtBCI, &st);
    }

    i1 = (int32_T)(k + 1U);
    if ((i1 < 1) || (i1 > outstats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, outstats->size[0], &b_emlrtBCI, &st);
    }

    if (i1 > stats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, stats->size[0], &c_emlrtBCI, &st);
    }

    outstats->data[i1 - 1].Centroid[0] = stats->data[i1 - 1].Centroid[0];
    if (i1 > outstats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, outstats->size[0], &b_emlrtBCI, &st);
    }

    if (i1 > stats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, stats->size[0], &c_emlrtBCI, &st);
    }

    outstats->data[i1 - 1].Centroid[1] = stats->data[i1 - 1].Centroid[1];
    i2 = k + 1;
    if ((i2 < 1) || (i2 > stats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, stats->size[0], &e_emlrtBCI, &st);
    }

    i2 = k + 1;
    if ((i2 < 1) || (i2 > outstats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, outstats->size[0], &d_emlrtBCI, &st);
    }

    if (i1 > outstats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, outstats->size[0], &b_emlrtBCI, &st);
    }

    if (i1 > stats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, stats->size[0], &c_emlrtBCI, &st);
    }

    outstats->data[i1 - 1].MajorAxisLength = stats->data[i1 - 1].MajorAxisLength;
    i2 = k + 1;
    if ((i2 < 1) || (i2 > stats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, stats->size[0], &e_emlrtBCI, &st);
    }

    i2 = k + 1;
    if ((i2 < 1) || (i2 > outstats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, outstats->size[0], &d_emlrtBCI, &st);
    }

    if (i1 > outstats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, outstats->size[0], &b_emlrtBCI, &st);
    }

    if (i1 > stats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, stats->size[0], &c_emlrtBCI, &st);
    }

    outstats->data[i1 - 1].MinorAxisLength = stats->data[i1 - 1].MinorAxisLength;
  }

  emxFree_struct_T(&stats);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (regionprops.c) */
