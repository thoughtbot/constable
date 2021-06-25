defmodule ConstableWeb.AnnouncementLive.ShowTest do
  use ConstableWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup do
    {:ok, browser_authenticate()}
  end

  test "renders the announcement", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, html} = live(conn, Routes.announcement_path(conn, :show, announcement))

    assert html =~ announcement.body
    assert render(view) =~ announcement.body
  end

  test "renders markdown as html", %{conn: conn} do
    announcement = insert(:announcement, body: "# Hello")

    {:ok, view, html} = live(conn, Routes.announcement_path(conn, :show, announcement))

    assert html =~ "<h1>Hello</h1>"
    assert render(view) =~ "<h1>Hello</h1>"
  end

  test "user can create a new comment", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, _html} = live(conn, Routes.announcement_path(conn, :show, announcement))

    view
    |> form("#new-comment", comment: %{body: "This is great!"})
    |> render_submit()

    assert has_element?(view, ".comment-body", "This is great!")
  end

  test "user can create a comment by pressing meta + enter", %{conn: conn} do
    announcement = insert(:announcement)
    path = Routes.announcement_path(conn, :show, announcement)
    {:ok, view, _html} = live(conn, path)

    view
    |> element("#comment_body")
    |> render_keydown(%{
      "key" => "Enter",
      "metaKey" => true,
      "value" => "Hey a comment"
    })

    assert has_element?(view, ".comment-body", "Hey a comment")
  end

  test "user can create a comment by pressing ctrl + enter", %{conn: conn} do
    announcement = insert(:announcement)
    path = Routes.announcement_path(conn, :show, announcement)
    {:ok, view, _html} = live(conn, path)

    view
    |> element("#comment_body")
    |> render_keydown(%{
      "key" => "Enter",
      "ctrlKey" => true,
      "value" => "Hey a comment"
    })

    assert has_element?(view, ".comment-body", "Hey a comment")
  end

  test "renders error if comment cannot be created", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, _html} = live(conn, Routes.announcement_path(conn, :show, announcement))

    rendered =
      view
      |> form("#new-comment", comment: %{body: nil})
      |> render_submit()

    assert rendered =~ "Comment was invalid"
  end

  test "commenting automatically subscribes user to announcement", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, _html} = live(conn, Routes.announcement_path(conn, :show, announcement))

    view
    |> form("#new-comment", comment: %{body: "This is great!"})
    |> render_submit()

    assert has_element?(view, "[data-role='subscription-button']", "Subscribed to thread")
  end

  test "renders comments as html", %{conn: conn} do
    announcement = insert(:announcement)
    insert(:comment, body: "# Comment", announcement: announcement)

    {:ok, _view, html} = live(conn, Routes.announcement_path(conn, :show, announcement))

    assert html =~ "<h1>Comment</h1>"
  end

  test "comments have an edit link if current user is author", %{conn: conn, user: user} do
    comment = insert(:comment, user: user)

    {:ok, _view, html} = live(conn, Routes.announcement_path(conn, :show, comment.announcement))

    assert html =~ "(edit)"
  end

  test "comments do not have an edit link if another user is the author", %{conn: conn} do
    another_user = insert(:user)
    comment = insert(:comment, user: another_user)

    {:ok, _view, html} = live(conn, Routes.announcement_path(conn, :show, comment.announcement))

    refute html =~ "(edit)"
  end

  test "user can see new comments in real-time", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, _html} = live(conn, Routes.announcement_path(conn, :show, announcement))

    comment = insert(:comment, announcement: announcement)
    Constable.PubSub.broadcast_new_comment(comment)

    assert has_element?(view, ".comment-body", comment.body)
  end
end
