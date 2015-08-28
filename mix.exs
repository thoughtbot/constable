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
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Constable, []},
     applications: app_list(Mix.env)]
  end

  defp app_list(:dev), do: [:dotenv | app_list]
  defp app_list(:test), do: [:blacksmith | app_list]
  defp app_list(_), do: app_list
  defp app_list, do: [:phoenix, :cowboy, :logger, :postgrex, :ecto, :httpoison]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:blacksmith, "~> 0.1.1"},
      {:cowboy, "~> 1.0"},
      {:dotenv, "~> 0.0.4"},
      {:earmark, "~> 0.1.17"},
      {:exgravatar, "~> 0.2.0"},
      {:oauth2, "~> 0.2.0"},
      {:pact, "~> 0.1.0"},
      {:phoenix_ecto, "~> 0.8"},
      {:phoenix_html, "~> 1.4"},
      {:phoenix, "~> 0.16.1"},
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
