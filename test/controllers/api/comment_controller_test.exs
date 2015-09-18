defmodule Constable.Api.CommentControllerTest do
  import Ecto.Query
  use Constable.ConnCase

  alias Constable.Comment

  defmodule FakeCommentMailer do
    def created(comment, users) do
      send self, {:comment, comment}
      send self, {:users, users}
    end

    def mentioned(_, _), do: nil
  end

  setup do
    {:ok, authenticate}
  end

  test "#create creates a comment for user and announcement", %{conn: conn, user: user} do
    Pact.override self, :comment_mailer, FakeCommentMailer

    announcement = create(:announcement)
    user |> with_subscription(announcement)

    conn = post conn, comment_path(conn, :create), comment: %{
      body: "Foo",
      announcement_id: announcement.id
    }

    assert json_response(conn, 201)
    comment = Repo.one(Comment)
    assert comment.body == "Foo"
    assert comment.user_id == user.id
    assert comment.announcement_id == announcement.id
    assert_received {:users, [user]}
  end
end
