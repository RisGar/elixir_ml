defmodule Mix.Tasks.Fashion do
  @moduledoc "Example implementation of a network aiming to replicate a XOR gate"
  @shortdoc "Recognise items in FashionMNIST dataset"

  use Mix.Task
  import ElixirML
  alias ElixirML.MNIST
  alias ElixirML.Layer

  @impl Mix.Task
  def run(_args) do
    image_size = 28 * 28
    [train_images, test_images, train_labels, test_labels] = MNIST.load()

    layers = [
      %Layer{type: :input, size: image_size},
      %Layer{type: :linear, size: 128},
      %Layer{type: :activation, activation: :relu},
      %Layer{type: :linear, size: 128},
      %Layer{type: :activation, activation: :relu},
      %Layer{type: :linear, size: 10},
      %Layer{type: :activation, activation: :softmax}
    ]

    ElixirML.init(
      layers,
      :cross_entropy,
      :adamw
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

    :ok
  end
end
