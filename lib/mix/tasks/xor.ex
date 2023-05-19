defmodule Mix.Tasks.Xor do
  @moduledoc "Example XOR network"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    layers = [2, 5, 2]

    training_data = [
      [[0, 0], [1, 0]],
      [[0, 1], [0, 1]],
      [[1, 0], [0, 1]],
      [[1, 1], [1, 0]]
    ]

    model = ElixirML.build(layers, training_data)
    IO.inspect(model)
  end
end
