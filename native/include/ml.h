#include <stdlib.h>
#include <stdio.h>
#include <math.h>

typedef struct
{
  size_t rows;
  size_t cols;
  size_t stride;
  double *vals;
} Matrix;

#define MAT_POS(mat, row, col) (mat).vals[(row) * (mat).stride + (col)]

void matrix_fill(Matrix mat, const double n);
void matrix_random(Matrix mat);
