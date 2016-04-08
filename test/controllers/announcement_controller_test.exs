defmodule Constable.AnnouncementControllerTest do
  use Constable.ConnCase

  setup do
    {:ok, browser_authenticate}
  end

  test "announcements are rendered on page", %{conn: conn, user: user} do
    create(:announcement, title: "Awesome", user: user)
    create(:announcement, title: "Lame", user: user)

    conn = get conn, announcement_path(conn, :index)

    assert html_response(conn, :ok) =~ "Awesome"
    assert html_response(conn, :ok) =~ "Lame"
  end
end
