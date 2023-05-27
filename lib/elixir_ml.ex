defmodule ElixirML do
  alias ElixirML.Network
  alias ElixirML.Utils

  def predict(network) do
    # for each input:
    #   dot product with weights
    #   sum with bias
    #   sigmoid

    Utils.matrix_dot_product(network.features |> Enum.at(0), network.weights |> Enum.at(0))
  end

  def cost(network) do
    # for each output:
    #   forward
    #   difference = final output - expected output
    #   square of difference
    #   sum up all the squares (scan / reduce)
    #   divide by amount of rows
  end

  def input(training_data) do
    [inputs, outputs] =
      [[input | _], [target | _]] =
      training_data
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    %Network{
      features: [inputs, []],
      targets: outputs,
      size: [length(input), length(target)]
    }
  end

  def layer(%Network{size: [head | tail]} = network, size) do
    %Network{
      network
      | size: [head | [size | tail]]
    }
  end

  def gen_network(%Network{features: [head | tail]} = network) do
    %Network{
      network
      | features: [head | [[] | tail]],
        weights:
          network.size
          |> Enum.zip(Enum.drop(network.size, 1))
          |> Enum.map(&Utils.random_matrix/1),
        biases:
          network.size
          |> Enum.drop(1)
          |> Enum.map(&Utils.random_vector/1)
    }
  end
end
