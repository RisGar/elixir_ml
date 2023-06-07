#include "../include/ml.h"

#include <cblas.h>
#include <assert.h>

void matrix_fill(Matrix mat, float num)
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
      MAT_POS(mat, i, j) = (float)rand() / (float)RAND_MAX;
    }
  }
}

void matrix_dot(Matrix res, Matrix a, Matrix b)
{
  // assert(a.rows == res.rows);
  // assert(b.cols == res.cols);
  // assert(a.cols == b.rows);

  cblas_sgemm(CblasRowMajor,
              CblasNoTrans,
              CblasNoTrans,
              a.rows,
              b.cols,
              a.cols,
              1.0,
              a.vals,
              a.stride,
              b.vals,
              b.stride,
              0.0,
              res.vals,
              res.stride);
}
