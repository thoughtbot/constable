defmodule Constable.Mixfile do
  use Mix.Project

  def project do
    [app: :constable,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     dialyzer: dialyzer_settings,
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

  defp app_list, do: [:ex_machina, :phoenix, :cowboy, :logger, :postgrex, :ecto, :httpoison]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:bamboo, "~> 0.1.0", github: "paulcsmith/bamboo"},
      {:cowboy, "~> 1.0"},
      {:dialyxir, "~> 0.3", only: [:dev]},
      {:envy, "~> 0.0.1"},
      {:earmark, "~> 0.1.17"},
      {:ecto, "~> 1.1"},
      {:exgravatar, "~> 0.2.0"},
      {:ex_machina, "~> 0.6.1"},
      {:oauth2, "~> 0.5.0"},
      {:pact, "~> 0.1.0"},
      {:phoenix_ecto, "~> 1.2.0"},
      {:phoenix_html, "~> 2.1"},
      {:phoenix, "~> 1.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 0.19.0"},
      {:secure_random, "~> 0.1"},
      {:httpoison, github: "edgurgel/httpoison", override: true},
      {:cors_plug, "~> 0.1.3"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]
end
