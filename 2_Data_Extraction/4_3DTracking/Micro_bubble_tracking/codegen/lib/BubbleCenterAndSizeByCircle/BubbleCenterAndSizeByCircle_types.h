//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  BubbleCenterAndSizeByCircle_types.h
//
//  Code generation for function 'BubbleCenterAndSizeByCircle_types'
//


#ifndef BUBBLECENTERANDSIZEBYCIRCLE_TYPES_H
#define BUBBLECENTERANDSIZEBYCIRCLE_TYPES_H

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#ifdef _MSC_VER

#pragma warning(push)
#pragma warning(disable : 4251)

#endif

// Type Declarations
struct b_struct_T;
class c_images_internal_coder_Neighbo;
struct struct_T;
class CircleIdentifier;

// Type Definitions
struct b_struct_T
{
  coder::array<bool, 2U> bw;
};

class c_images_internal_coder_Neighbo
{
 public:
  static void computeParameters(const int imSize[2], const bool nhConn[9], int
    loffsets[9], int linds[9], int soffsets[18], double interiorStart[2], int
    interiorEnd[2]);
  void process2D(const coder::array<double, 2U> &in, coder::array<bool, 2U> &out,
                 const b_struct_T *fparams) const;
  bool Neighborhood[9];
  int ImageSize[2];
  double InteriorStart[2];
  int InteriorEnd[2];
  int ImageNeighborLinearOffsets[9];
  double Padding;
  double PadValue;
  bool ProcessBorder;
  double NeighborhoodCenter;
  int NeighborLinearIndices[9];
  int NeighborSubscriptOffsets[18];
};

struct struct_T
{
  double WeightedCentroid[2];
};

#define MAX_THREADS                    omp_get_max_threads()
#ifdef _MSC_VER

#pragma warning(pop)

#endif
#endif

// End of code generation (BubbleCenterAndSizeByCircle_types.h)
