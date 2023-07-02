#include <stdint.h>

typedef double *Images;
typedef double *Labels;

#define UNUSED(x) x __attribute__((__unused__))
#define NOTNULL(ptr)                                      \
  if (!ptr)                                               \
  {                                                       \
    fprintf(stderr, "ERROR: Pointer empty: *%s\n", #ptr); \
    exit(1);                                              \
  }

#define TRAIN_SIZE 60000
#define TEST_SIZE 10000

#define IMAGE_SIZE 28 * 28
#define LABEL_SIZE 10

#define IMAGE_HEADER_COUNT 4
#define LABEL_HEADER_COUNT 2

#ifndef _MNIST_H
#define _MNIST_H

Images images_alloc(unsigned int n);
Labels labels_alloc(unsigned int n);
void print_image(uint8_t data[IMAGE_SIZE]);
void load_mnist_images(Images train, Images test);
void load_mnist_labels(Labels train, Labels test);

#endif
