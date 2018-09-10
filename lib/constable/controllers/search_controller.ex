defmodule ConstableWeb.SearchController do
  use Constable.Web, :controller

  alias Constable.Announcement

  def show(conn, params) do
    announcements = matching_announcements(params) |> Repo.paginate(params)

    conn
    |> assign(:announcements, announcements.entries)
    |> assign(:search_page, announcements)
    |> assign(:query, params["query"])
    |> page_title("Results for '#{params["query"]}'")
    |> render("new.html")
  end

  def new(conn, _params) do
    render conn, "new.html", announcements: []
  end

  defp matching_announcements(params = %{"query" => search_terms}) do
    excluded_interests = params["exclude_interests"] || []

    Announcement.search(search_terms, exclude_interests: excluded_interests)
    |> Announcement.last_discussed_first
    |> Announcement.with_announcement_list_assocs
  end
end
