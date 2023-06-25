#include <time.h>

#include "matrix.h"
#include "conversion.h"
#include "erl_nif.h"

// ------------------------------------------------------
//
// Exported NIFs
//
// ------------------------------------------------------

static ERL_NIF_TERM fill_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  unsigned int rows, cols;
  double fill_num;
  enif_get_uint(env, argv[0], &rows);
  enif_get_uint(env, argv[1], &cols);
  enif_get_double(env, argv[2], &fill_num);

  Matrix mat = matrix_alloc(rows, cols);
  matrix_fill(mat, fill_num);

  return matrix_to_nif(mat, env);
}

static ERL_NIF_TERM random_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  unsigned int rows, cols;
  enif_get_uint(env, argv[0], &rows);
  enif_get_uint(env, argv[1], &cols);

  Matrix mat = matrix_alloc(rows, cols);
  matrix_random(mat);

  return matrix_to_nif(mat, env);
}

static ERL_NIF_TERM activate_sigmoid_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  Matrix mat;
  enif_get_matrix(env, argv[0], &mat);

  matrix_sig(mat);

  return matrix_to_nif(mat, env);
}

static ERL_NIF_TERM activate_relu_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  Matrix mat;
  enif_get_matrix(env, argv[0], &mat);

  matrix_rel(mat);

  return matrix_to_nif(mat, env);
}

static ERL_NIF_TERM multiply_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  Matrix mat_a, mat_b;
  enif_get_matrix(env, argv[0], &mat_a);
  enif_get_matrix(env, argv[1], &mat_b);

  unsigned int rows = MAT_ROWS(mat_a);
  unsigned int cols = MAT_COLS(mat_b);

  Matrix res = matrix_alloc(rows, cols);
  matrix_dot(res, mat_a, mat_b);

  return matrix_to_nif(res, env);
}

static ERL_NIF_TERM add_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  Matrix mat_a, mat_b;
  enif_get_matrix(env, argv[0], &mat_a);
  enif_get_matrix(env, argv[1], &mat_b);

  unsigned int rows = MAT_ROWS(mat_a);
  unsigned int cols = MAT_COLS(mat_a);

  Matrix res = matrix_alloc(rows, cols);
  matrix_sum(res, mat_a, mat_b);

  return matrix_to_nif(res, env);
}

// static ERL_NIF_TERM batch_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
// {
//   unsigned int row;
//   Matrix mat;
//   enif_get_matrix(env, argv[0], &mat);
//   enif_get_int(env, argv[1], &row);

//   unsigned int rows = 1;
//   unsigned int cols = MAT_COLS(mat);

//   Matrix res = matrix_alloc(rows, cols);
//   matrix_row(res, mat, row - 1);

//   return matrix_to_nif(res, env);
// }

static ErlNifFunc nif_funcs[] = {
    {"fill", 3, fill_matrix, 0},
    {"random", 2, random_matrix, 0},
    {"prod", 2, multiply_matrix, 0},
    {"sum", 2, add_matrix, 0},
    {"sig", 1, activate_sigmoid_matrix, 0},
    {"rel", 1, activate_relu_matrix, 0},
};

ERL_NIF_INIT(Elixir.ElixirML.Matrix.NIFs, nif_funcs, NULL, NULL, NULL, NULL)
