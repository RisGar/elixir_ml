defmodule ElixirML.Matrix do
  alias ElixirML.NIFs
  alias ElixirML.Matrix

  defstruct data: []

  defimpl Inspect do
    @doc false
    def inspect(%Matrix{} = matrix, _opts) do
      Matrix.Inspect.do_inspect(matrix)
    end
  end

  @doc ~S"Generates an $(m \times n)$ or $(1 \times n)$ sized matrix filled with random numbers"
  def random({rows, cols}) when is_integer(rows) and is_integer(cols),
    do: %Matrix{data: NIFs.random(rows, cols)}

  def random(cols) when is_integer(cols),
    do: %Matrix{data: NIFs.random(1, cols)}

  @doc ~S"Fills an $(m \times n)$ or $(1 \times n)$ sized matrix filled with the specified value"
  def fill({rows, cols}, value) when is_integer(rows) and is_integer(cols) and is_float(value),
    do: %Matrix{data: NIFs.fill(rows, cols, value)}

  def fill(cols, value) when is_integer(cols) and is_float(value),
    do: %Matrix{data: NIFs.fill(1, cols, value)}

  @doc ~S"Performs matrix addition on two matrices of equal dimensions"
  def sum(a, b) when is_binary(a.data) and is_binary(b.data),
    do: %Matrix{data: NIFs.sum(a.data, b.data)}

  @doc ~S"Performs a matrix-matrix multiplication using cgemm"
  def prod(%Matrix{} = a, %Matrix{} = b) when is_binary(a.data) and is_binary(b.data),
    do: %Matrix{data: NIFs.prod(a.data, b.data)}
end
