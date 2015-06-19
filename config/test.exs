use Mix.Config

config :constable, Constable.Endpoint,
  http: [port: System.get_env("PORT") || 4001]

config :constable, Constable.Repo,
  database: "constable_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn
