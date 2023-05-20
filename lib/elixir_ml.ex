defmodule ElixirML do
  alias ElixirML.Network
  alias ElixirML.Utils

  def input(training_data) do
    [inputs, targets] =
      training_data
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    %Network{
      inputs: inputs,
      targets: targets,
      size: [length(Enum.at(inputs, 0)), length(Enum.at(targets, 0))]
    }
  end

  def layer(network, size) do
    [head | tail] = network.size

    %Network{
      network
      | size: [head | [size | tail]]
    }
  end

  def gen_network(network) do
    %Network{
      network
      | weights: Utils.get_weights(network.size),
        biases: Utils.get_biases(network.size)
    }
  end
end
