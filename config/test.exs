use Mix.Config

config :constable_api, ConstableApi.Endpoint,
  http: [port: System.get_env("PORT") || 4001]

config :constable_api, ConstableApi.Repo,
  database: "constable_api_test",
  hostname: "localhost"

# Print only warnings and errors during test
config :logger, level: :warn
