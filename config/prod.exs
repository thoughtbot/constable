use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :constable, Constable.Endpoint,
  url: [host: System.get_env("HOST"), port: System.get_env("URL_PORT")],
  http: [port: {:system, "PORT"}, compress: true],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :constable, Constable.Repo,
  url: System.get_env("DATABASE_URL")

config :constable, Constable.Mailer,
  adapter: Bamboo.MandrillAdapter,
  api_key: System.get_env("MANDRILL_KEY")

# Do not pring debug messages in production
config :logger, level: :info

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :constable, Constable.Endpoint, server: true
#
