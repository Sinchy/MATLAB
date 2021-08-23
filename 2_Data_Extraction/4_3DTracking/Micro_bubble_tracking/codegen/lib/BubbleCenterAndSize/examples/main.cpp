//
//  Academic License - for use in teaching, academic research, and meeting
//  course requirements at degree granting institutions only.  Not for
//  government, commercial, or other organizational use.
//
//  main.cpp
//
//  Code generation for function 'main'
//


//***********************************************************************
// This automatically generated example C++ main file shows how to call
// entry-point functions that MATLAB Coder generated. You must customize
// this file for your application. Do not modify this file directly.
// Instead, make a copy of this file, modify it, and integrate it into
// your development environment.
//
// This file initializes entry-point function arguments to a default
// size and value before calling the entry-point functions. It does
// not store or use any values returned from the entry-point functions.
// If necessary, it does pre-allocate memory for returned values.
// You can use this file as a starting point for a main function that
// you can deploy in your application.
//
// After you copy the file, and before you deploy it, you must make the
// following changes:
// * For variable-size function arguments, change the example sizes to
// the sizes that your application requires.
// * Change the example values of function arguments to the values that
// your application requires.
// * If the entry-point functions return values, store these values or
// otherwise use them as required by your application.
//
//***********************************************************************

// Include files
#include "main.h"
#include "BubbleIdentifier.h"
#include "bwconncomp.h"

// Function Declarations
static bool argInit_boolean_T();
static coder::array<bool, 2U> c_argInit_UnboundedxUnbounded_b();
static void main_BubbleCenterAndSize(BubbleIdentifier *instancePtr);

// Function Definitions
static bool argInit_boolean_T()
{
  return false;
}

static coder::array<bool, 2U> c_argInit_UnboundedxUnbounded_b()
{
  coder::array<bool, 2U> result;

  // Set the size of the array.
  // Change this size to the value that the application requires.
  result.set_size(2, 2);

  // Loop over the array to initialize each element.
  for (int idx0 = 0; idx0 < result.size(0); idx0++) {
    for (int idx1 = 0; idx1 < result.size(1); idx1++) {
      // Set the value of the array element.
      // Change this value to the value that the application requires.
      result[idx0 + result.size(0) * idx1] = argInit_boolean_T();
    }
  }

  return result;
}

static void main_BubbleCenterAndSize(BubbleIdentifier *instancePtr)
{
  coder::array<bool, 2U> img;
  coder::array<struct0_T, 1U> s;

  // Initialize function 'BubbleCenterAndSize' input arguments.
  // Initialize function input argument 'img'.
  img = c_argInit_UnboundedxUnbounded_b();

  // Call the entry-point 'BubbleCenterAndSize'.
  instancePtr->BubbleCenterAndSize(img, s);
}

int main(int, const char * const [])
{
  BubbleIdentifier *classInstance;
  classInstance = new BubbleIdentifier;

  // Invoke the entry-point functions.
  // You can call entry-point functions multiple times.
  main_BubbleCenterAndSize(classInstance);
  delete classInstance;
  return 0;
}

// End of code generation (main.cpp)
