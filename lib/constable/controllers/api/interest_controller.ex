defmodule ConstableWeb.Api.InterestController do
  use Constable.Web, :controller

  alias Constable.Interest
  alias ConstableWeb.Api.InterestView

  def index(conn, _params) do
    interests = Repo.all(Interest)

    render(conn, "index.json", interests: interests)
  end

  def show(conn, %{"id" => id}) do
    interest = Repo.get!(Interest, id)
    render conn, "show.json", interest: interest
  end

  def update(conn, %{"id" => id, "channel" => channel}) do
    interest = Repo.get!(Interest, id)
    case Repo.update(Interest.update_channel_changeset(interest, channel)) do
      {:ok, interest} ->
        ConstableWeb.Endpoint.broadcast!(
          "update",
          "interest:update",
          InterestView.render("show.json", %{interest: interest})
        )
        render(conn, "show.json", interest: interest)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ConstableWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
