# EnvHelper

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add env_helper to your list of dependencies in `mix.exs`:

        def deps do
          [{:env_helper, "~> 0.0.1"}]
        end

## Usage

Create a module to keep your settings in, and then call the `system_env/2` macro with the name of the environment variable you want to use as a lowercase atom, and the value you want to be the default as a string. For example:

    defmodule Settings
      import EnvHelper
      system_env(:base_url, "localhost:9000")
    end

This maps the method `Settings.base_url` to the system environment variable `BASE_URL`, or to the default value if the environment variable is not set.


