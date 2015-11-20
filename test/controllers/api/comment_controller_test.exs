defmodule Constable.Api.CommentControllerTest do
  import Ecto.Query
  use Constable.ConnCase

  alias Constable.Comment
  alias Bamboo.SentEmail
  alias Bamboo.Formatter

  setup do
    SentEmail.reset
    {:ok, authenticate}
  end

  test "#create creates a comment for user and announcement", %{conn: conn, user: user} do
    Pact.override self, :comment_mailer, FakeCommentMailer

    announcement = create(:announcement)
    subscribed_user = create(:user) |> with_subscription(announcement)

    conn = post conn, comment_path(conn, :create), comment: %{
      body: "Foo",
      announcement_id: announcement.id
    }

    assert json_response(conn, 201)
    comment = Repo.one(Comment)
    assert comment.body == "Foo"
    assert comment.user_id == user.id
    assert comment.announcement_id == announcement.id

    email = SentEmail.one
    assert email.to == Formatter.format_recipient([subscribed_user])
    assert email.subject =~ announcement.title
  end
end
