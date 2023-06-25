defmodule Mix.Tasks.Fashion do
  @moduledoc "Example implementation of a network aiming to replicate a XOR gate"
  @shortdoc "Recognise items in FashionMNIST dataset"

  use Mix.Task
  import ElixirML
  alias ElixirML.MNIST

  @impl Mix.Task
  def run(_args) do
    image_size = 28 * 28
    [train_images, test_images, train_labels, test_labels] = MNIST.load()

    ElixirML.init(
      # layer sizes
      [image_size, 10, 10, 10],
      # layer activations
      [:relu, :relu, :sigmoid],
      # optimiser
      :adamw,
      # loss
      :cross_entropy
    )
    |> train(
      # input
      train_images,
      # target
      train_labels,
      # epochs
      30,
      # batch size
      10
    )
    # |> feedforward()
    |> IO.inspect()
  end
end
