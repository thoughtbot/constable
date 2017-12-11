defmodule ConstableWeb.Api.AnnouncementViewTest do
  use ConstableWeb.ViewCase, async: true

  alias ConstableWeb.Api.AnnouncementView
  alias ConstableWeb.Api.CommentView

  test "show.json returns correct fields" do
    interest = insert(:interest)
    announcement = insert(:announcement) |> tag_with_interest(interest)
    comment = insert(:comment, announcement: announcement)

    rendered_announcement = render_one(announcement, AnnouncementView, "show.json")

    assert rendered_announcement == %{
      announcement: %{
        id: announcement.id,
        title: announcement.title,
        body: announcement.body,
        inserted_at: announcement.inserted_at,
        updated_at: announcement.updated_at,
        user_id: announcement.user_id,
        comments: render_many([comment], CommentView, "comment.json"),
        interest_ids: [interest.id],
        url: "http://localhost:4001/announcements/#{announcement.id}",
      }
    }
  end
end
