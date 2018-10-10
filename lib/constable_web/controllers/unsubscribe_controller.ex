defmodule ConstableWeb.UnsubscribeController do
  use ConstableWeb, :controller

  alias Constable.Subscription

  def show(conn, %{"id" => token}) do
    subscription = Repo.get_by(subscription_with_announcement(), token: token)

    if subscription do
      Repo.delete(subscription)

      conn
      |> put_flash(:info, gettext("You've been unsubscribed from this announcement."))
      |> redirect(to: Routes.announcement_path(conn, :show, subscription.announcement))
    else
      conn
      |> put_flash(:error, gettext("We could not unsubscribe you from the announcement."))
      |> redirect(to: Routes.announcement_path(conn, :index))
    end
  end

  defp subscription_with_announcement do
    Subscription |> preload(:announcement)
  end
end
