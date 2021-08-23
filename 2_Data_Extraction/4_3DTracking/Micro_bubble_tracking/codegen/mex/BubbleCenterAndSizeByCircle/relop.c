/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * relop.c
 *
 * Code generation for function 'relop'
 *
 */

/* Include files */
#include "relop.h"
#include "BubbleCenterAndSizeByCircle.h"
#include "BubbleCenterAndSizeByCircle_data.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
boolean_T relop(const creal_T a, const creal_T b)
{
  boolean_T p;
  real_T ma;
  boolean_T SCALEA;
  real_T mb;
  boolean_T SCALEB;
  real_T absbi;
  real_T y;
  real_T absx;
  int32_T exponent;
  real_T Ma;
  int32_T b_exponent;
  int32_T c_exponent;
  int32_T d_exponent;
  if (muDoubleScalarIsNaN(b.re) || muDoubleScalarIsNaN(b.im)) {
    p = false;
  } else if (muDoubleScalarIsNaN(a.re) || muDoubleScalarIsNaN(a.im)) {
    p = true;
  } else {
    ma = muDoubleScalarAbs(a.re);
    if ((ma > 8.9884656743115785E+307) || (muDoubleScalarAbs(a.im) >
         8.9884656743115785E+307)) {
      SCALEA = true;
    } else {
      SCALEA = false;
    }

    mb = muDoubleScalarAbs(b.re);
    if ((mb > 8.9884656743115785E+307) || (muDoubleScalarAbs(b.im) >
         8.9884656743115785E+307)) {
      SCALEB = true;
    } else {
      SCALEB = false;
    }

    if (SCALEA || SCALEB) {
      absbi = muDoubleScalarHypot(a.re / 2.0, a.im / 2.0);
      y = muDoubleScalarHypot(b.re / 2.0, b.im / 2.0);
    } else {
      absbi = muDoubleScalarHypot(a.re, a.im);
      y = muDoubleScalarHypot(b.re, b.im);
    }

    absx = y / 2.0;
    if ((!muDoubleScalarIsInf(absx)) && (!muDoubleScalarIsNaN(absx))) {
      if (absx <= 2.2250738585072014E-308) {
        absx = 4.94065645841247E-324;
      } else {
        frexp(absx, &exponent);
        absx = ldexp(1.0, exponent - 53);
      }
    } else {
      absx = rtNaN;
    }

    if ((muDoubleScalarAbs(y - absbi) < absx) || (muDoubleScalarIsInf(absbi) &&
         muDoubleScalarIsInf(y) && ((absbi > 0.0) == (y > 0.0)))) {
      p = true;
    } else {
      p = false;
    }

    if (p) {
      absx = muDoubleScalarAbs(a.im);
      absbi = muDoubleScalarAbs(b.im);
      if (ma > absx) {
        Ma = ma;
        ma = absx;
      } else {
        Ma = absx;
      }

      if (mb > absbi) {
        absx = mb;
        mb = absbi;
      } else {
        absx = absbi;
      }

      if (Ma > absx) {
        if (ma < mb) {
          absbi = Ma - absx;
          y = (ma / 2.0 + mb / 2.0) / (Ma / 2.0 + absx / 2.0) * (mb - ma);
        } else {
          absbi = Ma;
          y = absx;
        }
      } else if (Ma < absx) {
        if (ma > mb) {
          y = absx - Ma;
          absbi = (ma / 2.0 + mb / 2.0) / (Ma / 2.0 + absx / 2.0) * (ma - mb);
        } else {
          absbi = Ma;
          y = absx;
        }
      } else {
        absbi = ma;
        y = mb;
      }

      absx = muDoubleScalarAbs(y / 2.0);
      if ((!muDoubleScalarIsInf(absx)) && (!muDoubleScalarIsNaN(absx))) {
        if (absx <= 2.2250738585072014E-308) {
          absx = 4.94065645841247E-324;
        } else {
          frexp(absx, &b_exponent);
          absx = ldexp(1.0, b_exponent - 53);
        }
      } else {
        absx = rtNaN;
      }

      if ((muDoubleScalarAbs(y - absbi) < absx) || (muDoubleScalarIsInf(absbi) &&
           muDoubleScalarIsInf(y) && ((absbi > 0.0) == (y > 0.0)))) {
        p = true;
      } else {
        p = false;
      }

      if (p) {
        absbi = muDoubleScalarAtan2(a.im, a.re);
        y = muDoubleScalarAtan2(b.im, b.re);
        absx = muDoubleScalarAbs(y / 2.0);
        if ((!muDoubleScalarIsInf(absx)) && (!muDoubleScalarIsNaN(absx))) {
          if (absx <= 2.2250738585072014E-308) {
            absx = 4.94065645841247E-324;
          } else {
            frexp(absx, &c_exponent);
            absx = ldexp(1.0, c_exponent - 53);
          }
        } else {
          absx = rtNaN;
        }

        if ((muDoubleScalarAbs(y - absbi) < absx) || (muDoubleScalarIsInf(absbi)
             && muDoubleScalarIsInf(y) && ((absbi > 0.0) == (y > 0.0)))) {
          p = true;
        } else {
          p = false;
        }

        if (p) {
          if (absbi > 0.78539816339744828) {
            if (absbi > 2.3561944901923448) {
              absbi = -a.im;
              y = -b.im;
            } else {
              absbi = -a.re;
              y = -b.re;
            }
          } else if (absbi > -0.78539816339744828) {
            absbi = a.im;
            y = b.im;
          } else if (absbi > -2.3561944901923448) {
            absbi = a.re;
            y = b.re;
          } else {
            absbi = -a.im;
            y = -b.im;
          }

          absx = muDoubleScalarAbs(y / 2.0);
          if ((!muDoubleScalarIsInf(absx)) && (!muDoubleScalarIsNaN(absx))) {
            if (absx <= 2.2250738585072014E-308) {
              absx = 4.94065645841247E-324;
            } else {
              frexp(absx, &d_exponent);
              absx = ldexp(1.0, d_exponent - 53);
            }
          } else {
            absx = rtNaN;
          }

          if ((muDoubleScalarAbs(y - absbi) < absx) || (muDoubleScalarIsInf
               (absbi) && muDoubleScalarIsInf(y) && ((absbi > 0.0) == (y > 0.0))))
          {
            p = true;
          } else {
            p = false;
          }

          if (p) {
            absbi = 0.0;
            y = 0.0;
          }
        }
      }
    }

    p = (absbi < y);
  }

  return p;
}

/* End of code generation (relop.c) */
