defmodule Farmbot.CeleryScript.AST.Arg.Milliseconds do
  @moduledoc false
  @behaviour Farmbot.CeleryScript.AST.Arg

  def decode(val), do: {:ok, val}
  def encode(val), do: {:ok, val}
end