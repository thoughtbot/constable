defmodule Constable.AnnouncementView do
  use Constable.Web, :view
  alias Constable.Repo

  def render("index.json", %{announcements: announcements}) do
    %{announcements: render_many(announcements, "show.json")}
  end

  def render("show.json", %{announcement: announcement}) do
    announcement = announcement |> Repo.preload([:comments, :user, :interests])
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: render_one(announcement.user, "show.json"),
      comments: render_many(announcement.comments, "show.json"),
      interests: render_many(announcement.interests, "name.json"),
      inserted_at: announcement.inserted_at,
      updated_at: announcement.updated_at
    }
  end
end
