defmodule ConstableWeb.Api.UserInterestControllerTest do
  use ConstableWeb.ConnCase, async: true

  @view ConstableWeb.Api.UserInterestView

  setup do
    {:ok, api_authenticate()}
  end

  test "#index returns current users user_interests", %{conn: conn, user: user} do
    user_interests = insert_pair(:user_interest, user: user)

    conn = get conn, api_user_interest_path(conn, :index)

    assert json_response(conn, 200) == render_json("index.json", user_interests: user_interests)
  end

  test "#show returns invidual interest", %{conn: conn} do
    user_interest = insert(:user_interest)

    conn = get conn, api_user_interest_path(conn, :show, user_interest.id)

    assert json_response(conn, 200) == render_json("show.json", user_interest: user_interest)
  end

  test "#destroy destroys a user's interest", %{conn: conn, user: user} do
    user_interest = insert(:user_interest, user: user)

    conn = delete conn, api_user_interest_path(conn, :delete, user_interest.id)

    assert response(conn, 204)
  end

  test "#destroy only allows current user to destroy user interest", %{conn: conn} do
    other_user = insert(:user)
    user_interest = insert(:user_interest, user: other_user)

    conn = delete conn, api_user_interest_path(conn, :delete, user_interest.id)

    assert response(conn, 401)
  end
end
