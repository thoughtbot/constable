defmodule Constable.AnnouncementFormTest do
  use Constable.ModelCase, async: true
  alias Constable.AnnouncementForm
  alias Constable.Announcement
  alias Constable.Repo

  test "creates an announcement with new and existing interests" do
    author = insert(:user)
    existing_interest = insert(:interest)
    new_interest_name = "foo"
    interest_name_with_hash = "#everyone"
    duplicate_interest = "#foo"
    interest_names =
      [existing_interest.name, new_interest_name, interest_name_with_hash, duplicate_interest]

    changeset = AnnouncementForm.changeset(%{
      title: "Hello",
      body: "World",
      interests: Enum.join(interest_names, ",")
    })

    AnnouncementForm.create(changeset, author) |> Repo.transaction

    announcement = Repo.one(Announcement) |> Repo.preload([:interests])
    assert announcement_has_interest_named?(announcement, new_interest_name)
    assert announcement_has_interest_named?(announcement, existing_interest.name)
    assert announcement_has_interest_named?(announcement, "everyone")
    refute announcement_has_interest_named?(announcement, duplicate_interest)
  end

  test "does not create blank interests" do
    author = insert(:user)

    changeset = AnnouncementForm.changeset(%{
      title: "Hello",
      body: "World",
      interests: "",
    })

    AnnouncementForm.create(changeset, author) |> Repo.transaction

    announcement = Repo.one(Announcement) |> Repo.preload([:interests])
    assert announcement.interests == []
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> Enum.any?(&(&1.name == interest_name))
  end
end
