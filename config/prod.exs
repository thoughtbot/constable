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

heroku_app_name = System.get_env("HEROKU_APP_NAME")
if heroku_app_name && heroku_app_name =~ ~r/\Aconstable-api-staging-pr/ do
  System.put_env("HOST", "#{heroku_app_name}.herokuapp.com")
end

config :constable, ConstableWeb.Endpoint,
  url: [scheme: "https", host: System.get_env("HOST"), port: System.get_env("URL_PORT")],
  http: [port: {:system, "PORT"}, compress: true],
  force_ssl: [rewrite_on: [:x_forwarded_proto], host: System.get_env("HOST")],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  code_reloader: false,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :constable, :shubox_script_url, System.get_env("SHUBOX_SCRIPT_URL")

config :constable, Constable.Repo,
  url: System.get_env("DATABASE_URL")

config :constable, Constable.Mailer,
  adapter: Bamboo.MandrillAdapter,
  api_key: System.get_env("MANDRILL_KEY")

config :honeybadger, :environment_name, System.get_env("HONEYBADGER_ENV")

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
#     config :constable, ConstableWeb.Endpoint, server: true
#
