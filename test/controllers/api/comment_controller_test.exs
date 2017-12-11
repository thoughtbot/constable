defmodule ConstableWeb.Api.CommentControllerTest do
  import Ecto.Query
  use ConstableWeb.ConnCase, async: true
  use Bamboo.Test
  alias Constable.Emails
  alias Constable.Comment

  setup do
    {:ok, api_authenticate()}
  end

  test "#create creates a comment for user and announcement", %{conn: conn, user: user} do
    announcement = insert(:announcement)
    subscribed_user = insert(:user) |> with_subscription(announcement)

    conn = post conn, api_comment_path(conn, :create), comment: %{
      body: "Foo",
      announcement_id: announcement.id
    }

    assert json_response(conn, 201)
    comment = Repo.one(Comment) |> Repo.preload([:user, announcement: :user])
    assert comment.body == "Foo"
    assert comment.user_id == user.id
    assert comment.announcement_id == announcement.id

    assert_delivered_email Emails.new_comment(comment, [subscribed_user])
  end
end
