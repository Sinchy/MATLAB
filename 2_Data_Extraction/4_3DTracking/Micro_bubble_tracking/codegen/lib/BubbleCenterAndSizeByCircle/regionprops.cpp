//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  regionprops.cpp
//
//  Code generation for function 'regionprops'
//


// Include files
#include "regionprops.h"
#include "BubbleCenterAndSizeByCircle_rtwutil.h"
#include "CircleIdentifier.h"
#include "NeighborhoodProcessor.h"
#include "bwconncomp.h"
#include "chradii.h"
#include "rt_nonfinite.h"
#include <cstring>

// Type Definitions
struct emxArray_boolean_T_0x0
{
  int size[2];
};

struct emxArray_real_T_1x0
{
  int size[2];
};

struct d_struct_T
{
  double Area;
  double Centroid[2];
  double BoundingBox[4];
  double MajorAxisLength;
  double MinorAxisLength;
  double Eccentricity;
  double Orientation;
  emxArray_boolean_T_0x0 Image;
  emxArray_boolean_T_0x0 FilledImage;
  double FilledArea;
  double EulerNumber;
  double Extrema[16];
  double EquivDiameter;
  double Extent;
  coder::array<double, 1U> PixelIdxList;
  coder::array<double, 2U> PixelList;
  double Perimeter;
  double Circularity;
  coder::array<double, 1U> PixelValues;
  double WeightedCentroid[2];
  double MeanIntensity;
  double MinIntensity;
  double MaxIntensity;
  emxArray_real_T_1x0 SubarrayIdx;
  double SubarrayIdxLengths[2];
};

