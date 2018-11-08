defmodule Constable.Application do

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications

  @moduledoc false

  use Application

  def start(_type, _args) do
    unless Mix.env == "production" do
      Envy.auto_load
    end

    setup_dependencies()

    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Constable.Repo,
      # Start the endpoint when the application starts
      ConstableWeb.Endpoint,
      # Starts a worker by calling: ConstableWeb.Worker.start_link(arg)
      # {ConstableWeb.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Constable.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_dependencies do
    Constable.Pact.start_link
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConstableWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
