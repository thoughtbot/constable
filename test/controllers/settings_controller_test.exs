defmodule ConstableWeb.SettingsControllerTest do
  use ConstableWeb.ConnCase, async: true

  alias Constable.User

  setup do
    {:ok, browser_authenticate()}
  end

  test "show renders the settings form" , %{conn: conn} do
    conn = get conn, settings_path(conn, :show)

    assert html_response(conn, :ok)
  end

  test "#update updates user attributes" do
    user = insert(:user, name: "Joe Dirt", auto_subscribe: true, daily_digest: true)
    %{conn: conn, user: user} = browser_authenticate(user)

    put conn, settings_path(conn, :update), user: %{
      auto_subscribe: false,
      daily_digest: false,
      name: "Roger Murdoch",
    }

    user = Repo.get(User, user.id)
    assert user.name == "Roger Murdoch"
    refute user.auto_subscribe
    refute user.daily_digest
  end
end
