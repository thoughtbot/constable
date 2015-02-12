defmodule ConstableApi.Mixfile do
  use Mix.Project

  def project do
    [app: :constable_api,
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
    [mod: {ConstableApi, []},
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
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 0.5"},
      {:phoenix, "~> 0.8.0"},
      {:cowboy, "~> 1.0"},
      {:dotenv, "~> 0.0.4"},
      {:secure_random, "~> 0.1"},
      {:oauth2, "~> 0.0.3"},
      {:pact, "~> 0.0.1"},
      {:blacksmith, "~> 0.1.1"},
      {:exgravatar, "~> 0.2.0"}
    ]
  end
end
