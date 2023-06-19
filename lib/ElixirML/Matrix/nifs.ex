defmodule ElixirML.Matrix.NIFs do
  @on_load :load_nifs

  @doc false
  @spec load_nifs :: :ok
  def load_nifs do
    priv_dir =
      case :code.priv_dir(__MODULE__) do
        {:error, _} ->
          ebin_dir = :code.which(__MODULE__) |> :filename.dirname()
          app_path = :filename.dirname(ebin_dir)
          :filename.join(app_path, "priv")

        path ->
          path
      end

    case :erlang.load_nif(:filename.join(priv_dir, "ml_nifs"), 0) do
      :ok ->
        :ok

      {:error, {:load_failed, reason}} ->
        IO.warn("Error loading NIF #{reason}")
        :ok
    end
  end

  @spec random(non_neg_integer, non_neg_integer) :: binary
  def random(rows, cols)
      when is_integer(rows) and is_integer(cols),
      do: :erlang.nif_error(:nif_library_not_loaded)

  @spec fill(non_neg_integer, non_neg_integer, float) :: binary
  def fill(rows, cols, value)
      when is_integer(rows) and is_integer(cols) and is_float(value),
      do: :erlang.nif_error(:nif_library_not_loaded)

  @spec sig(binary) :: binary
  def sig(mat)
      when is_binary(mat),
      do: :erlang.nif_error(:nif_library_not_loaded)

  @spec sum(binary, binary) :: binary
  def sum(a, b)
      when is_binary(a) and is_binary(b),
      do: :erlang.nif_error(:nif_library_not_loaded)

  @spec prod(binary, binary) :: binary
  def prod(a, b)
      when is_binary(a) and is_binary(b),
      do: :erlang.nif_error(:nif_library_not_loaded)
end
