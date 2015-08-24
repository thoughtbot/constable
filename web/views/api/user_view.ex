defmodule Constable.Api.UserView do
  use Constable.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Constable.Api.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Constable.Api.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    user = user |> Repo.preload([:user_interests, :subscriptions])
    %{
      id: user.id,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email),
      user_interests: pluck(user.user_interests, :id),
      subscriptions: pluck(user.subscriptions, :id)
    }
  end
end
