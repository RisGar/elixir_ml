#include <vecLib.h>
#include <assert.h>
#include <stdlib.h>

#include "matrix.h"
#include "erl_nif.h"

Matrix matrix_batch(Matrix mat, unsigned int batch_size, unsigned int batch_num)
{
  Matrix res = matrix_alloc(batch_size, MAT_COLS(mat));
  for (size_t i = OFFSET; i < TOTAL_LEN(res); ++i)
  {
    res[i] = mat[i + batch_size * batch_num];
  }

  return res;
}
