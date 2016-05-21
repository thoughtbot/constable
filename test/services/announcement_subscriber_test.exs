defmodule Constable.Services.AnnouncementSubscriberTest do
  use Constable.TestWithEcto, async: false
  use Bamboo.Test
  alias Constable.Emails

  alias Constable.Announcement
  alias Constable.Subscription
  alias Constable.Services.AnnouncementSubscriber

  test "subscribes the author to the newly created announcement" do
    author = insert(:user)
    announcement = insert(:announcement, user: author)

    AnnouncementSubscriber.subscribe_users(announcement)

    announcement = Repo.one(Announcement)
    subscription = Repo.one(Subscription)
    assert subscription.user_id == author.id
    assert subscription.announcement_id == announcement.id
  end

  test "subscribes interested users when autosubscribe is on" do
    auto_subscribe_user = insert(:user, auto_subscribe: true)
    user = insert(:user, auto_subscribe: false)
    creator = insert(:user)
    interest = insert(:interest, name: "foo")
    insert(:user_interest, user: user, interest: interest)
    insert(:user_interest, user: auto_subscribe_user, interest: interest)

    announcement = insert(:announcement, user: creator)
      |> tag_with_interest(interest)

    AnnouncementSubscriber.subscribe_users(announcement)
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

    announcement = insert(:announcement, user: author)
      |> tag_with_interest(interest)

    AnnouncementSubscriber.subscribe_users(announcement)

    announcement = Repo.one(Announcement) |> Repo.preload(:user)
    assert_delivered_email Emails.new_announcement(announcement, [subscribed_user])
  end

  test "sends announcement email to mentioned users" do
    interest = insert(:interest, name: "foo")
    author = insert(:user) |> with_interest(interest)
    mentioned_user = insert(:user, username: "joedirt")

    announcement = insert(:announcement, user: author, body: "Hello @joedirt")
      |> tag_with_interest(interest)

    AnnouncementSubscriber.subscribe_users(announcement)

    announcement = Repo.one(Announcement) |> Repo.preload(:user)
    assert_delivered_email Emails.new_announcement_mention(announcement, [mentioned_user])
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> Enum.any?(&(&1.name == interest_name))
  end
end
