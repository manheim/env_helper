defmodule TestSettings do
  import EnvHelper
  system_env(:this, "that")
  system_env(:gist, "gast")
end

defmodule SettingsTest do
  use ExUnit.Case
  require TestSettings

  test "creates methods" do
    assert TestSettings.this == "that"
    assert TestSettings.gist == "gast"
  end
end
