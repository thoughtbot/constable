defmodule Constable.Api.SubscriptionViewTest do
  use Constable.ViewCase, async: true
  alias Constable.Api.SubscriptionView

  test "show.json returns correct fields" do
    user = Forge.user
    announcement = Forge.announcement(user: user)
    subscription = Forge.subscription(announcement: announcement, user: user)

    rendered_subscription = render_one(subscription, SubscriptionView, "show.json")

    assert rendered_subscription == %{
      subscription: %{
        id: subscription.id,
        announcement_id: announcement.id,
        user_id: user.id,
      }
    }
  end
end
