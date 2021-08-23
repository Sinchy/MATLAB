//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  minOrMax.cpp
//
//  Code generation for function 'minOrMax'
//


// Include files
#include "minOrMax.h"
#include "BubbleCenterAndSizeByCircle_rtwutil.h"
#include "CircleIdentifier.h"
#include "chradii.h"
#include "multithresh.h"
#include "relop.h"
#include "rt_defines.h"
#include "rt_nonfinite.h"
#include <cmath>
#include <math.h>

// Function Declarations
static double rt_atan2d_snf(double u0, double u1);

// Function Definitions
static double rt_atan2d_snf(double u0, double u1)
{
  double y;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = rtNaN;
  } else if (rtIsInf(u0) && rtIsInf(u1)) {
    int b_u0;
    int b_u1;
    if (u0 > 0.0) {
      b_u0 = 1;
    } else {
      b_u0 = -1;
    }

    if (u1 > 0.0) {
      b_u1 = 1;
    } else {
      b_u1 = -1;
    }

    y = atan2(static_cast<double>(b_u0), static_cast<double>(b_u1));
  } else if (u1 == 0.0) {
    if (u0 > 0.0) {
      y = RT_PI / 2.0;
    } else if (u0 < 0.0) {
      y = -(RT_PI / 2.0);
    } else {
      y = 0.0;
    }
  } else {
    y = atan2(u0, u1);
  }

  return y;
}

double b_maximum(const double x[256])
{
  double ex;
  int idx;
  int k;
  if (!rtIsNaN(x[0])) {
    idx = 1;
  } else {
    bool exitg1;
    idx = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k <= 256)) {
      if (!rtIsNaN(x[k - 1])) {
        idx = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }

  if (idx == 0) {
    ex = x[0];
  } else {
    ex = x[idx - 1];
    idx++;
    for (k = idx; k < 257; k++) {
      double d;
      d = x[k - 1];
      if (ex < d) {
        ex = d;
      }
    }
  }

  return ex;
}

double c_maximum(const double x_data[], const int x_size[2])
{
  double ex;
  int n;
  n = x_size[1];
  if (x_size[1] <= 2) {
    if (x_size[1] == 1) {
      ex = x_data[0];
    } else if ((x_data[0] < x_data[1]) || (rtIsNaN(x_data[0]) && (!rtIsNaN
                 (x_data[1])))) {
      ex = x_data[1];
    } else {
      ex = x_data[0];
    }
  } else {
    int idx;
    int k;
    if (!rtIsNaN(x_data[0])) {
      idx = 1;
    } else {
      bool exitg1;
      idx = 0;
      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= x_size[1])) {
        if (!rtIsNaN(x_data[k - 1])) {
          idx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }

    if (idx == 0) {
      ex = x_data[0];
    } else {
      ex = x_data[idx - 1];
      idx++;
      for (k = idx; k <= n; k++) {
        double d;
        d = x_data[k - 1];
        if (ex < d) {
          ex = d;
        }
      }
    }
  }

  return ex;
}

double d_maximum(const coder::array<double, 1U> &x)
{
  double ex;
  int n;
  n = x.size(0);
  if (x.size(0) <= 2) {
    if (x.size(0) == 1) {
      ex = x[0];
    } else if ((x[0] < x[1]) || (rtIsNaN(x[0]) && (!rtIsNaN(x[1])))) {
      ex = x[1];
    } else {
      ex = x[0];
    }
  } else {
    int idx;
    int k;
    if (!rtIsNaN(x[0])) {
      idx = 1;
    } else {
      bool exitg1;
      idx = 0;
      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= x.size(0))) {
        if (!rtIsNaN(x[k - 1])) {
          idx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }

    if (idx == 0) {
      ex = x[0];
    } else {
      ex = x[idx - 1];
      idx++;
      for (k = idx; k <= n; k++) {
        double d;
        d = x[k - 1];
        if (ex < d) {
          ex = d;
        }
      }
    }
  }

  return ex;
}

