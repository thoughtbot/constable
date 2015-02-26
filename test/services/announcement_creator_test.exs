defmodule Constable.Services.AnnouncementCreatorTest do
  use Constable.TestWithEcto, async: false
  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Services.AnnouncementCreator

  test "creates an announcement with new and existing interests" do
    user = Forge.saved_user(Repo)
    existing_interest = Forge.saved_interest(Repo)
    new_interest_name = "foo"
    interest_names = [existing_interest.name, new_interest_name]
    announcement_params = %{
      title: "Title",
      body: "Body",
      user_id: user.id
    }

    AnnouncementCreator.create(announcement_params, interest_names)

    announcement = Repo.one(Announcement) |> Repo.preload([:interests])
    assert announcement_has_interest_named?(announcement, new_interest_name)
    assert announcement_has_interest_named?(announcement, existing_interest.name)
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> Enum.any?(&(&1.name == interest_name))
  end
end
