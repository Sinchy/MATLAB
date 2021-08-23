//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  unique.cpp
//
//  Code generation for function 'unique'
//


// Include files
#include "unique.h"
#include "CircleIdentifier.h"
#include "chradii.h"
#include "multithresh.h"
#include "rt_nonfinite.h"
#include <cmath>

// Function Definitions
void unique_vector(const coder::array<float, 1U> &a, coder::array<float, 1U> &b)
{
  int na;
  int n;
  coder::array<int, 1U> idx;
  int i;
  int b_i;
  coder::array<int, 1U> iwork;
  int k;
  int i2;
  bool exitg1;
  int j;
  float absx;
  int pEnd;
  int p;
  int qEnd;
  int exponent;
  na = a.size(0);
  n = a.size(0) + 1;
  idx.set_size(a.size(0));
  i = a.size(0);
  for (b_i = 0; b_i < i; b_i++) {
    idx[b_i] = 0;
  }

  if (a.size(0) != 0) {
    iwork.set_size(a.size(0));
    b_i = a.size(0) - 1;
    for (k = 1; k <= b_i; k += 2) {
      if ((a[k - 1] <= a[k]) || rtIsNaNF(a[k])) {
        idx[k - 1] = k;
        idx[k] = k + 1;
      } else {
        idx[k - 1] = k + 1;
        idx[k] = k;
      }
    }

    if ((a.size(0) & 1) != 0) {
      idx[a.size(0) - 1] = a.size(0);
    }

    i = 2;
    while (i < n - 1) {
      i2 = i << 1;
      j = 1;
      for (pEnd = i + 1; pEnd < n; pEnd = qEnd + i) {
        int q;
        int kEnd;
        p = j;
        q = pEnd - 1;
        qEnd = j + i2;
        if (qEnd > n) {
          qEnd = n;
        }

        k = 0;
        kEnd = qEnd - j;
        while (k + 1 <= kEnd) {
          absx = a[idx[q] - 1];
          b_i = idx[p - 1];
          if ((a[b_i - 1] <= absx) || rtIsNaNF(absx)) {
            iwork[k] = b_i;
            p++;
            if (p == pEnd) {
              while (q + 1 < qEnd) {
                k++;
                iwork[k] = idx[q];
                q++;
              }
            }
          } else {
            iwork[k] = idx[q];
            q++;
            if (q + 1 == qEnd) {
              while (p < pEnd) {
                k++;
                iwork[k] = idx[p - 1];
                p++;
              }
            }
          }

          k++;
        }

        for (k = 0; k < kEnd; k++) {
          idx[(j + k) - 1] = iwork[k];
        }

        j = qEnd;
      }

      i = i2;
    }
  }

  b.set_size(a.size(0));
  for (k = 0; k < na; k++) {
    b[k] = a[idx[k] - 1];
  }

  k = a.size(0);
  while ((k >= 1) && rtIsNaNF(b[k - 1])) {
    k--;
  }

  i2 = a.size(0) - k;
  exitg1 = false;
  while ((!exitg1) && (k >= 1)) {
    absx = b[k - 1];
    if (rtIsInfF(absx) && (absx > 0.0F)) {
      k--;
    } else {
      exitg1 = true;
    }
  }

  i = (a.size(0) - k) - i2;
  pEnd = -1;
  p = 0;
  while (p + 1 <= k) {
    float x;
    x = b[p];
    int exitg2;
    do {
      exitg2 = 0;
      p++;
      if (p + 1 > k) {
        exitg2 = 1;
      } else {
        absx = std::abs(x / 2.0F);
        if ((!rtIsInfF(absx)) && (!rtIsNaNF(absx))) {
          if (absx <= 1.17549435E-38F) {
            absx = 1.4013E-45F;
          } else {
            std::frexp(absx, &exponent);
            absx = std::ldexp(1.0F, exponent - 24);
          }
        } else {
          absx = rtNaNF;
        }

        if ((!(std::abs(x - b[p]) < absx)) && ((!rtIsInfF(b[p])) || (!rtIsInfF(x))
             || ((b[p] > 0.0F) != (x > 0.0F)))) {
          exitg2 = 1;
        }
      }
    } while (exitg2 == 0);

    pEnd++;
    b[pEnd] = x;
  }

  if (i > 0) {
    pEnd++;
    b[pEnd] = b[k];
  }

  p = k + i;
  for (j = 0; j < i2; j++) {
    pEnd++;
    b[pEnd] = b[p + j];
  }

  if (1 > pEnd + 1) {
    b_i = 0;
  } else {
    b_i = pEnd + 1;
  }

  b.set_size(b_i);
}

// End of code generation (unique.cpp)
