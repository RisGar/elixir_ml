#include <cblas.h>
#include <assert.h>
#include <stdlib.h>

#include "matrix.h"
#include "erl_nif.h"

// ------------------------------------------------------
//
// Helper functions
//
// ------------------------------------------------------

double sigmoid(double x)
{
  return 1.0 / (1.0 + exp(-x));
}

double sigmoid_prime(double x)
{
  return sigmoid(x) * (1 - sigmoid(x));
}

#define RELU_FACTOR 0.01

double leaky_relu(double x)
{
  return x > 0 ? x : RELU_FACTOR * x;
  // return x > 0 ? x : 0;
}

double leaky_relu_prime(double x)
{
  return x > 0 ? 1 : RELU_FACTOR;
}

// ------------------------------------------------------
//
// Matrix functions
//
// ------------------------------------------------------

Matrix matrix_alloc(unsigned int rows, unsigned int cols)
{
  size_t size = OFFSET * sizeof(uint64_t) + rows * cols * sizeof(double);
  Matrix mat = enif_alloc(size);
  MAT_ROWS(mat) = rows;
  MAT_COLS(mat) = cols;
  MAT_STRIDE(mat) = cols;
  return mat;
}

void matrix_fill(Matrix mat, double num)
{
  for (size_t i = OFFSET; i < TOTAL_LEN(mat); ++i)
  {
    mat[i] = num;
  }
}

void matrix_random(Matrix mat)
{

  for (size_t i = OFFSET; i < TOTAL_LEN(mat); ++i)
  {
    mat[i] = (double)arc4random() / (double)RAND_MAX;
  }
}

void matrix_sig(Matrix mat)
{
  for (size_t i = OFFSET; i < TOTAL_LEN(mat); ++i)
  {
    mat[i] = sigmoid(mat[i]);
  }
}

void matrix_rel(Matrix mat)
{
  for (size_t i = OFFSET; i < TOTAL_LEN(mat); ++i)
  {
    mat[i] = leaky_relu(mat[i]);
  }
}

void matrix_sum(Matrix res, Matrix a, Matrix b)
{
  assert(MAT_ROWS(a) == MAT_ROWS(b));
  assert(MAT_COLS(b) == MAT_COLS(b));

  for (size_t i = OFFSET; i < TOTAL_LEN(res); ++i)
  {
    res[i] = a[i] + b[i];
  }
}

Matrix matrix_batch(Matrix mat, unsigned int batch_size, unsigned int batch_num)
{
  Matrix res = matrix_alloc(batch_size, MAT_COLS(mat));
  for (size_t i = OFFSET; i < TOTAL_LEN(res); ++i)
  {
    res[i] = mat[i + batch_size * batch_num];
  }

  return res;
}

void matrix_shuffle_rows(Matrix res, Matrix mat)
{
  for (size_t i = OFFSET; i < MAT_ROWS(res); ++i)
  {
    size_t j = i + arc4random() % (MAT_ROWS(res) - i);
    for (size_t k = OFFSET; k < MAT_COLS(res); ++k)
    {
      MAT_POS(res, i, k) = MAT_POS(mat, j, k);
      MAT_POS(res, j, k) = MAT_POS(mat, i, k);
    }
  }
}

void matrix_dot(Matrix res, Matrix a, Matrix b)
{
  assert(MAT_COLS(a) == MAT_ROWS(b));

  cblas_dgemm(CblasRowMajor,
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
