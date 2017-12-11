defmodule Constable.Plugs.RequireApiLoginTest do
  use ConstableWeb.ConnCase

  test "active user is assigned to current_user assigns on conn" do
    user = insert(:user, active: true)
    conn = build_conn()
      |> bypass_through
      |> put_req_header("authorization", user.token)
      |> run_plug

    assert conn.assigns[:current_user]
  end

  test "inactive user is not assigned to current_user assigns on conn" do
    user = insert(:user, active: false)
    conn = build_conn()
      |> bypass_through
      |> put_req_header("authorization", user.token)
      |> run_plug

    refute conn.assigns[:current_user]
  end

  defp run_plug(conn) do
    conn |> Constable.Plugs.RequireApiLogin.call(%{})
  end
end
