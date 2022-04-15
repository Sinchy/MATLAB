//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// BubbleImage.cpp
//
// Code generation for function 'BubbleImage'
//

// Include files
#include "BubbleImage.h"
#include "ObtainBubbleImage_data.h"
#include "imresize.h"
#include "rt_nonfinite.h"
#include "coder_array.h"
#include <cmath>

// Function Definitions
BubbleImage::BubbleImage()
{
  omp_init_nest_lock(&emlrtNestLockGlobal);
}

BubbleImage::~BubbleImage()
{
  omp_destroy_nest_lock(&emlrtNestLockGlobal);
}

void BubbleImage::ObtainBubbleImage(coder::array<double, 2U> &centers,
                                    coder::array<double, 1U> &radii,
                                    const coder::array<unsigned char, 2U> &img,
                                    coder::array<unsigned char, 2U> &b_i_m)
{
  coder::array<double, 2U> b_b_i_m;
  coder::array<double, 2U> b_centers;
  coder::array<double, 2U> weights;
  coder::array<double, 1U> b_radii;
  coder::array<int, 2U> indices;
  coder::array<int, 1U> r2;
  coder::array<int, 1U> r3;
  coder::array<unsigned char, 3U> bubble_images;
  coder::array<unsigned char, 2U> b_out;
  coder::array<unsigned char, 2U> out;
  coder::array<bool, 1U> r;
  coder::array<bool, 1U> r1;
  double d;
  double d_b;
  double outputSize_idx_0;
  double scale_idx_1;
  int b_i;
  int i;
  int ib;
  int idx;
  int j;
  int k;
  int last;
  int lastBlockLength;
  int nblocks;
  last = radii.size(0);
  if (radii.size(0) <= 2) {
    if (radii.size(0) == 1) {
      scale_idx_1 = radii[0];
    } else if ((radii[0] < radii[radii.size(0) - 1]) ||
               (std::isnan(radii[0]) &&
                (!std::isnan(radii[radii.size(0) - 1])))) {
      scale_idx_1 = radii[radii.size(0) - 1];
    } else {
      scale_idx_1 = radii[0];
    }
  } else {
    if (!std::isnan(radii[0])) {
      idx = 1;
    } else {
      bool exitg1;
      idx = 0;
      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= last)) {
        if (!std::isnan(radii[k - 1])) {
          idx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }
    if (idx == 0) {
      scale_idx_1 = radii[0];
    } else {
      scale_idx_1 = radii[idx - 1];
      i = idx + 1;
      for (k = i; k <= last; k++) {
        d = radii[k - 1];
        if (scale_idx_1 < d) {
          scale_idx_1 = d;
        }
      }
    }
  }
  d_b = std::round(scale_idx_1 * 2.0);
  scale_idx_1 = d_b / 2.0;
  idx = centers.size(0);
  r.set_size(centers.size(0));
  for (i = 0; i < idx; i++) {
    d = centers[i];
    r[i] = ((d - scale_idx_1 > 0.0) && (d + scale_idx_1 < img.size(1)) &&
            (centers[i + centers.size(0)] - scale_idx_1 > 0.0));
  }
  idx = centers.size(0);
  r1.set_size(centers.size(0));
  for (i = 0; i < idx; i++) {
    r1[i] = (centers[i + centers.size(0)] + scale_idx_1 < img.size(0));
  }
  last = r.size(0) - 1;
  idx = 0;
  for (b_i = 0; b_i <= last; b_i++) {
    if (r[b_i] && r1[b_i]) {
      idx++;
    }
  }
  r2.set_size(idx);
  idx = 0;
  for (b_i = 0; b_i <= last; b_i++) {
    if (r[b_i] && r1[b_i]) {
      r2[idx] = b_i + 1;
      idx++;
    }
  }
  b_centers.set_size(r2.size(0), 2);
  idx = r2.size(0);
  for (i = 0; i < 2; i++) {
    for (ib = 0; ib < idx; ib++) {
      b_centers[ib + b_centers.size(0) * i] =
          centers[(r2[ib] + centers.size(0) * i) - 1];
    }
  }
  centers.set_size(b_centers.size(0), 2);
  idx = b_centers.size(0) * 2;
  for (i = 0; i < idx; i++) {
    centers[i] = b_centers[i];
  }
  last = r.size(0) - 1;
  idx = 0;
  for (b_i = 0; b_i <= last; b_i++) {
    if (r[b_i] && r1[b_i]) {
      idx++;
    }
  }
  r3.set_size(idx);
  idx = 0;
  for (b_i = 0; b_i <= last; b_i++) {
    if (r[b_i] && r1[b_i]) {
      r3[idx] = b_i + 1;
      idx++;
    }
  }
  b_radii.set_size(r3.size(0));
  idx = r3.size(0);
  for (i = 0; i < idx; i++) {
    b_radii[i] = radii[r3[i] - 1];
  }
  radii.set_size(b_radii.size(0));
  idx = b_radii.size(0);
  for (i = 0; i < idx; i++) {
    radii[i] = b_radii[i];
  }
  i = static_cast<int>(d_b);
  bubble_images.set_size(centers.size(0), i, i);
  ib = centers.size(0);
  if (0 <= centers.size(0) - 1) {
    outputSize_idx_0 = d_b;
  }
  for (b_i = 0; b_i < ib; b_i++) {
    int i1;
    int i2;
    d = radii[b_i];
    //      if (round(centers(i, 2) + r_bb )> H  || round(centers(i, 1) + r_bb)
    //      > W)
    //          bubble_images(i, :,:) = [];
    //          continue;
    //       end
    //
    scale_idx_1 = centers[b_i + centers.size(0)];
    d_b = std::round(scale_idx_1 - radii[b_i]);
    scale_idx_1 = std::round(scale_idx_1 + radii[b_i]);
    if (d_b > scale_idx_1) {
      i1 = -1;
      i2 = -1;
    } else {
      i1 = static_cast<int>(d_b) - 2;
      i2 = static_cast<int>(scale_idx_1) - 1;
    }
    scale_idx_1 = centers[b_i];
    d_b = std::round(scale_idx_1 - radii[b_i]);
    scale_idx_1 = std::round(scale_idx_1 + radii[b_i]);
    if (d_b > scale_idx_1) {
      last = 0;
      lastBlockLength = 0;
    } else {
      last = static_cast<int>(d_b) - 1;
      lastBlockLength = static_cast<int>(scale_idx_1);
    }
    idx = i2 - i1;
    nblocks = lastBlockLength - last;
    out.set_size(idx, nblocks);
    for (i2 = 0; i2 < nblocks; i2++) {
      for (lastBlockLength = 0; lastBlockLength < idx; lastBlockLength++) {
        out[lastBlockLength + out.size(0) * i2] =
            img[((i1 + lastBlockLength) + img.size(0) * (last + i2)) + 1];
      }
    }
    i1 = idx - 1;
    for (j = 0; j <= i1; j++) {
      i2 = out.size(1);
      for (k = 0; k < i2; k++) {
        scale_idx_1 = (static_cast<double>(j) + 1.0) - d;
        d_b = (static_cast<double>(k) + 1.0) - d;
        if (scale_idx_1 * scale_idx_1 + d_b * d_b > d * d) {
          out[j + out.size(0) * k] = 0U;
        }
      }
    }
    d_b = outputSize_idx_0 / static_cast<double>(out.size(0));
    scale_idx_1 = outputSize_idx_0 / static_cast<double>(out.size(1));
    if (d_b <= scale_idx_1) {
      //  Resize first dimension
      coder::contributions(out.size(0), outputSize_idx_0, d_b, 4.0, weights,
                           indices);
      b_out.set_size(weights.size(1), out.size(1));
      coder::resizeAlongDim2D(out, weights, indices,
                              static_cast<double>(weights.size(1)), b_out);
      //  Resize second dimension
      coder::contributions(out.size(1), outputSize_idx_0, scale_idx_1, 4.0,
                           weights, indices);
      out.set_size(b_out.size(0), weights.size(1));
      coder::b_resizeAlongDim2D(b_out, weights, indices,
                                static_cast<double>(weights.size(1)), out);
    } else {
      coder::contributions(out.size(1), outputSize_idx_0, scale_idx_1, 4.0,
                           weights, indices);
      b_out.set_size(out.size(0), weights.size(1));
      coder::b_resizeAlongDim2D(out, weights, indices,
                                static_cast<double>(weights.size(1)), b_out);
      //  Resize second dimension
      coder::contributions(out.size(0), outputSize_idx_0, d_b, 4.0, weights,
                           indices);
      out.set_size(weights.size(1), b_out.size(1));
      coder::resizeAlongDim2D(b_out, weights, indices,
                              static_cast<double>(weights.size(1)), out);
    }
    idx = bubble_images.size(1);
    last = bubble_images.size(2);
    nblocks = bubble_images.size(1);
    for (i1 = 0; i1 < last; i1++) {
      for (i2 = 0; i2 < idx; i2++) {
        bubble_images[(b_i + bubble_images.size(0) * i2) +
                      bubble_images.size(0) * bubble_images.size(1) * i1] =
            out[i2 + nblocks * i1];
      }
    }
  }
  b_b_i_m.set_size(i, i);
  for (b_i = 0; b_i < i; b_i++) {
    for (j = 0; j < i; j++) {
      if (bubble_images.size(0) == 0) {
        scale_idx_1 = 0.0;
      } else {
        if (bubble_images.size(0) <= 1024) {
          idx = bubble_images.size(0);
          lastBlockLength = 0;
          nblocks = 1;
        } else {
          idx = 1024;
          nblocks = bubble_images.size(0) / 1024;
          lastBlockLength = bubble_images.size(0) - (nblocks << 10);
          if (lastBlockLength > 0) {
            nblocks++;
          } else {
            lastBlockLength = 1024;
          }
        }
        scale_idx_1 =
            bubble_images[bubble_images.size(0) * b_i +
                          bubble_images.size(0) * bubble_images.size(1) * j];
        for (k = 2; k <= idx; k++) {
          scale_idx_1 += static_cast<double>(
              bubble_images[((k + bubble_images.size(0) * b_i) +
                             bubble_images.size(0) * bubble_images.size(1) *
                                 j) -
                            1]);
        }
        for (ib = 2; ib <= nblocks; ib++) {
          idx = (ib - 1) << 10;
          d_b =
              bubble_images[(idx + bubble_images.size(0) * b_i) +
                            bubble_images.size(0) * bubble_images.size(1) * j];
          if (ib == nblocks) {
            last = lastBlockLength;
          } else {
            last = 1024;
          }
          for (k = 2; k <= last; k++) {
            d_b += static_cast<double>(
                bubble_images[(((idx + k) + bubble_images.size(0) * b_i) +
                               bubble_images.size(0) * bubble_images.size(1) *
                                   j) -
                              1]);
          }
          scale_idx_1 += d_b;
        }
      }
      b_b_i_m[b_i + b_b_i_m.size(0) * j] =
          scale_idx_1 / static_cast<double>(bubble_images.size(0));
    }
  }
  b_i_m.set_size(b_b_i_m.size(0), b_b_i_m.size(1));
  idx = b_b_i_m.size(0) * b_b_i_m.size(1);
  for (i = 0; i < idx; i++) {
    unsigned char u;
    d = std::round(b_b_i_m[i]);
    if (d < 256.0) {
      u = static_cast<unsigned char>(d);
    } else if (d >= 256.0) {
      u = MAX_uint8_T;
    } else {
      u = 0U;
    }
    b_i_m[i] = u;
  }
}

// End of code generation (BubbleImage.cpp)
