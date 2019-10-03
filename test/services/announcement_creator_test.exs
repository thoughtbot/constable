defmodule Constable.Services.AnnouncementCreatorTest do
  use Constable.TestWithEcto, async: false
  use Bamboo.Test
  alias Constable.Emails

  alias Constable.Announcement
  alias Constable.Subscription
  alias Constable.Services.AnnouncementCreator

  test "doesn't subscribe creator twice when interested in announcement and autosubscribe is set" do
    interest = insert(:interest)
    author = insert(:user, auto_subscribe: true) |> with_interest(interest)

    announcement_params = build(:announcement_params, user_id: author.id)

    assert AnnouncementCreator.create(announcement_params, [interest.name])
  end

  test "creates an announcement with new and existing interests" do
    author = insert(:user)
    existing_interest = insert(:interest)
    new_interest_name = "foo"
    interest_name_with_hash = "#everyone"
    duplicate_interest = "#foo"

    interest_names = [
      existing_interest.name,
      new_interest_name,
      interest_name_with_hash,
      duplicate_interest
    ]

    announcement_params = build(:announcement_params, user_id: author.id)

    AnnouncementCreator.create(announcement_params, interest_names)

    announcement = Repo.one(Announcement) |> Repo.preload([:interests])
    assert announcement_has_interest_named?(announcement, new_interest_name)
    assert announcement_has_interest_named?(announcement, existing_interest.name)
    assert announcement_has_interest_named?(announcement, "everyone")
    refute announcement_has_interest_named?(announcement, duplicate_interest)
  end

  test "does not allow creation of an announcement with no interests" do
    author = insert(:user)
    interest_names = []
    announcement_params = build(:announcement_params, user_id: author.id)

    AnnouncementCreator.create(announcement_params, interest_names)

    announcement = Repo.one(Announcement) |> Repo.preload([:interests])
    refute announcement
  end

  test "subscribes the author to the newly created announcement" do
    author = insert(:user)
    announcement_params = build(:announcement_params, user_id: author.id)

    AnnouncementCreator.create(announcement_params, ["everyone"])

    announcement = Repo.one(Announcement)
    subscription = Repo.one(Subscription)
    assert subscription.user_id == author.id
    assert subscription.announcement_id == announcement.id
  end

  test "does not create blank interests" do
    interest_names = [""]
    announcement_params = build(:announcement_params, user_id: insert(:user).id)

    AnnouncementCreator.create(announcement_params, interest_names)

    announcement = Repo.one(Announcement) |> Repo.preload([:interests])
    assert announcement.interests == []
  end

  test "subscribes interested users when autosubscribe is on" do
    auto_subscribe_user = insert(:user, auto_subscribe: true)
    user = insert(:user, auto_subscribe: false)
    creator = insert(:user)
    interest = insert(:interest, name: "foo")
    insert(:user_interest, user: user, interest: interest)
    insert(:user_interest, user: auto_subscribe_user, interest: interest)

    announcement_params = %{
      title: "Title",
      body: "Body",
      user_id: creator.id
    }

    AnnouncementCreator.create(announcement_params, "foo")
    announcement = Repo.one(Announcement)

    refute Repo.get_by(Subscription,
             user_id: user.id,
             announcement_id: announcement.id
           )

    assert Repo.get_by(Subscription,
             user_id: auto_subscribe_user.id,
             announcement_id: announcement.id
           )
  end

  test "sends announcement email to subscribed users except author" do
    interest = insert(:interest, name: "foo")
    author = insert(:user) |> with_interest(interest)
    subscribed_user = insert(:user) |> with_interest(interest)

    announcement_params = %{
      title: "Title",
      body: "Body",
      user_id: author.id
    }

    AnnouncementCreator.create(announcement_params, ["foo"])

    announcement = Repo.one(Announcement) |> Repo.preload(:user)
    assert_delivered_email(Emails.new_announcement(announcement, [subscribed_user]))
  end

  test "does not send announcement email to deactivated users" do
    interest = insert(:interest, name: "foo")
    author = insert(:user) |> with_interest(interest)
    subscribed_user = insert(:user) |> with_interest(interest)
    _deactivated_user = insert(:user, active: false) |> with_interest(interest)

    announcement_params = %{
      title: "Title",
      body: "Body",
      user_id: author.id
    }

    AnnouncementCreator.create(announcement_params, ["foo"])

    announcement = Repo.one(Announcement) |> Repo.preload(:user)
    assert_delivered_email(Emails.new_announcement(announcement, [subscribed_user]))
  end

  test "sends announcement email to mentioned users" do
    interest = insert(:interest, name: "foo")
    author = insert(:user) |> with_interest(interest)
    mentioned_user = insert(:user, username: "joedirt")

    announcement_params = %{
      title: "Title",
      body: "Hello @joedirt",
      user_id: author.id
    }

    AnnouncementCreator.create(announcement_params, ["foo"])

    announcement = Repo.one(Announcement) |> Repo.preload(:user)
    assert_delivered_email(Emails.new_announcement_mention(announcement, [mentioned_user]))
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> Enum.any?(&(&1.name == interest_name))
  end
end
