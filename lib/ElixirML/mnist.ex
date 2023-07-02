defmodule ElixirML.MNIST do
  alias ElixirML.MNIST.NIFs
  alias ElixirML.Matrix

  # def load do
  #   [train_images, test_images, train_labels, test_labels] = NIFs.load()

  #   [
  #     %Matrix{data: train_images},
  #     %Matrix{data: test_images},
  #     %Matrix{data: train_labels},
  #     %Matrix{data: test_labels}
  #   ]
  # end

  # def batch(mat, batch_size) do
  #   NIFs.batch(mat.data, batch_size)
  #   |> Enum.map(fn m ->
  #     %Matrix{data: m}
  #   end)
  # end
end
