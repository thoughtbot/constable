use Mix.Config

config :constable, ConstableWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :constable, Constable.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "constable_api_test",
  hostname: "localhost",
  # username: System.get_env("POSTGRES_USER") || "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :constable, :sql_sandbox, true

config :constable, :shubox_script_url, "#"

config :constable, Constable.Mailer, adapter: Bamboo.TestAdapter

config :honeybadger, :environment_name, :test

# The tests all use thoughtbot.com user emails
config :constable, :permitted_email_domain, "thoughtbot.com"

config :wallaby,
  max_wait_time: 250,
  js_logger: false,
  driver: Wallaby.Experimental.Chrome

# Set a higher stacktrace during test.
config :phoenix, :stacktrace_depth, 35
