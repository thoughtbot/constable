defmodule ConstableWeb.UserActivationControllerTest do
  use ConstableWeb.ConnCase, async: true

  alias Constable.{Repo, User}

  setup do
    {:ok, browser_authenticate()}
  end

  test "GET index renders deactivate button when user is active", %{conn: conn} do
    insert(:user, active: true)
    resp = get(conn, user_activation_path(conn, :index))

    assert html_response(resp, 200) =~ "Deactivate"
  end

  test "GET index renders activate button when user is inactive", %{conn: conn} do
    insert(:user, active: false)
    resp = get(conn, user_activation_path(conn, :index))

    assert html_response(resp, 200) =~ "Activate"
  end

  test "PUT update toggles active flag on user", %{conn: conn} do
    user = insert(:user, active: false)

    put(conn, user_activation_path(conn, :update, user))
    user = Repo.get!(User, user.id)
    assert user.active

    put(conn, user_activation_path(conn, :update, user))
    user = Repo.get!(User, user.id)
    refute user.active
  end
end
