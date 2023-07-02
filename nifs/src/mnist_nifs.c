#include <stdio.h>
#include <string.h>

#include "mnist.h"
#include "matrix.h"
#include "conversion.h"
#include "erl_nif.h"

// ------------------------------------------------------
//
// Exported NIFs
//
// ------------------------------------------------------

static ERL_NIF_TERM load_mnist_data(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *UNUSED(argv))
{
  Images train_images = images_alloc(TRAIN_SIZE);
  Images test_images = images_alloc(TEST_SIZE);
  Labels train_labels = labels_alloc(TRAIN_SIZE);
  Labels test_labels = labels_alloc(TEST_SIZE);

  load_mnist_images(train_images, test_images);
  load_mnist_labels(train_labels, test_labels);

  Matrix train_img_mat = matrix_alloc(TRAIN_SIZE, IMAGE_SIZE);
  memcpy(train_img_mat + OFFSET, train_images, sizeof(double) * TRAIN_SIZE * IMAGE_SIZE);
  enif_free(train_images);

  Matrix test_img_mat = matrix_alloc(TEST_SIZE, IMAGE_SIZE);
  memcpy(test_img_mat + OFFSET, test_images, sizeof(double) * TEST_SIZE * IMAGE_SIZE);
  enif_free(test_images);

  Matrix train_label_mat = matrix_alloc(TRAIN_SIZE, LABEL_SIZE);
  memcpy(train_label_mat + OFFSET, train_labels, sizeof(double) * TRAIN_SIZE * LABEL_SIZE);
  enif_free(train_labels);

  Matrix test_label_mat = matrix_alloc(TEST_SIZE, LABEL_SIZE);
  memcpy(test_label_mat + OFFSET, test_labels, sizeof(double) * TEST_SIZE * LABEL_SIZE);
  enif_free(test_labels);

  return enif_make_list4(env,
                         matrix_to_nif(train_img_mat, env),
                         matrix_to_nif(test_img_mat, env),
                         matrix_to_nif(train_label_mat, env),
                         matrix_to_nif(test_label_mat, env));
}

static ERL_NIF_TERM batch_mnist_data(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *UNUSED(argv))
{
  unsigned int batch_size;
  Matrix mat;
  enif_get_matrix(env, argv[0], &mat);
  enif_get_uint(env, argv[1], &batch_size);

  unsigned int batch_amount = MAT_ROWS(mat) / batch_size;
  size_t size = VALS_LEN(mat) * sizeof(double) + batch_amount * OFFSET;

  // printf("size: %zu\n", size);
  // printf("Batch amount: %u\n", batch_amount);
  // printf("Batch size: %u\n", batch_size);
  // printf("Mat rows: %llu\n", MAT_COLS(mat));

  ERL_NIF_TERM *res = enif_alloc(size);

  for (size_t i = 0; i < batch_amount; i++)
  {
    Matrix m = matrix_batch(mat, batch_size, i);
    res[i] = matrix_to_nif(m, env);
  }
  return enif_make_list_from_array(env, res, batch_amount);
}

static ErlNifFunc nif_funcs[] = {
    {"load", 0, load_mnist_data, 0},
    {"batch", 2, batch_mnist_data, 0},
};

ERL_NIF_INIT(Elixir.ElixirML.MNIST.NIFs, nif_funcs, NULL, NULL, NULL, NULL)
