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
    env_name = Atom.to_string(name) |> String.upcase()

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

  creates a method `name/0` which returns either `alt` or the environment variable set for the upcase version `name`, cast to a boolean.

  ## Paramenters
  * `name` :: atom

     The name of a system environment variable, downcase, as an atom
  * `alt` :: any

     The value used if the system variable is not set.
  * :string_to_boolean

    forces the returned value to be a boolean.

  ## Example

      defmodule EnvSets do
        import EnvHelper
        system_env(:auto_connect, false, :string_to_boolean)
      end
      > EnvSets.auto_connect
      false
      > System.put_env("AUTO_CONNECT", "true")
      :ok
      > EnvSets.auto_connect
      true
      > System.put_env("AUTO_CONNECT", "false")
      :ok
      > EnvSets.auto_connect
      false

  creates a method `name/0` which returns either `alt` or the environment variable set for the upcase version `name`, cast to a List.

  ## Paramenters
  * `name` :: atom

     The name of a system environment variable, downcase, as an atom
  * `alt` :: any

     The value used if the system variable is not set.
  * :string_to_list

    forces the returned value to be a list.

  ## Example

      defmodule EnvSets do
        import EnvHelper
        system_env(:destination_urls, "url_one,url_two", :string_to_list)
      end
      > EnvSets.destination_urls
      ["url_one", "url_two"]
      > System.put_env("DESTINATION_URLS", "url_three,url_four")
      :ok
      > EnvSets.destination_urls
      ["url_three", "url_four"]
      > System.put_env("AUTO_CONNECT", "url_five")
      :ok
      > EnvSets.destination_urls
      ["url_five"]

  """
  @spec system_env(atom, any, :string_to_integer) :: integer
  @spec system_env(atom, any, :string_to_boolean) :: boolean
  @spec system_env(atom, any, :string_to_list) :: list()
  defmacro system_env(name, alt, :string_to_integer) do
    env_name = Atom.to_string(name) |> String.upcase()

    quote do
      def unquote(name)() do
        value = System.get_env(unquote(env_name)) || unquote(alt)
        if is_binary(value), do: String.to_integer(value), else: value
      end
    end
  end
  defmacro system_env(name, alt, :string_to_boolean) do
    env_name = Atom.to_string(name) |> String.upcase()

    quote do
      def unquote(name)() do
        value = System.get_env(unquote(env_name)) || unquote(alt)

        if is_binary(value) do
          String.downcase(value) not in ["", "false", "nil"]
        else
          value && true
        end
      end
    end
  end
  defmacro system_env(name, alt, :string_to_list) do
    env_name = Atom.to_string(name) |> String.upcase()

    quote do
      def unquote(name)() do
        value = System.get_env(unquote(env_name)) || unquote(alt)

        if is_binary(value) do
          value
          |> String.split(",")
          |> Enum.map(&String.trim/1)
        else
          value
        end
      end
    end
  end

  @doc """
  defines a method `name/0` which returns either the application variable for `appname[key]` or the provided `alt` value.

  Works best in simple cases, such as `config :appname, :key, value`

  ## Example (simple app variable)

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

  ## Example (nested app variable)

      defmodule AppEnvs do
        import EnvHelper

        defmodule Section do
          app_env(:secret, [:appname, :section, :secret], "default secret")
        end
      end

      > AppEnvs.Section.secret
      "default secret"
      > Application.puts_env(:appname, :section, [secret: "my super secret"])
      :ok
      > AppEnvs.Section.secret
      "my super secret"
  """
  defmacro app_env(name, [appname, key], alt) do
    quote do
      def unquote(name)() do
        Application.get_env(unquote(appname), unquote(key)) || unquote(alt)
      end
    end
  end

  defmacro app_env(name, [appname, key, subkey], alt) do
    quote do
      def unquote(name)() do
        opts = Application.get_env(unquote(appname), unquote(key)) || []

        case List.keyfind(opts, unquote(subkey), 0) do
          {_, value} -> value
          nil -> unquote(alt)
        end
      end
    end
  end
end
