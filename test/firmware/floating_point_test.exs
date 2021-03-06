defmodule FarmbotOS.Firmware.FloatingPointTest do
  use ExUnit.Case
  alias FarmbotOS.Firmware.FloatingPoint

  @arbitrary_precision [
    {"1741.15", 1741.1474},
    {"2442.86", 2442.8583},
    {"2680.65", 2680.6528},
    {"3309.42", 3309.4192},
    {"4596.65", 4596.6471},
    {"4830.12", 4830.1191},
    {"5035.40", 5035.4027},
    {"5350.30", 5350.2997},
    {"5854.70", 5854.6954},
    {"7488.10", 7488.1041},
    {"8776.70", 8776.6954},
    {"9574.47", 9574.4702}
  ]

  @testcases [
    {"60805.40", 60805.4},
    {"91734.10", 91734.1},
    {"34374.00", 34374.0},
    {"-10766.60", -10766.6},
    {"59587.31", 59587.31},
    {"97994.20", 97994.2},
    {"18092.60", 18092.6},
    {"-0.81", -0.81},
    {"63246.90", 63246.9},
    {"19061.60", 19061.6},
    {"-64914.00", -64914.0},
    {"60500.00", 60500.0},
    {"-0.34", -0.34},
    {"-89309.08", -89309.08},
    {"74346.00", 74346.0},
    {"-97104.72", -97104.72},
    {"94006.75", 94006.75},
    {"-91882.73", -91882.73},
    {"-174.00", -174.0},
    {"-0.14", -0.14}
  ]

  test "encoder" do
    Enum.map(@arbitrary_precision ++ @testcases, fn {string, number} ->
      if String.contains?(string, ".") do
        assert FloatingPoint.encode(number) == string
      else
        assert FloatingPoint.encode(number) == string <> ".0"
      end
    end)
  end
end
