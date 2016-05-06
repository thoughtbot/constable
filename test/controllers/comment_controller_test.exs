defmodule Constable.CommentControllerTest do
  use Constable.ConnCase
  use Bamboo.Test

  alias Constable.Comment

  setup do
    {:ok, browser_authenticate}
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
end
