defmodule Utils do
  @spec sigmoid(number) :: float
  def sigmoid(x) do
    1 / (1 + :math.exp(-x))
  end

  @spec sigmoid_prime(number) :: float
  def sigmoid_prime(x) do
    sigmoid(x) * (1 - sigmoid(x))
  end

  @doc """
  Generates an `n` dimensional vector filled with random numbers in a standard normal distribution
  """
  @spec random_vector(pos_integer) :: nonempty_list(float)
  def random_vector(n) do
    for _ <- 1..n do
      :rand.normal()
    end
  end

  @doc ~S"""
  Generates an $m \times n$ sized matrix filled with random numbers in a standard normal distribution
  """
  @spec random_matrix({pos_integer, pos_integer}) :: nonempty_list(nonempty_list(float))
  def random_matrix({n, m}) do
    for _ <- 1..m do
      random_vector(n)
    end
  end
end
