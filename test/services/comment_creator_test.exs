defmodule Constable.Services.CommentCreatorTest do
  use Constable.TestWithEcto, async: false

  alias Constable.Comment
  alias Constable.Services.CommentCreator

  defmodule FakeCommentMailer do
    def created(comment, users) do
      send self, {:comment, comment}
      send self, {:users, users}
    end

    def mentioned(comment, users) do
      send self, {:mentioned_comment, comment}
      send self, {:mentioned_users, users}
    end
  end

  setup do
    Pact.override self, :comment_mailer, __MODULE__.FakeCommentMailer
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

  test "create emails announcement subscribers" do
    user = create(:user)
    announcement = create(:announcement) |> with_subscriber(user)

    {:ok, comment} = CommentCreator.create(%{
      user_id: create(:user).id,
      body: "Foo",
      announcement_id: announcement.id
    })

    assert_receive {:comment, ^comment}
    assert_receive {:users, [^user]}
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

    assert_receive {:mentioned_comment, ^comment}
    assert_receive {:mentioned_users, [^user]}
  end

  test "create only sends mention email if subscribed and mentioned" do
    mentioned_username = "blake"
    user = create(:user, username: mentioned_username)
    announcement = create(:announcement) |> with_subscriber(user)

    {:ok, comment} = CommentCreator.create(%{
      user_id: user.id,
      body: "Hey @#{mentioned_username}",
      announcement_id: announcement.id
    })

    assert_received {:comment, comment}
    assert_received {:users, []}

    assert_receive {:mentioned_comment, ^comment}
    assert_receive {:mentioned_users, [^user]}
  end

  test "create does not email author of comment" do
    author = create(:user)
    announcement = create(:announcement) |> with_subscriber(author)

    {:ok, comment} = CommentCreator.create(%{
      user_id: author.id,
      body: "Foo!",
      announcement_id: announcement.id
    })

    assert_received {:comment, comment}
    assert_received {:users, []}

    assert_receive {:mentioned_comment, ^comment}
    assert_receive {:mentioned_users, []}
  end
end
