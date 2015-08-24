defmodule Constable.Api.UserControllerTest do
  use Constable.ConnCase

  setup do
    {:ok, authenticate}
  end

  test "#index returns all users", %{conn: conn, user: user} do
    other_user = Forge.saved_user(Repo)
    conn = get conn, user_path(conn, :index)

    json_response(conn, 200)["data"]
    ids = fetch_json_ids(conn)

    assert ids == [user.id, other_user.id]
  end

  test "#show returns user", %{conn: conn} do
    user = Forge.saved_user(Repo)
    conn = get conn, user_path(conn, :show, user.id)

    assert json_response(conn, 200)["data"]["id"] == user.id
  end

  test "#show returns current user when id is me", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user.id)

    assert json_response(conn, 200)["data"]["id"] == user.id
  end
end
