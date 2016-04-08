defmodule Constable.AnnouncementController do
  use Constable.Web, :controller

  alias Constable.Announcement

  def index(conn, _params) do
    announcements = Repo.all(Announcement) |> Repo.preload(:interests)
    conn |> render("index.html", announcements: announcements)
  end
end
