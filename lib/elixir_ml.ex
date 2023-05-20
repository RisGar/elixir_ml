defmodule ElixirML do
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

  def input(training_data) do
    [inputs, targets] =
      training_data
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    %ElixirML.Network{
      inputs: inputs,
      targets: targets,
      size: [length(Enum.at(inputs, 0)), length(Enum.at(targets, 0))]
    }
  end

  def layer(network, size) do
    [head | tail] = network.size

    %ElixirML.Network{
      network
      | size: [head | [size | tail]]
    }
  end

  def gen_network(network) do
    %ElixirML.Network{
      network
      | weights: get_weights(network.size),
        biases: get_biases(network.size)
    }
  end
end
