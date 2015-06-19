defmodule Constable.UserView do
  use Constable.Web, :view
  alias Constable.Repo

  def render("show.json", %{user: user}) do
    user = user |> Repo.preload([:user_interests, :subscriptions])
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email),
      user_interests: render_many(user.user_interests, "show.json"),
      subscriptions: render_many(user.subscriptions, "show.json")
    }
  end
end
