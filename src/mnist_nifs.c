#include <stdio.h>

#include "mnist.h"
#include "erl_nif.h"

#define UNUSED(x) x __attribute__((__unused__))

// ------------------------------------------------------
//
// Helper functions
//
// ------------------------------------------------------

ERL_NIF_TERM images_to_nif(Images imgs, int amount, ErlNifEnv *env)
{
  ErlNifBinary bin = {
      .data = (unsigned char *)imgs,
      .size = sizeof(double) * amount,
  };

  ERL_NIF_TERM term = enif_make_binary(env, &bin);
  enif_free(imgs);

  return term;
}

ERL_NIF_TERM labels_to_nif(Labels lbls, int amount, ErlNifEnv *env)
{
  ErlNifBinary bin = {
      .data = (unsigned char *)lbls,
      .size = sizeof(int) * amount,
  };

  ERL_NIF_TERM term = enif_make_binary(env, &bin);
  enif_free(lbls);

  return term;
}

// ------------------------------------------------------
//
// Exported NIFs
//
// ------------------------------------------------------

static ERL_NIF_TERM
load_mnist_data(ErlNifEnv *env, int32_t UNUSED(argc), const ERL_NIF_TERM *UNUSED(argv))
{
  Images train_images = images_alloc(TRAIN_SIZE);
  Images test_images = images_alloc(TEST_SIZE);
  Labels train_labels = labels_alloc(TRAIN_SIZE);
  Labels test_labels = labels_alloc(TEST_SIZE);

  puts("Loading images...\n");
  load_mnist_images(train_images, test_images);
  puts("Loading labels...\n");
  load_mnist_labels(train_labels, test_labels);

    return enif_make_list4(env,
                         images_to_nif(train_images, TRAIN_SIZE, env),
                         images_to_nif(test_images, TEST_SIZE, env),
                         labels_to_nif(train_labels, TRAIN_SIZE, env),
                         labels_to_nif(test_labels, TEST_SIZE, env));
}

static ErlNifFunc nif_funcs[] = {
    {"load", 0, load_mnist_data, 0},
};

ERL_NIF_INIT(Elixir.ElixirML.MNIST.NIFs, nif_funcs, NULL, NULL, NULL, NULL)
