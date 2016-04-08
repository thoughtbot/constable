use Mix.Config

config :constable, Constable.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  cache_static_lookup: false,
  code_reloader: true,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

config :constable, Constable.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "constable_api_development",
  hostname: "localhost"

config :constable, Constable.Mailer,
  adapter: Bamboo.LocalAdapter

# Enables code reloading for development
config :phoenix, :code_reloader, true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
