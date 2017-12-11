defmodule ConstableWeb.CommentControllerTest do
  use ConstableWeb.ConnCase, async: true
  use Bamboo.Test

  alias Constable.Comment

  setup do
    {:ok, browser_authenticate()}
  end

  test "#create creates the comment", %{conn: conn, user: user} do
    announcement = insert(:announcement)

    post conn, announcement_comment_path(conn, :create, announcement.id), comment: %{
      body: "Foo"
    }

    comment = Repo.one(Comment) |> Repo.preload([:user, announcement: :user])
    assert comment.body == "Foo"
    assert comment.user_id == user.id
    assert comment.announcement_id == announcement.id
  end

  test "#create redirects back to announcement", %{conn: conn} do
    announcement = insert(:announcement)

    conn = post conn, announcement_comment_path(conn, :create, announcement), comment: %{
      body: "Foo"
    }

    assert redirected_to(conn) =~ announcement_path(conn, :show, announcement)
  end

  test "#create redirects back to the announcement with flash on failure", %{conn: conn} do
    announcement = insert(:announcement)

    conn = post conn, announcement_comment_path(conn, :create, announcement), comment: %{
    }

    assert Phoenix.ConnTest.get_flash(conn, :error) =~ "invalid"
  end

  test "#update updates the comments if the current user is the author", %{conn: conn, user: user} do
    comment = insert(:comment, body: "not updated", user: user)

    conn = put conn, announcement_comment_path(conn, :update, comment.announcement, comment), comment: %{
      body: "updated body"
    }

    assert Repo.get_by!(Comment, body: "updated body")
    assert redirected_to(conn) == comment_on_announcement_page(conn, comment)
  end

  defp comment_on_announcement_page(conn, comment) do
    announcement_path(conn, :show, comment.announcement) <> "#comment-#{comment.id}"
  end

  test "#update does nothing if current user isn't the author", %{conn: conn} do
    another_user = insert(:user)
    comment = insert(:comment, body: "not updated", user: another_user)

    assert_error_sent :not_found, fn ->
      put conn, announcement_comment_path(conn, :update, comment.announcement, comment), comment: %{
        body: "updated body"
      }
    end
  end
end
