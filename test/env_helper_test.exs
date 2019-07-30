defmodule TestSettings do
  import EnvHelper
  system_env(:this, "that")
  system_env(:this_gist, "bat")
  system_env(:force_int, "4821", :string_to_integer)
  system_env(:must_int, 5432, :string_to_integer)
  system_env(:should_int, 5699, :string_to_integer)
  system_env(:force_bool_true, "true", :string_to_boolean)
  system_env(:force_bool_false, "false", :string_to_boolean)
  system_env(:force_bool_nil, "nil", :string_to_boolean)
  system_env(:force_bool_empty, "", :string_to_boolean)
  system_env(:force_bool_words, "not a boolean", :string_to_boolean)
  system_env(:must_bool, false, :string_to_boolean)
  system_env(:as_a_list, "url_one,url_two", :string_to_list)
  system_env(:as_a_system_list, "url_one,url_two", :string_to_list)
  system_env(:as_a_one_item_list, "url_one", :string_to_list)
  system_env(:passed_a_list, ["url_one" ,"url_two"], :string_to_list)

  app_env(:unset, [:env_helper, :unset], "didn't set")
  app_env(:set, [:env_helper, :set], "didn't set")

  defmodule Section do
    app_env(:setvar, [:env_helper, :section, :setvar], "didn't set")
    app_env(:secret, [:env_helper, :section, :secret], "default secret")
  end
end

defmodule SettingsTest do
  use ExUnit.Case
  doctest EnvHelper
  require TestSettings

  setup do
    System.put_env("THIS_GIST", "ghast")
    System.put_env("MUST_INT", "4321")
    System.put_env("MUST_BOOL", "true")
    System.put_env("AS_A_SYSTEM_LIST", "url_three, url_four")
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

  test "allows forcing binary to boolean" do
    assert TestSettings.force_bool_true == true
    assert TestSettings.force_bool_false == false
    assert TestSettings.force_bool_nil == false
    assert TestSettings.force_bool_empty == false
    assert TestSettings.force_bool_words == true
    assert TestSettings.must_bool == true
  end

  test "creates lists from strings" do
    assert TestSettings.as_a_list() == ["url_one","url_two"]
    assert TestSettings.as_a_one_item_list() == ["url_one"]
    assert TestSettings.as_a_system_list() == ["url_three","url_four"]
    assert TestSettings.passed_a_list() == ["url_one","url_two"]
  end

  test "picks up application variables" do
    Application.put_env :env_helper, :set, "was set"
    assert TestSettings.unset == "didn't set"
    assert TestSettings.set == "was set"

    Application.put_env :env_helper, :section, [setvar: "was set"]
    assert TestSettings.Section.secret == "default secret"
    assert TestSettings.Section.setvar == "was set"
  end
end
