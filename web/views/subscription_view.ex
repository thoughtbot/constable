defmodule Constable.SubscriptionView do
  use Constable.Web, :view

  def render("show.json", %{subscription: subscription}) do
    %{
      id: subscription.id,
      user_id: subscription.user_id,
      announcement_id: subscription.announcement_id
    }
  end
end
