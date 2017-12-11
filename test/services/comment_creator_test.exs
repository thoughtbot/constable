defmodule Constable.Services.CommentCreatorTest do
  use ConstableWeb.ChannelCase, async: true
  use Bamboo.Test
  alias Constable.Emails
  alias ConstableWeb.Api.CommentView
  alias Constable.Comment
  alias Constable.Services.CommentCreator

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

  test "sends an update over a channel" do
    user = insert(:user)
    announcement = insert(:announcement)
    {:ok, socket} = connect(ConstableWeb.UserSocket, %{"token" => user.token})
    subscribe_and_join!(socket, "update")

    {:ok, comment} = CommentCreator.create(%{
      user_id: insert(:user).id,
      body: "Foo",
      announcement_id: announcement.id
    })

    content = CommentView.render("show.json", %{comment: comment})
    assert_broadcast "comment:add", ^content
  end

  test "create emails announcement subscribers" do
    user = insert(:user)
    announcement = insert(:announcement) |> with_subscriber(user)

    {:ok, comment} = CommentCreator.create(%{
      user_id: insert(:user).id,
      body: "Foo",
      announcement_id: announcement.id
    })

    assert_delivered_email Emails.new_comment(comment, [user])
  end

  test "create emails mentioned users" do
    mentioned_username = "blake"
    user = insert(:user, username: mentioned_username)
    announcement = insert(:announcement, user: user)

    {:ok, comment} = CommentCreator.create(%{
      user_id: insert(:user).id,
      body: "Hey @#{mentioned_username}, @fakeuser was looking for you.",
      announcement_id: announcement.id
    })

    assert_delivered_email Emails.new_comment_mention(comment, [user])
  end

  test "create only sends mention email if subscribed and mentioned" do
    mentioned_username = "blake"
    user = insert(:user, username: mentioned_username)
    announcement = insert(:announcement) |> with_subscriber(user)

    {:ok, comment} = CommentCreator.create(%{
      user_id: user.id,
      body: "Hey @#{mentioned_username}",
      announcement_id: announcement.id
    })

    assert_delivered_email Emails.new_comment_mention(comment, [user])
  end

  test "create does not email author of comment" do
    author = insert(:user)
    announcement = insert(:announcement) |> with_subscriber(author)

    {:ok, _comment} = CommentCreator.create(%{
      user_id: author.id,
      body: "Foo!",
      announcement_id: announcement.id
    })

    assert_no_emails_delivered()
  end
end
