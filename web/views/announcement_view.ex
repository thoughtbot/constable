defmodule Constable.AnnouncementView do
  use Constable.Web, :view
  alias Constable.Repo
  alias Constable.CommentView
  alias Constable.InterestView
  alias Constable.UserView

  def render("index.json", %{announcements: announcements}) do
    %{announcements: render_many(announcements, __MODULE__, "show.json")}
  end

  def render("show.json", %{announcement: announcement}) do
    announcement = announcement |> Repo.preload([:comments, :user, :interests])
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: render_one(announcement.user, UserView, "show.json"),
      comments: render_many(announcement.comments, CommentView, "show.json"),
      interests: render_many(announcement.interests, InterestView, "name.json"),
      inserted_at: announcement.inserted_at,
      updated_at: announcement.updated_at
    }
  end
end
