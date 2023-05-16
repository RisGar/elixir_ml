defmodule Utils do
  def sigmoid(x) do
    1 / (1 + :math.exp(-x))
  end

  def sigmoid_prime(x) do
    sigmoid(x) * (1 - sigmoid(x))
  end
end
