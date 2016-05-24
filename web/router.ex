defmodule Constable.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash

    if Mix.env == :test do
      plug Constable.Plugs.SetUserIdFromParams
    end

    plug Constable.Plugs.FetchCurrentUser
  end

  pipeline :authenticated do
    plug Constable.Plugs.ApiAuth
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Constable do
    pipe_through :browser

    get "/", SessionController, :new
    resources "/unsubscribe", UnsubscribeController, only: [:show]

    if Mix.env == :dev do
      get "/emails/:email_name", EmailPreviewController, :show
    end
  end

  scope "/", Constable do
    pipe_through [:browser, Constable.Plugs.RequireLogin]

    resources "/announcements", AnnouncementController, only: [:index, :show, :new, :create, :edit, :update] do
      resources "/comments", CommentController, only: [:create]
      resources "/subscriptions", SubscriptionController, singleton: true, only: [:create, :delete]
    end
    resources "/settings", SettingsController, singleton: true, only: [:show, :update]
    resources "/interests", InterestController, only: [:index, :show], param: "id_or_name" do
      resources "/slack_channel", SlackChannelController, singleton: true, only: [:edit, :update, :delete]
      resources "/user_interest", UserInterestController, singleton: true, only: [:create, :delete]
    end
    resources "/search", SearchController, singleton: true, only: [:new, :show]
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  scope "/", Constable do
    pipe_through :api

    resources "/email_forwards", EmailForwardController, only: [:create]
    resources "/email_replies", EmailReplyController, only: [:create]
  end

  scope "/auth", alias: Constable do
    pipe_through [:browser]

    get "/", AuthController, :index
    get "/javascript_callback", AuthController, :javascript_callback
    get "/browser_callback", AuthController, :browser_callback
  end

  scope "/auth", alias: Constable do
    pipe_through :api

    post "/mobile_callback", AuthController, :mobile_callback
  end

  scope "/api", as: :api, alias: Constable.Api do
    pipe_through [:api, :authenticated]

    resources "/announcements", AnnouncementController
    resources "/comments", CommentController, only: [:create]
    resources "/interests", InterestController, only: [:index, :show, :update]
    resources "/searches", SearchController, only: [:create]
    resources "/subscriptions", SubscriptionController, only: [:index, :create, :delete]
    resources "/user_interests", UserInterestController, only: [:index, :show, :create, :delete]
    resources "/users", UserController, only: [:index, :show]
    resources "/users", UserController, only: [:update], singleton: true
  end

  scope "/api", as: :api, alias: Constable.Api do
    pipe_through :api

    resources "/users", UserController, only: [:create]
  end
end