void e_maximum(const coder::array<creal_T, 1U> &x, creal_T *ex, int *idx)
{
  int istop;
  istop = x.size(0);
  *idx = 1;
  *ex = x[0];
  for (int k = 2; k <= istop; k++) {
    creal_T dc;
    bool SCALEA;
    dc = x[k - 1];
    if (rtIsNaN(dc.re) || rtIsNaN(x[k - 1].im)) {
      SCALEA = false;
    } else if (rtIsNaN(ex->re) || rtIsNaN(ex->im)) {
      SCALEA = true;
    } else {
      double ma;
      double mb;
      bool SCALEB;
      double b_x;
      double absbi;
      ma = std::abs(ex->re);
      if ((ma > 8.9884656743115785E+307) || (std::abs(ex->im) >
           8.9884656743115785E+307)) {
        SCALEA = true;
      } else {
        SCALEA = false;
      }

      mb = std::abs(x[k - 1].re);
      if ((mb > 8.9884656743115785E+307) || (std::abs(x[k - 1].im) >
           8.9884656743115785E+307)) {
        SCALEB = true;
      } else {
        SCALEB = false;
      }

      if (SCALEA || SCALEB) {
        b_x = rt_hypotd_snf(ex->re / 2.0, ex->im / 2.0);
        absbi = rt_hypotd_snf(x[k - 1].re / 2.0, x[k - 1].im / 2.0);
      } else {
        b_x = rt_hypotd_snf(ex->re, ex->im);
        absbi = rt_hypotd_snf(x[k - 1].re, x[k - 1].im);
      }

      if (iseq(b_x, absbi)) {
        double absai;
        double Ma;
        absai = std::abs(ex->im);
        absbi = std::abs(x[k - 1].im);
        if (ma > absai) {
          Ma = ma;
          ma = absai;
        } else {
          Ma = absai;
        }

        if (mb > absbi) {
          absai = mb;
          mb = absbi;
        } else {
          absai = absbi;
        }

        if (Ma > absai) {
          if (ma < mb) {
            b_x = Ma - absai;
            absbi = (ma / 2.0 + mb / 2.0) / (Ma / 2.0 + absai / 2.0) * (mb - ma);
          } else {
            b_x = Ma;
            absbi = absai;
          }
        } else if (Ma < absai) {
          if (ma > mb) {
            absbi = absai - Ma;
            b_x = (ma / 2.0 + mb / 2.0) / (Ma / 2.0 + absai / 2.0) * (ma - mb);
          } else {
            b_x = Ma;
            absbi = absai;
          }
        } else {
          b_x = ma;
          absbi = mb;
        }

        if (iseq(b_x, absbi)) {
          b_x = rt_atan2d_snf(ex->im, ex->re);
          absbi = rt_atan2d_snf(x[k - 1].im, x[k - 1].re);
          if (iseq(b_x, absbi)) {
            absbi = x[k - 1].re;
            absai = x[k - 1].im;
            if (b_x > 0.78539816339744828) {
              if (b_x > 2.3561944901923448) {
                b_x = -ex->im;
                absbi = -absai;
              } else {
                b_x = -ex->re;
                absbi = -absbi;
              }
            } else if (b_x > -0.78539816339744828) {
              b_x = ex->im;
              absbi = absai;
            } else if (b_x > -2.3561944901923448) {
              b_x = ex->re;
            } else {
              b_x = -ex->im;
              absbi = -absai;
            }

            if (iseq(b_x, absbi)) {
              b_x = 0.0;
              absbi = 0.0;
            }
          }
        }
      }

      SCALEA = (b_x < absbi);
    }

    if (SCALEA) {
      *ex = dc;
      *idx = k;
    }
  }
}

float maximum(const coder::array<float, 1U> &x)
{
  float ex;
  int n;
  n = x.size(0);
  if (x.size(0) <= 2) {
    if (x.size(0) == 1) {
      ex = x[0];
    } else if ((x[0] < x[1]) || (rtIsNaNF(x[0]) && (!rtIsNaNF(x[1])))) {
      ex = x[1];
    } else {
      ex = x[0];
    }
  } else {
    int idx;
    int k;
    if (!rtIsNaNF(x[0])) {
      idx = 1;
    } else {
      bool exitg1;
      idx = 0;
      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= x.size(0))) {
        if (!rtIsNaNF(x[k - 1])) {
          idx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }

    if (idx == 0) {
      ex = x[0];
    } else {
      ex = x[idx - 1];
      idx++;
      for (k = idx; k <= n; k++) {
        float f;
        f = x[k - 1];
        if (ex < f) {
          ex = f;
        }
      }
    }
  }

  return ex;
}

float minimum(const coder::array<float, 1U> &x)
{
  float ex;
  int n;
  n = x.size(0);
  if (x.size(0) <= 2) {
    if (x.size(0) == 1) {
      ex = x[0];
    } else if ((x[0] > x[1]) || (rtIsNaNF(x[0]) && (!rtIsNaNF(x[1])))) {
      ex = x[1];
    } else {
      ex = x[0];
    }
  } else {
    int idx;
    int k;
    if (!rtIsNaNF(x[0])) {
      idx = 1;
    } else {
      bool exitg1;
      idx = 0;
      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= x.size(0))) {
        if (!rtIsNaNF(x[k - 1])) {
          idx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }

    if (idx == 0) {
      ex = x[0];
    } else {
      ex = x[idx - 1];
      idx++;
      for (k = idx; k <= n; k++) {
        float f;
        f = x[k - 1];
        if (ex > f) {
          ex = f;
        }
      }
    }
  }

  return ex;
}

// End of code generation (minOrMax.cpp)
