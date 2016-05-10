use Mix.Config

config :constable, Constable.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
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

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
