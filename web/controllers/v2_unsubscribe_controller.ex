defmodule Constable.V2.UnsubscribeController do
  use Constable.Web, :controller
  import Constable.Controllers.UnsubscribeHelpers

  alias Constable.Services.SubscriptionToken

  def show(conn, %{"id" => token}) do
    subscription = case SubscriptionToken.decode(token) do
      {user_id, announcement_id} ->
        Repo.get_by(subscription_with_announcement,
          user_id: user_id,
          announcement_id: announcement_id,
        )
      _ ->
        nil
    end

    conn |> delete_subscription_and_redirect(subscription)
  end
end
