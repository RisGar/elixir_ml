defmodule ElixirML.MNIST do
  alias ElixirML.MNIST.NIFs

  def load, do: NIFs.load()
end
