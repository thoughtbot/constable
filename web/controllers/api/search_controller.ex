defmodule Constable.Api.SearchController do
  use Constable.Web, :controller

  plug :put_view, Constable.Api.AnnouncementView

  alias Constable.Announcement

  def create(conn, %{"query" => search_terms}) do
    announcements = Announcement.search(search_terms) |> Repo.all
    render(conn, "index.json", announcements: announcements)
  end
end
