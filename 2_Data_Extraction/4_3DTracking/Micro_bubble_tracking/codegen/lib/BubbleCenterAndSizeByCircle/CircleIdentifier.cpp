//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  CircleIdentifier.cpp
//
//  Code generation for function 'CircleIdentifier'
//


// Include files
#include "CircleIdentifier.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "chaccum.h"
#include "chcenters.h"
#include "chradii.h"
#include "rt_nonfinite.h"

// Function Definitions
void CircleIdentifier::BubbleCenterAndSizeByCircle(const coder::array<bool, 2U>
  &img, double rmin, double rmax, double sense, coder::array<double, 2U>
  &centers, coder::array<double, 2U> &radii)
{
  int radiusRange_size[2];
  double radiusRange_data[2];
  coder::array<creal_T, 2U> accumMatrix;
  coder::array<float, 2U> gradientImg;
  bool y;
  int nx;
  bool exitg1;
  coder::array<double, 2U> b_centers;
  coder::array<double, 2U> metric;
  coder::array<bool, 2U> x;
  coder::array<int, 1U> b_ii;
  coder::array<double, 1U> idx2Keep;

  //      s = regionprops(img,'Centroid','MajorAxisLength','MinorAxisLength');
  if (rmin == rmax) {
    radiusRange_size[0] = 1;
    radiusRange_size[1] = 1;
    radiusRange_data[0] = rmin;
  } else {
    radiusRange_size[0] = 1;
    radiusRange_size[1] = 2;
    radiusRange_data[0] = rmin;
    radiusRange_data[1] = rmax;
  }

  centers.set_size(0, 0);
  radii.set_size(0, 0);
  chaccum(img, radiusRange_data, radiusRange_size, accumMatrix, gradientImg);
  y = false;
  nx = 0;
  exitg1 = false;
  while ((!exitg1) && (nx + 1 <= accumMatrix.size(0) * accumMatrix.size(1))) {
    if (((accumMatrix[nx].re == 0.0) && (accumMatrix[nx].im == 0.0)) || (rtIsNaN
         (accumMatrix[nx].re) || rtIsNaN(accumMatrix[nx].im))) {
      nx++;
    } else {
      y = true;
      exitg1 = true;
    }
  }

  if (y) {
    int ii;
    chcenters(accumMatrix, 1.0 - sense, b_centers, metric);
    centers.set_size(b_centers.size(0), b_centers.size(1));
    nx = b_centers.size(0) * b_centers.size(1);
    for (ii = 0; ii < nx; ii++) {
      centers[ii] = b_centers[ii];
    }

    if ((b_centers.size(0) != 0) && (b_centers.size(1) != 0)) {
      int idx;
      x.set_size(metric.size(0), metric.size(1));
      nx = metric.size(0) * metric.size(1);
      for (ii = 0; ii < nx; ii++) {
        x[ii] = (metric[ii] >= 1.0 - sense);
      }

      nx = x.size(0) * x.size(1);
      idx = 0;
      b_ii.set_size(nx);
      ii = 0;
      exitg1 = false;
      while ((!exitg1) && (ii <= nx - 1)) {
        if (x[ii]) {
          idx++;
          b_ii[idx - 1] = ii + 1;
          if (idx >= nx) {
            exitg1 = true;
          } else {
            ii++;
          }
        } else {
          ii++;
        }
      }

      if (nx == 1) {
        if (idx == 0) {
          b_ii.set_size(0);
        }
      } else {
        if (1 > idx) {
          idx = 0;
        }

        b_ii.set_size(idx);
      }

      idx2Keep.set_size(b_ii.size(0));
      nx = b_ii.size(0);
      for (ii = 0; ii < nx; ii++) {
        idx2Keep[ii] = b_ii[ii];
      }

      nx = b_centers.size(1);
      centers.set_size(idx2Keep.size(0), b_centers.size(1));
      for (ii = 0; ii < nx; ii++) {
        idx = idx2Keep.size(0);
        for (int i = 0; i < idx; i++) {
          centers[i + centers.size(0) * ii] = b_centers[(static_cast<int>
            (idx2Keep[i]) + b_centers.size(0) * ii) - 1];
        }
      }

      if (idx2Keep.size(0) == 0) {
        centers.set_size(0, 0);
      } else if (radiusRange_size[1] == 1) {
        radii.set_size(idx2Keep.size(0), 1);
        nx = idx2Keep.size(0);
        for (idx = 0; idx < nx; idx++) {
          radii[idx] = radiusRange_data[0];
        }
      } else {
        chradii(centers, gradientImg, radiusRange_data, idx2Keep);
        radii.set_size(idx2Keep.size(0), 1);
        nx = idx2Keep.size(0);
        for (ii = 0; ii < nx; ii++) {
          radii[ii] = idx2Keep[ii];
        }
      }
    }
  }
}

CircleIdentifier::~CircleIdentifier()
{
  omp_destroy_nest_lock(&emlrtNestLockGlobal);
}

CircleIdentifier::CircleIdentifier()
{
  rt_InitInfAndNaN();
  omp_init_nest_lock(&emlrtNestLockGlobal);
}

// End of code generation (CircleIdentifier.cpp)
