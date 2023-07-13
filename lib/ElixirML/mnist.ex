defmodule ElixirML.MNIST do
  alias ElixirML.NIFs
  alias ElixirML.Matrix

  @filename "priv/data/mnist.bin"

  @spec load :: nonempty_list(%Matrix{})
  def load do
    case File.read(@filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _} -> NIFs.mnist_load()
    end
  end

  @spec save(nonempty_list(%Matrix{})) :: nil
  def save(data) do
    case File.read(@filename) do
      {:ok, _} ->
        nil

      {:error, _} ->
        File.mkdir_p!(Path.dirname(@filename))
        File.write(@filename, :erlang.term_to_binary(data))
        nil
    end
  end

  @spec print(nonempty_list, nonempty_list) :: nil
  def print(image, label) when length(image) == 28 * 28 and length(label) == 10 do
    for i <- 1..(28 * 28) do
      case Enum.at(image, i - 1) do
        n when n > 0.875 -> IO.write(IO.ANSI.color_background(255) <> "  ")
        n when n > 0.75 -> IO.write(IO.ANSI.color_background(252) <> "  ")
        n when n > 0.625 -> IO.write(IO.ANSI.color_background(249) <> "  ")
        n when n > 0.5 -> IO.write(IO.ANSI.color_background(246) <> "  ")
        n when n > 0.375 -> IO.write(IO.ANSI.color_background(243) <> "  ")
        n when n > 0.25 -> IO.write(IO.ANSI.color_background(240) <> "  ")
        n when n > 0.125 -> IO.write(IO.ANSI.color_background(237) <> "  ")
        _ -> IO.write(IO.ANSI.color_background(232) <> "  ")
      end

      if rem(i, 28) == 0, do: IO.write(IO.ANSI.reset() <> "\n")
    end

    case Enum.find_index(label, &(&1 == 1)) do
      0 -> "T-shirt/top"
      1 -> "Trouser"
      2 -> "Pullover"
      3 -> "Dress"
      4 -> "Coat"
      5 -> "Sandal"
      6 -> "Shirt"
      7 -> "Sneaker"
      8 -> "Bag"
      9 -> "Ankle boot"
    end
    |> IO.puts()

    nil
  end
end
