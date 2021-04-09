defmodule ConstableWeb.AnnouncementLive.ShowTest do
  use ConstableWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup do
    {:ok, browser_authenticate()}
  end

  test "renders the announcement", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, html} = live(conn, Routes.live_announcement_path(conn, :show, announcement))

    assert html =~ announcement.body
    assert render(view) =~ announcement.body
  end

  test "user can create a new comment", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, _html} = live(conn, Routes.live_announcement_path(conn, :show, announcement))

    view
    |> form("#new-comment", comment: %{body: "This is great!"})
    |> render_submit()

    assert has_element?(view, ".comment-body", "This is great!")
  end

  test "renders error if comment cannot be created", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, _html} = live(conn, Routes.live_announcement_path(conn, :show, announcement))

    rendered =
      view
      |> form("#new-comment", comment: %{body: nil})
      |> render_submit()

    assert rendered =~ "Comment was invalid"
  end

  test "commenting automatically subscribes user to announcement", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, _html} = live(conn, Routes.live_announcement_path(conn, :show, announcement))

    view
    |> form("#new-comment", comment: %{body: "This is great!"})
    |> render_submit()

    assert has_element?(view, "[data-role='subscription-button']", "Subscribed to thread")
  end

  test "user can see new comments in real-time", %{conn: conn} do
    announcement = insert(:announcement)

    {:ok, view, _html} = live(conn, Routes.live_announcement_path(conn, :show, announcement))

    comment = insert(:comment, announcement: announcement)
    Constable.PubSub.broadcast_new_comment(comment)

    assert has_element?(view, ".comment-body", comment.body)
  end
end
