defmodule ConstableApi do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    setup_dependencies

    children = [
      # Start the endpoint when the application starts
      worker(ConstableApi.Endpoint, []),
      worker(ConstableApi.Repo, [])

      # Here you could define other workers and supervisors as children
      # worker(ConstableApi.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConstableApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_dependencies do
    Pact.start
    Pact.put("announcement_mailer", ConstableApi.Mailers.Announcement)
    Pact.put("mailer", ConstableApi.Mandrill)
    Pact.put("request_with_access_token", OAuth2.AccessToken)
    Pact.put("token_retriever", OAuth2.Strategy.AuthCode)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ConstableApi.Endpoint.config_change(changed, removed)
    :ok
  end
end
