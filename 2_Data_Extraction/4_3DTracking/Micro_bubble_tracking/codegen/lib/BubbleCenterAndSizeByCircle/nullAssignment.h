//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// nullAssignment.h
//
// Code generation for function 'nullAssignment'
//

#ifndef NULLASSIGNMENT_H
#define NULLASSIGNMENT_H

// Include files
#include "rtwtypes.h"
#include "coder_array.h"
#include "omp.h"
#include <cstddef>
#include <cstdlib>

// Function Declarations
namespace coder {
namespace internal {
void nullAssignment(::coder::array<float, 2U> &x,
                    const ::coder::array<bool, 2U> &idx);

}
} // namespace coder

#endif
// End of code generation (nullAssignment.h)
