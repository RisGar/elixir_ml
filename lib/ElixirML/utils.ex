defmodule ElixirML.Utils do
  @type vector :: nonempty_list(number)
  @type matrix :: nonempty_list(nonempty_list(number))

  @spec sigmoid(number) :: float
  def sigmoid(x) do
    1 / (1 + :math.exp(-x))
  end

  @spec sigmoid_prime(number) :: float
  def sigmoid_prime(x) do
    sigmoid(x) * (1 - sigmoid(x))
  end

  @doc "Computes the dot product of two vectors"
  @spec dot_product([number], [number]) :: number
  def dot_product(a, b) when length(a) == length(b), do: dot_product(a, b, 0)

  def dot_product(_, _) do
    raise ArgumentError, message: "Vectors must have the same length."
  end

  defp dot_product([], [], product), do: product
  defp dot_product([h1 | t1], [h2 | t2], product), do: dot_product(t1, t2, product + h1 * h2)
end
