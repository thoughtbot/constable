use Mix.Config

config :constable, ConstableWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4001],
  server: true

config :constable, Constable.Repo,
  database: "constable_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :constable, :sql_sandbox, true

config :constable, :shubox_script_url, "http://localhost/testing123.js"

config :constable, Constable.Mailer,
  adapter: Bamboo.TestAdapter

config :honeybadger, :environment_name, :test

# Print only warnings and errors during test
config :logger, level: :warn

config :wallaby, :max_wait_time, 250

# Set a higher stacktrace during test.
config :phoenix, :stacktrace_depth, 35
