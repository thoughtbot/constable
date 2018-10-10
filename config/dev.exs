use Mix.Config

config :constable, ConstableWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  url: [host: "localhost"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :constable, ConstableWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/constable_web/views/.*(ex)$},
      ~r{lib/constable_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure your database
config :constable, Constable.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "constable_api_development",
  hostname: "localhost"

config :constable, Constable.Mailer, adapter: Bamboo.LocalAdapter

config :constable, :shubox_script_url, "http://shubox.io/x/a7c92ded.js"

config :honeybadger, :environment_name, :dev
