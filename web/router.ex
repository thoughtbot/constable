defmodule Constable.Router do
  use Phoenix.Router
  import Ecto.Query
  alias OAuth2.Strategy

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :api do
    plug :accepts, ~w(json)
    plug Constable.AuthPlug
  end

  scope "/", Constable do
    pipe_through :browser

    resources "/email_replies", EmailReplyController, only: [:create]
  end

  scope "/auth", alias: Constable do
    pipe_through [:browser]

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
  end

  scope "/api", alias: Constable.Api do
    pipe_through :api
    resources "/announcements", AnnouncementController
    resources "/comments", CommentController, only: [:create]
    resources "/interests", InterestController, only: [:index, :show]
    resources "/subscriptions", SubscriptionController, only: [:index, :create, :delete]
    resources "/user_interests", UserInterestController, only: [:index, :show, :delete]
    resources "/user", UserController, only: [:index, :show]
  end
end
