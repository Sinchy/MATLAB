//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  NeighborhoodProcessor.cpp
//
//  Code generation for function 'NeighborhoodProcessor'
//


// Include files
#include "NeighborhoodProcessor.h"
#include "BubbleCenterAndSizeByCircle_rtwutil.h"
#include "CircleIdentifier.h"
#include "chradii.h"
#include "rt_nonfinite.h"
#include <cfloat>
#include <cmath>
#include <cstring>

// Type Definitions
struct c_struct_T
{
  coder::array<bool, 2U> bw;
  double pixel;
  int ind;
  int nhInds[9];
  int imnhInds[9];
};

// Function Declarations
static double rt_remd_snf(double u0, double u1);

// Function Definitions
static double rt_remd_snf(double u0, double u1)
{
  double y;
  if (rtIsNaN(u0) || rtIsNaN(u1) || rtIsInf(u0)) {
    y = rtNaN;
  } else if (rtIsInf(u1)) {
    y = u0;
  } else {
    double b_u1;
    if (u1 < 0.0) {
      b_u1 = std::ceil(u1);
    } else {
      b_u1 = std::floor(u1);
    }

    if ((u1 != 0.0) && (u1 != b_u1)) {
      b_u1 = std::abs(u0 / u1);
      if (!(std::abs(b_u1 - std::floor(b_u1 + 0.5)) > DBL_EPSILON * b_u1)) {
        y = 0.0 * u0;
      } else {
        y = std::fmod(u0, u1);
      }
    } else {
      y = std::fmod(u0, u1);
    }
  }

  return y;
}

void c_images_internal_coder_Neighbo::computeParameters(const int imSize[2],
  const bool nhConn[9], int loffsets[9], int linds[9], int soffsets[18], double
  interiorStart[2], int interiorEnd[2])
{
  int nz;
  int k;
  int a[18];

  //  Process pixels with full neighborhood
  //  Process pixels with partial neighborhood
  //  Process pixels with full neighborhood
  //  Process pixels with partial neighborhood
  interiorStart[0] = 2.0;
  interiorEnd[0] = imSize[0] - 1;
  interiorStart[1] = 2.0;
  interiorEnd[1] = imSize[1] - 1;
  nz = nhConn[0];
  for (k = 0; k < 8; k++) {
    nz += nhConn[k + 1];
  }

  if (nz != 0) {
    int indx;
    indx = 0;
    for (int pind = 0; pind < 9; pind++) {
      if (nhConn[pind]) {
        nz = static_cast<int>(rt_remd_snf((static_cast<double>(pind) + 1.0) -
          1.0, 3.0));
        k = static_cast<int>((static_cast<double>((pind - nz) - 1) + 1.0) / 3.0);
        nz++;
        soffsets[indx] = nz;
        soffsets[indx + 9] = k + 1;
        linds[indx] = nz + k * 3;
        loffsets[indx] = nz + k * imSize[0];
        indx++;
      }
    }

    for (nz = 0; nz < 9; nz++) {
      loffsets[nz] = (loffsets[nz] - imSize[0]) - 2;
    }

    std::memcpy(&a[0], &soffsets[0], 18U * sizeof(int));
    for (k = 0; k < 2; k++) {
      for (indx = 0; indx < 9; indx++) {
        nz = indx + 9 * k;
        soffsets[nz] = a[nz] - 2;
      }
    }
  }
}

