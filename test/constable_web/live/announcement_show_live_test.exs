defmodule ConstableWeb.AnnouncementShowLiveTest do
  use ConstableWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  alias ConstableWeb.AnnouncementShowLive

  test "renders the announcement", %{conn: conn} do
    announcement = insert(:announcement)
    user = insert(:user)
    session = %{"id" => announcement.id, "current_user_id" => user.id}

    {:ok, view, html} = live_isolated(conn, AnnouncementShowLive, session: session)

    assert html =~ announcement.body
    assert render(view) =~ announcement.body
  end

  test "user can create a new comment", %{conn: conn} do
    announcement = insert(:announcement)
    user = insert(:user)
    session = %{"id" => announcement.id, "current_user_id" => user.id}

    {:ok, view, _html} = live_isolated(conn, AnnouncementShowLive, session: session)

    view
    |> form("#new-comment", comment: %{body: "This is great!"})
    |> render_submit()

    assert has_element?(view, ".comment-body", "This is great!")
  end

  test "renders error if comment cannot be created", %{conn: conn} do
    announcement = insert(:announcement)
    user = insert(:user)
    session = %{"id" => announcement.id, "current_user_id" => user.id}

    {:ok, view, _html} = live_isolated(conn, AnnouncementShowLive, session: session)

    rendered =
      view
      |> form("#new-comment", comment: %{body: nil})
      |> render_submit()

    assert rendered =~ "Comment was invalid"
  end

  test "commenting automatically subscribes user to announcement", %{conn: conn} do
    announcement = insert(:announcement)
    user = insert(:user)
    session = %{"id" => announcement.id, "current_user_id" => user.id}

    {:ok, view, _html} = live_isolated(conn, AnnouncementShowLive, session: session)

    view
    |> form("#new-comment", comment: %{body: "This is great!"})
    |> render_submit()

    assert has_element?(view, "[data-role='subscription-button']", "Subscribed to thread")
  end

  test "user can see new comments in real-time", %{conn: conn} do
    announcement = insert(:announcement)
    user = insert(:user)
    session = %{"id" => announcement.id, "current_user_id" => user.id}

    {:ok, view, _html} = live_isolated(conn, AnnouncementShowLive, session: session)

    comment = insert(:comment, announcement: announcement)
    Constable.PubSub.broadcast_new_comment(comment)

    assert has_element?(view, ".comment-body", comment.body)
  end
end
