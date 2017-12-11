defmodule ConstableWeb.Api.SubscriptionViewTest do
  use ConstableWeb.ViewCase, async: true
  alias ConstableWeb.Api.SubscriptionView

  test "show.json returns correct fields" do
    subscription = insert(:subscription)

    rendered_subscription = render_one(subscription, SubscriptionView, "show.json")

    assert rendered_subscription == %{
      subscription: %{
        id: subscription.id,
        announcement_id: subscription.announcement_id,
        user_id: subscription.user_id,
      }
    }
  end
end
