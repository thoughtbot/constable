defmodule Constable.Api.UserControllerTest do
  use Constable.ConnCase

  setup do
    {:ok, authenticate}
  end

  test "#index returns all users", %{conn: conn, user: user} do
    other_user = create(:user)

    conn = get conn, user_path(conn, :index)

    ids = fetch_json_ids("users", conn)
    assert ids == [user.id, other_user.id]
  end

  test "#show returns user", %{conn: conn} do
    user = create(:user)

    conn = get conn, user_path(conn, :show, user.id)

    assert json_response(conn, 200)["user"]["id"] == user.id
  end

  test "#show returns current user when id is me", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, "me")

    assert json_response(conn, 200)["user"]["id"] == user.id
  end

  test "#update updates the current user", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update), user: %{
      daily_digest: false,
      auto_subscribe: false
    }

    assert json_response(conn, 200)["user"]["id"] == user.id
    assert json_response(conn, 200)["user"]["daily_digest"] == false
  end
end
