# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :constable,
  ecto_repos: [Constable.Repo]

# Configures the endpoint
config :constable, ConstableWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tJ+MdrPlKWMpmz7JyJgSu/11xvwnNZo7Sz8IAacy9MM6di3GqackE9iNjhkHI9p8",
  render_errors: [view: ConstableWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Constable.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# To sign in, users must have an email in this domain
config :constable, :permitted_email_domain, System.get_env("PERMITTED_EMAIL_DOMAIN")

# The shubox key is unique to each app/env
config :constable, :shubox_key, System.get_env("SHUBOX_KEY")

# Hub
config :constable, :hub_url, System.get_env("HUB_URL")
config :constable, :hub_api_token, System.get_env("HUB_API_TOKEN")

config :oauth2, serializers: %{"application/json" => Poison}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
