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

  @spec random(non_neg_integer | {non_neg_integer, non_neg_integer}) ::
          %ElixirML.Matrix{data: binary}
  @doc ~S"Generates an $(m \times n)$ or $(1 \times n)$ sized matrix filled with random numbers"
  def random({rows, cols}) when is_integer(rows) and is_integer(cols),
    do: %Matrix{data: NIFs.random(rows, cols)}

  def random(cols) when is_integer(cols),
    do: %Matrix{data: NIFs.random(1, cols)}

  @spec fill(non_neg_integer, non_neg_integer, float) :: %ElixirML.Matrix{data: binary}
  def fill(rows, cols, value) when is_integer(rows) and is_integer(cols) and is_float(value),
    do: %Matrix{data: NIFs.fill(rows, cols, value)}

  @spec dot(
          %ElixirML.Matrix{data: binary},
          %ElixirML.Matrix{data: binary}
        ) :: binary
  @doc ~S"Performs a matrix-matrix multiplication using cgemm"
  def dot(%Matrix{} = a, %Matrix{} = b) do
    NIFs.dot(
      a.data,
      b.data
    )
  end
end