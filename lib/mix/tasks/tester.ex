defmodule Mix.Tasks.Tester do
  use Mix.Task
  alias ElixirML.Matrix

  @impl Mix.Task
  def run(_args) do
    # Matrix.random({1, 5})
    a =
      Matrix.fill({4, 4}, [
        1.0,
        2.0,
        3.0,
        4.0,
        5.0,
        6.0,
        7.0,
        8.0,
        9.0,
        10.0,
        11.0,
        12.0,
        13.0,
        14.0,
        15.0,
        16.0
      ])

    b = Matrix.fill({4, 4}, 2.5)
    IO.inspect(a)
    IO.inspect(b)

    c = Matrix.sum(a, b)
    IO.inspect(c)

    d = Matrix.prod(a, b)
    IO.inspect(d)

    e = Matrix.shuffle(a)
    IO.inspect(e)
  end
end
