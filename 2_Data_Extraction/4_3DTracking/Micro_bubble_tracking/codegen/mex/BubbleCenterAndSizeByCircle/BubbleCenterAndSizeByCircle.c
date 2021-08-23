/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BubbleCenterAndSizeByCircle.c
 *
 * Code generation for function 'BubbleCenterAndSizeByCircle'
 *
 */

/* Include files */
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "imfindcircles.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 3,     /* lineNo */
  "BubbleCenterAndSizeByCircle",       /* fcnName */
  "D:\\0.Code\\MATLAB\\2_Data_Extraction\\4_3DTracking\\Micro_bubble_tracking\\BubbleCenterAndSizeByCircle.m"/* pathName */
};

/* Function Definitions */
void BubbleCenterAndSizeByCircle(const emlrtStack *sp, const emxArray_boolean_T *
  img, real_T rmin, real_T rmax, real_T sense, emxArray_real_T *centers,
  emxArray_real_T *radii)
{
  real_T b_rmin[2];
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  covrtLogFcn(&emlrtCoverageInstance, 0U, 0U);
  covrtLogBasicBlock(&emlrtCoverageInstance, 0U, 0U);

  /*      s = regionprops(img,'Centroid','MajorAxisLength','MinorAxisLength'); */
  b_rmin[0] = rmin;
  b_rmin[1] = rmax;
  st.site = &emlrtRSI;
  imfindcircles(&st, img, b_rmin, sense, centers, radii);
}

/* End of code generation (BubbleCenterAndSizeByCircle.c) */
