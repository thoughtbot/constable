defmodule Constable.Api.AnnouncementView do
  use Constable.Web, :view

  def render("index.json", %{announcements: announcements}) do
    %{data: render_many(announcements, Constable.Api.AnnouncementView, "announcement.json")}
  end

  def render("show.json", %{announcement: announcement}) do
    %{data: render_one(announcement, Constable.Api.AnnouncementView, "announcement.json")}
  end

  def render("announcement.json", %{announcement: announcement}) do
    announcement = announcement |> Repo.preload([:comments, :interests])
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      inserted_at: announcement.inserted_at,
      updated_at: announcement.updated_at,
      user: announcement.user_id,
      comments: pluck(announcement.comments, :id),
      interests: pluck(announcement.interests, :id)
    }
  end
end
