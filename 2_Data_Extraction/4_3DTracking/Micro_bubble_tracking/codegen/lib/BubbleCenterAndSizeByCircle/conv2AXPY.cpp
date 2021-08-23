//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  conv2AXPY.cpp
//
//  Code generation for function 'conv2AXPY'
//


// Include files
#include "conv2AXPY.h"
#include "CircleIdentifier.h"
#include "chradii.h"
#include "rt_nonfinite.h"

// Function Definitions
void b_conv2AXPYSameCMP(const coder::array<double, 2U> &a, coder::array<double,
  2U> &c)
{
  int ma;
  int na;
  int jcut;
  int ub_loop;
  coder::array<double, 1U> cj;
  int imax;
  int imin;
  int bij;
  int jbmax;
  int jbmin;
  int jb;
  int ib;
  static const signed char b[9] = { -1, -2, -1, 0, 0, 0, 1, 2, 1 };

  int i;
  ma = a.size(0);
  na = a.size(1);
  jcut = a.size(1) - 1;
  c.set_size(a.size(0), a.size(1));
  ub_loop = a.size(1) - 1;

#pragma omp parallel for \
 num_threads(omp_get_max_threads()) \
 private(cj,imax,imin,bij,jbmax,jbmin,jb,ib,i)

  for (int j = 0; j <= ub_loop; j++) {
    cj.set_size(ma);
    for (imin = 0; imin < ma; imin++) {
      cj[imin] = 0.0;
    }

    jbmin = (j + 1 <= 1);
    if (j + 1 < jcut) {
      jbmax = 2;
    } else {
      jbmax = na - j;
    }

    for (jb = jbmin; jb <= jbmax; jb++) {
      for (ib = 0; ib < 3; ib++) {
        bij = b[(3 * (2 - jb) - ib) + 2];
        if (ib < 1) {
          imin = 2;
          imax = ma;
        } else {
          imin = 1;
          imax = (ma - ib) + 1;
        }

        for (i = imin; i <= imax; i++) {
          cj[i - 1] = cj[i - 1] + static_cast<double>(bij) * a[((i + ib) +
            a.size(0) * ((j + jb) - 1)) - 2];
        }
      }
    }

    imax = cj.size(0);
    for (imin = 0; imin < imax; imin++) {
      c[imin + c.size(0) * j] = cj[imin];
    }
  }
}

void c_conv2AXPYSameCMP(const coder::array<double, 2U> &a, coder::array<double,
  2U> &c)
{
  int ma;
  int na;
  int jcut;
  int ub_loop;
  coder::array<double, 1U> cj;
  int imax;
  int imin;
  int bij;
  int jbmax;
  int jbmin;
  int jb;
  int ib;
  static const signed char b[9] = { -1, 0, 1, -2, 0, 2, -1, 0, 1 };

  int i;
  ma = a.size(0);
  na = a.size(1);
  jcut = a.size(1) - 1;
  c.set_size(a.size(0), a.size(1));
  ub_loop = a.size(1) - 1;

#pragma omp parallel for \
 num_threads(omp_get_max_threads()) \
 private(cj,imax,imin,bij,jbmax,jbmin,jb,ib,i)

  for (int j = 0; j <= ub_loop; j++) {
    cj.set_size(ma);
    for (imin = 0; imin < ma; imin++) {
      cj[imin] = 0.0;
    }

    jbmin = (j + 1 <= 1);
    if (j + 1 < jcut) {
      jbmax = 2;
    } else {
      jbmax = na - j;
    }

    for (jb = jbmin; jb <= jbmax; jb++) {
      for (ib = 0; ib < 3; ib++) {
        bij = b[(3 * (2 - jb) - ib) + 2];
        if (ib < 1) {
          imin = 2;
          imax = ma;
        } else {
          imin = 1;
          imax = (ma - ib) + 1;
        }

        for (i = imin; i <= imax; i++) {
          cj[i - 1] = cj[i - 1] + static_cast<double>(bij) * a[((i + ib) +
            a.size(0) * ((j + jb) - 1)) - 2];
        }
      }
    }

    imax = cj.size(0);
    for (imin = 0; imin < imax; imin++) {
      c[imin + c.size(0) * j] = cj[imin];
    }
  }
}

void conv2AXPYSameCMP(const coder::array<double, 2U> &a, coder::array<double, 2U>
                      &c)
{
  int ma;
  int na;
  int jcut;
  int ub_loop;
  coder::array<double, 1U> cj;
  int imax;
  int imin;
  double bij;
  int jbmax;
  int jbmin;
  int jb;
  int ib;
  static const double b[25] = { 0.014418818362460822, 0.028084023356349175,
    0.0350727008055935, 0.028084023356349175, 0.014418818362460822,
    0.028084023356349175, 0.054700208300935887, 0.068312293270780214,
    0.054700208300935887, 0.028084023356349175, 0.0350727008055935,
    0.068312293270780214, 0.085311730190125085, 0.068312293270780214,
    0.0350727008055935, 0.028084023356349175, 0.054700208300935887,
    0.068312293270780214, 0.054700208300935887, 0.028084023356349175,
    0.014418818362460822, 0.028084023356349175, 0.0350727008055935,
    0.028084023356349175, 0.014418818362460822 };

  int i;
  ma = a.size(0);
  na = a.size(1);
  jcut = a.size(1) - 2;
  c.set_size(a.size(0), a.size(1));
  ub_loop = a.size(1) - 1;

#pragma omp parallel for \
 num_threads(omp_get_max_threads()) \
 private(cj,imax,imin,bij,jbmax,jbmin,jb,ib,i)

  for (int j = 0; j <= ub_loop; j++) {
    cj.set_size(ma);
    for (imin = 0; imin < ma; imin++) {
      cj[imin] = 0.0;
    }

    if (j + 1 > 2) {
      jbmin = 0;
    } else {
      jbmin = 2 - j;
    }

    if (j + 1 < jcut) {
      jbmax = 4;
    } else {
      jbmax = (na - j) + 1;
    }

    for (jb = jbmin; jb <= jbmax; jb++) {
      for (ib = 0; ib < 5; ib++) {
        bij = b[(5 * (4 - jb) - ib) + 4];
        if (ib < 2) {
          imin = 3 - ib;
          imax = ma;
        } else {
          imin = 1;
          imax = (ma - ib) + 2;
        }

        for (i = imin; i <= imax; i++) {
          cj[i - 1] = cj[i - 1] + bij * a[((i + ib) + a.size(0) * ((j + jb) - 2))
            - 3];
        }
      }
    }

    imax = cj.size(0);
    for (imin = 0; imin < imax; imin++) {
      c[imin + c.size(0) * j] = cj[imin];
    }
  }
}

// End of code generation (conv2AXPY.cpp)
