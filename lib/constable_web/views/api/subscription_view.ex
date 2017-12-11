defmodule ConstableWeb.Api.SubscriptionView do
  use Constable.Web, :view

  def render("index.json", %{subscriptions: subscriptions}) do
    %{subscriptions: render_many(subscriptions, ConstableWeb.Api.SubscriptionView, "subscription.json")}
  end

  def render("show.json", %{subscription: subscription}) do
    %{subscription: render_one(subscription, ConstableWeb.Api.SubscriptionView, "subscription.json")}
  end

  def render("subscription.json", %{subscription: subscription}) do
    %{
      id: subscription.id,
      user_id: subscription.user_id,
      announcement_id: subscription.announcement_id
    }
  end
end
