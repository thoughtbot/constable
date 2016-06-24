defmodule Constable.Controllers.UnsubscribeHelpers do
  import Constable.Gettext
  import Constable.Router.Helpers
  import Ecto.Query
  import Phoenix.Controller

  alias Constable.Repo
  alias Constable.Subscription

  def delete_subscription_and_redirect(conn, subscription) do
    if subscription do
      Repo.delete(subscription)

      conn
      |> put_flash(:info, gettext("You've been unsubscribed from this announcement."))
      |> redirect(to: announcement_path(conn, :show, subscription.announcement_id))
    else
      conn
      |> put_flash(:info, gettext("You've already unsubscribed from this announcement."))
      |> redirect(to: announcement_path(conn, :index))
    end
  end

  def subscription_with_announcement do
    Subscription |> preload(:announcement)
  end
end
