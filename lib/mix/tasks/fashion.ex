defmodule Mix.Tasks.Fashion do
  @moduledoc "Example implementation of a network aiming to replicate a XOR gate"
  @shortdoc "Recognise items in FashionMNIST dataset"

  use Mix.Task
  import ElixirML
  # alias ElixirML.Utils

  @impl Mix.Task
  def run(_args) do
    training_data = [
      [[0, 0], [1, 0]],
      [[0, 1], [0, 1]],
      [[1, 0], [0, 1]],
      [[1, 1], [1, 0]]
    ]

    ElixirML.input(training_data)
    |> layer(5)
    |> init_weights()
    |> IO.inspect()

    # |> predict()
  end
end
