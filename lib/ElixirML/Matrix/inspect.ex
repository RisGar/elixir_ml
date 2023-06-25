defmodule ElixirML.Matrix.Inspect do
  @decimal_precision 4

  def do_inspect(%ElixirML.Matrix{
        data:
          <<rows::unsigned-integer-little-64, cols::unsigned-integer-little-64,
            stride::unsigned-integer-little-64, _::binary>>
      }) do
    # values = parse_binary_float(vals)
    # "#Matrix{rows: #{rows}, cols: #{cols}, stride: #{stride}, values: #{inspect(values)}}"
    "#Matrix{rows: #{rows}, cols: #{cols}, stride: #{stride}}"
  end

  def parse_binary_float(<<>>), do: []

  def parse_binary_float(<<flt::float-little-64, rest::binary>>),
    do: [flt |> Float.round(@decimal_precision) | parse_binary_float(rest)]
end
