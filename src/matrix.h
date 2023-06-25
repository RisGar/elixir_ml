#include <math.h>

#define UNUSED(x) x __attribute__((__unused__))

typedef double *Matrix;

#define OFFSET 3 // how many elements to skip
#define MAT_ROWS(mat) ((uint64_t *)mat)[0]
#define MAT_COLS(mat) ((uint64_t *)mat)[1]
#define MAT_STRIDE(mat) ((uint64_t *)mat)[2]
#define MAT_POS(mat, row, col) ((mat)[(row)*MAT_STRIDE(mat) + (col) + OFFSET])
#define VALS_LEN(mat) (MAT_ROWS(mat) * MAT_COLS(mat))
#define TOTAL_LEN(mat) (VALS_LEN(mat) + OFFSET)
#define TOTAL_BIN_SIZE(mat) (TOTAL_LEN(mat) * sizeof(double))

Matrix matrix_alloc(unsigned int rows, unsigned int cols);
void matrix_fill(Matrix mat, double n);
void matrix_random(Matrix mat);
void matrix_sig(Matrix mat);
void matrix_rel(Matrix mat);
void matrix_sum(Matrix res, Matrix a, Matrix b);
void matrix_dot(Matrix res, Matrix a, Matrix b);
Matrix matrix_batch(Matrix mat, unsigned int batch_size, unsigned int batch_num);
// void matrix_row(Matrix res, Matrix mat, unsigned int row);
