defmodule ConstableWeb.Api.InterestControllerTest do
  use ConstableWeb.ConnCase, async: true

  @view ConstableWeb.Api.InterestView

  setup do
    {:ok, api_authenticate()}
  end

  test "#index displays all interests", %{conn: conn} do
    interests = insert_pair(:interest)

    conn = get conn, api_interest_path(conn, :index)

    assert json_response(conn, 200) == render_json("index.json", interests: interests)
  end

  test "#show displays a single interest", %{conn: conn} do
    interest = insert(:interest)

    conn = get conn, api_interest_path(conn, :show, interest.id)

    assert json_response(conn, 200)["interest"]["id"] == interest.id
  end

  test "#update changes the slack channel and adds leading #", %{conn: conn} do
    interest = insert(:interest)

    conn = put conn, api_interest_path(conn, :update, interest.id), channel: "boston"

    assert json_response(conn, 200)["interest"]["slack_channel"] == "#boston"
  end
end
