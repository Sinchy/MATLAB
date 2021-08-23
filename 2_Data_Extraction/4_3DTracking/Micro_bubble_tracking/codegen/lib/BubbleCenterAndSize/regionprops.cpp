//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  regionprops.cpp
//
//  Code generation for function 'regionprops'
//


// Include files
#include "regionprops.h"
#include "BubbleIdentifier.h"
#include <cmath>

// Function Declarations
static void ComputePixelList(const double imageSize[2], coder::array<b_struct_T,
  1U> &stats, struct_T *statsAlreadyComputed);
static int div_s32(int numerator, int denominator);

// Function Definitions
static void ComputePixelList(const double imageSize[2], coder::array<b_struct_T,
  1U> &stats, struct_T *statsAlreadyComputed)
{
  coder::array<int, 1U> v1;
  coder::array<int, 1U> vk;
  if (!statsAlreadyComputed->PixelList) {
    int i;
    statsAlreadyComputed->PixelList = true;
    i = stats.size(0);
    for (int k = 0; k < i; k++) {
      if (stats[k].PixelIdxList.size(0) != 0) {
        int loop_ub;
        int i1;
        v1.set_size(stats[k].PixelIdxList.size(0));
        loop_ub = stats[k].PixelIdxList.size(0);
        for (i1 = 0; i1 < loop_ub; i1++) {
          v1[i1] = static_cast<int>(stats[k].PixelIdxList[i1]) - 1;
        }

        vk.set_size(v1.size(0));
        loop_ub = v1.size(0);
        for (i1 = 0; i1 < loop_ub; i1++) {
          vk[i1] = div_s32(v1[i1], static_cast<int>(imageSize[0]));
        }

        loop_ub = v1.size(0);
        for (i1 = 0; i1 < loop_ub; i1++) {
          v1[i1] = v1[i1] - vk[i1] * static_cast<int>(imageSize[0]);
        }

        stats[k].PixelList.set_size(vk.size(0), 2);
        loop_ub = vk.size(0);
        for (i1 = 0; i1 < loop_ub; i1++) {
          stats[k].PixelList[i1] = vk[i1] + 1;
        }

        loop_ub = v1.size(0);
        for (i1 = 0; i1 < loop_ub; i1++) {
          stats[k].PixelList[i1 + stats[k].PixelList.size(0)] = v1[i1] + 1;
        }
      } else {
        stats[k].PixelList.set_size(0, 2);
      }
    }
  }
}

static int div_s32(int numerator, int denominator)
{
  int quotient;
  unsigned int b_numerator;
  if (denominator == 0) {
    if (numerator >= 0) {
      quotient = MAX_int32_T;
    } else {
      quotient = MIN_int32_T;
    }
  } else {
    unsigned int b_denominator;
    if (numerator < 0) {
      b_numerator = ~static_cast<unsigned int>(numerator) + 1U;
    } else {
      b_numerator = static_cast<unsigned int>(numerator);
    }

    if (denominator < 0) {
      b_denominator = ~static_cast<unsigned int>(denominator) + 1U;
    } else {
      b_denominator = static_cast<unsigned int>(denominator);
    }

    b_numerator /= b_denominator;
    if ((numerator < 0) != (denominator < 0)) {
      quotient = -static_cast<int>(b_numerator);
    } else {
      quotient = static_cast<int>(b_numerator);
    }
  }

  return quotient;
}

void ComputeCentroid(const double imageSize[2], coder::array<b_struct_T, 1U>
                     &stats, struct_T *statsAlreadyComputed)
{
  double y_idx_0;
  double y_idx_1;
  if (!statsAlreadyComputed->Centroid) {
    int i;
    statsAlreadyComputed->Centroid = true;
    ComputePixelList(imageSize, stats, statsAlreadyComputed);
    i = stats.size(0);
    for (int k = 0; k < i; k++) {
      int vlen;
      vlen = stats[k].PixelList.size(0);
      if (stats[k].PixelList.size(0) == 0) {
        y_idx_0 = 0.0;
        y_idx_1 = 0.0;
      } else {
        int b_k;
        int xpageoffset;
        y_idx_0 = stats[k].PixelList[0];
        for (b_k = 2; b_k <= vlen; b_k++) {
          y_idx_0 += stats[k].PixelList[b_k - 1];
        }

        xpageoffset = stats[k].PixelList.size(0);
        y_idx_1 = stats[k].PixelList[xpageoffset];
        for (b_k = 2; b_k <= vlen; b_k++) {
          y_idx_1 += stats[k].PixelList[(xpageoffset + b_k) - 1];
        }
      }

      vlen = stats[k].PixelList.size(0);
      stats[k].Centroid[0] = y_idx_0 / static_cast<double>(vlen);
      stats[k].Centroid[1] = y_idx_1 / static_cast<double>(vlen);
    }
  }
}

