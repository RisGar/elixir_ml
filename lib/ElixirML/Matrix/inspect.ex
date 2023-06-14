defmodule ElixirML.Matrix.Inspect do
  alias ElixirML.Matrix

  def do_inspect(%Matrix{
        data:
          <<rows::unsigned-integer-little-64, cols::unsigned-integer-little-64,
            stride::unsigned-integer-little-64, vals::binary>>
      }) do
    values = parse_binary_float(vals)
    "#Matrix{rows: #{rows}, cols: #{cols}, stride: #{stride}, values: #{inspect(values)}}"
  end

  def parse_binary_float(<<>>), do: []

  def parse_binary_float(<<flt::float-little-64, rest::binary>>),
    do: [flt | parse_binary_float(rest)]
end
