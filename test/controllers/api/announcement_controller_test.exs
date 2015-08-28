defmodule Constable.Api.AnnouncementControllerTest do
  use Constable.ConnCase

  alias Constable.Announcement

  setup do
    {:ok, authenticate}
  end

  test "#index lists all announcements", %{conn: conn, user: user} do
    Forge.saved_announcement(Repo, id: 1, user_id: user.id)
    Forge.saved_announcement(Repo, id: 2, user_id: user.id)
    conn = get conn, announcement_path(conn, :index)

    ids = fetch_json_ids("announcements", conn)

    assert ids == [1, 2]
  end

  test "#show renders single announcement", %{conn: conn, user: user} do
    announcement = Forge.saved_announcement(Repo, id: 1, user_id: user.id)

    conn = get conn, announcement_path(conn, :show, announcement.id)
    assert json_response(conn, 200)["announcement"]["id"] == announcement.id
  end

  test "#create with valid attributes saves an announcement", %{conn: conn} do
    conn = post conn, announcement_path(conn, :create), %{
      announcement: %{
        title: "Foo",
        body: "#bar",
      },
      interest_names: ["foo"]
    }

    json_response(conn, 201)["announcement"]
    announcement = Repo.one(Announcement) |> Repo.preload(:interests)
    interest_names = Enum.map(announcement.interests, fn(interest) ->
      interest.name
    end)

    assert announcement.title == "Foo"
    assert announcement.body == "#bar"
    assert interest_names == ["foo"]
  end

  test "#create with invalid attributes renders errors", %{conn: conn} do
    conn = post conn, announcement_path(conn, :create), announcement: %{}, interest_names: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "#update with valid attributes updates announcement", %{conn: conn, user: user} do
    announcement = Forge.saved_announcement(Repo, user_id: user.id, title: "Foo")

    put conn, announcement_path(conn, :update, announcement), announcement: %{
      title: "Foobar"
    }

    announcement = Repo.one(Announcement)

    assert announcement.title == "Foobar"
  end

  test "#update with invalid attributes renders errors", %{conn: conn, user: user} do
    announcement = Forge.saved_announcement(Repo, user_id: user.id, title: "Foo")

    conn = put conn, announcement_path(conn, :update, announcement), announcement: %{
      title: nil,
      body: nil
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "#update only creator can update attributes", %{conn: conn} do
    other_user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: other_user.id, title: "Foo")

    conn = put conn, announcement_path(conn, :update, announcement), announcement: %{}

    assert response(conn, 401)
  end

  test "#delete deletes announcement", %{conn: conn, user: user} do
    announcement = Forge.saved_announcement(Repo, user_id: user.id, title: "Foo")

    conn = delete conn, announcement_path(conn, :delete, announcement)

    assert response(conn, 204)
  end

  test "#delete only owner can delete announcement", %{conn: conn} do
    other_user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: other_user.id, title: "Foo")

    conn = delete conn, announcement_path(conn, :delete, announcement)

    assert response(conn, 401)
  end
end
