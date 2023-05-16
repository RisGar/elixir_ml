defmodule Utils do
  def sigmoid(x) do
    1 / (1 + :math.exp(-x))
  end

  def sigmoid_prime(x) do
    sigmoid(x) * (1 - sigmoid(x))
  end

  def random_1d_array(n) do
    for _ <- 1..n do
      :rand.normal()
    end
  end

  def random_2d_array({n, m}) do
    for _ <- 1..m do
      for _ <- 1..n do
        :rand.normal()
      end
    end
  end
end
