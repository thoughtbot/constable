defmodule Constable.SearchController do
  use Constable.Web, :controller

  alias Constable.Announcement

  def new(conn, %{"query" => search_terms}) do
    announcements = Announcement.search(search_terms)
      |> Announcement.with_announcement_list_assocs
      |> Repo.all
    render conn, "new.html", announcements: announcements
  end

  def new(conn, _params) do
    render conn, "new.html", announcements: []
  end
end
