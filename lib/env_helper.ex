defmodule EnvHelper do
  @moduledoc """
  Helpers for enviroment and application variables.
  """

  @doc """
  creates a method `name/0` which returns either alt or the environment variable set for the upcase version `name`.
  Expects `name` to be an atom, `value` can be anything.

  ##Examples

    iex> System.put_env("SET_VALUE", "aloha")
    iex> defmodule UnsetModule do
    iex>   import EnvHelper
    iex>   system_env(:novalue, "goodbye")
    iex>   system_env(:set_value, "hello")
    iex>   system_env(:int_value, 224)
    iex>   end
    iex> UnsetModule.novalue
    "goodbye"
    iex> UnsetModule.set_value
    "aloha"

  """
  defmacro system_env(name, alt) do
    env_name = Atom.to_string(name) |> String.upcase
    quote do
      def unquote(name)() do
        System.get_env(unquote(env_name)) || unquote(alt)
      end
    end
  end

  @doc """
  Same as system_env/2, but takes the argument `:string_to_integer` to ensure that the environment variable is converted to an integer value.
  """
  defmacro system_env(name, alt, :string_to_integer) do
    env_name = Atom.to_string(name) |> String.upcase
    quote do
      def unquote(name)() do
        value = System.get_env(unquote(env_name)) || unquote(alt)
        if is_binary(value), do: String.to_integer(value), else: value
      end
    end
  end

  @doc """
  Takes the simplest case of an application variable, one where the variable is set by application name and key only. May not handle more complex cases as expected.

  given a config.exs file such as:

  `config :envhelper, :key, "value"`

  Then we would expect to use `EnvHelper.app_env(:value, [:envhelper, :key], "set")` to create a module function `Module.value/0` that returned "value"

  See tests for better details.

  """
  defmacro app_env(name, [appname, key], alt) do
    quote do
      def unquote(name)() do
        Application.get_env(unquote(appname), unquote(key)) || unquote alt
      end
    end
  end
end
