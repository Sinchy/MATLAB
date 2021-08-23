//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  imhmax.cpp
//
//  Code generation for function 'imhmax'
//


// Include files
#include "imhmax.h"
#include "BubbleCenterAndSizeByCircle_rtwutil.h"
#include "CircleIdentifier.h"
#include "NeighborhoodProcessor.h"
#include "chcenters.h"
#include "chradii.h"
#include "minOrMax.h"
#include "rt_nonfinite.h"
#include "sortIdx.h"
#include <cstring>

// Function Definitions
void imhmax(const coder::array<double, 2U> &b_I, double H, coder::array<double,
            2U> &J)
{
  int loop_ub;
  int i;
  int trueCount;
  int ind;
  coder::array<int, 1U> r;
  int partialTrueCount;
  c_images_internal_coder_Neighbo np;
  int iv[18];
  int iv1[9];
  int imnhInds_[9];
  bool isInside[9];
  double dv[2];
  int pixelSub[2];
  int numPixels;
  int pInd;
  int J_size[2];
  coder::array<int, 2U> locationStack;
  int stackTop;
  int b_pixelSub[2];
  int c_pixelSub[2];
  int d_pixelSub[2];
  int imnhSubs[18];
  coder::array<double, 1U> J_data;
  double b_J_data[9];
  int imnhInds_data[9];
  bool exitg1;
  double c_J_data[9];
  coder::array<double, 1U> d_J_data;
  J.set_size(b_I.size(0), b_I.size(1));
  loop_ub = b_I.size(0) * b_I.size(1);
  for (i = 0; i < loop_ub; i++) {
    J[i] = b_I[i] - H;
  }

  loop_ub = J.size(0) * J.size(1) - 1;
  trueCount = 0;
  for (ind = 0; ind <= loop_ub; ind++) {
    if (J[ind] > b_I[ind]) {
      trueCount++;
    }
  }

  r.set_size(trueCount);
  partialTrueCount = 0;
  for (ind = 0; ind <= loop_ub; ind++) {
    if (J[ind] > b_I[ind]) {
      r[partialTrueCount] = ind + 1;
      partialTrueCount++;
    }
  }

  loop_ub = r.size(0);
  for (i = 0; i < loop_ub; i++) {
    J[r[i] - 1] = b_I[r[i] - 1];
  }

  np.ImageSize[0] = J.size(0);
  np.ImageSize[1] = J.size(1);
  for (ind = 0; ind < 9; ind++) {
    iv1[ind] = 0;
    imnhInds_[ind] = 0;
  }

  std::memset(&iv[0], 0, 18U * sizeof(int));
  for (i = 0; i < 9; i++) {
    isInside[i] = true;
  }

  c_images_internal_coder_Neighbo::computeParameters((np.ImageSize), (isInside),
    (iv1), (imnhInds_), (iv), (dv), (pixelSub));
  numPixels = J.size(0) * J.size(1);
  if (J.size(0) == 1) {
    double u0;
    if (0 <= numPixels - 1) {
      J_size[0] = 1;
    }

    for (pInd = 0; pInd < numPixels; pInd++) {
      for (ind = 0; ind < 9; ind++) {
        imnhInds_[ind] = (iv1[ind] + pInd) + 1;
      }

      if (np.ImageSize[0] == 0) {
        loop_ub = 0;
      } else {
        loop_ub = pInd - np.ImageSize[0] * div_s32(pInd, np.ImageSize[0]);
      }

      ind = pInd - loop_ub;
      if (np.ImageSize[0] == 0) {
        if (ind == 0) {
          partialTrueCount = 0;
        } else if (ind < 0) {
          partialTrueCount = MIN_int32_T;
        } else {
          partialTrueCount = MAX_int32_T;
        }
      } else if (np.ImageSize[0] == 1) {
        partialTrueCount = ind;
      } else {
        if (ind >= 0) {
          trueCount = ind;
        } else if (ind == MIN_int32_T) {
          trueCount = MAX_int32_T;
        } else {
          trueCount = -ind;
        }

        partialTrueCount = div_s32(trueCount, np.ImageSize[0]);
        trueCount -= partialTrueCount * np.ImageSize[0];
        if ((trueCount > 0) && (trueCount >= (np.ImageSize[0] >> 1) +
                                (np.ImageSize[0] & 1))) {
          partialTrueCount++;
        }

        if (ind < 0) {
          partialTrueCount = -partialTrueCount;
        }
      }

      b_pixelSub[1] = partialTrueCount + 1;
      b_pixelSub[0] = loop_ub + 1;
      for (ind = 0; ind < 2; ind++) {
        pixelSub[ind] = b_pixelSub[ind];
        for (trueCount = 0; trueCount < 9; trueCount++) {
          loop_ub = trueCount + 9 * ind;
          imnhSubs[loop_ub] = iv[loop_ub] + pixelSub[ind];
        }
      }

      trueCount = 0;
      partialTrueCount = 0;
      for (ind = 0; ind < 9; ind++) {
        isInside[ind] = true;
        loop_ub = 0;
        exitg1 = false;
        while ((!exitg1) && (loop_ub < 2)) {
          i = ind + 9 * loop_ub;
          if ((imnhSubs[i] < 1) || (imnhSubs[i] > np.ImageSize[loop_ub])) {
            isInside[ind] = false;
            exitg1 = true;
          } else {
            loop_ub++;
          }
        }

        if (isInside[ind]) {
          trueCount++;
          imnhInds_data[partialTrueCount] = imnhInds_[ind];
          partialTrueCount++;
        }
      }

      J_size[1] = trueCount;
      for (i = 0; i < trueCount; i++) {
        c_J_data[i] = J[imnhInds_data[i] - 1];
      }

      u0 = c_maximum(c_J_data, J_size);
      if ((u0 < b_I[pInd]) || rtIsNaN(b_I[pInd])) {
        J[pInd] = u0;
      } else {
        J[pInd] = b_I[pInd];
      }
    }

    locationStack.set_size(1, (numPixels << 1));
    stackTop = -1;
    if (numPixels >= 1) {
      J_size[0] = 1;
    }

    for (pInd = numPixels; pInd >= 1; pInd--) {
      for (ind = 0; ind < 9; ind++) {
        imnhInds_[ind] = iv1[ind] + pInd;
      }

      if (np.ImageSize[0] == 0) {
        loop_ub = 1;
      } else {
        loop_ub = pInd - np.ImageSize[0] * div_s32(pInd - 1, np.ImageSize[0]);
      }

      ind = pInd - loop_ub;
      if (np.ImageSize[0] == 0) {
        if (ind == 0) {
          partialTrueCount = 0;
        } else if (ind < 0) {
          partialTrueCount = MIN_int32_T;
        } else {
          partialTrueCount = MAX_int32_T;
        }
      } else if (np.ImageSize[0] == 1) {
        partialTrueCount = ind;
      } else {
        if (ind >= 0) {
          trueCount = ind;
        } else if (ind == MIN_int32_T) {
          trueCount = MAX_int32_T;
        } else {
          trueCount = -ind;
        }

        partialTrueCount = div_s32(trueCount, np.ImageSize[0]);
        trueCount -= partialTrueCount * np.ImageSize[0];
        if ((trueCount > 0) && (trueCount >= (np.ImageSize[0] >> 1) +
                                (np.ImageSize[0] & 1))) {
          partialTrueCount++;
        }

        if (ind < 0) {
          partialTrueCount = -partialTrueCount;
        }
      }

      c_pixelSub[1] = partialTrueCount + 1;
      c_pixelSub[0] = loop_ub;
      for (ind = 0; ind < 2; ind++) {
        pixelSub[ind] = c_pixelSub[ind];
        for (trueCount = 0; trueCount < 9; trueCount++) {
          loop_ub = trueCount + 9 * ind;
          imnhSubs[loop_ub] = iv[loop_ub] + pixelSub[ind];
        }
      }

      trueCount = 0;
      partialTrueCount = 0;
      for (ind = 0; ind < 9; ind++) {
        isInside[ind] = true;
        loop_ub = 0;
        exitg1 = false;
        while ((!exitg1) && (loop_ub < 2)) {
          i = ind + 9 * loop_ub;
          if ((imnhSubs[i] < 1) || (imnhSubs[i] > np.ImageSize[loop_ub])) {
            isInside[ind] = false;
            exitg1 = true;
          } else {
            loop_ub++;
          }
        }

        if (isInside[ind]) {
          trueCount++;
          imnhInds_data[partialTrueCount] = imnhInds_[ind];
          partialTrueCount++;
        }
      }

      J_size[1] = trueCount;
      for (i = 0; i < trueCount; i++) {
        c_J_data[i] = J[imnhInds_data[i] - 1];
      }

      u0 = c_maximum(c_J_data, J_size);
      if ((u0 < b_I[pInd - 1]) || rtIsNaN(b_I[pInd - 1])) {
        J[pInd - 1] = u0;
      } else {
        J[pInd - 1] = b_I[pInd - 1];
      }

      ind = 0;
      exitg1 = false;
      while ((!exitg1) && (ind <= trueCount - 1)) {
        if ((J[imnhInds_data[ind] - 1] < J[pInd - 1]) && (J[imnhInds_data[ind] -
             1] < b_I[imnhInds_data[ind] - 1])) {
          stackTop++;
          locationStack[stackTop] = pInd;
          exitg1 = true;
        } else {
          ind++;
        }
      }
    }
  } else {
    double u0;
    for (pInd = 0; pInd < numPixels; pInd++) {
      for (ind = 0; ind < 9; ind++) {
        imnhInds_[ind] = (iv1[ind] + pInd) + 1;
      }

      if (np.ImageSize[0] == 0) {
        loop_ub = 0;
      } else {
        loop_ub = pInd - np.ImageSize[0] * div_s32(pInd, np.ImageSize[0]);
      }

      ind = pInd - loop_ub;
      if (np.ImageSize[0] == 0) {
        if (ind == 0) {
          partialTrueCount = 0;
        } else if (ind < 0) {
          partialTrueCount = MIN_int32_T;
        } else {
          partialTrueCount = MAX_int32_T;
        }
      } else if (np.ImageSize[0] == 1) {
        partialTrueCount = ind;
      } else {
        if (ind >= 0) {
          trueCount = ind;
        } else if (ind == MIN_int32_T) {
          trueCount = MAX_int32_T;
        } else {
          trueCount = -ind;
        }

        partialTrueCount = div_s32(trueCount, np.ImageSize[0]);
        trueCount -= partialTrueCount * np.ImageSize[0];
        if ((trueCount > 0) && (trueCount >= (np.ImageSize[0] >> 1) +
                                (np.ImageSize[0] & 1))) {
          partialTrueCount++;
        }

        if (ind < 0) {
          partialTrueCount = -partialTrueCount;
        }
      }

      b_pixelSub[1] = partialTrueCount + 1;
      b_pixelSub[0] = loop_ub + 1;
      for (ind = 0; ind < 2; ind++) {
        pixelSub[ind] = b_pixelSub[ind];
        for (trueCount = 0; trueCount < 9; trueCount++) {
          loop_ub = trueCount + 9 * ind;
          imnhSubs[loop_ub] = iv[loop_ub] + pixelSub[ind];
        }
      }

      trueCount = 0;
      partialTrueCount = 0;
      for (ind = 0; ind < 9; ind++) {
        isInside[ind] = true;
        loop_ub = 0;
        exitg1 = false;
        while ((!exitg1) && (loop_ub < 2)) {
          i = ind + 9 * loop_ub;
          if ((imnhSubs[i] < 1) || (imnhSubs[i] > np.ImageSize[loop_ub])) {
            isInside[ind] = false;
            exitg1 = true;
          } else {
            loop_ub++;
          }
        }

        if (isInside[ind]) {
          trueCount++;
          imnhInds_data[partialTrueCount] = imnhInds_[ind];
          partialTrueCount++;
        }
      }

      for (i = 0; i < trueCount; i++) {
        b_J_data[i] = J[imnhInds_data[i] - 1];
      }

      J_data.set((&b_J_data[0]), trueCount);
      u0 = d_maximum(J_data);
      if ((u0 < b_I[pInd]) || rtIsNaN(b_I[pInd])) {
        J[pInd] = u0;
      } else {
        J[pInd] = b_I[pInd];
      }
    }

    locationStack.set_size(1, (numPixels << 1));
    stackTop = -1;
    for (pInd = numPixels; pInd >= 1; pInd--) {
      for (ind = 0; ind < 9; ind++) {
        imnhInds_[ind] = iv1[ind] + pInd;
      }

      if (np.ImageSize[0] == 0) {
        loop_ub = 1;
      } else {
        loop_ub = pInd - np.ImageSize[0] * div_s32(pInd - 1, np.ImageSize[0]);
      }

      ind = pInd - loop_ub;
      if (np.ImageSize[0] == 0) {
        if (ind == 0) {
          partialTrueCount = 0;
        } else if (ind < 0) {
          partialTrueCount = MIN_int32_T;
        } else {
          partialTrueCount = MAX_int32_T;
        }
      } else if (np.ImageSize[0] == 1) {
        partialTrueCount = ind;
      } else {
        if (ind >= 0) {
          trueCount = ind;
        } else if (ind == MIN_int32_T) {
          trueCount = MAX_int32_T;
        } else {
          trueCount = -ind;
        }

        partialTrueCount = div_s32(trueCount, np.ImageSize[0]);
        trueCount -= partialTrueCount * np.ImageSize[0];
        if ((trueCount > 0) && (trueCount >= (np.ImageSize[0] >> 1) +
                                (np.ImageSize[0] & 1))) {
          partialTrueCount++;
        }

        if (ind < 0) {
          partialTrueCount = -partialTrueCount;
        }
      }

      c_pixelSub[1] = partialTrueCount + 1;
      c_pixelSub[0] = loop_ub;
      for (ind = 0; ind < 2; ind++) {
        pixelSub[ind] = c_pixelSub[ind];
        for (trueCount = 0; trueCount < 9; trueCount++) {
          loop_ub = trueCount + 9 * ind;
          imnhSubs[loop_ub] = iv[loop_ub] + pixelSub[ind];
        }
      }

      trueCount = 0;
      partialTrueCount = 0;
      for (ind = 0; ind < 9; ind++) {
        isInside[ind] = true;
        loop_ub = 0;
        exitg1 = false;
        while ((!exitg1) && (loop_ub < 2)) {
          i = ind + 9 * loop_ub;
          if ((imnhSubs[i] < 1) || (imnhSubs[i] > np.ImageSize[loop_ub])) {
            isInside[ind] = false;
            exitg1 = true;
          } else {
            loop_ub++;
          }
        }

        if (isInside[ind]) {
          trueCount++;
          imnhInds_data[partialTrueCount] = imnhInds_[ind];
          partialTrueCount++;
        }
      }

      for (i = 0; i < trueCount; i++) {
        b_J_data[i] = J[imnhInds_data[i] - 1];
      }

      d_J_data.set((&b_J_data[0]), trueCount);
      u0 = d_maximum(d_J_data);
      if ((u0 < b_I[pInd - 1]) || rtIsNaN(b_I[pInd - 1])) {
        J[pInd - 1] = u0;
      } else {
        J[pInd - 1] = b_I[pInd - 1];
      }

      ind = 0;
      exitg1 = false;
      while ((!exitg1) && (ind <= trueCount - 1)) {
        if ((J[imnhInds_data[ind] - 1] < J[pInd - 1]) && (J[imnhInds_data[ind] -
             1] < b_I[imnhInds_data[ind] - 1])) {
          stackTop++;
          locationStack[stackTop] = pInd;
          exitg1 = true;
        } else {
          ind++;
        }
      }
    }
  }

  while (stackTop + 1 > 0) {
    pInd = locationStack[stackTop] - 1;
    stackTop--;
    for (ind = 0; ind < 9; ind++) {
      imnhInds_[ind] = (iv1[ind] + pInd) + 1;
    }

    if (np.ImageSize[0] == 0) {
      loop_ub = 0;
    } else {
      loop_ub = pInd - np.ImageSize[0] * div_s32(pInd, np.ImageSize[0]);
    }

    ind = pInd - loop_ub;
    if (np.ImageSize[0] == 0) {
      if (ind == 0) {
        partialTrueCount = 0;
      } else if (ind < 0) {
        partialTrueCount = MIN_int32_T;
      } else {
        partialTrueCount = MAX_int32_T;
      }
    } else if (np.ImageSize[0] == 1) {
      partialTrueCount = ind;
    } else {
      if (ind >= 0) {
        trueCount = ind;
      } else if (ind == MIN_int32_T) {
        trueCount = MAX_int32_T;
      } else {
        trueCount = -ind;
      }

      partialTrueCount = div_s32(trueCount, np.ImageSize[0]);
      trueCount -= partialTrueCount * np.ImageSize[0];
      if ((trueCount > 0) && (trueCount >= (np.ImageSize[0] >> 1) +
                              (np.ImageSize[0] & 1))) {
        partialTrueCount++;
      }

      if (ind < 0) {
        partialTrueCount = -partialTrueCount;
      }
    }

    d_pixelSub[1] = partialTrueCount + 1;
    d_pixelSub[0] = loop_ub + 1;
    for (ind = 0; ind < 2; ind++) {
      pixelSub[ind] = d_pixelSub[ind];
      for (trueCount = 0; trueCount < 9; trueCount++) {
        loop_ub = trueCount + 9 * ind;
        imnhSubs[loop_ub] = iv[loop_ub] + pixelSub[ind];
      }
    }

    trueCount = 0;
    partialTrueCount = 0;
    for (ind = 0; ind < 9; ind++) {
      isInside[ind] = true;
      loop_ub = 0;
      exitg1 = false;
      while ((!exitg1) && (loop_ub < 2)) {
        i = ind + 9 * loop_ub;
        if ((imnhSubs[i] < 1) || (imnhSubs[i] > np.ImageSize[loop_ub])) {
          isInside[ind] = false;
          exitg1 = true;
        } else {
          loop_ub++;
        }
      }

      if (isInside[ind]) {
        trueCount++;
        imnhInds_data[partialTrueCount] = imnhInds_[ind];
        partialTrueCount++;
      }
    }

    for (ind = 0; ind < trueCount; ind++) {
      if ((J[imnhInds_data[ind] - 1] < J[pInd]) && (J[imnhInds_data[ind] - 1] !=
           b_I[imnhInds_data[ind] - 1])) {
        if ((J[pInd] < b_I[imnhInds_data[ind] - 1]) || rtIsNaN
            (b_I[imnhInds_data[ind] - 1])) {
          J[imnhInds_data[ind] - 1] = J[pInd];
        } else {
          J[imnhInds_data[ind] - 1] = b_I[imnhInds_data[ind] - 1];
        }

        stackTop++;
        locationStack[stackTop] = imnhInds_data[ind];
      }
    }
  }
}

// End of code generation (imhmax.cpp)
