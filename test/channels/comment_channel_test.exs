defmodule CommentChannelTest do
  use Constable.ChannelCase
  import ChannelTestHelper
  require Pact
  alias Constable.Announcement
  alias Constable.Comment
  alias Constable.CommentChannel
  alias Constable.Serializers

  @channel CommentChannel

  test "'create' broadcasts and replies with new comment" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    socket = join!("comments", %{"token" => user.token})

    ref = push socket, "create", comment_params_for(announcement)

    payload = payload_from_reply(ref, :ok)
    comment = comment_with_associations
    assert payload == comment
    assert_broadcast "add", ^comment
  end

  test "'create' updates the announcements timestamp" do
    user = Forge.saved_user(Repo)
    date = Forge.date_time(year: 2000)
    announcement = Forge.saved_announcement(
      Repo,
      user_id: user.id,
      updated_at: date
    )
    socket = join!("comments", %{"token" => user.token})

    ref = push socket, "create", comment_params_for(announcement)

    wait_for_reply(ref, :ok)
    updated_announcement = Repo.get(Announcement, announcement.id)
    assert announcement.updated_at != updated_announcement.updated_at
  end

  defmodule FakeCommentMailer do
    def created(comment, users) do
      send self, {:comment, comment}
      send self, {:users, users}
    end
  end

  test "'create' emails subscribers of the announcement" do
    user = Forge.saved_user(Repo)
    Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_subscription(
      Repo,
      user_id: user.id,
      announcement_id: announcement.id
    )
    Pact.override self, :comment_mailer, FakeCommentMailer
    socket = join!("comments", %{"token" => user.token})

    ref = push socket, "create", comment_params_for(announcement)

    wait_for_reply ref, :ok
    comment = comment_with_associations
    # assert_received {:users, [^user]}
    # assert_received {:comment, ^comment}
  end

  def comment_params_for(announcement) do
    %{"comment" =>
      %{
        "announcement_id" => announcement.id,
        "body" => "Bar"
      }
    }
  end

  def comment_with_associations do
    %{comment: Repo.one(from c in Comment, preload: [:user, :announcement])}
  end
end
