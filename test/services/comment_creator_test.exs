defmodule Constable.Services.CommentCreatorTest do
  use Constable.ChannelCase
  use Phoenix.ChannelTest

  alias Constable.Api.CommentView
  alias Constable.Comment
  alias Constable.Services.CommentCreator
  alias Bamboo.SentEmail
  alias Bamboo.Formatter

  setup do
    SentEmail.reset
    {:ok, %{}}
  end

  test "creates a comment" do
    announcement = create(:announcement)

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
    user = create(:user)
    announcement = create(:announcement)
    {:ok, socket} = connect(Constable.UserSocket, %{"token" => user.token})
    subscribe_and_join!(socket, "update")

    {:ok, comment} = CommentCreator.create(%{
      user_id: create(:user).id,
      body: "Foo",
      announcement_id: announcement.id
    })

    content = CommentView.render("show.json", %{comment: comment})
    assert_broadcast "comment:add", ^content
  end

  test "create emails announcement subscribers" do
    user = create(:user)
    announcement = create(:announcement) |> with_subscriber(user)

    {:ok, comment} = CommentCreator.create(%{
      user_id: create(:user).id,
      body: "Foo",
      announcement_id: announcement.id
    })

    email = SentEmail.one
    assert email.to == Formatter.format_recipient([user])
    assert email.html_body =~ comment.body
  end

  test "create emails mentioned users" do
    mentioned_username = "blake"
    user = create(:user, username: mentioned_username)
    announcement = create(:announcement, user: user)

    {:ok, comment} = CommentCreator.create(%{
      user_id: create(:user).id,
      body: "Hey @#{mentioned_username}, @fakeuser was looking for you.",
      announcement_id: announcement.id
    })

    email = SentEmail.one
    assert email.to == Formatter.format_recipient([user])
    assert email.html_body =~ comment.body
    assert email.subject =~ "mentioned"
  end

  test "create only sends mention email if subscribed and mentioned" do
    mentioned_username = "blake"
    user = create(:user, username: mentioned_username)
    announcement = create(:announcement) |> with_subscriber(user)

    {:ok, _comment} = CommentCreator.create(%{
      user_id: user.id,
      body: "Hey @#{mentioned_username}",
      announcement_id: announcement.id
    })

    email = SentEmail.one
    assert email.to == Formatter.format_recipient([user])
    assert email.subject =~ "mentioned"
  end

  test "create does not email author of comment" do
    author = create(:user)
    announcement = create(:announcement) |> with_subscriber(author)

    {:ok, _comment} = CommentCreator.create(%{
      user_id: author.id,
      body: "Foo!",
      announcement_id: announcement.id
    })

    assert SentEmail.all == []
  end
end
