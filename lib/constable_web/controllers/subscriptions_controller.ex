defmodule ConstableWeb.SubscriptionController do
  use ConstableWeb, :controller

  alias Constable.Subscription

  plug Constable.Plugs.Deslugifier, slugified_key: "announcement_id"

  def create(conn, %{"announcement_id" => announcement_id}) do
    changeset = Subscription.changeset(%{
      announcement_id: announcement_id,
      user_id: conn.assigns.current_user.id,
    })

    Repo.insert!(changeset)

    redirect(conn, to: Routes.announcement_path(conn, :show, announcement_id))
  end

  def delete(conn, %{"announcement_id" => announcement_id}) do
    subscription = Repo.get_by(Subscription,
      announcement_id: announcement_id,
      user_id: conn.assigns.current_user.id
    )

    Repo.delete!(subscription)
    redirect(conn, to: Routes.announcement_path(conn, :show, announcement_id))
  end
end
