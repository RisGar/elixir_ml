defmodule ElixirML do
  def cost(training_data) do
    training_data
    |> Enum.reduce(0, fn {x, y}, acc ->
      nil
    end)
  end

  def predict do
  end

  @spec get_weights(nonempty_list(integer)) :: nonempty_list(nonempty_list(nonempty_list(float)))
  def get_weights(layers) do
    layers
    |> Enum.zip(Enum.drop(layers, 1))
    |> Enum.map(&Utils.random_matrix/1)
  end

  @spec get_biases(nonempty_list(integer)) :: nonempty_list(nonempty_list(float))
  def get_biases(layers) do
    layers
    |> Enum.drop(1)
    |> Enum.map(&Utils.random_vector/1)
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

    {weights, biases}
  end
end
