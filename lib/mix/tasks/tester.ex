defmodule Mix.Tasks.Tester do
  use Mix.Task
  alias ElixirML.Matrix

  @impl Mix.Task
  def run(_args) do
    Matrix.random({1, 5})
    |> IO.inspect()
  end
end
