defmodule ElixirML.Layer do
  @enforce_keys [:type]
  defstruct [:type, :size, :activation]
end
