defmodule ConstableWeb.AnnouncementControllerTest do
  use ConstableWeb.ConnCase, async: true

  alias Constable.Announcement

  setup do
    {:ok, browser_authenticate()}
  end

  test "#index all announcements are shown when query param all is set", %{conn: conn, user: user} do
    insert(:announcement, title: "Awesome", user: user)
    insert(:announcement, title: "Lame", user: user)

    conn = get conn, announcement_path(conn, :index, all: true)

    assert html_response(conn, :ok) =~ "Awesome"
    assert html_response(conn, :ok) =~ "Lame"
  end

  test "#index only my announcements are shown by default", %{conn: conn, user: user} do
    my_interest = insert(:interest)
    insert(:user_interest, user: user, interest: my_interest)
    insert(:announcement, title: "Shows up") |> tag_with_interest(my_interest)
    _announcement_with_no_matching_interest = insert(:announcement, title: "Does not show up")

    conn = get conn, announcement_path(conn, :index)

    assert html_response(conn, :ok) =~ "Shows up"
    refute html_response(conn, :ok) =~ "Does not show up"
  end

  test "#show renders markdown as html", %{conn: conn} do
    announcement = insert(:announcement, body: "# Hello")

    conn = get conn, announcement_path(conn, :show, announcement.id)

    assert html_response(conn, :ok) =~ "<h1>Hello</h1>"
  end

  test "#show renders comments as html", %{conn: conn} do
    announcement = insert(:announcement)
    insert(:comment, body: "# Comment", announcement: announcement)

    conn = get conn, announcement_path(conn, :show, announcement.id)

    assert html_response(conn, :ok) =~ "<h1>Comment</h1>"
  end

  test "comments on show page have an edit link if current user is the author", %{conn: conn, user: user} do
    comment = insert(:comment, user: user)

    conn = get conn, announcement_path(conn, :show, comment.announcement.id)

    assert html_response(conn, :ok) =~ "(edit)"
  end

  test "comments on show page do not have an edit link if another user is the author", %{conn: conn} do
    another_user = insert(:user)
    comment = insert(:comment, user: another_user)

    conn = get conn, announcement_path(conn, :show, comment.announcement.id)

    refute html_response(conn, :ok) =~ "(edit)"
  end

  test "#create splits interests by ,", %{conn: conn} do
    post conn, announcement_path(conn, :create), announcement: %{
      title: "Hello world",
      interests: "everyone, boston",
      body: "# Hello"
    }

    interest_names = Repo.one!(Announcement)
      |> Ecto.assoc(:interests)
      |> Ecto.Query.select([a], a.name)
      |> Ecto.Query.order_by([a], a.name)
      |> Repo.all

    assert interest_names == ["boston", "everyone"]
  end
end
