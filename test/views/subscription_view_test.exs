defmodule Constable.SubscriptionViewTest do
  use Constable.ViewCase, async: true

  test "returns json with id, user_id, and announcement_id" do
    subscription = Forge.subscription(id: 1, user_id: 2, announcement_id: 3)

    rendered_subscription =
      SubscriptionView.render("show.json", %{subscription: subscription})

    assert rendered_subscription == %{
      id: 1,
      user_id: 2,
      announcement_id: 3
    }
  end
end
