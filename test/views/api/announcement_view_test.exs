defmodule Constable.Api.AnnouncementViewTest do
  use Constable.ViewCase, async: true
  alias Constable.Api.AnnouncementView

  test "show.json returns correct fields" do
    user = Forge.user
    interest = Forge.interest
    announcement = Forge.announcement(user: user, interests: [interest])
    comment = Forge.comment(announcement: announcement, user: user)
    announcement = Map.put(announcement, :comments, [comment])

    rendered_announcement = render_one(announcement, AnnouncementView, "show.json")

    assert rendered_announcement == %{
      data: %{
        id: announcement.id,
        title: announcement.title,
        body: announcement.body,
        inserted_at: announcement.inserted_at,
        updated_at: announcement.updated_at,
        user: announcement.user_id,
        comments: [comment.id],
        interests: [interest.id],
      }
    }
  end
end
