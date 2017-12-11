defmodule ConstableWeb.InterestControllerTest do
  use ConstableWeb.ConnCase, async: true

  setup do
    {:ok, browser_authenticate()}
  end

  test "#show all announcements that are associated with this interest", %{conn: conn} do
    interest = insert(:interest)
    insert(:announcement, title: "Awesome") |> tag_with_interest(interest)
    insert(:announcement, title: "Nope") |> tag_with_interest(insert(:interest))

    conn = get conn, interest_path(conn, :show, interest)

    assert html_response(conn, :ok) =~ "Awesome"
    refute html_response(conn, :ok) =~ "Nope"
  end

  test "works with legacy ids for the param", %{conn: conn} do
    interest = insert(:interest)
    insert(:announcement, title: "Awesome") |> tag_with_interest(interest)

    conn = get conn, interest_path(conn, :show, interest.id)

    assert html_response(conn, :ok) =~ "Awesome"
  end
end
