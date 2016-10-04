defmodule Constable.Mixfile do
  use Mix.Project

  def project do
    [app: :constable,
     version: "0.0.1",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: dialyzer_settings,
     aliases: aliases,
     deps: deps]
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
    [mod: {Constable, []},
     applications: app_list]
  end

  defp app_list, do: [
    :bamboo,
    :cowboy,
    :ecto,
    :ex_machina,
    :gettext,
    :honeybadger,
    :httpoison,
    :logger,
    :phoenix,
    :postgrex
  ]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:bamboo, "~> 0.7"},
      {:cors_plug, "~> 0.1"},
      {:cowboy, "~> 1.0"},
      {:dialyxir, "~> 0.3", only: [:dev]},
      {:earmark, github: "pragdave/earmark"},
      {:ecto, "~> 2.0"},
      {:envy, "~> 0.0.1"},
      {:ex_machina, "~> 1.0"},
      {:exgravatar, "~> 0.2"},
      {:gettext, "~> 0.11"},
      {:good_times, "~> 1.1"},
      {:honeybadger, "~> 0.1"},
      {:html_sanitize_ex, "~> 1.0.0"},
      {:httpoison, github: "edgurgel/httpoison", override: true},
      {:oauth2, "~> 0.5"},
      {:pact, "0.1.0"},
      {:phoenix_ecto, "~> 3.0.0"},
      {:phoenix_live_reload, "~> 1.0.5"},
      {:phoenix, "~> 1.1"},
      {:phoenix_html, "~> 2.4"},
      {:postgrex, ">= 0.0.0"},
      {:quick_alias, "~> 0.1.0"},
      {:scrivener_ecto, git: "https://github.com/drewolson/scrivener_ecto"},
      {:secure_random, "~> 0.1"},
      {:wallaby, "~> 0.5", only: :test},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp aliases do
    [
      "ecto.reset": ["ecto.drop", "ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "test": ["cmd node_modules/brunch/bin/brunch build", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
