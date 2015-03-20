defmodule Constable.Mixfile do
  use Mix.Project

  def project do
    [app: :constable,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web", "test/support"],
     compilers: [:phoenix] ++ Mix.compilers,
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
      {:ecto, "~> 0.9.0"},
      {:exgravatar, "~> 0.2.0"},
      {:oauth2, "~> 0.0.4"},
      {:pact, "~> 0.1.0"},
      {:phoenix_ecto, "~> 0.1"},
      {:phoenix, "~> 0.10.0"},
      {:plug, "~> 0.11.0"},
      {:poison, "~> 1.3.1", override: true},
      {:postgrex, ">= 0.0.0"},
      {:secure_random, "~> 0.1"}
    ]
  end
end
