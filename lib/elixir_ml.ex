defmodule ElixirML do
  def cost(training_data) do
    training_data
    |> Enum.reduce(0, fn {x, y}, acc ->
      nil
    end)
  end

  def train do
    layers = [2, 5, 2]

    _training_data = [
      {[0, 0], [1, 0]},
      {[0, 1], [0, 1]},
      {[1, 0], [0, 1]},
      {[1, 1], [0, 1]}
    ]

    layers
    |> Enum.zip(Enum.drop(layers, 1))
    |> Enum.map(&Tuple.product/1)
  end
end
