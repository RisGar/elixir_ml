defmodule ElixirML do
  import ExUnit.Assertions
  alias ElixirML.Network
  alias ElixirML.Matrix
  alias ElixirML.MNIST

  def feedforward(network, i \\ 0) when is_struct(network) and is_integer(i) do
    if i < length(network.size) - 1 do
      next_features =
        Matrix.prod(Enum.at(network.features, i), Enum.at(network.weights, i))
        |> Matrix.sum(Enum.at(network.biases, i))
        |> Matrix.activate(network.activation)

      feedforward(
        %Network{network | features: [next_features | network.features] |> Enum.reverse()},
        i + 1
      )
    else
      network
    end
  end

  defp each_batch(network, img_batch, lbl_batch, batch_nums, i \\ 0) do
    if i < batch_nums do
      each_batch(network, img_batch, lbl_batch, batch_nums, i + 1)
    else
      network
    end
  end

  defp each_epoch(network, images, labels, epochs, batch_size, i \\ 0) do
    if i < epochs do
      images = Matrix.shuffle(images)
      labels = Matrix.shuffle(labels)

      batched_images = MNIST.batch(images, batch_size)
      batched_labels = MNIST.batch(labels, batch_size)

      each_batch(network, batched_images, batched_labels, length(batched_images))

      each_epoch(network, images, labels, epochs, batch_size, i + 1)
    else
      network
    end
  end

  def train(network, images, labels, epochs, batch_size)
      when is_struct(network) and is_struct(images) and is_struct(labels) and is_integer(epochs) and
             is_integer(batch_size) do
    # for each epoch:
    #   batches = batch_nif;
    #   for batch in batches:
    #     batch_train;
    #   shuffle;

    each_epoch(network, images, labels, epochs, batch_size)

    # %Network{network | features: [images], targets: labels}
  end

  def init(size, activation, optimiser, loss)
      when is_list(size) and is_list(activation) and is_atom(optimiser) and is_atom(loss) do
    assert(length(size) - 1 == length(activation))

    %Network{
      size: size,
      activation: activation,
      optimiser: optimiser,
      loss: loss,
      weights: Enum.zip(size, Enum.drop(size, 1)) |> Enum.map(&Matrix.random/1),
      biases: Enum.drop(size, 1) |> Enum.map(&Matrix.random/1)
    }
  end
end