void ComputeEllipseParams(const double imageSize[2], coder::array<b_struct_T, 1U>
  &stats, struct_T *statsAlreadyComputed)
{
  double den;
  coder::array<double, 1U> x;
  coder::array<double, 1U> y;
  coder::array<double, 1U> b_y;
  if ((!statsAlreadyComputed->MajorAxisLength) ||
      (!statsAlreadyComputed->MinorAxisLength) ||
      (!statsAlreadyComputed->Orientation) ||
      (!statsAlreadyComputed->Eccentricity)) {
    int i;
    statsAlreadyComputed->MajorAxisLength = true;
    statsAlreadyComputed->MinorAxisLength = true;
    statsAlreadyComputed->Eccentricity = true;
    statsAlreadyComputed->Orientation = true;
    ComputePixelList(imageSize, stats, statsAlreadyComputed);
    ComputeCentroid(imageSize, stats, statsAlreadyComputed);
    i = stats.size(0);
    for (int k = 0; k < i; k++) {
      if (stats[k].PixelList.size(0) == 0) {
        stats[k].MajorAxisLength = 0.0;
        stats[k].MinorAxisLength = 0.0;
        stats[k].Eccentricity = 0.0;
        stats[k].Orientation = 0.0;
      } else {
        int nx;
        int b_k;
        double uxx;
        double uyy;
        double uxy;
        double a_tmp;
        double common_tmp;
        double b_common_tmp;
        double num;
        den = stats[k].Centroid[0];
        nx = stats[k].PixelList.size(0);
        x.set_size(nx);
        for (b_k = 0; b_k < nx; b_k++) {
          x[b_k] = stats[k].PixelList[b_k] - den;
        }

        den = stats[k].Centroid[1];
        nx = stats[k].PixelList.size(0);
        y.set_size(nx);
        for (b_k = 0; b_k < nx; b_k++) {
          y[b_k] = -(stats[k].PixelList[b_k + stats[k].PixelList.size(0)] - den);
        }

        b_y.set_size(x.size(0));
        nx = x.size(0);
        for (b_k = 0; b_k < nx; b_k++) {
          b_y[b_k] = x[b_k] * x[b_k];
        }

        nx = b_y.size(0);
        if (b_y.size(0) == 0) {
          den = 0.0;
        } else {
          den = b_y[0];
          for (b_k = 2; b_k <= nx; b_k++) {
            den += b_y[b_k - 1];
          }
        }

        uxx = den / static_cast<double>(x.size(0)) + 0.083333333333333329;
        b_y.set_size(y.size(0));
        nx = y.size(0);
        for (b_k = 0; b_k < nx; b_k++) {
          b_y[b_k] = y[b_k] * y[b_k];
        }

        nx = b_y.size(0);
        if (b_y.size(0) == 0) {
          den = 0.0;
        } else {
          den = b_y[0];
          for (b_k = 2; b_k <= nx; b_k++) {
            den += b_y[b_k - 1];
          }
        }

        uyy = den / static_cast<double>(x.size(0)) + 0.083333333333333329;
        y.set_size(x.size(0));
        nx = x.size(0);
        for (b_k = 0; b_k < nx; b_k++) {
          y[b_k] = x[b_k] * y[b_k];
        }

        nx = y.size(0);
        if (y.size(0) == 0) {
          den = 0.0;
        } else {
          den = y[0];
          for (b_k = 2; b_k <= nx; b_k++) {
            den += y[b_k - 1];
          }
        }

        uxy = den / static_cast<double>(x.size(0));
        a_tmp = uxx - uyy;
        common_tmp = 4.0 * (uxy * uxy);
        b_common_tmp = std::sqrt(a_tmp * a_tmp + common_tmp);
        den = uxx + uyy;
        stats[k].MajorAxisLength = 2.8284271247461903 * std::sqrt(den +
          b_common_tmp);
        stats[k].MinorAxisLength = 2.8284271247461903 * std::sqrt(den -
          b_common_tmp);
        den = stats[k].MajorAxisLength / 2.0;
        num = stats[k].MinorAxisLength / 2.0;
        stats[k].Eccentricity = 2.0 * std::sqrt(den * den - num * num) / stats[k]
          .MajorAxisLength;
        if (uyy > uxx) {
          a_tmp = uyy - uxx;
          num = a_tmp + std::sqrt(a_tmp * a_tmp + common_tmp);
          den = 2.0 * uxy;
        } else {
          num = 2.0 * uxy;
          den = a_tmp + b_common_tmp;
        }

        if ((num == 0.0) && (den == 0.0)) {
          stats[k].Orientation = 0.0;
        } else {
          stats[k].Orientation = 57.295779513082323 * std::atan(num / den);
        }
      }
    }
  }
}

// End of code generation (regionprops.cpp)
