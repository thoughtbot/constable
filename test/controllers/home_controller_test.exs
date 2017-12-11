defmodule ConstableWeb.HomeControllerTest do
  use ConstableWeb.ConnCase, async: true

  setup do
    {:ok, browser_authenticate()}
  end

  test "when authenticated redirect to announcements", %{conn: conn} do
    conn = get conn, home_path(conn, :index)

    assert redirected_to(conn) == announcement_path(conn, :index)
  end

  test "redirects to the original request path and removes it from the session" do
    conn = build_conn(:get, "/")
      |> assign(:current_user, build(:user))
      |> with_session(original_request_path: search_path(build_conn(), :new))
      |> ConstableWeb.Router.call(ConstableWeb.Router.init([]))

    assert redirected_to(conn) == search_path(conn, :new)
    refute get_session(conn, :original_request_path)
  end
end
