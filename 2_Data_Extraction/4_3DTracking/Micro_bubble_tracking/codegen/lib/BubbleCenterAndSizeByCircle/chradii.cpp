//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  chradii.cpp
//
//  Code generation for function 'chradii'
//


// Include files
#include "chradii.h"
#include "BubbleCenterAndSizeByCircle_rtwutil.h"
#include "CircleIdentifier.h"
#include "colon.h"
#include "minOrMax.h"
#include "rt_nonfinite.h"
#include <cmath>

// Function Definitions
void chradii(const coder::array<double, 2U> &varargin_1, const coder::array<
             float, 2U> &varargin_2, const double varargin_3_data[], coder::
             array<double, 1U> &r_estimated)
{
  int loop_ub;
  int i;
  double varargin_3;
  double b_varargin_3;
  int ny;
  coder::array<double, 2U> y;
  coder::array<double, 2U> b_y;
  coder::array<double, 2U> dx;
  coder::array<double, 2U> dy;
  coder::array<double, 2U> r;
  coder::array<double, 1U> b_r;
  coder::array<float, 2U> b_varargin_2;
  coder::array<float, 1U> gradientImg;
  coder::array<bool, 1U> x;
  coder::array<bool, 1U> c_r;
  coder::array<double, 1U> bins;
  coder::array<creal_T, 1U> h;
  creal_T ex;
  r_estimated.set_size(varargin_1.size(0));
  loop_ub = varargin_1.size(0);
  for (i = 0; i < loop_ub; i++) {
    r_estimated[i] = 0.0;
  }

  i = varargin_1.size(0);
  if (0 <= varargin_1.size(0) - 1) {
    varargin_3 = varargin_3_data[0];
    b_varargin_3 = varargin_3_data[1];
  }

  for (int k = 0; k < i; k++) {
    double d;
    double bottom;
    double left;
    double u0;
    double right;
    double d1;
    double top;
    int i1;
    int j;
    int i2;
    int b_loop_ub;
    int nx;
    int b_i;
    bool exitg1;
    d = varargin_1[k];
    bottom = varargin_3_data[1];
    left = std::floor(d - bottom);
    if (!(left > 1.0)) {
      left = 1.0;
    }

    u0 = std::ceil(d + bottom);
    right = varargin_2.size(1);
    if (u0 < right) {
      right = u0;
    }

    d1 = varargin_1[k + varargin_1.size(0)];
    top = std::floor(d1 - bottom);
    if (!(top > 1.0)) {
      top = 1.0;
    }

    u0 = std::ceil(d1 + bottom);
    bottom = varargin_2.size(0);
    if (u0 < bottom) {
      bottom = u0;
    }

    if (top > bottom) {
      i1 = -1;
      j = -1;
    } else {
      i1 = static_cast<int>(top) - 2;
      j = static_cast<int>(bottom) - 1;
    }

    if (left > right) {
      i2 = -1;
      ny = -1;
    } else {
      i2 = static_cast<int>(left) - 2;
      ny = static_cast<int>(right) - 1;
    }

    left = (d - left) + 1.0;
    bottom = (d1 - top) + 1.0;
    loop_ub = ny - i2;
    if (loop_ub < 1) {
      y.set_size(1, 0);
    } else {
      b_loop_ub = loop_ub - 1;
      y.set_size(1, (b_loop_ub + 1));
      for (ny = 0; ny <= b_loop_ub; ny++) {
        y[ny] = static_cast<double>(ny) + 1.0;
      }
    }

    b_loop_ub = j - i1;
    if (b_loop_ub < 1) {
      b_y.set_size(1, 0);
    } else {
      nx = b_loop_ub - 1;
      b_y.set_size(1, (nx + 1));
      for (j = 0; j <= nx; j++) {
        b_y[j] = static_cast<double>(j) + 1.0;
      }
    }

    nx = y.size(1);
    ny = b_y.size(1);
    dx.set_size(b_y.size(1), y.size(1));
    dy.set_size(b_y.size(1), y.size(1));
    if ((y.size(1) != 0) && (b_y.size(1) != 0)) {
      for (j = 0; j < nx; j++) {
        for (b_i = 0; b_i < ny; b_i++) {
          dx[b_i + dx.size(0) * j] = y[j];
          dy[b_i + dy.size(0) * j] = b_y[b_i];
        }
      }
    }

    nx = dx.size(0) * dx.size(1);
    for (j = 0; j < nx; j++) {
      dx[j] = dx[j] - left;
    }

    nx = dy.size(0) * dy.size(1);
    for (j = 0; j < nx; j++) {
      dy[j] = dy[j] - bottom;
    }

    if (dx.size(0) <= dy.size(0)) {
      j = dx.size(0);
    } else {
      j = dy.size(0);
    }

    if (dx.size(1) <= dy.size(1)) {
      ny = dx.size(1);
    } else {
      ny = dy.size(1);
    }

    r.set_size(j, ny);
    nx = j * ny;
    for (b_i = 0; b_i < nx; b_i++) {
      r[b_i] = rt_hypotd_snf(dx[b_i], dy[b_i]);
    }

    nx = r.size(0) * r.size(1);
    for (b_i = 0; b_i < nx; b_i++) {
      r[b_i] = rt_roundd_snf(r[b_i]);
    }

    b_r.set_size((r.size(0) * r.size(1)));
    nx = r.size(0) * r.size(1);
    for (j = 0; j < nx; j++) {
      b_r[j] = r[j];
    }

    b_varargin_2.set_size(b_loop_ub, loop_ub);
    for (j = 0; j < loop_ub; j++) {
      for (ny = 0; ny < b_loop_ub; ny++) {
        b_varargin_2[ny + b_varargin_2.size(0) * j] = varargin_2[((i1 + ny) +
          varargin_2.size(0) * ((i2 + j) + 1)) + 1];
      }
    }

    ny = b_loop_ub * loop_ub;
    gradientImg.set_size(ny);
    for (i1 = 0; i1 < ny; i1++) {
      gradientImg[i1] = b_varargin_2[i1];
    }

    x.set_size((r.size(0) * r.size(1)));
    loop_ub = r.size(0) * r.size(1);
    for (i1 = 0; i1 < loop_ub; i1++) {
      x[i1] = (r[i1] >= varargin_3);
    }

    c_r.set_size((r.size(0) * r.size(1)));
    loop_ub = r.size(0) * r.size(1);
    for (i1 = 0; i1 < loop_ub; i1++) {
      c_r[i1] = (r[i1] <= b_varargin_3);
    }

    ny = x.size(0) - 1;
    j = 0;
    for (b_i = 0; b_i <= ny; b_i++) {
      if (x[b_i] && c_r[b_i]) {
        j++;
      }
    }

    nx = 0;
    for (b_i = 0; b_i <= ny; b_i++) {
      if (x[b_i] && c_r[b_i]) {
        gradientImg[nx] = gradientImg[b_i];
        nx++;
      }
    }

    gradientImg.set_size(j);
    ny = x.size(0) - 1;
    j = 0;
    for (b_i = 0; b_i <= ny; b_i++) {
      if (x[b_i] && c_r[b_i]) {
        j++;
      }
    }

    nx = 0;
    for (b_i = 0; b_i <= ny; b_i++) {
      if (x[b_i] && c_r[b_i]) {
        b_r[nx] = b_r[b_i];
        nx++;
      }
    }

    b_r.set_size(j);
    if (j <= 2) {
      if (j == 1) {
        left = b_r[0];
      } else if ((b_r[0] > b_r[1]) || (rtIsNaN(b_r[0]) && (!rtIsNaN(b_r[1])))) {
        left = b_r[1];
      } else {
        left = b_r[0];
      }
    } else {
      if (!rtIsNaN(b_r[0])) {
        nx = 1;
      } else {
        nx = 0;
        b_i = 2;
        exitg1 = false;
        while ((!exitg1) && (b_i <= j)) {
          if (!rtIsNaN(b_r[b_i - 1])) {
            nx = b_i;
            exitg1 = true;
          } else {
            b_i++;
          }
        }
      }

      if (nx == 0) {
        left = b_r[0];
      } else {
        left = b_r[nx - 1];
        i1 = nx + 1;
        for (b_i = i1; b_i <= j; b_i++) {
          d = b_r[b_i - 1];
          if (left > d) {
            left = d;
          }
        }
      }
    }

    bottom = d_maximum(b_r);
    if (rtIsNaN(left) || rtIsNaN(bottom)) {
      y.set_size(1, 1);
      y[0] = rtNaN;
    } else if (bottom < left) {
      y.set_size(1, 0);
    } else if ((rtIsInf(left) || rtIsInf(bottom)) && (left == bottom)) {
      y.set_size(1, 1);
      y[0] = rtNaN;
    } else if (std::floor(left) == left) {
      loop_ub = static_cast<int>(std::floor(bottom - left));
      y.set_size(1, (loop_ub + 1));
      for (i1 = 0; i1 <= loop_ub; i1++) {
        y[i1] = left + static_cast<double>(i1);
      }
    } else {
      b_eml_float_colon(left, bottom, y);
    }

    bins.set_size(y.size(1));
    loop_ub = y.size(1);
    for (i1 = 0; i1 < loop_ub; i1++) {
      bins[i1] = y[i1];
    }

    for (i1 = 0; i1 < j; i1++) {
      b_r[i1] = (b_r[i1] - bins[0]) + 1.0;
    }

    ny = b_r.size(0);
    if (b_r.size(0) <= 2) {
      if (b_r.size(0) == 1) {
        left = b_r[0];
      } else if ((b_r[0] < b_r[1]) || (rtIsNaN(b_r[0]) && (!rtIsNaN(b_r[1])))) {
        left = b_r[1];
      } else {
        left = b_r[0];
      }
    } else {
      if (!rtIsNaN(b_r[0])) {
        nx = 1;
      } else {
        nx = 0;
        b_i = 2;
        exitg1 = false;
        while ((!exitg1) && (b_i <= b_r.size(0))) {
          if (!rtIsNaN(b_r[b_i - 1])) {
            nx = b_i;
            exitg1 = true;
          } else {
            b_i++;
          }
        }
      }

      if (nx == 0) {
        left = b_r[0];
      } else {
        left = b_r[nx - 1];
        i1 = nx + 1;
        for (b_i = i1; b_i <= ny; b_i++) {
          d = b_r[b_i - 1];
          if (left < d) {
            left = d;
          }
        }
      }
    }

    loop_ub = static_cast<int>(left);
    h.set_size(loop_ub);
    for (i1 = 0; i1 < loop_ub; i1++) {
      h[i1].re = 0.0;
      h[i1].im = 0.0;
    }

    i1 = b_r.size(0);
    for (nx = 0; nx < i1; nx++) {
      ny = static_cast<int>(b_r[nx]) - 1;
      h[ny].re = static_cast<float>(h[ny].re) + gradientImg[nx];
      h[ny].im = static_cast<float>(h[ny].im);
    }

    i1 = h.size(0);
    for (nx = 0; nx < i1; nx++) {
      bottom = 6.2831853071795862 * bins[nx];
      if (h[nx].im == 0.0) {
        left = h[nx].re / bottom;
        bottom = 0.0;
      } else if (h[nx].re == 0.0) {
        left = 0.0;
        bottom = h[nx].im / bottom;
      } else {
        left = h[nx].re / bottom;
        bottom = h[nx].im / bottom;
      }

      h[nx].re = left;
      h[nx].im = bottom;
    }

    e_maximum(h, &ex, &ny);
    r_estimated[k] = bins[ny - 1];
  }
}

// End of code generation (chradii.cpp)
