defmodule FarmbotCore.Asset.FbosConfigTest do
  use ExUnit.Case
  alias FarmbotCore.Asset.FbosConfig

  @expected_keys [
    :id,
    :updated_at,
    :firmware_hardware,
    :firmware_path,
    :os_auto_update,
    :sequence_body_log,
    :sequence_complete_log,
    :sequence_init_log,
    :safe_height,
    :soil_height
  ]

  test "render/1" do
    result = FbosConfig.render(%FbosConfig{})
    mapper = fn key -> assert Map.has_key?(result, key) end
    Enum.map(@expected_keys, mapper)
  end
end
