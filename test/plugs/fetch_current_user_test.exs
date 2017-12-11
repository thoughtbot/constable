defmodule Constable.Plugs.FetchCurrentUserTest do
  use ConstableWeb.ConnCase

  test "active user is assigned to current_user assigns on conn" do
    user = insert(:user, active: true)
    token = Constable.UserIdentifier.sign_user_id(ConstableWeb.Endpoint, user.id)
    conn = build_conn()
      |> bypass_through
      |> Phoenix.ConnTest.put_req_cookie("user_id", token)
      |> with_session
      |> get("/")
      |> run_plug

    assert conn.assigns[:current_user]
  end

  test "inactive user is not assigned to current_user assigns on conn" do
    user = insert(:user, active: false)
    token = Constable.UserIdentifier.sign_user_id(ConstableWeb.Endpoint, user.id)
    conn = build_conn()
      |> bypass_through
      |> Phoenix.ConnTest.put_req_cookie("user_id", token)
      |> with_session
      |> get("/")
      |> run_plug

    refute conn.assigns[:current_user]
  end

  defp run_plug(conn) do
    conn |> Constable.Plugs.FetchCurrentUser.call(%{})
  end
end
