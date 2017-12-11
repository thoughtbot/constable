defmodule ConstableWeb.SessionControllerTest do
  use ConstableWeb.ConnCase, async: true

  setup do
    {:ok, browser_authenticate()}
  end

  test "when authenticated redirect to home", %{conn: conn} do
    conn = get conn, session_path(conn, :new)

    assert redirected_to(conn) == home_path(conn, :index)
  end

  test "when not authenticated render login" do
    conn = build_conn()

    conn = get conn, session_path(conn, :new)

    assert html_response(conn, :ok) =~ "Sign in"
  end

  test "delete logs user out and redirects to home", %{conn: conn} do
    conn = delete conn, session_path(conn, :delete)

    assert redirected_to(conn) == home_path(conn, :index)
    refute conn.cookies["user_id"]
  end
end
