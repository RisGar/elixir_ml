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

  def build(layers, training_data) do
    weights = get_weights(layers)
    biases = get_biases(layers)

    [inputs, targets] =
      training_data
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    %ElixirML.Network{
      layers: layers,
      weights: weights,
      biases: biases,
      inputs: inputs,
      targets: targets
    }
  end
end
