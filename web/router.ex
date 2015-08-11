defmodule Constable.Router do
  use Phoenix.Router
  alias OAuth2.Strategy

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Constable do
    pipe_through :browser # Use the default browser stack

    resources "/email_replies", EmailReplyController, only: [:create]
  end

  scope "/auth", alias: Constable do
    pipe_through [:browser]

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
  end
end
