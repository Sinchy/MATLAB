//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  multithresh.cpp
//
//  Code generation for function 'multithresh'
//


// Include files
#include "multithresh.h"
#include "CircleIdentifier.h"
#include "chradii.h"
#include "imhist.h"
#include "minOrMax.h"
#include "nullAssignment.h"
#include "rt_nonfinite.h"
#include "sort.h"
#include "unique.h"
#include <cmath>
#include <cstring>
#include <math.h>

// Function Definitions
float multithresh(const coder::array<float, 2U> &varargin_1)
{
  float thresh;
  coder::array<float, 2U> threshL;
  coder::array<float, 1U> b_varargin_1;
  float y_data[1];
  coder::array<float, 2U> threshout;
  double omega[256];
  double counts[256];
  coder::array<double, 2U> uniqueVals_d;
  coder::array<bool, 1U> nans;
  double maxval;
  double sigma_b_squared[256];
  double idxSum;
  coder::array<double, 1U> x;
  coder::array<float, 1U> b;
  coder::array<bool, 2U> r;
  coder::array<double, 1U> y;
  coder::array<int, 1U> r1;
  coder::array<bool, 2U> r2;
  int exponent;
  coder::array<unsigned char, 1U> Auint8;
  coder::array<bool, 2U> r3;
  if ((varargin_1.size(0) == 0) || (varargin_1.size(1) == 0)) {
    if ((varargin_1.size(0) * varargin_1.size(1) != 0) && (1 - varargin_1.size(0)
         * varargin_1.size(1) > 0)) {
      int idx;
      int N;
      float val;
      int i;
      if (varargin_1[0] > 1.0F) {
        if ((1.0F < varargin_1[0] - 1.0F) || rtIsNaNF(varargin_1[0] - 1.0F)) {
          val = 1.0F;
        } else {
          val = varargin_1[0] - 1.0F;
        }

        if (rtIsNaNF(val)) {
          N = 1;
          y_data[0] = rtNaNF;
        } else if (val < 1.0F) {
          N = 0;
        } else {
          N = 1;
          y_data[0] = 1.0F;
        }

        idx = varargin_1.size(0) * varargin_1.size(1);
        threshL.set_size(1, (N + idx));
        for (i = 0; i < N; i++) {
          threshL[0] = y_data[0];
        }

        for (i = 0; i < idx; i++) {
          threshL[i + N] = varargin_1[i];
        }
      } else {
        idx = varargin_1.size(0) * varargin_1.size(1);
        threshL.set_size(1, idx);
        for (i = 0; i < idx; i++) {
          threshL[i] = varargin_1[i];
        }
      }

      if (1.0 - static_cast<double>(threshL.size(1)) > 0.0) {
        threshout.set_size(1, (threshL.size(1) + 1));
        idx = threshL.size(1);
        for (i = 0; i < idx; i++) {
          threshout[i] = threshL[i];
        }

        threshout[threshL.size(1)] = 0.0F;
        idx = varargin_1.size(0) * varargin_1.size(1);
        uniqueVals_d.set_size(1, idx);
        for (i = 0; i < idx; i++) {
          uniqueVals_d[i] = varargin_1[i];
        }

        val = varargin_1[0];
        if (!(val > 0.0F)) {
          val = 0.0F;
        }

        N = 1;
        while (N <= 1) {
          bool emptyp;
          bool exitg1;
          val++;
          x.set_size(uniqueVals_d.size(1));
          idx = uniqueVals_d.size(1);
          for (i = 0; i < idx; i++) {
            x[i] = uniqueVals_d[i] - val;
          }

          idx = x.size(0);
          y.set_size(x.size(0));
          for (int k = 0; k < idx; k++) {
            y[k] = std::abs(x[k]);
          }

          if (!rtIsInf(static_cast<double>(val))) {
            frexp(static_cast<double>(val), &exponent);
            idxSum = std::ldexp(1.0, exponent - 53);
          } else {
            idxSum = rtNaN;
          }

          nans.set_size(y.size(0));
          idx = y.size(0);
          for (i = 0; i < idx; i++) {
            nans[i] = (y[i] < idxSum);
          }

          emptyp = false;
          idx = 1;
          exitg1 = false;
          while ((!exitg1) && (idx <= nans.size(0))) {
            if (!nans[idx - 1]) {
              idx++;
            } else {
              emptyp = true;
              exitg1 = true;
            }
          }

          if (!emptyp) {
            threshout[threshL.size(1)] = val;
            N = 2;
          }
        }

        sort(threshout);
      }
    }

    thresh = 1.0F;
  } else {
    bool emptyp;
    int idx;
    int N;
    int i;
    float maxA;
    int k;
    emptyp = true;
    idx = 0;
    N = varargin_1.size(0) * varargin_1.size(1);
    while ((idx + 1 <= N) && (rtIsInfF(varargin_1[idx]) || rtIsNaNF
            (varargin_1[idx]))) {
      idx++;
    }

    if (idx + 1 <= N) {
      thresh = varargin_1[idx];
      maxA = varargin_1[idx];
      i = idx + 2;
      for (k = i; k <= N; k++) {
        if ((varargin_1[k - 1] < thresh) && ((!rtIsInfF(varargin_1[k - 1])) && (
              !rtIsNaNF(varargin_1[k - 1])))) {
          thresh = varargin_1[k - 1];
        } else {
          if ((varargin_1[k - 1] > maxA) && ((!rtIsInfF(varargin_1[k - 1])) && (
                !rtIsNaNF(varargin_1[k - 1])))) {
            maxA = varargin_1[k - 1];
          }
        }
      }

      if (!(thresh == maxA)) {
        float val;
        val = maxA - thresh;
        threshout.set_size(varargin_1.size(0), varargin_1.size(1));
        idx = varargin_1.size(0) * varargin_1.size(1);
        for (i = 0; i < idx; i++) {
          threshout[i] = (varargin_1[i] - thresh) / val;
        }

        nans.set_size((threshout.size(0) * threshout.size(1)));
        idx = threshout.size(0) * threshout.size(1);
        for (i = 0; i < idx; i++) {
          nans[i] = rtIsNaNF(threshout[i]);
        }

        N = nans.size(0);
        idx = 0;
        for (k = 0; k < N; k++) {
          if (!nans[k]) {
            idx++;
          }
        }

        if (idx != 0) {
          N = nans.size(0) - 1;
          idx = 0;
          for (k = 0; k <= N; k++) {
            if (!nans[k]) {
              idx++;
            }
          }

          r1.set_size(idx);
          idx = 0;
          for (k = 0; k <= N; k++) {
            if (!nans[k]) {
              r1[idx] = k + 1;
              idx++;
            }
          }

          Auint8.set_size(r1.size(0));
          i = r1.size(0);
          for (idx = 0; idx < i; idx++) {
            val = threshout[r1[idx] - 1] * 255.0F;
            if (val < 0.0F) {
              Auint8[idx] = 0U;
            } else if (val > 255.0F) {
              Auint8[idx] = MAX_uint8_T;
            } else {
              Auint8[idx] = static_cast<unsigned char>(val + 0.5F);
            }
          }

          imhist(Auint8, counts);
          maxval = counts[0];
          for (k = 0; k < 255; k++) {
            maxval += counts[k + 1];
          }

          for (i = 0; i < 256; i++) {
            counts[i] /= maxval;
          }

          emptyp = false;
        }
      }
    } else {
      idx = varargin_1.size(0) * varargin_1.size(1);
      b_varargin_1 = varargin_1.reshape(idx);
      thresh = minimum(b_varargin_1);
      idx = varargin_1.size(0) * varargin_1.size(1);
      b_varargin_1 = varargin_1.reshape(idx);
      maxA = maximum(b_varargin_1);
    }

    if (emptyp) {
      if (rtIsNaNF(thresh)) {
        thresh = 1.0F;
      }
    } else {
      std::memcpy(&omega[0], &counts[0], 256U * sizeof(double));
      for (k = 0; k < 255; k++) {
        omega[k + 1] += omega[k];
      }

      for (i = 0; i < 256; i++) {
        counts[i] *= static_cast<double>(i) + 1.0;
      }

      for (k = 0; k < 255; k++) {
        counts[k + 1] += counts[k];
      }

      maxval = counts[255];
      for (k = 0; k < 256; k++) {
        idxSum = maxval * omega[k] - counts[k];
        counts[k] = idxSum;
        sigma_b_squared[k] = idxSum * idxSum / (omega[k] * (1.0 - omega[k]));
      }

      maxval = b_maximum(sigma_b_squared);
      if ((!rtIsInf(maxval)) && (!rtIsNaN(maxval))) {
        double idxNum;
        idxSum = 0.0;
        idxNum = 0.0;
        for (idx = 0; idx < 256; idx++) {
          if (sigma_b_squared[idx] == maxval) {
            idxSum += static_cast<double>(idx) + 1.0;
            idxNum++;
          }
        }

        uniqueVals_d.set_size(1, 1);
        uniqueVals_d[0] = idxSum / idxNum - 1.0;
        maxval = static_cast<double>(maxA) - thresh;
        threshout.set_size(1, 1);
        threshout[0] = static_cast<float>(thresh + uniqueVals_d[0] / 255.0 *
          maxval);
      } else {
        idx = varargin_1.size(0) * varargin_1.size(1);
        b_varargin_1 = varargin_1.reshape(idx);
        unique_vector(b_varargin_1, b);
        r.set_size(1, b.size(0));
        idx = b.size(0);
        for (i = 0; i < idx; i++) {
          r[i] = rtIsInfF(b[i]);
        }

        r2.set_size(1, b.size(0));
        idx = b.size(0);
        for (i = 0; i < idx; i++) {
          r2[i] = rtIsNaNF(b[i]);
        }

        threshout.set_size(1, b.size(0));
        idx = b.size(0);
        for (i = 0; i < idx; i++) {
          threshout[i] = b[i];
        }

        r3.set_size(1, r.size(1));
        idx = r.size(0) * r.size(1);
        for (i = 0; i < idx; i++) {
          r3[i] = (r[i] || r2[i]);
        }

        nullAssignment(threshout, r3);
        if (threshout.size(1) == 0) {
          threshout.set_size(1, 1);
          threshout[0] = 1.0F;
        }

        uniqueVals_d.set_size(1, threshout.size(1));
        idx = threshout.size(0) * threshout.size(1);
        for (i = 0; i < idx; i++) {
          uniqueVals_d[i] = threshout[i];
        }

        idx = varargin_1.size(0) * varargin_1.size(1);
        b_varargin_1 = varargin_1.reshape(idx);
        unique_vector(b_varargin_1, b);
        r.set_size(1, b.size(0));
        idx = b.size(0);
        for (i = 0; i < idx; i++) {
          r[i] = rtIsInfF(b[i]);
        }

        r2.set_size(1, b.size(0));
        idx = b.size(0);
        for (i = 0; i < idx; i++) {
          r2[i] = rtIsNaNF(b[i]);
        }

        threshout.set_size(1, b.size(0));
        idx = b.size(0);
        for (i = 0; i < idx; i++) {
          threshout[i] = b[i];
        }

        r3.set_size(1, r.size(1));
        idx = r.size(0) * r.size(1);
        for (i = 0; i < idx; i++) {
          r3[i] = (r[i] || r2[i]);
        }

        nullAssignment(threshout, r3);
        if (threshout.size(1) <= 1) {
          if (threshout.size(1) == 0) {
            threshout.set_size(1, 1);
            threshout[0] = 1.0F;
          }
        } else {
          maxval = static_cast<double>(maxA) - thresh;
          threshout.set_size(1, uniqueVals_d.size(1));
          idx = uniqueVals_d.size(0) * uniqueVals_d.size(1);
          for (i = 0; i < idx; i++) {
            threshout[i] = static_cast<float>(thresh + uniqueVals_d[i] / 255.0 *
              maxval);
          }
        }
      }

      thresh = threshout[0];
    }
  }

  return thresh;
}

// End of code generation (multithresh.cpp)
