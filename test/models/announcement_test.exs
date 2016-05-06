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

  defp cast(erlang_date_time) do
    Ecto.DateTime.cast!(erlang_date_time)
  end
end
