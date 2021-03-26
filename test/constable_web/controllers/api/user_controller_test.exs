defmodule ConstableWeb.Api.UserControllerTest do
  use ConstableWeb.ConnCase, async: true
  alias Constable.User

  setup do
    {:ok, api_authenticate()}
  end

  test "#create creates a user", %{conn: conn} do
    name = "Ian D. Anderson"
    email = "ian@thoughtbot.com"

    json_response =
      conn
      |> post(Routes.api_user_path(conn, :create),
        user: %{name: name, email: email}
      )
      |> json_response(200)

    user = Repo.get_by!(User, email: "ian@thoughtbot.com", username: "ian")
    assert user.name == name
    assert user.email == email
    assert %{"user" => %{"name" => ^name, "username" => "ian"}} = json_response
  end

  test "#create doesn't create a user with invalid data", %{conn: conn} do
    Repo.delete_all(User)

    conn =
      post conn, Routes.api_user_path(conn, :create),
        user: %{
          name: "",
          email: ""
        }

    assert json_response(conn, :unprocessable_entity)
    refute Repo.one(User)
  end

  test "#index returns all users", %{conn: conn, user: user} do
    other_user = insert(:user, name: "Aaron")

    conn = get(conn, Routes.api_user_path(conn, :index))

    ids = fetch_json_ids("users", conn)
    assert ids == [other_user.id, user.id]
  end

  test "#show returns user", %{conn: conn} do
    user = insert(:user)

    conn = get(conn, Routes.api_user_path(conn, :show, user.id))

    assert json_response(conn, 200)["user"]["id"] == user.id
  end

  test "#show returns current user when id is me", %{conn: conn, user: user} do
    conn = get(conn, Routes.api_user_path(conn, :show, "me"))

    assert json_response(conn, 200)["user"]["id"] == user.id
  end

  test "#update updates the current user", %{conn: conn, user: user} do
    conn =
      put conn, Routes.api_user_path(conn, :update),
        user: %{
          daily_digest: false,
          auto_subscribe: false,
          name: "Ian Justin"
        }

    assert json_response(conn, 200)["user"]["id"] == user.id
    assert json_response(conn, 200)["user"]["name"] == "Ian Justin"
    assert json_response(conn, 200)["user"]["daily_digest"] == false
  end
end
