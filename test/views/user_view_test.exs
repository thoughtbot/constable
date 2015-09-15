defmodule Constable.UserViewTest do
  use Constable.ViewCase
  alias Constable.UserInterestView
  alias Constable.SubscriptionView

  test "returns json with id, email, name, and gravatar_url" do
    user = create(:user)
    create(:user_interest, user: user)
    create(:subscription, user: user)
    user = user |> Repo.preload([:user_interests, :subscriptions])

    rendered_user = UserView.render("show.json", %{user: user})

    assert rendered_user == %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email),
      user_interests: render_many(user.user_interests, UserInterestView, "show.json"),
      subscriptions: render_many(user.subscriptions, SubscriptionView, "show.json")
    }
  end
end
