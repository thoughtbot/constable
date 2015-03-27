defmodule Constable.Router do
  use Phoenix.Router
  alias OAuth2.Strategy

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :auth do
    plug :put_oauth_strategy
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Constable do
    pipe_through :browser # Use the default browser stack

    resources "/email_replies", EmailReplyController, only: [:create]
  end

  scope "/auth", alias: Constable do
    pipe_through [:browser, :auth]

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
  end

  socket "/ws", Constable do
    channel "announcements*", AnnouncementChannel
    channel "subscriptions*", SubscriptionChannel
    channel "comments*", CommentChannel
    channel "users*", UserChannel
    channel "user_interests*", UserInterestChannel
  end

  defp put_oauth_strategy(conn, _) do
    put_private(conn, :oauth2_strategy, apply(Strategy.AuthCode, :new, [google_auth_params]))
  end

  defp google_auth_params do
    [
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url: "https://www.googleapis.com/oauth2/v3/token",
      site: "https://www.googleapis.com",
      redirect_uri: System.get_env("REDIRECT_URI"),
      scope: "email"
    ]
  end
end

