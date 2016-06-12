defmodule EnvHelper do
  defmacro system_env(name, alt) do
    env_name = Atom.to_string(name) |> String.upcase
    quote do
      def unquote(name)() do
        System.get_env(unquote(env_name)) || unquote(alt)
      end
    end
  end

  defmacro system_env(name, alt, :string_to_integer) do
    env_name = Atom.to_string(name) |> String.upcase
    quote do
      def unquote(name)() do
        value = System.get_env(unquote(env_name)) || unquote(alt)
        if is_binary(value), do: String.to_integer(value), else: value
      end
    end
  end
end
