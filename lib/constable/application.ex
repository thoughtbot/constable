defmodule Constable.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    unless Mix.env == "production" do
      Envy.auto_load
    end

    setup_dependencies()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Constable.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ConstableWeb.Endpoint, []),
      # Start your own worker by calling: Constable.Worker.start_link(arg1, arg2, arg3)
      # worker(Constable.Worker, [arg1, arg2, arg3]),
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
