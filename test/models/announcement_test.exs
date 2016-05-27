defmodule Constable.AnnouncementTest do
  use Constable.ModelCase, async: true
  alias Constable.Announcement
  import GoodTimes

  test "inserting a record sets the last_discussed_at" do
    announcement = build(:announcement) |> insert

    assert announcement.last_discussed_at
  end

  test "last_discussed_first" do
    oldest = insert(:announcement, last_discussed_at: cast(a_day_ago))
    newest = insert(:announcement, last_discussed_at: cast(now))

    announcements = Announcement.last_discussed_first |> Repo.all

    assert List.first(announcements).id == newest.id
    assert List.last(announcements).id == oldest.id
  end

  test "interests are sorted alphabetically" do
    interest_a = insert(:interest, name: "a")
    interest_b = insert(:interest, name: "b")
    insert(:announcement)
      |> tag_with_interest(interest_b)
      |> tag_with_interest(interest_a)

    announcement = Announcement.with_announcement_list_assocs
      |> Repo.one

    assert announcement.interests |> List.first == interest_a
    assert announcement.interests |> List.last  == interest_b
  end

  defp cast(erlang_date_time) do
    Ecto.DateTime.cast!(erlang_date_time)
  end
end
