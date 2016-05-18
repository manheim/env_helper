defmodule TestSettings do
  import EnvHelper
  system_env(:this, "that")
  system_env(:this_gist, "bat")
end

defmodule SettingsTest do
  use ExUnit.Case
  require TestSettings

  setup do
    System.put_env("THIS_GIST", "ghast")
  end

  test "creates methods" do
    assert TestSettings.this == "that"
    assert TestSettings.this_gist == "ghast"
  end
end
