#include "../include/ml.h"
#include "erl_nif.h"
#include <time.h>

#define UNUSED(x) x __attribute__((__unused__))

static ERL_NIF_TERM fill_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  unsigned long rows, cols;
  double fill_val;

  enif_get_ulong(env, argv[0], &rows);
  enif_get_ulong(env, argv[1], &cols);
  enif_get_double(env, argv[3], &fill_val);

  Matrix mat;
  mat.rows = rows;
  mat.cols = cols;
  mat.stride = cols;
  mat.vals = enif_alloc(sizeof(*mat.vals) * rows * cols);

  matrix_fill(mat, fill_val);

  return enif_make_resource(env, &mat);
}

static ERL_NIF_TERM random_matrix(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *argv)
{
  unsigned long rows, cols;

  enif_get_ulong(env, argv[0], &rows);
  enif_get_ulong(env, argv[1], &cols);

  Matrix mat;
  mat.rows = rows;
  mat.cols = cols;
  mat.stride = cols;
  mat.vals = enif_alloc(sizeof(*mat.vals) * rows * cols);

  matrix_random(mat);

  return enif_make_resource(env, &mat);
}

static ErlNifFunc nif_funcs[] = {
    {"fill", 3, fill_matrix, 0},
    {"random", 2, random_matrix, 0},
};

// RNG initialization.
int load(ErlNifEnv *UNUSED(env), void **UNUSED(priv_data), ERL_NIF_TERM UNUSED(load_info))
{
  srand(time(NULL));
  return 0;
}

ERL_NIF_INIT(Elixir.ElixirML.NIFs, nif_funcs, load, NULL, NULL, NULL)
