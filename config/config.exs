# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :constable,
  ecto_repos: [Constable.Repo]

# Configures the endpoint
config :constable, ConstableWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tJ+MdrPlKWMpmz7JyJgSu/11xvwnNZo7Sz8IAacy9MM6di3GqackE9iNjhkHI9p8",
  render_errors: [view: ConstableWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Constable.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# To sign in, users must have an email in this domain
config :constable,
  :permitted_email_domain,
  System.get_env("PERMITTED_EMAIL_DOMAIN") || "thoughtbot.com"

config :oauth2, serializers: %{"application/json" => Poison}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
