defmodule ConstableWeb.AnnouncementControllerTest do
  use ConstableWeb.ConnCase, async: true

  alias Constable.Announcement

  setup do
    {:ok, browser_authenticate()}
  end

  test "#index all announcements are shown when query param all is set", %{conn: conn, user: user} do
    insert(:announcement, title: "Awesome", user: user)
    insert(:announcement, title: "Great", user: user)

    conn = get(conn, Routes.announcement_path(conn, :index, all: true))

    assert html_response(conn, :ok) =~ "Awesome"
    assert html_response(conn, :ok) =~ "Great"
  end

  test "#index shows user's announcements when user_id is set", %{conn: conn, user: user} do
    other_user = insert(:user)
    insert(:announcement, title: "Awesome", user: user)
    insert(:announcement, title: "Do not show", user: other_user)

    response =
      conn
      |> get(Routes.announcement_path(conn, :index, user_id: user.id))
      |> html_response(:ok)

    assert response =~ "Awesome"
    refute response =~ "Do not show"
  end

  test(
    "#index shows Annoucements which have User's Comments when comment_user_id param is set",
    %{conn: conn, user: user}
  ) do
    other_user = insert(:user)

    announcement_with_user_comment =
      insert(:announcement, title: "FooBar with My Comment", user: other_user)

    announcement_without_user_comment =
      insert(:announcement, title: "FizzBuzz without My Comments", user: user)

    insert(
      :comment,
      body: "First! 👋",
      announcement: announcement_with_user_comment,
      user: user
    )

    insert(
      :comment,
      body: "word",
      announcement: announcement_without_user_comment,
      user: other_user
    )

    response =
      conn
      |> get(Routes.announcement_path(conn, :index, comment_user_id: user.id))
      |> html_response(:ok)

    assert response =~ "FooBar with My Comment"
    refute response =~ "FizzBuzz without My Comments"
  end

  test "#index only announcements of interest are shown by default", %{conn: conn, user: user} do
    my_interest = insert(:interest)
    insert(:user_interest, user: user, interest: my_interest)
    insert(:announcement, title: "Shows up") |> tag_with_interest(my_interest)
    _announcement_with_no_matching_interest = insert(:announcement, title: "Does not show up")

    conn = get(conn, Routes.announcement_path(conn, :index))

    assert html_response(conn, :ok) =~ "Shows up"
    refute html_response(conn, :ok) =~ "Does not show up"
  end

  test "#show renders markdown as html", %{conn: conn} do
    announcement = insert(:announcement, body: "# Hello")

    conn = get(conn, Routes.announcement_path(conn, :show, announcement))

    assert html_response(conn, :ok) =~ "<h1>Hello</h1>"
  end

  test "#show renders comments as html", %{conn: conn} do
    announcement = insert(:announcement)
    insert(:comment, body: "# Comment", announcement: announcement)

    conn = get(conn, Routes.announcement_path(conn, :show, announcement))

    assert html_response(conn, :ok) =~ "<h1>Comment</h1>"
  end

  test "comments on show page have an edit link if current user is the author", %{
    conn: conn,
    user: user
  } do
    comment = insert(:comment, user: user)

    conn = get(conn, Routes.announcement_path(conn, :show, comment.announcement))

    assert html_response(conn, :ok) =~ "(edit)"
  end

  test "comments on show page do not have an edit link if another user is the author", %{
    conn: conn
  } do
    another_user = insert(:user)
    comment = insert(:comment, user: another_user)

    conn = get(conn, Routes.announcement_path(conn, :show, comment.announcement))

    refute html_response(conn, :ok) =~ "(edit)"
  end

  test "#create splits interests by ,", %{conn: conn} do
    post conn, Routes.announcement_path(conn, :create),
      announcement: %{
        title: "Hello world",
        interests: "everyone, boston",
        body: "# Hello"
      }

    interest_names =
      Repo.one!(Announcement)
      |> Ecto.assoc(:interests)
      |> Ecto.Query.select([a], a.name)
      |> Ecto.Query.order_by([a], a.name)
      |> Repo.all()

    assert interest_names == ["boston", "everyone"]
  end

  test "#delete does not work for users who are not the owner of the announcement", %{conn: conn} do
    owner = insert(:user)
    announcement = insert(:announcement, user: owner)

    delete(conn, Routes.announcement_path(conn, :delete, announcement))

    assert Repo.one(Announcement)
  end

  test "#delete works for owner of the announcement", %{conn: conn, user: user} do
    announcement = insert(:announcement, user: user)

    delete(conn, Routes.announcement_path(conn, :delete, announcement))

    refute Repo.one(Announcement)
  end
end
