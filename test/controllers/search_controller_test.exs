defmodule ConstableWeb.SearchControllerTest do
  use ConstableWeb.ConnCase, async: true

  setup do
    {:ok, browser_authenticate()}
  end

  test "#show returns announcements matching search", %{conn: conn}do
    foo = insert(:interest, name: "foo")
    insert(:announcement, title: "Awesome Post") |> tag_with_interest(foo)
    insert(:announcement, title: "Not so much post", body: "awesome post!") |> tag_with_interest(foo)
    insert(:announcement, title: "Don't show up!", body: "lame post!") |> tag_with_interest(insert(:interest))

    conn = get conn, search_path(conn, :show, query: "awesome")

    assert html_response(conn, :ok) =~ "Awesome Post"
    assert html_response(conn, :ok) =~ "Not so much post"
    refute html_response(conn, :ok) =~ "Don't show up!"
  end

  test "#show hides announcements from excluded interests", %{conn: conn} do
    foo = insert(:interest, name: "foo")
    bar = insert(:interest, name: "bar")
    insert(:announcement, title: "Awesome Post") |> tag_with_interest(foo)
    insert(:announcement, title: "Not so much post", body: "awesome post!") |> tag_with_interest(foo)
    insert(:announcement, title: "Good post!", body: "another awesome post!") |> tag_with_interest(bar)

    conn = get conn, search_path(conn, :show, query: "awesome", exclude_interests: ["foo"])

    refute html_response(conn, :ok) =~ "Awesome Post"
    refute html_response(conn, :ok) =~ "Not so much post"
    assert html_response(conn, :ok) =~ "Good post!"
  end
end
