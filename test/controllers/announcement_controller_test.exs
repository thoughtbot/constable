defmodule Constable.AnnouncementControllerTest do
  use Constable.ConnCase

  setup do
    {:ok, browser_authenticate}
  end

  test "all announcements are shown when query param all is set", %{conn: conn, user: user} do
    create(:announcement, title: "Awesome", user: user)
    create(:announcement, title: "Lame", user: user)

    conn = get conn, announcement_path(conn, :index, all: true)

    assert html_response(conn, :ok) =~ "Awesome"
    assert html_response(conn, :ok) =~ "Lame"
  end

  test "only my announcements are shown by default", %{conn: conn, user: user} do
    my_interest = create(:interest)
    create(:user_interest, user: user, interest: my_interest)
    create(:announcement, title: "Shows up") |> tag_with_interest(my_interest)
    _announcement_with_no_matching_interest = create(:announcement, title: "Does not show up")

    conn = get conn, announcement_path(conn, :index)

    assert html_response(conn, :ok) =~ "Shows up"
    refute html_response(conn, :ok) =~ "Does not show up"
  end
end
