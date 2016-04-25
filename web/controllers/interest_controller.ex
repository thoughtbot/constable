defmodule Constable.InterestController do
  use Constable.Web, :controller

  alias Constable.Interest

  def index(conn, _params) do
    conn
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> assign(:interests, all_interests)
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    interest = Repo.get!(Interest.with_announcements, id)
    render conn, "show.html", interest: interest
  end

  defp preload_interests(user) do
    Repo.preload user, :interests
  end

  defp all_interests do
    Repo.all Interest.ordered_by_name
  end
end
