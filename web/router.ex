defmodule ConstableApi.Router do
  use Phoenix.Router
  alias OAuth2.Strategy

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :auth do
    plug :put_oauth_strategy
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", ConstableApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", alias: ConstableApi do
    pipe_through [:browser, :auth]

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
  end

  socket "/ws", ConstableApi do
    channel "announcements*", AnnouncementChannel
    channel "comments*", CommentChannel
    channel "users*", UserChannel
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

