defmodule Constable do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    setup_dependencies

    children = [
      # Start the endpoint when the application starts
      worker(Constable.Endpoint, []),
      worker(Constable.Repo, [])

      # Here you could define other workers and supervisors as children
      # worker(Constable.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Constable.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_dependencies do
    Pact.start
    Pact.put(:announcement_mailer, Constable.Mailers.Announcement)
    Pact.put(:comment_mailer, Constable.Mailers.Comment)
    Pact.put(:mailer, Constable.Mandrill)
    Pact.put(:request_with_access_token, OAuth2.AccessToken)
    Pact.put(:token_retriever, OAuth2.Strategy.AuthCode)
    Pact.put(:daily_digest, Constable.DailyDigest)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Constable.Endpoint.config_change(changed, removed)
    :ok
  end
end
