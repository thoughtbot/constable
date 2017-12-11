defmodule ConstableWeb.Api.UserControllerTest do
  use ConstableWeb.ConnCase, async: true
  alias Constable.User

  @view ConstableWeb.Api.UserView

  setup do
    {:ok, api_authenticate()}
  end

  test "#create creates a user", %{conn: conn} do
    name = "Ian D. Anderson"
    conn = post conn, api_user_path(conn, :create), user: %{
      name: name,
      email: "ian@thoughtbot.com"
    }

    user = Repo.get_by!(User, email: "ian@thoughtbot.com", username: "ian")
    assert json_response(conn, 200) == render_json("show.json", user: user)
  end

  test "#create doesn't create a user with invalid data", %{conn: conn} do
    Repo.delete_all(User)
    conn = post conn, api_user_path(conn, :create), user: %{
      name: "",
      email: ""
    }

    assert json_response(conn, :unprocessable_entity)
    refute Repo.one(User)
  end

  test "#index returns all users", %{conn: conn, user: user} do
    other_user = insert(:user, name: "Aaron")

    conn = get conn, api_user_path(conn, :index)

    ids = fetch_json_ids("users", conn)
    assert ids == [other_user.id, user.id]
  end

  test "#show returns user", %{conn: conn} do
    user = insert(:user)

    conn = get conn, api_user_path(conn, :show, user.id)

    assert json_response(conn, 200)["user"]["id"] == user.id
  end

  test "#show returns current user when id is me", %{conn: conn, user: user} do
    conn = get conn, api_user_path(conn, :show, "me")

    assert json_response(conn, 200)["user"]["id"] == user.id
  end

  test "#update updates the current user", %{conn: conn, user: user} do
    conn = put conn, api_user_path(conn, :update), user: %{
      daily_digest: false,
      auto_subscribe: false,
      name: "Ian Justin"
    }

    assert json_response(conn, 200)["user"]["id"] == user.id
    assert json_response(conn, 200)["user"]["name"] == "Ian Justin"
    assert json_response(conn, 200)["user"]["daily_digest"] == false
  end
end
