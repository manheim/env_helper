defmodule TestSettings do
  import EnvHelper
  system_env(:this, "that")
  system_env(:this_gist, "bat")
  system_env(:force_int, "4821", :string_to_integer)
  system_env(:must_int, 5432, :string_to_integer)
  system_env(:should_int, 5699, :string_to_integer)
  app_env(:unset, [:env_helper, :unset], "didn't set")
  app_env(:set, [:env_helper, :set], "didn't set")
end

defmodule SettingsTest do
  use ExUnit.Case
  doctest EnvHelper
  require TestSettings

  setup do
    System.put_env("THIS_GIST", "ghast")
    System.put_env("MUST_INT", "4321")
  end

  test "creates methods for simple cases" do
    assert TestSettings.this == "that"
    assert TestSettings.this_gist == "ghast"
  end

  test "allows forcing binary to integer" do
    assert TestSettings.must_int == 4321
    assert TestSettings.force_int == 4821
    assert TestSettings.should_int == 5699
  end

  test "picks up application variables" do
    Application.put_env :env_helper, :set, "was set"
    assert TestSettings.unset == "didn't set"
    assert TestSettings.set == "was set"
  end
end
