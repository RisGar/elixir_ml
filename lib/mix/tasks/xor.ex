defmodule Mix.Tasks.Xor do
  @moduledoc "Example XOR network"

  use Mix.Task
  import ElixirML

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
    |> gen_network()
    |> IO.inspect()
  end
end
