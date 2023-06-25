defmodule ElixirML.MNIST.NIFs do
  @moduledoc false
  @on_load :load_nif

  def load_nif do
    nif_file = :filename.join(:code.priv_dir(:elixir_ml), "mnist_nifs")

    case :erlang.load_nif(nif_file, 0) do
      :ok -> :ok
      {:error, {_, reason}} -> IO.warn("Error loading NIF #{reason}")
    end
  end

  def load, do: :erlang.nif_error(:nif_library_not_loaded)

  def batch(mat, batch_size)
      when is_binary(mat) and is_integer(batch_size),
      do: :erlang.nif_error(:nif_library_not_loaded)
end
