//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  chaccum.cpp
//
//  Code generation for function 'chaccum'
//


// Include files
#include "chaccum.h"
#include "CircleIdentifier.h"
#include "chcenters.h"
#include "chradii.h"
#include "colon.h"
#include "conv2AXPY.h"
#include "find.h"
#include "imfilter.h"
#include "minOrMax.h"
#include "multithresh.h"
#include "rt_nonfinite.h"
#include <cmath>
#include <cstring>

// Function Declarations
static float rt_hypotf_snf(float u0, float u1);

// Function Definitions
static float rt_hypotf_snf(float u0, float u1)
{
  float y;
  float a;
  a = std::abs(u0);
  y = std::abs(u1);
  if (a < y) {
    a /= y;
    y *= std::sqrt(a * a + 1.0F);
  } else if (a > y) {
    y /= a;
    y = a * std::sqrt(y * y + 1.0F);
  } else {
    if (!rtIsNaNF(y)) {
      y = a * 1.41421354F;
    }
  }

  return y;
}

void chaccum(const coder::array<bool, 2U> &varargin_1, const double
             varargin_2_data[], const int varargin_2_size[2], coder::array<
             creal_T, 2U> &accumMatrix, coder::array<float, 2U> &gradientImg)
{
  int radiusRangeIn_size_idx_1;
  double radiusRangeIn_data[2];
  int nm1d2;
  coder::array<bool, 1U> rows_to_keep;
  int i;
  bool y;
  int nx;
  bool exitg1;
  coder::array<float, 2U> A;
  double pad[2];
  coder::array<float, 2U> a;
  coder::array<double, 2U> w0;
  coder::array<float, 2U> Gx;
  coder::array<double, 2U> result;
  coder::array<float, 2U> Gy;
  coder::array<float, 1U> b_gradientImg;
  float Gmax;
  coder::array<bool, 2U> inside;
  coder::array<int, 1U> xckeep;
  coder::array<int, 1U> yckeep;
  coder::array<int, 1U> Ey;
  coder::array<int, 1U> Ex;
  coder::array<int, 1U> idxE;
  coder::array<double, 2U> radiusRange;
  int i2;
  int i3;
  int loop_ub;
  coder::array<double, 2U> r;
  coder::array<double, 1U> Ex_chunk;
  coder::array<int, 1U> idxE_chunk;
  coder::array<creal_T, 2U> r1;
  if (varargin_2_size[1] == 2) {
    if (varargin_2_data[0] == varargin_2_data[1]) {
      radiusRangeIn_size_idx_1 = 1;
      radiusRangeIn_data[0] = varargin_2_data[0];
    } else {
      radiusRangeIn_size_idx_1 = 2;
      nm1d2 = varargin_2_size[0] * 2;
      if (0 <= nm1d2 - 1) {
        std::memcpy(&radiusRangeIn_data[0], &varargin_2_data[0], nm1d2 * sizeof
                    (double));
      }
    }
  } else {
    radiusRangeIn_size_idx_1 = 1;
    radiusRangeIn_data[0] = varargin_2_data[0];
  }

  rows_to_keep.set_size((varargin_1.size(0) * varargin_1.size(1)));
  nm1d2 = varargin_1.size(0) * varargin_1.size(1);
  for (i = 0; i < nm1d2; i++) {
    rows_to_keep[i] = (varargin_1[i] == varargin_1[0]);
  }

  y = true;
  nx = 1;
  exitg1 = false;
  while ((!exitg1) && (nx <= rows_to_keep.size(0))) {
    if (!rows_to_keep[nx - 1]) {
      y = false;
      exitg1 = true;
    } else {
      nx++;
    }
  }

  if (y) {
    accumMatrix.set_size(varargin_1.size(0), varargin_1.size(1));
    nm1d2 = varargin_1.size(0) * varargin_1.size(1);
    for (i = 0; i < nm1d2; i++) {
      accumMatrix[i].re = 0.0;
      accumMatrix[i].im = 0.0;
    }

    gradientImg.set_size(varargin_1.size(0), varargin_1.size(1));
    nm1d2 = varargin_1.size(0) * varargin_1.size(1);
    for (i = 0; i < nm1d2; i++) {
      gradientImg[i] = 0.0F;
    }
  } else {
    int i1;
    int csz_idx_1;
    int k;
    float edgeThresh;
    double xcStep;
    int N;
    int M;
    A.set_size(varargin_1.size(0), varargin_1.size(1));
    nm1d2 = varargin_1.size(0) * varargin_1.size(1);
    for (i = 0; i < nm1d2; i++) {
      A[i] = varargin_1[i];
    }

    pad[0] = 2.0;
    pad[1] = 2.0;
    if ((A.size(0) != 0) && (A.size(1) != 0)) {
      padImage(A, pad, a);
      w0.set_size(a.size(0), a.size(1));
      nm1d2 = a.size(0) * a.size(1);
      for (i = 0; i < nm1d2; i++) {
        w0[i] = a[i];
      }

      conv2AXPYSameCMP(w0, result);
      nm1d2 = A.size(0);
      nx = A.size(1);
      A.set_size(nm1d2, nx);
      for (i = 0; i < nx; i++) {
        for (i1 = 0; i1 < nm1d2; i1++) {
          A[i1 + A.size(0) * i] = static_cast<float>(result[(i1 + result.size(0)
            * (i + 2)) + 2]);
        }
      }
    }

    pad[0] = 1.0;
    pad[1] = 1.0;
    if ((A.size(0) == 0) || (A.size(1) == 0)) {
      Gx.set_size(A.size(0), A.size(1));
      nm1d2 = A.size(0) * A.size(1);
      for (i = 0; i < nm1d2; i++) {
        Gx[i] = A[i];
      }
    } else {
      padImage(A, pad, a);
      w0.set_size(a.size(0), a.size(1));
      nm1d2 = a.size(0) * a.size(1);
      for (i = 0; i < nm1d2; i++) {
        w0[i] = a[i];
      }

      b_conv2AXPYSameCMP(w0, result);
      nm1d2 = A.size(0);
      nx = A.size(1);
      Gx.set_size(A.size(0), A.size(1));
      for (i = 0; i < nx; i++) {
        for (i1 = 0; i1 < nm1d2; i1++) {
          Gx[i1 + Gx.size(0) * i] = static_cast<float>(result[(i1 + result.size
            (0) * (i + 1)) + 1]);
        }
      }
    }

    Gy.set_size(A.size(0), A.size(1));
    nm1d2 = A.size(0) * A.size(1);
    for (i = 0; i < nm1d2; i++) {
      Gy[i] = A[i];
    }

    imfilter(Gy);
    if (Gx.size(1) <= Gy.size(1)) {
      csz_idx_1 = Gx.size(1);
    } else {
      csz_idx_1 = Gy.size(1);
    }

    if (Gx.size(0) <= Gy.size(0)) {
      i = Gx.size(0);
    } else {
      i = Gy.size(0);
    }

    gradientImg.set_size(i, csz_idx_1);
    if (Gx.size(0) <= Gy.size(0)) {
      i = Gx.size(0);
    } else {
      i = Gy.size(0);
    }

    nx = i * csz_idx_1;
    for (k = 0; k < nx; k++) {
      gradientImg[k] = rt_hypotf_snf(Gx[k], Gy[k]);
    }

    nx = gradientImg.size(0) * gradientImg.size(1);
    b_gradientImg = gradientImg.reshape(nx);
    Gmax = maximum(b_gradientImg);
    a.set_size(gradientImg.size(0), gradientImg.size(1));
    nm1d2 = gradientImg.size(0) * gradientImg.size(1);
    for (i = 0; i < nm1d2; i++) {
      a[i] = gradientImg[i] / Gmax;
    }

    edgeThresh = multithresh(a);
    Gmax *= edgeThresh;
    inside.set_size(gradientImg.size(0), gradientImg.size(1));
    nm1d2 = gradientImg.size(0) * gradientImg.size(1);
    for (i = 0; i < nm1d2; i++) {
      inside[i] = (gradientImg[i] > Gmax);
    }

    eml_find(inside, xckeep, yckeep);
    Ey.set_size(xckeep.size(0));
    nm1d2 = xckeep.size(0);
    for (i = 0; i < nm1d2; i++) {
      Ey[i] = xckeep[i];
    }

    Ex.set_size(yckeep.size(0));
    nm1d2 = yckeep.size(0);
    for (i = 0; i < nm1d2; i++) {
      Ex[i] = yckeep[i];
    }

    idxE.set_size(Ey.size(0));
    nm1d2 = Ey.size(0);
    for (i = 0; i < nm1d2; i++) {
      idxE[i] = Ey[i] + gradientImg.size(0) * (Ex[i] - 1);
    }

    if (radiusRangeIn_size_idx_1 > 1) {
      if (rtIsNaN(radiusRangeIn_data[0]) || rtIsNaN(radiusRangeIn_data[1])) {
        radiusRange.set_size(1, 1);
        radiusRange[0] = rtNaN;
      } else if (radiusRangeIn_data[1] < radiusRangeIn_data[0]) {
        radiusRange.set_size(1, 0);
      } else if ((rtIsInf(radiusRangeIn_data[0]) || rtIsInf(radiusRangeIn_data[1]))
                 && (radiusRangeIn_data[0] == radiusRangeIn_data[1])) {
        radiusRange.set_size(1, 1);
        radiusRange[0] = rtNaN;
      } else {
        eml_float_colon(radiusRangeIn_data[0], radiusRangeIn_data[1],
                        radiusRange);
      }
    } else {
      radiusRange.set_size(1, 1);
      radiusRange[0] = radiusRangeIn_data[0];
    }

    w0.set_size(1, radiusRange.size(1));
    nm1d2 = radiusRange.size(0) * radiusRange.size(1);
    for (i = 0; i < nm1d2; i++) {
      w0[i] = 1.0 / (6.2831853071795862 * radiusRange[i]);
    }

    xcStep = std::floor(1.0E+6 / static_cast<double>(radiusRange.size(1)));
    N = A.size(1);
    M = A.size(0);
    accumMatrix.set_size(A.size(0), A.size(1));
    nm1d2 = A.size(0) * A.size(1);
    for (i = 0; i < nm1d2; i++) {
      accumMatrix[i].re = 0.0;
      accumMatrix[i].im = 0.0;
    }

    i = static_cast<int>((static_cast<double>(Ex.size(0)) + (xcStep - 1.0)) /
                         xcStep);
    if (0 <= i - 1) {
      csz_idx_1 = radiusRange.size(1);
      i2 = radiusRange.size(1);
      i3 = radiusRange.size(1);
      pad[0] = static_cast<unsigned int>(A.size(0));
      pad[1] = static_cast<unsigned int>(A.size(1));
      loop_ub = A.size(0) * A.size(1);
    }

    for (int b_i = 0; b_i < i; b_i++) {
      double c_i;
      double ndbl;
      double u1;
      c_i = static_cast<double>(b_i) * xcStep + 1.0;
      ndbl = (c_i + xcStep) - 1.0;
      u1 = Ex.size(0);
      if (ndbl < u1) {
        u1 = ndbl;
      }

      if (rtIsNaN(c_i)) {
        r.set_size(r.size(0), 1);
      } else if (u1 < c_i) {
        r.set_size(r.size(0), 0);
      } else if ((rtIsInf(c_i) || rtIsInf(u1)) && (c_i == u1)) {
        r.set_size(r.size(0), 1);
      } else if (c_i == c_i) {
        r.set_size(r.size(0), (static_cast<int>(u1 - c_i) + 1));
      } else {
        double apnd;
        double cdiff;
        double b_y;
        ndbl = std::floor((u1 - c_i) + 0.5);
        apnd = c_i + ndbl;
        cdiff = apnd - u1;
        if ((c_i > u1) || rtIsNaN(u1)) {
          b_y = c_i;
        } else {
          b_y = u1;
        }

        if (std::abs(cdiff) < 4.4408920985006262E-16 * b_y) {
          ndbl++;
          apnd = u1;
        } else if (cdiff > 0.0) {
          apnd = c_i + (ndbl - 1.0);
        } else {
          ndbl++;
        }

        if (ndbl >= 0.0) {
          nx = static_cast<int>(ndbl);
        } else {
          nx = 0;
        }

        r.set_size(1, nx);
        if ((nx > 0) && (nx > 1)) {
          r[nx - 1] = apnd;
          nm1d2 = (nx - 1) / 2;
          for (k = 0; k <= nm1d2 - 2; k++) {
            i1 = k + 1;
            r[k + 1] = c_i + static_cast<double>(i1);
            r[(nx - k) - 2] = apnd - static_cast<double>(i1);
          }

          if (nm1d2 << 1 == nx - 1) {
            r[nm1d2] = (c_i + apnd) / 2.0;
          } else {
            r[nm1d2] = c_i + static_cast<double>(nm1d2);
            r[nm1d2 + 1] = apnd - static_cast<double>(nm1d2);
          }
        }
      }

      Ex_chunk.set_size(r.size(1));
      xckeep.set_size(r.size(1));
      idxE_chunk.set_size(r.size(1));
      nx = static_cast<int>(c_i) - 1;
      i1 = r.size(1);
      for (nm1d2 = 0; nm1d2 < i1; nm1d2++) {
        Ex_chunk[nm1d2] = Ex[nx];
        xckeep[nm1d2] = Ey[nx];
        idxE_chunk[nm1d2] = idxE[nx];
        nx++;
      }

      a.set_size(idxE_chunk.size(0), csz_idx_1);
      A.set_size(idxE_chunk.size(0), csz_idx_1);
      result.set_size(idxE_chunk.size(0), csz_idx_1);
      inside.set_size(idxE_chunk.size(0), csz_idx_1);
      rows_to_keep.set_size(idxE_chunk.size(0));
      nm1d2 = idxE_chunk.size(0);
      for (i1 = 0; i1 < nm1d2; i1++) {
        rows_to_keep[i1] = false;
      }

      for (nm1d2 = 0; nm1d2 < i2; nm1d2++) {
        i1 = idxE_chunk.size(0);
        for (radiusRangeIn_size_idx_1 = 0; radiusRangeIn_size_idx_1 < i1;
             radiusRangeIn_size_idx_1++) {
          ndbl = radiusRange[nm1d2];
          Gmax = static_cast<float>(Ex_chunk[radiusRangeIn_size_idx_1]) +
            static_cast<float>(-ndbl) * (Gx[idxE_chunk[radiusRangeIn_size_idx_1]
            - 1] / gradientImg[idxE_chunk[radiusRangeIn_size_idx_1] - 1]);
          if (Gmax > 0.0F) {
            edgeThresh = Gmax + 0.5F;
          } else if (Gmax < 0.0F) {
            edgeThresh = Gmax - 0.5F;
          } else {
            edgeThresh = 0.0F;
          }

          a[radiusRangeIn_size_idx_1 + a.size(0) * nm1d2] = edgeThresh;
          Gmax = static_cast<float>(xckeep[radiusRangeIn_size_idx_1]) +
            static_cast<float>(-ndbl) * (Gy[idxE_chunk[radiusRangeIn_size_idx_1]
            - 1] / gradientImg[idxE_chunk[radiusRangeIn_size_idx_1] - 1]);
          if (Gmax > 0.0F) {
            Gmax += 0.5F;
          } else if (Gmax < 0.0F) {
            Gmax -= 0.5F;
          } else {
            Gmax = 0.0F;
          }

          A[radiusRangeIn_size_idx_1 + A.size(0) * nm1d2] = Gmax;
          result[radiusRangeIn_size_idx_1 + result.size(0) * nm1d2] = w0[nm1d2];
          y = ((edgeThresh >= 1.0F) && (static_cast<double>(edgeThresh) <= N) &&
               (Gmax >= 1.0F) && (static_cast<double>(Gmax) < M));
          inside[radiusRangeIn_size_idx_1 + inside.size(0) * nm1d2] = y;
          if (y) {
            rows_to_keep[radiusRangeIn_size_idx_1] = true;
          }
        }
      }

      xckeep.set_size((a.size(0) * a.size(1)));
      yckeep.set_size((A.size(0) * A.size(1)));
      Ex_chunk.set_size((result.size(0) * result.size(1)));
      nx = -1;
      for (nm1d2 = 0; nm1d2 < i3; nm1d2++) {
        i1 = idxE_chunk.size(0);
        for (radiusRangeIn_size_idx_1 = 0; radiusRangeIn_size_idx_1 < i1;
             radiusRangeIn_size_idx_1++) {
          if (rows_to_keep[radiusRangeIn_size_idx_1] &&
              inside[radiusRangeIn_size_idx_1 + inside.size(0) * nm1d2]) {
            nx++;
            xckeep[nx] = static_cast<int>(a[radiusRangeIn_size_idx_1 + a.size(0)
              * nm1d2]);
            yckeep[nx] = static_cast<int>(A[radiusRangeIn_size_idx_1 + A.size(0)
              * nm1d2]);
            Ex_chunk[nx] = result[radiusRangeIn_size_idx_1 + result.size(0) *
              nm1d2];
          }
        }
      }

      r1.set_size((static_cast<int>(pad[0])), (static_cast<int>(pad[1])));
      for (i1 = 0; i1 < loop_ub; i1++) {
        r1[i1].re = 0.0;
        r1[i1].im = 0.0;
      }

      for (nm1d2 = 0; nm1d2 <= nx; nm1d2++) {
        r1[(yckeep[nm1d2] + r1.size(0) * (xckeep[nm1d2] - 1)) - 1].re = r1
          [(yckeep[nm1d2] + r1.size(0) * (xckeep[nm1d2] - 1)) - 1].re +
          Ex_chunk[nm1d2];
      }

      nm1d2 = accumMatrix.size(0) * accumMatrix.size(1);
      for (i1 = 0; i1 < nm1d2; i1++) {
        accumMatrix[i1].re = accumMatrix[i1].re + r1[i1].re;
        accumMatrix[i1].im = accumMatrix[i1].im + r1[i1].im;
      }
    }
  }
}

// End of code generation (chaccum.cpp)
