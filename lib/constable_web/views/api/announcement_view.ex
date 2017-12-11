defmodule ConstableWeb.Api.AnnouncementView do
  use Constable.Web, :view

  alias ConstableWeb.Api.CommentView

  def render("index.json", %{announcements: announcements}) do
    announcements = announcements |> Repo.preload([:comments, :interests])
    %{
      announcements: render_many(announcements, __MODULE__, "announcement.json"),
    }
  end

  def render("show.json", %{announcement: announcement}) do
    announcement = announcement |> Repo.preload([:comments, :interests])
    %{announcement: render_one(announcement, __MODULE__, "announcement.json")}
  end

  def render("announcement.json", %{announcement: announcement}) do
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      inserted_at: announcement.inserted_at,
      updated_at: announcement.updated_at,
      user_id: announcement.user_id,
      comments: render_many(announcement.comments, CommentView, "comment.json"),
      interest_ids: pluck(announcement.interests, :id),
      url: ConstableWeb.Router.Helpers.announcement_url(ConstableWeb.Endpoint, :show, announcement)
    }
  end
end
