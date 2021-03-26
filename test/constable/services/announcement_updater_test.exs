defmodule Constable.Services.AnnouncementUpdaterTest do
  use Constable.TestWithEcto, async: true

  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Services.AnnouncementUpdater

  test "updates an announcement and its interests" do
    user = insert(:user)
    announcement = insert(:announcement, user: user)
    interest = insert(:interest, name: "old")

    insert(:announcement_interest,
      announcement: announcement,
      interest: interest
    )

    params = %{title: "New!", body: "# Bar!"}
    {:ok, _} = AnnouncementUpdater.update(announcement, params, ["new", "newer"])

    announcement = Repo.get!(Announcement, announcement.id) |> Repo.preload(:interests)

    assert announcement.title == "New!"
    assert announcement.body == "# Bar!"
    assert announcement_has_interest_named?(announcement, "new")
    assert announcement_has_interest_named?(announcement, "newer")
    refute announcement_has_interest_named?(announcement, "old")
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> Enum.any?(&(&1.name == interest_name))
  end
end
