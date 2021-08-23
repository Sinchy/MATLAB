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
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "BubbleCenterAndSizeByCircle_emxutil.h"
#include "assertValidSizeArg.h"
#include "bwconncomp.h"
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
static emlrtRSInfo nh_emlrtRSI = { 32, /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo oh_emlrtRSI = { 73, /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ph_emlrtRSI = { 75, /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo qh_emlrtRSI = { 78, /* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo rh_emlrtRSI = { 168,/* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo sh_emlrtRSI = { 197,/* lineNo */
  "regionprops",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ri_emlrtRSI = { 1277,/* lineNo */
  "parseInputsAndInitializeOutStruct", /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo si_emlrtRSI = { 1462,/* lineNo */
  "getPropsFromInputAndInitializeOutStruct",/* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ti_emlrtRSI = { 1834,/* lineNo */
  "initializeStatsStruct",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo ui_emlrtRSI = { 295,/* lineNo */
  "ComputePixelIdxList",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo vi_emlrtRSI = { 1146,/* lineNo */
  "ComputeWeightedCentroid",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo wi_emlrtRSI = { 1137,/* lineNo */
  "ComputeWeightedCentroid",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo xi_emlrtRSI = { 1132,/* lineNo */
  "ComputeWeightedCentroid",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo yi_emlrtRSI = { 1129,/* lineNo */
  "ComputeWeightedCentroid",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo aj_emlrtRSI = { 766,/* lineNo */
  "ComputePixelList",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo bj_emlrtRSI = { 764,/* lineNo */
  "ComputePixelList",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtRSInfo cj_emlrtRSI = { 19, /* lineNo */
  "ind2sub",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\ind2sub.m"/* pathName */
};

static emlrtRSInfo dj_emlrtRSI = { 22, /* lineNo */
  "cat",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pathName */
};

static emlrtRSInfo ej_emlrtRSI = { 102,/* lineNo */
  "cat_impl",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pathName */
};

static emlrtRSInfo fj_emlrtRSI = { 1115,/* lineNo */
  "ComputePixelValues",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pathName */
};

static emlrtBCInfo yc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ad_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1892,                                /* lineNo */
  42,                                  /* colNo */
  "",                                  /* aName */
  "populateOutputStatsStructure",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1890,                                /* lineNo */
  56,                                  /* colNo */
  "",                                  /* aName */
  "populateOutputStatsStructure",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  65,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo dd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  51,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ed_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  74,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  298,                                 /* lineNo */
  60,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelIdxList",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo fb_emlrtRTEI = { 1265,/* lineNo */
  5,                                   /* colNo */
  "parseInputsAndInitializeOutStruct", /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtBCInfo gd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1893,                                /* lineNo */
  17,                                  /* colNo */
  "",                                  /* aName */
  "populateOutputStatsStructure",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1893,                                /* lineNo */
  49,                                  /* colNo */
  "",                                  /* aName */
  "populateOutputStatsStructure",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo og_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1117,                                /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelValues",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1117,                                /* lineNo */
  43,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelValues",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  766,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelList",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  768,                                 /* lineNo */
  13,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelList",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1132,                                /* lineNo */
  5,                                   /* colNo */
  "",                                  /* aName */
  "ComputeWeightedCentroid",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo qb_emlrtRTEI = { 38,/* lineNo */
  15,                                  /* colNo */
  "ind2sub_indexClass",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\ind2sub.m"/* pName */
};

static emlrtBCInfo tg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1114,                                /* lineNo */
  63,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelValues",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ug_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1115,                                /* lineNo */
  39,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelValues",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1116,                                /* lineNo */
  33,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelValues",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1117,                                /* lineNo */
  19,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelValues",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo rb_emlrtRTEI = { 283,/* lineNo */
  27,                                  /* colNo */
  "check_non_axis_size",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pName */
};

static emlrtBCInfo xg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  763,                                 /* lineNo */
  27,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelList",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yg_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  764,                                 /* lineNo */
  47,                                  /* colNo */
  "",                                  /* aName */
  "ComputePixelList",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ah_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1136,                                /* lineNo */
  27,                                  /* colNo */
  "",                                  /* aName */
  "ComputeWeightedCentroid",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bh_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1138,                                /* lineNo */
  30,                                  /* colNo */
  "",                                  /* aName */
  "ComputeWeightedCentroid",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ch_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1146,                                /* lineNo */
  27,                                  /* colNo */
  "",                                  /* aName */
  "ComputeWeightedCentroid",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo g_emlrtECI = { -1,  /* nDims */
  1146,                                /* lineNo */
  21,                                  /* colNo */
  "ComputeWeightedCentroid",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtBCInfo dh_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1150,                                /* lineNo */
  9,                                   /* colNo */
  "",                                  /* aName */
  "ComputeWeightedCentroid",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo yf_emlrtRTEI = { 1277,/* lineNo */
  9,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo ag_emlrtRTEI = { 1834,/* lineNo */
  1,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo bg_emlrtRTEI = { 295,/* lineNo */
  5,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo cg_emlrtRTEI = { 298,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo dg_emlrtRTEI = { 32,/* lineNo */
  9,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo eg_emlrtRTEI = { 1,/* lineNo */
  23,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo fg_emlrtRTEI = { 1713,/* lineNo */
  5,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo gg_emlrtRTEI = { 220,/* lineNo */
  9,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo hg_emlrtRTEI = { 234,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo bi_emlrtRTEI = { 30,/* lineNo */
  1,                                   /* colNo */
  "ind2sub",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\ind2sub.m"/* pName */
};

static emlrtRTEInfo ci_emlrtRTEI = { 768,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo di_emlrtRTEI = { 1132,/* lineNo */
  5,                                   /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo ei_emlrtRTEI = { 42,/* lineNo */
  5,                                   /* colNo */
  "ind2sub",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elmat\\ind2sub.m"/* pName */
};

static emlrtRTEInfo fi_emlrtRTEI = { 1146,/* lineNo */
  21,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRTEInfo gi_emlrtRTEI = { 766,/* lineNo */
  13,                                  /* colNo */
  "regionprops",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\images\\images\\eml\\regionprops.m"/* pName */
};

static emlrtRSInfo kl_emlrtRSI = { 18, /* lineNo */
  "indexDivide",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\indexDivide.m"/* pathName */
};

/* Function Declarations */
static void ComputeWeightedCentroid(const emlrtStack *sp, const real_T
  imageSize[2], const emxArray_real_T *b_I, b_emxArray_struct_T *stats, struct_T
  *statsAlreadyComputed);
static int32_T div_s32(const emlrtStack *sp, int32_T numerator, int32_T
  denominator);

/* Function Definitions */
static void ComputeWeightedCentroid(const emlrtStack *sp, const real_T
  imageSize[2], const emxArray_real_T *b_I, b_emxArray_struct_T *stats, struct_T
  *statsAlreadyComputed)
{
  int32_T i;
  emxArray_int32_T *idx;
  emxArray_int32_T *vk;
  int32_T k;
  int32_T i1;
  int32_T i2;
  real_T wc_idx_0;
  int32_T wc_idx_1;
  emxArray_real_T *b_stats;
  int32_T hi;
  int32_T loop_ub;
  int32_T hi_tmp;
  real_T sumIntensity;
  boolean_T exitg1;
  real_T M;
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
  statsAlreadyComputed->WeightedCentroid = true;
  st.site = &yi_emlrtRSI;
  statsAlreadyComputed->PixelList = true;
  i = stats->size[0];
  emxInit_int32_T(&st, &idx, 1, &bi_emlrtRTEI, true);
  emxInit_int32_T(&st, &vk, 1, &ei_emlrtRTEI, true);
  for (k = 0; k < i; k++) {
    i1 = stats->size[0];
    i2 = k + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &xg_emlrtBCI, &st);
    }

    if (stats->data[k].PixelIdxList->size[0] != 0) {
      b_st.site = &bj_emlrtRSI;
      i1 = stats->size[0];
      i2 = k + 1;
      if ((i2 < 1) || (i2 > i1)) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &yg_emlrtBCI, &b_st);
      }

      c_st.site = &cj_emlrtRSI;
      i1 = idx->size[0];
      idx->size[0] = stats->data[k].PixelIdxList->size[0];
      emxEnsureCapacity_int32_T(&c_st, idx, i1, &bi_emlrtRTEI);
      loop_ub = stats->data[k].PixelIdxList->size[0];
      for (i1 = 0; i1 < loop_ub; i1++) {
        idx->data[i1] = (int32_T)stats->data[k].PixelIdxList->data[i1];
      }

      hi_tmp = (int32_T)imageSize[0];
      hi = hi_tmp * (int32_T)imageSize[1];
      loop_ub = 0;
      exitg1 = false;
      while ((!exitg1) && (loop_ub <= idx->size[0] - 1)) {
        if ((idx->data[loop_ub] >= 1) && (idx->data[loop_ub] <= hi)) {
          loop_ub++;
        } else {
          emlrtErrorWithMessageIdR2018a(&c_st, &qb_emlrtRTEI,
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
      emxEnsureCapacity_int32_T(&c_st, vk, i1, &ei_emlrtRTEI);
      loop_ub = idx->size[0];
      for (i1 = 0; i1 < loop_ub; i1++) {
        d_st.site = &kl_emlrtRSI;
        vk->data[i1] = div_s32(&d_st, idx->data[i1], hi_tmp);
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

      b_st.site = &aj_emlrtRSI;
      c_st.site = &dj_emlrtRSI;
      d_st.site = &ej_emlrtRSI;
      if (idx->size[0] != vk->size[0]) {
        emlrtErrorWithMessageIdR2018a(&d_st, &rb_emlrtRTEI,
          "MATLAB:catenate:matrixDimensionMismatch",
          "MATLAB:catenate:matrixDimensionMismatch", 0);
      }

      hi = stats->size[0];
      i1 = (int32_T)(k + 1U);
      if ((i1 < 1) || (i1 > hi)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, hi, &qg_emlrtBCI, &c_st);
      }

      i2 = stats->data[i1 - 1].PixelList->size[0] * stats->data[i1 - 1].
        PixelList->size[1];
      stats->data[i1 - 1].PixelList->size[0] = vk->size[0];
      emxEnsureCapacity_real_T(&c_st, stats->data[i1 - 1].PixelList, i2,
        &gi_emlrtRTEI);
      i1 = (int32_T)(k + 1U);
      if ((i1 < 1) || (i1 > hi)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, hi, &qg_emlrtBCI, &c_st);
      }

      i2 = stats->data[i1 - 1].PixelList->size[0] * stats->data[i1 - 1].
        PixelList->size[1];
      stats->data[i1 - 1].PixelList->size[1] = 2;
      emxEnsureCapacity_real_T(&c_st, stats->data[i1 - 1].PixelList, i2,
        &gi_emlrtRTEI);
      loop_ub = vk->size[0];
      for (i1 = 0; i1 < loop_ub; i1++) {
        i2 = (int32_T)(k + 1U);
        if ((i2 < 1) || (i2 > hi)) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, hi, &qg_emlrtBCI, &c_st);
        }

        stats->data[i2 - 1].PixelList->data[i1] = vk->data[i1];
      }

      loop_ub = idx->size[0];
      for (i1 = 0; i1 < loop_ub; i1++) {
        i2 = (int32_T)(k + 1U);
        if ((i2 < 1) || (i2 > hi)) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, hi, &qg_emlrtBCI, &c_st);
        }

        stats->data[i2 - 1].PixelList->data[i1 + stats->data[i2 - 1]
          .PixelList->size[0]] = idx->data[i1];
      }
    } else {
      i1 = stats->size[0];
      i2 = (int32_T)(k + 1U);
      if ((i2 < 1) || (i2 > i1)) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &rg_emlrtBCI, &st);
      }

      stats->data[i2 - 1].PixelList->size[0] = 0;
      i1 = stats->size[0];
      if (i2 > i1) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &rg_emlrtBCI, &st);
      }

      i1 = stats->data[i2 - 1].PixelList->size[0] * stats->data[i2 - 1].
        PixelList->size[1];
      stats->data[i2 - 1].PixelList->size[1] = 2;
      emxEnsureCapacity_real_T(&st, stats->data[i2 - 1].PixelList, i1,
        &ci_emlrtRTEI);
      i1 = stats->size[0];
      if (i2 > i1) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &rg_emlrtBCI, &st);
      }

      i1 = stats->size[0];
      if (i2 > i1) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &rg_emlrtBCI, &st);
      }
    }
  }

  st.site = &xi_emlrtRSI;
  statsAlreadyComputed->PixelValues = true;
  i = stats->size[0];
  if (0 <= i - 1) {
    wc_idx_0 = b_I->size[0];
    wc_idx_1 = b_I->size[1];
  }

  for (k = 0; k < i; k++) {
    i1 = stats->size[0];
    i2 = k + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &tg_emlrtBCI, &st);
    }

    hi = stats->size[0];
    i1 = (int32_T)(k + 1U);
    if ((i1 < 1) || (i1 > hi)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, hi, &sg_emlrtBCI, &st);
    }

    i2 = stats->data[i1 - 1].PixelValues->size[0];
    stats->data[i1 - 1].PixelValues->size[0] = stats->data[k].PixelIdxList->
      size[0];
    emxEnsureCapacity_real_T(&st, stats->data[i1 - 1].PixelValues, i2,
      &di_emlrtRTEI);
    b_st.site = &fj_emlrtRSI;
    i1 = stats->size[0];
    i2 = k + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &ug_emlrtBCI, &b_st);
    }

    c_st.site = &cj_emlrtRSI;
    i1 = idx->size[0];
    idx->size[0] = stats->data[k].PixelIdxList->size[0];
    emxEnsureCapacity_int32_T(&c_st, idx, i1, &bi_emlrtRTEI);
    loop_ub = stats->data[k].PixelIdxList->size[0];
    for (i1 = 0; i1 < loop_ub; i1++) {
      idx->data[i1] = (int32_T)stats->data[k].PixelIdxList->data[i1];
    }

    hi_tmp = (int32_T)(uint32_T)wc_idx_0;
    hi = hi_tmp * wc_idx_1;
    loop_ub = 0;
    exitg1 = false;
    while ((!exitg1) && (loop_ub <= idx->size[0] - 1)) {
      if ((idx->data[loop_ub] >= 1) && (idx->data[loop_ub] <= hi)) {
        loop_ub++;
      } else {
        emlrtErrorWithMessageIdR2018a(&c_st, &qb_emlrtRTEI,
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
    emxEnsureCapacity_int32_T(&c_st, vk, i1, &ei_emlrtRTEI);
    loop_ub = idx->size[0];
    for (i1 = 0; i1 < loop_ub; i1++) {
      d_st.site = &kl_emlrtRSI;
      vk->data[i1] = div_s32(&d_st, idx->data[i1], hi_tmp);
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

    i1 = stats->size[0];
    i2 = k + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &vg_emlrtBCI, &st);
    }

    i1 = stats->data[k].PixelValues->size[0];
    for (loop_ub = 0; loop_ub < i1; loop_ub++) {
      i2 = stats->size[0];
      hi_tmp = k + 1;
      if ((hi_tmp < 1) || (hi_tmp > i2)) {
        emlrtDynamicBoundsCheckR2012b(hi_tmp, 1, i2, &wg_emlrtBCI, &st);
      }

      i2 = stats->data[k].PixelValues->size[0];
      hi_tmp = (int32_T)(loop_ub + 1U);
      if ((hi_tmp < 1) || (hi_tmp > i2)) {
        emlrtDynamicBoundsCheckR2012b(hi_tmp, 1, i2, &og_emlrtBCI, &st);
      }

      if (hi_tmp > vk->size[0]) {
        emlrtDynamicBoundsCheckR2012b(hi_tmp, 1, vk->size[0], &pg_emlrtBCI, &st);
      }

      i2 = vk->data[hi_tmp - 1];
      if ((i2 < 1) || (i2 > b_I->size[1])) {
        emlrtDynamicBoundsCheckR2012b(vk->data[hi_tmp - 1], 1, b_I->size[1],
          &pg_emlrtBCI, &st);
      }

      if (hi_tmp > idx->size[0]) {
        emlrtDynamicBoundsCheckR2012b(hi_tmp, 1, idx->size[0], &pg_emlrtBCI, &st);
      }

      hi = idx->data[hi_tmp - 1];
      if ((hi < 1) || (hi > b_I->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx->data[hi_tmp - 1], 1, b_I->size[0],
          &pg_emlrtBCI, &st);
      }

      stats->data[k].PixelValues->data[hi_tmp - 1] = b_I->data[(hi + b_I->size[0]
        * (i2 - 1)) - 1];
    }
  }

  emxFree_int32_T(&vk);
  emxFree_int32_T(&idx);
  i = stats->size[0];
  emxInit_real_T(sp, &b_stats, 1, &fi_emlrtRTEI, true);
  for (k = 0; k < i; k++) {
    i1 = stats->size[0];
    i2 = k + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &ah_emlrtBCI, sp);
    }

    st.site = &wi_emlrtRSI;
    sumIntensity = sum(&st, stats->data[k].PixelValues);
    i1 = stats->size[0];
    i2 = k + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &bh_emlrtBCI, sp);
    }

    i1 = stats->data[k].PixelList->size[0];
    loop_ub = stats->data[k].PixelList->size[0];
    i2 = stats->size[0];
    hi_tmp = k + 1;
    if ((hi_tmp < 1) || (hi_tmp > i2)) {
      emlrtDynamicBoundsCheckR2012b(hi_tmp, 1, i2, &ch_emlrtBCI, sp);
    }

    i2 = stats->data[k].PixelValues->size[0];
    if (i1 != i2) {
      emlrtSizeEqCheck1DR2012b(i1, i2, &g_emlrtECI, sp);
    }

    i2 = b_stats->size[0];
    b_stats->size[0] = loop_ub;
    emxEnsureCapacity_real_T(sp, b_stats, i2, &fi_emlrtRTEI);
    for (i2 = 0; i2 < loop_ub; i2++) {
      b_stats->data[i2] = stats->data[k].PixelList->data[i2] * stats->data[k].
        PixelValues->data[i2];
    }

    st.site = &vi_emlrtRSI;
    M = sum(&st, b_stats);
    wc_idx_0 = M / sumIntensity;
    i2 = stats->size[0];
    hi_tmp = k + 1;
    if ((hi_tmp < 1) || (hi_tmp > i2)) {
      emlrtDynamicBoundsCheckR2012b(hi_tmp, 1, i2, &ch_emlrtBCI, sp);
    }

    i2 = stats->data[k].PixelValues->size[0];
    if (i1 != i2) {
      emlrtSizeEqCheck1DR2012b(i1, i2, &g_emlrtECI, sp);
    }

    i1 = b_stats->size[0];
    b_stats->size[0] = loop_ub;
    emxEnsureCapacity_real_T(sp, b_stats, i1, &fi_emlrtRTEI);
    for (i2 = 0; i2 < loop_ub; i2++) {
      b_stats->data[i2] = stats->data[k].PixelList->data[i2 + stats->data[k].
        PixelList->size[0]] * stats->data[k].PixelValues->data[i2];
    }

    st.site = &vi_emlrtRSI;
    M = sum(&st, b_stats);
    hi = stats->size[0];
    i1 = (int32_T)(k + 1U);
    if ((i1 < 1) || (i1 > hi)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, hi, &dh_emlrtBCI, sp);
    }

    stats->data[i1 - 1].WeightedCentroid[0] = wc_idx_0;
    if (i1 > hi) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, hi, &dh_emlrtBCI, sp);
    }

    stats->data[i1 - 1].WeightedCentroid[1] = M / sumIntensity;
  }

  emxFree_real_T(&b_stats);
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
                 const emxArray_real_T *varargin_2, emxArray_struct_T *outstats)
{
  emxArray_real_T *CC_RegionIndices;
  emxArray_int32_T *regionLengths;
  real_T expl_temp;
  real_T CC_ImageSize[2];
  real_T CC_NumObjects;
  uint32_T b_varargin_2[2];
  boolean_T p;
  int32_T k;
  boolean_T exitg1;
  boolean_T b_p;
  b_struct_T statsOneObj;
  int32_T loop_ub;
  int32_T i;
  c_struct_T b_statsOneObj;
  struct_T statsAlreadyComputed;
  b_emxArray_struct_T *stats;
  int32_T varargin_3;
  emxArray_int32_T *idxCount;
  int32_T i1;
  int32_T b_stats;
  int32_T i2;
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
  emxInit_real_T(sp, &CC_RegionIndices, 1, &dg_emlrtRTEI, true);
  emxInit_int32_T(sp, &regionLengths, 1, &gg_emlrtRTEI, true);
  st.site = &nh_emlrtRSI;
  bwconncomp(&st, varargin_1, &expl_temp, CC_ImageSize, &CC_NumObjects,
             CC_RegionIndices, regionLengths);
  st.site = &oh_emlrtRSI;
  b_varargin_2[0] = (uint32_T)varargin_2->size[0];
  b_varargin_2[1] = (uint32_T)varargin_2->size[1];
  p = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!(CC_ImageSize[k] == b_varargin_2[k])) {
      p = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  b_p = (int32_T)p;
  if (!b_p) {
    emlrtErrorWithMessageIdR2018a(&st, &fb_emlrtRTEI,
      "images:regionprops:sizeMismatch", "images:regionprops:sizeMismatch", 0);
  }

  b_st.site = &ri_emlrtRSI;
  statsOneObj.WeightedCentroid[0] = 0.0;
  statsOneObj.WeightedCentroid[1] = 0.0;
  c_st.site = &si_emlrtRSI;
  d_st.site = &nb_emlrtRSI;
  b_assertValidSizeArg(&d_st, CC_NumObjects);
  loop_ub = (int32_T)CC_NumObjects;
  i = outstats->size[0];
  outstats->size[0] = loop_ub;
  emxEnsureCapacity_struct_T(&c_st, outstats, i, &yf_emlrtRTEI);
  for (i = 0; i < loop_ub; i++) {
    outstats->data[i] = statsOneObj;
  }

  emxInitStruct_struct_T(&c_st, &b_statsOneObj, &fg_emlrtRTEI, true);
  st.site = &ph_emlrtRSI;
  statsAlreadyComputed.Area = false;
  b_statsOneObj.Area = 0.0;
  statsAlreadyComputed.Centroid = false;
  b_statsOneObj.Centroid[0] = 0.0;
  b_statsOneObj.Centroid[1] = 0.0;
  statsAlreadyComputed.BoundingBox = false;
  b_statsOneObj.BoundingBox[0] = 0.0;
  b_statsOneObj.BoundingBox[1] = 0.0;
  b_statsOneObj.BoundingBox[2] = 0.0;
  b_statsOneObj.BoundingBox[3] = 0.0;
  statsAlreadyComputed.MajorAxisLength = false;
  b_statsOneObj.MajorAxisLength = 0.0;
  statsAlreadyComputed.MinorAxisLength = false;
  b_statsOneObj.MinorAxisLength = 0.0;
  statsAlreadyComputed.Eccentricity = false;
  b_statsOneObj.Eccentricity = 0.0;
  statsAlreadyComputed.Orientation = false;
  b_statsOneObj.Orientation = 0.0;
  statsAlreadyComputed.Image = false;
  b_statsOneObj.Image.size[0] = 0;
  b_statsOneObj.Image.size[1] = 0;
  statsAlreadyComputed.FilledImage = false;
  b_statsOneObj.FilledImage.size[0] = 0;
  b_statsOneObj.FilledImage.size[1] = 0;
  statsAlreadyComputed.FilledArea = false;
  b_statsOneObj.FilledArea = 0.0;
  statsAlreadyComputed.EulerNumber = false;
  b_statsOneObj.EulerNumber = 0.0;
  statsAlreadyComputed.Extrema = false;
  memset(&b_statsOneObj.Extrema[0], 0, 16U * sizeof(real_T));
  emxInit_struct_T1(&st, &stats, 1, &eg_emlrtRTEI, true);
  statsAlreadyComputed.EquivDiameter = false;
  b_statsOneObj.EquivDiameter = 0.0;
  statsAlreadyComputed.Extent = false;
  b_statsOneObj.Extent = 0.0;
  b_statsOneObj.PixelIdxList->size[0] = 0;
  statsAlreadyComputed.PixelList = false;
  b_statsOneObj.PixelList->size[0] = 0;
  b_statsOneObj.PixelList->size[1] = 2;
  statsAlreadyComputed.Perimeter = false;
  b_statsOneObj.Perimeter = 0.0;
  statsAlreadyComputed.Circularity = false;
  b_statsOneObj.Circularity = 0.0;
  statsAlreadyComputed.PixelValues = false;
  b_statsOneObj.PixelValues->size[0] = 0;
  statsAlreadyComputed.WeightedCentroid = false;
  statsAlreadyComputed.MeanIntensity = false;
  b_statsOneObj.MeanIntensity = 0.0;
  statsAlreadyComputed.MinIntensity = false;
  b_statsOneObj.MinIntensity = 0.0;
  statsAlreadyComputed.MaxIntensity = false;
  b_statsOneObj.MaxIntensity = 0.0;
  statsAlreadyComputed.SubarrayIdx = false;
  b_statsOneObj.SubarrayIdx.size[0] = 1;
  b_statsOneObj.SubarrayIdx.size[1] = 0;
  b_statsOneObj.WeightedCentroid[0] = 0.0;
  b_statsOneObj.SubarrayIdxLengths[0] = 0.0;
  b_statsOneObj.WeightedCentroid[1] = 0.0;
  b_statsOneObj.SubarrayIdxLengths[1] = 0.0;
  b_st.site = &ti_emlrtRSI;
  c_st.site = &nb_emlrtRSI;
  b_assertValidSizeArg(&c_st, CC_NumObjects);
  i = stats->size[0];
  stats->size[0] = loop_ub;
  emxEnsureCapacity_struct_T1(&b_st, stats, i, &ag_emlrtRTEI);
  for (i = 0; i < loop_ub; i++) {
    emxCopyStruct_struct_T(&b_st, &stats->data[i], &b_statsOneObj, &ag_emlrtRTEI);
  }

  emxFreeStruct_struct_T(&b_statsOneObj);
  st.site = &qh_emlrtRSI;
  statsAlreadyComputed.PixelIdxList = true;
  if (CC_NumObjects != 0.0) {
    b_st.site = &ui_emlrtRSI;
    c_st.site = &li_emlrtRSI;
    varargin_3 = 2;
    if (regionLengths->size[0] != 1) {
      varargin_3 = 1;
    }

    d_st.site = &mi_emlrtRSI;
    if ((1 == varargin_3) && (regionLengths->size[0] != 0) &&
        (regionLengths->size[0] != 1)) {
      varargin_3 = regionLengths->size[0];
      for (k = 0; k <= varargin_3 - 2; k++) {
        regionLengths->data[k + 1] += regionLengths->data[k];
      }
    }

    emxInit_int32_T(&d_st, &idxCount, 1, &hg_emlrtRTEI, true);
    i = idxCount->size[0];
    idxCount->size[0] = regionLengths->size[0] + 1;
    emxEnsureCapacity_int32_T(&st, idxCount, i, &bg_emlrtRTEI);
    idxCount->data[0] = 0;
    varargin_3 = regionLengths->size[0];
    for (i = 0; i < varargin_3; i++) {
      idxCount->data[i + 1] = regionLengths->data[i];
    }

    for (k = 0; k < loop_ub; k++) {
      i = k + 1;
      if ((i < 1) || (i > idxCount->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, idxCount->size[0], &fd_emlrtBCI, &st);
      }

      i = (int32_T)(((real_T)k + 1.0) + 1.0);
      if ((i < 1) || (i > idxCount->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, idxCount->size[0], &ed_emlrtBCI, &st);
      }

      i = idxCount->data[k + 1];
      if (idxCount->data[k] + 1 > i) {
        i1 = 0;
        i = 0;
      } else {
        i1 = idxCount->data[k] + 1;
        if ((i1 < 1) || (i1 > CC_RegionIndices->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, CC_RegionIndices->size[0],
            &dd_emlrtBCI, &st);
        }

        i1--;
        if ((i < 1) || (i > CC_RegionIndices->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i, 1, CC_RegionIndices->size[0],
            &cd_emlrtBCI, &st);
        }
      }

      b_stats = stats->size[0];
      i2 = k + 1;
      if ((i2 < 1) || (i2 > stats->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, stats->size[0], &yc_emlrtBCI, &st);
      }

      varargin_3 = i - i1;
      i = stats->data[i2 - 1].PixelIdxList->size[0];
      stats->data[i2 - 1].PixelIdxList->size[0] = varargin_3;
      emxEnsureCapacity_real_T(&st, stats->data[i2 - 1].PixelIdxList, i,
        &cg_emlrtRTEI);
      for (i = 0; i < varargin_3; i++) {
        i2 = k + 1;
        if ((i2 < 1) || (i2 > b_stats)) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, b_stats, &yc_emlrtBCI, &st);
        }

        stats->data[i2 - 1].PixelIdxList->data[i] = CC_RegionIndices->data[i1 +
          i];
      }
    }

    emxFree_int32_T(&idxCount);
  }

  emxFree_int32_T(&regionLengths);
  emxFree_real_T(&CC_RegionIndices);
  st.site = &rh_emlrtRSI;
  ComputeWeightedCentroid(&st, CC_ImageSize, varargin_2, stats,
    &statsAlreadyComputed);
  st.site = &sh_emlrtRSI;
  i = stats->size[0];
  for (k = 0; k < i; k++) {
    i1 = k + 1;
    if ((i1 < 1) || (i1 > stats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, stats->size[0], &bd_emlrtBCI, &st);
    }

    i1 = k + 1;
    if ((i1 < 1) || (i1 > outstats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, outstats->size[0], &ad_emlrtBCI, &st);
    }

    i1 = (int32_T)(k + 1U);
    if ((i1 < 1) || (i1 > outstats->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, outstats->size[0], &gd_emlrtBCI, &st);
    }

    if (i1 > stats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, stats->size[0], &hd_emlrtBCI, &st);
    }

    outstats->data[i1 - 1].WeightedCentroid[0] = stats->data[i1 - 1].
      WeightedCentroid[0];
    if (i1 > outstats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, outstats->size[0], &gd_emlrtBCI, &st);
    }

    if (i1 > stats->size[0]) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, stats->size[0], &hd_emlrtBCI, &st);
    }

    outstats->data[i1 - 1].WeightedCentroid[1] = stats->data[i1 - 1].
      WeightedCentroid[1];
  }

  emxFree_struct_T1(&stats);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (regionprops.c) */
