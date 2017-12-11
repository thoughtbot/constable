defmodule ConstableWeb.SubscriptionController do
  use Constable.Web, :controller

  alias Constable.Subscription

  def create(conn, %{"announcement_id" => announcement_id}) do
    changeset = Subscription.changeset(%{
      announcement_id: announcement_id,
      user_id: conn.assigns.current_user.id,
    })

    Repo.insert!(changeset)

    send_resp(conn, :no_content, "")
  end

  def delete(conn, %{"announcement_id" => announcement_id}) do
    subscription = Repo.get_by(Subscription,
      announcement_id: announcement_id,
      user_id: conn.assigns.current_user.id,
    )

    Repo.delete!(subscription)
    send_resp(conn, :no_content, "")
  end
end
