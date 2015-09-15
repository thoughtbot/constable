defmodule Constable.Api.InterestControllerTest do
  use Constable.ConnCase

  alias Constable.Api.InterestView

  setup do
    {:ok, authenticate}
  end

  test "#index displays all interests", %{conn: conn} do
    interests = create_pair(:interest)

    conn = get conn, interest_path(conn, :index)

    assert json_response(conn, 200) == render_json(interests)
  end

  test "#show displays a single interest", %{conn: conn} do
    interest = create(:interest)

    conn = get conn, interest_path(conn, :show, interest.id)

    assert json_response(conn, 200)["interest"]["id"] == interest.id
  end

  defp render_json(interests) do
    InterestView.render("index.json", interests: interests)
    |> format_json
  end
end
