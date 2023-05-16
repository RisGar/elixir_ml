defmodule ElixirMLTest do
  use ExUnit.Case
  doctest ElixirML

  test "greets the world" do
    assert ElixirML.hello() == :world
  end
end
