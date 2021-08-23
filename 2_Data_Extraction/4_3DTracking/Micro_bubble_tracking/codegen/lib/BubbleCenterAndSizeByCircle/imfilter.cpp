//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  imfilter.cpp
//
//  Code generation for function 'imfilter'
//


// Include files
#include "imfilter.h"
#include "BubbleCenterAndSizeByCircle_rtwutil.h"
#include "CircleIdentifier.h"
#include "chcenters.h"
#include "chradii.h"
#include "conv2AXPY.h"
#include "rt_nonfinite.h"
#include "sortIdx.h"

// Function Definitions
void imfilter(coder::array<float, 2U> &varargin_1)
{
  double pad[2];
  coder::array<float, 2U> a;
  coder::array<double, 2U> b_a;
  coder::array<double, 2U> result;
  pad[0] = 1.0;
  pad[1] = 1.0;
  if ((varargin_1.size(0) != 0) && (varargin_1.size(1) != 0)) {
    int loop_ub;
    int i;
    int i1;
    int i2;
    int i3;
    int b_loop_ub;
    padImage(varargin_1, pad, a);
    b_a.set_size(a.size(0), a.size(1));
    loop_ub = a.size(0) * a.size(1);
    for (i = 0; i < loop_ub; i++) {
      b_a[i] = a[i];
    }

    c_conv2AXPYSameCMP(b_a, result);
    if (2.0 > static_cast<double>(varargin_1.size(0)) + 1.0) {
      i = 0;
      i1 = -1;
    } else {
      i = 1;
      i1 = varargin_1.size(0);
    }

    if (2.0 > static_cast<double>(varargin_1.size(1)) + 1.0) {
      i2 = 0;
      i3 = -1;
    } else {
      i2 = 1;
      i3 = varargin_1.size(1);
    }

    loop_ub = i1 - i;
    varargin_1.set_size((loop_ub + 1), varargin_1.size(1));
    b_loop_ub = i3 - i2;
    varargin_1.set_size(varargin_1.size(0), (b_loop_ub + 1));
    for (i1 = 0; i1 <= b_loop_ub; i1++) {
      for (i3 = 0; i3 <= loop_ub; i3++) {
        varargin_1[i3 + varargin_1.size(0) * i1] = static_cast<float>(result[(i
          + i3) + result.size(0) * (i2 + i1)]);
      }
    }
  }
}

