#include "../include/ml.h"
#include "erl_nif.h"
#include <time.h>

#define UNUSED(x) x __attribute__((__unused__))
#define MAT_FROM_BIN(x) (Matrix *)x.data

Matrix *matrix_alloc(unsigned int rows, unsigned int cols)
{
  Matrix *mat = (Matrix *)enif_alloc(sizeof(Matrix));
  mat->rows = rows;
  mat->cols = cols;
  mat->stride = cols;
  mat->vals = (float *)enif_alloc(rows * cols * sizeof(float));
  return mat;
}

ERL_NIF_TERM matrix_to_nif(Matrix *mat, ErlNifEnv *env)
{
  size_t size_vals = mat->rows * mat->cols * sizeof(float);
  size_t size_dims = sizeof(unsigned int) * 3;
  ERL_NIF_TERM dims;
  ERL_NIF_TERM vals;

  return enif_make_list2(
      env,
      enif_make_resource_binary(env, &dims, mat, size_dims),
      enif_make_resource_binary(env, &vals, mat->vals, size_vals));
}

static ERL_NIF_TERM fill_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  unsigned int rows, cols;
  enif_get_uint(env, argv[0], &rows);
  enif_get_uint(env, argv[1], &cols);

  ErlNifBinary fill_num;
  enif_inspect_binary(env, argv[3], &fill_num);

  Matrix *mat = matrix_alloc(rows, cols);
  matrix_fill(*mat, *(float *)fill_num.data);

  return matrix_to_nif(mat, env);
}

static ERL_NIF_TERM random_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  unsigned int rows, cols;
  enif_get_uint(env, argv[0], &rows);
  enif_get_uint(env, argv[1], &cols);

  Matrix *mat = matrix_alloc(rows, cols);
  matrix_random(*mat);

  return matrix_to_nif(mat, env);
}

static ERL_NIF_TERM dot(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  ErlNifBinary mat_a;
  ErlNifBinary mat_b;
  enif_inspect_binary(env, argv[0], &mat_a);
  enif_inspect_binary(env, argv[1], &mat_b);

  unsigned int rows = (MAT_FROM_BIN(mat_a))->rows;
  unsigned int cols = (MAT_FROM_BIN(mat_b))->cols;

  Matrix *res = matrix_alloc(rows, cols);
  matrix_dot(*res, *MAT_FROM_BIN(mat_a), *MAT_FROM_BIN(mat_b));

  return matrix_to_nif(res, env);
}

static ErlNifFunc nif_funcs[] = {
    {"fill", 3, fill_matrix, 0},
    {"random", 2, random_matrix, 0},
    {"dot", 2, dot, 0},
};

// RNG initialization.
int load(ErlNifEnv *UNUSED(env), void **UNUSED(priv_data), ERL_NIF_TERM UNUSED(load_info))
{
  srand(time(NULL) + clock());
  return 0;
}

ERL_NIF_INIT(Elixir.ElixirML.NIFs, nif_funcs, load, NULL, NULL, NULL)
