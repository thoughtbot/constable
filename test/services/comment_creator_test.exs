defmodule Constable.Services.CommentCreatorTest do
  use Constable.TestWithEcto, async: false

  alias Constable.Repo
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
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)

    CommentCreator.create(%{
      user_id: user.id,
      body: "Foo",
      announcement_id: announcement.id
    })

    comment = Repo.one(Comment)

    assert comment.user_id == user.id
    assert comment.announcement_id == announcement.id
    assert comment.body == "Foo"
  end

  test "create emails announcement subscribers" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_subscription(Repo, user_id: user.id, announcement_id: announcement.id)

    {:ok, comment} = CommentCreator.create(%{
      user_id: user.id,
      body: "Foo",
      announcement_id: announcement.id
    })

    assert_receive {:comment, ^comment}
    assert_receive {:users, [^user]}
  end

  test "create emails mentioned users" do
    user = Forge.saved_user(Repo, username: "blake")
    announcement = Forge.saved_announcement(Repo, user_id: user.id)

    {:ok, comment} = CommentCreator.create(%{
      user_id: user.id,
      body: "Hey @blake, @fakeuser was looking for you.",
      announcement_id: announcement.id
    })

    assert_receive {:mentioned_comment, ^comment}
    assert_receive {:mentioned_users, [^user]}
  end

  test "create only emails user once if subscribed and mentioned" do
    user = Forge.saved_user(Repo, username: "blake")
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_subscription(Repo, user_id: user.id, announcement_id: announcement.id)

    {:ok, comment} = CommentCreator.create(%{
      user_id: user.id,
      body: "Hey @blake",
      announcement_id: announcement.id
    })

    assert_received {:comment, comment}
    assert_received {:users, []}


    assert_receive {:mentioned_comment, ^comment}
    assert_receive {:mentioned_users, [^user]}
  end
end
