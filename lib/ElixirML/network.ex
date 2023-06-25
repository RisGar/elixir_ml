defmodule ElixirML.Network do
  defstruct size: nil,
            activation: nil,
            optimiser: nil,
            loss: nil,
            weights: nil,
            biases: nil,
            features: nil,
            targets: nil
end
