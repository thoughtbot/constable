defmodule Constable.SearchController do
  use Constable.Web, :controller

  alias Constable.Announcement

  def show(conn, %{"query" => search_terms} = params) do
    conn
    |> assign(:announcements, matching_announcements(search_terms, page_number(params["page"])))
    |> assign(:page_number, page_number(params["page"]))
    |> assign(:query, search_terms)
    |> render("new.html")
  end

  def new(conn, _params) do
    render conn, "new.html", announcements: []
  end

  defp matching_announcements(search_terms, page) do
    Announcement.search(search_terms)
    |> Announcement.last_discussed_first
    |> Announcement.with_announcement_list_assocs
    |> Announcement.paginate(page)
    |> Repo.all
  end
end
