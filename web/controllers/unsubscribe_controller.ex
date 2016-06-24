defmodule Constable.UnsubscribeController do
  use Constable.Web, :controller
  import Constable.Controllers.UnsubscribeHelpers

  def show(conn, %{"id" => token}) do
    subscription = Repo.get_by(subscription_with_announcement, token: token)

    conn |> delete_subscription_and_redirect(subscription)
  end
end
