defmodule Constable.Mixfile do
  use Mix.Project

  def project do
    [app: :constable,
     version: "0.0.1",
     elixir: "~> 1.5",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: dialyzer_settings(),
     aliases: aliases(),
     deps: deps()]
  end

  defp dialyzer_settings do
    [
      plt_add_deps: true,
      plt_file: ".dialyzer.plt",
      flags: ["-Wunderspecs", "-Wno_undefined_callbacks"]
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {Constable.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:bamboo, "~> 0.7"},
      {:cors_plug, "~> 1.2"},
      {:cowboy, "~> 1.0"},
      {:dialyxir, "~> 0.3", only: [:dev]},
      {:earmark, "~> 1.2"},
      {:ecto, "~> 2.1"},
      {:envy, "~> 1.1.1"},
      {:ex_machina, "~> 2.0"},
      {:exgravatar, "~> 2.0.0"},
      {:gettext, "~> 0.11"},
      {:good_times, "~> 1.1"},
      {:honeybadger, "~> 0.6"},
      {:html_sanitize_ex, "~> 1.3.0"},
      {:httpoison, "~> 1.3", override: true},
      {:oauth2, "~> 0.8"},
      {:pact, "~> 0.2.0"},
      {:phoenix_ecto, "~> 3.4.0"},
      {:phoenix_live_reload, "~> 1.1.5"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_html, "~> 2.4"},
      {:postgrex, ">= 0.0.0"},
      {:quick_alias, "~> 0.1.0"},
      {:scrivener_ecto, "~> 1.1"},
      {:secure_random, "~> 0.1"},
      {:slugger, "~> 0.2"},
      {:wallaby, "~> 0.20", only: :test},
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "assets.compile --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ],
      "assets.compile": &compile_assets/1
    ]
  end

  defp compile_assets(_) do
    Mix.shell.cmd("assets/node_modules/.bin/brunch build assets/")
  end
end
