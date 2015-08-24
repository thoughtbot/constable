defmodule Constable.Api.CommentControllerTest do
  import Ecto.Query
  use Constable.ConnCase

  alias Constable.Comment

  setup do
    {:ok, authenticate}
  end

  test "#create creates a comment for user and announcement", %{conn: conn, user: user} do
    announcement = Forge.saved_announcement(Repo, user_id: user.id)

    post conn, comment_path(conn, :create), comment: %{
      body: "Foo",
      announcement_id: announcement.id
    }

    comment = Repo.one(Comment)
    assert comment.body == "Foo"
    assert comment.user_id == user.id
    assert comment.announcement_id == announcement.id
  end
end
