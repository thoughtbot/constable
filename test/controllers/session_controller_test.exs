defmodule Constable.SessionControllerTest do
  use Constable.ConnCase, async: true

  setup do
    {:ok, browser_authenticate}
  end

  test "when authenticated redirect to announcements", %{conn: conn} do
    conn = get conn, session_path(conn, :new)

    assert redirected_to(conn) == announcement_path(conn, :index)
  end

  test "when not authenticated render login" do
    conn = get conn, session_path(conn, :new)

    assert html_response(conn, :ok) =~ "Sign in"
  end
end
