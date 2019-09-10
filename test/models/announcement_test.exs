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

      assert is_nil(slug)
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

    test "does not generate slug if title is nil" do
      announcement = build(:announcement)

      slug =
        announcement
        |> Announcement.create_changeset(%{title: nil})
        |> Changeset.get_change(:slug)

      assert is_nil(slug)
    end
  end

  describe ".last_discussed_first/1" do
    test "returns the last discussed announcement" do
      oldest = insert(:announcement, last_discussed_at: Constable.Time.days_ago(1))
      newest = insert(:announcement, last_discussed_at: Constable.Time.now())

      announcements = Announcement.last_discussed_first() |> Repo.all()

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

      announcement =
        Announcement.with_announcement_list_assocs()
        |> Repo.one()

      assert announcement.interests |> List.first() == interest_a
      assert announcement.interests |> List.last() == interest_b
    end
  end

  describe ".for_user/1" do
    test "returns announcements for given user" do
      user = insert(:user)
      announcement = insert(:announcement, user: user)
      other_announcement = insert(:announcement, user: insert(:user))

      announcement_ids =
        user.id
        |> Announcement.for_user()
        |> Repo.all()
        |> Enum.map(& &1.id)

      assert announcement.id in announcement_ids
      refute other_announcement.id in announcement_ids
    end
  end

  describe ".with_comments_by_user/2" do
    test "returns Announcements on which User has created a Comment" do
      user = insert(:user)
      other_user = insert(:user)
      announcement_without_user_comment = insert(:announcement, user: user)
      announcement_with_user_comment = insert(:announcement, user: other_user)

      insert(
        :comment,
        body: "🐒",
        announcement: announcement_with_user_comment,
        user: user
      )

      announcement_ids =
        user.id
        |> Announcement.with_comments_by_user()
        |> Repo.all()
        |> Enum.map(& &1.id)

      assert announcement_with_user_comment.id in announcement_ids
      refute announcement_without_user_comment.id in announcement_ids
    end
  end
end
