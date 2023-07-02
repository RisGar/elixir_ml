defmodule ElixirML.Network do
  @enforce_keys [:layers, :loss, :optimiser]
  defstruct [:layers, :loss, :optimiser, :weights, :biases]
end

defmodule ElixirML.Layer do
  @enforce_keys [:type]
  defstruct [:type, :size, :activation]
end
