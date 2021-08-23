//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  BubbleIdentifier.cpp
//
//  Code generation for function 'BubbleIdentifier'
//


// Include files
#include "BubbleIdentifier.h"
#include "bwconncomp.h"
#include "regionprops.h"
#include <cstring>

// Function Definitions
void BubbleIdentifier::BubbleCenterAndSize(const coder::array<bool, 2U> &img,
  coder::array<struct0_T, 1U> &s)
{
  double expl_temp;
  double CC_ImageSize[2];
  double CC_NumObjects;
  coder::array<double, 1U> CC_RegionIndices;
  coder::array<int, 1U> regionLengths;
  struct0_T b_s;
  int loop_ub;
  int i;
  struct_T statsAlreadyComputed;
  b_struct_T statsOneObj;
  coder::array<b_struct_T, 1U> stats;
  coder::array<int, 1U> idxCount;
  int k;
  bwconncomp(img, &expl_temp, CC_ImageSize, &CC_NumObjects, CC_RegionIndices,
             regionLengths);
  b_s.Centroid[0] = 0.0;
  b_s.Centroid[1] = 0.0;
  b_s.MajorAxisLength = 0.0;
  b_s.MinorAxisLength = 0.0;
  loop_ub = static_cast<int>(CC_NumObjects);
  s.set_size(loop_ub);
  for (i = 0; i < loop_ub; i++) {
    s[i] = b_s;
  }

  statsAlreadyComputed.Area = false;
  statsOneObj.Area = 0.0;
  statsAlreadyComputed.Centroid = false;
  statsOneObj.Centroid[0] = 0.0;
  statsOneObj.Centroid[1] = 0.0;
  statsAlreadyComputed.BoundingBox = false;
  statsOneObj.BoundingBox[0] = 0.0;
  statsOneObj.BoundingBox[1] = 0.0;
  statsOneObj.BoundingBox[2] = 0.0;
  statsOneObj.BoundingBox[3] = 0.0;
  statsAlreadyComputed.MajorAxisLength = false;
  statsOneObj.MajorAxisLength = 0.0;
  statsAlreadyComputed.MinorAxisLength = false;
  statsOneObj.MinorAxisLength = 0.0;
  statsAlreadyComputed.Eccentricity = false;
  statsOneObj.Eccentricity = 0.0;
  statsAlreadyComputed.Orientation = false;
  statsOneObj.Orientation = 0.0;
  statsAlreadyComputed.Image = false;
  statsOneObj.Image.set_size(0, 0);
  statsAlreadyComputed.FilledImage = false;
  statsOneObj.FilledImage.set_size(0, 0);
  statsAlreadyComputed.FilledArea = false;
  statsOneObj.FilledArea = 0.0;
  statsAlreadyComputed.EulerNumber = false;
  statsOneObj.EulerNumber = 0.0;
  statsAlreadyComputed.Extrema = false;
  std::memset(&statsOneObj.Extrema[0], 0, 16U * sizeof(double));
  statsAlreadyComputed.EquivDiameter = false;
  statsOneObj.EquivDiameter = 0.0;
  statsAlreadyComputed.Extent = false;
  statsOneObj.Extent = 0.0;
  statsOneObj.PixelIdxList.set_size(0);
  statsAlreadyComputed.PixelList = false;
  statsOneObj.PixelList.set_size(0, 2);
  statsAlreadyComputed.Perimeter = false;
  statsOneObj.Perimeter = 0.0;
  statsAlreadyComputed.Circularity = false;
  statsOneObj.Circularity = 0.0;
  statsAlreadyComputed.PixelValues = false;
  statsOneObj.PixelValues.set_size(0);
  statsAlreadyComputed.WeightedCentroid = false;
  statsAlreadyComputed.MeanIntensity = false;
  statsOneObj.MeanIntensity = 0.0;
  statsAlreadyComputed.MinIntensity = false;
  statsOneObj.MinIntensity = 0.0;
  statsAlreadyComputed.MaxIntensity = false;
  statsOneObj.MaxIntensity = 0.0;
  statsAlreadyComputed.SubarrayIdx = false;
  statsOneObj.SubarrayIdx.set_size(1, 0);
  statsOneObj.WeightedCentroid[0] = 0.0;
  statsOneObj.SubarrayIdxLengths[0] = 0.0;
  statsOneObj.WeightedCentroid[1] = 0.0;
  statsOneObj.SubarrayIdxLengths[1] = 0.0;
  stats.set_size(loop_ub);
  for (i = 0; i < loop_ub; i++) {
    stats[i] = statsOneObj;
  }

  statsAlreadyComputed.PixelIdxList = true;
  if (CC_NumObjects != 0.0) {
    int b_loop_ub;
    if ((regionLengths.size(0) != 1) && (regionLengths.size(0) != 0) &&
        (regionLengths.size(0) != 1)) {
      i = regionLengths.size(0);
      for (k = 0; k <= i - 2; k++) {
        regionLengths[k + 1] = regionLengths[k] + regionLengths[k + 1];
      }
    }

    idxCount.set_size((regionLengths.size(0) + 1));
    idxCount[0] = 0;
    b_loop_ub = regionLengths.size(0);
    for (i = 0; i < b_loop_ub; i++) {
      idxCount[i + 1] = regionLengths[i];
    }

    for (k = 0; k < loop_ub; k++) {
      int i1;
      i = idxCount[k + 1];
      if (idxCount[k] + 1 > i) {
        i1 = 0;
        i = 0;
      } else {
        i1 = idxCount[k];
      }

      b_loop_ub = i - i1;
      stats[k].PixelIdxList.set_size(b_loop_ub);
      for (i = 0; i < b_loop_ub; i++) {
        stats[k].PixelIdxList[i] = CC_RegionIndices[i1 + i];
      }
    }
  }

  ComputeCentroid(CC_ImageSize, stats, &statsAlreadyComputed);
  ComputeEllipseParams(CC_ImageSize, stats, &statsAlreadyComputed);
  ComputeEllipseParams(CC_ImageSize, stats, &statsAlreadyComputed);
  i = stats.size(0);
  for (k = 0; k < i; k++) {
    s[k].Centroid[0] = stats[k].Centroid[0];
    s[k].Centroid[1] = stats[k].Centroid[1];
    s[k].MajorAxisLength = stats[k].MajorAxisLength;
    s[k].MinorAxisLength = stats[k].MinorAxisLength;
  }
}

BubbleIdentifier::~BubbleIdentifier()
{
  // (no terminate code required)
}

BubbleIdentifier::BubbleIdentifier()
{
}

// End of code generation (BubbleIdentifier.cpp)
