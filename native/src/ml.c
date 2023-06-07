#include "../include/ml.h"

#include <cblas.h>
#include <assert.h>

void matrix_fill(Matrix mat, float num)
{
  for (size_t i = 0; i < VALS_LEN(mat); ++i)
  {
    mat[i + OFFSET] = num;
  }
}

void matrix_random(Matrix mat)
{

  for (size_t i = 0; i < VALS_LEN(mat); ++i)
  {
    mat[i + OFFSET] = (float)rand() / (float)RAND_MAX;
  }
}

void matrix_dot(Matrix res, Matrix a, Matrix b)
{
  assert(MAT_ROWS(a) == MAT_ROWS(res));
  assert(MAT_COLS(b) == MAT_COLS(res));
  assert(MAT_COLS(a) == MAT_ROWS(b));

  cblas_sgemm(CblasRowMajor,
              CblasNoTrans,
              CblasNoTrans,
              MAT_ROWS(a),
              MAT_COLS(b),
              MAT_COLS(a),
              1.0,
              a + OFFSET,
              MAT_STRIDE(a),
              b + OFFSET,
              MAT_STRIDE(b),
              0.0,
              res + OFFSET,
              MAT_STRIDE(res));
}
