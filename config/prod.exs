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
  url: [host: System.get_env("HOST")],
  http: [port: System.get_env("PORT"), compress: true],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :constable, Constable.Repo,
  url: System.get_env("DATABASE_URL")

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
