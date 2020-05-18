defmodule ConstableWeb.Api.AnnouncementView do
  use ConstableWeb, :view

  alias ConstableWeb.Api.CommentView
  alias ConstableWeb.Api.InterestView
  alias ConstableWeb.Api.UserView

  def render("index.json", %{announcements: announcements}) do
    announcements = announcements |> Repo.preload([:comments, :interests])

    %{
      announcements: render_many(announcements, __MODULE__, "announcement.json")
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
      last_discussed_at: announcement.last_discussed_at,
      updated_at: announcement.updated_at,
      user: render_one(announcement.user, UserView, "author.json"),
      comments: render_many(announcement.comments, CommentView, "comment.json"),
      interests: render_many(announcement.interests, InterestView, "interest.json"),
      url:
        ConstableWeb.Router.Helpers.announcement_url(ConstableWeb.Endpoint, :show, announcement)
    }
  end
end
