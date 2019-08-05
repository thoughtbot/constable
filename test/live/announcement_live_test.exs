defmodule ConstableWeb.AnnouncementLiveTest do
  use ConstableWeb.ConnCase

  import Phoenix.LiveViewTest

  setup do
    {:ok, browser_authenticate()}
  end

  test "connected mount", %{conn: conn} do
    announcement_path = Routes.announcement_path(conn, :new, live: true)

    {:ok, _view, html} = live(conn, announcement_path)

    assert html =~ "Title Preview"
    assert html =~ "Your rendered markdown goes here"
  end

  test "renders title and body previews", %{conn: conn} do
    title = "This is the title preview"
    body = "## This h2"
    changes = %{"announcement" => %{"body" => body, "title" => title}}

    preview =
      conn
      |> live(Routes.announcement_path(conn, :new, live: true))
      |> render_preview(changes)

    assert preview =~ "<h1 data-role=\"title-preview\"><p>This is the title preview</p>\n</h1>"
    assert preview =~ "<h2>This h2</h2>"
  end

  test "updates interests", %{conn: conn} do
    insert(:user) |> with_interest(insert(:interest, name: "vim"))
    insert(:user) |> with_interest(insert(:interest, name: "remote"))
    interests = %{"interests" => "vim,remote"}

    updated_html =
      conn
      |> live(Routes.announcement_path(conn, :new, live: true))
      |> update_interests(interests)

    assert updated_html =~ "2 people are subscribed"
  end

  defp update_interests({:ok, view, _html}, interests) do
    render_change(view, :update_interests, interests)
  end

  defp render_preview({:ok, view, _html}, changes) do
    render_change(view, :render_preview, changes)
  end
end
