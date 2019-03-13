# EnvHelper

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://raw.githubusercontent.com/manheim/env_helper/master/LICENSE)
[![Travis](https://img.shields.io/travis/manheim/env_helper.svg?maxAge=2592000&style=flat-square)](https://travis-ci.org/manheim/env_helper)
[![Hex.pm](https://img.shields.io/hexpm/v/env_helper.svg?maxAge=2592000&style=flat-square)](https://hex.pm/packages/env_helper)
[![Coveralls](https://img.shields.io/coveralls/manheim/env_helper.svg?maxAge=2592000&style=flat-square)](https://coveralls.io/github/manheim/env_helper)
[![Inline docs](http://inch-ci.org/github/manheim/env_helper.svg)](http://inch-ci.org/github/manheim/env_helper)

Using system variables is good practice, and env helper helps you practice it. [Documentation available online](https://hexdocs.pm/env_helper/api-reference.html)

## Installation

The package can be installed from hex.pm:

  1. Add env_helper to your list of dependencies in `mix.exs`:

 ```elixir
  def deps do
    [{:env_helper, "~> 0.1.0"}]
  end
```

## Usage

#### General

Create a module and import `EnvHelper`, then use the `system_env` and `app_env` macros to to define functions for that module.

#### system_env

```elixir
defmodule Settings do
  import EnvHelper
  system_env(:base_url, "localhost:9000")
end
```

This maps the method `Settings.base_url` to the system environment variable `BASE_URL`, or to the default value if the environment variable is not set.

Some settings might need to be integer values in your code, but will be strings when read from the environment helper. In such cases you can use the `:string_to_integer` flag:

```elixir
system_env(:port, 9876, :string_to_integer)
```

Which will ensure that `PORT` environment variable will be interpreted as an integer.

#### app_env

In config/test.exs:

```elixir
config :my_app, :port, 5678
 ```

In settings.ex:

```elixir
defmodule Settings do
  import EnvHelper
  app_env(:port, [:my_app, :port], 1234)
end
```

Assuming that the `config/dev.exs` file does not define a   `:my_app, :port` variable, in the test environment `Settings.port` is `5678` and in dev it will be `1234`.
