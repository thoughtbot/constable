defmodule Constable.Plugs.RequireLoginTest do
  use Constable.PlugCase

  test "user is redirected when current_user is not set" do
    conn = conn() |> run_plug

    assert redirected_to(conn) == "/"
  end

  test "user passes through when current_user is set" do
    conn = conn() |> authenticate |> run_plug

    assert not_redirected?(conn)
  end

  defp not_redirected?(conn) do
    conn.status != 302
  end

  defp authenticate(conn) do
    conn |> assign(:current_user, %Constable.User{})
  end

  defp run_plug(conn) do
    conn |> Constable.Plugs.RequireLogin.call(%{})
  end
end
