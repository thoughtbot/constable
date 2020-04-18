defmodule Constable.MixProject do
  use Mix.Project

  def project do
    [
      app: :constable,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      dialyzer: dialyzer_settings(),
      aliases: aliases(),
      deps: deps()
    ]
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
      {:bamboo, "~> 1.1"},
      {:cors_plug, "~> 2.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:earmark, "~> 1.2"},
      {:ecto_sql, "~> 3.4.0"},
      {:envy, "~> 1.1.1"},
      {:ex_machina, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:good_times, "~> 1.1"},
      {:honeybadger, "~> 0.6"},
      {:html_sanitize_ex, "~> 1.4.0"},
      {:httpoison, "~> 1.3", override: true},
      {:jason, "~> 1.0"},
      {:memoize, "~> 1.2"},
      {:mock, "~> 0.3.0", only: :test},
      {:neuron, "~> 4.1.0"},
      {:oauth2, "~> 2.0"},
      {:pact, "~> 0.2.0"},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.1.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:plug_cowboy, "~> 2.0"},
      {:poison, ">= 1.5.0"},
      {:postgrex, ">= 0.0.0"},
      {:quick_alias, "~> 0.1.0"},
      {:scrivener_ecto, "~> 2.3.0"},
      {:secure_random, "~> 0.1"},
      {:slugger, "~> 0.2.0"},
      {:wallaby, "~> 0.20", only: :test}
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
    Mix.shell().cmd("cd assets && node_modules/.bin/webpack --mode production && cd ..")
  end
end
