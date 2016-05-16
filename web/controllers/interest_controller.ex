defmodule Constable.InterestController do
  use Constable.Web, :controller

  alias Constable.{Announcement, Interest}

  def index(conn, _params) do
    conn
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> assign(:interests, all_interests)
    |> render("index.html")
  end

  def show(conn, %{"param" => param}) do
    interest = get_interest_by_id_or_name(param)

    conn
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> assign(:announcements, sorted_announcements(interest))
    |> assign(:interest, interest)
    |> render("show.html")
  end

  defp get_interest_by_id_or_name(param) do
    case Integer.parse(param) do
      :error -> Repo.get_by!(Interest, name: param)
      {id, _} -> Repo.get!(Interest, id)
    end
  end

  defp preload_interests(user) do
    Repo.preload user, :interests
  end

  defp all_interests do
    Repo.all Interest.ordered_by_name
  end

  defp sorted_announcements(interest) do
    Ecto.assoc(interest, :announcements)
    |> Announcement.last_discussed_first
    |> Announcement.with_announcement_list_assocs
    |> Repo.all
  end
end