void c_images_internal_coder_Neighbo::process2D(const coder::array<double, 2U>
  &in, coder::array<bool, 2U> &out, const b_struct_T *fparams) const
{
  int firstIndRange[2];
  int i;
  int imageSize1;
  int imageNeighborLinearOffsets[9];
  int ub_loop;
  coder::array<bool, 1U> out_;
  c_struct_T fparamsAugmented;
  double imnh_data[81];
  signed char imnh_size[2];
  int imnhInds[9];
  int u1;
  int pind;
  int pixelSub[2];
  int a[18];
  int b_i;
  int i1;
  int secondIndRange[2];
  int b_firstInd;
  int i2;
  int c_i;
  int b_u1;
  int x;
  bool exitg1;
  bool isInside[9];
  int trueCount;
  int imnhSubs[18];
  int imnhInds_data[9];
  int b_pixelSub[2];
  double b_imnh_data[81];
  int i3;
  int b_trueCount;
  signed char tmp_data[9];
  int i4;
  int b_imnhInds_data[9];
  int c_pixelSub[2];
  int c_trueCount;
  signed char b_tmp_data[9];
  int c_imnhInds_data[9];
  int d_pixelSub[2];
  int d_trueCount;
  signed char c_tmp_data[9];
  int d_imnhInds_data[9];
  signed char d_tmp_data[9];
  firstIndRange[0] = static_cast<int>(this->InteriorStart[0]);
  firstIndRange[1] = this->InteriorEnd[0];
  for (i = 0; i < 9; i++) {
    imageNeighborLinearOffsets[i] = this->ImageNeighborLinearOffsets[i];
  }

  imageSize1 = this->ImageSize[0];
  i = static_cast<int>(this->InteriorStart[1]);
  ub_loop = this->InteriorEnd[1];

#pragma omp parallel for \
 num_threads(omp_get_max_threads()) \
 private(out_,fparamsAugmented,imnh_data,imnh_size,imnhInds,pind,b_i,i1,b_firstInd,c_i,exitg1)

  for (int secondInd = i; secondInd <= ub_loop; secondInd++) {
    out_.set_size(out.size(0));
    b_i = firstIndRange[0];
    i1 = firstIndRange[1];
    for (b_firstInd = b_i; b_firstInd <= i1; b_firstInd++) {
      pind = (secondInd - 1) * imageSize1 + b_firstInd;
      for (c_i = 0; c_i < 9; c_i++) {
        imnhInds[c_i] = imageNeighborLinearOffsets[c_i] + pind;
      }

      if (in.size(0) == 1) {
        imnh_size[0] = 1;
        imnh_size[1] = 9;
        for (c_i = 0; c_i < 9; c_i++) {
          imnh_data[c_i] = in[imnhInds[c_i] - 1];
        }
      } else {
        imnh_size[0] = 9;
        imnh_size[1] = 1;
        for (c_i = 0; c_i < 9; c_i++) {
          imnh_data[c_i] = in[imnhInds[c_i] - 1];
        }
      }

      fparamsAugmented.pixel = in[pind - 1];
      out_[b_firstInd - 1] = fparams->bw[pind - 1];
      if (fparams->bw[pind - 1]) {
        //  Pixel has not already been set as non-max
        pind = 0;
        exitg1 = false;
        while ((!exitg1) && (pind <= imnh_size[0] * imnh_size[1] - 1)) {
          if (imnh_data[pind] > fparamsAugmented.pixel) {
            //  Set pixel to zero if any neighbor is greater
            out_[b_firstInd - 1] = false;
            exitg1 = true;
          } else if ((imnh_data[pind] == fparamsAugmented.pixel) &&
                     (!fparams->bw[imnhInds[pind] - 1])) {
            //  Set pixel to zero if any equal neighbor is already set to zero
            out_[b_firstInd - 1] = false;
            exitg1 = true;
          } else {
            pind++;
          }
        }
      }
    }

    pind = out_.size(0);
    for (b_i = 0; b_i < pind; b_i++) {
      out[b_i + out.size(0) * (secondInd - 1)] = out_[b_i];
    }
  }

  if (this->ProcessBorder) {
    int firstDimExtents_tmp_idx_1;
    double secondDimExtents_idx_1;
    double padValue;
    int minval;
    int b_secondInd;
    int firstInd;
    int b_pind;
    int z;
    firstDimExtents_tmp_idx_1 = this->ImageSize[0];
    secondDimExtents_idx_1 = this->InteriorStart[1] - 1.0;
    padValue = this->PadValue;
    i = this->ImageSize[1];
    if (rtIsNaN(secondDimExtents_idx_1) || (secondDimExtents_idx_1 > i)) {
      minval = i;
    } else {
      minval = static_cast<int>(secondDimExtents_idx_1);
    }

    if (0 <= minval - 1) {
      u1 = this->ImageSize[0];
      if (firstDimExtents_tmp_idx_1 < u1) {
        u1 = firstDimExtents_tmp_idx_1;
      }

      if (1 <= u1) {
        std::memcpy(&a[0], &this->NeighborSubscriptOffsets[0], 18U * sizeof(int));
      }
    }

    for (b_secondInd = 0; b_secondInd < minval; b_secondInd++) {
      for (firstInd = 1; firstInd <= u1; firstInd++) {
        b_pind = (b_secondInd * this->ImageSize[0] + firstInd) - 1;
        for (i = 0; i < 9; i++) {
          imageNeighborLinearOffsets[i] = (this->ImageNeighborLinearOffsets[i] +
            b_pind) + 1;
        }

        secondIndRange[0] = this->ImageSize[0];
        if (secondIndRange[0] == 0) {
          imageSize1 = 0;
        } else {
          imageSize1 = b_pind - secondIndRange[0] * div_s32(b_pind,
            secondIndRange[0]);
        }

        ub_loop = b_pind - imageSize1;
        if (secondIndRange[0] == 0) {
          if (ub_loop == 0) {
            z = 0;
          } else if (ub_loop < 0) {
            z = MIN_int32_T;
          } else {
            z = MAX_int32_T;
          }
        } else if (secondIndRange[0] == 1) {
          z = ub_loop;
        } else if (secondIndRange[0] == -1) {
          z = -ub_loop;
        } else {
          if (ub_loop >= 0) {
            x = ub_loop;
          } else if (ub_loop == MIN_int32_T) {
            x = MAX_int32_T;
          } else {
            x = -ub_loop;
          }

          if (secondIndRange[0] >= 0) {
            i = secondIndRange[0];
          } else if (secondIndRange[0] == MIN_int32_T) {
            i = MAX_int32_T;
          } else {
            i = -secondIndRange[0];
          }

          z = div_s32(x, i);
          x -= z * i;
          if ((x > 0) && (x >= (i >> 1) + (i & 1))) {
            z++;
          }

          if ((ub_loop < 0) != (secondIndRange[0] < 0)) {
            z = -z;
          }
        }

        pixelSub[1] = z + 1;
        pixelSub[0] = imageSize1 + 1;
        for (i = 0; i < 2; i++) {
          secondIndRange[i] = pixelSub[i];
          for (ub_loop = 0; ub_loop < 9; ub_loop++) {
            imageSize1 = ub_loop + 9 * i;
            imnhSubs[imageSize1] = a[imageSize1] + secondIndRange[i];
          }
        }

        for (i = 0; i < 9; i++) {
          isInside[i] = true;
        }

        switch (static_cast<int>(this->Padding)) {
         case 1:
          trueCount = 0;
          ub_loop = 0;
          for (x = 0; x < 9; x++) {
            imageSize1 = 0;
            exitg1 = false;
            while ((!exitg1) && (imageSize1 < 2)) {
              i2 = x + 9 * imageSize1;
              if ((imnhSubs[i2] < 1) || (imnhSubs[i2] > this->
                   ImageSize[imageSize1])) {
                isInside[x] = false;
                exitg1 = true;
              } else {
                imageSize1++;
              }
            }

            if (isInside[x]) {
              trueCount++;
              imnhInds_data[ub_loop] = imageNeighborLinearOffsets[x];
              ub_loop++;
            }
          }
          break;

         case 2:
          trueCount = 9;
          for (x = 0; x < 9; x++) {
            imnhInds_data[x] = imageNeighborLinearOffsets[x];
            imageSize1 = 0;
            exitg1 = false;
            while ((!exitg1) && (imageSize1 < 2)) {
              i2 = x + 9 * imageSize1;
              if ((imnhSubs[i2] < 1) || (imnhSubs[i2] > this->
                   ImageSize[imageSize1])) {
                isInside[x] = false;
                imnhInds_data[x] = 1;
                exitg1 = true;
              } else {
                imageSize1++;
              }
            }
          }
          break;

         case 3:
          trueCount = 9;
          for (i2 = 0; i2 < 9; i2++) {
            imnhInds_data[i2] = imageNeighborLinearOffsets[i2];
          }

          for (x = 0; x < 9; x++) {
            i2 = imnhSubs[x];
            secondIndRange[0] = imnhSubs[x];
            if (imnhSubs[x] < 1) {
              isInside[x] = false;
              i2 = 1;
              secondIndRange[0] = 1;
            }

            if (i2 > this->ImageSize[0]) {
              isInside[x] = false;
              secondIndRange[0] = this->ImageSize[0];
            }

            i2 = imnhSubs[x + 9];
            secondIndRange[1] = i2;
            if (i2 < 1) {
              isInside[x] = false;
              i2 = 1;
              secondIndRange[1] = 1;
            }

            if (i2 > this->ImageSize[1]) {
              isInside[x] = false;
              secondIndRange[1] = this->ImageSize[1];
            }

            if (!isInside[x]) {
              imnhInds_data[x] = secondIndRange[0] + (secondIndRange[1] - 1) *
                this->ImageSize[0];
            }
          }
          break;

         case 4:
          trueCount = 9;
          for (i2 = 0; i2 < 9; i2++) {
            imnhInds_data[i2] = imageNeighborLinearOffsets[i2];
          }

          for (x = 0; x < 9; x++) {
            i2 = imnhSubs[x];
            secondIndRange[0] = imnhSubs[x];
            if (imnhSubs[x] < 1) {
              isInside[x] = false;
              i2 = imnhSubs[x] + (this->ImageSize[0] << 1);
              secondIndRange[0] = i2;
            }

            if (i2 > this->ImageSize[0]) {
              isInside[x] = false;
              i2 = ((this->ImageSize[0] << 1) - i2) + 1;
              secondIndRange[0] = i2;
            }

            i2 = imnhSubs[x + 9];
            secondIndRange[1] = i2;
            if (i2 < 1) {
              isInside[x] = false;
              i2 += this->ImageSize[1] << 1;
              secondIndRange[1] = i2;
            }

            if (i2 > this->ImageSize[1]) {
              isInside[x] = false;
              i2 = ((this->ImageSize[1] << 1) - i2) + 1;
              secondIndRange[1] = i2;
            }

            if (!isInside[x]) {
              imnhInds_data[x] = secondIndRange[0] + (secondIndRange[1] - 1) *
                this->ImageSize[0];
            }
          }
          break;
        }

        if (in.size(0) == 1) {
          x = 1;
          z = trueCount;
          for (i2 = 0; i2 < trueCount; i2++) {
            b_imnh_data[i2] = in[imnhInds_data[i2] - 1];
          }
        } else {
          x = trueCount;
          z = 1;
          for (i2 = 0; i2 < trueCount; i2++) {
            b_imnh_data[i2] = in[imnhInds_data[i2] - 1];
          }
        }

        if (this->Padding == 2.0) {
          imageSize1 = 0;
          ub_loop = 0;
          for (i = 0; i < 9; i++) {
            if (!isInside[i]) {
              imageSize1++;
              tmp_data[ub_loop] = static_cast<signed char>(i + 1);
              ub_loop++;
            }
          }

          imageSize1--;
          for (i2 = 0; i2 <= imageSize1; i2++) {
            b_imnh_data[tmp_data[i2] - 1] = padValue;
          }
        }

        secondDimExtents_idx_1 = in[b_pind];
        out[b_pind] = fparams->bw[b_pind];
        if (fparams->bw[b_pind]) {
          //  Pixel has not already been set as non-max
          imageSize1 = 0;
          exitg1 = false;
          while ((!exitg1) && (imageSize1 <= x * z - 1)) {
            if (b_imnh_data[imageSize1] > secondDimExtents_idx_1) {
              //  Set pixel to zero if any neighbor is greater
              out[b_pind] = false;
              exitg1 = true;
            } else if ((b_imnh_data[imageSize1] == secondDimExtents_idx_1) &&
                       (!fparams->bw[imnhInds_data[imageSize1] - 1])) {
              //  Set pixel to zero if any equal neighbor is already set to zero 
              out[b_pind] = false;
              exitg1 = true;
            } else {
              imageSize1++;
            }
          }
        }
      }
    }

    pixelSub[0] = this->InteriorEnd[1] + 1;
    pixelSub[1] = this->ImageSize[1];
    padValue = this->PadValue;
    if (pixelSub[0] < 1) {
      pixelSub[0] = 1;
    }

    u1 = this->ImageSize[1];
    if (pixelSub[1] >= u1) {
      pixelSub[1] = u1;
    }

    i2 = pixelSub[0];
    minval = pixelSub[1];
    if (pixelSub[0] <= pixelSub[1]) {
      b_u1 = this->ImageSize[0];
      if (firstDimExtents_tmp_idx_1 < b_u1) {
        b_u1 = firstDimExtents_tmp_idx_1;
      }

      if (1 <= b_u1) {
        std::memcpy(&a[0], &this->NeighborSubscriptOffsets[0], 18U * sizeof(int));
      }
    }

    for (b_secondInd = i2; b_secondInd <= minval; b_secondInd++) {
      for (firstInd = 1; firstInd <= b_u1; firstInd++) {
        b_pind = ((b_secondInd - 1) * this->ImageSize[0] + firstInd) - 1;
        for (i = 0; i < 9; i++) {
          imageNeighborLinearOffsets[i] = (this->ImageNeighborLinearOffsets[i] +
            b_pind) + 1;
        }

        secondIndRange[0] = this->ImageSize[0];
        if (secondIndRange[0] == 0) {
          imageSize1 = 0;
        } else {
          imageSize1 = b_pind - secondIndRange[0] * div_s32(b_pind,
            secondIndRange[0]);
        }

        ub_loop = b_pind - imageSize1;
        if (secondIndRange[0] == 0) {
          if (ub_loop == 0) {
            z = 0;
          } else if (ub_loop < 0) {
            z = MIN_int32_T;
          } else {
            z = MAX_int32_T;
          }
        } else if (secondIndRange[0] == 1) {
          z = ub_loop;
        } else if (secondIndRange[0] == -1) {
          z = -ub_loop;
        } else {
          if (ub_loop >= 0) {
            x = ub_loop;
          } else if (ub_loop == MIN_int32_T) {
            x = MAX_int32_T;
          } else {
            x = -ub_loop;
          }

          if (secondIndRange[0] >= 0) {
            i = secondIndRange[0];
          } else if (secondIndRange[0] == MIN_int32_T) {
            i = MAX_int32_T;
          } else {
            i = -secondIndRange[0];
          }

          z = div_s32(x, i);
          x -= z * i;
          if ((x > 0) && (x >= (i >> 1) + (i & 1))) {
            z++;
          }

          if ((ub_loop < 0) != (secondIndRange[0] < 0)) {
            z = -z;
          }
        }

        b_pixelSub[1] = z + 1;
        b_pixelSub[0] = imageSize1 + 1;
        for (i = 0; i < 2; i++) {
          secondIndRange[i] = b_pixelSub[i];
          for (ub_loop = 0; ub_loop < 9; ub_loop++) {
            imageSize1 = ub_loop + 9 * i;
            imnhSubs[imageSize1] = a[imageSize1] + secondIndRange[i];
          }
        }

        for (i = 0; i < 9; i++) {
          isInside[i] = true;
        }

        switch (static_cast<int>(this->Padding)) {
         case 1:
          b_trueCount = 0;
          ub_loop = 0;
          for (x = 0; x < 9; x++) {
            imageSize1 = 0;
            exitg1 = false;
            while ((!exitg1) && (imageSize1 < 2)) {
              i = x + 9 * imageSize1;
              if ((imnhSubs[i] < 1) || (imnhSubs[i] > this->ImageSize[imageSize1]))
              {
                isInside[x] = false;
                exitg1 = true;
              } else {
                imageSize1++;
              }
            }

            if (isInside[x]) {
              b_trueCount++;
              b_imnhInds_data[ub_loop] = imageNeighborLinearOffsets[x];
              ub_loop++;
            }
          }
          break;

         case 2:
          b_trueCount = 9;
          for (x = 0; x < 9; x++) {
            b_imnhInds_data[x] = imageNeighborLinearOffsets[x];
            imageSize1 = 0;
            exitg1 = false;
            while ((!exitg1) && (imageSize1 < 2)) {
              i = x + 9 * imageSize1;
              if ((imnhSubs[i] < 1) || (imnhSubs[i] > this->ImageSize[imageSize1]))
              {
                isInside[x] = false;
                b_imnhInds_data[x] = 1;
                exitg1 = true;
              } else {
                imageSize1++;
              }
            }
          }
          break;

         case 3:
          b_trueCount = 9;
          for (i = 0; i < 9; i++) {
            b_imnhInds_data[i] = imageNeighborLinearOffsets[i];
          }

          for (x = 0; x < 9; x++) {
            i = imnhSubs[x];
            secondIndRange[0] = imnhSubs[x];
            if (imnhSubs[x] < 1) {
              isInside[x] = false;
              i = 1;
              secondIndRange[0] = 1;
            }

            if (i > this->ImageSize[0]) {
              isInside[x] = false;
              secondIndRange[0] = this->ImageSize[0];
            }

            i = imnhSubs[x + 9];
            secondIndRange[1] = i;
            if (i < 1) {
              isInside[x] = false;
              i = 1;
              secondIndRange[1] = 1;
            }

            if (i > this->ImageSize[1]) {
              isInside[x] = false;
              secondIndRange[1] = this->ImageSize[1];
            }

            if (!isInside[x]) {
              b_imnhInds_data[x] = secondIndRange[0] + (secondIndRange[1] - 1) *
                this->ImageSize[0];
            }
          }
          break;

         case 4:
          b_trueCount = 9;
          for (i = 0; i < 9; i++) {
            b_imnhInds_data[i] = imageNeighborLinearOffsets[i];
          }

          for (x = 0; x < 9; x++) {
            i = imnhSubs[x];
            secondIndRange[0] = imnhSubs[x];
            if (imnhSubs[x] < 1) {
              isInside[x] = false;
              i = imnhSubs[x] + (this->ImageSize[0] << 1);
              secondIndRange[0] = i;
            }

            if (i > this->ImageSize[0]) {
              isInside[x] = false;
              i = ((this->ImageSize[0] << 1) - i) + 1;
              secondIndRange[0] = i;
            }

            i = imnhSubs[x + 9];
            secondIndRange[1] = i;
            if (i < 1) {
              isInside[x] = false;
              i += this->ImageSize[1] << 1;
              secondIndRange[1] = i;
            }

            if (i > this->ImageSize[1]) {
              isInside[x] = false;
              i = ((this->ImageSize[1] << 1) - i) + 1;
              secondIndRange[1] = i;
            }

            if (!isInside[x]) {
              b_imnhInds_data[x] = secondIndRange[0] + (secondIndRange[1] - 1) *
                this->ImageSize[0];
            }
          }
          break;
        }

        if (in.size(0) == 1) {
          x = 1;
          z = b_trueCount;
          for (i = 0; i < b_trueCount; i++) {
            b_imnh_data[i] = in[b_imnhInds_data[i] - 1];
          }
        } else {
          x = b_trueCount;
          z = 1;
          for (i = 0; i < b_trueCount; i++) {
            b_imnh_data[i] = in[b_imnhInds_data[i] - 1];
          }
        }

        if (this->Padding == 2.0) {
          trueCount = 0;
          ub_loop = 0;
          for (i = 0; i < 9; i++) {
            if (!isInside[i]) {
              trueCount++;
              b_tmp_data[ub_loop] = static_cast<signed char>(i + 1);
              ub_loop++;
            }
          }

          imageSize1 = trueCount - 1;
          for (i = 0; i <= imageSize1; i++) {
            b_imnh_data[b_tmp_data[i] - 1] = padValue;
          }
        }

        secondDimExtents_idx_1 = in[b_pind];
        out[b_pind] = fparams->bw[b_pind];
        if (fparams->bw[b_pind]) {
          //  Pixel has not already been set as non-max
          imageSize1 = 0;
          exitg1 = false;
          while ((!exitg1) && (imageSize1 <= x * z - 1)) {
            if (b_imnh_data[imageSize1] > secondDimExtents_idx_1) {
              //  Set pixel to zero if any neighbor is greater
              out[b_pind] = false;
              exitg1 = true;
            } else if ((b_imnh_data[imageSize1] == secondDimExtents_idx_1) &&
                       (!fparams->bw[b_imnhInds_data[imageSize1] - 1])) {
              //  Set pixel to zero if any equal neighbor is already set to zero 
              out[b_pind] = false;
              exitg1 = true;
            } else {
              imageSize1++;
            }
          }
        }
      }
    }

    secondDimExtents_idx_1 = this->InteriorStart[0] - 1.0;
    padValue = this->PadValue;
    i = this->ImageSize[0];
    if (rtIsNaN(secondDimExtents_idx_1) || (secondDimExtents_idx_1 > i)) {
      minval = i;
    } else {
      minval = static_cast<int>(secondDimExtents_idx_1);
    }

    imageSize1 = this->ImageSize[1];
    u1 = this->ImageSize[1];
    if (imageSize1 < u1) {
      u1 = imageSize1;
    }

    if ((1 <= u1) && (0 <= minval - 1)) {
      std::memcpy(&a[0], &this->NeighborSubscriptOffsets[0], 18U * sizeof(int));
    }

    for (b_secondInd = 1; b_secondInd <= u1; b_secondInd++) {
      for (firstInd = 0; firstInd < minval; firstInd++) {
        b_pind = (b_secondInd - 1) * this->ImageSize[0] + firstInd;
        for (i = 0; i < 9; i++) {
          imageNeighborLinearOffsets[i] = (this->ImageNeighborLinearOffsets[i] +
            b_pind) + 1;
        }

        secondIndRange[0] = this->ImageSize[0];
        if (secondIndRange[0] == 0) {
          imageSize1 = 0;
        } else {
          imageSize1 = b_pind - secondIndRange[0] * div_s32(b_pind,
            secondIndRange[0]);
        }

        ub_loop = b_pind - imageSize1;
        if (secondIndRange[0] == 0) {
          if (ub_loop == 0) {
            z = 0;
          } else if (ub_loop < 0) {
            z = MIN_int32_T;
          } else {
            z = MAX_int32_T;
          }
        } else if (secondIndRange[0] == 1) {
          z = ub_loop;
        } else if (secondIndRange[0] == -1) {
          z = -ub_loop;
        } else {
          if (ub_loop >= 0) {
            x = ub_loop;
          } else if (ub_loop == MIN_int32_T) {
            x = MAX_int32_T;
          } else {
            x = -ub_loop;
          }

          if (secondIndRange[0] >= 0) {
            i = secondIndRange[0];
          } else if (secondIndRange[0] == MIN_int32_T) {
            i = MAX_int32_T;
          } else {
            i = -secondIndRange[0];
          }

          z = div_s32(x, i);
          x -= z * i;
          if ((x > 0) && (x >= (i >> 1) + (i & 1))) {
            z++;
          }

          if ((ub_loop < 0) != (secondIndRange[0] < 0)) {
            z = -z;
          }
        }

        c_pixelSub[1] = z + 1;
        c_pixelSub[0] = imageSize1 + 1;
        for (i = 0; i < 2; i++) {
          secondIndRange[i] = c_pixelSub[i];
          for (ub_loop = 0; ub_loop < 9; ub_loop++) {
            imageSize1 = ub_loop + 9 * i;
            imnhSubs[imageSize1] = a[imageSize1] + secondIndRange[i];
          }
        }

        for (i = 0; i < 9; i++) {
          isInside[i] = true;
        }

        switch (static_cast<int>(this->Padding)) {
         case 1:
          c_trueCount = 0;
          ub_loop = 0;
          for (x = 0; x < 9; x++) {
            imageSize1 = 0;
            exitg1 = false;
            while ((!exitg1) && (imageSize1 < 2)) {
              i2 = x + 9 * imageSize1;
              if ((imnhSubs[i2] < 1) || (imnhSubs[i2] > this->
                   ImageSize[imageSize1])) {
                isInside[x] = false;
                exitg1 = true;
              } else {
                imageSize1++;
              }
            }

            if (isInside[x]) {
              c_trueCount++;
              c_imnhInds_data[ub_loop] = imageNeighborLinearOffsets[x];
              ub_loop++;
            }
          }
          break;

         case 2:
          c_trueCount = 9;
          for (x = 0; x < 9; x++) {
            c_imnhInds_data[x] = imageNeighborLinearOffsets[x];
            imageSize1 = 0;
            exitg1 = false;
            while ((!exitg1) && (imageSize1 < 2)) {
              i2 = x + 9 * imageSize1;
              if ((imnhSubs[i2] < 1) || (imnhSubs[i2] > this->
                   ImageSize[imageSize1])) {
                isInside[x] = false;
                c_imnhInds_data[x] = 1;
                exitg1 = true;
              } else {
                imageSize1++;
              }
            }
          }
          break;

         case 3:
          c_trueCount = 9;
          for (i2 = 0; i2 < 9; i2++) {
            c_imnhInds_data[i2] = imageNeighborLinearOffsets[i2];
          }

          for (x = 0; x < 9; x++) {
            i2 = imnhSubs[x];
            secondIndRange[0] = imnhSubs[x];
            if (imnhSubs[x] < 1) {
              isInside[x] = false;
              i2 = 1;
              secondIndRange[0] = 1;
            }

            if (i2 > this->ImageSize[0]) {
              isInside[x] = false;
              secondIndRange[0] = this->ImageSize[0];
            }

            i2 = imnhSubs[x + 9];
            secondIndRange[1] = i2;
            if (i2 < 1) {
              isInside[x] = false;
              i2 = 1;
              secondIndRange[1] = 1;
            }

            if (i2 > this->ImageSize[1]) {
              isInside[x] = false;
              secondIndRange[1] = this->ImageSize[1];
            }

            if (!isInside[x]) {
              c_imnhInds_data[x] = secondIndRange[0] + (secondIndRange[1] - 1) *
                this->ImageSize[0];
            }
          }
          break;

         case 4:
          c_trueCount = 9;
          for (i2 = 0; i2 < 9; i2++) {
            c_imnhInds_data[i2] = imageNeighborLinearOffsets[i2];
          }

          for (x = 0; x < 9; x++) {
            i2 = imnhSubs[x];
            secondIndRange[0] = imnhSubs[x];
            if (imnhSubs[x] < 1) {
              isInside[x] = false;
              i2 = imnhSubs[x] + (this->ImageSize[0] << 1);
              secondIndRange[0] = i2;
            }

            if (i2 > this->ImageSize[0]) {
              isInside[x] = false;
              i2 = ((this->ImageSize[0] << 1) - i2) + 1;
              secondIndRange[0] = i2;
            }

            i2 = imnhSubs[x + 9];
            secondIndRange[1] = i2;
            if (i2 < 1) {
              isInside[x] = false;
              i2 += this->ImageSize[1] << 1;
              secondIndRange[1] = i2;
            }

            if (i2 > this->ImageSize[1]) {
              isInside[x] = false;
              i2 = ((this->ImageSize[1] << 1) - i2) + 1;
              secondIndRange[1] = i2;
            }

            if (!isInside[x]) {
              c_imnhInds_data[x] = secondIndRange[0] + (secondIndRange[1] - 1) *
                this->ImageSize[0];
            }
          }
          break;
        }

        if (in.size(0) == 1) {
          x = 1;
          z = c_trueCount;
          for (i2 = 0; i2 < c_trueCount; i2++) {
            b_imnh_data[i2] = in[c_imnhInds_data[i2] - 1];
          }
        } else {
          x = c_trueCount;
          z = 1;
          for (i2 = 0; i2 < c_trueCount; i2++) {
            b_imnh_data[i2] = in[c_imnhInds_data[i2] - 1];
          }
        }

        if (this->Padding == 2.0) {
          trueCount = 0;
          ub_loop = 0;
          for (i = 0; i < 9; i++) {
            if (!isInside[i]) {
              trueCount++;
              c_tmp_data[ub_loop] = static_cast<signed char>(i + 1);
              ub_loop++;
            }
          }

          imageSize1 = trueCount - 1;
          for (i2 = 0; i2 <= imageSize1; i2++) {
            b_imnh_data[c_tmp_data[i2] - 1] = padValue;
          }
        }

        secondDimExtents_idx_1 = in[b_pind];
        out[b_pind] = fparams->bw[b_pind];
        if (fparams->bw[b_pind]) {
          //  Pixel has not already been set as non-max
          imageSize1 = 0;
          exitg1 = false;
          while ((!exitg1) && (imageSize1 <= x * z - 1)) {
            if (b_imnh_data[imageSize1] > secondDimExtents_idx_1) {
              //  Set pixel to zero if any neighbor is greater
              out[b_pind] = false;
              exitg1 = true;
            } else if ((b_imnh_data[imageSize1] == secondDimExtents_idx_1) &&
                       (!fparams->bw[c_imnhInds_data[imageSize1] - 1])) {
              //  Set pixel to zero if any equal neighbor is already set to zero 
              out[b_pind] = false;
              exitg1 = true;
            } else {
              imageSize1++;
            }
          }
        }
      }
    }

    imageSize1 = this->InteriorEnd[0] + 1;
    i = this->ImageSize[0];
    padValue = this->PadValue;
    if (imageSize1 < 1) {
      imageSize1 = 1;
    }

    b_u1 = this->ImageSize[0];
    if (i >= b_u1) {
      i = b_u1;
    }

    if (1 <= u1) {
      i3 = imageSize1;
      i4 = i;
      if (imageSize1 <= i) {
        std::memcpy(&a[0], &this->NeighborSubscriptOffsets[0], 18U * sizeof(int));
      }
    }

    for (b_secondInd = 1; b_secondInd <= u1; b_secondInd++) {
      for (firstInd = i3; firstInd <= i4; firstInd++) {
        b_pind = ((b_secondInd - 1) * this->ImageSize[0] + firstInd) - 1;
        for (i = 0; i < 9; i++) {
          imageNeighborLinearOffsets[i] = (this->ImageNeighborLinearOffsets[i] +
            b_pind) + 1;
        }

        secondIndRange[0] = this->ImageSize[0];
        if (secondIndRange[0] == 0) {
          imageSize1 = 0;
        } else {
          imageSize1 = b_pind - secondIndRange[0] * div_s32(b_pind,
            secondIndRange[0]);
        }

        ub_loop = b_pind - imageSize1;
        if (secondIndRange[0] == 0) {
          if (ub_loop == 0) {
            z = 0;
          } else if (ub_loop < 0) {
            z = MIN_int32_T;
          } else {
            z = MAX_int32_T;
          }
        } else if (secondIndRange[0] == 1) {
          z = ub_loop;
        } else if (secondIndRange[0] == -1) {
          z = -ub_loop;
        } else {
          if (ub_loop >= 0) {
            x = ub_loop;
          } else if (ub_loop == MIN_int32_T) {
            x = MAX_int32_T;
          } else {
            x = -ub_loop;
          }

          if (secondIndRange[0] >= 0) {
            i = secondIndRange[0];
          } else if (secondIndRange[0] == MIN_int32_T) {
            i = MAX_int32_T;
          } else {
            i = -secondIndRange[0];
          }

          z = div_s32(x, i);
          x -= z * i;
          if ((x > 0) && (x >= (i >> 1) + (i & 1))) {
            z++;
          }

          if ((ub_loop < 0) != (secondIndRange[0] < 0)) {
            z = -z;
          }
        }

        d_pixelSub[1] = z + 1;
        d_pixelSub[0] = imageSize1 + 1;
        for (i = 0; i < 2; i++) {
          secondIndRange[i] = d_pixelSub[i];
          for (ub_loop = 0; ub_loop < 9; ub_loop++) {
            imageSize1 = ub_loop + 9 * i;
            imnhSubs[imageSize1] = a[imageSize1] + secondIndRange[i];
          }
        }

        for (i = 0; i < 9; i++) {
          isInside[i] = true;
        }

        switch (static_cast<int>(this->Padding)) {
         case 1:
          d_trueCount = 0;
          ub_loop = 0;
          for (x = 0; x < 9; x++) {
            imageSize1 = 0;
            exitg1 = false;
            while ((!exitg1) && (imageSize1 < 2)) {
              i2 = x + 9 * imageSize1;
              if ((imnhSubs[i2] < 1) || (imnhSubs[i2] > this->
                   ImageSize[imageSize1])) {
                isInside[x] = false;
                exitg1 = true;
              } else {
                imageSize1++;
              }
            }

            if (isInside[x]) {
              d_trueCount++;
              d_imnhInds_data[ub_loop] = imageNeighborLinearOffsets[x];
              ub_loop++;
            }
          }
          break;

         case 2:
          d_trueCount = 9;
          for (x = 0; x < 9; x++) {
            d_imnhInds_data[x] = imageNeighborLinearOffsets[x];
            imageSize1 = 0;
            exitg1 = false;
            while ((!exitg1) && (imageSize1 < 2)) {
              i2 = x + 9 * imageSize1;
              if ((imnhSubs[i2] < 1) || (imnhSubs[i2] > this->
                   ImageSize[imageSize1])) {
                isInside[x] = false;
                d_imnhInds_data[x] = 1;
                exitg1 = true;
              } else {
                imageSize1++;
              }
            }
          }
          break;

         case 3:
          d_trueCount = 9;
          for (i2 = 0; i2 < 9; i2++) {
            d_imnhInds_data[i2] = imageNeighborLinearOffsets[i2];
          }

          for (x = 0; x < 9; x++) {
            i2 = imnhSubs[x];
            secondIndRange[0] = imnhSubs[x];
            if (imnhSubs[x] < 1) {
              isInside[x] = false;
              i2 = 1;
              secondIndRange[0] = 1;
            }

            if (i2 > this->ImageSize[0]) {
              isInside[x] = false;
              secondIndRange[0] = this->ImageSize[0];
            }

            i2 = imnhSubs[x + 9];
            secondIndRange[1] = i2;
            if (i2 < 1) {
              isInside[x] = false;
              i2 = 1;
              secondIndRange[1] = 1;
            }

            if (i2 > this->ImageSize[1]) {
              isInside[x] = false;
              secondIndRange[1] = this->ImageSize[1];
            }

            if (!isInside[x]) {
              d_imnhInds_data[x] = secondIndRange[0] + (secondIndRange[1] - 1) *
                this->ImageSize[0];
            }
          }
          break;

         case 4:
          d_trueCount = 9;
          for (i2 = 0; i2 < 9; i2++) {
            d_imnhInds_data[i2] = imageNeighborLinearOffsets[i2];
          }

          for (x = 0; x < 9; x++) {
            i2 = imnhSubs[x];
            secondIndRange[0] = imnhSubs[x];
            if (imnhSubs[x] < 1) {
              isInside[x] = false;
              i2 = imnhSubs[x] + (this->ImageSize[0] << 1);
              secondIndRange[0] = i2;
            }

            if (i2 > this->ImageSize[0]) {
              isInside[x] = false;
              i2 = ((this->ImageSize[0] << 1) - i2) + 1;
              secondIndRange[0] = i2;
            }

            i2 = imnhSubs[x + 9];
            secondIndRange[1] = i2;
            if (i2 < 1) {
              isInside[x] = false;
              i2 += this->ImageSize[1] << 1;
              secondIndRange[1] = i2;
            }

            if (i2 > this->ImageSize[1]) {
              isInside[x] = false;
              i2 = ((this->ImageSize[1] << 1) - i2) + 1;
              secondIndRange[1] = i2;
            }

            if (!isInside[x]) {
              d_imnhInds_data[x] = secondIndRange[0] + (secondIndRange[1] - 1) *
                this->ImageSize[0];
            }
          }
          break;
        }

        if (in.size(0) == 1) {
          x = 1;
          z = d_trueCount;
          for (i2 = 0; i2 < d_trueCount; i2++) {
            b_imnh_data[i2] = in[d_imnhInds_data[i2] - 1];
          }
        } else {
          x = d_trueCount;
          z = 1;
          for (i2 = 0; i2 < d_trueCount; i2++) {
            b_imnh_data[i2] = in[d_imnhInds_data[i2] - 1];
          }
        }

        if (this->Padding == 2.0) {
          trueCount = 0;
          ub_loop = 0;
          for (i = 0; i < 9; i++) {
            if (!isInside[i]) {
              trueCount++;
              d_tmp_data[ub_loop] = static_cast<signed char>(i + 1);
              ub_loop++;
            }
          }

          imageSize1 = trueCount - 1;
          for (i2 = 0; i2 <= imageSize1; i2++) {
            b_imnh_data[d_tmp_data[i2] - 1] = padValue;
          }
        }

        secondDimExtents_idx_1 = in[b_pind];
        out[b_pind] = fparams->bw[b_pind];
        if (fparams->bw[b_pind]) {
          //  Pixel has not already been set as non-max
          imageSize1 = 0;
          exitg1 = false;
          while ((!exitg1) && (imageSize1 <= x * z - 1)) {
            if (b_imnh_data[imageSize1] > secondDimExtents_idx_1) {
              //  Set pixel to zero if any neighbor is greater
              out[b_pind] = false;
              exitg1 = true;
            } else if ((b_imnh_data[imageSize1] == secondDimExtents_idx_1) &&
                       (!fparams->bw[d_imnhInds_data[imageSize1] - 1])) {
              //  Set pixel to zero if any equal neighbor is already set to zero 
              out[b_pind] = false;
              exitg1 = true;
            } else {
              imageSize1++;
            }
          }
        }
      }
    }
  }
}

// End of code generation (NeighborhoodProcessor.cpp)
