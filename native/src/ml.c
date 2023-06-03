#include "../include/ml.h"

#include <cblas.h>

void matrix_fill(Matrix mat, const double num)
{
  for (size_t i = 0; i < mat.rows; ++i)
  {
    for (size_t j = 0; j < mat.cols; ++j)
    {
      MAT_POS(mat, i, j) = num;
    }
  }
}

void matrix_random(Matrix mat)
{
  // RNG is initialized at load time.
  for (size_t i = 0; i < mat.rows; ++i)
  {
    for (size_t j = 0; j < mat.cols; ++j)
    {
      MAT_POS(mat, i, j) = (double)rand() / (double)RAND_MAX;
    }
  }
}
