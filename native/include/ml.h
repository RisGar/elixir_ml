#include <stdlib.h>
#include <stdio.h>
#include <math.h>

typedef struct
{
  unsigned int rows;
  unsigned int cols;
  unsigned int stride;
  float *vals;
} Matrix;

#define MAT_POS(mat, row, col) (mat).vals[(row) * (mat).stride + (col)]

void matrix_fill(Matrix mat, float n);
void matrix_random(Matrix mat);
void matrix_dot(Matrix res, Matrix a, Matrix b);
