defmodule ElixirML.Matrix.NIFs do
  @moduledoc false
  @on_load :load_nif

  def load_nif do
    nif_file = :filename.join(:code.priv_dir(:elixir_ml), "matrix_nifs")

    case :erlang.load_nif(nif_file, 0) do
      :ok -> :ok
      {:error, {_, reason}} -> IO.warn("Error loading NIF #{reason}")
    end
  end

  def random(rows, cols)
      when is_integer(rows) and is_integer(cols),
      do: :erlang.nif_error(:nif_library_not_loaded)

  def fill(rows, cols, value)
      when is_integer(rows) and is_integer(cols) and is_float(value),
      do: :erlang.nif_error(:nif_library_not_loaded)

  def sig(mat)
      when is_binary(mat),
      do: :erlang.nif_error(:nif_library_not_loaded)

  def rel(mat)
      when is_binary(mat),
      do: :erlang.nif_error(:nif_library_not_loaded)

  def sum(a, b)
      when is_binary(a) and is_binary(b),
      do: :erlang.nif_error(:nif_library_not_loaded)

  def prod(a, b)
      when is_binary(a) and is_binary(b),
      do: :erlang.nif_error(:nif_library_not_loaded)
end
