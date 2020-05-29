defmodule Constable.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications

  @moduledoc false

  use Application

  def start(_type, _args) do
    unless Mix.env() == "production" do
      Envy.auto_load()
      Envy.reload_config()
    end

    Neuron.Config.set(url: "#{Application.fetch_env!(:constable, :hub_url)}/graphql")

    Neuron.Config.set(
      headers: [authorization: "Bearer #{Application.fetch_env!(:constable, :hub_api_token)}"]
    )

    setup_dependencies()

    children = [
      Constable.Repo,
      ConstableWeb.Endpoint,
      {Task.Supervisor, name: Constable.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Constable.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_dependencies do
    Constable.Pact.start_link()
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConstableWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
