defmodule Constable.Api.InterestControllerTest do
  use Constable.ConnCase

  setup do
    {:ok, authenticate}
  end

  test "#index displays all interests", %{conn: conn} do
    Forge.saved_interest(Repo, id: 1)
    Forge.saved_interest(Repo, id: 2)

    conn = get conn, interest_path(conn, :index)
    ids = fetch_json_ids(conn)

    assert ids == [1, 2]
  end

  test "#show displays a single interest", %{conn: conn} do
    interest = Forge.saved_interest(Repo)

    conn = get conn, interest_path(conn, :show, interest.id)
    assert json_response(conn, 200)["data"]["id"] == interest.id
  end
end
