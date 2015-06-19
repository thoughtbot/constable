defmodule Constable.UserViewTest do
  use Constable.ViewCase, async: true

  test "returns json with id, email, name, and gravatar_url" do
    user =
      Forge.user
      |> Map.put(:user_interests, [Forge.user_interest])
      |> Map.put(:subscriptions, [Forge.subscription])

    rendered_user = UserView.render("show.json", %{user: user})

    assert rendered_user == %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email),
      user_interests: render_many(user.user_interests, "show.json"),
      subscriptions: render_many(user.subscriptions, "show.json")
    }
  end
end
