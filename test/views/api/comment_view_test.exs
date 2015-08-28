defmodule Constable.Api.CommentViewTest do
  use Constable.ViewCase, async: true
  alias Constable.Api.CommentView

  test "show.json returns correct fields" do
    user = Forge.user
    announcement = Forge.announcement(user: user)
    comment = Forge.comment(announcement: announcement, user: user)

    rendered_comment = render_one(comment, CommentView, "show.json")

    assert rendered_comment == %{
      comment: %{
        id: comment.id,
        body: comment.body,
        announcement_id: announcement.id,
        user_id: user.id,
        inserted_at: comment.inserted_at,
      }
    }
  end
end
