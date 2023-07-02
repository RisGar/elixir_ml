defmodule ElixirML do
  # import ExUnit.Assertions
  alias ElixirML.Network
  alias ElixirML.Matrix
  alias ElixirML.MNIST
  alias ElixirML.Layer

  def feedforward(network, features, i \\ 0) when is_struct(network) and is_integer(i) do
    if i < length(network.size) - 1 do
      next_features =
        Matrix.prod(features, Enum.at(network.weights, i))
        |> Matrix.sum(Enum.at(network.biases, i))
        |> Matrix.activate(network.activation)

      feedforward(
        network,
        next_features,
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
      IO.puts("Epoch #{i + 1}")

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

  def init(layers, loss, optimiser)
      # length > 2, because we need an input, a linear layer and an activation layer
      when is_list(layers) and length(layers) > 2 and is_atom(loss) and is_atom(optimiser) do
    size = Enum.map(layers, fn %Layer{size: size} -> size end) |> Enum.filter(& &1)

    %Network{
      layers: layers,
      loss: loss,
      optimiser: optimiser,
      weights: Enum.zip(size, Enum.drop(size, 1)) |> Enum.map(&Matrix.rand/1),
      biases: Enum.drop(size, 1) |> Enum.map(&Matrix.rand/1)
    }
  end
end
