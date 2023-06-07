#include <stdlib.h>
#include <stdio.h>
#include <math.h>

typedef float *Matrix;

#define OFFSET 3 // how many elements to skip
#define MAT_ROWS(mat) ((uint32_t *)mat)[0]
#define MAT_COLS(mat) ((uint32_t *)mat)[1]
#define MAT_STRIDE(mat) ((uint32_t *)mat)[2]
#define MAT_POS(mat, row, col) (mat)[(row)*MAT_STRIDE(mat) + (col) + OFFSET]
#define MAT_LEN(mat) (MAT_ROWS(mat) * MAT_COLS(mat) + OFFSET)

void matrix_fill(Matrix mat, float n);
void matrix_random(Matrix mat);
void matrix_dot(Matrix res, Matrix a, Matrix b);
