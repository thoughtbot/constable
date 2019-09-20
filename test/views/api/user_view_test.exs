defmodule ConstableWeb.Api.UserViewTest do
  use ConstableWeb.ViewCase, async: true
  alias ConstableWeb.Api.UserView
  alias Constable.Services.HubProfileProvider

  test "show.json returns correct fields" do
    user =
      insert(:user)
      |> with_interest
      |> with_subscription
      |> Repo.preload([:user_interests, :subscriptions])

    rendered_user = render_one(user, UserView, "show.json")

    assert rendered_user == %{
             user: %{
               id: user.id,
               name: user.name,
               profile_image_url: FakeProfileProvider.image_url(user),
               daily_digest: user.daily_digest,
               auto_subscribe: user.auto_subscribe,
               username: user.username,
               user_interests: ids_from(user.user_interests),
               subscriptions: ids_from(user.subscriptions)
             }
           }
  end
end
