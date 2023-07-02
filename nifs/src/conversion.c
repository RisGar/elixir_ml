#include "conversion.h"

ERL_NIF_TERM matrix_to_nif(Matrix mat, ErlNifEnv *env)
{
  ErlNifBinary bin = {
      .data = (unsigned char *)mat,
      .size = TOTAL_BIN_SIZE(mat),
  };

  ERL_NIF_TERM term = enif_make_binary(env, &bin);
  enif_free(mat);

  return term;
}

int enif_get_matrix(ErlNifEnv *env, ERL_NIF_TERM arg, Matrix *mat)
{
  ErlNifBinary bin;
  enif_inspect_binary(env, arg, &bin);

  *mat = enif_alloc(TOTAL_BIN_SIZE(bin.data));
  *mat = (double *)bin.data;
  enif_release_binary(&bin);

  return 0;
}
