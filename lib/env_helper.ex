defmodule EnvHelper do
  @moduledoc """
  Helpers for enviroment and application variables.
  """

  @doc """
  creates a method `name/0` which returns either `alt` or the environment variable set for the upcase version `name`.

  ## Paramenters
  * `name` :: atom

     The name of a system environment variable, downcase, as an atom
  * `alt` :: any

     The value used if the system variable is not set.

  ## Example   

      defmodule EnvSets do
        import EnvHelper
        system_env(:app_url, "localhost:2000")
      end
      > EnvSets.app_url
      "localhost:2000"
      > System.put_env("APP_URL", "app.io")
      :ok
      > EnvSets.app_url
      "app.io"


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
  creates a method `name/0` which returns either `alt` or the environment variable set for the upcase version `name`, cast to an integer.

  ## Paramenters
  * `name` :: atom

     The name of a system environment variable, downcase, as an atom
  * `alt` :: any

     The value used if the system variable is not set.
  * :string_to_integer 

    forces the returned value to be an integer.

  ## Example   

      defmodule EnvSets do
        import EnvHelper
        system_env(:app_port, 2000, :string_to_integer)
      end
      > EnvSets.app_port
      2000
      > System.put_env("APP_PORT", "2340")
      :ok
      > EnvSets.app_port
      2340
      > System.put_env("APP_PORT", 2360)
      :ok
      > EnvSets.app_url
      2360

  """
  @spec system_env(atom, any, :string_to_integer) :: integer
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
  defines a method `name/0` which returns either the application variable for `appname[key]` or the provided `alt` value.

  Works best in simple cases, such as `config :appname, :key, value`

  ## Example
      
      defmodule AppEnvs do
        import EnvHelper
        app_env(:port, [:appname, :port], 1234)
      end
      
      > AppEnvs.port
      1234
      > Application.put_env(:appname, :port, 5678)
      :ok
      > AppEnvs.port
      5678

  """
  defmacro app_env(name, [appname, key], alt) do
    quote do
      def unquote(name)() do
        Application.get_env(unquote(appname), unquote(key)) || unquote alt
      end
    end
  end
end
