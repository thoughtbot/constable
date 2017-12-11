defmodule ConstableWeb.Api.UserView do
  use Constable.Web, :view

  def render("index.json", %{users: users}) do
    users = users |> Repo.preload([:user_interests, :subscriptions])
    %{users: render_many(users, ConstableWeb.Api.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    user = user |> Repo.preload([:user_interests, :subscriptions])
    %{user: render_one(user, ConstableWeb.Api.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      auto_subscribe: user.auto_subscribe,
      daily_digest: user.daily_digest,
      gravatar_url: Exgravatar.generate(user.email, %{}, true),
      username: user.username,
      user_interests: pluck(user.user_interests, :id),
      subscriptions: pluck(user.subscriptions, :id)
    }
  end
end