void padImage(const coder::array<float, 2U> &a_tmp, const double pad[2], coder::
              array<float, 2U> &a)
{
  int loop_ub;
  coder::array<int, 2U> idxA;
  coder::array<double, 2U> y;
  coder::array<unsigned int, 2U> idxDir;
  if ((a_tmp.size(0) == 0) || (a_tmp.size(1) == 0)) {
    double sizeA_idx_0;
    double sizeA_idx_1;
    int i;
    sizeA_idx_0 = static_cast<double>(a_tmp.size(0)) + 2.0 * pad[0];
    sizeA_idx_1 = static_cast<double>(a_tmp.size(1)) + 2.0 * pad[1];
    i = static_cast<int>(sizeA_idx_0);
    loop_ub = static_cast<int>(sizeA_idx_1);
    a.set_size(i, loop_ub);
    loop_ub *= i;
    for (i = 0; i < loop_ub; i++) {
      a[i] = 0.0F;
    }
  } else {
    unsigned int varargin_1_idx_0_tmp_tmp;
    double sizeA_idx_0;
    double sizeA_idx_1;
    unsigned int varargin_1_idx_1_tmp_tmp;
    int i;
    int b_loop_ub;
    unsigned int u;
    varargin_1_idx_0_tmp_tmp = static_cast<unsigned int>(a_tmp.size(0));
    sizeA_idx_0 = 2.0 * pad[0] + static_cast<double>(varargin_1_idx_0_tmp_tmp);
    varargin_1_idx_1_tmp_tmp = static_cast<unsigned int>(a_tmp.size(1));
    sizeA_idx_1 = 2.0 * pad[1] + static_cast<double>(varargin_1_idx_1_tmp_tmp);
    if ((sizeA_idx_0 < sizeA_idx_1) || (rtIsNaN(sizeA_idx_0) && (!rtIsNaN
          (sizeA_idx_1)))) {
      sizeA_idx_0 = sizeA_idx_1;
    }

    idxA.set_size((static_cast<int>(sizeA_idx_0)), 2);
    loop_ub = static_cast<int>(pad[0]);
    b_loop_ub = static_cast<int>(static_cast<double>(varargin_1_idx_0_tmp_tmp) -
      1.0);
    y.set_size(1, (b_loop_ub + 1));
    for (i = 0; i <= b_loop_ub; i++) {
      y[i] = static_cast<double>(i) + 1.0;
    }

    idxDir.set_size(1, ((loop_ub + y.size(1)) + loop_ub));
    for (i = 0; i < loop_ub; i++) {
      idxDir[i] = 1U;
    }

    b_loop_ub = y.size(1);
    for (i = 0; i < b_loop_ub; i++) {
      sizeA_idx_0 = rt_roundd_snf(y[i]);
      if (sizeA_idx_0 < 4.294967296E+9) {
        if (sizeA_idx_0 >= 0.0) {
          u = static_cast<unsigned int>(sizeA_idx_0);
        } else {
          u = 0U;
        }
      } else if (sizeA_idx_0 >= 4.294967296E+9) {
        u = MAX_uint32_T;
      } else {
        u = 0U;
      }

      idxDir[i + loop_ub] = u;
    }

    for (i = 0; i < loop_ub; i++) {
      idxDir[(i + loop_ub) + y.size(1)] = varargin_1_idx_0_tmp_tmp;
    }

    loop_ub = idxDir.size(1);
    for (i = 0; i < loop_ub; i++) {
      idxA[i] = static_cast<int>(idxDir[i]);
    }

    loop_ub = static_cast<int>(pad[1]);
    b_loop_ub = static_cast<int>(static_cast<double>(varargin_1_idx_1_tmp_tmp) -
      1.0);
    y.set_size(1, (b_loop_ub + 1));
    for (i = 0; i <= b_loop_ub; i++) {
      y[i] = static_cast<double>(i) + 1.0;
    }

    idxDir.set_size(1, ((loop_ub + y.size(1)) + loop_ub));
    for (i = 0; i < loop_ub; i++) {
      idxDir[i] = 1U;
    }

    b_loop_ub = y.size(1);
    for (i = 0; i < b_loop_ub; i++) {
      sizeA_idx_0 = rt_roundd_snf(y[i]);
      if (sizeA_idx_0 < 4.294967296E+9) {
        if (sizeA_idx_0 >= 0.0) {
          u = static_cast<unsigned int>(sizeA_idx_0);
        } else {
          u = 0U;
        }
      } else if (sizeA_idx_0 >= 4.294967296E+9) {
        u = MAX_uint32_T;
      } else {
        u = 0U;
      }

      idxDir[i + loop_ub] = u;
    }

    for (i = 0; i < loop_ub; i++) {
      idxDir[(i + loop_ub) + y.size(1)] = varargin_1_idx_1_tmp_tmp;
    }

    loop_ub = idxDir.size(1);
    for (i = 0; i < loop_ub; i++) {
      idxA[i + idxA.size(0)] = static_cast<int>(idxDir[i]);
    }

    i = static_cast<int>(static_cast<double>(a_tmp.size(1)) + 2.0 * pad[1]);
    a.set_size((static_cast<int>(static_cast<double>(a_tmp.size(0)) + 2.0 * pad
      [0])), i);
    for (b_loop_ub = 0; b_loop_ub < i; b_loop_ub++) {
      loop_ub = a.size(0);
      for (int b_i = 0; b_i < loop_ub; b_i++) {
        a[b_i + a.size(0) * b_loop_ub] = a_tmp[(idxA[b_i] + a_tmp.size(0) *
          (idxA[b_loop_ub + idxA.size(0)] - 1)) - 1];
      }
    }
  }
}

// End of code generation (imfilter.cpp)
