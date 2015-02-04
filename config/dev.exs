use Mix.Config

config :constable_api, ConstableApi.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  cache_static_lookup: false

config :constable_api, ConstableApi.Repo,
  database: "constable_api_development",
  hostname: "localhost"

# Enables code reloading for development
config :phoenix, :code_reloader, true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
