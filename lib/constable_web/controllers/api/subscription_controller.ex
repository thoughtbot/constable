defmodule ConstableWeb.Api.SubscriptionController do
  use Constable.Web, :controller

  alias Constable.Subscription

  def index(conn, _params) do
    current_user = current_user(conn)
    subscriptions = subscriptions_for(current_user)

    render conn, "index.json", subscriptions: subscriptions
  end

  def create(conn, %{"subscription" => params}) do
    current_user = current_user(conn)
    params = params |> Map.put("user_id", current_user.id)

    changeset = Subscription.changeset(params)

    case Repo.insert(changeset) do
      {:ok, subscription} ->
        conn |> put_status(201) |> render("show.json", subscription: subscription)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(ConstableWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = current_user(conn)
    subscription = Repo.get!(Subscription, id)

    if current_user.id == subscription.user_id do
      Repo.delete!(subscription)
      send_resp(conn, 204, "")
    else
      unauthorized(conn)
    end
  end

  defp subscriptions_for(user) do
    Repo.all Ecto.assoc(user, :subscriptions)
  end
end
