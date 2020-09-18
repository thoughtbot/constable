defmodule ConstableWeb.Api.AnnouncementControllerTest do
  use ConstableWeb.ConnCase, async: true

  alias Constable.Announcement
  @view ConstableWeb.Api.AnnouncementView

  setup do
    {:ok, api_authenticate()}
  end

  test "#index lists all announcements", %{conn: conn, user: user} do
    announcements = insert_pair(:announcement, user: user)

    conn = get(conn, Routes.api_announcement_path(conn, :index))

    assert json_response(conn, 200) == render_json("index.json", announcements: announcements)
  end

  test "#index lists announcements after the provided id", %{conn: conn, user: user} do
    interest = insert(:interest, name: "everyone")
    insert(:user_interest, interest: interest, user: user)
    announcement1 = insert(:announcement, last_discussed_at: ~N[2020-05-16 00:00:00], interests: [interest], user: user)
    announcement2 = insert(:announcement, last_discussed_at: ~N[2020-05-17 00:00:00], interests: [interest], user: user)

    conn = get(conn, Routes.api_announcement_path(conn, :index), %{"after" => announcement2.id})

    assert json_response(conn, 200) == render_json("index.json", announcements: [announcement1])
  end

  test "#index lists announcements before the provided id", %{conn: conn, user: user} do
    announcement1 = insert(:announcement, inserted_at: ~N[2020-05-14 00:00:00], user: user)
    announcement2 = insert(:announcement, inserted_at: ~N[2020-05-15 00:00:00], user: user)
    announcement3 = insert(:announcement, inserted_at: ~N[2020-05-16 00:00:00], user: user)
    _announcement4 = insert(:announcement, inserted_at: ~N[2020-05-17 00:00:00], user: user)

    conn =
      get(conn, Routes.api_announcement_path(conn, :index), %{
        "before" => announcement1.id,
        "page_size" => 2
      })

    assert json_response(conn, 200) ==
             render_json("index.json",
               announcements: [announcement3, announcement2]
             )
  end

  test "#show renders single announcement", %{conn: conn, user: user} do
    announcement = insert(:announcement, user: user)

    conn = get(conn, Routes.api_announcement_path(conn, :show, announcement))

    assert json_response(conn, 200) == render_json("show.json", announcement: announcement)
  end

  test "#show uses iso8601 timestamps", %{conn: conn, user: user} do
    announcement = insert(:announcement, user: user, updated_at: ~N[2018-01-01 15:15:15.000000])

    conn = get(conn, Routes.api_announcement_path(conn, :show, announcement))
    body = json_response(conn, 200)

    # A previous Ecto version upgrade caused a regression around datetime formats
    assert body["announcement"]["updated_at"] == "2018-01-01T15:15:15Z"
  end

  test "#create with valid attributes saves an announcement", %{conn: conn} do
    announcement_params = build(:announcement_params)

    conn =
      post conn, Routes.api_announcement_path(conn, :create), %{
        announcement: announcement_params,
        interest_names: ["foo"]
      }

    announcement = Repo.one(Announcement) |> Repo.preload(:interests)

    interest_names =
      Enum.map(announcement.interests, fn interest ->
        interest.name
      end)

    assert json_response(conn, 201)
    assert announcement.title == announcement_params.title
    assert announcement.body == announcement_params.body
    assert interest_names == ["foo"]
  end

  test "#create with invalid attributes renders errors", %{conn: conn} do
    conn =
      post conn,
           Routes.api_announcement_path(conn, :create),
           announcement: %{},
           interest_names: %{}

    assert %{"errors" => _} = json_response(conn, 422)
  end

  test "#update with valid attributes updates announcement", %{conn: conn, user: user} do
    announcement = insert(:announcement, user: user, title: "Foo")

    put conn, Routes.api_announcement_path(conn, :update, announcement),
      announcement: %{
        title: "Foobar",
        body: "wat"
      },
      interest_names: ["foo"]

    announcement = Repo.one(Announcement) |> Repo.preload(:interests)
    interest_names = Enum.map(announcement.interests, & &1.name)
    assert announcement.title == "Foobar"
    assert interest_names == ["foo"]
  end

  test "#update with invalid attributes renders errors", %{conn: conn, user: user} do
    announcement = insert(:announcement, user: user)

    conn =
      put conn, Routes.api_announcement_path(conn, :update, announcement),
        announcement: %{
          title: nil,
          body: nil
        },
        interest_names: ["Foo"]

    assert %{"errors" => _} = json_response(conn, 422)
  end

  test "#update only creator can update attributes", %{conn: conn} do
    other_user = insert(:user)
    announcement = insert(:announcement, user: other_user)

    conn =
      put conn,
          Routes.api_announcement_path(conn, :update, announcement),
          announcement: %{},
          interest_names: []

    assert response(conn, 401)
  end

  test "#delete deletes announcement", %{conn: conn, user: user} do
    announcement = insert(:announcement, user: user)

    conn = delete(conn, Routes.api_announcement_path(conn, :delete, announcement))

    assert Repo.count(Announcement) == 0
    assert response(conn, 204)
  end

  test "#delete only owner can delete announcement", %{conn: conn} do
    other_user = insert(:user)
    announcement = insert(:announcement, user: other_user)

    conn = delete(conn, Routes.api_announcement_path(conn, :delete, announcement))

    assert response(conn, 401)
  end
end
