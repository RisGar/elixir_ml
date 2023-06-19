#include <stdio.h>
#include <string.h>

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

void print_image(uint8_t data[IMAGE_SIZE])
{
  char ascii[] = " .,:ilwW";
  uint8_t div = 256 / (sizeof(ascii) - 1);

  for (size_t i = 0; i < 28; i++)
  {
    for (size_t j = 0; j < 28; j++)
    {
      char str = ascii[(int)(data[i * 28 + j] / div)];
      printf("%c", str);
    }
    printf("\n");
  }
}

void load_mnist_images(Images train, Images test)
{
  // --- Training images ---

  FILE *train_file = fopen("./datasets/fashionmnist/train-images-idx3-ubyte", "r");
  NOTNULL(train_file);

  uint32_t train_header[IMAGE_HEADER_COUNT];
  fread(train_header, sizeof(uint32_t), IMAGE_HEADER_COUNT, train_file);
  printf("Training images: %d x %d x %d\n",
         reverse_32(train_header[1]),
         reverse_32(train_header[2]),
         reverse_32(train_header[3]));

  size_t train_size = sizeof(uint8_t) * TRAIN_SIZE * IMAGE_SIZE;
  uint8_t *train_data = enif_alloc(train_size);
  fread(train_data, sizeof(uint8_t), TRAIN_SIZE * IMAGE_SIZE, train_file);

  uint8_t first_image[IMAGE_SIZE];
  memcpy(first_image, train_data, IMAGE_SIZE);
  print_image(first_image);

  for (size_t i = 0; i < TRAIN_SIZE * IMAGE_SIZE; i++)
  {
    train[i] = train_data[i] / 255.0f;
  }

  fclose(train_file);
  enif_free(train_data);

  // --- Test images ---

  FILE *test_file = fopen("./datasets/fashionmnist/t10k-images-idx3-ubyte", "r");
  NOTNULL(test_file);

  uint32_t test_header[IMAGE_HEADER_COUNT];
  fread(test_header, sizeof(uint32_t), IMAGE_HEADER_COUNT, test_file);
  printf("Testing images: %d x %d x %d\n",
         reverse_32(test_header[1]),
         reverse_32(test_header[2]),
         reverse_32(test_header[3]));

  size_t test_size = sizeof(uint8_t) * TEST_SIZE * IMAGE_SIZE;
  uint8_t *test_data = enif_alloc(test_size);
  fread(test_data, sizeof(uint8_t), TEST_SIZE * IMAGE_SIZE, test_file);
  for (size_t i = 0; i < TEST_SIZE * IMAGE_SIZE; i++)
  {
    test[i] = test_data[i] / 255.0f;
  }

  fclose(test_file);
  enif_free(test_data);
}

void load_mnist_labels(Labels train, Labels test)
{
  // --- Training images ---

  FILE *train_file = fopen("./datasets/fashionmnist/train-labels-idx1-ubyte", "r");
  NOTNULL(train_file);

  uint32_t train_header[LABEL_HEADER_COUNT];
  fread(train_header, sizeof(uint32_t), LABEL_HEADER_COUNT, train_file);
  printf("Training labels: %d\n",
         reverse_32(train_header[1]));

  fread(train, sizeof(uint8_t), TRAIN_SIZE, train_file);

  fclose(train_file);

  // --- Test images ---

  FILE *test_file = fopen("./datasets/fashionmnist/t10k-labels-idx1-ubyte", "r");
  NOTNULL(test_file);

  uint32_t test_header[LABEL_HEADER_COUNT];
  fread(test_header, sizeof(uint32_t), LABEL_HEADER_COUNT, test_file);
  printf("Testing labels: %d\n",
         reverse_32(test_header[1]));

  fread(test, sizeof(uint8_t), TEST_SIZE, test_file);

  fclose(test_file);
}
