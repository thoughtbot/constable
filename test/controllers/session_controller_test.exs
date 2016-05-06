defmodule Constable.SessionControllerTest do
  use Constable.ConnCase, async: true

  setup do
    {:ok, browser_authenticate}
  end

  test "when authenticated redirect to announcements", %{conn: conn} do
    conn = get conn, session_path(conn, :new)

    assert redirected_to(conn) == announcement_path(conn, :index)
  end

  test "redirects to the original request path and removes it from the session" do
    announcement_path = announcement_path(conn, :show, insert(:announcement))
    conn = conn(:get, "/")
      |> assign(:current_user, build(:user))
      |> with_session(original_request_path: announcement_path)
      |> Constable.Router.call(Constable.Router.init([]))

    assert redirected_to(conn) == announcement_path
    refute get_session(conn, :original_request_path)
  end

  test "when not authenticated render login" do
    conn = get conn, session_path(conn, :new)

    assert html_response(conn, :ok) =~ "Sign in"
  end
end
