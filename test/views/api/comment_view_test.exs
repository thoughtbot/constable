defmodule Constable.Api.CommentViewTest do
  use Constable.ViewCase, async: true
  alias Constable.Api.CommentView

  test "show.json returns correct fields" do
    comment = insert(:comment)

    rendered_comment = render_one(comment, CommentView, "show.json")

    assert rendered_comment == %{
      comment: %{
        id: comment.id,
        body: comment.body,
        announcement_id: comment.announcement_id,
        user_id: comment.user_id,
        inserted_at: comment.inserted_at,
      }
    }
  end
end
