defmodule Constable.AnnouncementTest do
  use Constable.ModelCase, async: true
  alias Constable.Announcement
  alias Ecto.Changeset

  test "inserting a record sets the last_discussed_at" do
    announcement = build(:announcement) |> insert

    assert announcement.last_discussed_at
  end

  describe ".update_changeset/2" do
    test "generates a slug from the new title" do
      title = "A normal title"
      announcement = insert(:announcement)

      slug =
        announcement
        |> Announcement.update_changeset(%{title: title})
        |> Changeset.get_change(:slug)

      assert slug == "a-normal-title"
    end

    test "does not generate slug if title is nil" do
      announcement = build(:announcement)

      slug =
        announcement
        |> Announcement.create_changeset(%{title: nil})
        |> Changeset.get_change(:slug)

      refute slug
    end
  end

  describe ".create_changeset/2" do
    test "generates a slug from the title" do
      title = "A normal title"
      announcement = build(:announcement)

      slug =
        announcement
        |> Announcement.create_changeset(%{title: title})
        |> Changeset.get_change(:slug)

      assert slug == "a-normal-title"
    end

    test "does not generate slug if not title is nil" do
      announcement = build(:announcement)

      slug =
        announcement
        |> Announcement.create_changeset(%{title: nil})
        |> Changeset.get_change(:slug)

      refute slug
    end
  end

  describe ".last_discussed_first/1" do
    test "returns the last discussed announcement" do
      oldest = insert(:announcement, last_discussed_at: Constable.Time.days_ago(1))
      newest = insert(:announcement, last_discussed_at: Constable.Time.now)

      announcements = Announcement.last_discussed_first |> Repo.all

      assert List.first(announcements).id == newest.id
      assert List.last(announcements).id == oldest.id
    end
  end

  describe ".with_announcement_list_assocs/1" do
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
  end
end
