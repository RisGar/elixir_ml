#include "erl_nif.h"
#include "matrix.h"

#ifndef _CONVERSION_H
#define _CONVERSION_H

ERL_NIF_TERM matrix_to_nif(Matrix mat, ErlNifEnv *env);
int enif_get_matrix(ErlNifEnv *env, ERL_NIF_TERM arg, Matrix *mat);

#endif
