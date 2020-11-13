defmodule FarmbotCeleryScript.FormatUtil do
  def format_float(nil), do: nil

  def format_float(value) when is_integer(value) do
    format_float(value / 1)
  end

  def format_float(value) when is_float(value) do
    case :math.fmod(value, 1) do
      # value has no remainder
      rem when rem <= 0.0 -> :erlang.float_to_binary(value, decimals: 0)
      _ -> :erlang.float_to_binary(value, decimals: 1)
    end
  end

  def format_float(other), do: inspect(other)

  def format_coord(x, y, z) do
    x = format_float(x)
    y = format_float(y)
    z = format_float(z)
    "(#{x}, #{y}, #{z})"
  end
end
