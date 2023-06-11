defmodule Mix.Tasks.Tester do
  use Mix.Task
  alias ElixirML.Matrix

  @impl Mix.Task
  def run(_args) do
    # Matrix.random({1, 5})
    a = Matrix.fill({4, 3}, 2.5)
    b = Matrix.fill({4, 3}, 2.0)
    IO.inspect(a)
    IO.inspect(b)

    c = Matrix.sum(a, b)
    IO.inspect(c)
  end
end