// Function Definitions
void regionprops(const coder::array<bool, 2U> &varargin_1, const coder::array<
                 double, 2U> &varargin_2, coder::array<struct_T, 1U> &outstats)
{
  double sumIntensity;
  double wc[2];
  double CC_NumObjects;
  coder::array<double, 1U> CC_RegionIndices;
  coder::array<int, 1U> regionLengths;
  struct_T statsOneObj;
  int loop_ub;
  int i;
  d_struct_T b_statsOneObj;
  coder::array<d_struct_T, 1U> stats;
  int k;
  coder::array<int, 1U> idxCount;
  int vlen;
  int i1;
  bwconncomp(varargin_1, &sumIntensity, wc, &CC_NumObjects, CC_RegionIndices,
             regionLengths);
  statsOneObj.WeightedCentroid[0] = 0.0;
  statsOneObj.WeightedCentroid[1] = 0.0;
  loop_ub = static_cast<int>(CC_NumObjects);
  outstats.set_size(loop_ub);
  for (i = 0; i < loop_ub; i++) {
    outstats[i] = statsOneObj;
  }

  b_statsOneObj.Area = 0.0;
  b_statsOneObj.Centroid[0] = 0.0;
  b_statsOneObj.Centroid[1] = 0.0;
  b_statsOneObj.BoundingBox[0] = 0.0;
  b_statsOneObj.BoundingBox[1] = 0.0;
  b_statsOneObj.BoundingBox[2] = 0.0;
  b_statsOneObj.BoundingBox[3] = 0.0;
  b_statsOneObj.MajorAxisLength = 0.0;
  b_statsOneObj.MinorAxisLength = 0.0;
  b_statsOneObj.Eccentricity = 0.0;
  b_statsOneObj.Orientation = 0.0;
  b_statsOneObj.Image.size[0] = 0;
  b_statsOneObj.Image.size[1] = 0;
  b_statsOneObj.FilledImage.size[0] = 0;
  b_statsOneObj.FilledImage.size[1] = 0;
  b_statsOneObj.FilledArea = 0.0;
  b_statsOneObj.EulerNumber = 0.0;
  std::memset(&b_statsOneObj.Extrema[0], 0, 16U * sizeof(double));
  b_statsOneObj.EquivDiameter = 0.0;
  b_statsOneObj.Extent = 0.0;
  b_statsOneObj.PixelIdxList.set_size(0);
  b_statsOneObj.PixelList.set_size(0, 2);
  b_statsOneObj.Perimeter = 0.0;
  b_statsOneObj.Circularity = 0.0;
  b_statsOneObj.PixelValues.set_size(0);
  b_statsOneObj.MeanIntensity = 0.0;
  b_statsOneObj.MinIntensity = 0.0;
  b_statsOneObj.MaxIntensity = 0.0;
  b_statsOneObj.SubarrayIdx.size[0] = 1;
  b_statsOneObj.SubarrayIdx.size[1] = 0;
  b_statsOneObj.WeightedCentroid[0] = 0.0;
  b_statsOneObj.SubarrayIdxLengths[0] = 0.0;
  b_statsOneObj.WeightedCentroid[1] = 0.0;
  b_statsOneObj.SubarrayIdxLengths[1] = 0.0;
  stats.set_size(loop_ub);
  for (i = 0; i < loop_ub; i++) {
    stats[i] = b_statsOneObj;
  }

  if (CC_NumObjects != 0.0) {
    if ((regionLengths.size(0) != 1) && (regionLengths.size(0) != 0) &&
        (regionLengths.size(0) != 1)) {
      i = regionLengths.size(0);
      for (k = 0; k <= i - 2; k++) {
        regionLengths[k + 1] = regionLengths[k] + regionLengths[k + 1];
      }
    }

    idxCount.set_size((regionLengths.size(0) + 1));
    idxCount[0] = 0;
    vlen = regionLengths.size(0);
    for (i = 0; i < vlen; i++) {
      idxCount[i + 1] = regionLengths[i];
    }

    for (k = 0; k < loop_ub; k++) {
      i = idxCount[k + 1];
      if (idxCount[k] + 1 > i) {
        i1 = 0;
        i = 0;
      } else {
        i1 = idxCount[k];
      }

      vlen = i - i1;
      stats[k].PixelIdxList.set_size(vlen);
      for (i = 0; i < vlen; i++) {
        stats[k].PixelIdxList[i] = CC_RegionIndices[i1 + i];
      }
    }
  }

  i = stats.size(0);
  for (k = 0; k < i; k++) {
    loop_ub = stats[k].PixelIdxList.size(0);
    if (stats[k].PixelIdxList.size(0) != 0) {
      regionLengths.set_size(stats[k].PixelIdxList.size(0));
      for (i1 = 0; i1 < loop_ub; i1++) {
        regionLengths[i1] = static_cast<int>(stats[k].PixelIdxList[i1]) - 1;
      }

      idxCount.set_size(regionLengths.size(0));
      loop_ub = regionLengths.size(0);
      for (i1 = 0; i1 < loop_ub; i1++) {
        idxCount[i1] = div_s32(regionLengths[i1], static_cast<int>(wc[0]));
      }

      loop_ub = regionLengths.size(0);
      for (i1 = 0; i1 < loop_ub; i1++) {
        regionLengths[i1] = regionLengths[i1] - idxCount[i1] * static_cast<int>
          (wc[0]);
      }

      stats[k].PixelList.set_size(idxCount.size(0), 2);
      loop_ub = idxCount.size(0);
      for (i1 = 0; i1 < loop_ub; i1++) {
        stats[k].PixelList[i1] = idxCount[i1] + 1;
      }

      loop_ub = regionLengths.size(0);
      for (i1 = 0; i1 < loop_ub; i1++) {
        stats[k].PixelList[i1 + stats[k].PixelList.size(0)] = regionLengths[i1]
          + 1;
      }
    } else {
      stats[k].PixelList.set_size(0, 2);
    }
  }

  i = stats.size(0);
  if (0 <= stats.size(0) - 1) {
    wc[0] = varargin_2.size(0);
  }

  for (k = 0; k < i; k++) {
    loop_ub = stats[k].PixelIdxList.size(0);
    stats[k].PixelValues.set_size(stats[k].PixelIdxList.size(0));
    regionLengths.set_size(stats[k].PixelIdxList.size(0));
    for (i1 = 0; i1 < loop_ub; i1++) {
      regionLengths[i1] = static_cast<int>(stats[k].PixelIdxList[i1]) - 1;
    }

    idxCount.set_size(regionLengths.size(0));
    loop_ub = regionLengths.size(0);
    for (i1 = 0; i1 < loop_ub; i1++) {
      idxCount[i1] = div_s32(regionLengths[i1], static_cast<int>(static_cast<
        unsigned int>(wc[0])));
    }

    loop_ub = regionLengths.size(0);
    for (i1 = 0; i1 < loop_ub; i1++) {
      regionLengths[i1] = regionLengths[i1] - idxCount[i1] * static_cast<int>(
        static_cast<unsigned int>(wc[0]));
    }

    CC_RegionIndices.set_size(regionLengths.size(0));
    loop_ub = regionLengths.size(0);
    for (i1 = 0; i1 < loop_ub; i1++) {
      CC_RegionIndices[i1] = regionLengths[i1] + 1;
    }

    loop_ub = idxCount.size(0);
    for (i1 = 0; i1 < loop_ub; i1++) {
      idxCount[i1] = idxCount[i1] + 1;
    }

    i1 = stats[k].PixelValues.size(0);
    for (vlen = 0; vlen < i1; vlen++) {
      stats[k].PixelValues[vlen] = varargin_2[(static_cast<int>
        (CC_RegionIndices[vlen]) + varargin_2.size(0) * (idxCount[vlen] - 1)) -
        1];
    }
  }

  i = stats.size(0);
  for (k = 0; k < i; k++) {
    int b_k;
    i1 = stats[k].PixelValues.size(0);
    if (stats[k].PixelValues.size(0) == 0) {
      sumIntensity = 0.0;
    } else {
      sumIntensity = stats[k].PixelValues[0];
      for (b_k = 2; b_k <= i1; b_k++) {
        sumIntensity += stats[k].PixelValues[b_k - 1];
      }
    }

    loop_ub = stats[k].PixelList.size(0);
    CC_RegionIndices.set_size(stats[k].PixelList.size(0));
    for (i1 = 0; i1 < loop_ub; i1++) {
      CC_RegionIndices[i1] = stats[k].PixelList[i1] * stats[k].PixelValues[i1];
    }

    vlen = CC_RegionIndices.size(0);
    if (CC_RegionIndices.size(0) == 0) {
      CC_NumObjects = 0.0;
    } else {
      CC_NumObjects = CC_RegionIndices[0];
      for (b_k = 2; b_k <= vlen; b_k++) {
        CC_NumObjects += CC_RegionIndices[b_k - 1];
      }
    }

    wc[0] = CC_NumObjects / sumIntensity;
    CC_RegionIndices.set_size(stats[k].PixelList.size(0));
    for (i1 = 0; i1 < loop_ub; i1++) {
      CC_RegionIndices[i1] = stats[k].PixelList[i1 + stats[k].PixelList.size(0)]
        * stats[k].PixelValues[i1];
    }

    vlen = CC_RegionIndices.size(0);
    if (CC_RegionIndices.size(0) == 0) {
      CC_NumObjects = 0.0;
    } else {
      CC_NumObjects = CC_RegionIndices[0];
      for (b_k = 2; b_k <= vlen; b_k++) {
        CC_NumObjects += CC_RegionIndices[b_k - 1];
      }
    }

    stats[k].WeightedCentroid[0] = wc[0];
    stats[k].WeightedCentroid[1] = CC_NumObjects / sumIntensity;
  }

  i = stats.size(0);
  for (k = 0; k < i; k++) {
    outstats[k].WeightedCentroid[0] = stats[k].WeightedCentroid[0];
    outstats[k].WeightedCentroid[1] = stats[k].WeightedCentroid[1];
  }
}

// End of code generation (regionprops.cpp)
