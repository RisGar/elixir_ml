defmodule ElixirML do
  def cost(training_data) do
    training_data
    |> Enum.reduce(0, fn {x, y}, acc ->
      nil
    end)
  end

  def predict do
  end

  def get_weights(layers) do
    layers
    |> Enum.zip(Enum.drop(layers, 1))
    |> Enum.map(&Utils.random_2d_array/1)
  end

  def get_biases(layers) do
    layers
    |> Enum.drop(1)
    |> Enum.map(&Utils.random_1d_array/1)
  end

  def train do
    layers = [2, 5, 2]

    _training_data = [
      {[0, 0], [1, 0]},
      {[0, 1], [0, 1]},
      {[1, 0], [0, 1]},
      {[1, 1], [0, 1]}
    ]

    weights = get_weights(layers)
    biases = get_biases(layers)

    IO.inspect(weights)
    IO.inspect(biases)
  end
end
