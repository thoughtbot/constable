defmodule Constable.Services.CommentCreatorTest do
  use ConstableWeb.ChannelCase, async: true
  use Bamboo.Test
  alias Constable.Emails
  alias Constable.Comment
  alias Constable.PubSub
  alias Constable.Services.CommentCreator
  alias Constable.Subscription

  test "creates a comment" do
    announcement = insert(:announcement)

    CommentCreator.create(%{
      user_id: announcement.user.id,
      body: "Foo",
      announcement_id: announcement.id
    })

    comment = Repo.one!(Comment)

    assert comment.user_id == announcement.user_id
    assert comment.announcement_id == announcement.id
    assert comment.body == "Foo"
  end

  test "broadcasts the new comment" do
    announcement = insert(:announcement)
    PubSub.subscribe_to_announcement(announcement)

    CommentCreator.create(%{
      user_id: announcement.user.id,
      body: "Foo",
      announcement_id: announcement.id
    })

    assert_receive {:new_comment, comment}
    assert %{body: "Foo"} = comment
  end

  test "create emails announcement subscribers" do
    user = insert(:user)
    announcement = insert(:announcement) |> with_subscriber(user)

    {:ok, comment} =
      CommentCreator.create(%{
        user_id: insert(:user).id,
        body: "Foo",
        announcement_id: announcement.id
      })

    assert_delivered_email(Emails.new_comment(comment, [user]))
  end

  test "create emails mentioned users" do
    mentioned_username = "blake"
    user = insert(:user, username: mentioned_username)
    announcement = insert(:announcement, user: user)

    {:ok, comment} =
      CommentCreator.create(%{
        user_id: insert(:user).id,
        body: "Hey @#{mentioned_username}, @fakeuser was looking for you.",
        announcement_id: announcement.id
      })

    assert_delivered_email(Emails.new_comment_mention(comment, [user]))
  end

  test "create only sends mention email if subscribed and mentioned" do
    mentioned_username = "blake"
    user = insert(:user, username: mentioned_username)
    announcement = insert(:announcement) |> with_subscriber(user)

    {:ok, comment} =
      CommentCreator.create(%{
        user_id: user.id,
        body: "Hey @#{mentioned_username}",
        announcement_id: announcement.id
      })

    assert_delivered_email(Emails.new_comment_mention(comment, [user]))
  end

  test "create does not email author of comment" do
    author = insert(:user)
    announcement = insert(:announcement) |> with_subscriber(author)

    {:ok, _comment} =
      CommentCreator.create(%{
        user_id: author.id,
        body: "Foo!",
        announcement_id: announcement.id
      })

    assert_no_emails_delivered()
  end

  test "create subscribes the commenting user to the announcement" do
    commenter = insert(:user)
    announcement = insert(:announcement)

    {:ok, _comment} =
      CommentCreator.create(%{
        user_id: commenter.id,
        body: "Baz!",
        announcement_id: announcement.id
      })

    subscription = Repo.one!(Subscription)
    assert subscription.user_id == commenter.id
    assert subscription.announcement_id == announcement.id
  end
end
