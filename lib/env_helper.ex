defmodule EnvHelper do
  defmacro system_env(name, alt) do
    env_name = Atom.to_string(name) |> String.upcase
    quote do
      def unquote(name)() do
        System.get_env(unquote(env_name)) || unquote(alt)
      end
    end
  end
end
