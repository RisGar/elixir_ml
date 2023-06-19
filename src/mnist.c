#include <stdio.h>

#include "mnist.h"
#include "erl_nif.h"

Images images_alloc(unsigned int amount)
{
  size_t size = sizeof(double) * amount * IMAGE_SIZE;
  Images imgs = enif_alloc(size);
  return imgs;
}

Labels labels_alloc(unsigned int amount)
{
  size_t size = sizeof(int) * amount;
  Labels lbls = enif_alloc(size);
  return lbls;
}

void load_mnist_images(Images train, Images test)
{
  // --- Training images ---

  FILE *train_file = fopen("/Users/rishab/Documents/Programming/elixir-ml/datasets/fashionmnist/train-images-idx3-ubyte", "r");
  NOTNULL(train_file);

  uint32_t train_header[IMAGE_HEADER_COUNT];
  fread(train_header, sizeof(uint32_t), IMAGE_HEADER_COUNT, train_file);
  printf("Training images: %d x %d x %d\n",
         reverse_32(train_header[1]),
         reverse_32(train_header[2]),
         reverse_32(train_header[3]));

  uint8_t train_data[TRAIN_SIZE * IMAGE_SIZE];
  fread(train_data, sizeof(uint8_t), TRAIN_SIZE * IMAGE_SIZE, train_file);
  for (int i = 0; i < TRAIN_SIZE * IMAGE_SIZE; i++)
  {
    train[i] = train_data[i] / 255.0f;
  }

  fclose(train_file);

  // --- Test images ---

  FILE *test_file = fopen("/Users/rishab/Documents/Programming/elixir-ml/datasets/fashionmnist/t10k-images-idx3-ubyte", "r");
  NOTNULL(test_file);

  uint32_t test_header[IMAGE_HEADER_COUNT];
  fread(test_header, sizeof(uint32_t), IMAGE_HEADER_COUNT, test_file);
  printf("Testing images: %d x %d x %d\n",
         reverse_32(test_header[1]),
         reverse_32(test_header[2]),
         reverse_32(test_header[3]));

  uint8_t test_data[TEST_SIZE * IMAGE_SIZE];
  fread(test_data, sizeof(uint8_t), TEST_SIZE * IMAGE_SIZE, test_file);
  for (int i = 0; i < TEST_SIZE * IMAGE_SIZE; i++)
  {
    test[i] = test_data[i] / 255.0f;
  }

  fclose(test_file);
}

void load_mnist_labels(Labels train, Labels test)
{
  // --- Training images ---

  FILE *train_file = fopen("/Users/rishab/Documents/Programming/elixir-ml/datasets/fashionmnist/train-labels-idx1-ubyte", "r");
  NOTNULL(train_file);

  uint32_t train_header[LABEL_HEADER_COUNT];
  fread(train_header, sizeof(uint32_t), LABEL_HEADER_COUNT, train_file);
  printf("Training labels: %d\n",
         reverse_32(train_header[1]));

  fread(train, sizeof(uint8_t), TRAIN_SIZE, train_file);

  fclose(train_file);

  // --- Test images ---

  FILE *test_file = fopen("/Users/rishab/Documents/Programming/elixir-ml/datasets/fashionmnist/t10k-labels-idx1-ubyte", "r");
  NOTNULL(test_file);

  uint32_t test_header[LABEL_HEADER_COUNT];
  fread(test_header, sizeof(uint32_t), LABEL_HEADER_COUNT, test_file);
  printf("Testing labels: %d\n",
         reverse_32(test_header[1]));

  fread(test, sizeof(uint8_t), TEST_SIZE, test_file);

  fclose(test_file);
}
