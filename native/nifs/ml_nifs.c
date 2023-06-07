#include "../include/ml.h"
#include "erl_nif.h"
#include <time.h>

#define UNUSED(x) x __attribute__((__unused__))

Matrix matrix_alloc(unsigned int rows, unsigned int cols)
{
  size_t size = OFFSET * sizeof(uint32_t) + rows * cols * sizeof(float);
  Matrix mat = enif_alloc(size);
  MAT_ROWS(mat) = rows;
  MAT_COLS(mat) = cols;
  MAT_STRIDE(mat) = cols;
  return mat;
}

ERL_NIF_TERM matrix_to_nif(Matrix mat, ErlNifEnv *env)
{
  size_t size = OFFSET * sizeof(uint32_t) + MAT_ROWS(mat) * MAT_COLS(mat) * sizeof(float);
  // ERL_NIF_TERM dims;

  return enif_make_resource_binary(env, mat, mat, size);
}

Matrix nif_to_matrix(ErlNifEnv *env, ERL_NIF_TERM arg)
{
  ErlNifBinary mat_raw;
  enif_inspect_binary(env, arg, &mat_raw);
  Matrix mat = (float *)mat_raw.data;
  return mat;
}

static ERL_NIF_TERM fill_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  uint rows, cols;
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
  uint rows, cols;
  enif_get_uint(env, argv[0], &rows);
  enif_get_uint(env, argv[1], &cols);

  Matrix mat = matrix_alloc(rows, cols);
  matrix_random(mat);

  return matrix_to_nif(mat, env);
}

static ERL_NIF_TERM dot(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  Matrix mat_a = nif_to_matrix(env, argv[0]);
  Matrix mat_b = nif_to_matrix(env, argv[1]);

  uint rows = MAT_ROWS(mat_a);
  uint cols = MAT_COLS(mat_b);

  Matrix res = matrix_alloc(rows, cols);
  matrix_dot(res, mat_a, mat_b);

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
