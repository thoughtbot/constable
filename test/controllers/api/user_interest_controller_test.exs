defmodule Constable.Api.UserInterestControllerTest do
  use Constable.ConnCase

  setup do
    {:ok, authenticate}
  end

  test "#index returns current users user_interests", %{conn: conn, user: user} do
    Forge.saved_user_interest(Repo, id: 1, user_id: user.id)
    Forge.saved_user_interest(Repo, id: 2, user_id: user.id)
    conn = get conn, user_interest_path(conn, :index)

    json_response(conn, 200)["user_interests"]
    ids = fetch_json_ids("user_interests", conn)

    assert ids == [1, 2]
  end

  test "#show returns invidual interest", %{conn: conn} do
    user_interest = Forge.saved_user_interest(Repo, id: 2)
    conn = get conn, user_interest_path(conn, :show, user_interest.id)

    assert json_response(conn, 200)["user_interest"]["id"] == user_interest.id
  end

  test "#destroy destroys a user interest", %{conn: conn, user: user} do
    user_interest = Forge.saved_user_interest(Repo, id: 2, user_id: user.id)
    conn = delete conn, user_interest_path(conn, :delete, user_interest.id)

    assert response(conn, 204)
  end

  test "#destroy only allows current user to destroy user interest", %{conn: conn} do
    other_user = Forge.saved_user(Repo)
    user_interest = Forge.saved_user_interest(Repo, id: 2, user_id: other_user.id)
    conn = delete conn, user_interest_path(conn, :delete, user_interest.id)

    assert response(conn, 401)
  end
end
