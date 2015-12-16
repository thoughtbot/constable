defmodule Constable.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :authenticated do
    plug Constable.AuthPlug
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Constable do
    pipe_through :browser

    resources "/unsubscribe", UnsubscribeController, only: [:show]
    if Mix.env != :production do
      get "/emails/:email_name", EmailPreviewController, :show
    end
  end

  scope "/", Constable do
    pipe_through :api

    resources "/email_replies", EmailReplyController, only: [:create]
  end

  scope "/auth", alias: Constable do
    pipe_through [:browser]

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
  end

  scope "/auth", alias: Constable do
    pipe_through :api

    post "/mobile_callback", AuthController, :mobile_callback
  end

  scope "/api", alias: Constable.Api do
    pipe_through [:api, :authenticated]

    resources "/announcements", AnnouncementController
    resources "/comments", CommentController, only: [:create]
    resources "/interests", InterestController, only: [:index, :show]
    resources "/searches", SearchController, only: [:create]
    resources "/subscriptions", SubscriptionController, only: [:index, :create, :delete]
    resources "/user_interests", UserInterestController, only: [:index, :show, :create, :delete]
    resources "/users", UserController, only: [:index, :show]
    resources "/users", UserController, only: [:update], singleton: true
  end

  scope "/api", alias: Constable.Api do
    pipe_through :api

    resources "/users", UserController, only: [:create]
  end
end
