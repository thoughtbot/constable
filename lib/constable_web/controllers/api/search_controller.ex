defmodule ConstableWeb.Api.SearchController do
  use Constable.Web, :controller

  plug :put_view, ConstableWeb.Api.AnnouncementView

  alias Constable.Announcement

  def create(conn, params = %{"query" => search_terms}) do
    excludes = params["exclude_interests"] || []

    announcements =
      search_terms
      |> Announcement.search(exclude_interests: excludes)
      |> Repo.all
    render(conn, "index.json", announcements: announcements)
  end
end
