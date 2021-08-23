//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  colon.cpp
//
//  Code generation for function 'colon'
//


// Include files
#include "colon.h"
#include "CircleIdentifier.h"
#include "rt_nonfinite.h"
#include <cmath>

// Function Definitions
void b_eml_float_colon(double a, double b, coder::array<double, 2U> &y)
{
  double ndbl;
  double apnd;
  double cdiff;
  double u0;
  double u1;
  int n;
  ndbl = std::floor((b - a) + 0.5);
  apnd = a + ndbl;
  cdiff = apnd - b;
  u0 = std::abs(a);
  u1 = std::abs(b);
  if ((u0 > u1) || rtIsNaN(u1)) {
    u1 = u0;
  }

  if (std::abs(cdiff) < 4.4408920985006262E-16 * u1) {
    ndbl++;
    apnd = b;
  } else if (cdiff > 0.0) {
    apnd = a + (ndbl - 1.0);
  } else {
    ndbl++;
  }

  if (ndbl >= 0.0) {
    n = static_cast<int>(ndbl);
  } else {
    n = 0;
  }

  y.set_size(1, n);
  if (n > 0) {
    y[0] = a;
    if (n > 1) {
      int nm1d2;
      y[n - 1] = apnd;
      nm1d2 = (n - 1) / 2;
      for (int k = 0; k <= nm1d2 - 2; k++) {
        int y_tmp;
        y_tmp = k + 1;
        y[k + 1] = a + static_cast<double>(y_tmp);
        y[(n - k) - 2] = apnd - static_cast<double>(y_tmp);
      }

      if (nm1d2 << 1 == n - 1) {
        y[nm1d2] = (a + apnd) / 2.0;
      } else {
        y[nm1d2] = a + static_cast<double>(nm1d2);
        y[nm1d2 + 1] = apnd - static_cast<double>(nm1d2);
      }
    }
  }
}

void eml_float_colon(double a, double b, coder::array<double, 2U> &y)
{
  double ndbl;
  double apnd;
  double cdiff;
  double u0;
  double u1;
  int n;
  ndbl = std::floor((b - a) / 0.5 + 0.5);
  apnd = a + ndbl * 0.5;
  cdiff = apnd - b;
  u0 = std::abs(a);
  u1 = std::abs(b);
  if ((u0 > u1) || rtIsNaN(u1)) {
    u1 = u0;
  }

  if (std::abs(cdiff) < 4.4408920985006262E-16 * u1) {
    ndbl++;
    apnd = b;
  } else if (cdiff > 0.0) {
    apnd = a + (ndbl - 1.0) * 0.5;
  } else {
    ndbl++;
  }

  if (ndbl >= 0.0) {
    n = static_cast<int>(ndbl);
  } else {
    n = 0;
  }

  y.set_size(1, n);
  if (n > 0) {
    y[0] = a;
    if (n > 1) {
      int nm1d2;
      y[n - 1] = apnd;
      nm1d2 = (n - 1) / 2;
      for (int k = 0; k <= nm1d2 - 2; k++) {
        ndbl = (static_cast<double>(k) + 1.0) * 0.5;
        y[k + 1] = a + ndbl;
        y[(n - k) - 2] = apnd - ndbl;
      }

      if (nm1d2 << 1 == n - 1) {
        y[nm1d2] = (a + apnd) / 2.0;
      } else {
        ndbl = static_cast<double>(nm1d2) * 0.5;
        y[nm1d2] = a + ndbl;
        y[nm1d2 + 1] = apnd - ndbl;
      }
    }
  }
}

// End of code generation (colon.cpp)
